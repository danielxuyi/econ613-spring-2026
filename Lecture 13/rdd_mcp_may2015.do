/*
  RDD simulations for HRS class
  Real data available was avaiable at 
  http://harrisschool.uchicago.edu/Blogs/EITM/wp-content/uploads/2011/06/EITM-RD-Examples.zip
  
  May 2015
  
  Marcelo Coca Perraillon
  mcoca@uchicago.edu
  University of Chicago
*/ 


* Scheme for graphs
set scheme s1manual

* Install RDD-related packages
*ssc install rd, replace
*ssc install cmogram, replace

* Change directory to location of data and where you want the 
* graphs to be saved
cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 13"

* Seed seed so simulations can be replicated
set obs 1000
set seed 1234567

* Generate forcing variable
gen x = rnormal(100, 50)
replace x=0 if x < 0
drop if x > 280
sum x, det

* Treated if X > 140
gen T = 0
replace T = 1 if x > 140
sum T
 
/// --- Examples (parametric)
 
* Linear example with treatment effect
capture drop y
gen y = 100 + 80*T + 2*x + rnormal(0, 20)

scatter y x if T==0, msize(vsmall) || scatter y x if T==1, msize(vsmall) ///
        legend(off) xline(140, lstyle(foreground)) || ///
        lfit y x if T ==0, color(red) || lfit y x if T ==1, color(red) ytitle("Outcome (Y)")  ///
        xtitle("Test Score (X)") 
graph export linear_ex.png, replace


* Linear example with NO treatment effect
capture drop y1
gen y1 = 100 + 0*T + 2*x + rnormal(0, 20)

scatter y1 x if T==0, msize(vsmall) || scatter y1 x if T==1, msize(vsmall) ///
        legend(off) xline(140, lstyle(foreground)) || ///
        lfit y1 x if T ==0, color(red) || lfit y1 x if T ==1, color(red) ytitle("Outcome (Y)")  ///
        xtitle("Test Score (X)") 
graph export linear_ex_noe.png, replace


* Bias if nonlinear
capture drop y
gen x2 = x^2
gen x3 = x^3
gen y = 10000 + 0*T - 100*x +x2 + rnormal(0, 1000)

scatter y x if T==0, msize(vsmall) || scatter y x if T==1, msize(vsmall) ///
        legend(off) xline(140, lstyle(foreground)) ylabel(none) || ///
lfit y x if T ==0, color(red) || lfit y x if T ==1, color(red) xtitle("Test Score (X)") ytitle("Outcome (Y)") 
graph export bias_ex.png, replace

* Run more flexible model
reg y T x x2 x3
predict yhat 

scatter y x if T==0, msize(vsmall) || scatter y x if T==1, msize(vsmall) ///
        legend(off) xline(140, lstyle(foreground)) ylabel(none) || ///
line yhat x if T ==0, color(red) sort || line yhat x if T ==1, sort color(red) xtitle("Test Score (X)") ytitle("Outcome (Y)") 
graph export more_flex.png, replace

* Note that x3 is not really needed
* Following model recaptures simulated data
reg y T x x2

* Could center
gen x_c = x - 140
gen x2_c = x2-140
gen x3_c = x3-140

reg y T x_c x2_c
* only intercept changes

/// -- Use data from Lee, Moretti and Buttler (2004)

use "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 13\LMB.dta", clear

* Graph 1: scatter
scatter score demvoteshare, msize(small) xline(0.5) xtitle("Democrat vote share") ytitle("ADA score")
graph export lee1.png, replace

* Graph 1.1: jittering
scatter score demvoteshare, msize(small) xline(0.5) xtitle("Democrat vote share")  ///
		ytitle("ADA score") jitter(2)
graph export lee1_1.png, replace


* Graph 2: Add linear trend
scatter score demvoteshare, msize(tiny) xline(0.5) xtitle("Democrat vote share") ///
        ytitle("ADA score") || ///
		  lfit score demvoteshare if democrat ==1, color(red) ||  ///
		  lfit score demvoteshare if democrat ==0, color(red) legend(off)
graph export lee2.png, replace


* Polynomials  
gen demvoteshare2 = demvoteshare^2
gen demvoteshare3 = demvoteshare^3
gen demvoteshare4 = demvoteshare^4
gen demvoteshare5 = demvoteshare^5
gen demvoteshare6 = demvoteshare^6
gen demvoteshare7 = demvoteshare^7

* Quadratic (following Gelman and Imbens 2014)
reg score demvoteshare demvoteshare2 democrat
predict scorehat0

scatter score demvoteshare, msize(tiny) xline(0.5) xtitle("Democrat vote share") ///
  ytitle("ADA score") || ///
  line scorehat0 demvoteshare if democrat ==1, sort color(red) || ///
  line scorehat0 demvoteshare if democrat ==0, sort color(red) legend(off) 
graph export lee2_1.png, replace


