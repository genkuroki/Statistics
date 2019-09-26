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

# 尤度函数のプロット

黒木玄

2019-09-17

<!-- #region {"toc": true} -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#n-=-16,-64,-...,-16384" data-toc-modified-id="n-=-16,-64,-...,-16384-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>n = 16, 64, ..., 16384</a></span><ul class="toc-item"><li><span><a href="#(0.5,-0.1)-near-singular" data-toc-modified-id="(0.5,-0.1)-near-singular-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>(0.5, 0.1) near singular</a></span></li><li><span><a href="#(0.5,-0.5)-regular" data-toc-modified-id="(0.5,-0.5)-regular-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>(0.5, 0.5) regular</a></span></li><li><span><a href="#(0.5,-0.0)-singular" data-toc-modified-id="(0.5,-0.0)-singular-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>(0.5, 0.0) singular</a></span></li><li><span><a href="#(0.5,-4.0)--very-regular" data-toc-modified-id="(0.5,-4.0)--very-regular-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>(0.5, 4.0)  very regular</a></span></li></ul></li><li><span><a href="#n-=-256" data-toc-modified-id="n-=-256-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>n = 256</a></span></li></ul></div>
<!-- #endregion -->

```julia
using Distributions
using Plots
gr(size=(400, 250), titlefontsize=10, fmt=:png)
using Random
```

```julia
p(x, a, b) = exp(logp(x, a, b))
logp(x, a, b) = -x^2/2 - log(√(2π)) + log((1-a) + a*exp(b*x - b^2/2))
loglik(X, a, b) = sum(logp(x, a, b) for x in X)
mixnormal(a, b) = MixtureModel([Normal(), Normal(b, 1.0)], [1-a, a])

function plot_lik(a₀, b₀, n; seed=4649, alim=(0, 1), blim=(-1, 2), kwargs...)
    Random.seed!(seed)
    dist_true = mixnormal(a₀, b₀)
    X = rand(dist_true, n)
    L(a, b) = loglik(X, a, b)
    a = range(alim..., length=100)
    b = range(blim..., length=200)
    @time z = L.(a, b')
    zmax = maximum(z)
    idx = findmax(z)[2]
    w = @. exp(z - zmax) # is very important!
    plot!(; title="\$n = $n,\\quad (a_0, b_0) = ($(a₀), $(b₀))\$")
    plot!(; xlabel="\$b\$", ylabel="\$a\$")
    heatmap!(b, a, w; colorbar=false)
    scatter!([b₀], [a₀]; markersize=4, markerstrokewidth=0, color=:cyan, label="true")
    scatter!([b[idx[2]]], [a[idx[1]]]; markersize=5, markershape=:star, color=:lightgreen, label="MLE")
    plot!(; xlim=extrema(b), ylim=extrema(a))
    plot!(; kwargs...)
end
```

```julia
Random.seed!(4649)
histogram(rand(mixnormal(0.3, 5), 1000), bin=20, normed=true, legend=false, alpha=0.5)
plot!(x->p(x, 0.3, 5), lw=2, ls=:dash, size=(400, 250))
```

## n = 16, 64, ..., 16384


### (0.5, 0.1) near singular

```julia
a₀, b₀ = 0.5, 0.1
```

```julia
plot_lik(a₀, b₀, 2^4)
```

```julia
plot_lik(a₀, b₀, 2^6)
```

```julia
plot_lik(a₀, b₀, 2^8)
```

```julia
plot_lik(a₀, b₀, 2^10)
```

```julia
plot_lik(a₀, b₀, 2^12)
```

```julia
plot_lik(a₀, b₀, 2^14)
```

### (0.5, 0.5) regular

```julia
a₁, b₁ = 0.5, 0.5
```

```julia
plot_lik(a₁, b₁, 2^4)
```

```julia
plot_lik(a₁, b₁, 2^6)
```

```julia
plot_lik(a₁, b₁, 2^8)
```

```julia
plot_lik(a₁, b₁, 2^10)
```

```julia
plot_lik(a₁, b₁, 2^12)
```

```julia
plot_lik(a₁, b₁, 2^14)
```

### (0.5, 0.0) singular

```julia
a₂, b₂ = 0.5, 0.0
```

```julia
plot_lik(a₂, b₂, 2^4; blim=(-1.5, 1.5))
```

```julia
plot_lik(a₂, b₂, 2^6; blim=(-1.5, 1.5))
```

```julia
plot_lik(a₂, b₂, 2^8; blim=(-1.5, 1.5))
```

```julia
plot_lik(a₂, b₂, 2^10; blim=(-1.5, 1.5))
```

```julia
plot_lik(a₂, b₂, 2^12; blim=(-1.5, 1.5))
```

```julia
plot_lik(a₂, b₂, 2^14; blim=(-1.5, 1.5))
```

### (0.5, 4.0)  very regular

```julia
a₃, b₃ = 0.5, 4.0
```

```julia
plot_lik(a₃, b₃, 2^4; alim=(0, 1), blim=(1.5, 4.5))
```

```julia
plot_lik(a₃, b₃, 2^6; alim=(0.3, 0.7), blim=(3.3, 4.7))
```

```julia
plot_lik(a₃, b₃, 2^8; alim=(0.3, 0.7), blim=(3.3, 4.7))
```

```julia
plot_lik(a₃, b₃, 2^10; alim=(0.3, 0.7), blim=(3.3, 4.7))
```

```julia
plot_lik(a₃, b₃, 2^12; alim=(0.3, 0.7), blim=(3.3, 4.7))
```

```julia
plot_lik(a₃, b₃, 2^14; alim=(0.3, 0.7), blim=(3.3, 4.7))
```

## n = 256

```julia
for i in 1:16
    plot_lik(a₀, b₀, 2^8; seed=rand(UInt)) |> display
end
```

```julia
for i in 1:16
    plot_lik(a₁, b₁, 2^8; seed=rand(UInt)) |> display
end
```

```julia
for i in 1:16
    plot_lik(a₂, b₂, 2^8; blim=(-2, 2), seed=rand(UInt)) |> display
end
```

```julia
for i in 1:16
    plot_lik(a₃, b₃, 2^8; alim=(0.3, 0.7), blim=(3.5, 4.5), seed=rand(UInt)) |> display
end
```

```julia

```
