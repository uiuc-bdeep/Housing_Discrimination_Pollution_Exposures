/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4


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



clogit choice Minority_dec2_rent_dec1  Minority_dec3_rent_dec1  Minority_dec4_rent_dec1 ///
			  Minority_dec2_rent_dec2  Minority_dec3_rent_dec2  Minority_dec4_rent_dec2 ///
			 i.gender i.order  i.education_level , group(Address)  cl(Zip_Code) level(90) or




matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = _b[Minority_dec`j'_rent_dec1] - invttail(e(N),0.05)*_se[Minority_dec`j'_rent_dec1]
	matrix B[`i',2] = _b[Minority_dec`j'_rent_dec1]
	matrix B[`i',3] = _b[Minority_dec`j'_rent_dec1] + invttail(e(N),0.05)*_se[Minority_dec`j'_rent_dec1]

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


save "stores/aux/interquartile_toxconc_minority_rent_low.dta", replace
restore
*--------------------------------------------------------------------




matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = _b[Minority_dec`j'_rent_dec2] - invttail(e(N),0.05)*_se[Minority_dec`j'_rent_dec2]
	matrix B[`i',2] = _b[Minority_dec`j'_rent_dec2]
	matrix B[`i',3] = _b[Minority_dec`j'_rent_dec2] + invttail(e(N),0.05)*_se[Minority_dec`j'_rent_dec2]

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


save "stores/aux/interquartile_toxconc_minority_rent_high.dta", replace
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



clogit choice Minority_dec2_w_share_dec1  Minority_dec3_w_share_dec1  Minority_dec4_w_share_dec1 ///
			  Minority_dec2_w_share_dec2  Minority_dec3_w_share_dec2  Minority_dec4_w_share_dec2 ///
			 i.gender i.order  i.education_level , group(Address)  cl(Zip_Code) level(90) or



*Decile 1 Low share of minority


matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = _b[Minority_dec`j'_w_share_dec1] - invttail(e(N),0.05)*_se[Minority_dec`j'_w_share_dec1]
	matrix B[`i',2] = _b[Minority_dec`j'_w_share_dec1]
	matrix B[`i',3] = _b[Minority_dec`j'_w_share_dec1] + invttail(e(N),0.05)*_se[Minority_dec`j'_w_share_dec1]

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


save "stores/aux/interquartile_toxconc_minority_w_share_low.dta", replace
restore
*--------------------------------------------------------------------

*Decile 2 High share of minority

matrix define B=J(`quartiles'-1,5,.)

forvalues j = 2/`quartiles'{
	loc i=	`j'-1
	matrix B[`i',1] = _b[Minority_dec`j'_w_share_dec2] - invttail(e(N),0.05)*_se[Minority_dec`j'_w_share_dec2]
	matrix B[`i',2] = _b[Minority_dec`j'_w_share_dec2]
	matrix B[`i',3] = _b[Minority_dec`j'_w_share_dec2] + invttail(e(N),0.05)*_se[Minority_dec`j'_w_share_dec2]

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


save "stores/aux/interquartile_toxconc_minority_w_share_high.dta", replace
restore


************************************************************************************************
* Matched Sample
************************************************************************************************/




use "stores/toxic_discrimination_matched_data2.dta", clear

encode inquiry_order, gen(order)

loc quartiles 4


clogit choice Minority_dec2 Minority_dec3 Minority_dec4  ///
			   i.gender i.education_level i.order   , group(Address)  cl(Zip_Code) level(90) or




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
	
	
}
mat list B

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


save "stores/aux/interquartile_toxconc_minority_matched.dta", replace
restore

*end