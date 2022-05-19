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

# 条件付き確率分布, 尤度, 推定, 記述統計

* 黒木玄
* 2022-05-18
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
<div class="toc"><ul class="toc-item"><li><span><a href="#条件付き確率分布" data-toc-modified-id="条件付き確率分布-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>条件付き確率分布</a></span><ul class="toc-item"><li><span><a href="#離散確率分布の条件付き確率分布" data-toc-modified-id="離散確率分布の条件付き確率分布-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>離散確率分布の条件付き確率分布</a></span></li><li><span><a href="#離散分布の条件付き確率分布の簡単な例" data-toc-modified-id="離散分布の条件付き確率分布の簡単な例-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>離散分布の条件付き確率分布の簡単な例</a></span></li><li><span><a href="#問題:-離散分布の条件付き確率分布として二項分布が得られること" data-toc-modified-id="問題:-離散分布の条件付き確率分布として二項分布が得られること-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>問題: 離散分布の条件付き確率分布として二項分布が得られること</a></span></li><li><span><a href="#離散分布の場合のBayesの定理" data-toc-modified-id="離散分布の場合のBayesの定理-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>離散分布の場合のBayesの定理</a></span></li><li><span><a href="#2×2の分割表での条件付き確率分布(偽陽性率,-偽陰性率)" data-toc-modified-id="2×2の分割表での条件付き確率分布(偽陽性率,-偽陰性率)-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span>2×2の分割表での条件付き確率分布(偽陽性率, 偽陰性率)</a></span></li><li><span><a href="#必修の易しい計算問題:-有病率によって偽陽性率と偽陰性率がどのように変化するか" data-toc-modified-id="必修の易しい計算問題:-有病率によって偽陽性率と偽陰性率がどのように変化するか-1.6"><span class="toc-item-num">1.6&nbsp;&nbsp;</span>必修の易しい計算問題: 有病率によって偽陽性率と偽陰性率がどのように変化するか</a></span></li></ul></li><li><span><a href="#尤度" data-toc-modified-id="尤度-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>尤度</a></span></li><li><span><a href="#推定" data-toc-modified-id="推定-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>推定</a></span></li><li><span><a href="#記述統計-(要約統計)" data-toc-modified-id="記述統計-(要約統計)-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>記述統計 (要約統計)</a></span></li></ul></div>
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
x ⪅ y = x < y || x ≈ y

mypdf(dist, x) = pdf(dist, x)
mypdf(dist::DiscreteUnivariateDistribution, x) = pdf(dist, round(x))

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

## 条件付き確率分布

我々は複雑な現実世界に立ち向かうために, 各種の確率分布を数学的モデル(統計モデル)として採用して, モデルとデータを比較することによって, 現実世界の様子を推測しようとする.

そのときに, 統計モデル内部に現実世界で得たデータの数値を持ち込んで利用する方法として,

* 条件付き確率分布を考えること.  統計モデル(数学的フィクション)内部で現実世界から得たデータと同じ数値が生成された場合に制限した条件付き確率分布を考える.
* 尤度を考えること.  統計モデル(数学的フィクション)内部で現実世界から得たデータと同じ数値が生成される確率またはその密度を考える.

の2つが特に基本的である.

以下では前者の条件付き確率分布の概念について一般的に説明する.


### 離散確率分布の条件付き確率分布

離散集合 $\X$ (大文字のグザイ)の中を動く離散変数 $x$ とその確率質量函数 $P(x)$ によって, 離散確率分布 $D$ が与えられているとする. (注意: $x$ は $(x_1,\ldots,x_n)$ のように多変数を1つにまとめて書いたものかもしれない. その場合には $\Xi$ は $\R^n$ の離散部分集合であると考える.)

集合 $\Xi$ 上の函数 $y=f(x)$ が与えられたとき, 確率変数 $Y=f(X)$ が得られる. この $Y$ の函数の期待値は

$$
E[g(Y)] = \sum_{x\in\X} g(f(x)) P(x)
$$

と定義される.  (確率変数とはその函数の期待値が定義されているような変数とみなせるのであった.)

数値 $y$ について, $P(Y=y) > 0$ であると仮定する.

条件 $Y=y$ (もしくは条件 $f(x)=y$)が定める __条件付き確率分布__ (conditional probability distribution) $D|_{Y=y}$ を以下のように定める:

(1) 条件付き確率分布 $D|_{Y=y}$ は離散集合 $\X_y = \{\,x\in\X\mid f(x)=y\,\}$ 上の確率分布である.

