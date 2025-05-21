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
* 2025-05-13 -> 2025-05-21
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

このノートブックは[Google Colabで実行できる](https://colab.research.google.com/github/genkuroki/Statistics/blob/master/2022/Colab%20Notebooks/07-3%20How%20to%20use%20Julia%20language%20in%20Google%20Colab%20for%20learning%20statistics%202025-05-21.ipynb).
<!-- #endregion -->

<!-- #region toc=true id="c5054baf" -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#Google-ColabでのJulia言語の使い方" data-toc-modified-id="Google-ColabでのJulia言語の使い方-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Google ColabでのJulia言語の使い方</a></span><ul class="toc-item"><li><span><a href="#ColabでのJuliaの実行" data-toc-modified-id="ColabでのJuliaの実行-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>ColabでのJuliaの実行</a></span></li><li><span><a href="#グラフの描き方" data-toc-modified-id="グラフの描き方-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>グラフの描き方</a></span></li><li><span><a href="#標準正規分布乱数のプロット" data-toc-modified-id="標準正規分布乱数のプロット-1.3"><span class="toc-item-num">1.3&nbsp;&nbsp;</span>標準正規分布乱数のプロット</a></span></li><li><span><a href="#確率分布の扱い方" data-toc-modified-id="確率分布の扱い方-1.4"><span class="toc-item-num">1.4&nbsp;&nbsp;</span>確率分布の扱い方</a></span></li><li><span><a href="#正規分布の確率密度函数のプロット" data-toc-modified-id="正規分布の確率密度函数のプロット-1.5"><span class="toc-item-num">1.5&nbsp;&nbsp;</span>正規分布の確率密度函数のプロット</a></span></li></ul></li><li><span><a href="#Anscombeの例のプロット" data-toc-modified-id="Anscombeの例のプロット-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Anscombeの例のプロット</a></span><ul class="toc-item"><li><span><a href="#RDatasets.jlパッケージのインストール" data-toc-modified-id="RDatasets.jlパッケージのインストール-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>RDatasets.jlパッケージのインストール</a></span></li><li><span><a href="#データのプロットの仕方" data-toc-modified-id="データのプロットの仕方-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>データのプロットの仕方</a></span></li></ul></li><li><span><a href="#Datasaurusの散布図のプロット" data-toc-modified-id="Datasaurusの散布図のプロット-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Datasaurusの散布図のプロット</a></span><ul class="toc-item"><li><span><a href="#データの取得" data-toc-modified-id="データの取得-3.1"><span class="toc-item-num">3.1&nbsp;&nbsp;</span>データの取得</a></span></li><li><span><a href="#散布図の作成" data-toc-modified-id="散布図の作成-3.2"><span class="toc-item-num">3.2&nbsp;&nbsp;</span>散布図の作成</a></span></li></ul></li><li><span><a href="#中心極限定理のプロット" data-toc-modified-id="中心極限定理のプロット-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>中心極限定理のプロット</a></span><ul class="toc-item"><li><span><a href="#素朴なワークフロー" data-toc-modified-id="素朴なワークフロー-4.1"><span class="toc-item-num">4.1&nbsp;&nbsp;</span>素朴なワークフロー</a></span></li><li><span><a href="#Revise.jlを使うワークフロー" data-toc-modified-id="Revise.jlを使うワークフロー-4.2"><span class="toc-item-num">4.2&nbsp;&nbsp;</span>Revise.jlを使うワークフロー</a></span></li><li><span><a href="#問題:-自分で関数を定義して実行してみよ." data-toc-modified-id="問題:-自分で関数を定義して実行してみよ.-4.3"><span class="toc-item-num">4.3&nbsp;&nbsp;</span>問題: 自分で関数を定義して実行してみよ.</a></span></li></ul></li></ul></div>
<!-- #endregion -->

```julia id="c7c7e1c5" executionInfo={"status": "ok", "timestamp": 1747800764169, "user_tz": -540, "elapsed": 122777, "user": {"displayName": "", "userId": ""}} outputId="b4a26944-b356-443d-9d9e-eeb718ef19f3" colab={"base_uri": "https://localhost:8080/"}
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
default(fmt=:png, size=(400, 250), titlefontsize=10)
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

```julia id="7b92ff07" executionInfo={"status": "ok", "timestamp": 1747800765201, "user_tz": -540, "elapsed": 1038, "user": {"displayName": "", "userId": ""}} outputId="52a10187-bafe-4e8d-8699-02c97fb191fa" colab={"base_uri": "https://localhost:8080/"}
1 + 1
```

```julia id="d965833a" executionInfo={"status": "ok", "timestamp": 1747800765378, "user_tz": -540, "elapsed": 174, "user": {"displayName": "", "userId": ""}} outputId="06bb9ff5-6416-41e9-9c7d-0f82d61a508e" colab={"base_uri": "https://localhost:8080/"}
sin(pi/6)
```

```julia id="bc250130" executionInfo={"status": "ok", "timestamp": 1747800765443, "user_tz": -540, "elapsed": 61, "user": {"displayName": "", "userId": ""}} outputId="40573fa8-f5aa-422b-a73a-f93092b74e19" colab={"base_uri": "https://localhost:8080/"}
sinpi(1/6)
```

```julia id="L37Y-tSODhYZ" executionInfo={"status": "ok", "timestamp": 1747800997419, "user_tz": -540, "elapsed": 57, "user": {"displayName": "", "userId": ""}} outputId="4a62b11a-e29e-4d58-c6e8-f6c1c33f4aef" colab={"base_uri": "https://localhost:8080/"}
f(x) = x^3 - 2x + 1
```

```julia id="mmm0otIZDtv2" executionInfo={"status": "ok", "timestamp": 1747801014785, "user_tz": -540, "elapsed": 38, "user": {"displayName": "", "userId": ""}} outputId="5d891e4b-af4f-46ee-ca85-578eeda3bfba" colab={"base_uri": "https://localhost:8080/"}
f(0)
```

```julia id="0orZX8KpDxAG" executionInfo={"status": "ok", "timestamp": 1747801034023, "user_tz": -540, "elapsed": 78, "user": {"displayName": "", "userId": ""}} outputId="ce799fc2-11bb-4a05-c1ab-1f934aa23051" colab={"base_uri": "https://localhost:8080/"}
f(2)
```

```julia id="hsXNPTGqEDWS" executionInfo={"status": "ok", "timestamp": 1747801113484, "user_tz": -540, "elapsed": 336, "user": {"displayName": "", "userId": ""}} outputId="a39eed49-e78b-4091-b3c9-d815491f9243" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot(f)
```

```julia id="wG2tRlKwENBw" executionInfo={"status": "ok", "timestamp": 1747801159593, "user_tz": -540, "elapsed": 136, "user": {"displayName": "", "userId": ""}} outputId="8c3f3eb4-3399-445a-ffdd-3949ff5567b9" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot(f, -1, 1.5)
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

```julia id="f8f085c9" executionInfo={"status": "ok", "timestamp": 1747801448482, "user_tz": -540, "elapsed": 131, "user": {"displayName": "", "userId": ""}} outputId="76de33da-f485-4e8c-e372-97dc51e12268" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot(sin)
```

```julia id="09299c37" executionInfo={"status": "ok", "timestamp": 1747801451766, "user_tz": -540, "elapsed": 63, "user": {"displayName": "", "userId": ""}} outputId="03d9250f-edf9-4e32-b019-7f1d095396ef" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot(Normal(3, 10))
```

<!-- #region id="97ec64a0" -->
### 標準正規分布乱数のプロット
<!-- #endregion -->

```julia id="685fde1b" executionInfo={"status": "ok", "timestamp": 1747801345461, "user_tz": -540, "elapsed": 93, "user": {"displayName": "", "userId": ""}} outputId="9e2776f6-6101-4e2a-dc3e-264490321fb9" colab={"base_uri": "https://localhost:8080/"}
# 標準正規分布の乱数を10^4個生成
Z = randn(10^4)
```

```julia id="dd456229" executionInfo={"status": "ok", "timestamp": 1747801465059, "user_tz": -540, "elapsed": 119, "user": {"displayName": "", "userId": ""}} outputId="efb59f80-5143-4f96-d69d-ca6a25d8d568" colab={"base_uri": "https://localhost:8080/", "height": 271}
histogram(Z; norm=true, alpha=0.5, label="")
```

```julia id="6b0c7bb9" executionInfo={"status": "ok", "timestamp": 1747801470353, "user_tz": -540, "elapsed": 297, "user": {"displayName": "", "userId": ""}} outputId="526add11-d543-4b13-c0c4-29289d8a3f80" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot!(x -> exp(-x^2/2)/sqrt(2pi), -4, 4; label="", lw=3)
```

<!-- #region id="da7be905" -->
### 確率分布の扱い方

(7) 確率分布を扱うためのパッケージを使うためには次を実行する:

```julia
import Pkg
Pkg.add("StatsPlots")
using StatsPlots
```

このノートブックでは最初のセルでこれと同等のことを実行できるようにしてあるので, 最初のセルを実行しておけばよい.
<!-- #endregion -->

```julia id="603ea88c" executionInfo={"status": "ok", "timestamp": 1747801663991, "user_tz": -540, "elapsed": 157, "user": {"displayName": "", "userId": ""}} outputId="64fbed5d-24dc-4dc1-df52-5fad55bdf9ce" colab={"base_uri": "https://localhost:8080/", "height": 271}
dist = Binomial(20, 0.3)
bar(dist; alpha=0.5, label="Binomial(20, 0.3)")
```

```julia id="B-FF58fHGwpl" executionInfo={"status": "ok", "timestamp": 1747801860603, "user_tz": -540, "elapsed": 47, "user": {"displayName": "", "userId": ""}} outputId="3a811eb3-f8a4-4f5f-8e19-28f339d94ab3" colab={"base_uri": "https://localhost:8080/"}
normal = Normal(10, 3)
```

```julia id="n_5T1sGvG6Vz" executionInfo={"status": "ok", "timestamp": 1747802047918, "user_tz": -540, "elapsed": 267, "user": {"displayName": "", "userId": ""}} outputId="17cbd8da-23df-4870-8542-da5147bf1ce2" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot(normal; label="Normal(10, 3)")
plot!(xtick=-10:30, tickfontsize=7) # -10:30は-10,-9,...,0,1,2,...,30
```

<!-- #region id="50439d8c" -->
### 正規分布の確率密度函数のプロット
<!-- #endregion -->

```julia id="b63eae5d" executionInfo={"status": "ok", "timestamp": 1747802597225, "user_tz": -540, "elapsed": 108, "user": {"displayName": "", "userId": ""}}
X = rand(Normal(2, 3), 10^4);
```

```julia id="87d3d94b" executionInfo={"status": "ok", "timestamp": 1747802597944, "user_tz": -540, "elapsed": 194, "user": {"displayName": "", "userId": ""}} outputId="9e776307-6942-4751-e6f8-2509393414ef" colab={"base_uri": "https://localhost:8080/", "height": 271}
stephist(X; norm=true, label="", title="sample of Normal(2, 3)")
```

```julia id="92656f9c" executionInfo={"status": "ok", "timestamp": 1747802598625, "user_tz": -540, "elapsed": 163, "user": {"displayName": "", "userId": ""}} outputId="4ad30f55-cc30-439b-8668-adb85f0ba819" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot!(Normal(2, 3); label="Normal(2, 3)", lw=1)
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

```julia id="5d7f3628" executionInfo={"status": "ok", "timestamp": 1747800784139, "user_tz": -540, "elapsed": 8052, "user": {"displayName": "", "userId": ""}} outputId="46b40736-f7d1-49e1-e6bf-c684a28248fe" colab={"base_uri": "https://localhost:8080/", "height": 325}
anscombe = dataset("datasets", "anscombe")
```

<!-- #region id="ac4ec146" -->
### データのプロットの仕方

以下ではデータ1の場合のプロットの仕方を説明しよう.
<!-- #endregion -->

```julia id="e4d4809d" executionInfo={"status": "ok", "timestamp": 1747802761009, "user_tz": -540, "elapsed": 51, "user": {"displayName": "", "userId": ""}} outputId="08d1bafe-13d1-4c95-8b2e-fedf4a55d64a" colab={"base_uri": "https://localhost:8080/"}
# x, y にデータを入れる
x, y = anscombe.X1, anscombe.Y1
```

```julia id="4e4122c4" executionInfo={"status": "ok", "timestamp": 1747802777601, "user_tz": -540, "elapsed": 71, "user": {"displayName": "", "userId": ""}} outputId="9118c26d-2e64-4856-c8ae-3079aaa5e141" colab={"base_uri": "https://localhost:8080/", "height": 271}
# 散布図を描いてみる
#using StatsPlots
scatter(x, y)
```

```julia id="91a489e6" executionInfo={"status": "ok", "timestamp": 1747803123494, "user_tz": -540, "elapsed": 95, "user": {"displayName": "", "userId": ""}} outputId="bc84f714-2fe8-4080-d075-e08fc1c701b7" colab={"base_uri": "https://localhost:8080/", "height": 271}
# xlim, ylimなどを追加
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14))
```

```julia id="fLGa0ZLWMKAl" executionInfo={"status": "ok", "timestamp": 1747803277936, "user_tz": -540, "elapsed": 445, "user": {"displayName": "", "userId": ""}} outputId="8ac53438-d56d-4fbf-812f-63fd3897bbdf" colab={"base_uri": "https://localhost:8080/"}
mean(Gamma(3, 5)), std(Gamma(3, 5)), var(Gamma(3, 5))
```

```julia id="aUPfNnpQMdFZ" executionInfo={"status": "ok", "timestamp": 1747803317464, "user_tz": -540, "elapsed": 1047, "user": {"displayName": "", "userId": ""}} outputId="b4e4483d-ccae-4dd1-82c4-4e5153b82988" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot(Gamma(3, 5))
```

```julia id="iGCf4jQKNfbR" executionInfo={"status": "ok", "timestamp": 1747803827289, "user_tz": -540, "elapsed": 174, "user": {"displayName": "", "userId": ""}} outputId="c8294f86-9c92-4eb3-97d6-49ca379c7f71" colab={"base_uri": "https://localhost:8080/", "height": 271}
gamma = Gamma(1000, 5)
plot(gamma, 4300, 5700)
plot!(Normal(mean(gamma), std(gamma)), ls=:dash)
```

```julia id="sllvctI1OmEa" executionInfo={"status": "ok", "timestamp": 1747803977949, "user_tz": -540, "elapsed": 123, "user": {"displayName": "", "userId": ""}} outputId="f741eb0d-e34e-464f-d9e2-cea1e2b9e6cf" colab={"base_uri": "https://localhost:8080/", "height": 271}
gamma = Gamma(100, 5)
mu, sigma = mean(gamma), std(gamma)
plot(gamma, mu-4sigma, mu+4sigma)
plot!(Normal(mu, sigma), ls=:dash)
```

```julia id="Xxvhmm2APB5g" executionInfo={"status": "ok", "timestamp": 1747803980911, "user_tz": -540, "elapsed": 153, "user": {"displayName": "", "userId": ""}} outputId="a409050d-78b0-4383-812c-b7740bd69a2b" colab={"base_uri": "https://localhost:8080/", "height": 271}
gamma = Gamma(30, 5)
mu, sigma = mean(gamma), std(gamma)
plot(gamma, mu-4sigma, mu+4sigma)
plot!(Normal(mu, sigma), ls=:dash)
```

```julia id="78df6e34" executionInfo={"status": "ok", "timestamp": 1747800785403, "user_tz": -540, "elapsed": 32, "user": {"displayName": "", "userId": ""}} outputId="552e63cf-947a-4c13-e62a-3616c6bc122d" colab={"base_uri": "https://localhost:8080/"}
# データの標本平均や不偏分散・不偏共分散を計算
xbar = mean(x)
```

```julia id="b5b447e2" executionInfo={"status": "ok", "timestamp": 1747800785437, "user_tz": -540, "elapsed": 28, "user": {"displayName": "", "userId": ""}} outputId="eeca35e5-166b-49ca-d538-a0d0b6089d8d" colab={"base_uri": "https://localhost:8080/"}
ybar = mean(y)
```

```julia id="e6465be7" executionInfo={"status": "ok", "timestamp": 1747800785523, "user_tz": -540, "elapsed": 82, "user": {"displayName": "", "userId": ""}} outputId="fcb6a117-cb41-44d5-ad51-be03faba141d" colab={"base_uri": "https://localhost:8080/"}
sx2 = var(x)
```

```julia id="d17baa6e" executionInfo={"status": "ok", "timestamp": 1747800785545, "user_tz": -540, "elapsed": 17, "user": {"displayName": "", "userId": ""}} outputId="cd4a0a0b-cc72-4aa8-d748-ba0782eb3e32" colab={"base_uri": "https://localhost:8080/"}
sy2 = var(y)
```

```julia id="22103ab4" executionInfo={"status": "ok", "timestamp": 1747800785588, "user_tz": -540, "elapsed": 36, "user": {"displayName": "", "userId": ""}} outputId="56604dae-3956-4651-a9bb-80e95870373e" colab={"base_uri": "https://localhost:8080/"}
sxy = cov(x, y)
```

```julia id="60504664" executionInfo={"status": "ok", "timestamp": 1747800785619, "user_tz": -540, "elapsed": 23, "user": {"displayName": "", "userId": ""}} outputId="9fb569d6-2236-4a55-fc50-fa2f520dd354" colab={"base_uri": "https://localhost:8080/"}
betahat = sxy/sx2
```

```julia id="9880b6d8" executionInfo={"status": "ok", "timestamp": 1747800785703, "user_tz": -540, "elapsed": 38, "user": {"displayName": "", "userId": ""}} outputId="7a8ab0c1-c4bd-49b8-87f6-a7362aec78e4" colab={"base_uri": "https://localhost:8080/"}
alphahat = ybar - betahat*xbar
```

```julia id="2fcb3cf4" executionInfo={"status": "ok", "timestamp": 1747804089549, "user_tz": -540, "elapsed": 285, "user": {"displayName": "", "userId": ""}} outputId="f7dea576-7963-44e5-bb83-19a892bf851b" colab={"base_uri": "https://localhost:8080/", "height": 271}
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14))
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2)
```

```julia id="db752f33" executionInfo={"status": "ok", "timestamp": 1747804104520, "user_tz": -540, "elapsed": 246, "user": {"displayName": "", "userId": ""}} outputId="efb09ff4-fdf3-42ee-aeff-0e19630a8071" colab={"base_uri": "https://localhost:8080/", "height": 271}
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14), title="Anscombe 1")
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2, ls=:dash)
```

```julia id="5f791ad6" executionInfo={"status": "ok", "timestamp": 1747800788847, "user_tz": -540, "elapsed": 2724, "user": {"displayName": "", "userId": ""}} outputId="2b734f63-9519-4041-f813-b12257555f60" colab={"base_uri": "https://localhost:8080/"}
# design matrix
X = x .^ (0:1)'
```

```julia id="95f493d7" executionInfo={"status": "ok", "timestamp": 1747800789644, "user_tz": -540, "elapsed": 804, "user": {"displayName": "", "userId": ""}} outputId="fb2e5a6a-9a49-4f9e-b09b-b9e2f320f6d2" colab={"base_uri": "https://localhost:8080/"}
# 最小二乗法を一発実現 (計画行列の一般逆行列をyにかける)
alphahat2, betahat2 = X \ y
```

```julia id="bce868f9" executionInfo={"status": "ok", "timestamp": 1747804165586, "user_tz": -540, "elapsed": 506, "user": {"displayName": "", "userId": ""}} outputId="68db6846-453c-4ffe-c2d7-bf289022bd3a" colab={"base_uri": "https://localhost:8080/", "height": 271}
# 2つの直線はぴったり重なり合う.
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14), title="Anscombe 1")
plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2)
plot!(x -> alphahat2 + betahat2*x, 3, 20; label="", lw=2, ls=:dash)
```

<!-- #region id="d5e17c68" -->
__問題:__ 他のアンスコムのデータについて同様のグラフを作成せよ.
<!-- #endregion -->

```julia id="rpsuI4MyP0z7" executionInfo={"status": "ok", "timestamp": 1747804216432, "user_tz": -540, "elapsed": 59, "user": {"displayName": "", "userId": ""}} outputId="9de314e1-a76f-4a01-c0e8-f55ac2dc79b0" colab={"base_uri": "https://localhost:8080/"}
# x, y にデータを入れる
x, y = anscombe.X2, anscombe.Y2
```

```julia id="5lCVsAmaP-Sd" executionInfo={"status": "ok", "timestamp": 1747804241162, "user_tz": -540, "elapsed": 14, "user": {"displayName": "", "userId": ""}} outputId="326444b0-3ea2-41b9-b688-2c6e665876dd" colab={"base_uri": "https://localhost:8080/"}
# design matrix
X = x .^ (0:1)'
```

```julia id="jAuuIEDmQHsb" executionInfo={"status": "ok", "timestamp": 1747804274888, "user_tz": -540, "elapsed": 59, "user": {"displayName": "", "userId": ""}} outputId="eb7eaf5a-3904-4cf7-b78f-b7fb8116d689" colab={"base_uri": "https://localhost:8080/"}
# 最小二乗法を一発実現 (計画行列の一般逆行列をyにかける)
alphahat2, betahat2 = X \ y
```

```julia id="0nfjd-3vQPDC" executionInfo={"status": "ok", "timestamp": 1747804303182, "user_tz": -540, "elapsed": 328, "user": {"displayName": "", "userId": ""}} outputId="8027888b-a231-4eee-ebff-809ad2e62090" colab={"base_uri": "https://localhost:8080/", "height": 271}
# 2つの直線はぴったり重なり合う.
scatter(x, y; label="", xlim=(3, 20), ylim=(2, 14), title="Anscombe 2")
#plot!(x -> alphahat + betahat*x, 3, 20; label="", lw=2)
plot!(x -> alphahat2 + betahat2*x, 3, 20; label="", lw=2, ls=:dash)
```

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

```julia id="2d86492f" executionInfo={"status": "ok", "timestamp": 1747800790130, "user_tz": -540, "elapsed": 124, "user": {"displayName": "", "userId": ""}}
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

