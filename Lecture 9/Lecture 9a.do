
**Note: this code/data is downloaded from Bill Evans course web;

* this data for this program are a random sample;
* of 10k observations from the data used in;
* evans, farrelly and montgomery, aer, 1999;
* the data are indoor workers in the 1991 and 1993;
* national health interview survey.  the survey;
* identifies whether the worker smoked and whether;
* the worker faces a workplace smoking ban;

clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 9"

* use the workplace data set;
use workplace

* print out variable labels;
desc

* get summary statistics;
sum


* run a linear probability model for comparison purposes;
* estimate white standard errors to control for heteroskedasticity;
reg smoker age incomel male black hispanic hsgrad somecol college worka, robust

predict lp, xb

sum lp, d


* run probit model;
probit smoker age incomel male black hispanic hsgrad somecol college worka

**partial effect at average
margins, dydx(*) atmeans

**average partial effect
margins, dydx(*)

* get marginal effect/treatment effects for specific person;
* male, age 40, college educ, white, without workplace smoking ban;
* if a variable is not specified, its value is assumed to be;
* the sample mean.  in this case, the only variable i am not;
* listing is mean log income;
margins, at(male=1 age=40 black=0 hispanic=0 hsgrad=0 somecol=0 worka=0)

*predict probability of smoking;
predict pred_prob_smoke

* get detailed descriptive data about predicted prob;
sum pred_prob, d

* predict binary outcome with 50% cutoff;
gen pred_smoke1=pred_prob_smoke>=.5
label variable pred_smoke1 "predicted smoking, 50% cutoff"

* compare actual values;
tab smoker pred_smoke1, row col cell


* using a wald test, test the null hypothesis that;
* all the education coefficients are zero;
test hsgrad somecol college


* how to run the same tets with a likelihood ratio test;

* estimate the unresticted model and save the estimates ;
* in urmodel;
probit smoker age incomel male black hispanic hsgrad somecol college worka
estimates store urmodel

* estimate the restricted model.  save results in rmodel;
probit smoker age incomel male black hispanic worka
estimates store rmodel

lrtest urmodel rmodel


* run logit model;
logit smoker age incomel male black hispanic hsgrad somecol college worka

**partial effect at average
margins, dydx(*) atmeans

**average partial effect
margins, dydx(*)

