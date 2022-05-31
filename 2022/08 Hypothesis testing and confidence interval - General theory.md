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

数値の値

$\text{数値の値}$


# 検定と信頼区間: 一般論

* 黒木玄
* 2022-05-31～2022-05-31

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
\newcommand\pvalue{\op{pvalue}}
$

このノートでは[Julia言語](https://julialang.org/)を使用している: 

* [Julia言語のインストールの仕方の一例](https://nbviewer.org/github/genkuroki/msfd28/blob/master/install.ipynb)

自明な誤りを見つけたら, 自分で訂正して読んで欲しい.  大文字と小文字の混同や書き直しが不完全な場合や符号のミスは非常によくある.

このノートに書いてある式を文字通りにそのまま読んで正しいと思ってしまうとひどい目に会う可能性が高い. しかし, 数が使われている文献には大抵の場合に文字通りに読むと間違っている式や主張が書いてあるので, 内容を理解した上で訂正しながら読んで利用しなければいけない. 実践的に数学を使う状況では他人が書いた式をそのまま信じていけない.

このノートの内容よりもさらに詳しいノートを自分で作ると勉強になるだろう.  膨大な時間を取られることになるが, このノートの内容に関係することで飯を食っていく可能性がある人にはそのためにかけた時間は無駄にならないと思われる.

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#お勧め解説動画" data-toc-modified-id="お勧め解説動画-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>お勧め解説動画</a></span></li><li><span><a href="#まとめ" data-toc-modified-id="まとめ-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>まとめ</a></span><ul class="toc-item"><li><span><a href="#P値" data-toc-modified-id="P値-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>P値</a></span></li><li><span><a href="#検定" data-toc-modified-id="検定-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>検定</a></span></li><li><span><a href="#信頼区間" data-toc-modified-id="信頼区間-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>信頼区間</a></span></li><li><span><a href="#nuisanceパラメータがある場合" data-toc-modified-id="nuisanceパラメータがある場合-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>nuisanceパラメータがある場合</a></span></li></ul></li><li><span><a href="#P値の定義" data-toc-modified-id="P値の定義-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>P値の定義</a></span><ul class="toc-item"><li><span><a href="#統計モデルの設定" data-toc-modified-id="統計モデルの設定-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>統計モデルの設定</a></span></li></ul></li><li><span><a href="#P値を使った検定" data-toc-modified-id="P値を使った検定-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>P値を使った検定</a></span></li><li><span><a href="#P値函数を使った信頼区間" data-toc-modified-id="P値函数を使った信頼区間-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>P値函数を使った信頼区間</a></span></li><li><span><a href="#信頼区間と検定の表裏一体性" data-toc-modified-id="信頼区間と検定の表裏一体性-6"><span class="toc-item-num">6&nbsp;&nbsp;</span>信頼区間と検定の表裏一体性</a></span></li><li><span><a href="#P値函数が「よい」かどうかの判断基準達" data-toc-modified-id="P値函数が「よい」かどうかの判断基準達-7"><span class="toc-item-num">7&nbsp;&nbsp;</span>P値函数が「よい」かどうかの判断基準達</a></span></li><li><span><a href="#Neyman-Pearsonの補題" data-toc-modified-id="Neyman-Pearsonの補題-8"><span class="toc-item-num">8&nbsp;&nbsp;</span>Neyman-Pearsonの補題</a></span></li><li><span><a href="#よくある誤解" data-toc-modified-id="よくある誤解-9"><span class="toc-item-num">9&nbsp;&nbsp;</span>よくある誤解</a></span></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using BenchmarkTools
using Distributions
using LinearAlgebra
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
myskewness(dist::MixtureModel{Univariate, Continuous}) = standardized_moment(dist, 3)
mykurtosis(dist::MixtureModel{Univariate, Continuous}) = standardized_moment(dist, 4) - 3
```

## お勧め解説動画

P値と検定と信頼区間については次のリンク先の動画での解説が素晴らしいので, 閲覧を推奨する:

* 京都大学大学院医学研究科 聴講コース 臨床研究者のための生物統計学「仮説検定とP値の誤解」佐藤 俊哉 医学研究科教授 [https://youtu.be/vz9cZnB1d1c](https://youtu.be/vz9cZnB1d1c)

信頼区間の解説は40分あたり以降にある.  多くの入門的な解説が抱えているP値, 検定, 信頼区間の解説の難点は以下の2つに要約される:

* 複雑な現実と統計モデルを混同させるような解説が伝統的に普通になってしまっていること.
* 検定と信頼区間の表裏一体性(双対性)が解説されていないこと.

このことが原因がP値も $95\%$ 信頼区間の $95\%$ も数学的フィクションである統計モデル内での確率であることがクリアに説明されておらず, そのせいでP値と $95\%$ 信頼区間の $95\%$ についてまっとうな理解が得られ難くなっている.  上で紹介した動画は教科書の説明がまずいことについて明瞭に言及しながら, 伝統的な入門的解説が抱えている問題を解消しようとしている.


## まとめ


### P値

__P値__ (P-value)は以下を与えることによって定義される:

* 現実世界におけるデータの数値 $x$ の生成のされ方に関するパラメータ $\theta$ を持つ統計モデル,
* 「データの数値以上に極端な」の意味の定義,
* さらに必要ならば近似計算法.

データの数値 $x$ とパラメータの値 $\theta=\theta_0$ が与えらえたとき, P値は

* データの数値 $x$ 以上に極端な値が条件 $\theta=\theta_0$ の下での統計モデル内で生じる確率もしくはその近似値

と定義される. このとき, 条件 $\theta=\theta_0$ は __帰無仮説__ (null hypothesis)と呼ばれることがある. (「データの数値以上に極端な」の定義は __対立仮説__ (alternative hypothesis)の __集まり__ を与えることによって与えらえると考えられる.)

このノートでは以上のように定義されたP値を

* データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値

と呼ぶことにする.

P値は以下の2つの整合性の指標として使われる:

* 現実世界から得たデータの数値 $x$,
* 統計モデル＋パラメータの値 $\theta=\theta_0$.

P値が小さいほど, 統計モデル＋パラメータの値 $\theta$ は現実世界から得たデータの数値 $x$ と整合していないと考える.


### 検定

__有意水準__ と呼ばれる閾値(いきち, しきいち) $0<\alpha<1$ が与えられたとき, P値が $\alpha$ 未満ならば, 

* 統計モデル＋パラメータの値は現実世界から得たデータの数値と整合性がない

とみなす. このとき

* 統計モデル＋パラメータの値は現実世界から得たデータによって __棄却__ (reject)されたという.

この手続きを __検定__ (test, testing, hypothesis testing)と呼ぶ.  (P値が有意水準 $\alpha$ 以上になるとき, 「受容 (accept)された」ということがあるが, 混乱の原因になるので, このノートでは用いない.  このノートでは「棄却された」「棄却されなかった」の組み合わせを一貫して使うことにする.)

棄却されなかった統計モデルとパラメータの値の組み合わせについては強い結論は何も出せない. 棄却されずにすんだ統計モデルとパラメータの値の組み合わせは単に閾値 $\alpha$ の設定で捨てられずにすんだだけなので, 「棄却されなかった統計モデルとパラメータの値の組み合わせは正しいと考えてよい」と考えることは典型的な誤解になる.

有意水準 $\alpha$ として $5\%$ が非常によく使われているが, それは単に慣習的にそうなっているだけのことで, $5\%$ の有意水準を使うことに科学的な合理性はない. 

$5\%$ の有意水準の下での結果に一喜一憂することは非科学的な考え方である.

__検定の手続きは「科学的お墨付きを得るための手段」ではない!__

同じことは次の節で説明する信頼区間についても言える.


### 信頼区間

__信頼区間__ (confidence interval)の文脈で $1 - \alpha$ は __信頼度__ (信頼係数)と呼ばれる.

統計モデルが実数パラメータ $\theta$ を持つとき, データの数値 $x$ から決まる信頼度 $1-\alpha$ の信頼区間は

* データの数値 $x$ と有意水準 $\alpha$ で棄却されない統計モデルのパラメータ値 $\theta$ 全体の集合

として定義される.  (この集合が区間にならない場合には信頼領域(confidence region)と呼んだりする.  その集合を含む最小の区間を考える場合もある.)

信頼区間を使うことは, 検定の手続きを無数のパラメータ値 $\theta$ 達に対して適用することと同じである.

検定で棄却されなかった場合については強い結論は何も出せないので, 信頼区間は

* 正しさについて判断を保留するべきパラメータ値全体の集合

だとみなされる.


### nuisanceパラメータがある場合

実際には統計モデルは興味があるパラメータ $\theta$ 以外にパラメータ $\eta$ を含んでいることがある. (例えば平均パラメータ $\mu$ のみに興味があるときの正規分布 $\op{Normal}(\mu,\sigma)$ における標準偏差パラメータ $\sigma$.)

その場合にはパラメータ $\theta$ の値を決めても, 統計モデルの確率分布は唯一つに決まらず, パラメータ $\eta$ の分だけ不定になる.

P値の定義は「データの数値 $x$ 以上に極端な値が帰無仮説 $\theta=\theta_0$ の下での統計モデル内で生じる確率もしくはその近似値」であった.  帰無仮説 $\theta=\theta_0$ で統計モデルの確率分布が唯一つに決まらない場合にはこのP値の定義を単純に適用することが不可能になる.

このような状況のときに, 余計なパラメータ $\eta$ を __nuisanceパラメータ__ (ニューサンスパラメータ, 局外パラメータ,　撹乱パラメータ, 迷惑パラメータ)と呼ぶ(nuisanceは迷惑や妨害を意味する名詞). 

大抵の場合にnuisanceパラメータが存在しているという問題は, P値を使う統計分析の基礎付けが複雑になる主な原因の1つになっている.

nuisanceパラメータへの対処法には例えば以下がある:

* 条件付き確率分布に移ってnuisanceパラメータの自由度を消す.
* 最尤法の漸近論を使ってnuisanceパラメータによらずに成立する近似を得る.
* Bayes法を使う.


## P値の定義


### 統計モデルの設定

現実世界のデータの生じ方のモデル化として使用される統計モデルを考える.

__例 (二項分布モデル):__

* 現実世界のデータ: 当たりとはずれが出るルーレットを $n$ 回まわしたときの当たりの回数 $k$
* 統計モデル: 二項分布モデル $\op{Binomial}(n, p)$

__例 (正規分布の標本分布モデル):__

* 現実世界のデータ: S市の中学3年生男子全体から $n$ 人を無作為抽出して測った身長 $x_1,\ldots,x_n$
* 統計モデル: 正規分布のサイズ $n$ の標本分布モデル $\op{Normal}(\mu,\sigma)^n$


## P値を使った検定


## P値函数を使った信頼区間


## 信頼区間と検定の表裏一体性


## P値函数が「よい」かどうかの判断基準達


## Neyman-Pearsonの補題


## よくある誤解


$\sqrt{x}/\sqrt{2}$

```julia

```
