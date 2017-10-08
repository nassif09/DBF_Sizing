%Load all parameters
clear,close all,
Input_parameters_DBF


MTOM0 = 8;  %kg
W_S = 140;    %N/m^2
Geometry.W_S = W_S;
v_vector_ms = 10:20;   %velocity range m/s;
h_vector_m = 400:410; %altitude range m
MTOM=MTOM0;
%Energy_required(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,W_S)   %kWh
output_data.nothing = 0;
%Eavailable = Energy_available(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m)
dEnergy = @(MTOM) Energy_required(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,W_S) -  .95*Energy_available(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,output_data);
options = optimset('Display','iter','TolX',0.0005);

MTOM = fzero(dEnergy, MTOM0, options);
disp('The converged value in lbs is ')
MTOM*2.2
output_data = 0;
Print_Results



