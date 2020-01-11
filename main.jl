include("InputHandler.jl")
include("cluster.jl")
include("tournees.jl")
include("OutputHandler.jl")
using Combinatorics

Q, F, H, C, M, d_costs, u_costs, f_coords, s_trt = read_to_list("divers/Instance-propre.csv")
Qmax = 13000
Z = [(f_coords[i][1],f_coords[i][2],s_trt[i]) for i in 1:(F-2)]
"""
# SANS K_MEANS
choix = clustering(Z, d_coord)
choix_list_G = choix[1]
choix_l_st = choix[2]
list_tournees = Tournees_gen(choix_list_G, M, C, Q, H, d_costs, u_costs)
"""

# lorsqu'on fait avec k_means : rien n'est sous traité en premier lieu
choix_l_st, Z = premier_soustraitement(Z, d_costs, u_costs, M, Q)
print("premier sous traitement ok \n")
choix, tmp = clustering_kmeans(Z)
print("clustering ok \n")
# les groupes peuvent être à plus de 4
# si plus de 4 : on split aléatoirement
choix_list_G = split_cluster(choix)
print("split cluster ok \n")
# on définit les tournées opti pour les groupes ainsi constitués
# on vérifie s'il n'y a rien de plus intéressant à sous traiter (ptêt d'abord faire un premier tri pour réduire temps de calcul : on sous traite si cout_st < sum(charge_sem/13 * cout_ar))


choix = clustering(Z, d_coord)
choix_list_G = choix[1]
choix_l_st = choix[2]


#list_tournees = tournee_opti(choix_list_G, M, C, Q, H, d_costs, u_costs)


nom_unique = rejet_tournees_2(choix_list_G, M, C, Q, H, d_costs, u_costs, s_trt)
list_tournees = nom_unique[1]
choix_list_G = nom_unique[2]
choix_l_st = vcat(choix_l_st,nom_unique[3])

print("liste tournees ok \n")


create_output_file("solution_try.txt", choix_l_st, list_tournees, choix_list_G)

list_tournees_2, choix_list_G_2, l_rejet_enplus = rejet_tournees(list_tournees, choix_list_G, M, C, Q, H, d_costs, u_costs, s_trt)
print("rejet ok \n")

for k in l_rejet_enplus
    push!(choix_l_st,k)
end


nom_unique_2 = st_to_cluster(choix_l_st, choix_list_G_2, M, C, Q, H, d_costs, u_costs, s_trt)
choix_list_G_2 = nom_unique_2[1]
list_tournees_2 = vcat(list_tournees_2,nom_unique_2[2])
choix_l_st = nom_unique_2[3]


print("reclustering ok \n")

print(choix_l_st)
create_output_file("solution2_try.txt", choix_l_st, list_tournees_2, choix_list_G_2)

#[1,5,7], # choix_l_st
#[[1, 1, [[(2, 3), (3, 5)], [(2,4)]]], [2, 1, [[(3, 1), (2, 4)]]],[1, 2, [[(4, 5), (6, 1), (8, 10)]]], [2, 2, [[(8, 2), (6,10), (4,9)]]]],
#                   [[2,3],[4,6,8]]
