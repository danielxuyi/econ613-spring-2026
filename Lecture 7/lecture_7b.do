clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2024\Lecture 7"

use usbal89.dta

label var y_1 "first lag of y"
label var n_1 "first lag of n"
label var k_1 "first lag of k"
label var yk "log of sales-capital ratio"
label var nk "log of labor-capital ratio"

describe 

xtset id year

/***pooled OLS***/
reg y n L.n k L.k L.y i.year, cluster(id)

/***within FE***/
xtreg y n L.n k L.k L.y i.year, fe cluster(id)

/***first differencing GMM, i.e. without level equation***/

**lag 2
xi: xtabond2 y n L.n k L.k L.y i.year, gmm(y n k, lag(2 .)) iv(i.year) robust noleveleq

**lag 3
xi: xtabond2 y n L.n k L.k L.y i.year, gmm(y n k, lag(3 .)) iv(i.year) robust noleveleq

/***system GMM, i.e. with level equations***/
**lag 2
xi: xtabond2 y n L.n k L.k L.y i.year , gmm(y n k, lag(2 .)) iv(i.year, equation(level)) robust h(1)

xi: xtabond2 y n L.n k L.k L.y i.year , gmm(y n k, lag(2 .)) iv(i.year, equation(level)) robust twostep h(1)

**lag 3
xi: xtabond2 y n L.n k L.k L.y i.year , gmm(y n k, lag(3 .)) iv(i.year, equation(level)) robust h(1)

xi: xtabond2 y n L.n k L.k L.y i.year , gmm(y n k, lag(3 .)) iv(i.year, equation(level)) robust twostep h(1)

