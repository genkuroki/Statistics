# 数理統計学2022

## 資料

[Jupyter](https://jupyter.org/) notebook をオンラインで読むなら [nbviewer](https://nbviewer.org/) 経由の閲覧がおすすめです。オフラインでも読めるようにするためには pdf ファイルをダウンロードしてください。

[Julia言語](https://julialang.org/)を使って数値の計算やグラフの作画を行っています。[WolframAlpha](https://www.wolframalpha.com/)も併用しています。

__明らかな誤りをまだ大量に含んでいるものと思われます。ごめんなさい。適切に訂正しながら読んでください。__

### 01 Bernoulli試行と関連確率分布

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.pdf)\]

__定義された分布__

* __カテゴリカル分布__: Categorical(p_1,…,p_n)
* 成功確率 p の __Bernoulli分布__: Bernoulli(p)
* 試行回数 n の __Bernoulli試行の分布__: Bernoulli(p)ⁿ
* 試行回数 n, 成功確率 p の __二項分布__: Binomial(n, p)
* 成功階数 k, 成功確率 p の __負の二項分布__: NegativeBinomial(n, p) = NegBin(n, p)
* 成功確率 p の __幾何分布__: Geometric(p) = NegativeBinomial(1, p)
* 0～1のあいだの __一様分布__: Uniform(0, 1)
* 試行回数 n の __一様乱数生成の繰り返しの分布__: Uniform(0, 1)ⁿ
* 平均 μ, 分散 σ² (標準偏差 σ)の __正規分布__: Normal(μ, σ)
* __標準正規分布__: Normal() = Normal(0, 1)
* 分布 D の __アフィン変換___: aD+b
* 分布 D の __スケール変換__: aD (a > 0)
* 分布 D の __平行移動__: D + b
* 分布 D の __逆数__: 1/D

### 02 Gauss積分, ガンマ函数, ベータ函数

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.ipynb)
\[[nbvewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.pdf)\]

__定義された分布__

* 正規分布 (再): Normal(μ, σ) = μ + σ Normal(0, 1)
* 形状パラメータ α, スケールパラメータ θ の __ガンマ分布__: Gamma(α, θ) = θ Gamma(α, 1)
* 平均 θ の __指数分布__: Exponential(θ) = Gamma(1, θ)
* 形状パラメータ α, スケールパラメータ θ の __逆ガンマ分布__: InverseGamma(α, θ) = 1/Gamma(α, 1/θ)
* 自由度 ν の __χ²分布__(カイ二乗分布): Chisq(ν) = Gamma(ν/2, 2)
* パラメータ α, β の __ベータ分布__: Beta(α, β)
* 自由度 ν の __t分布__: TDist(ν) (Beta(1/2, ν/2) と密接に関係)
* パラメータ α, β の __ベータプライム分布__: BetaPrime(α, β) = 1/(1-Beta(α, β))-1  (分布 Beta(α, β) のオッズ u = t/(1-t)=1/(1-t)-1 への変) 
* 自由度 (ν₁, ν₂) の __F分布__: FDist(ν₁, ν₂) = (ν₂/ν₁)BetaPrime(ν₁/2, ν₂/2)
* __Dirichlet分布__: Dirichlet(α_1,…,α_n)  (n=2の場合がベータ分布と一致)

### 03 確率分布達の解釈

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/03%20Interpretation%20of%20probability%20distributions.pdf)\]

__定義された分布__

* __対数正規分布__: LogNormal(μ, σ) = exp(Normal(μ, σ))
* 期待値 λ の __Poisson分布__(ポアソン分布): Poisson(λ)
* __負の二項分布__ (Poisson分布の期待値パラメータがガンマ分布に従う場合): NegativeBinomial(α, 1/(1+θ))
* __ベータ二項分布__: BetaBinomial(n, α, β)
* __超幾何分布__: Hypergeometric(s, f, n)

### 04 標本分布について

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/04%20Distribution%20of%20samples.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/04%20Distribution%20of%20samples.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/04%20Distribution%20of%20samples.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/04%20Distribution%20of%20samples.pdf)\]

__演習用サンプル__

* アンスコムの例
  * [csv file](https://github.com/genkuroki/Statistics/blob/master/2022/data/anscombe.csv), [raw version](https://raw.githubusercontent.com/genkuroki/Statistics/master/2022/data/anscombe.csv)
  * [transposed version](https://github.com/genkuroki/Statistics/blob/master/2022/data/anscombe_transposed.csv), [transposed raw version](https://raw.githubusercontent.com/genkuroki/Statistics/master/2022/data/anscombe_transposed.csv)

__定義された分布__

* 分布達 D₁,…,Dₙ の __積__: D₁×⋯×Dₙ
* 分布 D の __累乗__: Dⁿ
* 分布 D のサイズnの __標本分布__: Dⁿ

### 05 中心極限定理について

* [Jupyter notebook]()
\[[nbviewer]()\]
* [pdf]()
\[[download]()\]

__演習用サンプル__

__定義された分布__

### 99 テンプレート

* [Jupyter notebook]()
\[[nbviewer]()\]
* [pdf]()
\[[download]()\]

__演習用サンプル__

__定義された分布__

---

## 参考資料

### 以上で解説できなかったことに関するノート

* Kullback-Leibler情報量とSanovの定理 (2016-2018) \[[pdf](https://genkuroki.github.io/documents/20160616KullbackLeibler.pdf)\]
* ガンマ分布の中心極限定理とStirlingの公式 (2016-2018) \[[pdf](https://genkuroki.github.io/documents/20160501StirlingFormula.pdf)\]
* 一般化されたLaplaceの方法 (2016) \[[pdf](https://genkuroki.github.io/documents/20161014GeneralizedLaplace.pdf)\]
* 最尤法とカイ二乗検定の基礎 (2017-2020) \[[pdf](https://genkuroki.github.io/documents/IntroMLE.pdf)\]
* 確率論入門 (2017) \[[pdf](https://genkuroki.github.io/documents/IntroProbability.pdf)\]
* ベイズ統計入門 (手書きのノート, 2019) \[[pdf](https://genkuroki.github.io/documents/2019-09-03_BayesianStatistics.pdf)\]
* ベイズ統計の枠組みと解釈について (2019) \[[Jupyter notebook](https://nbviewer.org/github/genkuroki/Statistics/blob/master/Introduction%20to%20Bayesian%20Statistics.ipynb)\]
* Kullback-Leibler情報量と記述統計 (2019-2020) \[[Jupyter notebook](https://nbviewer.org/github/genkuroki/Statistics/blob/master/KL%20information%20and%20descriptive%20statistics.ipynb)\]

