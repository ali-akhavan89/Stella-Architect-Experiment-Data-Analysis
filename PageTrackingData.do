
clear 

//you need to specify the folder where the data file is located
cd "/Users/Ali/Library/CloudStorage/OneDrive-USI/CPR Exp 3/Data/Survey Data" 

//you need to change the path for the page-tracking-data file
import delimited "/Users/Ali/Library/CloudStorage/OneDrive-USI/CPR Exp 3/Data/Survey Data/page-tracking-data.csv"



drop arrivaltimeepoch 
drop useremail 
rename durationsec duration

gen StartPage=0
gen SurveyPage=0
gen SurveyErrorPage=0
gen HelpPage1=0
gen HelpPage2=0
gen HelpPage3=0
gen HelpPage4=0
gen HelpPage5=0
gen HelpPageDuringTest=0
gen TestPage=0
gen QualifiedPage=0
gen NotQualifiedPage=0


local N = _N
forvalues i=1/`N' {
	replace StartPage = duration[`i'] in `i' if page=="Start"
	replace SurveyPage = duration[`i'] in `i' if page=="Survey Page"
	replace SurveyErrorPage = duration[`i'] in `i' if page=="Survey Error Page"
	replace HelpPage1 = duration[`i'] in `i' if page=="Help Page 1"
	replace HelpPage2 = duration[`i'] in `i' if page=="Help Page 2"
	replace HelpPage3 = duration[`i'] in `i' if page=="Help Page 3"
	replace HelpPage4 = duration[`i'] in `i' if page=="Help Page 4"
	replace HelpPage5 = duration[`i'] in `i' if page=="Help Page 5"
	replace HelpPageDuringTest = duration[`i'] in `i' if page=="Help Page During Test"
	replace TestPage = duration[`i'] in `i' if page=="Qualification Test Page"
	replace QualifiedPage = duration[`i'] in `i' if page=="Qualified Page"
	replace NotQualifiedPage = duration[`i'] in `i' if page=="Not Qualified Page"
}

drop page
drop duration
rename useridentifier UserStellaID


replace UserStellaID = UserStellaID[_n-1] if missing(UserStellaID)
ds UserStellaID, not
local variables `r(varlist)'
foreach v of varlist `variables' {
    by UserStellaID (`v'), sort: replace `v' = `v' if !missing(`v') & _n != _N
    by UserStellaID (`v'), sort: replace `v' = `v'[_n-1] + `v' if _n > 1
    by UserStellaID: replace `v' = `v'[_N]
}
by UserStellaID: keep if _n == _N


gen Duration = 0
local N = _N
forvalues i=1/`N' {
		replace Duration = HelpPage1[`i'] + HelpPage2[`i'] + HelpPage3[`i'] + HelpPage4[`i'] + HelpPage5[`i'] + HelpPageDuringTest[`i'] + TestPage[`i'] in `i' 
}

drop if Duration == 0

/*
gen Duration = 0
local N = _N
forvalues i=1/`N' {
		replace Duration = StartPage[`i'] + SurveyPage[`i'] + SurveyErrorPage[`i'] + HelpPage1[`i'] + HelpPage2[`i'] + HelpPage3[`i'] + HelpPage4[`i'] + HelpPage5[`i'] + HelpPageDuringTest[`i'] + TestPage[`i'] + QualifiedPage[`i'] + NotQualifiedPage[`i'] in `i' 
}
*/

save TrackingData, replace

