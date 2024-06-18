using DrWatson
@quickactivate "HokseonModelFit"
using Zygote

gradient(x -> 3x^2 + 2x + 1, 5)

gradient((a, b) -> a*b, 2, 3)
function pow(x, n)
    r = 1
    for i = 1:n
      r *= x
    end
    return r
end
gradient(x -> pow(x, 1), 5)

function logistic(L, k, x₀, c, a, r)
return L / (1 + exp(-k * a *(r - x₀))) + c
end

theta_logistic = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
gradient((L, k, x₀, c, a, r) -> logistic(L, k, x₀, c, a, r), theta_logistic...)