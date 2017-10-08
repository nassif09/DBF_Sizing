function [Erequired] = Energy_required(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,W_S)
plotOption  = 'plotOff'; %turn off plotting while in iterative mode
flag=0;
%1- Find geometry, aero parameters
[Geometry]              = DBF_Geometry_Generation(Input_parameters,Geometry,MTOM,W_S, plotOption,flag);

%Find parasite drag over the whole 2D spectrum
[Cd0_2D]     = DBF_Cd_0(Input_parameters, v_vector_ms, h_vector_m, Geometry, plotOption,flag);

%Find all aero characteristics, including Vcruise
[LD_vector, LD_cruise, LDmax, VbestLD_ms, VbestCL32CD_ms, CLbestLD, Vstall_ms, D_vector, D_2D,CL32CDmax] = DBF_LD(Geometry,MTOM,Input_parameters, h_vector_m, v_vector_ms, Cd0_2D, plotOption,flag);


%go back and get Cd0 values corresponding to Vcruise = VbestLD_kph
[Cd0_2D, Cd0_at_cruise] = DBF_Cd_0(Input_parameters, v_vector_ms, h_vector_m, Geometry, plotOption,flag, VbestLD_ms);

%3- find Pcruise, Ploiter, and Tcruise to use in weights. Units are kW and N
[Pcruise, ~] = cruiseCalcsSimple(MTOM,Input_parameters, LD_cruise, VbestLD_ms,Geometry,flag);

% find ROC power to find the cruise motor weight; compare to max speed power
[P_ROC_kW]         = ClimbPower(MTOM,Input_parameters, v_vector_ms, VbestLD_ms, D_vector,flag); % @ prop shaft, includes eta_prop



[Erequired,~]   = DBF_Phases(Input_parameters,CLbestLD, Vstall_ms,MTOM,VbestLD_ms,LD_cruise,W_S,P_ROC_kW,Pcruise,flag);


end

