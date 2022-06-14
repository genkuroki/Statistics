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
# 検定と信頼区間: 比率の比較

* 黒木玄
* 2022-06-14～2022-06-14

$
\newcommand\op{\operatorname}
\newcommand\R{{\mathbb R}}
\newcommand\Z{{\mathbb Z}}
\newcommand\var{\op{var}}
\newcommand\cov{\op{cov}}
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
\newcommand\Chi{\op{Chi}}
\newcommand\TDist{\op{TDist}}
\newcommand\Chisq{\op{Chisq}}
\newcommand\pvalue{\op{pvalue}}
\newcommand\confint{\op{confint}}
\newcommand\phat{\hat{p}}
\newcommand\SE{\op{SE}}
\newcommand\SEhat{\widehat{\SE}}
\newcommand\logistic{\op{logistic}}
\newcommand\logit{\op{logit}}
\newcommand\OR{\op{OR}}
\newcommand\ORhat{\widehat{\op{OR}}}
\newcommand\RR{\op{RR}}
\newcommand\ha{\hat{a}}
\newcommand\hb{\hat{b}}
\newcommand\hc{\hat{c}}
\newcommand\hd{\hat{d}}
\newcommand\Wald{\op{Wald}}
\newcommand\Pearson{\op{Pearson}}
\newcommand\Fisher{\op{Fisher}}
$


