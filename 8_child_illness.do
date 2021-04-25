**************************
*** Child illness ********
**************************
/*Note:
The structure of generatin disease-treatment variables (c_treatARI, c_treatARI2, c_diarrhea_pro, c_fevertreat,  )
is cited from Aline's Github: https://github.com/wengxyu1030/DHS-Recode-VI/blob/master/8_child_illness.do
*/
* ARI
* c_ari	Children under 5 with cough and rapid breathing in the two weeks preceding the survey which originated from the chest.
  g c_ari = (h31b==1 & inlist(h31c,1,3) & inlist(h31,1,2)) if h31b<8 & h31c<8 & h31<8

*c_ari2	 Children under 5 with cough and rapid breathing in the two weeks preceding the survey.
  gen ccough=(h31  ==1|h31  ==2)  if h31<8

  gen c_ari2=(h31b == 1 & ccough == 1) if  h31b<8 & ccough <2

* c_treatARI/c_treatARI2	   Child with acute respiratory infection (ARI) /ARI2 symptoms seen by formal provider
* Cited from Aline's code
gen c_treatARI= 0 if c_ari == 1
gen c_treatARI2= 0 if c_ari2 == 1

order h32a-h32x,sequential
foreach var of varlist h32a-h32x {
local lab: variable label `var'
  replace `var' = . if regexm("`lab'","( other|shop|pharmacy|market|kiosk|relative|friend|church|drug|addo|rescuer|trad|unqualified|stand|cabinet|ayush|^na)") ///
& !regexm("`lab'","(ngo|hospital|medical center|worker)")
replace `var' = . if !inlist(`var',0,1)
}
/* do not consider formal if contain words in
the first group but don't contain any words in the second group */
  egen pro_ari = rowtotal(h32a-h32x),mi

foreach var of varlist c_treatARI c_treatARI2 {
  replace `var' = 1 if `var' == 0 & pro_ari >= 1
  replace `var'  = . if pro_ari == .
}

if inlist(name,"Senegal2014","Senegal2012","Senegal2015"){  //For v000 == SN6, there's category don't show in label but back to survey.
 global h32 "h32a h32b h32c h32d h32e h32g h32h h32j h32l h32m h32n h32p h32q"
}
if inlist(name,"Senegal2010") {
             global h32 "h32a h32b h32c h32d h32e h32j h32l h32m h32n"
}
foreach var in $h32 {
 replace c_treatARI = 1 if c_treatARI == 0 & `var' == 1
 replace c_treatARI = . if `var' == .

 replace c_treatARI2 = 1 if c_treatARI2 == 0 & `var' == 1
 replace c_treatARI2 = . if `var' == .
}

/*
if inlist(name,"Uganda2016") {
  global h32 "h32a h32b h32c h32d h32j h32l h32m h32n"

}
foreach var in $h32 {
  replace c_treatARI = 1 if c_treatARI == 0 & `var' == 1
  replace c_treatARI = . if `var' == 8
  replace c_treatARI2 = 1 if c_treatARI2 == 0 & `var' == 1
  replace c_treatARI2 = . if `var' == 8
}
*/

* Diarrhea
* c_diarrhea Child with diarrhea in last 2 weeks
  g c_diarrhea = inlist(h11,1,2) if h11 <8

* c_diarrhea_hmf	Child with diarrhea received recommended home-made fluids
  g c_diarrhea_hmf = inlist(h14,1,2) if h14 < 8 & c_diarrhea == 1

* c_treatdiarrhea Child with diarrhea receive oral rehydration salts (ORS)
  cap gen h13b  =.
  g c_treatdiarrhea = (inlist(h13,1,2) | h13b ==1) if c_diarrhea ==1 & (h13 <8 | h13b <8)

* c_diarrhea_pro	The treatment was provided by a formal provider (all public provider except other public, pharmacy, and private sector)
  gen c_diarrhea_pro = 0 if c_diarrhea == 1
* Cited from Aline's Code
  order h12a-h12x,sequential
  foreach var of varlist h12a-h12x {
    local lab: variable label `var'
      replace `var' = . if regexm("`lab'","( other|shop|pharmacy|market|kiosk|relative|friend|church|drug|addo|rescuer|trad|unqualified|stand|cabinet|ayush|^na)") ///
    & !regexm("`lab'","(ngo|hospital|medical center|worker)")
    replace `var' = . if !inlist(`var',0,1)
  }

  egen pro_dia = rowtotal(h12a-h12x),mi
  replace c_diarrhea_pro = 1 if c_diarrhea_pro == 0 & pro_dia >= 1
  replace c_diarrhea_pro = . if pro_dia == .

  /*for countries below there are categories that identified as formal provider but not shown in the label*/
  if inlist(name,"Senegal2014","Senegal2012","Senegal2015"){
    foreach x in a b c d e g h j l m n p q {
     replace c_diarrhea_pro=1 if c_diarrhea==1 & h12`x'==1
     replace c_diarrhea_pro=. if c_diarrhea==1 & h12`x'==9
    }
  }

  if inlist(name,"Senegal2010") {
    foreach x in a b c d e j l m n {
      replace c_diarrhea_pro=1 if c_diarrhea==1 & h12`x'==1
      replace c_diarrhea_pro=. if c_diarrhea==1 & h12`x'==9
    }
  }
