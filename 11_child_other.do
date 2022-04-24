
******************************
*** Child mortality***********
******************************   
	
*c_ITN	Child slept under insecticide-treated-bednet (ITN) last night.
    gen c_ITN = .
	
	capture confirm variable ml0
	if _rc == 0 {
	replace c_ITN=(ml0==1 | ml0==2) 								
	replace c_ITN=. if ml0==.                  //Children under 5 in country where malaria 
	   }

*c_mateduc	Mother's highest educational level ever attended (1 = none, 2 = primary, 3 = lower sec or higher)
    recode v106 (0 = 1) (1 =2) (2/3 = 3) (6/8 = .),gen(c_mateduc)
	  label define w_label 1 "none" 2 "primary" 3 "lower sec or higher"
      label values c_mateduc w_label