* Third
qui {
   reg score demvoteshare demvoteshare2 demvoteshare3 democrat
   predict scorehat01
}
scatter score demvoteshare, msize(tiny) xline(0.5) xtitle("Democrat vote share") ///
  ytitle("ADA score") || ///
  line scorehat01 demvoteshare if democrat ==1, sort color(red) || ///
  line scorehat01 demvoteshare if democrat ==0, sort color(red) legend(off) 
graph export lee2_2.png, replace


* Fourth
qui {
   reg score demvoteshare demvoteshare2 demvoteshare3 demvoteshare4 democrat
   predict scorehat02
}
scatter score demvoteshare, msize(tiny) xline(0.5) xtitle("Democrat vote share") ///
  ytitle("ADA score") || ///
  line scorehat02 demvoteshare if democrat ==1, sort color(red) || ///
  line scorehat02 demvoteshare if democrat ==0, sort color(red) legend(off) 
graph export lee2_3.png, replace


* Fifth 
qui {
reg score demvoteshare demvoteshare2 demvoteshare3 demvoteshare4 demvoteshare5 democrat
qui predict scorehat03
} 

scatter score demvoteshare, msize(tiny) xline(0.5) xtitle("Democrat vote share") ///
  ytitle("ADA score") || ///
  line scorehat03 demvoteshare if democrat ==1, sort color(red) || ///
  line scorehat03 demvoteshare if democrat ==0, sort color(red) legend(off) 
graph export lee2_4.png, replace


* Just means
qui {
reg score democrat
qui predict scorehat04
} 

scatter score demvoteshare, msize(tiny) xline(0.5) xtitle("Democrat vote share") ///
  ytitle("ADA score") || ///
  line scorehat04 demvoteshare if democrat ==1, sort color(red) || ///
  line scorehat04 demvoteshare if democrat ==0, sort color(red) legend(off) 
graph export lee_5.png, replace


* All together
line scorehat04 demvoteshare if democrat ==1, sort color(gray) || ///
line scorehat04 demvoteshare if democrat ==0, sort color(gray) legend(off) xline(0.5) || ///
line scorehat03 demvoteshare if democrat ==1, sort color(black) || ///
line scorehat03 demvoteshare if democrat ==0, sort color(black) legend(off) xline(0.5) || ///
line scorehat02 demvoteshare if democrat ==1, sort color(red) || ///
line scorehat02 demvoteshare if democrat ==0, sort color(red) legend(off) xline(0.5) || ///
line scorehat01 demvoteshare if democrat ==1, sort color(blue) || ///
line scorehat01 demvoteshare if democrat ==0, sort color(blue) legend(off) xline(0.5) || ///
line scorehat0 demvoteshare if democrat ==1, sort color(orange) || ///
line scorehat0 demvoteshare if democrat ==0, sort color(orange) legend(off) xline(0.5) || ///
lfit score demvoteshare if democrat ==1, color(green) ||  ///
lfit score demvoteshare if democrat ==0, color(green) xtitle("Democrat vote share") ///
ytitle("ADA score")
graph export lee_all_parametric.png, replace

drop scorehat0
drop scorehat1
* Use winwdow and 2nd degree
reg score demvoteshare demvoteshare2 if democrat ==1 &  (demvoteshare>.40 & demvoteshare<.60)
predict scorehat1 if e(sample)
reg score demvoteshare demvoteshare2 if democrat ==0 &  (demvoteshare>.40 & demvoteshare<.60)
predict scorehat0 if e(sample)

scatter score demvoteshare, msize(tiny) xline(0.5) xtitle("Democrat vote share") ///
  ytitle("ADA score") || ///
  line scorehat1 demvoteshare if democrat ==1, sort color(red) || ///
  line scorehat0 demvoteshare if democrat ==0, sort color(red) legend(off) 
graph export lee3_1.png, replace

	  
* Lowess 
capture drop lowess_y_d1 lowess_y_d0
lowess score demvoteshare if democrat ==1, gen (lowess_y_d1) nograph bw(0.5)
lowess score demvoteshare if democrat ==0, gen (lowess_y_d0) nograph bw(0.5)

scatter score demvoteshare, msize(tiny) xline(0.5) xtitle("Democrat vote share") ///
  ytitle("ADA score") || ///
  line lowess_y_d1 demvoteshare if democrat ==1, sort color(red) || ///
  line lowess_y_d0 demvoteshare if democrat ==0, sort color(red) legend(off) 
graph export lee4.png, replace

* Binned graph
cmogram score demvoteshare, cut(.5) scatter line(.5) qfit
graph export lee5.png, replace

* with linear plot
qui cmogram score demvoteshare, cut(.5) scatter line(.5) lfit 
graph save lin.gph, replace

* lowess smoothing
qui cmogram score demvoteshare, cut(.5) scatter line(.5) lowess 
graph save lowess.gph, replace

graph combine lin.gph lowess.gph, xcommon col(1)
graph export lin_low.png, replace

* Show regression results
gen x_c = demvoteshare - 0.5
gen x2_c = x_c^2
gen x3_c = x_c^3
gen x4_c = x_c^4
gen x5_c = x_c^5

