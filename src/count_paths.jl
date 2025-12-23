module CountPaths

using Graphs

export count_walks, count_walks_memo, count_simple_paths

function _bfs_reachable_out(g::Graphs.AbstractGraph, src::Int)
    n = nv(g)
    @assert 1 <= src <= n
    visited = falses(n)
    q = Vector{Int}(undef, 0)
    push!(q, src)
    visited[src] = true
    for i in 1:length(q)
        u = q[i]
        for v in outneighbors(g, u)
            if !visited[v]
                visited[v] = true
                push!(q, v)
            end
        end
    end
    return Set(findall(identity, visited))
end

function _bfs_reachable_in(g::Graphs.AbstractGraph, tgt::Int)
    n = nv(g)
    @assert 1 <= tgt <= n
    visited = falses(n)
    q = Vector{Int}(undef, 0)
    push!(q, tgt)
    visited[tgt] = true
    for i in 1:length(q)
        u = q[i]
        for v in inneighbors(g, u)
            if !visited[v]
                visited[v] = true
                push!(q, v)
            end
        end
    end
    return Set(findall(identity, visited))
end

"""
Count all walks from `src` to `target` in directed graph `g`.
Returns a `BigInt` count, or the symbol `:infinite` when there are infinitely many walks.
"""
function count_walks(g::Graphs.DiGraph, src::Int, target::Int)
    n = nv(g)
    @assert 1 <= src <= n && 1 <= target <= n

    R = _bfs_reachable_out(g, src)
    T = _bfs_reachable_in(g, target)
    S = intersect(R, T)

    if isempty(S)
        return BigInt(0)
    end

    # compute indegree restricted to S
    indeg = Dict{Int,Int}()
    for u in S
        indeg[u] = 0
    end
    for u in S
        for v in outneighbors(g, u)
            if v in S
                indeg[v] += 1
            end
        end
    end

    # Kahn's algorithm for topological order on the subgraph induced by S
    q = [u for u in S if indeg[u] == 0]
    topo = Int[]
    while !isempty(q)
        u = popfirst!(q)
        push!(topo, u)
        for v in outneighbors(g, u)
            if v in S
                indeg[v] -= 1
                if indeg[v] == 0
                    push!(q, v)
                end
            end
        end
    end

    if length(topo) != length(S)
        return :infinite
    end

    ways = Dict{Int,BigInt}(u => BigInt(0) for u in S)
    ways[target] = BigInt(1)
    for u in reverse(topo)
        for v in outneighbors(g, u)
            if v in S
                ways[u] += ways[v]
            end
        end
    end
    return haskey(ways, src) ? ways[src] : BigInt(0)
end

"""
Memoized DFS variant (requires that the relevant subgraph is acyclic).
Returns `:infinite` if a cycle exists on nodes that can appear on a src->target walk.
"""
function count_walks_memo(g::Graphs.DiGraph, src::Int, target::Int)
    n = nv(g)
    @assert 1 <= src <= n && 1 <= target <= n

    R = _bfs_reachable_out(g, src)
    T = _bfs_reachable_in(g, target)
    S = intersect(R, T)
    if isempty(S)
        return BigInt(0)
    end

    # quick cycle check inside S using Kahn (only indegrees)
    indeg = Dict{Int,Int}(u => 0 for u in S)
    for u in S
        for v in outneighbors(g, u)
            if v in S
                indeg[v] += 1
            end
        end
    end
    q = [u for u in S if indeg[u] == 0]
    cnt = 0
    while !isempty(q)
        u = popfirst!(q); cnt += 1
        for v in outneighbors(g, u)
            if v in S
                indeg[v] -= 1
                if indeg[v] == 0
                    push!(q, v)
                end
            end
        end
    end
    if cnt != length(S)
        return :infinite
    end

    memo = Dict{Int,BigInt}()
    function dfs(u)
        if u == target
            return BigInt(1)
        end
        if haskey(memo, u)
            return memo[u]
        end
        total = BigInt(0)
        for v in outneighbors(g, u)
            if v in S
                total += dfs(v)
            end
        end
        memo[u] = total
        return total
    end
    return dfs(src)
end

"""
Count simple paths (no repeated vertices) from `src` to `target` using backtracking.
This is exact but exponential worst-case.
"""
function count_simple_paths(g::Graphs.DiGraph, src::Int, target::Int)
    n = nv(g)
    @assert 1 <= src <= n && 1 <= target <= n
    visited = falses(n)
    function dfs(u)
        if u == target
            return BigInt(1)
        end
        visited[u] = true
        total = BigInt(0)
        for v in outneighbors(g, u)
            if !visited[v]
                total += dfs(v)
            end
        end
        visited[u] = false
        return total
    end
    return dfs(src)
end

end # module
