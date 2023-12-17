%% NOTE TO SELF
% Kp => Proportional Gain
% Kd = Kp*Td => Derivative Gain
% Ki = Kp/Ti => Integral Gain

%% SYSTEM WITHOUT CONTROLLER
% Mass of Car
m = 1000;
% Damping Coefficient
b = 50;
% Open-loop TF of the system
TF_OL_vOverU = tf([0 1], [m b]);

% step(TF_OL_vOverU)
% stepinfo(TF_OL_vOverU)

%% OBSERVATIONS:
% 1. System is SUPER SLOW
% 2. Steady State Error is TOO LOW

%% REQUIREMENTS
% 1. Rise time < 5 sec
% 2. Overshoot < 10%
% 3. Steady-state error < 2%

%% METHODS TO FIX THE ISSUES
% 1. Add Kp to decrease Steady-state error && decrease Rise Time
% 2. Add Ki to ELIMINATE Steady-state error && Decrease Rise Time
% 3. Add Kd to decrease Overshoot without impacting Steady-state error

% Kp:Ki:Kd = 100:4:1

%% ADDING PID CONTROLLER
Kp = 470
Ki = 18.8
Kd = 4.7

TF_OL_PIDController = pid(Kp, Ki, Kd);

TF_CL_SystemWithController = feedback(TF_OL_PIDController * TF_OL_vOverU, 1);

step(TF_CL_SystemWithController)
stepinfo(TF_CL_SystemWithController)