```julia id="166eafb8" executionInfo={"status": "ok", "timestamp": 1747800790195, "user_tz": -540, "elapsed": 57, "user": {"displayName": "", "userId": ""}} outputId="b87befe7-a6a2-4148-89e9-08e2f16e84cd" colab={"base_uri": "https://localhost:8080/"}
# 行列Aの第j列はA[:,j]
@show datasaurus[:,1];
```

```julia id="a8263561" executionInfo={"status": "ok", "timestamp": 1747804407830, "user_tz": -540, "elapsed": 185, "user": {"displayName": "", "userId": ""}} outputId="dd4c25ce-e06b-4889-e4e4-7e9e4a9bf3e9" colab={"base_uri": "https://localhost:8080/", "height": 271}
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

```julia id="9ac111f7" executionInfo={"status": "ok", "timestamp": 1747804719496, "user_tz": -540, "elapsed": 16, "user": {"displayName": "", "userId": ""}} outputId="0ea4de32-aa63-43a1-9e22-9a704bf57ce8" colab={"base_uri": "https://localhost:8080/"}
# 確率分布を dist と書く.
dist = Gamma(2, 3)
```

```julia id="j95ymlBwRAZW" executionInfo={"status": "ok", "timestamp": 1747804720337, "user_tz": -540, "elapsed": 99, "user": {"displayName": "", "userId": ""}} outputId="6c07d38b-40f1-48fe-c293-f1688e69bd8e" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot(dist)
```

```julia id="ef715957" executionInfo={"status": "ok", "timestamp": 1747804721078, "user_tz": -540, "elapsed": 110, "user": {"displayName": "", "userId": ""}} outputId="9906c6da-1b90-4fad-8fd4-9ea6419c91ac" colab={"base_uri": "https://localhost:8080/"}
# 確率分布 dist のサイズ n のサンプルを L 個生成
n = 10
L = 10^4
Xs = [rand(dist, n) for _ in 1:L]
```

```julia id="51fb2677" executionInfo={"status": "ok", "timestamp": 1747804721769, "user_tz": -540, "elapsed": 59, "user": {"displayName": "", "userId": ""}} outputId="5c702cc8-cb84-4acf-fcca-67859d38fe97" colab={"base_uri": "https://localhost:8080/"}
# L個のサイズnのサンプルの各々の標本平均を計算
Xbars = mean.(Xs)
```

```julia id="452d0158" executionInfo={"status": "ok", "timestamp": 1747804722537, "user_tz": -540, "elapsed": 155, "user": {"displayName": "", "userId": ""}} outputId="df9b19f9-0fad-4d0e-d7d6-427b3338c71d" colab={"base_uri": "https://localhost:8080/", "height": 271}
# Xbarのヒストグラムを表示
histogram(Xbars; norm=true, alpha=0.5, label="", title="$dist, n=$n")
```

```julia id="b83a1413" executionInfo={"status": "ok", "timestamp": 1747804778815, "user_tz": -540, "elapsed": 123, "user": {"displayName": "", "userId": ""}} outputId="0ffd4781-0f78-4977-befc-030170769b48" colab={"base_uri": "https://localhost:8080/"}
# 中心極限定理による正規分布近似を設定
mu = mean(dist)
sigma = std(dist)
normal_approx = Normal(mu, sigma/sqrt(n))
```

```julia id="073e0c6e" executionInfo={"status": "ok", "timestamp": 1747804781738, "user_tz": -540, "elapsed": 127, "user": {"displayName": "", "userId": ""}} outputId="804f1e80-f402-46c5-b0f6-5f17564b6f8d" colab={"base_uri": "https://localhost:8080/", "height": 271}
# 上のグラフに重ねて正規分布をプロット
plot!(normal_approx; label="normal approx", lw=2)
```

<!-- #region id="ab543863" -->
$n=10$ が小さすぎてずれが大きい.
<!-- #endregion -->

```julia id="c466159d" executionInfo={"status": "ok", "timestamp": 1747804806326, "user_tz": -540, "elapsed": 275, "user": {"displayName": "", "userId": ""}} outputId="71c572bd-7304-4490-bd55-6e1b8d860152" colab={"base_uri": "https://localhost:8080/", "height": 271}
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

