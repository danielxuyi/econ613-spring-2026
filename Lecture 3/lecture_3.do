

clear

cd "/Users/yx42/Dropbox/Courses/Applied Econometrics 2024/Lecture 3"

insheet using broiler.csv

/***this data is from Ellison/Ryan (MIT)'s course web, subsample with 40 observations***/

describe

/***OLS demand**/
gen lnq=log(q)
gen lny=log(y)
gen lnp=log(pchick/cpi)

reg lnq lny lnp, r

gen lnpb=log(pbeef/cpi)

tsset year
reg lnq lny lnp lnpb, r
*pb wrong sign
estat dwatson

gen dlnq=lnq-lnq[_n-1]
gen dlny=lny-lny[_n-1]
gen dlnp=lnp-lnp[_n-1]
gen dlnpb=lnpb-lnpb[_n-1]

reg dlnq dlny dlnp dlnpb, r
*first difference most promising, treated as benchmark demand
estat dwatson

/***OLS supply, formulated in aggregate qA***/
gen lnqa=log(q*pop)
gen lnpf=log(pf/cpi)
gen llnqa=lnqa[_n-1]

*similarly control for serially correlated error
reg lnqa lnp lnpf time llnqa, r
*lnp is not significant, but other variables make sense

/**construct IV demand**/
gen lnpop=log(pop)
gen dlnpop=lnpop-lnpop[_n-1]
gen llnp=lnp[_n-1]
gen llnq=lnq[_n-1]

ivreg dlnq dlny dlnpb (dlnp=lnpf llnq dlnpop llnp), r   /*llnq dlnpop llnp*/

/**construct IV supply**/

ivreg lnqa lnpf time llnqa (lnp=dlny dlnpb dlnpop llnp), r
