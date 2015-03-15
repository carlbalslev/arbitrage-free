function [price, stats] = price_contract(s0, t0, model, contract)
				#  
				# Find the model value of a contract
				#
				# input: s0, t0, model, contract
				# output: price, statistics
				#
 
  npaths = model.numerical.npaths; 
  
				# create fix list times
				#

  switch (contract.cname)
	 case {"vanilla call", "vanilla put"} 
	   t1 = contract.characteristics.fix_date;
	   t_list = [t0, t1];
	 otherwise
	   error (["ERROR ==> ", contract.cname, " is an unsupported contract"])
  endswitch

				# set contract parameters
  k = contract.characteristics.strike;
  mat = contract.characteristics.pay_date;

				# extra model parameters
  r = model.pars.r;

				# find fix values (MC vector) 
  fix_list = propagate_model(s0,t_list,model);

				# price contract on each path
				#(MC vector)

  switch (contract.cname)
    case  "vanilla call"
      fix = fix_list(:,2);
      fv = max (fix - k, 0);    
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);     
    case "vanilla put" 
      fix = fix_list(:,2);
      fv = max (k - fix, 0);    
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    otherwise
      error ([contract.cname, " is not supported."])
  endswitch
  
  my_std = std(pv_dist);
  v95 = 1.96 * my_std / sqrt(npaths);
  stats.npaths = npaths;
  stats.std = my_std;
  stats.min95 = pv - v95;
  stats.max95 = pv + v95;
  
  price = pv;
  return
  
  
  
