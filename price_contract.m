function [price, stats] = price_contract(s0, t0, model, contract)
				#  
				# Find the model value of a contract
				#
				# input: s0, t0, model, contract
				# output: price, statistics
				#
  
				# a hardcoded tlist ...
  
  npaths = model.numerical.npaths; 
  
		 # this is for the vanilla option with a single fixing
  period.tstart = t0;
  period.tend = contract.characteristics.fix_date;

  k = contract.characteristics.strike;
  mat = contract.characteristics.pay_date;
  r = model.pars.r;
  
  for n=1:npaths
    fix = propagate_model(s0,period,model);
    fv(n) = max (fix - k, 0);    
  endfor
  disc = exp(-r * mat);
  pv = mean(fv) * disc;
  my_std = std(fv) * disc;
  v95 = 1.96 * my_std / sqrt(npaths);
  stats.std = my_std;
  stats.min95 = pv - v95;
  stats.max95 = pv + v95;

  price = pv;
  stats = stats;
  return
  
  
  
