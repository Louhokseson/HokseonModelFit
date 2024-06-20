using DrWatson
@quickactivate "HokseonModelFit"
include("../parameters_initial.jl")
include("../loss_function.jl")


###XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
###XXXXXXXXXXXXXXXX  Calculation of the Gradient XXXXXXXXXXXXXXXXXX
###XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

## Try to do one by one

perturbation = 1e-5
lr = 1e-2

## central difference for the approximated gradient of each parameter


hokseon_model_new_params = copy(hokseon_model_initial_params)

for i in 1:4
    global hokseon_model_initial_params # Declare the variable as global if you're modifying it
    println("At $(i-1) epoch Loss: ", Loss_DFT_groundstate(Hokseon_ground(hokseon_model_initial_params, x)))
    for θ in keys(hokseon_model_initial_params)
        θplusperturbed = copy(hokseon_model_initial_params[θ]) + perturbation
        θminusperturbed = copy(hokseon_model_initial_params[θ]) - perturbation
        groupstateplusperturbed = Hokseon_ground(merge(hokseon_model_initial_params, Dict(θ => θplusperturbed)), x)
        groupstateminusperturbed = Hokseon_ground(merge(hokseon_model_initial_params, Dict(θ => θminusperturbed)), x)
        ∇θ = (Loss_DFT_groundstate(groupstateplusperturbed)- Loss_DFT_groundstate(groupstateminusperturbed)) / (2*perturbation)
        println("Gradient of $θ: $∇θ")
        hokseon_model_new_params[θ] = copy(hokseon_model_initial_params[θ]) - lr*∇θ
    end
    hokseon_model_initial_params = copy(hokseon_model_new_params)
end
