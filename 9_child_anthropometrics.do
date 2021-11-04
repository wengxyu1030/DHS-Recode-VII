
******************************
*** Child anthropometrics ****
******************************   
*c_stunted: Child under 5 stunted
* DW Nov 2021 - add hc72
    foreach var in hc70 hc71 hc72 {
    replace `var'=. if `var'>900
    replace `var'=`var'/100
    }
    replace hc70=. if hc70<-6 | hc70>6
    replace hc71=. if hc71<-6 | hc71>5
    replace hc72=. if hc72<-6 | hc72>6
	
    gen c_stunted=1 if hc70<-2
    replace c_stunted=0 if hc70>=-2 & hc70!=.

*c_underweight: Child under 5 underweight
    gen c_underweight=1 if hc71<-2
    replace c_underweight=0 if hc71>=-2 & hc71!=.

							
*ant_sampleweight Child anthropometric sampling weight
    gen ant_sampleweight = hv005/10e6


*mother's line number
	gen c_motherln = hv112

*c_stuund: Both stunted and under weight
	gen c_stuund = (c_stunted == 1 & c_underweight ==1) 
		replace c_stuund = . if c_stunted == . | c_underweight == . 
		label var c_stuund "1 if child both stunted and underweight"
