/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "../stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 3


************************************************************************************************
* Columns (1)-(3)
************************************************************************************************

decode type, gen(ap_type)
table ap_type
gen SFH=(ap_type=="Single-Family Home")
gen Apt=(ap_type=="Apartment")
gen Multi_Fam=(ap_type=="Multi-Family")
gen Other=(ap_type=="")

replace scorecancer=scorecancer/pop
replace scorenoncancer=scorenoncancer/pop

lab var SFH "Single Family Home"
lab var Apt "Apartment"
lab var Multi_Fam "Multi Family"
lab var Other "Other Bldg. Type"

matrix define B=J(38,`quartiles',.)


*ssc install winsor2
winsor2 rent, suffix(_w) cuts(0 99)


replace toxconc=toxconc/1000
replace rent_w=rent_w/1000


loc l = 1
foreach i of varlist toxconc scorecancer scorenoncancer rent_w SFH  Apt Multi_Fam Other bedroom_max bathroom_max sqft assault groceries hispanicsh blackshare whiteshare povrate  unemployed college  {

	forvalues j = 1/`quartiles'{
		
	sum  `i' if quartileZIP_property==`j'+1
		
	matrix B[`l',`j'] = r(mean)
	matrix B[`l'+1,`j'] = r(sd)

	
	
	}
loc l=`l'+2
}

mat list B

preserve
clear
svmat B


forvalues j = 1/`quartiles'{
	rename B`j' Q`j'
	format %9.2fc Q`j'
}

export delimited using "../views/descriptive_RSEI.csv", replace
restore

************************************************************************************************
* Columns (4)-(5)
************************************************************************************************


tab quartileZIP_property, gen(Q)

loc quartiles 3
matrix define B=J(38,`quartiles',.)


loc l = 1
*
foreach i of varlist toxconc scorecancer scorenoncancer rent_w SFH  Apt Multi_Fam Other bedroom_max bathroom_max sqft assault groceries hispanicsh blackshare whiteshare povrate  unemployed college  {
	
		
	reg `i' Q2 Q3 i.Zip_Code
		
	matrix B[`l',1] = _b[_cons]
	matrix B[`l'+1,1] = _se[_cons]
	
	matrix B[`l',2] = _b[Q2]
	matrix B[`l'+1,2] = _se[Q2]
	matrix B[`l',3] = _b[Q3]
	matrix B[`l'+1,3] = _se[Q3]
	

	
loc l=`l'+2
}

mat list B

preserve
clear
svmat B


forvalues j = 1/`quartiles'{
	rename B`j' Q`j'
	format %9.2fc Q`j'
}

export delimited using "../views/descriptive_RSEI_ttest.csv", replace

restore

*Needs to be handcoded
preserve
egen listings_zip_bin = count(Address), by (Zip_Code quartileZIP_property)
egen listings_zip = count(Address), by (Zip_Code)
gen share_listings=listings_zip_bin/listings_zip


collapse (median) share_listings, by(quartileZIP_property Zip_Code)

forvalues j = 2/`quartiles'{
	sum  share_listings if quartileZIP_property==`j'
}	

tab quartileZIP_property, gen(Q)
reg share_listings Q2 Q3 i.Zip_Code
restore

*end