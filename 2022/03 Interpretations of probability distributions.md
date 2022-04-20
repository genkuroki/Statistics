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

# 確率分布の解釈達

* 黒木玄
* 2022-04-11～2022-04-20
$
\newcommand\op{\operatorname}
\newcommand\R{{\mathbb R}}
\newcommand\Z{{\mathbb Z}}
\newcommand\var{\op{var}}
\newcommand\std{\op{std}}
\newcommand\eps{\varepsilon}
\newcommand\T[1]{T_{(#1)}}
$

このノートでは[Julia言語](https://julialang.org/)を使用している: 

* [Julia言語のインストールの仕方の一例](https://nbviewer.org/github/genkuroki/msfd28/blob/master/install.ipynb)

自明な誤りを見つけたら, 自分で訂正して読んで欲しい.  大文字と小文字の混同や書き直しが不完全な場合や符号のミスは非常によくある.

このノートに書いてある式を文字通りにそのまま読んで正しいと思ってしまうとひどい目に会う可能性が高い. しかし, 数が使われている文献には大抵の場合に文字通りに読むと間違っている式や主張が書いてあるので, 内容を理解した上で訂正しながら読んで利用しなければいけない. 実践的に数学を使う状況では他人が書いた式をそのまま信じていけない.

このノートの内容よりもさらに詳しいノートを自分で作ると勉強になるだろう.  膨大な時間を取られることになるが, このノートの内容に関係することで飯を食っていく可能性がある人にはそのためにかけた時間は無駄にならないと思われる.

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#正規分布" data-toc-modified-id="正規分布-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>正規分布</a></span><ul class="toc-item"><li><span><a href="#正規分布のロケーションスケール変換も正規分布" data-toc-modified-id="正規分布のロケーションスケール変換も正規分布-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>正規分布のロケーションスケール変換も正規分布</a></span></li><li><span><a href="#問題:-正規分布の平均と分散" data-toc-modified-id="問題:-正規分布の平均と分散-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>問題: 正規分布の平均と分散</a></span></li><li><span><a href="#問題:-正規分布に従う独立な確率変数達の和も正規分布に従う" data-toc-modified-id="問題:-正規分布に従う独立な確率変数達の和も正規分布に従う-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>問題: 正規分布に従う独立な確率変数達の和も正規分布に従う</a></span></li><li><span><a href="#問題:-標準正規分布に従う独立な確率変数の和" data-toc-modified-id="問題:-標準正規分布に従う独立な確率変数の和-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>問題: 標準正規分布に従う独立な確率変数の和</a></span></li><li><span><a href="#必ず解いて欲しい問題:-正規分布における確率が95%または99%になる区間" data-toc-modified-id="必ず解いて欲しい問題:-正規分布における確率が95%または99%になる区間-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span>必ず解いて欲しい問題: 正規分布における確率が95%または99%になる区間</a></span></li><li><span><a href="#問題:-正規分布のモーメント母函数とキュムラント母函数" data-toc-modified-id="問題:-正規分布のモーメント母函数とキュムラント母函数-1.6"><span class="toc-item-num">1.6&nbsp;&nbsp;</span>問題: 正規分布のモーメント母函数とキュムラント母函数</a></span></li><li><span><a href="#問題:-キュムラント母函数と期待値と分散" data-toc-modified-id="問題:-キュムラント母函数と期待値と分散-1.7"><span class="toc-item-num">1.7&nbsp;&nbsp;</span>問題: キュムラント母函数と期待値と分散</a></span></li><li><span><a href="#問題:-対数正規分布の確率密度函数" data-toc-modified-id="問題:-対数正規分布の確率密度函数-1.8"><span class="toc-item-num">1.8&nbsp;&nbsp;</span>問題: 対数正規分布の確率密度函数</a></span></li><li><span><a href="#問題:-対数正規分布の期待値と分散" data-toc-modified-id="問題:-対数正規分布の期待値と分散-1.9"><span class="toc-item-num">1.9&nbsp;&nbsp;</span>問題: 対数正規分布の期待値と分散</a></span></li></ul></li><li><span><a href="#$t$-分布" data-toc-modified-id="$t$-分布-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>$t$ 分布</a></span><ul class="toc-item"><li><span><a href="#分散パラメータが確率分布に従う正規分布について" data-toc-modified-id="分散パラメータが確率分布に従う正規分布について-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>分散パラメータが確率分布に従う正規分布について</a></span></li><li><span><a href="#問題:-分散の-$\nu$-倍が自由度-$\nu$-のχ²分布に従う平均-$0$-の正規分布は-$t$-分布になる" data-toc-modified-id="問題:-分散の-$\nu$-倍が自由度-$\nu$-のχ²分布に従う平均-$0$-の正規分布は-$t$-分布になる-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>問題: 分散の $\nu$ 倍が自由度 $\nu$ のχ²分布に従う平均 $0$ の正規分布は $t$ 分布になる</a></span></li><li><span><a href="#必ず解いて欲しい問題:-$t$-分布における確率が95%または99%になる区間" data-toc-modified-id="必ず解いて欲しい問題:-$t$-分布における確率が95%または99%になる区間-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>必ず解いて欲しい問題: $t$ 分布における確率が95%または99%になる区間</a></span></li></ul></li><li><span><a href="#Poisson分布" data-toc-modified-id="Poisson分布-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Poisson分布</a></span><ul class="toc-item"><li><span><a href="#Poisson分布の定義" data-toc-modified-id="Poisson分布の定義-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>Poisson分布の定義</a></span></li><li><span><a href="#問題:-Poisson分布のキュムラント母函数と期待値と分散" data-toc-modified-id="問題:-Poisson分布のキュムラント母函数と期待値と分散-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>問題: Poisson分布のキュムラント母函数と期待値と分散</a></span></li><li><span><a href="#二項分布の連続時間極限" data-toc-modified-id="二項分布の連続時間極限-3.3"><span class="toc-item-num">3.3&nbsp;&nbsp;</span>二項分布の連続時間極限</a></span></li><li><span><a href="#Poisson分布は単位時間内に起こるイベントの回数の分布だとみなされる" data-toc-modified-id="Poisson分布は単位時間内に起こるイベントの回数の分布だとみなされる-3.4"><span class="toc-item-num">3.4&nbsp;&nbsp;</span>Poisson分布は単位時間内に起こるイベントの回数の分布だとみなされる</a></span></li><li><span><a href="#Poisson分布の中心極限定理と二項分布の中心極限定理の関係" data-toc-modified-id="Poisson分布の中心極限定理と二項分布の中心極限定理の関係-3.5"><span class="toc-item-num">3.5&nbsp;&nbsp;</span>Poisson分布の中心極限定理と二項分布の中心極限定理の関係</a></span></li><li><span><a href="#問題:-Poisson分布の中心極限定理の直接証明" data-toc-modified-id="問題:-Poisson分布の中心極限定理の直接証明-3.6"><span class="toc-item-num">3.6&nbsp;&nbsp;</span>問題: Poisson分布の中心極限定理の直接証明</a></span></li><li><span><a href="#Poisson分布のパラメータがガンマ分布に従っていれば負の二項分布が得られる" data-toc-modified-id="Poisson分布のパラメータがガンマ分布に従っていれば負の二項分布が得られる-3.7"><span class="toc-item-num">3.7&nbsp;&nbsp;</span>Poisson分布のパラメータがガンマ分布に従っていれば負の二項分布が得られる</a></span></li><li><span><a href="#問題:-Poisson分布とガンマ分布から負の二項分布が得られる" data-toc-modified-id="問題:-Poisson分布とガンマ分布から負の二項分布が得られる-3.8"><span class="toc-item-num">3.8&nbsp;&nbsp;</span>問題: Poisson分布とガンマ分布から負の二項分布が得られる</a></span></li><li><span><a href="#Poisson分布の累積分布函数とガンマ分布の累積分布函数の関係" data-toc-modified-id="Poisson分布の累積分布函数とガンマ分布の累積分布函数の関係-3.9"><span class="toc-item-num">3.9&nbsp;&nbsp;</span>Poisson分布の累積分布函数とガンマ分布の累積分布函数の関係</a></span></li></ul></li><li><span><a href="#ガンマ分布" data-toc-modified-id="ガンマ分布-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>ガンマ分布</a></span><ul class="toc-item"><li><span><a href="#問題:-標準正規分布に従う確率変数の2乗は自由度1のχ²分布に従う" data-toc-modified-id="問題:-標準正規分布に従う確率変数の2乗は自由度1のχ²分布に従う-4.1"><span class="toc-item-num">4.1&nbsp;&nbsp;</span>問題: 標準正規分布に従う確率変数の2乗は自由度1のχ²分布に従う</a></span></li><li><span><a href="#問題:-標準正規分布に従う-$n$-個の独立な確率変数達の2乗は自由度-$n$-のχ²分布に従う" data-toc-modified-id="問題:-標準正規分布に従う-$n$-個の独立な確率変数達の2乗は自由度-$n$-のχ²分布に従う-4.2"><span class="toc-item-num">4.2&nbsp;&nbsp;</span>問題: 標準正規分布に従う $n$ 個の独立な確率変数達の2乗は自由度 $n$ のχ²分布に従う</a></span></li><li><span><a href="#負の二項分布の連続時間極限" data-toc-modified-id="負の二項分布の連続時間極限-4.3"><span class="toc-item-num">4.3&nbsp;&nbsp;</span>負の二項分布の連続時間極限</a></span></li><li><span><a href="#ガンマ分布はイベントが-$\alpha$-回起こるまでにかかる時間の分布とみなされる" data-toc-modified-id="ガンマ分布はイベントが-$\alpha$-回起こるまでにかかる時間の分布とみなされる-4.4"><span class="toc-item-num">4.4&nbsp;&nbsp;</span>ガンマ分布はイベントが $\alpha$ 回起こるまでにかかる時間の分布とみなされる</a></span></li><li><span><a href="#負の二項分布の連続時間極限の様子をプロット" data-toc-modified-id="負の二項分布の連続時間極限の様子をプロット-4.5"><span class="toc-item-num">4.5&nbsp;&nbsp;</span>負の二項分布の連続時間極限の様子をプロット</a></span></li><li><span><a href="#必ず解いて欲しい問題:-χ²分布における確率が95%または99%になる範囲" data-toc-modified-id="必ず解いて欲しい問題:-χ²分布における確率が95%または99%になる範囲-4.6"><span class="toc-item-num">4.6&nbsp;&nbsp;</span>必ず解いて欲しい問題: χ²分布における確率が95%または99%になる範囲</a></span></li><li><span><a href="#問題:-自由度1のχ²分布と標準正規分布の関係の数値例" data-toc-modified-id="問題:-自由度1のχ²分布と標準正規分布の関係の数値例-4.7"><span class="toc-item-num">4.7&nbsp;&nbsp;</span>問題: 自由度1のχ²分布と標準正規分布の関係の数値例</a></span></li></ul></li><li><span><a href="#ベータ分布" data-toc-modified-id="ベータ分布-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>ベータ分布</a></span><ul class="toc-item"><li><span><a href="#一様分布のサイズ-$n$-の標本分布の順序統計量" data-toc-modified-id="一様分布のサイズ-$n$-の標本分布の順序統計量-5.1"><span class="toc-item-num">5.1&nbsp;&nbsp;</span>一様分布のサイズ $n$ の標本分布の順序統計量</a></span></li><li><span><a href="#一様分布のサイズ-$n$-の標本分布の順序統計量が従う分布" data-toc-modified-id="一様分布のサイズ-$n$-の標本分布の順序統計量が従う分布-5.2"><span class="toc-item-num">5.2&nbsp;&nbsp;</span>一様分布のサイズ $n$ の標本分布の順序統計量が従う分布</a></span></li><li><span><a href="#二項分布の累積分布函数のベータ分布の累積分布函数表示" data-toc-modified-id="二項分布の累積分布函数のベータ分布の累積分布函数表示-5.3"><span class="toc-item-num">5.3&nbsp;&nbsp;</span>二項分布の累積分布函数のベータ分布の累積分布函数表示</a></span></li><li><span><a href="#負の二項分布の累積分布函数のベータ分布の累積分布函数表示" data-toc-modified-id="負の二項分布の累積分布函数のベータ分布の累積分布函数表示-5.4"><span class="toc-item-num">5.4&nbsp;&nbsp;</span>負の二項分布の累積分布函数のベータ分布の累積分布函数表示</a></span></li><li><span><a href="#ベータ二項分布の定義" data-toc-modified-id="ベータ二項分布の定義-5.5"><span class="toc-item-num">5.5&nbsp;&nbsp;</span>ベータ二項分布の定義</a></span></li></ul></li></ul></div>
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

なので, $aX+b$ は平均 $a\mu+b$, 分散 $a^2\sigma^2$ の正規分布に従う: $aX+b\sim\op{Normal}(a\mu + b, |a|\sigma)$.


### 問題: 正規分布の平均と分散

分布 $\op{Normal}(\mu, \sigma)$ の平均と分散がそれぞれ $\mu$, $\sigma^2$ になることを示せ.

__解答例1:__ すでに標準正規分布 $\op{Normal}(0,1)$ の平均と分散がそれぞれ $0$ と $1^2$ になることは示してある. $X \sim \op{Normal}(\mu, \sigma)$ のとき, $Z = (X - \mu)/\sigma$ とおくと $Z\sim\op{Normal}((\mu-\mu)/\sigma, \sigma/\sigma) = \op{Normal}(0, 1)$ となるので, $X = \sigma Z + \mu$ の平均と分散はそれぞれ $\sigma\cdot0+\mu=\mu$, $\sigma^2\cdot 1^2 = \sigma^2$ になる.

__解答終__

__解答例2:__ 直接的に計算してみよう. $X \sim \op{Normal}(\mu, \sigma)$ のとき, 積分変数を $x = \sigma z + \mu$ と変換すると,

$$
E[X] =
\frac{1}{\sqrt{2\pi\sigma^2}}\int_{-\infty}^\infty x e^{-(x-\mu)^2/(2\sigma^2)}\,dx =
\frac{1}{\sqrt{2\pi}}\int_{-\infty}^\infty (\sigma z+\mu) e^{-z^2/2}\,dz =
\mu.
$$
最後の等号で $\int_{-\infty}^\infty z e^{-z^2/2}\,dz = 0$ と $\int_{-\infty}^\infty e^{-z^2/2}\,dy = \sqrt{2\pi}$ を使った.  この結果を使うと,

$$
\op{var}(X) = E[(X-\mu)^2] =
\frac{1}{\sqrt{2\pi\sigma^2}}\int_{-\infty}^\infty (x-\mu)^2 e^{-(x-\mu)^2/(2\sigma^2)}\,dx =
\frac{1}{\sqrt{2\pi}}\int_{-\infty}^\infty \sigma^2 z^2 e^{-z^2/2}\,dx = \sigma^2.
$$

最後の等号で $\int_{-\infty}^\infty z^2 e^{-z^2/2}\,dz = \sqrt{2\pi}$ を使った. この結果は

$$
\int_{-\infty}^\infty e^{-\alpha z^2}\,dz = \sqrt{\pi}\,\alpha^{-1/2}
$$

の両辺を $\alpha$ で微分して $-1$ 倍して $\alpha=1/2$ とおいても得られるし, ガンマ函数に帰着する方法でも得られる.

__解答終__


### 問題: 正規分布に従う独立な確率変数達の和も正規分布に従う

$X$, $Y$ はともに正規分布に従う独立な確率変数達であるとき, $X+Y$ も正規分布に従うことを示せ.  $X+Y$ の平均と分散は $X$, $Y$ の平均と分散でどのように表されるか?

__解答例:__ $X\sim\op{Normal}(\mu_X, \sigma_X)$, $Y\sim\op{Normal}(\mu_Y, \sigma_Y)$ でかつ $X,Y$ は独立であると仮定する.

$X,Y$ は独立なので $X+Y$ の平均と分散はそれぞれ $\mu_X + \mu_Y$, $\sigma_X^2 + \sigma_Y^2$ になる.

$X'=X-\mu_X$, $Y'=Y-\mu_Y$ とおくと, $X'\sim\op{Normal}(0,\sigma_X)$, $Y\sim\op{Normal}(0,\sigma_Y)$, $X+Y = (X'+Y') + (\mu_X+\mu_Y)$ となるので, $X'+Y'$ が正規分布に従うことを示せば十分である.  ゆえに $\mu_X=0$, $\mu_Y=0$ と仮定してよいので, そのように仮定する. 

$X+Y$ の確率密度函数を計算して, それが正規分布の密度函数になっていることを示せばよい. 

$$
E[f(X+Y)] =
\frac{1}{\sqrt{(2\pi)^2\sigma_X^2\sigma_Y^2}}
\iint_{\R^2} f(x+y) \exp\left(-\frac{1}{2}\left(
\frac{x^2}{\sigma_X^2}+\frac{y^2}{\sigma_Y^2}
\right)\right)\,dx\,dy
$$

であり, $x = x + y$ すなわち $y = z - x$ とおいて, $x$ について平方完成すると,

$$
\frac{x^2}{\sigma_X^2}+\frac{y^2}{\sigma_Y^2} =
\frac{x^2}{\sigma_X^2}+\frac{(z-x)^2}{\sigma_Y^2} =
\frac{\sigma_X^2+\sigma_Y^2}{\sigma_X^2\sigma_Y^2}
\left(x - \frac{\sigma_X^2 z}{\sigma_X^2+\sigma_Y^2}\right)^2 +
\frac{z^2}{\sigma_X^2 + \sigma_Y^2}.
$$

となる(この計算を自分で実行してみること).  ゆえに,

$$
\begin{aligned}
&
E[f(X+Y)]
\\ &=
\frac{1}{\sqrt{(2\pi)^2\sigma_X^2\sigma_Y^2}}
\int_\R\left(\int_\R f(z) \exp\left(-
\frac{\sigma_X^2+\sigma_Y^2}{2\sigma_X^2\sigma_Y^2}
\left(x - \frac{\sigma_X^2 z}{\sigma_X^2+\sigma_Y^2}\right)^2 -
\frac{z^2}{2(\sigma_X^2 + \sigma_Y^2)}
\right)\,dx\right)\,dz
\\ &=
\frac{1}{\sqrt{(2\pi)^2\sigma_X^2\sigma_Y^2}}
\sqrt{\frac{2\pi\sigma_X^2\sigma_Y^2}{\sigma_X^2+\sigma_Y^2}}
\int_\R f(z) \exp\left( -\frac{z^2}{2(\sigma_X^2 + \sigma_Y^2)} \right)\,dz
\\ &=
\frac{1}{\sqrt{2\pi(\sigma_X^2+\sigma_Y^2)}}
\int_\R f(z) \exp\left( -\frac{z^2}{2(\sigma_X^2 + \sigma_Y^2)} \right)\,dz
\end{aligned}
$$

以上によって $X+Y\sim\op{Normal}(\mu_X + \mu_Y, \sigma_X^2 + \sigma_Y^2)$ を示せた.

$z = x + y$, $y = z - x$ とおくと密度函数中の指数函数の中身が $z$ についでの二次式になることから, $Z = X+Y$ が正規分布に従うことは計算しなくても明らかだと考えることもできる. 上のように $z$ 以外の変数は積分して消せる.  そして, $Z=X+Y$ の期待値は $X,Y$ の期待値の和になり, $X,Y$ が独立という仮定からそれらは無相関になるので $Z=X+Y$ の分散は $X,Y$ の分散の和になることもわかる. これだけで $X+Y\sim\op{Normal}(\mu_X + \mu_Y, \sigma_X^2 + \sigma_Y^2)$ を証明でいたともみなせる.

__解答終__


上の解答中の最も面倒な部分の計算が正しいことはコンピュータで以下のように確認できる.

$a=\sigma_X^2$, $b=\sigma_Y^2$ とおくと,

```julia
@vars a b x z
(a+b)/(a*b)*(x - a*z/(a+b))^2 + z^2/(a+b) - x^2/a - (z-x)^2/b |> simplify
```

以下のように素朴に計算することもできる.

```julia
@vars a b positive=true
@vars x y z t
expr = x^2/a + y^2/b
```

```julia
expr = expr(y=>z-x).expand()
```

```julia
A, B = 1/a+1/b, z/b
expr = sympy.poly(expr(x => t + B/A), t) 
```

```julia
# 以下のセルでの説明で使う図の準備

μ, σ, c = 2, 3, 1.5
normal = Normal(μ, σ)

P1 = plot(normal, μ - 4σ, μ + 4σ; label="Normal(μ,σ)", xlabel="x = σz + μ")
vline!([μ]; label="x=μ", xtick = ([μ-c*σ, μ, μ+c*σ], ["μ-cσ", "μ", "μ+cσ"]), ytick=false)
plot!(normal, μ - 4σ, μ - c*σ; label="", c=1, frange=0, fc=:red, fa=0.5)
plot!(normal, μ + c*σ, μ + 4σ; label="", c=1, frange=0, fc=:red, fa=0.5)
annotate!(μ - 1.3c*σ, 0.8pdf(normal, μ - c*σ), ("P(X≤μ-cσ)", 10, :red, :right))
annotate!(μ - 1.5c*σ, 0.5pdf(normal, μ - c*σ), ("= α/2", 10, :red, :right))
annotate!(μ + 1.5c*σ, 0.5pdf(normal, μ + c*σ), ("= α/2", 10, :red, :left))
annotate!(μ + 1.3c*σ, 0.8pdf(normal, μ + c*σ), ("1-P(X≥μ+cσ)", 10, :red, :left))

P2 = plot(Normal(), -4, 4; label="Normal(0,1)", xlabel="z = (x - μ)/σ")
vline!([0]; label="z=0", xtick = ([-c, 0, c], ["-c", "0", "c"]), ytick=false)
plot!(Normal(), -4, -c; label="", c=1, frange=0, fc=:red, fa=0.5)
plot!(Normal(),  c,  4; label="", c=1, frange=0, fc=:red, fa=0.5)
annotate!(-1.3c, 0.8pdf(Normal(), -c), ("P(Z≤-c)", 10, :red, :right))
annotate!(-1.5c, 0.5pdf(Normal(), -c), ("= α/2", 10, :red, :right))
annotate!( 1.5c, 0.5pdf(Normal(),  c), ("= α/2", 10, :red, :left))
annotate!( 1.3c, 0.8pdf(Normal(),  c), ("1-P(Z≥c)", 10, :red, :left))

var"P(μ-cσ ≤ X ≤ μ+cσ) = 1-α ⟺ 1 - P(Z ≤ c) = α/2" =
    plot(P1, P2; size=(800, 250), bottommargin=4Plots.mm);
```

### 問題: 標準正規分布に従う独立な確率変数の和

確率変数 $X_1,\ldots,X_n$ の各々は標準正規分布に従い, それらは独立な確率変数達である(すなわちそれらの同時確率密度函数が標準正規分布の確率密度函数の積になっている)と仮定する. このとき

$$
Z_n = \frac{X_1 + \cdots + X_n}{\sqrt{n}}
$$

も標準正規分布に従うことを示せ.

__解答例:__ $X_i/\sqrt{n}$ は平均 $0$, 分散 $1/n$ の正規分布に従し, $X_1/\sqrt{n},\ldots,X_n/\sqrt{n}$ は独立になるので, 上の問題の結果より, それらの和は平均 $0+\cdots+0=0$, 分散 $1/n+\cdots+1/n=1$ の正規分布つまり標準正規分布に従う.

__解答終__


__注意:__ この問題の結果より, 各々が標準正規分布に従う $n$ 個の独立な確率変数達の和の $\sqrt{n}$ 分の $1$ が従う分布も標準正規分布になる. 

分布 $D$ は平均 $0$ と分散 $1$ を持つ分布であるとき, 各々が分布 $D$ に従う $n$ 個の独立な確率変数達の和の $\sqrt{n}$ 分の $1$ (以下 $Z_n$ と書く)が従う分布はどうなるだろうか?

その場合にも $Z_n$ の平均と分散はそれぞれ $0$ と $1$ になるが, $Z_n$ が従う分布は一般に $D$ とは異なる分布になる.

しかし, 応用上無理のないゆるい仮定のもとで, $Z_n$ が従う分布は $n$ を大きくすると標準正規分布に近付くことを示せる.

これが一般的な __中心極限定理__ の主張である.  もとの分布が標準正規分布なら $Z_n$ が従う分布はぴったり標準正規分布になるが, それ以外の一般の場合にも $n$ を大きくすれば $Z_n$ が従う分布が近似的に標準正規分布になることはいえるのである.


### 必ず解いて欲しい問題: 正規分布における確率が95%または99%になる区間

$X \sim \op{Normal}(\mu, \sigma)$ であると仮定する.  このとき, $X$ が区間 $[\mu-c\sigma, \mu+c\sigma]$ に含まれる確率

$$
P(\mu-c\sigma \le X \le \mu+c\sigma)
$$

が $1 - \alpha$ になるような $c$ を誤差函数

$$
y = \op{erf}(x) = \frac{2}{\sqrt{\pi}} \int_0^x \exp(-u^2) \,du
$$

の逆函数 $x = \op{erfinv}(y)$ を使って表せ.

さらに, 上の確率が $95\%$ になる $c$ と $99\%$ になる $c$ を小数点以下第2桁目まで求めよ. 

__解答例:__ 標準正規分布の場合の計算に帰着することを考えよう.

$Z = (X - \mu)/\sigma$ とおくと $Z$ は標準正規分布に従うのであった: $Z \sim \op{Normal}(0,1)$. このとき,

$$
\mu-c\sigma \le X \le \mu+c\sigma \iff -c \le Z = \frac{X-\mu}{\sigma} \le c
$$

なので, 標準正規分布に従う確率変数 $Z$ について $P(-c \le Z \le c)$ が $95\%$ になる $c$ と $99\%$ になる $c$ を求めればよい.  正規分布は左右対称なので, $P(-c \le Z \le c) = 1 - \alpha$ となることと, $1 - P(Z \le c) = \alpha/2$ すなわち

$$
P(Z \le c) = 1 - \alpha/2
$$

となることは同値である. 下の図を見よ.

```julia
var"P(μ-cσ ≤ X ≤ μ+cσ) = 1-α ⟺ 1 - P(Z ≤ c) = α/2"
```

標準正規分布の累積分布函数

$$
F(z) = P(Z \le z) =
\frac{1}{\sqrt{2\pi}}\int_{-\infty}^z e^{t^2/2}\,dt
$$

はコンピュータでの基本特殊函数ライブラリに含まれている誤差函数

$$
\op{erf}(x) = \frac{2}{\sqrt{\pi}} \int_0^x \exp(-u^2) \,du
$$

を使えば

$$
F(z) = \frac{1 + \op{erf}(z/\sqrt{2})}{2}.
$$

と書けるのであった. この公式を証明するためには,

$$
\frac{1}{\sqrt{2\pi}}\int_{-\infty}^0 e^{t^2/2}\,dt = \frac{1}{2}
$$

を使ってから, $t=\sqrt{2}\,u$ とおけばよい. ゆえに誤差函数の逆函数 $\op{erfinv}(y)$ (これもコンピュータでの基本特殊函数ライブラリに含まれている)を使えば, 標準正規分布の累積分布函数 $p = F(z)$ の逆函数(分位点函数)は

$$
z = Q(p) = F^{-1}(p) = \sqrt{2}\,\op{erfinv}(2p - 1)
$$

と書ける.  これを使えば $P(Z \le c) = 1 - \alpha/2$ となる $c$ を

$$
c = Q(1 - \alpha/2) = \sqrt{2}\,\op{erfinv}(1 - \alpha)
$$

と求めることができる.

* $1-\alpha=95\%$ のとき, $c = \sqrt{2}\,\op{erfinv}(0.95) \approx 1.96$
* $1-\alpha=99\%$ のとき, $c = \sqrt{2}\,\op{erfinv}(0.99) \approx 2.58$

__解答終__


[Julia言語](https://julialang.org/)では以下のように計算できる. (ただし, `using SpecialFunctions, Distributions` が必要.)

```julia
@show √2 * erfinv(0.95)
@show √2 * erfinv(0.99);
```

```julia
@show quantile(Normal(), 0.975)
@show quantile(Normal(), 0.995);
```

[WolframAlpha](https://www.wolframalpha.com/)では以下のように計算できる:

* [√2 erfinv(0.95)](https://www.wolframalpha.com/input?i=%E2%88%9A2+erfinv%280.95%29)
* [√2 erfinv(0.99)](https://www.wolframalpha.com/input?i=%E2%88%9A2+erfinv%280.99%29)

* [quantile(NormalDistribution(0,1), 0.975)](https://www.wolframalpha.com/input?i=quantile%28NormalDistribution%280%2C1%29%2C+0.975%29)
* [quantile(NormalDistribution(0,1), 0.995)](https://www.wolframalpha.com/input?i=quantile%28NormalDistribution%280%2C1%29%2C+0.995%29)


### 問題: 正規分布のモーメント母函数とキュムラント母函数

$X \sim \op{Normal}(\mu, \sigma)$ のとき次が成立することを示せ:

$$
E[e^{tX}] = e^{\mu t + \sigma^2 t^2/2}, \quad
\log E[e^{tX}] = \mu t + \sigma^2 \frac{t^2}{2}.
$$

__注意:__ 一般に確率変数 $X$ に対して, $E[e^{tX}]$ を $X$ の __モーメント母函数__ (moment generating function, mgf)と呼び, $\log E[e^{tX}]$ を $X$ の __キュムラント母函数__ (cumulant generating function, cgf)と呼ぶ. 

__注意:__ 正規分布のキュムラント母函数は上のように非常に単純な形になる. キュムラント母函数が $t$ について2次式になることと分布が正規分布であることは同値であり, キュムラント母函数中の $t$ について3次以上の項は分布が正規分布とどのように違うかを表している.  特にそのうちの最初の2つである $t^3/3!$ と $t^4/4!$ の係数はそれぞれ __歪度__ (わいど, skewness) と __尖度__ (せんど, kurtosis)と呼ばれている.

__注意:__ モーメント母函数とキュムラント母函数は物理での統計力学での分配函数と自由エネルギーの統計学での類似物になっており, 極めて便利な母函数になっている. 上の $t$ は物理的には逆温度 $\beta$ の $-1$ 倍の $-\beta$ に対応している.

__解答例:__ 

$$
\begin{aligned}
tx - \frac{(x-\mu)^2}{2\sigma^2} &= -
\frac{(x-\mu)^2 - 2\sigma^2 tx}{2\sigma^2} = -
\frac{x^2 - 2(\mu + \sigma^2 t) x + \mu^2}{2\sigma^2} \\ &= -
\frac{(x - (\mu + \sigma^2 t))^2 + \mu^2 - (\mu + \sigma^2 t)^2}{2\sigma^2} \\ &= -
\frac{(x - (\mu + \sigma^2 t))^2 - 2\sigma^2\mu t + \sigma^4 t^2}{2\sigma^2} \\ &= -
\frac{(x - (\mu + \sigma^2 t))^2}{2\sigma^2} + \mu t + \sigma^2\frac{t^2}{2}
\end{aligned}
$$

より

$$
\begin{aligned}
E[e^{tX}] &=
\frac{1}{\sqrt{2\pi\sigma^2}}
\int_{-\infty}^\infty e^{tx} e^{-(x-\mu)^2)/(2\sigma^2)}\,dx \\ &=
\frac{e^{\mu t+\sigma^2 t^2/2}}{\sqrt{2\pi\sigma^2}}
\int_{-\infty}^\infty e^{-(x-(\mu+\sigma^2 t))^2)/(2\sigma^2)}\,dx =
e^{\mu t+\sigma^2 t^2/2}.
\end{aligned}
$$

こらから $\log E[e^{tX}] = \mu t + \sigma^2 t^2/2$ はただちに得られる.

__解答終__


### 問題: キュムラント母函数と期待値と分散

期待値 $\mu$ と分散 $\sigma$ を持つ確率変数 $X$ について次が成立することを示せ:

$$
\log E[e^{tX}] = \mu t + \sigma^2\frac{t^2}{2} + O(t^3)
$$

この結果は期待値と分散の計算に有用な場合がある.  この結果は今後空気のごとく使われる.

__解答例:__ $e^{tX} = 1 + X t + X^2 t^2/2 + O(t^3)$ より,

$$
E[e^{tX}] = 1 + E[X] t + E[X^2] \frac{t^2}{2} + O(t^3).
$$

$\log(1 + a) = a - a^2/2 + O(a^3)$ を使うと,

$$
\begin{aligned}
\log E[e^{tX}] &=
E[X] t + E[X^2] \frac{t^2}{2} - \frac{E[X] t)^2}{2} + O(t^3) \\ &=
E[X] t + (E[X^2] - E[X]^2) \frac{t^2}{2} + O(t^3) =
\mu t + \sigma^2 \frac{t^2}{2} + O(t^3).
\end{aligned}
$$

__解答終__


### 問題: 対数正規分布の確率密度函数

$X \sim \op{Normal}(\mu, \sigma)$ のときの $Y = e^X$ が従う分布を対数正規分布と呼び,

$$
\op{LogNormal}(\mu, \sigma)
$$

と表す. 対数正規分布の確率密度函数を求めよ.

__解答例:__ $x = \log y$ と積分変数を変換すると, $dx = dy/y$ なので,

$$
E[f(Y)] =
\frac{1}{\sqrt{2\pi\sigma^2}}\int_{-\infty}^\infty
f(e^x) \exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)\,dx =
\frac{1}{\sqrt{2\pi\sigma^2}}\int_{-\infty}^\infty
f(y) \exp\left(-\frac{(\log y-\mu)^2}{2\sigma^2}\right)\,\frac{dy}{y}.
$$

ゆえに対数正規分布の確率密度函数は次の形になる:

$$
p(y) = \frac{1}{\sqrt{2\pi\sigma^2}\,y}
\exp\left(-\frac{(\log y-\mu)^2}{2\sigma^2}\right).
$$

__解答終__

```julia
plot(LogNormal(0, 1), 0, 8; label="", title="LogNormal(0, 1)")
```

### 問題: 対数正規分布の期待値と分散

$Y \sim \op{LogNormal}(\mu,\sigma)$ のとき次が成立することを示せ:

$$
E[Y^m] = e^{m\mu+m^2\sigma^2/2}, \quad
E[Y] = e^{\mu + \sigma^2/2}, \quad
\op{var}(Y) = e^{2\mu + \sigma^2}(e^{\sigma^2} - 1).
$$

__解答例:__ $X = \log Y \sim \op{Normal}(\mu, \sigma)$ となるので, $E[Y^m]$ の計算で正規分布のモーメント母函数に関する結果を使え, 次が得られる:

$$
E[Y^m] = E[e^{mX}] = e^{m\mu+m^2\sigma^2/2}.
$$

ゆえに

$$
\begin{aligned}
&
E[Y] = e^{\mu + \sigma^2/2},
\\ &
\op{var}(Y) = E[Y^2] - E[Y]^2 =
e^{2\mu + 2\sigma^2} - e^{2\mu + \sigma^2} =
e^{2\mu + \sigma^2}(e^{\sigma^2} - 1).
\end{aligned}
$$

__解答終__


## $t$ 分布

自由度 $\nu>0$ の$t$ 分布 $\op{TDist}(\nu)$ の確率密度函数は

$$
p(t|\nu) = \frac{1}{\sqrt{\nu}\,B(1/2, \nu/2)}\left(1 + \frac{t^2}{\nu}\right)^{(\nu+1)/2}
$$

であり, これは $\nu\to\infty$ で標準正規分布の確率密度函数 $e^{-t^2/2}/\sqrt{2\pi}$ に収束するのであった.


### 分散パラメータが確率分布に従う正規分布について

$Z$ は標準正規分布に従う確率変数であるとする.

$\sigma > 0$ について, $Z/\sqrt{\sigma^{-2}} = \sigma Z\sim \op{Normal}(0, \sigma)$ となる.

もしも, 値が正の実数になる確率変数 $Y$ の期待値が $\nu$ で標準偏差が $\nu$ との比較で小さいならば $Y/\nu$ の分布はその期待値 $1$ の近くに集中する. (以下, $Z,Y$ は独立であると仮定する.) そのとき, $Z/\sqrt{Y/\nu}$ が従う分布は分散が $1$ の周囲で確率的に揺らぐ「正規分布」に従うことになる.

$Y$ が確率密度函数 $p(y|\nu)$ を持つとき, $z = \sqrt{y/\nu}\,t$, $dz = \sqrt{y/\nu}\,dt$ とおくと,

$$
\begin{aligned}
E[f(Z/\sqrt{Y/\nu})] &=
\int_0^\infty
\left(\int_{-\infty}^\infty
f\left(z/\sqrt{y/\nu}\right) \frac{e^{-z^2/2}}{\sqrt{2\pi}}p(y|\nu)\,dz
\right)dy
\\ &=
\int_0^\infty
\left(\int_{-\infty}^\infty
f(t) \frac{e^{-yt^2/2}}{\sqrt{2\pi}}p(y|\nu)\sqrt{\frac{y}{\nu}}\,dt
\right)dy
\\ &=
\int_{-\infty}^\infty
f(t)\left(
\frac{1}{\sqrt{2\pi\nu}}\int_0^\infty e^{-t^2y/(2\nu)}y^{1/2}p(y|\nu)\,dy
\right)dt
\end{aligned}
$$

なので, 確率変数 $T=Z/\sqrt{Y/\nu}$ は確率密度函数

$$
p(t) = \frac{1}{\sqrt{2\pi\nu}}\int_0^\infty e^{-t^2y/(2\nu)}y^{1/2}p(y|\nu)\,dy
$$

を持つことになる. 

以上のように複数の確率変数を組み合わせて統計モデルを構築することが多い. 実は $t$ 分布もそのような統計モデルの一種とみなせることを次の問題で確認してもらう.  以上を踏まえて次の問題を解け.


### 問題: 分散の $\nu$ 倍が自由度 $\nu$ のχ²分布に従う平均 $0$ の正規分布は $t$ 分布になる

$\nu > 0$ だと仮定する. 確率変数達 $Y, Z$ は独立であるとし(同時確率密度函数がそれぞれの密度函数の積になる), 

$$
Z \sim \op{Normal}(0, 1), \quad
Y \sim \op{Chisq}(\nu) = \op{Gamma}(\nu/2, 2)
$$

と仮定する. $\op{Chisq}(\nu)$ の期待値は $(\nu/2)2 = \nu$ になり, 分散は $(\nu/2)2^2=2\nu$ になり, 標準偏差は $\sqrt{2\nu}$ になるので, $\nu$ が大きければ, 標準偏差は期待値よりも小さくなる. このとき,

$$
T = \frac{Z}{\sqrt{Y/\nu}} \sim \op{TDist}(\nu)
$$

となることを示せ.

__解答例:__ $Y \sim \op{Chisq}(\nu) = \op{Gamma}(\nu/2, 2)$ の確率密度函数は

$$
p(y|\nu) = \frac{1}{2^{\nu/2}\,\Gamma(\nu/2)}e^{-y/2}y^{\nu/2-1} \quad (y>0)
$$

になるので, 前節の結果より, $T$ の確率密度函数が以下のように計算される:

$$
\begin{aligned}
p(t) &=
\frac{1}{\sqrt{2\pi\nu}\,2^{\nu/2}\Gamma(\nu/2)}
\int_0^\infty e^{-t^2y/(2\nu)}y^{1/2}e^{-y/2}y^{\nu/2-1}\,dy
\\ &=
\frac{1}{\sqrt{\nu}\,2^{(\nu+1)/2}\sqrt{\pi}\,\Gamma(\nu/2)}\int_0^\infty
\exp\left( -\frac{1+t^2/\nu}{2}y \right)y^{(\nu+1)/2-1}\,dy
\\ &=
\frac{1}{\sqrt{\nu}\,2^{(\nu+1)/2}\Gamma(1/2)\,\Gamma(\nu/2)}
\left(\frac{1+t^2/\nu}{2}\right)^{-(\nu+1)/2} \Gamma((\nu+1)/2)
\\ &=
\frac{\Gamma((\nu+1)/2)}{\sqrt{\nu}\,\Gamma(1/2)\Gamma(\nu/2)}
\left(1+\frac{t^2}{\nu}\right)^{-(\nu+1)/2}
\\ &=
\frac{1}{\sqrt{\nu}\,B(1/2, \nu/2)}
\left(1+\frac{t^2}{\nu}\right)^{-(\nu+1)/2}
\end{aligned}
$$

3つめの等号で $\Gamma(1/2)=\sqrt{\pi}$ を使い, 4つめの等号でよくあるガンマ函数の使用法を使い, 最後の等号で $\Gamma(\alpha)\Gamma(\beta)=\Gamma(\alpha+\beta)B(\alpha,\beta)$ を使った.  最後の式は $t$ 分布の確率密度函数である. ゆえに $T\sim \op{TDist}(\nu)$.

__解答終__


以上のような積分の計算をすることがどうしても嫌な人は, 以下のようにコンピュータで乱数を発生させてその分布を比較して納得するとよい. 上のような数学の計算が得意な人であっても, 具体的な計算をコンピュータに大量にさせて, その結果を視覚化して確認した方がよい.  「百聞は一見に如かず」は確率分布の世界でも正し.

```julia
function plot_nct(ν; L = 10^6)
    Z = rand(Normal(), L) # 標準正規分布の乱数を大量に生成
    Y = rand(Chisq(ν), L) # χ²分布で乱数達を大量生成
    T_nc = @. Z/√(Y/ν)

    # 比較のための同時プロット
    binmin, binmax = round.(quantile.(TDist(ν), (0.001, 0.999)))
    bin = binmin:0.1:binmax
    histogram(T_nc; norm=true, alpha=0.3, bin, xlim=(-6, 6), label="Z/√(Y/ν)")
    plot!(TDist(ν), binmin, binmax; label="TDist(ν)", lw=1.5)
    plot!(Normal(), binmin, binmax; label="Normal(0,1)", lw=1.5, ls=:dash)
    title!("ν = $ν")
end
```

```julia
plot(plot_nct(1), plot_nct(2); size=(800, 250))
```

```julia
plot(plot_nct(3), plot_nct(4); size=(800, 250))
```

```julia
plot(plot_nct(10), plot_nct(20); size=(800, 250))
```

__注意:__ 一般に $Y\sim\op{Gamma}(\alpha, \theta)$ のとき $Y$ の平均と標準偏差はそれぞれ $\alpha\theta$ と $\sqrt{\alpha}\,\theta$ になるので, で $Y/(\alpha\theta)$ の平均と標準偏差はそれぞれ $1$ と $1/\sqrt{\alpha}$ になる. これは $\alpha$ が大きなとき, $Y/(\alpha\theta)$ の分布は $1$ の近くに集中することを意味している.

```julia
function plot_gamoαθ(α, θ = 1; L = 10^6) # Gamma over αθ
    Y = rand(Gamma(α, θ), L) # χ²分布で乱数達を大量生成
    histogram(Y/(α*θ); norm=true, alpha=0.3, bin=0:0.025:2, label="Y/(αθ)")
    title!("α = $α")
end
```

```julia
plot(plot_gamoαθ(10), plot_gamoαθ(30), plot_gamoαθ(100); size=(800, 200), layout=(1, 3))
```

### 必ず解いて欲しい問題: $t$ 分布における確率が95%または99%になる区間

$0<\alpha<1$, $\nu > 0$ であるとし, $T \sim \op{TDist}(\nu)$ と仮定する. このとき, $T$ が区間 $[-c, c]$ に含まれる確率

$$
P(-c \le T \le c)
$$

が $1 - \alpha$ になるような $c$ を __正則化された不完全ベータ函数__

$$
y = I(x|\alpha,\beta) = I_x(\alpha, \beta) =
\frac{\int_0^x v^{\alpha-1}(1-v)^{\beta-1}\,dv}{B(\alpha, \beta)}
$$

の逆函数 $x = I^{-1}(y|\alpha, \beta)$ を使って表せ.  (注意: $I_x(\alpha, \beta)$ は広く使われている標準的な記号法だが, $I(x|\alpha,\beta)$ と $I^{-1}(y|\alpha, \beta)$ はここだけの記号法である.)

さらに, $\nu = 9$ と $\nu = 19$ と $\nu = 29$ の場合に $P(-c \le T \le c)$ が $95\%$ になる $c$ と $99\%$ になる $c$ を小数点以下第2桁目まで求めよ. 

__お願い:__ この問題の前半部分は少し難しいかもしれないので, どうしても無理ならば以下の解答例をざっと見るだけでもよい. しかし, 後半の「さらに」以降の具体的な数値を求める部分は必ず解けるようになっておいて欲しい. コンピュータを使ってよい. (より正確に言えばコンピュータを使った計算の仕方を1つ以上マスターしておくこと!)

__注意:__ 正規分布モデルの統計学で $t$ 分布に関する計算が不完全ベータ函数に帰着できるという事実から, 正規分布モデルの統計学においてベータ分布が必須であることがわかる.


__解答例:__ 以下 $t\ge 0$ と仮定する.  $t$ 分布の累積分布函数を $F(t)=P(T\le t)$ と書くと, 

$$
F(t) =
\frac{1}{\sqrt{\nu}\,B(1/2, \nu/2)}
\int_{-\infty}^t \left(1 + \frac{s^2}{\nu}\right)^{-(\nu+2)/2}\,ds =
\frac{1}{2} +
\frac{1}{\sqrt{\nu}\,B(1/2, \nu/2)}
\int_0^t \left(1 + \frac{s^2}{\nu}\right)^{-(\nu+2)/2}\,ds.
$$

ベータ函数の様々な表示の計算で学んだように, この積分変数を $s = \sqrt{\nu u}$ ($\iff u = s^2/\nu$)とおいて, さらに $u = v/(1-v) = 1/(1-v)-1$ ($\iff v = u/(1+u)$)とおくとベータ分布の累積分布函数すなわち正則化された不完全ベータ函数に帰着できることがわかる:

$$
\begin{aligned}
F(t) &=
\frac{1}{2} +
\frac{1}{\sqrt{\nu}\,B(1/2, \nu/2)}
\int_0^{t^2/\nu} (1 + u)^{-(\nu+2)/2}\frac{\sqrt{\nu}}{2}u^{-1/2}\,du
\\ &=
\frac{1}{2} +
\frac{1}{2 B(1/2, \nu/2)}
\int_0^{t^2/\nu} \frac{u^{1/2-1}\,du}{(1+u)^{1/2+\nu/2}}
\\ &=
\frac{1}{2} +
\frac{1}{2 B(1/2, \nu/2)}
\int_0^{(t^2/\nu)/(1+t^2/\nu)}
\left(\frac{v}{1 - v}\right)^{1/2-1} 
(1 - v)^{1/2 + \nu/2}\,\frac{dv}{(1-v)^2}
\\ &=
\frac{1}{2} +
\frac{1}{2}
\frac{\int_0^{(t^2/\nu)/(1+t^2/\nu)} v^{1/2-1}(1 - v)^{\nu/2-1}\,dv}{B(1/2, \nu/2)}
\\ &=
\frac{1}{2}\left(
1 + I\left(\left.\frac{t^2/\nu}{1+t^2/\nu}\right|\alpha,\beta\right)
\right).
\end{aligned}
$$

ゆえに, $p = u/(1+u)$ と $u = p/(1-p) = 1/(1-p)-1$ が同値であることを使うと, $t\ge 0$ のとき,

$$
\begin{aligned}
p = F(t) & \iff
I^{-1}(2p-1|\alpha,\beta) = \frac{t^2/\nu}{1+t^2/\nu}
\\ & \iff
\frac{t^2}{\nu} =
\frac{I^{-1}(2p-1|\alpha,\beta)}{1 - I^{-1}(2p-1|\alpha,\beta)} =
\frac{1}{1 - I^{-1}(2p-1|\alpha,\beta)} - 1
\\ & \iff
t = \sqrt{\nu\left(\frac{1}{1 - I^{-1}(2p-1|\alpha,\beta)} - 1\right)}.
\end{aligned}
$$

ゆえに $t\ge 0$ における $p = F(t)$ の逆函数である分位点函数は

$$
t = Q(p) = F^{-1}(p) = \sqrt{\nu\left(\frac{1}{1 - I^{-1}(2p-1|\alpha,\beta)} - 1\right)}
$$

と書ける.

$P(-c\le T\le c) = 1 - \alpha$ と $F(c) = P(T \le c) = 1 - \alpha/2$ は同値なので, そのような $c\ge 0$ は次のように表される:

$$
c = Q(1 - \alpha/2) = \sqrt{\nu\left(\frac{1}{1 - I^{-1}(2p-1|\alpha,\beta)} - 1\right)}.
$$

$\nu = 9$ のとき,

* $P(-c \le T \le c) = 95\%$ となる $c\ge 0$ は $c \approx 2.26$
* $P(-c \le T \le c) = 99\%$ となる $c\ge 0$ は $c \approx 3.25$

$\nu = 19$ のとき,

* $P(-c \le T \le c) = 95\%$ となる $c\ge 0$ は $c \approx 2.09$
* $P(-c \le T \le c) = 99\%$ となる $c\ge 0$ は $c \approx 2.86$

$\nu = 29$ のとき,

* $P(-c \le T \le c) = 95\%$ となる $c\ge 0$ は $c \approx 2.05$
* $P(-c \le T \le c) = 99\%$ となる $c\ge 0$ は $c \approx 2.76$

ちなみに $Z \sim \op{Normal}(0,1)$ のとき,

* $P(-c \le Z \le c) = 95\%$ となる $c\ge 0$ は $c \approx 1.96$
* $P(-c \le Z \le c) = 99\%$ となる $c\ge 0$ は $c \approx 2.58$

__解答終__

```julia
quantile_tdist(ν, p) = √(ν * (1/(1 - beta_inc_inv(1/2, ν/2, 2p - 1)[1]) - 1))
quantile_stdnormal(p) = √2 * erfinv(2p - 1)

for ν in (9, 19, 29)
    @show ν
    @show quantile_tdist(ν, 0.975)
    @show quantile_tdist(ν, 0.995)
    println()
end
ν = Inf
@show ν
@show quantile_stdnormal(0.975)
@show quantile_stdnormal(0.995);
```

```julia
for ν in (9, 19, 29)
    @show ν
    @show quantile(TDist(ν), 0.975)
    @show quantile(TDist(ν), 0.995)
    println()
end
ν = Inf
@show ν
@show quantile(TDist(ν), 0.975)
@show quantile(TDist(ν), 0.995);
```

例えば $\nu = 9$ のとき, WolframAlphaでは以下のように計算できる:

* [sqrt(n (1/(1 - InverseBetaRegularized(0.95, 1/2, n/2)) - 1)) where n = 9](https://www.wolframalpha.com/input?i=sqrt%28n+%281%2F%281+-+InverseBetaRegularized%280.95%2C+1%2F2%2C+n%2F2%29%29+-+1%29%29+where+n+%3D+9),
* [sqrt(n (1/(1 - InverseBetaRegularized(0.99, 1/2, n/2)) - 1)) where n = 9](https://www.wolframalpha.com/input?i=sqrt%28n+%281%2F%281+-+InverseBetaRegularized%280.99%2C+1%2F2%2C+n%2F2%29%29+-+1%29%29+where+n+%3D+9),

* [quantile(StudentTDistribution(9), 0.995)](https://www.wolframalpha.com/input?i=quantile%28StudentTDistribution%289%29%2C+0.995%29)
* [quantile(StudentTDistribution(9), 0.975)](https://www.wolframalpha.com/input?i=quantile%28StudentTDistribution%289%29%2C+0.975%29)


## Poisson分布


### Poisson分布の定義

$\lambda > 0$ と仮定する. 確率質量函数

$$
p(k|\lambda) = e^{-\lambda}\frac{\lambda^k}{k!}
\quad (k = 0,1,2,\ldots)
$$

で定義される無限離散分布を __Poisson分布__ (ポアソン分布)と呼び, 次のように表すことにする:

$$
\op{Poisson}(\lambda).
$$

Poisson分布は一定期間内に起こるイベントの回数の分布のモデル化としてよく使われている. 

```julia
PP = []
for (λ, s) in ((1, 1), (3, 3), (10, 5), (30, 10) )
    x = max(0, round(λ-4√λ)):λ+4√λ+3/√λ
    P = bar(x, k -> pdf(Poisson(λ), k);
        alpha=0.3, label="", title="Poisson($λ)", xtick=0:s:maximum(x))
    push!(PP, P)
end
plot(PP...; size=(800, 150), layout=(1, 4))
```

以上はPoisson分布 $\op{Poisson}(\lambda)$ の確率質量函数のグラフの例である. ここでは $\lambda$ が整数の場合のみを扱ったが, $\lambda$ は整数でなくてもよい.  $\op{Poisson}(30)$ のグラフは正規分布のグラフに近くなっている.  __パラメータ $\lambda$ が大きなPoisson分布は正規分布で近似される.__


### 問題: Poisson分布のキュムラント母函数と期待値と分散

$K_\lambda \sim \op{Poisson}(\lambda)$ のとき次が成立することを示せ:

$$
\log E[e^{tK_\lambda}] = \lambda(e^t - 1), \quad
E[K_\lambda] = \op{var}(K_\lambda) = \lambda.
$$

さらに $K_\lambda$ の標準化 $Z_\lambda$ を $Z_\lambda = (K_\lambda - \lambda)/\sqrt{\lambda}$ と定めると次が成立することも示せ:

$$
\log E[e^{tZ_\lambda}] =
\log E\left[e^{t(K_\lambda-\lambda)/\sqrt{\lambda}}\right] =
\frac{t^2}{2} + O(\lambda^{-1/2}).
$$

ここで $O(\lambda^{-1/2})$ の部分は $O(\lambda)^{-1/2} = \lambda^{-1/2}\times$ ($\lambda\to\infty$ で有界な量)であることを表している. たとえば, $f(\lambda)$ が $\lambda\to\infty$ で収束するとき, $\lambda^{-1/2}f(\lambda)$ は $O(\lambda^{-1/2})$ と表される.  特に $O(\lambda^{-1/2})$ の部分は $\lambda\to\infty$ で $0$ に収束する.

__解答例:__

$$
\begin{aligned}
&
E[e^{tK_\lambda}] =
e^{-\lambda}\sum_{k=0}^\infty e^{tk}\frac{\lambda^k}{k!} =
e^{-\lambda}\sum_{k=0}^\infty \frac{(\lambda e^t)^k}{k!} =
e^{\lambda(e^t - 1)},
\\ &
\log E[e^{tK_\lambda}] = \lambda(e^t - 1) =
\lambda\left(t + \frac{t^2}{2} + O(t^3)\right) =
\lambda t + \lambda \frac{t^2}{2} + O(t^3).
\end{aligned}
$$

$\log E[e^{tK_\lambda}]$ の展開における $t$, $t^2/2$ の係数がそれぞれ $K_\lambda$ の期待値, 分散になるので

$$
E[K_\lambda] = \op{var}(K_\lambda) = \lambda.
$$

さらに, $Z_\lambda = (K_\lambda - \lambda)/\sqrt{\lambda})$ について

$$
\begin{aligned}
\log E[e^{tZ_\lambda}] &=
\log\left(e^{-\sqrt{\lambda}\, t} E\left[e^{\left(t/\sqrt{\lambda}\right)K_\lambda}\right]\right) =
\log E\left[e^{\left(t/\sqrt{\lambda}\right)K_\lambda}\right] - \sqrt{\lambda}\, t) \\ &=
\lambda\left(e^{t/\sqrt{\lambda}} - 1\right) - \sqrt{\lambda}\, t) =
\lambda\left(\frac{t}{\sqrt{\lambda}} + \frac{t^2}{2\lambda} + O(\lambda^{-3/2})\right) - \sqrt{\lambda}\,t \\ &=
\left(\sqrt{\lambda}\, t  + \frac{t^2}{2} + O(\lambda^{-1/2})\right) - \sqrt{\lambda}\,t =
\frac{t^2}{2} + O(\lambda^{-1/2}).
\end{aligned}
$$

__解答終__

__注意:__ 上の問題の結果より, $K_\lambda \sim \op{Poisson}(\lambda)$, $Z_\lambda = (K_\lambda - \lambda)/\sqrt{\lambda}$, $Z_\infty\sim\op{Normal}(0,1)$ のとき, $\lambda$ を大きくすると $\log E[e^{tZ_\lambda}]$ が $\log E[e^{tZ_\infty}]$ に収束する.  (一般に確率変数 $X$ の分布はそのキュムラント母函数 $\log E[e^{tX}]$ から一意的に決まる.  この点については別のノートで説明する.) これは実は $\lambda$ が大きなとき, $Z_\lambda = (K_\lambda - \lambda)/\sqrt{\lambda}$ の従う分布が標準正規分布で近似されることを意味している.  そのとき, もとの $K_\lambda$ の分布は平均 $\lambda$, 分散 $\lambda$ の正規分布で近似される.  この結果を, __Poisson分布の中心極限定理__ と呼ぶ.

```julia
PP = []
for λ in (10, 30)
    P = bar(max(0, round(λ-4√λ)):λ+4√λ+3/√λ, k -> pdf(Poisson(λ), k);
        alpha=0.3, label="", title="Poisson(λ = $λ)")
    plot!(Normal(λ, √λ); label="Normal(λ, √λ)", lw=2)
    push!(PP, P)
end
plot(PP...; size=(800, 250), layout=(1, 2))
```

### 二項分布の連続時間極限

期待値 $\lambda$ のPoisson分布は同じ期待値を持つ $p$ が小さな二項分布によって近似されることを示そう. 二項分布 $\op{Bonomial}(n, p)$ の期待値は $np$ なので, $p = \lambda/n$ とおくと期待値は $\lambda$ になる. そのように $p$ を定めて, $n\to\infty$ とすると, 以下のように, 二項分布の確率質量函数はPoisson分布の確率質量函数に収束する:

$$
\begin{aligned}
\binom{n}{k}p^k(1-p)^{n-k} &=
\frac{n(n-1)\cdots(n-k+1)}{k!}
\left(\frac{\lambda}{n}\right)^k\left(1-\frac{\lambda}{n}\right)^{n-k} \\ &=
\underbrace{\left(1-\frac{1}{n}\right)\cdots\left(1-\frac{k-1}{n}\right)}_{\to 1}\,
\underbrace{\left(1-\frac{\lambda}{n}\right)^{n-k}}_{\to \exp(-\lambda)}\,
\frac{\lambda^k}{k!} \to
e^{-\lambda} \frac{\lambda^k}{k!}.
\end{aligned}
$$

1つめの等号で二項係数の定義と $p=\lambda/n$ を使い, 2つめの等号で分子の $n(n-1)\cdots(n-k+1)$ を $(\lambda/n)^k = \lambda^k/n^k$ の分母の $n^k$ で割った.  最後に $n\to\infty$ の極限を取った.


### Poisson分布は単位時間内に起こるイベントの回数の分布だとみなされる

前節の結果は以下のように解釈される.

(1) 二項分布は $n$ 回のBernoulli試行で出る $1$ の個数の分布であった. $1$ が出ることを「イベントが起こった」と解釈することにする.

(2) $n$ 回の試行を単位時間内に等間隔で行う状況を考える.  これは時間の刻み幅が $1/n$ の離散時間を考えることに相当する. そのとき, 二項分布は単位時間のあいだに平均して $np$ 回起こるイベントが単位時間内で何回起こるかに関する分布になっている. 

(3) 単位時間内に起こる二項分布に従うイベントの回数の期待値 $np$ を $np = \lambda$ と固定したままで, $n\to\infty$ とすることは, 時間の刻み幅を細かくする連続時間極限を取ることだと考えられる.  この極限によって, 二項分布はPoisson分布に収束する.

(4) __Poisson分布は, 連続時間の場合に単位時間のあいだに平均して $\lambda$ 回起こるイベントが単位時間内で何回起こるかに関する分布になっている.__

```julia
function plot_binpoi(λ, n)
    @assert n > λ
    p = λ/n
    x = range(max(-0.5, λ - 5√λ), λ + 6√λ, 1000)
    plot(x, x -> pdf(Binomial(n, p), round(Int, x)); label="Binomial(n, p)")
    plot!(x, x -> pdf(Poisson(λ), round(Int, x)); label="Poisson(λ)", ls=:dash)
    title!("λ = $λ, n = $n, p = λ/n")
end
```

```julia
plot(plot_binpoi(1, 5), plot_binpoi(1, 15), plot_binpoi(1, 50); size=(800, 200), layout=(1, 3))
```

```julia
plot(plot_binpoi(3, 15), plot_binpoi(3, 45), plot_binpoi(3, 150); size=(800, 200), layout=(1, 3))
```

```julia
plot(plot_binpoi(10, 50), plot_binpoi(10, 150), plot_binpoi(10, 500); size=(800, 200), layout=(1, 3))
```

### Poisson分布の中心極限定理と二項分布の中心極限定理の関係

一般に期待値 $\mu$, 標準偏差 $\sigma$ を持つ確率変数 $X$ の __標準化__ $Z$ は $Z=(X-\mu)/\sigma$ と定義される.

そのとき $\log E[e^{tZ}]$ を $X$ の __標準化キュムラント母函数__ と呼ぶ.

標準化キュムラント母函数が正規分布の標準化キュムラント母函数 $t^2/2$ にどれだけ近いかは, その分布が正規分布にどれだけ近いかを表している(この点については後で中心極限定理について一般的に説明するときに再度触れる).

Poisson分布のキュムラント母函数に関する問題の結果によれば,

$$
K_\lambda \sim \op{Poisson}(\lambda), \quad
Z_\lambda = \frac{K_\lambda - \lambda}{\sqrt{\lambda}}
\quad\implies\quad
\log E[e^{tZ_\lambda}] = \frac{t^2}{2} + O(\lambda^{-1/2}).
$$

これより, $\lambda$ を大きくすると, Poisson分布は正規分布で近似されるようになることがわかる. この結果を__Poisson分布の中心極限定理__と呼ぶことにする.

さらに, 前節の結果より, $\lambda = np$ を一定としたままで, $n$ を大きくすると, 二項分布 $\op{Binomial}(n, p)$ はPoisson分布 $\op{Poisson}(\lambda)$ で近似される. 

そのとき注意するべきことは $\op{Binomial}(n, p)$ の分散 $np(1-p)$ は $np = \lambda$ のとき $np(1-p) = \lambda(1-p)$ になり, $p$ が小さくないと, $\op{Poisson}(\lambda)$ の分散 $\lambda$ と全然違う値になってしまうことである(たとえば $p=1/2$ だと二項分布の分散が対応するPoisson分布の分散の半分になってしまう).  二項分布によるPoisson分布の近似は $p$ が小さくないと精度が低くなる.

しかし, 以上の2つの結果を合わせると, Poisson分布の正規分布近似(=中心極限定理)を通して, $p$ は小さいが $np$ が大きい場合の二項分布 $\op{Binomial}(n, p)$ が正規分布で近似されることがわかる.  実際には, $p$ が小さくなくても, $np$ と $n(1-p)$ が大きければ, 二項分布は正規分布でよく近似される. 二項分布が正規分布で近似されるという結果を __二項分布の中心極限定理__ と呼ぶ.

$p$ が小さい場合の二項分布の中心極限定理は応用上あまりににも不完全なので, 後で二項分布を直接正規分布で近似するという $p$ が小さくない場合にも通用する方法で二項分布の中心極限定理を証明する.

__注意:__ 「中心極限定理」は「極限として中心に収束する定理」という意味では __ない__.  「中心極限定理」は「確率論における中心的な極限定理」という意味である.  「中心極限定理」はある種の状況で分布が正規分布で近似されるようになるという結果に付けられた名前である.

```julia
PP = []
for (λ, n) in ((15, 20), (15, 300))
    p = λ/n
    ks = max(0, round(Int, λ-5.5√λ)):round(Int, λ+5.5√λ+3/√λ)
    P = groupedbar(ks, 
        [pdf.(Poisson(λ), ks) pdf.(Binomial(n, λ/n), ks)];
        alpha=0.3,
        label=["Poisson(λ)" "Binomial(n,λ/n)"],
        title="λ = $λ,  n = $n,  p = λ/n = $p")
    plot!(Normal(λ, √λ); label="Normal(λ,√λ)", lw=1.5, c=:blue)
    plot!(Normal(λ, √(λ*(1-p))); label="Normal(λ,√(λ(1-p)))", lw=1.5, ls=:dash, c=:red)
    push!(PP, P)
end
plot(PP...; size=(800, 250), layout=(1, 2))
```

左側のグラフでは $p = \lambda/n = 3/4$ なので, 二項分布の側の分散はPoisson分布の側の分散の4分の1になっており, 標準偏差については半分になっている.

右側のグラフでは $p = \lambda/n = 1/20$ が小さくなっているので, 二項分布のグラフとPoisson分布のグラフはほとんど一致し, 正規分布による近似もほとんど一致する.


### 問題: Poisson分布の中心極限定理の直接証明

パラメータ $\lambda > 0$ を持つPoisson分布の確率質量函数の定義は

$$
p(k|\lambda) = e^{-\lambda}\frac{\lambda^k}{k!}
\quad (k = 0,1,2,\ldots)
$$

であった.  $k$ は $\lambda$ ごとに異なる値を取るものとし, 固定された $x$ について

$$
k = \lambda + \sqrt{\lambda}\, x + o(\sqrt{\lambda})
$$

を満たしていると仮定する. ここで $o(\sqrt{\lambda})$ は $\sqrt{\lambda}$ で割ると $\lambda\to\infty$ で $0$ に収束する量を表す.  このとき次が成立することを示せ:

$$
p(k|\lambda) = \frac{e^{-x^2/2}}{\sqrt{2\pi}} \frac{1}{\sqrt{\lambda}}\,(1 + o(1)).
$$

ここで $o(1)$ は $\lambda\to\infty$ で $0$ に収束する量である.

__注意:__ __以下の解答例は二項分布の中心極限定理の証明のひな型になる.__


__解答例:__ まず, 問題文よりも弱い次の条件を仮定する:

$$
k = \lambda + o(\lambda) = \lambda(1 + o(1))
$$

ここで $o(\lambda)$ は $\lambda$ で割ると $\lambda\to\infty$ で $0$ に収束する量である.  このとき, $k!$ にStirlingの公式を適用すると,

$$
p(k|\lambda) =
e^{-\lambda}\frac{\lambda^k}{k^k e^{-k} \sqrt{2\pi k}}(1 + o(1)) =
\frac{1}{\sqrt{2\pi\lambda}}
\left(\frac{k}{\lambda}\right)^{-k} e^{k - \lambda}
(1 + o(1)).
$$

そして,

$$ -
\log\left( \left(\frac{k}{\lambda}\right)^{-k} e^{k - \lambda} \right) =
k\log\frac{k}{\lambda} - (k - \lambda)
$$

を $f(k)$ と書くと, $f(\lambda)=0$, $f'(k) = \log(k/\lambda)$, $f'(\lambda)=0$, $f''(k)=1/k$, $f''(\lambda)=1/\lambda$, $f'''(k)=-1/k^2$, $f'''(\lambda)=-1/\lambda^2$, etc. なので, $f(k)$ は $k = \lambda$ で次のようにTaylor展開される:

$$
k\log\frac{k}{\lambda} + k - \lambda = f(k) =
\frac{1}{2}\frac{(k - \lambda)^2}{\lambda} - \frac{1}{3!}\frac{(k - \lambda)^3}{\lambda^2} + \cdots
$$

ゆえに, 問題文のように

$$
k = \lambda + \sqrt{\lambda}\, x + o(\sqrt{\lambda})
$$

と仮定すると, 

$$
\frac{k-\lambda}{\lambda} = \frac{x}{\sqrt{\lambda}} + o(\lambda^{-1/2}) = O(\lambda^{-1/2}), \quad
\frac{(k-\lambda)^2}{\lambda^2} = \frac{x^2}{\lambda} + o(\lambda^{-1}) = O(\lambda^{-1}), \quad
\text{etc.}
$$

なので

$$
\frac{(k-\lambda)^2}{\lambda} = x^2 + o(1), \quad
\frac{(k-\lambda)^3}{\lambda^2} = O(\lambda^{-1/2}) = o(1), \quad
\text{etc.}
$$

となり, 次が得られる:

$$
k\log\frac{k}{\lambda} + k - \lambda = \frac{x^2}{2} + o(1).
$$

したがって,

$$
p(k|\lambda) =
\frac{1}{\sqrt{2\pi\lambda}}\exp\left(-\frac{x^2}{2} + o(1)\right)(1 + o(1)) =
\frac{1}{\sqrt{2\pi\lambda}}e^{-x^2/2}\,(1 + o(1)).
$$

これで示したい公式が得られた.

__解答終__


__注意:__ 上の計算の途中で出て来た式

$$
\log\left(
\left(\frac{k}{\lambda}\right)^{-k} e^{k - \lambda}
\right) = -
k\log\frac{k}{\lambda} + k - \lambda
$$

における $k\log(k/\lambda)$ の部分は __Kullback-Leibler情報量__

$$
D(q||p) = \sum_i q_i \log\frac{q_i}{p_i}
$$

の各項に化ける式になっている.


__注意:__ 上の計算の途中で出て来た式

$$
\frac{(k-\lambda)^2}{\lambda} = x^2 + o(1)
$$

の左辺は, __Pearsonのχ²検定量__

$$
\sum_i \frac{(\text{observation}_i - \text{expectation}_i)^2}{\text{expectation}_i}
$$

の各項に化ける式になっている.


__注意:__ このように, Poisson分布の中心極限定理を直接証明することには, 統計学的に重要な数学的対象の構成要素を得る行為にもなっている!


### Poisson分布のパラメータがガンマ分布に従っていれば負の二項分布が得られる

Poisson分布は単位時間内に起こるイベントの回数の分布とみなされるのであった. 

Poisson分布でモデル化できると期待される現実の現象のデータを複数の対象について取得したとする. そのとき, そのすべてについて, 一定期間のあいだにイベントが起こる回数の期待値 $\lambda$ が等しいと期待できるならば, Poisson分布モデルを単純に適用すればよい.

しかし, データを取得した対象ごとに, 期待値が異なると考えられる場合にはどうすればよいだろうか?

例えば, 野球選手達が年間何本ホームランを打つかについてデータを取得したとする. 選手ごとに打つホームランの回数の期待値は異なると考えられる.

そのような場合には, ホームランの本数の期待値の選手間でのばらつき方も確率分布でモデル化すればよい.

たとえば一定期間内で打つホームランの本数の期待値の分布をガンマ分布でモデル化するとどうなるだろうか?

実はその場合には, ホームランの本数の分布を負の二項分布でモデル化したのと同じことになる.

次の問題ではそのことを実際に計算して確認してもらおう.


### 問題: Poisson分布とガンマ分布から負の二項分布が得られる

$\alpha, \theta > 0$ であるとし, 確率変数 $\Lambda$ は次のようにガンマ分布に従っていると仮定する: 

$$
\Lambda \sim \op{Gamma}(\alpha, \theta).
$$

さらに確率変数 $M$ はパラメータが確率変数 $\Lambda$ であるようなPoisson分布に従っていると仮定する:

$$
M \sim \op{Poisson}(\Lambda).
$$

これの意味は乱数の生成を考えるとわかりやすい. この確率変数 $M$ に対応する乱数は以下の手続きで生成されると考える:

1. 分布 $\op{Gamma}(\alpha, \theta)$ に従って乱数 $\Lambda$ を生成する.
2. 分布 $\op{Poisson}(\Lambda)$ に従って乱数 $M$ を生成する.

このとき, $M$ の分布が従う確率質量函数は次になることを示せ:

$$
P(m|\alpha,\theta) =
\binom{\alpha+m-1}{m}
\left(\frac{1}{1+\theta}\right)^\alpha
\left(1 - \frac{1}{1+\theta}\right)^m
\quad (m=0,1,2,\ldots)
$$

これは負の二項分布 $\op{NegativeBinomial}(\alpha, \theta/(1+\theta))$ の確率質量函数に一致する.  これによって, 負の二項分布の通常の解釈「$\alpha$ 回成功するまでに失敗する回数の分布」とは別の解釈が得られた.  負の二項分布は「期待値パラメータが固定されてなくてガンマ分布に従っているようなPoisson分布」であるとも考えられる. (この場合には「成功回数」にあたる $\alpha$ は整数でなくても任意の正の実数になれる.)

ただし, $\op{Gamma}(\alpha, \theta)$ の確率密度函数を $p(\lambda|\alpha,\theta)$ と書き, $\op{Poisson}(\lambda)$ の確率質量函数を $P(m|\lambda)$ と書くとき, 上のような状況における $M$ が従う分布の確率質量函数 $P(m|\alpha,\theta)$ は

$$
P(m|\alpha,\theta) = \int_0^\infty P(m|\lambda)p(\lambda|\alpha,\theta)\,d\lambda
$$

と定義される.


__解答例:__ $p(\lambda|\alpha,\theta)$, $P(k|\lambda)$ の定義は次の通り:

$$
p(\lambda|\alpha,\theta) = \frac{e^{-\lambda/\theta} x^{\alpha-1}}{\theta^\alpha\Gamma(\alpha)}, \quad
P(k|\lambda) = \frac{e^{-\lambda}\lambda^k}{k!}.
$$

ゆえに, ガンマ函数の基本的な使い方である

$$
\int_0^\infty e^{-\lambda/\eta} \lambda^{\beta-1}\,d\lambda = \eta^\beta\Gamma(\beta)
$$

を $\eta = \theta/(1+\theta)$, $\beta=\alpha+m$ の場合に使うと,

$$
\begin{aligned}
P(m|\alpha,\theta) &=
\int_0^\infty P(m|\lambda)p(\lambda|\alpha,\theta)\,d\lambda =
\int_0^\infty
\frac{e^{-\lambda}\lambda^m}{m!}
\frac{e^{-\lambda/\theta} x^{\alpha-1}}{\theta^\alpha\Gamma(\alpha)}
\,d\lambda
\\ &=
\frac{1}{m!\theta^\alpha\Gamma(\alpha)}
\int_0^\infty
e^{-((1 + \theta)/\theta)\lambda} \lambda^{\alpha+m-1}\,d\lambda
\,d\lambda
\\ &=
\frac{1}{m!\theta^\alpha\Gamma(\alpha)}
\left(\frac{\theta}{1+\theta}\right)^{\alpha+m}\Gamma(\alpha+m)
\\ &=
\frac{(\alpha+m-1)\cdots(\alpha+1)\alpha}{m!}
\left(\frac{1}{1+\theta}\right)^\alpha
\left(\frac{\theta}{1+\theta}\right)^m
\\ &=
\binom{\alpha+m-1}{m}
\left(\frac{1}{1+\theta}\right)^\alpha
\left(1 - \frac{1}{1+\theta}\right)^m.
\end{aligned}
$$

__解答終__


この手の積分計算をサボりたい人は, 以下のようにコンピュータでガンマ分布の乱数を発生させて, それをパラメータとするPoisson分布の乱数を発生させることを大量に実行し, それと負の二項分布を直接使って生成した乱数の分布を比較してみるとよい.

```julia
function plot_gampoi(α, θ; L = 10^6)
    p = 1/(1 + θ)
    Λ = rand(Gamma(α, θ), L) # ガンマ分布で乱数達を大量生成
    M_gampoi = @. rand(Poisson(Λ)) # その各々を期待値とするPoisson分布の乱数を生成
    M_negbin = rand(NegativeBinomial(α, p), L) # 直接的に負の二項分布の乱数を大量生成

    # 比較のための同時プロット
    binmin, binmax = round.(quantile.(Ref(M_negbin), (0.001, 0.999)))
    stephist(M_gampoi; norm=true, bin=binmin-0.5:binmax+0.5, label="Gamma-Poisson")
    stephist!(M_negbin; norm=true, bin=binmin-0.5:binmax+0.5, ls=:dash, label="NegativeBinomial")
end
```

```julia
plot(plot_gampoi(1, 3), plot_gampoi(3, 1); size=(800, 250), layout=(1, 2)) 
```

```julia
plot(plot_gampoi(6, 2), plot_gampoi(10, 1); size=(800, 250), layout=(1, 2)) 
```

このようにMonte Carloシミュレーション(コンピュータで乱数を発生させることによるシミュレーション)でも, 期待値パラメータがガンマ分布に従っているようなPoisson分布と負の二項分布はぴったり一致している.


__注意:__ $p = 1/(1+\theta)$ とおくと, $1-p=\theta/(1+\theta)$ になるので, 負の二項分布 $\op{NegativeBinomial}(\alpha, \theta/(1+\theta))$ の期待値と分散はそれぞれ次のように書ける:

$$
E[M] = \frac{\alpha(1-p)}{p} = \alpha\theta, \quad
\op{var}(M) = \frac{\alpha(1-p)}{p^2} = \alpha\theta(1+\theta).
$$

Poisson分布では期待値と分散が等しかったが, この場合には $1 + \theta$ 倍の分だけ分散が期待値よりも大きくなっている.  これより, $\mu = \alpha\theta$ を一定に保ったままで $\theta\searrow 0$ とすると負の二項分布 $\op{NegativeBinomial}(\alpha, \theta/(1+\theta))$ がPoisson分布 $\op{Poissom}(\mu)$ に収束すると予想されるが実際にそうなる:  $\alpha = \mu/\theta$ とおいて, $\theta\searrow 0$ とすると,

$$
\begin{aligned}
P(m|\alpha,\theta) &=
\binom{\alpha+m-1}{m}
\left(\frac{1}{1+\theta}\right)^\alpha
\left(1 - \frac{1}{1+\theta}\right)^m
\\ &=
\frac{(\mu/\theta+m-1)\cdots(\mu/\theta+1)(\mu/\theta)}{m!}
\left(\frac{1}{1+\theta}\right)^{\mu/\theta}
\left(\frac{\theta}{1+\theta}\right)^m
\\ &=
\underbrace{\frac{(\mu+(m-1)\theta)\cdots(\mu+\theta)\mu}{m!}}_{\to\mu^m/m!}
\underbrace{\left(\frac{1}{1+\theta}\right)^{\mu/\theta}}_{\to\exp(-\mu)}
\underbrace{\left(\frac{1}{1+\theta}\right)^m}_{\to 1}\to
\frac{e^{-\mu}\mu^m}{m!}.
\end{aligned} 
$$

$\alpha=\mu/\theta$ とおいて, $\theta$ を小さくすると, $\op{Gamma}(\mu/\theta,\theta)$ の分布は $\mu$ に集中して行くのでこうなるとも考えられる.

```julia
PP = []
μ = 3
for α in (10, 30, 100)
    θ = μ/α
    P = plot(Gamma(α,θ), 0, 6; label="", title="Gamma($α, $θ)")
    push!(PP, P)
end
plot(PP...; size=(800, 200), layout=(1, 3))
```

```julia
PP = []
μ = 3
for α in (10, 30, 100)
    θ = μ/α
    p = 1/(1 + θ)
    x = max(0, round(Int, μ - 4√μ)):round(Int, μ + 4√μ)
    y1 = pdf.(NegativeBinomial(α, p), x)
    y2 = pdf.(Poisson(μ), x)
    P = groupedbar(x, [y1 y2]; alpha=0.5, label=["NegBin" "Poisson"])
    title!("μ = $μ, α = $α, θ = $θ")
    push!(PP, P)
end
plot(PP...; size=(800, 200), layout=(1, 3))
```

### Poisson分布の累積分布函数とガンマ分布の累積分布函数の関係


## ガンマ分布

形状パラメータ $\alpha>0$, スケールパラメータ $\theta>0$ を持つガンマ分布 $\op{Gamma}(\alpha, \theta)$ の確率密度函数は

$$
p(y|\alpha,\beta) =
\frac{1}{\theta^\alpha\Gamma(\alpha)} e^{-y/\theta}y^{\alpha-1}
\quad (y > 0)
$$

であった. 我々は別のノートでガンマ分布を「正規分布に関係した分布」として導入したのであった(χ²分布はガンマ分布の特別な場合であった). 以下の2つの問題を見よ.  その後にガンマ分布の別の解釈を説明する.


### 問題: 標準正規分布に従う確率変数の2乗は自由度1のχ²分布に従う

標準正規分布に従う確率変数の2乗は自由度1のχ²分布に従うことを示せ.

__解答例:__ $Z\sim\op{Normal}(0,1)$ のとき, $Y=Z^2$ とおくと,

$$
\begin{aligned}
E[f(Y)] &=
\int_{-\infty}^\infty f(z^2) \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz =
2\int_0^\infty f(z^2) \frac{e^{-z^2}/2}{\sqrt{2\pi}}\,dz \\ &=
\int_0^\infty f(y) \frac{e^{-y/2}}{\sqrt{2\pi}}y^{-1/2}\,dy =
\int_0^\infty f(y) \frac{e^{-y/2}y^{1/2-1}}{2^{1/2}\Gamma(1/2)}\,dy
\end{aligned}
$$

2つめの等号で被積分函数が偶函数であることを使い, 3つめの等号で $z=\sqrt{y}$ とおき, 最後の等号で $\Gamma(1/2)=\sqrt{\pi}$ を使った.  これは $Y$ がχ²分布に従うことを意味している.

__解答終__

```julia
L = 10^6
Z = rand(Normal(), L)
Y = @. Z^2
histogram(Y; norm=true, alpha=0.3, label="Y = Z²")
plot!(Chisq(1); label="Chisq(1)", lw=1.5)
plot!(; xlim=(-0.2, 4.2), ylim=(-0.2, 4.2))
```

### 問題: 標準正規分布に従う $n$ 個の独立な確率変数達の2乗は自由度 $n$ のχ²分布に従う

標準正規分布に従う $n$ 個の独立な確率変数達の2乗は自由度 $n$ のχ²分布に従うことを示せ.

__解答例:__ $Z_1,\ldots,Z_n$ は独立な確率変数達であるとし, $Z_i\sim\op{Normal}(0,1)$ となっていると仮定する. このとき, 1つ上の問題より, 各 $i$ ごとに $Z_i^2 \sim \op{Chisq}(1) = \op{Gamma}(1/2, 1/2)$ となり, $Z_1^2,\ldots,Z_n^2$ は独立な確率変数達になる.

一般に, $X,Y$ が独立な確率変数達で $X\sim\op{Gamma}(\alpha, \theta)$, $Y\sim\op{Gamma}(\beta, \theta)$ のとき, $X+Y \sim \op{Gamma}(\alpha+\beta, \theta)$, $X/(X+Y)\sim\op{Beta}(\alpha,\beta)$ で $X+Y$, $X/(X+Y)$ は独立になるのであった. この結果を上の状況で使うと, 

$$
Z_1^2 + \cdots + Z_n^2 \sim \op{Gamma}(\underbrace{1/2+\cdots+1/2}_n, 1/2) =
\op{Gamma}(n/2, 1/2) = \op{Chisq}(n)
$$

となることがわかる.

__解答終__

```julia
L = 10^6
n = 5
Z = rand(Normal(), n, L)
Y = [sum(z -> z^2, Z) for Z in eachcol(Z)]
histogram(Y; norm=true, alpha=0.3, bin=100, label="Z₁² + ⋯ + Zₙ²")
plot!(Chisq(n); label="Chisq(1)", lw=1.5)
plot!(; xlim=(-1, 20))
title!("n = $n")
```

### 負の二項分布の連続時間極限

ガンマ分布 $\op{Gamma}(\alpha, \theta)$ が負の二項分布の連続極限になっていることを説明する. 以下ではガンマ分布が時間幅に関する確率分布だとみなしたいので, ガンマ分布に従う確率変数を $T$ と書き, 対応する通常の変数を $t$ と書くことにする.

負の二項分布は成功確率 $0 < p \le 1$ のBernoulli試行を $\alpha > 0$ 回成功するまで続けたときに失敗する回数 $M$ が従う分布であり, その確率質量函数は

$$
P(m|\alpha, p) = \binom{\alpha+m-1}{m} p^\alpha(1-p)^m
\quad (m=0,1,2,\ldots)
$$

と書けるのであった(分布がうまく定義されるために $\alpha$ は整数でなくてもよい). このときの総試行回数 $N$ は $N = \alpha + M$ と書ける.  $N$ が取り得る値の全体は $\alpha, \alpha+1, \alpha+2, \ldots$ になる.

一般に二項係数は

$$
\binom{\alpha+m-1}{m} =
\frac{\Gamma(\alpha+m)}{\Gamma(m+1)\Gamma(\alpha)} =
\frac{\Gamma(\alpha+m+1)}{(\alpha+m)\Gamma(m+1)\Gamma(\alpha)} =
\frac{1}{(\alpha+m)B(\alpha, m+1)}
$$

とベータ函数で書けるので, $N$ が従う分布の確率質量函数は次のように書ける:

$$
\begin{aligned}
P(n-\alpha|\alpha, p) &=
\frac{1}{n B(\alpha, n-\alpha+1)} p^\alpha(1-p)^{n-\alpha}
\end{aligned}
$$

$L > 0$ であるとし, 単位時間に $L$ 回にBenoulli試行を行い, 単位時間内での成功回数(イベントが起こる回数)の期待値 $Lp$ は一定であり,

$$
Lp = \frac{1}{\theta}
$$

を満たしていると仮定する($p$ はこれによって $L$ の函数とみなす).  これは固定された $\theta$ について, 単位時間に平均して $1/\theta$ 回のイベントが起こるという仮定であり, この仮定はイベントが起こる間隔の期待値が $\theta$ であるという仮定と同等である.

さらにこのとき, 試行回数を表す通常の変数 $n$ から離散時間変数 $t$ が

$$
t = \frac{n}{L}
$$

と定義される. このとき単位時間分の試行が行われたとき $n=L$ となり, $t=1$ となるのでつじつまが合っている.

以上の設定のもとで, 時間の刻み幅を $0$ に近付ける $L\to\infty$ で負の二項分布の確率質量函数がどのように振る舞うかを調べよう.  $n = Lt$ と $p = 1/(L\theta)$ を上の式に代入すると, $L\to\infty$ において,

$$
\begin{aligned}
P(Lt-\alpha|\alpha, 1/(L\theta)) &=
\frac{1}{Lt\,B(\alpha, Lt-\alpha+1)}
\frac{1}{(L\theta)^\alpha}\left(1-\frac{1}{L\theta}\right)^{Lt-\alpha}
\\ &=
\frac{1}{(Lt)^\alpha\,B(\alpha, Lt-\alpha+1)}
\frac{(Lt)^{\alpha-1}}{(L\theta)^\alpha}\left(1-\frac{1}{L\theta}\right)^{Lt-\alpha}
\\ &=
\frac{1}{\theta^\alpha\,\underbrace{(Lt)^\alpha\,B(\alpha, Lt-\alpha+1)}_{\to\Gamma(\alpha)}}
\underbrace{\left(1-\frac{1}{L\theta}\right)^{Lt-\alpha}}_{\to\exp(-t/\theta)}
\;t^{\alpha-1}
\frac{1}{L}
\\ &=
\frac{1}{\theta^\alpha\Gamma(\alpha)} e^{-t/\theta} t^{\alpha-1} \frac{1}{L}
\,(1 + O(1/L)).
\end{aligned}
$$

ここで $K^\alpha B(\alpha, K+b)\to\Gamma(\alpha)$ ($K\to\infty$) となることを使った.

$1/L$ は離散時間 $t$ の刻み幅なので, この式は時間の刻み幅を $0$ に近付ける $L\to\infty$ の極限で, 負の二項分布がガンマ分布に収束することを意味している:

$$
\frac{\alpha + \op{NegativeBinomial}(\alpha, p = 1/(L\theta))}{L} \to
\op{Gamma}(\alpha, \theta)
\quad (L\to\infty)
$$


### ガンマ分布はイベントが $\alpha$ 回起こるまでにかかる時間の分布とみなされる

前節の結果は以下のように解釈される.

(1) 負の二項分布は成功確率 $p$ のBernoulli試行を $1$ が $\alpha$ 回出るまでに出た $0$ の個数 $M$ の分布であった. 以下では $1$ が出たことを「イベントが起こった」と解釈することにし, イベントが $\alpha$ 回起こるまでの試行回数 $N = \alpha + M$ の分布を考える.

(2) さらに, 試行を単位時間あたり $L$ 回の等間隔で行う状況を考える.  これは刻み幅が $1/L$ の離散時間を考えることに相当する. そのとき, $T = N/L$ は $\alpha$ 回イベントが起こるまでにかかる時間を意味する.

(3) 単位時間内に起こるイベントの回数の期待値 $Lp = 1/\theta$ を固定したままで, $L\to\infty$ とすることは, イベントが起こる間隔の期待値を $\theta$ に固定して連続時間極限を取ることだと考えられる.  この極限によって, 負の二項分布における $T=N/L$ の分布はガンマ分布に収束する.

(4) __ガンマ分布は, 連続時間の場合に, イベント起こる間隔の期待値が $\theta$ であるときに, $\alpha$ 回のイベントが起こるまでにかかる時間の分布になっている.__


### 負の二項分布の連続時間極限の様子をプロット

前節の計算より, $L$ が大きなとき, ガンマ分布 $\Gamma(\alpha, \theta)$ の確率密度函数 $p(t|\alpha,\theta)$ を近似する函数を, 負の二項分布の確率質量函数 $P(m|\alpha, p)$ を使って次のように作れることがわかる:

$$
p_{\text{approx}}(t|\alpha, \theta, L) =
P\bigl(\op{round}(Lt-\alpha)\bigm|\alpha, 1/(L\theta)\bigr)L.
$$

$T=N/L$ を $M=N-\alpha$ について解くと, $M=(LT - \alpha)$ であることを使った.  前節の計算から右辺には $L$ をかけておかばければいけないことがわかる. ここで $\op{round}(x)$ は $x$ を四捨五入して整数に変換する函数であるとする.

この事実を使って, 負の二項分布とガンマ分布を比較するグラフを作成してみよう.

```julia
function plot_nbgam(α, θ, L)
    p = 1/(L*θ)
    t = range(max(-1/(2L), α*θ - 4√α*θ), α*θ + 6√α*θ, 1000)
    plot(t, t -> pdf(NegativeBinomial(α, p), round(Int, L*t - α))*L; label="(α+NB(α,p))/L")
    plot!(t, t -> pdf(Gamma(α, θ), t); label="Gamma(α, θ)", ls=:dash)
    title!("α=$α, θ=$θ, L=$L, p=1/(Lθ)")
end
```

```julia
plot(plot_nbgam.(1, 1, (1.2, 3, 10))...; size=(800, 200), layout=(1, 3))
```

```julia
plot(plot_nbgam.(2, 2, (1.2, 3, 10)./2)...; size=(800, 200), layout=(1, 3))
```

```julia
plot(plot_nbgam.(5, 4, (1.2, 3, 10)./4)...; size=(800, 200), layout=(1, 3))
```

### 必ず解いて欲しい問題: χ²分布における確率が95%または99%になる範囲

$0<\alpha<1$, $\nu > 0$ であるとし, $Y \sim \op{Chisq}(\nu)$ と仮定する. このとき, $Y$ が $c$ 以下になる確率

$$
P(Y \le c)
$$

が $1 - \alpha$ になるような $c$ を __正則化された(不完全)ガンマ函数__ (regularized (incomplete) gamma function)

$$
y = P(x|\alpha) = P(\alpha, x) =
\frac{\int_0^x e^{-u} u^{\alpha-1}\,du}{\Gamma(\alpha)}
\quad (x > 0)
$$

の逆函数 $x = P^{-1}(y|\alpha)$ を使って表せ. (注意: $P(\alpha, x)$ は広く使われている標準的な記号法だが, $P(x|\alpha)$ と $P^{-1}(y|\alpha)$ はここだけの記号法である.)

さらに, $\nu = 1$ と $\nu = 2$ と $\nu = 3$ の場合に $P(Y \le c)$ が $95\%$ になる $c$ と $99\%$ になる $c$ を小数点以下第2桁目まで求めよ. 

__お願い:__ 後半の「さらに」以降の具体的な数値を求める部分は必ず解けるようになっておいて欲しい. コンピュータを使ってよい. (より正確に言えばコンピュータを使った計算の仕方を1つ以上マスターしておくこと!)

__注意:__ 正規分布モデルの統計学でχ²分布に関する計算が不完全ガンマ函数に帰着できるという事実から, 正規分布モデルの統計学においてガンマ分布が必須であることがわかる.


__解答例:__ $F(y) = P(Y\le y)$ とおく. $p = F(y)$ の逆函数 $y = Q(p) = F^{-1}(p)$ を正則化された不完全ガンマ函数を使って表そう:

$$
\begin{aligned}
F(y) = P(Y\le y) &=
\frac{1}{2^{\nu/2}\Gamma(\nu/2)}\int_0^y e^{-x/2} x^{\nu/2-1}\,dx
\\ &=
\frac{1}{\Gamma(\nu/2)}\int_0^{y/2} e^{-u} u^{\nu/2-1}\,du =
P(y/2|\nu/2).
\end{aligned}
$$

2つめの等号で $x = 2u$ とおいた.  これより, $p = F(y)$ の逆函数(分位点函数) $y = Q(p) = F^{-1}(p)$ が次のように表されることがわかる:

$$
y = Q(p) = 2P^{-1}(p|\nu/2).
$$

したがって, $P(Y\le c) = 1 - \alpha$ となる $c$ は

$$
c = 2P^{-1}(1-\alpha|\nu/2)
$$

と表される.

$\nu = 1$ のとき,

* $P(Y\le c) = 95\%$ となる $c$ は $c \approx 3.84$
* $P(Y\le c) = 99\%$ となる $c$ は $c \approx 6.63$

$\nu = 3$ のとき,

* $P(Y\le c) = 95\%$ となる $c$ は $c \approx 5.99$
* $P(Y\le c) = 99\%$ となる $c$ は $c \approx 9.21$

$\nu = 3$ のとき,

* $P(Y\le c) = 95\%$ となる $c$ は $c \approx 7.81$
* $P(Y\le c) = 99\%$ となる $c$ は $c \approx 11.34$

__解答終__

```julia
quantile_chisq(ν, p) = 2gamma_inc_inv(ν/2, p, 1-p)

for ν in (1, 2, 3)
    @show ν
    @show quantile_chisq(ν, 0.95)
    @show quantile_chisq(ν, 0.99)
    println()
end
```

```julia
for ν in (1, 2, 3)
    @show ν
    @show quantile(Chisq(ν), 0.95)
    @show quantile(Chisq(ν), 0.99)
    println()
end
```

例えば $\nu = 2$ の場合について, WolframAlphaでは以下のように計算できる:

* [2 InverseGammaRegularized(n/2, 1 - 0.95) where n = 2](https://www.wolframalpha.com/input?i=2+InverseGammaRegularized%28n%2F2%2C+1+-+0.95%29+where+n+%3D+2)
* [2 InverseGammaRegularized(n/2, 1 - 0.99) where n = 2](https://www.wolframalpha.com/input?i=2+InverseGammaRegularized%28n%2F2%2C+1+-+0.99%29+where+n+%3D+2)

* [quantile(ChisqDistribution(2), 0.95)](https://www.wolframalpha.com/input?i=quantile%28ChisqDistribution%282%29%2C+0.95%29)
* [quantile(ChisqDistribution(2), 0.99)](https://www.wolframalpha.com/input?i=quantile%28ChisqDistribution%282%29%2C+0.99%29)

__注意:__ このノートでは分位点函数を $Q(p)$ と書いていて紛らわしいのだが, 不完全ガンマ函数として

$$
Q(x|\alpha) = Q(\alpha, x) = 1 - P(\alpha, x) =
\frac{\int_x^\infty e^{-u} u^{\alpha-1}}{\Gamma(\alpha)}
$$

の側が使われることもよくある. $p = Q(x|\alpha)$ の逆函数を $Q^{-1}(p|\alpha)$ と書くとき, $P(Y\le y) = 2Q^{-1}(1-p|\alpha)$ となることに注意せよ.  上のWolframAlphaでは実際にそうなっている.


### 問題: 自由度1のχ²分布と標準正規分布の関係の数値例

$Z \sim \op{Normal}(0,1)$, $Y \sim \op{Chisq}(1)$ のとき,

$$
P(-c \le Z \le c) = 0.95, \quad
P(Y \le d) = 0.95
$$

を満たす $c$, $d$ の値はそれぞれ

$$
c \approx 1.96, \quad d \approx 3.84
$$

であった.  このとき

$$
c^2 \approx 1.96^2 = 3.8416 \approx 3.84 \approx d
$$

となる. これが必然である理由を説明せよ.

```julia
(196//100)^2 |> float
```

__解答例1:__ 実際には正確に $c^2 = d$ となっている. なぜならば, $z>0$ を $z = \sqrt{y}$ とおくと, 

$$
\begin{aligned}
P(-c \le Z \le c) &=
\int_{-c}^c \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz =
2\int_0^c \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz
\\ &=
2\int_0^{c^2} \frac{e^{-y/2}}{\sqrt{2\pi}}\frac{1}{2}y^{-1/2}\,dy =
\int_0^{c^2} \frac{e^{-y/2}y^{1/2-1}}{2^{1/2}\Gamma(1/2)}\,dy =
\\ &=
P(Y \le c^2).
\end{aligned}
$$

つまり $P(-c \le Z \le c) = P(y \le c^2)$ なので, $P(-c \le Z \le c) = 1 - \alpha$ となる $c$ の二乗と $P(Y \le d) = 1 - \alpha$ となる $d$ は一致する.

__解答終__

__解答例2:__ $Z^2 \sim \op{Chisq}(1)$ となるのであった. ゆえに

$$
P(-c\le Z\le c) = P(Z^2\le c^2) = P(Y\le c^2).
$$

これより, $P(-c \le Z \le c) = 1 - \alpha$ となる $c$ の二乗と $P(Y \le d) = 1 - \alpha$ となる $d$ は一致することがわかる.

__解答終__


## ベータ分布

$\alpha,\beta>0$ と仮定する. ベータ分布は $0$ から $1$ のあいだに分布する連続確率分布でその確率密度函数は

$$
p(t|\alpha, \beta) = \frac{t^{\alpha-1}(1 - t)^{\beta-1}}{B(\alpha,\beta)}
\quad (0<t<1)
$$

と書けるのであった.  別のノートで我々はこの確率密度函数を天下り的に与えて, この分布のある種の極限でガンマ分布が得られることや, ガンマ分布からベータ分布を作れることなどを示した.  ガンマ分布は正規分布がらみの確率分布なので, この事実は, ベータ分布が正規分布モデルの統計学で大活躍する確率分布であることを示唆し, 実際にそうなっている.

以下ではこれとは別のベータ分布の解釈を紹介する.  それによって, ベータ分布を二項分布や負の二項分布と繋げることに成功する.  ベータ分布は二項分布モデルの統計学や負の二項分布モデルの統計学でも役に立つ.


### 一様分布のサイズ $n$ の標本分布の順序統計量

独立な確率変数達 $T_1,T_2,\ldots,T_n$ のそれぞれは一様分布 $\op{Uniform}(0,1)$ に従っていると仮定する.  $T_1,\ldots,T_n$ の中で下から $k$ 番目に小さなものを $\T{k}$ と書く. 

$\T{k}$ も確率変数になることに注意せよ.  $\T{k}$ に対応する乱数は次の手続きで作れる:

(1) $\op{rand}()$ を $n$ 回実行してその結果を $T_1,\ldots,T_n$ とする.
(2) $T_1,\ldots,T_n$ の中で下から $k$ 番目に小さな値を $\T{k}$ とする.

これによって $0$ から $1$ のあいだの数値 $\T{k}$ で以上の手続きによってランダムに与えられるものが得られる.

$\T{k}$ を __一様分布のサイズ $n$ の標本分布の順序統計量__ と呼ぶ.


### 一様分布のサイズ $n$ の標本分布の順序統計量が従う分布

一様分布のサイズ $n$ の標本分布の順序統計量 $\T{k}$ が従う分布はベータ分布 $\op{Beta}(k, n-k+1)$ になる:

$$
\T{k} \sim \op{Beta}(k-1, n-k).
$$

__証明1:__ $0 < t < t+dt < 1$ と $1,2,\ldots,n$ を並び替えたもの $i_1,i_2,\ldots,i_n$ について,

$$
P(T_{i_1},\ldots,T_{i_{k-1}} < t < T_{i_k} < t+dt < T_{i_{k+1}},\ldots,T_{i_n}) =
t^{k-1}\, dt\, (1 - (t+dt))^{n-k}.
$$

さらに, $1,2,\ldots,n$ を $k-1$ 個の $i_1,\ldots,i_{k-1}$ と1個の $i_k$ と $n-k$ 個の $i_{k+1},\ldots,i_n$ の3グループへの分割の仕方の個数は

$$
\frac{n!}{(k-1)!1!(n-k)!} =
\frac{\Gamma(n+1)}{\Gamma(k)\Gamma(n-k+1)} =
\frac{1}{B(k, n-k+1)}
$$

と書ける.  これと上の確率をかけて, $dt\to 0$ のときの $dt$ より高次の微小量を無視したものが $\T{k}$ が従う分布の密度函数 $\times dt$ になる. (順序統計量 $\T{k}$ は $T_1,\ldots,T_n$ の中で $k$ 番目に小さなものであった.) ゆえに, $\T{k}$ が従う分布の確率密度函数は

$$
p(t|n,k) = \frac{t^{k-1} (1 - t)^{n-k}}{B(k, n-k+1)}
\quad (0<t<1)
$$

になる. これはベータ分布 $\op{Beta}(k, n-k+1)$ の確率密度函数である. これで $\T{k}$ が従う分布はベータ分布 $\op{Beta}(k, n-k+1)$ になることがわかった.

__証明終__


__証明2:__ 一様分布 $\op{Uniform}(0,1)$ の累積分布函数と確率密度函数をそれぞれ $F(t)=t$ ($0<t<1$), $p(t)=F'(t)=1$ ($0<t<1$) と書き, 一様分布のサイズ $n$ の標本分布の順序統計量 $\T{k}$ の累積分布函数を $G(t)$ と書く:

$$
G(t) = P(\T{k}\le t).
$$

$\T{k}\le t$ が成立することは, $T_1,\ldots,T_n$ の中の $k$ 個以上が $t$ 以下になることと同値なので,

$$
G(t) = \sum_{j=k}^n \binom{n}{j} F(t)^j(1 - F(t))^{n-j}.
$$

これの導函数が $\T{k}$ の確率密度函数になる:

$$
\begin{aligned}
G'(t) &=
\sum_{j\ge k} j\binom{n}{j} F(t)^{j-1}F'(t)(1 - F(t))^{n-j}
\\ & -
\sum_{j\ge k} (n-j)\binom{n}{j} F(t)^j F'(t)(1 - F(t))^{n-j-1}
\\ & =
\sum_{j\ge k} n\binom{n-1}{j-1} F(t)^{j-1}F'(t)(1 - F(t))^{n-j}
\\ & -
\sum_{j\ge k} n\binom{n-1}{j} F(t)^j F'(t)(1 - F(t))^{n-j-1}
\\ & =
\sum_{j\ge k} n\binom{n-1}{j-1} F(t)^{j-1}F'(t)(1 - F(t))^{n-j}
\\ & -
\sum_{j\ge k+1} n\binom{n-1}{j-1} F(t)^j F'(t)(1 - F(t))^{n-j}
\\ & =
n\binom{n-1}{j-1} F(t)^{k-1}F'(t)(1 - F(t))^{n-k}
\\ & =
\frac{n!}{(k-1)!(n-k)!} F(t)^{k-1}F'(t)(1 - F(t))^{n-k}
\\ & =
\frac{1}{B(k, n-k+1)} t^{k-1} (1 - t)^{n-k}.
\end{aligned}
$$

これはベータ分布 $\op{Beta}(k, n-k+1)$ の確率密度函数である. これで $\T{k}$ が従う分布はベータ分布 $\op{Beta}(k, n-k+1)$ になることがわかった.

__証明終__


### 二項分布の累積分布函数のベータ分布の累積分布函数表示

前節の証明2の証明中で使った

$$
P(\T{k}\le t) = G(t) =
\sum_{j=k}^n \binom{n}{j} F(t)^j(1 - F(t))^{n-j} =
\sum_{j=k}^n \binom{n}{j} t^j(1 - t)^{n-j}
\quad (0<t<1)
$$

の最右辺は二項分布 $\op{Binomial}(n, t)$ において $k$ 以上になる確率に一致している. 

さらに, $\T{k}$ が従う分布が $\op{Beta}(k, n-k+1)$ だったので, その確率はベータ分布 $\op{Beta}(k, n-k+1)$ において $t$ 以下になる確率に一致することになる.

これで, 二項分布とベータ分布の累積分布函数の関係が得られた:

$$
\begin{aligned}
&
K \sim \op{Binomial}(n, t), \;\;
T \sim \op{Beta}(k, n-k+1)
\\ & \implies
P(K \ge k) = P(T \le t), \;\;
P(K \le k-1) = 1 - P(T \le t).
\end{aligned}
$$

後者は前者の補事象を取ることによって得られる.  $k$ を $k+1$ に置き換えると,

$$
\begin{aligned}
&
K \sim \op{Binomial}(n, t), \;\;
T \sim \op{Beta}(k+1, n-k)
\\ &\implies
P(K \ge k+1) = P(T \le t), \;\;
P(K \le k) = 1 - P(T \le t).
\end{aligned}
$$

これらの公式の利点は右辺のベータ分布側の確率の計算を基本特殊函数ライブラリによって効率よく可能なことである.  左辺の二項分布における確率は $n$ が大きいときには平均して $n/2$ 個の数値を足し上げる計算が必要になってしまう.


前節の証明1の結果($\T{k}$ の確率密度函数の形)を認めれば, 証明2で $G'(t)$ を計算する面倒な省略抜きに,

$$
P(\T{k}\le t) = \int_0^t \frac{u^{k-1} (1 - u)^{n-k}}{B(k, n-k+1)}\,du
$$

が得られるので, 易しく証明できる

$$
P(\T{k}\le t) = \sum_{j=k}^n \binom{n}{j} t^j(1 - t)^{n-j}
$$

と合わせて,

$$
\sum_{j=k}^n \binom{n}{j} t^j(1 - t)^{n-j} =
\int_0^t \frac{u^{k-1} (1 - u)^{n-k}}{B(k, n-k+1)}\,du
$$

が得られる. このことからも上の方で述べた二項分布の累積分布函数がベータ分布の累積分布函数で書けるという結果が得られる.


### 負の二項分布の累積分布函数のベータ分布の累積分布函数表示




### ベータ二項分布の定義

```julia

```
