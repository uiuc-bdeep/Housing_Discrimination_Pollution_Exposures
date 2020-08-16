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

gen male=(gender==2)
gen female=(gender==1)




forvalues i = 2/`quartiles'{
	foreach genero in male female {
		gen Hispanic_dec`i'_`genero'=Hispanic*dec`i'*`genero'
		gen Black_dec`i'_`genero'=Black*dec`i'*`genero'
		gen Minority_dec`i'_`genero'=Minority*dec`i'*`genero'
	}

	

}







************************************************************************************************
* Minority
************************************************************************************************





eststo: disc_boot choice Minority_dec2_female Minority_dec3_female Minority_dec4_female ///
			  Minority_dec2_male   Minority_dec3_male Minority_dec4_male ///
			 , varlist(i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local edu = "Yes", replace 
estadd local order = "Yes", replace 
estimates store model1






************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

eststo: disc_boot choice Black_dec2_female Black_dec3_female  Black_dec4_female ///
			  Black_dec2_male Black_dec3_male Black_dec4_male ///
			  Hispanic_dec2_female Hispanic_dec3_female Hispanic_dec4_female ///
			  Hispanic_dec2_male Hispanic_dec3_male Hispanic_dec4_male ///
			 , varlist(i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local edu = "Yes", replace 
estadd local order = "Yes", replace 
estimates store model2





************************************************************************************************
* Export to latex
* based on http://www.eyalfrank.com/code-riffs-stata-and-regression-tables/
************************************************************************************************



#delimit ; 
esttab model1
	  model2
       using "../views/tableA12.tex",  
       style(tex) 
       eform
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  ) 
       label 
       stats(responsewhite 
             edu 
             order
             N
             listings
             diff_response, fmt(2 0 0 %9.0gc %9.0gc 2)
             labels(" Mean Response (White)"
             		"\hline Education Level" 
                   "Inquiry Order"
                   "\hline Observations"
                   "Listings"
                   "\% w. diff. response"
                   )) 
       mlabels( ,none)  
       nonumbers
       collabels(,none) 
       eqlabels(,none)
       varlabels(Minority_dec2_female "Minority 0-25th perc. Toxic Concentration $\times$ Female"
				Minority_dec2_male 	"Minority 0-25th perc. Toxic Concentration $\times$ Male"
				Minority_dec3_female "Minority 25-75th perc. Toxic Concentration $\times$ Female"
				Minority_dec3_male 	"Minority 25-75th perc. Toxic Concentration $\times$ Male"
				Minority_dec4_female "Minority 75-100th perc. Toxic Concentration $\times$ Female"
				Minority_dec4_male 	"Minority 75-100th perc. Toxic Concentration $\times$ Male"
				Black_dec2_female "Af. American 0-25th perc. Toxic Concentration $\times$ Female"
				Black_dec2_male "Af. American 0-25th perc. Toxic Concentration $\times$ Male"
				Black_dec3_female "Af. American 25-75th perc. Toxic Concentration $\times$ Female"
				Black_dec3_male "Af. American 25-75th perc. Toxic Concentration $\times$ Male"
				Black_dec4_female "Af. American 75-100th perc. Toxic Concentration $\times$ Female"
				Black_dec4_male "Af. American 75-100th perc. Toxic Concentration $\times$ Male"
				Hispanic_dec2_female "Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ Female"
				Hispanic_dec2_male "Hispanic/LatinX 0-25th perc. Toxic Concentration $\times$ Male"
				Hispanic_dec3_female "Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ Female"
				Hispanic_dec3_male "Hispanic/LatinX 25-75th perc. Toxic Concentration $\times$ Male"
				Hispanic_dec4_female "Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ Female"
				Hispanic_dec4_male "Hispanic/LatinX 75-100th perc. Toxic Concentration $\times$ Male"
) 
       starl(* 0.1 ** 0.05 *** 0.01)   
       level(90) 
       prehead(
\begin{table}[H]
\scriptsize \centering
\begin{threeparttable}
\captionsetup{justification=centering}
  \caption{Estimates of Discriminatory Constraint on Housing Choice \\ Heterogeneity by Gender }
  \label{tab:heterogeneitygender}

\begin{tabular}{@{\extracolsep{5pt}}lcc}
\\[-1.8ex]\hline
\hline \\[-1.8ex]
 & \multicolumn{2}{c}{\textit{Dependent variable: {\it  Response}}} \\
 \cline{2-3}
 \\[-1.8ex] & (1) & (2)  \\
       )
       posthead(\hline) 
       prefoot() 
       postfoot(
\hline
\hline \\[-1.8ex]
\end{tabular}
\begin{tablenotes}[scriptsize,flushleft] \scriptsize
\item Notes: Table reports odds ratios from a within-property conditional logit by percentile of within-zip toxic concentration and applicant gender. Column (1) reports odds ratios for minority names relative to White names. Column (2) separates minority names into African American and Hispanic/LatinX names. Standard errors clustered at Zip Code level. 90\% Confidence Intervals reported in parentheses.*\$P< 10\%$ level, **\$P < 5\%$ level, ***\$P<1\%$ level.

\end{tablenotes}
\end{threeparttable}
\end{table}
       )
       replace;
#delimit cr




*end


*end

