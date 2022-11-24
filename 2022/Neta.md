# ネタ集

---

## まだ書いていなかったと思われる事柄達

### Brunner-Munzel検定とWilcoxon-Mann-Whitney検定

* https://github.com/genkuroki/public/blob/main/0022/Mann-Whitney%20vs.%20Welch's%20t-test.ipynb
* https://github.com/genkuroki/public/blob/main/0022/Wilcoxon%20test%20vs.%20t-test%20for%20asymmetric%20null.ipynb
* https://github.com/genkuroki/public/blob/6512deb14aa9fc7c0c527f066c71d2fbd0888569/0034/Brunner-Munzel.pdf
* https://github.com/genkuroki/public/blob/6512deb14aa9fc7c0c527f066c71d2fbd0888569/0034/Brunner-Munzel.ipynb
* https://github.com/genkuroki/public/blob/main/0037/probability%20of%20%CE%B1-error%20of%20exact%20Wilcoxon-Mann-Whiteney%20U-test.ipynb

### 離散分布の統計学の実装では確率の比較に ⪅ を使うべきであること

離散分布の統計学の実装では ≤ ではなく

```julia
x ⪅ y = x < y || x ≈ y
```

を使うべきであること.

__例:__ 2×2におけるSterne型のFisher検定

* https://twitter.com/genkuroki/status/1555707041456717824
* https://github.com/genkuroki/public/blob/main/0038/On%20implementation%20of%20fisher%20test.ipynb

__例:__ permutation版のBrunner-Munzel検定

* https://twitter.com/genkuroki/status/1555925442577985536
* https://github.com/genkuroki/public/blob/main/0034/Brunner-Munzel.ipynb

### たたみこみ積とモーメント母函数

### 共通オッズ比, 共通リスク比, 共通リスク差

### Stein推定

* https://nbviewer.org/gist/genkuroki/99e1f853282131f0d2b302bd55ab09e8

### Simpsonのparadox

* https://www.krsk-phs.com/entry/simpsonparadox

### 多項分布とDirichlet分布の分散共分散行列および多変量正規分布近似

### 対立仮説は, 検定の計算では使われず, 検定法の検出力の優劣について考えるときにのみ使われること

* https://twitter.com/genkuroki/status/1582937120590925824

### quantileを使ったSterneのP値函数の実装の改良

### 検定警察行為の代替案

* https://twitter.com/genkuroki/status/1582970571834691584

### Fisher氏がlikelihoodという専門用語を採用するまでの経緯

* https://twitter.com/genkuroki/status/1542156482149498884

### 信頼区間と整合性がないP値を使うと何が起こるか

* https://twitter.com/genkuroki/status/1586554206596780032
* https://twitter.com/genkuroki/status/1586555515248979968
* https://twitter.com/genkuroki/status/1587391695288954880
* https://twitter.com/genkuroki/status/1587411628437696512

---


