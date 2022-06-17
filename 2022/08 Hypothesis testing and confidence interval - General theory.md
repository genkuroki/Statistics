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
* 2022-05-31～2022-06-05

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
<div class="toc"><ul class="toc-item"><li><span><a href="#お勧め解説動画とお勧め文献" data-toc-modified-id="お勧め解説動画とお勧め文献-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>お勧め解説動画とお勧め文献</a></span><ul class="toc-item"><li><span><a href="#お勧め解説動画" data-toc-modified-id="お勧め解説動画-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>お勧め解説動画</a></span></li><li><span><a href="#お勧め文献:-P値に関するASA声明" data-toc-modified-id="お勧め文献:-P値に関するASA声明-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>お勧め文献: P値に関するASA声明</a></span></li></ul></li><li><span><a href="#まとめ" data-toc-modified-id="まとめ-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>まとめ</a></span><ul class="toc-item"><li><span><a href="#P値" data-toc-modified-id="P値-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>P値</a></span></li><li><span><a href="#検定" data-toc-modified-id="検定-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>検定</a></span></li><li><span><a href="#信頼区間" data-toc-modified-id="信頼区間-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>信頼区間</a></span></li><li><span><a href="#nuisanceパラメータがある場合" data-toc-modified-id="nuisanceパラメータがある場合-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>nuisanceパラメータがある場合</a></span></li></ul></li><li><span><a href="#P値の定義" data-toc-modified-id="P値の定義-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>P値の定義</a></span><ul class="toc-item"><li><span><a href="#統計モデルの設定" data-toc-modified-id="統計モデルの設定-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>統計モデルの設定</a></span></li><li><span><a href="#P値の定義" data-toc-modified-id="P値の定義-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>P値の定義</a></span></li><li><span><a href="#「データの数値以上に極端な値」の意味の定義の仕方" data-toc-modified-id="「データの数値以上に極端な値」の意味の定義の仕方-3.3"><span class="toc-item-num">3.3&nbsp;&nbsp;</span>「データの数値以上に極端な値」の意味の定義の仕方</a></span></li><li><span><a href="#例(二項分布モデルの場合)" data-toc-modified-id="例(二項分布モデルの場合)-3.4"><span class="toc-item-num">3.4&nbsp;&nbsp;</span>例(二項分布モデルの場合)</a></span></li><li><span><a href="#例(正規分布の標本分布モデルの場合)" data-toc-modified-id="例(正規分布の標本分布モデルの場合)-3.5"><span class="toc-item-num">3.5&nbsp;&nbsp;</span>例(正規分布の標本分布モデルの場合)</a></span></li><li><span><a href="#P値は帰無仮説下の統計モデルのデータの数値との整合性の指標" data-toc-modified-id="P値は帰無仮説下の統計モデルのデータの数値との整合性の指標-3.6"><span class="toc-item-num">3.6&nbsp;&nbsp;</span>P値は帰無仮説下の統計モデルのデータの数値との整合性の指標</a></span></li></ul></li><li><span><a href="#検定" data-toc-modified-id="検定-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>検定</a></span></li><li><span><a href="#第一種の過誤(αエラー)" data-toc-modified-id="第一種の過誤(αエラー)-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>第一種の過誤(αエラー)</a></span><ul class="toc-item"><li><span><a href="#第一種の過誤(αエラー)の定義" data-toc-modified-id="第一種の過誤(αエラー)の定義-5.1"><span class="toc-item-num">5.1&nbsp;&nbsp;</span>第一種の過誤(αエラー)の定義</a></span></li><li><span><a href="#第一種の過誤(αエラー)の確率" data-toc-modified-id="第一種の過誤(αエラー)の確率-5.2"><span class="toc-item-num">5.2&nbsp;&nbsp;</span>第一種の過誤(αエラー)の確率</a></span></li><li><span><a href="#二項分布モデルの4種のP値に関する第一種の過誤の確率のグラフ" data-toc-modified-id="二項分布モデルの4種のP値に関する第一種の過誤の確率のグラフ-5.3"><span class="toc-item-num">5.3&nbsp;&nbsp;</span>二項分布モデルの4種のP値に関する第一種の過誤の確率のグラフ</a></span></li></ul></li><li><span><a href="#信頼区間" data-toc-modified-id="信頼区間-6"><span class="toc-item-num">6&nbsp;&nbsp;</span>信頼区間</a></span><ul class="toc-item"><li><span><a href="#信頼区間のP値もしくは検定を用いた定義" data-toc-modified-id="信頼区間のP値もしくは検定を用いた定義-6.1"><span class="toc-item-num">6.1&nbsp;&nbsp;</span>信頼区間のP値もしくは検定を用いた定義</a></span></li><li><span><a href="#信頼区間の使い方" data-toc-modified-id="信頼区間の使い方-6.2"><span class="toc-item-num">6.2&nbsp;&nbsp;</span>信頼区間の使い方</a></span></li></ul></li><li><span><a href="#信頼区間と検定の表裏一体性" data-toc-modified-id="信頼区間と検定の表裏一体性-7"><span class="toc-item-num">7&nbsp;&nbsp;</span>信頼区間と検定の表裏一体性</a></span><ul class="toc-item"><li><span><a href="#検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合" data-toc-modified-id="検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合-7.1"><span class="toc-item-num">7.1&nbsp;&nbsp;</span>検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合</a></span></li><li><span><a href="#信頼区間と検定の表裏一体性について書かれた教科書の例" data-toc-modified-id="信頼区間と検定の表裏一体性について書かれた教科書の例-7.2"><span class="toc-item-num">7.2&nbsp;&nbsp;</span>信頼区間と検定の表裏一体性について書かれた教科書の例</a></span></li><li><span><a href="#仮説-$\theta=\theta_0$-下の統計モデル内でパラメータ値-$\theta=\theta_0$-が信頼区間に含まれる確率" data-toc-modified-id="仮説-$\theta=\theta_0$-下の統計モデル内でパラメータ値-$\theta=\theta_0$-が信頼区間に含まれる確率-7.3"><span class="toc-item-num">7.3&nbsp;&nbsp;</span>仮説 <span id="MathJax-Element-290-Frame" class="mjx-chtml MathJax_CHTML" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>&amp;#x03B8;</mi><mo>=</mo><msub><mi>&amp;#x03B8;</mi><mn>0</mn></msub></math>" role="presentation" style="font-size: 117%; position: relative;"><span id="MJXc-Node-2115" class="mjx-math" aria-hidden="true"><span id="MJXc-Node-2116" class="mjx-mrow"><span id="MJXc-Node-2117" class="mjx-mi"><span class="mjx-char MJXc-TeX-math-I" style="padding-top: 0.477em; padding-bottom: 0.287em;">θ</span></span><span id="MJXc-Node-2118" class="mjx-mo MJXc-space3"><span class="mjx-char MJXc-TeX-main-R" style="padding-top: 0.097em; padding-bottom: 0.335em;">=</span></span><span id="MJXc-Node-2119" class="mjx-msubsup MJXc-space3"><span class="mjx-base"><span id="MJXc-Node-2120" class="mjx-mi"><span class="mjx-char MJXc-TeX-math-I" style="padding-top: 0.477em; padding-bottom: 0.287em;">θ</span></span></span><span class="mjx-sub" style="font-size: 70.7%; vertical-align: -0.212em; padding-right: 0.071em;"><span id="MJXc-Node-2121" class="mjx-mn" style=""><span class="mjx-char MJXc-TeX-main-R" style="padding-top: 0.382em; padding-bottom: 0.382em;">0</span></span></span></span></span></span><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>θ</mi><mo>=</mo><msub><mi>θ</mi><mn>0</mn></msub></math></span></span>$\theta=\theta_0$ 下の統計モデル内でパラメータ値 <span id="MathJax-Element-291-Frame" class="mjx-chtml MathJax_CHTML" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>&amp;#x03B8;</mi><mo>=</mo><msub><mi>&amp;#x03B8;</mi><mn>0</mn></msub></math>" role="presentation" style="font-size: 117%; position: relative;"><span id="MJXc-Node-2122" class="mjx-math" aria-hidden="true"><span id="MJXc-Node-2123" class="mjx-mrow"><span id="MJXc-Node-2124" class="mjx-mi"><span class="mjx-char MJXc-TeX-math-I" style="padding-top: 0.477em; padding-bottom: 0.287em;">θ</span></span><span id="MJXc-Node-2125" class="mjx-mo MJXc-space3"><span class="mjx-char MJXc-TeX-main-R" style="padding-top: 0.097em; padding-bottom: 0.335em;">=</span></span><span id="MJXc-Node-2126" class="mjx-msubsup MJXc-space3"><span class="mjx-base"><span id="MJXc-Node-2127" class="mjx-mi"><span class="mjx-char MJXc-TeX-math-I" style="padding-top: 0.477em; padding-bottom: 0.287em;">θ</span></span></span><span class="mjx-sub" style="font-size: 70.7%; vertical-align: -0.212em; padding-right: 0.071em;"><span id="MJXc-Node-2128" class="mjx-mn" style=""><span class="mjx-char MJXc-TeX-main-R" style="padding-top: 0.382em; padding-bottom: 0.382em;">0</span></span></span></span></span></span><span class="MJX_Assistive_MathML" role="presentation"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>θ</mi><mo>=</mo><msub><mi>θ</mi><mn>0</mn></msub></math></span></span>$\theta=\theta_0$ が信頼区間に含まれる確率</a></span></li><li><span><a href="#二項分布モデルでのP値函数の視覚化" data-toc-modified-id="二項分布モデルでのP値函数の視覚化-7.4"><span class="toc-item-num">7.4&nbsp;&nbsp;</span>二項分布モデルでのP値函数の視覚化</a></span></li></ul></li><li><span><a href="#統計モデルやP値函数が「よい」かどうかの判断基準達" data-toc-modified-id="統計モデルやP値函数が「よい」かどうかの判断基準達-8"><span class="toc-item-num">8&nbsp;&nbsp;</span>統計モデルやP値函数が「よい」かどうかの判断基準達</a></span><ul class="toc-item"><li><span><a href="#計算方法はシンプルな方がよい" data-toc-modified-id="計算方法はシンプルな方がよい-8.1"><span class="toc-item-num">8.1&nbsp;&nbsp;</span>計算方法はシンプルな方がよい</a></span></li><li><span><a href="#頑健な方がよい" data-toc-modified-id="頑健な方がよい-8.2"><span class="toc-item-num">8.2&nbsp;&nbsp;</span>頑健な方がよい</a></span></li><li><span><a href="#第一種の過誤の確率は有意水準に近い方がよい" data-toc-modified-id="第一種の過誤の確率は有意水準に近い方がよい-8.3"><span class="toc-item-num">8.3&nbsp;&nbsp;</span>第一種の過誤の確率は有意水準に近い方がよい</a></span></li><li><span><a href="#第一種の過誤の確率は有意水準以下である方がよい" data-toc-modified-id="第一種の過誤の確率は有意水準以下である方がよい-8.4"><span class="toc-item-num">8.4&nbsp;&nbsp;</span>第一種の過誤の確率は有意水準以下である方がよい</a></span></li><li><span><a href="#検出力は高い方がよい" data-toc-modified-id="検出力は高い方がよい-8.5"><span class="toc-item-num">8.5&nbsp;&nbsp;</span>検出力は高い方がよい</a></span></li></ul></li><li><span><a href="#Neyman-Pearsonの仮説検定" data-toc-modified-id="Neyman-Pearsonの仮説検定-9"><span class="toc-item-num">9&nbsp;&nbsp;</span>Neyman-Pearsonの仮説検定</a></span><ul class="toc-item"><li><span><a href="#パラメータを持たない2つの統計モデルに関する仮説検定" data-toc-modified-id="パラメータを持たない2つの統計モデルに関する仮説検定-9.1"><span class="toc-item-num">9.1&nbsp;&nbsp;</span>パラメータを持たない2つの統計モデルに関する仮説検定</a></span></li><li><span><a href="#Neyman-Pearsonの補題" data-toc-modified-id="Neyman-Pearsonの補題-9.2"><span class="toc-item-num">9.2&nbsp;&nbsp;</span>Neyman-Pearsonの補題</a></span></li><li><span><a href="#Neyman-Pearsonの補題の証明" data-toc-modified-id="Neyman-Pearsonの補題の証明-9.3"><span class="toc-item-num">9.3&nbsp;&nbsp;</span>Neyman-Pearsonの補題の証明</a></span></li><li><span><a href="#尤度比検定の例:-正規分布モデルの場合" data-toc-modified-id="尤度比検定の例:-正規分布モデルの場合-9.4"><span class="toc-item-num">9.4&nbsp;&nbsp;</span>尤度比検定の例: 正規分布モデルの場合</a></span></li><li><span><a href="#Neyman-Pearsonの仮説検定に関する極端な解釈の普及の問題" data-toc-modified-id="Neyman-Pearsonの仮説検定に関する極端な解釈の普及の問題-9.5"><span class="toc-item-num">9.5&nbsp;&nbsp;</span>Neyman-Pearsonの仮説検定に関する極端な解釈の普及の問題</a></span></li><li><span><a href="#このノートの立場" data-toc-modified-id="このノートの立場-9.6"><span class="toc-item-num">9.6&nbsp;&nbsp;</span>このノートの立場</a></span></li></ul></li><li><span><a href="#よくある誤解" data-toc-modified-id="よくある誤解-10"><span class="toc-item-num">10&nbsp;&nbsp;</span>よくある誤解</a></span><ul class="toc-item"><li><span><a href="#P値の定義と使い方の復習" data-toc-modified-id="P値の定義と使い方の復習-10.1"><span class="toc-item-num">10.1&nbsp;&nbsp;</span>P値の定義と使い方の復習</a></span></li><li><span><a href="#問題:-P値に関するよくある誤解" data-toc-modified-id="問題:-P値に関するよくある誤解-10.2"><span class="toc-item-num">10.2&nbsp;&nbsp;</span>問題: P値に関するよくある誤解</a></span></li><li><span><a href="#信頼区間の定義の復習と使い方の復習" data-toc-modified-id="信頼区間の定義の復習と使い方の復習-10.3"><span class="toc-item-num">10.3&nbsp;&nbsp;</span>信頼区間の定義の復習と使い方の復習</a></span></li><li><span><a href="#問題:-信頼区間に関するよく見る誤解" data-toc-modified-id="問題:-信頼区間に関するよく見る誤解-10.4"><span class="toc-item-num">10.4&nbsp;&nbsp;</span>問題: 信頼区間に関するよく見る誤解</a></span></li><li><span><a href="#平均の信頼区間達の視覚化" data-toc-modified-id="平均の信頼区間達の視覚化-10.5"><span class="toc-item-num">10.5&nbsp;&nbsp;</span>平均の信頼区間達の視覚化</a></span><ul class="toc-item"><li><span><a href="#正規分布の標本達から得られる平均の信頼区間達" data-toc-modified-id="正規分布の標本達から得られる平均の信頼区間達-10.5.1"><span class="toc-item-num">10.5.1&nbsp;&nbsp;</span>正規分布の標本達から得られる平均の信頼区間達</a></span></li><li><span><a href="#ガンマ分布の標本から得られる平均の信頼区間達" data-toc-modified-id="ガンマ分布の標本から得られる平均の信頼区間達-10.5.2"><span class="toc-item-num">10.5.2&nbsp;&nbsp;</span>ガンマ分布の標本から得られる平均の信頼区間達</a></span></li><li><span><a href="#対数正規分布の標本達から得られる平均の信頼区間達" data-toc-modified-id="対数正規分布の標本達から得られる平均の信頼区間達-10.5.3"><span class="toc-item-num">10.5.3&nbsp;&nbsp;</span>対数正規分布の標本達から得られる平均の信頼区間達</a></span></li></ul></li><li><span><a href="#問題解答例:-P値に関するよくある誤解" data-toc-modified-id="問題解答例:-P値に関するよくある誤解-10.6"><span class="toc-item-num">10.6&nbsp;&nbsp;</span>問題解答例: P値に関するよくある誤解</a></span></li><li><span><a href="#問題解答例:-信頼区間に関するよく見る誤解" data-toc-modified-id="問題解答例:-信頼区間に関するよく見る誤解-10.7"><span class="toc-item-num">10.7&nbsp;&nbsp;</span>問題解答例: 信頼区間に関するよく見る誤解</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using Base.Threads
using BenchmarkTools
using Distributions
using LinearAlgebra
using Printf
using QuadGK
using RCall # requires the R language.
@rlibrary exactci # requires the package exactci of R.
using Random
Random.seed!(4649373)
using Roots
using SpecialFunctions
using StaticArrays
using StatsBase
using StatsFuns
using StatsPlots
default(fmt = :png, size = (400, 250),
    titlefontsize = 10,  plot_titlefontsize = 10)
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

