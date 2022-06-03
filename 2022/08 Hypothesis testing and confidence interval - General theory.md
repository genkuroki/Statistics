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
* 2022-05-31～2022-06-03

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
<div class="toc"><ul class="toc-item"><li><span><a href="#お勧め解説動画とお勧め文献" data-toc-modified-id="お勧め解説動画とお勧め文献-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>お勧め解説動画とお勧め文献</a></span><ul class="toc-item"><li><span><a href="#お勧め解説動画" data-toc-modified-id="お勧め解説動画-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>お勧め解説動画</a></span></li><li><span><a href="#お勧め文献:-P値に関するASA声明" data-toc-modified-id="お勧め文献:-P値に関するASA声明-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>お勧め文献: P値に関するASA声明</a></span></li></ul></li><li><span><a href="#まとめ" data-toc-modified-id="まとめ-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>まとめ</a></span><ul class="toc-item"><li><span><a href="#P値" data-toc-modified-id="P値-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>P値</a></span></li><li><span><a href="#検定" data-toc-modified-id="検定-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>検定</a></span></li><li><span><a href="#信頼区間" data-toc-modified-id="信頼区間-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>信頼区間</a></span></li><li><span><a href="#nuisanceパラメータがある場合" data-toc-modified-id="nuisanceパラメータがある場合-2.4"><span class="toc-item-num">2.4&nbsp;&nbsp;</span>nuisanceパラメータがある場合</a></span></li></ul></li><li><span><a href="#P値の定義" data-toc-modified-id="P値の定義-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>P値の定義</a></span><ul class="toc-item"><li><span><a href="#統計モデルの設定" data-toc-modified-id="統計モデルの設定-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>統計モデルの設定</a></span></li><li><span><a href="#P値の定義" data-toc-modified-id="P値の定義-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>P値の定義</a></span></li><li><span><a href="#データの数値以上に極端な値の定義の仕方" data-toc-modified-id="データの数値以上に極端な値の定義の仕方-3.3"><span class="toc-item-num">3.3&nbsp;&nbsp;</span>データの数値以上に極端な値の定義の仕方</a></span><ul class="toc-item"><li><span><a href="#例(二項分布モデル)の場合" data-toc-modified-id="例(二項分布モデル)の場合-3.3.1"><span class="toc-item-num">3.3.1&nbsp;&nbsp;</span>例(二項分布モデル)の場合</a></span></li><li><span><a href="#例(正規分布の標本分布モデル)の場合" data-toc-modified-id="例(正規分布の標本分布モデル)の場合-3.3.2"><span class="toc-item-num">3.3.2&nbsp;&nbsp;</span>例(正規分布の標本分布モデル)の場合</a></span></li></ul></li><li><span><a href="#P値は帰無仮説下の統計モデルのデータの数値との整合性の指標" data-toc-modified-id="P値は帰無仮説下の統計モデルのデータの数値との整合性の指標-3.4"><span class="toc-item-num">3.4&nbsp;&nbsp;</span>P値は帰無仮説下の統計モデルのデータの数値との整合性の指標</a></span></li><li><span><a href="#第一種の過誤(αエラー)の確率" data-toc-modified-id="第一種の過誤(αエラー)の確率-3.5"><span class="toc-item-num">3.5&nbsp;&nbsp;</span>第一種の過誤(αエラー)の確率</a></span></li><li><span><a href="#二項分布モデルの4種のP値に関する第一種の過誤の確率のグラフ" data-toc-modified-id="二項分布モデルの4種のP値に関する第一種の過誤の確率のグラフ-3.6"><span class="toc-item-num">3.6&nbsp;&nbsp;</span>二項分布モデルの4種のP値に関する第一種の過誤の確率のグラフ</a></span></li></ul></li><li><span><a href="#P値を使った検定" data-toc-modified-id="P値を使った検定-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>P値を使った検定</a></span></li><li><span><a href="#P値函数を使った信頼区間" data-toc-modified-id="P値函数を使った信頼区間-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>P値函数を使った信頼区間</a></span></li><li><span><a href="#信頼区間と検定の表裏一体性" data-toc-modified-id="信頼区間と検定の表裏一体性-6"><span class="toc-item-num">6&nbsp;&nbsp;</span>信頼区間と検定の表裏一体性</a></span><ul class="toc-item"><li><span><a href="#検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合" data-toc-modified-id="検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合-6.1"><span class="toc-item-num">6.1&nbsp;&nbsp;</span>検定における棄却領域の合併と信頼区間全体の合併は互いに相手の補集合</a></span></li><li><span><a href="#仮説-$\theta=\theta_0$-下の統計モデル内でパラメータ値-$\theta=\theta_0$-が信頼区間に含まれる確率" data-toc-modified-id="仮説-$\theta=\theta_0$-下の統計モデル内でパラメータ値-$\theta=\theta_0$-が信頼区間に含まれる確率-6.2"><span class="toc-item-num">6.2&nbsp;&nbsp;</span>仮説 $\theta=\theta_0$ 下の統計モデル内でパラメータ値 $\theta=\theta_0$ が信頼区間に含まれる確率</a></span></li><li><span><a href="#二項分布モデルでのP値函数の視覚化" data-toc-modified-id="二項分布モデルでのP値函数の視覚化-6.3"><span class="toc-item-num">6.3&nbsp;&nbsp;</span>二項分布モデルでのP値函数の視覚化</a></span></li></ul></li><li><span><a href="#統計モデルやP値函数が「よい」かどうかの判断基準達" data-toc-modified-id="統計モデルやP値函数が「よい」かどうかの判断基準達-7"><span class="toc-item-num">7&nbsp;&nbsp;</span>統計モデルやP値函数が「よい」かどうかの判断基準達</a></span><ul class="toc-item"><li><span><a href="#計算方法はシンプルな方がよい" data-toc-modified-id="計算方法はシンプルな方がよい-7.1"><span class="toc-item-num">7.1&nbsp;&nbsp;</span>計算方法はシンプルな方がよい</a></span></li><li><span><a href="#頑健な方がよい" data-toc-modified-id="頑健な方がよい-7.2"><span class="toc-item-num">7.2&nbsp;&nbsp;</span>頑健な方がよい</a></span></li><li><span><a href="#第一種の過誤の確率は有意水準に近い方がよい" data-toc-modified-id="第一種の過誤の確率は有意水準に近い方がよい-7.3"><span class="toc-item-num">7.3&nbsp;&nbsp;</span>第一種の過誤の確率は有意水準に近い方がよい</a></span></li><li><span><a href="#第一種の過誤の確率は有意水準以下である方がよい" data-toc-modified-id="第一種の過誤の確率は有意水準以下である方がよい-7.4"><span class="toc-item-num">7.4&nbsp;&nbsp;</span>第一種の過誤の確率は有意水準以下である方がよい</a></span></li><li><span><a href="#検出力は高い方がよい" data-toc-modified-id="検出力は高い方がよい-7.5"><span class="toc-item-num">7.5&nbsp;&nbsp;</span>検出力は高い方がよい</a></span></li></ul></li><li><span><a href="#Neyman-Pearsonの統計的検定" data-toc-modified-id="Neyman-Pearsonの統計的検定-8"><span class="toc-item-num">8&nbsp;&nbsp;</span>Neyman-Pearsonの統計的検定</a></span><ul class="toc-item"><li><span><a href="#パラメータを持たない2つの統計モデルに関する統計的検定" data-toc-modified-id="パラメータを持たない2つの統計モデルに関する統計的検定-8.1"><span class="toc-item-num">8.1&nbsp;&nbsp;</span>パラメータを持たない2つの統計モデルに関する統計的検定</a></span></li><li><span><a href="#Neyman-Pearsonの補題" data-toc-modified-id="Neyman-Pearsonの補題-8.2"><span class="toc-item-num">8.2&nbsp;&nbsp;</span>Neyman-Pearsonの補題</a></span></li><li><span><a href="#Neyman-Pearsonの補題の証明" data-toc-modified-id="Neyman-Pearsonの補題の証明-8.3"><span class="toc-item-num">8.3&nbsp;&nbsp;</span>Neyman-Pearsonの補題の証明</a></span></li><li><span><a href="#尤度比検定の例:-正規分布モデルの場合" data-toc-modified-id="尤度比検定の例:-正規分布モデルの場合-8.4"><span class="toc-item-num">8.4&nbsp;&nbsp;</span>尤度比検定の例: 正規分布モデルの場合</a></span></li></ul></li><li><span><a href="#よくある誤解" data-toc-modified-id="よくある誤解-9"><span class="toc-item-num">9&nbsp;&nbsp;</span>よくある誤解</a></span><ul class="toc-item"><li><span><a href="#P値の定義と使い方の復習" data-toc-modified-id="P値の定義と使い方の復習-9.1"><span class="toc-item-num">9.1&nbsp;&nbsp;</span>P値の定義と使い方の復習</a></span></li><li><span><a href="#問題:-P値に関するよくある誤解" data-toc-modified-id="問題:-P値に関するよくある誤解-9.2"><span class="toc-item-num">9.2&nbsp;&nbsp;</span>問題: P値に関するよくある誤解</a></span></li><li><span><a href="#信頼区間の定義の復習と使い方の復習" data-toc-modified-id="信頼区間の定義の復習と使い方の復習-9.3"><span class="toc-item-num">9.3&nbsp;&nbsp;</span>信頼区間の定義の復習と使い方の復習</a></span></li><li><span><a href="#問題:-信頼区間に関するよく見る誤解" data-toc-modified-id="問題:-信頼区間に関するよく見る誤解-9.4"><span class="toc-item-num">9.4&nbsp;&nbsp;</span>問題: 信頼区間に関するよく見る誤解</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia
ENV["LINES"], ENV["COLUMNS"] = 100, 100
using Base.Threads
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
    P1 = plot(x, x->F_clopper_pearson(x); label="", title="Clopper-Pearson", c=1)
    plot!(x, x; label="", ls=:dot, c=:black)
    P2 = plot(x, x->F_sterne(x); label="", title="Sterne", c=2)
    plot!(x, x; label="", ls=:dot, c=:black)
    P3 = plot(x, x->F_wilson(x); label="", title="Wilson", c=3)
    plot!(x, x; label="", ls=:dot, c=:black)
    P4 = plot(x, x->F_wald(x); label="", title="Wald", c=4)
    plot!(x, x; label="", ls=:dot, c=:black)
    
    plot(P1, P2, P3, P4; size=(700, 720), layout=(2,2))
    plot!(; xtick=0:0.1xmax:1, ytick=0:0.1xmax:1, tickfontsize=7)
    plot!(; xlim=(-0.02xmax, 1.02xmax), ylim=(-0.02xmax, 1.02xmax))
    plot!(; xguide="significance level α", yguide="probability of type I error")
    plot!(; plot_title="n = $n, p = p₀ = $p", plot_titlefontsize=12)
