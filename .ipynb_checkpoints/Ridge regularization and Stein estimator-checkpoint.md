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
    display_name: Julia 1.1.1
    language: julia
    name: julia-1.1
---

# Ridge正則化とStein推定量

黒木玄

2019-09-30

$
\newcommand\eps{\varepsilon}
\newcommand\ds{\displaystyle}
\newcommand\Z{{\mathbb Z}}
\newcommand\R{{\mathbb R}}
\newcommand\C{{\mathbb C}}
\newcommand\QED{\text{□}}
\newcommand\root{\sqrt}
\newcommand\bra{\langle}
\newcommand\ket{\rangle}
\newcommand\d{\partial}
\newcommand\sech{\operatorname{sech}}
\newcommand\cosec{\operatorname{cosec}}
\newcommand\sign{\operatorname{sign}}
\newcommand\sinc{\operatorname{sinc}}
\newcommand\real{\operatorname{Re}}
\newcommand\imag{\operatorname{Im}}
\newcommand\Li{\operatorname{Li}}
\newcommand\PROD{\mathop{\coprod\kern-1.35em\prod}}
$

Ridge正則化とはパラメーター $w$ の対数尤度函数の $-1$ 倍 $L(w)$ そのものを最小化する最尤法を実行するのではなく, パラメーターの $L^2$ ノルムの2乗に比例する罰則項 $\lambda\|w\|^2$ を加えた $L(w) + \lambda\|w\|^2$ の最小化によってパラメーターの推定値を決定する方法である.

Ridge正則化を非常にシンプルな場合に適用することによって, 最尤推定量よりも平均二乗誤差が小さいStein推定量が得られることを示す.

<!-- #region {"toc": true} -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#設定" data-toc-modified-id="設定-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>設定</a></span><ul class="toc-item"><li><span><a href="#平均汎化誤差と平均二乗誤差の関係" data-toc-modified-id="平均汎化誤差と平均二乗誤差の関係-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>平均汎化誤差と平均二乗誤差の関係</a></span></li></ul></li><li><span><a href="#最尤推定量" data-toc-modified-id="最尤推定量-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>最尤推定量</a></span></li><li><span><a href="#Ridge正則化とStein推定量" data-toc-modified-id="Ridge正則化とStein推定量-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Ridge正則化とStein推定量</a></span><ul class="toc-item"><li><span><a href="#$n\geqq-3$-という仮定からの帰結" data-toc-modified-id="$n\geqq-3$-という仮定からの帰結-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>$n\geqq 3$ という仮定からの帰結</a></span></li><li><span><a href="#第1項" data-toc-modified-id="第1項-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>第1項</a></span></li><li><span><a href="#第2項" data-toc-modified-id="第2項-3.3"><span class="toc-item-num">3.3&nbsp;&nbsp;</span>第2項</a></span></li><li><span><a href="#第3項" data-toc-modified-id="第3項-3.4"><span class="toc-item-num">3.4&nbsp;&nbsp;</span>第3項</a></span></li><li><span><a href="#Stein推定量" data-toc-modified-id="Stein推定量-3.5"><span class="toc-item-num">3.5&nbsp;&nbsp;</span>Stein推定量</a></span></li><li><span><a href="#$\mu_0-=-(\mu_{10},\ldots,\mu_{n0})=(0,\ldots,0)$-の場合" data-toc-modified-id="$\mu_0-=-(\mu_{10},\ldots,\mu_{n0})=(0,\ldots,0)$-の場合-3.6"><span class="toc-item-num">3.6&nbsp;&nbsp;</span>$\mu_0 = (\mu_{10},\ldots,\mu_{n0})=(0,\ldots,0)$ の場合</a></span></li></ul></li><li><span><a href="#数値的検証" data-toc-modified-id="数値的検証-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>数値的検証</a></span><ul class="toc-item"><li><span><a href="#すべての-$\mu_{i0}$-が0の場合" data-toc-modified-id="すべての-$\mu_{i0}$-が0の場合-4.1"><span class="toc-item-num">4.1&nbsp;&nbsp;</span>すべての $\mu_{i0}$ が0の場合</a></span></li><li><span><a href="#雑多な場合" data-toc-modified-id="雑多な場合-4.2"><span class="toc-item-num">4.2&nbsp;&nbsp;</span>雑多な場合</a></span></li></ul></li></ul></div>
<!-- #endregion -->

## 設定

