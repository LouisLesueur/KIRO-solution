include("InputHandler.jl")
include("cluster.jl")
include("tournees.jl")
include("OutputHandler.jl")

Q, F, H, C, M, d_costs, u_costs, f_coords, s_trt = read_to_list("divers/Instance-propre.csv")

Z = [(f_coords[i][1],f_coords[i][2],s_trt[i]) for i in 1:(F-2)]

using Plots
plot([f_coords[i][1] for i in 1:F],[f_coords[i][2] for i in 1:F],seriestype=:scatter,title="My Scatter Plot")
