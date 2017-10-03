function [P_ROC_kW] = ClimbPower(TOGW,Input_parameters, v_vector_kph,VbestCL32CD_kph, D_vector)

D_at_V_best_CL32CD = interp1(v_vector_kph, D_vector, VbestCL32CD_kph); %N

T_ROC_N = (Input_parameters.ROC_at_best_LD_ms * 3.73 * TOGW / (VbestCL32CD_kph/3.6)) + D_at_V_best_CL32CD; %Thrust required

P_ROC_kW = (T_ROC_N * (VbestCL32CD_kph/3.6)/ Input_parameters.eta_prop)/1000; % Power required at prop shaft
end

