function contract = set_call(t_fix, t_pay, underlying, strike)
				#
				# create vanilla call contract
				# input: t_fix, t_pay, underlying, strike
				# output: contract
  
  if (t_fix>t_pay)
    error ("Vanilla call: payment date cannot be before fixing date");
  endif
  
  contract.cname = "vanilla call";
  characs.fix_date = t_fix;
  characs.pay_date = t_pay;
  characs.underlying = underlying;
  characs.strike = strike;
  
  contract.characteristics = characs;
  
  return
  
  
