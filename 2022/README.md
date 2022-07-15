# 数理統計学2022

記号法などについては次のメモを参照:

* [Memo.md](https://github.com/genkuroki/Statistics/blob/master/2022/Memo.md)

すべてをまとめたPDF:

* [Statistics2022.pdf](https://github.com/genkuroki/Statistics/blob/master/2022/Statistics2022.pdf) \[[download](https://github.com/genkuroki/Statistics/raw/master/2022/Statistics2022.pdf)\]

これはおまけで作っているPDFファイルなので更新は遅れる予定.  以下の個別のPDFファイルの方が常に新しいバージョンになっている.

## 目標

* 確率変数の扱い方
* 大数の法則と中心極限定理
* よく使われる確率分布達に関する知識
* 尤度と推定と要約統計
* 検定と信頼区間を表裏一体のものとして理解すること
* __簡単な場合について具体的な数値の計算を行えること(重要!)__

## 資料

[Jupyter](https://jupyter.org/) notebook をオンラインで読むなら [nbviewer](https://nbviewer.org/) 経由の閲覧がおすすめです。オフラインでも読めるようにするためには pdf ファイルをダウンロードしてください.

[Julia言語](https://julialang.org/)を使って数値の計算やグラフの作画を行っています。必要最小限の使い方については次の資料を見て下さい:

* 07-2 [Julia言語を使った統計学の勉強の仕方](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/07-2%20How%20to%20use%20Julia%20language%20for%20learning%20statistics.ipynb)

[WolframAlpha](https://www.wolframalpha.com/)も併用しています.

__明らかな誤りをまだ大量に含んでいるものと思われます. ごめんなさい. 適切に訂正しながら読んでください. 随時訂正更新しています.__

### 01 Bernoulli試行と関連確率分布

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/01%20Bernoulli%20trial%20and%20related%20distributions.pdf)\]

__定義された確率分布__

* __カテゴリカル分布__: $\mathrm{Categorical}(p_1,\ldots,p_n)$

* 成功確率 $p$ の __Bernoulli分布__: $\mathrm{Bernoulli}(p)$
* 試行回数 $n$, 成功確率 $p$ の __Bernoulli試行の分布__: $\mathrm{Bernoulli}(p)^n$
* 試行回数 $n$, 成功確率 $p$ の __二項分布__: $\mathrm{Binomial}(n, p)$ ($n$ 回のBernoulli試行での成功回数の分布)
* 成功回数 $k$, 成功確率 $p$ の __負の二項分布__: $\mathrm{NegativeBinomial}(n, p) = \mathrm{NegBin}(n, p)$ (Bernoulli試行をちょうど $k$ 回成功するまで続けたときの失敗の回数の分布)
* 成功確率 $p$ の __幾何分布__: $\mathrm{Geometric}(p) = \mathrm{NegativeBinomial}(1, p)$ (Bernoulli試行を成功するまで続けたときの失敗の回数の分布)
* 0から1のあいだの __一様分布__: $\mathrm{Uniform}(0, 1)$ (コンピュータでの一様乱数函数 `rand()` のモデル化)
* 試行回数 $n$ の __一様乱数生成の繰り返しの分布__: $\mathrm{Uniform}(0, 1)^n$
* 平均 $\mu$, 分散 $\sigma^2$ (標準偏差 $\sigma$)の __正規分布__: $\mathrm{Normal}(\mu, \sigma)$
* __標準正規分布__: $\mathrm{Normal}() = \mathrm{Normal}(0, 1)$
* 分布 $D$ の __アフィン変換___: $aD+b$
* 分布 $D$ の __スケール変換__: $aD$ ($a > 0$)
* 分布 $D$ の __平行移動__: $D + b$
* 分布 $D$ の __逆数__: $1/D$

### 02 Gauss積分, ガンマ函数, ベータ函数

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.ipynb)
\[[nbvewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/02%20Gaussian%20integrals%2C%20Gamma%20and%20Beta%20functions.pdf)\]

__定義された確率分布__

* 正規分布 (再): $\mathrm{Normal}(\mu, \sigma) = \mu + \sigma\,\mathrm{Normal}(0, 1)$

* 形状 $\alpha$, スケール $\theta$ の __ガンマ分布__: $\mathrm{Gamma}(\alpha, \theta) = \theta\,\mathrm{Gamma}(\alpha, 1)$ (平均的なイベント発生間隔が $\theta$ のときにちょうど $\alpha$ 回イベントが生じるまでにかかる時間の分布)
* 平均 $\theta$ の __指数分布__: $\mathrm{Exponential}(\theta) = \mathrm{Gamma}(1, \theta)$ (平均的なイベント発生間隔が $\theta$ のときにイベントが発生するまでにかかる時間の分布)
* 中央値 $a$, スケール $b$ の __Laplace分布__: $\mathrm{Laplace}(a, b)$
* 形状 $\alpha$, スケール $\theta$ の __逆ガンマ分布__: $\mathrm{InverseGamma}(\alpha, \theta) = 1/\mathrm{Gamma}(\alpha, 1/\theta)$
* 自由度 $\nu$ の __χ²分布__(カイ二乗分布): $\mathrm{Chisq}(\nu) = \mathrm{Gamma}(\nu/2, 2)$
* 形状 $\alpha$, スケール $\theta$ の __Weibull分布__: $\mathrm{Weibull}(\alpha, \theta)$
* パラメータ $\alpha, \beta$ の __ベータ分布__: $\mathrm{Beta}(\alpha, \beta)$ ($\alpha+\beta-1$ 個の一様乱数の中で $\alpha$ 番目に小さな(= $\beta$ 番目に大きな)値の分布)
* 自由度 $\nu$ の __t分布__: $\mathrm{TDist}(\nu)$ (平均 $0$ の正規分布で分散の逆数が $\mathrm{Chisq}(\nu)/\nu$ に従う場合, $\mathrm{BetaPrime}(1/2, \nu/2)$ と密接に関係)
* パラメータ $\alpha,\beta$ の __ベータプライム分布__: $\mathrm{BetaPrime}(\alpha, \beta)$  (確率 $t$ に関するベータ分布 $\mathrm{Beta}(\alpha, \beta)$ をオッズ $u = t/(1-t)=1/(1-t)-1$ に関する分布に変換したもの) 
* 自由度 $\nu_1, \nu_2$ の __F分布__: $\mathrm{FDist}(\nu_1, \nu_2) = (\nu_2/\nu_1)\,\mathrm{BetaPrime}(\nu_1/2, \nu_2/2)$
* __Dirichlet分布__: $\mathrm{Dirichlet}(\alpha_1,\ldots,\alpha_n)$  ($n=2$ の場合がベータ分布と一致)

### 03 確率分布達の解釈

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/03%20Interpretation%20of%20probability%20distributions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/03%20Interpretation%20of%20probability%20distributions.pdf)\]

