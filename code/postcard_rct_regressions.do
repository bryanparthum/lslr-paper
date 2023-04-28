** estimate the effect of randomized postcards on LSLR program registration, inspection and LSLR

** up one directory from the code
cd ..

** import data, sensitive and censored from repository
use data/postcard_rct_data.dta, clear


******************************************
** outcome 1: Program sign-up/registration
******************************************

** intent-to-treat regression
reg registered_did turp_treatment after turp_after, vce(r) 
outreg2 using "regression_results\postcard_rct_regs_ITT", replace word ctitle("Registered, ITT") dec(3)

** IV approach - alternative to "intent to treat" analysis per Sussman & Hayward 2010 BMJ 
ivregress 2sls registered_did after (postcard_turp postcard_after = turp_treatment turp_after), first vce(r)
outreg2 using "regression_results\postcard_rct_regs_IV", replace word ctitle("Registered, IV") dec(3)

** intent-to-treat regression including BG FE and control variables
areg registered_did turp_treatment after turp_after tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value yr_built_1950below yr_built_1951_60 assessor_missing, absorb(BG_id) vce(r) 
outreg2 using "regression_results\postcard_rct_regs_FE", replace word ctitle("Registered, FE") dec(3)



******************************************
** outcome 2: Contractor inspection 
******************************************

** intent-to-treat regression
reg inspection_contractor_did turp_treatment after turp_after, vce(r)
outreg2 using "regression_results\postcard_rct_regs_ITT", append word ctitle("Inspection, ITT") dec(3)

*IV approach 
ivregress 2sls inspection_contractor_did after (postcard_turp postcard_after = turp_treatment turp_after), vce(r)  
outreg2 using "regression_results\postcard_rct_regs_IV", append word ctitle("Inspection, IV") dec(3)

* intent-to-treat regression including BG FE and control variables
areg inspection_contractor_did turp_treatment after turp_after tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value yr_built_1950below yr_built_1951_60 assessor_missing, absorb(BG_id) vce(r) 
outreg2 using "regression_results\postcard_rct_regs_FE", append word ctitle("Inspection, FE") dec(3)



******************************************
** outcome 3a: LSLR completed - conditional on properties having confirmed private LSL
******************************************

*Intent-to-treat regression
reg LSLR_did turp_treatment after turp_after if privateLSL==1, vce(r)
outreg2 using "regression_results\postcard_rct_regs_ITT", append word ctitle("LSLR, ITT") dec(3)

*IV approach 
ivregress 2sls LSLR_did after (postcard_turp postcard_after = turp_treatment turp_after) if privateLSL == 1, vce(r) 
outreg2 using "regression_results\postcard_rct_regs_IV", append word ctitle("LSLR, IV") dec(3)

* intent-to-treat regression including BG FE and control variables
areg LSLR_did turp_treatment after turp_after tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value yr_built_1950below yr_built_1951_60 assessor_missing if privateLSL==1, absorb(BG_id) vce(r) 
outreg2 using "regression_results\postcard_rct_regs_FE", append word ctitle("LSLR, FE") dec(3)




******************************************
** because postcard intervention was English-language only, test whether effectiveness varies by % Hispanic residents
******************************************

gen hisp_after      = after*shr_hisp
gen hisp_turp       = turp_treatment*shr_hisp
gen hisp_after_turp = turp_after*shr_hisp

reg registered_did turp_treatment after turp_after shr_hisp hisp_after hisp_turp hisp_after_turp, vce(r) 
outreg2 using "regression_results\postcard_rct_regs_hisp", replace word ctitle("Registered, ITT") dec(3)

reg inspection_contractor_did turp_treatment after turp_after shr_hisp hisp_after hisp_turp hisp_after_turp, vce(r) 
outreg2 using "regression_results\postcard_rct_regs_hisp", append word ctitle("Inspection, ITT") dec(3)

reg LSLR_did turp_treatment after turp_after shr_hisp hisp_after hisp_turp hisp_after_turp if privateLSL==1, vce(r) 
outreg2 using "regression_results\postcard_rct_regs_hisp", append word ctitle("LSLR, ITT") dec(3)

** end of script, have a great day!