/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4


gen computer=(person_or_computer==2)
bys Address: egen computer_total=total(computer)
tab computer_total 
tab computer_total Zip_Code



************************************************************************************************
* Minority
************************************************************************************************





label variable Minority_dec2 "Minority 0-25th perc. Toxic Concentration"
label variable Minority_dec3 "Minority 25-75th perc. Toxic Concentration"
label variable Minority_dec4 "Minority 75-100th perc. Toxic Concentration"



clogit choice  Minority_dec2 Minority_dec3 Minority_dec4  i.gender i.education_level i.order  , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_human_computer_minority.tex", excel tex eform cti(odds ratio) dec(4) ///
								label    ci  ///
								keep( Minority_dec2 Minority_dec3 Minority_dec4 ) level(90) addstat(Total obs, `e(N)'+`e(N_drop)' )  replace

clogit choice  Minority_dec2 Minority_dec3 Minority_dec4  i.gender i.education_level i.order if computer_total==0 , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_human_computer_minority.tex", excel tex eform cti(odds ratio) dec(4) ///
								label    ci  ///
								keep( Minority_dec2 Minority_dec3 Minority_dec4 ) level(90) addstat(Total obs, `e(N)'+`e(N_drop)' )  append





************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

label variable Hispanic_dec2 "Hispanic/LatinX 0-25th perc. Toxic Concentration"
label variable Hispanic_dec3 "Hispanic/LatinX 25-75th perc. Toxic Concentration"
label variable Hispanic_dec4 "Hispanic/LatinX 75-100th perc. Toxic Concentration"


label variable Black_dec2 "Af. American 0-25th perc. Toxic Concentration"
label variable Black_dec3 "Af. American 25-75th perc. Toxic Concentration"
label variable Black_dec4 "Af. American 75-100th perc. Toxic Concentration"

clogit choice Black_dec2  Black_dec3 Black_dec4 ///
	 				Hispanic_dec2  Hispanic_dec3 Hispanic_dec4 ///
	 				  i.gender i.education_level i.order  , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_human_computer.tex", excel tex eform cti(odds ratio) dec(4) ///
								label    ci  ///
								keep(  Black_dec2  Black_dec3 Black_dec4 Hispanic_dec2  Hispanic_dec3 Hispanic_dec4) level(90) addstat(Total obs, `e(N)'+`e(N_drop)' )  replace

clogit choice Black_dec2  Black_dec3 Black_dec4 ///
	 				Hispanic_dec2  Hispanic_dec3 Hispanic_dec4 ///
				 i.gender i.education_level i.order if computer_total==0 , group(Address)  cl(Zip_Code) level(90)
outreg2 using "views/table_human_computer.tex", excel tex eform cti(odds ratio) dec(4) ///
								label    ci  ///
								keep(  Black_dec2  Black_dec3 Black_dec4  Hispanic_dec2  Hispanic_dec3 Hispanic_dec4) level(90) addstat(Total obs, `e(N)'+`e(N_drop)' )  append


*end