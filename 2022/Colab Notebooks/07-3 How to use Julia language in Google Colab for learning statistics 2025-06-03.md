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
    display_name: Julia current stable release
    language: julia
    name: julia
---

<!-- #region id="faff35b7" -->
# ColabでJulia言語を使った統計学の勉強の仕方

* 黒木玄
* 2025-05-13, 2025-06-03 B202
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

このノートブックは[Google Colabで実行できる](https://colab.research.google.com/github/genkuroki/Statistics/blob/master/2022/07-3%20How%20to%20use%20Julia%20language%20in%20Google%20Colab%20for%20learning%20statistics.ipynb).
<!-- #endregion -->

<!-- #region toc=true id="c5054baf" -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Google-ColabでのJulia言語の使い方" data-toc-modified-id="Google-ColabでのJulia言語の使い方-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Google ColabでのJulia言語の使い方</a></span><ul class="toc-item"><li><span><a href="#ColabでのJuliaの実行" data-toc-modified-id="ColabでのJuliaの実行-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>ColabでのJuliaの実行</a></span></li><li><span><a href="#グラフの描き方" data-toc-modified-id="グラフの描き方-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>グラフの描き方</a></span></li><li><span><a href="#標準正規分布乱数のプロット" data-toc-modified-id="標準正規分布乱数のプロット-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>標準正規分布乱数のプロット</a></span></li><li><span><a href="#確率分布の扱い方" data-toc-modified-id="確率分布の扱い方-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>確率分布の扱い方</a></span></li><li><span><a href="#正規分布の確率密度函数のプロット" data-toc-modified-id="正規分布の確率密度函数のプロット-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span>正規分布の確率密度函数のプロット</a></span></li></ul></li><li><span><a href="#Anscombeの例のプロット" data-toc-modified-id="Anscombeの例のプロット-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Anscombeの例のプロット</a></span><ul class="toc-item"><li><span><a href="#RDatasets.jlパッケージのインストール" data-toc-modified-id="RDatasets.jlパッケージのインストール-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>RDatasets.jlパッケージのインストール</a></span></li><li><span><a href="#データのプロットの仕方" data-toc-modified-id="データのプロットの仕方-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>データのプロットの仕方</a></span></li></ul></li><li><span><a href="#Datasaurusの散布図のプロット" data-toc-modified-id="Datasaurusの散布図のプロット-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Datasaurusの散布図のプロット</a></span><ul class="toc-item"><li><span><a href="#データの取得" data-toc-modified-id="データの取得-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>データの取得</a></span></li><li><span><a href="#散布図の作成" data-toc-modified-id="散布図の作成-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>散布図の作成</a></span></li></ul></li><li><span><a href="#中心極限定理のプロット" data-toc-modified-id="中心極限定理のプロット-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>中心極限定理のプロット</a></span><ul class="toc-item"><li><span><a href="#素朴なワークフロー" data-toc-modified-id="素朴なワークフロー-4.1"><span class="toc-item-num">4.1&nbsp;&nbsp;</span>素朴なワークフロー</a></span></li><li><span><a href="#Revise.jlを使うワークフロー" data-toc-modified-id="Revise.jlを使うワークフロー-4.2"><span class="toc-item-num">4.2&nbsp;&nbsp;</span>Revise.jlを使うワークフロー</a></span></li><li><span><a href="#問題:-自分で関数を定義して実行してみよ." data-toc-modified-id="問題:-自分で関数を定義して実行してみよ.-4.3"><span class="toc-item-num">4.3&nbsp;&nbsp;</span>問題: 自分で関数を定義して実行してみよ.</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia id="c7c7e1c5" colab={"base_uri": "https://localhost:8080/"} outputId="334ae3a2-1101-42b2-e454-ae59aac3e503"
# Google Colabと自分のパソコンの両方で使えるようにするための工夫

import Pkg

"""すでにPkg.add済みのパッケージのリスト (高速化のために用意)"""
_packages_added = [info.name for (uuid, info) in Pkg.dependencies() if info.is_direct_dep]

"""_packages_added内にないパッケージをPkg.addする"""
add_pkg_if_not_added_yet(pkg) = if !(pkg in _packages_added)
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

@autoadd begin
using Distributions
using RDatasets
using StatsPlots
default(fmt = :png, size=(400, 250), titlefontsize=12)
end
```

<!-- #region id="24bfdf4c" -->
## Google ColabでのJulia言語の使い方
<!-- #endregion -->

<!-- #region id="0c948ee9" -->
### ColabでのJuliaの実行

(1) ブラウザでGoogleアカウントのどれかにログインしておきます.

(2) [Google Colab](https://colab.research.google.com/)にアクセスする.

(3) 「ノートブックを開く」の「GitHub」を選択する.

(4) GitHubにおいてある `ipynb` ファイルのURLを入力してEnterキーを押す.  例えば

 * `https://github.com/genkuroki/Statistics/blob/master/2022/07-3%20How%20to%20use%20Julia%20language%20in%20Google%20Colab%20for%20learning%20statistics.ipynb`

というURLを入力する.

(5) 実際にその例のURLを入力してEnterキーを押すと, このファイルがGoogle Colabで開かれる.

(6) そのノートブックの全体をColabで実行し直したければ, 「ランタイム」→「すべてのセルを実行」を選択する.

(7) 適当にGoogle Colabの使い方を検索して調べればより詳しい使い方が分かる.


* 各セルの先頭に `?` と入力した後に関数名などを入れるとヘルプを読むことができる.
* 各セルの先頭に `]` と入力した後にパッケージ管理モードのコマンドを入力して実行できる.
* タブキーによる補完を使える.
* 各セルの最後に `;` を付けて実行すると計算結果が表示されない.

__問題:__ 以上を実際に行ってみよ.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/"} id="7b92ff07" outputId="2f8b0d9e-9149-4c4f-fd4f-7fb43815e657"
1 + 1
```

```julia colab={"base_uri": "https://localhost:8080/"} id="Kqf-Ycz9GFZp" outputId="2043e601-4446-4654-ba44-c2489d50a113"
print("Hoge\n")
```

```julia colab={"base_uri": "https://localhost:8080/"} id="d965833a" outputId="86338678-69fa-4c74-a11d-3cbeaa0f3724"
sin(pi/6)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="bc250130" outputId="716a4422-2ab2-43fb-9ee3-289561e675fa"
sinpi(1/6)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="0HtPKzZKGq73" outputId="b8e2354d-23d2-4a0e-b5f4-19d39c46347e"
cospi(1/6)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="0bPWwdRTGzBk" outputId="f6eef0db-fcae-4bbc-d660-8e205dabed9a"
sqrt(3)/2
```

```julia colab={"base_uri": "https://localhost:8080/"} id="WwswfCpZG6Mk" outputId="ba2ce4e2-d434-48e2-d52b-2dc071fcc6ec"
√3/2
```

```julia colab={"base_uri": "https://localhost:8080/"} id="ds3EoYbKHCKa" outputId="9413f4c0-eb10-463e-d801-bb7aed19f122"
∛8
```

<!-- #region id="83c9aa11" -->
### グラフの描き方

(7) Colabで統計学対応のグラフ作画パッケージを使うためには次を実行する:

```julia
import Pkg
Pkg.add("StatsPlots")
using StatsPlots
```

このノートブックでは最初のセルでこれと同等のことを実行できるようにしてあるので, 最初のセルを実行しておけばよい.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="f8f085c9" outputId="5de4762a-217f-4a90-977b-a083f6118085"
plot(sin)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="ofFrOwlqII4P" outputId="abddbc13-f822-41ef-e743-f070887fd78c"
plot(sin, -3pi, 3pi; label="y = sin x")
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="09299c37" outputId="1d8d6cd8-2334-478d-82dd-1b800694436a"
plot(Normal(3, 10))
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="ojXKwaw2I8oY" outputId="61f44ae1-4287-41c3-e2d4-7962e90deb33"
plot(Normal(0, 1); label="standard normal dist.")
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 421} id="vP38MkXWJhO1" outputId="03217249-a6bf-407a-c336-4f379e764155"
P = plot(Gamma(2, 1); label="Gamma(2, 1)")
plot!(xtick=0:16)

Q = plot(Gamma(2, 3); label="Gamma(2, 3)")
plot!(xtick=0:3:48)

plot(P, Q; size=(400, 400), layout=(2, 1))
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 421} id="LjeTi-MmNa4y" outputId="7e60437d-86b1-4f28-b5a3-90c14f046b16"
P = bar(Binomial(1000, 0.01); xlim=(-0.5, 25.5), label="Binomial(1000, 0.01)")
Q = bar(Poisson(10); xlim=(-0.5, 25.5), label="Poisson(10)")
plot(P, Q; size=(400, 400), layout=(2, 1))
```

```julia colab={"base_uri": "https://localhost:8080/"} id="4SZYyweIOxtV" outputId="380195ee-eea8-4bd7-8827-cc917e79aabe"
var(Binomial(1000, 0.01))
```

```julia colab={"base_uri": "https://localhost:8080/"} id="eertsThrO7eC" outputId="cf7a6e46-dede-4aa0-d324-21b8fabba2ce"
var(Poisson(10))
```

<!-- #region id="97ec64a0" -->
### 標準正規分布乱数のプロット
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/"} id="685fde1b" outputId="9a0841ea-eac2-456a-9db5-f32f2fe10c4f"
# 標準正規分布の乱数を10^4個生成
Z = randn(10^4)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="dd456229" outputId="79ad5d62-0d34-4896-ed23-d4ce61ea95c0"
histogram(Z; norm=true, alpha=0.3, label="")
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="6b0c7bb9" outputId="5da92b87-c336-4da3-aa07-fed075f7b73b"
plot!(x -> exp(-x^2/2)/sqrt(2pi), -4, 4; label="", lw=3)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="mJHuyPRsQkM5" outputId="6394cb89-dbba-410f-e1ce-d2dfe318b7bc"
histogram(Z; norm=true, alpha=0.3, label="")
plot!(Normal(0, 1); label="", lw=3)
```

<!-- #region id="da7be905" -->
### 確率分布の扱い方

(7) 確率分布を扱うためのパッケージを使うためには次を実行する:

```julia
import Pkg
Pkg.add("Distributions")
using Distributions
```

このノートブックでは最初のセルでこれと同等のことを実行できるようにしてあるので, 最初のセルを実行しておけばよい.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="603ea88c" outputId="85728fcc-dd89-4dcc-8f8f-10cebf62ece4"
dist = Binomial(20, 0.3)
bar(dist; alpha=0.5, label="Binomial(20, 0.3)")
```

```julia colab={"base_uri": "https://localhost:8080/"} id="7RbKzbFKRgsU" outputId="220d50b3-ff99-41f4-ea87-7a27acef87c7"
dump(dist)
```

<!-- #region id="50439d8c" -->
### 正規分布の確率密度函数のプロット
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/"} id="b63eae5d" outputId="fe5b865e-41b5-438f-c5d9-4a83d08f41e5"
dist = Normal(170, 7)
n = 10^6
X = rand(dist, n)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="87d3d94b" outputId="050e6ad3-a3e4-436b-84db-b01e7303d613"
stephist(X; norm=true, label="", title="sample of dist")
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="92656f9c" outputId="a9a1eeae-ded9-42c2-fb21-ccbc0e41999e"
plot!(dist; label="", title="dist", lw=1.5)
```

```julia id="T4CYirt_T78v" colab={"base_uri": "https://localhost:8080/", "height": 271} outputId="1315b8ec-16b5-4702-a921-eb122c246faa"
stephist(X; norm=true, label="", title="sample of dist")
plot!(dist; label="", title="dist", lw=1.5)
```

<!-- #region id="0343bd8e" -->
## Anscombeの例のプロット
<!-- #endregion -->

<!-- #region id="fa6628f8" -->
### RDatasets.jlパッケージのインストール

確率分布を扱うためのパッケージを入れるためには次を実行する:

```julia
import Pkg
Pkg.add("RDatasets")
using RDatasets
```

このノートブックでは最初のセルでこれと同等のことを実行できるようにしてあるので, 最初のセルを実行しておけばよい.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/", "height": 331} id="5d7f3628" outputId="3bf9a53f-4e25-46b9-9974-5f2bb70e8859"
anscombe = dataset("datasets", "anscombe")
```

<!-- #region id="ac4ec146" -->
### データのプロットの仕方

以下ではデータ1の場合のプロットの仕方を説明しよう.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/"} id="e4d4809d" outputId="1a793907-ce1c-4783-bbf5-3bd033df2996"
# x, y にデータを入れる
x, y = anscombe.X1, anscombe.Y1
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="4e4122c4" outputId="5c5c404d-c631-4499-aa5d-f94f544c40c2"
# 散布図を描いてみる
using StatsPlots
scatter(x, y)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="91a489e6" outputId="174a04c1-2175-4371-a5c2-8f715960737e"
# xlim, ylimなどを追加
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14))
```

```julia colab={"base_uri": "https://localhost:8080/"} id="78df6e34" outputId="4aae7dca-4e8d-4bb5-8e41-9eb54cf99270"
# データの標本平均や不偏分散・不偏共分散を計算
xbar = mean(x)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="b5b447e2" outputId="ad186253-4bd9-4d3c-8b0b-fe916fdddfc3"
ybar = mean(y)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="e6465be7" outputId="b5d54af2-3c94-489f-f680-e3d509f8c827"
sx2 = var(x)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="d17baa6e" outputId="c078549f-5148-4cf6-df37-37ec5bc4de5f"
sy2 = var(y)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="22103ab4" outputId="855bc6e7-90f6-4696-f345-2c6e265f274f"
sxy = cov(x, y)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="60504664" outputId="6946fe24-501c-4708-f98a-1db3accc77a4"
betahat = sxy/sx2
```

```julia colab={"base_uri": "https://localhost:8080/"} id="9880b6d8" outputId="7a37b3b6-d218-430d-d0a8-06d6aff8075d"
alphahat = ybar - betahat*xbar
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="2fcb3cf4" outputId="91375448-4cfe-4b06-ea90-fb63938f49ef"
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14))
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="db752f33" outputId="16c1935d-8f3c-426f-8025-3e53b564880d"
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14), title="Anscombe 1")
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2, ls=:dash)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="5f791ad6" outputId="3d376471-186a-42ad-c800-a4dcf49a558b"
# design matrix
X = x .^ (0:1)'
```

```julia colab={"base_uri": "https://localhost:8080/"} id="95f493d7" outputId="f1ea047f-4286-4bd6-b15d-f65460b03637"
# 最小二乗法を一発実現 (計画行列の一般逆行列をyにかける)
alphahat2, betahat2 = X \ y
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="bce868f9" outputId="6b0cb3da-5037-4115-a068-f644579995a2"
# 2つの直線はぴったり重なり合う.
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14), title="Anscombe 1")
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2)
plot!(x -> alphahat2 + betahat2*x, 3, 20; label="", lw=2, ls=:dash)
```

<!-- #region id="d5e17c68" -->
__問題:__ 他のアンスコムのデータについて同様のグラフを作成せよ.
<!-- #endregion -->

<!-- #region id="b769853a" -->
## Datasaurusの散布図のプロット

以下のデータは「[条件付き確率分布, 尤度, 推定, 記述統計](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.ipynb)」からのコピー＆ペースト.
<!-- #endregion -->

<!-- #region id="f48098d1" -->
### データの取得

<!--
* http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html
  * https://www.dropbox.com/sh/xaxpz3pm5r5awes/AADUbGVagF9i4RmM9JkPtviEa?dl=0
-->
* https://www.dropbox.com/sh/xaxpz3pm5r5awes/AADUbGVagF9i4RmM9JkPtviEa?dl=0
* https://visualizing.jp/the-datasaurus-dozen/
* https://www.openintro.org/data/index.php?data=datasaurus
<!-- #endregion -->

```julia id="2d86492f"
datasaurus = [
    55.3846 97.1795
    51.5385 96.0256
    46.1538 94.4872
    42.8205 91.4103
    40.7692 88.3333
    38.7179 84.8718
    35.6410 79.8718
    33.0769 77.5641
    28.9744 74.4872
    26.1538 71.4103
    23.0769 66.4103
    22.3077 61.7949
    22.3077 57.1795
    23.3333 52.9487
    25.8974 51.0256
    29.4872 51.0256
    32.8205 51.0256
    35.3846 51.4103
    40.2564 51.4103
    44.1026 52.9487
    46.6667 54.1026
    50.0000 55.2564
    53.0769 55.6410
    56.6667 56.0256
    59.2308 57.9487
    61.2821 62.1795
    61.5385 66.4103
    61.7949 69.1026
    57.4359 55.2564
    54.8718 49.8718
    52.5641 46.0256
    48.2051 38.3333
    49.4872 42.1795
    51.0256 44.1026
    45.3846 36.4103
    42.8205 32.5641
    38.7179 31.4103
    35.1282 30.2564
    32.5641 32.1795
    30.0000 36.7949
    33.5897 41.4103
    36.6667 45.6410
    38.2051 49.1026
    29.7436 36.0256
    29.7436 32.1795
    30.0000 29.1026
    32.0513 26.7949
    35.8974 25.2564
    41.0256 25.2564
    44.1026 25.6410
    47.1795 28.7180
    49.4872 31.4103
    51.5385 34.8718
    53.5897 37.5641
    55.1282 40.6410
    56.6667 42.1795
    59.2308 44.4872
    62.3077 46.0256
    64.8718 46.7949
    67.9487 47.9487
    70.5128 53.7180
    71.5385 60.6410
    71.5385 64.4872
    69.4872 69.4872
    46.9231 79.8718
    48.2051 84.1026
    50.0000 85.2564
    53.0769 85.2564
    55.3846 86.0256
    56.6667 86.0256
    56.1538 82.9487
    53.8462 80.6410
    51.2821 78.7180
    50.0000 78.7180
    47.9487 77.5641
    29.7436 59.8718
    29.7436 62.1795
    31.2821 62.5641
    57.9487 99.4872
    61.7949 99.1026
    64.8718 97.5641
    68.4615 94.1026
    70.7692 91.0256
    72.0513 86.4103
    73.8462 83.3333
    75.1282 79.1026
    76.6667 75.2564
    77.6923 71.4103
    79.7436 66.7949
    81.7949 60.2564
    83.3333 55.2564
    85.1282 51.4103
    86.4103 47.5641
    87.9487 46.0256
    89.4872 42.5641
    93.3333 39.8718
    95.3846 36.7949
    98.2051 33.7180
    56.6667 40.6410
    59.2308 38.3333
    60.7692 33.7180
    63.0769 29.1026
    64.1026 25.2564
    64.3590 24.1026
    74.3590 22.9487
    71.2821 22.9487
    67.9487 22.1795
    65.8974 20.2564
    63.0769 19.1026
    61.2821 19.1026
    58.7179 18.3333
    55.1282 18.3333
    52.3077 18.3333
    49.7436 17.5641
    47.4359 16.0256
    44.8718 13.7180
    48.7179 14.8718
    51.2821 14.8718
    54.1026 14.8718
    56.1538 14.1026
    52.0513 12.5641
    48.7179 11.0256
    47.1795  9.8718
    46.1538  6.0256
    50.5128  9.4872
    53.8462 10.2564
    57.4359 10.2564
    60.0000 10.6410
    64.1026 10.6410
    66.9231 10.6410
    71.2821 10.6410
    74.3590 10.6410
    78.2051 10.6410
    67.9487  8.7180
    68.4615  5.2564
    68.2051  2.9487
    37.6923 25.7692
    39.4872 25.3846
    91.2821 41.5385
    50.0000 95.7692
    47.9487 95.0000
    44.1026 92.6923
];
```

<!-- #region id="d1ff2013" -->
### 散布図の作成
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/"} id="166eafb8" outputId="b410191d-0b2d-431b-f840-3c40c01cde30"
# 行列Aの第j列はA[:,j]
@show datasaurus[:,1];
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="a8263561" outputId="2f53bdb4-9a3d-4b42-fc56-4bf966cee769"
scatter(datasaurus[:,1], datasaurus[:,2]; label="", title="Datasaurus")
```

