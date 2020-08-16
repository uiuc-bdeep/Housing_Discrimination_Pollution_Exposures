

capture program drop disc_boot_logit
program define disc_boot_logit, eclass
	version 15.1

	syntax varlist(numeric fv),  [VARLIST2(varlist numeric fv) or]
	marksample touse

	if "`or'"!="" {
		local eform_option "eform(Odds Ratio)"
	}

	gettoken depvar controls: varlist

	local k : word count `controls'

	tokenize `controls'


	tempname Z V dofs B


	qui{
		
		*clogit `depvar' `controls'   `varlist2'  if `touse', group(Address)   cl(Zip_Code) level(90)
		logit  `depvar' `controls'   `varlist2'  if `touse',  cl(Zip_Code) level(90) 
		mat def  B=e(b)

		if `k'==1 {
			boottest  {`1'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==2 {
			boottest  {`1'} {`2'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==3 {
			boottest  {`1'} {`2'} {`3'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==4 {
			boottest  {`1'} {`2'} {`3'} {`4'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==5 {
			boottest  {`1'} {`2'} {`3'}  {`4'} {`5'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==6 {
			boottest  {`1'} {`2'} {`3'} {`4'} {`5'} {`6'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==7 {
			boottest  {`1'} {`2'} {`3'} {`4'} {`5'} {`6'} {`7'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==8 {
			boottest  {`1'} {`2'} {`3'} {`4'} {`5'} {`6'} {`7'} {`8'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==9 {
			boottest  {`1'} {`2'} {`3'} {`4'} {`5'} {`6'} {`7'} {`8'} {`9'} , bootcluster(Zip_Code) small qui  
		}
		else if `k'==12 {
			boottest  {`1'} {`2'} {`3'} {`4'} {`5'} {`6'} {`7'} {`8'} {`9'} {`10'} {`11'} {`12'}  , bootcluster(Zip_Code) small qui  
		}
		else if `k'==18 {
			boottest  {`1'} {`2'} {`3'} {`4'} {`5'} {`6'} {`7'} {`8'} {`9'} {`10'} {`11'} {`12'} {`13'} {`14'} {`15'} {`16'} {`17'} {`18'} , bootcluster(Zip_Code) small qui  
		}
	}
	
	



	*Matrics
	*Coeficients
	mat def Z = B[1,1..`k']
	*this 4 lines reset row and col names
	matrix colnames Z =
	matrix rownames Z =
	matrix coleq Z =
	matrix roweq Z =
	mat colnames Z=`controls'
	matrix coleq Z = _:

	*Matrics
	*Coeficients
	*mat def Z=J(1,`k',.)
	*mat colnames Z=`controls'
	*forvalues i= 1/`k'{
	*	mat Z[1,`i']=r(b_`i')
	*}
	
	*Variance Matrix
	mat def K=J(`k',`k',0)
	mat rownames K= `controls'
	mat colnames K= `controls'
	forvalues i= 1/`k'{
		mat K[`i',`i']=r(V_`i')		
	}

	*Degree of fredom
	forvalues i=1/`k'{
		local dofs_`i' = r(df_r_`i')
	}

	
	local dofs= r(df_r_1)
	local obs = e(N)
	
	
	ereturn local         cmd   "disc_boot_logit"
	ereturn post Z K , dof(`dofs') obs(`obs') esample(`touse') buildfvinfo
	ereturn scalar obs=`obs'
	
	forvalues i=1/`k'{
		ereturn scalar df_`i' = `dofs_`i''
	}

	display ""
	display ""
	display "Bootstrap Corrected Estimates"
	ereturn display, level(90) `eform_option'

end
