using DrWatson
@quickactivate "HokseonModelFit"
using ForwardDiff

# Define a function that takes a vector and returns a scalar
f(x::Vector) = sin(x[1]) + prod(x[2:end]);  # returns a scalar
x = vcat(pi/4, 2:4)

ForwardDiff.gradient(f, x)

f(x::Vector) = eigvals([3*x[1]^2 + 2*x[1] + 1 x[1]^3 ; x[1] x[1]^3])  # returns a vector


ForwardDiff.jacobian(f, [5])


function approximate_gradient(f, x; h=1e-5)
    grad = zeros(length(x))
    for i in 1:length(x)
        x_forward = copy(x)
        x_backward = copy(x)
        x_forward[i] += h
        x_backward[i] -= h
        grad[i] = (f(x_forward) - f(x_backward)) / (2h)
    end
    return grad
end

# Define a function that uses eigvals
function f_eigvals(x::Vector)
    A = [3*x[1]^2 + 2*x[1] + 1 x[1]^3; x[1] x[1]^3]
    return sum(eigvals(A))  # Example operation on eigenvalues
end

x = [5.0]
gradient_approx = approximate_gradient(f_eigvals, x)