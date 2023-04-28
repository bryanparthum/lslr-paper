** estimate the relationship between household characteristics and participation in lslr program
 
 ** up one directory from the code
cd ..

** import data, sensitive and censored from repository
use data/lsl_program_data.dta, clear 
 
** make globals for regressions
global X tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value yr_built_1950below yr_built_1951_60 assessor_missing shr_black shr_hisp shr_under5 shr_65over shr_college shr_belowpoverty

global X_suburb suburb tww_outreach_num_suburb inactive_ever_suburb publicLSL_suburb moratorium_most_suburb owner_occup_alt_suburb multi_unit_suburb ln_value_suburb yr_built_1950below_suburb yr_built_1951_60_suburb assessor_missing_suburb shr_black_suburb shr_hisp_suburb shr_under5_suburb shr_65over_suburb shr_college_suburb shr_belowpoverty_suburb

** create a second set of global excluding year built variables for use in LSLR regressions
global X2 tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value assessor_missing shr_black shr_hisp shr_under5 shr_65over shr_college shr_belowpoverty

global X2_suburb suburb tww_outreach_num_suburb inactive_ever_suburb publicLSL_suburb moratorium_most_suburb owner_occup_alt_suburb multi_unit_suburb ln_value_suburb assessor_missing_suburb shr_black_suburb shr_hisp_suburb shr_under5_suburb shr_65over_suburb shr_college_suburb shr_belowpoverty_suburb



******************************************
** OLS regressions (linear probability model)  separate models for urban and suburban areas 
******************************************

** registration equation - urban
reg registered_2022_07 $X if suburb==0, vce(r)
outreg2 using "regression_results\observational_regs_urban", replace word ctitle("Registered, ITT") dec(3)

** contractor inspection equation - urban
reg inspection_contractor_2022_07 $X if suburb==0, vce(r) 
outreg2 using "regression_results\observational_regs_urban", append word ctitle("Inspection, ITT") dec(3)

** LSLR equation - urban
reg LSLR_2022_07 $X2 if suburb==0 & privateLSL==1, vce(r) 
outreg2 using "regression_results\observational_regs_urban", append word ctitle("LSLR, ITT") dec(3)

** registration equation - suburban
reg registered_2022_07 $X if suburb==1, vce(r)
outreg2 using "regression_results\observational_regs_suburban", replace word ctitle("Registered, ITT") dec(3)

** contractor inspection equation - suburban
reg inspection_contractor_2022_07 $X if suburb==1, vce(r) 
outreg2 using "regression_results\observational_regs_suburban", append word ctitle("Inspection, ITT") dec(3)

** LSLR equation - suburban
reg LSLR_2022_07 $X2 if suburb==1 & privateLSL==1, vce(r) 
outreg2 using "regression_results\observational_regs_suburban", append word ctitle("LSLR, ITT") dec(3)



******************************************
** appendix: Pooled model including both city and suburbs, with suburb interaction terms to test for differential effects
******************************************

** registration equation -
reg registered_2022_07 $X $X_suburb, vce(r)
outreg2 using "regression_results\observational_regs_combo", replace word ctitle("Registered, ITT") dec(3)

** contractor inspection equation 
reg inspection_contractor_2022_07 $X $X_suburb, vce(r) 
outreg2 using "regression_results\observational_regs_combo", append word ctitle("Inspection, ITT") dec(3)

** LSLR equation 
reg LSLR_2022_07 $X2 $X2_suburb if privateLSL==1, vce(r) 
outreg2 using "regression_results\observational_regs_combo", append word ctitle("LSLR, ITT") dec(3)

** end of script, have a great day! 