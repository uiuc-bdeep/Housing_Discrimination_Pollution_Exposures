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
label variable Minority_within1 "Toxic Plant less than 1 mile $\times$ Minority"
label variable Minority_more1 "Toxic Plant more than 1 mile $\times$  Minority"


clogit choice Minority_within1  Minority_more1  ///
					  , group(Address) or  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_distance_minority.tex", eform cti(odds ratio) dec(4) ///
								label keep(Minority_within1 Minority_more1 ) addstat(Total obs, `e(N)'+`e(N_drop)' ) ci  level(90) replace 

								
clogit choice Minority_within1  Minority_more1  ///
					  i.gender  , group(Address) or  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_distance_minority.tex", eform cti(odds ratio) dec(4) ///
								label keep(Minority_within1 Minority_more1 ) addstat(Total obs, `e(N)'+`e(N_drop)' ) ci  level(90) append 


												
clogit choice Minority_within1  Minority_more1  ///
					  i.gender i.education_level  , group(Address) or  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_distance_minority.tex", eform cti(odds ratio) dec(4) ///
								label keep(Minority_within1 Minority_more1 ) addstat(Total obs, `e(N)'+`e(N_drop)' ) ci  level(90) append 
								
clogit choice Minority_within1  Minority_more1  ///
					  i.gender i.education_level i.order , group(Address) or  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_distance_minority.tex", eform cti(odds ratio) dec(4) ///
								label keep(Minority_within1 Minority_more1 ) addstat(Total obs, `e(N)'+`e(N_drop)' ) ci  level(90) append 



************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************


label variable Hispanic_within1 "Toxic Plant less than 1 mile $\times$ Hispanic"
label variable Black_within1 "Toxic Plant less than 1 mile $\times$ African American"

label variable Hispanic_more1 "Toxic Plant more than 1 mile $\times$  Hispanic"
label variable Black_more1 "Toxic Plant more than 1 mile $\times$  African American"


clogit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  , group(Address) or  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_distance.tex", eform cti(odds ratio) dec(4) ///
								label keep(Hispanic_within1 Hispanic_more1 Black_within1 Black_more1) addstat(Total obs, `e(N)'+`e(N_drop)' ) ci  level(90) replace 

								
clogit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.gender  , group(Address) or  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_distance.tex", eform cti(odds ratio) dec(4) ///
								label keep(Hispanic_within1 Hispanic_more1 Black_within1 Black_more1) addstat(Total obs, `e(N)'+`e(N_drop)' ) ci  level(90) append 


												
clogit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.gender i.education_level  , group(Address) or  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_distance.tex", eform cti(odds ratio) dec(4) ///
								label keep(Hispanic_within1 Hispanic_more1 Black_within1 Black_more1) addstat(Total obs, `e(N)'+`e(N_drop)' ) ci  level(90) append 
								
clogit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.gender i.education_level i.order , group(Address) or  cl(Zip_Code) level(90)
outreg2 using "views/table_var_controls_distance.tex", eform cti(odds ratio) dec(4) ///
								label keep(Hispanic_within1 Hispanic_more1 Black_within1 Black_more1) addstat(Total obs, `e(N)'+`e(N_drop)' ) ci  level(90) append 






*end