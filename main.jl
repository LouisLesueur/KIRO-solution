include("InputHandler.jl")
include("cluster.jl")
include("tournees.jl")
include("OutputHandler.jl")
include("evaluation.jl")
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

"""
# AVEC K_MEANS
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
"""

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
print("donne \n")
print(calc_cout(choix_l_st, list_tournees_2))


# heuristique
# on a choix_l_st, choix_liste_G_2
cout_act = calc_cout(choix_l_st, list_tournees_2)

function heuristique(choix_list_G_2, choix_l_st, cout_act, tourn_init)
    G_init = []
    for g in choix_list_G_2 # pour être sûre que deepcopy
        push!(G_init, deepcopy(g))
    end
    #for i in 1:1
        modif_g1 = rand(1:length(G_init))
        modif_g2 = rand(1:length(G_init))
        modif_f1 = rand(1:length(G_init[modif_g1]))
        modif_f2 = rand(1:length(G_init[modif_g2]))

        new_liste_G = []
        for g in G_init # pour être sûre que deepcopy
            push!(new_liste_G, deepcopy(g))
        end
        new_liste_G[modif_g1][modif_f1] = G_init[modif_g2][modif_f2]
        new_liste_G[modif_g2][modif_f2] = G_init[modif_g1][modif_f1]

        nom_unique_h = rejet_tournees_2(new_liste_G, M, C, Q, H, d_costs, u_costs, s_trt)
        """
        list_tournees = nom_unique[1]
        new_liste_G = nom_unique[2]
        for k in nom_unique[3]
            if !(k in choix_l_st)
                push!(choix_l_st, k)
            end
        end
        """
        list_tournees_h = nom_unique_h[1]
        new_liste_G = nom_unique_h[2]
        choix_l_st_h = vcat(deepcopy(choix_l_st),nom_unique_h[3])

        list_tournees_2_h, new_liste_G_2, l_rejet_enplus_h = rejet_tournees(list_tournees_h, new_liste_G, M, C, Q, H, d_costs, u_costs, s_trt)

        """
        for k in l_rejet_enplus
            if !(k in choix_l_st_h)
                push!(choix_l_st_h,k)
            end
        end
        """

        for k in l_rejet_enplus_h
            push!(choix_l_st_h,k)
        end

        nom_unique_2_h = st_to_cluster(choix_l_st_h, new_liste_G_2, M, C, Q, H, d_costs, u_costs, s_trt)

        new_liste_G_2 = nom_unique_2_h[1]
        list_tournees_2_h = vcat(list_tournees_2_h,nom_unique_2_h[2])
        choix_l_st_h = nom_unique_2_h[3]

        cout = calc_cout(choix_l_st_h, list_tournees_2_h)
        if cout < cout_act
            print("\n solution meilleure : ", cout)
            cout_act = cout
            G_init = []
            for g in new_liste_G_2
                push!(G_init, deepcopy(g))
            end
            create_output_file("solution2_try3.txt", choix_l_st_h, list_tournees_2_h, new_liste_G_2)
            res = []
            for g in new_liste_G_2 # pour être sûre que deepcopy
                push!(res, deepcopy(g))
            end
            return [res,cout_act,choix_l_st_h]
        end
    #end
    return [G_init,cout_act, choix_l_st]
end

function vrai_heuristique(n,cout_init,choix_list_G_2, choix_l_st, list_tournees_2)
    cout_actu = cout_init
    VARIABLE = heuristique(choix_list_G_2, choix_l_st, cout_actu, list_tournees_2)
    temp = VARIABLE[1]
    cout = VARIABLE[2]
    temp2 = VARIABLE[3]
    if cout < cout_actu
        cout_actu = cout
    end
    for i in 1:n
        VARIABLE = heuristique(temp, temp2, cout_actu, list_tournees_2)
        temp = VARIABLE[1]
        cout = VARIABLE[2]
        temp2 = VARIABLE[3]
        if cout < cout_actu
            cout_actu = cout
        end
    end
end

vrai_heuristique(1000,cout_act,choix_list_G_2, choix_l_st, list_tournees_2)
