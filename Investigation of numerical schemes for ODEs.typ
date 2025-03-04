#let cn_ver = true // 切换中英文
// #let cn_ver = false
#let cn_en(cn, en) = [#if cn_ver { cn } else { en }]

// * 页面设置
#set page(
  paper: "a4", // 设置纸张大小, 默认为a4
  // width: 595.28pt,     // 页面宽度, 默认为595.28pt
  // height: 841.89pt,    // 页面高度, 默认为841.89pt
  margin: auto, // 页边距, 默认为auto
  columns: 1, // 页面分列数, 默认为1
  fill: none, // 背景填充颜色, 默认为none
  numbering: "1", // 修改页码显示方式, 默认为none
  number-align: center, // 修改页码位置(left, right, center), 默认为center
  background: rotate(
    30deg,
    text(90pt, fill: rgb("FFCBC4"))[
      // *水印水印水印*
    ],
  ), // 背景图片或文字, 默认为none
  flipped: false, // 切换页面为横向, 默认为false
)
// * 段落设置
#set par(
  leading: 0.65em, // 行间距, 默认为0.65em
  justify: false, // 两端对齐, 默认为false
  linebreaks: auto, // 换行位置, 默认auto
  first-line-indent: 0em, // 首行缩进, 默认为0pt
)
// #show heading: it => {
//     it
//     par()[#text()[#h(0.0em)]]
// }   // 对第一段应用首行缩进, 缺点是会导致标题与段落间距拉大
// * 字体设置
#set text(
  font: ("Times New Roman", "Source Han Serif SC"), // 字体样式, 靠前的最先生效
  size: 11pt, // 字体大小, 默认为11pt
) // 文本字体设置
#show raw: set text(font: "Sarasa Mono SC") // 代码块字体设置
#show math.equation: set text(
  font: ("New Computer Modern Math", "Source Han Serif SC"),
) // 公式字体设置，默认为"New Computer Modern Math"
// * 文档设置
#set document(title: "", author: "")

#import "@preview/tablex:0.0.8": *
#import "@preview/codelst:2.0.1": *

#show figure.where(kind: raw): set figure(supplement: cn_en()[代码][Listing])
#show figure.where(kind: image): set figure(supplement: cn_en()[图像][Figure])
#show figure.where(kind: table): set figure(supplement: cn_en()[表格][Table])
#set figure(numbering: "1-1")
#set figure.caption(separator: [:])

#set heading(numbering: "1.1")
#show heading.where(level: 1): it => {
  v(2.5mm)
  it
  v(2.5mm)
}

#show outline.entry: it => {
  if it.level == 1 {
    strong(it)
    // } else if it.level >= 3 {
    //     emph(it)
  } else {
    it
  }
}

#let title = [
  #cn_en([关于 ODE 数值格式的研究], [Investigation of numerical schemes for ODEs])
]
#let author = "HPCesia"
#set document(author: author)

#set math.mat(delim: "[")

#align(
  center,
  text(17pt)[
    *#title*
  ],
)
#cn_en()[
  *作者*：
][
  *Author*:
]
#author

#cn_en([*摘要*], [*Abstract*]):
#cn_en()[
  通过数值实验研究不同方案（准确性、稳定性和复杂性）的特性。
][
  Investigating the properties of different schemes (accuracy, stability, and complexity) through numerical experiments.
]

#cn_en([*关键词*], [*Keywords*]):
#cn_en()[
  ODE，数值方法，数值差分格式，准确性，稳定性，复杂性，数值实验，数值分析
][
  ODE, numerical methods, numerical difference schemes, accuracy, stability, complexity, numerical experiments, numerical analysis.
]

#outline(title: cn_en()[目录][Contents], indent: 1em, depth: 3)
#pagebreak()

