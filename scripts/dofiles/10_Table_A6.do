/*********************************************************************************************************
Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins
*********************************************************************************************************/
*Note: LPM stars need to be corrected by hand, estout prints starts of a test against the null of zero
* the test againste the null of one has to be manually coded

clear all
set matsize 11000

use "../stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4

set seed 1010101

eststo clear

************************************************************************************************
* Toxic Concentration
************************************************************************************************
************************************************************************************************
* Minority
************************************************************************************************
*Note: same results if run the reghdfe for each bin


eststo modelA11: disc_boot choice Minority_dec2 Minority_dec3 Minority_dec4
estimates store modelA11
eststo modelA12: disc_boot choice Minority_dec2 Minority_dec3 Minority_dec4 , varlist(i.gender)
estimates store modelA12
eststo modelA13: disc_boot choice Minority_dec2 Minority_dec3 Minority_dec4 , varlist(i.gender i.education_level)
estimates store modelA13
eststo modelA14: disc_boot choice Minority_dec2 Minority_dec3 Minority_dec4 , varlist(i.gender i.education_level i.order)
estimates store modelA14

reghdfe choice  Minority_dec2 Minority_dec3 Minority_dec4, absorb(gender education_level order  Address ) cl(Zip_Code) level(90)  keepsing



eststo modelA15: nlcom  ( Minority_dec2: ((_b[_cons]+_b[Minority_dec2])/(1-(_b[_cons]+_b[Minority_dec2])))/(_b[_cons]/(1-_b[_cons]))) ///
                        ( Minority_dec3: ((_b[_cons]+_b[Minority_dec3])/(1-(_b[_cons]+_b[Minority_dec3])))/(_b[_cons]/(1-_b[_cons]))) ///           
                        ( Minority_dec4: ((_b[_cons]+_b[Minority_dec4])/(1-(_b[_cons]+_b[Minority_dec4])))/(_b[_cons]/(1-_b[_cons]))) ///
                        , level(90) post

