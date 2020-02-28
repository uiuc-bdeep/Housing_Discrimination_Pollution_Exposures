/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"



loc quartiles 4

************************************************************************************************
* Minority
************************************************************************************************

clogit choice  Minority_dec2 Minority_dec3 Minority_dec4  i.gender i.education_level i.order  , group(Address)  cl(Zip_Code) level(90)
	matrix coef=e(b)
	matrix var=vecdiag(e(V))
	mat list coef

matrix define B=J(`quartiles'-1,5,.)
forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = _b[Minority_dec`j'] - invttail(e(N),0.05)*_se[Minority_dec`j']
	matrix B[`i',2] = _b[Minority_dec`j']
	matrix B[`i',3] = _b[Minority_dec`j'] + invttail(e(N),0.05)*_se[Minority_dec`j']

	sum Minority if dec`j'==1
	matrix B[`i',4]=`r(N)'
	sum choice if White==1 &  dec`j'==1
	matrix B[`i',5]=`r(mean)'
	
	mat list B
	
}



*--------------------------------------------------------------------
preserve
clear
svmat B
gen n=_n
replace B1=exp(B1)
replace B2=exp(B2)
replace B3=exp(B3)


rename B1 H_lower
rename B2 Hispanic
rename B3 H_higher

rename n deciles


save "stores/aux/interquartile_toxconc_minority_full_set.dta", replace
restore


************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

clogit choice Hispanic_dec2  Hispanic_dec3 Hispanic_dec4 ///
	 				Black_dec2  Black_dec3 Black_dec4 ///
	 				 i.gender i.education_level i.order  , group(Address)  cl(Zip_Code) level(90) or

	matrix coef=e(b)
	matrix var=vecdiag(e(V))
	


matrix define H=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	
	matrix H[`i',1] = _b[Hispanic_dec`j'] - invttail(e(N),0.05)*_se[Hispanic_dec`j'] 
	matrix H[`i',2] = _b[Hispanic_dec`j']
	matrix H[`i',3] = _b[Hispanic_dec`j'] + invttail(e(N),0.05)*_se[Hispanic_dec`j'] 
	
	sum Hispanic if dec`j'==1
	matrix H[`i',4]=`r(N)'
	sum choice if White==1 &  dec`j'==1
	matrix H[`i',5]=`r(mean)'
	
}



matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	
	matrix B[`i',1] = _b[Black_dec`j'] - invttail(e(N),0.05)*_se[Black_dec`j'] 
	matrix B[`i',2] = _b[Black_dec`j'] 
	matrix B[`i',3] = _b[Black_dec`j'] + invttail(e(N),0.05)*_se[Black_dec`j'] 
	
	sum Black if dec`j'==1
	matrix B[`i',4]=`r(N)'
	sum choice if White==1 &  dec`j'==1
	matrix B[`i',5]=`r(mean)'
	
}

mat list B

clogit choice  Hispanic_dec2 Hispanic_dec3 Hispanic_dec4 ///
	 				 Black_dec2 Black_dec3 Black_dec4 ///
	 				 i.gender i.education_level i.order , or group(Address)  cl(Zip_Code) level(90)

di (`e(N)'+`e(N_drop)')/3
*--------------------------------------------------------------------
preserve
clear
svmat B
gen n=_n
replace B1=exp(B1)
replace B2=exp(B2)
replace B3=exp(B3)



rename B1 lci
rename B2 or
rename B3 uci
rename B4 obs
rename B5 c_mean
rename n deciles

save "stores/aux/interquartile_toxconc_AA_full_set.dta", replace
restore




*--------------------------------------------------------------------
preserve
clear
svmat H
gen n=_n
replace H1=exp(H1)
replace H2=exp(H2)
replace H3=exp(H3)



rename H1 lci
rename H2 or
rename H3 uci
rename H4 obs
rename H5 c_mean
rename n deciles



save "stores/aux/interquartile_toxconc_Hisp_full_set.dta", replace
restore






*end
