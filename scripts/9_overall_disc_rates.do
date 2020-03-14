clear all
set matsize 11000


cd  "~/Dropbox/Research/toxic_discrimination/"


do "scripts/analysis/Round5/Interquartile/5_clean_subset_data.do"

loc quartiles 4

split Address , p("_")

replace Address3=Address1 if Address3==""

*br Address*

drop Address1
rename Address2 round
rename Address3 Address_clean

*br  Address* round Zip_Code

table round Zip_Code

gen times_zip=.
replace times_zip=1 if Zip_Code==21230 & round=="1"
replace times_zip=1 if Zip_Code==21230 & round=="2"
replace times_zip=2 if Zip_Code==21230 & round=="5"
replace times_zip=2 if Zip_Code==21230 & round=="6"

replace times_zip=1 if Zip_Code==47906 & round=="12"
replace times_zip=2 if Zip_Code==47906 & round=="15"

replace times_zip=1 if Zip_Code==53212 & round=="4"
replace times_zip=2 if Zip_Code==53212 & round=="9"
replace times_zip=3 if Zip_Code==53212 & round=="13"


replace times_zip=1 if Zip_Code==60623 & round=="7"
replace times_zip=2 if Zip_Code==60623 & round=="10"

table times_zip Zip_Code


drop if times_zip==.
drop if times_zip==3

gen one=1
bys Address_clean: egen total=total(one)
keep if total>3



label variable Hispanic "Hispanic"
label variable Black "African American"

gen first=(times_zip==1)
gen second=(times_zip==2)





foreach depvar in first second {
	gen Hispanic_`depvar'=Hispanic*`depvar'
	gen Black_`depvar'=Black*`depvar'
	gen Minority_`depvar'=Minority*`depvar'

}

* Minority
clogit choice Minority_first Minority_second   i.gender i.education_level i.order  , group(Address)  or cl(Zip_Code) level(90)
outreg2 using "views/table2_overall_second_inquiry.tex", eform tex excel cti(odds ratio) dec(4) ///
								label  ci  level(90)  keep(Minority_first Minority_second) addstat(Total obs, `e(N)'+`e(N_drop)' )  replace 

/*
clogit choice Minority_first Minority_second i.month i.gender i.education_level i.order  , group(Address)  or cl(Zip_Code) level(90)
outreg2 using "views/table2_overall_second_inquiry.tex", eform tex excel cti(odds ratio) dec(4) ///
								label  ci  level(90)  keep(Minority_first Minority_second) addstat(Total obs, `e(N)'+`e(N_drop)' )  append 
*/


* Race


clogit choice Hispanic_first Hispanic_second ///
			  Black_first Black_second  ///
			    i.gender i.education_level i.order , group(Address)  or cl(Zip_Code) level(90)
outreg2 using "views/table2_overall_second_inquiry.tex", eform tex excel cti(odds ratio) dec(4) ///
								label  ci  level(90)  keep(Hispanic_first Hispanic_second Black_first Black_second ) addstat(Total obs, `e(N)'+`e(N_drop)' )  append 
/*
clogit choice Hispanic_first Hispanic_second ///
			  Black_first Black_second  ///
			  i.month  i.gender i.education_level i.order , group(Address)  or cl(Zip_Code) level(90)
outreg2 using "views/table2_overall_second_inquiry.tex", eform tex excel cti(odds ratio) dec(4) ///
								label  ci  level(90)  keep(Hispanic_first Hispanic_second Black_first Black_second ) addstat(Total obs, `e(N)'+`e(N_drop)' )  append 




 levelsof Zip_Code, local(levels) 
 foreach l of local levels {
		clogit choice Hispanic_first Hispanic_second ///
					  Black_first Black_second  ///
					  i.gender i.education_level i.order if Zip_Code==`l', group(Address)  or level(90)
		outreg2 using "views/table2_overall_second_inquiry.tex", eform tex excel cti(`l') dec(4) ///
										label  ci  level(90)  keep(Hispanic_first Hispanic_second Black_first Black_second ) addstat(Total obs, `e(N)'+`e(N_drop)' )  append 


		clogit choice Hispanic_first Hispanic_second ///
					  Black_first Black_second  ///
					  i.month  i.gender i.education_level i.order if Zip_Code==`l', group(Address)  or level(90)
		outreg2 using "views/table2_overall_second_inquiry.tex", eform tex excel cti(`l') dec(4) ///
										label  ci  level(90)  keep(Hispanic_first Hispanic_second Black_first Black_second ) addstat(Total obs, `e(N)'+`e(N_drop)' )  append 
}
 	
*/
*end