__定義された確率分布__

* __対数正規分布__: $\mathrm{LogNormal}(\mu, \sigma) = \exp(\mathrm{Normal}(\mu, \sigma))$

* 平均 $\lambda$ の __Poisson分布__(ポアソン分布): $\mathrm{Poisson}(\lambda)$
* __負の二項分布__: $\mathrm{NegativeBinomial}(\alpha, 1/(1+\theta))$ (Poisson分布の平均パラメータ $\lambda$ がガンマ分布に従う場合)
* $a$ から $b$ のあいだの __一様分布__: $\mathrm{Uniform}(a, b)$
* __ベータ二項分布__: $\mathrm{BetaBinomial}(n, \alpha, \beta)$ (二項分布の成功確率パラメータがベータ分布に従う場合)
* __超幾何分布__: $\mathrm{Hypergeometric}(s, f, n)$ (非復元抽出の分布)
* __ベータ負の二項分布__: $\mathrm{NegativeBetaBinomial}(n, \alpha, \beta)$ (負の二項分布の成功確率パラメータがベータ分布に従う場合)
* 試行回数 $n$ の __Pólyaの壺の確率分布__: $\mathrm{Pólya}(n, \alpha, \beta)$ (Bernoulli試行の分布で成功確率パラメータがベータ分布に従う場合)