reg score x_c x2_c if democrat ==1 & (demvoteshare>.40 & demvoteshare<.60)

* Use all obs
reg score i.democrat##(c.x_c c.x2_c c.x3_c c.x4_c c.x5_c)

* Restrict to window and drop some polynomials
reg score i.democrat##(c.x_c c.x2_c) if (demvoteshare>.40 & demvoteshare<.60)

* Better SEs with clustering
reg score i.democrat##(c.x_c c.x2_c) if (demvoteshare>.40 & demvoteshare<.60), cluster(id2)

// ----- Local regression (non-parametric)
* Graph using lpoly
capture drop sdem0 sdem1 x0 x1

lpoly score demvoteshare if democrat == 0, nograph kernel(triangle) gen(x0 sdem0)  ///
         bwidth(0.1)
lpoly score demvoteshare if democrat == 1, nograph kernel(triangle) gen(x1 sdem1)  ///
         bwidth(0.1)
scatter sdem1 x1, color(red) msize(small) || scatter sdem0 x0, msize(small) color(red) ///
     xline(0.5,lstyle(dot)) legend(off) xtitle("Democratic vote share") ytitle("ADA score")
graph export lee_lpoly.png, replace
			
					
* Could use rd or rd_obs but it's buggy
* Do it by hand using lpoly
gen forat = 0.5 in 1

capture drop sdem0 sdem1

lpoly score demvoteshare if democrat == 0, nograph kernel(triangle) gen(sdem0)  ///
       at(forat) bwidth(0.1)
lpoly score demvoteshare if democrat == 1, nograph kernel(triangle) gen(sdem1)  ///
       at(forat) bwidth(0.1)
gen dif = sdem1 - sdem0
list sdem1 sdem0 dif in 1/1
	
* Show different windows
capture drop smoothdem0* smoothdem1* x0* x1*

local co 0
foreach i in 0.01 0.05 0.1 0.20 0.30 0.40 {
   local co = `co' +1
   lpoly score demvoteshare if democrat == 0, nograph kernel(triangle) gen(x0`co' smoothdem0`co')  ///
         bwidth(`i')
   lpoly score demvoteshare if democrat == 1, nograph kernel(triangle) gen(x1`co' smoothdem1`co')  ///
         bwidth(`i')
}

line smoothdem01 x01, msize(small) color(gray) sort || line smoothdem11 x11, sort color(gray) || ///
     line smoothdem02 x02, color(black) sort || line smoothdem12 x12, sort color(black) || ///
     line smoothdem03 x03, color(red) sort || line smoothdem13 x13, sort color(red) || ///
     line smoothdem04 x04, color(blue) sort || line smoothdem14 x14, sort color(blue) || ///
	  line smoothdem05 x05, color(green)sort || line smoothdem15 x15, sort color(green)|| ///
	  line smoothdem06 x06, color(orange) sort || line smoothdem16 x16, sort  color(orange) ///
     xline(0.5,lstyle(dot)) legend(off) xtitle("Democratic vote share") ytitle("ADA score") ///
	  title("Bandwidths: 0.01, 0.05, 0.1, 0.2, 0.3, 0.4")
graph export lee_dif_bws.png, replace
	  	  
	  
* rectangular kernel
capture drop smoothdem0* smoothdem1* x0* x1*

local co 0
foreach i in 0.01 0.05 0.1 0.20 0.30 0.5 {
   local co = `co' +1
   lpoly score demvoteshare if democrat == 0, nograph kernel(rec) gen(x0`co' smoothdem0`co')  ///
         bwidth(`i')
   lpoly score demvoteshare if democrat == 1, nograph kernel(rec) gen(x1`co' smoothdem1`co')  ///
         bwidth(`i')
}

line smoothdem01 x01, msize(small) color(gray) sort || line smoothdem11 x11, sort msize(small) color(gray) || ///
     line smoothdem02 x02, msize(small) color(black) sort || line smoothdem12 x12, sort msize(small) color(black) || ///
     line smoothdem03 x03, msize(small) color(red) sort || line smoothdem13 x13, sort msize(small) color(red) || ///
     line smoothdem04 x04, msize(small) color(blue) sort || line smoothdem14 x14, sort msize(small) color(blue) || ///
	  line smoothdem05 x05, msize(small) color(green)sort || line smoothdem15 x15, sort msize(small) color(green)|| ///
	  line smoothdem06 x06, msize(small) color(orange) sort || line smoothdem16 x16, sort msize(small) color(orange) ///
     xline(0.5,lstyle(dot)) legend(off) xtitle("Democratic vote share") ytitle("ADA score") ///
	  title("Bandwidths: 0.01, 0.05, 0.1, 0.2, 0.3, 0.5")
graph export lee_dif_bws_rec.png, replace
	  
	  
/* Try the new command
 install it
findit rdrobust*/

rdrobust score demvoteshare, c(0.5) h(0.1)
rdrobust score demvoteshare, c(0.5) bwselect(mserd)
rdrobust score demvoteshare, c(0.5) all bwselect(cerrd)

 
 
 



















  
 