```julia
# 二項分布モデルの4種のP値函数

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
    has exceeded the maximum number $maxiters of iterations.""")
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
function illustrate_binomial_pvalues()
    n = 20
    p = 0.25
    k = 9
    
    p̂ = k/n
    σ̂² = n*p̂*(1-p̂)
    
    null = Binomial(n, p)
    μ, σ² = mean(null), var(null)
    nullname = distname(null)
    
    f(x) = mypdf(null, x)
    xlim = (-2, n+1)
    xlimk = (k-0.5, n+0.5)
    
    pval = @sprintf "%.03f" pvalue_clopper_pearson(n, k, p)
    cval = @sprintf "%.03f" ccdf(null, k-1)
    P1 = plot(title="(1) Clopper-Pearson")
    plot!(f, xlim...; label="", c=1)
    plot!(f, xlimk...; label="", fillrange=0, c=1, fc=:red, fa=0.5)
    vline!([μ]; label="μ=$μ", c=1, lw=0.5, ls=:dash)
    annotate!(k+5, 4f(k), text("P-value = $pval", 10, :red))
    plot!([k+7, k+7], [2.4f(k), 3.6f(k)]; arrow=true, c=:red, label="")
    annotate!(k+6, 3f(k), text("2×", 10, :red, :right))
    annotate!(k+5, 2f(k), text("one-tailed = $cval", 10, :red))
    plot!([k+7, k+1], [1.5f(k), 1.5f(k+1)]; arrow=true, c=:red, label="")
    plot!(; xtick=0:n, tickfontsize=7)
    
    pval = @sprintf "%.03f" pvalue_sterne(n, k, p)
    j = _search_boundary(_pdf_le, 2mode(null)-k, -1, (null, pdf(null, k)))
    xlimj = (-0.5, j+0.5)
    P2 = plot(title="(2) Sterne")
    plot!(f, xlim...; label="", c=1)
    plot!(f, xlimk...; label="", fillrange=0, c=1, fc=:red, fa=0.5)
    plot!(f, xlimj...; label="", fillrange=0, c=1, fc=:red, fa=0.5)
    vline!([μ]; label="μ=$μ", c=1, lw=0.5, ls=:dash)
    plot!([k-0.5, j+0.5], [f(k), f(k)]; label="", c=2, ls=:dash)
    annotate!(k+5, 3f(k), text("P-value = $pval", 10, :red))
    plot!([k+5, k+1], [2.5f(k), 0.8f(k)]; arrow=true, c=:red, label="")
    plot!([k+5, j+1], [2.5f(k), 0.8f(j)]; arrow=true, c=:red, label="")
    plot!(; xtick=0:n, tickfontsize=7)
    
    pval = @sprintf "%.03f" pvalue_wilson(n, k, p)
    normal = Normal(μ, √σ²)
    g(x) = pdf(normal, x)
    P3 = plot(title="(3) Wilson")
    plot!(f, xlim...; label="", c=1)
    vline!([μ]; label="μ=$μ", c=1, lw=0.5, ls=:dash)
    plot!(g, xlim...; ls=:dash, label="Normal(μ=$μ, σ=√$σ²)", c=2)
    plot!(g, k, n; label="", fillrange=0, c=2, fc=:red, fa=0.5)
    plot!(g, -2, 2μ-k; label="", fillrange=0, c=2, fc=:red, fa=0.5)
    annotate!(k+5, 3f(k), text("P-value = $pval", 10, :red))
    plot!([k+5, k+0.5], [2.5f(k), 0.8g(k)]; arrow=true, c=:red, label="")
    plot!([k+5, j+0.2], [2.5f(k), 0.7g(j)]; arrow=true, c=:red, label="")
    plot!(; xtick=0:n, tickfontsize=7)
    
    pval = @sprintf "%.03f" pvalue_wald(n, k, p)
    normal = Normal(μ, √σ̂²)
    h(x) = pdf(normal, x)
    P4 = plot(title="(4) Wald")
    plot!(f, xlim...; label="", c=1)
    vline!([μ]; label="μ=$μ", c=1, lw=0.5, ls=:dash)
    plot!(h, xlim...; ls=:dash, label="Normal(μ=$μ, σ=√$σ̂²)", c=2)
    plot!(h, k, n; label="", fillrange=0, c=2, fc=:red, fa=0.5)
    plot!(h, -2, 2μ-k; label="", fillrange=0, c=2, fc=:red, fa=0.5)
    annotate!(k+5, 3f(k), text("P-value = $pval", 10, :red))
    plot!([k+5, k+0.5], [2.5f(k), 0.8g(k)]; arrow=true, c=:red, label="")
    plot!([k+5, j+0.2], [2.5f(k), 0.7g(j)]; arrow=true, c=:red, label="")
    plot!(; xtick=0:n, tickfontsize=7)

    plot(P1, P2, P3, P4; size=(800, 520), layout=(2, 2))
    plot!(; plot_title="model: $nullname,   data: n=$n, k=$k")
end

#illustrate_binomial_pvalues()
```

```julia
# 二項分布モデルの4種のP値函数のプロット

function plot_binom_pvaluefunctions(; n = 20, k = 6)
    P1 = plot(p -> pvalue_clopper_pearson(n, k, p), 0, 1;
        label="", title="Clopper-Pearson", c=1)
    P2 = plot(p -> pvalue_sterne(n, k, p), 0, 1;
        label="", title="Sterne", c=2)
    P3 = plot(p -> pvalue_wilson(n, k, p), 0, 1;
        label="", title="Wilson", c=3)
    P4 = plot(p -> pvalue_wald(n, k, p), 0, 1;
        label="", title="Wald", ls=:dash, c=4)
    plot(P1, P2, P3, P4; size=(800, 520), layout=(2, 2))
    plot!(; xtick=0:0.1:1, ytick=0:0.1:1)
    plot!(; xguide="success rate parameter p",
            yguide="P-value", guidefontsize=10)
    plot!(; plot_title="data: n = $n, k = $k",
            plot_titlefontsize=12)
    plot!(; titlefontsize=12)
end

#plot_binomial_pvaluefunctions(; n = 20, k = 6)
```

```julia
# 二項分布モデルのP値函数の動画 (データ k を動かしてアニメ化)

function gif_binomtest(; n = 20, fn = "images/pvaluefunction20.gif", fps = 5, step=1)
    anim = @animate for k in [0:step:n; n-1:-step:1]
        plot(p -> pvalue_clopper_pearson(n, k, p), 0, 1; label="Clopper-Pearson")
        plot!(p -> pvalue_sterne(n, k, p), 0, 1; label="Sterne")
        plot!(p -> pvalue_wilson(n, k, p), 0, 1; label="Wilson")
        plot!(p -> pvalue_wald(n, k, p), 0, 1; label="Wald", ls=:dash)
        plot!(; xtick=0:0.1:1, ytick=0:0.1:1)
        plot!(; xguide="success rate parameter p", yguide="P-value")
        title!("data: n = $n, k = $k")
        plot!(; size=(600, 300))
        2k > n && plot!(; legend=:topleft)
    end
    gif(anim, fn; fps)
end
```

```julia
# pvalue(x|p) 達のヒートマップ (明るい所ほど値が大きい)

function heatmap_binom_pvaluefunctions(; n = 20, xtick = 0:n)
    k = 0:n
    p = 0:0.01:1

    P1 = heatmap(k, p, (k, p)->pvalue_clopper_pearson(n, k, p);
        colorbar=false, title="(1) Clopper-Pearson")
    P2 = heatmap(k, p, (k, p)->pvalue_sterne(n, k, p);
        colorbar=false, title="(2) Sterne")
    P3 = heatmap(k, p, (k, p)->pvalue_wilson(n, k, p);
        colorbar=false, title="(3) Wilson")
    P4 = heatmap(k, p, (k, p)->pvalue_wald(n, k, p);
        colorbar=false, title="(4) Wald")
    plot(P1, P2, P3, P4; size=(800, 810), layout=(2, 2),
        xtick, ytick=0:0.1:1, tickfontsize=7,
        xguide="k", yguide="p")
    plot!(; plot_title="data size: n = $n", plot_titlefontsize=12)
end

#heatmap_binom_pvaluefunctions(; n = 100, xtick=0:10:100)
```

```julia
# pvalue(x|p) ≥ α のヒートマップ

function heatmap_binom_rejectionregions(; α = 0.05, n = 20, xtick = 0:n)
    k = 0:n
    p = 0:0.01:1

    c = cgrad([colorant"red", colorant"blue"])
    alpha = 0.5
    P1 = heatmap(k, p, (k, p)->pvalue_clopper_pearson(n, k, p) ≥ α;
        colorbar=false, title="(1) Clopper-Pearson", c, alpha)
    P2 = heatmap(k, p, (k, p)->pvalue_sterne(n, k, p) ≥ α;
        colorbar=false, title="(2) Sterne", c, alpha)
    P3 = heatmap(k, p, (k, p)->pvalue_wilson(n, k, p) ≥ α;
        colorbar=false, title="(3) Wilson", c, alpha)
    P4 = heatmap(k, p, (k, p)->pvalue_wald(n, k, p) ≥ α;
        colorbar=false, title="(4) Wald,", c, alpha)
    plot(P1, P2, P3, P4; size=(800, 800), layout=(2, 2),
        xtick, ytick=0:0.1:1, tickfontsize=7,
        xguide="k", yguide="p")
    plot!(; plot_title="significane level: α = $α,  \
        data size: n = $n", plot_titlefontsize=12)
end

#heatmap_binom_rejectionregions(; α = 0.05, n = 100, xtick=0:10:100)
```

