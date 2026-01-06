
clear

cd "C:\Users\yx42\Dropbox\Courses\Applied Econometrics 2024\Lecture 4"

insheet using OTC_Data.csv

label var brand "brand-package"
label var sales "quantity sold"
label var count "number of people visited the store"
label var price "price of the brand-package"


/***calculate revene at each brand-store-week level***/
/**1,4,7 in 25 tabs, 3, 6, 9, 11 in 100tabs**/
**adjust quantity/price into standardized 50 tabs
replace sales=sales/2 if brand==1
replace sales=sales*2 if brand==3
replace sales=sales/2 if brand==4
replace sales=sales*2 if brand==6
replace sales=sales/2 if brand==7
replace sales=sales*2 if brand==9
replace sales=sales*2 if brand==11
replace price=price*2 if brand==1
replace price=price/2 if brand==3
replace price=price*2 if brand==4
replace price=price/2 if brand==6
replace price=price*2 if brand==7
replace price=price/2 if brand==9
replace price=price/2 if brand==11

gen rev=sales*price
/***1,2,3 Tyernol, 4,5,6, Advil, 7,8,9, Bayer, 10,11, Store brand***/
gen fbrand=1
replace fbrand=2 if brand==4|brand==5|brand==6
replace fbrand=3 if brand==7|brand==8|brand==9
replace fbrand=4 if brand==10|brand==11

collapse (sum) sales rev (max) prom, by (store week fbrand)

gen price=rev/sales
rename fbrand brand
 
/**define sales market share**/
gen rev_jnt=sales*price
egen rev_nt=sum(rev_jnt), by (store week)   /**Ygnt**/
gen s_jnt=rev_jnt/rev_nt

tabstat s_jnt, by (brand)

/**price and stone price index, in logs**/
gen lp_jnt=log(price)
egen mlp_nt=sum(lp_jnt*s_jnt), by (store week)  /**LnPnt**/
egen y_nt=sum(rev_jnt), by (store week)
gen yp_nt=log(y_nt)-mlp_nt

**generate Hausman instruments
**average log price of same brand in other stores
unique store
egen sp=sum(lp_jnt), by (brand week)
gen ivp_jnt=(sp-lp_jnt)/(73-1)

**now reshape observations in (store week)
keep s_jnt lp_jnt ivp_jnt yp_nt prom store week brand
reshape wide s_jnt lp_jnt ivp_jnt prom, i(store week) j(brand)

#delimit;
gen lp_jnt14=lp_jnt1-lp_jnt4;
gen lp_jnt24=lp_jnt2-lp_jnt4;
gen lp_jnt34=lp_jnt3-lp_jnt4;

**FGLS (under GMM framework);
gmm (s_jnt1-{xb1: lp_jnt14  lp_jnt24 lp_jnt34 prom_1 yp_nt}-{a1}) 
		   (s_jnt2-{xb2: lp_jnt24  lp_jnt14 lp_jnt34 prom_2 yp_nt}-{a2})
		   (s_jnt3-{xb3: lp_jnt34  lp_jnt14 lp_jnt24 prom_3 yp_nt}-{a3}), 
		   instruments (1: lp_jnt14 lp_jnt24 lp_jnt34 prom_1 yp_nt)  
		   instruments (2: lp_jnt24 lp_jnt14 lp_jnt34 prom_2 yp_nt) 
		   instruments (3: lp_jnt34 lp_jnt14 lp_jnt24 prom_3 yp_nt)  
		   winitial(identity) twostep; 

**Two-step GMM ;
gmm (s_jnt1-{zb1: lp_jnt14  lp_jnt24 lp_jnt34 prom_1 yp_nt}-{b1}) 
		   (s_jnt2-{zb2: lp_jnt24  lp_jnt14 lp_jnt34 prom_2 yp_nt}-{b2})
		   (s_jnt3-{zb3: lp_jnt34  lp_jnt14 lp_jnt24 prom_3 yp_nt}-{b3}),
		   instruments (1: ivp_jnt1 lp_jnt24 lp_jnt34 prom_1 yp_nt)  
		   instruments (2: ivp_jnt2 lp_jnt14 lp_jnt34 prom_2 yp_nt) 
		   instruments (3: ivp_jnt3 lp_jnt14 lp_jnt24 prom_3 yp_nt)  
		   winitial(identity) twostep;
		   
**Examples of caculating demand elasticities;

**own price elas; 
**strict AIDS formula;
gen eta_Tyl= -1 + (-0.1455)/s_jnt1 - (0.00038)/s_jnt1*(0.3963-.1455*lp_jnt14+0.2200*lp_jnt24+0.0418*lp_jnt34);
gen eta_Adv= -1 + (-0.4126)/s_jnt2 - (-0.0004)/s_jnt2*(0.4152-.4126*lp_jnt24+0.2638*lp_jnt14+0.0486*lp_jnt34);
**stone approximation;
gen eta_Tyl2= -1 + (-0.1455)/s_jnt1 - (0.00038)/s_jnt1*s_jnt1;
gen eta_Adv2= -1 + (-0.4126)/s_jnt2 - (-0.0004)/s_jnt2*s_jnt2;		   
sum eta_Tyl eta_Tyl2 eta_Adv eta_Adv2;		   

**cross price elas;
**strict AIDS formula;
gen eta_TA = (0.2638)/s_jnt1- (0.00038)/s_jnt1*(0.4152-.4126*lp_jnt24+0.2638*lp_jnt14+0.0486*lp_jnt34);
**stone approximation;
gen eta_TA2=  (0.2638)/s_jnt1 - (0.00038)/s_jnt1*s_jnt2; 		   
sum eta_TA eta_TA2;
		   
**Compare with equation-by-equation 2SLS;  
ivreg s_jnt1 (lp_jnt14 lp_jnt24 lp_jnt34 prom_1 yp_nt=ivp_jnt1 lp_jnt24 lp_jnt34 prom_1 yp_nt), r;

/**Comment:  almost numerically identical in linear GMM cases, 
we will see the gmm command can be applied to nonlinear cases later**/
