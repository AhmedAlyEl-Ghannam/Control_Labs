%% Prepreparations
clear
close all
clc 


%% System Parameters

% Gain Blocks
GAIN_speedSensorSensitivity = 0.0433;                   % Kss
GAIN_currentSensorSensitivity = 0.5;                    % Kcs
GAIN_motorInertia = 7.226;                              % Jtot
GAIN_motorResistor = 1;                                 % Ra
GAIN_viscousFriction = 0.1;                             % kf
GAIN_backEMFConstant = 2;                               % kb
GAIN_aeroDynamicDragTorque = 0.6154;                    % pCwAvo
GAIN_vehicleDynamics = 0.0615;                          % r__i_tot
GAIN_motorTorque = 1.8;                                 % MtotKt

% Transfer Function Blocks
TF_speedController = tf([100 40], [1 0]);               % Gsc(s)
TF_torqueControllerAndPowerAmp = tf([10 6], [1 0]);     % Ka.Gtc(s)
TF_angularSpeed = tf([0 1], [GAIN_motorInertia 0]);     % 1/Jtot.s


%% Move the takeoff point (Angular Velocity) one block to the right

%% Total Transfer Function (G1) From Motive Torque (T(s)) to Vehicle Speed (V(s))

TTF_feedback1_vehicleSpeedOverMotiveTorque = tf([GAIN_aeroDynamicDragTorque], [1]);
TTF_feedback2_vehicleSpeedOverMotiveTorque = series(tf([GAIN_viscousFriction], [1]), tf([1], [GAIN_vehicleDynamics]));
TTF_feedback_vehicleSpeedOverMotiveTorque = parallel(TTF_feedback1_vehicleSpeedOverMotiveTorque, TTF_feedback2_vehicleSpeedOverMotiveTorque); % 2.241
TTF_forward_vehicleSpeedOverMotiveTorque = series(tf([TF_angularSpeed], [1]), tf([GAIN_vehicleDynamics], [1]));
TTF_G1_vehicleSpeedOverMotiveTorque = feedback(TTF_forward_vehicleSpeedOverMotiveTorque, 2.241);

%% Total Transfer Function (G2) From Armature Current (Ia(s)) to Vehicle Speed (V(s))

TTF_G2_vehicleSpeedOverArmatureCurrent = series(TTF_G1_vehicleSpeedOverMotiveTorque, tf([GAIN_motorTorque], [1]));


%% Move takeoff point before G2 to the end of system

%% Total Transfer Function (G3) From Amplifier Output Voltage (Ia(s)) to Vehicle Speed (V(s))

TTF_forward_vehicleSpeedOverAmplifierOutputVoltage = series(tf([1], [GAIN_motorResistor]), TTF_G2_vehicleSpeedOverArmatureCurrent);
TTF_feedback_vehicleSpeedOverAmplifierOutputVoltage = series(tf([GAIN_backEMFConstant], [1]), tf([1], [GAIN_vehicleDynamics])); % 32.52
TTF_G3_vehicleSpeedOverAmplifierOutputVoltage = feedback(TTF_forward_vehicleSpeedOverAmplifierOutputVoltage, 32.52);


%% Total Transfer Function (G4) From Torque Controller (Ka.Gtc(s)) to Vehicle Speed (V(s))

TTF_forward_vehicleSpeedOverTorqueController = series(TF_torqueControllerAndPowerAmp, TTF_G3_vehicleSpeedOverAmplifierOutputVoltage);
TTF_feedback_vehicleSpeedOverTorqueController = series(tf([GAIN_currentSensorSensitivity], [1]), 1 / TTF_G3_vehicleSpeedOverAmplifierOutputVoltage);
TTF_G4_vehicleSpeedOverTorqueController = feedback(TTF_forward_vehicleSpeedOverTorqueController, TTF_feedback_vehicleSpeedOverTorqueController);


%% Total Transfer Function For the System From Reference Signal Rv(s) to Vehicle Speed V(s)

TTF_forward_vehicleSpeedOverTorqueController = series(TTF_G4_vehicleSpeedOverTorqueController, TF_speedController);
TTF_feedback_vehicleSpeedOverTorqueController = series(tf([GAIN_speedSensorSensitivity], [1]), tf([1], [GAIN_vehicleDynamics]));
TTF_G5_vehicleSpeedOverTorqueController = feedback(TTF_forward_vehicleSpeedOverTorqueController, TTF_feedback_vehicleSpeedOverTorqueController);


%% Simplifying The Expresion

TTF_G5_Output = minreal(TTF_G5_vehicleSpeedOverTorqueController);
