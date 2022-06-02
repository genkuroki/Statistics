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

# 検定と信頼区間: 一般論

* 黒木玄
* 2022-05-31～2022-06-02

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
<div class="toc"><ul class="toc-item"><li><span><a href="#お勧め解説動画" data-toc-modified-id="お勧め解説動画-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>お勧め解説動画</a></span></li><li><span><a href="#まとめ" data-toc-modified-id="まとめ-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>まとめ</a></span><ul class="toc-item"><li><span><a href="#P値" data-toc-modified-id="P値-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>P値</a></span></li><li><span><a href="#検定" data-toc-modified-id="検定-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>検定</a></span></li><li><span><a href="#信頼区間" data-toc-modified-id="信頼区間-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>信頼区間</a></span></li><li><span><a href="#nuisanceパラメータがある場合" data-toc-modified-id="nuisanceパラメータがある場合-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>nuisanceパラメータがある場合</a></span></li></ul></li><li><span><a href="#P値の定義" data-toc-modified-id="P値の定義-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>P値の定義</a></span><ul class="toc-item"><li><span><a href="#統計モデルの設定" data-toc-modified-id="統計モデルの設定-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>統計モデルの設定</a></span></li><li><span><a href="#P値の定義" data-toc-modified-id="P値の定義-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>P値の定義</a></span></li><li><span><a href="#データの数値以上に極端な値の定義の仕方" data-toc-modified-id="データの数値以上に極端な値の定義の仕方-3.3"><span class="toc-item-num">3.3&nbsp;&nbsp;</span>データの数値以上に極端な値の定義の仕方</a></span><ul class="toc-item"><li><span><a href="#例(二項分布モデル)の場合" data-toc-modified-id="例(二項分布モデル)の場合-3.3.1"><span class="toc-item-num">3.3.1&nbsp;&nbsp;</span>例(二項分布モデル)の場合</a></span></li><li><span><a href="#例(正規分布の標本分布モデル)の場合" data-toc-modified-id="例(正規分布の標本分布モデル)の場合-3.3.2"><span class="toc-item-num">3.3.2&nbsp;&nbsp;</span>例(正規分布の標本分布モデル)の場合</a></span></li></ul></li><li><span><a href="#P値は帰無仮説下の統計モデルのデータの数値との整合性の指標" data-toc-modified-id="P値は帰無仮説下の統計モデルのデータの数値との整合性の指標-3.4"><span class="toc-item-num">3.4&nbsp;&nbsp;</span>P値は帰無仮説下の統計モデルのデータの数値との整合性の指標</a></span></li></ul></li><li><span><a href="#P値を使った検定" data-toc-modified-id="P値を使った検定-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>P値を使った検定</a></span></li><li><span><a href="#P値函数を使った信頼区間" data-toc-modified-id="P値函数を使った信頼区間-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>P値函数を使った信頼区間</a></span></li><li><span><a href="#信頼区間と検定の表裏一体性" data-toc-modified-id="信頼区間と検定の表裏一体性-6"><span class="toc-item-num">6&nbsp;&nbsp;</span>信頼区間と検定の表裏一体性</a></span><ul class="toc-item"><li><span><a href="#検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合" data-toc-modified-id="検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合-6.1"><span class="toc-item-num">6.1&nbsp;&nbsp;</span>検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合</a></span></li><li><span><a href="#仮説-$\theta=\theta_0$-下の統計モデル内でパラメータ値-$\theta=\theta_0$-が信頼区間に含まれる確率" data-toc-modified-id="仮説-$\theta=\theta_0$-下の統計モデル内でパラメータ値-$\theta=\theta_0$-が信頼区間に含まれる確率-6.2"><span class="toc-item-num">6.2&nbsp;&nbsp;</span>仮説 <span id="MathJax-Element-2442-Frame" class="mjx-chtml MathJax_CHTML" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>&amp;#x03B8;</mi><mo>=</mo><msub><mi>&amp;#x03B8;</mi><mn>0</mn></msub></math>" role="presentation" style="font-size: 117%; position: relative;"><span id="MJXc-Node-23379" class="mjx-math" aria-hidden="true"><span id="MJXc-Node-23380" class="mjx-mrow"><span id="MJXc-Node-23381" class="mjx-mi"><span class="mjx-char MJXc-TeX-math-I" style="padding-top: 0.477em; padding-bottom: 0.287em;">θ</span></span><span id="MJXc-Node-23382" class="mjx-mo MJXc-space3"><span class="mjx-char MJXc-TeX-main-R" style="padding-top: 0.097em; padding-bottom: 0.335em;">=</span></span><span id="MJXc-Node-23383" class="mjx-msubsup MJXc-space3"><span class="mjx-base"><span id="MJXc-Node-23384" class="mjx-mi"><span class="mjx-char MJXc-TeX-math-I" style="padding-top: 0.477em; padding-bottom: 0.287em;">θ</span></span></span><span class="mjx-sub" style="font-size: 70.7%; vertical-align: -0.212em; padding-right: 0.071em;"><span id="MJXc-Node-23385" class="mjx-mn" style=""><span class="mjx-char MJXc-TeX-main-R" style="padding-top: 0.382em; padding-bottom: 0.382em;">0</span></span></span></span></span></span><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>θ</mi><mo>=</mo><msub><mi>θ</mi><mn>0</mn></msub></math></span></span>$\theta=\theta_0$ 下の統計モデル内でパラメータ値 <span id="MathJax-Element-2443-Frame" class="mjx-chtml MathJax_CHTML" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>&amp;#x03B8;</mi><mo>=</mo><msub><mi>&amp;#x03B8;</mi><mn>0</mn></msub></math>" role="presentation" style="font-size: 117%; position: relative;"><span id="MJXc-Node-23386" class="mjx-math" aria-hidden="true"><span id="MJXc-Node-23387" class="mjx-mrow"><span id="MJXc-Node-23388" class="mjx-mi"><span class="mjx-char MJXc-TeX-math-I" style="padding-top: 0.477em; padding-bottom: 0.287em;">θ</span></span><span id="MJXc-Node-23389" class="mjx-mo MJXc-space3"><span class="mjx-char MJXc-TeX-main-R" style="padding-top: 0.097em; padding-bottom: 0.335em;">=</span></span><span id="MJXc-Node-23390" class="mjx-msubsup MJXc-space3"><span class="mjx-base"><span id="MJXc-Node-23391" class="mjx-mi"><span class="mjx-char MJXc-TeX-math-I" style="padding-top: 0.477em; padding-bottom: 0.287em;">θ</span></span></span><span class="mjx-sub" style="font-size: 70.7%; vertical-align: -0.212em; padding-right: 0.071em;"><span id="MJXc-Node-23392" class="mjx-mn" style=""><span class="mjx-char MJXc-TeX-main-R" style="padding-top: 0.382em; padding-bottom: 0.382em;">0</span></span></span></span></span></span><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>θ</mi><mo>=</mo><msub><mi>θ</mi><mn>0</mn></msub></math></span></span>$\theta=\theta_0$ が信頼区間に含まれる確率</a></span></li><li><span><a href="#二項分布モデルでの視覚化" data-toc-modified-id="二項分布モデルでの視覚化-6.3"><span class="toc-item-num">6.3&nbsp;&nbsp;</span>二項分布モデルでの視覚化</a></span></li></ul></li><li><span><a href="#P値函数が「よい」かどうかの判断基準達" data-toc-modified-id="P値函数が「よい」かどうかの判断基準達-7"><span class="toc-item-num">7&nbsp;&nbsp;</span>P値函数が「よい」かどうかの判断基準達</a></span></li><li><span><a href="#Neyman-Pearsonの補題" data-toc-modified-id="Neyman-Pearsonの補題-8"><span class="toc-item-num">8&nbsp;&nbsp;</span>Neyman-Pearsonの補題</a></span></li><li><span><a href="#よくある誤解" data-toc-modified-id="よくある誤解-9"><span class="toc-item-num">9&nbsp;&nbsp;</span>よくある誤解</a></span></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using BenchmarkTools
using Distributions
using LinearAlgebra
using Printf
using QuadGK
using RCall # reauires installation of R language.
@rlibrary exactci # reauires the package exactci of R.
using Random
Random.seed!(4649373)
using Roots
using SpecialFunctions
using StaticArrays
using StatsBase
using StatsFuns
using StatsPlots
default(fmt = :png, size = (400, 250), titlefontsize = 10)
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

