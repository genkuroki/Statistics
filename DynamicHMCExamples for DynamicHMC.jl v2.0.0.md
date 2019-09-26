---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.1'
      jupytext_version: 1.2.1
  kernelspec:
    display_name: Julia 1.2.0
    language: julia
    name: julia-1.2
---

<!-- #region -->
# DynamicHMCExamples for DynamicHMC.jl v2.0.0

黒木玄

2019-08-26～2019-09-03

2019年9月3日に

```
pkg> add LogDensityProblems
pkg> add DynamicHMC
```

した状態で

https://github.com/tpapp/DynamicHMCExamples.jl/tree/master/src

にあるexamplesを動くようにしたノートブック.

DynamicHMC.jl は v2.0.0 から仕様が大幅に変化するので, 現在公開されているexamplesがそのままでは動かない.  それを修正してみたのが, このノートブックです.
<!-- #endregion -->

```julia
]status LogDensityProblems
```

```julia
]status DynamicHMC
```

<!-- #region {"toc": true} -->
<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Bernoulli" data-toc-modified-id="Bernoulli-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Bernoulli</a></span></li><li><span><a href="#Logistic-regression" data-toc-modified-id="Logistic-regression-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Logistic regression</a></span></li><li><span><a href="#Linear-regression" data-toc-modified-id="Linear-regression-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Linear regression</a></span></li></ul></div>
<!-- #endregion -->

```julia
using Distributions
using TransformVariables
using LogDensityProblems
using DynamicHMC
using DynamicHMC.Diagnostics
using MCMCDiagnostics
using Parameters
using Statistics
using Random
using Plots
gr(size=(400, 250), titlefontsize=12)
using ForwardDiff
using StatsFuns
using LinearAlgebra
```

## Bernoulli

https://github.com/tpapp/DynamicHMCExamples.jl/blob/master/src/example_independent_bernoulli.jl

```julia
# # Estimate Bernoulli draws probabilility

# We estimate a simple model of ``n`` independent Bernoulli draws, with
# probability ``α``. First, we load the packages we use.

# using TransformVariables
# using LogDensityProblems
# using DynamicHMC
# using MCMCDiagnostics
# using Parameters
# using Statistics

# Then define a structure to hold the data.
# For this model, the number of draws equal to `1` is a sufficient statistic.

"""
Toy problem using a Bernoulli distribution.
We model `n` independent draws from a ``Bernoulli(α)`` distribution.
"""
struct BernoulliProblem
    "Total number of draws in the data."
    n::Int
    "Number of draws `==1` in the data"
    s::Int
end

# Then make the type callable with the parameters *as a single argument*.  We
# use decomposition in the arguments, but it could be done inside the function,
# too.

function (problem::BernoulliProblem)((α, )::NamedTuple{(:α, )})
    @unpack n, s = problem        # extract the data
    # log likelihood: the constant log(combinations(n, s)) term
    # has been dropped since it is irrelevant to sampling.
    s * log(α) + (n-s) * log(1-α)
end

# We should test this, also, this would be a good place to benchmark and
# optimize more complicated problems.

p = BernoulliProblem(30, 10)
p((α = 0.5, ))
```

```julia
# Recall that we need to
#
# 1. transform from ``ℝ`` to the valid parameter domain `(0,1)` for more efficient sampling, and
#
# 2. calculate the derivatives for this transformed mapping.
#
# The helper packages `TransformVariables` and `LogDensityProblems` take care of
# this. We use a flat prior (the default, omitted)


trans = as((α = as𝕀,))
P = TransformedLogDensity(trans, p)
∇P = ADgradient(:ForwardDiff, P);

display(trans)
display(P)
display(∇P)
```

```julia
# Finally, we sample from the posterior. `chain` holds the chain (positions and
# diagnostic information), while the second returned value is the tuned sampler
# which would allow continuation of sampling.

L = 1000

#chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, L)
@time results = mcmc_with_warmup(Random.GLOBAL_RNG, ∇P, L; reporter = NoProgressReport());

display(results.chain)
```

```julia
# To get the posterior for ``α``, we need to use `get_position` and
# then transform

#posterior = transform.(Ref(t), get_position.(chain));
posterior = transform.(trans, results.chain)
```

```julia
# Extract the parameter.

posterior_α = first.(posterior)
```

```julia
# check the mean

mean(posterior_α)
```

```julia
# check the effective sample size

ess_α = effective_sample_size(posterior_α)
```

```julia
# NUTS-specific statistics

#NUTS_statistics(chain)
summarize_tree_statistics(results.tree_statistics)
```