end
```

## お勧め解説動画とお勧め文献


### お勧め解説動画

P値と検定と信頼区間については次のリンク先の動画での解説が素晴らしいので, 閲覧を推奨する:

* 京都大学大学院医学研究科 聴講コース<br>臨床研究者のための生物統計学「仮説検定とP値の誤解」<br>佐藤 俊哉 医学研究科教授<br>[https://youtu.be/vz9cZnB1d1c](https://youtu.be/vz9cZnB1d1c)

信頼区間の解説は40分あたり以降にある.  多くの入門的な解説が抱えているP値, 検定, 信頼区間の解説の難点は以下の2つに要約される:

* 複雑な現実と統計モデルを混同させるような解説が伝統的に普通になってしまっていること.
* 検定と信頼区間の表裏一体性(双対性)が解説されていないこと.

このことが原因がP値も $95\%$ 信頼区間の $95\%$ も数学的フィクションである統計モデル内での確率であることがクリアに説明されておらず, そのせいでP値と $95\%$ 信頼区間の $95\%$ についてまっとうな理解が得られ難くなっている.  上で紹介した動画は教科書の説明がまずいことについて明瞭に言及しながら, 伝統的な入門的解説が抱えている問題を解消しようとしている.

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

という説明における「データ」という用語の意味の解釈には注意を要する.  この意味での「データ」は現実世界での観察で得たデータのことではなく, 統計モデル内で生成された仮想的なデータのことである. 

現実世界で得たデータは決まった数値になるが, 数学的フィクションである統計モデル内で生成されたデータは確率変数とみなせ, それが現実世界での観察で得たデータの数値以上の極端な値を取る確率を考えることができる.

統計学は, 現実世界でデータを得る活動と数学的世界で統計モデルを考えることを行ったり来たりするので, 現実とモデルを混同しないように注意しなければいけない.

P値は現実において常に意味を持つ確率またはその近似値ではなく, 数学的フィクションである統計モデル内部で測った確率に過ぎない.


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

__有意水準__ (significance level)と呼ばれる閾値(いきち, しきいち) $0<\alpha<1$ が与えられたとき, P値が $\alpha$ 未満ならば, 

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

__信頼区間__ (confidence interval)の文脈で $1 - \alpha$ は __信頼度__ (信頼係数, 信頼水準, confidence level)と呼ばれる.

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

「仮説 $\theta=\theta_0$ 下の統計モデル内におけるデータの数値 $x$ 以上に極端な値」の定義は目的ごとに別に与えられる.  その概略については後の方の説明を参照せよ.

__補足:__ 「$x$ が $x'$ 以上に極端な値である」という条件は __反射性__(reflexivity)と __推移性__ (transitivity)と __比較可能性__(comparability)の3つの条件を満たしていることを要請する. すなわち「$x$ が $x'$ 以上に極端な値である」ことを $x\succcurlyeq x'$ と書くと, 以下が成立していると仮定する:

* 反射性(reflexibity): $x \succcurlyeq x$,
* 推移性(transitivity): $x \succcurlyeq x'$ and $x' \succcurlyeq x''$ $\implies$ $x \succcurlyeq x''$,
* 比較可能性(comparability): $x \succcurlyeq x'$ or $x' \succcurlyeq x$.


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
\chi^2 = \sum \frac
{(\text{現実における観測値} - \text{帰無仮説下の統計モデル内での期待値})^2}
{\text{帰無仮説下の統計モデル内での期待値}}
$$

の特別な場合に過ぎない. 上の場合に「現実における観測地」は $n$ 回中の成功回数 $k$ と失敗回数 $n-k$ であり, 「帰無仮説下の統計モデル内での期待値」は成功回数の期待値 $np_0$ と失敗回数の期待値 $n(1-p_0)$ である.  (より進んだ注意: Pearsonのχ²統計量はスコア検定における検定統計量になっている.)

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

これが便利なのは, 仮説 $\mu = \mu_0$ の下での正規分布の標本分布モデル内で, __分散パラメータ $\sigma^2$ がどんな値であっても,__  $T(x|\mu_0)$ に対応する確率変数が自由度 $n-1$ の $t$ 分布に従うからである.

__注意:__ 統計モデルが $\theta$ 以外にパラメータ $\eta$ を持っていて, 帰無仮説 $\theta=\theta_0$ を課しても, パラメータ $\eta$ の分だけ統計モデルの確率分布が唯一つに決まらないとき, $\eta$ を __nuisanceパラメータ__  (ニューサンスパラメータ, 局外パラメータ,　撹乱パラメータ, 迷惑パラメータ)と呼ぶ.  上の例では分散パラメータ $\sigma^2$ がnuisanceパラメータになっている.  そして, 上の例はnuisanceパラメータの問題をシンプルに解決できる稀有な場合になっている.


### P値は帰無仮説下の統計モデルのデータの数値との整合性の指標

__データの数値 $x$ から計算される帰無仮説 $\theta = \theta_0$ のP値は __仮説 $\theta=\theta_0$ 下の統計モデルとデータの数値 $x$ の整合性の指標である__.

P値が小さいことは, 仮説 $\theta=\theta_0$ 下の統計モデルとデータの数値 $x$ があまり整合していないと考える.

これがP値の基本的な使い方である.


### 第一種の過誤(αエラー)の確率

$X$ はパラメータの数値が $\theta=\theta_0$ の統計モデルに従う確率変数であると仮定する.

データの数値がその確率変数 $X$ の値であるときの仮説 $\theta = \theta_0$ のP値が有意水準 $\alpha$ 未満になる確率を仮説 $\theta = \theta_0$ に関する __第一種の過誤の確率__ または __αエラーの確率__ と呼ぶ.

すなわち, 仮説 $\theta = \theta_0$ 下の統計モデル内部において, 同一の仮説 $\theta = \theta_0$ が検定の手続きで棄却されてしまうことを __第一種の過誤__ と呼び, その確率を __第一種の過誤の確率__ と呼ぶ.

第一種の過誤は検定する仮説 $\theta=\theta_0$ が成立しているモデル内部においてその仮説が棄却されてしまうことを意味しており, その確率は小さい方がよい.  しかし, 第一種の過誤の確率を小さくすることが原因で生じる害(後で述べる検出力の低下)もあるので, 目的に合わせてバランスを取ることが必要である.

__注意:__ 第一種の過誤は「無実のものを有罪にしてしまう誤り」に例えられることがある.

__注意:__ 第一種の過誤は統計モデルが自分自身を確率的に否定してしまうことであると言うこともできる.

__注意:__ 現実世界から得たデータの数値 $x$ は値が確定した定数だが, 数学的フィクションである統計モデル内ではデータの数値が確率変数 $X$ としてランダムに生成されていると考えることができる.  多くの教科書でこの辺について誤解に誘導するような説明があるので注意して欲しい.

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


### 二項分布モデルでのP値函数の視覚化

__文献:__ P値函数の使い方については次の文献が詳しい:

* Timothy L. Lash, Tyler J. VanderWeele, Sebastien Haneuse, and Kenneth J. Rothman.<br>Modern Epidemiology, 4th edition, 2020. [Google](https://www.google.com/search?q=Modern+Epidemiology+4th)

第4版よりも古い版でもよい.

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

function gif_bintest(; n = 20, fn = "images/pvaluefunction20.gif", fps = 5, step=1)
    anim = @animate for k in [0:step:n; n-1:-step:1]
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
    gif(anim, fn; fps)
end
```

