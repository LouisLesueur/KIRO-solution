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
# définir une solution admissible facile

# calcul du graph résiduel

# si il existe un chemin de s à t
# on prend le plus court et on l'ajoute




# format des solutions :
# [[(6,7),180],[..]..]
# arête et qté

function calc_graph_res(solution)
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

function existe_chemin(F_res, i) # commencer à 1
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

function trouve_chemin(F_res, i)
end
