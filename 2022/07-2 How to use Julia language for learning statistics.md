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

# Julia言語を使った統計学の勉強の仕方

* 黒木玄
* 2022-05-28～2022-05-31, 2024-01-06, 2024-01-13, 2025-01-22, 2025-05-13, 2025-06-03
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

このノートでは[Julia言語](https://julialang.org/)を使用している: 

* [Julia言語のインストールの仕方の一例](https://nbviewer.org/github/genkuroki/msfd28/blob/master/install.ipynb)

自明な誤りを見つけたら, 自分で訂正して読んで欲しい.  大文字と小文字の混同や書き直しが不完全な場合や符号のミスは非常によくある.

このノートに書いてある式を文字通りにそのまま読んで正しいと思ってしまうとひどい目に会う可能性が高い. しかし, 数学が使われている文献には大抵の場合に文字通りに読むと間違っている式や主張が書いてあるので, 内容を理解した上で訂正しながら読んで利用しなければいけない. 実践的に数学を使う状況では他人が書いた式をそのまま信じていけない.

このノートの内容よりもさらに詳しいノートを自分で作ると勉強になるだろう.  膨大な時間を取られることになるが, このノートの内容に関係することで飯を食っていく可能性がある人にはそのためにかけた時間は無駄にならないと思う.

このノートブックは[Google Colabで実行できる](https://colab.research.google.com/github/genkuroki/Statistics/blob/master/2022/07-2%20How%20to%20use%20Julia%20language%20for%20learning%20statistics.ipynb).

<!-- #region toc=true -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Julia言語の使い方" data-toc-modified-id="Julia言語の使い方-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Julia言語の使い方</a></span><ul class="toc-item"><li><span><a href="#Juliaのインストールと実行" data-toc-modified-id="Juliaのインストールと実行-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>Juliaのインストールと実行</a></span></li><li><span><a href="#グラフの描き方" data-toc-modified-id="グラフの描き方-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>グラフの描き方</a></span></li><li><span><a href="#標準正規分布乱数のプロット" data-toc-modified-id="標準正規分布乱数のプロット-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>標準正規分布乱数のプロット</a></span></li><li><span><a href="#確率分布の扱い方" data-toc-modified-id="確率分布の扱い方-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>確率分布の扱い方</a></span></li><li><span><a href="#正規分布の確率密度函数のプロット" data-toc-modified-id="正規分布の確率密度函数のプロット-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span>正規分布の確率密度函数のプロット</a></span></li></ul></li><li><span><a href="#Anscombeの例のプロット" data-toc-modified-id="Anscombeの例のプロット-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Anscombeの例のプロット</a></span><ul class="toc-item"><li><span><a href="#RDatasets.jlパッケージのインストール" data-toc-modified-id="RDatasets.jlパッケージのインストール-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>RDatasets.jlパッケージのインストール</a></span></li><li><span><a href="#データのプロットの仕方" data-toc-modified-id="データのプロットの仕方-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>データのプロットの仕方</a></span></li></ul></li><li><span><a href="#Datasaurusの散布図のプロット" data-toc-modified-id="Datasaurusの散布図のプロット-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Datasaurusの散布図のプロット</a></span><ul class="toc-item"><li><span><a href="#データの取得" data-toc-modified-id="データの取得-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>データの取得</a></span></li><li><span><a href="#散布図の作成" data-toc-modified-id="散布図の作成-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>散布図の作成</a></span></li></ul></li><li><span><a href="#中心極限定理のプロット" data-toc-modified-id="中心極限定理のプロット-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>中心極限定理のプロット</a></span><ul class="toc-item"><li><span><a href="#素朴なワークフロー" data-toc-modified-id="素朴なワークフロー-4.1"><span class="toc-item-num">4.1&nbsp;&nbsp;</span>素朴なワークフロー</a></span></li><li><span><a href="#Revise.jlを使うワークフロー" data-toc-modified-id="Revise.jlを使うワークフロー-4.2"><span class="toc-item-num">4.2&nbsp;&nbsp;</span>Revise.jlを使うワークフロー</a></span></li><li><span><a href="#問題:-Revise.jlを実際に使ってみよ" data-toc-modified-id="問題:-Revise.jlを実際に使ってみよ-4.3"><span class="toc-item-num">4.3&nbsp;&nbsp;</span>問題: Revise.jlを実際に使ってみよ</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia
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
default(fmt = :png)
end
```

## Julia言語の使い方


### Juliaのインストールと実行

__注意:__ 本当は [juliaup](https://www.google.com/search?q=juliaup) を使うと楽になるので, 余裕がある人は自分で [juliaup](https://www.google.com/search?q=juliaup) について調べて使った方が良い.

(1) [JuliaLangについて検索](https://www.google.com/search?q=JuliaLang)する.

(2) [Julia言語のウェブサイト](https://julialang.org/)に移動する.

(3) Downloadボタンを押して, [Download Julia](https://julialang.org/downloads/) のページに移動する.

(4) 自分のパソコンに合わせて, current stable release のインストーラをダウンロード

(5) それを実行してJulia言語の公式バイナリを自分のパソコンにインストールする.

__重要な注意:__ Windowsユーザーはjuliaを日本語の文字が含まれた名前のディレクトリの下にインストールしないように注意して下さい.  おそらくjuliaを正常に実行できなくなります.  最も安直な解決作は `C:\julia-1.10.3` のようにCドライブ直下にインストールするという手があります.

(6) juliaを実行すると以下のように表示される.

```
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.7.3 (2022-05-06)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```

* `julia>` プロンプトで `?` を入力するとヘルプモードに移る.
* `julia>` プロンプトで `]` を入力するとパッケージ管理モードに移る.
* それらのモードから `julia>` プロンプトに戻るにはバックスペースキーを押す.
* 至るところでタブキーによる補完を使える.
* `julia>` プロンプトでJulia言語のコードを入力して終わりに `;` を付けて実行すると計算結果が表示されない.

__問題:__ 以下を自分がインストールしたjuliaで実行してみよ.

```julia
1 + 1
```

```julia
sin(pi/6)
```

```julia
sinpi(1/6)
```

### グラフの描き方

(7) 統計学対応のグラフ作画パッケージを入れるためには

```
julia> using StatsPlots
```

を実行するだけでよい.  インストールするかどうかをjuliaが聞いて来た場合には `y` と答える.

__重要な注意1:__ 上の方法でうまく行かない場合には, 

```
julia> ]を押す
pkg> add StatsPlots
数分時間がかかる
pkg> BackSpaceキーを押す
```

のようにしてパッケージをインストールして下さい.

__重要な注意2:__ StatsPlots.jlパッケージのインストールに成功した後に

```
julia> using StatsPlots
julia> plot(sin)
```

としても,

```
Plot{Plots.GRBackend() n=1}
```

と表示されるだけでグラフが作画されない場合には, 

```
julia> default(gui=true)
```

を実行して下さい.

__問題:__ 自分のパソコンで `using StatsPlots` の後に以下を実行してグラフを作画してみよ.

```julia
using StatsPlots
plot(sin)
```

### 標準正規分布乱数のプロット

```julia
Z = randn(10^4);
```

```julia
histogram(Z; norm=true, alpha=0.5, label="")
```

```julia
plot!(x -> exp(-x^2/2)/sqrt(2pi), -4, 4; label="", lw=3)
```

### 確率分布の扱い方

(7) 確率分布を扱うためのパッケージを入れるためには

```
julia> using Distributions
```

を実行するだけでよい. インストールするかどうかをjuliaが聞いて来た場合には `y` と答える.

しかし, この機会にパッケージモードでのパッケージの入れ方についてもこの機会に学んでおいた方がよい.

```
julia> ]
```

と `]` を入力すると,

```
pkg> 
```

と表示されてパッケージ管理モードに移行できる(戻るには `pkg> ` プロンプトの直後にバックスペースを押せばよい).

以下を実行すると, `Distributions.jl` パッケージをjuliaの環境にインストールできる.

```
pkg> add Distributions
```


### 正規分布の確率密度函数のプロット

```julia
using Distributions
X = rand(Normal(2, 3), 10^4);
```

```julia
histogram(X; norm=true, alpha=0.5, label="sample of Normal(2, 3)")
```

```julia
plot!(Normal(2, 3); label="Normal(2, 3)", lw=2)
```

## Anscombeの例のプロット


### RDatasets.jlパッケージのインストール

確率分布を扱うためのパッケージを入れるためには

```
julia> using RDatasets
```

を実行するだけでよい. インストールするかどうかをjuliaが聞いて来た場合には `y` と答える. もしくはパッケージ管理モードで

```
pkg> add RDatasets
```

を実行してもよい.  その場合には `julia> ` プロンプトで改めて `using RDatasets` を実行する必要がある.

```julia
using RDatasets
anscombe = dataset("datasets", "anscombe")
```

### データのプロットの仕方

以下ではデータ1の場合のプロットの仕方を説明しよう.

```julia
# x, y にデータを入れる
x, y = anscombe.X1, anscombe.Y1
```

```julia
# 散布図を描いてみる
using StatsPlots
scatter(x, y)
```

```julia
# xlim, ylimなどを追加
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14))
```

```julia
# データの標本平均や不偏分散・不偏共分散を計算
xbar = mean(x)
```

```julia
ybar = mean(y)
```

```julia
sx2 = var(x)
```

```julia
sy2 = var(y)
```

```julia
sxy = cov(x, y)
```

```julia
betahat = sxy/sx2
```

```julia
alphahat = ybar - betahat*xbar
```

```julia
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14))
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2)
```

```julia
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14), title="Anscombe 1")
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2, ls=:dash)
```

```julia
# design matrix
X = x .^ (0:1)'
```

```julia
# 最小二乗法を一発実現 (計画行列の一般逆行列をyにかける)
alphahat2, betahat2 = X \ y
```

```julia
# 2つの直線はぴったり重なり合う.
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14), title="Anscombe 1")
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2)
plot!(x -> alphahat2 + betahat2*x, 3, 20; label="", lw=2, ls=:dash)
```

__問題:__ 他のアンスコムのデータについて同様のグラフを作成せよ.


## Datasaurusの散布図のプロット

以下のデータは「[条件付き確率分布, 尤度, 推定, 記述統計](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.ipynb)」からのコピー＆ペースト.


### データの取得

<!--
* http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html
  * https://www.dropbox.com/sh/xaxpz3pm5r5awes/AADUbGVagF9i4RmM9JkPtviEa?dl=0
-->
* https://www.dropbox.com/sh/xaxpz3pm5r5awes/AADUbGVagF9i4RmM9JkPtviEa?dl=0
* https://visualizing.jp/the-datasaurus-dozen/
* https://www.openintro.org/data/index.php?data=datasaurus

```julia
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