* 京都大学大学院医学研究科 聴講コース<br>臨床研究者のための生物統計学「仮説検定とP値の誤解」<br>佐藤 俊哉 医学研究科教授<br>[https://youtu.be/vz9cZnB1d1c](https://youtu.be/vz9cZnB1d1c)

信頼区間の解説は40分あたり以降にある.  多くの入門的な解説が抱えているP値, 検定, 信頼区間の解説の難点は以下の2つに要約される:

* 複雑な現実と統計モデルを混同させるような解説が伝統的に普通になってしまっていること.
* 検定と信頼区間の表裏一体性(双対性)が解説されていないこと.

このことが原因がP値も $95\%$ 信頼区間の $95\%$ も数学的フィクションである統計モデル内での確率であることがクリアに説明されておらず, そのせいでP値と $95\%$ 信頼区間の $95\%$ についてまっとうな理解が得られ難くなっている.  上で紹介した動画は教科書の説明がまずいことについて明瞭に言及しながら, 伝統的な入門的解説が抱えている問題を解消しようとしている.

__注意:__ 上の解説動画内で説明されている事柄を理解すれば, P値と検定と信頼区間について広まってしまった誤解を避けることができる.  そして, その後は個別の場合について詳しく勉強するだけの問題になるだろう.


## まとめ

以下のまとめは「理解が進むたびに何度もこのまとめに戻る」というような使い方をして欲しい.


### P値

__P値__ (P-value)は以下を与えることによって定義される:

* 現実世界におけるデータの数値 $x$ の生成のされ方に関するパラメータ $\theta$ を持つ統計モデル,
* 「データの数値以上に極端な」の意味の定義,
* さらに必要ならば近似計算法.

データの数値 $x$ とパラメータの値 $\theta=\theta_0$ が与えらえたとき, P値は

* データの数値 $x$ 以上に極端な値が条件 $\theta=\theta_0$ の下での統計モデル内で生じる確率もしくはその近似値

と定義される. このとき, 条件 $\theta=\theta_0$ は __帰無仮説__ (null hypothesis)と呼ばれることが多い. (「データの数値以上に極端な」の定義は __対立仮説__ (alternative hypothesis)の __集まり__ を与えることによって与えらえると考えられる.)

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

__注意:__ この節の内容はこのノートの内容を超えて先走っている.

実際には統計モデルは興味があるパラメータ $\theta$ 以外にパラメータ $\eta$ を含んでいることがある. (例えば平均パラメータ $\mu$ のみに興味があるときの正規分布 $\op{Normal}(\mu,\sigma)$ における標準偏差パラメータ $\sigma$.)

その場合にはパラメータ $\theta$ の値を決めても, 統計モデルの確率分布は唯一つに決まらず, パラメータ $\eta$ の分だけ不定になる.

P値の定義は「データの数値 $x$ 以上に極端な値が帰無仮説 $\theta=\theta_0$ の下での統計モデル内で生じる確率もしくはその近似値」であった.  帰無仮説 $\theta=\theta_0$ で統計モデルの確率分布が唯一つに決まらない場合にはこのP値の定義を単純に適用することが不可能になる.

このような状況のときに, 余計なパラメータ $\eta$ を __nuisanceパラメータ__ (ニューサンスパラメータ, 局外パラメータ,　撹乱パラメータ, 迷惑パラメータ)と呼ぶ(nuisanceは迷惑や妨害を意味する名詞). 

大抵の場合にnuisanceパラメータが存在しているという問題は, P値を使う統計分析の基礎付けが複雑になる主な原因の1つになっている.

nuisanceパラメータへの対処法には例えば以下がある:

* nuisanceパラメータを動かして上限(supremum)を考える.
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

このように統計モデルはパラメータ付きの確率分布として与えられる.


### P値の定義

データ $x$ の生成のされ方のモデル化になっているパラメータ $\theta$ を持つ統計モデルが与えられていると仮定する.

データの数値 $x$ とパラメータの数値 $\theta = \theta_0$ が与えられたとき, 

* データの数値 $x$ から定まる仮説 $\theta = \theta_0$ のP値

を次によって定める:

* データの数値 $x$ 以上に極端な値が仮説 $\theta=\theta_0$ 下の統計モデル内で生じる確率もしくはその近似値.

「仮説 $\theta=\theta_0$ 下の統計モデル内におけるデータの数値 $x$ 以上に極端な値」の定義は目的ごとに別に与えられる.  その概略については次の節を見よ.


### データの数値以上に極端な値の定義の仕方

P値の定義を確定させるためには, データの数値 $x$ とパラメータの数値 $\theta = \theta_0$ が与えられたとき, 統計モデルとそのパラメータ値が与える確率分布に従う確率変数 $X$ の値がデータの数値 $x_0$ 以上に極端な値であることに定義を目的に合わせて適切に設定する必要がある.

以下の条件が「仮説 $\theta=\theta_0$ の下での統計モデルに従う確率変数 $X$ がデータの数値 $x$ 以上に極端な値であること」の定義としてよく使われる:

(1) $X \ge x$ (または $X \le x$).

(1)' $X \ge x$ と $X \le x$ の確率が小さい方の条件.

(2) モデル内での $X$ の値が生じる確率(もしくはその密度)がデータの数値 $x$ 以下である.

$X$ が実数値の確率変数ではなく, $\R^n$ 値の確率変数の場合には, $X$ の実数値函数 $S(X|\theta_0)$ を用意して,

(3) $S(X|\theta_0) \ge S(x|\theta_0)$ (もしくは $S(X|\theta_0) \le S(x|\theta_0)$)

という条件で「仮説 $\theta=\theta_0$ の下での統計モデルに従う確率変数 $X$ がデータの数値 $x$ 以上に極端な値であること」を定義することが多い. 函数 $S(x|\theta_0)$ は __検定統計量__ と呼ばれ, 目的ごとに適切に選択する必要がある.

他にも正規分布近似を使う方法も多用される.


#### 例(二項分布モデル)の場合

データの数値「$n$ 回中 $k$ 回成功」と成功確率パラメータの数値 $p=p_0$ が与えられているとする.  さらに, 仮説 $p=p_0$ 下の二項分布 $\op{Binomial}(n, p_0)$ に従う確率変数 $K$ を用意する:

$$
K \sim \op{Binomial}(n, p_0).
$$

このとき, 「仮説 $p=p_0$ の下での二項分布モデル内での成功回数 $K$ の値がデータの数値 $k$ 以上に極端であること」を以下のように, 互いに同値でない様々な方法で定義できる:

(1) $K \ge k$ (もしくは $K\le k$)という条件で「$k$ 以上に極端」の意味を定義する. この定義は仮説 $p\le p_0$ (もしくは $p \ge p_0$)の __片側検定__ (one-tailed test, one-sided test) で使われる.

(1)' 仮説 $p=p_0$ の下での二項分布モデル内での $K\ge k$ と $K\le k$ の確率の小さい方の2倍(と $1$ の小さい方)を __両側検定__ のP値として使う(Clopper-Pearsonの信頼区間の場合).  以下の定義はどれも両側検定の場合になっている. __検定は通常両側検定を使用する.__

(2) $K$ の値がモデル内で生じる確率がデータの数値 $k$ がモデル内で生じる確率以下になる(二項分布の確率質量函数を $P(k|n,p_0)$ と書くときの $P(K|n,p_0)\le P(k|n,p_0)$)という条件で「$k$ 以上に極端」の意味を定義する(Sterneの信頼区間の場合).

この他にも正規分布近似(中心極限定理)を使って定義することもできる.

(3) 二項分布 $\op{Binomial}(m, p_0)$ に関する中心極限定理によれば, $(K - np_0)/\sqrt{np_0(1-p_0)}$ は $np$ と $n(1-p)$ が十分に大きければ近似的に標準正規分布に従う.  「標準正規分布 $\op{Normal}(0, 1)$ に従う確率変数 $Z$ の値がデータの数値以上に極端であること」を

$$
|Z| \ge \frac{|k - np_0|}{\sqrt{np_0(1-p_0)}}
$$

という条件で定め, こうなる確率を標準正規分布を使って計算してP値とする(近似の一種, Wilsonの信頼区間の場合).

(3)' 上と同値な次の条件を使うこともある:

$$
Z^2 \ge
\frac{(k - np_0)^2}{np_0(1-p_0)}.
$$

$Z\sim\op{Normal}(0,1)$ のとき, $Z^2$ は自由度 $1$ のχ²分布に従うので, こうなる確率を自由度 $1$ のχ²分布を用いて計算してP値とする(これも近似の一種).  さらに上の条件は次とも同値である(Pearsonのχ²検定の場合):

$$
Z^2 \ge
\frac{(k - np_0)^2}{np_0} + \frac{((n-k) - n(1-p_0))^2}{n(1-p_0)}.
$$

これの不等式の右辺を __Pearsonのχ²統計量__ と呼ぶ.  これはそのように呼ばれる検定統計量達

$$
\chi^2 = \sum \frac{(\text{観測値} - \text{期待値})^2}{\text{期待値}}
$$

の特別な場合に過ぎない.

(4) 上の(3)における右辺の分母の $p_0$ をパラメータの推定量 $\hat{p} = k/n$ で置き換えて得られる次の条件で「データの数値以上に極端であること」を定義することもある(Waldの信頼区間の場合):

$$
|Z| \ge
\frac{|k - np_0|}{\sqrt{n\hat{p}(1-\hat{p})}}.
$$

以上のように, 二項分布モデルのP値の定義の仕方も沢山ある.  基本的にどれを使ってもよい.  ユーザー側は自分の目的に合わせて合理的だと考えられるものを自由に使えばよい.


#### 例(正規分布の標本分布モデル)の場合

__注意:__ この節の内容は別のノートで詳しく説明する. この段階では以下で説明する複雑な式を覚える必要はない.

データの数値 $x_0 = \left(x^{(0)}_1,\ldots,x_n^{(0)}\right) \in \R^n$ と興味があるパラメータの数値 $\mu=\mu_0$ が与えられているとする. このとき, 「仮説 $\mu = \mu_0$ の下での正規分布の標本分布モデル内での $x\in\R^n$ の値がデータの数値 $x_0$ 以上に極端であること」を以下の方法で定義すると便利であることが知られている.

まず, $T$ 統計量 $T(x|\mu)$ を次のように定める:

$$
T(x|\mu) = \frac{\bar{x} - \mu}{\sqrt{s^2/n}}, \quad
\bar{x} = \frac{1}{n}\sum_{i=1}^n x_i, \quad
s^2 = \frac{1}{n-1}\sum_{i=1}^n \left(x_i - \bar{x}\right)^2.
$$

そして, 「仮説 $\mu = \mu_0$ の下で, $x$ の値がデータの数値 $x_0$ 以上に極端であること」を

$$
\left|T(x|\mu_0)\right| \ge \left|T(x_0|\mu_0)\right| 
$$

という条件で定める. これは大雑把に言って,

* $x$ が $(\mu_0,\ldots,\mu_0)$ からデータの数値 $x_0$ 以上に離れている.

という意味の条件になっている.

これが便利なのは, 仮説 $\mu = \mu_0$ の下での正規分布の標本分布モデル内で $T(x|\mu_0)$ に対応する確率変数が自由度 $n-1$ の $t$ 分布に従うからである.


### P値は帰無仮説下の統計モデルのデータの数値との整合性の指標

データの数値 $x$ から計算される帰無仮説 $\theta = \theta_0$ のP値は, 仮説 $\theta=\theta_0$ 下の統計モデルとデータの数値 $x$ の整合性の指標である.

P値が小さいことは, 仮説 $\theta=\theta_0$ 下の統計モデルとデータの数値 $x$ があまり整合していないと考える.


## P値を使った検定

データ $x$ の生成のされ方のモデル化になっているパラメータ $\theta$ を持つ統計モデルが与えられていると仮定する.

さらに有意水準と呼ばれる __閾値__(いきち, しきいち) $0 < \alpha < 1$ が与えられていると仮定する.  $\alpha$ は目的に合わせて適当に小さな値としておく.  (有意水準として $5\%$ がよく用いられているが, そのことに科学的な合理性はない.)

データの数値 $x$ とパラメータの数値 $\theta=\theta_0$ が与えられているとき, 仮説 $\theta = \theta_0$ のP値を求め,  P値が $\alpha$ 未満になるとき, 仮説 $\theta = \theta_0$ 下の統計モデルは __棄却__ (reject)されたという.

この手続きを __仮説検定__ (Hypothesis tesitng)もしくは単に __検定__ と呼ぶ.

すなわち, 検定とは, ある閾値を設けて, その閾値以上に整合性がないモデルのパラメータ値を捨て去る手続きのことである.

ただし, 閾値を設けて捨て去る行為なので間違う危険性がある.  有意水準が小さなほどそのリスクは小さくなるが, その分だけ, 科学的に興味深い結果を見逃してしまうリスクが増える.


## P値函数を使った信頼区間

有意水準 $\alpha$ の検定の手続きをパラメータ $\theta$ のすべての値に適用したとき, 棄却されなかったパラメータ値全体の集合をパラメータ $\theta$ に関する __信頼度__ (信頼係数) $1-\alpha$ の __信頼区間__ (confidence interval)と呼ぶ. ($\alpha = 5\%$ のとき, 信頼度 $1-\alpha$ の信頼区間を $95\%$ 信頼区間と呼ぶことが多い.)

有意水準 $\alpha$ の検定の手続きでパラメータの値 $\theta=\theta_0$ が棄却されることは, 仮説 $\theta=\theta_0$ 下の統計モデルのデータの値 $x$ との整合性(P値)が閾値 $\alpha$ 未満になることであった.  そのような状況を

* 仮説 $\theta=\theta_0$ 下の統計モデルとデータの値 $x$ との整合性が無さすぎる

と言うことにしよう.  このスタイルの下では, 信頼区間は

* 統計モデルの下で, データの数値 $x$ との整合性が無さすぎないパラメータ値全体の集合

であると言える.

「整合性が無さすぎること」は「正しいこと」を意味しないし, 「正しい可能性が高いこと」も意味しない.  信頼区間に含まれるパラメータ値の下での統計モデルの妥当性については判断を保留しなければいけない.

__例:__ 例えば, パラメータ $\theta$ がある治療法の治療効果を意味するパラメータであったとしよう.  そのとき, 現実世界における調査で得たデータの数値 $x$ に関する $\theta$ の信頼区間は

* その区間に含まれる治療効果の数値の各々については現実の正しさについては判断を保留する.
* その区間のどれかの値が真の治療効果であっても大丈夫なようにしておく.
* 得られたデータの数値へのその統計モデルの使用が妥当でない可能性についても常に注意を払う.

のような使い方をすることが妥当だと思われる.


## 信頼区間と検定の表裏一体性


### 検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合

データ $x$ の生成のされ方のモデル化になっているパラメータ $\theta$ を持つ統計モデルが設定されていると仮定し, データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値 $\op{pvalue}(x|\theta_0)$ が定義されていると仮定し, 有意水準 $\alpha$ が与えられているとする.

データの数値 $x$ が与えらえたとき, パラメータの数値 $\theta=\theta_0$ をP値 $\op{pvalue}(x|\theta_0)$ に対応させる函数

$$
\theta_0 \mapsto \op{pvalue}(x|theta_0)
$$

を __P値函数__ (P-value function)と呼ぶ.  P値函数は無数の仮説 $\theta=\theta_0$ 達の検定結果の情報をすべて持っているので, 信頼区間の情報もそこに含まれる.

このとき, 仮説 $\theta=\theta_0$ を有意水準 $\alpha$ で棄却するようなデータの数値全体の集合を __棄却領域__ (rejection region)と呼び, 次のように書くことにする:

$$
R_\alpha(\theta_0) =
\{\, x \mid \op{pvalue}(x|\theta_0) < \alpha\,\}.
$$

信頼度 $1-\alpha$ の信頼区間 $C_\alpha(x)$ は

$$
C_\alpha(x) =
\{\, \theta_0 \mid \op{pvalue}(x|\theta_0) \ge \alpha\,\}
$$

と書ける.  これらの関係は以下の図のようになっている.

以下の図を見れば, すべてのデータの数値 $x$ について信頼区間 $C_\alpha(x)$ を与えることと, すべてのパラメータの数値 $\theta=\theta_0$ についての棄却領域 $R_\alpha(\theta_0)$ を与えることが同じであることがわかる.  そして, 図中の赤の領域と青の領域の境界上でのP値 $\op{pvalue}(x|\theta_0)$ の値が有意水準 $\alpha$ になる.


![HypothesisTesting-ConfidenceInterval.jpg](attachment:HypothesisTesting-ConfidenceInterval.jpg)


### 仮説 $\theta=\theta_0$ 下の統計モデル内でパラメータ値 $\theta=\theta_0$ が信頼区間に含まれる確率

$(x, \theta_0)$ がこの図中の(信頼区間を含む)青の領域の点であることは, 仮説 $\theta = \theta_0$ がデータの数値 $x$ によって棄却されないことと同値であり, さらに, データの数値 $x$ から決まる信頼区間にパラメータ値 $\theta = \theta_0$ が含まれることとも同値である.

$X$ がパラメータ値 $\theta=\theta_0$ の統計モデルに従う確率変数であると仮定する. $X$ は仮説 $\theta=\theta_0$ 下の統計モデル内で生成された仮想的なデータの数値だと考えられる.

P値の定義より $\op{pvalue}(X|\theta_0) < \alpha$ となる確率は $\alpha$ もしくはその近似になるので,  $\op{pvalue}(X|\theta_0) \ge \alpha$ となる確率は $1-\alpha$ もしくはその近似値になる.

そして, $\op{pvalue}(X|\theta_0) \ge \alpha$ という条件は仮説 $\theta=\theta_0$ 下の統計モデル内で生成されたデータの値 $X$ から決まる信頼度 $1-\alpha$ の信頼区間に $\theta_0$ が含まれることと同値である.

ゆえに, 仮説 $\theta=\theta_0$ 下の統計モデル内で生成されたデータの値 $X$ から決まる信頼度 $1-\alpha$ の信頼区間にパラメータ値 $\theta=\theta_0$ が含まれる確率は $1-\alpha$ またはその近似値になる.

例えば, 大雑把に言うと, $95\%$ 信頼区間に統計モデル内でデータを生成したパラメータ値が含まれる確率は $95\%$ またはその近似値になる.

__注意:__ この事実はP値の定義より, $95\%$ 信頼区間の $95\%$ が確率とみなされることを意味している.  ただし, その確率は数学的フィクションである __統計モデル内で測った確率__ に過ぎない.  何らかの特別な理由があって, 現実のデータの数値 $x$ の生成のされ方を統計モデルが忠実に再現していると考えられるならば, $95\%$ という数値は現実においても意味を持ち得る.  しかし, そうでない場合いは, 単なる __モデル内確率__ であることに十分な注意を払う必要がある.

__注意:__ 「$95\%$ 信頼区間の $95\%$ は確率ではなく, 割合である」というようなことが多くの教科書に書かれているようだが, 以上の説明を読めば分かるように自明に誤りである.

__注意:__ 「$95\%$ 信頼区間の $95\%$ は確率ではなく, 割合である」と言いたい人達は, データの数値 $x$ はすでに確定した数値になっており, 確率的に揺らがないので, データの数値 $x$ から計算される信頼区間も確率的に揺らがないので, パラメータ値 $\theta=\theta_0$ が信頼区間に含まれる確率を考えることはできない, というようなことを言いたいのかもしれないが, 上の説明を読めば分かるように的を外している.  $95\%$ 信頼区間の $95\%$ は数学的フィクションであるモデル内確率であり, モデル内で生成されたデータの数値は確率変数になっている.  現実とモデルを混同するという典型的に非科学的な考え方に陥っている疑いもある.

__文献:__ P値函数の使い方については次の文献が詳しい:

* Timothy L. Lash, Tyler J. VanderWeele, Sebastien Haneuse, and Kenneth J. Rothman.<br>Modern Epidemiology, 4th edition, 2020. [Google](https://www.google.com/search?q=Modern+Epidemiology+4th)

第4版よりも古い版でもよい.


### 二項分布モデルでの視覚化

```julia
# Clopper-Pearson

function pvalue_clopper_pearson(n, k, p)
    bin = Binomial(n, p)
    min(1, 2cdf(bin, k), 2ccdf(bin, k-1))
end

# Sterne

_pdf_le(x, (dist, y)) =  pdf(dist, x) ⪅ y

function _search_boundary(f, x0, Δx, param; maxiters=10^7)
    x = x0
    if f(x, param)
        for _ in 1:maxiters
            !f(x - Δx, param) && return x
            x -= Δx
        end
    else # if !f(x, param)
        for _ in 1:maxiters
            x += Δx
            f(x, param) && return x
        end
    end
    error("""
    _search_boundary($f, $x0, $Δx, param = $param; maxiters = $maxiters) \
    has exceeded the maximum number of iterations.""")
end

function pvalue_sterne(dist::DiscreteUnivariateDistribution, x)
    Px = pdf(dist, x)
    0 < Px < 1 || return Px
    m = mode(dist)
    Px ≈ pdf(dist, m) && return one(Px)
    if x < m
        y = _search_boundary(_pdf_le, 2m - x, 1, (dist, Px))
        cdf(dist, x) + ccdf(dist, y-1)
    else # x > m
        y = _search_boundary(_pdf_le, 2m - x, -1, (dist, Px))
        cdf(dist, y) + ccdf(dist, x-1)
    end
end

pvalue_sterne(n, k, p) = pvalue_sterne(Binomial(n, p), k)

# Wilson

function pvalue_wilson(n, k, p)
    z = safediv(k - n*p, √(n*p*(1-p)))
    2ccdf(Normal(), abs(z))
end

# Wald

function pvalue_wald(n, k, p)
    z = safediv(k - n*p, √(k*(n-k)/n))
    2ccdf(Normal(), abs(z))
end
```

```julia
# P値函数 (データ k を固定した場合)

n, k = 20, 6

P1 = plot(p -> pvalue_clopper_pearson(n, k, p), 0, 1; label="Clopper-Pearson", c=1)
P2 = plot(p -> pvalue_sterne(n, k, p), 0, 1; label="Sterne", c=2)
P3 = plot(p -> pvalue_wilson(n, k, p), 0, 1; label="Wilson", c=3)
P4 = plot(p -> pvalue_wald(n, k, p), 0, 1; label="Wald", ls=:dash, c=4)
plot(P1, P2, P3, P4; size=(800, 500), layout=(2, 2))
plot!(; xtick=0:0.1:1, ytick=0:0.1:1)
plot!(; xguide="success rate parameter p", yguide="P-value", guidefontsize=10)
title!("n = $n, k = $k", titlefontsize=12)
```

以上は「$n=20$ 回中 $k=6$ 回成功」というデータの数値が与えられたときの, P値函数のグラフである.

P値が小さいほどデータの数値と成功確率パラメータ値が $p$ の二項分布モデルのあいだに整合性がないと考える.

上のグラフを見れば, P値函数による判定では, 「$n=20$ 回中 $k=6$ 回成功」というデータの数値に最も整合するパラメータ $p$ の値は $p = 6/20 = 0.3$ になっており, そこから離れると整合性が下がる.

どの場合も,「$n=20$ 回中 $k=6$ 回成功」というデータの数値にあまりにも整合しないパラメータ $p$ の値全体の集合の補集合は大雑把に $0.1$ から $0.6$ までの区間になることもわかる.  これが信頼区間である. ただし, 有意水準を決めずにグラフの見た目で判断してどんぶり勘定で区間を決めた.  信頼区間の正式な定義はP値が有意水準という名の閾値 $\alpha$ 以上になるパラメータの範囲である. 

信頼区間では「そこに含まれるか否か」($\alpha$ 以上か否か)の情報しか残っていないが, P値函数の様子を直接見れば, パラメータを動かしたときの統計モデルとデータの数値の整合性の度合いについても知ることができる.

__注意:__ 有意水準として $\alpha=5\%$ がよく使われているが, そのことに科学的合理性はない. だから閾値 $\alpha=5\%$ で計算した信頼区間を見て一喜一憂するのはバカげている. そのようにバカげたことをするくらいならば, 閾値を決めずにP値函数の様子を直接眺めてどんぶり勘定で判断した方がましだと思われる.


__注意:__ R言語では exactci パッケージを入れると,
Clopper-Pearsonの信頼区間を与えるP値函数(`tsmethod = "central"`)と
Sterneの信頼区間を与えるP値函数(`tsmethod = "minlik"`)を容易にプロットできる.

* https://rdrr.io/cran/exactci/man/binom.exact.html

のExamplesに適当に `, plot=TRUE` を挿入してRunボタンを押してみよ.

```julia
binom_exact(6, 20; tsmethod = "central", plot = true)
```

```julia
binom_exact(6, 20; tsmethod = "minlik", plot = true)
```

```julia
# P値函数 (データ k を動かしてアニメ化)
# PDFファイルではこの動画を見ることはできない.
# 

n = 20
anim = @animate for k in [0:n; n-1:-1:1]
    plot(p -> pvalue_clopper_pearson(n, k, p), 0, 1; label="Clopper-Pearson")
    plot!(p -> pvalue_sterne(n, k, p), 0, 1; label="Sterne")
    plot!(p -> pvalue_wilson(n, k, p), 0, 1; label="Wilson")
    plot!(p -> pvalue_wald(n, k, p), 0, 1; label="Wald", ls=:dash)
    plot!(; xtick=0:0.1:1, ytick=0:0.1:1)
    plot!(; xguide="success rate parameter p", yguide="P-value")
    title!("n = $n, k = $k")
    plot!(; size=(600, 300))
    2k > n && plot!(; legend=:topleft)
end

gif(anim, "images/pvaluefunction.gif"; fps = 5)
```

```julia
# pvalue(x|p) 達のヒートマップ

n = 20
k = 0:n
p = 0:0.01:1

P1 = heatmap(k, p, (k, p)->pvalue_clopper_pearson(n, k, p);
    colorbar=false, title="Clopper-Pearson, n=$n")
P2 = heatmap(k, p, (k, p)->pvalue_sterne(n, k, p);
    colorbar=false, title="Sterne, n=$n")
P3 = heatmap(k, p, (k, p)->pvalue_wilson(n, k, p);
    colorbar=false, title="Wilson, n=$n")
P4 = heatmap(k, p, (k, p)->pvalue_wald(n, k, p);
    colorbar=false, title="Wald, n=$n")
plot(P1, P2, P3, P4; size=(800, 800), layout=(2, 2),
    xtick=0:20, ytick=0:0.1:1, tickfontsize=7,
    xguide="k", yguide="p")
```

明るい部分ほどP値が大きい.  P値が小さな部分はほぼ黒色になっている.  そこでは「$n$ 回中 $k$ 回成功」というデータの数値に成功回数パラメータ値が $p$ の二項分布モデルが整合していないと考える.

例えば「$n=20$ 回中 $k=6$ 回成功」というデータの数値が得られたとき $k=6$ でのP値函数の「明るさ」を上のグラフで確認すると, $p=6/20=0.6$ で最も明るくなっており, そこから $p$ が離れると暗くなって行くことがわかる. P値による判定によれば, 「$n=20$ 回中 $k=6$ 回成功」というデータの数値に最も整合する二項分布モデルの成功確率パラメータ $p$ の値は $p=0.3$ であり, そこから $p$ が離れるにつれて整合性は下がって行く.

```julia
# pvalue(x|p) ≥ α のヒートマップ

α = 0.05
n = 20
k = 0:n
p = 0:0.01:1

c = cgrad([colorant"red", colorant"blue"])
alpha = 0.5
P1 = heatmap(k, p, (k, p)->pvalue_clopper_pearson(n, k, p) ≥ α;
    colorbar=false, title="Clopper-Pearson, α=$α", c, alpha)
P2 = heatmap(k, p, (k, p)->pvalue_sterne(n, k, p) ≥ α;
    colorbar=false, title="Sterne, α=$α", c, alpha)
P3 = heatmap(k, p, (k, p)->pvalue_wilson(n, k, p) ≥ α;
    colorbar=false, title="Wilson, α=$α", c, alpha)
P4 = heatmap(k, p, (k, p)->pvalue_wald(n, k, p) ≥ α;
    colorbar=false, title="Wald, α=$α", c, alpha)
plot(P1, P2, P3, P4; size=(800, 800), layout=(2, 2),
    xtick=0:20, ytick=0:0.1:1, tickfontsize=7,
    xguide="k", yguide="p")
```

薄い赤の領域はP値が $\alpha = 5\%$ 未満になる部分であり, 薄い青の領域はP値が $\alpha = 5\%$ 以上になる部分である.  P値の定義の仕方によって結果は異なるが概ね似たような様子になっている.


## P値函数が「よい」かどうかの判断基準達


## Neyman-Pearsonの補題


## よくある誤解

```julia

```
