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
* Above vs Below Median Rent
************************************************************************************************

egen quartileZIP_rent=xtile(rent), n(2) by(Zip_Code)  


forvalues i = 1/2{
	gen rent_dec`i'=(quartileZIP_rent==`i')
}

forvalues i = 2/`quartiles'{
	forvalues j = 1/2{
		gen Minority_dec`i'_rent_dec`j'=Minority*dec`i'*rent_dec`j'
	}
}



disc_boot choice  Minority_dec2_rent_dec1  Minority_dec3_rent_dec1  Minority_dec4_rent_dec1 ///
			  Minority_dec2_rent_dec2  Minority_dec3_rent_dec2  Minority_dec4_rent_dec2 ///
					  , varlist(i.gender i.education_level i.order)

mat def b=e(b)
mat def V=e(V)
*Matrices for boottest estimates
*Low Rent
mat def L_R=J(3,3,.)
forvalues i= 1/3{
	mat L_R[`i',1]=b[1,`i']
	mat L_R[`i',2]=V[`i',`i']
	mat L_R[`i',3]=e(df_`i')
	}

*High Rent	
mat def H_R=J(3,3,.)
forvalues i= 4/6{
	loc j=`i'-3
	mat H_R[`j',1]=b[1,`i']
	mat H_R[`j',2]=V[`i',`i']
	mat H_R[`j',3]=e(df_`i')
	}



matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = L_R[`i',1] - invttail(L_R[`i',3],0.05)*sqrt(L_R[`i',2])
	matrix B[`i',2] = L_R[`i',1] 
	matrix B[`i',3] = L_R[`i',1] + invttail(L_R[`i',3],0.05)*sqrt(L_R[`i',2])

	*sum Minority_dec`j'_rent_dec1
	*matrix B[`i',4]=`r(sum)'
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


rename B1 lci
rename B2 or
rename B3 uci

rename n deciles


save "../stores/aux/interquartile_toxconc_minority_rent_low_bootcl.dta", replace
restore
*--------------------------------------------------------------------




matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = H_R[`i',1] - invttail(H_R[`i',3],0.05)*sqrt(H_R[`i',2])
	matrix B[`i',2] = H_R[`i',1] 
	matrix B[`i',3] = H_R[`i',1] + invttail(H_R[`i',3],0.05)*sqrt(H_R[`i',2])

	*sum Minority_dec`j'_rent_dec2
	*matrix B[`i',4]=`r(sum)'
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



rename B1 lci
rename B2 or
rename B3 uci

rename n deciles


save "../stores/aux/interquartile_toxconc_minority_rent_high_bootcl.dta", replace
restore
*--------------------------------------------------------------------


************************************************************************************************
* Demographinc Composition, Above vs Below Minority Shares
************************************************************************************************
gen minorityshare=blackshare+hispanicshare 
egen quartileZIP_minority_share=xtile(minorityshare), n(2) by(Zip_Code)  

mean minorityshare, over(quartileZIP_minority_share)

*Decile 1 Low share of minority
*Decile 2 High share of minority

forvalues i = 1/2{
	gen w_share_dec`i'=(quartileZIP_minority_share==`i')
}


forvalues i = 2/`quartiles'{
	forvalues j = 1/2{
		gen Minority_dec`i'_w_share_dec`j'=Minority*dec`i'*w_share_dec`j'
	}
}




disc_boot choice  Minority_dec2_w_share_dec1  Minority_dec3_w_share_dec1  Minority_dec4_w_share_dec1 ///
			  Minority_dec2_w_share_dec2  Minority_dec3_w_share_dec2  Minority_dec4_w_share_dec2 ///
					  , varlist(i.gender i.education_level i.order)

mat def b=e(b)
mat def V=e(V)

*Matrices for boottest estimates
*Low Share
mat def L_S=J(3,3,.)
forvalues i= 1/3{
	mat L_S[`i',1]=b[1,`i']
	mat L_S[`i',2]=V[`i',`i']
	mat L_S[`i',3]=e(df_`i')
	}

*High Share	
mat def H_S=J(3,3,.)
forvalues i= 4/6{
	loc j=`i'-3
	mat H_S[`j',1]=b[1,`i']
	mat H_S[`j',2]=V[`i',`i']
	mat H_S[`j',3]=e(df_`i')
	}


*Decile 1 Low share of minority


matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = L_S[`i',1] - invttail(L_S[`i',3],0.05)*sqrt(L_S[`i',2])
	matrix B[`i',2] = L_S[`i',1] 
	matrix B[`i',3] = L_S[`i',1] + invttail(L_S[`i',3],0.05)*sqrt(L_S[`i',2])

	*sum Minority_dec`j'_w_share_dec1
	*matrix B[`i',4]=`r(sum)'
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



rename B1 lci
rename B2 or
rename B3 uci

rename n deciles


save "../stores/aux/interquartile_toxconc_minority_w_share_low_bootcl.dta", replace
restore
*--------------------------------------------------------------------

*Decile 2 High share of minority

matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = H_S[`i',1] - invttail(H_S[`i',3],0.05)*sqrt(H_S[`i',2])
	matrix B[`i',2] = H_S[`i',1] 
	matrix B[`i',3] = H_S[`i',1] + invttail(H_S[`i',3],0.05)*sqrt(H_S[`i',2])

	*sum Minority_dec`j'_w_share_dec2
	*matrix B[`i',4]=`r(sum)'
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



rename B1 lci
rename B2 or
rename B3 uci

rename n deciles


save "../stores/aux/interquartile_toxconc_minority_w_share_high_bootcl.dta", replace
restore


************************************************************************************************
* Matched Sample
************************************************************************************************/



preserve
keep if matched_sample==1


loc quartiles 4

disc_boot choice  Minority_dec2 Minority_dec3 Minority_dec4 ///
					  , varlist(i.gender i.education_level i.order)

mat def b=e(b)
mat def V=e(V)

mat def C=J(3,3,.)
forvalues i= 1/3{
	mat C[`i',1]=b[1,`i']
	mat C[`i',2]=V[`i',`i']
	mat C[`i',3]=e(df_`i')
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
restore

*--------------------------------------------------------------------
preserve
clear
svmat M
gen n=_n
replace M1=exp(M1)
replace M2=exp(M2)
replace M3=exp(M3)


rename M1 lci
rename M2 or
rename M3 uci


rename n deciles


save "../stores/aux/interquartile_toxconc_minority_matched_bootcl.dta", replace
restore

*end