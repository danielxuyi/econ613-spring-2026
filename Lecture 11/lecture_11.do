clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2025\Lecture 11"

use mroz.dta

reg lwage educ exper expersq age

heckman lwage educ exper expersq age, select(inlf = educ exper expersq age kidslt6 kidsge6 mtr nwifeinc) twostep
