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

<!-- #region -->
# 検定と信頼区間: 平均の検定と信頼区間

* 黒木玄
* 2022-05-31～2022-06-09

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
\newcommand\CP{{\mathrm{CP}}}
\newcommand\Sterne{{\mathrm{Stern}}}
\newcommand\Wilson{{\mathrm{Wilson}}}
\newcommand\Wald{{\mathrm{Wald}}}
\newcommand\LLR{{\mathrm{LLR}}}
\newcommand\pdf{\op{pdf}}
\newcommand\pmf{\op{pmf}}
\newcommand\cdf{\op{cdf}}
\newcommand\quantile{\op{quantile}}
\newcommand\Binomial{\op{Binomial}}
\newcommand\Beta{\op{Beta}}
\newcommand\Normal{\op{Normal}}
\newcommand\Chisq{\op{Chisq}}
\newcommand\TDist{\op{TDist}}
\newcommand\Chisq{\op{Chisq}}
\newcommand\pvalue{\op{pvalue}}
\newcommand\confint{\op{confint}}
\newcommand\phat{\hat{p}}
\newcommand\SE{\op{SE}}
\newcommand\SEhat{\widehat{\SE}}
$


このノートでは[Julia言語](https://julialang.org/)を使用している: 

* [Julia言語のインストールの仕方の一例](https://nbviewer.org/github/genkuroki/msfd28/blob/master/install.ipynb)

自明な誤りを見つけたら, 自分で訂正して読んで欲しい.  大文字と小文字の混同や書き直しが不完全な場合や符号のミスは非常によくある.

このノートに書いてある式を文字通りにそのまま読んで正しいと思ってしまうとひどい目に会う可能性が高い. しかし, 数が使われている文献には大抵の場合に文字通りに読むと間違っている式や主張が書いてあるので, 内容を理解した上で訂正しながら読んで利用しなければいけない. 実践的に数学を使う状況では他人が書いた式をそのまま信じていけない.

このノートの内容よりもさらに詳しいノートを自分で作ると勉強になるだろう.  膨大な時間を取られることになるが, このノートの内容に関係することで飯を食っていく可能性がある人にはそのためにかけた時間は無駄にならないと思われる.
<!-- #endregion -->

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#平均の検定と信頼区間" data-toc-modified-id="平均の検定と信頼区間-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>平均の検定と信頼区間</a></span><ul class="toc-item"><li><span><a href="#平均の検定で使用されるP値の定義(1)-標準正規分布を使う場合" data-toc-modified-id="平均の検定で使用されるP値の定義(1)-標準正規分布を使う場合-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>平均の検定で使用されるP値の定義(1) 標準正規分布を使う場合</a></span></li><li><span><a href="#P値の定義(1)の標準正規分布を使う場合に対応する平均の信頼区間" data-toc-modified-id="P値の定義(1)の標準正規分布を使う場合に対応する平均の信頼区間-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>P値の定義(1)の標準正規分布を使う場合に対応する平均の信頼区間</a></span></li><li><span><a href="#平均の検定で使用されるP値の定義(2)-t-分布を使う場合" data-toc-modified-id="平均の検定で使用されるP値の定義(2)-t-分布を使う場合-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>平均の検定で使用されるP値の定義(2) t 分布を使う場合</a></span></li><li><span><a href="#P値の定義(2)のt分布を使う場合に対応する平均の信頼区間" data-toc-modified-id="P値の定義(2)のt分布を使う場合に対応する平均の信頼区間-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>P値の定義(2)のt分布を使う場合に対応する平均の信頼区間</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using BenchmarkTools
using DataFrames
using Distributions
using LinearAlgebra
using Printf
using QuadGK
using RCall
using Random
Random.seed!(4649373)
using Roots
using SpecialFunctions
using StaticArrays
using StatsBase
using StatsFuns
using StatsPlots
default(fmt = :png, size = (400, 250),
    titlefontsize = 10, plot_titlefontsize = 12)
using SymPy
```

```julia
# Override the Base.show definition of SymPy.jl:
# https://github.com/JuliaPy/SymPy.jl/blob/29c5bfd1d10ac53014fa7fef468bc8deccadc2fc/src/types.jl#L87-L105

@eval SymPy function Base.show(io::IO, ::MIME"text/latex", x::SymbolicObject)
    print(io, as_markdown("\\displaystyle " *
            sympy.latex(x, mode="plain", fold_short_frac=false)))
end
@eval SymPy function Base.show(io::IO, ::MIME"text/latex", x::AbstractArray{Sym})
    function toeqnarray(x::Vector{Sym})
        a = join(["\\displaystyle " *
                sympy.latex(x[i]) for i in 1:length(x)], "\\\\")
        """\\left[ \\begin{array}{r}$a\\end{array} \\right]"""
    end
    function toeqnarray(x::AbstractArray{Sym,2})
        sz = size(x)
        a = join([join("\\displaystyle " .* map(sympy.latex, x[i,:]), "&")
                for i in 1:sz[1]], "\\\\")
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
myskewness(dist::MixtureModel{Univariate, Continuous}) =
    standardized_moment(dist, 3)
mykurtosis(dist::MixtureModel{Univariate, Continuous}) =
    standardized_moment(dist, 4) - 3
```

## 平均の検定と信頼区間

以下のようなことを行いたい.

(1) S市の中学3年生男子達から $n$ 人を無作為抽出して身長を測って得た数値のデータ $x_1,\ldots,x_n$ から, S市の中学3年生男子達の身長の平均値を推定したい.

(2) とある店で出されるプライドポテトの長さを $n$ 本分測って得た数値のデータ $x_1,\ldots,x_n$ から, その店で出されるフライドポテトの長さの平均値を推定したい.

このような推定を以下では __平均の推定__ と呼ぶことにする.

目標は平均の信頼区間の構成である.

そのためには, 検定と信頼区間の表裏一体性より, P値を適切に定義すればよい.


### 平均の検定で使用されるP値の定義(1) 標準正規分布を使う場合

__データ:__　$n$ 個の実数値 $x_1,\ldots,x_n$.

データの標本平均と不偏分散をそれぞれ $\bar{x}$, $s^2$ と書く:

$$
\bar{x} = \frac{1}{n}\sum_{i=1}^n x_i, \quad
s^2 = \frac{1}{n-1}\sum_{i=1}^n \left(x_i - \bar{x}\right).
$$

__統計モデル:__　確率密度函数 $q(x)$ を持つ未知の連続分布 $Q$ のサイズ $n$ の標本分布 $Q^n$.  その同時確率密度函数は

$$
q(x_1,\ldots,x_n) = q(x_1)\cdots q(x_n)
$$

と表される.  未知の連続分布 $Q$ の平均と分散をそれぞれ $\mu$, $\sigma$ と書くことにする.

__検定される仮説:__　$\mu = \mu_0$　($\mu_0$ は具体的な数値).

$X_1,\ldots,X_n$ は統計モデル $Q^n$ に従う確率変数達であるとする. すなわち, $X_1,\ldots,X_n$ は独立な確率変数達であり, 各々がモデルの確率分布 $Q$ に従っていると仮定する.

__標本平均に関する中心極限定理:__　中心極限定理によって, $n$ が十分に大きいならば, $X_1,\ldots,X_n$ の標本平均

$$
\bar{X} = \frac{1}{n}\sum_{i=1}^n X_i
$$

は平均 $\mu$, 分散 $\sigma^2/n$ の正規分布に近似的に従う:

$$
\bar{X} \sim \Normal\left(\mu, \sqrt{\sigma^2/n}\right), \ \text{approximately}.
$$

__不偏分散に関する大数の法則:__　大数の法則より, $n$ が十分に大きいならば, モデルの確率分布 $Q$ の分散 $\sigma^2$ の値は $X_1,\ldots,X_n$ の不偏分散(不偏推定量になるように補正された標本分散)

$$
S^2 = \frac{1}{n-1}\sum_{i=1}^n \left(X_i - \bar{X}\right)
$$

で近似される:

$$
S^2 \approx \sigma^2.
$$

__検定で使われる $T$ 統計量:__　以上の状況の下で, $T$ 統計量を

$$
T(\mu) := \frac{\bar{X} - \mu}{\sqrt{S^2/n}} \approx
\frac{\bar{X} - \mu}{\sqrt{\sigma^2/n}} \sim
\Normal(0,1), \ \text{approximately}.
$$

と定めると, これは近似的に標準正規分布に従う:

$$
T(\mu) \sim \Normal(0,1), \ \text{approximately}.
$$

データの $t$ 値を次のように定める:

$$
t(\mu) := \frac{\bar{x} - \mu}{\sqrt{s^2/n}}.
$$

__P値の定義:__　仮説 $\mu = \mu_0$ の下で $|T(\mu_0)| \ge |t(\mu_0)|$ となる確率を, 標準正規分布に従ってランダムに生成される値の絶対値が $|t(\mu_0)|$ 以上になる確率として近似的に求めて, その値をデータ $x_1,\ldots,x_n$ に関する仮説 $\mu = \mu_0$ のP値として採用する. そのP値を次のように書く:

$$
\pvalue_{\Normal}(\bar{x}, s^2|n, \mu=\mu_0) = 
2(1 - \cdf(\Normal(0,1), |t(\mu_0)|)).
$$

```julia
@. round(quantile(Normal(), 1 - (0.05, 0.01, 0.001) / 2); digits=4)
```

### P値の定義(1)の標準正規分布を使う場合に対応する平均の信頼区間

有意水準を $0\le\alpha\le 1$ と書き, 標準正規分布において $z_{\alpha/2}$ 以上になる確率は $\alpha/2$ になると仮定する:

$$
z_{\alpha/2} = \quantile(\Normal(0,1), 1 - \alpha/2).
$$

例えば,

$$
z_{5\%/2} \approx 1.9600, \quad
z_{1\%/2} \approx 2.5758, \quad
z_{0.1\%/2} \approx 3.2905.
$$

P値函数 $\pvalue_{\Normal}(\bar{x}, s^2|Q, n, \mu=\mu_0) = 2(1 - \cdf(\Normal(0,1), |t(\mu_0)|))$ に対応する信頼度 $1-\alpha$ の信頼区間は次のようになる:

$$
\confint_{\Normal}(\bar{x}, s^2|n, \mu=\mu_0) =
\left[
\bar{x} - z_{\alpha/2} \sqrt{s^2/n},\;
\bar{x} + z_{\alpha/2} \sqrt{s^2/n}
\right].
$$

__証明:__ 検定と信頼区間の表裏一体性より, P値函数 $\pvalue_{\Normal}(\bar{x}, s^2|Q, n, \mu=\mu_0)$ に対応する信頼度 $1-\alpha$ の信頼区間は次のように定義されるのであった:

$$
\confint_{\Normal}(\bar{x}, s^2|n, \mu=\mu_0) =
\{\, \mu_0\in\R \mid \pvalue_{\Normal}(\bar{x}, s^2|n, \mu=\mu_0) \ge \alpha\,\}.
$$

そして,

$$
\begin{aligned}
&
\pvalue_{\Normal}(\bar{x}, s^2|n, \mu=\mu_0) \ge \alpha
\\ &\iff
1 - \cdf(\Normal(0,1), |t(\mu_0)|)) \ge \alpha/2
\\ &\iff
|t(\mu_0)| = \frac{|\bar{x} - \mu_0|}{\sqrt{s^2/n}} \le z_{\alpha/2}
\\ &\iff
\bar{x} - z_{\alpha/2} \sqrt{s^2/n} \le \mu_0 \le
\bar{x} + z_{\alpha/2} \sqrt{s^2/n}.
\end{aligned}
$$

これより, P値の定義(1)に対応する平均の信頼区間が上のようになることがわかった.

__証明終__


### 平均の検定で使用されるP値の定義(2) t 分布を使う場合

分布 $Q$ が左右対称の分布ならば $n=10$ のようなかなり小さな $n$ で中心極限定理による近似の誤差は非常に小さくなる場合がある.  しかし, そういう場合であっても, 大数の法則を使った不偏分散 $S^2$ による $\sigma^2$ の近似の精度は低いままの場合がある.

そういう場合の補正を $t$ 分布を使って行う処方箋を採用しよう.

__統計モデルとして正規分布の標本分布を仮定:__　以下では, 統計モデルとして, 平均 $\mu$, 分散 $\sigma^2$ を持つ正規分布のサイズ $n$ の標本分布を採用する.  その確率密度函数は次のように表される:

$$
p(x_1,\ldots,x_n|\mu,\sigma^2) =
\frac{1}{(2\pi\sigma^2)^{n/2}}
\exp\left(-\frac{1}{2\sigma^2}\sum_{i=1}^n (x_i - \mu)^2\right).
$$

$X_1,\ldots,X_n$ はこの統計モデルに従う確率変数達であるとし, それらの標本平均と不偏分散をそれぞれ $\bar{X}$, $S^2$ と表す.

__X̄とS²の同時分布:__　標本平均と不偏分散

$$
\bar{x} = \frac{1}{n}\sum_{i=1}^n x_i, \quad
s^2 = \frac{1}{n}\sum_{i=1}^n (x_i - \bar{x})^2
$$

を使うと, 

$$
\sum_{i=1}^n (x_i - \mu)^2 =
\sum_{i=1}^n ((x_i - \bar{x}) (\bar{x} - \mu))^2 =
(n-1)s^2 + n(\bar{x} - \mu))^2.
$$

なので, 

$$
p(x_1,\ldots,x_n|\mu,\sigma^2) =
\frac{1}{(2\pi\sigma^2)^{n/2}}
\exp\left(-\frac{1}{2}\frac{(n-1)s^2}{\sigma^2} - \frac{(\bar{x} - \mu)^2}{2\sigma^2/n}\right).
$$

このことから, $\bar{X}, S^2$ は独立な確率変数であり, $\bar{X}$ は平均 $\mu$, 分散 $\sigma^2/n$ の正規分布に従い, $(n-1)S^2/\sigma^2$ は自由度 $n-1$ のχ²分布に従うことを示せる:

$$
\bar{X} \sim \Normal\left(\mu, \sqrt{\sigma^2/n}\right), \quad
\frac{(n-1)S^2}{\sigma^2} \sim \Chisq(n-1).
$$

詳しくは「標本分布について」のノートの「正規分布の標本分布の場合」の節を参照せよ.  自由度 $n-1$ のχ²分布の密度函数を作るために必要な, $u=s^2$ とおいたときの因子 $u^{(n-1)/2-1} は

$$
dy_1\cdots dy_{n-1} \propto
\left(\sqrt{u}\right)^{n-2}\,d\sqrt{u}\,d\theta \propto
u^{(n-1)/2-1}\,du\,d\theta
$$

のような計算で出て来る. ここで $d\theta$ は $n-2$ 次元単位球面の微小面積要素である.

__T統計量が従う分布:__　ゆえに, $T$ 統計量

$$
T(\mu) = \frac{\bar{X} - \mu}{\sqrt{S^2/n}}
$$

は自由度 $n-1$ の $t$ 分布に従う:

$$
T(\mu) \sim \TDist(n-1).
$$

詳しくは, 「正規分布の標本分布から自然にt分布に従う確率変数が得られること」を参照せよ.

__注意:__ 自由度が大きな $t$ 分布は標準正規分布とほぼ同じになるので, この結果はP値の定義(1)で使った結果と整合的であり, この結果が意味を持つのは $n$ が大きくない場合にのみ意味を持つ.  実践的には $n$ が十分に大きな場合には $\TDist(n-1)$ を標準正規分布で置き換えてよい.

__P値の定義:__　仮説 $\mu = \mu_0$ の下で $|T(\mu_0)| \ge |t(\mu_0)|$ となる確率を, 自由度 $n-1$ の $t$ 分布に従ってランダムに生成される値の絶対値が $|t(\mu_0)|$ 以上になる確率として正確に求めて, その値をデータ $x_1,\ldots,x_n$ に関する仮説 $\mu = \mu_0$ のP値として採用する. そのP値を次のように書く:

$$
\pvalue_{\TDist}(\bar{x}, s^2|n, \mu=\mu_0) = 
2(1 - \cdf(\TDist(n-2), |t(\mu_0)|)).
$$

このP値は $n$ が大きな場合には定義(1)のP値 $\pvalue_{\Normal}(\bar{x}, s^2|n, \mu=\mu_0)$ と近似的に一致する.  ゆえに, P値の定義(1)を使うことを止めて, こちらの定義(2)の方だけを使うことにしても害がないと考えられる.

__我々はこれ以後こちらのP値の定義のみを使用する.__

__注意:__ ただし, こちらの定義(2)のP値は先の定義(1)のP値よりも少し大きくなり, 定義(2)の場合の信頼区間は定義(1)の場合の信頼区間よりも少し広くなる.

```julia
df = 10:10:100
α = [0.05, 0.01, 0.001]
z = @. round(quantile(Normal(), 1-α'/2); digits=4)
t = @. round(quantile(TDist(df), 1-α'/2); digits=4)
table_of_t = DataFrame(
    df = Any[df; Inf],
    var"α = 5%" = [t[:,1]; z[1]],
    var"α = 1%" = [t[:,2]; z[2]],
    var"α = 0.1%" = [t[:,3]; z[3]],
)
```

```julia
quantile(TDist(30), 1-0.05/2) / quantile(Normal(), 1-0.05/2)
```

### P値の定義(2)のt分布を使う場合に対応する平均の信頼区間

有意水準を $0\le\alpha\le 1$ と書き, 自由度 $\nu$ の $t$ 分布において $t_{\alpha/2}(\nu)$ 以上になる確率は $\alpha/2$ になると仮定する:

$$
t_{\alpha/2}(\nu) = \quantile(\TDist(\nu), 1 - \alpha/2).
$$

例えば,

$$
t_{5\%/2}(10) \approx 2.2281, \quad
t_{5\%/2}(20) \approx 2.0860, \quad
t_{5\%/2}(30) \approx 2.0423.
$$

自由度を大きくする極限では, $t_{5\%/2}(\infty) = z_{5\%/2} \approx 1.9600$ となる.  $t_{5\%/2}(30) \approx 2.0423$ はその値よりも $4.2\%$ 程度大きい. (信頼区間もその割合で広くなる.)

P値 $\pvalue_{\TDist}(\bar{x}, s^2|n, \mu=\mu_0) = 2(1 - \cdf(\TDist(n-2), |t(\mu_0)|))$ に対応する信頼度 $1-\alpha$ の信頼区間は次のようになる:

$$
\confint_{\TDist}(\bar{x}, s^2|n, \mu=\mu_0) =
\left[
\bar{x} - t_{\alpha/2}(n-1) \sqrt{s^2/n},\;
\bar{x} + t_{\alpha/2}(n-1) \sqrt{s^2/n}
\right].
$$

証明はP値の定義(1)の場合と完全に同様である. 標準正規分布を $t$ 分布で置き換えるだけでよい.

__証明:__ 検定と信頼区間の表裏一体性より, P値函数 $\pvalue_{\TDist}(\bar{x}, s^2|Q, n, \mu=\mu_0)$ に対応する信頼度 $1-\alpha$ の信頼区間は次のように定義されるのであった:

$$
\confint_{\TDist}(\bar{x}, s^2|n, \mu=\mu_0) =
\{\, \mu_0\in\R \mid \pvalue_{\TDist}(\bar{x}, s^2|n, \mu=\mu_0) \ge \alpha\,\}.
$$

そして,

$$
\begin{aligned}
&
\pvalue_{\TDist}(\bar{x}, s^2|n, \mu=\mu_0) \ge \alpha
\\ &\iff
1 - \cdf(\TDist(n-1), |t(\mu_0)|)) \ge \alpha/2
\\ &\iff
|t(\mu_0)| = \frac{|\bar{x} - \mu_0|}{\sqrt{s^2/n}} \le t_{\alpha/2}(n-1)
\\ &\iff
\bar{x} - t_{\alpha/2}(n-1) \sqrt{s^2/n} \le \mu_0 \le
\bar{x} + t_{\alpha/2}(n-1) \sqrt{s^2/n}.
\end{aligned}
$$

これより, P値の定義(2)に対応する平均の信頼区間が上のようになることがわかった.

__証明終__




```julia

```

```julia

```

```julia

```
