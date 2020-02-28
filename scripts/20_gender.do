/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1



loc quartiles 4

gen male=(gender==2)
gen female=(gender==1)




forvalues i = 2/`quartiles'{
	foreach genero in male female {
		gen Hispanic_dec`i'_`genero'=Hispanic*dec`i'*`genero'
		gen Black_dec`i'_`genero'=Black*dec`i'*`genero'
		gen Minority_dec`i'_`genero'=Minority*dec`i'*`genero'
	}

	

}


label variable Hispanic_dec2_female "Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ Female"
label variable Hispanic_dec2_male "Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ Male"
label variable Hispanic_dec3_female "Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ Female"
label variable Hispanic_dec3_male "Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ Male"
label variable Hispanic_dec4_female "Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ Female"
label variable Hispanic_dec4_male "Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ Male"


label variable Black_dec2_female "Af. American 0-25th perc. Toxic Concentration $\times$ Female"
label variable Black_dec2_male "Af. American 0-25th perc. Toxic Concentration $\times$ Male"
label variable Black_dec3_female "Af. American 25-75th perc. Toxic Concentration $\times$ Female"
label variable Black_dec3_male "Af. American 25-75th perc. Toxic Concentration $\times$ Male"
label variable Black_dec4_female "Af. American 75-100th perc. Toxic Concentration $\times$ Female"
label variable Black_dec4_male "Af. American 75-100th perc. Toxic Concentration $\times$ Male"


label variable Minority_dec2_female "Minority 0-25th perc. Toxic Concentration $\times$ Female"
label variable Minority_dec2_male 	"Minority 0-25th perc. Toxic Concentration $\times$ Male"
label variable Minority_dec3_female "Minority 25-75th perc. Toxic Concentration $\times$ Female"
label variable Minority_dec3_male 	"Minority 25-75th perc. Toxic Concentration $\times$ Male"
label variable Minority_dec4_female "Minority 75-100th perc. Toxic Concentration $\times$ Female"
label variable Minority_dec4_male 	"Minority 75-100th perc. Toxic Concentration $\times$ Male"

************************************************************************************************
* Minority
************************************************************************************************





clogit choice Minority_dec2_female Minority_dec3_female Minority_dec4_female ///
			  Minority_dec2_male   Minority_dec3_male Minority_dec4_male ///
			 i.education_level i.order  , group(Address)  cl(Zip_Code) level(90) 

outreg2 using "views/tableSI_5.tex", eform cti(odds ratio) dec(4) ///
								label drop(education_level order) tex excel  ci addstat(Total obs, `e(N)'+`e(N_drop)' )    level(90) replace





************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

clogit choice Black_dec2_female Black_dec3_female  Black_dec4_female ///
			  Black_dec2_male Black_dec3_male Black_dec4_male ///
			  Hispanic_dec2_female Hispanic_dec3_female Hispanic_dec4_female ///
			  Hispanic_dec2_male Hispanic_dec3_male Hispanic_dec4_male ///
			 i.education_level i.order  , group(Address)  cl(Zip_Code) level(90) or

outreg2 using "views/table_maternal_education.tex", eform excel tex cti(odds ratio) dec(4) ///
								label drop(i.gender i.order)   ci   level(90)  addstat(Total obs, `e(N)'+`e(N_drop)' )    append





*end