= #cn_en([格式描述], [Description of the schemes])
#cn_en([考虑如下初值问题的数值解], [Consider numerical solution of the initial problem]):
$ cases(u' = f(t,u)\, space t in [0,T], u(0) = u_0) $
#cn_en()[将 $[0,T]$ 划分为 $M$ 个等距区间，$h = T slash M$，考虑如下几种差分方法：][Divide $[0,T]$ into $M$ equally spaced intervals, where $h = T slash M$. Consider the following several difference schemes: ]
== #cn_en([向前 Euler 格式], [Forward Euler Scheme]) (FE)
$ u^(n+1) = u^n + h f(t^n,u^n). $
== #cn_en([向后 Euler 格式], [Backward Euler Scheme]) (BE)
$ u^(n+1) = u^n + h f(t^(n+1),u^(n+1)). $
== #cn_en([跃点格式], [Leap-frog Scheme]) (LF)
$ u^(n+1) = u^(n-1) + 2h f(t^n,u^n). $
== #cn_en([梯形格式], [Trapezoidal Scheme]) (Tz)
$ u^(n+1) = u^n + h (f(f^n, u^n) + f(t^(n+1), u^(n+1))) / 2. $

= #cn_en([格式分析], [Analysis of schemes])
#cn_en()[
  指出关于截断误差和收敛阶、稳定性以及计算复杂度的已知结果。
][
  Indicate the known results about the truncation error and convergence order, stability, and computational complexity.
]
== #cn_en([准确性], [Accuracy]): $R^n, e^n$
#cn_en()[
  定义 $R^n$ 为截断误差，$e^n = u(t^n) - u^n$，假定 $f$ 满足如下 Lipschtiz 连续条件
][
  Define $R^n$ as the truncation error, and $e^n = u(t^n) - u^n$. Assuming that $f$ satisfies the following Lipschitz continuity condition.
]
$ abs(f(t,u) - f(t,v)) <= L abs(u-v), forall t in [0,T], forall u,v in RR. $
=== #cn_en([向前 Euler 格式], [Forward Euler Scheme]) (FE)
#cn_en()[
  向前 Euler 格式的截断误差 $R^n$ 可表示为如下等式
][
  The truncation error $R^n$ of the Forward Euler Scheme can be expressed as follows
]
$ u'(t^n) = (u(t^(n+1)) - u(t^n)) / h - R^n. $
#cn_en()[对 $u(t^(n+1))$ 进行 Taylor 展开有][Expanding $u(t^(n+1))$ using Taylor series gives]
$ u(t^(n+1)) = u(t^n) + h u'(t^n) + h^2 / 2 u''(xi^n), #h(1em) xi^n in [t^n,t^(n+1)]. $
#cn_en()[于是有][Then we have]
$ R^n = h / 2 u''(xi^n) = O(h), #h(1em) xi^n in [t^n,t^(n+1)]. $
#cn_en()[误差 $e^n$ 可表示为如下形式：][The error $e^n$ can be represented in the following form:]
$ (e^(n+1) - e^n) / h + R^n = f(t^n, u(t^n)) - f(t^n,u^n). $
#cn_en()[
  令 $R = max_(n) abs(R^n)$，对误差 $e^n$ 有如下估计：
][
  Let $R = max_(n) abs(R^n)$, the following estimate holds for the error $e^n$:
]
$
  abs(e^(n+1)) &<= abs(e^n) + h R + h L abs(u(t^n) - u^n) = (1+ h L) abs(e^n) + h R \
  &<= (1 + h L)^(n+1) abs(e^0) + R / L ((1 + h L)^(n+1)-1) \
  &<= e^(L T) abs(e^0) + R / L (e^(L T) - 1) <= O(h), n = 0,1,dots.c, M-1.
