cap log close

local rho1 = 0

log using "${path}data-rho0`rho1'-u-cons-2.log", replace

set more off
set seed 987654321


clear

quietly{

forvalues num = 1/1000{


clear






set obs 1000



generate id=_n

expand 10

by id, sort: generate tper=_n
matrix m = (0,0,0)
matrix sd = (1,1,0)
drawnorm alpha e_i z, n(10000) means(m) sds(sd) 


sort id tper
by id: replace alpha=alpha[1]

sort id (tper)
local theta=1 

sort id (tper)

by id (tper), sort: gen u_i = e_i if _n == 1

by id: gen x1 = rnormal() if _n==1
by id: generate ystar=-0.5*x1 + 0.5*z + 0.5* alpha + u_i if _n==1

by id: generate y=cond(ystar>0,1,0) if _n==1


local rho  = 0.`rho1'
local brho = sqrt(1-(`rho')^2)

sort id (tper)

sort id (tper)
forvalues i=2/10 {
by id (tper), sort: replace x1 		= rnormal() + z if _n==`i'
by id (tper), sort: replace u_i 	= `rho' * u_i[_n-1] + `brho' *  e_i if _n==`i'
by id (tper), sort: replace ystar 	=.5*y[_n-1] + 0 - 0.5*x1 + alpha + u_i if _n==`i'
by id (tper), sort: replace y=cond(ystar>0,1,0) if _n==`i'
}

sort id (tper)
by id: generate ylag=cond(_n>1,y[_n-1],.)
by id: gen u_ilag = u_i[_n-1] 

by id (tper), sort: generate nwave=_N


rename id idcode
rename tper year 

by idcode (year), sort: gen ic = y[1]
by idcode (year): egen x1m = mean(x1) if year >= 2 & year < .


save "${path}data`num'", replace

}


}

log close




