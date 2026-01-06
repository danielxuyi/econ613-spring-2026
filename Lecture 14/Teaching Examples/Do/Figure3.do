
global revision "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 14\Teaching Examples" /* Change this path to run file */
set more off

*Figure 3 : Effects of the Program on Regulated Firms

*************************************
* Figure3-A Energy Use: Coefficients
*************************************

use "$revision/Data/Table1.dta",clear

tab year, gen(ydummy)
forvalues i=1(1)10 {
      local j=2000+`i'
      gen treat_year`j'=ydummy`i'*top1000
      }

local treat_yeardummy "treat_year2001-treat_year2005 treat_year2007-treat_year2010"
local absorb3 "firmid ind2_year province_year"
local cluster "firmid"

reghdfe lenergy `treat_yeardummy', absorb(`absorb3') cluster(`cluster')
parmest,saving("$revision/Figure/dta/Figure3_A.dta",replace)

use "$revision/Figure/dta/Figure3_A.dta",clear
gen x=length(parm)
keep if x==14
gen year=substr(parm,11,.)
destring year,replace
keep year estimate min95 max95
set obs 10
replace year = 2006 in 10
replace estimate = 0 if year==2006
order year estimate min95 max95
sort year
graph tw (scatter estimate year, color(navy) msymbol(circle)) ///
(rcap min95 max95 year, lp(solid) msymbol(none) color(navy)) ///
, scheme(s1mono) graphregion(fcolor(white) lcolor(none) ifcolor(white) ///
ilcolor(none)) plotregion(fcolor(white) lcolor(none) ifcolor(white) ilcolor(none)) ///
xline(2006,lp(solid)) yline(0,lp(solid) lcolor(cranberry)) ///
xlabel(2001(1)2010,valuelabel)  ylabel(-0.4(0.1)0.3,valuelabel) ///
xtitle("") ytitle("") legend( label(1 "Estimate") label(2 "95% CI"))
graph export "$revision/Figure/Figure3_A.pdf", replace

************************************
* Figure3-B Energy Use: Event Study
************************************

use "$revision/Data/Table1.dta",clear

tab year, gen(ydummy)
forvalues i=1(1)10 {
     local j=2000+`i'
     gen treat_year`j'=ydummy`i'*top1000
     }

