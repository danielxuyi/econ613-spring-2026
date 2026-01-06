
global revision "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2024\Lecture 14\Teaching Examples" /* Change this path to run file */
set more off

* Table 1: Effects of the Program on Regulated Firms

use "$revision/Data/Table1.dta",clear

local x "treat_post"
local control "soe roa age exp"
local cluster "firmid"
local absorb1 "firmid year"
local absorb2 "firmid ind2_year"
local absorb3 "firmid ind2_year province_year"

foreach y of varlist lenergy loutput lefficiency {
       eststo `y'_1: reghdfe `y' `x', absorb(`absorb1') cluster(`cluster')
       eststo `y'_2: reghdfe `y' `x', absorb(`absorb2') cluster(`cluster')
       eststo `y'_3: reghdfe `y' `x', absorb(`absorb3') cluster(`cluster')
       eststo `y'_4: reghdfe `y' `x' `control', absorb(`absorb3') cluster(`cluster')
      }

***********************
* Panel A: Energy Use
***********************

esttab lenergy_?  using "$revision/Table/Table1.tex",  ///
preh("\begin{table} \centering" ///
"\caption{\bf Effects of the Program on Regulated Firms}" ///
"\label{tab:diff_in_diff_top1000}" ///
"\\ $\;$\\ {\bf A. Energy Use} \\ $\;$\\" ///
"\begin{tabular}{l c c c c}") ///
stats() posth("\toprule" ///
"Variables & \multicolumn{4}{c}{ln(Energy Use)} \\" ///
"\midrule" ) ///
star(* 0.10 ** 0.05 *** 0.01) ///
b(3) se par mlab(none) coll(none) nonum ///
s(N r2, label("Observations" "$ R^2$") fmt(%9.0fc %9.3f)) noobs nogap ///
keep(treat_post) coeflabel(treat_post "Treat $\times$ Post") label /// 
prefoot("\hline") postfoot( ///
"\hline" ///
"Firm FE & Y & Y & Y & Y \\" ///
"Year FE & Y & Y & Y & Y \\" ///
"Industry $\times$ Year FE & {} & Y & Y & Y \\" ///
"Province $\times$ Year FE & {} & {} & Y & Y \\" ///
"Firm-level Controls & {} & {} & {} & Y \\" ///
"\bottomrule" ///
"\end{tabular}" ) replace 

*******************
* Panel B: Output
*******************

esttab loutput_?  using "$revision/Table/Table1.tex",  ///
preh("\\ $\;$\\ \\ $\;$\\ {\bf B. Output} \\ $\;$\\" ///
"\begin{tabular}{l c c c c }") ///
posth("\toprule" ///
"Variables & \multicolumn{4}{c}{ln(Output)} \\" ///
"\midrule" ) ///
star(* 0.10 ** 0.05 *** 0.01) ///
b(3) se par mlab(none) coll(none) nonum ///
s(N r2, label("Observations" "$ R^2$") fmt(%9.0fc %9.3f)) noobs nogap ///
keep(treat_post) coeflabel(treat_post "Treat $\times$ Post") label /// 
prefoot("\hline") postfoot( ///
"\hline" ///
"Firm FE & Y & Y & Y & Y \\" ///
"Year FE & Y & Y & Y & Y \\" ///
"Industry $\times$ Year FE & {} & Y & Y & Y \\" ///
"Province $\times$ Year FE & {} & {} & Y & Y \\" ///
"Firm-level Controls & {} & {} & {} & Y \\" ///
"\bottomrule" ///
"\end{tabular}" ) append sty(tex)

*****************************
* Panel C: Energy Efficiency
*****************************

esttab lefficiency_?  using "$revision/Table/Table1.tex",  ///
preh("\\ $\;$\\ \\ $\;$\\ {\bf C. Energy Efficiency} \\ $\;$\\" ///
"\begin{tabular}{l c c c c }") ///
posth("\toprule" ///
"Variables & \multicolumn{4}{c}{ln(Energy Effiency)} \\" ///
"\midrule" ) ///
star(* 0.10 ** 0.05 *** 0.01) ///
b(3) se par mlab(none) coll(none) nonum ///
s(N r2, label("Observations" "$ R^2$") fmt(%9.0fc %9.3f)) noobs nogap ///
keep(treat_post) coeflabel(treat_post "Treat $\times$ Post") label /// 
prefoot("\hline") postfoot( ///
"\hline" ///
"Firm FE & Y & Y & Y & Y \\" ///
"Year FE & Y & Y & Y & Y \\" ///
"Industry $\times$ Year FE & {} & Y & Y & Y \\" ///
"Province $\times$ Year FE & {} & {} & Y & Y \\" ///
"Firm-level Controls & {} & {} & {} & Y \\" ///
"\bottomrule" ///
"\end{tabular}" ///
"\end{table}" ) append sty(tex)