```julia
gif_bintest()
```

```julia
gif_bintest(n = 100, fn = "images/pvaluefunction100.gif", fps=20)
```

PDFファイルではこの動画を見ることはできない.  作成した動画は

* https://github.com/genkuroki/Statistics/blob/master/2022/images/pvaluefunction20.gif
* https://github.com/genkuroki/Statistics/blob/master/2022/images/pvaluefunction100.gif

でも見ることができる.

```julia
# pvalue(x|p) 達のヒートマップ (明るい所ほど値が大きい)

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
plot_sim_binomtest(1000, 0.01; xmax=0.1, L=10^6)
```

### 第一種の過誤の確率は有意水準以下である方がよい

「第一種の過誤の確率は有意水準以下である方がよい」という基準のことを __保守性__ (conservativity)と呼ぶことがある.

上の例では, Clopper-Pearsonの信頼区間を与えるP値とSterneの信頼区間を与えるP値では, 第一種の過誤の確率が常に有意水準以下になり, __保守的__ (conservative)である.  しかし, Wilsonの信頼区間を与えるP値とWaldの信頼区間を与えるP値はその意味で保守的ではない(__リベラル__ (liberal)ということがある).


### 検出力は高い方がよい

大雑把に言うと, 仮説 $\theta=\theta_0$ のP値の __検出力__ (power)はその仮説 $\theta=\theta_0$ と別の仮説 $\theta=\theta_1$ との分解能を意味する.

