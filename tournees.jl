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
        """
        for tournee in l_tournees_G
            c += calc_cout_chemin(G,d_costs,u_costs,C)
        end
        """
        for tournee in l_tournees_G
            c += calc_cout_tournees(tournee[3],d_costs,u_costs,C)
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



#############
function remplissage(g, ordre, new_M, Q)
	k = 1
	i = ordre[k]
	charge = new_M[i]
    if new_M[i] != 0
        T = [[(g[i], new_M[i])]]
    else
        T = [[]]
    end
	while k < length(g)
		k += 1
		i = ordre[k]
		if charge + new_M[i] <= Q
			charge += new_M[i]
		else
			push!(T, [])
            charge = new_M[i]
		end
        if new_M[i] != 0
            push!(T[length(T)], (g[i], new_M[i]))
        end
	end
	return T
end

function calc_cout_tournees(T, d_costs, u_costs, C)
    cout = 0
    for t in T
        if t != Any[]
            chem = [t[i][1] for i in 1:length(t)]
            cout += calc_cout_chemin(chem, d_costs, u_costs, C)
        end
    end
    return cout
end

function tournee_opti_gs(g, s, d_costs, u_costs, M, C, Q)
    l_T = []
    # d’abord on fait des tournées pour les supérieurs à 13 :
    new_M = []
    for i in g
        m = M[i][s]
        while isless(Q, m)
           push!(l_T, [(i, Q)])
           m -= Q
       end
       push!(new_M, m)
   end
   # ensuite on regroupe de la façon la plus opti = le moins de camion possible, parcourant la plus petite distance possible
   # (QUESTION : selon le remplissage du coup pas sûr que le calcul préalable de l’ordre opti soit intéressant à effectuer)
   # les groupes étant de 4 on peut faire une fonction qui fait le remplissage « correct » prenant en argument l’ordre de passage :
   ordre = collect(permutations(1:length(g)))
   T_min = remplissage(g, ordre[1], new_M, Q)
   cout_min = calc_cout_tournees(T_min, d_costs, u_costs, C)
   i_min = 1
   for (i, ord) in enumerate(ordre)
       T = remplissage(g, ord, new_M, Q)
       cout = calc_cout_tournees(T, d_costs, u_costs, C)
       if isless(cout, cout_min)
           cout_min = cout
           i_min = i
           T_min = T
       end
   end
   l_T = vcat(l_T, T_min)
   return l_T
end

function tournee_opti(G, M, C, Q_max, H, d_costs, u_costs)
    # fonction qui calcule les tournées pour tout fournisseur pour toute semaine
    l_tournees = []
    for (i,g) in enumerate(G)
        for s in 1:H
            tourn = tournee_opti_gs(g, s, d_costs, u_costs, M, C, Q)
            if tourn != [[]]
                push!(l_tournees, [s, i, tourn])
            end
        end
    end
    return l_tournees
end

#############
function rejet_tournees_2(G, M, C, Q_max, H, d_costs, u_costs, s_trt)
    # idem que la première version, mais en essayant de rejeter 1 par 1 les fournisseurs du cluster
    # Les clusters de taille 1 sont sous-traité ; on testera ensuite s'il est plus interessant de les sous traiter ou d'en faire des clusters de taille 1
    l_tournees = []
    choix_list_G_2 = []
    l_rejet = []

    i_actu = 1
    # pour mettre le bon numéro de groupe

    for (i,g) in enumerate(G)
        if length(g)==1
            push!(l_rejet,g[1])
            continue
        end

        cout_init = 0
        l_tournees_g = []

        for s in 1:H
            tourn = tournee_opti_gs(g, s, d_costs, u_costs, M, C, Q)
            if tourn != [[]]
                push!(l_tournees_g, [s, i_actu, tourn])
            end
            cout_init += calc_cout_tournees(tourn, d_costs, u_costs, C)
        end

        changement = true

        while length(g)>1 && changement
            changement = false
            for k in 1:length(g)

                new_g = [g[ind] for ind in 1:length(g) if ind != k]
                new_cout = 0
                new_l_tournees_g = []

                for s in 1:H
                    tourn = tournee_opti_gs(new_g, s, d_costs, u_costs, M, C, Q)
                    if tourn != [[]]
                        push!(new_l_tournees_g, [s, i_actu, tourn])
                    end
                    new_cout += calc_cout_tournees(tourn, d_costs, u_costs, C)
                end
                new_cout += s_trt[ g[k] ]

                if new_cout<cout_init
                    push!(l_rejet, g[k])
                    cout_init = new_cout
                    l_tournees_g = new_l_tournees_g
                    g = new_g
                    changement = true
                    break
                end
            end
        end

        if length(g)==1
            push!(l_rejet,g[1])
            continue
        end

        l_tournees = vcat(l_tournees, l_tournees_g)
        push!(choix_list_G_2,g)
        i_actu += 1

    end
    return l_tournees, choix_list_G_2, l_rejet
end

function st_to_cluster(l_st, G, M, C, Q_max, H, d_costs, u_costs, s_trt)
    # essaie de faire des cluster de 1 avec les sous-traités
    i_actu = length(G) + 1
    l_tournees_enplus = []
    l_st_actu = []
    for i_fournisseur in l_st
        g = [i_fournisseur]
        test_tourn = []
        cout_cluster = 0
        for s in 1:H
            tourn = tournee_opti_gs(g, s, d_costs, u_costs, M, C, Q)
            if tourn != [[]]
                push!(test_tourn, [s, i_actu, tourn])
            end
            cout_cluster += calc_cout_tournees(tourn, d_costs, u_costs, C)
        end
        if cout_cluster < s_trt[i_fournisseur]
            push!(G,g)
            l_tournees_enplus = vcat(l_tournees_enplus, test_tourn)
            i_actu += 1
        else
            push!(l_st_actu, i_fournisseur)
        end
    end
    return(G, l_tournees_enplus, l_st_actu)
end
