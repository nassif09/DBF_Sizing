%Load all parameters
Input_parameters_DBF


MTOM0 = 6;  %kg
W_S = 105;    %N/m^2
Geometry.W_S = W_S;
v_vector_ms = 20:30;   %velocity range m/s;
h_vector_m = 400:410; %altitude range m
MTOM=MTOM0;
Energy_required(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,W_S)   %kWh

Eavailable = Energy_available(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m)
dEnergy = @(MTOM) Energy_required(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,W_S) -  .95*Energy_available(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m);
options = optimset('Display','iter','TolX',0.0005);

MTOM = fzero(dEnergy, MTOM0, options);
disp('The converged value in lbs is ')
MTOM*2.2
[Geometry]=DBF_Geometry_Generation(Input_parameters,Geometry,MTOM,W_S,'plotOff');
Energy_available(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m);

