function [Mass,output_data,Energy_available] = Mass_DBF(Input_parameters, Geometry, MTOM)


Mass.MTOM = MTOM;   %kg
% [rho,~,~,~,~]         = stdatmo(Input_parameters.h_cruise_abs);
% V_cruise_ms             = VbestLD_ms;
% q_cruise                = .5*rho*(V_cruise_ms).^2; %kg/(m.s^2) or Pa


Mass.EW_fract      = .44;  %assumption

Mass.payload_frac      = .44;  %assumption

Mass.batt_fraction     = 1 - Mass.EW_fract - Mass.payload_frac;

Mass.Mbatteries = Mass.batt_fraction*MTOM;


Energy_available = Mass.Mbatteries * Input_parameters.Batt_Sp_E * Input_parameters.depthOfDischarge*1000;
output_data=0;
end
