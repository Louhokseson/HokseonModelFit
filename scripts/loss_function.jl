using DrWatson
@quickactivate "HokseonModelFit"
using NQCModels
using Unitful, UnitfulAtomic
using Polynomials
using Serialization
using LinearAlgebra

include("parameters_initial.jl")

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXX Loss of DFT data XXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

## REMIND THAT DFT_polynomial has inputs with ATOMIC UNITS!!!
polynomial_path = "polynomials/DFT_polynomial.jls"
DFT_polynomial = open(f -> deserialize(f), polynomial_path)


## Computation of the groundstate vector of Hokseon model
##
function Hokseon_ground(params::Dict{Symbol,Float64}, x::Vector{Float64})
    hokseonmodel = Hokseon(;params...)
    Twobytwos = NQCModels.potential.(hokseonmodel,x)
    groundstate = map(v -> v[1],eigvals.(Twobytwos))
    return groundstate
end

Loss_DFT_groundstate(groundstate) = sqrt.(sum((DFT_austripped .- groundstate).^2) * ustrip(auconvert(u"eV", 1))^2 ./ 200)



function RMSE_DFT(params,DFT_polynomial)

    groundstate = Hokseon_ground(params,x)

    C = ustrip(auconvert(u"eV", groundstate[end])) - DFT_polynomial(x_ang[end])

    DFT_polynomial = DFT_polynomial .+ C

    DFT_austripped  = austrip.(DFT_polynomial.(x_ang).*u"eV")

    return sqrt.(sum((DFT_austripped .- groundstate).^2) * ustrip(auconvert(u"eV", 1))^2 ./ 200)
end

RMSE_DFT(hokseon_model_initial_params,DFT_polynomial)


