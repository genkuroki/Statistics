# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:hydrogen
#     text_representation:
#       extension: .jl
#       format_name: hydrogen
#       format_version: '1.3'
#       jupytext_version: 1.10.3
#   kernelspec:
#     display_name: Julia 1.10.3
#     language: julia
#     name: julia-1.10
# ---

# %%
using Distributions
using StatsPlots
default(fmt=:png)

n, θ = 80, 0.3
L = 10^5
Z = zeros(L)
for i in 1:L
    K = rand(Binomial(n, θ))
    Z[i] = (K/n - θ) / √(θ*(1 - θ)/n)
end

Kbin = -0.5:n+0.5
bin = @. (Kbin/n - θ) / √(θ*(1 - θ)/n)
histogram(Z; norm=true, alpha=0.3, bin, label="(K/n - θ) / √(θ*(1 - θ)/n)")
plot!(Normal(0, 1); label="Normal(0, 1)", lw=2)
plot!(xguide="z", legendfontsize=12)
title!("n=$n,  θ=$θ,  K ~ Binomial(n, θ)")

# %%
using Distributions
using StatsPlots
default(fmt=:png)
r(x) = round(x; sigdigits=3)

θ = 0.5
n = 100
k = 59
@show a = (k/n - θ) / √(θ*(1 - θ)/n)
@show pval = 2ccdf(Normal(0, 1), abs(a))

plot(Normal(0, 1), -5, 5; label="Normal(0, 1)", c=1)
plot!(Normal(0, 1), -5, -abs(a); label="", c=1, fillrange=0, fc=:red, fa=0.3)
plot!(Normal(0, 1), abs(a), 5; label="", c=1, fillrange=0, fc=:red, fa=0.3)
vline!([abs(a), -abs(a)]; label="|z| = |a| = $(r(abs(a)))", c=:red, ls=:dot)
plot!(xguide="z", legendfontsize=12)
title!("k=$k,  n=$n,  θ=$θ,  pvalue=$(r(pval))")

# %%
using Distributions
using StatsPlots
default(fmt=:png)
r(x) = round(x; sigdigits=3)
safediv(x, y) = x == 0 ? zero(x/y) : x/y

function pvalue_wilson(k, n, θ)
    a = safediv(k/n - θ, √(θ*(1 - θ)/n))
    2ccdf(Normal(0, 1), abs(a))
end

n, k = 100, 60
plot(θ -> pvalue_wilson(k, n, θ), 0, 1; label="pvalue_wilson(k, n, θ)")
plot!(xguide="θ", yguide="P-value")
plot!(legend=:topleft, legendfontsize=12)
plot!(xtick=0:0.1:1, ytick=0:0.05:1)
title!("Wilson's P-value function for n=$n, k=$k")

# %%
using Distributions
using StatsPlots
default(fmt=:png)
r(x) = round(x; sigdigits=3)
safediv(x, y) = x == 0 ? zero(x/y) : x/y

function likelihood_wilson(k, n, θ)
    a = safediv(k/n - θ, √(θ*(1 - θ)/n))
    pdf(Normal(0, 1), a)
end

n, k = 100, 60
plot(θ -> likelihood_wilson(k, n, θ), 0, 1; label="likelihood_wilson(k, n, θ)")
plot!(xguide="θ", yguide="likelihood")
plot!(legend=:topleft, legendfontsize=12)
plot!(xtick=0:0.1:1, ytick=0:0.05:1)
title!("Wilson's likelihood function for n=$n, k=$k")

# %%
using Distributions
using StatsPlots
default(fmt=:png)
r(x) = round(x; sigdigits=3)
safediv(x, y) = x == 0 ? zero(x/y) : x/y

function pvalue_wilson(k, n, θ)
    a = safediv(k/n - θ, √(θ*(1 - θ)/n))
    2ccdf(Normal(0, 1), abs(a))
end

n, k = 10, 0
plot(θ -> pvalue_wilson(k, n, θ), 0, 1; label="pvalue_wilson(k, n, θ)")
plot!(xguide="θ", yguide="P-value")
plot!(legendfontsize=12)
plot!(xtick=0:0.1:1, ytick=0:0.05:1)
title!("Wilson's P-value function for n=$n, k=$k")

# %%
using Distributions
using StatsPlots
default(fmt=:png)
r(x) = round(x; sigdigits=3)
safediv(x, y) = x == 0 ? zero(x/y) : x/y

function likelihood_wilson(k, n, θ)
    a = safediv(k/n - θ, √(θ*(1 - θ)/n))
    pdf(Normal(0, 1), a)
end

n, k = 10, 0
plot(θ -> likelihood_wilson(k, n, θ), 0, 1; label="likelihood_wilson(k, n, θ)")
plot!(xguide="θ", yguide="likelihood")
plot!(legendfontsize=12)
plot!(xtick=0:0.1:1, ytick=0:0.05:1)
title!("Wilson's likelihood function for n=$n, k=$k")

# %%
using Distributions
using StatsPlots
default(fmt=:png)
r(x) = round(x; sigdigits=3)
safediv(x, y) = x == 0 ? zero(x/y) : x/y

function pvalue_wilson(k, n, θ)
    a = safediv(k/n - θ, √(θ*(1 - θ)/n))
    2ccdf(Normal(0, 1), abs(a))
end

n, k = 10, 1
plot(θ -> pvalue_wilson(k, n, θ), 0, 1; label="pvalue_wilson(k, n, θ)")
plot!(xguide="θ", yguide="P-value")
plot!(legendfontsize=12)
plot!(xtick=0:0.1:1, ytick=0:0.05:1)
title!("Wilson's P-value function for n=$n, k=$k")

# %%
using Distributions
using StatsPlots
default(fmt=:png)
r(x) = round(x; sigdigits=3)
safediv(x, y) = x == 0 ? zero(x/y) : x/y

function likelihood_wilson(k, n, θ)
    a = safediv(k/n - θ, √(θ*(1 - θ)/n))
    pdf(Normal(0, 1), a)
end

n, k = 10, 1
plot(θ -> likelihood_wilson(k, n, θ), 0, 1; label="likelihood_wilson(k, n, θ)")
plot!(xguide="θ", yguide="likelihood")
plot!(legendfontsize=12)
plot!(xtick=0:0.1:1, ytick=0:0.05:1)
title!("Wilson's likelihood function for n=$n, k=$k")

# %%
using Distributions
using StatsPlots
default(fmt=:png)
safediv(x, y) = x == 0 ? zero(x/y) : x/y

function pvalue_wilson(k, n, θ)
    a = safediv(k/n - θ, √(θ*(1 - θ)/n))
    2ccdf(Normal(0, 1), abs(a))
end

function confint_wilson(k, n, α)
    c = cquantile(Normal(0, 1), α/2) # c=quantile(Normal(0,1), 1-α/2)と同じ
    θ̂ = k/n # \theta TAB \hat TAB → θ̂
    A, B, C = 1 + c^2/n, θ̂ + c^2/(2n), θ̂^2
    D = B^2 - A*C
    [(B - √D)/A, (B + √D)/A]
end

n, k, α = 100, 60, 0.05
@show ci = confint_wilson(k, n, α)
plot(θ -> pvalue_wilson(k, n, θ), 0, 1; label="pvalue_wilson(k, n, θ)")
plot!(ci, fill(α, 2); label="confint_wilson(k, n, α)", lw=3)
plot!(xguide="θ", yguide="P-value")
plot!(legend=:topleft, legendfontsize=12)
plot!(xtick=0:0.1:1, ytick=0:0.05:1)
title!("n=$n, k=$k, α=$α")

# %%
