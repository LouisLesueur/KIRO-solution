include("InputHandler.jl")
include("cluster.jl")
include("tournees.jl")
using Combinatorics

Q, F, H, C, M, d_costs, u_costs, f_coords, s_trt = read_to_list("/home/nadege/Documents/ASSOS/ki/kiro_test/kiro/KIRO_test/divers/Instance-propre.in")

Z = [(f_coords[i][1],f_coords[i][2],s_trt[i]) for i in 1:(F-2)]
choix = clustering(Z, d_coord)
choix_list_G = choix[1]
choix_l_st = choix[2]


list_tournees = Tournees_gen(choix_list_G, M, C, Q, H, d_costs, u_costs)