### 04 標本分布について

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/04%20Distribution%20of%20samples.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/04%20Distribution%20of%20samples.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/04%20Distribution%20of%20samples.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/04%20Distribution%20of%20samples.pdf)\]

__演習用サンプル__

* Anscombeの例(アンスコムの例)
  * [csv file](https://github.com/genkuroki/Statistics/blob/master/2022/data/anscombe.csv), [raw version](https://raw.githubusercontent.com/genkuroki/Statistics/master/2022/data/anscombe.csv)
  * [transposed version](https://github.com/genkuroki/Statistics/blob/master/2022/data/anscombe_transposed.csv), [transposed raw version](https://raw.githubusercontent.com/genkuroki/Statistics/master/2022/data/anscombe_transposed.csv)

__定義された確率分布__

* 分布達 $D_1,\ldots,D_n$ の __積__: $D_1\times\cdots\times D_n$

* 分布 $D$ の __累乗__: $D^n$

* 分布 $D$ のサイズ $n$ の __標本分布__: $D^n$

__作成された動画__

[楕円と回帰直線の関係](https://github.com/genkuroki/Statistics/blob/master/2022/images/ellipse_and_regressionline.gif)

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/ellipse_and_regressionline.gif">

### 05 大数の法則と中心極限定理

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/05%20Central%20limit%20theorem.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/05%20Central%20limit%20theorem.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/05%20Central%20limit%20theorem.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/05%20Central%20limit%20theorem.pdf)\]

__大数の法則の数値例 ($(X_1+X_2+\cdots+X_n)/n$ の分布)__

Bernoulli試行,
正規分布の標本分布,
ガンマ分布 Gamma(2, 3) の標本分布

__大数の法則が成立しない場合の数値例__

Cachy分布の標本分布,
Pólyaの壺＝事前分布がベータ分布のBernoulli試行

__ランダムウォークの数値例 $X_1+X_2+\cdots+X_n$ の分布__

Bernoulli試行,
正規分布の標本分布,
ガンマ分布 Gamma}(2, 3) の標本分布,
Cachy分布の標本分布,
Pólyaの壺＝事前分布がベータ分布のBernoulli試行

__中心極限定理の数値例__

__対称な分布__　 
二項分布, 
一様分布の標本分布, 
ベータ分布 Beta(0.5, 0.5), 
Bernoulli試行 p = 0.5, 
Laplace分布の標本分布

__非対称な分布__　
ガンマ分布 Gamma(3, 1) の標本分布,
Bernoulli試行 (p = 0.25) の標本分布,
Poisson分布 (期待値1) の標本分布,
指数分布 (期待値1) の標本分布,
χ²分布 (自由度1) の標本分布,
混合正規分布の標本分布,
対数正規分布の標本分布

__正規分布で近似される確率分布の数値例__

__デルタ法の応用__　
自由度が大きなχ²分布の逆数,
自由度が大きなχ²分布の対数,
2つのパラメータが両方とも大きなベータ分布

__適当なパラメータ領域において正規分布で近似される分布__　
二項分布,
負の二項分布,
Poisson分布,
ガンマ分布,
χ²分布,
逆ガンマ分布,
ベータ分布,
t分布,
ベータプライム分布,
F分布,
超幾何分布,
ベータ二項分布,
ベータ負の二項分布

### 06 条件付き確率分布, 尤度, 推定, 記述統計

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/06%20Conditional%20distribution%2C%20likelihood%2C%20estimation%2C%20and%20summary.pdf)\]

__演習用サンプル__

