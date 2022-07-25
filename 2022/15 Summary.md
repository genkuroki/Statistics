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

# まとめ

* 黒木玄
* 2022-07-20～2022-07-23
$
\newcommand\ds{\displaystyle}
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
\newcommand\Sterne{{\mathrm{Sterne}}}
\newcommand\Wilson{{\mathrm{Wilson}}}
\newcommand\Wald{{\mathrm{Wald}}}
\newcommand\LLR{{\mathrm{LLR}}}
\newcommand\pdf{\op{pdf}}
\newcommand\pmf{\op{pmf}}
\newcommand\cdf{\op{cdf}}
\newcommand\ecdf{\op{ecdf}}
\newcommand\quantile{\op{quantile}}
\newcommand\Bernoulli{\op{Bernoulli}}
\newcommand\Binomial{\op{Binomial}}
\newcommand\Beta{\op{Beta}}
\newcommand\Normal{\op{Normal}}
\newcommand\MvNormal{\op{MvNormal}}
\newcommand\Chisq{\op{Chisq}}
\newcommand\Chi{\op{Chi}}
\newcommand\TDist{\op{TDist}}
\newcommand\Chisq{\op{Chisq}}
\newcommand\LogisticModel{\op{LogisticModel}}
\newcommand\pvalue{\op{pvalue}}
\newcommand\confint{\op{confint}}
\newcommand\predint{\op{predint}}
\newcommand\credint{\op{credint}}
\newcommand\phat{\hat{p}}
\newcommand\SE{\op{SE}}
\newcommand\SEhat{\widehat{\SE}}
\newcommand\se{\op{se}}
\newcommand\sehat{\widehat{\se}}
\newcommand\logistic{\op{logistic}}
\newcommand\logit{\op{logit}}
\newcommand\OR{\op{OR}}
\newcommand\ORhat{\widehat{\OR}}
\newcommand\RR{\op{RR}}
\newcommand\RRhat{\widehat{\RR}}
\newcommand\RD{\op{RD}}
\newcommand\RDhat{\widehat{\RD}}
\newcommand\hA{\hat{A}}
\newcommand\hB{\hat{B}}
\newcommand\ha{\hat{a}}
\newcommand\hb{\hat{b}}
\newcommand\hc{\hat{c}}
\newcommand\hd{\hat{d}}
\newcommand\hp{\hat{p}}
\newcommand\hq{\hat{q}}
\newcommand\hz{\hat{z}}
\newcommand\ta{\tilde{a}}
\newcommand\tb{\tilde{b}}
\newcommand\tc{\tilde{c}}
\newcommand\td{\tilde{d}}
\newcommand\tp{\tilde{p}}
\newcommand\tq{\tilde{q}}
\newcommand\deltatilde{\tilde{\delta}}
\newcommand\tx{\tilde{x}}
\newcommand\phat{\hat{p}}
\newcommand\qhat{\hat{q}}
\newcommand\ptilde{\tilde{p}}
\newcommand\qtilde{\tilde{q}}
\newcommand\Wald{\op{Wald}}
\newcommand\Pearson{\op{Pearson}}
\newcommand\Fisher{\op{Fisher}}
\newcommand\Bayes{\op{Bayes}}
\newcommand\Welch{\op{Welch}}
\newcommand\Student{\op{Student}}
\newcommand\FisherNoncentralHypergeometric{\op{FisherNoncentralHypergeometric}}
\newcommand\xbar{\bar{x}}
\newcommand\ybar{\bar{y}}
\newcommand\Xbar{\bar{X}}
\newcommand\Ybar{\bar{Y}}
\newcommand\dmu{{\varDelta\mu}}
\newcommand\nuhat{\hat\nu}
\newcommand\yhat{\hat{y}}
\newcommand\alphahat{\hat{\alpha}}
\newcommand\betahat{\hat{\beta}}
\newcommand\betatilde{\tilde{\beta}}
\newcommand\muhat{\hat{\mu}}
\newcommand\sigmahat{\hat{\sigma}}
\newcommand\shat{\hat{s}}
\newcommand\tr{\op{tr}}
\newcommand\diag{\op{diag}}
\newcommand\pred{\op{pred}}
$