このノートでは[Julia言語](https://julialang.org/)を使用している: 

* [Julia言語のインストールの仕方の一例](https://nbviewer.org/github/genkuroki/msfd28/blob/master/install.ipynb)

自明な誤りを見つけたら, 自分で訂正して読んで欲しい.  大文字と小文字の混同や書き直しが不完全な場合や符号のミスは非常によくある.

このノートに書いてある式を文字通りにそのまま読んで正しいと思ってしまうとひどい目に会う可能性が高い. しかし, 数が使われている文献には大抵の場合に文字通りに読むと間違っている式や主張が書いてあるので, 内容を理解した上で訂正しながら読んで利用しなければいけない. 実践的に数学を使う状況では他人が書いた式をそのまま信じていけない.

このノートの内容よりもさらに詳しいノートを自分で作ると勉強になるだろう.  膨大な時間を取られることになるが, このノートの内容に関係することで飯を食っていく可能性がある人にはそのためにかけた時間は無駄にならないと思われる.
<!-- #endregion -->

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#比率の比較に関するP値と信頼区間" data-toc-modified-id="比率の比較に関するP値と信頼区間-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>比率の比較に関するP値と信頼区間</a></span><ul class="toc-item"><li><span><a href="#比率の比較に関するP値と信頼区間を使って行いたいこと" data-toc-modified-id="比率の比較に関するP値と信頼区間を使って行いたいこと-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>比率の比較に関するP値と信頼区間を使って行いたいこと</a></span></li><li><span><a href="#2×2の分割表型データとその2つの二項分布モデル" data-toc-modified-id="2×2の分割表型データとその2つの二項分布モデル-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>2×2の分割表型データとその2つの二項分布モデル</a></span></li><li><span><a href="#比率の違いを表す2つの指標:-オッズ比-OR-とリスク比-RR" data-toc-modified-id="比率の違いを表す2つの指標:-オッズ比-OR-とリスク比-RR-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>比率の違いを表す2つの指標: オッズ比 OR とリスク比 RR</a></span></li><li><span><a href="#Wald版のオッズ比に関するP値と信頼区間の定義" data-toc-modified-id="Wald版のオッズ比に関するP値と信頼区間の定義-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>Wald版のオッズ比に関するP値と信頼区間の定義</a></span></li><li><span><a href="#Wald版のオッズ比に関するP値と信頼区間の計算例" data-toc-modified-id="Wald版のオッズ比に関するP値と信頼区間の計算例-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span>Wald版のオッズ比に関するP値と信頼区間の計算例</a></span><ul class="toc-item"><li><span><a href="#WolframAlphaによるWald版のP値と信頼区間の計算の仕方" data-toc-modified-id="WolframAlphaによるWald版のP値と信頼区間の計算の仕方-1.5.1"><span class="toc-item-num">1.5.1&nbsp;&nbsp;</span>WolframAlphaによるWald版のP値と信頼区間の計算の仕方</a></span></li><li><span><a href="#Julia言語によるWald版のP値と信頼区間の計算の仕方(1)" data-toc-modified-id="Julia言語によるWald版のP値と信頼区間の計算の仕方(1)-1.5.2"><span class="toc-item-num">1.5.2&nbsp;&nbsp;</span>Julia言語によるWald版のP値と信頼区間の計算の仕方(1)</a></span></li><li><span><a href="#Julia言語によるWald版のP値と信頼区間の計算の仕方(2)" data-toc-modified-id="Julia言語によるWald版のP値と信頼区間の計算の仕方(2)-1.5.3"><span class="toc-item-num">1.5.3&nbsp;&nbsp;</span>Julia言語によるWald版のP値と信頼区間の計算の仕方(2)</a></span></li><li><span><a href="#R言語での計算の仕方" data-toc-modified-id="R言語での計算の仕方-1.5.4"><span class="toc-item-num">1.5.4&nbsp;&nbsp;</span>R言語での計算の仕方</a></span></li></ul></li><li><span><a href="#Pearsonのχ²検定版のオッズ比に関するP値と信頼区間の定義" data-toc-modified-id="Pearsonのχ²検定版のオッズ比に関するP値と信頼区間の定義-1.6"><span class="toc-item-num">1.6&nbsp;&nbsp;</span>Pearsonのχ²検定版のオッズ比に関するP値と信頼区間の定義</a></span></li><li><span><a href="#Pearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算例" data-toc-modified-id="Pearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算例-1.7"><span class="toc-item-num">1.7&nbsp;&nbsp;</span>Pearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算例</a></span><ul class="toc-item"><li><span><a href="#WolframAlphaによるPearsonのχ²検定のP値の計算の仕方" data-toc-modified-id="WolframAlphaによるPearsonのχ²検定のP値の計算の仕方-1.7.1"><span class="toc-item-num">1.7.1&nbsp;&nbsp;</span>WolframAlphaによるPearsonのχ²検定のP値の計算の仕方</a></span></li><li><span><a href="#Julia言語によるPearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算の仕方(1)" data-toc-modified-id="Julia言語によるPearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算の仕方(1)-1.7.2"><span class="toc-item-num">1.7.2&nbsp;&nbsp;</span>Julia言語によるPearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算の仕方(1)</a></span></li><li><span><a href="#Julia言語によるPearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算の仕方(2)" data-toc-modified-id="Julia言語によるPearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算の仕方(2)-1.7.3"><span class="toc-item-num">1.7.3&nbsp;&nbsp;</span>Julia言語によるPearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算の仕方(2)</a></span></li><li><span><a href="#R言語によるPearsonのχ²検定のP値の計算の仕方" data-toc-modified-id="R言語によるPearsonのχ²検定のP値の計算の仕方-1.7.4"><span class="toc-item-num">1.7.4&nbsp;&nbsp;</span>R言語によるPearsonのχ²検定のP値の計算の仕方</a></span></li></ul></li><li><span><a href="#ニューサンスパラメータの問題に関する注意" data-toc-modified-id="ニューサンスパラメータの問題に関する注意-1.8"><span class="toc-item-num">1.8&nbsp;&nbsp;</span>ニューサンスパラメータの問題に関する注意</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using Base.Threads
using BenchmarkTools
using DataFrames
using Distributions
using LinearAlgebra
using Memoization
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

```julia
oddsratiohat(a, b, c, d) = safediv(a*d, b*c)
stderr_logoddsratiohat(a, b, c, d) = √(1/a + 1/b + 1/c + 1/d)

function confint_or_wald(a, b, c, d; α=0.05)
    z = quantile(Normal(), 1-α/2)
    ORhat = oddsratiohat(a, b, c, d)
    SElogORhat = stderr_logoddsratiohat(a, b, c, d)
    [exp(-z*SElogORhat)*ORhat, exp(z*SElogORhat)*ORhat]
end

function pvalue_or_wald(a, b, c, d, ω=1)
    logORhat = log(oddsratiohat(a, b, c, d))
    SElogORhat = stderr_logoddsratiohat(a, b, c, d)
    2ccdf(Normal(0, 1), abs(log(ω) - logORhat)/SElogORhat)
end

function delta(a, b, c, d, ω=1)
    A, B, C = 1-ω, a+d+ω*(b+c), a*d-ω*b*c
    isinf(ω) ? typeof(ω)(-min(b, c)) : safediv(2C, B + √(B^2 - 4A*C))
end

# correction = 0.5 は連続性補正を与える.
function chisqstat(a, b, c, d, ω=1; correction=0.0)
    δ = delta(a, b, c, d, ω)
    â, b̂, ĉ, d̂ = a-δ, b+δ, c+δ, d-δ
    safemul(max(0, abs(δ)-correction)^2, 1/â+1/b̂+1/ĉ+1/d̂)
end

function pvalue_or_pearson(a, b, c, d, ω=1; correction=0.0)
    χ² = chisqstat(a, b, c, d, ω; correction)
    ccdf(Chisq(1), χ²)
end

function confint_or_pearson(a, b, c, d; α=0.05, correction=0.0)
    ω_L, ω_U = confint_or_wald(a, b, c, d; α)
    f(ω) = logit(pvalue_or_pearson(a, b, c, d, ω; correction)) - logit(α)
    [find_zero(f, ω_L), find_zero(f, ω_U)]
end
```

```julia
a, b, c, d = 49, 965, 26, 854
```

```julia
oddsratiohat(a, b, c, d)
```

```julia
[
    pvalue_or_wald(a, b, c, d, 1.1)
    pvalue_or_pearson(a, b, c, d, 1.1)
    pvalue_or_pearson(a, b, c, d, 1.1; correction=0.5)
]
```

```julia
[
    confint_or_wald(a, b, c, d),
    confint_or_pearson(a, b, c, d),
    confint_or_pearson(a, b, c, d; correction=0.5)
]
```

```julia
# cf. Cornfeild (1956), p.139, (4.2)
let (a, b, c, d) = (3, 11, 60, 32)
    [
        confint_or_wald(a, b, c, d),
        confint_or_pearson(a, b, c, d),
        confint_or_pearson(a, b, c, d; correction=0.5)
    ]
end
```

```julia
R"""
A = matrix(c(49, 965, 26, 854), 2, 2, byrow=T)
result = epiR::epi.2by2(A, digits=4, conf.level=0.95)
"""
```

```julia
@rget result
```

```julia
md = result[:massoc_detail]
```

```julia
ms = result[:massoc_summary]
```

## 比率の比較に関するP値と信頼区間


### 比率の比較に関するP値と信頼区間を使って行いたいこと

(1) ウェブページのデザインAとBではどちらの側がどれだけ商品が売れ易いかを知りたい. 

(2) 薬Xを処方した側ではしなかった側よりも快復者の割合がどれだけ増えるかを知りたい.

例えば, (1)の場合に次のようなデータが得られたとする:

$$
\begin{array}{c|c|c|c}
& \text{商品を購入した} & \text{購入しなかった} & \text{合計} \\
\hline
\text{デザインA} & 49   &  965 & 1014 \\
\hline
\text{デザインB} & 26   &  854 &  880 \\
\hline
\text{合計}      & 75   & 1819 & 1894 \\ 
\end{array}
$$

このデータの数値は, デザインAの側にアクセスした1014人中の49人が商品を購入し, デザインBの側にアクセスした880人中の26人が商品を購入したことを表している.

このデータの数値からの印象では, デザインAの方がデザインBの方が商品の購入確率が高いように見える. 実際, デザインAでの購入者割合は $49/1014 \approx 4.8\%$ 程度で, デザインBでの購入者割合の $26/880 \approx 3.0\%$ より大きい.

しかし, データの確率的揺らぎのせいで偶然に, デザインAの側がよく売れるように見えるデータの数値が得られただけなのかもしれない.  (実際には他にも様々な原因で偏ったデータが得られる場合がある.)

もしもそうならば, 上のデータに基くウェブページのデザイン採用に関する意思決定は無駄に終わることになってしまう.  だから, そのようなリスクの程度を見積もる必要がある.  そのための道具がP値や信頼区間である.  

このようなデータに適当な統計モデルを適用して, デザインAとデザインBでの購入確率の違いを信頼区間で表したい.

そのためには以下のようにすればよい:

1. 統計モデルの設定.
2. 購入確率の違いを表す指標を導入.
3. その指標の値が〇〇であるという仮説のP値を定義する.
4. そのP値を使って信頼区間を定義する.
5. 以上によって得られたP値函数や信頼区間を利用する.


### 2×2の分割表型データとその2つの二項分布モデル

このノートでは次の形の $2\times2$ の分割表型のデータを扱う:

$$
\begin{array}{c|c|c|c}
& Y = 1 & Y = 0 & \\
\hline
X = 1 & a & b & m = a+b \\
\hline
X = 0 & c & d & n = c+d \\
\hline
      & s = a+c & t = b+d & N=a+b+c+d \\ 
\end{array}
$$

ここで $a,b,c,d$ は $0$ 以上の整数である.

このノートでは2×2の分割表型データに関する以下のような設定の統計モデルを扱う. 

(1) 横方向の合計 $m=a+b$, $n=c+d$ (ゆえに全体の合計 $N=m+n$) は固定されていると仮定する.

(2) $a$ は成功確率パラメータ $p$ の二項分布に従っており, $c$ は成功確率パラメータ $q$ の二項分布に従っているとし, $a$, $c$ は独立であると仮定する.  $p$, $q$ を比率と呼ぶこともある.

このとき, $a,b,c,d$ の同時確率質量函数は次のように表される:

$$
\begin{aligned}
&
P(a,b,c,d|m,n,p,q) =
\binom{m}{a}p^a(1-p)^b \binom{n}{c}q^c(1-q)^d
\\ &
\qquad\qquad
(a,b,c,d\in\Z_{\ge 0},\; a+b=m,\; c+d=n).
\end{aligned}
$$

これを __2つの二項分布モデル__ と呼ぶ.

(3) このモデルは上の分割表において, 以下が成立しているという設定になっている:

* $X=1$ のときには $Y=1$ となる確率は $p$ である.
* $X=0$ のときには $Y=1$ となる確率は $q$ である.

そして, $X=1$ となる人達を $m$ 人選び, $X=0$ となる人を $n$ 人選んで $Y$ がどうなるかを調べた.

$X$, $Y$ として以下のような場合を想定している:

* $X=1,0$ はウェブページのデザインがA,Bのどちらであるかを意味し, $Y=1,0$ は商品を購入したかしないかを意味する.
* $X=1,0$ は薬Xを処方したか否かを意味し, $Y=1,0$ は快復したか否かを意味する.

__注意:__ このモデルの採用が妥当であるかどうかはデータの数値とは別の情報を使って判断しなければいけない.  例えば, 比較したい母集団とは異なる偏った母集団からの無作為抽出になってしまっている疑いが強い場合には, モデルを変更するか, データの取得の仕方を変更するか, どちらかの処置が必要になる.

__注意:__ 分割表の縦方向と横方向の役割を逆転させた場合も数学的には同様である.  ただし, データの分析結果の解釈では立場を交換したことによって違いが出るので注意すること.

__注意:__ 以上で説明した2つの二項分布モデル以外に, 多項分布(四項分布)モデルや4つのPoisson分布モデルも考えられるが, 以下では省略する.  実は統計モデルをそのように変更しても以下で説明するP値や信頼区間の計算の仕方はどれも同じになることが知られている.  2×2の分割表に関する統計モデルについては, [「条件付き確率分布, 尤度, 推定, 記述統計」のノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.ipynb)の「2×2の分割表の分布」の節を参照せよ.


### 比率の違いを表す2つの指標: オッズ比 OR とリスク比 RR

比率 $0<p<1$ に関する

$$
u = \frac{p}{1 - p}
$$

を __オッズ__(odds)と呼び, 2つの比率 $0<p<1$, $0<q<1$ に関する

$$
\OR = \frac{p/(1-p)}{q/(1-q)} = \frac{p(1-q)}{(1-p)q}
$$

を __オッズ比__(odds ratio, OR)と呼び, これの対数 $\beta$ を __対数オッズ比__ (log odds ratio)と呼ぶ:

$$
\log \OR = \log \frac{p(1-q)}{(1-p)q} =
\log\frac{p}{1-p} - \log\frac{q}{1-q}.
$$

さらにこのノートでは, 2つの比率 $0<p<1$, $0<q<1$ に関する

$$
\RR = \frac{p}{q}
$$

を __リスク比__(risk ratio, RR)と呼び, これの対数 $\gamma$ を __対数リスク比__ (log risk ratio)と呼ぶ:

$$
\log\RR = \log\frac{p}{q} = \log p - \log q.
$$

もしも, $p,q$ の両方が $0$ に近ければ, $1-p\approx 1$, $1-q\approx 1$ という近似を使えるので, リスク比はオッズ比で近似される:

$$
1-p\approx 1,\ 1-q\approx 1
\implies
\RR \approx \OR.
$$

比率 $p$ と $q$ が等しいという条件はオッズ比やリスク比を使って以下のように言い換えられる:

$$
p = q \iff \OR = 1 \iff \RR = 1.
$$

だから, $p$ と $q$ が等しいという仮説は $\OR=1$ や $\RR=1$ のように表現できる. (もちろん, それらの対数版である $\log\OR = 0$ や $\log\RR = 0$ を採用してもよい.)

そして, オッズ比 $\OR$ とリスク比 $\RR$ が $1$ からどれだけどのように離れているかは, 2つの比率 $p$, $q$ の違いを表す指標として使える.  (もちろん, それらの対数版である $\log\OR$ や $\log\RR$ が $0$ からどれだけどのように 離れているかを指標として採用してもよい.)

__注意:__ 他にも __比率の差__ $p - q$ も重要な指標だが, このノートでは面倒だという理由で扱わないことにする.

__注意:__ オッズは賭け事ではよく使われる用語である. 例えばある勝負で $A$ が勝つことに賭けるときに

$$
\text{勝つ確率} : \text{負ける確率} = 1 : 4
$$

だと思っているなら, あなたはオッズは「$1$ 対 $4$」だと思っていることになる.

__注意:__ 例えば確率 $p$, $q$ が「死亡確率」ならば「リスク」という呼び方は適切になる.  ここではそうでない場合も $p$, $q$ を「リスク」と呼んでしまい, $p/q$ を「リスク比」と呼ぶことにする.  具体的な応用先で, この呼び方に違和感を感じる場合には適宜別の呼び方をするようにして欲しい.

__注意:__ このノートでは主にオッズ比を比率の違いを表す指標として利用する.  その理由は. 応用上の理由ではなく, 単に数学的に扱いやすいからである. そして, 以下の注意で説明するように, オッズ比を考えることは, その対数を考えることによって, ロジスティック回帰の話とも関係付けることができる.

__注意:__ オッズ $u=p/(1-p)$ の対数を $x$ と書き, __対数オッズ__(log odds)と呼ぶ. このとき, 以下の公式によって $0<p<1$, $0<u<\infty$, $-\infty<x<\infty$ が一対一に対応する:

$$
\begin{aligned}
&
p = \frac{u}{1+u} = \frac{1}{1+e^{-x}} = \logistic(x),
\\ &
u = \frac{p}{1-p} = \exp(x), 
\\ &
x = \log(u) = \log \frac{p}{1-p} = \logit(p).
\end{aligned}
$$

$x$ を $p$ に対応させる函数は __ロジスティック函数__ と呼ばれ, その逆函数は __ロジット函数__ と呼ばれる. 

__注意:__ 対数オッズ比を $\beta = \log\OR$ と書き, さらに $q$ の対数を $\alpha=\log q$ と書くと, $p$, $q$ の対数オッズはそれぞれ次のように表される:

$$
\logit(p) = \log\frac{p}{1-p} = \alpha + \beta, \quad
\logit(q) = \log\frac{q}{1-p} = \alpha.
$$

これらは次と同値である:

$$
p = \logistic(\alpha + \beta), \quad
q = \logistic(\alpha).
$$

モデルの2つの比率パラメータ $p$, $q$ をこのように表して, データの数値から $\alpha, \beta$ の値を推定することを __ロジスティック回帰__ (logisti regression)と呼ぶ.  (実際にはもっと一般の場合もロジスティック回帰と呼ぶ.)

__注意:__ 対数リスク比を $\beta = \log\RR = \log p - \log q$ と書き, $q$ の対数を $\alpha=\log q$ と書くと, $p$, $q$ の対数はそれぞれ次のように表される:

$$
\log p = \alpha + \beta, \quad
\log q = \alpha.
$$

これは次と同値である:

$$
p = \exp(\alpha + \beta), \quad
q = \exp(\alpha).
$$

これと上の違いは $\logistic$ と $\exp$ の違いになっている.


### Wald版のオッズ比に関するP値と信頼区間の定義

__検定したい仮説:__ 検定したい仮説は

$$
\text{オッズ比は $\OR = \omega$ である.}
$$

であるとする.  ここで $\omega > 0$ は具体的な正の実数である.

__正規分布近似:__ 仮に $a,b,c,d$ が2つの二項分布モデルに従う確率変数ならば, それらの __オッズ比__

$$
\ORhat = \frac{a/b}{c/d} = \frac{ad}{bc}
$$

の対数 $\log\ORhat$ (対数オッズ比)は, 平均がモデルのパラメータの対数オッズ比

$$
\log\OR = \log\frac{p(1-q)}{(1-p)q}
$$

で, 分散が

$$
\SEhat^2 = \frac{1}{a} + \frac{1}{b} + \frac{1}{c} + \frac{1}{d}
$$

であるような正規分布に近似的に従うことを示せる.  ゆえに, 

$$
\frac{\log\ORhat - \log\OR}{\SEhat} \sim
\Normal(0,1),\ \text{approximately}.
$$

([「大数の法則と中心極限定理」のノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/05%20Central%20limit%20theorem.ipynb)で解説したデルタ法を使えば示せる.)

__P値の構成法:__ 上の近似を使えば, 「オッズ比は $\OR = \omega$ である」という仮説のP値を次のように定めることができる:

$$
\pvalue_{\Wald}(a, b, c, d|\OR=\omega) =
2\left(1 - \cdf\left(\Normal(0,1), \frac{\widehat{\OR} - \omega}{\widehat{\SE}}\right)\right)
$$

ただし, $\log\ORhat$ と $\SEhat$ はデータの数値 $a,b,c,d$ から上で示した式で計算された値であるとする.

__対応する信頼区間:__ このP値の定義に対応するオッズ比 $\OR$ に関する信頼度 $1-\alpha$ の信頼区間は次のようになる:

$$
\confint^{\log\OR}_{\Wald}(a, b, c, d|\alpha) =
\left[
\ORhat - z_{\alpha/2}\SEhat,\;
\ORhat + z_{\alpha/2}\SEhat
\right]
$$

対応するオッズ比 $\OR$ の信頼区間は次のようになる:

$$
\confint^{\OR}_{\Wald}(a, b, c, d|\alpha) =
\left[
\exp\left(-z_{\alpha/2}\SEhat\right)\ORhat,\;
\exp\left( z_{\alpha/2}\SEhat\right)\ORhat
\right]
$$

ここで, $z_{\alpha/2} = \quantile(\Normal(0,1), 1-\alpha/2)$ である.


### Wald版のオッズ比に関するP値と信頼区間の計算例

データが次の場合のWald版の仮説「オッズ比は $\OR=1$ である」のP値とオッズ比 $\OR$ の $95\%$ 信頼区間を計算してみよう:

$$
\begin{array}{c|c|c|c}
& \text{商品を購入した} & \text{購入しなかった} & \text{合計} \\
\hline
\text{デザインA} & 49   &  965 & 1014 \\
\hline
\text{デザインB} & 26   &  854 &  880 \\
\hline
\text{合計}      & 75   & 1819 & 1894 \\ 
\end{array}
$$

結果は次のようになる:

* (Wald版の仮説「オッズ比は $\OR=1$ である」のP値) ≈ 3.847%
* (Wald版のオッズ比 $\OR$ の $95\%$ 信頼区間) ≈ \[1.0275, 2.7072\]


#### WolframAlphaによるWald版のP値と信頼区間の計算の仕方

`sqrt(1/a+1/b+1/c+1/d) where a=49.0, b=965, c=26, d=854` → [実行](https://www.wolframalpha.com/input?i=sqrt%281%2Fa%2B1%2Fb%2B1%2Fc%2B1%2Fd%29+where+a%3D49.0%2C+b%3D965%2C+c%3D26%2C+d%3D854) → 0.247137

`log(a*d/(b*c))/0.247137 where a=49.0, b=965, c=26, d=854` → [実行](https://www.wolframalpha.com/input?i=log%28a*d%2F%28b*c%29%29%2F0.247137+where+a%3D49.0%2C+b%3D965%2C+c%3D26%2C+d%3D854) → 2.06981

`2(1 - cdf(NormalDistrubution(0,1), 2.06981))` → [実行](https://www.wolframalpha.com/input?i=2%281+-+cdf%28NormalDistrubution%280%2C1%29%2C+2.06981%29%29) → 0.0384701 (P値)

`quantile(NormalDistribution(0,1), 0.975))` → [実行](https://www.wolframalpha.com/input?i=quantile%28NormalDistribution%280%2C1%29%2C+0.975%29) → 1.95996

`{exp(-0.247137z)*a*d/(b*c), exp(0.247137z)*a*d/(b*c)} where a=49.0, b=965, c=26, d=854, z=1.95996` → [実行](https://www.wolframalpha.com/input?i=%7Bexp%28-0.247137z%29*a*d%2F%28b*c%29%2C+exp%280.247137z%29*a*d%2F%28b*c%29%7D+where+a%3D49.0%2C+b%3D965%2C+c%3D26%2C+d%3D854%2C+z%3D1.95996) → {1.02752, 2.70717} (95%信頼区間)


#### Julia言語によるWald版のP値と信頼区間の計算の仕方(1)

素朴に定義通りにコードを入力すれば計算できる.

```julia
a, b, c, d = 49, 965, 26, 854
@show a, b, c, d
ω = 1.0
@show ω
@show ORhat = a*d/(b*c)
@show SEhat = √(1/a + 1/b + 1/c + 1/d)
@show pvalue = 2ccdf(Normal(), abs(log(ORhat) - log(ω))/SEhat)
α = 0.05
@show α
@show z = quantile(Normal(), 1-α/2)
@show confint = [exp(-z*SEhat)*ORhat, exp(z*SEhat)*ORhat]
;
```

#### Julia言語によるWald版のP値と信頼区間の計算の仕方(2)

このノートブックの最初の方で定義した函数を使って計算.

```julia
a, b, c, d = 49, 965, 26, 854
@show a, b, c, d
@show pvalue_or_wald(a, b, c, d, 1)
@show confint_or_wald(a, b, c, d; α=0.05);
```

<!-- #region -->
#### R言語での計算の仕方

定義通りにコードを入力すれば計算できる.

```R
a = 49
b = 965
c = 26
d = 854
omega = 1
ORhat = a*d/(b*c)
SEhat = sqrt(1/a + 1/b + 1/c + 1/d)
p.value = 2*(1 - pnorm(abs(log(ORhat) - log(omega))/SEhat))
alpha = 0.05
z = qnorm(1 - alpha/2)
conf.int = c(exp(-z*SEhat)*ORhat, exp(z*SEhat)*ORhat)

cat("data: a b c d = ", a, b, c, d, "\n")
cat("null hypothesis: OR = ", omega, "\n")
cat("ORhat = ", ORhat, "\n")
cat("SEhat = ", SEhat, "\n")
cat("p.value = ", p.value, "\n")
cat("conf.level = ", 1 - alpha, "\n")
cat("conf.int = ", conf.int, "\n")
```
<!-- #endregion -->

```julia
R"""
a = 49
b = 965
c = 26
d = 854
omega = 1
ORhat = a*d/(b*c)
SEhat = sqrt(1/a + 1/b + 1/c + 1/d)
p.value = 2*(1 - pnorm(abs(log(ORhat) - log(omega))/SEhat))
alpha = 0.05
z = qnorm(1 - alpha/2)
conf.int = c(exp(-z*SEhat)*ORhat, exp(z*SEhat)*ORhat)

cat("data: a b c d = ", a, b, c, d, "\n")
cat("null hypothesis: OR = ", omega, "\n")
cat("ORhat = ", ORhat, "\n")
cat("SEhat = ", SEhat, "\n")
cat("p.value = ", p.value, "\n")
cat("conf.level = ", 1 - alpha, "\n")
cat("conf.int = ", conf.int, "\n")
""";
```

<!-- #region -->
$95\%$ 信頼区間はepiR パッケージを使えば

```R
A = matrix(c(49, 965, 26, 854), 2, 2, byrow=T)
result = epiR::epi.2by2(A, digits=4, conf.level=0.95)
```

で計算できる. 色々表示されるが,

```
Odds ratio                                     1.6678 (1.0275, 2.7072)
```

の行の括弧の内側にWald版の信頼区間が表示されている.
<!-- #endregion -->

```julia
R"""
A = matrix(c(49, 965, 26, 854), 2, 2, byrow=T)
result = epiR::epi.2by2(A, digits=4, conf.level=0.95)
"""
```

<!-- #region -->
### Pearsonのχ²検定版のオッズ比に関するP値と信頼区間の定義

天下り的になってしまい非常に申し訳ないのだが, オッズ比の値に関する仮説のP値のPearsonのχ²検定版を以下のように定義する.  特にP値の構成法の(1)の段階がひどく天下り的である.  しかし, それ以外の部分については計算の筋道を詳しく書いておくので, 自分の手で計算して確認して欲しい.

そして, さらに, それだけだとどういうことなのか分かりにくいので, 後の方で示す具体的な数値の計算例と以下で説明する各ステップの対応を繰り返し確認して欲しい.

__検定したい仮説:__ 検定したい仮説は

$$
\text{オッズ比は $\OR = \omega$ である.}
$$

であるとする.  ここで $\omega > 0$ は具体的な正の実数である.

仮説が $\OR = 1$ である場合に, 以下で定義するP値はちょうど __独立性に関するPearsonのχ²検定__ で使うP値になっている.

__P値の構成法:__ オッズ比の値に関する仮説のP値のPearsonのχ²検定版の構成法は以下の通り.

(1) 分割表のデータの数値 $a,b,c,d$ に対して, 次を満たす $\delta$ を求める:

$$
\frac{(a-\delta)(d-\delta)}{(b+\delta)(c+\delta)} = \omega,
\quad -\min(b,c) \le \delta \le \min(a,d).
$$

これの左側の等式は

$$
A = 1 - \omega, \quad
B = a + d + \omega(b + c), \quad
C = ad - \omega bc
$$

とおくと, 次のように書き直される:

$$
A \delta^2 - B \delta + C = 0.
$$

これの解で $-\min(b,c) \le \delta \le \min(a,d)$ を満たす側が欲しい $\delta$ である. それは次のように表される:

$$
\delta = \frac{2C}{B + \sqrt{B^2 - 4AC}}.
$$

この表示で浮動小数点数の計算をした方が安全でかつ誤差も小さくなり易い.

特に $\omega = 1$ の場合(独立性検定の場合)には, $\delta$ を決める方程式は $-(a+b+c+d)\delta + ad-bc=0$ になるので,

$$
\omega = 1 \implies \delta = \frac{ad-bc}{a+b+c+d} = \frac{ad-bc}{N}.
$$

(2) $\ha,\hb,\hc,\hd$ を次のように定める:

$$
\ha = a - \delta, \quad
\hb = b + \delta, \quad
\hc = c + \delta, \quad
\hd = d - \delta.
$$

これが実は仮説 $\OR=1$ 下での期待値の最尤推定値になっていることを後の方の節で説明する.

特に $\omega = 1$ の場合(独立性検定の場合)には次のようになっている:

$$
\omega = 1 \implies
\begin{cases}
\;
\ha = \dfrac{(a+b)(a+c)}{N} = \dfrac{ms}{N}, &
\hb = \dfrac{(a+b)(b+d)}{N} = \dfrac{mr}{N},
\\ \;
\hc = \dfrac{(c+d)(a+c)}{N} = \dfrac{ns}{N}, &
\hd = \dfrac{(c+d)(b+d)}{N} = \dfrac{nr}{N}.
\end{cases}
$$

(3) データの数値に対応するPearsonのχ²統計量 $\chi^2$ の値を次のように定める:

$$
\begin{aligned}
\chi^2 &=
\frac{(a - \ha)^2}{\ha} +
\frac{(b - \hb)^2}{\hb} +
\frac{(c - \hc)^2}{\hc} +
\frac{(d - \hd)^2}{\hd}
\\ &=
\delta^2
\left(\frac{1}{\ha}+\frac{1}{\hb}+\frac{1}{\hc}+\frac{1}{\hd}\right).
\end{aligned}
$$

この $\chi^2$ は $a,b,c,d,\omega$ のみを使って計算できる数値になっている.

上の $\chi^2$ に関する前者の式はPearsonのχ²統計量の一般的な表式

$$
\chi^2 =
\sum \frac{((観測値) - (帰無仮説下のモデル内での期待値))^2}{(帰無仮説下のモデル内での期待値)}
$$

の特別な場合になっていることに注意せよ. 帰無仮説下のモデル内での期待値は最尤推定値として求めたものになっている.


特に $\omega = 1$ の場合(独立性検定の場合)には次のようになっている:

$$
\chi^2 = \frac{N(ad-bc)^2}{(a+b)(c+d)(a+c)(b+d)} =
\frac{N(ad-bc)^2}{mnrs}
$$

これは独立性に関するPearsonのχ²統計量の公式として有名である.

(4) 仮説 $\OR = \omega$ の下での統計モデル内で同様に定義されたPearsonのχ²統計量の値がデータから計算した $\chi^2$ の値以上になる確率の近似値としてP値を定義したい.  (一般にP値は, 統計モデル内でデータの数値以上に極端な場合が生じる確率またはその近似値として定義されるのであった.)

仮に $a,b,c,d$ が現実から得たデータの数値ではなく, 仮説 $\OR = \omega$ の下での統計モデル内でランダムに生成された仮想的なデータであるとき, (3)のように定義された $\chi^2$ は $a,b,c,d$ が十分に大きなとき(実はそう大きくなくてもよい), 近似的に自由度 $1$ のχ²分布に従うことを示せる.

このことを使って, 仮説 $\OR = \omega$ のP値を次のように定義する:

$$
\pvalue_{\Pearson}(a,b,c,d|\OR=\omega) =
1 - \cdf(\Chisq(1), \chi^2).
$$

仮説 $\OR = \omega$ に関するデータの数値 $a,b,c,d$ に関するPearsonのχ²統計量の値 $\chi^2$ は $a,b,c,d,\omega$ だけで計算される値なので, これでP値がうまく定義されている.

__対応する信頼区間:__ このP値の定義に対応するオッズ比 $\OR$ の信頼度 $1-\alpha$ の信頼区間は次のように定義される:

$$
\confint^{\OR}_{\Pearson}(a,b,c,d|\alpha) = 
\{\, \omega > 0 \mid \pvalue_{\Pearson}(a,b,c,d|\OR=\omega) \ge \alpha\,\}.
$$

この信頼区間を計算するために使えるシンプルな公式はないように思われる.  このノートでは、$\pvalue_{\Pearson}(a,b,c,d|\OR=\omega) = \alpha$ を満たす $\omega$ を数値的に求めることによって信頼区間を計算している.

__文献:__ この節の構成は次の論文に書いてある方法の連続補正無し版になっている:

* Jerome Cornfield, A Statistical Problem Arising from Retrospective Studies, Berkeley Symposium on Mathematical Statistics and Probability, 1956: 135-148 (1956)  [link](https://projecteuclid.org/ebooks/berkeley-symposium-on-mathematical-statistics-and-probability/Proceedings%20of%20the%20Third%20Berkeley%20Symposium%20on%20Mathematical%20Statistics%20and%20Probability,%20Volume%204:%20Contributions%20to%20Biology%20and%20Problems%20of%20Health/chapter/A%20Statistical%20Problem%20Arising%20from%20Retrospective%20Studies/bsmsp/1200502552)
<!-- #endregion -->

### Pearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算例

データが次の場合のPearsonのχ²検定版仮説「オッズ比は $\OR=1$ である」のP値とオッズ比 $\OR$ の $95\%$ 信頼区間を計算してみよう:

$$
\begin{array}{c|c|c|c}
& \text{商品を購入した} & \text{購入しなかった} & \text{合計} \\
\hline
\text{デザインA} & 49   &  965 & 1014 \\
\hline
\text{デザインB} & 26   &  854 &  880 \\
\hline
\text{合計}      & 75   & 1819 & 1894 \\ 
\end{array}
$$

結果は次のようになる:

* (Pearsonのχ²検定版の仮説「オッズ比は $\OR=1$ である」のP値) ≈ 3.661%
* (Pearsonのχ²検定版のオッズ比 $\OR$ の $95\%$ 信頼区間) ≈ \[1.0318, 2.6957\]

信頼区間ついてはJulia言語版の計算例のみを示す.  WolframAlphaでこの信頼区間を求めることはかなり面倒である.


#### WolframAlphaによるPearsonのχ²検定のP値の計算の仕方

$\omega = 1$ の場合には, Pearsonのχ²統計量は,

$$
\chi^2 = \frac{(a+b+c+d)(ad-bc)^2}{(a+b)(c+d)(a+c)(b+d)}
$$

となるのであった. これを用いてP値を計算してみよう.

`(a+b+c+d)(ad-bc)^2/((a+b)(c+d)(a+c)(b+d)) where a=49.0, b=965, c=26, d=854` → [実行](https://www.wolframalpha.com/input?i=%28a%2Bb%2Bc%2Bd%29%28ad-bc%29%5E2%2F%28%28a%2Bb%29%28c%2Bd%29%28a%2Bc%29%28b%2Bd%29%29+where+a%3D49.0%2C+b%3D965%2C+c%3D26%2C+d%3D854) → 4.36824 (独立性に関するPearsonのχ²統計量)

`1 - cdf(ChisqDistribution(1), 4.36824)` → [実行](https://www.wolframalpha.com/input?i=1+-+cdf%28ChisqDistribution%281%29%2C+4.36824%29) → 0.0366148 (P値)


#### Julia言語によるPearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算の仕方(1)

$\omega = 1$ の場合のPearsonのχ²検定版のオッズ比に関するP値は, 独立性に関するPearsonのχ²検定のP値そのものになる.  それを上でやったのと同じ方法で計算する.

信頼区間の側は函数の零点を見つけてくれる函数を使って求めてみよう.

```julia
a, b, c, d = 49, 965, 26, 854
@show a, b, c, d
χ² = (a+b+c+d)*(a*d-b*c)^2/((a+b)*(c+d)*(a+c)*(b+d))
@show χ²
@show pvalue = ccdf(Chisq(1), χ²)
α = 0.05
@show α
confint = find_zeros(0.5, 3.0) do ω
    A, B, C = 1-ω, a+d+ω*(b+c), a*d-ω*b*c
    δ = 2C/(B + √(B^2 - 4A*C))
    χ² = δ^2 * (1/(a-δ) + 1/(b+δ) + 1/(c+δ) + 1/(d-δ))
    ccdf(Chisq(1), χ²) - α
end
@show confint;
```

`f(x, y) do z ... end` 構文については

* https://docs.julialang.org/en/v1/manual/functions/#Do-Block-Syntax-for-Function-Arguments

を参照せよ.  `find_zeros` 函数の使い方については,

* https://juliamath.github.io/Roots.jl/stable/#Basic-usage

を参照せよ.


#### Julia言語によるPearsonのχ²検定版のオッズ比に関するP値と信頼区間の計算の仕方(2)

このノートブックの最初の方で定義した函数を使って計算.

```julia
a, b, c, d = 49, 965, 26, 854
@show a, b, c, d
@show chisqstat(a, b, c, d, 1)
@show pvalue_or_pearson(a, b, c, d, 1)
@show confint_or_pearson(a, b, c, d; α=0.05);
```

<!-- #region -->
#### R言語によるPearsonのχ²検定のP値の計算の仕方

独立性に関するPearsonのχ²検定のP値は次のようにして計算できる.

```R
A = matrix(c(49, 965, 26, 854), 2, 2, byrow=T)
result = chisq.test(A, correct=F)
```
<!-- #endregion -->

```julia
R"""
A = matrix(c(49, 965, 26, 854), 2, 2, byrow=T)
result = chisq.test(A, correct=F)
"""
```

### ニューサンスパラメータの問題に関する注意

我々が想定している統計モデルには $p$ と $q$ という2つのパラメータが含まれている. そこに仮説 $\OR = \omega$ によって制限を課しても, 独立なパラメータの個数は1つしか減らず, たとえば $q$ の側を自由に動けるパラメータとして採用し, 仮説 $\OR=\omega$ によって $p$ の値は $q$ の値から決まると考えることができる. 

だから, P値を定義するために必要な「仮説 $\OR = \omega$ の下での統計モデル内でデータの数値以上に極端な値が生じる確率」は, パラメータ $q$ の値を決めるごとに別々に決まる値になってしまう.  このような状況のとき, $q$ はニューサンスパラメータ(nuisance parameters, 局外パラメータ, 攪乱パラメータ, 迷惑パラメータ)であるという.

しかし, 「データの数値以上に極端な値」の意味を, Wald的な正規分布近似を使ったり, Pearsonのχ²統計量を使ったりして定義すれば, 「仮説 $\OR = \omega$ の下での統計モデル内でデータの数値以上に極端な値が生じる確率」が, $a,b,c,d$ が十分に大きなとき, 近似的にパラメータ $q$ の値によらなくなることを示せる.

以上で紹介したP値の定義にはこのような非常に巧妙な方法が使われている.

ニューサンスパラメータの問題への対処の仕方にはそれら以外にも, 以下の節で説明する条件付き確率分布を利用する方法がある. その方法による検定は __Fisher検定__ と呼ばれている.

```julia

```
