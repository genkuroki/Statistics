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
    display_name: Julia current stable release
    language: julia
    name: julia
---

# ColabでJuliaを使うためのノートブック

このノートブックの内容については再配布・改変・部分的コピーその他すべてを自由に行って構いません.
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

このノートブックは[Google Colabで実行できる](https://colab.research.google.com/github/genkuroki/Statistics/blob/master/2022/07-4%20Julia%20notebook%20for%20Google%20Colab.ipynb).


__注意:__ 以下のセルを `using` の行のコメントアウトを全部外してからGoogle Colabで実行すると5分から6分程度かかるようである.  その待ち時間に耐え切れないと感じる人は自分のパソコン上にJuliaをJupyter上で実行する環境を作ればよい.  コンピュータの取り扱いの初心者のうちはその作業は非常に難しいと感じるかもしれないが, 適当に検索したり, AIに質問したりすればできるはずである.

```julia jupyter={"outputs_hidden": true} tags=[]
# Google Colabと自分のパソコンの両方で使えるようにするための工夫

import Pkg

"""すでにPkg.add済みのパッケージのリスト (高速化のために用意)"""
_packages_added = [info.name for (uuid, info) in Pkg.dependencies() if info.is_direct_dep]

"""_packages_added内にないパッケージをPkg.addする"""
add_pkg_if_not_added_yet(pkg) = if !(pkg in _packages_added)
    println(stderr, "# $(pkg).jl is not added yet, so let's add it.")
    Pkg.add(pkg)
end

"""expr::Exprからusing内の`.`を含まないモジュール名を抽出"""
function find_using_pkgs(expr::Expr)
    pkgs = String[]
    function traverse(expr::Expr)
        if expr.head == :using
            for arg in expr.args
                if arg.head == :. && length(arg.args) == 1
                    push!(pkgs, string(arg.args[1]))
                elseif arg.head == :(:) && length(arg.args[1].args) == 1
                    push!(pkgs, string(arg.args[1].args[1]))
                end
            end
        else
            for arg in expr.args arg isa Expr && traverse(arg) end
        end
    end
    traverse(expr)
    pkgs
end

"""必要そうなPkg.addを追加するマクロ"""
macro autoadd(expr)
    pkgs = find_using_pkgs(expr)
    :(add_pkg_if_not_added_yet.($(pkgs)); $expr)
end

# 以下は黒木玄がよく使っているパッケージ達
# 例えばQuadGKパッケージ(数値積分のパッケージ)の使い方は
# QuadGK.jl をインターネットで検索すれば得られる.

ENV["LINES"], ENV["COLUMNS"] = 100, 100
using LinearAlgebra
using Printf
using Random
Random.seed!(4649373)

@autoadd begin
using Distributions
using StatsPlots
default(fmt=:png, legendfontsize=12)
#using BenchmarkTools
#using Optim
#using QuadGK
#using RDatasets
#using Roots
#using StatsBase
#using StatsFuns
#using SpecialFunctions
#using SymPy
end
```

[Julia言語](https://julialang.org/)については以下の検索で色々学べる.

* Julia言語のドキュメント: https://docs.julialang.org/en/v1/
* Julia言語について検索: https://www.google.com/search?q=Julia%E8%A8%80%E8%AA%9E
* Distributions.jlパッケージについて検索: https://www.google.com/search?q=Distributions.jl
* Plots.jlパッケージについて検索: https://www.google.com/search?q=Plots.jl
* StatsPlots.jlパッケージについて検索: https://www.google.com/search?q=StatsPlots.jl
* BenchmarkTools.jlパッケージについて検索: https://www.google.com/search?q=BenchmarkTools.jl
* Optim.jlパッケージについて検索: https://www.google.com/search?q=Optim.jl
* QuadGK.jlパッケージについて検索: https://www.google.com/search?q=QuadGK.jl
* RDatasets.jlパッケージについて検索: https://www.google.com/search?q=RDatasets.jl
* Roots.jlパッケージについて検索: https://www.google.com/search?q=Roots.jl
* StatsBase.jlパッケージについて検索: https://www.google.com/search?q=StatsBase.jl
* StatsFuns.jlパッケージについて検索: https://www.google.com/search?q=StatsFuns.jl
* SpecialFunctions.jlパッケージについて検索: https://www.google.com/search?q=SpecialFunctions.jl
* SymPy.jlパッケージについて検索: https://www.google.com/search?q=SymPy.jl

<!-- #region -->
## @autoadd マクロの使い方

例えば, パッケージA.jlやB.jlをインストール前(Pkg.add前)であるとき, 

```julia
using A
using B: b1, b2
```

を実行しようとするとエラーになってしまう. しかし,

```julia
@autoadd using A
@autoadd using B: b1, b2

```

または

```julia
@autoadd begin
using A
using B: b1, b2
end
```

を実行すれば, 自動的にパッケージA.jlやB.jlがインストールされてから, using達が実行される.

以下のように `@macroexpand` を使えば具体的に何が実行されるかを確認できる.
<!-- #endregion -->

```julia
(@macroexpand @autoadd using A) |> Base.remove_linenums!
```

```julia
(@macroexpand @autoadd using A, B, C) |> Base.remove_linenums!
```

```julia
(@macroexpand @autoadd using A: a1, a2, @a3) |> Base.remove_linenums!
```

```julia
(@macroexpand @autoadd begin
using A: a1
using A.B
using A.C: c1, c2
#using D
using E, A.F, G
using H: h1, h2
using I
end) |> Base.remove_linenums!
```

## ランダムウォーク

期待値が $\mu$ で標準偏差が $\sigma$ の確率分布の独立同分布確率変数列 $X_1,X_2,X_3,\ldots$について,

$$
W_n = (X_1-\mu)+(X_2-\mu)+\cdots+(X_n-\mu), \quad n=1,2,3,\ldots
$$

の様子がどうなるかを見てみよう.

```julia
dist = Gamma(2, 3)
@show mu, sigma = mean(dist), std(dist)
plot(dist; label="dist")
```

```julia
X_minus_mu = rand(dist - mu, 10) # X_1 - mu, X_2 - mu, ..., X_10 - mu を生成
```

```julia
cumsum(X_minus_mu) # W_1, W_2, ..., W_10 を作成
```

```julia
?cumsum
```

```julia
nmax = 2^10 # maximum sample size
niters = 200 # number of iterations
Ws = [cumsum(rand(dist - mu, nmax)) for _ in 1:niters] # [W_1, W_2, ..., W_nmax] をniters個生成

plot()
for W in Ws
    plot!([0; W]; label="", lw=0.3, alpha=0.5)
end
plot!(n -> +2sqrt(n)*sigma, 0, nmax; label="±2√n σ", c=:red)
plot!(n -> -2sqrt(n)*sigma, 0, nmax; label="", c=:red)
```

期待値が $0$ のギャンブルを $n$ 回繰り返すと, __トータルでの勝ち負けの金額__はおおよそ $\pm 2\sqrt{n}\;\sigma$ の範囲におさまる(ランダムウォークの偏差).


## 大数の法則

期待値が $0$ で標準偏差が $\sigma$ の確率分布の独立同分布確率変数列$X_1,X_2,X_3,\ldots$について, サイズ $n$ の標本平均

$$
\bar{X}_n = \frac{X_1+X_2+\cdots+X_n}{n}
$$

の様子がどうなるかを見てみよう.

```julia
dist = Gamma(2, 3)
@show mu, sigma = mean(dist), std(dist)
plot(dist; label="dist")
```

```julia
X = rand(dist, 10) # X_1, X_2, ..., X_10 を生成
```

```julia
Xbar = cumsum(X) ./ (1:10) # Xbar_1, Xbar_2, ..., Xbar_10 を作成
```

```julia
nmax = 1000 # maximum sample size
niters = 100 # number of iterations
Xbars = [cumsum(rand(dist, nmax)) ./ (1:nmax) for _ in 1:niters] # [Xbar_1, ..., Xbar_nmax] をniters個生成

plot()
for Xbar in Xbars
    plot!([0; Xbar]; label="", lw=0.3, alpha=0.5)
end
plot!(x -> mu, 0, nmax; label="µ", c=:red)
plot!(ylim=(mu-sigma, mu+sigma))
```

期待値が $0$ のギャンブルを $n$ 回繰り返すと, 1回ごとの勝ち負けの平均値は $\mu$ に近付く(大数の法則).

ランダムウォーク(トータルでの勝ち負けの金額の話)と大数の法則(トータルの勝ち負けの金額を繰り返した回数の $n$ で割って得られる1回ごとの平均値の話)を混同するとひどい目にあうだろう!


## 中心極限定理の素朴な確認の仕方

期待値が $\mu$ で標準偏差が $\sigma$ の確率分布の独立同分布確率変数列$X_1,X_2,X_3,\ldots$について, 標本平均 $\bar{X}_n = (X_1+\cdots+X_n)/n$ が従う分布は $n$ が大きなとき, 期待値 $\mu$ と標準偏差 $\sigma/\sqrt{n}$ を持つ正規分布で近似される. すなわち,

$$
Y_n = \sqrt{n}\;(\bar{X} - \mu)
= \frac{(X_1-\mu)+\cdots+(X_n-\mu)}{\sqrt{n}}
$$

が従う分布は, $n$が大きいとき, 期待値 $0$ と標準偏差 $\sigma$ を持つ正規分布で近似され, 

$$
Z_n = \frac{\sqrt{n}\;(\bar{X} - \mu)}{\sigma} 
= \frac{(X_1-\mu)+\cdots+(X_n-\mu)}{\sqrt{n}\;\sigma}
$$

が従う分布は, $n$が大きいとき, 標準正規分布で近似される.

```julia
dist = Gamma(2, 3)
@show mu, sigma = mean(dist), std(dist)
plot(dist; label="dist")
```

```julia
n = 2^5 # sample size
niters = 10^6 # number of iterations
Xbars = [mean(rand(dist, n)) for _ in 1:niters] # niters個の標本平均を計算

stephist(Xbars; norm=true, label="size-$n sample means")
plot!(Normal(mu, sigma/sqrt(n)); label="normal approximation")
```

```julia
n = 2^5 # sample size
Yns = [sqrt(n) * (Xbar - mu) for Xbar in Xbars] # Z_nを繰り返し計算

stephist(Yns; norm=true, label="distribution of Y_$n")
plot!(Normal(0, sigma); label="normal approximation")
```

```julia
n = 2^5 # sample size
Zns = [sqrt(n) * (Xbar - mu) / sigma for Xbar in Xbars] # Z_nを繰り返し計算

stephist(Zns; norm=true, label="distribution of Z_$n")
plot!(Normal(); label="standard normal dist")
plot!(xtick=-10:10)
```

## 以下は自由に使って下さい

```julia

```

```julia

```

```julia

```

```julia

```

```julia

```
