* Please save the files for the simulation in one folder on your computer. Please save the pathname in the following global (between the quotation marks). 


global path		""


cap postclose simulation

do "${path}data-rho00-balanced.do"
do "${path}xtprobit-rho00-balanced.do"
do "${path}wooldridge-rho00-balanced.do"
do "${path}wooldridge-rho00-unbalanced.do"
do "${path}wooldridge-rho00-abschmelzend.do"

use 			"${path}xtprobit-balanced.dta", clear
append using 	"${path}wooldridge-balanced.dta"
append using 	"${path}wooldridge-unbalanced.dta"
append using 	"${path}wooldridge-weakly-balanced.dta"

* The true value for the lagged endogenous coefficient ytlag_coef is 0.5 

* Estimated coefficient of model 1 (Random Effect Probit not controlling for initial conditions):

sum ytlag_coef if estimator == 1

* Estimated coefficient of model 2 (Wooldridge Model on balanced sample):

sum ytlag_coef if estimator == 2

* Estimated coefficient of model 3 (Wooldridge Model on unbalanced sample):

sum ytlag_coef if estimator == 3

* Estimated coefficient of model 4 (Wooldridge Model on weakly unbalanced sample):

sum ytlag_coef if estimator == 4

