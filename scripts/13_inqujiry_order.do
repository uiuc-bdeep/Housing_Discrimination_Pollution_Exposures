/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4


************************************************************************************************
* Toxic Concentration
************************************************************************************************


label variable Minority_dec2 "Minority 0-25th perc. Toxic Concentration"
label variable Minority_dec3 "Minority 25-75th perc. Toxic Concentration"
label variable Minority_dec4 "Minority 75-100th perc. Toxic Concentration"




label variable Hispanic_dec2 "Hispanic 0-25th perc. Toxic Concentration"
label variable Hispanic_dec3 "Hispanic 25-75th perc. Toxic Concentration"
label variable Hispanic_dec4 "Hispanic 75-100th perc. Toxic Concentration"


label variable Black_dec2 "Af. American 0-25th perc. Toxic Concentration"
label variable Black_dec3 "Af. American 25-75th perc. Toxic Concentration"
label variable Black_dec4 "Af. American 75-100th perc. Toxic Concentration"

preserve

keep if order==1								


logit choice Minority_dec2 Minority_dec3 Minority_dec4  ///
			   i.gender i.education_level i.order  ,  cl(Zip_Code) level(90) 
outreg2 using "views/table_inquiry_order_toxconc_minority.tex", tex excel eform cti( 1st Inquiry ) dec(4) ///
								label  ci  level(90) replace 									

logit choice Hispanic_dec2 Hispanic_dec3 Hispanic_dec4  ///
			  Black_dec2 Black_dec3 Black_dec4   ///
			   i.gender i.education_level i.order  ,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_toxconc.tex", tex excel eform cti( 1st Inquiry ) dec(4) ///
								label  ci  level(90) replace 									
restore



preserve

keep if order==2								

logit choice Minority_dec2 Minority_dec3 Minority_dec4  ///
			   i.gender i.education_level i.order  ,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_toxconc_minority.tex", tex excel eform cti( 2nd Inquiry ) dec(4) ///
								label  ci  level(90) append 									

logit choice Hispanic_dec2 Hispanic_dec3 Hispanic_dec4  ///
			  Black_dec2 Black_dec3 Black_dec4   ///
			   i.gender i.education_level i.order  ,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_toxconc.tex", tex excel eform cti( 2nd Inquiry ) dec(4) ///
								label  ci  level(90) append 									
restore



preserve

keep if order==3								

logit choice Minority_dec2 Minority_dec3 Minority_dec4  ///
			   i.gender i.education_level i.order  ,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_toxconc_minority.tex", tex excel eform cti( 3rd Inquiry ) dec(4) ///
								label  ci  level(90) append 		

logit choice Hispanic_dec2 Hispanic_dec3 Hispanic_dec4  ///
			  Black_dec2 Black_dec3 Black_dec4   ///
			   i.gender i.education_level i.order  ,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_toxconc.tex", tex excel eform cti( 3rd Inquiry ) dec(4) ///
								label  ci  level(90) append 									
restore



************************************************************************************************
* Distance
************************************************************************************************


label variable Hispanic_within1 "Toxic Plant less than 1 mile $\times$ Hispanic"
label variable Black_within1 "Toxic Plant less than 1 mile $\times$ African American"

label variable Hispanic_more1 "Toxic Plant more than 1 mile $\times$  Hispanic"
label variable Black_more1 "Toxic Plant more than 1 mile $\times$  African American"

label variable Minority_within1 "Toxic Plant less than 1 mile $\times$ Minority"
label variable Minority_more1 "Toxic Plant more than 1 mile $\times$  Minority"

								
preserve								
keep if order==1								
logit choice Minority_within1  Minority_more1  ///
					  i.gender i.education_level,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_distance_minority.tex", eform cti( 1st Inquiry ) dec(4) ///
								label keep(Minority_within1 Minority_more1 ) ci  level(90) replace 								


logit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.gender i.education_level,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_distance.tex", eform cti( 1st Inquiry ) dec(4) ///
								label keep(Hispanic_within1 Hispanic_more1 Black_within1 Black_more1) ci  level(90) replace 								

restore



preserve								
keep if order==2								
logit choice Minority_within1  Minority_more1  ///
					  i.gender i.education_level,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_distance_minority.tex", eform cti( 2nd Inquiry ) dec(4) ///
								label keep(Minority_within1 Minority_more1 ) ci  level(90) append 								


logit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.gender i.education_level,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_distance.tex", eform cti( 2nd Inquiry ) dec(4) ///
								label keep(Hispanic_within1 Hispanic_more1 Black_within1 Black_more1) ci  level(90) append 								

restore



preserve								
keep if order==3								
logit choice Minority_within1  Minority_more1  ///
					  i.gender i.education_level,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_distance_minority.tex", eform cti( 3rd Inquiry ) dec(4) ///
								label keep(Minority_within1 Minority_more1 ) ci  level(90) append 								


logit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.gender i.education_level,  cl(Zip_Code) level(90)
outreg2 using "views/table_inquiry_order_distance.tex", eform cti( 3rd Inquiry ) dec(4) ///
								label keep(Hispanic_within1 Hispanic_more1 Black_within1 Black_more1) ci  level(90) append 								

restore


*end