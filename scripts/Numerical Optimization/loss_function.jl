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

 groundstate = Hokseon_ground(hokseon_model_initial_params, x)


## Polynomials should covengre to the groundstate when x_ang goes to 5Å
C = ustrip(auconvert(u"eV", groundstate[end])) - DFT_polynomial(x_ang[end])
DFT_polynomial = DFT_polynomial .+ C

DFT_austripped  = austrip.(DFT_polynomial.(x_ang).*u"eV")

Loss_DFT(groundstate) = sum((DFT_austripped .- groundstate).^2);


#println(Loss_DFT(DFT_austripped,groundstate))


