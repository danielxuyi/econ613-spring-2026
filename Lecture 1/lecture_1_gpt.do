
clear


cd "/Users/yx42/Dropbox/Courses/Applied Econometrics 2025/Lecture 1"

*******************************************************
* Card (1995) IV demo (clean version) — card.dta
* OLS vs 2SLS using nearc4 as an instrument for educ
*******************************************************

clear all
set more off
version 16.0

* Load data
use "card.dta", clear

* Core controls used in the classic Card specs
* (experience quadratic, race, urban, south, and region-of-birth dummies)
local X "exper expersq black smsa south reg661-reg669"

*******************************************************
* 1) OLS: Mincer equation
*******************************************************
reg lwage educ `X', vce(robust)
est store OLS

*******************************************************
* 2) First stage: schooling on instrument
*******************************************************
reg educ nearc4 `X', vce(robust)
est store FS
test nearc4   // excluded-instrument F test

*******************************************************
* 3) Reduced form: wages on instrument
*******************************************************
reg lwage nearc4 `X', vce(robust)
est store RF

*******************************************************
* 4) 2SLS: instrument educ with nearc4
*******************************************************
ivregress 2sls lwage (educ = nearc4) `X', vce(robust)
est store IV
estat firststage

*******************************************************
* 5) (Optional) Interaction-IV idea: nearc4 × low background
*    Include nearc4 directly; use interaction as excluded IV
*******************************************************
gen byte lowbg = (motheduc < 12 & fatheduc < 12) if !missing(motheduc, fatheduc)
label var lowbg "Low background: both parents < HS"

gen byte z_int = nearc4 * lowbg
label var z_int "nearc4 x low background"

ivregress 2sls lwage (educ = z_int) nearc4 lowbg `X', vce(robust)
est store IV_int
estat firststage

*******************************************************
* 6) Quick comparison table in Results window
*******************************************************

esttab OLS IV IV_int, ///
    b(%9.3f) se(%9.3f) ///
    stats(N r2, fmt(%9.0g %9.3f)) ///
    keep(educ) ///
    star(* 0.10 ** 0.05 *** 0.01)


