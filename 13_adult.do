********************
*** adult***********
********************
*a_inpatient_1y	18y+ household member hospitalized in last 12 months (1/0)
    gen a_inpatient_1y = . 
    gen a_inpatient_ref =.
    
	if inlist(name,"Philippines2017"){
		replace a_inpatient_1y =0 
		recode sh212 (8=.)
		gen ip_30dident = sh208a*sh212 
		recode ip_30dident sh222a (0=.) // ip_30dident is the line num. for individuals who visit IP for the last 30 days 
	* sh208a_*line sh222a_*line are line num. for hh members who pay IP visit for last 30d/12m. generate by hhid to prepare for matching with hvidx
		forvalue i = 1(1)5{      
			gen sh208a_`i' = ip_30dident		
			gen sh222a_`i' = sh222a 
		}
		foreach i in 1 2 3 4 5{
			bysort hhid: egen sh208a_`i'line =min(sh208a_`i') 
			bysort hhid: egen sh222a_`i'line =min(sh222a_`i') 
				foreach k in 1 2 3 4 5{ 
					replace sh208a_`k' =. if sh208a_`k'== sh208a_`i'line
					replace sh222a_`k' =. if sh222a_`k'== sh222a_`i'line
			}
		}
	* generate a_inpatient_1y
		foreach k in 1 2 3 4 5{
			replace a_inpatient_1y =1 if sh208a_`k'line == hvidx | sh222a_`k'line== hvidx
		} // ind. confined in hospital in last 30days/12months if their line number matched with hvidx
		replace a_inpatient_ref = 12
		drop sh208a_*  sh222a_*
	}	// exclude the person who is deceased or no longer in the household, report p.346
	
*a_bp_treat	18y + being treated for high blood pressure 
    gen a_bp_treat = . 

	if inlist(name, "Bangladesh2011") {
		replace a_bp_treat=0 if sh250!=. 
		replace a_bp_treat=1 if sh250==1 
	}
	if inlist(name,"Bangladesh2017") {
		replace a_bp_treat=sb318a
	}	
	if inlist(name,"SouthAfrica2016") {
	replace a_bp_treat=0 if sh224!=. | sh324!=.
	replace a_bp_treat=1 if sh224==1 | sh324==1
	}

*a_bp_sys & a_bp_dial: 18y+ systolic & diastolic blood pressure (mmHg) in adult population 
	gen a_bp_sys = .
	gen a_bp_dial = .
	
	if inlist(name, "Bangladesh2011") {	
		drop a_bp_sys a_bp_dial
		recode sh246s sh255s sh264s sh246d sh255d sh264d  (994 995 996 998 999 =.) 
		egen a_bp_sys = rowmean(sh246s sh255s sh264s)
		egen a_bp_dial = rowmean(sh246d sh255d sh264d)
    }	
	
	

	
*a_bp_sys & a_bp_dial: 18y+ systolic & diastolic blood pressure (mmHg) in adult population 
	gen a_bp_sys = .
	gen a_bp_dial = .
	
	if inlist(name, "Bangladesh2011") {	
		drop a_bp_sys a_bp_dial
		recode sh246s sh255s sh264s sh246d sh255d sh264d  (994 995 996 998 999 =.) 
		egen a_bp_sys = rowmean(sh246s sh255s sh264s)
		egen a_bp_dial = rowmean(sh246d sh255d sh264d)
    }	
	
	
*a_bp_sys 18y+ systolic blood pressure (mmHg) in adult population 
  	if inlist(name,"Bangladesh2017") {
		recode sb315a sb323a sb332a (994 995 996 997 998 999 =.)
		egen a_bp_sys = rowmean(sb315a sb323a sb332a)
	}
	if inlist(name,"SouthAfrica2016") {
	egen a_bp_sys = rowmean(sh221a sh228a sh232a sh321a sh328a sh332a)
	}

	
*a_bp_dial	18y+ diastolic blood pressure (mmHg) in adult population 
	if inlist(name,"Bangladesh2017") {
		recode sb315b sb323b sb332b (994 995 996 997 998 999 =.)		
		egen a_bp_dial = rowmean(sb315b sb323b sb332b)
	}
	if inlist(name,"SouthAfrica2016") {
	egen a_bp_dial = rowmean(sh221b sh228b sh232b sh321b sh328b sh332b)
	}

	
*a_hi_bp140_or_on_med	18y+ with high blood pressure or on treatment for high blood pressure	
	gen a_hi_bp140=.
    replace a_hi_bp140=1 if a_bp_sys>=140 | a_bp_dial>=90 
    replace a_hi_bp140=0 if a_bp_sys<140 & a_bp_dial<90 
	replace a_hi_bp140 = . if a_bp_sys == . | a_bp_dial == .
	
	gen a_hi_bp140_or_on_med = .
	replace a_hi_bp140_or_on_med=1 if a_bp_treat==1 | a_hi_bp140==1
    replace a_hi_bp140_or_on_med=0 if a_bp_treat==0 & a_hi_bp140==0
	replace a_hi_bp140_or_on_med = . if a_bp_treat == . | a_hi_bp140 == .
	
*a_bp_meas				18y+ having their blood pressure measured by health professional in the last year  
    gen a_bp_meas = . 
	if inlist(name,"Bangladesh2017") {
		recode sb316 (7 =.)		
		replace a_bp_meas = sb316
	}	
*a_diab_treat				18y+ being treated for raised blood glucose or diabetes 
    gen a_diab_treat = .

	if inlist(name, "Bangladesh2011") {	
		gen a_diab_diag=(sh258==1)
		replace a_diab_diag=. if sh257==.|sh257==8|sh257==9|sh258==9

		replace a_diab_treat=(sh259==1)
		replace a_diab_treat=. if sh257==.|sh257==8|sh257==9|sh259==9
    }		

	if inlist(name,"Bangladesh2017") {
		replace a_diab_treat = sb327a
	}
