function [P_ROC_kW] = ClimbPower(MTOM,Input_parameters, v_vector_ms,VbestLD_ms, D_vector,flag)

D_at_V_best_LD = interp1(v_vector_ms, D_vector, VbestLD_ms); %N

T_ROC_N = (Input_parameters.ROC_at_best_LD_ms * 9.81 * MTOM / (VbestLD_ms)) + D_at_V_best_LD; %Thrust required

P_ROC_kW = (T_ROC_N * (VbestLD_ms)/ Input_parameters.eta_prop)/1000; % Power required at prop shaft
if flag==1
    flag=1;
end
end