/*
  if inlist(name,"Afghanistan2015") {
    global h12 "h12a h12b h12c h12d h12e h12f h12g h12j h12l h12s h12t h12w"
  }
  if inlist(name,"Myanmar2015") {
    global h12 "h12a h12b h12c h12d h12e h12f h12g h12j h12l h12m  h12p h12q h12r h12v"
  }       // include public traditional medical clinic(h12g), however exclue private traditional medical clinic(h12n)
  if inlist(name,"Angola2015") {
    global h12 "h12a h12b h12c h12d h12e h12j h12m"
  }
  if inlist(name,"Ethiopia2016") {
    global h12 "h12a h12b h12c h12d h12e h12f h12g h12j h12l h12m h12w"
  }
  if inlist(name,"Malawi2015") {
    global h12 "h12a h12b h12c h12d h12e h12j h12l h12m h12n h12o h12p h12q"
  }
  if inlist(name,"Armenia2015") {
    global h12 "h12a h12e h12f h12l"
  }
  if inlist(name,"Tanzania2015") {
    global h12 "h12a h12b h12c h12d h12e h12f h12g h12h h12j h12l h12m h12n h12o h12p h12q h12t h12u"
  }
  if inlist(name,"Albania2017") {
    global h12 "h12a h12b h12c h12d h12f h12g h12h h12j h12l h12n h12o h12p h12q "
  }
  if inlist(name,"Nepal2016") {
    global h12 "h12a h12b h12c h12d h12e h12g h12h h12j h12l h12n h12o h12p h12q "
  }

  if inlist(name,"Uganda2016") {
    global h12 "h12a h12b h12c h12d h12j h12l h12m h12n"
  }
  foreach var in $h12 {
    replace c_diarrhea_pro = 1 if c_diarrhea_pro == 0 & `var' == 1
    replace c_diarrhea_pro = . if `var' == 8
  }
*/

*c_diarrhea_med	Child with diarrhea received any medicine other than ORS or hmf
  recode h12z h15 h15a h15b h15c h15d h15e h15f h15g h15h h15i (8=.)
  egen med =rowtotal(h12z h15 h15a h15b h15c h15d h15e h15f h15g h15h h15i),mi
  gen c_diarrhea_med = ( med !=0) if c_diarrhea == 1   // formal medicine don't include "home remedy, herbal medicine and other"
  replace c_diarrhea_med = . if h12z+h15+h15a+h15b+h15c+h15d+h15e+h15f+h15g+h15h+h15i==.

* c_diarrhea_medfor Get formal medicine except (ors hmf home other_med).
  recode h12z h15 h15a h15b h15c h15e h15g h15h h15i (8=.)
  egen medfor =rowtotal(h12z h15 h15a h15b h15c h15e h15g h15h h15i),mi
  gen c_diarrhea_medfor = ( medfor !=0) if c_diarrhea == 1   // formal medicine don't include "home remedy, herbal medicine and other"
  replace c_diarrhea_medfor = . if h12z+h15+h15a+h15b+h15c+h15e+h15g+h15h+h15i == .

