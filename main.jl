include("InputHandler.jl")
include("cluster.jl")
include("tournees.jl")
include("OutputHandler.jl")
using Combinatorics

Q, F, H, C, M, d_costs, u_costs, f_coords, s_trt = read_to_list("divers/Instance-propre.csv")

Z = [(f_coords[i][1],f_coords[i][2],s_trt[i]) for i in 1:(F-2)]
choix = clustering(Z, d_coord)
#choix = clustering_kmeans(Z, d_coord)
choix_list_G = choix[1]
choix_l_st = choix[2]

list_tournees = Tournees_gen(choix_list_G, M, C, Q, H, d_costs, u_costs)

create_output_file("solution.txt", choix_l_st, list_tournees, choix_list_G)

list_tournees_2, choix_list_G_2, l_rejet_enplus = rejet_tournees(list_tournees, choix_list_G, M, C, Q, H, d_costs, u_costs, s_trt)

for k in l_rejet_enplus
    push!(choix_l_st,k)
end

create_output_file("solution2.txt", choix_l_st, list_tournees_2, choix_list_G_2)

#[1,5,7], # choix_l_st
#[[1, 1, [[(2, 3), (3, 5)], [(2,4)]]], [2, 1, [[(3, 1), (2, 4)]]],[1, 2, [[(4, 5), (6, 1), (8, 10)]]], [2, 2, [[(8, 2), (6,10), (4,9)]]]],
#                   [[2,3],[4,6,8]]
