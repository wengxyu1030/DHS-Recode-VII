
********************************
*** Woman anthropometrics*******
********************************

*w_bmi_1549	15-49y woman's BMI
	foreach var of varlist v437 v438 {
	replace `var'=. if `var'>=9994
	}
	replace v437=v437/10
	replace v438=v438/1000

	replace v437=. if v437>250
	replace v438=. if v438>2.50

	gen w_bmi_1549=v437/(v438)^2

	gen wunderweight=(w_bmi_1549<18.5) if w_bmi_1549!=.

	gen wnormal_weight=(w_bmi_1549>=18.5 & w_bmi_1549<25) if w_bmi_1549!=.

*w_overweight_1549	15-49 woman's BMI>25 (1/0)
	gen w_overweight_1549=w_bmi_1549>=25 if w_bmi_1549!=.

*w_obese_1549	15-49y woman's BMI>=30 (1/0)
	gen w_obese_1549=w_bmi_1549>=30 if w_bmi_1549!=.

*w_height_1549	15-49y woman's height in meters
	rename v438 w_height_1549

*wm_sampleweight sample weight for individual woman
    gen w_sampleweight = v005/10e6

***********compare
