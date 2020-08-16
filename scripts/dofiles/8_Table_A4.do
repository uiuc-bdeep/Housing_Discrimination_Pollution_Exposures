/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "../stores/toxic_discrimination_data.dta"


keep if sample==1

set seed 1010101

************************************************************************************************
* Overall Discrimination Rates
************************************************************************************************


************************************************************************************************
* Minority
************************************************************************************************



eststo: disc_boot choice Minority , varlist(i.gender i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local edu = "Yes", replace 
estadd local order = "Yes", replace 
estimates store model1


************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************
eststo: disc_boot choice Black  Hispanic , varlist(i.gender i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local edu = "Yes", replace 
estadd local order = "Yes", replace 
estimates store model2


************************************************************************************************
* Export to latex
* based on http://www.eyalfrank.com/code-riffs-stata-and-regression-tables/
***********************************************************************************************


#delimit ; 
esttab model1
	  model2
       using "../views/tableA4.tex",  
       style(tex) 
       eform
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  ) 
       label 
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
       mlabels( ,none)  
       nonumbers
       collabels(,none) 
       eqlabels(,none)
       varlabels(Minority  "Minority"
				Black  "African American"
				Hispanic "Hispanic/LatinX")
       starl(* 0.1 ** 0.05 *** 0.01)   
       level(90) 
       prehead( 

\begin{table}[H]
\footnotesize \centering
\begin{threeparttable}
\captionsetup{justification=centering}
  \caption{Overall Discrimination Rates }
  \label{tab:probhighexposure}

\begin{tabular}{@{\extracolsep{5pt}} lcc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
& \multicolumn{2}{c}{\it Dependent variable:} \\
& \multicolumn{2}{c}{\it  Response} \\
\cline{2-3}\\ [-1.8ex]

&(1)              & (2)                   \\
       )
       posthead(\hline) 
       prefoot() 
       postfoot(


\\[-1.8ex]\hline 
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
