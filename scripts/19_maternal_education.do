/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4


gen low=(education_level==2)
gen medium=(education_level==3)
gen high=(education_level==1)



forvalues i = 2/`quartiles'{
	foreach edu in low medium high {
		gen Hispanic_dec`i'_`edu'=Hispanic*dec`i'*`edu'
		gen Black_dec`i'_`edu'=Black*dec`i'*`edu'
		gen Minority_dec`i'_`edu'=Minority*dec`i'*`edu'
	}

}




label var Hispanic_dec2_low 	"Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ Low"
label var Hispanic_dec2_medium 	"Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ Medium"
label var Hispanic_dec2_high 	"Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ High"
label var Black_dec2_low 		"Af. American 0-25th perc. Toxic Concentration $\times$ Low"
label var Black_dec2_medium 	"Af. American 0-25th perc. Toxic Concentration $\times$ Medium"
label var Black_dec2_high 		"Af. American 0-25th perc. Toxic Concentration  $\times$ High"
label var Minority_dec2_low 	"Minority 0-25th perc. Toxic Concentration $\times$ Low"
label var Minority_dec2_medium 	"Minority 0-25th perc. Toxic Concentration $\times$ Medium"
label var Minority_dec2_high 	"Minority 0-25th perc. Toxic Concentration $\times$ High"

label var Hispanic_dec3_low 	"Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ Low"
label var Hispanic_dec3_medium 	"Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ Medium"
label var Hispanic_dec3_high 	"Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ High"
label var Black_dec3_low 		"Af. American 25-75th perc. Toxic Concentration $\times$ Low"
label var Black_dec3_medium 	"Af. American 25-75th perc. Toxic Concentration $\times$ Medium"
label var Black_dec3_high 		"Af. American 25-75th perc. Toxic Concentration  $\times$ High"
label var Minority_dec3_low 	"Minority 25-75th perc. Toxic Concentration $\times$ Low"
label var Minority_dec3_medium 	"Minority 25-75th perc. Toxic Concentration $\times$ Medium"
label var Minority_dec3_high 	"Minority 25-75th perc. Toxic Concentration $\times$ High"


label var Hispanic_dec4_low 	"Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ Low"
label var Hispanic_dec4_medium 	"Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ Medium"
label var Hispanic_dec4_high 	"Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ High"
label var Black_dec4_low 		"Af. American 75-100th perc. Toxic Concentration $\times$ Low"
label var Black_dec4_medium 	"Af. American 75-100th perc. Toxic Concentration $\times$ Medium"
label var Black_dec4_high 		"Af. American 75-100th perc. Toxic Concentration  $\times$ High"
label var Minority_dec4_low 	"Minority 75-100th perc. Toxic Concentration $\times$ Low"
label var Minority_dec4_medium 	"Minority 75-100th perc. Toxic Concentration $\times$ Medium"
label var Minority_dec4_high 	"Minority 75-100th perc. Toxic Concentration $\times$ High"

************************************************************************************************
* Minority
************************************************************************************************



clogit choice Minority_dec2_low  Minority_dec3_low Minority_dec4_low /// 
				Minority_dec2_medium Minority_dec3_medium Minority_dec4_medium ///
			    Minority_dec2_high Minority_dec3_high Minority_dec4_high ///
			 i.gender i.order  , group(Address)  cl(Zip_Code) level(90) 

outreg2 using "views/table_maternal_education.tex", eform excel tex cti(odds ratio) dec(4) ///
								label drop(i.gender i.order)  ci   level(90)  addstat(Total obs, `e(N)'+`e(N_drop)' )    replace





************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

clogit choice Black_dec2_low       Black_dec3_low Black_dec4_low ///
			  Black_dec2_medium    Black_dec3_medium  Black_dec4_medium  ///
			  Black_dec2_high      Black_dec3_high Black_dec4_high ///
			  Hispanic_dec2_low    Hispanic_dec3_low Hispanic_dec4_low ///
			  Hispanic_dec2_medium Hispanic_dec3_medium Hispanic_dec4_medium ///
			  Hispanic_dec2_high   Hispanic_dec3_high Hispanic_dec4_high ///
			 i.education_level i.order  , group(Address)  cl(Zip_Code) level(90) or

outreg2 using "views/table_maternal_education.tex", eform excel tex cti(odds ratio) dec(4) ///
								label drop(i.gender i.order)   ci   level(90)  addstat(Total obs, `e(N)'+`e(N_drop)' )    append





*end

