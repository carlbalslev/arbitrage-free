function [res_fix, res_t] = propagate_model(s0, period, model)
				#  
				# Propagate asset with some model.
				# 
				# input: s0, period, model
				# output: s1, t1
				#
				# s1 is vector
  
				# a hardcoded tlist ...
  
				# extract model parameters
  pars = model.pars;
  switch (model.mname) 
    case "blackscholes"
      r = pars.r;
      sigma = pars.sigma;
    case "sabr"
      alpha = pars.alpha;
      beta = pars.beta;
      rho = pars.rho;
      nu = pars.nu;
    otherwise
      error ( "model not recognised");
  endswitch
  
				# extract numnerical parameters
  npaths = model.numerical.npaths;
  dt = model.numerical.max_dt; % ignored

  nmax = 2; % single step only
  t0=period.tstart;
  t_end=period.tend;  
  dt = (t_end - t0) / (nmax-1);
				# generate pseudorandom numbers  
  dw = normrnd(0,1,[npaths,1]);
				# init
  sn = s0;
  tn = t0;

  % large-step propagation
  sn1 = black_scholes(sn, dt, r, sigma, dw);  
  res_fix = sn1;
  res_t = t_end;
  
  return
  
  
