using DrWatson
@quickactivate "HokseonModelFit"
using Unitful, UnitfulAtomic


global hokseon_model_initial_params = Dict{Symbol,Float64}(
    ## Hokseon Morse parameters ##
    :Dₑ => austrip(1.761u"eV"), 
    :a => austrip(1.92u"Å^-1"), 
    :x₀ => austrip(1.532u"Å"), 
    :c => austrip(-1.706u"eV"), 
    
    ## Hokseon Logistic parameters ##
    :L => austrip(14.206u"eV"),
    :k => austrip(1.935u"Å^-1"),
    :x₀′ => austrip(2.457u"Å"),
    :c′ => austrip(-1.230u"eV"),
    :a′ => 0.975,

    ## Hokseon coupling function parameters ##
    :Γ => austrip(0.1u"eV"),
    :q => 0.05,
    :ã => austrip(0.5u"Å"),
    :x̃ => austrip(2.7u"Å"),
)


global general_params = Dict{String,Any}(

    "x_ang" => range(0.8, 6, length=200),
    "bandgap" => 0.49,
    "centre" => 0.0,
    "discretisation"=>:GapGaussLegendre,
    "nstates" => 500,
    "width" => 50,
)
@unpack x_ang, bandgap, centre, discretisation, nstates, width = general_params

x = austrip.(x_ang .* u"Å");