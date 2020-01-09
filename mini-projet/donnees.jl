# matrice des incidences I

# ajout d'une super source qui dessert toutes les sources (S)
# ajout d'une super usine pour imposer le flot de sortie (T)
# 1 2 3 4 A B C D E F U : num ligne -> num colonne
I = [[0,1,1,1,1,0,0,0,0,0,0,0,0],
     [-1,0,0,0,0,0,1,1,0,0,0,0,0],
     [-1,0,0,0,0,1,1,0,0,0,0,0,0],
     [-1,0,0,0,0,1,0,0,0,1,0,0,0],
     [-1,0,0,0,0,0,0,0,0,1,1,0,0],
     [0,0,-1,-1,0,0,0,0,1,0,0,0,0],
     [0,-1,-1,0,0,0,0,0,1,0,0,0,0],
     [0,-1,0,0,0,0,0,0,1,0,0,1,0],
     [0,0,0,0,0,-1,-1,-1,0,-1,0,1,0],
     [0,0,0,-1,-1,0,0,0,1,0,1,0,0],
     [0,0,0,0,-1,0,0,0,0,-1,0,1,0],
     [0,0,0,0,0,0,0,-1,-1,0,-1,0,1],
     [0,0,0,0,0,0,0,0,0,0,0,-1,0]]

# matrice des coûts M
M = [[Inf,0,0,0,0,Inf,Inf,Inf,Inf,Inf,Inf,Inf],
     [0,Inf,Inf,Inf,Inf,Inf,14,19,Inf,Inf,Inf,Inf,Inf],
     [0,Inf,Inf,Inf,Inf,9,10,Inf,Inf,Inf,Inf,Inf,Inf],
     [0,Inf,Inf,Inf,Inf,12,Inf,Inf,Inf,18,Inf,Inf,Inf],
     [0,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,26,10,Inf,Inf],
     [Inf,Inf,Inf,Inf,Inf,Inf,Inf,25,Inf,Inf,Inf,Inf],
     [Inf,Inf,Inf,Inf,Inf,Inf,Inf,11,Inf,Inf,Inf,Inf],
     [Inf,Inf,Inf,Inf,Inf,Inf,Inf,8,Inf,Inf,14,Inf],
     [Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,15,Inf],
     [Inf,Inf,Inf,Inf,Inf,Inf,Inf,4,Inf,7,Inf,Inf],
     [Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,20,Inf],
     [Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,0],
     [Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf]]

# matrice du flot max supporté
F_max = [[0,205,75,95,195,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,200,200,0,0,0,0,0],
        [0,0,0,0,0,200,200,0,0,0,0,0,0],
        [0,0,0,0,0,200,0,0,0,200,0,0,0],
        [0,0,0,0,0,0,0,0,0,200,200,0,0],
        [0,0,0,0,0,0,0,0,200,0,0,0,0],
        [0,0,0,0,0,0,0,0,200,0,0,0,0],
        [0,0,0,0,0,0,0,0,200,0,0,200,0],
        [0,0,0,0,0,0,0,0,0,0,0,200,0],
        [0,0,0,0,0,0,0,0,200,0,200,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,200,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,570],
        [0,0,0,0,0,0,0,0,0,0,0,0,0]]

F_min = [[0,205,75,95,195,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,570],
        [0,0,0,0,0,0,0,0,0,0,0,0,0]]

# to do :
# définir une solution admissible facile, exemple :
#1(205) 1-c 200 c-u 200 1-b 5 b-d 80 d-u 175
#2(75) 2-b 75
#3(95) 3-e 95 e-d 95
#4(195) 4-f 195 f-u 195
# + trajets obligés : S-1 205, S-2 75, S-3 95, S-4 195, U-F 570
#a6,b7,c8,d9,e10,f11
solution_naive = [[(1,2),205],[(1,3),75],[(1,4),95],[(1,5),195],[(12,13),570],[(2,8),200],[(8,12),200],
                  [(2,7),5],[(7,9),80],[(9,12),175],[(3,7),75],[(4,10),95],[(10,9),95],[(5,11),195],[(11,12),195]]

