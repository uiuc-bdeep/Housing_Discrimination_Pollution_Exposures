#!/bin/bash


#cd "~/Dropbox/Research/Toxic_Discrimination/github/Toxic_Discrimination/"

#create a folder to store intermediate results
echo ""
echo "**********************************************************************************************************"
echo "Start Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins"
echo "**********************************************************************************************************"
mkdir ../stores/aux

echo "*" &&
# Start of files
stata-mp  -b dofiles/3_estimates_figure3.do &&
stata-mp  -b dofiles/4_estimates_figure4.do &&
stata-mp  -b dofiles/5_estimates_figure5.do &&

echo "**" &&
stata-mp  -b dofiles/6_estimates_figureA1.do &&
stata-mp  -b dofiles/7_estimates_figureA2.do &&

echo "***" &&
R CMD BATCH Rscripts/Figures.R	 &&

echo "****" &&
stata-mp  -b dofiles/9_table_A4.do &&
stata-mp  -b dofiles/10_table_A5.do &&


echo "*****" &&

rm -rf ../stores/aux &&
rm *.Rout &&
rm *.log &&
#rm *.pdf &&


echo "**********************************************************************************************************"
echo "End Replication Files"
echo "**********************************************************************************************************"
#End of Script