### 散布図の作成

```julia
# 行列Aの第j列はA[:,j]
@show datasaurus[:,1];
```

```julia
using StatsPlots
scatter(datasaurus[:,1], datasaurus[:,2]; label="", title="Datasaurus")
```

__問題:__ [Datasaurusについて検索](https://www.google.com/search?q=Datasaurus)して見つけた解説を読め.


## 中心極限定理のプロット


### 素朴なワークフロー

以下のセルの内容を julia の `julia> ` プロンプトに順番に入力すれば(コピー＆ペーストすれば)同じ結果が得られる.  各行の最後にセミコロン `;` を追加すれば計算結果の出力を抑制できる.

```julia
using StatsPlots, Distributions
```

```julia
# 確率分布を dist と書く.
dist = Gamma(2, 3)
```

```julia
# 確率分布 dist のサイズ n のサンプルを L 個生成
n = 10
L = 10^4
Xs = [rand(dist, n) for _ in 1:L]
```

```julia
# L個のサイズnのサンプルの各々の標本平均を計算
Xbars = mean.(Xs)
```

```julia
# Xbarのヒストグラムを表示
histogram(Xbars; norm=true, alpha=0.5, label="", title="$dist, n=$n")
```

```julia
# 中心極限定理による正規分布近似を設定
mu = mean(dist)
sigma = std(dist)
normal_approx = Normal(mu, sigma/sqrt(n))
```

```julia
# 上のグラフに重ねて正規分布をプロット
plot!(normal_approx; label="normal approx", lw=2)
```

$n=10$ が小さすぎてずれが大きい.

```julia
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

$n=100$ にしたら, 正規分布とよく一致するようになった.

```julia
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

```julia
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

### Revise.jlを使うワークフロー

上のように素朴に毎回コードを入力することは非常に面倒である.

似た仕事は函数化して1行の入力で実行できるようにしておく方がよい.

しかし, 函数の定義を `julia> ` プロンプトに直接入力すると, 試行錯誤で函数の定義を何度も変える作業が非常に面倒になる. 

もしも, 函数の定義をファイルに書いておき, ファイル内の函数の定義を書き換えると, 自動的に `julia> ` プロンプトの側に函数の定義の変更が反映されるようにできれば非常に便利である. それを実現するのが [Revise.jl](https://github.com/timholy/Revise.jl) パッケージである. Revise.jlパッケージは

```
pkg> add Revise
```

でインストールできる.

<!-- #region -->
### 問題: Revise.jlを実際に使ってみよ

`using Revise` を実際に使ってみよ.

例えば, 以下のセルの内容で `central_limit_theorem.jl` という名前のファイルを作成し,

```julia
julia> using Revise
julia> includet("central_limit_theorem.jl")
julia> hello_sine()
```

を実行してみよ. 他の函数の実行例については下の方を参考にせよ.

`using Revise` 後に `includet` (最後の `t` を忘れずに)したファイルの内容を変更すると自動的に `julia> ` プロンプト側(juliaのREPL側(read-eval-print loop側))に反映されるので, それ以後は

* `includet` で読み込んだファイルを変更する.
* 例えば, 函数の内容を変更したり, 新しい函数を書いたりする.
* その結果は自動的に `julia> ` プロンプト側に反映される.
* ファイルの変更結果をテストするために函数を実行する.

の繰り返して, 色々な仕事をできるようになる.
<!-- #endregion -->

```julia
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

```julia
hello_sine()
```

```julia
plot_dist_clt(Uniform(), 10)
```

```julia
plot_dist_clt(Laplace(), 10)
```

```julia
plot_dist_clt(Gamma(2, 3), 10)
```

```julia
plot_dist_clt(Gamma(2, 3), 100)
```

```julia
plot_dist_clt(Gamma(2, 3), 1000)
```

```julia
plot_dist_clt(Exponential(), 10)
```

```julia
plot_dist_clt(Exponential(), 100)
```

```julia
plot_dist_clt(Bernoulli(), 10)
```

```julia
plot_dist_clt(Bernoulli(), 100)
```

```julia
plot_dist_clt(Bernoulli(0.2), 10)
```

```julia
plot_dist_clt(Bernoulli(0.2), 100)
```

```julia
plot_dist_clt(Poisson(), 10)
```

```julia
plot_dist_clt(Poisson(), 100)
```
