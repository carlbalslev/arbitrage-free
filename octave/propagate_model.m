function res_fix = propagate_model(s0, t_list, model)
				#  
				# Propagate asset with some model.
				# 
				# input: s0, t_list, model
				# output: s_list
				#
				# t_list should contain t0, t1, ..., tN. Include t0.
				# s_list contains s values corresponding to t_list and is also MC-vectorised 
  
  
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
  
				# extract numerical parameters
  npaths = model.numerical.npaths;
  dt = model.numerical.max_dt; # ignored

  nmax = length(t_list); 

  sn = s0*ones(npaths,1);
  s_list(:,1)=sn;
  
  for n=2:nmax,
    dt = t_list(n)-t_list(n-1);   # large-step;    
    dw = normrnd(0,1,[npaths,1]); # generate pseudorandom numbers for a single step in time, but all MC paths
    sn = black_scholes(sn, dt, r, sigma, dw);  
    s_list(:,n)=sn; % single asset so no assigning problems.
  endfor
  res_fix = s_list;
  
  return
  
  