$
=== #cn_en([向后 Euler 格式], [Backward Euler Scheme]) (BE)
#cn_en()[
  向后 Euler 格式的截断误差 $R^n$ 可表示为如下等式
][
  The truncation error $R^n$ of the Backward Euler Scheme can be expressed as follows
]
$ u'(t^(n)) = (u(t^(n)) - u(t^(n-1))) / h - R^(n). $
#cn_en()[对 $u(t^(n-1))$ 进行 Taylor 展开有][Expanding $u(t^(n-1))$ using Taylor series gives]
$ u(t^(n-1)) = u(t^n) - h u'(t^n) + h^2 / 2 u''(xi^n), #h(1em) xi^n in [t^(n-1),t^(n)]. $
#cn_en()[于是有][Then we have]
$ R^n = -h / 2 u''(xi^n) = O(h), #h(1em) xi^n in [t^(n-1),t^(n)]. $
#cn_en()[误差 $e^n$ 可表示为如下形式：][The error $e^n$ can be represented in the following form:]
$ (e^(n) - e^(n-1)) / h - R^n = f(t^n, u(t^n)) - f(t^n,u^n). $
#cn_en()[
  令 $R = max_(n) abs(R^n)$，假定 $h L < 1$, 对误差 $e^n$ 有如下估计：
][
  Let $R = max_(n) abs(R^n)$. Assuming $h L < 1$, the following estimate holds for the error $e^n$:
]
$
  abs(e^(n))&<= (1-h L)^(-1) abs(e^(n-1)) + h R <= (1- h L)^(-n) abs(e^0) + R / L (1- h L) ((1- h L)^(-n) - 1) \
  &< (1+ (h L) / (1- h L))^n abs(e^0) + R / L ((1+ (h L) / (1- h L))^n - 1) \
  &<= exp((L T) / (1-h L)) abs(e^0) + R / L (exp((L T) / (1-h L)) - 1) <= O(h), n = 1,2,3,dots.c,M.
$
=== #cn_en([跃点格式], [Leap-frog Scheme]) (LF)
#cn_en()[
  跃点格式的截断误差 $R^n$ 可表示为如下等式
][
  The truncation error $R^n$ of the Leap-frog Scheme can be expressed as follows
]
$ u'(t^n) = (u(t^(n+1))-u(t^(n-1))) / (2h) - R_n. $
#cn_en()[
  对 $u(t^(n-1))$ 和 $u(t^(n+1))$ 进行 Taylor 展开有
][
  Expanding $u(t^(n-1))$ and $u(t^(n+1))$ using Taylor series gives
]
$ u(t^(n-1)) = u(t^n) - h u'(t^n) + h^2 / 2 u''(xi_1^n), #h(1em) xi_1^n in [t^(n-1),t^(n)], $
$ u(t^(n+1)) = u(t^n) + h u'(t^n) + h^2 / 2 u''(xi_2^n), #h(1em) xi_2^n in [t^(n),t^(n+1)]. $
#cn_en()[于是有][Then we have]
$ R_n = h/4 (u''(xi_1^n) + u''(xi_2^n)) = O(h), #h(1em) xi_1^n in [t^(n-1),t^(n)], xi_2^n in [t^(n),t^(n+1)]. $
#cn_en()[误差 $e^n$ 可表示为如下形式：][The error $e^n$ can be represented in the following form:]
$ (e^(n+1) - e^(n-1)) / (2h) - R^n = f(t^n, u(t^n)) - f(t^n,u^n). $
#cn_en()[
  令 $R = max_(n) abs(R^n)$，对误差 $e^n$ 有如下估计：
][
  Let $R = max_(n) abs(R^n)$, the following estimate holds for the error $e^n$:
]
$ abs(e^(n+1)) <= abs(e^(n-1)) + 2h L abs(e^n) + 2h R. $
#cn_en()[
  令 $mu = sqrt(1 + h^2 L^2) - h L$，$lambda = sqrt(1 + h^2 L^2) + h L$，则 $mu lambda = 1$，且 $lambda - mu = 2 h L$。于是上式可改写为如下形式：
][
  Let $mu = sqrt(1 + h^2 L^2) - h L$ and $lambda = sqrt(1 + h^2 L^2) + h L$. Then we have $mu lambda = 1$ and $lambda - mu = 2 h L$. Thus, the above expression can be rewritten in the following form:
]
$
  abs(e^(n+1)) + mu abs(e^(n)) &<= lambda (abs(e^(n)) + mu abs(e^(n-1))) + 2h R <= dots.c <= lambda^(n) (abs(e^(1)) + mu abs(e^(0))) + (lambda^n - 1) / (lambda - 1) 2 h R\
  &<= (1 + 2 h L)^n (abs(e^(1)) + mu abs(e^(0))) + ((1 + 2 h L)^n - 1) / (lambda - 1) 2 h R\
  &<= e^(2 L T)(abs(e^(1)) + mu abs(e^(0))) + (e^(2 L T) - 1) / (lambda - 1) 2 h R.
