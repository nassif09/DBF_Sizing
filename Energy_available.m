function [Eavailable] = Energy_available(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,output_data)
flag =0;
 plotOption  = 'plotOff'; %turn off plotting while in iterative mode
[Mass,~,Eavailable] = Mass_DBF(Input_parameters, Geometry, MTOM,output_data,flag);




end
