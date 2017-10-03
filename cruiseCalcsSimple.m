function [Pcruise, Tcruise] = cruiseCalcsSimple(MTOM,Input_parameters, LD_cruise, VbestLD_ms,Geometry)
%CRUISECALCSSIMPLE Summary of this function goes here
%   Detailed explanation goes here

    Tcruise = MTOM*9.81 / LD_cruise; %N
    

    Input_parameters.Vcruise_ms =  VbestLD_ms; %convert to m/s
    

    Pcruise = (1/1000)*(Tcruise*Input_parameters.Vcruise_ms) / Input_parameters.eta_prop;% kW, @ prop shaft
    
    
    
end