* [Datasaurusの例 (データサウルスの例)](http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html)
  * [csv file](https://github.com/genkuroki/Statistics/blob/master/2022/data/Datasaurus_data.csv), [raw version](https://raw.githubusercontent.com/genkuroki/Statistics/master/2022/data/Datasaurus_data.csv)
  * [x座標のみ](https://github.com/genkuroki/Statistics/blob/master/2022/data/Datasaurus_X.txt), [y座標のみ](https://github.com/genkuroki/Statistics/blob/master/2022/data/Datasaurus_Y.txt)
  * [x座標のみコンマ付き](https://github.com/genkuroki/Statistics/blob/master/2022/data/Datasaurus_X_with_commas.txt), [y座標のみコンマ付き](https://github.com/genkuroki/Statistics/blob/master/2022/data/Datasaurus_Y_with_commas.txt)

この例に関する詳しい解説が次の場所にある:

* Justin Matejka, George Fitzmaurice. Same Stats, Different Graphs: Generating Datasets with Varied Appearance and Identical Statistics through Simulated Annealing. Honourable Mention, ACM SIGCHI Conference on Human Factors in Computing Systems, 2017 \[[link](https://www.autodesk.com/research/publications/same-stats-different-graphs)\]

関連の情報が [datasaurus same stats を検索](https://www.google.com/search?q=datasaurus+same+stats) すれば得られる.

__定義された確率分布__

* __2変量正規分布__: $\mathrm{MvNormal}(\mu, \Sigma)$ (__多変量正規分布__ でも同じ記号を使う.)

* __2×2の分割表の分布__

  * 4つのPoisson分布の積
  * 四項分布
  * 2つの二項分布の積
  * Fisherの非心超幾何分布

### 07 例

#### 07-1 例：ベータ函数と二項分布の関係とその応用

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/07-1%20Relationship%20between%20beta%20and%20binomial%20distributions.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/07-1%20Relationship%20between%20beta%20and%20binomial%20distributions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/07-1%20Relationship%20between%20beta%20and%20binomial%20distributions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/07-1%20Relationship%20between%20beta%20and%20binomial%20distributions.pdf)\]

#### 07-2 Julia言語を使った統計学の勉強の仕方

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/07-2%20How%20to%20use%20Julia%20language%20for%20learning%20statistics.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/07-2%20How%20to%20use%20Julia%20language%20for%20learning%20statistics.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/07-2%20How%20to%20use%20Julia%20language%20for%20learning%20statistics.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/07-1%20Relationship%20between%20beta%20and%20binomial%20distributions.pdf)\]

### 08 検定と信頼区間(1) 一般論

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/08%20Hypothesis%20testing%20and%20confidence%20interval%20-%20General%20theory.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/08%20Hypothesis%20testing%20and%20confidence%20interval%20-%20General%20theory.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/08%20Hypothesis%20testing%20and%20confidence%20interval%20-%20General%20theory.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/08%20Hypothesis%20testing%20and%20confidence%20interval%20-%20General%20theory.pdf)\]

__P値函数__ の概念が最も重要である.

この一連のノートでは __信頼区間は常に対応するP値函数を使って定義される__ ことになる.

__関連講義動画__

* 京都大学大学院医学研究科 聴講コース<br>臨床研究者のための生物統計学「仮説検定とP値の誤解」<br>佐藤 俊哉 医学研究科教授<br>[https://youtu.be/vz9cZnB1d1c](https://youtu.be/vz9cZnB1d1c)

この講義動画は「[P値に関するASA声明](https://www.biometrics.gr.jp/news/all/ASA.pdf)」の考え方の非常に良い解説になっている.

### 09 検定と信頼区間(2) 比率

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/09%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Proportion.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/09%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Proportion.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/09%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Proportion.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/09%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Proportion.pdf)\]

__定義された信頼区間__

二項検定に付随する4種の信頼区間

* Clopper-Pearsonの信頼区間
* Sterneの信頼区間
* Wilsonの信頼区間
* Waldの信頼区間

__作成された動画__

[n=20の二項分布モデルのP値函数](https://github.com/genkuroki/Statistics/blob/master/2022/images/pvaluefunction20.gif)

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/pvaluefunction20.gif">

[n=100の二項分布モデルのP値函数](https://github.com/genkuroki/Statistics/blob/master/2022/images/pvaluefunction100.gif)

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/pvaluefunction100.gif">

### 10 検定と信頼区間(3) 平均

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/10%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Mean.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/10%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Mean.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/10%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Mean.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/10%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Mean.pdf)\]

__定義された信頼区間__

平均の信頼区間

* 標準正規分布を使って計算される信頼区間
* t分布を使って計算される信頼区間

後者のみを使用する.

__定義された確率分布__

* 自由度νのχ分布: $\mathrm{Chi}(\nu) = \sqrt{\mathrm{Chisq}(\nu)}$

__作成された動画__

