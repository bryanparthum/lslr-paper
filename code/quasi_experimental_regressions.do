** conduct a quasi-experimental/DiD analysis to assess whether East Trenton Collaborative's LSLR grant program had an effect on LSLR program 

** up one directory from the code
cd ..

******************************************
** create weights
******************************************

** import data for weights, sensitive and censored from repository
use data/quasi_experimental_data_pre_weights.dta, clear

** derive CEM weights for East Trenton quasi-experiment
** need multiple sets of weights becuase of different subsamples used for different outcomes/regressions
** maximum NET_VALUE for residential properties in East Trenton is $103,500. Match on 5 categories. 

** 1st set of CEM weights - full sample 
cem tww_outreach_num(#0) inactive_ever(#0) multi_unit(#0) owner_occup_alt(#0) assessor_missing(#0) publicLSL(#0) moratorium_most(#0) yr_built_1950below(#0) yr_built_1951_60(#0) NET_VALUE(0 1 25 50 75 100 125) if submit_date_unk == 0, treatment(east_trenton) show
rename cem_weights cem_weights1

** 2nd set of CEM weights - restrict sample to properties with private-side LSL 
cem tww_outreach_num(#0) inactive_ever(#0) multi_unit(#0) owner_occup_alt(#0) assessor_missing(#0) publicLSL(#0) moratorium_most(#0) NET_VALUE(0 1 25 50 75 100 125) if privateLSL == 1 & LSLR_date_unk == 0, treatment(east_trenton) show
rename cem_weights cem_weights2


** derive entropy weights for synthetic control
** first get "regular" entropy weights
** full sample for registration/inspection equation
ebalance east_trenton registered_preETCgr inspection_contractor_preETCgr LSLR_preETCgr tww_outreach_num inactive_ever multi_unit owner_occup_alt assessor_missing publicLSL moratorium_most yr_built_1950below yr_built_1951_60 NET_VALUE shr_black shr_under5 shr_65over shr_college shr_belowpoverty if submit_date_unk == 0 & LSLR_date_unk == 0
rename _webal entropy1

** sample with private-side LSL for conditional LSLR equation
ebalance east_trenton registered_preETCgr inspection_contractor_preETCgr LSLR_preETCgr tww_outreach_num inactive_ever multi_unit owner_occup_alt assessor_missing publicLSL moratorium_most yr_built_1950below yr_built_1951_60 NET_VALUE shr_black if privateLSL == 1 & LSLR_date_unk == 0
rename _webal entropy2



******************************************
** quasi-experimental regression anaysis
******************************************

** import data with weights, sensitive and censored from repository
use data/quasi_experimental_data.dta, clear

** make globals for regressions
global X tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value yr_built_1950below yr_built_1951_60 assessor_missing 

global X2 tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value assessor_missing 



******************************************
** outcome 1: Program registration
******************************************

reg registered_did east_trenton after ET_after [w = entropy1], vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_synthcontr", replace word dec(3) ctitle("Registered, SynthContr")


areg registered_did east_trenton after ET_after [w = cem_weights1], absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_cem", replace word dec(3) ctitle("Registered, CEM")

areg registered_did east_trenton after ET_after tww_outreach_num inactive_ever moratorium_most publicLSL yr_built_1950below yr_built_1951_60 owner_occup_alt multi_unit ln_value assessor_missing, absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_nomatching", replace word dec(3) ctitle("Registered, no matching")



******************************************
** outcome 2: Contractor inspections 
******************************************

reg inspection_contractor_did east_trenton after ET_after [w = entropy1], vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_synthcontr", append word dec(3) ctitle("Inspection, SynthContr")

areg inspection_contractor_did east_trenton after ET_after [w = cem_weights1], absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_cem", append word dec(3) ctitle("Inspection, CEM")

areg inspection_contractor_did east_trenton after ET_after tww_outreach_num inactive_ever moratorium_most publicLSL yr_built_1950below yr_built_1951_60 owner_occup_alt multi_unit ln_value assessor_missing, absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_nomatching", append word dec(3) ctitle("Inspection, no matching")



******************************************
** outcome 3a: LSLR completed - conditional on having a contractor-confirmed private LSL
******************************************

reg LSLR_did east_trenton after ET_after if LSLR_date_unk == 0 & privateLSL == 1 [w = entropy2], vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_synthcontr", append word dec(3) ctitle("LSLR, SynthContr")

areg LSLR_did east_trenton after ET_after if LSLR_date_unk == 0 & privateLSL == 1 [w = cem_weights2], absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_cem", append word dec(3) ctitle("LSLR, CEM")

areg LSLR_did east_trenton after ET_after tww_outreach_num inactive_ever moratorium_most publicLSL owner_occup_alt multi_unit ln_value assessor_missing if privateLSL == 1 & LSLR_date_unk == 0, absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_nomatching", append word dec(3) ctitle("LSLR, no matching")



******************************************
** appendix - reestimate the synthetic control model including control variables and BG FEs
******************************************

areg registered_did east_trenton after ET_after tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value yr_built_1950below yr_built_1951_60 assessor_missing [w=entropy1], absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_synthcontrFE", replace word dec(3) ctitle("Registered, SynthContrFE")

areg inspection_contractor_did east_trenton after ET_after tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value yr_built_1950below yr_built_1951_60 assessor_missing [w=entropy1], absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_synthcontrFE", append word dec(3) ctitle("Inspection, SynthContrFE")

areg LSLR_did east_trenton after ET_after tww_outreach_num inactive_ever publicLSL moratorium_most owner_occup_alt multi_unit ln_value assessor_missing [w=entropy2] if privateLSL==1, absorb(BG_id) vce(cluster BG_id)
outreg2 using "regression_results\quasi_experimental_regs_synthcontrFE", append word dec(3) ctitle("LSLR, SynthContrFE")


** end of script, have a great day!