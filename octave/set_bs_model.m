function [model, period] = set_bs_model(mtype, s0, t0,t1,r,sigma,n_mc)
				#
				# input: mtype, s0, t0,t1,r,sigma,n_mc
				# output: model, period
				#
				# where mtype is in {mc, mc-lsm, pde}

  switch mtype
    case {"mc","mc-lsm", "pde"}
      numerical.mtype = mtype;
    otherwise
      error(["Numerical scheme ",mtype," not supported!"])
  endswitch
	 
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
  