以下では, 平均 $\mu$, 分散 $1$ の正規分布の確率密度函数を

$$
N(x|\mu) = \frac{1}{\mu}e^{-(x-\mu)^2/2}
$$

と書くことにし, $\mu_{i0}\in\R$, $i1,\ldots,n$ を任意に取って固定する. $X=(X_1,\ldots,X_n)$ は確率密度函数

$$
q(x) = \prod_{i=1}^n N(x|\mu_{i0})
$$

で定義される確率分布に従う確率変数であるとする. 以下 $X$ をサンプルと呼ぶ.

サンプル $X=(X_1,\ldots,X_n)$ からサンプルが従う分布をパラメーター $\mu=(\mu_1,\ldots,\mu_n)$ を持つ $x=(x_1,\ldots,x_n)$ に関する確率モデル

$$
p(x|\mu) = \prod_{i=1}^n N(x_i|\mu_i)
$$

を用いて推定しよう.  以上が基本的な設定である.


### 平均汎化誤差と平均二乗誤差の関係

このとき $p(x|\mu)$ による $q(x)$ の予測の汎化誤差の2倍は

$$
\begin{aligned}
&
\int_{\R^n} q(x)(-2\log p(x|\mu))\,dx = 
\int_{\R^2}q(x)\left(n\log(2\pi)+\sum_{i=1}^n(x_i-\mu_i)^2\right)\,dx
\\ & =
\int_{\R^2}q(x)\left(n\log(2\pi)+\sum_{i=1}^n((x_i-\mu_{i0})-(\mu_i-\mu_{i0}))^2\right)\,dx
\\ & =
\int_{\R^2}q(x)\left(n\log(2\pi)+
\sum_{i=1}^n((x_i-\mu_{i0})^2-2(\mu_i-\mu_{i0})(x_i-\mu_{i0})+(\mu_i-\mu_{i0})^2)\right)\,dx
\\ & =
n\log(2\pi) + n + \sum_{i=1}^n (\mu_i - \mu_{i0})^2.
\end{aligned}
$$

ゆえに, もしも $\mu_i$ が $X=(X_1,\ldots,X_n)$ の函数 $\mu_i(X)$ ならば, サンプル $X$ を動かす汎化誤差の平均の2倍は $\mu(X)=(\mu_1(X),\ldots,\mu_n(X))$ の二乗誤差の平均と定数の和

$$
n\log(2\pi) + n + E\left[\sum_{i=1}^n(\mu_i(X)-\mu_{i0})^2\right]
$$

になる. ゆえに, 平均汎化誤差を小さくすること(平均予測誤差を小さくすること)と,  平均二乗誤差を小さくすることは同じことになる.

平均二乗誤差の小さな推定量の方が平均予測誤差も小さくなり, より優れた推定量だということになる.


## 最尤推定量

まず, 最尤法の場合を調べてみよう. 尤度函数の対数の $-2$ 倍は

$$
-2\log p(X|\mu) = -2\sum_{i=1}^n \log N(X_i|\mu_i) = 
n\log(2\pi) + \sum_{i=1}^n (X_i - \mu_i)^2
$$

となるので, これの最小化は損失函数

$$
L(\mu) = \sum_{i=1}^n (X_i - \mu_i)^2
$$

の最小化と同じになる. これを最小化する $\mu_i$ 達は $\hat\mu_i = X_i$ となる.  これが最尤法の解である. 最尤法の解の平均二乗誤差は

$$
E\left[\sum_{i=1}^n(\hat\mu_i - \mu_{i0})^2\right] = 
\sum_{i=1}^nE\left[(X_i - \mu_{i0})^2\right] = n
$$

となる. 


## Ridge正則化とStein推定量

以下では $n\geqq 3$ であると仮定する.

Ridge正則化された損失函数 $R(\mu|\lambda)$ を

$$
R(\mu|\lambda) = L(\mu) + \lambda\|\mu\|^2 =
\sum_{i=1}^n (X_i - \mu_i)^2 + \lambda\sum_{i=1}^n \mu_i^2
$$

と定める. $\lambda > 0$ には後でサンプル $X_i$ から決まるある正の実数を代入することになる.

$R(\mu|\lambda)$ を最小化する $\mu_i=\tilde\mu_i$ は, 簡単な計算で

$$
\tilde\mu_i = \frac{1}{1+\lambda} X_i = (1 - \alpha)X_i, \quad
0\leqq \alpha = \frac{\lambda}{1+\lambda} < 1
$$