```julia
P1 = plot(posterior_α)
P2 = histogram(posterior_α)
plot(P1, P2, size=(800, 250), title="alpha", legend=false)
```

## Logistic regression

https://github.com/tpapp/DynamicHMCExamples.jl/blob/master/src/example_logistic_regression.jl

```julia
# # Logistic regression

#using TransformVariables, LogDensityProblems, DynamicHMC, MCMCDiagnostics, Parameters,
#    Distributions, Statistics, StatsFuns, ForwardDiff

"""
Logistic regression.
For each draw, ``logit(Pr(yᵢ == 1)) ∼ Xᵢ β``. Uses a `β ∼ Normal(0, σ)` prior.
`X` is supposed to include the `1`s for the intercept.
"""
struct LogisticRegression{Ty, TX, Tσ}
    y::Ty
    X::TX
    σ::Tσ
end

function (problem::LogisticRegression)(θ)
    @unpack y, X, σ = problem
    @unpack β = θ
    loglik = sum(logpdf.(Bernoulli.(logistic.(X*β)), y))
    logpri = sum(logpdf.(Ref(Normal(0, σ)), β))
    loglik + logpri
end

# Make up parameters, generate data using random draws.

N = 1000
β = [1.0, 2.0]
X = hcat(ones(N), randn(N))
y = rand.(Bernoulli.(logistic.(X*β)));
```

```julia
# Create a problem, apply a transformation, then use automatic differentiation.

p = LogisticRegression(y, X, 10.0)   # data and (vague) priors
```

```julia
trans = as((β = as(Array, length(β)), )) # identity transformation, just to get the dimension
P = TransformedLogDensity(trans, p)      # transformed
∇P = ADgradient(:ForwardDiff, P)

display(trans)
display(P)
display(∇P)
```

```julia
# Sample using NUTS, random starting point.

#chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, 1000);

L = 10^3
@time results = mcmc_with_warmup(Random.GLOBAL_RNG, ∇P, L; reporter = NoProgressReport());
display(results.chain)
```

```julia
# Extract the posterior. Here the transformation was not really necessary.

posterior = transform.(trans, results.chain)
```

```julia
β_posterior = first.(posterior)
```

```julia
# Check that we recover the parameters.

mean(β_posterior)
```

```julia
# Quantiles

qs = [0.05, 0.25, 0.5, 0.75, 0.95]
quantile(first.(β_posterior), qs)
```

```julia
quantile(last.(β_posterior), qs)
```

```julia
# Check that mixing is good.

ess = vec(mapslices(effective_sample_size, reduce(hcat, β_posterior); dims = 2))
```

```julia
P1 = plot(first.(β_posterior))
P2 = histogram(first.(β_posterior))
plot(P1, P2, size=(800, 250), title="beta1", legend=false)
```

```julia
P1 = plot(last.(β_posterior))
P2 = histogram(last.(β_posterior))
plot(P1, P2, size=(800, 250), title="beta2", legend=false)
```

## Linear regression

https://github.com/tpapp/DynamicHMCExamples.jl/blob/master/src/example_linear_regression.jl

```julia
Random.seed!(4649);
```

```julia
# # Linear regression

# We estimate simple linear regression model with a half-T prior.
# First, we load the packages we use.

# using TransformVariables, LogDensityProblems, DynamicHMC, MCMCDiagnostics,
#     Parameters, Statistics, Distributions, ForwardDiff

# Then define a structure to hold the data: observables, covariates, and the degrees of freedom for the prior.

"""
Linear regression model ``y ∼ Xβ + ϵ``, where ``ϵ ∼ N(0, σ²)`` IID.
Flat prior for `β`, half-T for `σ`.
"""
struct LinearRegressionProblem{TY <: AbstractVector, TX <: AbstractMatrix,
                               Tν <: Real}
    "Observations."
    y::TY
    "Covariates"
    X::TX
    "Degrees of freedom for prior."
    ν::Tν
end

# Then make the type callable with the parameters *as a single argument*.

function (problem::LinearRegressionProblem)(θ)
    @unpack y, X, ν = problem   # extract the data
    @unpack β, σ = θ            # works on the named tuple too
    loglikelihood(Normal(0, σ), y .- X*β) + logpdf(TDist(ν), σ)
end

# We should test this, also, this would be a good place to benchmark and
# optimize more complicated problems.

#N = 100
N = 5
#X = hcat(ones(N), randn(N, 2));
x = rand(Uniform(-2, 2), N)
X = hcat(ones(N), x, x.^2);
β = [1.0, 2.0, -1.0]
#σ = 0.5
σ = 1.0
y = X*β .+ randn(N) .* σ;
p = LinearRegressionProblem(y, X, 1.0);
p((β = β, σ = σ))
```

