
********************
***Demographics*****
********************
* HM data
* w_sampleweight
  g w_sampleweight = hv005/10e6

*hm_headrel	Relationship with HH head
	clonevar hm_headrel = hv101

*hm_stay				Stayed in the HH the night before the survey (1/0)
  clonevar hm_stay =  hv103  //vary by survey

*ln	Original line number of household member
    gen ln = hvidx

*hm_live Alive (1/0)
  gen hm_live = 1

*hm_male Male (1/0)
  recode hv104 (2 = 0),gen(hm_male)

*hm_age_yrs	Age in years
  gen hm_age_yrs = hv105
	replace hm_age_yrs = . if inlist(hv105,98)


capture confirm hc1 hc32
if _rc == 0 {
*hm_age_mon	Age in months (children only)
  clonevar hm_age_mon = hc1
	
*hm_dob	date of birth (cmc)
  gen hm_dob = hc32
}

if _rc != 0 {
   gen hm_age_mon = .
   gen hm_dob = .
}

*hm_doi	date of interview (cmc)
  gen hm_doi = hv008
