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
    display_name: Julia
    language: julia
    name: julia
---

<!-- #region id="41d75adc" -->
# ColabでJuliaを使うためのノートブック

このノートブックの内容については再配布・改変・部分的コピーその他すべてを自由に行って構いません.
$
\newcommand\op{\operatorname}
\newcommand\R{{\mathbb R}}
\newcommand\Z{{\mathbb Z}}
\newcommand\var{\op{var}}
\newcommand\std{\op{std}}
\newcommand\eps{\varepsilon}
\newcommand\T[1]{T_{(#1)}}
\newcommand\bk{\bar\kappa}
\newcommand\X{{\mathscr X}}
$

このノートブックは[Google Colabで実行できる](https://colab.research.google.com/github/genkuroki/Statistics/blob/master/2022/07-4%20Julia%20notebook%20for%20Google%20Colab.ipynb).
<!-- #endregion -->

__注意警告:__ すべてのセルを実行する前に少し下の方にある注意警告を参照せよ。

```julia jupyter={"outputs_hidden": true} tags=[] id="fbfd965f" colab={"base_uri": "https://localhost:8080/"} outputId="01a1f70c-2f36-40b7-972f-82504f121c20"
# Google Colabと自分のパソコンの両方で使えるようにするための工夫

haskey(ENV, "COLAB_GPU") && (ENV["JULIA_PKG_PRECOMPILE_AUTO"] = "0")
using Pkg

"""すでにPkg.add済みのパッケージのリスト"""
_packages_added = [sort!(readdir(Sys.STDLIB));
    sort!([info.name for (uuid, info) in Pkg.dependencies() if info.is_direct_dep])]

"""_packages_added内にないパッケージをPkg.addする"""
add_pkg_if_not_added_yet(pkg) = if isnothing(Base.find_package(pkg))
    println(stderr, "# $(pkg).jl is not added yet, so let's add it.")
    Pkg.add(pkg)
end

"""expr::Exprからusing内の`.`を含まないモジュール名を抽出"""
function find_using_pkgs(expr::Expr)
    pkgs = String[]
    function traverse(expr::Expr)
        if expr.head == :using
            for arg in expr.args
                if arg.head == :. && length(arg.args) == 1
                    push!(pkgs, string(arg.args[1]))
                elseif arg.head == :(:) && length(arg.args[1].args) == 1
                    push!(pkgs, string(arg.args[1].args[1]))
                end
            end
        else
            for arg in expr.args arg isa Expr && traverse(arg) end
        end
    end
    traverse(expr)
    pkgs
end

"""必要そうなPkg.addを追加するマクロ"""
macro autoadd(expr)
    pkgs = find_using_pkgs(expr)
    :(add_pkg_if_not_added_yet.($(pkgs)); $expr)
end
```

<!-- #region id="R5QinUUMtmyU" -->
__注意警告:__ 以下のセルの `@usingdocstringtranslation; @switchlang! :ja` をコメントアウトすると(`#`を行頭に追加すると)、実験的にヘルプの主要な一部分を日本語に翻訳して表示してくれる設定を無効にできる。無効にしない場合にはGoogle Colabで約3分程度時間が取られることになる。HDD上に展開する場合にはそれを超えて大変な時間がかかる可能性がある。
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/"} id="hHqTHfxwsx1J" outputId="405e5e75-bc03-4e8e-86ad-53a27d450949"
macro usingdocstringtranslation()
    quote
        translationurl = "https://github.com/AtelierArith/DocStrBankExperimental.jl/releases/download/full-ja/translation.zip"
        #translationurl = "https://github.com/AtelierArith/DocStrBankExperimental.jl/releases/download/stats-ja/translation.zip"
        scratchspaces_dir = joinpath(DEPOT_PATH[1], "scratchspaces", "d404e13b-1f8e-41a5-a26a-0b758a0c6c97")
        translation_dir = joinpath(scratchspaces_dir, "translation")
        if isdir(translation_dir)
            println(stderr, "Directory $translation_dir already exists.")
            println(stderr, "To download and extract translation.zip again, the directory must be deleted.")
        else
            println(stderr, "translation.zip to be downloaded will be extracted into $translation_dir.")
            run(`wget --no-verbose $(translationurl) -P $(scratchspaces_dir)`)
            run(`unzip -q $(joinpath(scratchspaces_dir, "translation.zip")) -d $(scratchspaces_dir)`)
        end
        @autoadd using DocstringTranslation
    end
end

# Google Colabで次の行の実行には3分秒程度かかる。
@usingdocstringtranslation; @switchlang! :ja
```

<!-- #region id="c5e1f853" -->
__注意:__ 以下のセルを `using` の行のコメントアウトを全部外してからGoogle Colabで実行すると5分から6分程度かかるようである.  その待ち時間に耐え切れないと感じる人は自分のパソコン上にJuliaをJupyter上で実行する環境を作ればよい.  コンピュータの取り扱いの初心者のうちはその作業は非常に難しいと感じるかもしれないが, 適当に検索したり, AIに質問したりすればできるはずである.
<!-- #endregion -->

```julia jupyter={"outputs_hidden": true} tags=[] id="fbfd965f" colab={"base_uri": "https://localhost:8080/"} outputId="01a1f70c-2f36-40b7-972f-82504f121c20"
# 以下は黒木玄がよく使っているパッケージ達
# 例えばQuadGKパッケージ(数値積分のパッケージ)の使い方は
# QuadGK.jl をインターネットで検索すれば得られる.

ENV["LINES"], ENV["COLUMNS"] = 100, 100

@autoadd begin
using LinearAlgebra
using Printf
using Random
Random.seed!(4649373)
using Distributions
using StatsPlots
default(fmt=:png, legendfontsize=12, titlefontsize=12)
#using BenchmarkTools
#using Optim
#using QuadGK
#using RDatasets
#using Roots
#using StatsBase
#using StatsFuns
#using SpecialFunctions
#using SymPy
end
```

<!-- #region id="503a07b8" -->
[Julia言語](https://julialang.org/)については以下の検索で色々学べる.

* Julia言語のドキュメント: https://docs.julialang.org/en/v1/
* Julia言語について検索: https://www.google.com/search?q=Julia%E8%A8%80%E8%AA%9E
* Distributions.jlパッケージについて検索: https://www.google.com/search?q=Distributions.jl
* Plots.jlパッケージについて検索: https://www.google.com/search?q=Plots.jl
* StatsPlots.jlパッケージについて検索: https://www.google.com/search?q=StatsPlots.jl
* BenchmarkTools.jlパッケージについて検索: https://www.google.com/search?q=BenchmarkTools.jl
* Optim.jlパッケージについて検索: https://www.google.com/search?q=Optim.jl
* QuadGK.jlパッケージについて検索: https://www.google.com/search?q=QuadGK.jl
* RDatasets.jlパッケージについて検索: https://www.google.com/search?q=RDatasets.jl
* Roots.jlパッケージについて検索: https://www.google.com/search?q=Roots.jl
* StatsBase.jlパッケージについて検索: https://www.google.com/search?q=StatsBase.jl
* StatsFuns.jlパッケージについて検索: https://www.google.com/search?q=StatsFuns.jl
* SpecialFunctions.jlパッケージについて検索: https://www.google.com/search?q=SpecialFunctions.jl
* SymPy.jlパッケージについて検索: https://www.google.com/search?q=SymPy.jl
<!-- #endregion -->

<!-- #region id="bf904455" -->
## @autoadd マクロの使い方

例えば, パッケージA.jlやB.jlをインストール前(Pkg.add前)であるとき,

```julia
using A
using B: b1, b2
```

を実行しようとするとエラーになってしまう. しかし,

```julia
@autoadd using A
@autoadd using B: b1, b2

```

または

```julia
@autoadd begin
using A
using B: b1, b2
end
```

を実行すれば, 自動的にパッケージA.jlやB.jlがインストールされてから, using達が実行される.

以下のように `@macroexpand` を使えば具体的に何が実行されるかを確認できる.
<!-- #endregion -->

```julia id="cfe73cc8" outputId="40047c22-7bca-40e3-9b2a-95abe8be01ea" colab={"base_uri": "https://localhost:8080/"}
(@macroexpand @autoadd using A) |> Base.remove_linenums!
```

```julia id="17e2d6cd" outputId="a4650fbc-c1ce-48fb-e15c-1fd40787ab8a" colab={"base_uri": "https://localhost:8080/"}
(@macroexpand @autoadd using A, B, C) |> Base.remove_linenums!
```

```julia id="60029a5f" outputId="aa2298ae-de86-44d1-bad8-a447c0cec28d" colab={"base_uri": "https://localhost:8080/"}
(@macroexpand @autoadd using A: a1, a2, @a3) |> Base.remove_linenums!
```

```julia id="d39028e2" outputId="eb2e891b-8562-45b2-a6e4-d95a8bade9f0" colab={"base_uri": "https://localhost:8080/"}
(@macroexpand @autoadd begin
using A: a1
using A.B
using A.C: c1, c2
#using D
using E, A.F, G
using H: h1, h2
using I
end) |> Base.remove_linenums!
```

<!-- #region id="138808b9" -->
## ランダムウォーク

期待値が $\mu$ で標準偏差が $\sigma$ の確率分布の独立同分布確率変数列 $X_1,X_2,X_3,\ldots$について,

$$
W_n = (X_1-\mu)+(X_2-\mu)+\cdots+(X_n-\mu), \quad n=1,2,3,\ldots
$$

の様子がどうなるかを見てみよう.
<!-- #endregion -->

<!-- #region id="mKYJskO_zSuE" -->
まずはガンマ分布の説明を見てみよう。セルの先頭に `?` と書き、その後に説明してもらいたいものの名前を書けば説明が表示される。
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/", "height": 306} id="64mYRbVIyviL" outputId="0957a47a-38ca-4783-9c07-38536cb17e56"
?Gamma
```

```julia id="96b175e3" outputId="76c910bd-7639-49cb-ac10-124c27fc3853" colab={"base_uri": "https://localhost:8080/", "height": 439}
dist = Gamma(2, 3)
@show mu, sigma = mean(dist), std(dist)
plot(dist; label="dist")
```

```julia id="973eb239" colab={"base_uri": "https://localhost:8080/"} outputId="7a8dc8ba-321b-4ab3-c468-7d8d39961813"
X_minus_mu = rand(dist - mu, 10) # X_1 - mu, X_2 - mu, ..., X_10 - mu を生成
```

```julia id="f95633b1" colab={"base_uri": "https://localhost:8080/"} outputId="d5daf9d0-02e4-4e7b-dd00-30e0306410a2"
cumsum(X_minus_mu) # W_1, W_2, ..., W_10 を作成
```

<!-- #region id="eaBFxnNyzkwl" -->
上で使った `cumsum` の説明を見てみよう。
<!-- #endregion -->

```julia id="8360636e" colab={"base_uri": "https://localhost:8080/", "height": 1000} outputId="021ff2ba-bf53-402a-d1e7-5c961b2192f3"
?cumsum
```

```julia id="0e4c2922" colab={"base_uri": "https://localhost:8080/", "height": 421} outputId="d2ec3ed0-e434-41db-bde4-660caef68aed"
nmax = 2^10 # maximum sample size
niters = 200 # number of iterations
Ws = [cumsum(rand(dist - mu, nmax)) for _ in 1:niters] # [W_1, W_2, ..., W_nmax] をniters個生成

plot()
for W in Ws
    plot!([0; W]; label="", lw=0.3, alpha=0.5)
end
plot!(n -> +2sqrt(n)*sigma, 0, nmax; label="±2√n σ", c=:red)
plot!(n -> -2sqrt(n)*sigma, 0, nmax; label="", c=:red)
```

<!-- #region id="0070fd01" -->
期待値が $0$ のギャンブルを $n$ 回繰り返すと, __トータルでの勝ち負けの金額__はおおよそ $\pm 2\sqrt{n}\;\sigma$ の範囲におさまる(ランダムウォークの偏差).
<!-- #endregion -->

<!-- #region id="2f32eac8" -->
## 大数の法則

期待値が $0$ で標準偏差が $\sigma$ の確率分布の独立同分布確率変数列$X_1,X_2,X_3,\ldots$について, サイズ $n$ の標本平均

$$
\bar{X}_n = \frac{X_1+X_2+\cdots+X_n}{n}
$$

の様子がどうなるかを見てみよう.
<!-- #endregion -->

```julia id="f8450df1" colab={"base_uri": "https://localhost:8080/", "height": 439} outputId="04710bd6-7cf0-4ed1-8dcb-23af9e6ae317"
dist = Gamma(2, 3)
@show mu, sigma = mean(dist), std(dist)
plot(dist; label="dist")
```

```julia id="5622f2a6" colab={"base_uri": "https://localhost:8080/"} outputId="3b5b3457-4b01-4867-b572-8eb9731d0230"
X = rand(dist, 10) # X_1, X_2, ..., X_10 を生成
```

```julia id="15d981e1" colab={"base_uri": "https://localhost:8080/"} outputId="9964fd1c-b5b0-4cdc-fbc4-4c2a34f2baa5"
Xbar = cumsum(X) ./ (1:10) # Xbar_1, Xbar_2, ..., Xbar_10 を作成
```

上の行の `./` で使っているドット記法については

* https://docs.julialang.org/en/v1/manual/functions/#man-vectorized

を参照せよ。例えば長さ`n`の配列`A`について `A ./ (1:n)` の結果は`A`の第k成分をkで割って得られる配列になる。ドット記法は各成分ごとに演算子や関数を作用させるために使われる。

```julia id="c2d77247" colab={"base_uri": "https://localhost:8080/", "height": 421} outputId="69b9a8ca-2174-4887-b8ad-0ca492b87cde"
nmax = 1000 # maximum sample size
niters = 100 # number of iterations
Xbars = [cumsum(rand(dist, nmax)) ./ (1:nmax) for _ in 1:niters] # [Xbar_1, ..., Xbar_nmax] をniters個生成

plot()
for Xbar in Xbars
    plot!([0; Xbar]; label="", lw=0.3, alpha=0.5)
end
plot!(x -> mu, 0, nmax; label="µ", c=:red)
plot!(ylim=(mu-sigma, mu+sigma))
```

<!-- #region id="23075984" -->
期待値が $0$ のギャンブルを $n$ 回繰り返すと, 1回ごとの勝ち負けの平均値は $\mu$ に近付く(大数の法則).

ランダムウォーク(トータルでの勝ち負けの金額の話)と大数の法則(トータルの勝ち負けの金額を繰り返した回数の $n$ で割って得られる1回ごとの平均値の話)を混同するとひどい目にあうだろう!
<!-- #endregion -->

<!-- #region id="174bcd70" -->
## 中心極限定理の素朴な確認の仕方

期待値が $\mu$ で標準偏差が $\sigma$ の確率分布の独立同分布確率変数列$X_1,X_2,X_3,\ldots$について, 標本平均 $\bar{X}_n = (X_1+\cdots+X_n)/n$ が従う分布は $n$ が大きなとき, 期待値 $\mu$ と標準偏差 $\sigma/\sqrt{n}$ を持つ正規分布で近似される. すなわち,

$$
Y_n = \sqrt{n}\;(\bar{X} - \mu)
= \frac{(X_1-\mu)+\cdots+(X_n-\mu)}{\sqrt{n}}
$$

が従う分布は, $n$が大きいとき, 期待値 $0$ と標準偏差 $\sigma$ を持つ正規分布で近似され,

$$
Z_n = \frac{\sqrt{n}\;(\bar{X} - \mu)}{\sigma}
= \frac{(X_1-\mu)+\cdots+(X_n-\mu)}{\sqrt{n}\;\sigma}
$$

が従う分布は, $n$が大きいとき, 標準正規分布で近似される.
<!-- #endregion -->

```julia id="5720ae88" colab={"base_uri": "https://localhost:8080/", "height": 439} outputId="0a463c35-f894-4e81-e791-d98ec781c904"
dist = Gamma(2, 3)
@show mu, sigma = mean(dist), std(dist)
plot(dist; label="dist")
```

<!-- #region id="J4K4DgjHz9Jn" -->
以下で使う `stephist` の説明を見てみよう。
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/", "height": 116} id="5wtw5Dhez8jP" outputId="b0b213a7-39ed-4f2c-b7f4-21542d86fbe6"
?stephist
```

<!-- #region id="I_gMupup0LCl" -->
`stephist` は縦線が表示されないヒストグラムを表示してくれる。
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/", "height": 522} id="fj7_EBx30FQG" outputId="41af447d-cb29-4897-c7f4-669ad514799b"
?histogram
```

<!-- #region id="KHiK7SH50U6g" -->
`stephist` や `histogram` では `normalize=true` もしくは `norm=true` と設定して使う習慣しておくと、統計学の学習時に便利である。そのようにしておくと、確率密度関数のスケールでヒストグラムをプロットしてくれる。
<!-- #endregion -->

```julia id="dda8d565" colab={"base_uri": "https://localhost:8080/", "height": 421} outputId="209cc8cd-1155-4d14-84a8-9f8202f4307c"
n = 2^5 # sample size
niters = 10^6 # number of iterations
Xbars = [mean(rand(dist, n)) for _ in 1:niters] # niters個の標本平均を計算

stephist(Xbars; norm=true, label="size-$n sample means")
plot!(Normal(mu, sigma/sqrt(n)); label="normal approximation")
```

```julia id="c9f0fc24" colab={"base_uri": "https://localhost:8080/", "height": 421} outputId="e70db97a-acf2-49ed-d0c3-d74d2ae2a5e9"
n = 2^5 # sample size
Yns = [sqrt(n) * (Xbar - mu) for Xbar in Xbars] # Z_nを繰り返し計算

stephist(Yns; norm=true, label="distribution of Y_$n")
plot!(Normal(0, sigma); label="normal approximation")
```

```julia id="8154bb01" colab={"base_uri": "https://localhost:8080/", "height": 421} outputId="76938e3f-3e3e-4716-b040-e06221abf2ce"
n = 2^5 # sample size
Zns = [sqrt(n) * (Xbar - mu) / sigma for Xbar in Xbars] # Z_nを繰り返し計算

stephist(Zns; norm=true, label="distribution of Z_$n")
plot!(Normal(); label="standard normal dist")
plot!(xtick=-10:10)
```

<!-- #region id="5874b063" -->
## 以下は自由に使って下さい
<!-- #endregion -->

```julia id="ef8e6434"

```

```julia id="3bcc4140"

```

```julia id="8c7a8668"

```

```julia id="32b5b7bd"

```

```julia id="33e69d19"

```