```julia id="yXwKvCurSdnR" executionInfo={"status": "ok", "timestamp": 1747804910957, "user_tz": -540, "elapsed": 4323, "user": {"displayName": "", "userId": ""}} outputId="c388df25-6539-4b32-8ae7-274e27d1256e" colab={"base_uri": "https://localhost:8080/", "height": 271}
# nを大きくしてやり直してみる.
n = 100
L = 10^6
Xs = [rand(dist, n) for _ in 1:L]
Xbars = mean.(Xs)
stephist(Xbars; norm=true, label="", title="$dist, n=$n")
mu = mean(dist)
sigma = std(dist)
normal_approx = Normal(mu, sigma/sqrt(n))
plot!(normal_approx; label="normal approx", lw=2)
```

<!-- #region id="aca07a90" -->
$n=100$ にしたら, 正規分布とよく一致するようになった.
<!-- #endregion -->

```julia id="cdb77c2f" executionInfo={"status": "ok", "timestamp": 1747804983914, "user_tz": -540, "elapsed": 635, "user": {"displayName": "", "userId": ""}} outputId="51ed1e1e-56bb-4cc0-b45f-fde28e360d67" colab={"base_uri": "https://localhost:8080/", "height": 271}
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

```julia id="3ec9888d" executionInfo={"status": "ok", "timestamp": 1747805027762, "user_tz": -540, "elapsed": 6832, "user": {"displayName": "", "userId": ""}} outputId="a216d726-dc06-4e40-cac4-46b51c4339ed" colab={"base_uri": "https://localhost:8080/", "height": 271}
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

