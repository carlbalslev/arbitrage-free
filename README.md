# arbitrage-free
#
# Collection of octave functions for simple monte carlo simulation of arbitrage free models
# 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Some common data structures:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model:
*name = string % example: "ou", "hw", "sabr", "hw2f" (a variant would be nice)
*pars = float list % model parameters, example: r, sigma for scalar OU. 
*numerical = float list % list of parameters relevant for numerical solution. First is dt.

state:
*t = float list % asset price(s) at t
*hist = float list list % asset price(s) at 0,..,t-1

interval:
*tstart = float % period start 
*tend = float % period end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Main functions:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
val propagate_model : interval * state * model -> state
% propagate asset(s) on an interval, i.e. from t0 to t1, with defined model.  


