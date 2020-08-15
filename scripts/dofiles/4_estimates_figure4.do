/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "../stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4

set seed 1010101

************************************************************************************************
* Minority
************************************************************************************************
* Within 1 more than 1
************************************************************************************************


disc_boot choice  Minority_within1  Minority_more1 , varlist(i.gender i.education_level i.order)

mat def b=e(b)
mat def V=e(V)

mat def R=J(2,3,.)

forvalues i= 1/2{
	mat R[`i',1]=b[1,`i']
	mat R[`i',2]=V[`i',`i']
	mat R[`i',3]=e(df_`i')
	}

matrix define B=J(2,5,.)

forvalues i= 1/2{
	matrix B[`i',1] =  R[`i',1] - invttail(R[`i',3],0.05)*sqrt(R[`i',2])
	matrix B[`i',2] =  R[`i',1] 
	matrix B[`i',3] =  R[`i',1] + invttail(R[`i',3],0.05)*sqrt(R[`i',2])
}

	
	


	sum Minority if within1==1
	matrix B[1,4]=`r(N)'

	sum Minority if more1==1
	matrix B[2,4]=`r(N)'
	

	sum choice if White==1 &  within1==1
	matrix B[1,5]=`r(mean)'

	sum choice if White==1 &  more1==1
	matrix B[2,5]=`r(mean)'
mat list B	




************************************************************************************************
* Matrix to dta
************************************************************************************************
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
rename n distance


save "../stores/aux/distance_minority_bootcl.dta"	, replace
restore

************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************
* Within 1 more than 1
************************************************************************************************
disc_boot choice  Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  , varlist(i.gender i.education_level i.order)

mat def b=e(b)
mat def V=e(V)

mat def R=J(4,3,.)

forvalues i= 1/4{
	mat R[`i',1]=b[1,`i']
	mat R[`i',2]=V[`i',`i']
	mat R[`i',3]=e(df_`i')
	}


matrix define H=J(2,5,.)
forvalues i= 1/2{
	matrix H[`i',1] =  R[`i',1] - invttail(R[`i',3],0.05)*sqrt(R[`i',2])
	matrix H[`i',2] =  R[`i',1] 
	matrix H[`i',3] =  R[`i',1] + invttail(R[`i',3],0.05)*sqrt(R[`i',2])
}

	sum Hispanic if within1==1
	matrix H[1,4]=`r(N)'

	sum Hispanic if more1 ==1
	matrix H[2,4]=`r(N)'
	mat list H

	sum choice if White==1 &  within1==1
	matrix H[1,5]=`r(mean)'

	sum choice if White==1 &  more1==1
	matrix H[2,5]=`r(mean)'
	mat list H


matrix define B=J(2,5,.)

forvalues i= 1/2{
	matrix B[`i',1] =  R[`i'+2,1] - invttail(R[`i'+2,3],0.05)*sqrt(R[`i'+2,2])
	matrix B[`i',2] =  R[`i'+2,1] 
	matrix B[`i',3] =  R[`i'+2,1] + invttail(R[`i'+2,3],0.05)*sqrt(R[`i'+2,2])
}


	sum Black if within1==1
	matrix B[1,4]=`r(N)'

	sum Black if more1==1
	matrix B[2,4]=`r(N)'
	mat list B

	sum choice if White==1 &  within1==1
	matrix B[1,5]=`r(mean)'

	sum choice if White==1 &  more1==1
	matrix B[2,5]=`r(mean)'
	mat list B




************************************************************************************************
* Matrix to dta
************************************************************************************************
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
rename n distance



save "../stores/aux/distance_race_afam_bootcl.dta"	, replace
restore

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
rename n distance



save "../stores/aux/distance_race_hispanic_bootcl.dta"	, replace
restore


clogit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.order i.gender  i.education_level , group(Address) or  cl(Zip_Code) level(90)









*end