```julia id="94aa7205" executionInfo={"status": "ok", "timestamp": 1747800797498, "user_tz": -540, "elapsed": 245, "user": {"displayName": "", "userId": ""}} outputId="ab95b709-fcbe-48ac-b383-6b35770e4bf4" colab={"base_uri": "https://localhost:8080/"}
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

```julia id="bd829972" executionInfo={"status": "ok", "timestamp": 1747800797696, "user_tz": -540, "elapsed": 187, "user": {"displayName": "", "userId": ""}} outputId="1630b81f-43ed-4c0d-f547-1d69d50c71b8" colab={"base_uri": "https://localhost:8080/", "height": 289}
hello_sine()
```

```julia id="b9ed0da0" executionInfo={"status": "ok", "timestamp": 1747800799040, "user_tz": -540, "elapsed": 1303, "user": {"displayName": "", "userId": ""}} outputId="584d9e82-a2d7-45a5-e872-560381aa563e" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Uniform(), 10)
```

```julia id="32707a9a" executionInfo={"status": "ok", "timestamp": 1747800799710, "user_tz": -540, "elapsed": 664, "user": {"displayName": "", "userId": ""}} outputId="171c2112-6fff-4a46-a987-220056baaf54" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Laplace(), 10)
```

```julia id="09b12d6b" executionInfo={"status": "ok", "timestamp": 1747800800275, "user_tz": -540, "elapsed": 558, "user": {"displayName": "", "userId": ""}} outputId="3e85cea8-095f-4377-8db5-44ffa39672e4" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Gamma(2, 3), 10)
```

```julia id="fb696de1" executionInfo={"status": "ok", "timestamp": 1747800800548, "user_tz": -540, "elapsed": 264, "user": {"displayName": "", "userId": ""}} outputId="184fa10d-9c72-4342-fdf0-a1e361b8ce0d" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Gamma(2, 3), 100)
```

```julia id="7c3f3c1f" executionInfo={"status": "ok", "timestamp": 1747800800963, "user_tz": -540, "elapsed": 410, "user": {"displayName": "", "userId": ""}} outputId="ce711c47-2243-4e41-cd5a-9174165bcc60" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Gamma(2, 3), 1000)
```

```julia id="b8dff73d" executionInfo={"status": "ok", "timestamp": 1747800801436, "user_tz": -540, "elapsed": 467, "user": {"displayName": "", "userId": ""}} outputId="036e3a7c-f20a-46eb-8011-b9eb8194f4c6" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Exponential(), 10)
```

```julia id="16534a0c" executionInfo={"status": "ok", "timestamp": 1747800801519, "user_tz": -540, "elapsed": 77, "user": {"displayName": "", "userId": ""}} outputId="231180fc-eb6c-4b91-b3e3-75f658c41eb3" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Exponential(), 100)
```

```julia id="f09b2842" executionInfo={"status": "ok", "timestamp": 1747800802075, "user_tz": -540, "elapsed": 547, "user": {"displayName": "", "userId": ""}} outputId="500b0274-1c00-46e5-b5d1-81febf5d33ad" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Bernoulli(), 10)
```

```julia id="873f63c7" executionInfo={"status": "ok", "timestamp": 1747800802171, "user_tz": -540, "elapsed": 92, "user": {"displayName": "", "userId": ""}} outputId="98b99dac-0578-42d5-88d0-2b26a5c66a38" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Bernoulli(), 100)
```

```julia id="a6e3c037" executionInfo={"status": "ok", "timestamp": 1747800802350, "user_tz": -540, "elapsed": 171, "user": {"displayName": "", "userId": ""}} outputId="a4bbc701-06d0-4c1a-9e9a-c20e94577f83" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Bernoulli(0.2), 10)
```

```julia id="3de5b99c" executionInfo={"status": "ok", "timestamp": 1747800802606, "user_tz": -540, "elapsed": 251, "user": {"displayName": "", "userId": ""}} outputId="b51bb2b9-2001-4c9a-a9f6-738857ce3df4" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Bernoulli(0.2), 100)
```

```julia id="f8920a1b" executionInfo={"status": "ok", "timestamp": 1747800803118, "user_tz": -540, "elapsed": 518, "user": {"displayName": "", "userId": ""}} outputId="7b780d57-25f7-4c14-a950-d1a89ca33fe9" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Poisson(), 10)
```

```julia id="f3461a81" executionInfo={"status": "ok", "timestamp": 1747800803436, "user_tz": -540, "elapsed": 311, "user": {"displayName": "", "userId": ""}} outputId="4c8cdf2d-e279-4f76-e6a9-3ab4556cf4d2" colab={"base_uri": "https://localhost:8080/", "height": 271}
plot_dist_clt(Poisson(), 100)
```

```julia id="55c1512b" executionInfo={"status": "ok", "timestamp": 1747800803447, "user_tz": -540, "elapsed": 6, "user": {"displayName": "", "userId": ""}}

```
