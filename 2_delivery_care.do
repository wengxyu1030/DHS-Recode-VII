******************************
*** Delivery Care************* 
******************************
gen DHS_phase=substr(v000, 3, 1)
destring DHS_phase, replace

gen country_year="`name'"
gen year = regexs(1) if regexm(country_year, "([0-9][0-9][0-9][0-9])[\-]*[0-9]*[ a-zA-Z]*$")
destring year, replace
gen country = regexs(1) if regexm(country_year, "([a-zA-Z]+)")


 *sba_skill (not nailed down yet, need check the result and update key words accordingly.)

	foreach var of varlist m3a-m3m {

	local lab: variable label `var' 

    replace `var' = . if  ///
	!regexm("`lab'","trained") & (!regexm("`lab'","doctor|nurse|midwife|mifwife|aide soignante|assistante accoucheuse|clinical officer|mch aide|auxiliary birth attendant|physician assistant|professional|ferdsher|feldshare|skilled|community health care provider|birth attendant|hospital/health center worker|hew|auxiliary|icds|feldsher|mch|vhw|village health team|health personnel|gynecolog(ist|y)|obstetrician|internist|pediatrician|family welfare visitor|medical assistant|health assistant|general practitioner|matron|health officer|extension|ob-gy") ///
	|regexm("`lab'","na^|-na|traditional birth attendant|untrained|unquallified|empirical midwife|box|community|village birth attendant"))
	
	replace `var' = . if !inlist(`var',0,1)
	
	 }
	if inlist(name, "Senegal2018", "Senegal2019", "Senegal2017") {
		replace m3h = . // exclude auxiliary midwife (matrone)
	}
	if inlist(name,"Nepal2016") {
		replace m3d = .  // Nepal doesn't include health assistant in the report.
	}
	/* do consider as skilled if contain words in the first group but don't contain any words in the second group */

	egen sba_skill = rowtotal(m3a-m3m),mi

	*c_hospdel: child born in hospital of births in last 2 years

	decode m15, gen(m15_lab)
	replace m15_lab = lower(m15_lab)
	
	gen c_hospdel = 0 if !mi(m15)
	replace c_hospdel = 1 if ///
    regexm(m15_lab,"medical college|surgical") | ///
	regexm(m15_lab,"hospital") & !regexm(m15_lab,"sub-center")
	replace c_hospdel = . if mi(m15) | m15 == 99 | mi(m15_lab)	
	// please check this indicator in case it's country specific

	if inlist(name, "Benin2017") {
		replace c_hospdel= ( inlist(m15,21,31,32) ) if !mi(m15)   
	}
	 
	*c_facdel: child born in formal health facility of births in last 2 years
	
	gen c_facdel = 0 if !mi(m15)
	replace c_facdel = 1 if regexm(m15_lab,"hospital|maternity|health center|dispensary") | ///
	!regexm(m15_lab,"home|other private|other$|pharmacy|non medical|private nurse|religious|abroad|india|other public|tba")
	replace c_facdel = . if mi(m15) | m15 == 99 | mi(m15_lab)

	
	*c_earlybreast: child breastfed within 1 hours of birth of births in last 2 years
	
	gen c_earlybreast = 0

	replace c_earlybreast  = 1 if inlist(m34,0,100)
	replace c_earlybreast  = . if inlist(m34,199,999)
	replace c_earlybreast  = . if m34 ==. & m4 != 94

/*	or:
	gen c_earlybreast  = inlist(m34,0,100) if !inlist(m34,199,299,.)  // code . if m34 or m4 missing
	replace c_earlybreast = 0 if m4 ==94  // code 0 if no breastfeeding
*/  
	
    *c_skin2skin: child placed on mother's bare skin immediately after birth of births in last 2 years
	gen c_skin2skin = (m77 == 1) if    !inlist(m77,.,3,8)               //though missing but still a place holder.(the code might change depends on how missing represented in surveys)
	
	*c_sba: Skilled birth attendance of births in last 2 years: go to report to verify how "skilled is defined"

	gen c_sba = . 

	replace c_sba = 1 if sba_skill>=1  & sba_skill!=.

	replace c_sba = 0 if sba_skill==0 


	*c_sba_q: child placed on mother's bare skin and breastfeeding initiated immediately after birth among children with sba of births in last 2 years
	gen c_sba_q = (c_skin2skin == 1 & c_earlybreast == 1) if c_sba == 1
	replace c_sba_q = . if c_skin2skin == . | c_earlybreast == .
	
	*c_caesarean: Last birth in last 2 years delivered through caesarean                    
	clonevar c_caesarean = m17
	replace c_caesarean = . if m17 == 8
	replace c_caesarean = . if m15 == .
	
    *c_sba_eff1: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth)
  	if !inlist(name,"Angola2015","Burundi2016","Cameroon2018","Colombia2015","Nepal2016","Tanzania2015"){
	gen stay = 0 if m15 != .
	replace stay = 1 if stay == 0 & (inrange(m61,124,198)|inrange(m61,201,298)|inrange(m61,301,399))
	replace stay = . if inlist(m61,.,299,998)  & !inlist(m15,11,12,96) // filter question, based on m15
	}
	if inlist(name,"Angola2015","Burundi2016"){
	gen stay = 0 if m15 != .
	replace stay = 1 if stay == 0 & (inrange(m61,124,198)|inrange(m61,201,298)|inrange(m61,301,399))
	replace stay = . if inlist(m61,.,299,998)  & !inlist(m15,11,12,36,96) // filter question, based on m15
	}
	if inlist(name,"Cameroon2018"){
	gen stay = 0 if m15 != .
	replace stay = 1 if stay == 0 & (inrange(m61,124,198)|inrange(m61,201,298)|inrange(m61,301,399))
	replace stay = . if inlist(m61,.,299,998)  & !inlist(m15,11,12,26,96) // filter question, based on m15
	}
	if inlist(name,"Colombia2015"){
	gen stay = .
	}	
	if inlist(name,"Nepal2016"){
	gen stay = 0 if m15 != .
	replace stay = 1 if stay == 0 & (inrange(m61,124,198)|inrange(m61,201,298)|inrange(m61,301,399))
	replace stay = . if inlist(m61,.,299,998)  & !inlist(m15,11,12,51,96) // filter question, based on m15
	}
	if inlist(name,"Tanzania2015"){
	gen stay = 0 if m15 != .
	replace stay = 1 if stay == 0 & (inrange(m61,124,198)|inrange(m61,201,298)|inrange(m61,301,399))
	replace stay = . if inlist(m61,.,299,998)  & !inlist(m15,11,12,13,96) // filter question, based on m15
	}
	gen c_sba_eff1 = (c_facdel == 1 & c_sba == 1 & stay == 1 & c_earlybreast == 1) 
	replace c_sba_eff1 = . if c_facdel == . | c_sba == . | stay == . | c_earlybreast == . 
		
	*c_sba_eff1_q: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth) among those with any SBA
	gen c_sba_eff1_q = c_sba_eff1 if c_sba == 1
		
	*c_sba_eff2: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth, skin2skin contact)
	gen c_sba_eff2 = (c_facdel == 1 & c_sba == 1 & stay == 1 & c_earlybreast == 1 & c_skin2skin == 1) 
	replace c_sba_eff2 = . if c_facdel == . | c_sba == . | stay == . | c_earlybreast == . | c_skin2skin == .
	
	*c_sba_eff2_q: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth, skin2skin contact) among those with any SBA
	
	gen c_sba_eff2_q =  c_sba_eff2 if c_sba == 1


	