その文脈で別の仮説 $\theta=\theta_1$ を帰無仮説 $\theta=\theta_0$ の __対立仮説__ (alternative hypothesis)と呼ぶ.

帰無仮説 $\theta=\theta_0$ のP値の対立仮説 $\theta=\theta_1 (\ne\theta_0)$ に対する __検出力__ (power)は

* 対立仮説 $\theta=\theta_1$ 化の統計モデル内部で帰無仮説 $\theta=\theta_0$ のP値が有意水準 $\alpha$ 未満になる確率

と定義される.  すなわち, 

* $X$ を対立仮説 $\theta=\theta_1$ 化の統計モデルに従う確率変数とし, データの数値を $X$ としたとき仮説 $\theta=\theta_0$ が有意水準 $\alpha$ で棄却される確率

をそのように呼ぶ.  

有意水準が等しいなら, 検出力は高い方がよい. 

可能ならば任意の $\theta_1$ についてそうであって欲しいがそのようにすることは一般には不可能である. 

検出力については次の節も参照せよ.


## Neyman-Pearsonの統計的検定


### パラメータを持たない2つの統計モデルに関する統計的検定

データ $x$ の生成のされ方に関するパラメータを持たない(もしくはすべてのパラメータの値が固定された)統計モデルが2つ与えられているとする.

