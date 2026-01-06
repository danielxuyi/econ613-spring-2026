clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 5"

use airfare.dta

***interested in how market concentration affects air fare

tab year

sum fare concen dist


/**1. Pooled OLS, wo/w cluster standard errors**/
*reg lfare concen ldist ldistsq y98 y99 y00

reg lfare concen ldist ldistsq y98 y99 y00, cluster(id)

/**2. Random Effect (FGLS), wo/w cluster standard errors**/

*xtreg lfare concen ldist ldistsq y98 y99 y00, re

xtreg lfare concen ldist ldistsq y98 y99 y00, re cluster(id)

/**3. Fixed Effect (Within) **/
xtset id 
xtreg lfare concen ldist ldistsq y98 y99 y00, fe
/**equivalence to dummy reg**/
areg lfare concen ldist ldistsq y98 y99 y00, absorb(id) 

xtreg lfare concen ldist ldistsq y98 y99 y00, fe cluster(id)

/**interaction**/
gen ldisconcen = (ldist - 6.7)*concen
xtreg lfare concen ldisconcen y98 y99 y00, fe cluster(id)

/**4. First Differencing Estimator**/
sort id year
gen clfare=lfare-lfare[_n-1] if year>1997
gen cconcen=concen-concen[_n-1] if year>1997

reg clfare cconcen y99 y00

reg clfare cconcen y99 y00, cluster(id)

/**results quite close to FE**/

/**5. Test for Serial Correlation**/
reg clfare cconcen y99 y00, cluster(id)
predict eh, resid

gen eh_1=eh[_n-1] if year>1998

reg eh eh_1, r
/**reject zero correlation**/

lincom eh_1 + 0.5
/**rejct -0.5 too**/

/***Neither FE.3 or FD.3 seem correct here***/

/**6. Illustrate Hausman Test**/
qui xtreg lfare concen ldist ldistsq y98 y99 y00, fe

estimates store b_fe

qui xtreg lfare concen ldist ldistsq y98 y99 y00, re

estimates store b_re

hausman b_fe b_re

hausman b_fe b_re, sigmamore


