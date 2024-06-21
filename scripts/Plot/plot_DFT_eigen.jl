using DrWatson
@quickactivate "HokseonModelFit"
using NQCModels
using Unitful, UnitfulAtomic
using Polynomials
using Serialization
using LinearAlgebra
using Serialization

include("../parameters_initial.jl")
include("../loss_function.jl")


using CairoMakie
using JamesPlots, ColorSchemes, Colors, Printf


function plot_DFTPoly_groundstate(x_ang,groundstate,DFT_austripped)
    ylimitsup = [nothing]
    ylimitslow = [nothing]
    fig = Figure(figure_padding=(1, 2, 1, 4), 
                 fonts=(;regular=projectdir("fonts", "MinionPro-Capt.otf")), 
                 size=(JamesPlots.RESOLUTION[1]*2, JamesPlots.RESOLUTION[2]*3))

    ax1 = MyAxis(fig[1,1]; xlabel="x /Å", limits=(0, 5, ylimitslow[1], ylimitsup[1]), ylabel = "Energy /eV")
    ax1.title = ""

    lines!(ax1, x_ang, groundstate, color=:black, linewidth=1.5, label="Hokseon Model Groundstate")
    lines!(ax1, x_ang, DFT_austripped, color=:red, linewidth=1.5, label="DFT Data", linestyle=:dash)

    Legend(fig[1,1], ax1, tellwidth=false, tellheight=false, valign=:top, halign=:right, margin=(5, 5, 5, 5), orientation=:horizontal)
    Label(fig[1,1], "RMSE:$(@sprintf("%.5f", L))"; tellwidth=false, tellheight=false, valign=:bottom, halign=:right, padding=(5,5,5,5), fontsize=14)
    return fig
end


## Load the optimal parameters from the optimization ##
optimal_dict_path = "parameters/optimal_parameters_adaptive_de_rand_1_bin_radiuslimited.jls"
optimal_dict = open(f -> deserialize(f), optimal_dict_path)
Values = collect(values(optimal_dict))

## Load the initial parameters ##
Values = values_initial



L, groundstate,DFT_austripped  = RMSE_DFT(Values,DFT_polynomial)

groundstate_ev = groundstate .* ustrip(auconvert(u"eV", 1))

DFT_ev = DFT_austripped .* ustrip(auconvert(u"eV", 1))

save("plots/ground_DFT_initial.pdf",plot_DFTPoly_groundstate(x_ang,groundstate_ev,DFT_ev))