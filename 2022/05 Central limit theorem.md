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
<div class="toc"><ul class="toc-item"><li><span><a href="#大数の法則" data-toc-modified-id="大数の法則-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>大数の法則</a></span></li><li><span><a href="#モーメントとその母函数と特性函数とキュムラント母函数" data-toc-modified-id="モーメントとその母函数と特性函数とキュムラント母函数-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>モーメントとその母函数と特性函数とキュムラント母函数</a></span><ul class="toc-item"><li><span><a href="#モーメントとその母函数と特性函数とキュムラント母函数の定義" data-toc-modified-id="モーメントとその母函数と特性函数とキュムラント母函数の定義-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>モーメントとその母函数と特性函数とキュムラント母函数の定義</a></span></li><li><span><a href="#特性函数による期待値の表示" data-toc-modified-id="特性函数による期待値の表示-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>特性函数による期待値の表示</a></span></li><li><span><a href="#問題:-キュムラントのロケーションスケール変換" data-toc-modified-id="問題:-キュムラントのロケーションスケール変換-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>問題: キュムラントのロケーションスケール変換</a></span></li><li><span><a href="#問題:-標準正規分布のモーメント母函数と特性函数とキュムラント母函数" data-toc-modified-id="問題:-標準正規分布のモーメント母函数と特性函数とキュムラント母函数-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>問題: 標準正規分布のモーメント母函数と特性函数とキュムラント母函数</a></span></li><li><span><a href="#確率変数の標準化と標準化キュムラントと歪度と尖度" data-toc-modified-id="確率変数の標準化と標準化キュムラントと歪度と尖度-2.5"><span class="toc-item-num">2.5&nbsp;&nbsp;</span>確率変数の標準化と標準化キュムラントと歪度と尖度</a></span></li><li><span><a href="#問題:-独立な確率変数達の和のモーメント母函数と特性函数とキュムラント母函数" data-toc-modified-id="問題:-独立な確率変数達の和のモーメント母函数と特性函数とキュムラント母函数-2.6"><span class="toc-item-num">2.6&nbsp;&nbsp;</span>問題: 独立な確率変数達の和のモーメント母函数と特性函数とキュムラント母函数</a></span></li></ul></li><li><span><a href="#中心極限定理" data-toc-modified-id="中心極限定理-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>中心極限定理</a></span><ul class="toc-item"><li><span><a href="#中心極限定理の特性函数を使った証明" data-toc-modified-id="中心極限定理の特性函数を使った証明-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>中心極限定理の特性函数を使った証明</a></span></li><li><span><a href="#中心極限定理の収束の速さと歪度" data-toc-modified-id="中心極限定理の収束の速さと歪度-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>中心極限定理の収束の速さと歪度</a></span></li><li><span><a href="#中心極限定理のキュムラント母函数を使った証明" data-toc-modified-id="中心極限定理のキュムラント母函数を使った証明-3.3"><span class="toc-item-num">3.3&nbsp;&nbsp;</span>中心極限定理のキュムラント母函数を使った証明</a></span></li><li><span><a href="#中心極限定理の収束の速さと歪度と尖度" data-toc-modified-id="中心極限定理の収束の速さと歪度と尖度-3.4"><span class="toc-item-num">3.4&nbsp;&nbsp;</span>中心極限定理の収束の速さと歪度と尖度</a></span></li><li><span><a href="#問題:-中心極限定理の収束の様子" data-toc-modified-id="問題:-中心極限定理の収束の様子-3.5"><span class="toc-item-num">3.5&nbsp;&nbsp;</span>問題: 中心極限定理の収束の様子</a></span></li><li><span><a href="#標本平均と不偏分散の定義" data-toc-modified-id="標本平均と不偏分散の定義-3.6"><span class="toc-item-num">3.6&nbsp;&nbsp;</span>標本平均と不偏分散の定義</a></span></li><li><span><a href="#問題:-標本平均の期待値と分散" data-toc-modified-id="問題:-標本平均の期待値と分散-3.7"><span class="toc-item-num">3.7&nbsp;&nbsp;</span>問題: 標本平均の期待値と分散</a></span></li><li><span><a href="#問題:-不偏分散の期待値と分散" data-toc-modified-id="問題:-不偏分散の期待値と分散-3.8"><span class="toc-item-num">3.8&nbsp;&nbsp;</span>問題: 不偏分散の期待値と分散</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using Distributions
using Printf
using QuadGK
using Random
Random.seed!(4649373)
using SpecialFunctions
using StatsBase
using StatsFuns
using StatsPlots
default(fmt = :png, titlefontsize = 10, size = (400, 250))
using SymPy
```

## 大数の法則


## モーメントとその母函数と特性函数とキュムラント母函数


### モーメントとその母函数と特性函数とキュムラント母函数の定義

確率変数 $X$ と $m=0,1,2,\ldots$ について

$$
\mu_m(X) = E[X^m]
$$

を $X$ の $m$ 次の __モーメント__(moment, 積率) と呼び,

$$
M_X(t) = E[e^{tX}] =
E\left[\sum_{m=0}^\infty X^m\frac{t^m}{m!}\right] =
\sum_{m=0}^\infty E[X^m] \frac{t^m}{m!} =
\sum_{m=0}^\infty \mu_m(X) \frac{t^m}{m!}
$$

を __モーメント母函数__ (moment generating function, mgf)と呼ぶ.

$X$ が従う確率分布の名前が $\op{Dist}$ のとき, これらを __分布 $\op{Dist}$ のモーメントとモーメント母函数__ と呼ぶ. 以下も同様である.

モーメント母函数の定義で $t$ を $it = \sqrt{-1}\,t$ で置き換えたもの

$$
\varphi_X(t) = E[e^{itX}] =
E\left[\sum_{m=0}^\infty i^m X^m\frac{t^m}{m!}\right] =
\sum_{m=0}^\infty i^m E[X^m] \frac{t^m}{m!} =
\sum_{m=0}^\infty i^m \mu_m(X) \frac{t^m}{m!}
$$

を __特性函数__ (characteristic function)と呼ぶ.  特性函数を扱う場合には $i = \sqrt{-1}$ としたいので, $i$ を番号の意味で使わないように気を付ける必要がある.

モーメント母函数だけではなく, 特性函数もモーメント達の母函数になっている.

モーメント母函数の対数

$$
K_X(t) = \log M(t) = \log E[e^{tX}] =
\sum_{m=1}^\infty \kappa_m(X) \frac{t^m}{m!} = \sum_{m=1}^\infty \kappa_m \frac{t^m}{m!}
$$

を __キュムラント母函数__ (cumulant generating function, cgf) と呼び, その展開係数 $\kappa_m = \kappa_m(X)$ を $X$ の $m$ 次のキュムラントと呼ぶ.

__注意:__ 取り得る値が実数になる確率変数 $X$ について $|e^{itX}|=1$ となるので, $E[e^{itX}]$ は常に絶対収束しており, 特性函数は常にうまく定義されている.  それに対して $e^{tX}$ の値は巨大になる可能性があり, $E[e^{tX}]$ が収束しない場合が出て来る.  モーメント母函数やキュムラント母函数の取り扱いではこの点に注意する必要がある. 

__注意:__ モーメント母函数とキュムラント母函数はそれぞれ物理での統計力学における __分配函数__ と __自由エネルギー__ (もしくは __Massieu函数__)の確率論的な類似物になっている.  ただし, 逆温度 $\beta$ について $t = -\beta$ とおく必要がある.  逆に言えば, モーメント母函数とキュムラントの表示における $\beta = -t$ の逆数は絶対温度の確率論的類似物になっていることになる.


### 特性函数による期待値の表示

$X$ が確率密度函数 $p(x)$ を持つとき, 函数 $f(x)$ のFourier変換を

$$
\hat{f}(t) = \int_{-\infty}^\infty f(x) e^{-itx}\,dx
$$

と書くと, $f(t)$ がそう悪くない函数ならば逆Fourier変換によってもとの函数に戻せる:

$$
f(x) = \frac{1}{2\pi} \int_{-\infty}^\infty \hat{f}(t) e^{itx}\,dt.
$$

Fourier解析の基礎については次のリンク先を参照せよ(逆Fourier変換に関する結果はこのノート内では認めて使ってよい):

* [12 Fourier解析](https://nbviewer.org/github/genkuroki/Calculus/blob/master/12%20Fourier%20analysis.ipynb)

ゆえに, $x$ に確率変数 $X$ を代入して両辺の期待値を取り, 期待値を取る操作と積分を交換すると,

$$
E[f(X)] =
\frac{1}{2\pi} \int_{-\infty}^\infty \hat{f}(t) E[e^{itX}]\,dt =
\frac{1}{2\pi} \int_{-\infty}^\infty \hat{f}(t) \varphi_X(t)\,dt.
$$

ここで $\varphi_X(t) = E[e^{itX}]$ は $X$ の特性函数である.

確率変数 $X$ が従う分布は様々な函数 $f(x)$ に関する期待値 $E[f(X)]$ から決まるので, $E[f(X)]$ が $X$ の特性函数 $\varphi_X(t)$ を用いて表せたということは, __$X$ の特性函数 $\varphi_X(t)$ から $X$ が従う分布が唯一つに決まる__ ことを意味している. 

さらに, 分布Aの特性函数が分布Bの特性函数で近似されていれば, 分布Aにおける期待値が分布Bにおける期待値で近似されることもわかる.  これは __分布の近似を特性函数の近似で確認できる__ ことを意味する.

モーメント母函数 $M_X(t) = E[e^{tX}]$ が $t$ の函数として, 定義域を自然に複素数まで拡張できているとき(正確には解析接続できていれば), $\varphi_X(t) = M_X(it)$ が成立する.  キュムラント母函数はモーメント母函数の対数である. これらより, __モーメント母函数やキュムラント母函数からも分布が唯一つに決まる__ ことがわかる.


### 問題: キュムラントのロケーションスケール変換

確率変数 $X$ と $a, b\in\R$, $a\ne 0$ について, $aX+b$ のモーメント母函数とキュムラント母函数とキュムラントが $X$ のそれらで次のように表されることを示せ:

$$
\begin{aligned}
&
M_{aX+b}(t) = e^{bt}M_X(at), \quad
K_{aX+b}(t) = K_X(at) + bt, \\ &
\kappa_1(aX+b) = a\kappa_1(X) + b, \quad
\kappa_m(aX+b) = a^m \kappa_m(X) \quad (m = 2,3,4,\ldots)
\end{aligned}
$$

__注意:__ __キュムラントの変換公式は非常に単純な形になる.__ $\kappa_1(aX+b) = a\kappa_1(X) + b$ は $\kappa_1(X)=E[X]$ だったので当然である.  $2$ 次以上のキュムラントは $a^m$ 倍されるだけになる. ここにもわざわざ対数を取ってキュムラント母函数とキュムラントを定義することの利点が現れている.

__注意:__ この結果は空気のごとく使われる.

__解答例:__ $aX+b$ のモーメント母函数を $X$ のモーメント母函数であらわそう:

$$
M_{aX+b}(t) = E[e^{t(aX+b)}] = e^{bt}E[e^{atX}] = e^{bt}M_X(at).
$$

ゆえに, $aX+b$ のキュムラントは次の形になる:

$$
K_{aX+b}(t) = \log M_{aX+b}(t) = \log(e^{bt}M_X(at)) = K_X(at) + bt.
$$

$X \mapsto aX+b$ によってキュムラント母函数は $K_X(t) \mapsto K_X(at) + bt$ に似た形式で変換される.

$X$ のキュムラント $\kappa_m(X)$ は次のようにキュムラント母函数を展開することによって定義されるのであった:

$$
K_X(t) = \sum_{m=1}^\infty \kappa_m(X)\frac{t^m}{m!}.
$$

$K_{aX+b}(t)$ の展開結果は

$$
K_{aX+b}(t) = K_X(at) + bt =
\sum_{m=0}^\infty \kappa_m(X)\frac{(at)^m}{m!} + bt =
(a\kappa_1(X)+b)t + \sum_{m=2}^\infty a^m \kappa_m(X) \frac{t^m}{m!}
$$

になるので,

$$
\kappa_1(aX+b) = a\kappa_1(X) + b, \quad
\kappa_m(aX+b) = a^m \kappa_m(X) \quad (m = 2,3,4,\ldots)
$$

となることがわかる.

__解答終__


### 問題: 標準正規分布のモーメント母函数と特性函数とキュムラント母函数

標準正規分布に従う確率変数 $Z$ のモーメント母函数と特性函数とキュムラント母函数が次のようになることを示せ:

$$
M_Z(t) = e^{t^2/2}, \quad
\varphi_Z(t) = M_Z(it) = e^{-t^2/2}, \quad
K_Z(t) = \log M_Z(t) = \frac{t^2}{2}.
$$

__解答例:__ $Z\sim\op{Normal}(0,1)$ と仮定する.  このとき,

$$
M_Z(t) = E[e^{tZ}] =
\int_{-\infty}^\infty e^{tz} \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz =
\frac{1}{\sqrt{2\pi}}\int_{-\infty}^\infty e^{-(z-t)^2/2 + t^2/2}\,dz =
\frac{e^{t^2/2}}{\sqrt{2\pi}}\int_{-\infty}^\infty e^{-w^2/2}\,dw =
e^{t^2/2}.
$$

4つめの等号で $z=w+t$ とおいた. ゆえに,

$$
\varphi_Z(t) = E[e^{itZ}] = M_Z(it) = e^{-t^2/2}, \quad
K_Z(t) = \log M_Z(t) = \frac{t^2}{2}.
$$

__解答終__

__注意:__ 標準正規分布のキュムラント母函数は $t^2/2$ というたったの一項だけになってしまう. 標準でない正規分布のキュムラント母函数は $t$ について1次と2次の項だけになる. 1次の項の係数は分布の期待値で, $t^2/2$ の係数は分散になる.  実際, 平均 $\mu$, 分散 $\sigma^2$ を持つ確率変数 $X$ について,

$$
\begin{aligned}
K_X(t) &= \log E[e^{tX}] = \log E[e^{t(X-\mu)+t\mu}]
\\ &=
t\mu + \log\left(1 + E[X-\mu]t + E[(X-\mu)^2]\frac{t^2}{2} + O(t^3)\right)
\\ &=
t\mu + \log\left(1 + \sigma^2\frac{t^2}{2} + O(t^3)\right) =
t\mu + \sigma^2\frac{t^2}{2} + O(t^3).
\end{aligned}
$$

そして, $\sigma Z + \mu \sim \op{Normal}(\mu, \sigma)$ であり, 

$$
M_{\sigma Z+\mu}(t) = E[e^{t(\sigma Z + \mu)}] =
e^{\mu t}E[e^{t\sigma Z}] = e^{\mu t}M_Z(\sigma t) = e^{\mu t + \sigma^2 t^2/2}.
$$

ゆえに

$$
K_{\sigma Z+\mu}(t) = \log M_{\sigma Z+\mu}(t) = \mu t + \sigma^2 \frac{t^2}{2}.
$$

他の分布のキュムラント母函数を計算したときに出て来る $t$ について3次以上の項はその分布が正規分布からどれだけ離れているかを表している.


### 確率変数の標準化と標準化キュムラントと歪度と尖度

確率変数 $X$ は確率変数であるとし, $\mu = E[X]$, $\sigma = \sqrt{E[(X-\mu)^2]}$ とおく.  このとき, 

$$
Z = \frac{X - \mu}{\sigma}
$$

を確率変数の __標準化__ (standardization)と呼ぶ.  $Z$ の期待値と分散はそれぞれ $0$ と $1$ になる.

$X$ の標準化のモーメントやキュムラントをそれぞれ __標準化モーメント__, __標準化キュムラント__ と呼び, それぞれを $\mu'_m(X)$, $\kappa'_m(X)$ と表す. 詳しくは以下の通り:

$$
\begin{aligned}
&
\mu'_m(X) = \mu_m(Z) = E\left[\left(\frac{X - \mu}{\sigma}\right)^m\right],
\\ &
M_Z(t) = E\left[\exp\left(t \frac{X - \mu}{\sigma}\right)\right] =
\sum_{m=0}^\infty \mu'_m(X) \frac{t^m}{m!} =
1 + \frac{t^2}{2} + \mu'_3(X)\frac{t^3}{3!} + \mu'_4(X)\frac{t^4}{4!} + \cdots,
\\ &
K_Z(t) = \log M_Z(t) =
\sum_{m=1}^\infty \kappa'_m(X) \frac{t^m}{m!} =
\frac{t^2}{2} + \kappa'_3(X) \frac{t^3}{3!} + \kappa'_4(X) \frac{t^4}{4!} + \cdots.
\end{aligned}
$$

$\kappa'_3(X)$ と $\kappa'_4(X)$ は次のように表される:

$$
\kappa'_3(X) = \mu'_3(X) = E\left[\left(\frac{X - \mu}{\sigma}\right)^3\right], \quad
\kappa'_4(X) = \mu'_4(X) - 3 = E\left[\left(\frac{X - \mu}{\sigma}\right)^4\right] - 3.
$$

このことは, $\log(1+a)=a-a^2/2+O(a^3)$ を使って以下のようにして確認される:

$$
\begin{aligned}
\log\left(1 + \frac{t^2}{2} + \mu'_3(X)\frac{t^3}{3!} + \mu'_4(X)\frac{t^4}{4!} + O(t^5)\right) &=
\frac{t^2}{2} + \mu'_3(X)\frac{t^3}{3!} + \mu'_4(X)\frac{t^4}{4!} -
\frac{1}{2}\left(\frac{t^2}{2}\right)^2 + O(t^5) \\ &=
\frac{t^2}{2} + \mu'_3(X)\frac{t^3}{3!} + (\mu'_4(X) - 3)\frac{t^4}{4!} + O(t^5).
\end{aligned}
$$

$\kappa'_3(X)$ を $X$ もしくは $X$ が従う分布の __歪度__ (わいど, skewness) と呼び, $\kappa'_4(X)$ を __尖度__ (せんど, kurtosis)と呼び, 以下のように書くことにする:

$$
\op{skewness}(X) = \kappa'_3(X) = E\left[\left(\frac{X - \mu}{\sigma}\right)^3\right], \quad
\op{kurtosis}(X) = \kappa'_4(X) = E\left[\left(\frac{X - \mu}{\sigma}\right)^4\right] - 3.
$$

歪度は左右の非対称性の尺度であり, 尖度は分布の尖り具合が正規分布とどれだけ違うかの尺度になっている.

$X$ が正規分布に従う確率変数の場合にはその標準化 $Z = (X-\mu)/\sigma$ は標準正規分布に従う確率変数になるので, その標準化キュムラント達は $\kappa'_2(X) = 1$, $\kappa'_m(X) = 0$ ($m\ne 0$) となる. 2次の標準化キュムラントは常に $1$ になるが, $3$ 次以上の標準化キュムラントは $X$ が正規分布でなければ $0$ でなくなる.

ゆえに, $3$ 次以上の標準化キュムラントは分布が正規分布からどれだけ離れているかを表していると考えられる. その最初の2つが上で定義した歪度 $\kappa'_3(X)$ と尖度 $\kappa'_4(X)$ である.  

__分布の歪度 $\kappa'_3(X)$ と尖度 $\kappa'_4(X)$ は分布がどれだけ正規分布から離れているかを表す最も基本的な量である.__

__注意:__ $\kappa'_4(X) = \mu'_4(X) - 3$ ではなく, $3$ を引く前の $\mu'_4(X)$ を尖度と定義する流儀もあるが, このノートでは __正規分布の尖度を $0$ にしたいので, $3$ を引いた側の $\kappa'_4$ を尖度の定義として採用する.__

__注意:__ $\kappa'_4(X) = \mu'_4(X) - 3$ は __過剰尖度__ (__excess kurtosis__)と呼ばれることも多い.  正規分布の尖度を $\kappa'_4$ ではなく, $\mu'_4$ の方の $3$ とするときに, そこからどれだけ分布の尖り具合が増したかを $\kappa'(X)$ が表しているので, 過剰尖度と呼ぶのである.

```julia
@vars t μ3 μ4 μ5 κ3 κ4 κ5 
Mt = 1 + t^2/2 + μ3*t^3/6 + μ4*t^4/24 + μ5*t^5
expr = series(log(Mt), t)
```

### 問題: 独立な確率変数達の和のモーメント母函数と特性函数とキュムラント母函数

独立な確率変数達 $X_1,\ldots,X_n$ の和のモーメント母函数と特性函数とキュムラント母函数が次のように表されることを示せ:

$$
\begin{aligned}
&
M_{X_1+\cdots+X_n}(t) = M_{X_1}(t) \cdots M_{X_n}(t),
\\ &
\varphi_{X_1+\cdots+X_n}(t) = \varphi_{X_1}(t) \cdots \varphi_{X_n}(t),
\\ &
K_{X_1+\cdots+X_n}(t) = K_{X_1}(t) + \cdots + K_{X_n}(t).
\end{aligned}
$$

__注意:__ この結果は空気のごとく使われる.

__解答例:__ 独立な確率変数達 $X_1,\ldots,X_n$ について

$$
E[f_1(X_1)\cdots f_n(X_n)] = E[f_1(X_1)]\cdots E[f_n(X_n)]
$$

が成立することより,

$$
\begin{aligned}
&
M_{X_1+\cdots+X_n}(t) =
E[e^{t(X_1+\cdots+X_n)}] =
E[e^{t X_1}\cdots e^{t X_n}] =
M_{X_1}(t) \cdots M_{X_n}(t),
\\ &
\varphi_{X_1+\cdots+X_n}(t) =
E[e^{it(X_1+\cdots+X_n)}] =
E[e^{it X_1}\cdots e^{it X_n}] =
\varphi_{X_1}(t) \cdots \varphi_{X_n}(t).
\end{aligned}
$$

ゆえに

$$
\begin{aligned}
K_{X_1+\cdots+X_n}(t) &=
\log M_{X_1+\cdots+X_n}(t) =
\log(M_{X_1}(t) \cdots M_{X_n}(t)) \\ &=
\log M_{X_1}(t) + \cdots + \log M_{X_n}(t) =
K_{X_1}(t) + \cdots + K_{X_n}(t).
\end{aligned}
$$

__解答終__


## 中心極限定理


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
\mu'_3 = E[Y_k^3] = E\left[\left(\frac{X_k - \mu}{\sigma}\right)^3\right]
$$

とおくと,

$$
\varphi\left(\frac{t}{\sqrt{n}}\right) = E[e^{itY_k}] =
1 - \frac{t^2}{2n} - i\mu'_3\frac{t^3}{6n\sqrt{n}} + O(n^{-2})
$$

なので, 

$$
\log\varphi\left(\frac{t}{\sqrt{n}}\right)^n = 
n\log\left(1 - \frac{t^2}{2n} - i\mu'_3\frac{t^3}{6n\sqrt{n}} + O(n^{-2})\right) =
-\frac{t^2}{2} - i\mu'_3\frac{t^3}{6\sqrt{n}} + O(n^{-1}).
$$

これは $n\to\infty$ での $\log\varphi\left(t/\sqrt{n}\right)^n \to -t^2/2$ の収束の速さは, $Y_k=(X_k-\mu)/\sigma$ の3次のモーメント $\mu'_3$ の絶対値の大きさで大体決まっていることがわかる. $\mu'_3$ の絶対値が小さいほど収束が速く, 大きいほど収束が遅い.

$\mu'_3$ は $X_k$ の分布の期待値 $\mu$ を中心とする非対称性の $\sigma$ によって適切に正規化した尺度になっている.  $\mu'_3$ は $Y_k=(X_k-\mu)/\sigma$ の3次のキュムラントにも一致している:

$$
K_{Y_k}(t) = \log E[e^{tY_k}] =
\log\left(1 + \frac{t^2}{2} + \mu'_3\frac{t^3}{3!} + O(t^4)\right) =
\frac{t^2}{2} + \mu'_3 \frac{t^3}{3!} + O(t^4).
$$

ここでの $t^3/3!$ の係数 $\kappa'_3 = \mu'_3$ は $X_k$ の __歪度__ (skewness) と呼ばれるのであった.


### 中心極限定理のキュムラント母函数を使った証明

__中心極限定理:__ $X_1, X_2, X_3, \ldots$ が独立同分布な確率変数の列であるとき, $\mu=E[X_k]$ が定義されていて, $\sigma^2 = \var(X_k) = E[(X_k - \mu)^2] < \infty$ でかつ, $E[|X_k - \mu|^3] < \infty$ となっており, さらに各 $X_k$ のキュムラント母函数がうまく定義されているとする. このとき,

$$
\bar{X}_n = \frac{1}{n}\sum_{k=1}^n X_k, \quad
Z_n = \frac{\sqrt{n}\,(\bar{X}_n - \mu)}{\sigma}
$$

とおくと, $n\to\infty$ で $Z_n$ の分布は標準正規分布に近付く.

__証明:__ $X_k$ の標準化を $Y_k = (X_k - \mu)/\sigma$ と書くことにする. $Y_1, Y_2, \ldots$ も独立同分布になり, $E[Y_k] = 0, \quad E[Y_k^2] = 1$ が成立している.  ゆえに $Y_k$ のキュムラント母函数 $K(t)$ は $k$ によらず,

$$
K(t) = \frac{t^2}{2} + O(t^3)
$$

という形になる. そして,

$$
\frac{1}{\sqrt{n}}\sum_{k=1}^n Y_k =
\frac{\sqrt{n}}{\sigma}\frac{1}{n}\sum_{k=1}^n (X_k - \mu) =
\frac{\sqrt{n}}{\sigma}(\bar{X}_n - \mu) = Z_n
$$

なので, $Z_n$ のキュムラント函数は, $n\to\infty$ で

$$
\begin{aligned}
K_{Z_n}(t) &=
K_{(Y_1/\sqrt{n}+\cdots+Y_n/\sqrt{n}}(t) =
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
K(t) = K_{(X_k - \mu)/\sigma}
$$

とおいたときの, $n\to\infty$ での $n K(t/\sqrt{n}) \to t^2/2$ という収束の速さを調べれば, 中心極限定理による正規分布への収束の速さがわかる. $X_k$ の標準化のキュムラント母函数は $X_k$ の歪度(わいど) $\kappa'_3$ と尖度(せんど)は

$$
\kappa'_3 = E\left[\left(\frac{X_k - \mu}{\sigma}\right)^3\right], \quad
\kappa'_4 = E\left[\left(\frac{X_k - \mu}{\sigma}\right)^4\right] - 3
$$

と表され, $X_k$ の標準化のキュムラント母函数 $K(t)$ の展開の係数になっているのであった:

$$
K(t) = \frac{t^2}{2} + \kappa'_3\frac{t^3}{3!} + \kappa'_4\frac{t^4}{4!} + O(t^5).
$$

このとき,

$$
n K\left(\frac{t}{\sqrt{n}}\right) =
n\left(
\frac{t^2}{2n} + \kappa'_3\frac{t^3}{3!\,n^{3/2}} + \kappa'_4\frac{t^4}{4!\,n^2} + O(n^{-5/2})
\right) =
\frac{t^2}{2} + \kappa'_3\frac{t^3}{3!\,n^{1/2}} + \kappa'_4\frac{t^4}{4!\,n} + O(n^{-3/2})
$$

これが $t^2/2$ に収束する速さは $\kappa'_3 \ne 0$ ならば $O(n^{-1/2})$ のオーダーになり, 歪度 $\kappa'_3$ の絶対値が大きいほど遅くなる. そして, $\kappa'_3 = 0$ ならば $O(n^{-1})$ のオーダーでの収束になり, 尖度 $\kappa'_4$ の絶対値が大きいほど遅くなる.


### 問題: 中心極限定理の収束の様子

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

### 標本平均と不偏分散の定義


### 問題: 標本平均の期待値と分散


### 問題: 不偏分散の期待値と分散

```julia

```
