cap log close

local rho1 = 0

cap log close

log using "${path}unbalanced.log", replace

set more off

tempname simulation

tempname simulation

postfile simulation estimator replication ytlag_coef x1_coef   cons_coef using "${path}wooldridge-weakly-balanced.dta", replace

quietly{

forvalues num = 1/1000{

noisily display `num'



clear

use	"${path}data`num'", clear

drop if year >= 6 & idcode < 500

noisily xtprobit y ylag x1 x1m ic  , i(idcode)

post simulation (4) (`num') (_b[ylag]) (_b[x1])	 	(_b[_cons]) 	


}


}

postclose simulation

log close


