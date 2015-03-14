function [model, period] = set_bs_model(s0, t0,t1,r,sigma)
				#
				# 
  period.tstart = t0;
  period.tend = t1;

  pars.r = r
  pars.sigma = sigma;

  model.mname = "blackscholes";
  model.pars = pars;
  model.numerical = [0,0];
  
  return
  
  
