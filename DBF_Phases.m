function [Energy_required,output_data]   = DBF_Phases(Input_parameters,CLbestLD, Vstall_ms,MTOM,VbestLD_ms,LD_cruise,W_S,P_ROC_kW,Pcruise,flag)
g = 9.81;
[rho,~,~,~,~,~] = stdatmo(Input_parameters.h_cruise_abs);

%% Takeoff phase
V_takeoff = 1.2*Vstall_ms;
T_takeoff = V_takeoff^2*MTOM/(2*Input_parameters.max_takeoff_distance);
P_takeoff = (T_takeoff*V_takeoff)*.001;
t_takeoff = Input_parameters.max_takeoff_distance/V_takeoff;
E_takeoff = P_takeoff*t_takeoff;
output_data.Etakeoff = E_takeoff*0.2777778;
%% Turns
V_max_turn = sqrt(2*Input_parameters.nmax*W_S/(rho*Input_parameters.CL_max));
T_max_turn = Input_parameters.nmax*MTOM*g/(LD_cruise);
P_max_turn = (T_max_turn*V_max_turn)*.001;

wmax = g*sqrt(rho*Input_parameters.CL_max*Input_parameters.nmax/(2*W_S));

t_turn1 = pi/wmax;
t_turn2 = pi/wmax;
t_turn3 = 2*pi/wmax;
E_turn1 = P_max_turn*t_turn1;
E_turn2 = P_max_turn*t_turn2;
E_turn3 = P_max_turn*t_turn3;
output_data.E_turn1 = E_turn1*0.2777778;
output_data.E_turn2 = E_turn3*0.2777778;
output_data.E_turn3 = E_turn3*0.2777778;
%% Cruise
cruise_distance  = 2000*.3048;
t_cruise = cruise_distance/VbestLD_ms;
E_cruise = Pcruise*t_cruise;
output_data.E_cruise = E_cruise*0.2777778;
%% Climb
t_climb = Input_parameters.h_cruise_AGL/Input_parameters.ROC_at_best_LD_ms;
E_climb = P_ROC_kW*t_climb;
output_data.E_climb = E_climb*0.2777778;
%Take off + 1 climb + 3*3turns (10laps)
Energy_required = (E_takeoff + (E_turn1 + E_turn2 + E_turn3 + E_cruise)*10 + E_climb)*0.2777778;  %kWs to Wh
if flag==1
    flag=1;
end
end