```julia
# 二項分布モデルの4種のP値函数に関するシミュレーション

function sim_binomtest(n, p; L=10^5)
    bin = Binomial(n, p)
    p_clopper_pearson = Vector{Float64}(undef, L)
    p_sterne = Vector{Float64}(undef, L)
    p_wilson = Vector{Float64}(undef, L)
    p_wald = Vector{Float64}(undef, L)
    @threads for i in 1:L
        k = rand(bin)
        p_clopper_pearson[i] = pvalue_clopper_pearson(n, k, p)
        p_sterne[i] = pvalue_sterne(n, k, p)
        p_wilson[i] = pvalue_wilson(n, k, p)
        p_wald[i] = pvalue_wald(n, k, p)
    end
    F_clopper_pearson = ecdf(p_clopper_pearson)
    F_sterne = ecdf(p_sterne)
    F_wilson = ecdf(p_wilson)
    F_wald = ecdf(p_wald)
    (; F_clopper_pearson, F_sterne, F_wilson, F_wald)
end

function plot_sim_binomtest(n, p; L=10^5, xmax=1)
    (; F_clopper_pearson, F_sterne, F_wilson, F_wald) = sim_binomtest(n, p; L)
    x = range(0, xmax, 1001)
    P1 = plot(x, x->F_clopper_pearson(x);
        label="", title="(1) Clopper-Pearson", c=1)
    plot!(x, x; label="", ls=:dot, c=:black)
    P2 = plot(x, x->F_sterne(x);
        label="", title="(2) Sterne", c=2)
    plot!(x, x; label="", ls=:dot, c=:black)
    P3 = plot(x, x->F_wilson(x);
        label="", title="(3) Wilson", c=3)
    plot!(x, x; label="", ls=:dot, c=:black)
    P4 = plot(x, x->F_wald(x);
        label="", title="(4) Wald", c=4)
    plot!(x, x; label="", ls=:dot, c=:black)
    
    plot(P1, P2, P3, P4; size=(700, 720), layout=(2,2))
    plot!(; xtick=0:0.1xmax:1, ytick=0:0.1xmax:1, tickfontsize=7)
    plot!(; xlim=(-0.02xmax, 1.02xmax), ylim=(-0.02xmax, 1.02xmax))
    plot!(; xguide="significance level α", yguide="probability of type I error")
    plot!(; plot_title="data: n = $n, p = p₀ = $p", plot_titlefontsize=12)
end
```

```julia
function pvalue_t(X, μ)
    n = length(X)
    X̄ = mean(X)
    S² = var(X)
    T = (X̄ - μ)/√(S²/n)
    2ccdf(TDist(n-1), abs(T))
end

function confint_t(X; α = 0.05)
    n = length(X)
    X̄ = mean(X)
    S² = var(X)
    SE = √(S²/n)
    t = quantile(TDist(n-1), 1 - α/2)
    (X̄ - t*SE, X̄ + t*SE)
end
```

```julia
function illustrate_ttest(;
    x = [10, 4, 20, 10, 18, 7, 5, 8, 4, 16, 8])
    n = length(x)
    x̄ = mean(x)
    s² = var(x)
    μ = 7
    t = (x̄ - μ)/√(s²/n)
    pval = 2ccdf(TDist(n-1), abs(t))
    pval_str = @sprintf "%.03f" pval
    
    println("null hypothesis: μ = ", μ)
    println("data: x = ", x)
    println("data size: n = ", n)
    println("summary statistics; x̄ = ", x̄, ", s² = ", s²,
        ", √s² = ", round(√s²; digits=1))
    println("t-statistics: t = (x̄ - μ)/√(s²/n) = ", t)
    println("degree of freedom: n - 1 = ", n - 1)
    println("P-value: 2(1 - cdf(TDist(n-1), abs(t))) = ", pval)
    
    P1 = plot()
    plot!(TDist(n-1), -5, 5; label="TDist($(n-1))", c=1)
    plot!(TDist(n-1), abs(t), 5; label="", c=1, fillrange=0, fc=:blue, fa=0.3)
    plot!(TDist(n-1), -5, -abs(t); label="", c=1, fillrange=0, fc=:blue, fa=0.3)
    plot!([t, t], [0, 3pdf(TDist(n-1), t)]; label="t = $(round(t; digits=2))", c=:blue)
    plot!(Normal(), -5, 5; label="Normal(0,1)", ls=:dash, c=2)
    plot!(; xtick=-10:10)
    annotate!(-5, 0.25, text("P-value = $pval_str", 10, :blue, :left))
    plot!([-2, -2], [0.23, 0.08]; arrow=true, label="", c=:blue)
    plot!([-2, 1.7], [0.23, 0.04]; arrow=true, label="", c=:blue)
    
    ccdf_t = @sprintf "%.03f" ccdf(TDist(n-1), t)
    ccdf_n = @sprintf "%.03f" ccdf(Normal(), t)
    P2 = plot()
    plot!(TDist(n-1), 1, 5; label="TDist($(n-1))", c=1)
    plot!(TDist(n-1), abs(t), 5; label="", c=1, fillrange=0, fc=:blue, fa=0.3)
    plot!([t, t], [0, 3pdf(TDist(n-1), t)]; label="t = $(round(t; digits=2))", c=:blue)
    plot!(Normal(), 1, 5; label="Normal(0,1)", ls=:dash, c=2)
    plot!(; xtick=-10:10)
    annotate!(5, 0.15, text("1 - cdf(TDist($(n-1)), t) = $ccdf_t", 10, :blue, :right))
    annotate!(5, 0.12, text("1 - cdf(Normal(0,1), t) = $ccdf_n", 10, :red, :right))
    
    plot_title = """
    null hypothesis: μ = $μ,  \
    data: x = [10, 4, 20, 10, 18, 7, 5, 8, 4, 16, 8],  \
    size: n = $n
    """
    plot(P1, P2; size=(800, 270))
    plot!(; plot_title)
end

#illustrate_ttest()
```

```julia
function illustrate_confintmean(; dist = Normal(), n = 30, α = 0.05)
    μ_true = mean(dist)

    plot()
    for i in 1:200
        X = rand(dist, n)
        ci = collect(confint_t(X))
        c = pvalue_t(X, mean(dist)) < α ? 2 : 1
        plot!([i, i], ci; label="", lw=2, c)
    end
    plot!(size=(800, 220))
    hline!([mean(dist)]; label="", c=:black, lw=0.3)
    title!("""
        $(100(1-α))% confidence intervals for mean of \
        size-$n samples of $(distname(dist))
        """)
end

#illustrate_confintmean(dist = LogNormal())
```

```julia
# 正規分布モデルで定めた平均のt検定のシミュレーション

function sim_ttest(; dist=Normal(), n=20, μ=mean(dist), L=10^5)
    pvals = Vector{Float64}(undef, L)
    tmp = [Vector{eltype(dist)}(undef, n) for _ in 1:nthreads()]
    @threads for i in 1:L
        X = rand!(dist, tmp[threadid()])
        pvals[i] = pvalue_t(X, μ)
    end
    ecdf_pvals = ecdf(pvals)
end

function plot_sim_ttest(; dist=Normal(), n=30, μ=mean(dist),
        dist_str=distname(dist), L=10^5)
    ecdf_pvals = sim_ttest(; dist, n, μ, L)
    f(x) = ecdf_pvals(x)
    plot(; legend=:topleft)
    plot!(f, 0, 1; label="")
    plot!(identity, 0, 1; label="", c=:black, lw=0.3, ls=:dash)
    plot!(; xlim=(-0.005, 0.155), ylim=(-0.005, 0.155))
    plot!(; xtick=0:0.01:1, ytick=0:0.01:1, xrotation=45,
        tickfontsize=7)
    plot!(; xguide="α", yguide="probability of P-value < α")
    title!("""
        ecdf of t-test P-values for mean
        sample: $(dist_str), n=$n\
        """)
    plot!(; size=(400, 415))
end

#plot_sim_ttest(; dist=LogNormal())
```

```julia
Random.seed!(4649373)
```

## お勧め解説動画とお勧め文献


### お勧め解説動画

P値と検定と信頼区間については次のリンク先の動画での解説が素晴らしいので, 閲覧を推奨する:

