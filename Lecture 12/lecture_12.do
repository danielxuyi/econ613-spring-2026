clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 12"

use jtrain2.dta

**1. regression based linear estimator

**for age
egen mage=mean(age)
gen dage=age-mage
gen wdage=train*dage

**for re74
egen mre74=mean(re74)
gen dre74=re74-mre74
gen wdre74=train*dre74

reg re78 train age re74 wdage wdre74, r


**2. generate propensity score

probit train re74 re75 age agesq nodegree educ married black hisp

predict propensity, p

*compare overlop
tabstat propensity, by (train) stat (min p5 p10 p50 p90 p95 max)

**3. Construct propensity score weighting
gen psw=(train-propensity)*re78/(propensity*(1-propensity))
tabstat psw, stat (mean)

**4. 
*contrast ATE estimated from regression vs. propensity score weighting
sum propensity
gen wp=train*(propensity-r(mean))
reg re78 train propensity wp

**5. Finally use the build-in rountine of Abadie/Imbens for nearest neighbor matching
*teffects nnmatch re78 train 
teffects nnmatch (re78 re74 re75 age agesq nodegree married black hisp) (train)
teffects nnmatch (re78 re74 re75 age agesq nodegree married black hisp) (train), nn(30)

