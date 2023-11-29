%% Prepreparations
clear
close all
clc 


%% System Parameters
J = 600e3;
B = 20e3;
K = 1;

%% Transfer Function (Input: theta_r --- Output: theta)
TF_thetaOverThetar = tf([0 0 K], [J B K]);

%% Converting the Transfer Function to the State-Space Model
SS_thetaOverThetar = ss(TF_thetaOverThetar);
size(SS_thetaOverThetar);

%% Maximum Value for K to Have a Stable Closed-Loop System
% Characteristic Eqn: JS^2 + BS + K = 0
syms K S;
K = -(J * (S^2)) - (B * S);

S = solve(diff(K, S)==0);
K_max = subs(K);

%% Finding Value for K to Have Mp < 10%
SS_variables = stepinfo(SS_thetaOverThetar);

for K = 1:0.1:1006
        TF_thetaOverThetar = tf([0 0 K], [J B K]);
        SS_thetaOverThetar = ss(TF_thetaOverThetar);
        SS_variables = stepinfo(SS_thetaOverThetar);
        if (SS_variables.Overshoot <= 10)
            K_Mp = K;
        end
end

%% Finding Value for K to Have tr < 80 sec
for K = 1006:-0.1:1
        TF_thetaOverThetar = tf([0 0 K], [J B K]);
        SS_thetaOverThetar = ss(TF_thetaOverThetar);
        SS_variables = stepinfo(SS_thetaOverThetar);
        if (SS_variables.RiseTime <= 80)
            K_tr = K;
        end
end

%% Step Response + Zeros/Poles + Steady State Error at Different Values of K (= 200, 400, 1000, 2000)
% @ K = 200
SS_errorAtK__200 = FN_plotSS_ZP_SSerror(200, J, B)
% @ K = 400
SS_errorAtK__400 = FN_plotSS_ZP_SSerror(400, J, B)
% @ K = 1000
SS_errorAtK__1000 = FN_plotSS_ZP_SSerror(1000, J, B)
% @ K = 2000
SS_errorAtK__2000 = FN_plotSS_ZP_SSerror(2000, J, B)

