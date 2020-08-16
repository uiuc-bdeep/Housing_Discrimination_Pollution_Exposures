/*********************************************************************************************************
Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins
*********************************************************************************************************/

clear all
set matsize 11000

use "../stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4

set seed 1010101



************************************************************************************************
* Toxic Concentration
***********************************************************************************************

eststo clear

forvalues i=1/3{
	preserve
	keep if order==`i'							
	 eststo: disc_boot_logit choice Minority_dec2 Minority_dec3 Minority_dec4 , varlist(i.gender i.education_level)
	estimates store modelA1`i'
	 eststo: disc_boot_logit choice Black_dec2 Black_dec3 Black_dec4 Hispanic_dec2 Hispanic_dec3 Hispanic_dec4, varlist(i.gender i.education_level)
	estimates store modelA2`i'	
	 eststo: disc_boot_logit choice Minority_within1  Minority_more1, varlist(i.gender i.education_level) 
	estimates store modelB1`i'
	 eststo: disc_boot_logit choice Black_within1  Black_more1 Hispanic_within1  Hispanic_more1 , varlist(i.gender i.education_level)
		estadd local gender = "Yes", replace 
		estadd local edu = "Yes", replace 
	estimates store modelB2`i'	
	restore
	}


************************************************************************************************
* Export to latex
* based on http://www.eyalfrank.com/code-riffs-stata-and-regression-tables/
************************************************************************************************

************************************************************
* estout Panel A1
************************************************************


#delimit ; 
esttab modelA11 
       modelA12 
       modelA13
       using "../views/tableA7.tex", 
       style(tex) 
       eform
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  )  
       label 
       noobs
       mlabels(,none)  
       nonumbers 
       collabels(,none) 
       eqlabels(,none)
       varlabels(Minority_dec2 "Minority 0-25th perc. Toxic Concentration" 
				 Minority_dec3 "Minority 25-75th perc. Toxic Concentration"  
				 Minority_dec4 "Minority 75-100th perc. Toxic Concentration" ) 
       starl(* 0.1 ** 0.05 *** 0.01)   
       level(90)     
       prehead( 
				\begin{table}[H]
					\scriptsize \centering
					\begin{threeparttable}
					\captionsetup{justification=centering}
					  \caption{Estimates of Discriminatory Constraint on Housing Choice: \\ Inquiry Order}
					  \label{tab:inqorder}

					\begin{tabular}{@{\extracolsep{5pt}}lccc}
					\\[-1.8ex]\hline
					\hline \\[-1.8ex]
					 & \multicolumn{3}{c}{\textit{Dependent variable: {\it  Response}}} \\
					 \cline{2-4}
					\\[-1.8ex] & (1) & (2) & (3) \\
					\\[-1.8ex] &  1st Inquiry & 2nd Inquiry & 3rd Inquiry\\
					\hline \\[-1.8ex]
					{\it Panel A: Quartiles of RSEI Toxic Concentration}\\
					 \hline \\[-1.8ex]
       )
       posthead({\it Panel A.1.: Minority } \\
       				&  &  &    \\) 
      prefoot() 
       postfoot(
      \hline \\[-1.8ex] )
       
       replace;
#delimit cr

************************************************************
* estout Panel A2
************************************************************

#delimit ; 
esttab modelA21 
       modelA22 
       modelA23
       using "../views/tableA7.tex", 
       style(tex)
       eform 
       level(90)
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  )  
       label 
       noobs
       mlabels(,none)
       nonumbers 
       collabels(,none)      
       eqlabels(,none)
       varlabels(Black_dec2 "Af. American 0-25th perc. Toxic Concentration" 
				 Black_dec3 "Af. American 25-75th perc. Toxic Concentration" 
				 Black_dec4 "Af. American 75-100th perc. Toxic Concentration"
				 Hispanic_dec2 "Hispanic/LatinX 0-25th perc. Toxic Concentration" 
				 Hispanic_dec3 "Hispanic/LatinX 25-75th perc. Toxic Concentration" 
				 Hispanic_dec4 "Hispanic/LatinX 75-100th perc. Toxic Concentration" ) 
       starl(* 0.1 ** 0.05 *** 0.01)   
       prehead( 
       )
       posthead({\it Panel A.2.: By Race }\\
       		&  &  &    \\) 
       prefoot() 
       postfoot(
            \\[-1.8ex]\hline 
      \hline \\[-1.8ex] )
       
       append;
#delimit cr


************************************************************
* estout Panel B1
************************************************************

#delimit ; 
esttab modelB11 
       modelB12 
       modelB13
       using "../views/tableA7.tex", 
       style(tex)
       eform 
       level(90)
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  )  
       label 
       noobs
       mlabels(,none)
       nonumbers 
       collabels(,none)      
       eqlabels(,none)
       varlabels(Minority_within1 "TRI plant less than 1 mile $\times$ Minority"
				 Minority_more1 "TRI plant more than 1 mile $\times$  Minority") 
       starl(* 0.1 ** 0.05 *** 0.01)   
       prehead(  {\it Panel B: Proximity to TRI Plant}\\
				 \hline \\[-1.8ex]
       )
       posthead({\it Panel B.1.: Minority} \\
				 &  &  &    \\) 
       prefoot() 
       postfoot(
      \hline \\[-1.8ex] )
       
       append;
#delimit cr

************************************************************
* estout Panel B2
************************************************************

#delimit ; 
esttab modelB21 
       modelB22 
       modelB23
       using "../views/tableA7.tex", 
       style(tex) 
       eform
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  )  
       label 
       noobs
       mlabels(,none)  
       nonumbers
       collabels(,none) 
       eqlabels(,none)
       varlabels(Hispanic_within1 "TRI plant less than 1 mile $\times$ Hispanic/LatinX"
				 Hispanic_more1 "TRI plant more than 1 mile $\times$  Hispanic/LatinX"
				 Black_within1 "TRI plant less than 1 mile $\times$ African American"
				 Black_more1 "TRI plant more than 1 mile $\times$  African American") 
       starl(* 0.1 ** 0.05 *** 0.01) 
        stats(gender 
             edu              
             N
             , fmt(2 0 0 0 %9.0gc %9.0gc 2)
             labels("Gender" 
                   "Education Level" 
                   "\hline Observations"
                   )) 
       level(90)     
         prehead( 
       )
       posthead({\it Panel B.2.: By Race }\\
					 &  &  &    \\) 
      prefoot() 
       postfoot(           
				\hline
				\hline \\[-1.8ex]
				\end{tabular}
				\begin{tablenotes}[scriptsize,flushleft] \scriptsize
				\item Notes: 
				\end{tablenotes} 
				\end{threeparttable}
				\end{table})
       append;
#delimit cr



*end 