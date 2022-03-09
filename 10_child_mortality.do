
******************************
*** Child mortality***********
******************************

*mor_dob				Child date of birth (cmc)
    g mor_dob = b3

*mor_wln				Woman line number in HH to match child with mother (original)
    g mor_wln = v003

*mor_ali				Child still alive (1/0)
  ge mnths_born_bef_int = v008 - b3 /* months born before interview  */
	clonevar mor_ali =  b5

*mor_ade				Child age at death in months
    g mor_ade = b7
	replace mor_ade = . if b13!=0

  ge age_alive_mnths = mnths_born_bef_int
  ge time = mor_ade
	replace time = age_alive_mnths if mor_ali==0
	replace time = 0 if time<0

*mor_afl				Child age at death imputation flag
      gen mor_afl = b13

*hm_birthorder: Birth order
	gen hm_birthorder = bord

*c_magebrt: Mother's age at birth [DW - NOV2021]
if ~inlist(name,"Philippines2017","Afghanistan2015","Colombia2015","Indonesia2017") {
	gen c_magebrt = v012 - round(hw1/12)
}
else if inlist(name,"Philippines2017","Colombia2015","Indonesia2017") {
	gen c_magebrt = v012 - round(b19/12)
}
else if inlist(name,"Afghanistan2015","Liberia2019") {
	gen c_magebrt = v012 - round(b8)
}



