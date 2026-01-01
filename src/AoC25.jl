module AoC25

module Day1
    function rotate_right(pos)
        return pos == 99 ? 0 : pos + 1
    end
    function rotate_left(pos)
        return pos == 0 ? 99 : pos - 1
    end
    function rotate(pos, code::AbstractString)
        n = 0
        dir = code[1]
        steps = parse(Int, code[2:end])
        for _ in 1:steps
            pos = rotate(pos, dir)
            if pos == 0
                n += 1
            end
        end
        return pos, n
    end
    function rotate(pos, dir::Char)
        if dir == 'R'
            return rotate_right(pos)
        elseif dir == 'L'
            return rotate_left(pos)
        else
            error("Invalid direction: $dir")
        end
    end
end

module Day2
    function isinvalid(id::Integer)
        # !isempty(eachmatch(r"^(\d+)\1+$", string(id)))
        x = digits(id)
        iseven(length(x)) || return false
        x[1:length(x) ÷ 2] == x[length(x) ÷ 2 + 1:end]
    end
    function isinvalid_(id::Integer)
        !isempty(eachmatch(r"^(\d+)\1+$", string(id)))
    end
end

module Day3
    # function largestjoltage(input)
	#     highest, highest_pos = findmax(input)
	#     tosearch = SubString(input, highest_pos + 1, length(input))
	#     if isempty(tosearch)
	# 	    second_highest, second_highest_pos = highest, highest_pos
	# 	    highest, highest_pos = findmax(SubString(input, 1, highest_pos - 1))
	#     else
	# 	    second_highest, second_highest_pos = findmax(SubString(input, highest_pos + 1, length(input)))
	#     end
	#     parse(Int, string(highest, second_highest))
    # end
    function largestjoltage(input, n::Integer)
        highest_pos = 0
        output = Char[]
        text = input
        for idx in n:-1:1
            text = SubString(input, highest_pos + 1, length(input) - idx + 1)
    	    highest, highest_pos_ = findmax(text)
            highest_pos += highest_pos_
            push!(output, highest)
        end
        output = parse(Int, reduce(*, string.(output)))
    end
end

module Day4
    using Unicode: graphemes
    function accesible(input)
        # input = convert(BitMatrix, reduce(vcat, permutedims([ gm == "@" for gm in graphemes(ln) ]) for ln in split(input, '\n')))
	    neighborhood = CartesianIndex[]
	    for idx₀ in findall(input)
		    x₀, y₀ = idx₀.I
		    neighbors = CartesianIndex[]
		    for idx₁ in findall(input)
			    x₁, y₁ = idx₁.I
			    d = (x₀ - x₁)^2 + (y₀ - y₁)^2
			    if d ∈ 1:2
				    push!(neighbors, idx₁)
			    end
		    end
		    length(neighbors) < 4 && push!(neighborhood, idx₀)
	    end
        neighborhood
    end
end

end # module AoC25
