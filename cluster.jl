function sous_traitement(Z)
  l_st = []
  Z_C = []
  for i in 1:length(Z)
    if Z[i][3] < 10
        push!(l_st, i)
    else
        push!(Z_C, (i, Z[i]))
    end
  end
  return (l_st, Z_C)
end

function calc_dist(x,y)
    return (x[1]-y[1])^2+(x[2]-y[2])^2
end

function min_dist_ind(el,Z,a_traiter)
    # el : Tuple[float,float]
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
    l_st, Z_C = sous_traitement(Z)
    a_traiter = [true for i in 1:length(Z)]
    list_G = []
    for i in l_st
        a_traiter[i] = false
    end
    while sum(a_traiter) >= 4
        premier_f = min_dist_ind(D_coord, Z, a_traiter)
        G = [premier_f]
        a_traiter[premier_f] = false
        for k in 1:3
            f_min = min_dist_ind(Z[G[k]],Z, a_traiter)
            a_traiter[f_min] = false
            push!(G, f_min)
        end
        push!(list_G, G)
    end
    while sum(a_traiter) > 0
        f_st = findfirst(isequal(true), a_traiter)
        push!(l_st, f_st)
        a_traiter[f_st] = false
    end
    return (list_G, l_st)
end