(2) 条件付き確率分布 $D|_{Y=y}$ は確率質量函数

$$
P(x|y) = \frac{P(x)}{P(Y=y)}, \quad P(Y=y) = \sum_{f(x)=y}P(x) = \sum_{x\in\X_y}P(x)
$$

によって定義される.  このとき,

$$
\sum_{x\in\X_y} P(x|y) =
\frac{\sum_{x\in\X_y} P(x)}{P(Y=y)} = 1
$$

なので確かにこの確率質量函数は「確率の総和が1になる」という条件を満たしており, 確率分布を定める.


### 離散分布の条件付き確率分布の簡単な例

正二十面体のサイコロの20個の面のうち $6$ つの面には1と書いてあり, 5つの面には2と書いてあり, 4つの面には3と書いてあり, 3つの面には4と書いてあり, 残りの2つの面には5と書いてあるとする. そのサイコロをふったときにすべての面は等確率で出るとする. このサイコロの出目の確率分布は

$$
P(1) = \frac{6}{20}, \quad
P(2) = \frac{5}{20}, \quad
P(3) = \frac{4}{20}, \quad
P(4) = \frac{3}{20}, \quad
P(5) = \frac{2}{20}
$$

によって定まる集合 $\X = \{1,2,3,4,5\}$ 上の有限離散分布によってモデル化される.

$\X$ 上の函数 $f(x)$ を $x$ が偶数ならば $f(x)=0$, 奇数ならば $f(x)=1$ と定める.

このとき, 確率変数 $Y=f(X)$ に関する条件付き確率分布を求めてみよう. 

この場合の $\X_y = \{\,x\in\X\mid f(x)=y\,\}$ は次のようになる:

$$
\X_0 = \{2,4\}, \quad
\X_1 = \{1,2,3\}.
$$

さらに,

$$
P(Y=0) = P(2)+P(4) = \frac{8}{20}, \quad
P(Y=1) = P(1)+P(3)+P(5) = \frac{12}{20}
$$

となる.  ゆえに, $P(x|0)$ ($x\in\X_0$) は

$$
\begin{aligned}
&
P(2|0) = \frac{P(2)}{P(Y=0)} = \frac{5/20}{8/20} = \frac{5}{8}, \\ &
P(4|0) = \frac{P(4)}{P(Y=0)} = \frac{3/20}{8/20} = \frac{3}{8}
\end{aligned}
$$

となり, $P(x|1)$ ($x\in\X_1$) は

$$
\begin{aligned}
&
P(1|0) = \frac{P(1)}{P(Y=1)} = \frac{6/20}{12/20} = \frac{6}{12}, \\ &
P(2|0) = \frac{P(3)}{P(Y=1)} = \frac{4/20}{12/20} = \frac{4}{12}, \\ &
P(3|0) = \frac{P(5)}{P(Y=1)} = \frac{2/20}{12/20} = \frac{2}{12}.
\end{aligned}
$$

となる. 偶数の目は2,4の2通りで20面のうち8面に2,4と書かれており, そのうちの5面が2で残りの3面が4なので, 偶数の目に制限した場合に2の目が出る条件付き確率は $P(2|0)=5/8$ になり, 4の目が出る条件付き確率は $P(4|0)=3/8$ になる. 奇数の目の場合も同様である.


### 問題: 離散分布の条件付き確率分布として二項分布が得られること

2つの0以上の整数の組 $(x,y)$ 全体の集合 $\X = \Z_{\ge 0}^2 = \{\,(x,y)\mid x,y=0,1,2,\ldots\,\}$ 上の確率質量函数を次のようにPoisson分布の確率質量函数の積で定める($\lambda,\mu>0$ と仮定する):

$$
P(x,y) = e^{-(\lambda+\mu)}\frac{\lambda^x}{x!}\frac{\mu^y}{y!}
\quad (x,y=0,1,2,\ldots)
$$

集合 $\X$ 上の函数 $f(x,y)$ を $f(x,y)=x+y$ と定める. $N = f(X, Y)$ によって確率変数 $N$ を定めることができる. $N$ の函数の期待値は次のように表される:

$$
E[g(N)] = \sum_{(x,y)\in\X} g(x+y)P(x,y).
$$

以下を示せ:

(1) $N$ は平均 $\lambda+\mu$ のPoisson分布に従う.

(2) $n$ が $0$ 以上の整数であるとき, この場合に条件 $N=n$ が定める条件付き確率分布は本質的に二項分布になる.

