# 数理統計学2022

## 資料

[Jupyter](https://jupyter.org/) notebook をオンラインで読むなら [nbviewer](https://nbviewer.org/) 経由の閲覧がおすすめです。オフラインでも読めるようにするためには pdf ファイルをダウンロードしてください。

[Julia言語](https://julialang.org/)を使って数値的な計算はグラフの作画を行っています。[WolframAlpha](https://www.wolframalpha.com/)も併用しています。

__明らかな誤りをまだ大量に含んでいるものと思われます。ごめんなさい。適切に訂正しながら読んでください。__

### 01 Bernoulli試行と関連確率分布

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.pdf)\]

__定義された分布__

* カテゴリカル分布: Categorical(p_1,…,p_n)
* 試行回数 n のBernoulli試行の分布: Bernoulli(p)ⁿ
* 成功確率 p のBernoulli分布: Bernoulli(p)
* 試行回数 n, 成功確率 p の二項分布: Binomial(n, p)
* 成功階数 k, 成功確率 p の負の二項分布: NegativeBinomial(n, p) = NegBin(n, p)
* 成功確率 p の幾何分布: Geometric(p) = NegativeBinomial(1, p)
* 0～1のあいだの一様分布: Uniform(0, 1)
* 試行回数 n の一様乱数生成の分布: Uniform(0, 1)ⁿ
* 平均 μ, 分散 σ² (標準偏差 σ)の正規分布: Normal(μ, σ)
* 標準正規分布: Normal() = Normal(0, 1)

### 02 Gauss積分, ガンマ函数, ベータ函数

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.ipynb)
\[[nbvewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.pdf)\]

__定義された分布__

* 正規分布(再): Normal(μ, σ)
* 形状パラメータ α, スケールパラメータ θ のガンマ分布: Gamma(α, θ)
* 平均 θ の指数分布: Exponential(θ) = Gamma(1, θ)
* 自由度 ν のχ²分布(カイ二乗分布): Chisq(ν) = Gamma(ν/2, 2)
* パラメータ α, β のベータ分布: Beta(α, β)
* 自由度 ν のt分布: TDist(ν) (Beta(1/2, ν/2) と密接に関係)
* 自由度 (ν₁, ν₂) のF分布: FDist(ν₁, ν₂) (本質的にオッズに関する Beta(ν₁/2, ν₂/2) 分布)
* Dirichlet分布: Dirichlet(α_1,…,α_n)  (n=2の場合がベータ分布と一致)

### 03 確率分布達の解釈

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/03%20Interpretation%20of%20probability%20distributions.pdf)\]

__定義された分布__

* 対数正規分布: LogNormal(μ, σ)
* 期待値 λ のPoisson分布(ポアソン分布): Poisson(λ)
* 負の二項分布 (Poisson分布の期待値パラメータがガンマ分布に従う場合): NegativeBinomial(α, 1/(1+θ))
* ベータ二項分布: BetaBinomial(n, α, β)

### 99 テンプレート

* [Jupyter notebook]()
\[[nbviewer]()\]
* [pdf]()
\[[download]()\]

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

