/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4


************************************************************************************************
* Columns (1)-(3)
************************************************************************************************



loc quartiles 4

decode type, gen(ap_type)
table ap_type
gen SFH=(ap_type=="Single-Family Home")
gen Apt=(ap_type=="Apartment")
gen Multi_Fam=(ap_type=="Multi-Family")
gen Other=(ap_type=="")

replace scorecancer=scorecancer/pop
replace scorenoncancer=scorenoncancer/pop

lab var rent "Rent"
lab var SFH "Single Family Home"
lab var Apt "Apartment"
lab var Multi_Fam "Multi Family"
lab var Other "Other Bldg. Type"
lab var bedroom_max "Bedrooms"
lab var bathroom_max "Bathrooms"
lab var sqft "Sqft."
lab var assault  "Assault"
lab var groceries  "Groceries"
lab var hispanicshare  "Share of Hispanics"
lab var blackshare  "Share of African American"
lab var whiteshare  "Share of Whites"
lab var povrate  " Poverty Rate"
lab var unemployed  "Unemployment Rate"
lab var college  "Share of College Educated"

matrix define B=J(38,`quartiles',.)

*ssc install winsor2
winsor2 rent, suffix(_w) cuts(0 99)

loc l = 1
foreach i of varlist toxconc scorecancer scorenoncancer rent_w SFH  Apt Multi_Fam Other bedroom_max bathroom_max sqft assault groceries hispanicsh blackshare whiteshare povrate  unemployed college  {

	forvalues j = 1/`quartiles'{
		
	sum  `i' if quartileZIP_property==`j'
		
	matrix B[`l',`j'] = r(mean)
	matrix B[`l'+1,`j'] = r(sd)

	*mat list B

	}
loc l=`l'+2
}

preserve
clear
svmat B


forvalues j = 1/`quartiles'{
	rename B`j' Q`j'
	format %9.2fc Q`j'
}

export delimited using "views/descriptive_RSEI.csv", replace
restore

************************************************************************************************
* Columns (4)-(5)
************************************************************************************************


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

export delimited using "views/descriptive_RSEI_ttest.csv", replace

restore
*end