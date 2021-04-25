******************************
*** Delivery Care*************
******************************
/* Note: Generation of c_facdel, c_hospdel & c_sba is cited from Aline: https://github.com/wengxyu1030/DHS-Recode-VI/blob/master/2_delivery_care.do
*/
gen DHS_phase=substr(v000, 3, 1)
destring DHS_phase, replace

gen country_year="`name'"
gen year = regexs(1) if regexm(country_year, "([0-9][0-9][0-9][0-9])[\-]*[0-9]*[ a-zA-Z]*$")
destring year, replace
gen country = regexs(1) if regexm(country_year, "([a-zA-Z]+)")

*c_caesarean: Last birth in last 2 years delivered through caesarean
	clonevar c_caesarean = m17

*c_skin2skin: child placed on mother's bare skin immediately after birth of births in last 2 years
	gen c_skin2skin = (m77 == 1) if  !inlist(m77,.,8)               //though missing but still a place holder.(the code might change depends on how missing represented in surveys)

*c_earlybreast: child breastfed within 1 hours of birth of births in last 2 years
	gen c_earlybreast = .

	replace c_earlybreast = 0 if m4 != .    //  based on Last born children who were ever breastfed
	replace c_earlybreast = 1 if inlist(m34,0,100)
	replace c_earlybreast = . if inlist(m34,199,299,.)

* The structure to generate c_facdel, c_hospdel & c_sba is cited from Aline: https://github.com/wengxyu1030/DHS-Recode-VI/blob/master/2_delivery_care.do
	*c_hospdel: child born in hospital of births in last 2 years
		decode m15, gen(m15_lab)
		replace m15_lab = lower(m15_lab)

		gen c_hospdel = 0 if !mi(m15)
		replace c_hospdel = 1 if ///
		regexm(m15_lab,"medical college|surgical") | ///
		regexm(m15_lab,"hospital") & !regexm(m15_lab,"center|sub-center")
		replace c_hospdel = . if mi(m15) | m15 == 99 | mi(m15_lab)
		// please check this indicator in case it's country specific

	*c_facdel: child born in formal health facility of births in last 2 years
		gen c_facdel = 0 if !mi(m15)
		replace c_facdel = 1 if regexm(m15_lab,"hospital|maternity|health center|dispensary") | ///
		!regexm(m15_lab,"home|other private|other$|pharmacy|non medical|private nurse|religious|abroad|india|other public|tba")
		replace c_facdel = . if mi(m15) | m15 == 99 | mi(m15_lab)
	*sba_skill
		foreach var of varlist m3a-m3n {
		local lab: variable label `var'
		replace `var' = . if !regexm("`lab'","trained") & (!regexm("`lab'","doctor|nurse|midwife|mifwife|aide soignante|assistante accoucheuse|clinical officer|mch aide|auxiliary birth attendant|physician assistant|professional|ferdsher|feldshare|skilled|community health care provider|birth attendant|hospital/health center worker|hew|auxiliary|icds|feldsher|mch|vhw|village health team|health personnel|gynecolog(ist|y)|obstetrician|internist|pediatrician|family welfare visitor|medical assistant|health assistant|general practitioner|matron") ///
		|regexm("`lab'","na -|na^|-na|traditional birth attendant|untrained|unquallified|empirical midwife|box"))
		replace `var' = . if !inlist(`var',0,1)
			if regexm("`lab'","trained") | !(!regexm("`lab'","doctor|nurse|midwife|mifwife|aide soignante|assistante accoucheuse|clinical officer|mch aide|auxiliary birth attendant|physician assistant|professional|ferdsher|feldshare|skilled|community health care provider|birth attendant|hospital/health center worker|hew|auxiliary|icds|feldsher|mch|vhw|village health team|health personnel|gynecolog(ist|y)|obstetrician|internist|pediatrician|family welfare visitor|medical assistant|health assistant|general practitioner|matron") ///
				|regexm("`lab'","na -|na^|-na|traditional birth attendant|untrained|unquallified|empirical midwife|box")) {
			ren `var' `var'gskill
			}
		}
	/* do consider as skilled if contain words in
	 the first group but don't contain any words in the second group */
		egen sba_skill = rowtotal(m3a-m3n),mi

	*c_sba: Skilled birth attendance of births in last 2 years: go to report to verify how "skilled is defined"
	gen c_sba = 1 if sba_skill>=1 & sba_skill!=.
	replace c_sba = 0 if sba_skill==0 
	foreach var of varlist *gskill{
		replace c_sba = . if sba_skill==0  & `var'==.
	}
	/*
	gen c_sba = 0
	replace c_sba = 1 if (m3a==1 | m3b==1 | m3c==1)
	replace c_sba = . if m3a==. | m3b==. | m3c==.
	*/

*c_sba_q: child placed on mother's bare skin and breastfeeding initiated immediately after birth among children with sba of births in last 2 years
		gen c_sba_q = (c_skin2skin == 1 & c_earlybreast == 1) if c_sba == 1
		replace c_sba_q = . if c_skin2skin == . | c_earlybreast == .

*c_sba_eff1: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth)
    //gen stay = (inrange(m61,124,161)|inrange(m61,201,240)|inrange(m61,301,308))
	gen stay = (inrange(m61,124,198)|inrange(m61,201,298)|inrange(m61,301,398)) if !inlist(m61,199,299,998,.)
	gen c_sba_eff1 = 1 if c_facdel == 1 & c_sba == 1 & stay == 1 & c_earlybreast == 1
	replace c_sba_eff1 = 0 if c_facdel == 0 | c_sba == 0 | stay == 0 | c_earlybreast == 0

*c_sba_eff1_q: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth) among those with any SBA
	gen c_sba_eff1_q = c_sba_eff1 if c_sba == 1

*c_sba_eff2: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth, skin2skin contact)
	gen c_sba_eff2 = 1 if c_sba_eff1 == 1 & c_skin2skin ==1
	replace c_sba_eff2 = 0 if c_sba_eff1 == 0 | c_skin2skin ==0

*c_sba_eff2_q: Effective delivery care (baby delivered in facility, by skilled provider, mother and child stay in facility for min. 24h, breastfeeding initiated in first 1h after birth, skin2skin contact) among those with any SBA
	gen c_sba_eff2_q =  c_sba_eff2 if c_sba == 1
