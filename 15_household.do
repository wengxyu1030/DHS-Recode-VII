
******************************
*****Household Level Info*****
******************************   

*hh_id	ID (generated)      
    gen hh_id = hhid
	
*hh_headed	Head's highest educational attainment (1 = none, 2 = primary, 3 = lower sec or higher)
    recode hv106 (0 = 1) (1 = 2) (2/3 = 3) (8 9=.) if hv101 == 1,gen(headed)
    bysort hh_id: egen hh_headed = min(headed)
	label define l_headed 1 "none" 2 "primary" 3 "lower sec or higher"
    label values hh_headed l_headed
	
* hh_country_code Country code
	clonevar hh_country_code = hv000 
	
*hh_region_num	Region of residence numerical (hv024)
    clonevar hh_region_num = hv024
	
*hh_region_lab	Region of residence label (v024)
    decode hv024,gen(hh_region_lab)

*hh_size # of members   
    clonevar hh_size = hv009
           
*hh_urban Resides in urban area (1/0)
    recode hv025 (2=0),gen(hh_urban)
	
*hh_sampleweight Sample weight (v005/1000000)       
    gen hh_sampleweight = hv005/10e6 
	
*ind_sampleweight Sample weight (v005/1000000) 
    gen ind_sampleweight = hh_size*hh_sampleweight
 
*hh_wealth_quintile	Wealth quintile       
    clonevar hh_wealth_quintile = hv270                          
	
*hh_wealthscore	Wealth index score   
    clonevar hhwealthscore_old = hv271
    egen hhwealthscore_oldmin=min(hhwealthscore_old) 
    gen hh_wealthscore=hhwealthscore_old-hhwealthscore_oldmin
    replace hh_wealthscore=hh_wealthscore/1000000

*hh_religion: religion of household head (DW Team Nov 2021)
	cap clonevar hh_religion = v130
	
*hh_watersource: Water source (hv201 in DHS HH dataset, already coded for MICS)
	clonevar hh_watersource = hv201

*hh_toilet: Toilet type (hv205 “”, already coded for MICS)
	clonevar hh_toilet = hv205
	
/* DW Apr 2022 */

* Household Head - Age [raw]
	rename hv220 hh_headage_raw

* Household Head - Sex [raw]
	rename hv219 hh_headsex_raw	

* Household Head - Education [hm file, computed]
	* create mod-education indicator
	gen temp_edu = hv106
		replace temp_edu = . if missing(hv101) | hv106 >=8 /*drop don't know or missing*/
		replace temp_edu = . if hv101 != 1 /*keep values for household heads*/

	* this methodology implies - when multiple household head, we take the highest
	bysort hv001 hv002: egen hh_headedu_comp = max(temp_edu) 
	drop temp_edu
	
	label define l_headedu 0 "none" 1 "primary" 2 "secondary" 3 "higher"
    label values hh_headedu_comp l_headedu

	  
*hv001 Sampling cluster number (original)
*hv002 Household number (original)
*hv003 Respondent's line number in household roster (original)

duplicates drop hv001 hv002,force
	
