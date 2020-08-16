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
* Prep data
************************************************************************************************
gen low=(education_level==2)
gen medium=(education_level==3)
gen high=(education_level==1)



forvalues i = 2/`quartiles'{
	foreach edu in low medium high {
		gen Hispanic_dec`i'_`edu'=Hispanic*dec`i'*`edu'
		gen Black_dec`i'_`edu'=Black*dec`i'*`edu'
		gen Minority_dec`i'_`edu'=Minority*dec`i'*`edu'
	}

}



************************************************************************************************
* Minority
************************************************************************************************



eststo: disc_boot choice Minority_dec2_low  Minority_dec3_low Minority_dec4_low /// 
				Minority_dec2_medium Minority_dec3_medium Minority_dec4_medium ///
			    Minority_dec2_high Minority_dec3_high Minority_dec4_high ///
			 , varlist(i.gender i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local order = "Yes", replace 
estimates store model1





************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

eststo: disc_boot choice Black_dec2_low  Black_dec3_low Black_dec4_low ///
			  Black_dec2_medium    Black_dec3_medium  Black_dec4_medium  ///
			  Black_dec2_high      Black_dec3_high Black_dec4_high ///
			  Hispanic_dec2_low    Hispanic_dec3_low Hispanic_dec4_low ///
			  Hispanic_dec2_medium Hispanic_dec3_medium Hispanic_dec4_medium ///
			  Hispanic_dec2_high   Hispanic_dec3_high Hispanic_dec4_high ///
			 , varlist(i.gender  i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local order = "Yes", replace 			 
estimates store model2




************************************************************************************************
* Export to latex
* based on http://www.eyalfrank.com/code-riffs-stata-and-regression-tables/
************************************************************************************************


#delimit ; 
esttab model1
	  model2
       using "../views/tableA11.tex",  
       style(tex) 
       eform
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  ) 
       label 
       stats(responsewhite
             gender  
             order
             N
             listings
             diff_response, fmt(2 0 0 %9.0gc %9.0gc 2)
             labels(" Mean Response (White)"
                   "\hline Gender" 
                   "Inquiry Order"
                   "\hline Observations"
                   "Listings"
                   "\% w. diff. response"
                   )) 
       mlabels( ,none)  
       nonumbers
       collabels(,none) 
       eqlabels(,none)
       varlabels(Hispanic_dec2_low 	"Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ Low"
				Hispanic_dec2_medium 	"Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ Medium"
				Hispanic_dec2_high 	"Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ High"
				Black_dec2_low 		"Af. American 0-25th perc. Toxic Concentration $\times$ Low"
				Black_dec2_medium 	"Af. American 0-25th perc. Toxic Concentration $\times$ Medium"
				Black_dec2_high 		"Af. American 0-25th perc. Toxic Concentration  $\times$ High"
				Minority_dec2_low 	"Minority 0-25th perc. Toxic Concentration $\times$ Low"
				Minority_dec2_medium 	"Minority 0-25th perc. Toxic Concentration $\times$ Medium"
				Minority_dec2_high 	"Minority 0-25th perc. Toxic Concentration $\times$ High"
				Hispanic_dec3_low 	"Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ Low"
				Hispanic_dec3_medium 	"Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ Medium"
				Hispanic_dec3_high 	"Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ High"
				Black_dec3_low 		"Af. American 25-75th perc. Toxic Concentration $\times$ Low"
				Black_dec3_medium 	"Af. American 25-75th perc. Toxic Concentration $\times$ Medium"
				Black_dec3_high 		"Af. American 25-75th perc. Toxic Concentration  $\times$ High"
				Minority_dec3_low 	"Minority 25-75th perc. Toxic Concentration $\times$ Low"
				Minority_dec3_medium 	"Minority 25-75th perc. Toxic Concentration $\times$ Medium"
				Minority_dec3_high 	"Minority 25-75th perc. Toxic Concentration $\times$ High"
				Hispanic_dec4_low 	"Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ Low"
				Hispanic_dec4_medium 	"Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ Medium"
				Hispanic_dec4_high 	"Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ High"
				Black_dec4_low 		"Af. American 75-100th perc. Toxic Concentration $\times$ Low"
				Black_dec4_medium 	"Af. American 75-100th perc. Toxic Concentration $\times$ Medium"
				Black_dec4_high 		"Af. American 75-100th perc. Toxic Concentration  $\times$ High"
				Minority_dec4_low 	"Minority 75-100th perc. Toxic Concentration $\times$ Low"
				Minority_dec4_medium 	"Minority 75-100th perc. Toxic Concentration $\times$ Medium"
				Minority_dec4_high 	"Minority 75-100th perc. Toxic Concentration $\times$ High") 
       starl(* 0.1 ** 0.05 *** 0.01)   
       level(90) 
       prehead(
\begin{table}[H]
\tiny \centering
\begin{threeparttable}
\captionsetup{justification=centering}
  \caption{Estimates of Discriminatory Constraint on Housing Choice \\ Heterogeneity by Maternal Education }
  
  \label{tab:heterogeneityedu}

\begin{tabular}{@{\extracolsep{5pt}}lcc}
\\[-1.8ex]\hline
\hline \\[-1.8ex]
 & \multicolumn{2}{c}{\textit{Dependent variable: {\it  Response}}} \\
 \cline{2-3}


\\[-1.8ex] & (1) & (2)  \\
\hline \\[-1.8ex] 
       )
       posthead(\hline) 
       prefoot() 
       postfoot(
\hline
\hline \\[-1.8ex]
\end{tabular}
\begin{tablenotes}[scriptsize,flushleft] \scriptsize
\item Notes:
\end{tablenotes}
\end{threeparttable}
\end{table}

       )
       replace;
#delimit cr




*end