<!-- #region id="00607c70" -->
__問題:__ [Datasaurusについて検索](https://www.google.com/search?q=Datasaurus)して見つけた解説を読め.
<!-- #endregion -->

<!-- #region id="22db6e7b" -->
## 中心極限定理のプロット
<!-- #endregion -->

<!-- #region id="581b72d5" -->
### 素朴なワークフロー

以下のセルの内容を julia の `julia> ` プロンプトに順番に入力すれば(コピー＆ペーストすれば)同じ結果が得られる.  各行の最後にセミコロン `;` を追加すれば計算結果の出力を抑制できる.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/"} id="9ac111f7" outputId="22b9b17a-988e-4c1b-c4ea-cadcc4f81d85"
# 確率分布を dist と書く.
dist = Gamma(2, 3)
```

```julia colab={"base_uri": "https://localhost:8080/"} id="ef715957" outputId="cd137710-480a-4451-a5c3-cfbac05b027a"
# 確率分布 dist のサイズ n のサンプルを L 個生成
n = 10
L = 10^4
Xs = [rand(dist, n) for _ in 1:L]
```

```julia colab={"base_uri": "https://localhost:8080/"} id="51fb2677" outputId="e6d4e27a-ef82-4539-95ba-194149ca92b2"
# L個のサイズnのサンプルの各々の標本平均を計算
Xbars = mean.(Xs)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="452d0158" outputId="42653d76-9be7-482e-e866-be626ad192a9"
# Xbarのヒストグラムを表示
histogram(Xbars; norm=true, alpha=0.5, label="", title="$dist, n=$n")
```

```julia colab={"base_uri": "https://localhost:8080/"} id="b83a1413" outputId="feb79fec-3055-4ef9-e19e-bc36ec597b28"
# 中心極限定理による正規分布近似を設定
mu = mean(dist)
sigma = std(dist)
normal_approx = Normal(mu, sigma/sqrt(n))
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="073e0c6e" outputId="1926e9a7-c8d2-4b56-925b-8443e830ad10"
# 上のグラフに重ねて正規分布をプロット
plot!(normal_approx; label="normal approx", lw=2)
```

<!-- #region id="ab543863" -->
$n=10$ が小さすぎてずれが大きい.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="c466159d" outputId="4f0bd2f9-071f-44db-fcfa-6b92343499cc"
# nを大きくしてやり直してみる.
n = 100
L = 10^4
Xs = [rand(dist, n) for _ in 1:L]
Xbars = mean.(Xs)
histogram(Xbars; norm=true, alpha=0.5, label="", title="$dist, n=$n")
mu = mean(dist)
sigma = std(dist)
normal_approx = Normal(mu, sigma/sqrt(n))
plot!(normal_approx; label="normal approx", lw=2)
```

<!-- #region id="aca07a90" -->
$n=100$ にしたら, 正規分布とよく一致するようになった.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="cdb77c2f" outputId="8ef3b9a1-dba2-4692-ae85-9641abeb1757"
# Lも大きくしてやり直してみる.
n = 100
L = 10^5
Xs = [rand(dist, n) for _ in 1:L]
Xbars = mean.(Xs)
histogram(Xbars; norm=true, alpha=0.5, label="", title="$dist, n=$n")
mu = mean(dist)
sigma = std(dist)
normal_approx = Normal(mu, sigma/sqrt(n))
plot!(normal_approx; label="normal approx", lw=2)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="3ec9888d" outputId="243ee2f7-f002-41a3-f0df-cb95fdec6efd"
# Lも大きくしてやり直してみる.
n = 1000
L = 10^5
Xs = [rand(dist, n) for _ in 1:L]
Xbars = mean.(Xs)
histogram(Xbars; norm=true, alpha=0.5, label="", title="$dist, n=$n")
mu = mean(dist)
sigma = std(dist)
normal_approx = Normal(mu, sigma/sqrt(n))
plot!(normal_approx; label="normal approx", lw=2)
```

<!-- #region id="baf0821c" -->
### Revise.jlを使うワークフロー

上のように素朴に毎回コードを入力することは非常に面倒である.

似た仕事は函数化して1行の入力で実行できるようにしておく方がよい.

しかし, 函数の定義を `julia> ` プロンプトに直接入力すると, 試行錯誤で函数の定義を何度も変える作業が非常に面倒になる.

もしも, 函数の定義をファイルに書いておき, ファイル内の函数の定義を書き換えると, 自動的に `julia> ` プロンプトの側に函数の定義の変更が反映されるようにできれば非常に便利である. それを実現するのが [Revise.jl](https://github.com/timholy/Revise.jl) パッケージである. Revise.jlパッケージは

```
pkg> add Revise
```

でインストールできる.
<!-- #endregion -->

<!-- #region id="4ff18544" -->
### 問題: 自分で関数を定義して実行してみよ.

以下のセルのように関数を定義しておくと, 同じような仕事を何度も楽に実行できるようになる.
<!-- #endregion -->

```julia colab={"base_uri": "https://localhost:8080/"} id="94aa7205" outputId="a9ff438a-9062-443d-8c32-612a0c954300"
using StatsPlots
using Distributions
default(size=(400, 250), titlefontsize=10)

function hello_sine()
    println("Hello, Sine!")
    plot(sin; label="y=sin(x)")
end

function plot_central_limit_theorem(dist, n; L=10^4, bin=:auto)
    distname = mydistname(dist)
    mu = mean(dist)
    sigma = std(dist)
    Xs = [rand(dist, n) for _ in 1:L]
    Xbars = mean.(Xs)
    normal_approx = Normal(mu, sigma/sqrt(n))

    if dist isa DiscreteUnivariateDistribution
        mu = mean(dist)
        sigma = std(dist)
        a = round(n*mu - 4.5sqrt(n)*sigma)
        b = round(n*mu + 4.5sqrt(n)*sigma)
        ran = a-0.5:b+0.5
        bin = ran / n
    end

    histogram(Xbars; bin, norm=true, alpha=0.5, label="Xbars")
    plot!(normal_approx; lw=2, label="normal approx")
    title!("$distname, n=$n")
end

mypdf(dist, x) = pdf(dist, x)
mypdf(dist::DiscreteUnivariateDistribution, x) = pdf(dist, round(Int, x))
mydistname(dist) = replace(string(dist), r"{[^}]*}"=>"")

function plot_dist(dist; xlim0=nothing)
    distname = mydistname(dist)
    if isnothing(xlim0)
        mu = mean(dist)
        sigma = std(dist)
        a = max(minimum(dist), mu - 4.5sigma)
        b = min(maximum(dist), mu + 4.5sigma)
        if dist isa DiscreteUnivariateDistribution
            a, b = a-1, b+1
        else
            a, b = a-0.025(b-a), b+0.025(b-a)
        end
        xlim0 = (a, b)
    end
    plot(x -> mypdf(dist, x), xlim0...; label="", title="$distname")
end

function plot_dist_clt(dist, n; L=10^4, xlim0=nothing)
    P0 = plot_dist(dist; xlim0)
    P1 = plot_central_limit_theorem(dist, n; L)
    plot(P0, P1; size=(800, 250), layout=(1, 2))
end
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 288} id="bd829972" outputId="f02a790c-a1bb-425b-dc30-dd2a0818e3c6"
hello_sine()
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="b9ed0da0" outputId="fc10f887-8bb9-4238-e613-f3975a0cb6a5"
plot_dist_clt(Uniform(), 10)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="32707a9a" outputId="d70e8df0-d0f6-4b8e-fa4c-35d04e0eed97"
plot_dist_clt(Laplace(), 10)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="09b12d6b" outputId="1ac6a2a1-8a05-4b7b-acd3-f00a8731818f"
plot_dist_clt(Gamma(2, 3), 10)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="fb696de1" outputId="3eea4083-eda4-4a1f-e604-ef0f68a1ae6e"
plot_dist_clt(Gamma(2, 3), 100)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="7c3f3c1f" outputId="aec83488-5558-490d-9d03-807203df53b1"
plot_dist_clt(Gamma(2, 3), 1000)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="b8dff73d" outputId="f1dd6a58-0da4-4f12-ecec-6c13532634e8"
plot_dist_clt(Exponential(), 10)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="16534a0c" outputId="66c9863a-a151-465f-cdbe-5034d60d504b"
plot_dist_clt(Exponential(), 100)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="f09b2842" outputId="64f6d31c-5f54-4135-dd55-93566066a407"
plot_dist_clt(Bernoulli(), 10)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="873f63c7" outputId="d285ccb6-fe35-40ed-d5df-94b755b5a002"
plot_dist_clt(Bernoulli(), 100)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="a6e3c037" outputId="2ac6559b-556a-4251-dbbe-a37dde990ba0"
plot_dist_clt(Bernoulli(0.2), 10)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="3de5b99c" outputId="a31cc603-6940-462d-c8cd-c42738d7a497"
plot_dist_clt(Bernoulli(0.2), 100)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="f8920a1b" outputId="35723b0a-d40d-4dc3-bd18-7f925f39d084"
plot_dist_clt(Poisson(), 10)
```

```julia colab={"base_uri": "https://localhost:8080/", "height": 271} id="f3461a81" outputId="4915afa6-efde-4574-f236-3d07dd496d2d"
plot_dist_clt(Poisson(), 100)
```

```julia id="55c1512b"

```