と書けることがわかる. 

$\alpha$ をある定数 $c$ を用いて, 

$$
\alpha = \alpha(X) = \frac{c}{X^2}, \quad X^2 = \sum_{i=1}^n X_i^2
$$

とおいて, 

$$
\tilde\mu_i = 
\left(1 - \alpha(X)\right)X_i =
\left(1 - \frac{c}{X^2}\right)X_i
$$
    
の平均二乗誤差

$$
E\left[\sum_{i=1}^n(\tilde\mu_i - \mu_{i0})^2\right] = 
\sum_{i=1}^n E[(X_i-\mu_{i0})^2] - 
2\sum_{i=1}^n E[\alpha(X)X_i(X_i-\mu_{i0})] + 
\sum_{i=1}^n E[\alpha(X)^2 X_i^2]
$$

を最小化する $c$ を求めよう.


### $n\geqq 3$ という仮定からの帰結

$n\geqq 3$ と仮定したことより, $E[1/X^2]$ が有限の値になることを示そう.

$$
E\left[\frac{1}{X^2}\right] = 
\frac{1}{(2\pi)^{n/2}}\int_{\R^n} e^{-(x-\mu_0)^2/2} \frac{1}{x^2}\,dx.
$$

ここで $(x-\mu_0)^2 = \sum_{i=1}^n (x_i-\mu_{i0})^2$, $x^2=\sum_{i=1}^n x_i^2$ である. 

原点を中心とする $n-1$ 次元単位球面を $S^{n-1}$ と書き, その面積を $A_n = 2\pi^{n/2}/\Gamma(n/2)$ と書き, $S^{n-1}$ 上の一様分布を $d\omega$ と書くことにする.  このとき, 極座標変換

$$
x = r\omega, \quad (r > 0,\ \omega\in S^{n-1})
$$

によって,

$$
E\left[\frac{1}{X^2}\right] = 
\frac{1}{(2\pi)^{n/2}}\iint_{\R^n} e^{-(r\omega-\mu_0)^2/2} \frac{1}{r^2}A_n r^{n-1}\,dr\,d\omega =
\frac{A_n}{(2\pi)^{n/2}}\iint_{\R^n} e^{-(r\omega-\mu_0)^2/2} r^{n-3}\,dr\,d\omega
$$

これは $n-3>-1$ すなわち $n>2$ ならば絶対収束している.


### 第1項

$X_i$ は平均 $\mu_{i0}$, 分散 $1$ の正規分布に従うので

$$
\sum_{i=1}^n E[(X_i-\mu_{i0})^2] = n.
$$


### 第2項

正規分布に関する部分積分の公式

$$
E[\alpha(X)X_i(X_i-\mu_{i0})] = E\left[\frac{\d}{\d X_i}(\alpha(X)X_i)\right]
$$

を使う. 

$$
\frac{\d}{\d X_i}(\alpha(X)X_i) = 
c\frac{\d}{\d X_i}\frac{X_i}{X^2} =
c\left(\frac{1}{X^2}-\frac{2X_i^2}{X^4}\right)
$$

より,

$$
\sum_{i=1}^n E[\alpha(X)X_i(X_i-\mu_{i0})] =
c\left(\sum_{i=1}^nE\left[\frac{1}{X^2}\right] - E\left[\frac{2X^2}{X^4}\right]\right) =
c(n-2)E\left[\frac{1}{X^2}\right].
$$


### 第3項

$\alpha(X)^2 = c^2/X^4$, $\sum_{i=1}^n X_i^2 = X^2$ なので

$$
\sum_{i=1}^n E[\alpha(X)^2 X_i^2] = 
E[\alpha(X)^2 X^2] =
E\left[\frac{c^2}{X^2}\right] = 
c^2 E\left[\frac{1}{X^2}\right].
$$


### Stein推定量

ゆえに, $\tilde\mu_i$ の平均二乗誤差は

$$
\begin{aligned}
E\left[\sum_{i=1}^n(\tilde\mu_i - \mu_{i0})^2\right] &=
n - 2c(n-2)E\left[\frac{1}{X^2}\right] + c^2 E\left[\frac{1}{X^2}\right] 
\\ &=
n + (c^2 -2(n-2)c)E\left[\frac{1}{X^2}\right].
\end{aligned}
$$

これを最小にする $c$ は

$$
c = n-2
$$

になる.  このときの, 推定値

