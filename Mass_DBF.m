function [Mass,output_data,Energy_available] = Mass_DBF(Input_parameters, Geometry, MTOM,output_data,flag)


Mass.MTOM = MTOM;   %kg
% [rho,~,~,~,~]         = stdatmo(Input_parameters.h_cruise_abs);
% V_cruise_ms             = VbestLD_ms;
% q_cruise                = .5*rho*(V_cruise_ms).^2; %kg/(m.s^2) or Pa


Mass.EW_fract      = .70; %assumption
Mass.payload       = 10*0.0283495;      %oz to kg
Mass.payload_frac      = Mass.payload/MTOM;  %assumption

Mass.remaining_fraction     = 1 - Mass.EW_fract;
Mass.remaining              = Mass.remaining_fraction*MTOM;
Mass.Mbatteries             = Mass.remaining - Mass.payload;



Energy_available = Mass.Mbatteries * Input_parameters.Batt_Sp_E * Input_parameters.depthOfDischarge*1000;
output_data.MassEW = Mass.EW_fract*MTOM;
output_data.Mbatteries = Mass.Mbatteries;
output_data.payload = Mass.payload;
if flag==1
    flag=1;
end
end
