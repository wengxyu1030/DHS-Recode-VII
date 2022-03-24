
******************************
*** Child mortality***********
******************************   
	
*c_ITN	Child slept under insecticide-treated-bednet (ITN) last night.
    gen c_ITN = .
	
	capture confirm variable ml0
	if _rc == 0 {
	replace c_ITN=(ml0==1 | ml0==2) 								
	replace c_ITN=. if ml0==.                  //Children under 5 in country where malaria is endemic (only in countries with endemic)
		  
	   
	*m10 variable in Liberia2019birth label "wanted pregnancy when became pregnant",change the c_ITN according to v460(label:   children under 5 slept under mosquito bed net last night-household questionnaire)as below
	
	if inlist(name,"Liberia2019"){
       replace c_ITN=1 if v460==1|v460==2
	   replace c_ITN=0 if v460==0|v460==3

	   }
	}

*w_mateduc	Mother's highest educational level ever attended (1 = none, 2 = primary, 3 = lower sec or higher)
    recode v106 (0 = 1) (1 =2) (2/3 = 3) (6/8 = .),gen(w_mateduc)
	  label define w_label 1 "none" 2 "primary" 3 "lower sec or higher"
      label values w_mateduc w_label



