function contract = set_callput(t_fix, t_pay, underlying, strike, callput)
				#
				# create vanilla call contract
				# input: t_fix, t_pay, underlying, strike, callput
				# output: contract
				#
				# callput enumeration:
				# 1: vanilla call
				# 2: vanilla put
				# 3: asian strike call
				# 4: asian strike put
				# 5: asian rate call
				# 6: asian rate put
				# 7: lookback strike call
				# 8: lookback strike put
				# 9: lookback rate call
				# 10: lookback rate put
				# 11: american call
				# 12: american put
				# 13: vanilla chooser


  if (t_fix>t_pay)
    error ("set_callput: payment date cannot be before fixing date");
  endif

				     # make these input parameters
  asian_times = 0.1:0.1:(t_fix-0.1);
  choose_time = 0.5;

  switch(callput)
    case 1
      contract.cname = "vanilla call";
    case 2
      contract.cname = "vanilla put";
    case 3
      contract.cname = "asian strike call";
      characs.asian = asian_times;
    case 4
      contract.cname = "asian strike put";
      characs.asian = asian_times;
    case 5
      contract.cname = "asian rate call";
      characs.asian = asian_times;
    case 6
      contract.cname = "asian rate put";
      characs.asian = asian_times;
    case 7
      contract.cname = "lookback strike call";
      characs.asian = asian_times;
    case 8
      contract.cname = "lookback strike put";
      characs.asian = asian_times;
    case 9
      contract.cname = "lookback rate call";
      characs.asian = asian_times;
    case 10
      contract.cname = "lookback rate put";
      characs.asian = asian_times;
    case 11
      contract.cname = "american call";
    case 12
      contract.cname = "american put";
    case 13
      contract.cname = "vanilla chooser";
      characs.fix_choose = choose_time;
    otherwise
      error (["callput =", mat2str(callput), " is out of bounds as contract type"])
  endswitch

  characs.fix_date = t_fix;
  characs.pay_date = t_pay;
  characs.underlying = underlying;
  characs.strike = strike;

  contract.characteristics = characs;

  return
