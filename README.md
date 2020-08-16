# Housing Discrimination and the Pollution Exposure Gap in the United States

Data and replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" by  [Christensen](https://peter-christensen-pe55.squarespace.com/christensen),  [Sarmiento-Barbieri](https://ignaciomsarmiento.github.io/) and  [Timmins](https://sites.duke.edu/christophertimmins/)

# Abstract

Local pollution exposures disproportionately impact minority households, but the root causes remain unclear. This study conducts a correspondence experiment on a major online housing platform to test whether housing discrimination constrains minority access to housing options in markets with significant sources of airborne chemical toxics.  We find that renters with African American or Hispanic/LatinX names are 41% less likely than renters with White names to receive responses for properties in low exposure locations.  We find no evidence of discriminatory constraints in high exposure locations, indicating that discrimination increases relative access to housing choices at elevated exposure risk.  



Data files

- toxic_discrimination_data.dta: experimental data set that includes information from 19 ZIP codes drawn at random from the set of high emissions markets. 
- ACS_population.dta: 2016 ACS block group data on renters 
- Potential_zips.csv: 111 ZIP codes that are above the 80th percentile of TRI stack air releases
- zipcodes.zip shapefile of US ZIP codes from the US census (must be unzipped before running files)

Code files:

The analysis is conducted using Stata-15 and R version 4.0.2 (2020-06-22) software:

Previous to running the command users should add the `disc_boot.ado` `disc_boot_logit.ado` file into their  stata local ado file locations. These ado files implement the  Kline and Santos (2012) standard errors correction.

main.sh: Produces all figures and tables in the paper and appendix. Figures and tables are saved in the "views" folder. 

Additional Notes:

-  Scripts to reproduce Figures 1 and A3 are not released. To preserve confidentiality and in compliance with IRB we don't release identifying information of  listings, e.g., Address, geolocation, etc.
-  Rscripts/aux folder includes auxiliary files for plots and generating matched sample
-  Table A5, column (5) stata prints to latex the incorrect significance stars, must be corrected "by hand"
-  Table A2 and A10, must be saved manually


 
Data dictionary

- toxic_discrimination_data:

		- choice                                                                                         =1 if response and property available
		- Minority                                                                                                              =1 if Minority
		- White                                                                                                                    =1 if White
		- Black                                                                                                         =1 if African American
		- Hispanic                                                                                                       =1 if Hispanic/LatinX
		- quartileZIP_property                                                                         Quartile Within Zip Toxic Concentration
		- dec2                                                                                       =1 if 0-25 Within Zip Toxic Concentration
		- dec3                                                                                      =1 if 25-75 Within Zip Toxic Concentration
		- dec4                                                                                     =1 if 75-100 Within Zip Toxic Concentration
		- dist                                                                                                 Distance (miles) to closest TRI
		- within1                                                                                              =1 within 1 mile to closest TRI
		- more1                                                                                             =1 more than 1 mile to closest TRI
		- race                                                                                                                   Race Identity
		- Minority_dec2                                                                   =1 if Minority x 0-25 Within Zip Toxic Concentration
		- Minority_dec3                                                                  =1 if Minority x 25-75 Within Zip Toxic Concentration
		- Minority_dec4                                                                 =1 if Minority x 75-100 Within Zip Toxic Concentration
		- Minority_within1                                                                       =1 if Minority x within 1 mile to closest TRI
		- Minority_more1                                                                           =1 if Minority x more 1 mile to closest TRI
		- Black_dec2                                                              =1 if African American x 0-25 Within Zip Toxic Concentration
		- Black_dec3                                                             =1 if African American x 25-75 Within Zip Toxic Concentration
		- Black_dec4                                                            =1 if African American x 75-100 Within Zip Toxic Concentration
		- Black_within1                                                                  =1 if African American x within 1 mile to closest TRI
		- Black_more1                                                                      =1 if African American x more 1 mile to closest TRI
		- Hispanic_dec2                                                            =1 if Hispanic/LatinX x 0-25 Within Zip Toxic Concentration
		- Hispanic_dec3                                                           =1 if Hispanic/LatinX x 25-75 Within Zip Toxic Concentration
		- Hispanic_dec4                                                          =1 if Hispanic/LatinX x 75-100 Within Zip Toxic Concentration
		- Hispanic_within1                                                                =1 if Hispanic/LatinX x within 1 mile to closest TRI
		- Hispanic_more1                                                                    =1 if Hispanic/LatinX x more 1 mile to closest TRI
		- gender                                                                                                               Gender Identity
		- education_level                                                                                      Mother Education Level Identity
		- order                                                                                                             Order Inquiry Sent
		- Address                                                                                                    Property Address (masked)
		- Zip_Code                                                                                                           ZIP Code (masked)
		- sample                                                                                                                =1 main sample
		- times_zip                                                                                          =1 times we run experiment in zip
		- sample_two_inquiries                                                               =1 subsample of homes with two round of inquiries
		- matched_sample                                                                                                     =1 matched sample
		- timestamp_inquiry_sent_out                                                                               Time stamp Inquiry Sent Out
		- timestamp_response_received                                                                              Time stamp Inquiry Received
		- person_or_computer                                                                           if response was by a person or computer
		- toxconc                                                                                                     RSEI Toxic Concentration
		- scorecancer                                                                                                        RSEI Cancer Score
		- scorenoncancer                                                                                                 RSEI Non Cancer Score
		- type                                                                                                                Type of Property
		- sqft                                                                                                                           Sqft.
		- bedroom_max                                                                                                                 Bedrooms
		- bathroom_max                                                                                                               Bathrooms
		- assault                                                                                                                      Assault
		- groceries                                                                                                                  Groceries
		- rent                                                                                                                            Rent
		- povrate                                                                                                                 Poverty Rate
		- blackshare                                                                                                 Share of African American
		- whiteshare                                                                                                           Share of Whites
		- hispanicshare                                                                                                     Share of Hispanics
		- pop                                                                                                        Population in Block Group
		- college                                                                                                    Share of College Educated
		- unemployed                                                                                                         Unemployment Rate

- ACS_population:

		- race                                                                                                                    Race Renters
		- population_renters                                                                              Population of Renters in Block Group
		- quartileZIP_property                                                                         Quartile Within Zip Toxic Concentration
		- Zip_Code                                                                                                                    ZIP Code