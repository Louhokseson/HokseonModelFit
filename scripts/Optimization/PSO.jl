using BlackBoxOptim
using Serialization
using Optimization, ForwardDiff, Zygote
using OptimizationOptimJL, OptimizationBBO
using Polynomials

include("../parameters_initial.jl")
include("../loss_function.jl")

# Load your DFT polynomial
polynomial_path = "polynomials/DFT_polynomial.jls"
DFT_polynomial = open(f -> deserialize(f), polynomial_path)

# Define a wrapper function for your objective
function objective_wrapper(x)
    RMSE_DFT(x, DFT_polynomial)
end

# Define the bounds for your parameters
symbols = [:x̃, :k, :x₀′, :Γ, :c, :c′, :q, :a, :ã, :x₀, :L, :Dₑ, :a′]
bounds = [(sym == :Γ ? 0.0 : -2.0, 10.0) for sym in symbols]

# Run Particle Swarm Optimization
result = bboptimize(objective_wrapper; Method = :particle_swarm, SearchRange = bounds, MaxTime = 1000.0, NumDimensions = length(symbols), PopulationSize = 50)

# Extract the optimal parameters and value
optimal_parameters = best_candidate(result)
optimal_value = best_fitness(result)

println("Optimal parameters: ", optimal_parameters)
println("Optimal value: ", optimal_value)