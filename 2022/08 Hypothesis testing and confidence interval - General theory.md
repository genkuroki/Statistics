---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.10.3
  kernelspec:
    display_name: Julia 1.7.3
    language: julia
    name: julia-1.7
---

# 検定と信頼区間: 一般論

* 黒木玄
* 2022-05-31～2022-05-31

$
\newcommand\op{\operatorname}
\newcommand\R{{\mathbb R}}
\newcommand\Z{{\mathbb Z}}
\newcommand\var{\op{var}}
\newcommand\std{\op{std}}
\newcommand\eps{\varepsilon}
\newcommand\T[1]{T_{(#1)}}
\newcommand\bk{\bar\kappa}
\newcommand\X{{\mathscr X}}
$

このノートでは[Julia言語](https://julialang.org/)を使用している: 

* [Julia言語のインストールの仕方の一例](https://nbviewer.org/github/genkuroki/msfd28/blob/master/install.ipynb)

自明な誤りを見つけたら, 自分で訂正して読んで欲しい.  大文字と小文字の混同や書き直しが不完全な場合や符号のミスは非常によくある.

このノートに書いてある式を文字通りにそのまま読んで正しいと思ってしまうとひどい目に会う可能性が高い. しかし, 数が使われている文献には大抵の場合に文字通りに読むと間違っている式や主張が書いてあるので, 内容を理解した上で訂正しながら読んで利用しなければいけない. 実践的に数学を使う状況では他人が書いた式をそのまま信じていけない.

このノートの内容よりもさらに詳しいノートを自分で作ると勉強になるだろう.  膨大な時間を取られることになるが, このノートの内容に関係することで飯を食っていく可能性がある人にはそのためにかけた時間は無駄にならないと思われる.

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#P値と検定と信頼区間の関係" data-toc-modified-id="P値と検定と信頼区間の関係-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>P値と検定と信頼区間の関係</a></span><ul class="toc-item"><li><span><a href="#P値およびP値函数の定義" data-toc-modified-id="P値およびP値函数の定義-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>P値およびP値函数の定義</a></span></li><li><span><a href="#P値を使った検定" data-toc-modified-id="P値を使った検定-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>P値を使った検定</a></span></li><li><span><a href="#P値函数を使った信頼区間" data-toc-modified-id="P値函数を使った信頼区間-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>P値函数を使った信頼区間</a></span></li><li><span><a href="#P値函数が「よい」かどうかの判断基準達" data-toc-modified-id="P値函数が「よい」かどうかの判断基準達-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>P値函数が「よい」かどうかの判断基準達</a></span></li><li><span><a href="#信頼区間と検定の表裏一体性" data-toc-modified-id="信頼区間と検定の表裏一体性-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span>信頼区間と検定の表裏一体性</a></span></li></ul></li><li><span><a href="#二項分布モデルの場合" data-toc-modified-id="二項分布モデルの場合-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>二項分布モデルの場合</a></span><ul class="toc-item"><li><span><a href="#Clopper-Pearsonの信頼区間" data-toc-modified-id="Clopper-Pearsonの信頼区間-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>Clopper-Pearsonの信頼区間</a></span></li><li><span><a href="#Waldの信頼区間" data-toc-modified-id="Waldの信頼区間-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>Waldの信頼区間</a></span></li><li><span><a href="#Wilsonの信頼区間" data-toc-modified-id="Wilsonの信頼区間-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>Wilsonの信頼区間</a></span></li><li><span><a href="#Sterneの信頼区間" data-toc-modified-id="Sterneの信頼区間-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>Sterneの信頼区間</a></span></li></ul></li><li><span><a href="#よくある誤解" data-toc-modified-id="よくある誤解-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>よくある誤解</a></span></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using BenchmarkTools
using Distributions
using LinearAlgebra
using Printf
using QuadGK
using Random
Random.seed!(4649373)
using Roots
using SpecialFunctions
using StaticArrays
using StatsBase
using StatsFuns
using StatsPlots
default(fmt = :png, titlefontsize = 10, size = (400, 250))
using SymPy
```

```julia
# Override the Base.show definition of SymPy.jl:
# https://github.com/JuliaPy/SymPy.jl/blob/29c5bfd1d10ac53014fa7fef468bc8deccadc2fc/src/types.jl#L87-L105

@eval SymPy function Base.show(io::IO, ::MIME"text/latex", x::SymbolicObject)
    print(io, as_markdown("\\displaystyle " * sympy.latex(x, mode="plain", fold_short_frac=false)))
end
@eval SymPy function Base.show(io::IO, ::MIME"text/latex", x::AbstractArray{Sym})
    function toeqnarray(x::Vector{Sym})
        a = join(["\\displaystyle " * sympy.latex(x[i]) for i in 1:length(x)], "\\\\")
        """\\left[ \\begin{array}{r}$a\\end{array} \\right]"""
    end
    function toeqnarray(x::AbstractArray{Sym,2})
        sz = size(x)
        a = join([join("\\displaystyle " .* map(sympy.latex, x[i,:]), "&") for i in 1:sz[1]], "\\\\")
        "\\left[ \\begin{array}{" * repeat("r",sz[2]) * "}" * a * "\\end{array}\\right]"
    end
    print(io, as_markdown(toeqnarray(x)))
end
```

```julia
safemul(x, y) = x == 0 ? x : x*y
safediv(x, y) = x == 0 ? x : x/y

x ⪅ y = x < y || x ≈ y

mypdf(dist, x) = pdf(dist, x)
mypdf(dist::DiscreteUnivariateDistribution, x) = pdf(dist, round(Int, x))

distname(dist::Distribution) = replace(string(dist), r"{.*}" => "")
myskewness(dist) = skewness(dist)
mykurtosis(dist) = kurtosis(dist)
function standardized_moment(dist::ContinuousUnivariateDistribution, m)
    μ, σ = mean(dist), std(dist)
    quadgk(x -> (x - μ)^m * pdf(dist, x), extrema(dist)...)[1] / σ^m
end
myskewness(dist::MixtureModel{Univariate, Continuous}) = standardized_moment(dist, 3)
mykurtosis(dist::MixtureModel{Univariate, Continuous}) = standardized_moment(dist, 4) - 3
```

## P値と検定と信頼区間の関係


### P値およびP値函数の定義


### P値を使った検定


### P値函数を使った信頼区間


### P値函数が「よい」かどうかの判断基準達


### 信頼区間と検定の表裏一体性


## 二項分布モデルの場合


### Clopper-Pearsonの信頼区間

データ「$n$ 回中 $k$ 回成功」について, 「データの数値以上に極端な」の意味を「$k$ 以上または $k$ 以下の」とした場合.


### Waldの信頼区間

データ「$n$ 回中 $k$ 回成功」について, 「データの数値以上に極端な」の意味を「$k$ 以上または $k$ 以下の」とした場合.  ただし, 二項分布の中心極限定理(正規分布近似)と分散が少しことなる正規分布による近似を使う.


### Wilsonの信頼区間

データ「$n$ 回中 $k$ 回成功」について, 「データの数値以上に極端な」の意味を「$k$ 以上または $k$ 以下の」とした場合.  ただし, 二項分布の中心極限定理(正規分布近似)のみを使う.


### Sterneの信頼区間

「データの数値以上に極端な」の意味を「生成される確率がデータの数値以下の」とした場合.


## よくある誤解


$\sqrt{x}/\sqrt{2}$

```julia

```
