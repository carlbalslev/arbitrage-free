function [price, stats] = price_contractMC(s0, t0, model, contract)
				#
				# MC model value of contract  
				#
				# input: s0, t0, model, contract
				# output: price, statistics
				#

  npaths = model.numerical.npaths;

				# create fix list times
				#

				# set common contract parameters
  k = contract.characteristics.strike;
  mat = contract.characteristics.pay_date;

				# set contract specific parameters
  switch (contract.cname)
	 case {"vanilla call", "vanilla put"}
	   t1 = contract.characteristics.fix_date;
	   t_list = [t0, t1];
	 case {"asian strike call", "asian strike put", "lookback strike call", "lookback strike put"}
	   t1 = contract.characteristics.fix_date;
	   t_list = contract.characteristics.asian;
	   n_fix = length(t_list);
	   t_list(n_fix+1) = t1;
	   n_fix = length(t_list);
	 case {"asian rate call", "asian rate put", "lookback rate call", "lookback rate put"}
	   t_list = contract.characteristics.asian;
	   n_fix = length(t_list);
	 otherwise
	   error (["ERROR ==> ", contract.cname, " is an unsupported contract for the vanilla MC algo"])
  endswitch

				# extra model parameters
  r = model.pars.r;

				# find all fix values (MC vector)
  fix_list = propagate_model(s0,t_list,model);

				# price contract
				#(at each MC vector)

  switch (contract.cname)
    case  "vanilla call"
      fix = fix_list(:,2);
      fv = max (fix - k, 0);
      stats.f_dist = fv;
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "vanilla put"
      fix = fix_list(:,2);
      fv = max (k - fix, 0);
      stats.f_dist = fv;
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "asian strike call"
      fix = fix_list(:,n_fix);
      fix_strike = fix_list(:,2:n_fix-1);
      k = mean(fix_strike,2);
      stats.f_dist = k;
      fv = max (fix - k, 0);
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "asian strike put"
      fix = fix_list(:,n_fix);
      fix_strike = fix_list(:,2:n_fix-1);
      k = mean(fix_strike,2)
      stats.f_dist = k;
      fv = max (k - fix, 0);
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "asian rate call"
      fix_rate = fix_list(:,2:n_fix); % all fixings except s0
      rate = mean(fix_rate,2);
      stats.f_dist = rate;
      fv = max (rate - k, 0); % strike set as parameter
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "asian rate put"
      fix_rate = fix_list(:,2:n_fix); % all fixings except s0
      rate = mean(fix_rate,2);
      stats.f_dist = rate;
      fv = max (k - rate, 0); % strike set as parameter
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "lookback strike call"
      fix = fix_list(:,n_fix);
      fix_strike = fix_list(:,2:n_fix-1);
      k = min(fix_strike,[],2);
      stats.f_dist = k;
      fv = max (fix - k, 0);
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "lookback strike put"
      fix = fix_list(:,n_fix);
      fix_strike = fix_list(:,2:n_fix-1);
      k = max(fix_strike,[],2)
      stats.f_dist = k;
      fv = max (k - fix, 0);
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "lookback rate call"
      fix_rate = fix_list(:,2:n_fix); % all fixings except s0
      rate = max(fix_rate,[],2);
      stats.f_dist = rate;
      fv = max (rate - k, 0); % strike set as parameter
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    case "lookback rate put"
      fix_rate = fix_list(:,2:n_fix); % all fixings except s0
      rate = min(fix_rate,[],2);
      stats.f_dist = rate;
      fv = max (k - rate, 0); % strike set as parameter
      disc = exp(-r * mat);
      pv_dist = disc * fv;
      pv = mean(pv_dist);
    otherwise
      error ([contract.cname, " is not supported."])
  endswitch

				# common calcs
  my_std = std(pv_dist);
  v95 = 1.96 * my_std / sqrt(npaths);
  v99 = 2.576 * my_std / sqrt(npaths);
  stats.npaths = npaths;
  stats.std = my_std;
  stats.min95 = pv - v95;
  stats.max95 = pv + v95;
  stats.min99 = pv - v99;
  stats.max99 = pv + v99;
  stats.p_dist = pv_dist;
  
  price = pv;
  return
