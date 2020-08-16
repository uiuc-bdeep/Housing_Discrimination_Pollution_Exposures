/*
Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
*/


clear all
set matsize 11000

use "../stores/toxic_discrimination_data.dta"


keep if sample==1

loc quartiles 4


set seed 1010101

************************************************************************************************
* Minority
************************************************************************************************



clogit choice Minority_dec2 Minority_dec3 Minority_dec4 i.gender i.education_level i.order, group(Address)
predict phat, pu0

sum phat if Minority==1 & dec2==1
loc p12 `r(mean)'
sum phat if Minority==0 & dec2==1
loc p02 `r(mean)'

di "Relative Risk P(Minority=1|Dec=2]/P(Minority=0|Dec=2] " `p12'/`p02' 


sum phat if Minority==1 & dec3==1
loc p13 `r(mean)'
sum phat if Minority==0 & dec3==1
loc p03 `r(mean)'

di `p13'/`p03'
di "Relative Risk P(Minority=1|Dec=3]/P(Minority=0|Dec=3] " `p13'/`p03'

sum phat if Minority==1 & dec4==1
loc p14 `r(mean)'
sum phat if Minority==0 & dec4==1
loc p04 `r(mean)'

di `p14'/`p04'
di "Relative Risk P(Minority=1|Dec=4]/P(Minority=0|Dec=4] " `p14'/`p04'
*collapse (mean) phat (count) choice, by(Minority dec2 dec3 dec4)


mat def M=J(3,1,.)
mat rownames M = minority minority minority
mat M[1,1]=`p12'/`p02' 
mat M[2,1]=`p13'/`p03'
mat M[3,1]=`p14'/`p04'


************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

clogit choice  Hispanic_dec2  Hispanic_dec3 Hispanic_dec4 ///
	 				Black_dec2  Black_dec3 Black_dec4 i.gender i.education_level i.order, group(Address)
predict phat_h_b, pu0

sum phat_h_b if Hispanic==1 & dec2==1 & Black==0
loc p12_h `r(mean)'
sum phat_h_b if Hispanic==0 & dec2==1 & Black==0
loc p02_h `r(mean)'

di "Relative Risk P(Hispanic=1|Dec=2]/P(Hispanic=0|Dec=2] " `p12_h'/`p02_h' 


sum phat_h_b if Hispanic==1 & dec3==1 & Black==0
loc p13_h `r(mean)'
sum phat_h_b if Hispanic==0 & dec3==1 & Black==0
loc p03_h `r(mean)'

di `p13_h'/`p03_h'
di "Relative Risk P(Hispanic=1|Dec=3]/P(Hispanic=0|Dec=3] " `p13_h'/`p03_h'

sum phat_h_b if Hispanic==1 & dec4==1 & Black==0
loc p14_h `r(mean)'
sum phat_h_b if Hispanic==0 & dec4==1 & Black==0
loc p04_h `r(mean)'

di `p14_h'/`p04_h'
di "Relative Risk P(Hispanic=1|Dec=4]/P(Hispanic=0|Dec=4] " `p14_h'/`p04_h'


mat def H=J(3,1,.)
mat rownames H = hispanic hispanic hispanic
mat H[1,1]=`p12_h'/`p02_h' 
mat H[2,1]=`p13_h'/`p03_h'
mat H[3,1]=`p14_h'/`p04_h'



*Af American

sum phat_h_b if Black==1 & dec2==1 & Hispanic==0
loc p12_b `r(mean)'
sum phat_h_b if Black==0 & dec2==1 & Hispanic==0
loc p02_b `r(mean)'

di "Relative Risk P(Hispanic=1|Dec=2]/P(Hispanic=0|Dec=2] " `p12_b'/`p02_b' 


sum phat_h_b if Black==1 & dec3==1 & Hispanic==0
loc p13_b `r(mean)'
sum phat_h_b if Black==0 & dec3==1 & Hispanic==0
loc p03_b `r(mean)'

di `p13_b'/`p03_b'
di "Relative Risk P(Hispanic=1|Dec=3]/P(Hispanic=0|Dec=3] " `p13_b'/`p03_b'

sum phat_h_b if Black==1 & dec4==1 & Hispanic==0
loc p14_b `r(mean)'
sum phat_h_b if Black==0 & dec4==1 & Hispanic==0
loc p04_b `r(mean)'

di `p14_b'/`p04_b'
di "Relative Risk P(Hispanic=1|Dec=4]/P(Hispanic=0|Dec=4] " `p14_b'/`p04_b'


mat def A=J(3,1,.)
mat rownames A = black black black
mat A[1,1]=`p12_b'/`p02_b' 
mat A[2,1]=`p13_b'/`p03_b'
mat A[3,1]=`p14_b'/`p04_b'


*Export

mat def Res=M\A\H
mat list Res

preserve
clear
svmat2 Res,  names(col)  rnames(race)
gen n=_n

save "../stores/aux/rel_risk_quartile.dta"  , replace
restore


************************************************************************************************
************************************************************************************************
* Distance Minority_within1  Minority_more1
************************************************************************************************
************************************************************************************************


drop phat phat_h_b
clogit choice Minority_within1  Minority_more1 i.gender i.education_level i.order, group(Address)
predict phat, pu0

sum phat if Minority==1 & within1==1
loc p12 `r(mean)'
sum phat if Minority==0 & within1==1
loc p02 `r(mean)'



sum phat if Minority==1 & more1==1
loc p13 `r(mean)'
sum phat if Minority==0 & more1==1
loc p03 `r(mean)'


mat def M=J(2,1,.)
mat rownames M = minority minority 
mat M[1,1]=`p12'/`p02' 
mat M[2,1]=`p13'/`p03'



************************************************************************************************
* African American vs Hispanic/LatinX
************************************************************************************************

clogit choice  Hispanic_within1  Hispanic_more1  ///
	 				Black_within1  Black_more1  i.gender i.education_level i.order, group(Address)
predict phat_h_b, pu0

sum phat_h_b if Hispanic==1 & within1==1 & Black==0
loc p12_h `r(mean)'
sum phat_h_b if Hispanic==0 & within1==1 & Black==0
loc p02_h `r(mean)'



sum phat_h_b if Hispanic==1 & more1==1 & Black==0
loc p13_h `r(mean)'
sum phat_h_b if Hispanic==0 & more1==1 & Black==0
loc p03_h `r(mean)'




mat def H=J(2,1,.)
mat rownames H = hispanic hispanic 
mat H[1,1]=`p12_h'/`p02_h' 
mat H[2,1]=`p13_h'/`p03_h'




*Af American

sum phat_h_b if Black==1 & within1==1 & Hispanic==0
loc p12_b `r(mean)'
sum phat_h_b if Black==0 & within1==1 & Hispanic==0
loc p02_b `r(mean)'




sum phat_h_b if Black==1 & more1==1 & Hispanic==0
loc p13_b `r(mean)'
sum phat_h_b if Black==0 & more1==1 & Hispanic==0
loc p03_b `r(mean)'



mat def A=J(2,1,.)
mat rownames A = black black 
mat A[1,1]=`p12_b'/`p02_b' 
mat A[2,1]=`p13_b'/`p03_b'



*Export

mat def Res=M\A\H
mat list Res

preserve
clear
svmat2 Res,  names(col)  rnames(race)
gen n=_n

save "../stores/aux/rel_risk_distance.dta"  , replace
restore
*end

