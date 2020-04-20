********************
*** adult***********
********************

capture confirm variabel sh246s sh255s sh264s sh246d sh255d sh264d
	if _rc == 0 {
    replace `var' =. if `var'>900
	}

*a_inpatient_1y	18y+ household member hospitalized in last 12 months (1/0)
    gen a_inpatient_1y = . 
	
	if inlist(name, "Albania2017") {
		replace a_inpatient_1y = sh17f
		replace a_inpatient_1y = . if a_inpatient_1y == 8
	}
*a_bp_treat	18y + being treated for high blood pressure 
    gen a_bp_treat = . 
	
	capture confirm variabel sh250
	if _rc == 0 {
	replace a_bp_treat=0 if sh250!=. 
	replace a_bp_treat=1 if sh250==1 
	}
	
*a_bp_sys 18y+ systolic blood pressure (mmHg) in adult population 
    gen  a_bp_sys = . 
	capture confirm variabel sh246s sh255s sh264s
	if _rc == 0 {
	egen a_bp_sys = rowmean(sh246s sh255s sh264s)
	}
	
*a_bp_dial	18y+ diastolic blood pressure (mmHg) in adult population 
    gen a_bp_dial = .
	capture confirm variabel sh246d sh255d sh264d
	if _rc == 0 {
	egen a_bp_dial = rowmean(sh246d sh255d sh264d)
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
	
*a_diab_treat				18y+ being treated for raised blood glucose or diabetes 
    gen a_diab_treat = .

	capture confirm variable sh257 sh258 sh259  
    if _rc==0 {
    gen a_diab_diag=(sh258==1)
    replace a_diab_diag=. if sh257==.|sh257==8|sh257==9|sh258==9

    replace a_diab_treat=(sh259==1)
    replace a_diab_treat=. if sh257==.|sh257==8|sh257==9|sh259==9
    }



