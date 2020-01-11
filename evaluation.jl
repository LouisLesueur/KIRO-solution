""" pour evaluer le cout d'une solution"""

function calc_cout_t(T, d_costs, u_costs, C)
    cout = 0
    if T != Any[]
        chem = [T[3][i] for i in 1:length(T[3])]
        cout += calc_cout_tournees(chem, d_costs, u_costs, C)
    end
    return cout
end

function calc_cout(choix_l_st, list_tournees)
    cout = 0
    for f in choix_l_st
        cout += s_trt[f]
    end
    for l_t in list_tournees
        cout += calc_cout_t(l_t, d_costs, u_costs, C)
        end
    return cout
end
