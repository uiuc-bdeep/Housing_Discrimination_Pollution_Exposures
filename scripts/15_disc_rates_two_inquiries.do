/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4




drop if times_zip==.
drop if times_zip==3


keep if sample_two_inquiries>3



gen first=(times_zip==1)
gen second=(times_zip==2)


foreach depvar in first second {
	gen Hispanic_`depvar'=Hispanic*`depvar'
	gen Black_`depvar'=Black*`depvar'
	gen Minority_`depvar'=Minority*`depvar'

}



************************************************************************************************
* Minority
************************************************************************************************
 
label variable Minority_first  "Minority First Inquiry"
label variable Minority_second "Minority Second Inquiry"


clogit choice Minority_first Minority_second   i.gender i.education_level i.order  , group(Address)  or cl(Zip_Code) level(90)
outreg2 using "views/table_overall_second_inquiry.tex", eform tex excel cti(odds ratio) dec(4) ///
								label  ci  level(90)  keep(Minority_first Minority_second) addstat(Total obs, `e(N)'+`e(N_drop)' )  replace 


************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************
label variable Black_first  "African American First Inquiry"
label variable Black_second "African American Second Inquiry"

label variable Hispanic_first "Hispanic/LatinX First Inquiry"
label variable Hispanic_second "Hispanic/LatinX Second Inquiry"

clogit choice Black_first Black_second  ///
			  Hispanic_first Hispanic_second ///
			    i.gender i.education_level i.order , group(Address)  or cl(Zip_Code) level(90)
outreg2 using "views/table_overall_second_inquiry.tex", eform tex excel cti(odds ratio) dec(4) ///
								label  ci  level(90)  keep(Black_first Black_second Hispanic_first Hispanic_second ) addstat(Total obs, `e(N)'+`e(N_drop)' )  append 
/*



*end