function calc_cout_chemin(G, d_costs, u_costs, C)
    cout = d_costs[G[1]]
    for k in 2:length(G)
        cout += C[G[k-1]][G[k]]
    end
    cout += u_costs[G[length(G)]]
    return cout
end

function chemin_opti(G, d_costs, u_costs, C)
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
    quantite = [M[G[i]][s] for i in 1:length(G)]
    Tournees = []
    while sum(quantite) > Q_max
        num_f = 1
        quantite_rest = Q_max
        T = []
        while quantite_rest > 0 && num_f<=length(G)
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
    l_tournees = []
    for G in list_G
        G = chemin_opti(G, d_costs, u_costs, C)
        for s in 1:H
            tourn = tournees(G, s, M, C, Q_max)
            if tourn != [[]]
                push!(l_tournees, [s, G, tourn])
                print(tourn, "\n")
            end
        end
    end
    return l_tournees
end
