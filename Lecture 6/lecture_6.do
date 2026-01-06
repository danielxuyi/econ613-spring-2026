clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 6"

use twins.dta

sum

/*Missing data are indicated by a period.  

NOTE: For most data analysis purposes, the logarithm of the hourly wage is used instead of the hourly wage itself. 

DLHRWAGE: the difference (twin 1 minus twin 2) in the logarithm of hourly wage, given in dollars. 
DEDUC1: the difference (twin 1 minus twin 2) in self-reported education, given in years.                                         
AGE: Age in years of twin 1.                                                  
AGESQ: AGE squared.  
HRWAGEH: Hourly wage of twin 2.  
WHITEH: 1 if twin 2 is white, 0 otherwise. 
MALEH: 1 if twin 2 is male, 0 otherwise. 
EDUCH: Self-reported education (in years) of twin 2. 
HRWAGEL: Hourly wage of twin 1. 
WHITEL: 1 if twin 1 is white, 0 otherwise. 
MALEL: 1 if twin 1 is male, 0 otherwise. 
EDUCL: Self-reported education (in years) of twin 1. 
DEDUC2: the difference (twin 1 minus twin 2) in cross-reported  education. Twin 1's cross-reported education, for example, is the number of years of schooling completed by twin 1 as               reported by twin 2.                                      
DTEN: the difference (twin 1 minus twin 2) in tenure, or number of years at current job. 
DMARRIED: the difference (twin 1 minus twin 2) in marital status, where 1 signifies "married" and 0 signifies "unmarried".  
DUNCOV: the difference (twin 1 minus twin 2) in union coverage, where 1 signifies "covered" and 0 "uncovered". */

gen lhrwageh=log(hrwageh)
gen lhrwagel=log(hrwagel)
keep if lhrwageh~=.&lhrwagel~=.

*****RE (FGLS)
constraint define 1 [lhrwageh]_cons = [lhrwagel]_cons 
constraint define 2 [lhrwageh]age = [lhrwagel]age
constraint define 3 [lhrwageh]agesq = [lhrwagel]agesq
constraint define 4 [lhrwageh]educh = [lhrwagel]educl
constraint define 5 [lhrwageh]maleh = [lhrwagel]malel
constraint define 6 [lhrwageh]whiteh = [lhrwagel]whitel

sureg (lhrwageh educh age agesq maleh whiteh) (lhrwagel educl age agesq malel whitel), isure constraints (1-6)

*****RE including sibling education
constraint define 1 [lhrwageh]_cons = [lhrwagel]_cons 
constraint define 2 [lhrwageh]age = [lhrwagel]age
constraint define 3 [lhrwageh]agesq = [lhrwagel]agesq
constraint define 4 [lhrwageh]educh = [lhrwagel]educl
constraint define 5 [lhrwageh]maleh = [lhrwagel]malel
constraint define 6 [lhrwageh]whiteh = [lhrwagel]whitel
constraint define 7 [lhrwageh]educl = [lhrwagel]educh

sureg (lhrwageh educh educl age agesq maleh whiteh) (lhrwagel educl educh age agesq malel whitel), isure constraints (1-7)

*****FE/FD regression
reg dlhrwage deduc1, r

*****FE IV
ivreg dlhrwage (deduc1=deduc2)