簡単のために2つの統計モデルはそれぞれ確率密度函数 $p_0(x)$, $p_1(x)$ によって与えられているとする.

有意水準 $0\le\alpha\le 1$ について, 棄却領域と呼ばれれる $x$ の集合 $R_\alpha$ が与えられており, 統計モデル $p_0(x)$ に従う確率変数 $X_0$ について,

$$
P(X_0 \in R_\alpha) \le \alpha
$$

が成立していると仮定する.

このとき, 棄却領域 $R_\alpha$ によって有意水準 $\alpha$ の検定法が与えられたと言い, データの数値 $x$ が $R_\alpha$ に含まれるときに, 統計モデル $p_0(x)$ が棄却されたと言う.

以下では, 統計モデル $p_0(x)$ を帰無仮説と呼び, 統計モデル $p_1(x)$ を対立仮説と呼ぶことにする.

以上の設定において, $R_\alpha$ で与えられた帰無仮説 $p_0(x)$ の検定法における対立仮説 $p_1(x)$ の検出力 $\op{power}(R_\alpha)$ を, 対立仮説 $p_1(x)$ に従う確率変数 $X_1$ を使って次のように定める:

$$
\op{power}(R_\alpha) = P(X_1 \in R_\alpha).
$$

検出力が高い検定法を __強力__(powerful)という.


