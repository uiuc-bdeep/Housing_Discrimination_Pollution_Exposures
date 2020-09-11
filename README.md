# Housing Discrimination and the Pollution Exposure Gap in the United States

Data and replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" by  [Christensen](https://www.uiuc-bdeep.org/christensen),  [Sarmiento-Barbieri](https://ignaciomsarmiento.github.io/) and  [Timmins](https://sites.duke.edu/christophertimmins/)

# Abstract

Local pollution exposures disproportionately impact minority households, but the root causes remain unclear. This study conducts a correspondence experiment on a major online housing platform to test whether housing discrimination constrains minority access to housing options in markets with significant sources of airborne chemical toxics.  We find that renters with African American or Hispanic/LatinX names are 41% less likely than renters with White names to receive responses for properties in low exposure locations.  We find no evidence of discriminatory constraints in high exposure locations, indicating that discrimination increases relative access to housing choices at elevated exposure risk.  



## Data files

- toxic_discrimination_data.dta: experimental data set that includes information from 19 ZIP codes drawn at random from the set of high emissions markets. Listing location was then matched to EPA 810m grid with the 2016 aggregated microdata to obtain RSEI Toxic Concentration, RSEI Cancer Score, and RSEI Non Cancer Score. RSEI data are publicly available from the EPA's ftp server at [ftp://newftp.epa.gov/RSEI/](ftp://newftp.epa.gov/RSEI/). Rent, Poverty Rate, Share of African American, Share of Whites, Share of Hispanics, Population in Block Group, Share of College Educated, Unemployment Rate come from the 2016 ACS block group data available from the US Census.
- ACS_population.dta: 2016 ACS block group data on renters 
- Potential_zips.csv: 111 ZIP codes that are above the 80th percentile of TRI stack air releases. This was calculated using 2016 TRI data available from [https://www.epa.gov/toxics-release-inventory-tri-program/tri-basic-data-files-calendar-years-1987-2018](https://www.epa.gov/toxics-release-inventory-tri-program/tri-basic-data-files-calendar-years-1987-2018)
- zipcodes.tar.gz shapefile of US ZIP codes from the US Census. 

## Code files:

- The analysis is conducted using Stata-15 version 15.1 and R version 4.0.2 (2020-06-22) software

- All the code was run on a MacBookPro 2020 running macOS Catalina Version 10.15.6

- Previous to running the command users should add the  files`disc_boot.ado` `disc_boot_logit.ado` files located in the ado folder into their  stata local ado file location. These ado files implement the  Kline and Santos (2012) standard errors correction.
 
- main.sh: Contains the sequence of execution of dofiles and Rscripts to produce the figures and tables in the paper and appendix. Dofiles and Rscripts are named according to the function they perform
	- The folder dofiles contains the dofiles called by main.sh:
		- 1_estimates_figure2.do
		- 2_estimates_figure3.do
		- 3_estimates_figure3.do
		- 3_estimates_figure4.do
		- 4_estimates_figure5.do
		- 5_estimates_figure5.do
		- 5_estimates_figureA1.do
		- 6_estimates_figureA2.do
		- 7_Table_A2.do
		- 8_Table_A4.do
		- 9_table_A5.do
		- 10_Table_A6.do
		- 11_Table_A7.do
		- 12_Table_A8.do
		- 13_Table_A9.do
		- 14_Table_A10.do
		- 15_Table_A11.do
		- 16_Table_A12.do
	- The folder Rscripts contains the Rscripts called by main.sh:
		- 1_Figure_1a.R
		- 2_Figure_2.R
		- 3_Figures_Odds.R
		- 4_Figures_Odds_App.R
		- 4_Figures_Odds_Appendix.R
		- 5_TableA2.R
		- 6_Figure_A4.R
		- 7_Figure_A5.R
		- 8_TableA10.R
		- aux folder includes auxiliary files for plots and generating matched sample
			- gen_matched_sample.R
			- plot_fct_tox_conc_n_distance.R
	- main.sh creates:
		- temporary auxiliary data frames that are saved in stores/aux and deleted at the end of the script
		- a folder called logs is created and contains log files: .log for stata  and .Rout for R


Figures and tables are saved in the "views" folder. 


Additional Notes:

-  Scripts to reproduce Figures 1 and A3 are not released. To preserve confidentiality and in compliance with IRB we don't release identifying information of  listings, e.g., Address, geolocation, etc.
-  Table A5, column (5) stata prints to latex the incorrect significance stars, must be corrected "by hand"
-  Table A2 rows of share of listings must be manually added from stata otuput
-  Table A10 is printed in 2 parts: tableA10_a.tex, percentile results, and tableA10_b.tex, distance results.


 
## Data dictionary

- toxic_discrimination_data:

	- choice                                                =1 if response and property available
	- Minority                                                                     =1 if Minority
	- White                                                                           =1 if White
	- Black                                                                =1 if African American
	- Hispanic                                                              =1 if Hispanic/LatinX
	- quartileZIP_property                                Quartile Within Zip Toxic Concentration
	- dec2                                              =1 if 0-25 Within Zip Toxic Concentration
	- dec3                                             =1 if 25-75 Within Zip Toxic Concentration
	- dec4                                            =1 if 75-100 Within Zip Toxic Concentration
	- dist                                                        Distance (miles) to closest TRI
	- within1                                                     =1 within 1 mile to closest TRI
	- more1                                                    =1 more than 1 mile to closest TRI
	- race                                                                          Race Identity
	- Minority_dec2                          =1 if Minority x 0-25 Within Zip Toxic Concentration
	- Minority_dec3                         =1 if Minority x 25-75 Within Zip Toxic Concentration
	- Minority_dec4                        =1 if Minority x 75-100 Within Zip Toxic Concentration
	- Minority_within1                              =1 if Minority x within 1 mile to closest TRI
	- Minority_more1                                  =1 if Minority x more 1 mile to closest TRI
	- Black_dec2                     =1 if African American x 0-25 Within Zip Toxic Concentration
	- Black_dec3                    =1 if African American x 25-75 Within Zip Toxic Concentration
	- Black_dec4                   =1 if African American x 75-100 Within Zip Toxic Concentration
	- Black_within1                         =1 if African American x within 1 mile to closest TRI
	- Black_more1                             =1 if African American x more 1 mile to closest TRI
	- Hispanic_dec2                   =1 if Hispanic/LatinX x 0-25 Within Zip Toxic Concentration
	- Hispanic_dec3                  =1 if Hispanic/LatinX x 25-75 Within Zip Toxic Concentration
	- Hispanic_dec4                 =1 if Hispanic/LatinX x 75-100 Within Zip Toxic Concentration
	- Hispanic_within1                       =1 if Hispanic/LatinX x within 1 mile to closest TRI
	- Hispanic_more1                           =1 if Hispanic/LatinX x more 1 mile to closest TRI
	- gender                                                                      Gender Identity
	- education_level                                             Mother Education Level Identity
	- order                                                                    Order Inquiry Sent
	- inquiry_weekday 										 Day of the week inquiry was sent out
	- Address                                                           Property Address (masked)
	- Zip_Code                                                                  ZIP Code (masked)
	- sample                                                                       =1 main sample
	- times_zip                                                 =1 times we run experiment in zip
	- sample_two_inquiries                      =1 subsample of homes with two round of inquiries
	- matched_sample                                                            =1 matched sample
	- timestamp_inquiry_sent_out                                      Time stamp Inquiry Sent Out
	- timestamp_response_received                                     Time stamp Inquiry Received
	- person_or_computer                                  if response was by a person or computer
	- toxconc                                                            RSEI Toxic Concentration
	- scorecancer                                                               RSEI Cancer Score
	- scorenoncancer                                                        RSEI Non Cancer Score
	- type                                                                       Type of Property
	- sqft                                                                                  Sqft.
	- bedroom_max                                                                        Bedrooms
	- bathroom_max                                                                      Bathrooms
	- assault                                                                             Assault
	- groceries                                                                         Groceries
	- rent                                                                                   Rent
	- povrate                                                                        Poverty Rate
	- blackshare                                                        Share of African American
	- whiteshare                                                                  Share of Whites
	- hispanicshare                                                            Share of Hispanics
	- pop                                                               Population in Block Group
	- college                                                           Share of College Educated
	- unemployed                                                                Unemployment Rate

- ACS_population:

	- race                                                                           Race Renters
	- population_renters                                     Population of Renters in Block Group
	- quartileZIP_property                                Quartile Within Zip Toxic Concentration
	- Zip_Code                                                                           ZIP Code

