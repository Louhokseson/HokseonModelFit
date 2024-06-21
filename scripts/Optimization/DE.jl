##################################################
# Differential Evolution
##################################################
using BlackBoxOptim
using Serialization
# Define the problem to solve
using Optimization, ForwardDiff, Zygote
using OptimizationOptimJL, OptimizationBBO
using Serialization
using Polynomials

include("../parameters_initial.jl")
include("../loss_function.jl")

# Assuming RMSE_DFT is your objective function and it's already defined
# Make sure it accepts a vector of parameters and returns a scalar value

# Load your DFT polynomial
polynomial_path = "polynomials/DFT_polynomial.jls"
DFT_polynomial = open(f -> deserialize(f), polynomial_path)

# Define a wrapper function if necessary to match the expected signature
function objective_wrapper(x)
    # Assuming [`values`](command:_github.copilot.openSymbolFromReferences?%5B%7B%22%24mid%22%3A1%2C%22path%22%3A%22%2FUsers%2Fu5575142%2FDocuments%2FHokseonModelFit%2Fscripts%2Fparameters_initial.jl%22%2C%22scheme%22%3A%22file%22%7D%2C%7B%22line%22%3A40%2C%22character%22%3A0%7D%5D "scripts/parameters_initial.jl") is a global variable or obtained within this scope
    RMSE_DFT(x, DFT_polynomial)[1]
end


# Define the bounds for your parameters
symbols = [:x̃, :k, :x₀′, :Γ, :c, :c′, :q, :a, :ã, :x₀, :L, :Dₑ, :a′]
#bounds = [(sym == :Γ ? 0.0 : -1.0, 10.0) for sym in symbols]
bounds = [(sym == :Γ ? (0.0, 5.0) : (hokseon_model_initial_params[sym] - 1.0, hokseon_model_initial_params[sym] + 1.0)) for sym in symbols]
  
# Run Optimization
optimization_method = :adaptive_de_rand_1_bin_radiuslimited
result = bboptimize(objective_wrapper; Method = optimization_method, SearchRange = bounds, MaxTime = 500.0, NumDimensions = length(symbols))

# Extract the optimal parameters
optimal_parameters = copy(best_candidate(result))
optimal_value = copy(best_fitness(result))

println("Optimal parameters: ", optimal_parameters)
println("Optimal value: ", optimal_value)

optimal_dict = Dict{Symbol,Float64}(zip(symbols, optimal_parameters))

# Specify the file path where you want to save the dictionary
file_path = "parameters/optimal_parameters_$(optimization_method).jls" # .jls extension for Julia Serialized file

# Serialize and save the dictionary to the file
open(file_path, "w") do file
    serialize(file, optimal_dict)
end

println("Dictionary saved to $file_path")