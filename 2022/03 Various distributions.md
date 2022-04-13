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

# 色々な確率分布

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

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using Distributions
using StatsPlots
default(fmt = :png, titlefontsize = 10, size = (400, 250))
using Random
Random.seed!(4649373)
using StatsBase
using QuadGK
using SymPy
using SpecialFunctions
```

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#確率変数の独立性" data-toc-modified-id="確率変数の独立性-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>確率変数の独立性</a></span><ul class="toc-item"><li><span><a href="#同時確率質量函数と同時確率密度函数" data-toc-modified-id="同時確率質量函数と同時確率密度函数-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>同時確率質量函数と同時確率密度函数</a></span></li><li><span><a href="#確率変数の独立性の定義" data-toc-modified-id="確率変数の独立性の定義-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>確率変数の独立性の定義</a></span></li><li><span><a href="#任意の2つが独立であっても全体が独立であるとは限らない" data-toc-modified-id="任意の2つが独立であっても全体が独立であるとは限らない-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>任意の2つが独立であっても全体が独立であるとは限らない</a></span></li><li><span><a href="#確率変数の独立性の現実における解釈に関する重大な注意" data-toc-modified-id="確率変数の独立性の現実における解釈に関する重大な注意-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>確率変数の独立性の現実における解釈に関する重大な注意</a></span></li><li><span><a href="#" data-toc-modified-id="-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span></a></span></li></ul></li><li><span><a href="#正規分布" data-toc-modified-id="正規分布-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>正規分布</a></span><ul class="toc-item"><li><span><a href="#正規分布のロケーションスケール変換も正規分布" data-toc-modified-id="正規分布のロケーションスケール変換も正規分布-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>正規分布のロケーションスケール変換も正規分布</a></span></li></ul></li></ul></div>
<!-- #endregion -->

## 確率変数の独立性

<!-- #region -->
### 同時確率質量函数と同時確率密度函数

複数の確率変数 $X_1,\ldots,X_n$ が同時確率質量函数 $P(x_1,\ldots,x_n)$ を持つとは, $P(x_1,\ldots,x_n)\ge 0$ であり, $P(x_1,\ldots,x_n)$ の総和が $1$ にあり, 

$$
E[f(X_1,\ldots,X_n)] = \sum_{x_1}\cdots\sum_{x_n}f(x_1,\ldots,x_n)P(x_1,\ldots,x_n)
$$

が成立することである. このとき, $X_1$ 単独の確率質量函数 $P(x_1)$ は

$$
P(x_1) = \sum_{x_2}\cdots\sum_{x_n}P(x_1,\ldots,x_n)
$$

になる. なぜならば,

$$
$$


複数の確率変数 $X_1,\ldots,X_n$ が同時確率密度函数 $p(x_1,\ldots,x_n)$ を持つとは, $p(x_1,\ldots,x_n)\ge 0$ であり, $p(x_1,\ldots,x_n)$ の積分が $1$ になり, 

$$
E[f(X_1,\ldots,X_n)] = \int\!\!\cdots\!\!\int f(x_1,\ldots,x_n)p(x_1,\ldots,x_n)\,dx_1\cdots dx_n
$$

が成立することである. ここで $\int$ は定積分を表す.

$X_1$ 
<!-- #endregion -->

### 確率変数の独立性の定義

複数の確率変数 $X_1,\ldots,X_n$ が同時に与えられており, それらの函数の期待値 $E[f(X_1,\ldots,X_n)]$ が定義されているとする.  このとき, $X_1,\ldots,X_n$ が __独立__ (independent)であるとは, 

$$
E[f(X_1)\cdots f(X_n)] = E[f(X_1)] \cdots E[f(X_n)]
$$

と $X_i$ ごと函数達 $f(X_i)$ の積の期待値が各々の $f(X_i)$ の期待値の積になることだと定める.

__注意:__ 厳密には函数 $f_i$ 達を動かす範囲を確定させる必要があるが, このノートではそのようなことにこだわらずに解説することにする. (厳密な理論の展開のためには測度論的確率論の知識が必要になる.)

上の条件は, 例えば, $X_i$ 達のそれぞれが確率密度函数 $p_i(x_i)$ を持つとき, $(X_1,\ldots,X_n)$ の同時確率密度函数 $p(x_1,\ldots,x_n)$ が $p(x_1)\cdots p(x_n)$ と積の形になること

$$
p(x_1,\ldots,x_n) = p(x_1)\cdots p(x_n)
$$

と同値だと考えてよい. すなわち, $(X_1,\ldots,X_n)$ の函数の期待値が次のように書かれることと同値だと思ってよい:

$$
E[f(X_1,\ldots,X_n)] = \int\!\!\cdots\!\!\int f(x_1,\ldots,x_n)p(x_1)\cdots p(x_n)\,dx_1\cdots dx_n.
$$

ここで $\int\cdots\int$ は適切な範囲での定積分を表す.

$X_i$ 達のそれぞれが確率質量函数 $P_i(x_i)$ を持つ場合には, $X_1,\ldots,X_n$ の独立性は

$$
E[f(X_1,\ldots,X_n)] = \sum_{x_1}\cdots\sum_{x_n} f(x_1,\ldots,x_n)P_n(x_1)\cdots P_1(x_n)
$$

が成立することと同値である.

確率密度函数と確率質量函数が混ざっている場合も同様である.

__大雑把に誤解を恐れずに言うと, 確率が積になるときに独立だという.__

__実際の計算では, 積の期待値が期待値の積になるという形式で確率変数の独立性を使う.__


### 任意の2つが独立であっても全体が独立であるとは限らない

確率変数達 $X,Y,Z$ の任意の2つが独立であっても, $X,Y,Z$ の全体が独立でない場合があることを具体的な例を作ることによって証明しよう.

確率変数 $X,Y,Z$ の同時確率質量函数が $P(x,y,z)$ であるとき, $X$ 単独の確率質量函数は $P(x) = \sum_{y,z} P(x,y,z)$ になり, $(X,Y)$ の同時確率質量函数は $P(x,y) = \sum_z P(x,y,z)$ になる. 他の場合も同様である. (変数名で異なる函数を区別するスタイルを採用したので記号法の運用時に注意すること. このスタイルでは $P(x,y)$ と $P(x,z)$ は異な函数になる.)  $P(x,y,z)$ で $P(x,y)=P(x)P(y)$, $P(x,z)=P(x)P(z)$, $P(y,z)=P(y)P(z)$ を満たすが $P(x,y,z)\ne P(x)P(y)P(z)$ となるものを具体的に構成すればよい.

例えば以下のような確率質量函数 $P(x,y,z)$ の例を作ることができる:

$$
\begin{array}{|l|ll|ll|}
\hline
& z = 1 & &  z = 0 & \\
\hline
& y = 1 & y = 0 & y = 1 & y = 0 \\
\hline
x = 1 & P(1,1,1)=1/4 & P(1,0,1)=0   & P(1,1,0)=0   & P(1,0,0)=1/4 \\
x = 0 & P(0,1,1)=0   & P(0,0,1)=1/4 & P(0,1,0)=1/4 & P(0,0,0)=0 \\
\hline
\end{array}
$$

$x,y,z$ はそれぞれ $1,0$ を動くとする. このとき, $P(x,y)$, $P(x,z)$, $P(y,z)$ の値はすべて $1/4$ になり, $P(x)$, $P(y)$, $P(z)$ の値はすべて $1/2$ になることがわかる. たとえば, $P(x=1, y=1) = P(1,1,1)+P(1,1,0)=1/4+0=1/4$ であり, $P(x=1) = \sum_{y,z}P(1,y,z) = 1/4+0+0+1/4=1/2$. 

だから, $P(x,y)=P(x)P(y)$, $P(x,z)=P(x)P(z)$, $P(y,z)=P(y)P(z)$ が成立するが, $P(x,y,z)\ne 1/8 = P(x)P(y)P(z)$ となっている.

このとき, $X,Y,Z$ が同時確率質量函数 $P(x,y,z)$ を持つとすると, そのうちの任意の2つは独立だが, $X,Y,Z$ の全体は独立ではない.


### 確率変数の独立性の現実における解釈に関する重大な注意 

上の例は具体的には次のような状況だと解釈可能である. 

(1) $P(x) = 1/2$ の解釈: $X=1$ は薬Aを与えたことを, $X=0$ は薬Bを与えたことを意味する. 全員に確率 $1/2$ で薬AまたはBを与えた. 

(2) $P(y) = 1/2$ の解釈: $Y=1$ は薬に効果があったことを, $Y=0$ は効果が無かったことを意味する. 全体で見たら, $1/2$ の確率で薬には効果があった.

(3) $P(z) = 1/2$ の解釈: $Z=1$ は女性であることをを, $Z=0$ は男性であることを意味する. 女性である確率と男性である確率は $1/2$ だった.

(4) 男女の区別をやめると, 薬Aも薬Bも効果がある確率は半々であり, 薬Aと薬Bのどちらを与えたかと効果があったかどうかは独立である. 男女を合わせた($z=1,0$ の場合の和を取って得られる)確率質量函数 $P(x,y)$ の表

$$
\begin{array}{|l|ll|}
\hline
& y = 1 & y = 0 \\
\hline
x = 1 & P(x=1,y=1)=1/4 & P(x=1,y=0)=1/4 \\
x = 0 & P(x=0,y=1)=1/4 & P(x=0,y=0)=1/4 \\
\hline
\end{array}
$$

は$x=1$ の薬Aの場合も $x=0$ の薬Bの場合も男女全体を見ると半々で効果があることを意味している.

(5) 薬Aと薬Bのどちらを与えたかと男女のどちらであるかは独立である. そのことは効果の有無を意味する $y=1,0$ について和を取って得られる確率質量函数 $P(x,z)$ の表

$$
\begin{array}{|l|ll|}
\hline
& z = 1 & z = 0 \\
\hline
x = 1 & P(x=1,z=1)=1/4 & P(x=1,z=0)=1/4 \\
x = 0 & P(x=0,z=1)=1/4 & P(x=0,z=0)=1/4 \\
\hline
\end{array}
$$

からわかる.

(6) 薬Aと薬Bのどちらを与えたかを無視すると, 男女のどちらであるかと薬の効果の有無は独立である. そのことは薬Aと薬Bのどちらを与えたかを意味する $x=1,0$ について和を取って得られる確率質量函数 $P(y,z)$ の表

$$
\begin{array}{|l|ll|}
\hline
& z = 1 & z = 0 \\
\hline
y = 1 & P(y=1,z=1)=1/4 & P(y=1,z=0)=1/4 \\
y = 0 & P(y=0,z=1)=1/4 & P(y=0,z=0)=1/4 \\
\hline
\end{array}
$$

からわかる.

(7) しかし, 男女を区別すると全然違う結果が見えて来る. 女性には薬Aのみに常に効果があり, 男性には薬Bのみに常に効果がある. 女性を意味する $z=1$ の場合に制限した確率質量函数の表 

$$
\begin{array}{|l|ll|}
\hline
& z = 1 & \\
\hline
& y = 1 & y = 0 \\
\hline
x = 1 & P(1,1,1)=1/4 & P(1,0,1)=0   \\
x = 0 & P(0,1,1)=0   & P(0,0,1)=1/4 \\
\hline
\end{array}
$$

より, $x=1$ の薬Aの場合には $y=1$ の確率が正で効果があるが, $x=0$ の薬Bの場合には $y=1$ の確率が0で効果がないことがわかる. 男性を意味する $z=0$ のに制限した確率質量函数の表

$$
\begin{array}{|l|ll|}
\hline
& z = 0 & \\
\hline
& y = 1 & y = 0 \\
\hline
x = 1 & P(1,1,0)=0   & P(1,0,0)=1/4 \\
x = 0 & P(0,1,0)=1/4 & P(0,0,0)=0 \\
\hline
\end{array}
$$

より, $x=1$ の薬Aの場合には $y=1$ の確率が0で効果がないが, $x=0$ の薬Bの場合には $y=1$ の確率が正で効果があることがわかる.

__このように確率変数達が独立か否かは現実において重大な意味を持ち得る.  ある重要な条件(上の場合には女性か男性か)を無視して, 「XとYは独立である」と結論すると大変なことになる場合がある. XとYも, XとZも, YとZも独立であっても, XとYとZの全体は独立でないかもしれない.__


### 


## 正規分布

$\mu, \sigma\in\R$, $\sigma > 0$ と仮定する.  確率密度函数

$$
p(x|\mu,\sigma) = \frac{1}{\sqrt{2\pi\sigma^2}}\exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)
$$

で定義される連続分布を平均 $\mu$, 分散 $\sigma^2$ (標準偏差 $\sigma$)の __正規分布__ (normal distribution)と呼び, $\op{Normal}(\mu,\sigma)$ と書くのであった.

さらに, 平均 $0$, 分散 $1^2$ の正規分布を __標準正規分布__ (standard normal distribution)と呼び, $\op{Normal}()$ と書くのであった. 標準正規分布の密度函数は次の形になる:

$$
p(z) = \frac{e^{-z^2/2}}{\sqrt{2\pi}}.
$$


### 正規分布のロケーションスケール変換も正規分布

$a,b\in\R$, $a\ne 0$ と仮定する. 一般に確率変数 $X$ について,

$$
E[aX+b] = aE[X]+b, \quad \var(aX+b) = a^2\var(X)
$$

が成立するのであった.  $X$ が正規分布に従う確率変数の場合には $aX+b$ も正規分布に従うことを示せる. 実際, $X\sim\op{Normal}(\mu,\sigma)$ のとき, $y = ax + b$ すなわち $x = (y - b)/a$ とおくと,

$$
\begin{aligned}
E[f(aX+b)] &=
\frac{1}{\sqrt{2\pi\sigma^2}}
\int_{-\infty}^\infty f(ax+b) \exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)\,dx
\\ &=
\frac{1}{\sqrt{2\pi\sigma^2}}
\int_{-\infty}^\infty f(y) \exp\left(-\frac{((y-b)/a-\mu)^2}{2\sigma^2}\right)\,\frac{dy}{|a|}
\\ &=
\frac{1}{\sqrt{2\pi(a^2\sigma)^2}}
\int_{-\infty}^\infty f(y) \exp\left(-\frac{(y-(a\mu+b))^2}{2a^2\sigma^2}\right)\,dy
\end{aligned}
$$

なので, $aX+b$ は平均 $a\mu+b$, 分散 $a^2\sigma^2$ の正規分布に従う: $aX+b\sim\op{Normal}(\mu, |a|\sigma)$.

```julia

```