### Neyman-Pearsonの補題

尤度比検定と呼ばれる検定法を次の棄却領域 $L_\alpha$ によって定める:

$$
L_\alpha =
\left\{\, x \,\left|\, \frac{p_0(x)}{p_1(x)} < c_\alpha \right.\right\}.
$$

ただし, 定数 $c_\alpha$ は $P(X_0\in L_\alpha) = \alpha$ をみたすものだとする.

__定理(Neyman-Pearsonの補題):__ 棄却領域 $R_\alpha$ を持つ任意の検定法について

$$
\op{power}(L_\alpha) \ge \op{power}(R_\alpha).
$$

すなわち, 尤度比検定は帰無仮説 $p_0(x)$ の検定法の中で対立仮説 $p_1(x)$ の検出力が最大である.


### Neyman-Pearsonの補題の証明

$X_0$, $X_1$ はそれぞれ帰無仮説 $p_0(x)$, 対立仮説 $p_1(x)$ に従う確率変数であるとする. このとき,

$$
P(X_0 \in L_\alpha) = \alpha \ge P(X_0 \in R_\alpha).
$$

$L_\alpha$, $R_\alpha$ の補集合を $L_\alpha^c$, $R_\alpha^c$ と書くことにすると,

$$
L_\alpha = (L_\alpha\cap R_\alpha)\cup(L_\alpha\cap R_\alpha^c), \quad
R_\alpha = (L_\alpha\cap R_\alpha)\cup(L_\alpha^c\cap R_\alpha).
\tag{$*$}
$$

$P(X_0 \in L_\alpha) \ge P(X_0 \in R_\alpha)$ より,