$$
\tilde\mu_i = 
(1 - \alpha(X))X_i =
\left(1 - \frac{n-2}{X^2}\right)X_i
$$

を[**Stein推定量**](https://www.google.com/search?q=Stein%E6%8E%A8%E5%AE%9A%E9%87%8F)と呼ぶことにする.

そのとき得られる $\tilde\mu_i$ の平均二乗誤差の最小値は

$$
E\left[\sum_{i=1}^n(\tilde\mu_i - \mu_{i0})^2\right] =
n - (n-2)^2 E\left[\frac{1}{X^2}\right] < 
n = 
E\left[\sum_{i=1}^n(\hat\mu_i - \mu_{i0})^2\right]
$$

となる. 

このようにRidge正則化によって得られたStein推定量 $\tilde\mu_i$ の平均二乗誤差は最尤推定量 $\hat\mu_i=X_i$ の平均二乗誤差より小さい.


### $\mu_0 = (\mu_{10},\ldots,\mu_{n0})=(0,\ldots,0)$ の場合

$\mu_0 = (\mu_{10},\ldots,\mu_{n0})=(0,\ldots,0)$ のとき, 

$$
E\left[\frac{1}{X^2}\right] = 
\frac{1}{(2\pi)^{n/2}}\int_{\R^n} e^{-x^2/2} \frac{1}{x^2}\,dx.
$$

これは, $x_i$ の分散を $1/t>0$ にした場合より,

$$
\frac{1}{(2\pi)^{n/2}} \int_{\R^n} e^{-t x^2/2}\,dx = t^{-n/2}.
$$

両辺を $t$ について $1$ から $\infty$ まで積分すると, 

$$
\frac{1}{(2\pi)^{n/2}} \int_{\R^n} e^{-x^2/2}\frac{2}{x^2}\,dx = \frac{1}{n/2-1}.
$$

ゆえに

$$
E\left[\frac{1}{X^2}\right] = \frac{1}{n-2}.
$$

したがって, この場合には, Stein推定量の平均二乗誤差は

$$
E\left[\sum_{i=1}^n(\tilde\mu_i - \mu_{i0})^2\right] =
n - (n-2)^2 E\left[\frac{1}{X^2}\right] = 2
$$

となる.  これは $n\geqq 3$ が大きいとき, 最尤推定量の平均二乗誤差の $n$ より相当に小さくなる.


## 数値的検証

```julia
using Distributions
using LinearAlgebra

mu_hat(X) = X
alpha(X) = (length(X)-2)/dot(X,X)
mu_tilde(X) = (1 - alpha(X))*X
square_error(mu, mu0) = sum((mu[i] - mu0[i])^2 for i in 1:length(mu))

function sim_stein(;
        mu0 = rand(Normal(), 10),
        niters = 10^5,
    )
    n = length(mu0)
    square_error_mu_hat   = Array{Float64, 1}(undef, niters)
    square_error_mu_tilde = Array{Float64, 1}(undef, niters)
    for l in 1:niters
        X = rand(MvNormal(mu0, I))
        square_error_mu_hat[l]   = square_error(mu_hat(X),   mu0)
        square_error_mu_tilde[l] = square_error(mu_tilde(X), mu0)
    end
    @show mean(square_error_mu_hat)
    @show mean(square_error_mu_tilde)
    mean(square_error_mu_hat), mean(square_error_mu_tilde)
end
```

### すべての $\mu_{i0}$ が0の場合

この場合には, 最尤推定量 $\hat\mu_i = X_i$ の平均二乗誤差は $n$ になり, Stein推定量 $\tilde\mu_i = (1-(n-2)/X^2)X_i$ の平均二乗誤差は $2$ になる.  以下の計算でも実際にそうなっていることを確認できる.

```julia
n = 2
sim_stein(mu0 = zeros(n))
```

```julia
n = 3
sim_stein(mu0 = zeros(n))
```

```julia
n = 4
sim_stein(mu0 = zeros(n))
```

```julia
n = 10
sim_stein(mu0 = zeros(n))
```

```julia
n = 100
sim_stein(mu0 = zeros(n))
```

### 雑多な場合

```julia
mu0 = rand(10)
sim_stein(mu0 = mu0)
```

```julia
mu0 = collect(range(-1, 1, length=10))
sim_stein(mu0 = mu0)
```

```julia
mu0 = randn(10)
sim_stein(mu0 = mu0)
```

```julia

```
