include("InputHandler.jl")
include("cluster.jl")
include("tournees.jl")
include("OutputHandler.jl")
using Combinatorics

Q, F, H, C, M, d_costs, u_costs, f_coords, s_trt = read_to_list("divers/Instance-propre.csv")

Z = [(f_coords[i][1],f_coords[i][2],s_trt[i]) for i in 1:(F-2)]
#choix = clustering(Z, d_coord)
choix = clustering_kmeans(Z, d_coord)
choix_list_G = choix[1]
choix_l_st = choix[2]

list_tournees = Tournees_gen(choix_list_G, M, C, Q, H, d_costs, u_costs)

print("bouh")

create_output_file("solution.txt", choix_l_st, list_tournees, choix_list_G)

list_tournees_2, choix_list_G_2, l_rejet_enplus = rejet_tournees(list_tournees, choix_list_G, M, C, Q, H, d_costs, u_costs, s_trt)

print("bonsoir")

for k in l_rejet_enplus
    push!(choix_l_st,k)
end

create_output_file("solution2.txt", choix_l_st, list_tournees_2, choix_list_G_2)

using Plots
plot([f_coords[i][1] for i in 1:F],[f_coords[i][2] for i in 1:F],seriestype=:scatter,title="My Scatter Plot")

list_coord_st_x = [f_coords[i][1] for i in choix_l_st]
list_coord_st_y = [f_coords[i][2] for i in choix_l_st]
plot!(list_coord_st_x,list_coord_st_y,seriestype=:scatter)

for G in choix_list_G_2
	list_coord_G_x = [f_coords[i][1] for i in G]
	list_coord_G_y = [f_coords[i][2] for i in G]
    print("\n")
    print(list_coord_G_x)
    print("\n")
    print(list_coord_G_y)
	plot!(list_coord_G_x,list_coord_G_y,seriestype=:scatter,label="")
end

plot!([f_coords[i][1] for i in F:F],[f_coords[i][2] for i in F:F],seriestype=:scatter)
