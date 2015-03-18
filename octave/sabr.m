function result = sabr(alpha0, alpha, beta, rho, dW1, dW2)
# 
# Take a step with SABR.
# The random step dW is normalised, i.e. it has distrib N(0,1)
#
  
  coeff = sigma*dW*sqrt(dt) + (r - 0.5*sigma*sigma)*dt;
  st = s0 .* exp(coeff);
  result = st;

return
  
