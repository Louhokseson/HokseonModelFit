# Define the problem to solve
using Optimization, ForwardDiff, Zygote
using OptimizationOptimJL
using Serialization
using Polynomials

include("../parameters_initial.jl")
include("../loss_function.jl")


## REMIND THAT DFT_polynomial has inputs with ATOMIC UNITS!!!
polynomial_path = "polynomials/DFT_polynomial.jls"
DFT_polynomial = open(f -> deserialize(f), polynomial_path)


f = OptimizationFunction(RMSE_DFT, Optimization.AutoForwardDiff())

prob = OptimizationProblem(f, hokseon_model_initial_params, DFT_polynomial)

sol = solve(prob, NelderMead()) # Nelder–Mead method: derivative-free


"""
rosenbrock(x, p) = (p[1] - x[1])^2 + p[2] * (x[2] - x[1]^2)^2
x0 = zeros(2)
_p = [1.0, 100.0]
f = OptimizationFunction(rosenbrock, Optimization.AutoForwardDiff())
prob = OptimizationProblem(f, x0, _p)
sol = solve(prob, SimulatedAnnealing())
"""