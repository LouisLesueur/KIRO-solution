function read_to_list(filename)
    d_id = 0
    u_id = 0
    d_costs = []
    u_costs = []
    f_ids = []
    f_coords = []
    s_trt = []
    Q = 0
    F = 0
    H = 0
    C = Array{Array{Float64, 1}, 1}()
    M = Array{Array{Float64, 1}, 1}()
    open(filename) do file
        iter = 1
        for first_line in eachline(file)
            if iter == 1
                first_line = split(replace(replace(first_line, "\n" => ""), "\r" => ""), " ")
                Q = Int(parse(Float64, first_line[2]))
                F = Int(parse(Float64, first_line[4])) + 2
                H = Int(parse(Float64, first_line[6]))
                C = [[0.0 for j in 1:F] for i in 1:F]
                M = [[0.0 for j in 1:H] for i in 1:F]
            end
            iter += 1
        end
    end
    open(filename) do file
        for ln in eachline(file)
            line = split(replace(replace(ln, "\n" => ""), "\r" => ""), " ")
            if line[1] == "d"
                d_id = Int(parse(Float64, line[2])) + 1
                global d_coord = (parse(Float64, line[4]), parse(Float64, line[5]))
            elseif line[1] == "u"
                u_id = Int(parse(Float64, line[2])) + 1
                global u_coord = (parse(Float64, line[4]), parse(Float64, line[5]))
            elseif line[1] == "f"
                push!(f_ids, Int(parse(Float64, line[2])))
                push!(s_trt, parse(Float64, line[4]))
                for sem in 1:H
                    M[length(f_ids)][sem] = parse(Float64, line[5 + sem])
                end
                push!(f_coords, parse(Float64, line[7 + H]))
            elseif line[1] == "a"
                a_dep = Int(parse(Float64, line[2])) + 1
                a_arr = Int(parse(Float64, line[3])) + 1
                C[a_dep][a_arr] = parse(Float64, line[5])
            end
        end
        u_costs = C[u_id]
        d_costs = C[d_id]
        push!(f_coords, d_coord)
        push!(f_coords, u_coord)
    end
    return Q, F, H, C, M, d_costs, u_costs, f_coords, s_trt
end

# Q, F, H, C, M, d_costs, u_costs, f_coords, s_trt = read_to_list("divers/Instance-propre.in")
