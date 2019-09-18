# 統計学

著者: 黒木玄

## Bayse統計関連のノート

* [ベイズ統計の枠組みと解釈について](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/Introduction%20to%20Bayesian%20Statistics.ipynb): 2019年9月17日(火)午後のセミナーのために準備したJupyterノートブック

* [ベイズ統計の手書きのノート](https://genkuroki.github.io/documents/2019-09-03_BayesianStatistics.pdf) ([MetaMojiNote形式](2019-09-03_BayesianStatistics.atdoc)): 2019年9月17日(火)午後のセミナーのために準備した手書きのノート

* [3種の簡単な統計モデルのベイズ統計の比較 n=128](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/Comparison%20the%20mixnormal%2C%20normal1%2C%20and%20normal%20models%20by%20samples%20of%20size%20128.ipynb): $N(x|\mu,\sigma)$ は平均 $\mu$, 分散 $\sigma$ の正規分布の密度函数であるとする. 

$$
\begin{aligned}
&
p_{\mathrm{mixnormal}}(x|a,b)=(1-a)N(x|0,1)+aN(x|b,1),
\\ &
p_{\mathrm{normal}}(x|\mu,\sigma)=N(x|\mu,\sigma),
\\ &
p_{\mathrm{normal1}}(x|\mu)=N(x|\mu,1)
\end{aligned}
$$

の3つのモデルで母集団分布 $q(x)=N(x|0,1)$ のサンプルをBayes推定した結果の比較.  この状況ではmixnormalモデルは特異モデルになっている.

* [DynamicHMCExamples for DynamicHMC.jl v2.0.0](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/DynamicHMCExamples%20for%20DynamicHMC.jl%20v2.0.0.ipynb): [Julia言語](https://julialang.org/)でのNUTSの実装例である[DynamicHMC.jl](https://github.com/tpapp/DynamicHMC.jl)の使用例.

## 雑多なノート

* [尤度函数のプロット](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/likelihood%20functions%20of%20mixture%20normal%20distributions.ipynb): 簡単な1次元の混合正規分布モデルの尤度函数をプロット. 特異モデルに近い正則モデルの尤度函数はまるで特異モデルであるかのような形状になる.

* [Kullback-Leibler情報量と記述統計](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/KL%20information%20and%20descriptive%20statistics.ipynb): 任意の正規分布になっているとは限らない母集団分布のサンプルへの正規分布モデルの最尤法の適用はサンプルの平均と分散を記述することに一致する. Laplace分布モデルの最尤法を適用はサンプルの中央値を求めることを含む.

* [母平均の仮説検定と区間推定](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/Hypothesis%20test%20and%20interval%20estimation%20for%20population%20mean.ipynb): 現実の母集団分布が正規分布になっているという仮定は要注意である.
