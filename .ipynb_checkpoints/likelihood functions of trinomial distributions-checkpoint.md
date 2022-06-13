---
jupyter:
  jupytext:
    cell_metadata_json: true
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

# 三項分布の尤度函数

黒木玄

2019-09-21

$n$ が増えると尤度函数の広がり方は段々狭くなる.

<!-- #region {"toc": true} -->
<h1>目次<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"><li><span><a href="#三項分布" data-toc-modified-id="三項分布-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>三項分布</a></span></li><li><span><a href="#三項分布のサンプルの尤度函数" data-toc-modified-id="三項分布のサンプルの尤度函数-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>三項分布のサンプルの尤度函数</a></span></li><li><span><a href="#尤度函数を最大にするパラメーターの値" data-toc-modified-id="尤度函数を最大にするパラメーターの値-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>尤度函数を最大にするパラメーターの値</a></span></li><li><span><a href="#最尤法" data-toc-modified-id="最尤法-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>最尤法</a></span></li><li><span><a href="#三項分布モデルの尤度函数の形" data-toc-modified-id="三項分布モデルの尤度函数の形-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>三項分布モデルの尤度函数の形</a></span></li></ul></div>
<!-- #endregion -->

## 三項分布

1と2の目のみが出るルーレットを回したとき, $1$ が出る確率は $p$ であると仮定する. このときそのルーレットを $n$ 回まわしたときに1の目が $k$ 回出る確率は $n$ 個から $k$ 個選ぶ組み合わせの個数と $p^k(1-p)^{n-k}$ の積

$$
\frac{n!}{k!(n-k)!}p^k(1-p)^{n-k}
$$

になる. これが二項分布の確率である.

三項分布も同じように得られる. 1,2,3の目のみが出るルーレットを回したとき, $1$ の目が出る確率を $p$, $2$ の目が出る確率を $q$ と書くとき(そのとき $3$ の目が出る確率は $1-p-q$ になる), そのルーレットを $n$ 回まわしたとき, $1$ の目が $k$ 回, $2$ の目が $l$ 回, $3$ の目が $n-k-l$ 回出る確率は

$$
\frac{n!}{k!l!(n-k-l)!}p^k q^l (1-p-q)^{n-k-l}
$$

と表わされる. これを三項分布の確率と呼ぶ.  $p,q$ を $n$ に対する三項分布のパラメーターと呼ぶ.


## 三項分布のサンプルの尤度函数

$p_0, q_0 \geqq 0$, $p_0+q_0\leqq 1$ と仮定する.

$p_0,q_0$ をパラメーターとする三項分布の確率でランダムに生成された $(k, l, n-k-l)$ を真のパラメーター $(p_0, q_0)$ の三項分布の**サンプル (標本)** と呼ぶ. 以下 $(k, l, n-k-l)$ はサンブルであると仮定する.

与えられたサンプル $(k,l,n-k-l)$ に対して, パラメーター $(p,q)$ に三項分布でそのサンプルが生成される確率を対応させる函数

$$
f(p,q) = \frac{n!}{k!l!(n-k-l)!}p^k q^l (1-p-q)^{n-k-l}
$$

を尤度函数と呼ぶ.  尤度函数の値はパラメーター $(p,q)$ の三項分布からサンプルどれだけ生成され易いかを表している.


## 尤度函数を最大にするパラメーターの値

尤度函数 $f(p,q)$ を最大化するパラメーター $(p,q)$ を求めよう. $f(p,q)$ を最大化するためには

$$
F(p,q) = \log f(p,q) = k\log p + l\log q + (n-k-l)\log(1-p-q)
$$

を最大化すればよい. 

(1) $F(p,q)$ が上に凸な函数であることを示そう. そのためには, $k,l,m>0$ のとき

$$
G(p,q,r) = k\log p + l\log q + m\log r
$$

が上に凸な函数であることを示せばよい. しかし, これは対数函数が上に凸な函数であることより明らかである. 

(2) $F(p,q)$ を最大化する $p,q$ は

$$
p:q:1-p-q=k:l:n-k-l
$$

を満たす $(p,q)$ であることを示そう. $F=F(p,q)$ は上に凸な函数なのでその1階の偏導函数が $0$ になる $(p,q)$ が $F$ を最大化する $(p,q)$ になる.

