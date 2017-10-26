function [Energy_required,output_data]   = DBF_Phases(Input_parameters,CLbestLD, Vstall_ms,MTOM,VbestLD_ms,LD_cruise,W_S,P_ROC_kW,Pcruise,flag)
g = 9.81;
[rho,~,~,~,~,~] = stdatmo(Input_parameters.h_cruise_abs);

%% Takeoff phase
V_takeoff = 1.2*Vstall_ms;
<<<<<<< HEAD
T_takeoff = V_takeoff^2*MTOM/(2*Input_parameters.max_takeoff_distance);
P_takeoff = (T_takeoff*V_takeoff);
t_takeoff = sqrt(Input_parameters.max_takeoff_distance*2*MTOM/T_takeoff);
E_takeoff = P_takeoff*t_takeoff;
output_data.Etakeoff = E_takeoff*0.0002777778;
=======
T_takeoff = sqrt(2)*V_takeoff^2*MTOM/(2*Input_parameters.max_takeoff_distance);
P_takeoff = (T_takeoff*V_takeoff);  %N*m/s
t_takeoff = Input_parameters.max_takeoff_distance/V_takeoff;  %s
E_takeoff = P_takeoff*t_takeoff;   %Ws
output_data.Etakeoff = E_takeoff*0.0002777778; %Wh

%% Cruise
cruise_distance  = 2000*.3048;
t_cruise = cruise_distance/VbestLD_ms;
E_cruise = Pcruise*t_cruise*1000; %Ws
output_data.E_cruise = E_cruise*0.0002777778;
>>>>>>> 06db69ab245253d05e56e6544723a71fa386d9c6
%% Turns
V_max_turn = sqrt(2*Input_parameters.nmax*W_S/(rho*Input_parameters.CL_max));
T_max_turn = Input_parameters.nmax*MTOM*g/(LD_cruise);
if VbestLD_ms < V_max_turn
    V_turn  = VbestLD_ms;
else
    V_turn = V_max_turn;
end

<<<<<<< HEAD
% wmax = g*sqrt(rho*Input_parameters.CL_max*Input_parameters.nmax/(2*W_S));
R_turn = V_max_turn^2/sqrt(Input_parameters.nmax^2-1);
=======
    
P_max_turn = (T_max_turn*V_turn);

wmax = g*sqrt(rho*CLbestLD*Input_parameters.nmax/(2*W_S));
>>>>>>> 06db69ab245253d05e56e6544723a71fa386d9c6

%     t_turn1 = pi/wmax;
%     t_turn2 = pi/wmax;
%     t_turn3 = 2*pi/wmax;
t_turn1 = pi*R_turn/V_max_turn;
t_turn2 = pi*R_turn/V_max_turn;
t_turn3 = 2*pi*R_turn/V_max_turn;
    
E_turn1 = P_max_turn*t_turn1;
E_turn2 = P_max_turn*t_turn2;
E_turn3 = P_max_turn*t_turn3;
output_data.E_turn1 = E_turn1*0.0002777778;
output_data.E_turn2 = E_turn2*0.0002777778;
output_data.E_turn3 = E_turn3*0.0002777778;

<<<<<<< HEAD
%% Cruise
cruise_distance  = 2000*.3048;
t_cruise = cruise_distance/VbestLD_ms;
E_cruise = Pcruise*t_cruise*1000;
output_data.E_cruise = E_cruise*0.0002777778;


%% Lap Calculation
TotalTime = 10*60; %seconds

Input_parameters.LapTime = 4*pi*R_turn/V_max_turn + 609.6/VbestLD_ms;
Input_parameters.NumLaps = round((TotalTime-T_takeoff)/LapTime-.5);;

=======
>>>>>>> 06db69ab245253d05e56e6544723a71fa386d9c6
%% Climb
t_climb = Input_parameters.h_cruise_AGL/Input_parameters.ROC_at_best_LD_ms;
E_climb = P_ROC_kW*t_climb*1000;
output_data.E_climb = E_climb*0.0002777778;  %Ws -> Wh
output_data.lap_takeoff   = t_turn1+t_turn2+t_turn3+t_climb+t_cruise+t_takeoff;
output_data.full_lap   = t_turn1+t_turn2+t_turn3+t_cruise;
output_data.M2_score_num = Input_parameters.n_passenger /(output_data.full_lap*2 + output_data.lap_takeoff);
no_of_laps_completed = floor((600-output_data.lap_takeoff - t_climb)/(output_data.full_lap));
output_data.no_of_laps = no_of_laps_completed;
output_data.M3_score_num = Input_parameters.n_passenger/2 * 5 * no_of_laps_completed;
%Take off + 1 climb + 3*3turns (10laps)
Energy_required = (E_takeoff + (E_turn1 + E_turn2 + E_turn3 + E_cruise)*Input_parameters.NumLaps + E_climb)*0.0002777778;  %Ws to Wh
if flag==1
    flag=1;
end
end

