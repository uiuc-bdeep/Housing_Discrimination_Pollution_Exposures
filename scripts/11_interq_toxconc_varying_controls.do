/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4


************************************************************************************************
* Minority
************************************************************************************************
label variable Minority_dec2 "Minority 0-25th perc. Toxic Concentration"
label variable Minority_dec3 "Minority 25-75th perc. Toxic Concentration"
label variable Minority_dec4 "Minority 75-100th perc. Toxic Concentration"





clogit choice Minority_dec2 Minority_dec3 Minority_dec4  ///
			   , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_Minority.tex", tex excel eform cti(odds ratio) dec(4) ///
								label  ci  level(90) replace 									

clogit choice Minority_dec2 Minority_dec3 Minority_dec4  ///
			   i.gender   , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_Minority.tex", tex excel eform cti(odds ratio) dec(4) ///
								label  ci  level(90) append 									

clogit choice Minority_dec2 Minority_dec3 Minority_dec4  ///
			   i.gender i.education_level  , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_Minority.tex", tex excel eform cti(odds ratio) dec(4) ///
								label  ci  level(90) append 		

clogit choice Minority_dec2 Minority_dec3 Minority_dec4  ///
			   i.gender i.education_level i.order  , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_Minority.tex", tex excel eform cti(odds ratio) dec(4) ///
								label  ci  level(90) append 									

************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************


label variable Hispanic_dec2 "Hispanic 0-25th perc. Toxic Concentration"
label variable Hispanic_dec3 "Hispanic 25-75th perc. Toxic Concentration"
label variable Hispanic_dec4 "Hispanic 75-100th perc. Toxic Concentration"


label variable Black_dec2 "Af. American 0-25th perc. Toxic Concentration"
label variable Black_dec3 "Af. American 25-75th perc. Toxic Concentration"
label variable Black_dec4 "Af. American 75-100th perc. Toxic Concentration"


clogit choice Hispanic_dec2 Hispanic_dec3 Hispanic_dec4  ///
			  Black_dec2 Black_dec3 Black_dec4   ///
			   , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls.tex", tex excel eform cti(odds ratio) dec(4) ///
								label  ci  level(90)  addstat(Total obs, `e(N)'+`e(N_drop)' ) replace 





clogit choice Hispanic_dec2 Hispanic_dec3 Hispanic_dec4  ///
			  Black_dec2 Black_dec3 Black_dec4   ///
			   i.gender   , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls.tex", tex excel eform cti(odds ratio) dec(4) ///
								label  ci  level(90)  addstat(Total obs, `e(N)'+`e(N_drop)' ) append 								





clogit choice Hispanic_dec2 Hispanic_dec3 Hispanic_dec4  ///
			  Black_dec2 Black_dec3 Black_dec4   ///
			   i.gender i.education_level   , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls.tex", tex excel eform cti(odds ratio) dec(4) ///
								label  ci  level(90)  addstat(Total obs, `e(N)'+`e(N_drop)' ) append 			




clogit choice Hispanic_dec2 Hispanic_dec3 Hispanic_dec4  ///
			  Black_dec2 Black_dec3 Black_dec4   ///
			   i.gender i.education_level i.order  , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls.tex", tex excel eform cti(odds ratio) dec(4) ///
								label  ci  level(90)  addstat(Total obs, `e(N)'+`e(N_drop)' ) append 					




*end