
global root "C:\Users\wb500886\WBG\Sven Neelsen - World Bank\MEASURE UHC DATA"

* Define path for data sources
global SOURCE "${root}/RAW DATA/Recode VI"

* Define path for output data
global OUT "${root}/STATA/DATA/SC/FINAL"

* Define path for INTERMEDIATE
global INTER "${root}/STATA/DATA/SC/INTER"

* Define path for do-files
global DO "${root}/STATA/DO/SC/DHS/Recode VI"

use "${SOURCE}/external/hefpi_full_database",clear
keep if survey_list == "DHS"

tostring(year),replace
gen surveyid = iso2c+year+"DHS"

rename (indic pop )(varname_my value_hefpi)
replace value_hefpi = value_hefpi*100

replace varname_my = "c_measles" if varname_my == "c_measles_vacc"
replace varname_my = "w_papsmear" if varname_my == "w_pap_3y"
replace varname_my = "w_mammogram" if varname_my == "w_mam_2y"
replace varname_my = "a_bp_meas" if varname_my == "a_bp_meas_1yr"

save "${SOURCE}/external/HEFPI_DHS",replace
