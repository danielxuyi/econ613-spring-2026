
clear


cd "/Users/yx42/Dropbox/Courses/Applied Econometrics 2025/Lecture 1"

use card.dta

describe

/***summarize key variables***/
sum educ lwage

/***OLS regression.  Table 2.  Column (1)/(3)***/
reg lwage educ exper expersq black south smsa, r

gen miss_feduc=1 if fatheduc==.
replace miss_feduc=0 if miss_feduc==.
gen miss_meduc=1 if motheduc==.
replace miss_meduc=0 if miss_meduc==.
replace fatheduc=0 if fatheduc==.
replace motheduc=0 if motheduc==. 

reg lwage educ exper expersq black south smsa reg661-reg668 smsa66 fatheduc motheduc miss_feduc miss_meduc, r

/***First Stage reduced form equations.  Table 3. Column (1)/(3)***/
reg educ exper expersq black south smsa reg661-reg668 smsa66 nearc4, r
predict educh, xb

reg lwage exper expersq black south smsa reg661-reg668 smsa66 nearc4, r

/**2SLS.  Table 3. Column (5)***/
/**for comparison**/
reg lwage educh exper expersq black south smsa reg661-reg668 smsa66, r

ivreg lwage exper expersq black south smsa reg661-reg668 smsa66 (educ=nearc4), r

gen agesq=age^2
ivreg lwage black south smsa reg661-reg668 smsa66 (educ exper expersq =age agesq nearc4), r

**age does NOT work here, since age = 6 + educ + exper