****************************************************************************
*These have to be added by hand
forvalues i=2/4{
       test _b[Minority_dec`i'] == 1
}
****************************************************************************

/* Also works, same result
sum choice if dec2==1 & White==1 
loc mean_2=r(mean)
sum choice if dec3==1 & White==1 
loc mean_3=r(mean)
sum choice if dec4==1 & White==1 
loc mean_4=r(mean)

nlcom  ( Minority_dec2: ((`mean_2'+_b[Minority_dec2])/(1-(`mean_2'+_b[Minority_dec2])))/(`mean_2'/(1-`mean_2'))) ///
       ( Minority_dec3: ((`mean_3'+_b[Minority_dec3])/(1-(`mean_3'+_b[Minority_dec3])))/(`mean_3'/(1-`mean_3'))) ///
       ( Minority_dec4: ((`mean_4'+_b[Minority_dec4])/(1-(`mean_4'+_b[Minority_dec4])))/(`mean_4'/(1-`mean_4'))) , level(90) post

                        
*these have to be added by hand
forvalues i=2/4{
       test _b[Minority_dec`i'] == 1
}

*/
************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************
eststo: disc_boot choice Black_dec2 Black_dec3 Black_dec4 Hispanic_dec2 Hispanic_dec3 Hispanic_dec4 
estimates store modelA21
eststo: disc_boot choice Black_dec2 Black_dec3 Black_dec4 Hispanic_dec2 Hispanic_dec3 Hispanic_dec4, varlist(i.gender)
estimates store modelA22
eststo: disc_boot choice Black_dec2 Black_dec3 Black_dec4 Hispanic_dec2 Hispanic_dec3 Hispanic_dec4, varlist(i.gender i.education_level)
estimates store modelA23
eststo: disc_boot choice Black_dec2 Black_dec3 Black_dec4 Hispanic_dec2 Hispanic_dec3 Hispanic_dec4, varlist(i.gender i.education_level i.order)
estimates store modelA24
reghdfe choice Black_dec2 Black_dec3 Black_dec4 Hispanic_dec2 Hispanic_dec3 Hispanic_dec4, absorb(gender education_level order  Address ) cl(Zip_Code) level(90)  keepsing
eststo modelA25: nlcom  ( Black_dec2: ((_b[_cons]+_b[Black_dec2])/(1-(_b[_cons]+_b[Black_dec2])))/(_b[_cons]/(1-_b[_cons]))) ///
                        ( Black_dec3: ((_b[_cons]+_b[Black_dec3])/(1-(_b[_cons]+_b[Black_dec3])))/(_b[_cons]/(1-_b[_cons]))) ///           
                        ( Black_dec4: ((_b[_cons]+_b[Black_dec4])/(1-(_b[_cons]+_b[Black_dec4])))/(_b[_cons]/(1-_b[_cons]))) ///
                        ( Hispanic_dec2: ((_b[_cons]+_b[Hispanic_dec2])/(1-(_b[_cons]+_b[Hispanic_dec2])))/(_b[_cons]/(1-_b[_cons]))) ///
                        ( Hispanic_dec3: ((_b[_cons]+_b[Hispanic_dec3])/(1-(_b[_cons]+_b[Hispanic_dec3])))/(_b[_cons]/(1-_b[_cons]))) ///           
                        ( Hispanic_dec4: ((_b[_cons]+_b[Hispanic_dec4])/(1-(_b[_cons]+_b[Hispanic_dec4])))/(_b[_cons]/(1-_b[_cons]))) ///
                        , level(90) post


*these have to be added by hand
foreach k in Black Hispanic{
      forvalues i=2/4{
             test _b[`k'_dec`i'] == 1
      }
}
************************************************************************************************
* Toxic Concentration
************************************************************************************************
************************************************************************************************
* Distance
************************************************************************************************
eststo: disc_boot choice Minority_within1  Minority_more1
estimates store modelB11
eststo: disc_boot choice Minority_within1  Minority_more1 , varlist(i.gender)
estimates store modelB12
eststo: disc_boot choice Minority_within1  Minority_more1 , varlist(i.gender i.education_level)
estimates store modelB13
eststo: disc_boot choice Minority_within1  Minority_more1 , varlist(i.gender i.education_level i.order)
estimates store modelB14
reghdfe choice Minority_within1  Minority_more1, absorb(gender education_level order  Address ) cl(Zip_Code) level(90)  keepsing
eststo modelB15: nlcom  ( Minority_within1: ((_b[_cons]+_b[Minority_within1])/(1-(_b[_cons]+_b[Minority_within1])))/(_b[_cons]/(1-_b[_cons]))) ///
                        ( Minority_more1: ((_b[_cons]+_b[Minority_more1])/(1-(_b[_cons]+_b[Minority_more1])))/(_b[_cons]/(1-_b[_cons]))) ///
                        , level(90) post

*these have to be added by hand
foreach i in within1 more1{
       test _b[Minority_`i'] == 1
}

************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************
  

eststo: disc_boot choice Black_within1  Black_more1 Hispanic_within1  Hispanic_more1
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "", replace 
estadd local edu = "", replace 
estadd local order = "", replace 
estimates store modelB21
eststo: disc_boot choice Black_within1  Black_more1 Hispanic_within1  Hispanic_more1 , varlist(i.gender)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local edu = "", replace 
estadd local order = "", replace 
estimates store modelB22
eststo: disc_boot choice Black_within1  Black_more1 Hispanic_within1  Hispanic_more1 , varlist(i.gender i.education_level)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local edu = "Yes", replace 
estadd local order = "", replace 
estimates store modelB23
eststo: disc_boot choice Black_within1  Black_more1 Hispanic_within1  Hispanic_more1 , varlist(i.gender i.education_level i.order)
sum choice if White==1 
estadd scalar responsewhite = r(mean), replace 
estadd local gender = "Yes", replace 
estadd local edu = "Yes", replace 
estadd local order = "Yes", replace 
estimates store modelB24
loc d_resp `e(diff_response)'
di `d_resp' 
reghdfe choice Black_within1  Black_more1 Hispanic_within1  Hispanic_more1, absorb(gender education_level order  Address ) cl(Zip_Code) level(90)  keepsing
eststo modelB25: nlcom  ( Black_within1: ((_b[_cons]+_b[Black_within1])/(1-(_b[_cons]+_b[Black_within1])))/(_b[_cons]/(1-_b[_cons]))) ///
                        ( Black_more1: ((_b[_cons]+_b[Black_more1])/(1-(_b[_cons]+_b[Black_more1])))/(_b[_cons]/(1-_b[_cons]))) ///
                        ( Hispanic_within1: ((_b[_cons]+_b[Hispanic_within1])/(1-(_b[_cons]+_b[Hispanic_within1])))/(_b[_cons]/(1-_b[_cons]))) ///
                        ( Hispanic_more1: ((_b[_cons]+_b[Hispanic_more1])/(1-(_b[_cons]+_b[Hispanic_more1])))/(_b[_cons]/(1-_b[_cons]))) ///
                        , level(90) post

eststo modelB25: estadd scalar listings =  `e(N)'/3
eststo modelB25: estadd scalar diff_response= `d_resp'
sum choice if White==1 
eststo modelB25: estadd scalar responsewhite = r(mean), replace 
eststo modelB25: estadd local gender = "Yes", replace 
eststo modelB25: estadd local edu = "Yes", replace 
eststo modelB25: estadd local order = "Yes", replace 
*estimates store modelB25

foreach k in Black Hispanic{
      foreach i in within1 more1{
             test _b[`k'_`i'] == 1
      }
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
       modelA14
       modelA15
       using "../views/tableA6.tex", 
       style(tex) 
       eform(1 1 1 1 0)
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  )  
       label 
       noobs
       mlabels(,none)  
       nonumbers 
       collabels(,none) 
       eqlabels(,none)
       varlabels(Minority_dec2 "Minority 0-25th perc. Tox. Conc." 
				 Minority_dec3 "Minority 25-75th perc. Tox. Conc."  
				 Minority_dec4 "Minority 75-100th perc. Tox. Conc." ) 
       starl(* 0.1 ** 0.05 *** 0.01)   
       level(90)     
       prehead( 	
\begin{table}[H]
\tiny \centering
\begin{threeparttable}
\captionsetup{justification=centering}
  \caption{Estimates of Discriminatory Constraint on Housing Choice: \\ Robustness to Controls and Estimation Strategy}
  	\label{tab:02mainresults}
\begin{tabular}{@{\extracolsep{5pt}}lccccc}
\\[-1.8ex]\hline
\hline \\[-1.8ex]
 & \multicolumn{5}{c}{\textit{Dependent variable: {\it Response}}} \\
 \cline{2-6} \\
& \multicolumn{4}{c}{\textit{Conditional }} & {\it Linear} \\  
& \multicolumn{4}{c}{\textit{ Logit}} & {\it Probability}\\
& \multicolumn{4}{c}{\textit{ }}  & {\it Model}\\
\cline{2-5} \\ \\[-1.8ex] 
& (1) & (2) & (3) & (4)  & (5) \\ 
\\[-1.8ex] 
\hline \\[-1.8ex]
 {\it Panel A: Quartiles of RSEI Tox. Conc.}\\
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
       modelA24
       modelA25
       using "../views/tableA6.tex", 
       style(tex)
       eform(1 1 1 1 0) 
       level(90)
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  )  
       label 
       noobs
       mlabels(,none)
       nonumbers 
       collabels(,none)      
       eqlabels(,none)
       varlabels(Black_dec2 "Af. American 0-25th perc. Tox. Conc." 
				 Black_dec3 "Af. American 25-75th perc. Tox. Conc." 
				 Black_dec4 "Af. American 75-100th perc. Tox. Conc."
				 Hispanic_dec2 "Hispanic/LatinX 0-25th perc. Tox. Conc." 
				 Hispanic_dec3 "Hispanic/LatinX 25-75th perc. Tox. Conc." 
				 Hispanic_dec4 "Hispanic/LatinX 75-100th perc. Tox. Conc." ) 
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
       modelB14
       modelB15
       using "../views/tableA6.tex", 
       style(tex)
       eform(1 1 1 1 0) 
       level(90)
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  )  
       label 
       noobs
       mlabels(,none)
       nonumbers 
       collabels(,none)      
       eqlabels(,none)
       varlabels(Minority_within1 "TRI less than 1 mile $\times$ Minority"
				 Minority_more1 "TRI more than 1 mile $\times$  Minority") 
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
       modelB24
       modelB25
       using "../views/tableA6.tex", 
       style(tex) 
       eform(1 1 1 1 0)
       cells(b(star fmt(4)) ci(par fmt(4) par(( , )))  )  
       label 
       noobs
       mlabels(,none)  
       nonumbers
       collabels(,none) 
       eqlabels(,none)
       varlabels(Hispanic_within1 "TRI less than 1 mile $\times$ Hispanic/LatinX"
				 Hispanic_more1 "TRI more than 1 mile $\times$  Hispanic/LatinX"
				 Black_within1 "TRI less than 1 mile $\times$ African American"
				 Black_more1 "TRI more than 1 mile $\times$  African American") 
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
