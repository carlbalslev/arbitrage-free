function [model, period] = set_bs_model(s0, t0,t1,r,sigma,n_mc)
				#
				# input: s0, t0,t1,r,sigma,n_mc
				# output: model, period
				#
  period.tstart = t0;
  period.tend = t1;

  pars.r = r;
  pars.sigma = sigma;

  model.mname = "blackscholes";
  model.pars = pars;

  numerical.max_dt = 0.0; % 0 means adaptive 
  numerical.npaths = n_mc; % number of paths
  model.numerical = numerical;
  
  return
  
