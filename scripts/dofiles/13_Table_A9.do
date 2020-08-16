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
gen computer=(person_or_computer==2)
bys Address: egen computer_total=total(computer)



************************************************************************************************
* Minority
************************************************************************************************



eststo: disc_boot choice Minority_dec2 Minority_dec3 Minority_dec4 , varlist(i.gender i.education_level i.order)
estimates store modelA1

preserve
keep if computer_total==0 
eststo: disc_boot choice Minority_dec2 Minority_dec3 Minority_dec4 , varlist(i.gender i.education_level i.order)
estimates store modelA2
restore

************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************
eststo: disc_boot choice  Black_dec2  Black_dec3 Black_dec4 Hispanic_dec2  Hispanic_dec3 Hispanic_dec4  , varlist(i.gender i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local edu = "Yes", replace 
estadd local order = "Yes", replace 
estimates store modelB1

preserve
keep if computer_total==0 
eststo: disc_boot  choice Black_dec2  Black_dec3 Black_dec4 Hispanic_dec2  Hispanic_dec3 Hispanic_dec4  , varlist(i.gender i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local edu = "Yes", replace 
estadd local order = "Yes", replace 
estimates store modelB2
restore



************************************************************************************************
* Export to latex
* based on http://www.eyalfrank.com/code-riffs-stata-and-regression-tables/
************************************************************************************************



************************************************************
* estout Panel A
************************************************************

#delimit ; 
esttab modelA1 
       modelA2 
       using "../views/tableA9.tex", 
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
  \caption{Estimates of Discriminatory Constraint on Housing Choice \\ Heterogeneity by Response Origin: Human or Computer}
  \label{tab:heterogeneitycomputer}

\begin{tabular}{@{\extracolsep{5pt}}lcc}
\\[-1.8ex]\hline
\hline \\[-1.8ex]
 & \multicolumn{2}{c}{\textit{Dependent variable: {\it  Response}}} \\
 \cline{2-3}

\\[-1.8ex] & Full Sample & Human-Generated Responses  \\
\\[-1.8ex] & (1) & (2)  \\
\hline \\[-1.8ex] 
       )
       posthead({\it Panel A.: Minority } \\
       				&  &    \\) 
      prefoot() 
       postfoot(
      \hline \\[-1.8ex] )
       
       replace;
#delimit cr



************************************************************
* estout Panel B
************************************************************

#delimit ; 
esttab modelB1 
       modelB2 
       using "../views/tableA9.tex", 
       style(tex) 
       eform
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
				Hispanic_dec4 "Hispanic/LatinX 75-100th perc. Toxic Concentration") 
       starl(* 0.1 ** 0.05 *** 0.01) 
       stats(responsewhite
             gender 
             edu 
             order
             N
             listings
             diff_response, fmt(2 0 0 0 %9.0gc %9.0gc 2)
             labels(" Mean Response (White)"
                   "\hline Gender" 
                   "Education Level" 
                   "Inquiry Order"
                   "\hline Observations"
                   "Listings"
                   "\% w. diff. response"
                   )) 
       level(90)     
         prehead( 
       )
       posthead({\it Panel B: By Race }\\
					 &  &     \\) 
      prefoot() 
       postfoot(           
\hline
\hline \\[-1.8ex]
\end{tabular}
\begin{tablenotes}[scriptsize,flushleft] \scriptsize
\item Notes:  Notes: Table reports odds ratios from a within-property conditional logit regression for the full sample and excluding computer-generated responses. Column (1) reports results for the full sample. Column (2) excludes 362 listings that responded with computer-automated responses.  Panel A shows odds ratio of minority names relative to White names. Panel B separates minority names into African American and Hispanic/LatinX names.   Standard errors clustered at Zip Code level. 90\% Confidence Intervals reported in parentheses.*\$P< 10\%$ level, **\$P < 5\%$ level, ***\$P<1\%$ level.
\end{tablenotes} 
\end{threeparttable}
\end{table})
       append;
#delimit cr



*end 


*end