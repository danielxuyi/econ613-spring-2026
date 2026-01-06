clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2024\Lecture 10"

***example of multinomial logit
**insurance data
webuse sysdsn1

**notice data structure
*Fit multinomial logistic regression model
mlogit insure age male nonwhite i.site, base(3)

*Can also use margins
margins, dydx(*) atmeans predict(outcome(1)) 
margins, dydx(*) predict(outcome(1))



***example of conditional logit model
use energy.dta

/**
(1) gas central, 
(2) gas room, 
(3) electric central, 
(4) electric room, 
(5) heat pump. **/

label var  idcase "observation number (1-900)"
label var  depvar "the chosen alternative (1-5)"

label var   ic      "installation cost"
label var  oc "annual operating cost "

label var income "annual income of the household"
label var agehead "age of the household head"
label var rooms "number of rooms in the house"
label var ncoast "identifies whether the house is in the northern coastal region"
label var scoast "identifies whether the house is in the southern coastal region"
label var mountn "identifies whether the house is in the mountain region"
label var valley "identifies whether the house is in the central valley region"

asclogit depvar ic oc, case(idcase) alternatives(idalt)
estat alternatives
estat mfx

gen ln_income=log(income)
asclogit depvar ic oc, case(idcase) alternatives(idalt) casevar(ln_income agehead rooms ncoast scoast mountn valley)
estat mfx
