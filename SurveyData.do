
clear

//you may need to install some of the packages below:
//ssc install filelist


//You need to specify the folder where the data file is located

//Because survey data may be gathered in different episodes, you can put all folders containing the survey data each with the same csv filename in a parent folder. Put data folders separately.

//If you have gathered multiplayer data on Stella, you may need to remove Multiplayer Team Info.csv from the data folder. 

//You should run the page-tracking-data code separately. The page-tracking-data.csv comes from downloading the page tracing data on exchange platform provided by iseesystems

cd "/Users/Ali/Library/CloudStorage/OneDrive-USI/CPR Exp 3/Data/Survey Data/All Data" 


//Lists all the CSV files within subfolders and save it to the csv_datasets.dta
filelist, pat("*.csv") save("csv_datasets.dta") replace

//reading all csv files and temporarily save them as datasets
use "csv_datasets.dta", clear

local obs = _N
forvalues i=1/`obs' {
	use "csv_datasets.dta" in `i', clear
	local f = dirname + "/" + filename
	local name = subinstr(filename,".csv","",.)
	insheet using "`f'", clear
	drop v1
	drop if _n!=3 & _n!=10
	sxpose, clear
	rename _var1 UserStellaID
	rename _var2 `name'
	sort UserStellaID
	quietly by UserStellaID:  gen dup = cond(_N==1,0,_n)
	drop if dup>1
	drop dup	
	tempfile save`i'
	save "`save`i''"
}

//Merging all temporarily saved datasets

