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
* Within 1 more than 1
************************************************************************************************



clogit choice Minority_within1  Minority_more1  ///
					  i.order i.gender  i.education_level , group(Address)   cl(Zip_Code) level(90)  


matrix define B=J(2,5,.)

	matrix B[1,1] =  _b[Minority_within1] - invttail(e(N),0.05)*_se[Minority_within1]
	matrix B[1,2] =  _b[Minority_within1]
	matrix B[1,3] =  _b[Minority_within1] + invttail(e(N),0.05)*_se[Minority_within1]

	

	matrix B[2,1] =  _b[Minority_more1] - invttail(e(N),0.05)*_se[Minority_more1]
	matrix B[2,2] =  _b[Minority_more1]
	matrix B[2,3] =  _b[Minority_more1] + invttail(e(N),0.05)*_se[Minority_more1]

	
	


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


save "stores/aux/distance_minority_full_set.dta"	, replace
restore

************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************
* Within 1 more than 1
************************************************************************************************

clogit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.order i.gender  i.education_level , group(Address)   cl(Zip_Code) level(90) 

matrix define H=J(2,5,.)

	matrix H[1,1] =  _b[Hispanic_within1] - invttail(e(N),0.05)*_se[Hispanic_within1]
	matrix H[1,2] =  _b[Hispanic_within1]
	matrix H[1,3] =  _b[Hispanic_within1] + invttail(e(N),0.05)*_se[Hispanic_within1]

	matrix H[2,1] =  _b[Hispanic_more1] - invttail(e(N),0.05)*_se[Hispanic_more1]
	matrix H[2,2] =  _b[Hispanic_more1]
	matrix H[2,3] =  _b[Hispanic_more1] + invttail(e(N),0.05)*_se[Hispanic_more1]
	
	
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
	matrix B[1,1] =  _b[Black_within1] - invttail(e(N),0.05)*_se[Black_within1]
	matrix B[1,2] =  _b[Black_within1]
	matrix B[1,3] =  _b[Black_within1] + invttail(e(N),0.05)*_se[Black_within1]

	matrix B[2,1] =  _b[Black_more1] - invttail(e(N),0.05)*_se[Black_more1]
	matrix B[2,2] =  _b[Black_more1]
	matrix B[2,3] =  _b[Black_more1] + invttail(e(N),0.05)*_se[Black_more1]
	mat list B	

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



save "stores/aux/distance_race_black_full_set.dta"	, replace
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



save "stores/aux/distance_race_Hispanic_full_set.dta"	, replace
restore


clogit choice Hispanic_within1  Hispanic_more1  ///
					  Black_within1  Black_more1  ///
					  i.order i.gender  i.education_level , group(Address) or  cl(Zip_Code) level(90)









*end