%% Prepreparations
clear
close all
clc 


%% Block Diagram Parameters

% Current Sensor Sensitivity
K_cs = 0.5;

% Speed Sensor Sensitivity
K_ss = 0.0433;

% Motor Inertia
J_tot = 7.226;

% Motor Resistor
R_a = 1;

% Viscous Friction
k_f = 0.1;

% Back emf Constant
k_b = 2;

% Vehicle Dynamics
r__i_tot = 0.0615;
p_Cw_A_vo_r__i_tot = 0.6154;

% Motor Torque
m_tot__K_t = 1.8;

% Speed Controller: G_SC(s) = 100 + 40/s = (100s + 40)/(s + 0)
% Torque Controller & Power Amplifier: K_A . G_TC(s) = 10 + 6/s = (10s + 6)/(s + 0)


%% Input Signal ID

% ID 0->9 chooses the input waveform
% ID =  0: step('StepTime',0,'InitialValue',0,'FinalValue',2)
% ID =  1: sin('Amplitude',2,'Frequency',300,'Phase',0)
% ID =  2: sawtooth('Amplitude',5,'Frequency',1)
% ID =  3: square('Amplitude',1,'Frequency',10,'Phase',0,'DutyCycle',50)
% ID =  4: pulse('Amplitude',1,'TriggerTime',1,'Duration',2)
% ID =  5: step('StepTime',1,'InitialValue',0,'FinalValue',4)
% ID =  6: sin('Amplitude',4,'Frequency',200,'Phase',pi/2)
% ID =  7: sawtooth('Amplitude',2.5,'Frequency',10)
% ID =  8: square('Amplitude',5,'Frequency',5,'Phase',0,'DutyCycle',80)
% ID =  9: pulse('Amplitude',4,'TriggerTime',2,'Duration',5)

choice = 2;
ID = choice + 1;


%% Transfer Function For The System

tf(linsys1)