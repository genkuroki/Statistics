# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:hydrogen
#     text_representation:
#       extension: .jl
#       format_name: hydrogen
#       format_version: '1.3'
#       jupytext_version: 1.10.3
#   kernelspec:
#     display_name: Julia 1.10.0
#     language: julia
#     name: julia-1.10
# ---

# %% [markdown]
# # 記号法に関するメモ
#
# $\mathbb{Z}$ は整数 $0,\pm 1,\pm 2,\ldots$ 全体の集合.
#
# $\mathbb{R}$ は実数全体の集合.
#
# $\mathbb{R}_{>0}$ は正の実数全体の集合.
#
# $[a, b]$ は $a$ 以上 $b$ 以下の実数全体で構成される閉区間.
#
# $(a, b)$ は $a$ より大きく $b$ 未満の実数全体で構成される開区間.
#
# $\Gamma$ はガンマ $\gamma$ の大文字.
#
# $B$ はベータ $\beta$ の大文字になる場合がある.
#
# $\Gamma(\alpha)$ はガンマ函数で $B(\alpha,\beta)$ はベータ函数:
#
# $$
# \Gamma(\alpha) = \int_0^\infty e^{-x} x^{\alpha-1}\,dx, \quad
# B(\alpha, \beta) = \int_0^1 t^{\alpha-1}(1-t)^{\beta-1}\,dt.
# $$
#
# $\le$ と $\leqq$ は同じ意味.
#
# $\approx$ は近似的に等しいを意味する. その正確な意味は文脈に依存する.
#
# $p(x|\theta)$ はパラメータ $\theta$ を持つ $x$ に関する確率密度函数.
#
# $P(x|\theta)$ はパラメータ $\theta$ を持つ $x$ に関する確率質量函数.
#
# $\mathrm{Binomial}(n, p)$ は二項分布を表す.
#
# $\mathrm{Normal}(\mu, \sigma)$ は平均 $\mu$ と標準偏差 $\sigma$ を持つ正規分布を表す.
#
# $\mathrm{Gamma}(\alpha, \theta)$ はガンマ分布を表す.
#
# $\mathrm{Chisq}(\nu)$ は自由度 $\nu$ の $\chi^2$ 分布を表す.
#
# $\mathrm{Beta}(a, b)$ はベータ分布を表す.
#
# $\mathrm{TDist}(\nu)$ は自由度 $\nu$ の $t$ 分布を表す.
#
# $X \sim D$ は確率変数 $X$ が確率分布 $D$ に従うことを意味する.
#
# $X \sim D$, approximately は確率分布 $X$ が確率分布 $D$ に近似的に従うことを意味する.  近似的に従うことの正確な意味は文脈依存.
#
# $(X_1,\ldots,X_n) \sim D^n$ は確率変数達 $X_1,\ldots,X_n$ の組が確率分布 $D$ の標本分布に従うことを意味する. これは, $X_1,\ldots,X_n$ が独立同分布な確率変数達でその各々が確率分布 $D$ に従うことと同値である.
#
# $E[f(X)]$ は確率変数 $X$ の函数 $f(X)$ (これも確率変数)の期待値.
#
# $1_{a<X<b}(X)$ は $a<X<b$ という条件が成立するときに $1$ になり, それ以外のときに $0$ になる函数.
#
# $P(X \le x)$ は確率変数 $X$ の値が $x$ 以下になる確率.
#
# $P(X=x, Y=y)$ は確率変数 $X$ が $x$ に等しくてかつ確率変数 $Y$ が $y$ に等しい確率.
#
# $P(X=x|Y=y)$ は確率変数 $Y$ が $y$ に等しいという条件における確率変数 $X$ が $x$ に等しい条件付き確率. $P(X=y|Y=y)$ はパラメータ $y$ を持つ $x$ の確率質量函数になっている.
#
# $p(x, y)$ に対する $p(x|y)$ は $y$ で条件付けらえた $x$ に関する条件付き確率分布の密度函数.  $p(x|y)$ はパラメータ $y$ を持つ $x$ の確率密度函数になっている.
#
# $E[f(X,Y)|Y=y]$ は $Y=y$ という条件のもとでの確率変数 $f(X,Y)$ の条件付き期待値. これは $y$ の函数とみなされ, 確率変数 $E[f(X,Y)|Y]$ を $y$ を $E[f(X,Y)|Y=y]$ に対応させる函数として定義すると, $E[E[f(X,Y)|Y]] = E[f(X,Y)]$ が成立している.
#
# 確率分布 $D$ の累積分布函数(分布 $D$ に従う確率変数の値が $x$ 以下になる確率)を $\mathrm{cdf}(D, x)$ と表す. $D$ が確率質量函数 $P(k)$ を持つとき, 
#
# $$
# \mathrm{cdf}(D, x) = \sum_{k \le x} P(k)
# $$
#
# であり, $D$ が確率密度函数 $p(x)$ を持つとき,
#
# $$
# \mathrm{cdf}(D, x) = \int_{-\infty}^x p(t) \,dt.
# $$
#
# 確率分布 $D$ の分位点函数(累積分布函数 $p=\mathrm{cdf}(D, x)$ の逆函数または逆函数がない場合には適切に定義された逆函数のような函数)を $x = \mathrm{quantile}(D, p)$ と表す.
#
# パラメータのまたはパラメータで表された数値としてのオッズ比(odds ratio)は $\mathrm{OR}$ のようにハット無しで表す.
#
# 確率変数のまたはデータの数値で表されたオッズ比は $\widehat{\mathrm{OR}}$ のようにハットを付けて表す. 
#
# 基本的にハット付きの記号はハット無しの値の推定量という意味になる.
#
# ハットの有無は標準誤差(standard error)の場合も同様で, モデルのパラメータで表された標準誤差は $\mathrm{SE}$ と書くが, 確率変数またはデータの数値で表された数値としての標準誤差の推定値は $\widehat{\mathrm{SE}}$ と表す.
#