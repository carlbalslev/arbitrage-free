function [res_fix, res_t] = propagate_model(s0, period, model)
				#  
				# Propagate asset with some model.
				# 
				# input: s0, period, model
				# output: s1, t1
				#
  
				# a hardcoded tlist ...
  nmax = 3;
  clear('res_list');
  t0=period.tstart;
  t_end=period.tend;
  
  dt = (t_end - t0) / (nmax-1);
  tlist = t0:dt:t_end;

  
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
				# never mind
  
  
				# generate pseudorandom numbers  
  dw_list = normrnd(0,1,[1,nmax]);
				# init
  sn = s0;
  tn = tlist(1);
  slist(1)=sn;
  
  for n=2:nmax
     tn1 = tlist(n);
     dt = tn1 - tn;
     tn = tn1;
     dw = dw_list(n);
     sn1 = black_scholes(sn, dt, r, sigma, dw);
     slist(n) = sn1;
     sn = sn1;
  endfor
  res_fix = sn;
  res_t = tn;
  
  return
  
  
