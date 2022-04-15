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
    display_name: Julia 1.7.2
    language: julia
    name: julia-1.7
---

# 中心極限定理などについて

* 黒木玄
* 2022-04-11～2022-04-12
$
\newcommand\op{\operatorname}
\newcommand\R{{\mathbb R}}
\newcommand\Z{{\mathbb Z}}
\newcommand\var{\op{var}}
\newcommand\std{\op{std}}
\newcommand\eps{\varepsilon}
$

このノートでは[Julia言語](https://julialang.org/)を使用している: 

* [Julia言語のインストールの仕方の一例](https://nbviewer.org/github/genkuroki/msfd28/blob/master/install.ipynb)

自明な誤りを見つけたら, 自分で訂正して読んで欲しい.  大文字と小文字の混同や書き直しが不完全な場合や符号のミスは非常によくある.

このノートの内容よりもさらに詳しいノートを自分で作ると勉強になるだろう.  膨大な時間を取られることになるが, このノートの内容に関係することで飯を食っていく可能性がある人にはそのためにかけた時間は無駄にならないと思われる.

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#大数の法則" data-toc-modified-id="大数の法則-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>大数の法則</a></span></li><li><span><a href="#中心極限定理" data-toc-modified-id="中心極限定理-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>中心極限定理</a></span><ul class="toc-item"><li><span><a href="#中心極限定理のラフな説明" data-toc-modified-id="中心極限定理のラフな説明-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>中心極限定理のラフな説明</a></span></li><li><span><a href="#中心極限定理の特性函数を使った証明" data-toc-modified-id="中心極限定理の特性函数を使った証明-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>中心極限定理の特性函数を使った証明</a></span></li><li><span><a href="#中心極限定理の収束の速さと歪度" data-toc-modified-id="中心極限定理の収束の速さと歪度-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>中心極限定理の収束の速さと歪度</a></span></li><li><span><a href="#中心極限定理のキュムラント母函数を使った証明" data-toc-modified-id="中心極限定理のキュムラント母函数を使った証明-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>中心極限定理のキュムラント母函数を使った証明</a></span></li><li><span><a href="#中心極限定理の収束の速さと歪度と尖度" data-toc-modified-id="中心極限定理の収束の速さと歪度と尖度-2.5"><span class="toc-item-num">2.5&nbsp;&nbsp;</span>中心極限定理の収束の速さと歪度と尖度</a></span></li><li><span><a href="#中心極限定理のTaylorの定理のみを使う証明" data-toc-modified-id="中心極限定理のTaylorの定理のみを使う証明-2.6"><span class="toc-item-num">2.6&nbsp;&nbsp;</span>中心極限定理のTaylorの定理のみを使う証明</a></span></li><li><span><a href="#中心極限定理の収束の速さと歪度と尖度(再)" data-toc-modified-id="中心極限定理の収束の速さと歪度と尖度(再)-2.7"><span class="toc-item-num">2.7&nbsp;&nbsp;</span>中心極限定理の収束の速さと歪度と尖度(再)</a></span></li><li><span><a href="#問題:-中心極限定理の収束の様子のグラフ" data-toc-modified-id="問題:-中心極限定理の収束の様子のグラフ-2.8"><span class="toc-item-num">2.8&nbsp;&nbsp;</span>問題: 中心極限定理の収束の様子のグラフ</a></span></li><li><span><a href="#問題:-デルタ法-(実は単なる一次近似)" data-toc-modified-id="問題:-デルタ法-(実は単なる一次近似)-2.9"><span class="toc-item-num">2.9&nbsp;&nbsp;</span>問題: デルタ法 (実は単なる一次近似)</a></span></li><li><span><a href="#標本平均と不偏分散の定義" data-toc-modified-id="標本平均と不偏分散の定義-2.10"><span class="toc-item-num">2.10&nbsp;&nbsp;</span>標本平均と不偏分散の定義</a></span></li><li><span><a href="#問題:-標本平均の期待値と分散" data-toc-modified-id="問題:-標本平均の期待値と分散-2.11"><span class="toc-item-num">2.11&nbsp;&nbsp;</span>問題: 標本平均の期待値と分散</a></span></li><li><span><a href="#問題:-不偏分散の期待値と分散" data-toc-modified-id="問題:-不偏分散の期待値と分散-2.12"><span class="toc-item-num">2.12&nbsp;&nbsp;</span>問題: 不偏分散の期待値と分散</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using BenchmarkTools
using Distributions
using Printf
using QuadGK
using Random
Random.seed!(4649373)
using Roots
using SpecialFunctions
using StatsBase
using StatsFuns
using StatsPlots
default(fmt = :png, titlefontsize = 10, size = (400, 250))
using SymPy
```

## 大数の法則


## 中心極限定理


### 中心極限定理のラフな説明

$X_1,\ldots,X_n$ は各々が期待値 $\mu$, 分散 $\sigma^2$ を持つ分布に従う $n$ 個の独立同分布確率変数達であるとし, $n$ は十分に大きいと仮定する. 

中心極限定理は以下のように同値な言い方が色々ある:

(1) それらの和 $X_1+\cdots+X_n$ が従う分布は期待値 $n\mu$, 分散 $n\sigma^2$ の正規分布で近似される:

$$
\sum_{i=1}^n X_i
\sim \op{Normal}(n\mu, \sqrt{n}\,\sigma)\quad\text{approximately}.
$$

(2) それらの加法平均 $\bar{X}_n = (X_1+\cdots+X_n)/n$ が従う分布は期待値 $\mu$, 分散 $\sigma^2/n$ の正規分布で近似される:

$$
\bar{X}_n = \frac{1}{n}\sum_{i=1}^n X_i
\sim \op{Normal}(\mu, \sigma/\sqrt{n})\quad\text{approximately}.
$$

(3) $\sqrt{n}\,(\bar{X}_n - \mu)$ が従う分布は期待値 $0$, 分散 $\sigma^2$ の正規分布で近似される:

$$
\sqrt{n}\,(\bar{X}_n - \mu) =
\frac{1}{\sqrt{n}}\sum_{i=1}^n (X_i - \mu)
\sim \op{Normal}(0, \sigma)\quad\text{approximately}.
$$

(4) 次の $Z_n$ が従う分布は標準正規分布で近似される:

$$
Z_n = \frac{\sqrt{n}\,(\bar{X}_n - \mu)}{\sigma} =
\frac{1}{\sqrt{n}\,\sigma}\sum_{i=1}^n (X_i - \mu)
\sim \op{Normal}(0, 1)\quad\text{approximately}.
$$


### 中心極限定理の特性函数を使った証明

__中心極限定理:__ $X_1, X_2, X_3, \ldots$ が独立同分布な確率変数の列であるとき, $\mu=E[X_k]$ が定義されていて, $\sigma^2 = \var(X_k) = E[(X_k - \mu)^2] < \infty$ でかつ, $E[|X_k - \mu|^3] < \infty$ となっていると仮定する. このとき,

$$
\bar{X}_n = \frac{1}{n}\sum_{k=1}^n X_k, \quad
Z_n = \frac{\sqrt{n}\,(\bar{X}_n - \mu)}{\sigma}
$$

とおくと, $n\to\infty$ で $Z_n$ の分布は標準正規分布に近付く.

__証明:__ $X_k$ の標準化を $Y_k = (X_k - \mu)/\sigma$ と書くことにする. $Y_1, Y_2, \ldots$ も独立同分布になり, $E[Y_k] = 0, \quad E[Y_k^2] = 1$ が成立している.  ゆえに $Y_k$ の特性函数 $\varphi(t)$ は $k$ によらず,

$$
\varphi(t) =
E[e^{itY_k}] =
1 + iE[Y_k]t - E[Y_k^2]\frac{t^2}{2} + O(t^3) =
1 - \frac{t^2}{2} + O(t^3)
$$

という形になる. そして,

$$
\frac{1}{\sqrt{n}}\sum_{k=1}^n Y_k =
\frac{\sqrt{n}}{\sigma}\frac{1}{n}\sum_{k=1}^n (X_k - \mu) =
\frac{\sqrt{n}}{\sigma}(\bar{X}_n - \mu) = Z_n
$$

なので, $Z_n$ の特性函数は, $n\to\infty$ で

$$
\begin{aligned}
\varphi_{Z_n}(t) &=
E\left[\exp\left(it \frac{1}{\sqrt{n}}\sum_{k=1}^n Y_k\right)\right] =
E\left[\prod_{k=1}^n\exp\left(i\frac{t}{\sqrt{n}}Y_k\right)\right]
\\ &=
\prod_{k=1}^n E\left[\exp\left(i\frac{t}{\sqrt{n}}Y_k\right)\right] =
\varphi\left(\frac{t}{\sqrt{n}}\right)^n =
\left(1 - \frac{t^2}{2n} + O(n^{-3/2})\right)^n \to
e^{-t^2/2}.
\end{aligned}
$$

と標準正規分布の特性函数 $e^{-t^2/2}$ に収束する.  (3つめの等号で $Y_1,\ldots,Y_n$ の独立性を使った.)

ゆえに $Z_n$ の分布は $n\to\infty$ で標準正規分布に近付く.

__証明終__


### 中心極限定理の収束の速さと歪度

前節の証明より, 独立同分布確率変数列 $X_1,X_2,\ldots$ に対して, 

$$
\mu = E[X_k], \quad
\sigma = \sqrt{E[(X-\mu)^2]}, \quad
Y_k = \frac{X_k - \mu}{\sigma}, \quad
\varphi(t) = E[e^{itY_k}]
$$

とおいたときの, $n\to\infty$ での $\varphi(t/\sqrt{n})^n \to e^{-t^2/2}$ という収束の速さを調べれば, 中心極限定理による正規分布への収束の速さがわかる.  

$$
\bar\mu_3 = E[Y_k^3] = E\left[\left(\frac{X_k - \mu}{\sigma}\right)^3\right]
$$

とおくと,

$$
\varphi\left(\frac{t}{\sqrt{n}}\right) = E[e^{itY_k}] =
1 - \frac{t^2}{2n} - i\bar\mu_3\frac{t^3}{6n\sqrt{n}} + O(n^{-2})
$$

なので, 

$$
\log\varphi\left(\frac{t}{\sqrt{n}}\right)^n = 
n\log\left(1 - \frac{t^2}{2n} - i\bar\mu_3\frac{t^3}{6n\sqrt{n}} + O(n^{-2})\right) =
-\frac{t^2}{2} - i\bar\mu_3\frac{t^3}{6\sqrt{n}} + O(n^{-1}).
$$

これは $n\to\infty$ での $\log\varphi\left(t/\sqrt{n}\right)^n \to -t^2/2$ の収束の速さは, $Y_k=(X_k-\mu)/\sigma$ の3次のモーメント $\bar\mu_3$ の絶対値の大きさで大体決まっていることがわかる. $\bar\mu_3$ の絶対値が小さいほど収束が速く, 大きいほど収束が遅い.

$\bar\mu_3$ は $X_k$ の分布の期待値 $\mu$ を中心とする非対称性の $\sigma$ によって適切に正規化した尺度になっている.  $\bar\mu_3$ は $Y_k=(X_k-\mu)/\sigma$ の3次のキュムラントにも一致している:

$$
K_{Y_k}(t) = \log E[e^{tY_k}] =
\log\left(1 + \frac{t^2}{2} + \bar\mu_3\frac{t^3}{3!} + O(t^4)\right) =
\frac{t^2}{2} + \bar\mu_3 \frac{t^3}{3!} + O(t^4).
$$

ここでの $t^3/3!$ の係数 $\bar\kappa_3 = \bar\mu_3$ は $X_k$ の __歪度__ (skewness) と呼ばれるのであった.


### 中心極限定理のキュムラント母函数を使った証明

__中心極限定理:__ $X_1, X_2, X_3, \ldots$ が独立同分布な確率変数の列であるとき, $\mu=E[X_k]$ が定義されていて, $\sigma^2 = \var(X_k) = E[(X_k - \mu)^2] < \infty$ でかつ, $E[|X_k - \mu|^3] < \infty$ となっており, さらに各 $X_k$ のキュムラント母函数がうまく定義されているとする. このとき,

$$
\bar{X}_n = \frac{1}{n}\sum_{k=1}^n X_k, \quad
Z_n = \frac{\sqrt{n}\,(\bar{X}_n - \mu)}{\sigma}
$$

とおくと, $n\to\infty$ で $Z_n$ の分布は標準正規分布に近付く.

__証明:__ $X_k$ の標準化を $Y_k = (X_k - \mu)/\sigma$ と書くことにする. $Y_1, Y_2, \ldots$ も独立同分布になり, $E[Y_k] = 0, \quad E[Y_k^2] = 1$ が成立している.  ゆえに $Y_k$ のキュムラント母函数 $K(t)$ は $k$ によらず,

$$
K(t) = K_{Y_k}(t) = \frac{t^2}{2} + O(t^3)
$$

という形になる. そして,

$$
\frac{1}{\sqrt{n}}\sum_{k=1}^n Y_k =
\frac{\sqrt{n}}{\sigma}\frac{1}{n}\sum_{k=1}^n (X_k - \mu) =
\frac{\sqrt{n}}{\sigma}(\bar{X}_n - \mu) = Z_n
$$

なので, $Z_n$ のキュムラント母函数は, $n\to\infty$ で

$$
\begin{aligned}
K_{Z_n}(t) &=
K_{Y_1/\sqrt{n}+\cdots+Y_n/\sqrt{n}}(t) =
K_{Y_1}\left(\frac{t}{\sqrt{n}}\right) + \cdots + K_{Y_1}\left(\frac{t}{\sqrt{n}}\right) \\ &=
n K\left(\frac{t}{\sqrt{n}}\right) =
n\left(\frac{t^2}{2n} + O(n^{-3/2})\right) =
\frac{t^2}{2} + O(n^{-1/2})) \to
\frac{t^2}{2}
\end{aligned}
$$

と標準正規分布のキュムラント母函数 $t^2/2$ に収束する.

ゆえに $Z_n$ の分布は $n\to\infty$ で標準正規分布に近付く.

__証明終__

__注意:__ このようにキュムラント母函数を使うと証明が非常にシンプルになる.


### 中心極限定理の収束の速さと歪度と尖度

前節の証明より, 独立同分布確率変数列 $X_1,X_2,\ldots$ に対して, 

$$
\mu = E[X_k], \quad
\sigma = \sqrt{E[(X-\mu)^2]}, \quad
K(t) = K_{(X_k - \mu)/\sigma}(t) = \log E\left[\left(\frac{X_k-\mu}{\sigma}\right)\right]
$$

とおいたときの, $n\to\infty$ での $n K(t/\sqrt{n}) \to t^2/2$ という収束の速さを調べれば, 中心極限定理による正規分布への収束の速さがわかる. $X_k$ の歪度(わいど) $\bar\kappa_3$ と尖度(せんど) $\bar\kappa_4$ は

$$
\bar\kappa_3 = E\left[\left(\frac{X_k - \mu}{\sigma}\right)^3\right], \quad
\bar\kappa_4 = E\left[\left(\frac{X_k - \mu}{\sigma}\right)^4\right] - 3
$$

と表され, $X_k$ の標準化のキュムラント母函数 $K(t)$ の展開の係数になっているのであった:

$$
K(t) = \frac{t^2}{2} + \bar\kappa_3\frac{t^3}{3!} + \bar\kappa_4\frac{t^4}{4!} + O(t^5).
$$

このとき,

$$
n K\left(\frac{t}{\sqrt{n}}\right) =
n\left(
\frac{t^2}{2n} + \bar\kappa_3\frac{t^3}{3!\,n^{3/2}} + \bar\kappa_4\frac{t^4}{4!\,n^2} + O(n^{-5/2})
\right) =
\frac{t^2}{2} + \bar\kappa_3\frac{t^3}{3!\,n^{1/2}} + \bar\kappa_4\frac{t^4}{4!\,n} + O(n^{-3/2})
$$

これが $t^2/2$ に収束する速さは $\bar\kappa_3 \ne 0$ ならば $O(n^{-1/2})$ のオーダーになり, 歪度 $\bar\kappa_3$ の絶対値が大きいほど遅くなる. そして, $\bar\kappa_3 = 0$ ならば $O(n^{-1})$ のオーダーでの収束になり, 尖度 $\bar\kappa_4$ の絶対値が大きいほど収束は遅くなる.


### 中心極限定理のTaylorの定理のみを使う証明


### 中心極限定理の収束の速さと歪度と尖度(再)


### 問題: 中心極限定理の収束の様子のグラフ

中心極限定理による正規分布への収束の様子をコンピュータでグラフを描いて確認せよ. 収束が速い場合($n=10$ ですでに正規分布に十分に近い場合)と遅い場合の両方の例を作れ. 

__注意:__ 特に収束が遅い場合の様子を確認することが重要である.  中心極限定理は統計学において空気のごとく使用されるが, 数学的には収束が遅い場合があるので, 現実の分析で中心極限定理を使うことには注意を要する.  しかし, 単に注意を要することを知っているだけでは役に立たない. 中心極限定理による収束が遅い場合について具体的な例を知っていれば, 危険を察知し易くなるだろう.

解答例は以下の通り.

```julia
# 中心極限定理による収束が速い場合1
# distを左右対称な分布でかつ「おとなしめなもの」とする
dist = Uniform(0, 1)
@show skewness(dist) kurtosis(dist)
plot(dist, -0.5, 1.5; label="")
title!("Uniform(0, 1)")
```

```julia
# 分布distの独立同分布確率変数達(n個)の実現値(要するに乱数)を大量に(L個)生成
n = 10
L = 10^6
Xs = rand(dist, n, L) # Xs の s は X = (X_1, … , X_n) 達意味(複数という意味)
```

```julia
# Z_n = √n(X̄_n - μ)/σ を大量に計算
μ = mean(dist)
σ = std(dist)
Zns = [√n*(mean(X) - μ)/σ for X in eachcol(Xs)] # Zns はZ_n達という意味
first(Zns, 5)
```

```julia
# Z_n達のヒストグラムと標準正規分布の密度函数を比較
histogram(Zns; norm=true, alpha=0.3, bin=100, label="Zₙ")
plot!(Normal(0, 1); label="Normal(0,1)", lw=2)
title!("n = $n")
```

```julia
# 以上の手続きを函数化
# さらに
#   * メモリアロケーションの節約と並列化による最適化
#   * 離散分布の場合にも対応
#   * 歪度と尖度を混合モデルの場合にも表示

distname(dist::Distribution) = replace(string(dist), r"{.*}" => "")
myskewness(dist) = skewness(dist)
mykurtosis(dist) = kurtosis(dist)
function standardized_moment(dist::ContinuousUnivariateDistribution, m)
    μ, σ = mean(dist), std(dist)
    quadgk(x -> (x - μ)^m * pdf(dist, x), extrema(dist)...)[1] / σ^m
end
myskewness(dist::MixtureModel{Univariate, Continuous}) = standardized_moment(dist, 3)
mykurtosis(dist::MixtureModel{Univariate, Continuous}) = standardized_moment(dist, 4) - 3

function plot_central_limit_theorem(dist, n;
        L=10^6,
        μ = mean(dist),
        σ = std(dist),
        a = max(minimum(dist), μ - 5σ),
        b = min(maximum(dist), μ + 5σ),
        disttitle = distname(dist),
        bin = 100,
        kwargs...
    )
    println("skewness(dist) = ", myskewness(dist))
    println("kurtosis(dist) = ", mykurtosis(dist))
    
    # 分布distをプロット
    if dist isa DiscreteUnivariateDistribution
        P1 = bar(round(Int, a):round(Int, b), x -> pdf(dist, x), ; alpha=0.3, label="")
    else
        P1 = plot(x -> pdf(dist, x), a, b; label="")
    end
    title!(disttitle)

    # 分布distの独立同分布確率変数達(n個)の実現値(要するに乱数)を大量に(L個)生成し,
    # Z_n = √n(X̄_n - μ)/σ を大量に計算することを並列化で実行
    # このような計算には並列化が非常に有効である
    Zns = Vector{Float64}(undef, L)
    tmp = [Vector{Float64}(undef, n) for _ in 1:Threads.nthreads()]
    Threads.@threads for i in 1:L # Threads.@threads マクロで並列化
        X = rand!(dist, tmp[Threads.threadid()]) # rand!を使ってアロケーションを節約
        Zns[i] = √n*(mean(X) - μ)/σ
    end

    # Z達のヒストグラムと標準正規分布の密度函数を比較
    if dist isa DiscreteUnivariateDistribution
        summin = max(n*minimum(dist), round(n*μ - 6√n*σ))
        summax = min(n*maximum(dist), round(n*μ + 6√n*σ))
        sumran = summin-0.5:summax+0.5
        bin = @. √n*(sumran/n - μ)/σ
        P2 = histogram(Zns; norm=true, alpha=0.3, bin, label="Zₙ")
    else
        P2 = histogram(Zns; norm=true, alpha=0.3, bin, label="Zₙ")
    end
    plot!(Normal(0,1); label="Normal(0,1)", lw=2)
    title!("n = $n")

    plot(P1, P2; size=(800, 250), kwargs...)
end
```

```julia
# 中心極限定理による収束が速い場合1の再現
plot_central_limit_theorem(Uniform(0, 1), 10; a=-0.5, b=1.5)
```

```julia
# 中心極限定理による収束が速い場合2
plot_central_limit_theorem(Beta(0.5, 0.5), 10; a=0.01, b=0.99)
```

```julia
# 中心極限定理による収束が速い場合3
plot_central_limit_theorem(Bernoulli(0.5), 10)
```

```julia
# 中心極限定理による収束が速い場合4
plot_central_limit_theorem(Laplace(), 10)
```

```julia
# 左右非対称な分布の場合1
plot_central_limit_theorem(Gamma(3, 1), 10)
```

```julia
# 左右非対称な分布の場合2
plot_central_limit_theorem(Bernoulli(0.25), 10)
```

```julia
# 左右非対称な分布の場合3
plot_central_limit_theorem(Poisson(1), 10)
```

```julia
# 中心極限定理による収束が遅い場合1
# 左右の非対称性が大きな分布を試してみる
# 指数分布は左右の非対称性が大きな分布になっている
plot_central_limit_theorem(Exponential(), 10)
```

```julia
plot_central_limit_theorem(Exponential(), 40)
```

```julia
plot_central_limit_theorem(Exponential(), 160)
```

```julia
# 中心極限定理による収束が遅い場合2
# 自由度1のχ²分は左右の非対称性が指数分布よりも大きな分布になっている
plot_central_limit_theorem(Chisq(1), 10; a=0.05, b=6)
```

```julia
plot_central_limit_theorem(Chisq(1), 40; a=0.05, b=6)
```

```julia
plot_central_limit_theorem(Chisq(1), 160; a=0.05, b=6)
```

以下で使う, 分布 `MixtureModel([Normal(0, 1), Normal(20, 1)], [0.95, 0.05])` の確率密度函数は次の形になる:

$$
p(x) = 0.95\,\frac{e^{-x^2/2}}{\sqrt{2\pi}} + 0.05\,\frac{e^{-(x-20)^2/2}}{\sqrt{2\pi}}.
$$

これは標準正規分布に割合が $5\%$ の極端な外れ値を付け加えた分布になっている.  何らかの原因で分布に極端な外れ値が混ざっている場合には中心極限定理を使うときに注意を要する.

このように確率密度函数が複数の正規分布の確率密度函数の一次結合になっている分布は __混合正規分布__ (mixture normal distribution)と呼ばれている.

```julia
# 中心極限定理による収束が遅い場合3
# 以下のような分布distも左右の非対称性が大きな分布に分類される
dist = MixtureModel([Normal(0, 1), Normal(20, 1)], [0.95, 0.05])
disttitle = "MixtureModel([Normal(0, 1), Normal(20, 1)], [0.95, 0.05])"
titlefontsize = 9
a, b = -4, 24
plot_central_limit_theorem(dist, 10; a, b, disttitle, titlefontsize)
```

```julia
plot_central_limit_theorem(dist, 40; a, b, disttitle, titlefontsize)
```

```julia
plot_central_limit_theorem(dist, 160; a, b, disttitle, titlefontsize)
```

```julia
# 中心極限定理による収束が遅い場合4
# 対数正規分布は左右の非対称性が非常に大きな分布である
# 右側の裾が太く, 外れ値が出やすい
plot_central_limit_theorem(LogNormal(), 10; bin=range(-3, 9, 100))
```

```julia
plot_central_limit_theorem(LogNormal(), 40; bin=range(-3, 9, 100))
```

```julia
plot_central_limit_theorem(LogNormal(), 160; bin=range(-3, 9, 100))
```

### 問題: デルタ法 (実は単なる一次近似)


### 標本平均と不偏分散の定義


### 問題: 標本平均の期待値と分散


### 問題: 不偏分散の期待値と分散

```julia

```