local absorb3 "firmid ind2_year province_year"
local cluster "firmid"
reghdfe lenergy treat_year2002-treat_year2010 ,absorb(`absorb3') cluster(`cluster')

gen beta = .
forvalues i = 2002(1)2010{
          replace beta = _b[treat_year`i'] if year==`i'
}

sum beta if year<=2006 & year>=2002
local a = r(mean)
replace beta = beta - `a'

egen mean_lenergy = mean(lenergy), by(year)
gen treated_lenergy = mean_lenergy + .5*beta
gen untreated_lenergy = mean_lenergy - .5*beta 

/*gen diff = untreated_lenergy-treated_lenergy
sum diff if year<=2006 & year>=2002
local a = r(mean)
replace treated_lenergy = treated_lenergy + `a'*/

twoway (connect treated_lenergy year if year>=2002 & year<=2010, lcolor(navy) lwidth(thick) mcolor(navy) msize(medium)sort ) /*
*/ (connect untreated_lenergy year  if year>=2002 & year<=2010, lcolor(cranberry) msymbol(S) mcolor(cranberry) lwidth(medthick) msize(vsmall) lpattern(dash) sort) /*
*/, xline(2006, lcolor(black)) ytitle("") xtitle("") xlabel(2002(1)2010) yla(, format(%5.2f))/*
*/ graphregion(color(white)) bgcolor(white) plotregion(color(white)) scheme(s2mono) /*
*/ legend(rows(1)label(1 "Top1000")label(2 "Top10000")region(lcolor(white))) ylabel(,nogrid)
graph export "$revision/Figure/Figure3_B.pdf", replace

*********************************
* Figure3-C Output: Coefficients
*********************************

use "$revision/Data/Table1.dta",clear

tab year, gen(ydummy)
forvalues i=1(1)10 {
      local j=2000+`i'
      gen treat_year`j'=ydummy`i'*top1000
      }

local treat_yeardummy "treat_year2001-treat_year2005 treat_year2007-treat_year2010"
local absorb3 "firmid ind2_year province_year"
local cluster "firmid"

reghdfe loutput `treat_yeardummy', absorb(`absorb3') cluster(`cluster')
parmest,saving("$revision/Figure/dta/Figure3_C.dta",replace)

use "$revision/Figure/dta/Figure3_C.dta",clear
gen x=length(parm)
keep if x==14
gen year=substr(parm,11,.)
destring year,replace
keep year estimate min95 max95
set obs 10
replace year = 2006 in 10
replace estimate = 0 if year==2006
order year estimate min95 max95
sort year
graph tw (scatter estimate year, color(navy) msymbol(circle)) ///
(rcap min95 max95 year, lp(solid) msymbol(none) color(navy)) ///
, scheme(s1mono) graphregion(fcolor(white) lcolor(none) ifcolor(white) ///
ilcolor(none)) plotregion(fcolor(white) lcolor(none) ifcolor(white) ilcolor(none)) ///
xline(2006,lp(solid)) yline(0,lp(solid) lcolor(cranberry)) ///
xlabel(2001(1)2010,valuelabel)  ylabel(-0.4(0.1)0.3,valuelabel) ///
xtitle("") ytitle("") legend( label(1 "Estimate") label(2 "95% CI"))
graph export "$revision/Figure/Figure3_C.pdf", replace

********************************
* Figure3-D Output: Event Study
********************************

use "$revision/Data/Table1.dta",clear

tab year, gen (ydummy)
forvalues i=1(1)10 {
        local j=2000+`i'
        gen treat_year`j'=ydummy`i'*top1000
}

local absorb3 "firmid ind2_year province_year"
local cluster "firmid"
reghdfe loutput treat_year2002-treat_year2010 ,absorb(`absorb3') cluster(`cluster')

gen beta = .
forvalues i = 2002(1)2010{
        replace beta = _b[treat_year`i'] if year==`i'
        }

sum beta if year<=2006 & year>=2002
local a = r(mean)
replace beta = beta - `a'

egen mean_loutput = mean(loutput), by(year)
gen treated_loutput = mean_loutput + .5*beta
gen untreated_loutput = mean_loutput - .5*beta 

/*gen diff = untreated_loutput-treated_loutput
sum diff if year<=2006 & year>=2002
local a = r(mean)
replace treated_loutput = treated_loutput + `a'*/

twoway (connect treated_loutput year if year>=2002 & year<=2010, lcolor(navy) lwidth(thick) mcolor(navy) msize(medium)sort ) /*
*/ (connect untreated_loutput year  if year>=2002 & year<=2010, lcolor(cranberry) msymbol(S) mcolor(cranberry) lwidth(medthick) msize(vsmall) lpattern(dash) sort) /*
*/, xline(2006, lcolor(black)) ytitle("") xtitle("") xlabel(2002(1)2010) yla(, format(%5.2f))/*
*/ graphregion(color(white)) bgcolor(white) plotregion(color(white)) scheme(s2mono) /*
*/ legend(rows(1)label(1 "Top1000")label(2 "Top10000")region(lcolor(white))) ylabel(,nogrid)
graph export "$revision/Figure/Figure3_D.pdf", replace

********************************************
* Figure3-E Energy Efficiency: Coefficients
********************************************

use "$revision/Data/Table1.dta",clear

tab year, gen(ydummy)
forvalues i=1(1)10 {
      local j=2000+`i'
      gen treat_year`j'=ydummy`i'*top1000
      }

local treat_yeardummy "treat_year2001-treat_year2005 treat_year2007-treat_year2010"
local absorb3 "firmid ind2_year province_year"
local cluster "firmid"

reghdfe lefficiency `treat_yeardummy', absorb(`absorb3') cluster(`cluster')
parmest,saving("$revision/Figure/dta/Figure3_E.dta",replace)

use "$revision/Figure/dta/Figure3_E.dta",clear
gen x=length(parm)
keep if x==14
gen year=substr(parm,11,.)
destring year,replace
keep year estimate min95 max95
set obs 10
replace year = 2006 in 10
replace estimate = 0 if year==2006
order year estimate min95 max95
sort year
graph tw (scatter estimate year, color(navy) msymbol(circle)) ///
(rcap min95 max95 year, lp(solid) msymbol(none) color(navy)) ///
, scheme(s1mono) graphregion(fcolor(white) lcolor(none) ifcolor(white) ///
ilcolor(none)) plotregion(fcolor(white) lcolor(none) ifcolor(white) ilcolor(none)) ///
xline(2006,lp(solid)) yline(0,lp(solid) lcolor(cranberry)) ///
xlabel(2001(1)2010,valuelabel)  ylabel(-0.3(0.1)0.3,valuelabel)  ///
xtitle("") ytitle("") legend( label(1 "Estimate") label(2 "95% CI"))
graph export "$revision/Figure/Figure3_E.pdf", replace

*******************************************
* Figure3-F Energy Efficiency: Event Study
*******************************************

use "$revision/Data/Table1.dta",clear

tab year, gen (ydummy)
forvalues i=1(1)10 {
        local j=2000+`i'
        gen treat_year`j'=ydummy`i'*top1000
        }

local absorb3 "firmid ind2_year province_year"
local cluster "firmid"
reghdfe lefficiency treat_year2002-treat_year2010 ,absorb(`absorb3') cluster(`cluster')

gen beta = .
forvalues i = 2002(1)2010{
        replace beta = _b[treat_year`i'] if year==`i'
        }

sum beta if year<=2006 & year>=2002
local a = r(mean)
replace beta = beta - `a'

egen mean_lefficiency = mean(lefficiency), by(year)
gen treated_lefficiency = mean_lefficiency + .5*beta
gen untreated_lefficiency = mean_lefficiency - .5*beta 

gen diff = untreated_lefficiency-treated_lefficiency
sum diff if year<=2006 & year>=2002
local a = r(mean)
replace treated_lefficiency = treated_lefficiency + `a'

twoway (connect treated_lefficiency year if year>=2002 & year<=2010, lcolor(navy) lwidth(thick) mcolor(navy) msize(medium)sort ) /*
*/ (connect untreated_lefficiency year  if year>=2002 & year<=2010, lcolor(cranberry) msymbol(S) mcolor(cranberry) lwidth(medthick) msize(vsmall) lpattern(dash) sort) /*
*/, xline(2006, lcolor(black)) ytitle("") xtitle("") xlabel(2002(1)2010) yla(, format(%5.2f))/*
*/ graphregion(color(white)) bgcolor(white) plotregion(color(white)) scheme(s2mono) /*
*/ legend(rows(1)label(1 "Top1000")label(2 "Top10000")region(lcolor(white))) ylabel(,nogrid)
graph export "$revision/Figure/Figure3_F.pdf", replace