F_naif =[[0,205,75,95,195,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,5,200,0,0,0,0,0],
        [0,0,0,0,0,0,0,75,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,95,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,195,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,80,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,200,0],
        [0,0,0,0,0,0,0,0,0,0,0,175,0],
        [0,0,0,0,0,0,0,0,95,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,195,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,570],
        [0,0,0,0,0,0,0,0,0,0,0,0,0]]

# calcul du graph résiduel

# si il existe un chemin de s à t
# on prend le plus court et on l'ajoute




# format des solutions :
# [[(6,7),180],[..]..]
# arête et qté

function calc_graph_res(solution) # calcul du graph résiduel
    # à finir
    F_res = F_max
    for s in solution
        A = s[1]
        flot = s[2]
        if flot < F_max[A[1]][A[2]]
            F_res[A[1]][A[2]] = F_max[A[1]][A[2]] - flot
        end
        if flot > 0
            F_res[A[2]][A[1]] = flot
        end
    end
end

function existe_chemin(F_res, i) # commencer à 1, # renvoi true s'il existe un chemin dans le graph res
    if i == length(F_res[1])-1
        return true
    end
    for (k,site) in enumerate(F_res[i])
        if site > 0
            existe = existe_chemin(F_res, k)
            if existe
                return true
            end
        end
    end
end

existe_chemin(F_max, 1)

function calc_cout(solution)
    cout = 0
    for s in solution
        A = s[1]
        cout += M[A[1]][A[2]]
    end
    return cout
end



#### algo folkerson
## fonctions utiles
function successeurs(x, prec=false)
    # renvoi la liste des successeurs de x
    liste_incidence = I[x]
    suc = []
    condition = 1
    if prec
        condition = -1
    end
    for (sommet, inc) in enumerate(liste_incidence)
        if inc == condition
            push!(suc, sommet)
        end
    end
    return suc
end

function chaine_ameliorante(F_sol) # trouve une chaine ameliorante
    Z = [] # file des sommets à traiter
    # marquage des sommets visités
    marque_sommets = [true, false, false, false, false, false, false, false, false, false, false, false, false]
    Z = [1]
    mu_plus = []
    mu_moins = []
    while length(Z)>0 && !marque_sommets[13]
        x = Z[1]
        deleteat!(Z, 1)
        suc = successeurs(x)
        for s in suc
            if !marque_sommets[s] && F_sol[x][s]<F_max[x][s]
                marque_sommets[s] = true
                push!(Z, s)
                push!(mu_plus, (x,s))
            end
        end
        pred = successeurs(x, true)
        for p in pred
            if !marque_sommets[p] && F_sol[p][x]>0
                marque_sommets[p] = true
                push!(Z, p)
                push!(mu_moins, (p,x))
            end
        end
    end
    if marque_sommets[13]
        return true, mu_plus, mu_moins
    end
    return false, false, false
end

function calcul_delta(F, mu_plus, mu_moins)
    flot_moins = []
    for arc in mu_moins
        push!(flot_moins, F[arc[1]][arc[2]])
    end
    min1 = min(flot_moins)
    flot_plus = []
    for arc in mu_plus
        push!(flot_plus, F_max[arc[1]][arc[2]] - F[arc[1]][arc[2]])
    end
    min2 = min(flot_plus)
    return min(min1, min2)
end

function algo_ff()
    F = F_naif
    CA = chaine_ameliorante(F)
    print(CA[1])
    while CA[1]
        delta = calcul_delta(F, CA[2], CA[3])
        for arc in CA[2]
            F[arc[1]][arc[2]] += delta
        end
        for arc in CA[3]
            F[arc[1]][arc[2]] -= delta
        end
    end
    return F
end

# ne prend pas en compte les cous et vois pas comment les ajouter

# en fait, par itération : on prend le puit 1, on regarde cb de routes on est obligés d'ouvrir
# idem pour chacun des puits
# on ouvre ceux de coût min