$$
F_p = \frac{k}{p} - \frac{n-k-l}{1-p-q}, \quad
F_q = \frac{l}{q} - \frac{n-k-l}{1-p-q},
$$

なので, $F_p=F_q=0$ と 

$$
\frac{k}{p} = \frac{l}{q} = \frac{n-k-l}{1-p-q}
$$

は同値である. これは $p,q,1-p-q$ と $k,l,n-k-l$ の比が等しいことを意味している.


## 最尤法

与えられたサンプル $(k,l,n-k-l)$ に対して, 三項分布でそのサンプルが生成される確率(尤度と呼ばれる)を最大化するパラメーター $(p,q)$ を求め, 求めたパラメーターに対応する三項分布がサンプルを生成した真の三項分布を近似していると期待する推定法を**最尤法**と呼ぶ.

前節の結果より, サンプルが $(k,l,n-k-l)$ の場合の解は

$$
p = \frac{k}{n}, \quad
q = \frac{l}{n}, \quad
1-p-q = \frac{n-k-l}{n}
$$

になる.  すなわち, サンプル中の各目の割合をその目が出る真の確率の近似値とみなす推定法がこの場合の最尤法だということになる.


## 三項分布モデルの尤度函数の形

尤度函数の形は単峰型になる. そして山型の尤度函数の広がり方は $n$ が大きくなればなるほど狭くなる.  そのことをサンプルをランダムに何回も生成して尤度函数をプロットすることによって視覚的に確認しよう.

```julia
using Base64
displayfile(mime, file; tag="img") = open(file) do f
    display("text/html", """<$tag src="data:$mime;base64,$(base64encode(f))">""")
end

using Plots
gr()
default(titlefontsize=10)
using ImplicitEquations

using Distributions

# 尤度函数 (p + q > 1 では値を NaN に設定)
likelihood_func(p, q; x=[34, 32, 34]) = if p + q ≤ 1
    pdf(Multinomial(sum(x), [p, q, max(0, 1-p-q)]), x)
else
    NaN
end

# 1フレーム分のプロット
function plot_random_linkelihood_func(n; p₀=0.3, q₀=0.3, α=0.05)
    true_dist = Multinomial(n, [p₀, q₀, max(0, 1-p₀-q₀)]) # サンプルを生成する確率分布
    tau = cquantile(Chisq(2), α)
    X = rand(true_dist) # サンプルXをランダムに生成
    k, l = X[1], X[2]
    phat, qhat = k/n, l/n # 最尤法の解
    MLE_str = "($(round(phat, digits=2)), $(round(qhat, digits=2)))"

    p = q = range(0, 1, length=201)
    z = likelihood_func.(p', q; x=X) # サンプルXから得られる尤度函数の値の計算

    P1 = plot(; title="n = $n, sample = ($k, $l, $(n-k-l))")
    heatmap!(p, q, z; colorbar=false, aspectratio=1)
    scatter!([p₀], [q₀]; color=:cyan, markerstrokewidth=0, markersize=3, label="true param")
    scatter!([phat], [qhat]; color=:blue, markerstrokewidth=0, markersize=2.5, label=MLE_str)
    plot!(xlim=(0,1), ylim=(0,1))
    plot!(xlabel="p", ylabel="q")
    
    P2 = surface(p, q, z; colorbar=false, gridalpha=0.5, grid_lw=0.5)
    plot!(xlabel="p", ylabel="q")
    
    plot(P1, P2; size=(800, 400))
end

# GiF動画を作成
function gif_random_linkelihood_func(n; p₀=0.3, q₀=0.3, nframes=100, fps=2, fn="images/lik$n.gif")
    anim = @animate for i in 1:nframes
        plot_random_linkelihood_func(n; p₀=p₀, q₀=q₀, α=0.05)
    end
    gif(anim, fn, fps=fps)
    displayfile("image/gif", fn)
end
```

```julia
gif_random_linkelihood_func(10)
```

```julia
gif_random_linkelihood_func(30)
```

```julia
gif_random_linkelihood_func(100)
```

```julia
gif_random_linkelihood_func(300)
```

```julia
gif_random_linkelihood_func(1000)
```

```julia

```
