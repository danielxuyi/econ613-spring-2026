clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 7"

use invrat1.dta
describe


unique firm

tab year


/***set panel structure***/
xtset firm year


/**1. Pooled OLS***/
reg invrate L.invrate i.year, cluster(firm)

/**2. Within Estimator***/
xtreg invrate L.invrate i.year, fe cluster(firm)

/**3. 2SLS exactly identified***/
ivregress 2sls d.invrate (Ld.invrate=LL.invrate) i.year, cluster(firm)

/**4. GMM estimator with only lag2/3**/
***robust is used for "cluster"
***ignore noleveleq for now
xi: xtabond2 invrate L.invrate i.year , gmm(invrate, lag(2 3)) iv(i.year) robust noleveleq
xi: xtabond2 invrate L.invrate i.year , gmm(invrate, lag(2 3)) iv(i.year) robust twostep noleveleq

/**5. GMM estimator with full set of lags**/
xi: xtabond2 invrate L.invrate i.year , gmm(invrate, lag(2 .)) iv(i.year) robust noleveleq
xi: xtabond2 invrate L.invrate i.year , gmm(invrate, lag(2 .)) iv(i.year) robust twostep noleveleq
