function calc_cout_chemin(G, d_costs, u_costs, C)
    # fonction qui calcule le coût d'une tournée
    # input : G (tournée (ordonnée)), d_costs (coût dépôt -> fournisseur), u_costs (coût f -> usine)
    # C (matrice des coûts)
    # output : coût
    cout = d_costs[G[1]]
    for k in 2:length(G)
        cout += C[G[k-1]][G[k]]
    end
    cout += u_costs[G[length(G)]]
    return cout
end

function chemin_opti(G, d_costs, u_costs, C)
    # fonction qui calcule l'ordre de la tournée
    # input : G, d_costs, u_costs, C
    # output : tournée opti
    l_ordres = collect(permutations(G))
    cout_min = calc_cout_chemin(l_ordres[1], d_costs, u_costs, C)
    i_min = 1
    for (i, ordre) in enumerate(l_ordres)
        cout = calc_cout_chemin(ordre, d_costs, u_costs, C)
        if isless(cout, cout_min)
            cout_min = cout
            i_min = i
        end
    end
    return l_ordres[i_min]
end


function tournees(G, s, M, C, Q_max)
    # fonction qui donne les tournées à effectuer pour un cluster G la semaine s
    # input : G, s, M (qté à prendre la semaine s chez f), C, Q_max (charge max du camion)
    # output : liste de tournées (liste de liste de tuple (f, q_f))

    # A VOIR POUR PRENDRE MOINS DE CAMION POSSIBLE (PASSER LE MOINS SOUVENT POUR UN MEME FOURNISSEUR)
    quantite = [M[G[i]][s] for i in 1:length(G)]
    Tournees = []
    while sum(quantite) > Q_max
        num_f = 1
        quantite_rest = Q_max
        T = []
        while quantite_rest > 0 && num_f<=length(G)
            if quantite[num_f] == 0
                num_f += 1
                continue
            end
            if isless(quantite[num_f],quantite_rest)
                push!(T, (G[num_f], quantite[num_f]))
                quantite_rest -= quantite[num_f]
                quantite[num_f] = 0
                num_f += 1
            else
                push!(T, (G[num_f], quantite_rest))
                quantite[num_f] -= quantite_rest
                quantite_rest = 0
            end
        end
        push!(Tournees, T)
    end
    T = []
    for i in 1:length(G)
        if quantite[i] > 0
            push!(T, (G[i], quantite[i]))
        end
    end
    push!(Tournees, T)
    return Tournees
end

function Tournees_gen(list_G, M, C, Q_max, H, d_costs, u_costs)
    # fonction qui calcule les tournées pour tout fournisseur pour toute semaine
    l_tournees = []
    for (i,G) in enumerate(list_G)
        G = chemin_opti(G, d_costs, u_costs, C)
        for s in 1:H
            tourn = tournees(G, s, M, C, Q_max)
            if tourn != [[]]
                push!(l_tournees, [s, i, tourn])
            end
        end
    end
    return l_tournees
end

function find_tournees_groupe(numero_G,l_tournees)
    # trouver toutes les tournées qui sont dans le même groupe
    res = []
    for tournee in l_tournees
        if tournee[2] == numero_G
            push!(res,tournee)
        end
    end
    return res
end

function rejet_tournees(l_tournees, choix_list_G, M, C, Q_max, H, d_costs, u_costs, s_trt)
    # si coût st plus avantageux : on st
    l_tournees_2 = []
    choix_list_G_2 = []
    l_rejet = []

    i_actu = 1
    # pour mettre le bon numéro de groupe

    for (i,G) in enumerate(choix_list_G)

        l_tournees_G = find_tournees_groupe(i,l_tournees)

        c = 0
        for tournee in l_tournees_G
            c += calc_cout_chemin(G,d_costs,u_costs,C)
        end

        # bon indice pour s_trt ?
        c_str = 0
        for k in G
            c_str += s_trt[k]
        end

        if c > c_str
            for k in G
                push!(l_rejet,k)
            end
        else
            push!(choix_list_G_2,G)
            for tournee in l_tournees_G
                push!(l_tournees_2,[ tournee[1], i_actu, tournee[3] ])
            end
            i_actu += 1
        end
    end
    return l_tournees_2, choix_list_G_2, l_rejet
end

function reduit_tournees(l_tournees, choix_list_G, M, C, Q_max, H, d_costs, u_costs, s_trt)
    # idee : on fait la meme chose qu'au dessus, mais en essayant d'enlever les fournisseurs 1 par 1 du cluster
end