__解答例:__ $\X_n = \{\,(x,y)\in\X\mid f(x,y)=x+y=n\,\}$, $P(N=n)$, $P(x,y|n) = P(x,y)/P(N=n)$ ($(x,y\in\X_n$) を順番に計算して行こう. まず, 

$$
\X_n =\{\,(x,n-x)\mid x=0,1,2,\ldots,n\}
$$

であることはすぐにわかる.  次に,

$$
\begin{aligned}
P(N=n) &= \sum_{(x,y)\in\X_n} P(x,y) =
\sum_{x=0}^n e^{-(\lambda+\mu)}\frac{\lambda^x}{x!}\frac{\mu^{n-x}}{(n-x)!}
\\ &=
e^{-(\lambda+\mu)}\frac{1}{n!} \sum_{x=0}^n \frac{n!}{x!(n-x)!} \lambda^x \mu^{n-x} =
e^{-(\lambda+\mu)}\frac{(\lambda+\mu)^n}{n!}.
\end{aligned}
$$

これは確率変数 $N$ が平均 $\lambda+\mu$ のPoisson分布 $\op{Poisson}(\lambda+\mu)$ に従うことを意味し, (1)が示された.  したがって, $(x, n-x)\in\X_n$ のとき,

$$
\begin{aligned}
P(x,n-x|n) &=
\frac{P(x,n-x)}{P(N=n)} =
\frac
{e^{-(\lambda+\mu)}(\lambda^x/x!)(\mu^{n-x}/(n-x)!)}
{e^{-(\lambda+\mu)}(\lambda+\mu)^n/n!}
\\ &=
\frac{n!}{x!(n-x)!}
\left(\frac{\lambda}{\lambda+\mu}\right)^x
\left(\frac{\mu}{\lambda+\mu}\right)^{n-x}
\\ &=
\frac{n!}{x!(n-x)!}
\left(\frac{\lambda}{\lambda+\mu}\right)^x
\left(1 - \frac{\lambda}{\lambda+\mu}\right)^{n-x}.
\end{aligned}
$$

これは条件 $N=n$ が定める条件付き確率分布が本質的に二項分布 $\op{Binomial}(n, \lambda/(\lambda+\mu))$ であることを意味している.  これで(2)も示された.

__解答終__


### 離散分布の場合のBayesの定理

条件付き確率分布の概念を理解していれば, Bayesの定理(ベイズの定理)については忘れてもよい. しかし, Bayesの定理という用語が使われる頻度は高いので念のために説明しておくことにする.

離散集合 $\X=\{(x,y)\}$ 上の離散確率分布が確率質量函数 $P(x,y)$ によって定義されているとする. 以下では $P(X=x)$ や $P(Y=y)$ を以下のように書くことにする:

$$
P(x) = P(X=x) = \sum_y P(x,y),
\quad
P(y) = P(Y=y) = \sum_x P(x,y).
$$

このとき, $y$ に対応する確率変数 $Y$ によって $Y=y$ という条件で定義される条件付き確率分布の確率質量函数

$$
P(x|y) = \frac{P(x,y)}{P(y)}, \quad
P(y) = \sum_x P(x,y)
\tag{1}
$$

だけではなく, $x$ に対応する確率変数 $X$ によって $X=x$ という条件で定義される条件付き確率分布の確率質量函数

$$
P(y|x) = \frac{P(x,y)}{P(x)}, \quad
P(x) = \sum_y P(x,y)
\tag{2}
$$

が定義される.  このとき

$$
\begin{aligned}
&
P(x,y) = P(x|y)P(y) = P(y|x)P(x),
\\ &
P(x) = \sum_y P(x, y) = \sum_y P(x|y)P(y),
\\ &
P(y) = \sum_x P(x, y) = \sum_x P(y|x)P(x)
\end{aligned}
\tag{3}
$$

なので,

$$
\begin{aligned}
&
P(y|x) = \frac{P(x|y)P(y)}{\sum_y P(x|y)P(y)}, 
\\ &
P(x|y) = \frac{P(y|x)P(x)}{\sum_x P(y|x)P(x)}.
\end{aligned}
\tag{B}
$$

この結果(B)を __Bayesの定理__ (ベイズの定理)と呼ぶ.

しかし, 以上の議論を見ればわかるように, Bayesの定理は条件付き確率分布の定義を書き直したものに過ぎず, 価値ある新しい考え方が得られるような結果ではない.  しかし, 具体的もしくは理論的な計算で条件付き確率の概念が(B)の形式で使われることがあることは知っておいて損がないと思われるので, このように紹介することにした.

__注意:__ 多くの初学者はBayesの定理を「与えられた公式」として直接使う計算を直観的に理解できないことをやってしまっているという理由でよく間違ってしまうようだ. そのようになってしまいそうな人は無理して(B)の公式を直接使おうとせずに, (1),(2)(および(3))まで戻って地道に計算するようにした方がよいだろう.

__注意:__ 以上のようにBayesの定理は条件付き確率の定義から自明に導かれる無理して使う必要がない公式に過ぎない. そのような自明でつまらない結果について, 「逆確率」「主観確率」のような用語を用いて特別な価値があるかのように説明するスタイルが伝統的になってしまっているので惑わされないように注意が必要である.　Bayesの定理は, 条件付き確率の定義を書き直しただけの, 「逆確率」「主観確率」のような用語と無関係に一般的かつ普遍的に成立している自明な数学的定理に過ぎない.

__注意:__ 所謂Bayes統計についても条件付き確率分布の概念まで戻って考えればBayesの定理を使わずに理解可能である.


### 2×2の分割表での条件付き確率分布(偽陽性率, 偽陰性率)

病気Dに罹っているいるかどうかに関するある検査法を使うと,

* 病気Dに罹っている人は $75\%$ の確率で陽性だと判定でき,
* 病気Dに罹っていない人は $95\%$ の確率で陰性と判定できるもの

と仮定する. このとき, この検査法の __感度__ は $75\%$ であり, __特異度__ は $95\%$ であるという. 

この検査を病気Dに罹っている確率が $p$ の人(__有病率__ $p$ の人)に適用する状況について考える. このとき, その人が病気Dに罹っているか否かと検査結果が陽性か陰性かで分類することによって, 次のような $2\times 2$ の確率の表を作れる:

$$
\begin{array}{c|c|c|c}
& \text{病気有} & \text{病気無} & \\
\hline
\text{陽性} & 0.75 p & 0.05(1-p) & 0.05 + 0.70p \\
\hline
\text{陰性} & 0.25 p & 0.95(1-p) & 0.95 - 0.70p \\
\hline
 & p & 1-p & 1 \\
\end{array}
$$

下段の $p, 1-p$ や右端の $0.05+0.70p, 0.95-0.70p$ は確率の縦もしくは横の合計である. それらをよく __マージン__ (margin, 周辺確率)と呼ぶ.

この確率の2×2の表の部分に対応する確率質量函数は以下のように書ける:

$$
\begin{alignedat}{2}
&
P(\text{陽性}, \text{病気有}) = 0.75p, \qquad\qquad
& &
P(\text{陽性}, \text{病気無}) = 0.05(1-p), \qquad\qquad
\\ &
P(\text{陰性}, \text{病気有}) = 0.25p,
& &
P(\text{陰性}, \text{病気無}) = 0.95(1-p).
\end{alignedat}
$$

さらに, マージンとして以下の確率も上の表にすでに書き込まれている:

$$
\begin{aligned}
&
P(\text{病気有}) =
P(\text{陽性}, \text{病気有}) + P(\text{陰性}, \text{病気有}) = p,
\\ &
P(\text{病気無}) =
P(\text{陽性}, \text{病気無}) + P(\text{陰性}, \text{病気無}) = 1-p,
\\ &
P(\text{陽性}) =
P(\text{陽性}, \text{病気有}) + P(\text{陽性}, \text{病気無}) = 0.05 + 0.70p,
\\ &
P(\text{陰性}) =
P(\text{陰性}, \text{病気有}) + P(\text{陰性}, \text{病気無}) = 0.95 - 0.70p.
\end{aligned}
$$

上の表から, 陽性または陰性であるという条件によって定まる病気の有無に関する条件付き確率が以下のように計算される:

$$
\begin{aligned}
&
(\text{陽性的中率}) :=
P(\text{病気有}|\text{陽性}) =
\frac{P(\text{陽性}, \text{病気有})\qquad}{P(\text{陽性})\qquad} =
\frac{0.75p}{0.05 + 0.70p},
\\ &
(\text{偽陽性率}) :=
P(\text{病気有}|\text{陽性}) =
\frac{P(\text{陽性}, \text{病気有})\qquad}{P(\text{陽性})\qquad} =
\frac{0.05(1-p)}{0.05 + 0.70p},
\\ &
(\text{偽陰性率}) :=
P(\text{病気有}|\text{陰性}) =
\frac{P(\text{陰性}, \text{病気有})\qquad}{P(\text{陰性})\qquad} =
\frac{0.25p}{0.95 - 0.70p},
\\ &
(\text{陰性的中率}) :=
P(\text{病気無}|\text{陰性}) =
\frac{P(\text{陰性}, \text{病気無})\qquad}{P(\text{陰性})\qquad} =
\frac{0.95(1-p)}{0.95 - 0.70p}.
\end{aligned}
$$

これらの式は, 私には見難く, 上の確率の表を直接見た方がわかり易いように感じられる. しかし, 議論の内容を正確に把握できるようにするためにあえて式も書いてみた.

__注意:__ 伝統的には以上の内容はBayesの定理の応用として説明されることが多い. しかし, 上の説明ではBayesの定理は一切使用する必要がなかった. このことからもBayesの定理が必須ではないことがわかる. 最後に得られた陽性的中立, 偽陽性率, 偽陰性率, 陰性的中率の公式達はちょうどBayesの定理の形をしている.  そして, すぐ上でも述べたように見易い結果ではない.  実際の計算ではそれらのBayesの定理を使っても得られる公式を使うよりも, 確率の表を地道に書いて, 表を見ながら直接計算した方が間違う可能性も減り, 直観的な意味も理解し易いだろう.

以上を踏まえて次の問題を解け.


### 必修の易しい計算問題: 有病率によって偽陽性率と偽陰性率がどのように変化するか

前節の状況において, 有病率 $p$ が $10\%, 20\%, 40\%, 80\%$ の場合の偽陽性率と偽陰性率を求めよ. 

__解答例:__ 前節で求めた偽陽性率と偽陰性率の公式に $p=0.1,0.2,0.4,0.8$ を代入すれば求まるが, 以下では地道に確率の表を書いて求めてみよう.  (前節で求めた公式を使った人は以下の地道なやり方を採用しても手間がそう増えず, 状況をより把握し易くなっていることを確認して欲しい.)

前節の確率の表を引用しよう:

$$
\begin{array}{c|c|c|c}
& \text{病気有} & \text{病気無} & \\
\hline
\text{陽性} & 0.75 p & 0.05(1-p) & 0.05 + 0.70p \\
\hline
\text{陰性} & 0.25 p & 0.95(1-p) & 0.95 - 0.70p \\
\hline
 & p & 1-p & 1 \\
\end{array}
$$

$p=0.1$ の場合:

$$
\begin{array}{c|c|c|c}
& \text{病気有} & \text{病気無} & \\
\hline
\text{陽性} & 7.5\% & 4.5\% & 12\% \\
\hline
\text{陰性} & 2.5\% & 85.5\% & 88\% \\
\hline
 & 10\% & 90\% & 100\% \\
\end{array}
$$

$p=0.2$ の場合:

$$
\begin{array}{c|c|c|c}
& \text{病気有} & \text{病気無} & \\
\hline
\text{陽性} & 15\% & 4\% & 19\% \\
\hline
\text{陰性} & 5\% & 76\% & 81\% \\
\hline
 & 20\% & 80\% & 100\% \\
\end{array}
$$

$p=0.4$ の場合:

$$
\begin{array}{c|c|c|c}
& \text{病気有} & \text{病気無} & \\
\hline
\text{陽性} & 30\% & 3\% & 33\% \\
\hline
\text{陰性} & 10\% & 57\% & 67\% \\
\hline
 & 40\% & 60\% & 100\% \\
\end{array}
$$

$p=0.8$ の場合:

$$
\begin{array}{c|c|c|c}
& \text{病気有} & \text{病気無} & \\
\hline
\text{陽性} & 60\% & 1\% & 61\% \\
\hline
\text{陰性} & 20\% & 19\% & 39\% \\
\hline
 & 80\% & 20\% & 100\% \\
\end{array}
$$

以上の表を眺めると, 偽陽性率(陽性になった場合の病気無の条件付き確率)と偽陰性率(陰性になった場合の病気有の条件付き確率)は以下の表のようになることがわかる:

$$
\begin{array}{|c|c|c|}
\hline
\text{有病率} & \text{偽陽性率} & \text{偽陰性率} \\
\hline
10\% & 4.5/12 \approx 38\% & 2.5/88 \approx 2.8\% \\
20\% & 4/19 \approx 21\%   & 5/81 \approx 6.2\% \\
30\% & 3/33 \approx 9.1\%  & 10/67 \approx 15\% \\
40\% & 1/61 \approx 1.6\%  & 20/39 \approx 51\% \\
\hline
\end{array}
$$

有病率が低いと偽陽性率が高くなり, 有病率が高いと偽陰性率が高くなる.

__解答終__


## 尤度


## 推定


## 記述統計 (要約統計)

```julia

```
