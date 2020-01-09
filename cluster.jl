using Clustering


rejet = 500 # si coût sous traitance inférieurs : on sous traite
# ça a l'air d'etre la meilleur valeur après quelques tests
# à voir si on s'amuse à le faire en détail

function sous_traitement(Z)
  # fonction qui permet de choisir quel fournisseur sous traiter ou non (dépend de la valeur de rejet)
  # input : Z (coordonnées et coût sous traitance des fournisseurs)
  # output : l_st : liste des fournisseurs à sous traiter
  #          Z_C : liste des fournisseurs à traiter
  l_st = []
  Z_C = []
  for i in 1:length(Z)
    if Z[i][3] < rejet
        push!(l_st, i)
    else
        push!(Z_C, (i, Z[i]))
    end
  end
  return (l_st, Z_C)
end

function calc_dist(x,y)
    # fonction qui calcule la distance entre deux points
    # input : points x et y (tuple de coordonnées)
    # output : distance
    return (x[1]-y[1])^2+(x[2]-y[2])^2
end

function min_dist_ind(el,Z,a_traiter)
    # fonction qui trouve le fournisseur le plus proche du fournisseur donnés
    # input : el (fournisseur), Z (liste fournissseur), a_traiter (liste qui reste à regarder)
    # output : indice du fournisseur le plus proche
    premier_indice = findfirst(isequal(true), a_traiter)
    min_j = premier_indice
    min_dist = calc_dist(el, Z[premier_indice])
    for j in (premier_indice+1):length(Z)
        if a_traiter[j]
            dist = calc_dist(el, Z[j])
            if dist<min_dist
                min_dist = dist
                min_j = j
            end
        end
    end
    return min_j
end

function clustering(Z, D_coord)
    # fonction qui établit les clusters initiaux
    # input : Z (liste des fournisseurs), D_coord (coord du dépôt)
    # output : list_G (liste des clusters), l_st (liste des sous traités)
    l_st, Z_C = sous_traitement(Z) # on regarde lesquels sous traiter
    a_traiter = [true for i in 1:length(Z)]
    list_G = []
    for i in l_st # pas besoin de mettre dans cluster si st
        a_traiter[i] = false
    end
    while sum(a_traiter) >= 4 # on fait des groupes de 4
        # ESSAYER AVEC D'AUTRES HYPOTHESES (3 PUIS ON RAJOUTE)
        premier_f = min_dist_ind(D_coord, Z, a_traiter) # le plus proche du dépôt
        G = [premier_f] # initialisation tournée
        a_traiter[premier_f] = false
        for k in 1:3 # on rajoute les trois plus proches
            f_min = min_dist_ind(Z[G[k]],Z, a_traiter)
            a_traiter[f_min] = false
            push!(G, f_min)
        end
        push!(list_G, G)
    end
    while sum(a_traiter) > 0 # si c'est pas un multiple de 4, on sous traite les restants
        # ESSAYER AUTREMENT
        f_st = findfirst(isequal(true), a_traiter)
        push!(l_st, f_st)
        a_traiter[f_st] = false
    end
    return (list_G, l_st)
end

function clustering_kmeans(Z)
    nb_clusters = 100
    Z_sans_st = [ [ elt[1], elt[2] ] for elt in Z]
    Z_sans_st = hcat(Z_sans_st...)
    #print(Z_sans_st)
    R = kmeans(Matrix(Z_sans_st), nb_clusters)
    A = assignments(R)
    list_G = [ [] for i in 1:nb_clusters ]
    for i in 1:length(A)
        push!(list_G[A[i]],i)
    end
    """list_G_2 = []
    for elt in list_G
        if (length(elt) > 0)
            push!(list_G_2,elt)
        end
    end"""
    return(list_G,[])
end



##################
function premier_soustraitement(Z, d_costs, u_costs, M, Q_max)
    # Z[i][3] = cout sous traite
    # charge semaine : M[i][s]
    # cout aller retour : d_costs, u_costs
    l_st = []
    Z_C = []
    for i in 1:length(Z)
      if Z[i][3] < (d_costs[i]+u_costs[i])/Q_max*(sum([M[i][s] for s in 1:H]))
          push!(l_st, i)
      else
          push!(Z_C, Z[i])
      end
    end
    return (l_st, Z_C)
end


function split_cluster(G)
    G2 = []
    for g in G
        if length(g) > 4
            push!(G2, g[1:4])
            if length(g)-4 > 4
                push!(G2, g[5:8])
                push!(G2, g[9:length(g)])
            else
                push!(G2, g[5:length(g)])
            end
        else
            push!(G2, g)
        end
    end
    return G2
end
