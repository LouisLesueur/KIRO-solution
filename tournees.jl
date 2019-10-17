function tournees(G, s, M, C, Q_max)
    quantite = [M[G[i], s] for i in 1:length(G)]
    Tournees = []
    while sum(quantite)>Q_max
        # permutation opti
        num_f = 1
        quantite_rest = Q_max
        T = []
        while quantite_rest > 0 # && num_f<=length(G)
            if quantite[num_f] < quantite_rest
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
        if quantite[i]>0
            push!(T, (G[i], quantite[i]))
        end
    end
    push!(Tournees, T)
    return Tournees
end

function Tournees_gen(list_G, M, C, Q_max, H)
    l_tournees = []
    for s in 1:H
        for G in list_G
            push!(l_tournees, [s, G, tournees(G, s, M, C, Q_max)])
        end
    end
    return l_tournees
end
