function result = black_scholes(s0, dt, r, sigma, dW)
#  
# take one step. The random step is predefined.
#
 
st = s0 * exp(r*dt + 0.5*sqrt(dt)*sigma*dW);
result = st;
return

