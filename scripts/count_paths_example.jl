using Pkg
Pkg.activate(".")

include("../src/count_paths.jl")
using .CountPaths
using Graphs

println("Example: DAG with finite number of walks")
g1 = DiGraph(6)
add_edge!(g1, 1, 2)
add_edge!(g1, 1, 3)
add_edge!(g1, 2, 4)
add_edge!(g1, 3, 4)
add_edge!(g1, 4, 5)
add_edge!(g1, 5, 6)

println("count_walks g1 1->6:", CountPaths.count_walks(g1, 1, 6))
println("count_walks_memo g1 1->6:", CountPaths.count_walks_memo(g1, 1, 6))
println("count_simple_paths g1 1->6:", CountPaths.count_simple_paths(g1, 1, 6))

println("\nExample: graph with a cycle on relevant nodes -> infinite walks")
g2 = DiGraph(4)
add_edge!(g2, 1, 2)
add_edge!(g2, 2, 3)
add_edge!(g2, 3, 2) # cycle between 2 and 3
add_edge!(g2, 3, 4)

println("count_walks g2 1->4:", CountPaths.count_walks(g2, 1, 4))
println("count_walks_memo g2 1->4:", CountPaths.count_walks_memo(g2, 1, 4))
