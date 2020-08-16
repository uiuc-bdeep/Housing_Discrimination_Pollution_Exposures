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
drop if times_zip==.
drop if times_zip==3
keep if sample_two_inquiries>3


gen first=(times_zip==1)
gen second=(times_zip==2)


foreach depvar in first second {
	gen Hispanic_`depvar'=Hispanic*`depvar'
	gen Black_`depvar'=Black*`depvar'
	gen Minority_`depvar'=Minority*`depvar'

}



************************************************************************************************
* Minority
************************************************************************************************
 


eststo: disc_boot choice Minority_first Minority_second , varlist(i.gender i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local edu = "Yes", replace 
estadd local order = "Yes", replace 
estimates store model1


************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************
eststo: disc_boot choice Black_first Black_second  Hispanic_first Hispanic_second , varlist(i.gender i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
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
       using "../views/tableA8.tex",  
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
       varlabels(Minority_first  "Minority First Inquiry"
		Minority_second "Minority Second Inquiry"
		Black_first  "African American First Inquiry"
		Black_second "African American Second Inquiry"
		Hispanic_first "Hispanic/LatinX First Inquiry"
		Hispanic_second "Hispanic/LatinX Second Inquiry") 
       starl(* 0.1 ** 0.05 *** 0.01)   
       level(90) 
       prehead(
\begin{table}[H]
\footnotesize \centering
\begin{threeparttable}
\captionsetup{justification=centering}
  \caption{Overall Discrimination Rates \\
  Properties with Two Inquiries}
  \label{tab:probhighexposuretwoinquiries}

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




*end