
******************************
***Postnatal Care************* 
****************************** 

	*c_pnc_any : mother OR child receive PNC in first six weeks by skilled health worker	
	if inlist(name,"Afghanistan2015") {
		gen c_pnc_any = 0 if !mi(m70) | !mi(m50) 
        replace c_pnc_any = 1 if (m71 <= 306 & inrange(m72,11,13) ) | (m51 <= 306 & inrange(m52,10,13) )
		replace c_pnc_any = . if inlist(m71,199,299,399,998)| inlist(m51,998)| m72 == 8 | m52 == 8
	}
	
	if inlist(name,"Myanmar2015") {
		// in a health facility after delivery and before discharge | after discharge or delivery at home for mother or child
		gen c_pnc_any = .
		
		replace c_pnc_any = 0 if m62 != . | m66 != . | m70 != . 
		replace c_pnc_any = 1 if (m63 <= 306 & inrange(m64,11,13)) | (m67 <= 306 & inrange(m68,11,13)) | (m71 <= 306 & inrange(m72,11,13))
		replace c_pnc_any = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 
	}  
	
	if inlist(name,"Angola2015","Armenia2015","Albania2017") {
		gen c_pnc_any = .
		replace c_pnc_any = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_any = 1 if (m63 <= 306 & inrange(m64,11,13)) | (m67 <= 306 & inrange(m68,11,13)) | (m71 <= 306 & inrange(m72,11,13)) | (m75 <= 306 & inrange(m76,11,13))
		replace c_pnc_any = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}  
	
	if inlist(name,"Ethiopia2016","Malawi2015","Uganda2016","Nepal2016","Haiti2016") {	
	gen c_pnc_any = .
		replace c_pnc_any = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_any = 1 if (m63 <= 306 & inrange(m64,11,15)) | (m67 <= 306 & inrange(m68,11,15)) | (m71 <= 306 & inrange(m72,11,15)) | (m75 <= 306 & inrange(m76,11,15))
		replace c_pnc_any = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}
	
	if inlist(name,"Tanzania2015") {	
	gen c_pnc_any = .
		replace c_pnc_any = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_any = 1 if (m63 <= 306 & !inlist(m64,21,96)) | (m67 <= 306 & !inlist(m68,21,96)) | (m71 <= 306 & !inlist(m72,21,96)) | (m75 <= 306 & !inlist(m76,21,96))
		replace c_pnc_any = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}
	
    if inlist(name,"Uganda2016") {
	gen c_pnc_any = .
	    replace c_pnc_any = 0 if m62 != . | m66 != . | m70 != . | m74 != .
	    replace c_pnc_any = 1 if (m63 <= 306 & inlist(m64,11,12,13)) | (m67 <= 306 & inlist(m68,11,12,13) & m67>=m63 ) | (m71 <= 306 & inlist(m72,11,12,13) & m71 >= m75) | (m75 <= 306 & inlist(m76,11,12,13))																																							 
		replace c_pnc_any = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}
	

	
	*c_pnc_eff: mother AND child in first 24h by skilled health worker
	if inlist(name,"Afghanistan2015") {
		gen c_pnc_eff = (inrange(m72,11,13) & inrange(m51,100,124) & inrange(m71,100,124) )      
		replace c_pnc_eff = . if inlist(m71,199,299,399,998,.) | inlist(m51,998,.) | !mi(m72)
	}
	
	if inlist(name,"Myanmar2015") {
		gen c_pnc_eff = ((inrange(m63,100,124) & inrange(m64,11,13)) | (inrange(m67,100,124) & inrange(m68,11,13))) & (inrange(m71,100,124) & inrange(m72,11,13))
		replace c_pnc_eff = . if inlist(m63,998) | inlist(m67,998) | inlist(m71,998) 
	}
	if inlist(name,"Angola2015","Armenia2015","Albania2017") {
		gen c_pnc_eff = .
		
		replace c_pnc_eff = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_eff = 1 if (((inrange(m63,100,124) | m63 == 201 ) & inrange(m64,11,13)) | ((inrange(m67,100,124) | m67 == 201) & inrange(m68,11,13))) & (((inrange(m71,100,124) | m71 == 201) & inrange(m72,11,13)) | ((inrange(m75,100,124) | m75 == 201) & inrange(m76,11,13)))
		replace c_pnc_eff = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}
	
	if inlist(name,"Ethiopia2016","Malawi2015","Uganda2016","Nepal2016","Haiti2016") {	
		gen c_pnc_eff = .
		
		replace c_pnc_eff = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_eff = 1 if (((inrange(m63,100,124) | m63 == 201 ) & inrange(m64,11,15)) | ((inrange(m67,100,124) | m67 == 201) & inrange(m68,11,15))) & (((inrange(m71,100,124) | m71 == 201) & inrange(m72,11,15)) | ((inrange(m75,100,124) | m75 == 201) & inrange(m76,11,15)))
		replace c_pnc_eff = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}
	
	if inlist(name,"Tanzania2015") {	
		gen c_pnc_eff = .
		
		replace c_pnc_eff = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_eff = 1 if (((inrange(m63,100,124) | m63 == 201 ) & !inlist(m64,21,96)) | ((inrange(m67,100,124) | m67 == 201) & !inlist(m68,21,96))) & (((inrange(m71,100,124) | m71 == 201) & !inlist(m72,21,96)) | ((inrange(m75,100,124) | m75 == 201) & !inlist(m76,21,96)))
		replace c_pnc_eff = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}
	
	if inlist(name,"Uganda2016") {
	    gen c_pnc_eff = .
		replace c_pnc_eff = 0 if m62 != . | m66 != . | m70 != . | m74 != .
		replace c_pnc_eff = 1 if (((inrange(m63,100,124) | m63 == 201 ) & inlist(m64,11,12,13)) | ((inrange(m67,100,124) | m67 == 201) & inlist(m68,11,12,13) & m67 >= m63 )) & (((inrange(m71,100,124) | m71 == 201) & inlist(m72,11,12,13) & m71>=m75) | ((inrange(m75,100,124) | m75 == 201) & inlist(m76,11,12,13)))
		replace c_pnc_eff = . if inlist(m63,199,299,399,998) | inlist(m67,199,299,399,998) | inlist(m71,199,299,399,998) | inlist(m75,199,299,399,998) | m62 == 8 | m66 == 8 | m70 == 8 | m74 == 8
	}
	
	
	//replace c_pnc_eff = . if !(inrange(hm_age_mon,0,23)& bidx ==1)

	
	
	*c_pnc_eff_q: mother AND child in first 24h by skilled health worker among those with any PNC
    gen c_pnc_eff_q = c_pnc_eff if c_pnc_any == 1
	
	
	*c_pnc_eff2: mother AND child in first 24h by skilled health worker and cord check, temperature check and breastfeeding counselling within first two days
	capture confirm variable m78a m78b m78d                            //m78* only available for Recode VII, cited from Aline
	if _rc == 0 {
	recode m78a m78b m78d (8=.)
	egen check = rowtotal(m78a m78b m78d),mi
	gen c_pnc_eff2 = c_pnc_eff
	replace c_pnc_eff2 = . if check != 3															// structure changed according to missing condition in Guide
	replace c_pnc_eff2 = 0 if c_pnc_eff == 0 | m78a == 0 | m78b == 0 | m78d == 0
    }
	
	
    *c_pnc_eff2_q: mother AND child in first 24h weeks by skilled health worker and cord check, temperature check and breastfeeding counselling within first two days among those with any PNC
	gen c_pnc_eff2_q = c_pnc_eff2 if c_pnc_any ==1
			
		


	
*******compare with statacompiler
preserve
keep if inrange(hm_age_mon,0,59)
restore

