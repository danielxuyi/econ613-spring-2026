clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 9"

use mroz.dta

tab inlf

sum nwifeinc educ exper expersq age kidslt6 kidsge6

/**1. Linear Probability Model**/

reg inlf nwifeinc educ exper expersq age kidslt6 kidsge6, r

predict lp, xb

sum lp, d

/**2. Probit Model**/

probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6

**partial effect at average
margins, dydx(*) atmeans

**average partial effect
margins, dydx(*)


/**3. Logit Model**/

logit inlf nwifeinc educ exper expersq age kidslt6 kidsge6

**partial effect at average
margins, dydx(*) atmeans

**average partial effect
margins, dydx(*)

/**4. Endogenous Education Level**/

**LPM
ivreg inlf nwifeinc exper expersq age kidslt6 kidsge6 (educ = huseduc), r

**Rivers-Vuong
reg educ nwifeinc huseduc exper expersq age kidslt6 kidsge6
predict v2hat, resid

probit inlf nwifeinc educ exper expersq age kidslt6 kidsge6 v2hat


**IV probit
ivprobit inlf nwifeinc (educ=huseduc) exper expersq age kidslt6 kidsge6
**average partial effect
margins, dydx(*)

