/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1


************************************************************************************************
* Overall Discrimination Rates
************************************************************************************************


label variable Hispanic "Hispanic/LatinX"
label variable Black "African American"

clogit choice Minority  i.gender i.education_level i.order  , group(Address)  or cl(Zip_Code) level(90)
sum choice if White==1
loc mean r(mean)
*outreg2 using "views/table_overall_disc.tex", eform tex excel cti(odds ratio) dec(4) ///
*								label keep(Minority) ci  level(90)  addstat(Total obs, `e(N)'+`e(N_drop)',  Mean Choice (White), `mean')  replace 


clogit choice Hispanic Black  i.gender i.education_level i.order , group(Address)  or cl(Zip_Code) level(90)
sum choice if White==1
loc mean r(mean)
*outreg2 using "views/table_overall_disc.tex", eform tex excel cti(odds ratio) dec(4) ///
*								label keep(Hispanic Black) ci  level(90)  addstat(Total obs, `e(N)'+`e(N_drop)',  Mean Choice (White), `mean' )  append 




*end