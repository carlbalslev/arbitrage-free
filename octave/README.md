# octave library

straight-forward, old-fashioned, non-generic implementation of basic pricing algorithms.

* numerics: vanilla MC, LSM-MC, PDE
* models: bs, sabr, hw, hw2f, quasi-gaussian, lmm-sabr 


## data structures

*model*

mname = string % example: "ou", "hw", "sabr", "hw2f" (a variant would be nice)

pars = struct % model parameters, example: r, sigma for scalar OU. 

numerical = struct % parameters relevant for numerical solution. Format is *dt, *npaths

*state*

t = float list % asset price(s) at t

hist = float list list % asset price(s) at 0,..,t-1

*interval*

tstart = float % period start 

tend = float % period end

*contract*

cname = string : name of payout, for example "vanilla call"

characteristics = struct: name dependent struct. For example for call it contains strike, fix date, pay date 


##Main functions

*val propagate_model* : interval * state * model -> state % propagate asset(s) on an interval, i.e. from t0 to t1, with defined model.  

*val dates_from_contract* : contract -> (fix dates, pay dates)
