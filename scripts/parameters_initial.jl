using DrWatson
@quickactivate "HokseonModelFit"
using Unitful, UnitfulAtomic
using Serialization


global hokseon_model_initial_params = Dict{Symbol,Float64}(
    ## Hokseon Morse parameters ##
    :Dₑ => austrip(1.761u"eV"), 
    :a => austrip(1.92u"Å^-1"), 
    :x₀ => austrip(1.532u"Å"), 
    :c => austrip(0.0u"eV"), 
    
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

hokseon_model_initial_params_vector = [(:x̃, 5.10226053648958), 
                                       (:k, 1.023957903097305), 
                                       (:x₀′, 4.643057088205517), 
                                       (:Γ, 0.0036749322175518595), 
                                       (:c, 0.0), 
                                       (:c′, -0.04520166627588787), 
                                       (:q, 0.05), 
                                       (:a, 1.0160202449337599), 
                                       (:ã, 0.9448630623128851), 
                                       (:x₀, 2.89506042292668), 
                                       (:L, 0.5220608708254171), 
                                       (:Dₑ, 0.06471555635108824), 
                                       (:a′, 0.975)]

values_initial = [pair[2] for pair in hokseon_model_initial_params_vector]


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




#Do it when you need to save the initial parameters


#file_path = "parameters/initial_parameters.jls" # .jls extension for Julia Serialized file

# Serialize and save the dictionary to the file
#open(file_path, "w") do file
#    serialize(file, hokseon_model_initial_params)
#end
