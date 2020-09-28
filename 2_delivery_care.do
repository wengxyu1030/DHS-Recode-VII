******************************
*** Delivery Care************* 
******************************
gen DHS_phase=substr(v000, 3, 1)
destring DHS_phase, replace

gen country_year="`name'"
gen year = regexs(1) if regexm(country_year, "([0-9][0-9][0-9][0-9])[\-]*[0-9]*[ a-zA-Z]*$")
destring year, replace
gen country = regexs(1) if regexm(country_year, "([a-zA-Z]+)")

	*c_hospdel: child born in hospital of births in last 2 years
	if inlist(name, "Afghanistan2015") {
		gen c_hospdel= ( inlist(m15,21,41) ) if   !mi(m15)        
	}
	if inlist(name, "Myanmar2015","Ethiopia2016","Malawi2015","Uganda2016","Armenia2015","Albania2017","Nepal2016") {
		gen c_hospdel= ( inlist(m15,21,31) ) if   !mi(m15)   
	}
	if inlist(name, "Angola2015") {
		gen c_hospdel= ( inlist(m15,21,22,23,31) ) if   !mi(m15)   
	}
	if inlist(name, "Tanzania2015") {
		gen c_hospdel= ( inlist(m15,21,22,23,24,31,32,33,41,42) ) if   !mi(m15)  
	}
	if inlist(name, "Haiti2016") {
		gen c_hospdel= ( inlist(m15,21,23,24,26,31,33) ) if   !mi(m15)  
	}


	
	
	*c_facdel: child born in formal health facility of births in last 2 years
	
	if ~inlist(name, "Tanzania2015","Haiti2016") {
			gen c_facdel = ( !inlist(m15,11,12,26,36,46,96) ) if   !mi(m15)   
	}
	if inlist(name, "Tanzania2015","Haiti2016") {
			gen c_facdel = ( !inlist(m15,11,12,96) ) if   !mi(m15)
	}
	*c_earlybreast: child breastfed within 1 hours of birth of births in last 2 years

        gen c_earlybreast = 0
        replace c_earlybreast = 1 if inlist(m34,0, 100)
	replace c_earlybreast = . if inlist(m34,199, 999)
	replace c_earlybreast = . if m34 ==. & m4 != 94
	
	/*
	gen c_earlybreast = (inlist(m34,0,100)) 
	replace c_earlybreast = . if inlist(m34,199,299,.) 
	*/
	
    *c_skin2skin: child placed on mother's bare skin immediately after birth of births in last 2 years
	gen c_skin2skin = (m77 == 1) if    !inlist(m77,.,8)               //though missing but still a place holder.(the code might change depends on how missing represented in surveys)
	
	*c_sba: Skilled birth attendance of births in last 2 years: go to report to verify how "skilled is defined"
	if inlist(name, "Afghanistan2015","Myanmar2015","Angola2015","Armenia2015") {
		gen c_sba = 0
		replace c_sba = 1 if (m3a==1 | m3b==1 | m3c==1 ) 
		replace c_sba = . if m3a==. | m3b==. | m3c==.
	}
	if inlist(name, "Ethiopia2016") {
		gen c_sba = 0
		replace c_sba = 1 if (m3a==1 | m3b==1 | m3c==1 | m3d==1 | m3e==1) 
		replace c_sba = . if m3a==. | m3b==. | m3c==. | m3d==. | m3e==. 
	}
	if inlist(name, "Malawi2015") {
		gen c_sba = 0
		replace c_sba = 1 if (m3a==1 | m3b==1 ) 
		replace c_sba = . if m3a==. | m3b==.
	}
	if inlist(name, "Uganda2016"，"Haiti2016") {
		gen c_sba = 0
		replace c_sba = 1 if (m3a==1 | m3b==1 | m3c==1 | m3d==1) 
		replace c_sba = . if m3a==. | m3b==. | m3c==. | m3d==.  
	}
	if inlist(name, "Albania2017") {
		gen c_sba = 0
		replace c_sba = 1 if (m3a==1 | m3b==1 | m3d==1) 
		replace c_sba = . if m3a==. | m3b==. | m3d==. 
	}
	if inlist(name, "Tanzania2015") {
		gen c_sba = 0
		replace c_sba = 1 if (m3a==1 | m3b==1 | m3c==1 | m3g==1 | m3h==1 | m3i==1) 
		replace c_sba = . if m3a==. | m3b==. | m3c==. | m3g==. | m3h==. | m3i==.  
	}
	if inlist(name, "Nepal2016") {
		gen c_sba = 0
		replace c_sba = 1 if (m3a==1 | m3b==1 | m3d==1 | m3e==1) 
		replace c_sba = . if m3a==. | m3b==. | m3d==. | m3e==.
	}

	*c_sba_q: child placed on mother's bare skin and breastfeeding initiated immediately after birth among children with sba of births in last 2 years
	gen c_sba_q = (c_skin2skin == 1 & c_earlybreast == 1) if c_sba == 1
	replace c_sba_q = . if c_skin2skin == . | c_earlybreast == .
	
	*c_caesarean: Last birth in last 2 years delivered through caesarean                    
	clonevar c_caesarean = m17
	
    *c_sba_eff1: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth)
    //gen stay = (inrange(m61,124,161)|inrange(m61,201,240)|inrange(m61,301,308))
	gen stay = (inrange(m61,124,198)|inrange(m61,201,298)|inrange(m61,301,398))
	replace stay = . if mi(m61) | inlist(m61,199,299,998)
	gen c_sba_eff1 = (c_facdel == 1 & c_sba == 1 & stay == 1 & c_earlybreast == 1) 
	replace c_sba_eff1 = . if c_facdel == . | c_sba == . | stay == . | c_earlybreast == . 
	
	*c_sba_eff1_q: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth) among those with any SBA
	gen c_sba_eff1_q = (c_facdel==1 & c_sba == 1 & stay==1 & c_earlybreast == 1) if c_sba == 1	
	replace c_sba_eff1_q = . if c_facdel == . | c_sba == . | stay == . | c_earlybreast == . 
	
	*c_sba_eff2: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth, skin2skin contact)
	gen c_sba_eff2 = (c_facdel == 1 & c_sba == 1 & stay == 1 & c_earlybreast == 1 & c_skin2skin == 1) 
	replace c_sba_eff2 = . if c_facdel == . | c_sba == . | stay == . | c_earlybreast == . | c_skin2skin == .
	
	*c_sba_eff2_q: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth, skin2skin contact) among those with any SBA
	gen c_sba_eff2_q = (c_facdel == 1 & c_sba == 1 & stay == 1 & c_earlybreast == 1 & c_skin2skin == 1) if c_sba == 1	
	replace c_sba_eff2_q = . if c_facdel == . | c_sba == . | stay == . | c_earlybreast == . | c_skin2skin == .
	



	