use "`save1'", clear
forvalues i=2/`obs' {
	merge 1:1 UserStellaID using "`save`i''", nogenerate update
}


//Saving the dataset in the main directory 
cd "/Users/Ali/Library/CloudStorage/OneDrive-USI/CPR Exp 3/Data/Survey Data/" 
save master, replace 



gen str Age="0"
replace Age="Under 18" if SQ11AgeUnder18=="1"
replace Age="18 - 24" if SQ12Age18To24=="1"
replace Age="25 - 34" if SQ13Age25To34=="1"
replace Age="35 - 44" if SQ14Age35To44=="1"
replace Age="45 - 54" if SQ15Age45To54=="1"
replace Age="55 - 64" if SQ16Age55To64=="1"
replace Age="65 - 74" if SQ17Age65To74=="1"
replace Age="75 - 84" if SQ18Age75To84=="1"
replace Age="85 or Older" if SQ19Age85OrOlder=="1"


gen str Gender="Female"
replace Gender="Male" if SQ21Male=="1"

gen str Education="0"
replace	Education="Less than High School" if SQ31LessThanHighSchool=="1"
replace Education="High School Graduate" if SQ32HighSchoolGraduate=="1"
replace Education="Some College" if SQ33SomeCollege=="1"
replace Education="4-year Degree" if SQ34FourYearDegree=="1"
replace Education="Professional Degree" if SQ35ProfessionalDegree=="1"
replace Education="Doctorate" if SQ36Doctorate=="1"

gen str Experience="0" 
replace Experience="None" if SQ41None=="1"
replace Experience="Less than 1 Year" if SQ42LessThanOneYear=="1"
replace Experience="1-3 Years" if SQ43OneToThreeYears=="1"
replace Experience="3-6 Years" if SQ44ThreeToSixYears=="1"
replace Experience="More than 6 years" if SQ45MoreThanSixYears=="1"

gen str Employment="0"
replace Employment="Student" if SQ51Student=="1"
replace Employment="Homemaker" if SQ52Homemaker=="1"
replace Employment="Retired" if SQ53Retired=="1"
replace Employment="Unemployed" if SQ54Unemployed=="1"
replace Employment="Working part-time" if SQ55WorkingPartTime=="1"
replace Employment="Working full-time" if SQ56WorkingFullTime=="1"

gen str Income="0"
replace Income="Under $10,000" if SQ61Under10K=="1"
replace Income="$10,000-$20,000" if SQ62From10KTo20K=="1"
replace Income="$20,000-$30,000" if SQ63From20KTo30K=="1" 
replace Income="$30,000-$45,000" if SQ64From30KTo45K=="1"
replace Income="$45,000-$60,000" if SQ65From45KTo60K=="1"
replace Income="$60,000-$80,000" if SQ66From60KTo80K=="1"
replace Income="$80,000-$120,000" if SQ67From80KTo120K=="1"
replace Income="Over $120,000" if SQ68Over120K=="1"



//code for calculations

gen AgeC=0
replace AgeC=0 if Age=="Under 18"
replace AgeC=21 if Age=="18 - 24"
replace AgeC=29.5 if Age=="25 - 34"
replace AgeC=39.5 if Age=="35 - 44"
replace AgeC=49.5 if Age=="45 - 54"
replace AgeC=59.5 if Age=="55 - 64"
replace AgeC=69.5 if Age=="65 - 74"
replace AgeC=85 if Age=="85 or Older"

gen Female=0
replace Female=1 if Gender=="Female" 

gen EducationC=0
replace EducationC=0 if Education=="Less than High School"
replace EducationC=0 if Education=="High School Graduate"
replace EducationC=1 if Education=="Some College"
replace EducationC=2 if Education=="4-year Degree"
replace EducationC=3 if Education=="Professional Degree"
replace EducationC=4 if Education=="Doctorate"


gen ExperienceC=0
replace ExperienceC=0 if Experience=="None"
replace ExperienceC=0.5 if Experience=="Less than 1 Year"
replace ExperienceC=2 if Experience=="1-3 Years"
replace ExperienceC=4.5 if Experience=="3-6 Years"
replace ExperienceC=6 if Experience=="More than 6 years"

gen EmploymentC=0
replace EmploymentC=1 if Employment=="Student"
replace EmploymentC=2 if Employment=="Homemaker"
replace EmploymentC=3 if Employment=="Retired"
replace EmploymentC=4 if Employment=="Unemployed"
replace EmploymentC=5 if Employment=="Working part-time"
replace EmploymentC=6 if Employment=="Working full-time"

gen IncomeC=0
replace IncomeC=0 if Income=="Under $10,000"
replace IncomeC=1 if Income=="$10,000-$20,000"
replace IncomeC=2 if Income=="$20,000-$30,000"
replace IncomeC=3 if Income=="$30,000-$45,000"
replace IncomeC=4 if Income=="$45,000-$60,000"
replace IncomeC=5 if Income=="$60,000-$80,000"
replace IncomeC=6 if Income=="$80,000-$120,000"
replace IncomeC=7 if Income=="Over $120,000"


//removing all Stella generated codes

/* */
drop SQ11AgeUnder18 SQ18Age75To84 SQ17Age65To74 SQ19Age85OrOlder SQ12Age18To24 SQ14Age35To44 SQ15Age45To54 SQ13Age25To34 SQ16Age55To64
drop SQ22Female SQ21Male
drop SQ31LessThanHighSchool SQ35ProfessionalDegree SQ33SomeCollege SQ32HighSchoolGraduate SQ34FourYearDegree SQ36Doctorate
drop SQ41None SQ45MoreThanSixYears SQ43OneToThreeYears SQ44ThreeToSixYears SQ42LessThanOneYear
drop SQ52Homemaker SQ54Unemployed SQ51Student SQ56WorkingFullTime SQ53Retired SQ55WorkingPartTime
drop SQ66From60KTo80K SQ67From80KTo120K SQ62From10KTo20K SQ61Under10K SQ63From20KTo30K SQ65From45KTo60K SQ68Over120K SQ64From30KTo45K


//cleaning the data

destring UserIDCode, replace
destring UserFinalScore, replace
destring UserQualified, replace

rename UserIDCode UserID
rename UserFinalScore FinalScore
rename UserQualified Qualified


//removing the answers to the qualification test

/*

drop TQ8416Player TQ22Orchards TQ44OrchardsSell TQ72No TQ51Price TQ92No TQ71Yes TQ31LessThan6Years TQ23OrchardsCosts TQ41Temperature TQ6220Years TQ824Player TQ811Player TQ6110Years TQ54Production TQ53Profit TQ26WaterCosts TQ52Demand TQ12Profits TQ24Production TQ42OrchardsGrowth TQ33Between15To19Years TQ25Groundwater TQ32Between10To14Years TQ43Demand TQ45Price TQ11Orchards TQ6330Years TQ91Yes TQ838Player TQ6440Years TQ21Profits TQ13Groundwater TQ34Between20To24Years

*/







save master, replace



//merging with PageTracking Data 
//save the master file where the PageTracking Data is located 

//enable these




cd "/Users/Ali/Library/CloudStorage/OneDrive-USI/CPR Exp 3/Data/Survey Data/"
save master, replace
merge 1:1 UserStellaID using "/Users/Ali/Work/Research/CPR Exp/Data/Survey Data/TrackingData.dta", keep(match) nogenerate




//regression analysis


//drop if AgeC==0
//drop if EmploymentC==0

drop if Income=="0"
drop if Experience=="0"
drop if Education=="0"


tab FinalScore Qualified



tab Employment, gen(EmpD)


rename EmpD1 EmpHomemaker
rename EmpD2 EmpRetired
rename EmpD3 EmpStudent
rename EmpD4 EmpUnemployed
rename EmpD5 EmpFullTime
rename EmpD6 EmpPartTime


tab Education, gen(EduD)
rename EduD1 FlCl
rename EduD2 PhD
rename EduD3 HiSc
rename EduD4 LeHi
rename EduD5 Prfl
rename EduD6 SmCl


tab Experience, gen(ExpD)
rename ExpD1 OneToThree
rename ExpD2 ThreeToSix
rename ExpD3 LessThanOne
rename ExpD4 MoreThanSix
rename ExpD5 None



tab Age
tab Gender
tab Education
tab Experience
tab Employment
tab Income
tab Qualified


gen EducationC_x = EducationC^5
gen ExperienceC_x = ExperienceC^5

logit Qualified Duration AgeC Female IncomeC EducationC_x EmploymentC ExperienceC_x 
regress FinalScore Duration AgeC Female IncomeC EducationC_x EmploymentC ExperienceC_x


//logit Qualified Duration AgeC Female ExperienceC IncomeC EmpHomemaker EmpRetired EmpStudent EmpUnemployed EmpFullTime EmpPartTime FlCl PhD HiSc LeHi Prfl SmCl 

//regress FinalScore Duration AgeC Female ExperienceC IncomeC EmpHomemaker EmpRetired EmpStudent EmpUnemployed EmpFullTime EmpPartTime FlCl PhD HiSc LeHi Prfl SmCl





/*

//logit Qualified Duration AgeC Female ExperienceC IncomeC EmpHomemaker EmpRetired EmpStudent EmpUnemployed EmpFullTime EmpPartTime FlCl PhD HiSc LeHi Prfl SmCl 

//logit Qualified TestPage AgeC Female ExperienceC IncomeC EmpHomemaker EmpRetired EmpStudent EmpUnemployed EmpFullTime EmpPartTime FlCl PhD HiSc LeHi Prfl SmCl

//regress FinalScore Duration AgeC Female ExperienceC IncomeC EmpHomemaker EmpRetired EmpStudent EmpUnemployed EmpFullTime EmpPartTime FlCl PhD HiSc LeHi Prfl SmCl

//regress FinalScore TestPage AgeC Female ExperienceC IncomeC EmpHomemaker EmpRetired EmpStudent EmpUnemployed EmpFullTime EmpPartTime FlCl PhD HiSc LeHi Prfl SmCl 

logit Qualified Duration AgeC Female ExperienceC IncomeC EducationC EmpHomemaker EmpRetired EmpStudent EmpUnemployed EmpFullTime EmpPartTime 

logit Qualified Duration AgeC Female ExperienceC IncomeC EducationC EmploymentC

logit Qualified Duration AgeC Female IncomeC EmpHomemaker EmpRetired EmpStudent EmpUnemployed EmpFullTime EmpPartTime FlCl PhD HiSc LeHi Prfl SmCl OneToThree ThreeToSix LessThanOne MoreThanSix None
*/
