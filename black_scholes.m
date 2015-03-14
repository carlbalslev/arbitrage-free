function result = black_scholes(s0, dt, r, sigma, dW)
# 
# Take a step with OU model.
# The random step dW is normalised, i.e. it has distrib N(0,1)
#
  
  coeff = sigma*dW*sqrt(dt) + (r - 0.5*sigma*sigma)*dt;
  st = s0 .* exp(coeff);
  result = st;

return
  