$$
P(X_0\in L_\alpha\cap R_\alpha^c) \ge P(X_0\in L_\alpha^c\cap R_\alpha).
\tag{$\sharp$}
$$

$x\in L_\alpha$ と $p_0(x)/c_\alpha \le p_1(x)$ が同値であることと, すぐ上で示した($\sharp$)と, $x\not\in L_\alpha$ と $p_0(x)/c_\alpha > p_1(x)$ が同値であることを順番に使うと,

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


### 尤度比検定の例: 正規分布モデルの場合

$\mu \in \R$ であるとし, $p_0(x)$, $p_1(x)$ が次の場合について考える:

$$
p_0(x) = \frac{e^{-x^2/2}}{\sqrt{2\pi}}, \quad
p_1(x) = \frac{e^{-(x-\alpha)^2/2}}{\sqrt{2\pi}}
$$

このとき, 

$$
\frac{p_0(x)}{p_1(x)} = e^{\mu^2 - 2\mu x}.
$$

これがある値未満になるという条件は, 

* $\mu > 0$ の場合には, $x$ がある値 $a$ より大きいという条件と同値になり,
* $\mu < 0$ の場合には, $x$ がある値 $a$ より小さいという条件と同値になる.

$x$ がそのようになる標準正規分布における確率はそれぞれ

* $\mu > 0$ の場合: $1 - \op{cdf}(\op{Normal}(0,1), a)$, 
* $\mu < 0$ の場合: $\op{cdf}(\op{Normal}(0,1), a)$ 

なので, これらが有意水準 $\alpha$ に等しくなる $a = a_\alpha$ はそれぞれ

* $\mu > 0$ の場合: $a_\alpha = \op{quantile}(\op{Normal}(0,1), 1-\alpha)$,
* $\mu < 0$ の場合: $a_\alpha = \op{quantile}(\op{Normal}(0,1), \alpha)$

になる. ゆえに, 帰無仮説 $p_0(x)$ と対立仮説 $p_1(x)$ に関する対数尤度比検定を与える棄却領域はそれぞれ次のようになる:

* $\mu > 0$ の場合: $L_\alpha = \{\,x\mid x > a_\alpha\,\}$, 
* $\mu < 0$ の場合: $L_\alpha = \{\,x\mid x < a_\alpha\,\}$.

これは以下のように解釈される.

* 対立仮説の平均 $\mu$ が帰無仮説の平均 $0$ より大きい場合には, データ $x$ の値がある値より大きくなると, 帰無仮説よりも対立仮説と整合的になり, 帰無仮説が棄却される.
* 対立仮説の平均 $\mu$ が帰無仮説の平均 $0$ より小さい場合には, データ $x$ の値がある値より小さくなると, 帰無仮説よりも対立仮説と整合的になり, 帰無仮説が棄却される.

この例より, すべての $\mu$ について, 最強になるような単一の検定法が存在しないことが分かる.

$\{\,x\mid x > a\,\}$ または $\{\,x\mid x < a\,\}$ の形の棄却領域で定まる検定法を __片側検定__ と呼ぶ.

__注意:__ $\{\,x\mid x < a\ \text{or}\ b<x\,\}$ の形の棄却領域で定まる検定法を __両側検定__ と呼ぶ.  両側検定は最強力にはならない.  しかし, __不偏__ という非常に強い条件を満たす検定法の中では最強力になることがある(所謂, 一様最強力不偏検定(uniformly most powerful unbiased test, UMPU test)に関する理論).  20世紀の検定の理論はこのような方向で整備された.  詳しくは次の教科書を参照せよ:

* Erich L. Lehmann, Joseph P. Romano, Testing Statistical Hypotheses, 2005

古い版を読んでもよい. しかし, 一様最強力不偏検定(UMPU test)の話は実践的にはそう役に立つわけではない.


## よくある誤解


### P値の定義と使い方の復習

現実世界から得るデータ $x$ の生成のされ方に関するパラメータ $\theta$ を持つ統計モデルが与えられているとき, データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値は

* 仮説 $\theta = \theta_0$ 下の統計モデル内部でデータの数値 $x$ 以上に極端な値が生成される確率もしくはその近似値

