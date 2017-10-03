% These are parameters that do not change throughout main code execution

% Input_parameters.Wpayload           = 2;  %kg
Input_parameters.h_cruise_abs       = 405;              %1330ft 
Input_parameters.h_cruise_AGL       = (1340-1300)*.3048;   


Input_parameters.ROC_at_best_LD_ms  = 75*.00508;  % ft/min converted to m/s - Assumption
%Propulsion system parameters
Input_parameters.eta_prop           = .75;      %-
Input_parameters.eta_motor          = .87;      
Input_parameters.eta_ESC            = .97;      
Input_parameters.eta_wires          = .99;
%-----------------------------------------
Input_parameters.Powertrain_losses = Input_parameters.eta_motor * Input_parameters.eta_ESC * Input_parameters.eta_wires;





%wing aerodynamic assumptions
Input_parameters.Percent_lam_flow   = .4; %assuming 40% laminar flow and 60%turbulent flow

%tail data
Input_parameters.V_TVC              = 0.04;  %assumptiOn from Raymer t6.4 
Input_parameters.H_TVC              = 0.5;   %assumptiOn from Raymer t6.4 

% AERODYNAMICS
Input_parameters.Oswald             = 0.95; % from AVL 
Input_parameters.CL_max             = 1.3;  %
%margins
Input_parameters.Oswald_margin      = 0.97; % 
Input_parameters.K_Cd0              = 1.0;  %
Input_parameters.K_Cdi              = 1.0; %

% WEIGHTS
% Input_parameters.Weight_margin      = 1.0;

% Input_parameters.Wavionics                  = (.75)/2.2;       %kg FMP=15.7 lbs, TNAV = 2.5 lbs
Input_parameters.Motor_Sp_Pwr               = 2.6;    % Kw/kg from Neu 1110G motors

Input_parameters.n_rows_passengers  =    2;
Input_parameters.max_takeoff_distance  = 100*.3048;   %100ft to m
Input_parameters.nmax                   = 4;

Input_parameters.AR                 = 7;
% BATTERY STUFF 
Input_parameters.Batt_Sp_E          = .100; %kWhr/kg %NiMH

Input_parameters.depthOfDischarge   = .9; 

%--------------------------------------------------
Input_parameters.Batt_overhead = 0;

%Avionics
Input_parameters.Pavionics          = .01; % kW avionics + communications 
% Geometry elements
Geometry.wing_taper                 = 1;