$
#cn_en()[
  不妨假定上式中的 $e^1 = u(t^1) - u^1$ 是由向前 Euler 格式得到的，注意到 $h -> 0$ 时 $h slash (lambda - 1) -> 1 slash L$，于是有：
][
  Let's assume that in the above equation, $e^1 = u(t^1) - u^1$ is obtained from the Forward Euler Scheme. Note that as $h -> 0$, $h slash (lambda - 1) -> 1 slash L$. Hence, we have:
]
$ abs(e^(n+1)) <= abs(e^(n+1)) + mu abs(e^(n)) <= O(h), n = 1,2,3,dots.c,M-1. $
=== #cn_en([梯形格式], [Trapezoidal Scheme]) (Tz)
#cn_en()[
  梯形格式的截断误差 $R^n$ 可表示为如下等式
][
  The truncation error $R^n$ of the Trapezoidal Scheme can be expressed as follows
]
$ (u'(t^(n+1)) + u'(t^(n))) / 2 = (u(t^(n+1)) - u(t^(n))) / h - R^n. $
#cn_en()[
  对 $u'(t^(n+1))$ 和 $u(t^(n+1))$ 进行 Taylor 展开有
][
  Expanding $u(t^(n+1))$ and $u'(t^(n+1))$ using Taylor series gives
]
$ u(t^(n+1)) = u(t^n) + h u'(t^n) + h^2/2 u''(t^n) + h^3/6 u'''(xi_1^n), #h(1em) xi_1^n in [t^n, t^(n+1)]. $
$ u'(t^(n+1)) = u'(t^n) + h u''(t^n) + h^2/2 u'''(xi_2^n), #h(1em) xi_2^n in [t^n, t^(n+1)]. $
#cn_en()[于是有][Then we have]
$ R^n = h^2/12 (2 u'''(xi_1^n) - 3 u'''(xi_2^n)) = O(h^2), #h(1em) xi_1^n in [t^n, t^(n+1)], xi_2^n in [t^n, t^(n+1)]. $
#cn_en()[误差 $e^n$ 可表示为如下形式：][The error $e^n$ can be represented in the following form:]
$
  (e^(n+1) - e^(n)) / h - R^n = (f(t^(n+1), u(t^(n+1))) + f(t^(n), u(t^(n)))) / 2 - (f(t^(n+1), u^(n+1))+ f(t^(n), u^(n))) / 2.
$
#cn_en()[
  令 $R = max_(n) abs(R^n)$，假定 $h L < 2$, 对误差 $e^n$ 有如下估计：
][
  Let $R = max_(n) abs(R^n)$. Assuming $h L < 2$, the following estimate holds for the error $e^n$:
]
$ abs(e^(n+1)) <= abs(e^(n)) + (h L) / 2 (abs(e^(n+1)) + abs(e^n)) + h R, $
$
  abs(e^(n)) &<= (2 + h L) / (2 - h L) abs(e^(n-1)) + (2 h R) / (2 - h L) <= (2 + h L)^(n) / (2 - h L)^(n) abs(e^0) + (R) / (L) ((2 + h L)^(n) / (2 - h L)^(n) - 1)\
  & <= exp((2 L T) / (2 - h L)) abs(e^0) + R / L (exp((2 L T) / (2 - h L)) - 1) <= O(h^2), n = 1,2,3,dots.c,M.
$
== #cn_en([稳定性], [Stability])
#cn_en()[考虑模型问题][Consider the model problem]
$ (dif u) / (dif t) = lambda u, $
#cn_en()[
  其中 $lambda$ 为常数。定义 $epsilon^n$ 为舍入误差，$z = h lambda$。
][
  where $lambda$ is a constant. Define $epsilon^n$ as the round-off error, and $z = h lambda$.
]
=== #cn_en([向前 Euler 格式], [Forward Euler Scheme]) (FE)
#cn_en()[
  将格式代入模型问题可得
][
  Substituting the scheme into the model problem, we obtain
]
$ u^(n+1) = (1 + h lambda) u^n. $
#cn_en()[
  考虑到舍入误差，我们有 ${macron(u)^n}$ 而非 ${u^n}$：
][
  Taking into account the round-off errors, we will obtain ${macron(u)^n}$ rather than ${u^n}$:
]
$ macron(u)^(n+1) = macron(u)^(n) + h lambda macron(u)^n + epsilon^n. $
#cn_en()[
  误差 $e^n colon.eq macron(u)^n - u^n$ 满足
][
  Error $e^n colon.eq macron(u)^n - u^n$ satisfies
]
$ e^(n+1) = e^n + h lambda e^n + epsilon^n = dots.c = (1+h lambda)^(n+1) e^0 + (1+h lambda)^n epsilon^0 + dots.c + epsilon^n. $
#cn_en()[
  假设 $epsilon^n < epsilon$，若 $abs(1 + h lambda) < 1$，则有
][
  Suppose $epsilon^n < epsilon$, if $abs(1 + h lambda)<1$, then
]
$ abs(e^(n+1)) <= abs(1 + h lambda)^(n+1) abs(e^0) + (abs(1 + h lambda) + 1) / (abs(h lambda)) epsilon -> c epsilon. $
#cn_en()[
  所以本格式的绝对稳定区域为 $abs(1 + z) < 1$。
][
  So the absolute stability region of this scheme is $abs(1 + z) < 1$.
]
=== #cn_en([向后 Euler 格式], [Backward Euler Scheme]) (BE)
#cn_en()[
  将格式代入模型问题可得
][
  Substituting the scheme into the model problem, we obtain
]
$ (1 - h lambda)u^(n+1) = u^n. $
#cn_en()[
  考虑到舍入误差，我们有 ${macron(u)^n}$ 而非 ${u^n}$：
][
  Taking into account the round-off errors, we will obtain ${macron(u)^n}$ rather than ${u^n}$:
]
$ macron(u)^(n+1) = macron(u)^(n) + h lambda macron(u)^(n+1) + epsilon^n. $
#cn_en()[
  误差 $e^n colon.eq macron(u)^n - u^n$ 满足
][
  Error $e^n colon.eq macron(u)^n - u^n$ satisfies
]
$
  e^(n+1) &= e^n + h lambda e^(n+1) + epsilon^n = (1 - h lambda)^(-1) e^(n) + (1 - h lambda)^(-1) epsilon^n = dots.c\
  &= (1 - h lambda)^(-(n+1)) e^(0) + (1 - h lambda)^(-(n+1)) epsilon^0 + dots.c + (1 - h lambda)^(-1) epsilon^n.
$
#cn_en()[
  假设 $epsilon^n < epsilon$，若 $abs(1 - h lambda) > 1$，则有
][
  Suppose $epsilon^n < epsilon$, if $abs(1 - h lambda) > 1$, then
]
$ abs(e^(n+1)) <= (1 - h lambda)^(-(n+1)) abs(e^0) + (abs(1 - h lambda)^(-n) + 1) / (abs(h lambda)) epsilon -> c epsilon. $
#cn_en()[
  所以本格式的绝对稳定区域为 $abs(1 - z) > 1$。
][
  So the absolute stability region of this scheme is $abs(1 - z) > 1$.
]
=== #cn_en([跃点格式], [Leap-frog Scheme]) (LF)
#cn_en()[
  将格式代入模型问题可得
][
  Substituting the scheme into the model problem, we obtain
]
$ u^(n+1) = u^(n-1) + 2 h lambda u^(n). $
#cn_en()[
  考虑到舍入误差，我们有 ${macron(u)^n}$ 而非 ${u^n}$：
][
  Taking into account the round-off errors, we will obtain ${macron(u)^n}$ rather than ${u^n}$:
]
$ macron(u)^(n+1) = macron(u)^(n-1) + 2 h lambda macron(u)^(n) + epsilon^(n-1). $
#cn_en()[
  误差 $e^n colon.eq macron(u)^n - u^n$ 满足
][
  Error $e^n colon.eq macron(u)^n - u^n$ satisfies
]
$
  e^(n+1) + alpha e^n = 1 / alpha (e^(n) + alpha e^(n-1)) + epsilon^(n-1) = dots.c = 1 / alpha^n (e^1 + alpha e^0) + 1 / alpha^(n-1) epsilon^0 + dots.c + epsilon^(n-1) ,
$
#cn_en()[
  其中 $alpha = (h^2 lambda^2 + 1)^(1 slash 2) - h lambda$，多值函数 $z^(1 slash 2)$ 取将正数映射到正数的解析分支。随后我们有
][
  where $alpha = (h^2 lambda^2 + 1)^(1 slash 2) - h lambda$ and the multi-valued function $z^(1 slash 2)$ takes the positive numbers to the positive numbers via an analytic branch. Then we have
]
$
  e^(n+1) &= alpha^(-n) (e^1 + alpha e^0) + sum_(k=0)^(n-1) alpha^(k - (n-1)) epsilon^k - alpha e^(n) = dots.c \
  &= ((-1)^(n-1) a^n + a^(-n)) / (a^2 + 1) (e^1 + alpha e^0) + sum_(k=0)^(n-1) ((-1)^(n-1-k) alpha^(n+1-k) + alpha^(k - (n-1))) / (alpha^2 + 1) epsilon^k + (-1)^(n) alpha e^(1).
$
#cn_en()[
  假设 $epsilon^n < epsilon$，若 $abs(1 - h lambda) > 1$，则有
][
  Suppose $epsilon^n < epsilon$, if $abs(1 - h lambda) > 1$, then
]
$
  abs(e^(n+1)) <= (abs(alpha)^(n) + abs(alpha)^(-n)) / (abs(alpha^2 + 1)) abs(e^1 + alpha e^0) + abs(alpha) abs(e^1) + abs(a) / abs(alpha^2 + 1) (abs(alpha^n + 1) / abs(alpha^(-1) + 1) + abs(alpha^(-n) - 1) / abs(alpha-1)) epsilon.
$
#cn_en()[
  上式同时出现 $abs(alpha)^(n)$ 和 $ abs(alpha)^(-n)$，所以仅 $abs(alpha) = 1$ 时 Leapfrog scheme 稳定。令 $z = a + b i$ 有
][
  The equation simultaneously involves $abs(alpha)^(n)$ and $ abs(alpha)^(-n)$, so the Leapfrog scheme is stable only when $abs(alpha) = 1$. Let $z = a + b i$, we have
]
$
  abs(alpha)^2 = (sqrt(r)cos theta - a)^2 + (sqrt(r)sin theta - b)^2 = r + a^2 + b^2 - 2 sqrt(r) (a cos theta + b sin theta) = 1,
$
#cn_en()[其中][where]
$ r = sqrt((a^2 - b^2 + 1)^2 + 4a^2 b^2), space theta = arctan((2a b) / (a^2 - b^2 + 1)) / 2. $
#cn_en()[
  注意到仅 $a = 0$ 且 $abs(b) <= 1$ 时上式成立，所以跃点格式的绝对稳定区域为 $z = b i, b in [-1,1]$。
][
  Note that the equation holds true only when $a = 0$ and $abs(b) <= 1$. Therefore, the absolute stability region of this scheme is $z = b i, b in [-1,1]$.
]
=== #cn_en([梯形格式], [Trapezoidal Scheme]) (Tz)
#cn_en()[
  将格式代入模型问题可得
][
  Substituting the scheme into the model problem, we obtain
]
$ u^(n+1) = u^n + (h lambda) / 2 (u^(n) + u^(n+1)). $
#cn_en()[
  考虑到舍入误差，我们有 ${macron(u)^n}$ 而非 ${u^n}$：
][
  Taking into account the round-off errors, we will obtain ${macron(u)^n}$ rather than ${u^n}$:
]
$ macron(u)^(n+1) = macron(u)^(n) + (h lambda) / 2 macron(u)^(n) + (h lambda) / 2 macron(u)^(n+1) + epsilon^n. $
#cn_en()[
  误差 $e^n colon.eq macron(u)^n - u^n$ 满足
][
  Error $e^n colon.eq macron(u)^n - u^n$ satisfies
]
$
  e^(n+1) &= e^(n) + (h lambda) / 2 e^(n) + (h lambda) / 2 e^(n+1) + epsilon^n = (2 + h lambda) / (2 - h lambda) e^(n) + 2 / (2 - h lambda) epsilon^n = dots.c\
  &= (2 + h lambda)^(n+1) / (2 - h lambda)^(n+1) e^0 + (2 + h lambda)^(n) / (2 - h lambda)^(n+1) 2epsilon^0 + dots.c + 2 / (2 - h lambda) epsilon^n.
$
#cn_en()[
  假设 $epsilon^n < epsilon$，令 $z = a + b i$，若 $a < 0$，则有
][
  Suppose $epsilon^n < epsilon$, Let $z = a + b i$, if $a < 0$, then
]
$
  abs(e^(n+1)) <= abs(2 + h lambda)^(n+1) / abs(2 - h lambda)^(n+1) abs(e^0) + (abs(2 + h lambda)^(n+1) / abs(2 - h lambda)^(n+1) - 1) -> c epsilon.
$
#cn_en()[
  所以本格式的绝对稳定区域为 $op("Re")(z) < 0$。
][
  So the absolute stability region of this scheme is $op("Re")(z) < 0$.
]
== #cn_en([计算复杂性], [Computational complexity])
#cn_en()[
  记 $n = T slash h$。

  对于递推式中不含 $f(t^(n+1), u^(n+1))$ 的差分格式，其求解全部 $u^n$ 只需进行 n 次计算，即计算复杂度为 $O(n)$。

  反之对于递推式中含有 $f(t^(n+1), u^(n+1))$ 的差分格式，其计算每一个 $u^n$ 时都需要求解隐函数零点，这一过程是 $O(log n)$ 的，因此整个求解过程的计算复杂度为 $O(n log n)$。
][
  Let $n = T slash h$.

  For a finite difference scheme without $f(t^(n+1), u^(n+1))$ in the recurrence relation, solving for all $u^n$ only requires $n$ computations, thus the computational complexity is $O(n)$.

  Conversely, for a finite difference scheme with $f(t^(n+1), u^(n+1))$ in the recurrence relation, solving for each $u^n$ requires finding the root of an implicit function, which has a complexity of $O(log n)$. Therefore, the computational complexity of the entire solving process is $O(n log n)$.
]
= #cn_en([数值实验], [Numerical experiment])
#cn_en()[
  以下面的例子对四种差分格式进行数值实验。
][
  Numerical experiments are conducted on four different finite difference schemes using the following examples.
]
== Example 1
$ cases(u'(t) = f(t,u(t)) = u(t) tan (t)\,, u(0) = 1.) $
#cn_en()[
  其中 $t in [0, 1]$。

  上述初值问题的解析解为 $u(t) = sec(t)$。网格宽度 $h = 0.02$ 时，使用差分格式求解上述初值问题，可得如下图表：
][
  where $t in [0, 1]$.

  The analytical solution to the above initial value problem is $u(t) = sec(t)$. When the grid spacing is $h = 0.02$, solving the initial value problem using finite difference schemes yields the following figure:
]
#figure(
  grid(
    columns: (1fr, 1fr),
    image("figures/example1.svg"), image("figures/example1-close-up.svg"),
  ),
  caption: cn_en[
    数值实验结果与在 $t = 1$ 附近的放大图像
  ][
    Result of numerical solution and magnified image around $t = 1$
  ],
)

== Example 2
$ cases(u'(t) = f(t,u(t)) = -cos (5 pi t) tan (5 pi u)\,, u(0) = 1 slash 60.) $
#cn_en()[
  其中 $t in [0, 1]$。
][
  where $t in [0, 1]$.
]
#cn_en()[
  上述初值问题的解析解为
][
  The analytical solution to the above initial value problem is
]
$ u(t) = 1 / (5pi) arcsin((sqrt(6) - sqrt(2))/(4 exp(sin(5 pi t)))). $
#cn_en()[
  网格宽度 $h = 0.01$ 时，使用差分格式求解上述初值问题，可得如下图表：
][
  When the grid spacing is $h = 0.01$, solving the initial value problem using finite difference schemes yields the following figure:
]
#figure(
  grid(
    columns: (1fr, 1fr),
    image("figures/example2.svg"), image("figures/example2-close-up.svg"),
  ),
  caption: cn_en[
    数值实验结果与在 $t = 0.1$ 附近的放大图像
  ][
    Result of numerical solution and magnified image around $t = 0.1$
  ],
)
= #cn_en([结论], [Conclusion])
#cn_en()[
  由上述几个数值实验的实验结果，可以看出虽然向前 Euler 格式、向后 Euler 格式和跃点格式的准确性都是 $O(h)$ 的，但是跃点格式的实际准确性明显优于向前 Euler 格式和向后 Euler 格式。

  而准确性为 $O(h^2)$ 的梯形格式则明显优于所有准确性为 $O(h)$ 的差分格式。
][
  Based on the results of the numerical experiments mentioned above, it can be observed that although the accuracy of the forward Euler, backward Euler, and Leap-Frog schemes is all $O(h)$, the actual accuracy of the Leap-Frog scheme is significantly superior to that of the forward Euler and backward Euler schemes.

  Moreover, the trapezoidal scheme, with accuracy $O(h^2)$, is evidently superior to all finite difference schemes with accuracy $O(h)$.
]

= #cn_en([附录], [Appendix])
#figure(
  sourcecode()[
    ```matlab
    function [x, result] = forward_euler(T, step, u0, f)
        x = linspace(0, T, step + 1);
        h = T / step;
        result = zeros(1, step + 1);
        result(1) = u0;
        for k = 2:step + 1
            result(k) = result(k - 1) + h * f(x(k - 1), result(k - 1));
        end
    end
    ```
  ],
  caption: cn_en[
    向前 Euler 格式的源代码
  ][
    The source code of Forward Euler Scheme
  ],
)
#figure(
  sourcecode()[
    ```matlab
    function [x, result] = backward_euler(T, step, u0, f)
        x = linspace(0, T, step + 1);
        h = T / step;
        result = zeros(1, step + 1);
        result(1) = u0;
        for k = 2:step + 1
            temp_func = @(uk) result(k - 1) + h * f(x(k), uk) - uk;
            result(k) = fzero(temp_func, result(k - 1));
        end
    end
    ```
  ],
  caption: cn_en[
    向后 Euler 格式的源代码
  ][
    The source code of Backward Euler Scheme
  ],
)
#figure(
  sourcecode()[
    ```matlab
    function [x, result] = leap_frog(T, step, u0, u1, f)
        x = linspace(0, T, step + 1);
        h = T / step;
        result = zeros(1, step + 1);
        result(1) = u0;
        result(2) = u1;
        for k = 3:step + 1
            result(k) = result(k - 2) + 2 * h * f(x(k - 1), result(k - 1));
        end
    end
    ```
  ],
  caption: cn_en[
    跃点格式的源代码
  ][
    The source code of Leap-frog Scheme
  ],
)
#figure(
  sourcecode()[
    ```matlab
    function [x, result] = trapezoidal(T, step, u0, f)
        x = linspace(0, T, step + 1);
        h = T / step;
        result = zeros(1, step + 1);
        result(1) = u0;
        for k = 2:step + 1
            temp_func = @(uk) result(k - 1) - uk + ...
                h * (f(x(k), uk) + f(x(k - 1), result(k - 1))) / 2;
            result(k) = fzero(temp_func, result(k - 1));
        end
    end
    ```
  ],
  caption: cn_en[
    梯形格式的源代码
  ][
    The source code of Trapezoidal Scheme
  ],
)
