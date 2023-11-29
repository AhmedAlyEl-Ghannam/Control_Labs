%% System Parameters
J_sm = 600e3;
B_sm = 20e3;
K_sm = 1;

%% System Poles

syms S

eqn = (J_sm * (S^2)) + (B_sm * S) + K_sm == 0;

sol = solve(eqn);

X1 = sol(1);
X2 = sol(2); % dominant