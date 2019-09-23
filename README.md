# 統計学

著者: 黒木玄

## Bayse統計関連のノート

● [三項分布の尤度函数 2019-09-21](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/likelihood%20functions%20of%20trinomial%20distributions.ipynb): 三項分布の尤度函数のGIFアニメーション. nを大きくすると尤度函数の広がり方は狭くなる.

● [ベイズ統計の枠組みと解釈について (2019-09-16)](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/Introduction%20to%20Bayesian%20Statistics.ipynb) ([PDF版](https://genkuroki.github.io/documents/Statistics/Introduction%20to%20Bayesian%20Statistics.pdf)): 2019年9月17日(火)午後のセミナーのために準備したJupyterノートブック

● [3種の簡単な統計モデルのベイズ統計の比較 n=128 (2019-09-08)](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/Comparison%20the%20mixnormal%2C%20normal1%2C%20and%20normal%20models%20by%20samples%20of%20size%20128.ipynb): N(x|μ,σ) は平均 μ, 分散 σ の正規分布の密度函数であるとする. 

1. mixnormal(x|a,b) = (1-a) N(x|0,1) + a N(x|b,1),
2. normal(x|μ,σ) = N(x|μ,σ),
3. normal1(x|μ) = N(x|μ,1)

の3つのモデルで母集団分布 q(x)=N(x|0,1) のサンプルをBayes推定した結果の比較.  この状況ではmixnormalモデルは特異モデルになっている.

● [ベイズ統計に関する手書きのノート (2019-09-03)](https://genkuroki.github.io/documents/2019-09-03_BayesianStatistics.pdf) ([MetaMojiNote形式](2019-09-03_BayesianStatistics.atdoc)): 2019年9月17日(火)午後のセミナーのために準備した手書きのノート

● [DynamicHMCExamples for DynamicHMC.jl v2.0.0 (2019-08-26～2019-09-03)](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/DynamicHMCExamples%20for%20DynamicHMC.jl%20v2.0.0.ipynb): [Julia言語](https://julialang.org/)でのNUTSの実装の1つである [DynamicHMC.jl](https://github.com/tpapp/DynamicHMC.jl) の使用例.

## 統計学関連のノート

● [尤度函数のプロット 2019-09-17](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/likelihood%20functions%20of%20mixture%20normal%20distributions.ipynb): 簡単な1次元の混合正規分布モデルの尤度函数をプロット. 特異モデルに近い正則モデルの尤度函数はまるで特異モデルであるかのような形状になる.

● [母平均の仮説検定と区間推定 2019-09-14](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/Hypothesis%20test%20and%20interval%20estimation%20for%20population%20mean.ipynb): 現実の母集団分布が正規分布になっているという仮定は要注意である.

● [Kullback-Leibler情報量と記述統計 2019-09-13](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/KL%20information%20and%20descriptive%20statistics.ipynb) ([PDF版](https://genkuroki.github.io/documents/Statistics/KL%20information%20and%20descriptive%20statistics.pdf)): 任意の正規分布になっているとは限らない母集団分布のサンプルへの正規分布モデルの最尤法の適用はサンプルの平均と分散を記述することに一致する. Laplace分布モデルの最尤法を適用はサンプルの中央値を求めることを含む.

● [混合正規分布について正規分布モデルで信頼区間を求めた場合 2019-08-17～2019-08-19](https://nbviewer.jupyter.org/github/genkuroki/Statistics/blob/master/%E6%B7%B7%E5%90%88%E6%AD%A3%E8%A6%8F%E5%88%86%E5%B8%83%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6%E6%AD%A3%E8%A6%8F%E5%88%86%E5%B8%83%E3%83%A2%E3%83%87%E3%83%AB%E3%81%A7%E4%BF%A1%E9%A0%BC%E5%8C%BA%E9%96%93%E3%82%92%E6%B1%82%E3%82%81%E3%81%9F%E5%A0%B4%E5%90%88.ipynb): 母集団の中に含まれる小さな割合の部分集団が全体の平均に影響を与えるくらい飛び離れた値を持っている場合には, 正規分布モデルによる区間推定が失敗する確率は非常に高くなる.

## このリポジトリ外に置いてある昔のノート

● [正規分布と混合正規分布のKL情報量のプロット 2018-04-10 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/b4697ce70f356cebd27e784fe556263f): Q(a,b)を混合正規分布とし, P(μ,σ)を正規分布とするときのKL(P(μ,σ), Q(a,b))を最小化するμ,σをプロットした. (a,b)について, KL(P(μ,σ), Q(a,b))を最小化する(μ,σ)は不連続函数になることがわかる.

● [混合正規分布と正規分布のKL情報量 2018-04-08 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/34a79d95cd150150a33029f89389be43): Qを混合正規分布とし, P(μ,σ)を正規分布とするとき, KL(Q, P(μ,σ))を最小化するμ,σはそれぞれQの平均と分散になる. それでは, KL(P(μ,σ), Q)を最小化するμ,σはどうなるだろうか? こちらの場合には混合正規分布Qが少し変化しただけで, μ,σが大きく変化することがある.

● [KL情報量に関するSanovの定理の数値的確認 2018-04-08 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/73583088dc80a23f4673a7d3131482fc): Sanovの定理の直接的な数値的確認はかなり苦しい.

● [過学習の過程の動画 LASSO版 2018-03-25, 2018-04-04, 2018-09-19 (Julia v1.0以上)](https://nbviewer.jupyter.org/gist/genkuroki/c08b416648d4d7db4948ffac6abeadfd): LASSO回帰のハイパーパラメーターを調節している.  LASSO回帰無し(λ=0)の場合にはかなりひどいオーバーフィッティングが観察される.

● [過学習の過程の動画 2018-03-25 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/c440bc748ba230921c1a1f3613053b21): 警告. この動画中のAICはAICではない. 単に尤度を最大化するパラメーターを探す途中の対数尤度の-2倍にパラメーター数の2倍を足したものをAICと呼んでいる. 正しいAICの定義は最大対数尤度の-2倍にパラメーター数の2倍を足したものである.  この動画を見ると尤度が大きくしても予測精度が悪化する場合があることがわかる.

● [AICと予測誤差の分布 2018-03-09, 2018-03-22 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/1f0fd84bcf23a5269a7fb9ba90027e0d): AICと予測誤差(KL情報量)は綺麗に逆相関する.

● [「八学校」への最尤法とベイズ推定法の適用 2018-03-21 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/922c2997146ceb154eec43b89001634d)

● [Optim.jl と BlackBoxOptim.jl の比較 2018-03-07 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/0de1b5a82d6a539d97ba4321c3df48fc): 残差がt分布の線形回帰で2つの最適化パッケージを比較. 局所解が複数ある場合にはBlackBoxOptim.jlの方が勝る.

● [残差が指数分布に従うときの最小二乗法の振る舞い 2018-02-19～20 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/8f41a876ec9a7e5e18dfb8074e300077): 最小二乗法による推定が不適切な場合.

● [2次元Ising模型：メトロポリス法 2018-01-07～2018-12-15](https://nbviewer.jupyter.org/gist/genkuroki/057814687dcba128ecc2f830dad6e64f): Markov chain Monte Carlo method の最もシンプルな物理的適用例

● [ロジスティック分布の2通りの正規分布近似の比較 2017-12-23, 2018-10-06](https://nbviewer.jupyter.org/gist/genkuroki/96b0508a5773035e3a5247beff1d4f99): 正規分布に近いロジスティック分布の確率密度函数の正規分布の確率密度函数によるsupノルム最小化による近似とKL情報量最小化による近似を比較.  AICによる判別が難しくなるのは後者の方になる.  supノルムによる近似はサンプルの分析で楽に「偽物」だとばれてしまう.

● [ベイズ推定のアニメーション (混合ガンマ分布のサンプルの場合) 2017-11-19 (Julia v0.6, HTML)](https://genkuroki.github.io/documents/Jupyter/Animation%20of%20Bayesian%20estimation%20(Mixture%20Gamma%20Sample%20Case).html): 2つの山を持つ分布のサンプルの要素を増やしながら, 推定の収束の様子をプロット.

● [ベイズ推定のアニメーション (ガンマ分布のサンプルの場合) 2017-11-19 (Julia v0.6, HTML)](https://genkuroki.github.io/documents/Jupyter/Animation%20of%20Bayesian%20estimation%20(Gamma%20Sample%20Case).html): サンプルの要素を増やしながら, 推定の収束の様子をプロット.

● [1次元の混合正規分布モデル 2017-11-12 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/42106c9574766a86e8f7f375e039df76): Bayes推論の例. WAICなどで比較.

● [t-distribution linear regression by Mamba 2017-11-09 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/1c9f3c342167ccf01dd583857fd97b35): Bayes推論の例. WAICで比較.

● [AICと汎化損失の簡単な計算例 2017-11-06 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/17f19359e475fb01cae47dbf65d4b574/Simple%20examples%20of%20AICs%20and%20generalization%20losses.ipynb): AICの比較によって正規分布に近いガンマ分布をガンマ分布だとかなりの確率で判定可能.

● [対数尤度の比較によるモデル選択の簡単な例 2017-11-01 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/17f19359e475fb01cae47dbf65d4b574/Simple%20example%20of%20model%20selection%20by%20comparison%20of%20log-likelihood%20ratios.ipynb): 対数尤度の比較だけで正規分布に近いガンマ分布をガンマ分布だとかなりの確率で判定可能. Wilksの定理の簡単な例.

● [混合正規分布モデルの最尤法とベイズ法による推定例 2017-10-29 (Julia v0.6)](https://nbviewer.jupyter.org/gist/genkuroki/5a29679b0ecece1a155c93ce1ab00ee4): 

● [TDist(μ, ρ, ν) モデルの尤度函数の形 2017-10-27～2019-09-18](https://nbviewer.jupyter.org/gist/genkuroki/32fe4cbb13fae90aa697f54355df6767?flush_cache=true): t分布モデルの大数尤度函数は凸性を持たないので, 極小点を見付ける数値計算では初期値によって異なる局所解に収束してしまうことがある.

● [t分布モデルと正規分布モデルの対数尤度比に関する実験 2017-10-18～2019-09-18](https://nbviewer.jupyter.org/gist/genkuroki/37e06943aa91f0d7db65dc40052367e9): 対数尤度比のカイ二乗検定に関する実験

● [t分布線形回帰の実験と動画の作成 2017-10-06, 2018-03-25 (Julia v0.6)](https://nbviewer.jupyter.org/urls/genkuroki.github.io/documents/Jupyter/Animation%20of%20t-distribution%20regression.ipynb): Optim.jlの複数のアルゴリズム
の動画による比較. 初期条件によって収束先も変わる.

● [t-distribution linear regression 2017-10-02～2019-09-18](https://nbviewer.jupyter.org/gist/genkuroki/6897ddc41f69566112675a13962d9187): 残差がt分布に従うと仮定した場合の線形回帰の実験を色々やってみた.  残差がt分布に従うモデルによる回帰は外れ値に強いはずである.

● 平衡状態でのカノニカル分布をMarkov chain Mote Carlo法で作成

* [平衡状態でのカノニカル分布としての正規分布 2017-10-04](https://nbviewer.jupyter.org/gist/genkuroki/fe7fa7d7446fd02cf1106374e8128624)
* [平衡状態でのカノニカル分布としてのガンマ分布 2017-09-28](https://nbviewer.jupyter.org/gist/genkuroki/3b5566ee3f2fe9620a85bc41ee988b35/%E5%B9%B3%E8%A1%A1%E7%8A%B6%E6%85%8B%E3%81%A7%E3%81%AE%E3%82%AB%E3%83%8E%E3%83%8B%E3%82%AB%E3%83%AB%E5%88%86%E5%B8%83%E3%81%A8%E3%81%97%E3%81%A6%E3%81%AE%E3%82%AC%E3%83%B3%E3%83%9E%E5%88%86%E5%B8%83.ipynb)

● [測定スキルの異なる7人の科学者たち 2017-09-29～2019-09-18](https://nbviewer.jupyter.org/gist/genkuroki/bc35fc074dff611b1284942758a285fc): 仮想的な測定スキルの異なる7人の科学者たちの測定結果について, 異なる4つのモデルの最尤法で推定し, AICとLOOCVを比較してみた. このノートブックを理解できればt分布がどのような分布であるかをよく理解できるだろう.

● 2×2の独立性検定の比較: Fisher's exact test が実際には「正確な検定」ではないことがわかる.

* [複数の確率分布でカイ二乗検定とG検定とFisherの正確検定を比較 2017-09-19～20](https://nbviewer.jupyter.org/gist/genkuroki/7c52b10fc6cdb254c8227f4fb0a47e0d)
* [2x2の分割表での独立性検定の比較 2017-09-26](https://nbviewer.jupyter.org/gist/genkuroki/1dd6d1ee5b473435a2027d221c560640): カイ二乗検定とG検定とFisher検定の詳細な比較, (補正無しの)カイ二乗検定がかなりrobustであることがわかる.
* [2×2の分割表における尤度函数 2017-09-26](https://nbviewer.jupyter.org/gist/genkuroki/a3034d25a429b590d96c486064e53c8b): 尤度函数のプロット
* [2×2の分割表の独立性に関する様々な検定法の比較 2017-11-02](https://nbviewer.jupyter.org/gist/genkuroki/3935a24dcfcb0fa4da46a0a3955158d8): カイ二乗検定とG検定とFisher検定以外に, Barnard検定とBoschloo検定も比較してみた. 単純なカイ二乗検定で十分だと思われる.

● Monte Carlo simulation of the 2D Potts model 2017-08-15～2017-08-16: 2次元ポッツ模型のモンテカルロシミュレーション
[Part 1](https://nbviewer.jupyter.org/gist/genkuroki/f01626c723efeaaed7f396ca8b9eaef1)
([HTML](https://genkuroki.github.io/documents/Jupyter/Monte%20Carlo%20simulation%20of%20the%202D%20Potts%20model%20-%20Part%201.html)),
[Part 2](https://nbviewer.jupyter.org/gist/genkuroki/6deedf25cdcff6f7afe56c89bc342ef9), 
[Part 3](https://nbviewer.jupyter.org/gist/genkuroki/fd45cae92c0cb6e972ab3ed313beb4e3), 
[Part 4](https://nbviewer.jupyter.org/gist/genkuroki/3fe61da186194d3ed6b2bbd9d690e024),
[Part 5](https://nbviewer.jupyter.org/gist/genkuroki/a16313f5ec1ebddc171e00738cf1b38b)