このノートでは[Julia言語](https://julialang.org/)を使用している: 

* [Julia言語のインストールの仕方の一例](https://nbviewer.org/github/genkuroki/msfd28/blob/master/install.ipynb)

自明な誤りを見つけたら, 自分で訂正して読んで欲しい.  大文字と小文字の混同や書き直しが不完全な場合や符号のミスは非常によくある.

このノートに書いてある式を文字通りにそのまま読んで正しいと思ってしまうとひどい目に会う可能性が高い. しかし, 数が使われている文献には大抵の場合に文字通りに読むと間違っている式や主張が書いてあるので, 内容を理解した上で訂正しながら読んで利用しなければいけない. 実践的に数学を使う状況では他人が書いた式をそのまま信じていけない.

このノートの内容よりもさらに詳しいノートを自分で作ると勉強になるだろう.  膨大な時間を取られることになるが, このノートの内容に関係することで飯を食っていく可能性がある人にはそのためにかけた時間は無駄にならないと思われる.

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#二項分布モデルでのClopper-Pearsonの信頼区間" data-toc-modified-id="二項分布モデルでのClopper-Pearsonの信頼区間-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>二項分布モデルでのClopper-Pearsonの信頼区間</a></span><ul class="toc-item"><li><span><a href="#Clopper-Pearsonの信頼区間を例に信頼区間の解釈の仕方について説明" data-toc-modified-id="Clopper-Pearsonの信頼区間を例に信頼区間の解釈の仕方について説明-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>Clopper-Pearsonの信頼区間を例に信頼区間の解釈の仕方について説明</a></span></li><li><span><a href="#二項分布モデルのClopper-Pearsonの信頼区間の効率的な計算の仕方" data-toc-modified-id="二項分布モデルのClopper-Pearsonの信頼区間の効率的な計算の仕方-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>二項分布モデルのClopper-Pearsonの信頼区間の効率的な計算の仕方</a></span></li><li><span><a href="#二項分布モデルのBayes統計" data-toc-modified-id="二項分布モデルのBayes統計-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>二項分布モデルのBayes統計</a></span></li><li><span><a href="#P値とBayes統計の関係" data-toc-modified-id="P値とBayes統計の関係-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>P値とBayes統計の関係</a></span></li><li><span><a href="#復習:-二項分布とベータ分布の関係の証明" data-toc-modified-id="復習:-二項分布とベータ分布の関係の証明-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span>復習: 二項分布とベータ分布の関係の証明</a></span><ul class="toc-item"><li><span><a href="#両辺を-p--で微分して確認する方法" data-toc-modified-id="両辺を-p--で微分して確認する方法-1.5.1"><span class="toc-item-num">1.5.1&nbsp;&nbsp;</span>両辺を p  で微分して確認する方法</a></span></li><li><span><a href="#ベータ分布の一様分布の順序統計量の分布として解釈を使う方法" data-toc-modified-id="ベータ分布の一様分布の順序統計量の分布として解釈を使う方法-1.5.2"><span class="toc-item-num">1.5.2&nbsp;&nbsp;</span>ベータ分布の一様分布の順序統計量の分布として解釈を使う方法</a></span></li></ul></li></ul></li><li><span><a href="#P値函数について" data-toc-modified-id="P値函数について-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>P値函数について</a></span><ul class="toc-item"><li><span><a href="#P値はモデルのパラメータ値とデータの数値の整合性の指標の1つ" data-toc-modified-id="P値はモデルのパラメータ値とデータの数値の整合性の指標の1つ-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>P値はモデルのパラメータ値とデータの数値の整合性の指標の1つ</a></span></li><li><span><a href="#P値は信頼区間を考えたいすべてのパラメータ値について定義されている" data-toc-modified-id="P値は信頼区間を考えたいすべてのパラメータ値について定義されている-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>P値は信頼区間を考えたいすべてのパラメータ値について定義されている</a></span></li><li><span><a href="#分割表の場合のP値函数" data-toc-modified-id="分割表の場合のP値函数-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>分割表の場合のP値函数</a></span></li><li><span><a href="#P値函数から信頼区間が定義される" data-toc-modified-id="P値函数から信頼区間が定義される-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>P値函数から信頼区間が定義される</a></span></li><li><span><a href="#2×2の分割表のP値と信頼区間とP値函数の例" data-toc-modified-id="2×2の分割表のP値と信頼区間とP値函数の例-2.5"><span class="toc-item-num">2.5&nbsp;&nbsp;</span>2×2の分割表のP値と信頼区間とP値函数の例</a></span></li><li><span><a href="#2×2の分割表での検定ではどれを使うべきか" data-toc-modified-id="2×2の分割表での検定ではどれを使うべきか-2.6"><span class="toc-item-num">2.6&nbsp;&nbsp;</span>2×2の分割表での検定ではどれを使うべきか</a></span></li><li><span><a href="#P値函数と最尤法の関係" data-toc-modified-id="P値函数と最尤法の関係-2.7"><span class="toc-item-num">2.7&nbsp;&nbsp;</span>P値函数と最尤法の関係</a></span></li><li><span><a href="#以上のまとめの図" data-toc-modified-id="以上のまとめの図-2.8"><span class="toc-item-num">2.8&nbsp;&nbsp;</span>以上のまとめの図</a></span></li><li><span><a href="#おまけ:-Bayes統計の方法を使った場合" data-toc-modified-id="おまけ:-Bayes統計の方法を使った場合-2.9"><span class="toc-item-num">2.9&nbsp;&nbsp;</span>おまけ: Bayes統計の方法を使った場合</a></span></li></ul></li><li><span><a href="#Welchの-t-検定について" data-toc-modified-id="Welchの-t-検定について-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Welchの t 検定について</a></span><ul class="toc-item"><li><span><a href="#Welchの-t-検定のP値と信頼区間の定義" data-toc-modified-id="Welchの-t-検定のP値と信頼区間の定義-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>Welchの t 検定のP値と信頼区間の定義</a></span></li><li><span><a href="#Welchの-t-検定のP値や信頼区間の計算例" data-toc-modified-id="Welchの-t-検定のP値や信頼区間の計算例-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>Welchの t 検定のP値や信頼区間の計算例</a></span><ul class="toc-item"><li><span><a href="#WolframAlphaによるWelchの-t-検定のP値と信頼区間の計算の必修問題の解答例" data-toc-modified-id="WolframAlphaによるWelchの-t-検定のP値と信頼区間の計算の必修問題の解答例-3.2.1"><span class="toc-item-num">3.2.1&nbsp;&nbsp;</span>WolframAlphaによるWelchの t 検定のP値と信頼区間の計算の必修問題の解答例</a></span></li><li><span><a href="#Julia言語によるWelchの-t-検定のP値と信頼区間の計算の必修問題の解答例" data-toc-modified-id="Julia言語によるWelchの-t-検定のP値と信頼区間の計算の必修問題の解答例-3.2.2"><span class="toc-item-num">3.2.2&nbsp;&nbsp;</span>Julia言語によるWelchの t 検定のP値と信頼区間の計算の必修問題の解答例</a></span></li></ul></li></ul></li><li><span><a href="#数学的な補足:-大数の法則と中心極限定理について" data-toc-modified-id="数学的な補足:-大数の法則と中心極限定理について-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>数学的な補足: 大数の法則と中心極限定理について</a></span><ul class="toc-item"><li><span><a href="#二項分布の大数の法則" data-toc-modified-id="二項分布の大数の法則-4.1"><span class="toc-item-num">4.1&nbsp;&nbsp;</span>二項分布の大数の法則</a></span></li><li><span><a href="#二項分布の中心極限定理" data-toc-modified-id="二項分布の中心極限定理-4.2"><span class="toc-item-num">4.2&nbsp;&nbsp;</span>二項分布の中心極限定理</a></span></li><li><span><a href="#他の分布の場合" data-toc-modified-id="他の分布の場合-4.3"><span class="toc-item-num">4.3&nbsp;&nbsp;</span>他の分布の場合</a></span><ul class="toc-item"><li><span><a href="#例:-Poisson分布" data-toc-modified-id="例:-Poisson分布-4.3.1"><span class="toc-item-num">4.3.1&nbsp;&nbsp;</span>例: Poisson分布</a></span></li><li><span><a href="#例:-Gamma分布" data-toc-modified-id="例:-Gamma分布-4.3.2"><span class="toc-item-num">4.3.2&nbsp;&nbsp;</span>例: Gamma分布</a></span></li></ul></li><li><span><a href="#標本分布の場合" data-toc-modified-id="標本分布の場合-4.4"><span class="toc-item-num">4.4&nbsp;&nbsp;</span>標本分布の場合</a></span></li><li><span><a href="#再掲:-大数の法則と中心極限定理のイメージ" data-toc-modified-id="再掲:-大数の法則と中心極限定理のイメージ-4.5"><span class="toc-item-num">4.5&nbsp;&nbsp;</span>再掲: 大数の法則と中心極限定理のイメージ</a></span></li><li><span><a href="#統計学の基礎になる確率論の三種の神器" data-toc-modified-id="統計学の基礎になる確率論の三種の神器-4.6"><span class="toc-item-num">4.6&nbsp;&nbsp;</span>統計学の基礎になる確率論の三種の神器</a></span></li><li><span><a href="#Kullback-Leibler情報量に関するSanovの定理の数値例" data-toc-modified-id="Kullback-Leibler情報量に関するSanovの定理の数値例-4.7"><span class="toc-item-num">4.7&nbsp;&nbsp;</span>Kullback-Leibler情報量に関するSanovの定理の数値例</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using Base.Threads
using BenchmarkTools
using DataFrames
using Distributions
using LinearAlgebra
using Memoization
using Optim
using Printf
using QuadGK
using RCall
@rimport stats as R
using Random
Random.seed!(4649373)
using Roots
using SpecialFunctions
using StaticArrays
using StatsBase
using StatsFuns
using StatsPlots
default(fmt = :png, size = (400, 250),
    titlefontsize = 10, guidefontsize=9, plot_titlefontsize = 12)
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
safemul(x, y) = x == 0 ? x : isinf(x) ? typeof(x)(Inf) : x*y
safediv(x, y) = x == 0 ? x : isinf(y) ? zero(y) : x/y

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
function logtick(; xlim=(0.03, 30))
    xmin, xmax = xlim
    a = floor(Int, log10(xmin))
    b = ceil(Int, log10(xmax))
    nums =     [1, 2, 3, 4, 5, 6, 7, 8, 9]
    mask = Bool[1, 1, 0, 0, 1, 0, 0, 0, 0]
    
    logtick = foldl(vcat, ([10.0^k*x for x in nums if xmin ≤ 10.0^k*x ≤ xmax] for k in a:b))
    logticklabel_a = foldl(vcat,
        ([mask[i] ? string(round(10.0^k*x; digits=-k)) : ""
                for (i, x) in enumerate(nums) if xmin ≤ 10.0^k*x ≤ xmax]
            for k in a:-1))
    logticklabel_b = foldl(vcat,
        ([mask[i] ? string(10^k*x) : ""
                for (i, x) in enumerate(nums) if xmin ≤ 10.0^k*x ≤ xmax]
            for k in 0:b))
    logticklabel = vcat(logticklabel_a, logticklabel_b)
    (logtick, logticklabel)
end

# logtick()
```

## 二項分布モデルでのClopper-Pearsonの信頼区間


### Clopper-Pearsonの信頼区間を例に信頼区間の解釈の仕方について説明

「$n$ 回中 $k$ 回当たりが出た」「$n$ 人中 $k$ 人が重症化」「$n$ 人中 $k$ 人が商品を購入」などの型のデータを扱うための統計モデルとして, 成功確率パラメータ $p$ を持つ二項分布

$$
P(k|n,p) = \binom{n}{k} p^k(1-p)^{n-k} \quad (k=0,1,\ldots,n)
$$

を使う状況を考える.  このとき, 仮説 $p=p_0$ のP値(データの数値とモデル＋パラメータ値の整合性の指標の1つ)を次のように定義できるのであった:

$$
\pvalue_{\CP}(k|n,p=p_0) =
\min\begin{pmatrix}
1 \\
2\cdf(\Binomial(n, p_0), k) \\
2(1 - \cdf(\Binomial(n, p_0), k-1)) \\
\end{pmatrix}
$$

これをClopper-PearsonのP値と呼ぶことにしていた.  このP値は以下の3つのうちの最小値として定義されている:

* $1$
* 仮説 $p=p_0$ の下での二項分布で $n$ 回中の当たりの回数が $k$ 回以下の確率の2倍
* 仮説 $p=p_0$ の下での二項分布で $n$ 回中の当たりの回数が $k$ 回以上の確率の2倍

本当はモデル内で仮想的に生成されたデータの値 $i$ ($n$ 回中の当たりの回数)が期待値 $np_0$ からデータの数値 $k$ 以上離れる確率をP値としたいのだが(P値の定義は仮説下のモデル内でデータの数値以上に極端な値が生成される確率またはその近似値であった), 反対側の確率を自然に決めることができないので, 2倍して反対側の確率も足し上げたことにしている.  (これは1つの処方箋に過ぎず, 別の方法もあるのであった.)

これに対応する信頼度 $1-\alpha$ の信頼区間の定義は次の通り:

$$
\confint_{\CP}(k|n,\alpha) = 
\{\, p_0 \in [0, 1] \mid \pvalue_{\CP}(k|n,p=p_0) \ge \alpha\,\}.
$$

仮説 $p=p_0$ のP値 $\pvalue_{\CP}(k|n,p=p_0)$ はデータの数値「$n$ 回中 $k$ 回」とモデルのパラメータに関する仮説 $p=p_0$ の整合性の指標として使われるのであった. 

信頼区間を定義している条件 $\pvalue_{\CP}(k|n,p=p_0) \ge \alpha$ はその整合性の指標の値がある閾値 $\alpha$ (この閾値は有意水準と呼ばれる)以上になっているという条件になっている.

通常, 有意水準 $\alpha$ は目的に合わせて小さな値を採用し, 検定の手続きではP値が $\alpha$ 未満になるパラメータ値 $p=p_0$ を棄却する.

信頼度 $1-\alpha$ 信頼区間は有意水準 $\alpha$ で棄却されないパラメータ値 $p=p_0$ 全体の集合になっている.

「棄却されないこと」は「判断を保留すること」を意味する.

__信頼区間に含まれるパラメータ値 $p=p_0$ については判断を保留することになるが, もしも信頼区間が十分に狭くなっていれば, その外側にある大部分のパラメータ値は検定の手続きによって棄却されており, 可能性として考慮すればよいのは, 十分に狭くなっている信頼区間に含まれるパラメータ値だけになっているので, 科学的に十分に意味のある結論を出すことができる場合が出て来る.__

ただし, 信頼区間を使って科学的に信頼できる結論を出すためには, データの取得法が信頼できるか, 採用した統計モデルは妥当であるか, その他見落としている重要な問題はないか, などの多くの問題をクリアする必要がある.

機械的に信頼区間を計算して科学的な御墨付きが得られたような態度を取ることは誤りなので注意して欲しい.


### 二項分布モデルのClopper-Pearsonの信頼区間の効率的な計算の仕方

Clopper-Pearsonの信頼区間は定義をうまく変形すると以下のように書き直される:

$$
\confint_{\CP}(k|n,\alpha) = [p_L, p_U].
$$

ここで, $p_L, p_U$ は次の条件で特徴付けられる値である:

$$
\begin{aligned}
&
1 - \cdf(\Binomial(n, p_L), k-1) = \alpha/2,
\\ &
\cdf(\Binomial(n, p_U), k) = \alpha/2.
\end{aligned}
$$

すなわち, 小さい方の $p_L$ は $p=p_L$ の二項分布内で $n$ 回中の当たりの回数が $k$ 以上になる確率が $\alpha/2$ になるという条件で特徴付けられ, 大きい方の $p_U$ は $p=p_U$ の二項分布内で $n$ 回中当たりの回数が $k$ 回以下になる確率が $\alpha/2$ になるという条件で特徴付けられる.

問題はこの $p_L, p_U$ をどのように計算するかである.

これには二項分布とベータ分布の間の関係を使う驚くべき方法がある.

二項分布の累積分布函数(cumulative distribution function, cdf)の定義は

$$
\cdf(\Binomial(n, p), k) =
\sum_{i=0}^k \binom{n}{i} p^i(1-p)^{n-i}
$$

である.  場合によっては万単位の個数の値を足し上げる計算になる. 

しかし, そういう和を取る計算をコンピュータで素朴に行うのはコンピュータ資源の無駄遣いになってしまう.

なぜならば, すでに説明したように非常にうまい方法があるからである.

__二項分布とベータ分布の関係:__

$$
\begin{aligned}
&
1 - \cdf(\Binomial(n, p), k-1) = \cdf(\Beta(k, n-k+1), p),
\\ &
\cdf(\Binomial(n, p), k) = 1 - \cdf(\Beta(k+1, n-k), p).
\end{aligned}
$$

この前者と後者の公式は同値な公式になっており, 片方からもう一方が導かれる.

以下でこれの前者を $n=20$, $k=7$ の場合に数値的に確認してみよう.

```julia
n, k = 20, 7
plot(p -> ccdf(Binomial(n, p), k-1), 0, 1; label="ccdf(Binomial(n, p), k-1)")
plot!(p -> cdf(Beta(k, n-k+1), p); label="cdf(Beta(k, n-k+1), p)", ls=:dash)
title!("n = $n, k = $k", xguide="p", legend=:bottomright)
```

2つのグラフがぴったり重なり合っている. ($\op{ccdf}$ は $1-\cdf$ の意味である.)


ベータ分布の累積分布函数 $\cdf(\Beta(k+1, n-k), p)$ は正則化された不完全ベータ函数という名前がついている基本特殊函数になっており, その $p$ に関する逆函数(分位点函数, quantile function)もコンピュータの基本特殊函数ライブラリの中で効率的に実装されている.  だから, 

$$
1 - \cdf(\Binomial(n, p_L), k-1) = \cdf(\Beta(k, n-k+1), p_L) = \alpha/2
$$

を満たす $p_L$ は, ベータ分布の分位点函数(quantile function)を用いて,

$$
p_L = \quantile(\Beta(k, n-k+1), \alpha/2)
$$

を使えばコンピュータで効率的に計算できる. 同様に

$$
\cdf(\Binomial(n, p_U), k) = 1 - \cdf(\Beta(k+1, n-k), p_U) = \alpha/2
$$

を満たす $p_U$ は

$$
p_U = \quantile(\Beta(k+1, n-k), 1-\alpha/2)
$$

を使えばコンピュータで効率的に計算できる.

__まとめ:__ 二項分布モデルのでClopper-Pearsonの信頼区間 $[p_L, p_U]$ は

$$
p_L = \quantile(\Beta(k, n-k+1), \alpha/2), \quad
p_U = \quantile(\Beta(k+1, n-k), 1-\alpha/2)
$$

と計算できる.

__二項分布とベータ分布の間の関係が, コンピュータ上に実装された基本特殊函数ライブラリを通して, 二項分布モデルの場合の信頼区間の効率的な計算に役に立っている!__

* 異なる確率分布に間の関係に関する数学
* 不完全ベータ函数などの基本特殊函数に関する数学
* それをコンピュータで実装するプログラミングの技術

などの多くの技術を組み合わせることによって, Clopper-Pearsonの信頼区間のシンプルで効率的な計算法が実現されている!

このようなことから, __このClopper-Pearsonの信頼区間についてこのように理解することは, 高等教育を受けた人達にとっての重要な教養になり得る__ と思われる. 




例えば, $n=20$, $k=7$, $\alpha=0.05$ の場合の信頼度 $1-\alpha$ のClopper-Pearsonの信頼区間は次のように計算される.

```julia
n, k, α = 20, 7, 0.05
[quantile(Beta(k, n-k+1), α/2), quantile(Beta(k+1, n-k), 1-α/2)] |> println
```

R言語を使って計算した結果も同じになっている:

```julia
rcopy(R"""binom.test(7, 20, p=0.05)""")[:conf_int] |> println
```

WolframAlphaでも以下のようにすれば容易に計算できる.

$p_L$ → `quantile(BetaDistribution(7, 20-7+1), 0.025)` → \[[実行](https://www.wolframalpha.com/input?i=quantile%28BetaDistribution%287%2C+20-7%2B1%29%2C+0.025%29)\] → 0.153909

$p_U$ → `quantile(BetaDistribution(7+1, 20-7), 0.975)` → \[[実行](https://www.wolframalpha.com/input?i=quantile%28BetaDistribution%287%2B1%2C+20-7%29%2C+0.975%29)\] → 0.592189


### 二項分布モデルのBayes統計

二項分布とベータ分布の関係は通常の検定とBayes統計の関係を理解するためにも役に立つ.

二項分布のベイズ統計では先に用意した二項分布の確率質量函数 $P(k|n,p)$ だけではなく, パラメータ $p$ に関する確率密度函数 $\varphi(p)$ を任意に与え(目的に合わせて適切に事前分布を決めることになるが, 理論的には任意でよい), $(k, p)$ に関する同時分布 (joint distribution)

$$
P(k,p|n) = P(k|n,p)\varphi(p), \quad \sum_{k=0}^n \int_0^1 P(k, p|n)\,dp = 1
$$

を考える.  そして, 「$n$ 回中 $k$ 回」の形のデータの数値が与えられたとき, このモデルの同時確率分布を, データと同じ数値が生成されたという条件で制限して得られるパラメータ $p$ に関する条件付き確率分布 $\varphi(p|n,k)$ を考える:

$$
\varphi(p|n,k) = \frac{P(k|n,p)\varphi(p)}{\int_0^1 P(k|n,p)\varphi(p)\,dp}.
$$

このとき, $\varphi(p)$ を __事前分布__ (prioir)と呼び, $\varphi(p|n,k)$ を __事後分布__ (posterior)と呼ぶ.

条件付き確率分布については

* [「条件付き確率分布, 尤度, 推定, 記述統計」のノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.ipynb)

に解説がある.  数学的には

* 確率＝全体に対する部分の割合
* 条件付き確率＝部分に対する部分の割合

のように考えると直観的に理解し易いと思う.  上の事後分布の公式を __ベイズの定理__ と呼ぶこともあるが, ベイズの定理を知らなくても, 条件付き確率分布について理解していれば困らない.

事後分布 $\varphi(p|n,k)$ の $p=p_0$ での値 $\varphi(p=p_0|n,k)$ はデータの数値 $p=p_0$ とデータの数値 $n,k$ の統計モデル $P(k,p|n) = P(k|n,p)\varphi(p)$ の下での整合性の指標として利用できる. (P値とはまた別のモデルとデータの整合性の指標が得られたことになる.)

さて, 例によって, 問題はどのように事後分布と呼ばれる条件付き確率分布を計算するかである.

事後分布の公式を見れば分母が積分

$$
Z(k|n) := \int_0^1 P(k|n,p)\varphi(p)\,dp
$$

になっていて, その積分の部分の計算が大変そうなことがわかる.  (事後分布の分母を __周辺尤度__ (marginal likelihood)と呼ぶことがある.  他にも様々な呼び方があるが, 呼び方自体は重要ではない.)

二項分布の場合には, 事前分布としてベータ分布を採用すると, 事後分布もベータ分布になり, 事後分布の計算が著しく単純化される.  この事実をベータ分布は二項分布の __共役事前分布__ (conjugate prior)であるという.

以下では $\varphi(p)$ が $\Beta(a, b)$ ($a,b>0$)の確率密度函数であると仮定する:

$$
\varphi(p) = \frac{p^{a-1}(1-p)^{b-1}}{B(a, b)} \quad (0 < p < 1).
$$

このとき, 事後分布の分母は次のように計算される:

$$
\begin{aligned}
Z(k|n) &=
\int_0^1 \binom{n}{k} p^k(1-p)^{n-k}\frac{p^{a-1}(1-p)^{b-1}}{B(a, b)}\,dp
\\ &=
\binom{n}{k}\frac{1}{B(a,b)}\int_0^1 p^{a+k-1}(1-p)^{b+n-k}\,dp
\\ &=
\binom{n}{k}\frac{B(a+k, b+n-k)}{B(a,b)}.
\end{aligned}
$$

ゆえに, 事後分布は次のようになる:

$$
\begin{aligned}
\varphi(p|n,k) &= \frac{P(k|n,p)\varphi(p)}{Z(k|n)}
\\ &=
\binom{n}{k}\frac{1}{B(a,b)}p^{a+k-1}(1-p)^{b+n-k}
\times \left(\binom{n}{k}\frac{B(a+k, b+n-k)}{B(a,b)}\right)^{-1}
\\ &=
\frac{p^{a+k-1}(1-p)^{b+n-k}}{B(a+k, b+n-k)}.
\end{aligned}
$$

以上によって, 事前分布が共役事前分布 $\Beta(a,b)$ のとき, データ「$n$ 回中 $k$ 回」から得られる事後分布は $\Beta(a+k,b+n-k)$ になることがわかった.

$a,b>0$ と仮定していたが, $a=0$ または $b=0$ の場合にも, $a+k$ と $b+n-k$ が共に正になるならば, 事後分布は $\Beta(a+k, b+n-k)$ はうまく定義されている.  このような場合のうまく定義されていない事前分布は __improper事前分布__ (improper prior)と呼ばれている.

この節の事柄については

* [「例：ベータ函数と二項分布の関係とその応用」のノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/07-1%20Relationship%20between%20beta%20and%20binomial%20distributions.ipynb)

の最後の方にも解説がある.


### P値とBayes統計の関係

二項分布とベータ分布の累積分布函数の間には以下の関係があるのであった:

$$
\begin{aligned}
&
1 - \cdf(\Binomial(n, p_0), k-1) = \cdf(\Beta(k, n-k+1), p_0),
\\ &
\cdf(\Binomial(n, p_0), k) = 1 - \cdf(\Beta(k+1, n-k), p_0).
\end{aligned}
$$

一般に分布 $D$ について累積分布函数 $\cdf(D, x)$ は分布 $D$ に従う確率変数 $X$ が $x$ 以下になる確率を意味することに注意せよ.

ゆえに上の公式の前者の両辺は以下のような解釈を持つ:

* $1 - \cdf(\Binomial(n, p_0), k-1)$ (分布 $\Binomial(n, p_0)$ で $k$ 以上になる確率)は仮説 $p\le p_0$ に関する片側検定のP値である.
* $\cdf(\Beta(k, n-k+1), p_0)$ はimproper事前分布 $\Beta(0,1)$ の下での事後分布 $\Beta(k, n-k+1)$ において仮説 $p\le p_0$ が成立する確率である.

このように, 仮説 $p\le p_0$ の片側検定のP値はBayes統計での事後分布において仮説 $p\le p_0$ が成立する確率に一致する. 同様に, 

* $\cdf(\Binomial(n, p_0), k)$ (分布 $\Binomial(n, p_0)$ で $k$ 以下になる確率)は仮説 $p\ge p_0$ に関する片側検定のP値である.
* $1 - \cdf(\Beta(k+1, n-k), p_0)$ はimproper事前分布 $\Beta(1,0)$ の下での事後分布 $\Beta(k+1, n-k+1)$ において仮説 $p\ge p_0$ が成立する確率である.

ゆえに, 仮説 $p\ge p_0$ の片側検定のP値はBayes統計での事後分布において仮説 $p\ge p_0$ が成立する確率に一致する.

このように, 数学的にはP値とBayes統計のあいだにexactな関係が付けられる場合もある.

__P値を使う統計学とBayes統計は決して水と油ではない.__

以上によって, 片側検定のP値については, Bayes統計でのexactな解釈が得られたことになる.

しかし, 通常使われるP値は両側検定のP値(Clopper-Pearson型のP値では片側検定のP値の2倍を両側検定のP値として採用する)とBayes統計の関係はどうなっているのだろうか?

Clopper-Pearson型のP値のBayes統計での類似物を構成するには, 上の片側検定の場合に関する結果を利用すればよい.

そのときに問題になることは, 片側検定の向きを変えると, 使用する(improper)事前分布が $\Beta(0,1)$ と $\Beta(1,0)$ のあいだで変化してしまうことである.

そこで, 両側検定のP値のBayes統計によるexactな解釈を作ることはあきらめて, 近似的な関係を得ることを目標にしよう.

そのためには事前分布として $\Beta(0,1)$ と $\Beta(1,0)$ の中間に位置する $\Beta(1/2,1/2)$ を採用すると良さそうであると予想され, 実際にそうであることが計算によって確認可能である.

$\Beta(1/2,1/2)$ は二項分布の __Jeffreys事前分布__ と呼ばれる.

他の選択肢として, 事前分布として平坦事前分布 $\Beta(1,1)$ を採用することも考えられる. ($\Beta(1,1)$ の確率密度函数は $\varphi(p)=1$ ($0<p<1$) となるので, __平坦事前分布__ または __一様事前分布__ と呼んだりする.)

事前分布として平坦事前分布を採用すると, 両側検定のP値との対応において, Jeffreys事前分布を採用した場合よりも誤差が増えるが, $k$ と $n-k$ が大きければ, $\Beta(k+1/2, n-k+1/2)$ と $\Beta(k+1,n-k+1)$ の違いは小さくなるので, 実践的な応用の場面では問題でなくなる.

以下では, 事前分布が $\Beta(a,a)$ である場合を考える.

このとき, 事後分布は $\Beta(k+a, n-k+a)$ になる. 

この事後分布における仮説 $p=p_0$ の両側検定に関するClopper-Pearson型のP値函数の類似物は次のように定義される:

$$
\pvalue_{\Bayes}(k|n,p=p_0) =
\min\begin{pmatrix}
1 \\
2\cdf(\Beta(k+a, n-k+a), p_0) \\
2(1 - \cdf(\Beta(k+a, n-k+a), p_0)) \\
\end{pmatrix}.
$$

これは, 二項分布に関するClopper-Pearson型のP値をそのままベータ分布に一般化しただけの定義になっている.

さらに, 通常のP値として, Clopper-Pearson型のP値だけではなく, 正規分布近似(中心極限定理)を使ったWilson型のP値函数も考えることにしよう:

$$
\pvalue_{\Wilson}(k|n,p=p_0) =
2\left(1 - \cdf\left(\Normal(0,1), \frac{|k - np_0|}{\sqrt{np_0(1-p_0)}}\right)\right).
$$

このとき, 次が成立している.

__結論:__ $k$ と $n-k$ が大きければ, 以上の3つのP値 $\pvalue_{\CP}(k|n,p=p_0)$, $\pvalue_{\Bayes}(k|n,p=p_0)$, $\pvalue_{\Wilson}(k|n,p=p_0)$ は近似的に一致する.

要するに, 両側検定の通常使われるP値についても, Bayes統計での近似的な解釈が存在する.

これを $n=100$, $k=30$ の場合に数値的に確認してみよう.

```julia
# 上に書いてある定義の通りのP値の実装

function pvalue_cp(k, n, p)
    bin = Binomial(n, p)
    min(1, 2cdf(bin, k), 2ccdf(bin, k-1))
end

function pvalue_wilson(k, n, p)
    z = (k - n*p)/√(n*p*(1-p))
    2ccdf(Normal(0, 1), abs(z))
end

function pvalue_bayes(k, n, p; a=1/2)
    beta = Beta(k+a, n-k+a)
    min(1, 2cdf(beta, p), 2ccdf(beta, p))
end

# 後で使うための別のP値の定義

function pvalue_sterne(k, n, p)
    bin = Binomial(n, p)
    # 次はnaiveな定義で計算効率は非常に悪い
    sum(pdf(bin, i) for i in support(bin) if pdf(bin, i) ⪅ pdf(bin, k))
end

function pvalue_wald(k, n, p)
    phat = k/n
    z = (k - n*p)/√(n*phat*(1-phat))
    2ccdf(Normal(0, 1), abs(z))
end
```

```julia
n, k, a = 100, 30, 1/2
xlim = (0.1, 0.5)
P1 = plot(p -> pvalue_cp(k, n, p), xlim...; label="Clopper-Pearson")
P2 = plot(p -> pvalue_wilson(k, n, p), xlim...; label="Wilson", c=2, ls=:dash)
P3 = plot(p -> pvalue_bayes(k, n, p; a), xlim...; label="Bayes(a=$a)", c=3, ls=:dashdot)
P4 = plot(p -> pvalue_cp(k, n, p), xlim...; label="Clopper-Pearson")
plot!(p -> pvalue_wilson(k, n, p), xlim...; label="Wilson", c=2, ls=:dash)
plot!(p -> pvalue_bayes(k, n, p; a), xlim...; label="Bayes(a=$a)", c=3, ls=:dashdot)

plot(P1, P2, P3, P4; size=(800, 500), plot_title="data: n = $n, k = $k")
```

3つのP値函数が近似的に一致しており, 特にJeffreys事前分布でのBayes版のP値函数は正規分布近似を使って定義されたWilson版のP値函数と非常によく一致している.

```julia
n, k, a = 100, 30, 1
xlim = (0.1, 0.5)
P1 = plot(p -> pvalue_cp(k, n, p), xlim...; label="Clopper-Pearson")
P2 = plot(p -> pvalue_wilson(k, n, p), xlim...; label="Wilson", c=2, ls=:dash)
P3 = plot(p -> pvalue_bayes(k, n, p; a), xlim...; label="Bayes(a=$a)", c=3, ls=:dashdot)
P4 = plot(p -> pvalue_cp(k, n, p), xlim...; label="Clopper-Pearson")
plot!(p -> pvalue_wilson(k, n, p), xlim...; label="Wilson", c=2, ls=:dash)
plot!(p -> pvalue_bayes(k, n, p; a), xlim...; label="Bayes(a=$a)", c=3, ls=:dashdot)

plot(P1, P2, P3, P4; size=(800, 500), plot_title="data: n = $n, k = $k")
```

平坦事前分布の場合にも, Bayes版のP値函数はWilson型のP値函数とよく一致している.


以上のグラフを見ても, P値を使う統計学とBayes統計が水と油だと考えることはバカげているように思われる.


### 復習: 二項分布とベータ分布の関係の証明

以上を理解できた人は二項分布とベータ分布の累積分布函数の関係を完璧に理解しておくことの価値は大きいと感じると思われる.

以下では, 再度, 二項分布とベータ分布の累積分布函数の関係を証明しておく.

__大事なことは何度でも証明しておいた方がよい.__


#### 両辺を p  で微分して確認する方法

証明したい公式

$$
1 - \cdf(\Binomial(n, p), k-1) = \cdf(\Beta(k, n-k+1), p)
\quad (k=1,2,\ldots,n)
$$

の両辺を具体的に書き下すと以下のようになる:

$$
\sum_{i=k}^n \binom{n}{i} p^i (1-p)^{n-i} = \frac{\int_0^p t^{k-1}(1-t)^{n-k}\,dt}{B(k, n-k+1)}
\quad (k=1,2,\ldots,n).
\tag{$*$}
$$

$p=0$ のとき, $k\ge 1$ より($*$)の左辺は $0$ になり, ($*$)の右辺も $0$ になる. 

($*$)の左辺を $p$ で微分すると,

$$
\begin{aligned}
\frac{\partial}{\partial p}(\text{($*$)の左辺}) &=
\sum_{i\ge k} \frac{n!}{i!(n-i)!}i p^{i-1}(1-p)^{n-i} -
\sum_{i\ge k} \frac{n!}{i!(n-i)!}(n-i) p^i(1-p)^{n-i-1}
\\ &=
\sum_{i\ge k} \frac{n!}{(i-1)!(n-i)!} p^{i-1}(1-p)^{n-i} -
\sum_{i\ge k} \frac{n!}{i!(n-i-1)!} p^i(1-p)^{n-i-1}
\\ &=
\sum_{i\ge k} \frac{n!}{(i-1)!(n-i)!} p^{i-1}(1-p)^{n-i} -
\sum_{i\ge k+1} \frac{n!}{(i-1)!(n-i)!} p^{i-1}(1-p)^{n-i}
\\ &
\frac{n!}{(k-1)!(n-k)!} p^{k-1}(1-p)^{n-k}.
\end{aligned}
$$

3つめの等号は2つめの和の項のインデックスの $i$ を $i-1$ で置き換えることによって得られる. 

一方, $\Gamma(i+1)=i!$ ($i=0,1,2,\ldots$)より,

$$
\frac{1}{B(k, n-k+1)} = \frac{\Gamma(n+1)}{\Gamma(k)\Gamma(n-k+1)} =
\frac{n!}{(k-1)!(n-k)!}
$$

なので, ($*$)の右辺を $p$ で微分すると,

$$
\frac{\partial}{\partial p}(\text{($*$)の右辺}) =
\frac{n!}{(k-1)!(n-k)!} p^{k-1}(1-p)^{n-k}.
$$

($*$)の両辺は $p=0$ のとき互いに等しく, 導函数も互いに等しい.  ゆえに($*$)の左辺と右辺は等しい.


#### ベータ分布の一様分布の順序統計量の分布として解釈を使う方法

前節での($*$)の証明法では公式($*$)が成立する理由はよくわからないので, この節では一様分布の順序統計量としてベータ分布が解釈できることを使った照明を紹介しよう.

$T_1,\ldots,T_n$ は $0$ から $1$ のあいだの $n$ 個の独立な一様乱数であるとし, その中で $k$ 番目に小さなものを $\T{k}$ と書く($\T{k}$ を一様分布の順序統計量と呼ぶ).

このとき, $\T{k}\le p$ となることと, $T_1,\ldots,T_n$ の中に $p$ 以下のものが $k$ 個以上あることは同値である. 各々の $T_i$ が $p$ 以下になる確率は $p$ なので, $T_1,\ldots,T_n$ の中に含まれる $p$ 以下のものの個数は二項分布 $\Binomial(n, p)$ に従う. したがって, 

$$
(\text{$\T{k}\le p$ となる確率}) =
(\text{二項分布 $\Binomial(n, p)$ において $k$ 以上になる確率}) =
\sum_{i\ge k} \binom{n}{i} p^i (1-p)^{n-i}.
$$

一方, $t \le \T{k} \le t + dt$ となる確率は

$$
\begin{aligned}
&
(\text{$t \le \T{k} \le t + dt$ となる確率})
\\ &=
(\text{$\T{1}\le\cdots\le\T{k-1}\le\T{k}\le t+dt$ かつ $t\le\T{k}\le\T{k+1}\le\cdots\le\T{n}$ となる確率})
\\ &\approx
(\text{$\T{1}\le\cdots\le\T{k-1}\le t\le\T{k}\le t+dt\le\T{k+1}\le\cdots\le\T{n}$ となる確率})
\\ &=
(\text{$T_1,\ldots,T_n$ のうち $k-1$ 個が $t$ 以下で, 1個が $[t, t+dt]$ に含まれ, $n-k$ 個が $t+dt$ 以上の確率})
\\ &=
\frac{n!}{(k-1)!1!(n-k)!} t^{k-1}\,dt\,(1-t)^{n-k}
\end{aligned}
$$

と近似され, 誤差は $dt$ より高次の微小量になる.  $\T{1}\le\T{2}\le\cdots\le\T{n}$ が $T_i$ 達を小さな順序に並べたものになっていることおよび, $n!/((k-1)!1!(n-k)!)$ が $n$ 個の $T_1,\dots,T_n$ を $k-1$ 個, $1$ 個, $n-k$ 個にグループ分けする方法全体の個数(多項係数の特別な場合)になっていることに注意せよ. そして, 

$$
\frac{n!}{(k-1)!1!(n-k)!} =
\frac{\Gamma(n+1)}{\Gamma(k)\Gamma(n-k+1)} =
\frac{1}{B(k, n-k+1)}
$$

なので, $\T{k}$ が従う分布の確率密度函数はベータ分布 $\Beta(k, n-k+1)$ の密度函数

$$
p(t) = \frac{t^{k-1}(1-t)^{n-k}}{B(k, n-k+1)}
$$

に一致することがわかる. したがって,

$$
(\text{$\T{k}\le p$ となる確率}) =
\int_0^p p(t)\,dt =
\frac{\int_0^p t^{k-1}(1-t)^{n-k}\,dt}{B(k, n-k+1)}.
$$

これを上で示した結果と比較することによって次が得られる:

$$
\sum_{i=k}^n \binom{n}{i} p^i (1-p)^{n-i} = \frac{\int_0^p t^{k-1}(1-t)^{n-k}\,dt}{B(k, n-k+1)}.
$$


## P値函数について

P値函数に関する考え方の簡潔な説明については次の論文を参照せよ:

* Valentin Amrhein and Sander Greenland, Discuss practical importance of results based on interval estimates and p-value functions, not only on point estimates and null p-values, Journal of Information Technology, First Published June 3, 2022. \[[doi](https://doi.org/10.1177%2F02683962221105904)\]


### P値はモデルのパラメータ値とデータの数値の整合性の指標の1つ

我々は, データの数値の生成のされ方(未知の法則)をパラメータ付きの確率分布でモデル化し, それを統計モデルと呼ぶのであった.

例えば, 「$n$ 回中 $k$ 回当たりが出た」の形のデータの生成のされ方の統計モデルの代表例は二項分布モデル $\Binomial(n,p)$ であり, 当たりが出る確率は成功確率パラメータ $p$ でモデル化される.

以下では, データの数値 $x$ の生成のされ方をパラメータ $\theta$ を持つ統計モデル $M(\theta)$ でモデル化している状況を考える.

そしてさらに, データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値 $\pvalue(x|\theta=\theta_0)$ が適切に定義されているという一般的な状況も考える.

P値は, データの数値 $x$ と仮説 $\theta=\theta_0$ の下での統計モデル $M(\theta=\theta_0)$ の整合性の指標の1つである. 

ここでの整合性は英語では compatibility (両立性)や consititency (無矛盾性)という意味である.

例えば, 二項分布モデルの場合には, 「$100$ 回中 $40$ 回当たりが出た」というデータが得られたとき, 仮説 $p=1/2$ のP値(Clopper-Pearsonの信頼区間を与えるP値)は約 $5.7\%$ になる. 

__その $5.7\%$ というP値は「$100$ 回中 $40$ 回当たりが出た」というデータと「当たりが出る確率は $p=1/2$ である」という仮説の整合性の指標として使われることになる.__

ただし, __統計モデルの妥当性に注意を払う必要がある.__

P値の定義の仕方によって, その値は微妙に異なった値になる.

そういう細かな違いに結果が影響されないような頑健な議論を目指すべきである.

```julia
@show k, n, p = 40, 100, 1/2
@show pvalue_cp(k, n, p)
@show pvalue_sterne(k, n, p)
@show pvalue_wilson(k, n, p)
@show pvalue_wald(k, n, p);
```

### P値は信頼区間を考えたいすべてのパラメータ値について定義されている

二項分布モデルの場合には仮説 $p=1/2$ に限らず, $0$ から $1$ のあいだの任意の数値 $p_0$ に関する仮説 $p=p_0$ についてP値が定義されている.

それによって, 「$100$ 回中 $40$ 回当たりが出た」というデータが得られたとき, 仮説 $p=p_0$ における $p_0$ を動かしながらP値を計算することによって, $p=1/2$ の場合以外についても仮説 $p=p_0$ と「$100$ 回中 $40$ 回当たりが出た」というデータの整合性達がどうなっているかを知ることができる.

例えば, 仮説 $p=0.3$ とデータの数値の整合性を知ることができる.

```julia
@show k, n, p = 40, 100, 0.3
@show pvalue_cp(k, n, p)
@show pvalue_sterne(k, n, p)
@show pvalue_wilson(k, n, p)
@show pvalue_wald(k, n, p);
```

一般に, パラメータ値 $\theta_0$ に対して, データ $x$ に関する仮説 $\theta=\theta_0$ のP値を対応させる函数 $\theta_0\mapsto\pvalue(x|\theta=\theta_0)$ を __P値函数__ (P-value function)と呼ぶ.

P値函数は, 統計モデルについて, データの数値とパラメータ値のあいだの整合性(相性)の様子全体の情報を持っている重要な函数である.

以下では, 二項分布モデルにおける4種のP値函数のグラフをプロットしてみよう.

```julia
k, n = 40, 100
xlim = (0.2, 0.6)
P1 = plot(p -> pvalue_cp(k, n, p), xlim...;
    label="", title="Clopper-Pearson (n = $n, k = $k)")
P2 = plot(p -> pvalue_sterne(k, n, p), xlim...;
    label="", title="Sterne (n = $n, k = $k)", c=2)
P3 = plot(p -> pvalue_wald(k, n, p), xlim...;
    label="", title="Wald (n = $n, k = $k)", c=3)
P4 = plot(p -> pvalue_wilson(k, n, p), xlim...;
    label="", title="Wilson (n = $n, k = $k)", c=4)
plot(P1, P2, P3, P4; xguide="p = p₀", yguide="P-value", size=(800, 500))
```

近似的にはどれもほぼ同じ形をしている.


### 分割表の場合のP値函数

「Aでは $m=a+b$ 回中 $a$ 回当たりが出て, Bでは $n=c+d$ 回中 $c$ 回当たりが出た」の形式のデータを

$$
\begin{array}{|c|cc|c|}
\hline
& \text{当たり} & \text{はずれ} & \text{合計} \\
\hline
\text{A} & a & b & m \\
\text{B} & c & d & n \\
\hline
\end{array}
$$

のように $2\times 2$ の分割表で表すのであった.

このようなデータの生成のされ方の統計モデルとして, 2つの二項分布モデル $\Binomial(m,p)\times\Binomial(n,q)$ を採用しよう.

このモデル内で, $a$ の値は二項分布 $\Binomial(m,p)$ に従ってランダムに決まり, $c$ の値はそれとは独立に二項分布 $\Binomial(n,q)$ に従ってランダムに決まっていると考える. ($m=a+b$ と $n=c+d$ は固定されているので, $a,c$ から $b,d$ が自動的に決まる.)

応用時に重要になるのは, $p$ と $q$ の違いである.

__入門的な多くの教科書では非常に残念なことに, 仮説 $p=q$ のP値の定義しか書かれておらず, $p$ と $q$ の違いの大きさを表す指標の信頼区間の定義が書かれていない.__

これが前節で, __P値は信頼区間を考えたいすべてのパラメータ値について定義されている__ と強調したくなった理由である.

しかし, 我々はすでに

* [「検定と信頼区間: 比率の比較」のノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/11%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20proportions.ipynb)

で $p$ と $q$ の違いを表す3つの指標についてP値と信頼区間を定義している:

* オッズ比パラメータ $\ds \OR = \frac{p/(1-p)}{q/(1-q)} = \frac{p(1-q)}{(1-p)q}$,
* リスク比パラメータ $\ds \RR = \frac{p}{q}$,
* リスク差パラメータ $\ds \RD = p - q$.

これは, このノート群が入門的な教科書の多くと一線を画する点である.

この点に関しては, Rothmanさん達の有名な疫学の教科書

* Rothman, Lash, and Greenland, Modern Epidemiology \[[Googleで検索](https://www.google.com/search?q=Rothman+Lash+Greenland+Modern+Epidemiology)\]

が詳しい. 講義動画

* 佐藤俊哉, 臨床研究者のための生物統計学「回帰モデルと傾向スコア」2019年2月21日 \[[YouTube](https://youtu.be/cOHN444kBlo)\]

も参照せよ. 8:30以降の「変換しない場合」がリスク差パラメータを $p$ と $q$ の違いの指標として採用した場合に対応しており, 10:30以降の「対数変換の場合」がリスク比パラメータを $p$ と $q$ の違いの指標として採用した場合に対応しており, 12:00以降の「ロジット変換の場合」がオッズ比パラメータ(正確にはその対数)を $p$ と $q$ の違いの指標として採用した場合に対応している.  「ロジット変換の場合」はロジスティック回帰の話になっている.  ただし, 複数の分割表のデータを扱うより複雑な場合を扱っている.

__注意:__ 実際にはオッズ比パラメータの代わりに対数オッズ比パラメータ $\log\OR$ を扱うことが多い. その場合はロジスティック・モデルの特別な場合になっている. __注意終__


### P値函数から信頼区間が定義される

P値が信頼区間を考えたいすべてのパラメータ値について定義されていることの利点は, 言うまでもないことだが, 信頼区間を定義できることである.

一般に, データ $x$ の生成のされ方に関する統計モデル $M(\theta)$ に関するP値函数 $\pvalue(x|\theta=\theta_0)$ が与えられているとき, パラメータ $\theta$ に関する信頼度 $1-\alpha$ の信頼区間 ($100(1-\alpha)\%$ 信頼区間, confidence interval)は次のように定義される:

$$
\confint^\theta(x|\alpha) =
\{\, \theta_0 \mid \pvalue(x|\theta=\theta_0) \ge \alpha\,\}.
$$

すなわち, データの数値 $x$ について仮説 $\theta = \theta_0$ のP値が $\alpha$ 以上になるような $\theta_0$ 全体の集合が信頼区間になる.

ここで使われている閾値 $\alpha$ は __有意水準__ (significance level)と呼ばれる.

$1-\alpha$ は __信頼度__ (信頼水準, confidence level)と呼ばれる.

コンピュータで計算するときには, $\pvalue(x|\theta=\theta_0)=\alpha$ を満たす $\theta_0$ の値を2分法やNewton法などで計算すれば, 一般的な場合にも信頼区間を概ね計算できる.

しかし, それだとバグも発生し易くなるし, 計算効率も悪くなりがちなので, 信頼区間を直接できるシンプルな公式がある場合にはそちらを使うことになる.


### 2×2の分割表のP値と信頼区間とP値函数の例

以下では2×2の分割表のデータの数値

$$
\begin{array}{|c|cc|c|}
\hline
& \text{当たり} & \text{はずれ} \\
\hline
\text{A} & a=30 & b=70 \\
\text{B} & c=20 & d=80 \\
\hline
\end{array}
$$

に関するP値と信頼区間の例を示そう.

簡単のためオッズ比パラメータ $\OR$ を扱う場合(実際には対数オッズ比パラメータ $\log\OR$ を扱う場合)のWald型のP値函数のみを扱う.

$a+b=m$, $c+d=n$ が十分に大きければ, 仮説 $\OR=\dfrac{p/(1-p)}{q/(1-q)}=\omega$ の統計モデル内で, モデル内での仮想的データ $a,b,c,d$ の数値の対数オッズ比

$$
\log\ORhat = \log\frac{ad}{bc}
$$

が次のように近似的に正規分布に従うことを示せる:

$$
\log\ORhat \sim
\Normal\left(\log\omega, \SEhat_{\log\ORhat}\right), 
\ \text{approximately}.
$$

ここで,

$$
\SEhat_{\log\ORhat} = \sqrt{\frac{1}{a}+\frac{1}{b}+\frac{1}{c}+\frac{1}{d}}
$$

この近似については

* [「検定と信頼区間: 比率の比較」のノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/11%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20proportions.ipynb)

の「Wald版のオッズ比に関するP値と信頼区間の定義」に関する節を参照せよ.

これによって, 以下のように仮説 $\OR=\omega$ のP値と $\OR$ の信頼区間が定義できる:

$$
\begin{aligned}
&
\pvalue_{\Wald}(a, b, c, d|\OR=\omega) =
2\left(
1 - \cdf\left(\Normal(0,1), \frac{\left|\log\ORhat - \log\omega\right|}{\SEhat_{\log\ORhat}}\right)
\right),
\\ &
\confint^{\OR}_{\Wald}(a, b, c, d|\alpha) =
\left[
\exp\left(-z_{\alpha/2}\SEhat_{\log\ORhat}\right)\ORhat,\;
\exp\left( z_{\alpha/2}\SEhat_{\log\ORhat}\right)\ORhat
\right].
\end{aligned}
$$

ここで, $z_{\alpha/2} = \quantile(\Normal(0,1), 1-\alpha/2)$.

__注意:__ $\pvalue_{\Wald}(a, b, c, d|\OR=\omega)$ の定義の右辺は, 標準正規分布内で

$$
\frac{\log\ORhat - \log\omega}{\SEhat_{\log\ORhat}}
$$

の絶対値以上の(データの数値以上極端な)数値が生成される確率の2倍になっている.

```julia
# 上の定義通りのP値函数と信頼区間函数の実装

oddsratiohat(a, b, c, d) = safediv(a*d, b*c)
stderrhat_logoddsratiohat(a, b, c, d) = √(1/a + 1/b + 1/c + 1/d)

function pvalue_or_wald(a, b, c, d; ω=1)
    logORhat = log(oddsratiohat(a, b, c, d))
    SEhat_logORhat = stderrhat_logoddsratiohat(a, b, c, d)
    2ccdf(Normal(0, 1), safediv(abs(logORhat - log(ω)), SEhat_logORhat))
end

function confint_or_wald(a, b, c, d; α=0.05)
    z = quantile(Normal(), 1-α/2)
    ORhat = oddsratiohat(a, b, c, d)
    SEhat_logORhat = stderrhat_logoddsratiohat(a, b, c, d)
    [safemul(exp(-z*SEhat_logORhat), ORhat), safemul(exp(z*SEhat_logORhat), ORhat)]
end
```

```julia
# グラフのプロット用の函数
# この手の函数は計算用の函数よりも複雑になりがち

function plot_pvalue_function_of_or_wald(;
        a=30, b=70, c=20, d=80, ω = 1.0, α = 0.05,
        xlim = confint_or_wald(a, b, c, d; α=1e-3)
    )
    @show α
    @show ω
    @show z = quantile(Normal(0, 1), 1 - α/2)
    println()
    @show ORhat = oddsratiohat(a, b, c, d)
    @show exp(z *stderrhat_logoddsratiohat(a, b, c, d))
    println()
    @show P_value = pvalue_or_wald(a, b, c, d; ω)
    @show CI = confint_or_wald(a, b, c, d; α)
    
    plot(ω -> pvalue_or_wald(a, b, c, d; ω), xlim...;
        label="P-value function (Wald)", c=:black)
    vline!([ORhat]; label="ORhat = $(round(ORhat; digits=5))", ls=:dash, c=2)
    plot!(CI, fill(α, 2); label="$(100(1-α))% confidence interval", lw=2, c=3)
    scatter!([ω], [α]; label="significance level α = $(100α)%", c=3, msc=:auto)
    vline!([ω]; label="", c=:black, lw=0.5)
    scatter!([ω], [P_value]; label="P-value of OR = $ω", c=:red, msc=:auto)
    plot!(xguide="OR = ω     (log scale)", yguide="P-value")
    plot!(xscale=:log, xtick=logtick(; xlim), ytick=0:0.05:1)
    title!("a, b, c, d = $a, $b, $c, $d")
    plot!(size=(720, 350), bottommargin=4Plots.mm)
end
```

```julia
a, b, c, d = 30, 70, 20, 80
graph_of_pvalue_function =
    plot_pvalue_function_of_or_wald(; a, b, c, d, ω = 1.0, α = 0.05)
```

仮説 $\OR=1$ すなわち「AとBで当たりが出る確率は同じ」という仮説のP値は $10.4\%$ 程度になっている.

これが意味するところは以下の通り. データの数値

$$
\begin{array}{|c|cc|c|}
\hline
& \text{当たり} & \text{はずれ} \\
\hline
\text{A} & a=30 & b=70 \\
\text{B} & c=20 & d=80 \\
\hline
\end{array}
$$

を見ると, Aの方がBよりも当たりが出る確率が高そうに見えるが, 統計モデル内ではAとBで当たりが出る確率が同じであったとしても, モデル内でこのデータの数値以上に偏った値が生じる確率は約 $10.4\%$ もある.


さらに, 上のグラフを見ると, 仮説 $\OR=4$ のP値は $1\%$ 程度に見えるが, 実際に計算してもその程度の値になる.

```julia
pval4 = pvalue_or_wald(a, b, c, d; ω=4)
```

WolframAlphaでも仮説 $\OR=4$ のP値を計算してみよう.

$\SEhat_{\log\ORhat}$ → `sqrt(1/a + 1/b + 1/c + 1/d) where a=30.0, b=70, c=20, d=80` → \[[実行](https://www.wolframalpha.com/input?i=sqrt%281%2Fa+%2B+1%2Fb+%2B+1%2Fc+%2B+1%2Fd%29+where+a%3D30.0%2C+b%3D70%2C+c%3D20%2C+d%3D80)\] → 0.331842

$\log\ORhat - \log\omega$ → `log((a d)/(b c)) - log(4) where a=30.0, b=70, c=20, d=80` → \[[実行](https://www.wolframalpha.com/input?i=log%28%28a+d%29%2F%28b+c%29%29+-+log%284%29+where+a%3D30.0%2C+b%3D70%2C+c%3D20%2C+d%3D80)\] → -0.847298

$(\log\ORhat - \log\omega)/\SEhat_{\log\ORhat}$ → `0.847298/0.331842` → \[[実行](https://www.wolframalpha.com/input?i=0.847298%2F0.331842)\] → 2.55332

P値 → `2(1 - cdf(NormalDistribution(0,1), 2.55332))` → \[[実行](https://www.wolframalpha.com/input?i=2%281+-+cdf%28NormalDistribution%280%2C1%29%2C+2.55332%29%29)\] → 0.0106701

```julia
# WolframAlphaで求めたP値のJuliaで求めたP値に対する相対誤差が小さいことの確認
0.0106701/pval4 - 1
```

WolframAlphaでも $\OR$ の $95\%$ 信頼区間を求めてみよう.

$z_{\alpha/2}$ → `quantile(Normal(0,1), 0.975)` → \[[実行](https://www.wolframalpha.com/input?i=quantile%28Normal%280%2C1%29%2C+0.975%29)\] → 1.95996

信頼区間 → `{exp(-1.95996*0.331842) (a d)/(b c),  exp(1.95996*0.331842) (a d)/(b c)} where a=30.0, b=70, c=20, d=80` → \[[実行](https://www.wolframalpha.com/input?i=%7Bexp%28-1.95996*0.331842%29+%28a+d%29%2F%28b+c%29%2C++exp%281.95996*0.331842%29+%28a+d%29%2F%28b+c%29%7D+where+a%3D30.0%2C+b%3D70%2C+c%3D20%2C+d%3D80)\] → {0.89458, 3.28509}

```julia
# WolframAlphaで求めた信頼区間のJuliaで求めた信頼区間に対する相対誤差が小さいことの確認
[0.89458, 3.28509] ./ confint_or_wald(a, b, c, d; α=0.05) .- 1
```

<!-- #region -->
### 2×2の分割表での検定ではどれを使うべきか

以上においては計算の仕方がシンプルだという理由でWald型のP値函数と信頼区間を扱ったが, 標本サイズが小さいときに誤差が大きくなるという欠点がある.  他にも以下の選択肢がある:

(1) Pearsonの $\chi^2$ 検定 (ただし扱う仮説を $\OR=\omega$ と $\RR=\rho$ の場合に一般化しておくこと, 連続性補正はかけない)

(2) Fisher検定 (ただし扱う仮説を $\OR=\omega$ の場合に一般化しておくこと)

(3) $p$ と $q$ の違いの指標としてそれらの差 $p-q$ を扱う場合には Zou-Donner 2004 の方法が使える. ([Julia言語による実装例](https://github.com/genkuroki/public/blob/main/0033/probability%20of%20alpha%20error%20of%20Zou-Donner.ipynb))

それぞれ長所と短所があるので目的に合わせて適当に使い分ければよい.  標本サイズが十分に大きい場合にはWald型のP値函数と信頼区間も十分な精度を持ち, 問題なく使える.



__注意:__ よく使われているのは, Pearsonの $\chi^2$ 検定とFisher検定である.  標本サイズが小さい場合にはFisher検定を使えと解説されている場合もあるようだが, 実際に色々計算するとそれは誤りだと分かる.  実際には標本サイズが小さなとき, Fisher検定には過剰にP値が大きくなり過ぎるという欠点がある. しかし, その欠点は「第一種の過誤の確率が常に有意水準以下である」というFisher検定の優れた性質の裏返しなので, どの条件を重視するかによって, (Yatesの連続性補正をかけない)Pearsonの $\chi^2$ 検定と使い分けるとよいと思われる.  次の解説も参考になる:

* 朝倉こう子, 濱﨑俊光, 連載 第3回　医学データの統計解析の基本　２つの割合の比較　\[[PDF](https://www.jstage.jst.go.jp/article/dds/30/3/30_235/_pdf)\]

第一種の過誤の確率を確実に名目有意水準以下にしたければFisher検定を使う方がよいし, 平均的により高い検出力を得たいならば(連続補正されていない)Pearsonの $\chi^2$ 検定を使えばよいだろう.
<!-- #endregion -->

### P値函数と最尤法の関係

2×2の分割表のデータの数値

$$
\begin{array}{|c|cc|c|}
\hline
& \text{当たり} & \text{はずれ} \\
\hline
\text{A} & a=30 & b=70 \\
\text{B} & c=20 & d=80 \\
\hline
\end{array}
$$

に関するP値函数などは1つのグラフの中に以下のようにプロットされるのであった.

```julia
graph_of_pvalue_function
```

このグラフにおけるデータの数値のオッズ比

$$
\ORhat = \frac{ad}{bc} = \frac{30\cdot 80}{70\cdot 20} =
\frac{12}{7} \approx 1.7142857142857142
$$

の値でP値函数が最大値の $1$ になっていることに注意せよ.  P値函数の定義

$$
\pvalue_{\Wald}(a, b, c, d|\OR=\omega) =
2\left(
1 - \cdf\left(\Normal(0,1), \frac{\left|\log\ORhat - \log\omega\right|}{\SEhat_{\log\ORhat}}\right)
\right)
$$

を見れば, $\omega = \ORhat$ のとき最大値 $1$ になることはすぐにわかる.

実はこのデータの数値のオッズ比 $\OR = (ad)/(bc)$ は2つの二項分布モデルにおける最尤法(さいゆうほう)の解

$$
\phat = \frac{a}{a+b}, \quad \qhat = \frac{c}{c+d}
\quad\left(
\text{このとき}\ 1-\phat = \frac{b}{a+b}, \quad 1-\qhat = \frac{d}{c+d}
\right)
$$

のオッズ比になっている:

$$
\frac{\phat(1 - \qhat)}{(1-\phat)\qhat} = \frac{ad}{bc} = \ORhat.
$$

この場合に限らず, __多くの場合にP値函数が最大になるパラメータ値は最尤法の解に対応する値になっている.__

少なくとも, 近似的にはP値函数を最大化するパラメータ値は最尤法の解に対応する値だと考えてよい.

データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値は, 統計モデルを前提にしたときの仮説 $\theta=\theta_0$ とデータの数値 $x$ の整合性の指標の1つであった.

ゆえに, 以上で述べたことは, __最尤法の解に対応するパラメータ値はデータの数値との整合性が最も高いパラメータ値である__ とみなせる.

最尤法による点推定にはこのような解釈がある.

__注意・警告:__ 統計学を実践的に使う場合には, 最尤法による点推定の結果のみを報告せずに, 信頼区間などの区間推定の結果も報告する習慣になっている.  点推定の値は単に統計モデルの前提の下でデータの数値と最も整合性が高いパラメータ値を計算したにすぎず, 確率的な揺らぎが考慮されていない.  確率的揺らぎの影響に配慮した区間推定の結果も報告しないと, 点推定の値がどこまで正確な推定値だと考えられるかが全くわからなくなってしまう.

__注意:__ 尤度(ゆうど, likelihood)については

* [「条件付き確率分布, 尤度, 推定, 記述統計」に関するノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.ipynb)

における「尤度 (ゆうど)と推定」の節を参照せよ.  尤度の定義は __統計モデル内でデータと同じ数値が生成される確率もしくは確率の密度__ であり,  モデルのデータの数値への適合度の指標としては使えるが, 「もっともらしさ」の指標としては不適切であることに注意せよ.


### 以上のまとめの図

以下の図のように, P値函数全体の形を見れば多くのことを一目で確認できる.

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/P-value_function_and_etc.jpg" width=60%>


仮説 $\theta=0$ のP値のみ, 点推定値のみ, 信頼区間のみをP値函数のグラフ抜きにばらばらに描くと以下のようになり, 全体の関係がどうなっているかがひどく分かり難くなる.

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/P-value_function_not_displayed.jpg" width=90%>


__注意:__ Bayes統計における事後分布も以上で説明したP値函数とほぼ同じ使い方をできる.  P値函数について十分に理解しておけば, Bayes統計について学習するときにも役に立つだろう.


### おまけ: Bayes統計の方法を使った場合

このノート群の中ではできるだけBayes統計の方法には触れないように気を使ったが, 何も触れないわけには行かなかった. 現代においては, P値函数を使う方法だけではなく, Bayes統計の方法も「統計学の道具箱」の中に入れておいた方がよいと思われる.


2つの二項分布モデル $\Binomial(m, p)\times\Binomial(n, q)$ の事前分布として, 2つのJeffreya事前分布 $\Beta(1/2, 1/2)\times\Beta(1/2, 1/2)$ を採用する. 

このとき, 2×2の分割表のデータの数値

$$
\begin{array}{|c|cc|c|}
\hline
& \text{当たり} & \text{はずれ} \\
\hline
\text{A} & a=30 & b=70 \\
\text{B} & c=20 & d=80 \\
\hline
\end{array}
$$

から得られる事後分布は, $\Beta(30+1/2, 70+1/2)\times\Beta(20+1/2, 80+1/2)$ になる.

```julia
a, b, c, d = 30, 70, 20, 80
posterior = product_distribution([Beta(a+1/2, b+1/2), Beta(c+1/2, d+1/2)])
```

事後分布のサイズ100万のサンプルを作る.

```julia
sample_of_posterior = rand(posterior, 10^6)
```

事後分布でのオッズ比のサンプルを構成する.

```julia
@views p, q = sample_of_posterior[1,:], sample_of_posterior[2,:]
sample_of_posterior_odds_ratio = @. (p*(1-q))/((1-p)*q)
sample_of_posterior_odds_ratio'
```

オッズ比の点推定値として, 事後分布での中央値を採用しよう.

```julia
ORhat_posterior_median = median(sample_of_posterior_odds_ratio)
```

```julia
ORhat = oddsratiohat(a, b, c, d) # 最尤推定値
```

最尤推定値の `ORhat` との違いは小さい.

```julia
ORhat_posterior_median / ORhat - 1
```

オッズ比の区間推定として, 事後分布での $2.5\%$ と $97.5\%$ 分位点の間を採用しよう.

これを $95\%$ 信用区間(確信区間, credible interval)と呼ぶ.

```julia
credible_interval = quantile.(Ref(sample_of_posterior_odds_ratio), [0.025, 0.975])
print(credible_interval)
```

```julia
confidence_interval = confint_or_wald(a, b, c, d; α=0.05)
print(confidence_interval)
```

信頼区間(confidence interval)と信用区間(credible interval)の違いは小さい.

```julia
credible_interval ./ confidence_interval .- 1 |> print
```

オッズ比パラメータが $1$ という仮説のP値のBayes的代替物として, 事後分布で $1$ 以下になる確率と $1$ 以上になる確率の小さい方の2倍(と $1$ の小さい方)を採用する.  (これはClopper-Pearson型のP値函数の定義の類似になっている.)

```julia
ecdf_OR = ecdf(sample_of_posterior_odds_ratio)
pvalue_or_bayesian = ω -> min(1, 2ecdf_OR(ω), 2(1 - ecdf_OR(ω)))
P_value_Bayesian = pvalue_or_bayesian(1)
```

```julia
Pvalue_Wald = pvalue_or_wald(a, b, c, d; ω=1)
```

通常のP値とそのBayes的類似の違いは小さい.

```julia
P_value_Bayesian/Pvalue_Wald - 1
```

以上をまとめてプロットしてみよう.

```julia
ORs = sample_of_posterior_odds_ratio
CI = credible_interval
α = 0.05

xlim = quantile.(Ref(ORs), (1e-4, 1-1e-4))
bin = range(xlim..., 201)
h = Plots._make_hist((ORs,), bin, normed=true)
y = h.weights

plot(bin, y; seriestype=:stepbins)
stephist(ORs; norm=true, bin,
    label="posterior of odds ratio")
vline!([ORhat_posterior_median];
    label="median of posterior = $(round(ORhat_posterior_median; digits=5))", ls=:dash, c=2)
plot!(xguide="OR = ω", yguide="probability density")
plot!(xtick=0:0.5:10, ytick=0:0.05:1)
title!("data: a, b, c, d = $a, $b, $c, $d,     prior = Jeffreys")
plot!(size=(720, 350))

imin = findlast(i -> ecdf_OR(bin[i]) < 0.025, eachindex(bin))
imax = findlast(i -> ecdf_OR(bin[i]) > 0.975, reverse(eachindex(bin)))
@show ecdf_OR(bin[imin]), ecdf_OR(bin[imax])

plot!(CI, fill(α, 2); label="$(100(1-α))% credible interval (Bayesian CI)", lw=2, c=3)
plot!(bin[begin:imin], y[begin:imin-1]; seriestype=:stepbins,
    label="probability = 2.5%", c=4, fillrange=0, alpha=0.5)
plot!(bin[imax:end], y[imax:end]; seriestype=:stepbins,
    label="probability = 2.5%", c=5, fillrange=0, alpha=0.5)
```

```julia
plot(bin, y; seriestype=:stepbins)
stephist(ORs; norm=true, bin,
    label="posterior of odds ratio")
vline!([ORhat_posterior_median];
    label="median of posterior = $(round(ORhat_posterior_median; digits=5))", ls=:dash, c=2)
plot!(xguide="OR = ω", yguide="probability density")
plot!(xtick=0:0.5:10, ytick=0:0.05:1)
title!("data: a, b, c, d = $a, $b, $c, $d,     prior = Jeffreys")
plot!(size=(720, 350))

inull = findlast(i -> bin[i] < 1, eachindex(bin)) + 1

plot!(bin[begin:inull], y[begin:inull-1]; seriestype=:stepbins,
    label="half of P-value = $(round(P_value_Bayesian; digits=5)) / 2", c=6, fillrange=0, alpha=0.5)
```

通常のP値函数(Wald)とBayes的なP値函数の類似物のグラフを同時に描くとほぼぴったり重なる.

```julia
a, b, c, d = 30, 70, 20, 80
plot(ω -> pvalue_or_wald(a, b, c, d; ω);
    label="ordinary P-value function (Wald)")
plot!(ω -> pvalue_or_bayesian(ω);
    label="Bayesian analogue of P-value function", ls=:dash)
plot!(xguide="OR = ω", yguide="P-value")
plot!(xtick=0:0.5:10, ytick=0:0.05:1)
title!("data: a, b, c, d = $a, $b, $c, $d,     prior = Jeffreys")
plot!(size=(720, 350))
```

サンプルサイズがもっと小さいな場合にはここまでぴったり一致しないが, この場合には非常によく一致している.

この一致を見てしまった人が, 「ベイズ統計とP値を使う統計学は水と油である」のような考え方をすることは難しいように思われる.

以上によって, 通常のP値を使った統計分析をBayes統計の方法でどのようにすれば置き換えることができるかがわかった.

Bayes統計の方法では事前分布(prior)という新しい道具を使えるので, 別の新しいことも可能になる.

次の論文では以上と本質的に同じ方法をオッズ比ではなくリスク比の場合に適用して, Bayes統計の方法を使って統計分析を行っている:

* https://www.nejm.org/doi/full/10.1056/NEJMoa2115869

この論文ではBayes統計の方法を使っているが, 通常のP値を使う方法でも実質的に同じ結果が得られる.


## Welchの t 検定について

2つの群の平均の差に関するWelchの $t$ 検定に付随するP値と信頼区間については

* [「検定と信頼区間: 平均の比較」に関するノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/12%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20means.ipynb)

で非常に詳しく解説したが, 手続きが複雑なので以下で再度まとめておくことにする.


### Welchの t 検定のP値と信頼区間の定義

データは別の母集団Aから抽出されたサイズ $m$ の標本 $x_1,\ldots,x_m$ と別の母集団Bから抽出されたサイズ $n$ の標本 $y_1,\ldots,y_n$ であると仮定する.

母集団Aからのサイズ $m$ の標本についてその標本平均が従う分布は中心極限定理によって正規分布で十分に近似されていると仮定する.  母集団Bとサイズ $n$ についても同様であると仮定しておく.

母集団Aの(真の)平均を $\mu_x$ と書き, 母集団Bの(真の)平均を $\mu_y$ と書く.

標本 $x_1,\ldots,x_m$ の標本平均を $\xbar$ と書き, 標本 $y_1,\ldots,y_n$ の標本平均を $\ybar$ と書く.

母集団Aから一意的に決まっている定数 $\mu_x$ と標本を取り直すごとに確率的に変化する標本平均 $\xbar$ を混同しないように注意せよ.  $\mu_y$ と $\ybar$ についても同様に混同しないようにして欲しい.

さらに, 標本 $x_1,\ldots,x_m$ の不偏分散を $s_x^2$ と書き, 標本 $y_1,\ldots,y_n$ の不偏分散を $s_y^2$ と書く:

$$
s_x^2 = \frac{1}{m-1}\sum_{i=1}^m (x_i - \xbar)^2, \quad
s_y^2 = \frac{1}{n-1}\sum_{j=1}^n (y_j - \ybar)^2.
$$

これらを, 母集団Aの(真の)分散 $\sigma_x^2$ と母集団Bの(真の)分散 $\sigma_y^2$ と混同しないように注意せよ.

以上の状況で, 任意に与えられた実数 $\dmu$ に対して, $\mu_x - \mu_y = \dmu$ という仮説のP値を定義しよう.

まず, $t$ 統計量 $t = t(\dmu)$ を次のように定義する:

$$
t = t(\dmu) =
\frac
{(\xbar - \ybar) - \dmu}
{\ds \sqrt{\frac{s_x^2}{m} + \frac{s_y^2}{n}}}.
$$

さらに, 自由度と呼ばれる統計量 $\nu$ を次のように定義する:

$$
\nu =
\frac
{\ds \left(s_x^2/m + s_y^2/n\right)^2}
{\ds \frac{(s_x^2/m)^2}{m-1} + \frac{(s_y^2/n)^2}{n-1}}.
$$

そして, P値を次のように定義する:

$$
\pvalue_{\Welch}(\xbar, \ybar, s_x^2, s_y^2|m,n, \mu_x-\mu_y=\dmu) =
2(1-\cdf(\TDist(\nu), |t(\dmu)|)).
$$

ここで, $\cdf(\TDist(\nu), x)$ は自由度 $\nu$ の $t$ 分布の累積分布函数(cumulative distribution function, cdf)である.

以上に対応する平均の差 $\mu_x - \mu_y$ に関する信頼度 $1-\alpha$ の信頼区間は次のようになる:

$$
\begin{aligned}
&
\confint_{\Welch}(\xbar, \ybar, s_x^2, s_y^2|m,n,\alpha)
\\ &=
\left[
\xbar - \ybar - t_{\nu,\alpha/2}\sqrt{\frac{s_x^2}{m} + \frac{s_y^2}{n}},\;
\xbar - \ybar + t_{\nu,\alpha/2}\sqrt{\frac{s_x^2}{m} + \frac{s_y^2}{n}}\;
\right].
\end{aligned}
$$

ここで, $t_{\nu,\alpha/2} = \quantile(\TDist(\nu), 1-\alpha/2)$.  ただし, $\quantile(\TDist(\nu), p)$ は自由度 $\nu$ の $t$ 分布の分位点函数(quantile function, 累積分布函数の逆函数)である.


__注意:__ 自由度 $\nu$ をそのように定義する理由については

* [「検定と信頼区間: 平均の比較」のノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/12%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20means.ipynb)

の「Welchの t 検定で使う自由度の式の導出」の節を参照せよ. さらにその「Studentの t 検定とWelchの t 検定で使用する t 分布の自由度の比較」の節では

$$
(m+n-2) - \nu =
\frac
{\left(s_x^2/(m(m-1)) - s_y^2/(n(n-1))\right)^2}
{\ds \frac{(s_x^2/(m(m-1)))^2}{n-1} + \frac{(s_y^2/(n(n-1)))^2}{m-1}}
\ge 0
$$

となることも注意している. これより $\nu \le m+n-2$ となっている.

```julia
@vars s²_x s²_y m n ν
ν = (s²_x/m + s²_y/n)^2/((s²_x/m)^2/(m-1) + (s²_y/n)^2/(n-1))
lhs = (m+n-2) - ν
rhsnum = (s²_x/(m*(m-1)) - s²_y/(n*(n-1)))^2
rhsden = (s²_x/(m*(m-1)))^2/(n-1) + (s²_y/(n*(n-1)))^2/(m-1)
@show (lhs - rhsnum/rhsden).simplify()
Eq(lhs, rhsnum/rhsden)
```

__注意:__ $X_1,\ldots,X_n$ は分散 $\sigma^2$ を持つ分布の標本で, $\Xbar$ はその標本平均であるとする.  このとき, 不偏分散を計算するときに $n$ ではなく, $n-1$ で割る理由は単に

$$
E\left[\sum_{i=1}^n (X_i - \Xbar)^2\right] = (n-1)\sigma^2
$$

となるからである.  両辺を $n$ ではなく, $n-1$ で割らないと $\sigma^2$ が期待値として得られない. このような事実に関するより深い理解は __線形回帰が直交射影そのものであること__ を学べば得られる.  線形回帰に一般化された場合の不偏分散は, $n$ 次元空間の中の $r$ 次元部分空間の直交補空間の次元 $n-r$ で割ることによって得られる. 詳しい説明は

* [「回帰 (regression)」に関するノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/14%20Regression.ipynb)

の「βとσ²の不偏推定量」の節にある.  通常の標本の不偏分散は部分空間が1次元の $\{\,(t,t,\ldots,t)\mid t\in\R\,\}$ の場合になっている.

<!-- #region -->
### Welchの t 検定のP値や信頼区間の計算例

以下の例は

* [「検定と信頼区間: 平均の比較」に関するノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/12%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20means.ipynb#Welch%E3%81%AE-t-%E6%A4%9C%E5%AE%9A%E3%81%AEP%E5%80%A4%E3%81%A8%E4%BF%A1%E9%A0%BC%E5%8C%BA%E9%96%93%E3%81%AE%E8%A8%88%E7%AE%97%E3%81%AE%E5%BF%85%E4%BF%AE%E5%95%8F%E9%A1%8C%E3%81%AE%E8%A7%A3%E7%AD%94%E4%BE%8B)

における

* [必修問題: Welchの t 検定のP値と信頼区間の計算](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/12%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20means.ipynb#%E5%BF%85%E4%BF%AE%E5%95%8F%E9%A1%8C:-Welch%E3%81%AE-t-%E6%A4%9C%E5%AE%9A%E3%81%AEP%E5%80%A4%E3%81%A8%E4%BF%A1%E9%A0%BC%E5%8C%BA%E9%96%93%E3%81%AE%E8%A8%88%E7%AE%97)

の再掲である. 

サイズが `m = 20`, `n = 30` のデータ

```julia
x = [19.2, 22.7, 7.8, 138.5, 70.5, 44.3, 84.0, 35.6, 72.4, 23.9,
    11.7, 26.6, 73.8, 118.3, 54.2, 57.6, 40.5, 117.4, 102.3, 67.6]

y = [44.3, 66.9, 62.9, 78.4, 71.2, 32.5, 111.4, 38.2, 68.2, 50.7,
    74.5, 46.2, 65.7, 58.7, 42.5, 57.4, 63.0, 67.9, 72.1, 117.7,
    124.1, 48.9, 91.8, 80.8, 60.2, 76.8, 76.3, 59.9, 70.7, 46.4]
```

について以下を求めよ.

(1) 仮説 $\mu_x − \mu_y = 0$ のP値.

(2) 仮説 $\mu_x − \mu_y = −30$ のP値.

(3) Welchの t 検定に付随する 95% 信頼区間.
<!-- #endregion -->

#### WolframAlphaによるWelchの t 検定のP値と信頼区間の計算の必修問題の解答例

WoldramAlphaで標本の標本平均は `mean {a, b, c, …}` のように入力すれば計算できる.

WoldramAlphaで標本の不偏分散は `var {a, b, c, …}` のように入力すれば計算できる. 

__注意:__ 統計学の慣習では, 標本の分散は $n$ ではなく $n-1$ で割る方の不偏分散を意味することが多く, ソフトウェア側でもその慣習に従っていることが多い.  WoldramAlphaやJuliaやRの `var` はデフォルトで不偏分散を計算するが, Pythonのnumpyの `np.var` はそうではないので注意せよ. `np.var(x, ddof=1)` のように `ddof=1` が必要になる. 詳しくは公式ドキュメントの

* https://numpy.org/doc/stable/reference/generated/numpy.var.html

を参照せよ.  コンピュータで標本の分散の値を計算する場合にはそのための函数の仕様を確認しておいた方がよい. __注意終__

$\xbar$ → `mean {19.2, 22.7, 7.8, 138.5, 70.5, 44.3, 84.0, 35.6, 72.4, 23.9, 11.7, 26.6, 73.8, 118.3, 54.2, 57.6, 40.5, 117.4, 102.3, 67.6}` → [実行](https://www.wolframalpha.com/input?i=mean+%7B19.2%2C+22.7%2C+7.8%2C+138.5%2C+70.5%2C+44.3%2C+84.0%2C+35.6%2C+72.4%2C+23.9%2C+11.7%2C+26.6%2C+73.8%2C+118.3%2C+54.2%2C+57.6%2C+40.5%2C+117.4%2C+102.3%2C+67.6%7D) → 59.445

$s_x^2$ → `var {19.2, 22.7, 7.8, 138.5, 70.5, 44.3, 84.0, 35.6, 72.4, 23.9, 11.7, 26.6, 73.8, 118.3, 54.2, 57.6, 40.5, 117.4, 102.3, 67.6}` → [実行](https://www.wolframalpha.com/input?i=var+%7B19.2%2C+22.7%2C+7.8%2C+138.5%2C+70.5%2C+44.3%2C+84.0%2C+35.6%2C+72.4%2C+23.9%2C+11.7%2C+26.6%2C+73.8%2C+118.3%2C+54.2%2C+57.6%2C+40.5%2C+117.4%2C+102.3%2C+67.6%7D) → 1448.48

$\ybar$ → `mean {44.3, 66.9, 62.9, 78.4, 71.2, 32.5, 111.4, 38.2, 68.2, 50.7, 74.5, 46.2, 65.7, 58.7, 42.5, 57.4, 63.0, 67.9, 72.1, 117.7, 124.1, 48.9, 91.8, 80.8, 60.2, 76.8, 76.3, 59.9, 70.7, 46.4}` → [実行](https://www.wolframalpha.com/input?i=mean+%7B44.3%2C+66.9%2C+62.9%2C+78.4%2C+71.2%2C+32.5%2C+111.4%2C+38.2%2C+68.2%2C+50.7%2C+74.5%2C+46.2%2C+65.7%2C+58.7%2C+42.5%2C+57.4%2C+63.0%2C+67.9%2C+72.1%2C+117.7%2C+124.1%2C+48.9%2C+91.8%2C+80.8%2C+60.2%2C+76.8%2C+76.3%2C+59.9%2C+70.7%2C+46.4%7D) → 67.5433

$s_y^2$ → `var {44.3, 66.9, 62.9, 78.4, 71.2, 32.5, 111.4, 38.2, 68.2, 50.7, 74.5, 46.2, 65.7, 58.7, 42.5, 57.4, 63.0, 67.9, 72.1, 117.7, 124.1, 48.9, 91.8, 80.8, 60.2, 76.8, 76.3, 59.9, 70.7, 46.4}` → [実行](https://www.wolframalpha.com/input?i=var+%7B44.3%2C+66.9%2C+62.9%2C+78.4%2C+71.2%2C+32.5%2C+111.4%2C+38.2%2C+68.2%2C+50.7%2C+74.5%2C+46.2%2C+65.7%2C+58.7%2C+42.5%2C+57.4%2C+63.0%2C+67.9%2C+72.1%2C+117.7%2C+124.1%2C+48.9%2C+91.8%2C+80.8%2C+60.2%2C+76.8%2C+76.3%2C+59.9%2C+70.7%2C+46.4%7D) → 479.481

以下において, `x`, `v`, `y`, `w` はそれぞれ $\xbar$, $s_x^2$, $\ybar$, $s_y^2$ を意味する.

自由度 $\nu$ → `(v/m+w/n)^2/((v/m)^2/(m-1)+(w/n)^2/(n-1)) where {m=20, x=59.445, v=1448.48, n=30, y=67.5433, w=479.481}` → [実行](https://www.wolframalpha.com/input?i=%28v%2Fm%2Bw%2Fn%29%5E2%2F%28%28v%2Fm%29%5E2%2F%28m-1%29%2B%28w%2Fn%29%5E2%2F%28n-1%29%29+where+%7Bm%3D20%2C+x%3D59.445%2C+v%3D1448.48%2C+n%3D30%2C+y%3D67.5433%2C+w%3D479.481%7D) → 27.4358

(1)

仮説 $\mu_x-\mu_y = 0$ の $t$ 値 → `(x-y-0)/sqrt(v/m+w/n) where {m=20, x=59.445, v=1448.48, n=30, y=67.5433, w=479.481}` → [実行](https://www.wolframalpha.com/input?i=%28x-y-0%29%2Fsqrt%28v%2Fm%2Bw%2Fn%29+where+%7Bm%3D20%2C+x%3D59.445%2C+v%3D1448.48%2C+n%3D30%2C+y%3D67.5433%2C+w%3D479.481%7D) → -0.861294

仮説 $\mu_x-\mu_y = 0$ のP値 → `2(1 - cdf(TDistribution(27.4358), 0.861294))` → [実行](https://www.wolframalpha.com/input?i=2%281+-+cdf%28TDistribution%2827.4358%29%2C+0.861294%29%29) → 0.396541

(2)

仮説 $\mu_x-\mu_y = -30$ の $t$ 値 → `(x-y+30)/sqrt(v/m+w/n) where {m=20, x=59.445, v=1448.48, n=30, y=67.5433, w=479.481}` → [実行](https://www.wolframalpha.com/input?i=%28x-y%2B30%29%2Fsqrt%28v%2Fm%2Bw%2Fn%29+where+%7Bm%3D20%2C+x%3D59.445%2C+v%3D1448.48%2C+n%3D30%2C+y%3D67.5433%2C+w%3D479.481%7D) → 2.32935

仮説 $\mu_x-\mu_y = -30$ のP値 → `2(1 - cdf(TDistribution(27.4358), 2.32935))` → [実行](https://www.wolframalpha.com/input?i=2%281+-+cdf%28TDistribution%2827.4358%29%2C+2.32935%29%29) → 0.0274389

(3)

$\alpha=0.05$ のときの $t_{\nu, \alpha/2}$ → `quantile(TDistribution(27.4358), 0.975)` → [実行](https://www.wolframalpha.com/input?i=quantile%28TDistribution%2827.4358%29%2C+0.975%29) → 2.05031

$\mu_x - \mu_y$ の $95\%$ 信頼区間 → `{x-y-2.05031*sqrt(v/m+w/n), x-y+2.05031*sqrt(v/m+w/n)} where {m=20, x=59.445, v=1448.48, n=30, y=67.5433, w=479.481}` → [実行](https://www.wolframalpha.com/input?i=%7Bx-y-2.05031*sqrt%28v%2Fm%2Bw%2Fn%29%2C+x-y%2B2.05031*sqrt%28v%2Fm%2Bw%2Fn%29%7D+where+%7Bm%3D20%2C+x%3D59.445%2C+v%3D1448.48%2C+n%3D30%2C+y%3D67.5433%2C+w%3D479.481%7D) → {-27.3763, 11.1797}


#### Julia言語によるWelchの t 検定のP値と信頼区間の計算の必修問題の解答例

まず, 定義通りにJulia言語のコードで必要な函数を書く.

Julia言語対応環境において

* `x̄` は `x\bar` と入力してタブキーを押せば入力できる.
* `sx²` は `sx\^2` と入力してタブキーを押せば入力できる.
* `Δ` は `\Delta` と入力してタブキーを押せば入力できる.
* `ν` は `\nu` と入力してタブキーを押せば入力できる.
* `√` は `\sqrt` と入力してタブキーを押せば入力できる.

ユニコードの文字をプログラムのコードとして使いたくない人は `x̄` や `sx²` の代わりに `xbar`, `sx2` のように書いても全然問題ない.

以下ではほとんど数式通りにコードが書かれている

```julia
# 確率分布を扱う場合には常に以下を前もって実行しておく.

using Distributions

# t値の計算の仕方 (デフォルトで Δμ = 0 にしておく)

function tvalue_welch(m, x̄, sx², n, ȳ, sy²; Δμ=0)
    (x̄ - ȳ - Δμ) / √(sx²/m + sy²/n)
end

function tvalue_welch(x, y; Δμ=0)
    m, x̄, sx² = length(x), mean(x), var(x)
    n, ȳ, sy² = length(y), mean(y), var(y)
    tvalue_welch(m, x̄, sx², n, ȳ, sy²; Δμ)
end

# 自由度 ν の計算の仕方

function degree_of_freedom_welch(m, sx², n, sy²)
    (sx²/m + sy²/n)^2 / ((sx²/m)^2/(m-1) + (sy²/n)^2/(n-1))
end

function degree_of_freedom_welch(x, y)
    m, sx² = length(x), var(x)
    n, sy² = length(y), var(y)
    degree_of_freedom_welch(m, sx², n, sy²)
end

# P値の計算の仕方

function pvalue_welch(m, x̄, sx², n, ȳ, sy²; Δμ=0)
    t = tvalue_welch(m, x̄, sx², n, ȳ, sy²; Δμ)
    ν = degree_of_freedom_welch(m, sx², n, sy²)
    2ccdf(TDist(ν), abs(t))
end

function pvalue_welch(x, y; Δμ=0)
    m, x̄, sx² = length(x), mean(x), var(x)
    n, ȳ, sy² = length(y), mean(y), var(y)
    pvalue_welch(m, x̄, sx², n, ȳ, sy²; Δμ)
end

# 信頼区間の計算の仕方 (デフォルトでは α = 0.05 にしておく)

function confint_welch(m, x̄, sx², n, ȳ, sy²; α=0.05)
    ν = degree_of_freedom_welch(m, sx², n, sy²)
    c = quantile(TDist(ν), 1-α/2)
    SEhat = √(sx²/m + sy²/n)
    [x̄-ȳ-c*SEhat, x̄-ȳ+c*SEhat]
end

function confint_welch(x, y; α=0.05)
    m, x̄, sx² = length(x), mean(x), var(x)
    n, ȳ, sy² = length(y), mean(y), var(y)
    confint_welch(m, x̄, sx², n, ȳ, sy²; α)
end
```

以上のコードを何も考えずにコピー＆ペーストして使っても勉強にならない.

可能ならば全部自分で書き直してみるべきである.

そのためには, 出て来たビルトイン函数のすべてについて公式ドキュメントを参照した方がよい. 

Juliaの場合には公式ドキュメントはほぼ `?` で表示されるドキュメントに等しい.

Julia対応環境では例えば `?TDist` と入力すれば `TDist` のドキュメントを読むことができる.

```julia
?TDist
```

```julia
# x, y に標本の値を代入する.
x = [19.2, 22.7, 7.8, 138.5, 70.5, 44.3, 84.0, 35.6, 72.4, 23.9,
    11.7, 26.6, 73.8, 118.3, 54.2, 57.6, 40.5, 117.4, 102.3, 67.6];
y = [44.3, 66.9, 62.9, 78.4, 71.2, 32.5, 111.4, 38.2, 68.2, 50.7,
    74.5, 46.2, 65.7, 58.7, 42.5, 57.4, 63.0, 67.9, 72.1, 117.7,
    124.1, 48.9, 91.8, 80.8, 60.2, 76.8, 76.3, 59.9, 70.7, 46.4];
```

```julia
# (1)
pval1 = pvalue_welch(x, y; Δμ = 0)
```

統計学関係のコードを自分で書いた場合には, 何らかの方法で実装を間違っていないことを確認した方がよい. そのための1つの方法は別の方法で計算して確認することである.  例えばR言語で計算し直すと次のようになる.

```julia
@rput x y
pval1_R = rcopy(R"""t.test(x, y, mu = 0)""")[:p_value]
```

浮動小数点計算で生じる微小な誤差を除いてよく一致している.

```julia
pval1 - pval1_R
```

__注意:__ Julia言語から[R言語](https://cran.r-project.org/)を使うためには, 自分のパソコンにR言語一式をインストールし, さらにJulia言語の側で

* https://github.com/JuliaInterop/RCall.jl

をインストールしておく必要がある.

統計学を勉強するためには, 自分のパソコンで Julia, Python, R の3つを使えるようにしておくと非常に便利である.  しかし, そのためにはまた別のスキルが必要になる.  数年計画で身に付けるようにしておくとよいと思われる.  トラブルに出会ったら, 表示されたエラーメッセージをインターネットで検索してみるとよい.  コンピュータやプログラミングでは英語で書かれたトラブルの解決法を読むことは普通であり, そのために英語にも慣れておくことが必要になる.  結局のところ, __統計学を十分にマスターするために, コンピュータの使い方と技術英語もマスターする必要が生じる.__  しかし, 統計学を含めたそれら諸々のスキルを身に付けた人達は我々の社会の中で少数派であり, 学生時代のうちに身に付けることに成功した人達は相当に自信を持ってよいと思う.  繰り返しになるが, 数年計画で無理せずに身に付ければ十分である.  あせる必要はない.  就職した後にも勉強を続けることが普通である. __注意終__


WolframAlphaで求めた値の相対誤差が十分に小さいことの確認.

```julia
0.396541/pval1 - 1
```

```julia
# (2)
pval2 = pvalue_welch(x, y; Δμ = -30)
```

R言語で計算し直すと次のようになる.

```julia
@rput x y
pval2_R = rcopy(R"""t.test(x, y, mu = -30)""")[:p_value]
```

```julia
pval2 - pval2_R
```

WolframAlphaで求めた値の相対誤差が十分に小さいことの確認.

```julia
0.0274389/pval2 - 1
```

```julia
# (3)
ci3 = confint_welch(x, y; α = 0.05)
print(ci3)
```

R言語で計算し直すと次のようになる.

```julia
@rput x y
ci3_R = rcopy(R"""t.test(x, y, conf.level = 0.95)""")[:conf_int]
print(ci3_R)
```

```julia
ci3 - ci3_R |> print
```

WolframAlphaで求めた値の相対誤差が十分に小さいことの確認.

```julia
[-27.3763, 11.1797] ./ ci3 .- 1 |> print
```

Julia言語では要素ごとの演算(broadcast)にするためにはこのように演算記号に `.` を付ける.


せっかくなのでP値函数もプロットしておこう.

```julia
@show xlim = confint_welch(x, y; α=1e-3)
plot(Δμ -> pvalue_welch(x, y; Δμ), xlim...; label="P-value function", c=:black)
vline!([mean(x) - mean(y)]; label="Δμ = x̄ - ȳ", ls=:dash, c=2)
plot!(ci3, fill(0.05, 2); label="95% conf. int.", lw=2, c=3)
scatter!([0], [0.05]; label="sig. level α = 5%", c=3, msc=:auto)
vline!([0]; label="", lw=0.5, c=:black)
scatter!([0], [pval1]; label="P-value of Δμ = 0", c=:red, msc=:auto)
plot!(xguide="μ_x - μ_y = Δμ", yguide="P-value")
plot!(ytick=0:0.05:1)
plot!(size=(640, 350))
```

これと以下を比較せよ.

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/P-value_function_and_etc.jpg" width=60%>


上のWelchの $t$ 検定でのP値函数のグラフでは, パラメータ $\theta$ は2つの群の平均の差を意味する $\dmu$ になっている. 

そして, 点推定値は $\dmu = \xbar - \ybar$ になっている.  (この点推定値は正規分布の標本分布モデルにおける最尤推定値にもなっている.)

母集団からの標本の無作為抽出(random samplping, ランダム・サンプリング)を行うごとに変化するデータの数値の確率的揺らぎも考慮すると, 標本を取得した2つの母集団の平均の差 $\mu_x - \mu_y$ (これの値は未知)がぴったり点推定値 $\xbar - \ybar$ になっているとは考えられないことに注意せよ.

データの数値と $\mu_x - \mu_y = \dmu$ という仮説の整合性がP値函数のグラフを見ればわかる.

大雑把に, $\dmu$ の値が $-43$ 未満だったり, $27$ より大きいとき, $\mu_x - \mu_y = \dmu$ という仮説とデータの整合性はほぼないように見える. (この判断は有意水準を $\alpha=0.1\%$ とした場合に相当している.)

さらに大雑把に閾値 $\alpha = 5\%$ で切断した場合の信頼区間は大体 $[-27, 11]$ でそれよりは狭くなっている.


## 数学的な補足: 大数の法則と中心極限定理について

以下で $f(x)$ は有界な連続函数であると仮定する.


### 二項分布の大数の法則

二項分布

$$
P(k|n,p) = \binom{n}{k} p^k (1-p)^{n-k} \quad (k=0,1,\ldots,n)
$$

に関する大数の法則は, $n$ が大きなとき, $k/n$ の分布が $p$ の近くに集中することを意味する. これは

$$
\lim_{n\to\infty}
\sum_{k=0}^n f\left(\frac{k}{n}\right) \binom{n}{k} p^k (1-p)^{n-k} = f(p)
$$

が成立することを意味している. 

__注意:__ この結果の厳密な直接的証明は

* 高木貞治『解析概論』岩波書店

の「§78. Weierstrassの定理」の節にある.  そこの式(8)を見よ.  すなわち, 閉区間上の連続函数が多項式函数で一様近似できるというWeierstrassの定理は二項分布の大数の法則(の精密化)から得られる.  この方法は Serge Bernstein による.  __注意終__


$f(x)=\cos(\pi x)$, $p=1/3$ の場合について, 二項分布の大数の法則を数値的に確認してみよう.

```julia
f(x) = cospi(x)
n, p = 10^6, 1/3
@show bin = Binomial(n, p)
@show LHS = sum(f(k/n)*pdf(bin, k) for k in support(bin))
@show RHS = f(p)
@show LHS/RHS - 1;
```

```julia
f(x) = cospi(x)
ns, p = 10 .^ (1:0.5:4), 1/3
LHSs = [(n = round(Int, n); bin = Binomial(n, p);
        sum(f(k/n)*pdf(bin, k) for k in support(bin))) for n in ns]
RHS = f(p)
plot(ns, LHSs; xscale=:log10, xtick=ns, marker=:o,
    label="LHS", legend=:right)
hline!([RHS]; label="RHS")
```

```julia
plot((plot(x -> pdf(Binomial(10^k, 1/3), round(Int, x)), 0, 1.05*10^k;
            label="", title="Binomial($(10^k), 1/3)") for k in 2:5)...;
    size=(800, 500), layout=(2,2))
```

### 二項分布の中心極限定理

二項分布

$$
P(k|n,p) = \binom{n}{k} p^k (1-p)^{n-k} \quad (k=0,1,\ldots,n)
$$

に関する大数の法則は, $n$ が大きなとき, $k$ の分布が二項分布と同じ平均 $np$ と分散 $np(1-p)$ を持つ正規分布で近似されることを意味する.  すなわち, $n$ が大きなとき, 

$$
z = \frac{k - np}{\sqrt{np(1-p)}}
$$

の分布が標準正規分布で近似されることを意味する.  このことは次が成立することを意味する:

$$
\lim_{n\to\infty}
\sum_{k=0}^n f\left(\frac{k-np}{\sqrt{np(1-p)}}\right) \binom{n}{k} p^k (1-p)^{n-k} =
\int_{-\infty}^\infty f(z) \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz.
$$


$f(x)=\cos(x)$, $p=1/3$ の場合について, 二項分布の中心極限定理を数値的に確認してみよう.

```julia
f(x) = cos(x)
n, p = 10^6, 1/3
@show bin = Binomial(n, p)
@show LHS = sum(f((k-n*p)/√(n*p*(1-p)))*pdf(bin, k) for k in support(bin))
g(z) = f(z) * pdf(Normal(0, 1), z)
@show RHS = quadgk(g, -Inf, Inf)[1] # using QuadGK すると使える数値積分函数
@show LHS/RHS - 1;
```

実は次が成立している:

$$
\int_{-\infty}^\infty \cos(tz) \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz =
\int_{-\infty}^\infty e^{itz} \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz =
E\left[e^{itZ}\right] =
e^{-t^2/2}.
$$

ここで $Z$ は標準正規分布に従う確率変数である.

```julia
@vars z t real=true
g_sym(z) = cos(t*z) * exp(-z^2/2)/√(2Sym(π))
expr = sympy.Integral(g_sym(z), (z, -oo, oo))
sol_exact = expr.doit()
Eq(expr, sol_exact)
```

```julia
@show sol_numeriacal = float(sol_exact(t=>1))
@show RHS/sol_numeriacal - 1;
```

```julia
f(x) = cos(x)
ns, p = 10 .^ (1:0.5:4), 1/3
LHSs = [(n = round(Int, n); bin = Binomial(n, p);
        sum(f((k-n*p)/√(n*p*(1-p)))*pdf(bin, k) for k in support(bin))) for n in ns]
g(z) = f(z) * pdf(Normal(0, 1), z)
RHS = quadgk(g, -Inf, Inf)[1] # using QuadGK すると使える数値積分函数
plot(ns, LHSs; xscale=:log10, xtick=ns, marker=:o,
    label="LHS", legend=:right)
hline!([RHS]; label="RHS")
```

```julia
plot((plot(x -> pdf(Binomial(n, 1/3), round(Int, x)),
            round(Int, n/3 - 5√(n*1/3*2/3)),
            round(Int, n/3 + 5√(n*1/3*2/3));
            label="", title="Binomial($n, 1/3)") for n in (3, 10, 100, 1000))...;
    size=(800, 500), layout=(2,2))
```

### 他の分布の場合

正規分布で近似される他の分布の場合にも同様の結果が成立している.

#### 例: Poisson分布

$$
P(k|\lambda) = \frac{e^{-\lambda}\lambda^k}{k!} \quad (k=0,1,2,\ldots)
$$

の平均と分散は共に $\lambda$ であり, $\lambda$ が大きなとき同じ平均と分散を持つ正規分布で近似されるので,

$$
\lim_{\lambda\to\infty}
\sum_{k=0}^\infty
f\left(\frac{k-\lambda}{\sqrt{\lambda}}\right)
\frac{e^{-\lambda}\lambda^k}{k!} =
\int_{-\infty}^\infty f(z) \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz.
$$

```julia
f(x) = cos(x)
λ = 10^6
@show poi = Poisson(λ)
m, s = mean(poi), std(poi)
supp = max(0, round(Int, m-6s)):round(Int, m+6s)
@show LHS = sum(f((k-λ)/√λ) * pdf(poi, k) for k in supp)
g(z) = f(z) * pdf(Normal(0, 1), z)
@show RHS = quadgk(g, -Inf, Inf)[1] # using QuadGK すると使える数値積分函数
@show LHS/RHS - 1;
```

```julia
f(x) = cos(x)
λs = 10 .^ (1:0.5:4)
LHSs = [(poi = Poisson(λ);
        (m, s) = (mean(poi), std(poi));
        supp = max(0, round(Int, m-6s)):round(Int, m+6s);
        sum(f((k-λ)/√λ) * pdf(poi, k) for k in supp)) for λ in λs]
g(z) = f(z) * pdf(Normal(0, 1), z)
RHS = quadgk(g, -Inf, Inf)[1] # using QuadGK すると使える数値積分函数
plot(λs, LHSs; xscale=:log10, xtick=λs, marker=:o,
    label="LHS", legend=:right)
hline!([RHS]; label="RHS")
```

```julia
plot((plot(x -> pdf(Poisson(λ), round(Int, x)),
            round(Int, λ - 5√(λ)),
            round(Int, λ + 5√(λ));
            label="", title="Poisson($λ)") for λ in (3, 10, 100, 1000))...;
    size=(800, 500), layout=(2,2))
```

#### 例: Gamma分布

$$
p(x|\alpha,\theta) = \frac{e^{-x/\theta}x^{\alpha-1}}{\theta^\alpha\Gamma(\alpha)}
$$

は 平均 $\alpha\theta$, 分散 $\alpha\theta^2$ を持ち, $\alpha$ が大きなとき同じ平均と分散を持つ正規分布で近似されるので,

$$
\lim_{\lambda\to\infty}
\int_0^\infty
f\left(\frac{x-\alpha\lambda}{\sqrt{\alpha\theta^2}}\right)
\frac{e^{-x/\theta}x^{\alpha-1}}{\theta^\alpha\Gamma(\alpha)}
\,dx =
\int_{-\infty}^\infty f(z) \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz.
$$

```julia
f(x) = cos(x)
α, θ = 10^6, 2
@show gam = Gamma(α, θ)
F(x) = f((x - α*θ)/√(α*θ^2)) * pdf(gam, x)
m, s = mean(gam), std(gam)
a, b = m-5s, m+5s
@show LHS = quadgk(F, a, b)[1]
g(z) = f(z) * pdf(Normal(0, 1), z)
@show RHS = quadgk(g, -Inf, Inf)[1] # using QuadGK すると使える数値積分函数
@show LHS/RHS - 1;
```

```julia
f(x) = cos(x)
αs, θ = 10 .^ (1:0.5:4), 2
LHSs = [(gam = Gamma(α, θ);
        F(x) = f((x - α*θ)/√(α*θ^2)) * pdf(gam, x);
        (m, s) = (mean(gam), std(gam));
        (a, b) = (m-5s, m+5s);
        quadgk(F, a, b)[1]) for α in αs]
g(z) = f(z) * pdf(Normal(0, 1), z)
RHS = quadgk(g, -Inf, Inf)[1] # using QuadGK すると使える数値積分函数
plot(αs, LHSs; xscale=:log10, xtick=αs, marker=:o,
    label="LHS", legend=:right)
hline!([RHS]; label="RHS")
```

```julia
plot((plot(x -> pdf(Gamma(α, θ), x), α*θ - 5√(α*θ^2), α*θ + 5√(α*θ^2);
            label="", title="Gamma($α, θ)") for α in (3, 10, 100, 1000))...;
    size=(800, 500), layout=(2,2))
```

### 標本分布の場合

平均 $\mu$, 分散 $\sigma^2$ を持つ分布 $D$ の標本分布 $D^n$ に従う確率変数 $(X_1,\ldots,X_n)$ について,

$$
\Xbar_n = \frac{1}{n}\sum_{i=1}^n X_i
$$

は平均 $\mu$, 分散 $\sigma^2/n$ を持ち, 大数の法則より, $n$ が大きなとき $\mu$ の近くにその分布は集中する.  このことは次が成立することを意味している:

$$
\lim_{n\to\infty} E[f(\Xbar_n)] = f(\mu).
$$

さらに, 中心極限定理より, $\Xbar_n$ は$n$ が大きなとき同じ平均と分散を持つ正規分布に近似的に従う.  すなわち,

$$
Z_n = \frac{\Xbar_n - \mu}{\sqrt{\sigma^2/n}} =
\frac{\sqrt{n}\,(\Xbar_n - \mu)}{\sigma} =
\frac{1}{\sqrt{n}\;\sigma}\sum_{i=1}^n (X_i - \mu)
$$

は $n$ が大きなとき近似的に標準正規分布に従う.  このことは次が成立することを意味している:

$$
\lim_{n\to\infty} E[f(Z_n)] = \int_{-\infty}^\infty f(z) \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz.
$$

例えば, 平均 $\mu$, 分散 $\sigma^2$ の分布 $D$ が確率密度函数 $p(x)$ を持つとき,

$$
\begin{aligned}
&
\lim_{n\to\infty}
\int\!\!\cdots\!\!\int
f\left(\frac{x_1+\cdots+x_n}{n}\right)
p(x_1)\cdots p(x_n)\,dx_1\cdots dx_n =
f(\mu),
\\ &
\lim_{n\to\infty}
\int\!\!\cdots\!\!\int
f\left(\frac{(x_1-\mu)+\cdots+(x_n-\mu)}{\sqrt{n}\;\sigma}\right)
p(x_1)\cdots p(x_n)\,dx_1\cdots dx_n =
\int_{-\infty}^\infty f(z) \frac{e^{-z^2/2}}{\sqrt{2\pi}}\,dz.
\end{aligned}
$$

ここで $\int$ は適切な範囲の定積分を意味し, 各 $n$ ごとに $n$ 重の積分を考えている.

このような $n$ 重積分の $n\to\infty$ での極限公式は非常に複雑な形に見えるが, 大数の法則と中心極限定理を理解していれば直観的に当然そうなるべき結果だと理解できる.


### 再掲: 大数の法則と中心極限定理のイメージ

以下の図は

* [「大数の法則と中心極限定理」に関するノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/05%20Central%20limit%20theorem.ipynb)

にあった図の再掲である.

確率統計に関する入門的教科書の中には, 大数の法則や中心極限定理について説明するために, 確率変数や確率分布に関する様々な種類の収束性の定義を説明しているものが多い. (確率収束, 概収束, 法収束(法則収束, 分布収束)など. 他にも色々ある.)

この一連のノート群においては, そのような説明を意図的に避けた.

なぜならば, 統計学を実践的に使うことが目標の人達は以下の図のイメージを大事した方がよいように思われるからである.

数学的に正確な理解を目指す場合であっても, 最初のうちは以下の図のようなイメージを大事にして, むしろこのイメージを元に, 確率変数や確率分布の収束に関する数学的に適切な定義について, 自分で考えるようにした方が良いように思われる.

教科書に書いてある天下り的な定義から出発しようとすると数学の理解は苦しくなることが多い.

自分の力で適切な定義を作るために十分な「論理的スキル」と「健全な直観」の組み合わせの習得を目指す方が楽に理解できる可能性が増えるだろう.


<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/CTL.png" width=90%>


### 統計学の基礎になる確率論の三種の神器

これは筆者の個人的な意見に過ぎないのだが, 統計学の基礎になる確率論の三種の神器は次の3つである:

* 大数の法則
* 中心極限定理
* Kullback-Leibler情報量に関するSanovの定理

この一連のノート群で3つ目の __Kullback-Leibler情報量に関するSanovの定理__ にはほとんど触れることができなかった.

Kullback-Leibler情報量のSanovの定理については

* [「Bernoulli試行と関連確率分布」に関するノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.ipynb)

の「問題: Kullback-Leibler情報量とGibbsの情報不等式」と

* [「大数の法則と中心極限定理」に関するノート](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/05%20Central%20limit%20theorem.ipynb)

の「注意: Kullback-Leibler情報量とSanovの定理との関係」で簡単に触れただけで終わった.

Kullback-Leibler情報量のSanovの定理は __大偏差原理__ (large deviation principle)の特別な場合になっているので, 三種の神器の3番目は「大偏差原理」に一般化しておいてもよい.  大偏差原理は統計力学的な意味でのエントロピーや除法理論における情報量の概念を扱う話だと思ってよい.

Kullback-Leibler情報量のSanovの定理は赤池情報量規準(AIC)などの情報量規準の基礎になる.

Sanovの定理の易しい解説が以下の場所にある:

* [Kullback-Leibler情報量とSanovの定理](https://genkuroki.github.io/documents/20160616KullbackLeibler.pdf)

確率論で役に立つ解析学については次のノートも参考になるかもしれない:

* [ガンマ分布の中心極限定理とStirlingの公式](https://genkuroki.github.io/documents/20160501StirlingFormula.pdf)

ついでに紹介しておくと, ガンマ函数やベータ函数などについては次の場所にあるノート群が詳しい:

* [「微分積分学」に関するノート群](https://github.com/genkuroki/Calculus)

さらに, 図書館で次の文献も参照できれば, 統計学の基礎になる確率論の三種の神器について理解を深め易いと思われる:

* 高橋陽一郎, 確率論の広がり, 数学のたのしみ, no.8 (1998) pp.26-35　([関連情報を検索](https://www.google.com/search?q=%E9%AB%98%E6%A9%8B%E9%99%BD%E4%B8%80%E9%83%8E+%E7%A2%BA%E7%8E%87%E8%AB%96%E3%81%AE%E5%BA%83%E3%81%8C%E3%82%8A+%E6%95%B0%E5%AD%A6%E3%81%AE%E3%81%9F%E3%81%AE%E3%81%97%E3%81%BF+1998))

__面白いことはたくさんある(ありすぎる).__

__あせらずに楽しみながら勉強して欲しいと思います.__


### Kullback-Leibler情報量に関するSanovの定理の数値例

__二項分布の場合のSanovの定理の1つの形:__ $n\to\infty$, $k\sim np$ のとき

$$
\lim_{n\to\infty} \frac{-1}{n}\log\left(\binom{n}{k}q^k(1-q)^{n-k}\right) =
p\log\frac{p}{q} + (1-p)\log\frac{1-p}{1-q}.
$$

この公式の右辺はKullback-Leibler情報量の最も簡単な場合になっている.  これは

$$
\begin{aligned}
&
(\text{二項分布 $\Binomial(n, q)$ で $np$ に近い値 $k$ が生成される確率})
\\ &=
\exp\left(-n\left(p\log\frac{p}{q} + (1-p)\log\frac{1-p}{1-q}\right) + o(n)\right).
\end{aligned}
$$

と書き直される.  これは, 二項分布 $\Binomial(n, q)$ で $np$ に近い値 $k$ が生成される確率の大きさがほぼKullback-Leibler情報量で決まっていることを意味している.

__注意:__ 上の結果は, 階乗のStirlingの近似公式を使うと簡単に証明できるし, 高校数学で習ったはずに区分求積法を使っても容易に証明できる. __注意終__

上の結果を数値的に確認してみよう.

```julia
n, p, q = 10^16, 1/3, 1/2
@show LHS = (-1/n)*logpdf(Binomial(n, q), round(Int, n*p))
@show RHS = p*log(p/q) + (1-p)*log((1-p)/(1-q));
```

```julia
ns, p, q = 10 .^ (1:0.5:4), 1/3, 1/2
LHSs = [(-1/n)*logpdf(Binomial(round(Int, n), q), round(Int, n*p)) for n in ns]
RHS = p*log(p/q) + (1-p)*log((1-p)/(1-q))
plot(ns, LHSs; xscale=:log10, xtick=ns, marker=:o, label="LHS")
hline!([RHS]; label="RHS")
```

```julia

```