と定義されるのであった. (「数値 $x$ 以上に極端な値」の意味は別に定義しなければいけない.)

そして, そのようにして計算されるP値は, __仮説 $\theta = \theta_0$ 下の統計モデルとデータの数値の整合性の指標__ として使われ, P値が小さすぎる場合には「整合性がない」と判定するのであった(検定の手続き).


### 問題: P値に関するよくある誤解

データの数値 $x$ に関する仮説 $\theta=\theta_0$ のP値を以下では単にP値と呼ぶことにする.

以下の主張の中で誤解であるものをすべて挙げよ.

(1) P値は仮説 $\theta=\theta_0$ が正しい確率である.

(2) 検定の手続きでは, P値が有意水準より小さいときには, 仮説 $\theta=\theta_0$ は科学的に疑わしいと考える.

(3) 検定の手続きでは, P値が有意水準以上のときには, 仮説 $\theta=\theta_0$ は科学的に肯定されたと考える.

(3) P値が小さい結果ほど重要な結果である.


__解答例:__ すべて誤りである. 各々にコメントしておこう.

(1) P値の定義と全然違う.

(2) 検定の手続きで, P値が有意水準より小さいときには, 仮説 $\theta=\theta_0$ だけが疑わしいと考えるのではなく, 統計モデルの前提の全体のどれかも疑わしいと考える必要がある.

(3) 検定の手続きで, P値が有意水準以上になった場合には, 仮説 $\theta=\theta_0$ 下での統計モデルの現実における妥当性に関する判断を保留する(否定も肯定もしない).

(4) 例えば, ある薬の効果について, 巨大なサイズのデータによって非常に小さなP値が得られたとする. しかし, 存在することが確からしいその効果は実生活において無視できるほど小さなものだったとする.  そのような場合にはP値が小さくても重要な結果が得られたとは言えない.  薬の効果について統計分析をする場合には, P値だけではなく, 効果の大きさの指標にも注意を払う必要がある.

__解答終__


### 信頼区間の定義の復習と使い方の復習

データの数値 $x$ が与えられたとき, 有意水準 $\alpha$ の検定の手続きによって棄却されないパラメータ値 $\theta=\theta_0$ 全体の集合を, パラメータ $\theta$ に関する信頼度 $1-\alpha$ の信頼区間と呼ぶのであった.  $\alpha=5\%$ のときには $95\%$ 信頼区間と呼ばれる.


### 問題: 信頼区間に関するよく見る誤解

以下の主張が誤りまたはずさんな考え方である理由を説明せよ:

(1) $95\%$ 信頼区間の $95\%$ は確率ではなく, 割合である.

(2) 平均値の $95\%$ 信頼区間について考える. このとき, 現実の母集団からの無作為抽出を繰り返して, $95\%$ 信頼区間をそのたびに計算し直すとき, 現実の母集団の未知の平均値を含む区間の割合は $95\%$ になる.


__解答例:__ (1) 仮説 $\theta = \theta_0$ 下の統計モデル内部で生成された仮想的なデータの数値(確率変数になる)に関するパラメータ $\theta$ に関する $95\%$ 信頼区間に $\theta_0$ が含まれる確率は $95\%$ またはその近似値になる.

このように $95\%$ 信頼区間の $95\%$ は統計モデル内部での確率になっていると解釈される.

ゆえに確率ではないと言ってしまうと自明に誤りになる.

(2) 現実の母集団の未知の平均値を $\mu_{\op{real}}$ と書くことにする.  もしも平均値の信頼区間を定義するために使った統計モデルで平均値パラメータ $\mu$ を $\mu = \mu_{\op{real}}$ とおくことによって得られる確率分布が現実の母集団の分布をよく近似していれば, 問題文の(2)の内容は正しい.

しかし, 現実の母集団の分布が数学的フィクションである統計モデルとよく一致しているという仮定が成立しているは限らない. 成立していない場合には(2)は成立していない.

この問題中の(1),(2)の誤解は現実とモデルの混同が引き起こしたと考えられる.

__解答終__

```julia

```
