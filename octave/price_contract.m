function [price, stats] = price_contract(s0, t0, model, contract)
				#
				# Calculate the value of a contract based on particular model
				#
				# input: s0, t0, model, contract
				# output: price, statistics
				#


  mt = model.numerical.mtype
  switch (mt)
    case "mc"
      [price,stats] = price_contractMC(s0, t0, model, contract);
    otherwise
      error (["ERROR ==> ", mt, " is not supported!"])
  endswitch

  return
