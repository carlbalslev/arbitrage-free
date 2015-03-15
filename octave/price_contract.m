function [price, stats] = price_contract(s0, t0, model, contract)
				#  
				# Find the model value of a contract
				#
				# input: s0, t0, model, contract
				# output: price, statistics
				#
 
  npaths = model.numerical.npaths; 
  
				# create fix list
				#

  switch (contract.cname)
	 case {"vanilla call", "vanilla put"} 
	   t1 = contract.characteristics.fix_date;
	   t_list = [t0, t1];
	 otherwise
	   error ("unknown contract")
  endswitch
	   
				# price contract on each path (vectorised on MC paths)

  k = contract.characteristics.strike;
  mat = contract.characteristics.pay_date;
  r = model.pars.r;
  
  fix_list = propagate_model(s0,t_list,model);
  fix = fix_list(:,2);
  fv = max (fix - k, 0);    
  disc = exp(-r * mat);
  pv = mean(fv) * disc;
  my_std = std(fv) * disc;
  v95 = 1.96 * my_std / sqrt(npaths);
  stats.npaths = npaths;
  stats.std = my_std;
  stats.min95 = pv - v95;
  stats.max95 = pv + v95;

  price = pv;
  stats = stats;
  return
  
  
  
