
******************************
*** Child anthropometrics ****
******************************   
pause anthropo
/*

*/


*c_stunted: Child under 5 stunted
* DW Nov 2021 - add hc72

capture confirm variable hc70 hc71 hc72 
if _rc == 0 {
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

*c_wasted
gen c_wasted=1 if hc72<-2
replace c_wasted=0 if hc72>=-2 & hc72!=.

*c_xxx_sev
	gen c_stunted_sev=1 if hc70<-3
	replace c_stunted_sev=0 if hc70>=-3 & hc70!=.
	gen c_underweight_sev=1 if hc71<-3
    replace c_underweight_sev=0 if hc71>=-3 & hc71!=.
	gen c_wasted_sev=1 if hc72<-3
	replace c_wasted_sev=0 if hc72>=-3 & hc72!=.
}

if _rc != 0 {
    gen c_stunted = . 
	gen c_wasted = .
	gen c_stunted_sev = .
	gen c_underweight = .
	gen c_underweight_sev = .
	gen c_wasted_sev = .
	gen hc70 = .
	gen hc71 = .
	gen hc72 = .
	
}
							
*ant_sampleweight Child anthropometric sampling weight
    gen ant_sampleweight = hv005/10e6

*mother's line number
	gen c_motherln = hv112

*c_stu_was: Both stunted and wasted
		gen c_stu_was = (c_stunted == 1 & c_wasted ==1) 
		replace c_stu_was = . if c_stunted == . | c_wasted == . 
		label define l_stu_was 1 "Both stunted and wasted"
		label values c_stu_was l_stu_was		

*c_stu_was_sev: Both severely stunted and severely wasted		
		gen c_stu_was_sev = (c_stunted_sev == 1 & c_wasted_sev == 1)
		replace c_stu_was_sev = . if c_stunted_sev == . | c_wasted_sev == . 
		label define l_stu_was_sev 1 "Both severely stunted and severely wasted"
		label values c_stu_was_sev l_stu_was_sev
	
