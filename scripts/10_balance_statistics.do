/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1

label variable Hispanic "Hispanic/LatinX"
label variable Black "African American"


************************************************************************************************
* Balance Statistics
************************************************************************************************
gen first=(inquiry_order=="1")
gen second=(inquiry_order=="2")
gen third=(inquiry_order=="3")
gen Mon=(inquiry_weekday==3)
gen Tue=(inquiry_weekday==7)
gen Wed=(inquiry_weekday==8)
gen Thurs=(inquiry_weekday==6)
gen Fri=(inquiry_weekday==2)
gen Male=(gender==2)
gen Female=(gender==1)
gen Low=(education_level==2)
gen Medium=(education_level==3)
gen High=(education_level==1)



clogit first  Black Hispanic , group(Address)   level(90)
outreg2 using "views/table_balance_statistics.tex",  tex excel  dec(4) ///
								label keep(Black Hispanic)   addstat(Total obs, `e(N)'+`e(N_drop)' )  replace


foreach depvar in second third Mon Tue Wed Thurs Fri Male Female Low Medium High {
	clogit `depvar' Black Hispanic  , group(Address)   level(90)
	outreg2 using "views/table_balance_statistics.tex",  tex excel  dec(4) ///
									label keep(Black Hispanic)   addstat(Total obs, `e(N)'+`e(N_drop)' )  append
}

*end
