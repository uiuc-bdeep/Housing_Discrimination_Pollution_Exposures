#!/bin/bash


#cd "~/Dropbox/Research/Toxic_Discrimination/github/Toxic_Discrimination/"

#create a folder to store intermediate results
echo ""
echo "**********************************************************************************************************"
echo "Start Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins"
echo "**********************************************************************************************************"
mkdir ../stores/aux
mkdir logs

# Main Figures 
echo "*" &&



stata-mp  -b dofiles/1_estimates_figure2.do   &&
stata-mp  -b dofiles/2_estimates_figure3.do   &&
stata-mp  -b dofiles/3_estimates_figure4.do   &&
stata-mp  -b dofiles/4_estimates_figure5.do   &&

echo "**" &&
R CMD BATCH Rscripts/1_Figure_1a.R 			  &&
R CMD BATCH Rscripts/2_Figure_2.R             &&

R CMD BATCH Rscripts/3_Figures_Odds.R	      &&



echo "***" &&
stata-mp  -b dofiles/5_estimates_figureA1.do    &&
stata-mp  -b dofiles/6_estimates_figureA2.do    &&

R CMD BATCH Rscripts/4_Figures_Odds_App.R	    &&


echo "****" &&
stata-mp  -b dofiles/7_Table_A2.do              &&
stata-mp  -b dofiles/8_Table_A4.do              &&
stata-mp  -b dofiles/9_table_A5.do              && 
stata-mp  -b dofiles/10_Table_A6.do             &&
stata-mp  -b dofiles/11_Table_A7.do             &&
stata-mp  -b dofiles/12_Table_A8.do             &&
stata-mp  -b dofiles/13_Table_A9.do             &&
stata-mp  -b dofiles/14_Table_A10.do            &&
stata-mp  -b dofiles/15_Table_A11.do            &&
stata-mp  -b dofiles/16_Table_A12.do            &&

echo "*****" &&
R CMD BATCH Rscripts/5_TableA2.R     		  	&&
R CMD BATCH Rscripts/6_Figure_A4.R     		  	&&
R CMD BATCH Rscripts/7_Figure_A5.R     		  	&&
R CMD BATCH Rscripts/8_TableA10.R      		  	&&

echo "******" &&
rm -rf ../stores/aux &&

#Move all log files to a single folder
mv *.log logs/
mv *.Rout logs/
#delete pdf
rm *.pdf &&


echo "**********************************************************************************************************"
echo "End Replication Files"
echo "**********************************************************************************************************"
#End of Script
