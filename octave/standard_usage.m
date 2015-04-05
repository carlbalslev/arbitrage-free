t0 = 0;
t1 = 10;
r = 0.03;
sigma = 0.2;
n_mc  = 10000; # MC paths
mtype = "mc"; # numerical scheme in {"mc","mc-lsm", "pde"}
##
[m_bs, period] = set_bs_model(mtype, t0, t1, r, sigma, n_mc);
##

t_fix = 0.9;
t_pay = 1.0;
underlying = "Carlsberg";
strike = 101;
callput = 5; # contract type in 1-13
##
c = set_callput(t_fix, t_pay, underlying, strike, callput);
##

s0 = 100;
t0 = 0;
model = m_bs;
contract = c;
[pr,st] = price_contract(s0, t0, model, contract);

[st.min95; pr; st.max95]

