/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "../stores/toxic_discrimination_data.dta"


loc quartiles 4


set seed 1010101

************************************************************************************************
* Minority
************************************************************************************************


disc_boot choice Minority_dec2 Minority_dec3 Minority_dec4 , varlist(i.gender i.education_level i.order)
mat def b=e(b)
mat def V=e(V)

mat def C=J(3,3,.)
forvalues i= 1/3{
	mat C[`i',1]=b[1,`i'] // coefs
	mat C[`i',2]=V[`i',`i'] // var
	mat C[`i',3]=e(df_`i') // dofs
	}


loc quartiles 4
matrix define M=J(`quartiles'-1,5,.)
forvalues j = 2/`quartiles'{
	loc i=	`j'-1
		
	matrix M[`i',1] = C[`i',1] - invttail(C[`i',3],0.05)*sqrt(C[`i',2])
	matrix M[`i',2] = C[`i',1] 
	matrix M[`i',3] = C[`i',1] + invttail(C[`i',3],0.05)*sqrt(C[`i',2])

	sum Minority if dec`j'==1
	matrix M[`i',4]=`r(N)'
	sum choice if White==1 &  dec`j'==1
	matrix M[`i',5]=`r(mean)'
	
	mat list M

}



*--------------------------------------------------------------------
preserve
clear
svmat M
gen n=_n
replace M1=exp(M1)
replace M2=exp(M2)
replace M3=exp(M3)


rename M1 lci
rename M2 coef
rename M3 uci
rename M4 obs
rename M5 c_mean
rename n deciles



save "../stores/aux/interquartile_toxconc_minority_full_set_bootcl.dta", replace
restore


************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

disc_boot choice Hispanic_dec2  Hispanic_dec3 Hispanic_dec4 ///
	 				Black_dec2  Black_dec3 Black_dec4  , varlist(i.gender i.education_level i.order)
mat def b=e(b)
mat def V=e(V)

*Matrices for boottest estimates
*Hispanics
mat def H_C=J(3,3,.)
forvalues i= 1/3{
	mat H_C[`i',1]=b[1,`i']
	mat H_C[`i',2]=V[`i',`i']
	mat H_C[`i',3]=e(df_`i')
	}

*Af. Am.	
mat def H_B=J(3,3,.)
forvalues i= 4/6{
	loc j=`i'-3
	mat H_B[`j',1]=b[1,`i']
	mat H_B[`j',2]=V[`i',`i']
	mat H_B[`j',3]=e(df_`i')
	}
	
*Matrices with results to export and plot
matrix define H=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	
	matrix H[`i',1] = H_C[`i',1] - invttail(H_C[`i',3],0.05)*sqrt(H_C[`i',2])
	matrix H[`i',2] = H_C[`i',1] 
	matrix H[`i',3] = H_C[`i',1] + invttail(H_C[`i',3],0.05)*sqrt(H_C[`i',2])
	
	sum Hispanic if dec`j'==1
	matrix H[`i',4]=`r(N)'
	sum choice if White==1 &  dec`j'==1
	matrix H[`i',5]=`r(mean)'
	
}



matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	
	matrix B[`i',1] = H_B[`i',1] - invttail(H_B[`i',3],0.05)*sqrt(H_B[`i',2])
	matrix B[`i',2] = H_B[`i',1] 
	matrix B[`i',3] = H_B[`i',1] + invttail(H_B[`i',3],0.05)*sqrt(H_B[`i',2])
	
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

save "../stores/aux/interquartile_toxconc_AA_full_set_bootcl.dta", replace
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



save "../stores/aux/interquartile_toxconc_Hisp_full_set_bootcl.dta", replace
restore

*end