[n → ∞ でのP値函数と信頼区間の挙動](https://github.com/genkuroki/Statistics/blob/master/2022/images/confint_of_mean.gif)

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/confint_of_mean.gif">

### 11 検定と信頼区間(4) 比率の違い

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/11%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20proportions.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/11%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20proportions.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/11%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20proportions.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/11%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20proportions.pdf)\]

__定義された信頼区間__

オッズ比の信頼区間

* Wald型の信頼区間
* Pearsonのχ²検定に付随する信頼区間
* Fisher検定に付随する信頼区間
  * Sterne型
  * Clopper-Pearson型

リスク比の信頼区間

* Wald型の信頼区間
* Pearsonのχ²検定に付随する信頼区間

比率の差の信頼区間

* Wald型の信頼区間

__定義された確率分布__

* Fisherの非心超幾何分布: $\mathrm{FisherNoncentralHypergeometric}(m, n, r, \omega)$

__関連講義動画__

* [聴講コース 臨床研究者のための生物統計学](https://ocw.kyoto-u.ac.jp/course/328/)
  * 佐藤俊哉, ランダム化ができないとき, 2018/10/25, 長さ 1:02:31) \[[https://youtu.be/tUkyjZXU1vc](https://youtu.be/tUkyjZXU1vc)\]
  * 佐藤俊哉, 交絡とその調整, 2018/12/20, 長さ 1:00:52) \[[https://youtu.be/ybdkQFEdCPM](https://youtu.be/ybdkQFEdCPM)\]
  * 佐藤俊哉, 回帰モデルと傾向スコア, 2019/02/21, 長さ 1:04:44) \[[https://youtu.be/cOHN444kBlo](https://youtu.be/cOHN444kBlo)\]

__Julia言語を使うためのヒント__

[上のノートブック](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/11%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20proportions.ipynb) の中の

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/2022-07-15-01.png">

の部分を直接 Julia ([download](https://julialang.org/downloads/))で実行するためには以下のようにすればよい.

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/2022-07-15-02.png">

__注意するべきポイントは `using Distributions, Roots` を忘れないことである.__

しかし, どのくらい前もって `using` しておけばよいのか分かり難いので, 上のノートブックの上の方にある `using` 達をすべて前持って実行しておくという手もある. `using` には少し時間が取られるので, そのようにしたJuliaの窓をそのまま閉じずに放置しておき, 超高級電卓として利用し続けると便利だと思われる.

### 12 検定と信頼区間(5) 平均の差

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/12%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20means.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/12%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20means.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/12%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20means.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/12%20Hypothesis%20testing%20and%20confidence%20interval%20-%20Two%20means.pdf)\]

__定義された信頼区間__

2群の平均の差の信頼区間

* Welchのt検定に付随する信頼区間

Studentのt検定は使用しない.

__作成された動画__

[データサイズを大きくしたときのP値函数と信頼区間の挙動](https://github.com/genkuroki/Statistics/blob/master/2022/images/confint_of_diffmeans.gif)

<img src="https://github.com/genkuroki/Statistics/raw/master/2022/images/confint_of_diffmeans.gif">

### 13 誤用を避けるための注意

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/13%20How%20to%20avoid%20misuse.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/13%20How%20to%20avoid%20misuse.ipynb)\]
* [pdf]()
\[[download]()\]

### 14 例: 回帰

* [Jupyter notebook](https://github.com/genkuroki/Statistics/blob/master/2022/14%20Regression.ipynb)
\[[nbviewer](https://nbviewer.org/github/genkuroki/Statistics/blob/master/2022/14%20Regression.ipynb)\]
* [pdf](https://github.com/genkuroki/Statistics/blob/master/2022/14%20Regression.pdf)
\[[download](https://github.com/genkuroki/Statistics/raw/master/2022/14%20Regression.pdf)\]

__定義された確率分布__

* 多変量正規分布: $\mathrm{MvNormal}(\mu, \Sigma)$

### 15 例

### 99 テンプレート

* [Jupyter notebook]()
\[[nbviewer]()\]
* [pdf]()
\[[download]()\]

__演習用サンプル__

__定義された確率分布__

__定義された信頼区間__

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