*c_diarrhea_mof	Child with diarrhea received more fluids
  gen c_diarrhea_mof = (h38 == 5) if h38<8 & c_diarrhea == 1

* c_diarrheaact	Child with diarrhea seen by provider OR given any form of formal treatment
  gen c_diarrheaact = (c_diarrhea_pro==1 | c_diarrhea_medfor==1 | c_diarrhea_hmf==1 | c_treatdiarrhea==1) if c_diarrhea == 1
  replace c_diarrheaact = . if (c_diarrhea_pro == . | c_diarrhea_medfor == . | c_diarrhea_hmf == . | c_treatdiarrhea == .) & c_diarrhea == 1

* c_diarrheaact_q	Child under 5 with diarrhea in last 2 weeks seen by formal healthcare provider or given any form of treatment who received ORS
  gen c_diarrheaact_q = c_treatdiarrhea  if c_diarrheaact == 1

* Fever
* c_fever	Child with a fever in last two weeks
  g c_fever = h22 == 1  if h22 < 8

* c_fevertreat	Child with fever symptoms seen by formal provider
* Cited from Aline's Code
  if inlist(name,"Senegal2014","Senegal2012","Senegal2015","Senegal2010") {
    gen c_fevertreat = 0 if c_fever == 1
 foreach var in $h32 {
   replace c_fevertreat = 1 if c_fevertreat == 0 & `var' == 1
   replace c_fevertreat = . if `var' == 9
 }
}
if ~inlist(name,"Senegal2014","Senegal2012","Senegal2015","Senegal2010") {
gen c_fevertreat = 0 if c_fever == 1
 replace c_fevertreat = 1 if c_fevertreat == 0 & pro_ari >= 1
 replace c_fevertreat = . if pro_ari == .
}
/*
  foreach var in h32a h32b h32c h32d h32j h32l h32m h32n  {
    replace c_fevertreat = 1 if c_fevertreat == 0 & `var' == 1
    replace c_fevertreat = . if `var' == . | `var' == 8
  }
*/

* Severe Diarrhea
* c_sevdiarrhea	Child with severe diarrhea
  g c_sevdiarrhea = c_diarrhea ==1 & (inlist(h39,0,1,2) | inlist(h38,5) | c_fever ==1 )
  replace c_sevdiarrhea = . if c_diarrhea ==. | (inlist(h39,8,9,.) & inlist(h38,8,9,.) & c_fever ==. )

* c_sevdiarrheatreat	Child with severe diarrhea seen by formal healthcare provider
  gen c_sevdiarrheatreat = (c_sevdiarrhea == 1 & c_diarrhea_pro == 1) if c_sevdiarrhea  == 1 & c_diarrhea_pro != .

* c_sevdiarrheatreat_q	IV (intravenous) treatment of severe diarrhea among children with any formal provider visits
  gen iv = (h15c == 1) if h15c<8 & c_diarrhea == 1
  gen c_sevdiarrheatreat_q = (iv ==1 ) if c_sevdiarrheatreat == 1

* Illness
* c_illness	Child with any illness symptoms in last two weeks
  g c_illness = (c_ari==1 | c_diarrhea==1 | c_fever==1) if (c_ari+c_diarrhea+c_fever!=.)
  g c_illness2 = (c_diarrhea == 1 | c_ari2 == 1 | c_fever == 1) if (c_ari2+c_diarrhea+c_fever!=.)

* c_illtreat	Child with any illness symptoms taken to formal provider
  gen c_illtreat = (c_fevertreat == 1 | c_diarrhea_pro == 1 | c_treatARI == 1) if c_illness == 1 & (c_fevertreat+c_diarrhea_pro+c_treatARI !=.)
  gen c_illtreat2 = (c_fevertreat == 1 | c_diarrhea_pro == 1 | c_treatARI == 1) if c_illness2 == 1 & (c_fevertreat+c_diarrhea_pro+c_treatARI !=.)
