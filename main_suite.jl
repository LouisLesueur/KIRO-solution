


Z_fictif = deepcopy(Z)
for i in 1:length(Z)
    if !(i in choix_l_st)
        Z_fictif[i] = (0.0,0.0,0.0)
    end
end
choix = clustering(Z_fictif, d_coord,choix_rejet = 300000)
choix_list_G = vcat(choix_list_G_2,choix[1])
choix_l_st = [indice for indice in choix[2] if (indice in choix_l_st)]


print("clustering ok \n")


#list_tournees = tournee_opti(choix_list_G, M, C, Q, H, d_costs, u_costs)


nom_unique = rejet_tournees_2(choix_list_G, M, C, Q, H, d_costs, u_costs, s_trt)
list_tournees = nom_unique[1]
choix_list_G = nom_unique[2]
choix_l_st = vcat(choix_l_st,nom_unique[3])

print("liste tournees ok \n")

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
create_output_file("solution3_try.txt", choix_l_st, list_tournees_2, choix_list_G_2)
