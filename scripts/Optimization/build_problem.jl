# Define the problem to solve
using Optimization, ForwardDiff, Zygote
using OptimizationOptimJL, OptimizationBBO
using Serialization
using Polynomials

include("../parameters_initial.jl")
include("../loss_function.jl")


## REMIND THAT DFT_polynomial has inputs with ATOMIC UNITS!!!
polynomial_path = "polynomials/DFT_polynomial.jls"
DFT_polynomial = open(f -> deserialize(f), polynomial_path)


f = OptimizationFunction(RMSE_DFT, Optimization.AutoForwardDiff())


symbols = [:x̃, :k, :x₀′, :Γ, :c, :c′, :q, :a, :ã, :x₀, :L, :Dₑ, :a′]
lb = [sym == :Γ ? 0.0 : -1.0 for sym in symbols]
ub = [10.0 for sym in symbols]

prob = Optimization.OptimizationProblem(f, values, DFT_polynomial, lb = lb, ub = ub)

# Define a callback function to display the current iteration number
callback = function (state)
    println("Current iteration: ", state.iteration)
    return false # Return false to indicate that the optimization should not terminate
end

sol = solve(prob, BBO_adaptive_de_rand_1_bin_radiuslimited(), maxiters = 3,
    maxtime = 1000.0) # Nelder–Mead method: derivative-free


"""
rosenbrock(x, p) = (p[1] - x[1])^2 + p[2] * (x[2] - x[1]^2)^2
x0 = zeros(2)
_p = [1.0, 100.0]
f = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
prob = OptimizationProblem(f, x0, _p)
sol = solve(prob, SimulatedAnnealing())
"""