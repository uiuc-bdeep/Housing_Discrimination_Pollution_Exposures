/*********************************************************************************************************
Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins
*********************************************************************************************************/

clear all
set matsize 11000


use "../stores/ACS_population.dta"



gen ihs_pop=asinh(population_renters)



gen black=(race=="Black")
gen hispanic=(race=="Hispanic")
gen white=(race=="White")


gen RSEI_25=(quartileZIP_property==1)
gen RSEI_25_75=(quartileZIP_property==2 |quartileZIP_property==3)
gen RSEI_75=(quartileZIP_property==4)


xtset Zip_Code			 

matrix define H=J(9,2,0)

xtreg ihs_pop   RSEI_25_75 RSEI_75 if white==1, fe 
matrix H[2,1] =_b[RSEI_25_75]
matrix H[2,2] =_se[RSEI_25_75]


matrix H[3,1] =_b[RSEI_75]
matrix H[3,2] =_se[RSEI_75]

xtreg ihs_pop   RSEI_25_75 RSEI_75 if black==1, fe 
matrix H[5,1] =_b[RSEI_25_75]
matrix H[5,2] =_se[RSEI_25_75]
matrix H[6,1] =_b[RSEI_75]
matrix H[6,2] =_se[RSEI_75]

xtreg ihs_pop   RSEI_25_75 RSEI_75 if hispanic==1, fe 
matrix H[8,1] =_b[RSEI_25_75]
matrix H[8,2] =_se[RSEI_25_75]
matrix H[9,1] =_b[RSEI_75]
matrix H[9,2] =_se[RSEI_75]





preserve
clear
svmat H
gen n=_n

gen race=""
replace race="White" if n<=3
replace race="Black" if n>3 & n<=6
replace race="Hispanic" if n>6

gen ToxConc_bin=""
replace ToxConc_bin="0-25"   if n==1 | n==4 | n==7
replace ToxConc_bin="25-75"  if n==2 | n==5 | n==8
replace ToxConc_bin="75-100" if n==3 | n==6 | n==9

rename H1 coef
rename H2 std_err

save "../stores/aux/ACS_coefficients.dta", replace
restore

*end