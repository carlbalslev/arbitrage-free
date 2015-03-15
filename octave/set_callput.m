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
  
  
  if (t_fix>t_pay)
    error ("set_callput: payment date cannot be before fixing date");
  endif

  switch(callput)
    case 1
      contract.cname = "vanilla call";
    case 2
      contract.cname = "vanilla put";
    case 3
      contract.cname = "asian strike call";
    case 4
      contract.cname = "asian strike put";
    case 5
      contract.cname = "asian rate call";
    case 6
      contract.cname = "asian rate put";
    case 7
      contract.cname = "lookback strike call";
    case 8
      contract.cname = "lookback strike put";
    case 9
      contract.cname = "lookback rate call";
    case 10
      contract.cname = "lookback rate put";
    otherwise
      error (["callput =", mat2str(callput), " is out of bounds as contract type"])  
  endswitch
  
  characs.fix_date = t_fix;
  characs.pay_date = t_pay;
  characs.underlying = underlying;
  characs.strike = strike;
  
  contract.characteristics = characs;
  
  return
  
  