```julia
law_true(β, x) = β[1] + β[2]*x + β[3]*x^2
```

```julia
# For this problem, we write a function to return the transformation (as it varies with the number of covariates).

problem_transformation(p::LinearRegressionProblem) =
    as((β = as(Array, size(p.X, 2)), σ = asℝ₊))

# Wrap the problem with a transformation, then use Flux for the gradient.

trans = problem_transformation(p)
P = TransformedLogDensity(trans, p)
∇P = ADgradient(:ForwardDiff, P);

display(trans)
display(P)
display(∇P)
```

```julia
# Finally, we sample from the posterior. `chain` holds the chain (positions and
# diagnostic information), while the second returned value is the tuned sampler
# which would allow continuation of sampling.

L = 2^11

#chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, 1000);
@time results = mcmc_with_warmup(Random.GLOBAL_RNG, ∇P, L; reporter = NoProgressReport());

display(results.chain)
```

```julia
# We use the transformation to obtain the posterior from the chain.

#posterior = transform.(Ref(t), get_position.(chain));
posterior = transform.(trans, results.chain)
```

```julia
# Extract the parameter posterior means: `β`,

posterior_β = first.(posterior)
@show mean_posterior_β = mean(posterior_β)

# then `σ`:

posterior_σ = last.(posterior)
@show mean_posterior_σ = mean(posterior_σ)

display(posterior_β)
display(posterior_σ)
```

```julia
# Effective sample sizes (of untransformed draws)

ess = mapslices(effective_sample_size, hcat(results.chain...); dims = 2)
```

```julia
# NUTS-specific statistics

#NUTS_statistics(chain)
summarize_tree_statistics(results.tree_statistics)
```

```julia
scatter(X[:,2], y, label="sample", legend=:bottomright)
plot!(x -> law_true(β, x), label="true law", ls=:dash)
```

```julia
P1 = plot((x->x[1]).(posterior_β))
P2 = histogram((x->x[1]).(posterior_β))
plot(P1, P2, size=(800, 250), title="beta1", legend=false)
```

```julia
P1 = plot((x->x[2]).(posterior_β))
P2 = histogram((x->x[2]).(posterior_β))
plot(P1, P2, size=(800, 250), title="beta2", legend=false)
```

```julia
P1 = plot((x->x[3]).(posterior_β))
P2 = histogram((x->x[3]).(posterior_β))
plot(P1, P2, size=(800, 250), title="beta3", legend=false)
```

```julia
P1 = plot(posterior_σ)
P2 = histogram(posterior_σ)
plot(P1, P2, size=(800, 250), title="sigma", legend=false)
```

```julia
function pred_linreg(posterior, x, y)
    L = length(posterior)
    β = first.(posterior)
    σ = last.(posterior)
    mean(pdf(Normal(0.0, σ[i]), y - (β[i][1] + β[i][2]*x + β[i][3]*x^2)) for i in 1:L)
end
```

```julia
@show a = (X'X)\X'*y
@show s = fit_mle(Normal, y - X*a).σ
pred_linreg_mle(a, s, x, y) = pdf(Normal(0.0, s), y - (a[1] + a[2]*x + a[3]*x^2))
```

```julia
xs = range(-4, 4, length=100)
ys = range(-23, 7, length=100)

@time zs = [pred_linreg(posterior, x, y) for y in ys, x in xs]
P1 = plot(; size=(400, 300))
heatmap!(xs, ys, zs, colorbar=false)
scatter!(X[:,2], y, label="sample", legend=false, markersize=4, color=:cyan, alpha=0.7)
plot!(xs, [law_true(β, x) for x in xs], ls=:dash, lw=2)
title!("Bayes")

@time zs = [pred_linreg_mle(a, s, x, y) for y in ys, x in xs]
P2 = plot(; size=(400, 300))
heatmap!(xs, ys, zs, colorbar=false)
scatter!(X[:,2], y, label="sample", legend=false, markersize=4, color=:cyan, alpha=0.7)
plot!(xs, [law_true(β, x) for x in xs], ls=:dash, lw=2)
title!("MLE")

plot(P1, P2, size=(800, 300))
```

```julia
2N*mean(-log(pred_linreg(posterior, X[i,2], y[i])) for i in 1:N) 
```

```julia
2N*mean(-log(pred_linreg_mle(a, s, X[i,2], y[i])) for i in 1:N) 
```

```julia

```