* 京都大学大学院医学研究科 聴講コース<br>臨床研究者のための生物統計学「仮説検定とP値の誤解」<br>佐藤 俊哉 医学研究科教授<br>[https://youtu.be/vz9cZnB1d1c](https://youtu.be/vz9cZnB1d1c)

信頼区間の解説は40分あたり以降にある.

多くの入門的な解説が抱えているP値, 検定, 信頼区間の解説の難点は以下の2つに要約される:

* 複雑な現実と統計モデルを混同させるような解説が伝統的に普通になってしまっていること.
* 検定と信頼区間の表裏一体性(双対性)が解説されていないこと.

そのせいで, P値も $95\%$ 信頼区間の $95\%$ も数学的フィクションである統計モデル内での確率であることがクリアに説明されておらず, P値と $95\%$ 信頼区間の $95\%$ についてまっとうな理解が得られ難くなっている.

上で紹介した動画は教科書の説明がまずいことについて明瞭に言及しながら, 伝統的な入門的解説が抱えている問題を解消しようとしている.

__注意:__ 上の解説動画内で説明されている事柄を理解すれば, P値と検定と信頼区間について広まってしまった誤解を避けることができる.  そして, その後は個別の場合について詳しく勉強するだけの問題になるだろう.


### お勧め文献: P値に関するASA声明

* 統計的有意性と P 値に関する ASA 声明 (日本語訳) \[[PDF](https://www.biometrics.gr.jp/news/all/ASA.pdf)\]

P値に関する解説ではこれが非常によい. しかし, その第2節の

>2. P値とは?
>
>おおざっぱにいうと、P 値とは特定の統計モ
デルのもとで、データの統計的要約（たとえば、
2 グループ比較での標本平均の差）が観察され
た値と等しいか、それよりも極端な値をとる確率
である。

という説明における「データ」という用語の解釈には注意を要する.  この意味での「データ」は現実世界での観察で得たデータのことではなく, __統計モデル内で生成された仮想的なデータ__のことである. 

現実世界で得たデータは決まった数値になるが, 数学的フィクションである統計モデル内で生成されたデータは確率変数とみなせ, それが現実世界での観察で得たデータの数値以上の極端な値を取る確率を考えることができる.

統計学は, 現実世界でデータを得る活動と数学的世界で統計モデルを考えることを行ったり来たりするので, 現実とモデルを混同しないように注意しなければいけない.

P値は現実において常に意味を持つ確率またはその近似値ではなく, 数学的フィクションである統計モデル内部で測った確率に過ぎない.


## まとめ

<span style="font-size: 100%; color: red;">__以下のまとめは「理解が進むたびに繰り返しこのまとめに戻る」というような使い方をして欲しい.__</span>


### P値

__P値__ (P-value)は以下を与えることによって定義される:

* 現実世界におけるデータの数値 $x$ の生成のされ方に関するパラメータ $\theta$ を持つ統計モデル,
* 「データの数値以上に極端な」の意味の定義,
* さらに必要ならば近似計算法.

データの数値 $x$ とパラメータの値 $\theta=\theta_0$ が与えらえたとき, P値は

* __データの数値 $x$ 以上に極端な値が条件 $\theta=\theta_0$ の下での統計モデル内で生じる確率もしくはその近似値__

と定義される. このとき, 条件 $\theta=\theta_0$ は __帰無仮説__ (null hypothesis)と呼ばれることが多い. (「データの数値以上に極端な」の定義は __対立仮説__ (alternative hypothesis)の __集まり__ を与えることによって与えらえると考えられる.)

このノートでは以上のように定義されたP値を

* データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値

と呼ぶことにする.

P値は以下の2つの整合性の指標として使われる:

* 現実世界から得たデータの数値 $x$,
* 統計モデル＋パラメータの値 $\theta=\theta_0$.

P値が小さいほど, 統計モデル＋パラメータの値 $\theta$ は現実世界から得たデータの数値 $x$ と整合していないと考える.


### 検定

__有意水準__ (significance level)と呼ばれる閾値(いきち, しきいち) $0<\alpha<1$ が与えられたとき, P値が $\alpha$ 未満ならば, 

* 統計モデル＋パラメータの値は現実世界から得たデータの数値と整合性がない

とみなす. このとき

* 統計モデル＋パラメータの値は現実世界から得たデータによって __棄却__ (reject)されたという.

この手続きを __検定__ (test, testing, hypothesis testing)と呼ぶ.  (P値が有意水準 $\alpha$ 以上になるとき, 「受容 (accept)された」ということがあるが, 混乱の原因になるので, このノートでは用いない.  このノートでは「棄却された」「棄却されなかった」の組み合わせを一貫して使うことにする.)

棄却されなかった統計モデルとパラメータの値の組み合わせについては強い結論は何も出せない.

棄却されずにすんだ統計モデルとパラメータの値の組み合わせは単に閾値 $\alpha$ の設定で捨てられずにすんだだけなので, 「棄却されなかった統計モデルとパラメータの値の組み合わせは妥当である」のように考えることは典型的な誤解になる.

有意水準 $\alpha$ として $5\%$ が非常によく使われているが, それは単に慣習的にそうなっているだけのことで, $5\%$ の有意水準を使うことに科学的な合理性はない. 

$5\%$ の有意水準の下での結果に一喜一憂することは非科学的な考え方である.

__検定の手続きは「科学的お墨付きを得るための手段」ではない!__

同じことは次の節で説明する信頼区間についても言える.


### 信頼区間

__信頼区間__ (confidence interval)の文脈で $1 - \alpha$ は __信頼度__ (信頼係数, 信頼水準, confidence level)と呼ばれる.

統計モデルが実数パラメータ $\theta$ を持つとき, データの数値 $x$ から決まる信頼度 $1-\alpha$ の信頼区間は

* データの数値 $x$ と有意水準 $\alpha$ で棄却されない統計モデルのパラメータ値 $\theta$ 全体の集合

として定義される.  (この集合が区間にならない場合には信頼領域(confidence region)と呼んだりする.  その集合を含む最小の区間を考える場合もある.)

信頼区間を使うことは, 検定の手続きを無数のパラメータ値 $\theta$ 達に対して適用することと同じである.

検定で棄却されなかった場合については強い結論は何も出せないので, 信頼区間は

* 妥当性について判断を保留するべきパラメータ値全体の集合

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

まず, 現実世界におけるデータの生成のされ方のモデル化として使われる統計モデルを考える.

__例 (二項分布モデル):__

* 現実世界のデータ: 当たりとはずれが出るルーレットを $n$ 回まわしたときの当たりの回数 $k$
* 統計モデル: 二項分布モデル $\op{Binomial}(n, p)$

__例 (正規分布の標本分布モデル):__

* 現実世界のデータ: S市の中学3年生男子全体から $n$ 人を無作為抽出して測った身長の数値達 $x_1,\ldots,x_n$
* 統計モデル: 正規分布のサイズ $n$ の標本分布モデル $\op{Normal}(\mu,\sigma)^n$

このように統計モデルは多くの場合にパラメータ付きの確率分布として与えられる.


### P値の定義

データ $x$ の生成のされ方のモデル化になっているパラメータ $\theta$ を持つ統計モデルが与えられているとする.

データの数値 $x$ とパラメータの数値 $\theta = \theta_0$ が与えられたとき, 

　　__データの数値 $x$ から定まる仮説 $\theta = \theta_0$ のP値__

を次によって定める:

　　__データの数値 $x$ 以上に極端な値が仮説 $\theta=\theta_0$ 下の統計モデル内で生じる確率もしくはその近似値.__

「仮説 $\theta=\theta_0$ 下の統計モデル内におけるデータの数値 $x$ 以上に極端な値」の定義は目的ごとに別に与えられる.  その概略については後の方の説明を参照せよ.

仮説 $\theta=\theta_0$ は __帰無仮説__ (null hypothesis)と呼ばれることが多い.


<span style="font-size: 120%; color: red;">__まとめ: P値＝帰無仮説下のモデル内でデータの数値以上に極端な値が生じる確率(の近似値)__</span>


__補足:__ 「$x$ が $x'$ 以上に極端な値である」という条件は __反射性__(reflexivity)と __推移性__ (transitivity)と __比較可能性__(comparability)の3つの条件を満たしていることを要請する. すなわち「$x$ が $x'$ 以上に極端な値である」ことを $x\succcurlyeq x'$ と書くと, 以下が成立していると仮定する:

* 反射性(reflexibity): $x \succcurlyeq x$,
* 推移性(transitivity): $x \succcurlyeq x'$ and $x' \succcurlyeq x''$ $\implies$ $x \succcurlyeq x''$,
* 比較可能性(comparability): $x \succcurlyeq x'$ or $x' \succcurlyeq x$.

__注意:__ 実際にはこの基本に忠実にP値が定義されるとは限らない.


### 「データの数値以上に極端な値」の意味の定義の仕方

__注意:__ 以下の説明は抽象的過ぎて分かりにくいので, 後の節の具体例の方を先に参照した方がよいと思われる.

P値の定義を確定させるためには, データの数値 $x$ とパラメータの数値 $\theta = \theta_0$ が与えられたとき, 統計モデルとそのパラメータ値が与える確率分布に従う確率変数 $X$ の値がデータの数値 $x_0$ 以上に極端な値であることの定義を, 統計分析の目的に合わせて適切に設定する必要がある.

「仮説 $\theta=\theta_0$ 下の統計モデルに従う確率変数 $X$ がデータの数値 $x$ 以上に極端な値であること」の定義として, 以下のような条件がよく使われる:

(0) $X \ge x$ (または $X \le x$).  

この(0)の条件は例えばχ²検定達で使われる.

さらにこの(0)の条件は帰無仮説 $\theta \le \theta_0$ を($\theta$ の値を $\theta_0$ 以上のどれかとする)を対立仮説 $\theta > \theta_0$ ($\theta$ の値を $\theta_0$ 未満のどれかとする)と比較する __片側検定__ で使用される.

しかし, 主に使われるのは(一部に見かけ上の例外もある(例: χ²検定達)), 帰無仮説 $\theta = \theta_0$ を対立仮説 $\theta \ne \theta_0$ ($\theta$ の値を $\theta_0$ 以外のどれかの値とする)と比較する __両側検定__ の場合である.  以下はすべて両側検定の場合である.  (用語「対立仮説」についてはNeyman-Pearsonの仮説検定の節を参照せよ.)

(1) $X \ge x$ と $X \le x$ の確率が小さい方の条件. (この場合にP値はその確率の2倍にする.)

(2) モデル内での $X$ の値が生じる確率(もしくはその密度)がデータの数値 $x$ 以下である.

$X$ が実数値の確率変数ではなく, $\R^n$ 値の確率変数の場合には, $X$ の実数値函数 $S(X|\theta_0)$ を用意して,

(3) $S(X|\theta_0) \ge S(x|\theta_0)$ (もしくは $S(X|\theta_0) \le S(x|\theta_0)$)

という条件で「仮説 $\theta=\theta_0$ の下での統計モデルに従う確率変数 $X$ がデータの数値 $x$ 以上に極端な値であること」を定義することが多い. 函数 $S(x|\theta_0)$ は __検定統計量__ と呼ばれ, 目的ごとに適切に選択する必要がある.

(4) 他にも正規分布近似を使う方法も多用される.


### 例(二項分布モデルの場合)

__注意:__ 以下の文章による説明はわかりにくいので, 下の方に用意してある図を先に見た方が良いかもしれない.

データの数値「$n$ 回中 $k$ 回成功」と成功確率パラメータの数値 $p=p_0$ が与えられているとし, 仮説 $p=p_0$ 下の二項分布 $\op{Binomial}(n, p_0)$ に従う確率変数 $K$ を用意する:

$$
K \sim \op{Binomial}(n, p_0).
$$

このとき, 「仮説 $p=p_0$ 下の二項分布モデル内での成功回数 $K$ の値がデータの数値 $k$ 以上に極端であること」を以下のように, 互いに同値でない様々な方法で定義できる:

(0) $K \ge k$ (もしくは $K\le k$)という条件で「$k$ 以上に極端」の意味を定義する. この定義はぞれぞれ仮説 $p\le p_0$ (もしくは $p \ge p_0$)の __片側検定__ (one-tailed test, one-sided test) で使われる. 

(1) __Clopper-Pearsonの信頼区間の場合:__ 仮説 $p=p_0$ の下での二項分布モデル内での

　　$K\ge k$ と $K\le k$ の確率の小さい方の2倍(と $1$ の小さい方)

を __両側検定__ のP値として使う.

以下の定義達も両側検定の場合になっている. __検定は, 通常, 両側検定を使用する.__

(2) __Sterneの信頼区間の場合:__ $K$ の値がモデル内で生じる確率がデータの数値 $k$ がモデル内で生じる確率以下になるという条件で, すなわち,

　　二項分布の確率質量函数を $P(k|n,p_0)$ と書くとき, $P(K|n,p_0)\le P(k|n,p_0)$

という条件で「$k$ 以上に極端」の意味を定義する. すなわち, 

　　仮説 $p=p_0$ 下の統計モデル内でデータの数値 $k$ 以上に確率的に珍しいこと

を「$k$ 以上に極端」の定義とする.

以下のように正規分布近似(中心極限定理)を使って定義することもできる.

(3) __Wilsonの信頼区間の場合:__ 二項分布 $\op{Binomial}(n, p_0)$ に関する中心極限定理によれば, $(K - np_0)/\sqrt{np_0(1-p_0)}$ は $np$ と $n(1-p)$ が十分に大きければ近似的に標準正規分布に従う.  「標準正規分布 $\op{Normal}(0, 1)$ に従う確率変数 $Z$ の値がデータの数値以上に極端であること」を

$$
|Z| \ge \frac{|k - np_0|}{\sqrt{np_0(1-p_0)}}
$$

という条件で定め, こうなる確率を標準正規分布を使って計算してP値とする(近似の一種).

(3)' __Pearsonのχ²検定の場合:__ 上の(3)と同値な次の条件を使うこともある:

$$
Z^2 \ge
\frac{(k - np_0)^2}{np_0(1-p_0)}.
$$

$Z\sim\op{Normal}(0,1)$ のとき, $Z^2$ は自由度 $1$ のχ²分布に従うので, こうなる確率を自由度 $1$ のχ²分布を用いて計算してP値とする(これも近似の一種).  さらに上の条件は次とも同値である:

$$
Z^2 \ge
\frac{(k - np_0)^2}{np_0} + \frac{((n-k) - n(1-p_0))^2}{n(1-p_0)}.
$$

これの不等式の右辺を __Pearsonのχ²統計量__ と呼ぶ.  これはそのように呼ばれる検定統計量達

$$
\chi^2 = \sum \frac
{(\text{現実における観測値} - \text{帰無仮説下の統計モデル内での期待値})^2}
{\text{帰無仮説下の統計モデル内での期待値}}
$$

の特別な場合に過ぎない. 上の場合に「現実における観測地」は $n$ 回中の成功回数 $k$ と失敗回数 $n-k$ であり, 「帰無仮説下の統計モデル内での期待値」は成功回数の期待値 $np_0$ と失敗回数の期待値 $n(1-p_0)$ である.  (より進んだ注意: Pearsonのχ²統計量はスコア検定における検定統計量になっている.)

(4) __Waldの信頼区間の場合:__ 上の(3)における右辺の分母の $p_0$ をパラメータの推定量 $\hat{p} = k/n$ で置き換えて得られる次の条件で「データの数値以上に極端であること」を定義することもある:

$$
|Z| \ge
\frac{|k - np_0|}{\sqrt{n\hat{p}(1-\hat{p})}}.
$$

以上のように, 二項分布モデルのP値の定義の仕方も沢山ある.  基本的にどれを使ってもよい.  ユーザー側は自分の目的に合わせて合理的だと考えられるものを自由に使えばよい.

```julia
illustrate_binomial_pvalues()
```

__注意:__ Waldの信頼区間を与えるP値の計算で使っている正規分布近似では, 正規分布の分散としてモデルの分散 $np(1-p) = 3.75$ ではなく, データ「$n=20$ 回中 $k=9$ 回成功」から推定した $k(n-k)/n = 4.95$ を使っているせいで, 正規分布近似の精度が低くなっている.  精度が高いのはWilsonの信頼区間を与えるP値の方である. しかし, 信頼区間の計算はWaldの側がずっと簡単になる.

__注意:__ ここでは詳しく説明できないが, Sterneの信頼区間の方がClopper-Pearsonの信頼区間よりも被覆確率という基準で精度が高いことが知られている. 原論文でもそのことが指摘されている:

* Theodore E. Sterne, Some Remarks on Confidence or Fiducial Limits, Biometrika, Vol. 41, No. 1/2 (Jun., 1954), pp. 275-278 \[[link](https://www.jstor.org/stable/2333026)\]

しかし, 計算法はClopper-Pearsonの信頼区間の方がずっとシンプルである.

__注意:__ P値の定義の仕方の各々には利点と欠点がある.


### 例(正規分布の標本分布モデルの場合)

<span style="font-size: 100%; color: red;">__注意: この節の内容は別のノートで詳しく説明する. この段階では以下で説明する複雑な式を覚える必要はない.__</span>

データの数値 $x = (x_1,\ldots,x_n) \in \R^n$ と興味があるパラメータの数値 $\mu=\mu_0$ が与えられているとする. このとき, 「仮説 $\mu = \mu_0$ の下での正規分布の標本分布モデルに従う確率変数 $X=(X_1,\ldots,X_n)$ の値がデータの数値 $x=(x_1,\ldots,x_n)$ 以上に極端であること」を以下の方法で定義するとよいことが知られている.

まず, $T$ 統計量 $T(X|\mu)$ を次のように定める:

$$
T(x|\mu) = \frac{\bar{x} - \mu}{\sqrt{s^2/n}}, \quad
\bar{x} = \frac{1}{n}\sum_{i=1}^n x_i, \quad
s^2 = \frac{1}{n-1}\sum_{i=1}^n \left(x_i - \bar{x}\right)^2.
$$

そして, 「仮説 $\mu = \mu_0$ の下で確率変数 $X$ の値がデータの数値 $x$ 以上に極端であること」を

$$
\left|T(X|\mu_0)\right| \ge \left|T(x|\mu_0)\right| 
$$

という条件で定める. これは大雑把に言って,

* モデル内で生成された仮想的なデータ $X$ の標本平均 $\bar{X}$ が $\mu=\mu_0$ からデータの標本平均 $\bar{x}$ 以上に離れている.

という意味の条件になっている. ただし, 分散を推定して適当にスケールして比較している.

これが便利なのは, 仮説 $\mu = \mu_0$ の下での正規分布の標本分布モデル内で, __分散パラメータ $\sigma^2$ がどんな値であっても,__  確率変数 $T(X|\mu_0)$ が自由度 $n-1$ の $t$ 分布に従うからである.

__注意:__ 統計モデルが $\theta$ 以外にパラメータ $\eta$ を持っていて, 帰無仮説 $\theta=\theta_0$ を課しても, パラメータ $\eta$ の分だけ統計モデルの確率分布が唯一つに決まらないとき, $\eta$ を __nuisanceパラメータ__  (ニューサンスパラメータ, 局外パラメータ,　撹乱パラメータ, 迷惑パラメータ)と呼ぶ.  上の例では分散パラメータ $\sigma^2$ がnuisanceパラメータになっている.  そして, 上の例はnuisanceパラメータの問題をシンプルに解決できる稀有な場合になっている.

```julia
illustrate_ttest()
```

__注意:__ 自由度 $n-1=10$ の $t$ 分布 $\op{TDist}(10)$ と標準正規分布 $\op{Normal}(0,1)$ は非常に近いように見えるが, その裾野の部分の確率の大きさで違いが生じていることに注意せよ.


__問題:__ サイズ $n=11$ のデータ

　　`x = [10, 4, 20, 10, 18, 7, 5, 8, 4, 16, 8]`

と仮説 $\mu = 7$ について, 標本平均 $\bar{x}$ と不偏分散 $s^2$ と $t = (\bar{x}-\mu)/\sqrt{s^2/2}$ を自分で計算してみて, 上の計算例と一致することを確認せよ.  さらに, インターネットで検索して, $t$ 検定のP値を求める方法を調べ, 実際に計算してみて, 上の計算例と一致することを確認せよ.


### P値は帰無仮説下の統計モデルのデータの数値との整合性の指標

__データの数値 $x$ から計算される帰無仮説 $\theta = \theta_0$ のP値は, データの数値 $x$ と仮説 $\theta=\theta_0$ 下の統計モデルの整合性の指標である__.

P値が小さいとき, 仮説 $\theta=\theta_0$ 下の統計モデルとデータの数値 $x$ があまり整合していないと考える.

これがP値の基本的な使い方である.


<span style="font-size: 120%; color: red;">__まとめ: P値はデータの数値と帰無仮説下のモデルの整合性の指標.__</span>


## 検定

データ $x$ の生成のされ方のモデル化になっているパラメータ $\theta$ を持つ統計モデルが与えられていると仮定する.

さらに __有意水準__ と呼ばれる __閾値__(いきち, しきいち) $0 \le \alpha \le 1$ が与えられていると仮定する.  $\alpha$ は目的に合わせて適当に小さな値としておく.  (有意水準として $5\%$ がよく用いられているが, そのことに科学的な合理性はない.)

データの数値 $x$ とパラメータの数値 $\theta=\theta_0$ が与えられているとき, (帰無)仮説 $\theta = \theta_0$ のP値を求め,  P値が $\alpha$ 未満になるとき, 仮説 $\theta = \theta_0$ 下の統計モデルは __棄却__ (reject)されたという.  (実際には「帰無仮説は棄却された」と略した言い方をすることが多い.)

この手続きを __仮説検定__ (Hypothesis tesitng)もしくは単に __検定__ (test)と呼ぶ.

すなわち, 検定とは, __ある閾値を設けて, データの数値との整合性が閾値未満のモデルのパラメータ値を捨て去る手続き__ のことである.

ただし, 検定は閾値を設けて捨て去る行為なので, 捨て去り過ぎてしまう誤りを犯すリスクがある.

有意水準が小さなほどそのリスクは小さくなるが, その分だけ, 科学的に興味深い結果を見逃してしまうリスクが増える.


<span style="font-size: 120%; color: red;">__まとめ: 検定＝閾値を設けてデータの数値との整合性が低過ぎるパラメータ値を捨て去る手続き.__</span>


## 第一種の過誤(αエラー)


### 第一種の過誤(αエラー)の定義

$X$ はパラメータの数値を $\theta=\theta_0$ に設定した統計モデルに従う確率変数であると仮定する.

データの数値がその確率変数 $X$ の値であるときの仮説 $\theta = \theta_0$ のP値が有意水準 $\alpha$ 未満になる確率を仮説 $\theta = \theta_0$ に関する __第一種の過誤の確率__ または __αエラーの確率__ と呼ぶ.

すなわち, 仮説 $\theta = \theta_0$ 下の統計モデル内部において, その仮説 $\theta = \theta_0$ が検定の手続きで棄却されてしまうことを __第一種の過誤__ (Type I error, αエラー, α-error)と呼び, その確率を __第一種の過誤の確率__ と呼ぶ.

第一種の過誤は検定する仮説 $\theta=\theta_0$ が成立しているモデル内部においてその仮説が棄却されてしまうことを意味しており, その確率は小さい方がよい.  しかし, 第一種の過誤の確率を小さくすることが原因で生じる害(後で述べる検出力の低下)もあるので, 目的に合わせてバランスを取ることが必要である.

__注意:__ 第一種の過誤は「無実のものを有罪にしてしまう誤り」に例えられることがある.

__注意:__ 第一種の過誤は統計モデルが自分自身を確率的に否定してしまうことであると言うこともできる.

__注意:__ 現実世界から得たデータの数値 $x$ は値が確定した定数だが, 数学的フィクションである統計モデル内ではデータの数値が確率変数 $X$ としてランダムに生成されていると考えることができる.  多くの教科書でこの辺について誤解に誘導するような説明があるので注意して欲しい.


<span style="font-size: 120%; color: red;">__まとめ: 第一種の過誤＝帰無仮説下の統計モデル内で帰無仮説が棄却されること.__</span>


### 第一種の過誤(αエラー)の確率

__定理:__ 有意水準 $\alpha$ の下での第一種の過誤の確率の値は $\alpha$ で近似される.

__証明:__ $x$ の値が $x'$ 以上に極端であるという条件を $x \succcurlyeq x'$ と書き,  $X$ はパラメータ値 $\theta=\theta_0$ の統計モデルに従う確率変数であると仮定する.

このとき, P値の定義($X$ の値が $x$ 以上に極端な値になる確率もしくはその近似値)より,

$$
(\text{データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値}) \approx P(X \succcurlyeq x).
$$

$P(X \succcurlyeq x_\alpha) \approx \alpha$ となる $x_\alpha$ を取る. このとき,

$$
\begin{aligned}
&
(\text{データの数値 $x$ について仮説 $\theta = \theta_0$ のP値が $\alpha$ 未満になるという条件})
\\ &\approx
(\text{$P(X \succcurlyeq x) < \alpha$ という条件})
\\ &\approx
(\text{$x \succcurlyeq x_\alpha$ という条件}).
\end{aligned}
$$

したがって, 

$$
\begin{aligned}
&
(\text{仮説 $\theta = \theta_0$ に関する第一種の過誤の確率})
\\ &=
(\text{データの数値が確率変数 $X$ の値であるときに
仮説 $\theta = \theta_0$ のP値が $\alpha$ 未満になる確率})
\\ &\approx
(\text{$X \succcurlyeq x_\alpha$ となる確率}) =
P(X \succcurlyeq x_\alpha) \approx \alpha.
\end{aligned}
$$

__証明終__

__注意:__ 上の問題の結果は, 仮説 $\theta=\theta_0$ 下の統計モデル内部において, 同仮説 $\theta=\theta_0$ のP値の分布が一様分布で近似されることを意味している. 次の節の計算例を参照せよ.

__注意:__ 実際にはP値を基本に忠実でない方法で定義することもあり, 上の定理の証明が適用できない場合もあるのだが, 検定の理論では第一種の過誤の確率が有意水準に近くなることを要請することが普通である.


<span style="font-size: 120%; color: red;">__まとめ: 第一種の過誤の確率は有意水準に等しいかそれに近い値になる.__</span>

これは実際には「要請」であり, 証明されるべき結果ではないとみなされる.


### 二項分布モデルの4種のP値に関する第一種の過誤の確率のグラフ

二項分布モデルの4種のP値について, $0$ から $1$ のあいだの有意水準 $\alpha$ 達について第一種の過誤の確率を計算してグラフを描いてみよう.

そのグラフは, 仮説 $p=p_0$ 下の二項分布モデル内部における同仮説 $p=p_0$ のP値の分布の累積分布函数のグラフだと言ってよいので, そのグラフが「45度線」に近ければ近いほど, その分布は一様分布に近いということになる.

```julia
plot_sim_binomtest(20, 0.3)
```

```julia
plot_sim_binomtest(100, 0.3)
```

```julia
plot_sim_binomtest(1000, 0.3)
```

確かに二項分布モデルの4種のP値の帰無仮説下の二項分布内での累積分布函数は, 確かに45度線を近似していることが分かる.  このことはそのP値の分布が一様分布で近似されることを意味している.


## 信頼区間


### 信頼区間のP値もしくは検定を用いた定義

有意水準 $\alpha$ の検定の手続きをパラメータ $\theta$ のすべての値に適用したとき, 棄却されなかったパラメータ値全体の集合をパラメータ $\theta$ に関する __信頼度__ (信頼係数) $1-\alpha$ の __信頼区間__ (confidence interval)と呼ぶ. ($\alpha = 5\%$ のとき, 信頼度 $1-\alpha$ の信頼区間を $95\%$ 信頼区間と呼ぶことが多い.)

有意水準 $\alpha$ の検定の手続きでパラメータの値 $\theta=\theta_0$ が棄却されることは, 仮説 $\theta=\theta_0$ 下の統計モデルとデータの値 $x$ との整合性(P値)が有意水準 $\alpha$ 未満になることであった.  そのような状況を

* 仮説 $\theta=\theta_0$ 下の統計モデルとデータの値 $x$ との整合性が無さすぎる

と言うことにしよう.  このスタイルの下では, 信頼区間は

* 統計モデルの下で, データの数値 $x$ との整合性が無さすぎないパラメータ値全体の集合

であると言える.


<span style="font-size: 120%; color: red;">__まとめ: 信頼区間＝検定で棄却されないモデルのパラメータ値全体の集合.__</span>


### 信頼区間の使い方

「整合性が無さすぎないこと」は「正しいこと」を意味しないし, 「正しい可能性が高いこと」も意味しない.

__信頼区間に含まれるパラメータ値の下での統計モデルの妥当性については判断を保留しなければいけない.__

__例:__ 例えば, パラメータ $\theta$ がある治療法の治療効果を意味するパラメータであったとしよう.  そのとき, 現実世界における調査で得たデータの数値 $x$ に関する $\theta$ の信頼区間は

* その区間に含まれる治療効果の数値の各々については, 現実における正しさの判断を保留する.
* その区間のどれかの値が真の治療効果であっても大丈夫なようにしておく.
* 得られたデータの数値へのその統計モデルの使用が妥当でない可能性についても常に注意を払う.

のような使い方をすることが妥当だと思われる.


<span style="font-size: 110%; color: red;">__まとめ: 信頼区間に含まれるパラメータ値の下での統計モデルの妥当性については判断を保留する.__</span>


## 信頼区間と検定の表裏一体性


### 検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合

データ $x$ の生成のされ方のモデル化になっているパラメータ $\theta$ を持つ統計モデルが設定されていると仮定し, データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値 $\op{pvalue}(x|\theta_0)$ が定義されていると仮定し, 有意水準 $\alpha$ が与えられているとする.

データの数値 $x$ が与えらえたとき, パラメータの数値 $\theta=\theta_0$ をP値 $\op{pvalue}(x|\theta_0)$ に対応させる函数

$$
\theta_0 \mapsto \op{pvalue}(x|\theta_0)
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


<span style="font-size: 110%; color: red;">__まとめ: 信頼区間と検定は表裏一体である.__</span>


### 信頼区間と検定の表裏一体性について書かれた教科書の例

以下の教科書にはこのノートが採用した信頼区間と検定の表裏一体性に関する考え方が書いてある.

* 竹内啓, 数理統計学―データ解析の方法, 東洋経済新報社, 1963 (のp.103) 
* 小針晛宏, 確率・統計入門, 岩波書店, 1973 (のp.197)
* 久保川達也, 現代数理統計学の基礎, 共立出版, 2017 (のp.169)
* 竹村彰通, 新装改訂版 現代数理統計学, 学術図書出版社, 2020 (のp.202)

これらの教科書は有名である.

* https://twitter.com/genkuroki/status/1531827825879445505

にその部分の引用がある.


<span style="font-size: 110%; color: red;">__まとめ: 信頼区間と検定が表裏一体であることは有名な教科書群に書いてある.__</span>


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


<span style="font-size: 120%; color: red;">__まとめ: 仮説 $\theta=\theta_0$ 下の統計モデル内部において, 信頼区間がパラメータ値 $\theta=\theta_0$ を含む確率は信頼度 $1-\alpha$ に等しい, もしくはそれに近い値になる.__</span>

これも証明するべきことではなく, 「要請」だと考えた方がよい.


### 二項分布モデルでのP値函数の視覚化

__文献:__ P値函数の使い方については次の文献が詳しい:

* Timothy L. Lash, Tyler J. VanderWeele, Sebastien Haneuse, and Kenneth J. Rothman.<br>Modern Epidemiology, 4th edition, 2020. [Google](https://www.google.com/search?q=Modern+Epidemiology+4th)

第4版よりも古い版でもよい.

```julia
plot_binom_pvaluefunctions(; n = 20, k = 6)
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
gif_binomtest()
```

$n$ を大きくするとP値函数の「幅」は狭くなる.

```julia
plot_binom_pvaluefunctions(; n = 100, k = 30)
```

```julia
gif_binomtest(n = 100, fn = "images/pvaluefunction100.gif", fps=20)
```

PDFファイルではこの動画を見ることはできない.  作成した動画は

* https://github.com/genkuroki/Statistics/blob/master/2022/images/pvaluefunction20.gif
* https://github.com/genkuroki/Statistics/blob/master/2022/images/pvaluefunction100.gif

でも見ることができる.


__pvalue(x|p) 達のヒートマップ (明るい所ほど値が大きい)__

```julia
heatmap_binom_pvaluefunctions(; n = 20)
```

明るい部分ほどP値が大きい.  P値が小さな部分はほぼ黒色になっている.  そこでは「$n$ 回中 $k$ 回成功」というデータの数値に成功回数パラメータ値が $p$ の二項分布モデルが整合していないと考える.

例えば「$n=20$ 回中 $k=6$ 回成功」というデータの数値が得られたとき $k=6$ でのP値函数の「明るさ」を上のグラフで確認すると, $p=6/20=0.6$ で最も明るくなっており, そこから $p$ が離れると暗くなって行くことがわかる. P値による判定によれば, 「$n=20$ 回中 $k=6$ 回成功」というデータの数値に最も整合する二項分布モデルの成功確率パラメータ $p$ の値は $p=0.3$ であり, そこから $p$ が離れるにつれて整合性は下がって行く.

```julia
heatmap_binom_pvaluefunctions(; n = 100, xtick = 0:10:100)
```

このように, $n$ を大きくすると, 明るい部分が「細く」なる.  これは, $n$ を大きくすると, $k$ を固定したときに得られるP値函数のグラフが「狭く」なることと同じ.

```julia
heatmap_binom_rejectionregions(; α = 0.05, n = 20)
```

薄い赤の領域はP値が $\alpha = 5\%$ 未満になる部分であり, 薄い青の領域はP値が $\alpha = 5\%$ 以上になる部分である.  P値の定義の仕方によって結果は異なるが概ね似たような様子になっている.

```julia
heatmap_binom_rejectionregions(; α = 0.05, n = 100, xtick = 0:10:100)
```

```julia
heatmap_binom_rejectionregions(; α = 0.05, n = 1000, xtick = 0:100:1000)
```

## 統計モデルやP値函数が「よい」かどうかの判断基準達


### 計算方法はシンプルな方がよい

このノートで扱っている4種のP値(Clopper-Pearson, Sterne, Wilson, Waldの信頼区間を与えるP値)では, 計算効率を気にする実装を行うと, Sterneの信頼区間を与えるP値の実装がひどく複雑になってしまい, バグも発生し易い.

計算法がシンプルな方が実装のミスも少なく, 計算効率もよいことが多い.

だから, たとえ別の方法が道具としての性能が勝っていたとしても, 計算方法がシンプルな側を採用することは十分に検討に値する.


### 頑健な方がよい

統計モデルが現実のデータ生成法則をぴったり記述していると考えることは非現実的な場合が多い.

だから, 統計モデルが現実のデータ生成法則からずれている場合について考えることも非常に重要になる.

統計モデルが現実のデータ生成法則からずれていても統計分析の誤差が小さくなる傾向があるとき, その分析法は __頑健__ (robust)であるという.

頑健な方が実践的な適用範囲が広がり, 統計分析の失敗のリスクも減るので好ましい.

<!-- #region -->
### 第一種の過誤の確率は有意水準に近い方がよい


第一種の過誤の確率は有意水準に近い方がよい.  応用上特に重要なのは有意水準が $\alpha \le 5\%$ と小さいところでの近似の精度である.


例えば, 以下の二項分布モデルの4種のP値の例については, Clopper-Pearsonの信頼区間を与えるP値よりもSterneの信頼区間を与えるP値を使った方が誤差は小さくなっており, Waldの信頼区間を与えるP値よりもWilsonの信頼区間を与えるP値を使った方が誤差は小さくなっている.
<!-- #endregion -->

```julia
Random.seed!(4649373)
```

```julia
plot_sim_binomtest(100, 0.2; xmax=0.1, L=10^6)
```

```julia
plot_sim_binomtest(1000, 0.02; xmax=0.1, L=10^6)
```

```julia
plot_sim_binomtest(1000, 0.2; xmax=0.1, L=10^6)
```

### 第一種の過誤の確率は有意水準以下である方がよい

「第一種の過誤の確率は有意水準以下である方がよい」という基準のことを __保守性__ (conservativity)と呼ぶことがある.

上の例では, Clopper-Pearsonの信頼区間を与えるP値とSterneの信頼区間を与えるP値では, 第一種の過誤の確率が常に有意水準以下になり, __保守的__ (conservative)である.  しかし, Wilsonの信頼区間を与えるP値とWaldの信頼区間を与えるP値はその意味で保守的ではない(__リベラル__ (liberal)ということがある).


### 検出力は高い方がよい

大雑把に言うと, 仮説 $\theta=\theta_0$ のP値の __検出力__ (power)はその仮説 $\theta=\theta_0$ と別の仮説 $\theta=\theta_1$ との分解能を意味する.

その文脈で別の仮説 $\theta=\theta_1$ を帰無仮説 $\theta=\theta_0$ の __対立仮説__ (alternative hypothesis)と呼ぶ.

帰無仮説 $\theta=\theta_0$ のP値の対立仮説 $\theta=\theta_1 (\ne\theta_0)$ に関する __検出力__ (power)は

* 対立仮説 $\theta=\theta_1$ 下の統計モデル内部で帰無仮説 $\theta=\theta_0$ のP値が有意水準 $\alpha$ 未満になる確率

と定義される.  すなわち, 

* $X$ を対立仮説 $\theta=\theta_1$ 下の統計モデルに従う確率変数とし, データの数値を $X$ としたとき仮説 $\theta=\theta_0$ が有意水準 $\alpha$ で棄却される確率

をそのように呼ぶ.  

有意水準が等しいなら, 検出力は高い方がよい. 

可能ならば任意の $\theta_1$ についてそうであって欲しいがそのようにすることは一般には不可能である. 

検出力については次の節も参照せよ.


<span style="font-size: 120%; color: red;">__まとめ: 検出力＝対立仮説下の統計モデル内で帰無仮説が棄却される確率.__</span>


<span style="font-size: 100%; color: red;">__復習: 有意水準 ≈ 第一種の過誤の確率＝帰無仮説下の統計モデル内で帰無仮説が棄却される確率.__</span>


## Neyman-Pearsonの仮説検定


### パラメータを持たない2つの統計モデルに関する仮説検定

データ $x$ の生成のされ方に関するパラメータを持たない(もしくはすべてのパラメータの値が固定された)統計モデルが2つ与えられているとする.

簡単のために2つの統計モデルはそれぞれ確率密度函数 $p_0(x)$, $p_1(x)$ によって与えられているとする.

以下では統計モデル $p_0(x)$ を __帰無仮説__ (null hypothesis)と呼び, 統計モデル $p_1(x)$ を __対立仮説__ (alternative hypothesis)と呼ぶ.  (多くの場合に, 帰無仮説は「薬Aには効果がない」のような否定したい仮説になり, 対立仮説は例えば「薬Aには～という効果がある」のような正しいことを発見したい仮説になる.)

有意水準 $0\le\alpha\le 1$ について, 棄却領域と呼ばれれる $x$ の集合 $R_\alpha$ が与えられており, 帰無仮説 $p_0(x)$ に従う確率変数 $X_0$ について,

$$
P(X_0 \in R_\alpha) \le \alpha
$$

が成立していると仮定する.

このとき, 棄却領域 $R_\alpha$ によって, __帰無仮説に関する有意水準 $\alpha$ の検定法__ が与えられたと言い, データの数値 $x$ が $R_\alpha$ に含まれるときに, 帰無仮説 $p_0(x)$ は __棄却__ されたと言う.

棄却領域 $R_\alpha$ で与えられた帰無仮説 $p_0(x)$ の検定法における対立仮説 $p_1(x)$ の __検出力__ $\op{power}(R_\alpha)$ を, 対立仮説 $p_1(x)$ に従う確率変数 $X_1$ を使って次のように定める:

$$
\op{power}(R_\alpha) = P(X_1 \in R_\alpha).
$$

対立仮説の検出力がより高い検定法は __より強力__(more powerful)であるという.


<span style="font-size: 120%; color: red;">__まとめ: 検出力＝power＝対立仮説下の統計モデル内で帰無仮説が棄却される確率.__</span>

<span style="font-size: 100%; color: red;">__復習: 第一種の過誤の確率＝帰無仮説下の統計モデル内で帰無仮説が棄却される確率.__</span>


### Neyman-Pearsonの補題

__尤度比検定__ (likelihood ratio test)と呼ばれる検定法を次の棄却領域 $L_\alpha$ によって定める:

$$
L_\alpha =
\left\{\, x \,\left|\, \frac{p_0(x)}{p_1(x)} < c_\alpha \right.\right\}.
$$

ただし, 定数 $c_\alpha$ は $P(X_0\in L_\alpha) = \alpha$ をみたすものであるとする.

__定理(Neyman-Pearsonの補題):__ 棄却領域 $R_\alpha$ で与えられた任意の検定法について

$$
\op{power}(L_\alpha) \ge \op{power}(R_\alpha).
$$

すなわち, 尤度比検定は帰無仮説 $p_0(x)$ の検定法の中で対立仮説 $p_1(x)$ の検出力が最大である.


<span style="font-size: 120%; color: red;">__Neyman-Pearsonの補題: 帰無仮説と対立仮説がともにすべてのパラメータが固定された統計モデルであるときには, 尤度比検定が最強力になる.__</span>


__用語について補足説明:__ 対立仮説の下で帰無仮説が棄却されない確率を __第二種の過誤の確率__ (type II error, βエラー, β-error)と呼ぶ. すなわち,

$$
(\text{第二種の過誤の確率}) = 1 - (\text{検出力}).
$$

仮説検定法では, 第一種の過誤の確率＝有意水準をある小さな値に定めたとき, 第二種の過誤の確率を小さくしたい.


### Neyman-Pearsonの補題の証明

$X_0$, $X_1$ はそれぞれ帰無仮説 $p_0(x)$, 対立仮説 $p_1(x)$ に従う確率変数であるとする. このとき,

$$
P(X_0 \in L_\alpha) = \alpha \ge P(X_1 \in R_\alpha).
$$

$L_\alpha$, $R_\alpha$ の補集合を $L_\alpha^c$, $R_\alpha^c$ と書くことにすると,

$$
L_\alpha = (L_\alpha\cap R_\alpha)\cup(L_\alpha\cap R_\alpha^c), \quad
R_\alpha = (L_\alpha\cap R_\alpha)\cup(L_\alpha^c\cap R_\alpha).
\tag{$*$}
$$

$P(X_0 \in L_\alpha) \ge P(X_0 \in R_\alpha)$ より,

$$
P(X_0\in L_\alpha\cap R_\alpha^c) \ge P(X_1\in L_\alpha^c\cap R_\alpha).
\tag{$\sharp$}
$$

$x\in L_\alpha$ と $p_1(x) > p_0(x)/c_\alpha$ が同値であることと, すぐ上で示した($\sharp$)と, $x\not\in L_\alpha$ と $p_0(x)/c_\alpha \ge p_1(x)$ が同値であることを順番に使うと,

$$
\begin{aligned}
P(X_1\in L_\alpha\cap R_\alpha^c) &=
\int_{L_\alpha\cap R_\alpha^c} p_1(x)\,dx \ge
\frac{1}{c_\alpha} \int_{L_\alpha\cap R_\alpha^c} p_0(x)\,dx
\\ &=
\frac{1}{c_\alpha} P(X_0\in L_\alpha\cap R_\alpha^c) \ge
\frac{1}{c_\alpha} P(X_0\in L_\alpha^c\cap R_\alpha) 
\\ &=
\frac{1}{c_\alpha} \int_{L_\alpha^c\cap R_\alpha} p_0(x)\,dx \ge
\int_{L_\alpha^c\cap R_\alpha} p_1(x)\,dx =
P(X_1 \in L_\alpha^c\cap R_\alpha).
\end{aligned}
$$

上と同様にして($*$)より,

$$
P(X_1\in L_\alpha) - P(X_1\in R_\alpha) =
P(X_1\in L_\alpha\cap R_\alpha^c) - P(X_1\in L_\alpha^c\cap R_\alpha) \ge 0.
$$

これで示すべきことが示された.

__証明終__


![NeymanPearsonLemma.jpg](attachment:NeymanPearsonLemma.jpg)


### 尤度比検定の例: 正規分布モデルの場合

$\mu_1 \in \R$ であるとし, $p_0(x)$, $p_1(x)$ が次の場合について考える:

$$
p_0(x) = \frac{e^{-x^2/2}}{\sqrt{2\pi}}, \quad
p_1(x) = \frac{e^{-(x-\mu_1)^2/2}}{\sqrt{2\pi}}
$$

このとき, 

$$
\frac{p_0(x)}{p_1(x)} = \exp(\mu_1^2 - 2\mu_1 x).
$$

これがある値未満になるという条件は, 

* $\mu_1 > 0$ の場合には, $x$ がある値 $a$ より大きいという条件と同値になり,
* $\mu_1 < 0$ の場合には, $x$ がある値 $a$ より小さいという条件と同値になる.

$x$ がそのようになる標準正規分布における確率はそれぞれ

* $\mu_1 > 0$ の場合: $1 - \op{cdf}(\op{Normal}(0,1), a)$, 
* $\mu_1 < 0$ の場合: $\op{cdf}(\op{Normal}(0,1), a)$ 

なので, これらが有意水準 $\alpha$ に等しくなる $a = a_\alpha$ はそれぞれ

* $\mu_1 > 0$ の場合: $a_\alpha = \op{quantile}(\op{Normal}(0,1), 1-\alpha)$,
* $\mu_1 < 0$ の場合: $a_\alpha = \op{quantile}(\op{Normal}(0,1), \alpha)$

になる. ゆえに, 帰無仮説 $p_0(x)$ と対立仮説 $p_1(x)$ に関する対数尤度比検定を与える棄却領域はそれぞれ次のようになる:

* $\mu_1 > 0$ の場合: $L_\alpha = \{\,x\mid x > a_\alpha\,\}$, 
* $\mu_1 < 0$ の場合: $L_\alpha = \{\,x\mid x < a_\alpha\,\}$.

これは以下のように解釈される.

* 対立仮説の平均 $\mu_1$ が帰無仮説の平均 $0$ より大きい場合には, データ $x$ の値がある値より大きくなると, 帰無仮説よりも対立仮説と整合的になり, 帰無仮説が棄却される.
* 対立仮説の平均 $\mu_1$ が帰無仮説の平均 $0$ より小さい場合には, データ $x$ の値がある値より小さくなると, 帰無仮説よりも対立仮説と整合的になり, 帰無仮説が棄却される.

この例より, すべての $\mu_1$ について, 最強力になるような単一の検定法が存在しないことも分かる.

__注意:__ しかし, __不偏__ という非常に強い条件を満たす検定法の中ではすべての対立仮説パラメータ値 $\theta_1$ について最強力になるような検定が存在することがある(一様最強力不偏検定(uniformly most powerful unbiased test, UMPU test)).  20世紀の検定の理論はこのような方向で整備された.  詳しくは次の教科書を参照せよ:

* Erich L. Lehmann, Joseph P. Romano, Testing Statistical Hypotheses, Third edition, 2005

しかし, 一様最強力不偏検定(UMPU test)の理論は実践的にはそう役に立つわけではない.

特に, 離散分布モデルを用いてUMPU検定を作るためには特定のデータによって帰無仮説が確率的に棄却される場合が出て来ることを受け入れる必要があり, 通常の科学研究でそれは受け入れらる条件ではない. 離散分布モデルによる実践的に使用されている検定法はどれもUMPU検定ではない.

とは言うものの, たとえ実践的ではないとしても, UMPU検定の話も数学的には結構面白い. 興味がある人は, UMPU検定について自分で調べ, 二項分布モデルなどの場合についてUMPU検定をコンピュータで実装してみるとよいだろう.


### Neyman-Pearsonの仮説検定に関する極端な解釈の普及の問題

Neyman-Pearsonの仮説検定では, 帰無仮説についての第一種の過誤の確率を有意水準 $\alpha$ の設定によって上からおさえ, 対立仮説の検出力を可能な限り大きくすることによって, 帰無仮説と対立仮説をデータの数値によって比較する方法である.

Neyman-Pearsonの仮説検定では, 帰無仮説が棄却された場合には「帰無仮説よりも対立仮説の方が __相対的に__ 妥当である」と __暫定的に__ 判断してもよいだろう.  その判断は単に帰無仮説と対立仮説の相対的な比較の下での暫定的な判断に過ぎず, 対立仮説の側が正しいと最終的に判断することとは異なる.

しかし, 「帰無仮説が棄却されなかった場合には帰無仮説を受容し, 帰無仮説が棄却された場合には対立仮説の側が正しいと判断する」ことは, Neyman-Pearsonの仮説検定の本質的要請であるとみなす極端な解釈が広く普及してしまっている.

その解釈が極端過ぎることは, 少なくとも, 

* E. S. Pearson, Statistical Concepts in the Relation to Reality, Journal of the Royal Statistical Society. Series B (Methodological), Vol. 17, No. 2 (1955), pp. 204-207. \[[link](https://www.jstor.org/stable/2983954)\], \[[pdf](https://errorstatistics.files.wordpress.com/2021/02/pearson_1955-stat-concepts-reality.pdf)\]

のp.206からの以下の段落の引用を読めば明らかだと思われる:

>Professor Fisher's next objection is to the use of such terms as the "acceptance" or "rejection" of a statistical hypothesis, and "errors of the first and second kinds".
>It may be readily agreed that in the first Neyman and Pearson paper of 1928, more space might have been given to discussing how the scientific worker's attitude of mind could be related to the formal structure of the mathematical probability theory that was introduced.
>Nevertheless it should be clear from the first paragraph of this paper that we were not speaking of the final acceptance or rejection of a scientific hypothesis on the basis of statistical analysis. 
>We speak of accepting or rejecting a hypothesis with a "greater or less degree of confidence". 
>Further, we were very far from suggesting that statistical methods should force an irreversible acceptance procedure upon the experimenter. 
>Indeed, from the start we shared Professor Fisher's view that in scientific enquiry, a statistical test is "a means of learning", for we remark: "the tests themselves give no final verdict, but as tools help the worker who is using them to form his final decision". 
>No doubt we could more aptly have said "his final or provisional decision"; even scientists, if they are employed in research departments by industry or government, may sometimes have to give a final decision.

翻訳:

>Fisher教授の次の反対は, 統計的仮説の「受容」または「棄却」, 「第一種および第二種の過誤」といった用語の使用に対するものである. 
>NeymanとPearsonによる1928年の最初の論文では, 科学的な研究者の心構えが導入された数学的確率論の形式的構造にどのように関係付けられるか, について論じるためにより多くのスペースが設けることができたということについてはただちに同意できる.
>しかし, この論文の最初の段落から明らかなように, 我々は科学的仮説の統計的分析に基く最終的受容や最終的棄却について語ってはいない.
>我々は, 「信頼性の度合いの大小」によって仮説を受容するか棄却するかについて語っている.
>さらに, 我々は, 統計的手法が実験者に不可逆的な受容手順を強いることの示唆をまったくしていない.
>実際我々は, 科学的探求において統計的検定は「学習の手段」であるというFisher教授の考えを最初から共有していた. その証拠に, 我々は「検定そのものは最終的判断を与えないが, 最終的決定のための道具として研究者にとって役に立つ.」と注意している.
>間違いなく我々はより適切に「研究者の最終的または暫定的な判断」と言えた. たとえ産業界や政府の研究部門に雇用されていて最終的決定を下さなければいけない科学者達であってもそうである.

このように, Neyman-PearsonのPearson氏は「Neuman-Pearsonの仮説検定では, 検定の手続きによって仮説の受容と棄却に関する最終的判断を強いる」という解釈を明瞭に否定している.

検定の手続きは, 科学的探求における「学習の手段」であり, 最終的判断ではなく暫定的判断を与え, 道具としては最終的決定にも役に立つと述べている. さらに, 帰無仮説または対立仮説の絶対的な受容と棄却ではなく, 信頼度の度合いの大小による相対的な判断に過ぎないことも説明している.

おそらく, 「受容」(acceptance)と「棄却」(rejection)という1か0かの極端な判断を強いるニュアンスを与える用語を専門用語として採用してしまったことが悪かったのだろう.  この「受容」「棄却」は現代の教科書でも使われている場合がある. Pearson氏にならって極端な意味に解釈しないように注意することが必要である. 

なお, このノート群では「受容する」という言い方は避けて「棄却しない」という言い方を用いることにしている.  (通常の意味で)「棄却しない」ことはただちに(通常の意味で)「受容する」ことを意味せず, 「判断を保留する」ことが可能なことも意味している.

さらに次の解説も参照せよ:

* Deborah Mayo, Erich Lehmann’s 100 Birthday: Neyman Pearson vs Fisher on P-values, Posted on November 19, 2017. \[[link](https://errorstatistics.com/2017/11/19/erich-lehmanns-100-birthday-neyman-pearson-vs-fisher-on-p-values/)\]

そこで引用されている次の論文では, Fisher流の検定とNeyman-Pearson流の検定の良い点を組み合わせて使うことを提案している:

* E. L. Lehmann, The Fisher, Neyman-Pearson Theories of Testing Hypotheses: One Theory or Two?, ournal of the American Statistical Association, Vol. 88, No. 424 (Dec., 1993), pp. 1242-1249. \[[link](https://www.jstor.org/stable/2291263)\], \[[pdf](https://errorstatistics.files.wordpress.com/2013/11/lehmann_1-theory-or-2.pdf)\]

非常に残念なことに, 極端な解釈によって, Fisher流の検定とNeyman-Pearson流の検定の違いを強調し, 対立を煽っているかのような解説を見ることがある.  そのような解説では, Fisher流の検定とNeyman-Pearson流の検定の考え方を混ぜることは許さないという方針になりがちである. (これは上で引用したLehmann氏の論文とは正反対の態度である.)

そのようなことをしても科学的に建設的ではなく, 現代における最良の視点から, 科学的常識に沿った穏健で有用な解釈を普及させる方がよいと思われる.

__補足:__ 上で引用した論文の著者のLehmann氏([Erich Leo Lehmann (1917-2009)](https://en.wikipedia.org/wiki/Erich_Leo_Lehmann)はNeyman氏の弟子の有名な統計学者である. 

__補足:__ このノートでは「検定の手続きが1か0かの最終的判断を強いる」という極端な解釈を「統計学は科学的お墨付きを得るための手段ではない」という言い方でも明瞭に否定している.

__補足:__ このノートで採用したP値を「仮説 $\theta=\theta_0$ 下の統計モデルとデータの数値 $x$ の整合性の指標」とみなす考え方はFisherの有意性検定の考え方に近いように思われる. そして, それと同時に, Neyman-Pearson的に対立仮説の検出力も重要であるという立場も採用している(その縛り抜きには無意味な検定法を排除できない). 

__補足:__ P値に関する「第一種の過誤の確率が有意水準 $\alpha$ に近い方がよい」という基準は「検出力が高い方がよい」という基準と密接に関係している. 実際, 保守的過ぎる検定法は検出力が低くなってしまいがちである.

__補足:__ この一連のノート群では, 数学的な道具の使い方はユーザーが自分の目的に合わせて自由に決めればよいという立場も採用している.  ただし, その使い方は普通の常識的な意味で科学的に合理的なければいけない.


### このノートの立場

検定の手続きは, 例えば, 「薬Aに効果はない」というような仮説をモデルのパラメータに関する仮説 $\theta = 0$ で代替し, 「薬Aに効果はない」という仮説は疑わしい(もしくは誤りである)という結論を出したい状況で使われていること多い.

そのとき「薬Aに効果はない」のような否定したい特別な仮説が帰無仮説と呼ばれることになり, 仮説 $\theta = 0$ の $0$ という値は特別な意味を持つものとして固定されていることが多い.

しかし, __このノートでは, 検定にかけられる仮説 $\theta=\theta_0$ を定めるパラメータ値 $\theta_0$ は1つに固定されておらず, 任意の値を取り得ることを強調し, 可能なすべての $\theta_0$ に関する検定の手続きによって信頼区間を定義している.__

すなわち, このノートにおける信頼度 $1-\alpha$ 信頼区間の定義は, 仮説 $\theta = \theta_0$ がデータの数値 $x$ による有意水準 $\alpha$ の検定の手続きで棄却されないような数値 $\theta_0$ 全体の集合だとしている.

このスタイルの利点は, __信頼区間は, 「薬Aに効果はない」という仮説だけではなく, 任意の値 $\theta_0$ に関する「薬Aの効果は $\theta_0$ である」という仮説の検定結果の情報もすべて含んでいる__ ことが最初から明らかになることである.

信頼区間を見れば以下のような情報が得られる:

* $a$ より小さな値を信頼区間は含まないので, 薬Aの効果は概ね $a$ 以上だと考えてよさそうだ.
* 信頼区間は $0$ を含んでいるので, データの数値 $x$ からは薬Aの効果の有無はわからなかった. (注意:「効果はない」と判断するのは誤り.)
* $a$ より大きな値を信頼区間は含まないので, 薬Aの効果は概ね $a$ 以下だと考えてよさそうだ.

このようなことが可能になったのは, 検定にかける仮説 $\theta = \theta_0$ の $\theta_0$ を自由に動かせる設定を採用したからである.

信頼区間は有意水準 $\alpha$ という閾値を設定することによって定義される. 

しかし, $\alpha = 5\%$ のような慣習化された有意水準をP値が下回るか否かに一喜一憂するというような愚行に警戒する必要が生じてしまった.

この人為的な閾値の設定に関わる問題について, このノートではP値函数について紹介することによって対処したつもりである.

データの数値 $x$ が与えられたとき, パラメータ値 $\theta_0$ に対して, 仮説 $\theta=\theta_0$ のP値を対応させる函数をP値函数と呼ぶのであった.

信頼度 $1-\alpha$ の信頼区間の定義は, P値函数の値が有意水準以上になるパラメータ値 $\theta_0$ 全体の集合なので, P値函数のグラフを描けば視覚的に信頼区間がどうなるかも確認できる. 

すなわち, P値函数のグラフはすべての信頼度 $1-\alpha$ に関する信頼区間の情報を持っている.

ゆえに, P値函数のグラフを描けば, 有意水準 $\alpha$ を固定せずに, 統計モデルのパラメータ値とデータの数値の整合性(P値が小さいほど整合性が低い)を確認できる. 

__P値函数のグラフを利用すれば, 有意水準を設定しなくても, そこから科学的に有益な情報を引き出すことが可能である.__

この考え方はRothman氏達の有名な疫学の教科書 Modern Epidemiology でも紹介されている.

P値函数のグラフは, ある特定の信頼度(例えば $95\%$) に関する信頼区間よりも, 圧倒的に豊富な情報を持っている. まず, 信頼度を自由に変えられる.  さらに, P値函数が最大になるパラメータ値は, 統計モデルがデータの数値に最もフィットするようなパラメータ値だと解釈される. 実際, それは多くの場合に最尤推定値またはそれに近い値になっている.

P値函数がどういうものだったか忘れた人のために以下に二項分布モデルのP値函数のグラフを以下に掲載しておこう.  P値函数のグラフは多くの場合に以下の図のように「とんがり帽子」のような形になる. そしてその「とんがり帽子」の幅が概ね信頼区間の幅に対応している.

```julia
plot_binom_pvaluefunctions(; n = 50, k = 15)
```

P値函数のグラフの例とR言語による描き方に関する解説が以下の場所にある:

* Denis Infanger, P-value functions: Tutorial using the pvaluefunctions package, 2021-11-30. \[[link](https://cran.r-project.org/web/packages/pvaluefunctions/vignettes/pvaluefun.html)\]
* Plot a P-value Function from one or two Confidence Intervals. \[[link](https://epijim.shinyapps.io/episheet_shiny/)\]

以下のリンク先も面白い.

* https://twitter.com/ken_rothman/status/1258552231286063106
* https://twitter.com/MinatoNakazawa/status/656235447220224000
* https://twitter.com/MinatoNakazawa/status/1202738229180416000
* https://twitter.com/MinatoNakazawa/status/1202893936181645312


<span style="font-size: 100%; color: red;">__今後の目標: データ $x$ とパラメータ値 $\theta=\theta_0$ に対してP値を対応させる函数 $\op{pvalue}(x|\theta=\theta_0)$ の例を構成して利用すること.__</span>


## よくある誤解


### P値の定義と使い方の復習

現実世界から得るデータ $x$ の生成のされ方に関するパラメータ $\theta$ を持つ統計モデルが与えられているとき, データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値は

* 仮説 $\theta = \theta_0$ 下の統計モデル内部でデータの数値 $x$ 以上に極端な値が生成される確率もしくはその近似値

と定義されるのであった. (「数値 $x$ 以上に極端な値」の意味は別に定義しなければいけない.)

そして, そのようにして計算されるP値は, __仮説 $\theta = \theta_0$ 下の統計モデルとデータの数値の整合性の指標__ として使われ, 適当な閾値(有意水準)を設けて, P値が小さすぎる場合には「整合性がない」と判定するのであった(これが検定の手続き).


### 問題: P値に関するよくある誤解

データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値を以下では単にP値と呼ぶことにする.

以下の主張の中で誤解であるものをすべて挙げよ.

(1) P値は現実世界において仮説 $\theta=\theta_0$ が正しい確率である.

(2) 検定の手続きでは, P値が有意水準より小さいときには, 仮説 $\theta=\theta_0$ は科学的に疑わしいと考える.

(3) 検定の手続きでは, P値が有意水準以上のときには, 仮説 $\theta=\theta_0$ は科学的に肯定されたと考える.

(4) P値が小さい結果ほど重要な結果である.

正しい主張を誤解だとみなさないように注意して欲しい.

この問題の解答例はこのノートの最後の方に掲載する.


### 信頼区間の定義の復習と使い方の復習

データの数値 $x$ が与えられたとき, 有意水準 $\alpha$ の検定の手続きによって棄却されないパラメータ値 $\theta=\theta_0$ 全体の集合を, パラメータ $\theta$ に関する信頼度 $1-\alpha$ の信頼区間と呼ぶのであった.  $\alpha=5\%$ のときには $95\%$ 信頼区間と呼ばれる.


### 問題: 信頼区間に関するよく見る誤解

以下の主張が誤りもしくは杜撰である理由を説明せよ.

(1) $95\%$ 信頼区間の $95\%$ は確率ではなく, 割合である.

(2) 平均値の $95\%$ 信頼区間について考える. このとき, 現実の母集団からの無作為抽出を繰り返して, 平均値の $95\%$ 信頼区間を計算し直すとき, 現実の母集団の平均値を含む区間達の割合は $95\%$ になる.

この問題の解答例はこのノートの最後に掲載する.


### 平均の信頼区間達の視覚化

後で別のノートで解説する予定の正規分布の標本分布モデルと $t$ 分布を用いて計算される平均の信頼区間を正規分布の標本達および正規分布以外の分布の標本達についてプロットしてみよう.

```julia
Random.seed!(4649373)
```

#### 正規分布の標本達から得られる平均の信頼区間達

標本(データ)を生成する分布が正規分布の場合は, 信頼区間を計算するために用いる統計モデルで標本の生成のされ方がぴったり記述可能な場合になっている. 

これは実践的な統計分析においては非現実的な想定である.

この場合には理論通りの結果がそのまま成立している.

```julia
dist = Normal(2, 3)
@show μ, σ = mean(dist), std(dist)
plot(dist, μ-4σ, μ+4σ; label="", title="$(distname(dist))",
    xtick=-100:2:100)
```

以下のセルでは正規分布 $\op{Normal}(2, 3)$ のサイズ $n=30$ の標本を200個ランダムに生成し, その各々について平均の $95\%$ 信頼区間を計算してプロットしている.

橙色でプロットされている $95\%$ 信頼区間は標本を生成した分布の平均値を含まない信頼区間である.

標本を生成した分布の平均値を含まない $95\%$ 信頼区間の割合は $5\%$ であって欲しい.

```julia
illustrate_confintmean(; dist, n = 30)
```

```julia
sim_ttest(; dist, n = 30, L = 10^6)(0.05)
```

以下のセルでは正規分布 $\op{Normal}(2, 3)$ のサイズ $n=30$ の標本を100万個ランダムに生成し, 信頼度 $1-\alpha$ 信頼区間に標本を生成した分布の平均値が含まれない確率(＝割合)を計算している.

その割合は $\alpha$ であって欲しい.

この場合には実際にぴったり $\alpha$ になっている.

```julia
plot_sim_ttest(; dist, n = 30, L = 10^6)
```

#### ガンマ分布の標本から得られる平均の信頼区間達

標本(データ)を生成する分布が左右非対称なガンマ分布 $\op{Gamma}(3,4)$ の場合には, 平均の信頼区間を構成するために使った正規分布とは異なる種類の分布で標本を生成しているので, 誤差が生じることになる.

その誤差がどの程度であるかに注目して以下のグラフ達を眺めて欲しい.

```julia
dist = Gamma(3, 4)
@show μ, σ = mean(dist), std(dist)
plot(dist, -1, 50; label="", title="$(distname(dist))")
```

以下のセルではガンマ分布 $\op{Gamma}(3, 4)$ のサイズ $n=30$ の標本を200個ランダムに生成し, その各々について平均の $95\%$ 信頼区間を計算してプロットしている.

橙色でプロットされている $95\%$ 信頼区間は標本を生成した分布の平均値を含まない信頼区間である.

標本を生成した分布の平均値を含まない $95\%$ 信頼区間の割合は $5\%$ であって欲しいが, この場合にはその割合は $5.8\%$ 程度で $5\%$ より少し大きい.

```julia
illustrate_confintmean(; dist, n = 30)
```

```julia
sim_ttest(; dist, n = 30, L = 10^6)(0.05)
```

以下のセルではガンマ分布 $\op{Gamma}(3, 4)$ のサイズ $n=30$ の標本を100万個ランダムに生成し, 信頼度 $1-\alpha$ 信頼区間に標本を生成した分布の平均値が含まれない確率(＝割合)を計算している.

その割合は $\alpha$ であって欲しい.

この場合にその割合は $\alpha$ より少し大きな値になってしまっている.

```julia
plot_sim_ttest(; dist, n = 30, L = 10^6)
```

#### 対数正規分布の標本達から得られる平均の信頼区間達

標本(データ)を生成する分布が左右非対称でかつ非常に大きな値が生成され易い対数正規分布 $\op{LogNormal}(0,1)$ の場合には, 非常に大きな誤差が生じることになる.

```julia
dist = LogNormal()
@show μ, σ = mean(dist), std(dist)
plot(dist, -0.2, 10.2; label="", title="$(distname(dist))")
```

以下のセルでは対数正規分布 $\op{LogNormal}(0,1)$ のサイズ $n=30$ の標本を200個ランダムに生成し, その各々について平均の $95\%$ 信頼区間を計算してプロットしている.

橙色でプロットされている $95\%$ 信頼区間は標本を生成した分布の平均値を含まない信頼区間である.

標本を生成した分布の平均値を含まない $95\%$ 信頼区間の割合は $5\%$ であって欲しいが, この場合にはその割合は $12\%$ 弱程度で $5\%$ より非常に大きい.

正規分布の標本分布モデルと $t$ 分布を使った平均に関する検定や信頼区間は小さな確率で極端な値が生じる分布(外れ値を持つ分布)の標本については誤差が大きくなり易いので注意を要する.

```julia
illustrate_confintmean(; dist, n = 30)
```

```julia
sim_ttest(; dist, n = 30, L = 10^6)(0.05)
```

以下のセルでは対数正規分布 $\op{LogNormal}(0, 1)$ のサイズ $n=30$ の標本を100万個ランダムに生成し, 信頼度 $1-\alpha$ 信頼区間に標本を生成した分布の平均値が含まれない確率(＝割合)を計算している.

その割合は $\alpha$ であって欲しい.

この場合にその割合は $\alpha$ よりもずっと大きな値になってしまっている.

```julia
plot_sim_ttest(; dist, n = 30, L = 10^6)
```

サンプルサイズ $n$ を大きくすると誤差は小さくなる.

```julia
plot_sim_ttest(; dist, n = 100, L = 10^6)
```

```julia
plot_sim_ttest(; dist, n = 1000, L = 10^6)
```

### 問題解答例: P値に関するよくある誤解

(1) P値は現実世界において仮説 $\theta=\theta_0$ が正しい確率である.

(2) 検定の手続きでは, P値が有意水準より小さいときには, 仮説 $\theta=\theta_0$ は科学的に疑わしいと考える.

(3) 検定の手続きでは, P値が有意水準以上のときには, 仮説 $\theta=\theta_0$ は科学的に肯定されたと考える.

(4) P値が小さい結果ほど重要な結果である.

はすべて誤りである. 各々についてコメントしておこう.

(1) P値の定義と全然違う. P値の定義は「仮説 $\theta=\theta_0$ 下の統計モデル内でデータの数値以上に極端な値が生じる確率またはその近似値」であった.

P値は「データの数値と仮説 $\theta=\theta_0$ 下の統計モデルの整合性の指標」として使われる.  統計モデル全体とデータの整合性を見ているのであり, 仮説 $\theta=\theta_0$ 単体との整合性を見ているのではない.

(2) 検定の手続きで, P値が有意水準より小さいときには, 仮説 $\theta=\theta_0$ だけが疑わしいと考えるのではなく, 統計モデルの前提の全体のどれかも疑わしいと考える必要がある.

(3) 検定の手続きで, P値が有意水準以上になった場合には, 仮説 $\theta=\theta_0$ 下での統計モデルの現実における妥当性に関する判断を保留する(否定も肯定もしない).

(4) 例えば, ある薬の効果について, 巨大なサイズのデータによって非常に小さなP値が得られたとする.

しかし, 存在することが確からしいその効果は実生活においてほとんど無視できるほど小さなものだったとする.

そのような場合にはP値が小さくても重要な結果が得られたとは言えない.

薬の効果について統計分析をする場合には, P値だけではなく, 効果の大きさの指標にも注意を払う必要がある.

__解答終__


### 問題解答例: 信頼区間に関するよく見る誤解

(1) $95\%$ 信頼区間の $95\%$ は確率ではなく, 割合である.

(2) 平均値の $95\%$ 信頼区間について考える. このとき, 現実の母集団からの無作為抽出を繰り返して, 平均値の $95\%$ 信頼区間を計算し直すとき, 現実の母集団の平均の真の値を含む区間達の割合は $95\%$ になる.

はどちらも誤りもしくは杜撰な考え方である.

(1) 仮説 $\theta = \theta_0$ 下の統計モデル内部で生成された仮想的なデータの数値(確率変数になる)に関するパラメータ $\theta$ に関する $95\%$ 信頼区間に $\theta_0$ が含まれる確率は $95\%$ またはそれに近い値になる.

このように $95\%$ 信頼区間の $95\%$ は統計モデル内部での確率になっていると解釈される. ゆえに「確率ではない」と言ってしまうと自明に誤りになる.

ただし, 確率的に揺らぐのはデータを生成するために使われたパラメータ値 $\theta = \theta_0$ ではなく, そのパラメータ値を使って生成されたデータの値とそれを使って計算される信頼区間である.  固定されている値 $\theta_0$ が確率的に様々に変化する $95\%$ 信頼区間に含まれる確率が $95\%$ またはそれに近い値になる.

(2) 現実の母集団の未知の平均値を $\mu_{\op{real}}$ と書くことにする.  もしも平均値の信頼区間を定義するために使った統計モデルで平均値パラメータを $\mu = \mu_{\op{real}}$ とおくことによって得られる確率分布が現実の母集団の分布をよく近似していれば, 問題文の(2)の主張は確かは正しい.

しかし, 数学的フィクションである統計モデルが現実の母集団の分布をよく近似しているという仮定が成立しているは限らない. 成立していない場合には(2)の主張も成立しているとは限らない.

この問題中の(1),(2)の誤解の背景には現実とモデルの混同が隠れていると考えられる.

__解答終__

```julia

```
