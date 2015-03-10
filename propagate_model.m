function [resx, resy] = propagate_model(s0, t0, t_end, model, pars)
#  
# Propagate asset with some model.
# 
# input: time axis and model
# output: (t, fixings) list
#

  nmax = 101;
  clear('res_list');
  dt = (t_end - t0) / (nmax-1);
  tlist = t0:dt:t_end;
# a hardcoded tlist ...

# extract model
  r = pars(1);
  sigma = pars(2);
# generate pseudorandom numbers  
  dw_list = normrnd(0,1,[1,nmax]);
# init
  sn = s0;
  tn = tlist(1);
  slist(1)=sn;
  
  for n=2:nmax,
     tn1 = tlist(n);
     dt = tn1 - tn;
     tn = tn1;
     dw = dw_list(n);
     sn1 = black_scholes(sn, dt, r, sigma, dw);
     slist(n) = sn1;
     sn = sn1;
  endfor  
  resx = tlist;
  resy = slist;
  
return

