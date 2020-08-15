
*! disc_boot 0.0.1

* This program is free software under MIT license




capture program drop disc_boot
program define disc_boot, eclass
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

	
		
		clogit `depvar' `controls'   `varlist2'  if `touse', group(Address)   cl(Zip_Code) level(90)
		
		mat def  B=e(b)
		
		
qui{
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

	*mat def Z=J(1,`k',.)
	*mat colnames Z=`controls'
	*if `k'==1{
	*	mat Z[1,1]=r(b)
	*}
	*else {
	*	forvalues i= 1/`k'{
	*		mat Z[1,`i']=r(b_`i')
	*	}
	*}
	*Variance Matrix
	mat def K=J(`k',`k',0)
	mat rownames K= `controls'
	mat colnames K= `controls'

	if `k'==1{
		mat K[1,1]=r(V)		
	}
	else {
		forvalues i= 1/`k'{
			mat K[`i',`i']=r(V_`i')		
		}
	}


	*Degree of fredom
	forvalues i=1/`k'{
		local dofs_`i' = r(df_r_`i')
	}
	
	if `k'==1{
			local dofs= r(df_r)
		} 
	else { 
			local dofs= r(df_r_1) 
		}
	local obs = e(N)+e(N_drop)
	local diff_response=e(N)/(e(N)+e(N_drop))
	local listings= `obs'/3
	
	
	
	ereturn post Z K , dof(`dofs') obs(`obs') esample(`touse') buildfvinfo
	ereturn scalar listings=`listings'
	ereturn scalar diff_response=`diff_response'
	
	forvalues i=1/`k'{
		ereturn scalar df_`i' = `dofs_`i''
	}

	display ""
	display ""
	display "Bootstrap Corrected Estimates"
	ereturn display, level(90) `eform_option'
	ereturn local         cmd   "disc_boot"

end


