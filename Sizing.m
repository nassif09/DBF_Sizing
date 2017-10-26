%Load all parameters
clear,close all,
Input_parameters_DBF

%if type=1 then you can run parametric design
%if type=2 then run point design

type = 1;
if type ==1
AR = [3:.5:7];
W_S_E = [2:.2:4];    %lbf/ft^2

else
    AR = [4];
    W_S_E = [3.6];
end
W_S_M = W_S_E*47.88;    
v_vector_ms = 20:22;   %velocity range m/s;
h_vector_m = 405; %altitude range m
case_count = 1;
total_cases = length(AR)*length(W_S_M);
n_cases_carpet = length(AR)*length(W_S_M);
stored_data = zeros(n_cases_carpet,8);
for AR_index = 1:length(AR)
    for W_S_index = 1:length(W_S_M)

    Input_parameters.AR                 = AR(AR_index);
    MTOM0 = 7/2.2;  %kg
    W_S = W_S_M(W_S_index);
    Geometry.W_S = W_S_M(W_S_index);
   
    MTOM=MTOM0;
    %Energy_required(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,W_S)  %kWh
    output_data.nothing = 0;
    %Eavailable = Energy_available(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,output_data);
    dEnergy = @(MTOM) Energy_required(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,W_S) -  .90*Energy_available(MTOM,Input_parameters, Geometry, v_vector_ms, h_vector_m,output_data);
    if type==1
        options = optimset('Display','off','TolX',0.0005);
    else 
        options = optimset('Display','iter','TolX',0.0005);
    end
    MTOM = fzero(dEnergy, MTOM0, options);
%disp('The converged value in lbs is ')
%MTOM*2.2
    output_data = 0;
    if type ==1
        flag = 0;
    else
        flag = 1;
    end
    
    Print_Results
    stored_data(case_count,1) = MTOM*2.2;
    stored_data(case_count,2) = W_S_E(W_S_index);
    stored_data(case_count,3) = AR(AR_index);
    stored_data(case_count,4) = Geometry.wingspan*39.37;
    stored_data(case_count,5) = output_data.M2_score_num;
    stored_data(case_count,6) =  output_data.M3_score_num;
    stored_data(case_count,7) = Mass.EW_fract*MTOM*2.2 * Geometry.wingspan*39.37;
    stored_data(case_count,8) = stored_data(case_count,7);
    case_count = case_count + 1;
    end
end
stored_data(:,5) = 2*stored_data(:,5)/max(stored_data(:,5));
stored_data(:,6) = (4*stored_data(:,6)/max(stored_data(:,6))) + 2;
stored_data(:,7) = (1 + stored_data(:,5) + stored_data(:,6))./(stored_data(:,7));
if type ==1
figure(2)
 for carpet_counter = 1:1
           o = carpetplot(stored_data(1+n_cases_carpet*(carpet_counter-1):(carpet_counter*n_cases_carpet),2), ...
                 stored_data(1+n_cases_carpet*(carpet_counter-1):(carpet_counter*n_cases_carpet),3),...
                 stored_data(1+n_cases_carpet*(carpet_counter-1):(carpet_counter*n_cases_carpet),1),...
                 stored_data(1+n_cases_carpet*(carpet_counter-1):(carpet_counter*n_cases_carpet),7)...
                 );hold on,
           label(o,'W_S(lbf/ft^2)','AR')
 set(o.alines,'color',[1 0 0],'linestyle','--');
 xlabel('MTOM(lbs)')
  ylabel('Score')
  hold off
 end
end
