function [Cd0_2D,varargout] = DBF_Cd_0(Input_parameters, v_vector_ms, h_vector_m, Geometry, plotOption,varargin)


v_ms = v_vector_ms;
v_ms_2D = repmat(v_ms,length(h_vector_m),1);


[~,~,~,~,nu_2D,~] = stdatmo(h_vector_m);

Reynolds_per_meter_2D = v_ms_2D./nu_2D;

% DRAG components
% Fuselage          |
% Wing              |
% HTail             |  Friction coefficients
% VTail             |

%% find Reynolds number for all components:
Re_fuselage_2D      = Reynolds_per_meter_2D * Geometry.l_fuselage;
Re_wing_2D          = Reynolds_per_meter_2D * Geometry.mac_wing;
Re_htail_2D         = Reynolds_per_meter_2D * Geometry.c_ht;
Re_vtail_2D         = Reynolds_per_meter_2D * Geometry.c_vt;

%% find friction coefficients for all components:
%fuselage 
Cf_fuse_2D = .455 ./ (log10(Re_fuselage_2D).^2.58);  
%Wing 
Cf_wing_2D_lam  =  1.328./sqrt(Re_wing_2D);
Cf_wing_2D_turb =  .455 ./ (log10(Re_wing_2D).^2.58);

Cf_wing_2D = Cf_wing_2D_lam*Input_parameters.Percent_lam_flow + Cf_wing_2D_turb*(1-Input_parameters.Percent_lam_flow);
%Horizontal tail 
Cf_htail_2D = .455 ./ (log10(Re_htail_2D).^2.58);  
%Vertical tail 
Cf_vtail_2D = .455 ./ (log10(Re_vtail_2D).^2.58); 

%% find Form Factors for all components:
%fuselage  
FF_fuse     = (1+(60/Geometry.fineness_ratio_fuse^3)+(Geometry.fineness_ratio_fuse/400));  
%Wing 
FF_wing     = 1 + (2*Geometry.tc_wing)+(60*Geometry.tc_wing^4) ; %from Hoerner, airfoils with t/c max at 30% chord  
%H tail 
FF_htail    = 1 + (2*Geometry.tc_tail)+(60*Geometry.tc_tail^4) ; %from Hoerner, airfoils with t/c max at 30% chord  
%V tail 
FF_vtail    = FF_htail;

%% Assign Interference Factors for all components:
%fuselage  
IF_fuse         = 1.00;  
%Wing 
IF_wing         = 1.00;  
%H tail 
IF_htail        = 1.02;  
%V tail 
IF_vtail        = 1.02;

%% Calculate individual friction coefficients

Cd_F_fuselage_2D            = (Cf_fuse_2D         * Geometry.Swet_Fuselage    * FF_fuse * IF_fuse)/  Geometry.Swing ;
Cd_F_wing_2D                = (Cf_wing_2D         * Geometry.Swet_Wing        * FF_wing * IF_wing)/  Geometry.Swing ;
Cd_F_Htail_2D               = (Cf_htail_2D        * Geometry.Swet_Htail       * FF_htail* IF_htail)/  Geometry.Swing ;
Cd_F_Vtail_2D               = (Cf_vtail_2D        * Geometry.Swet_Vtail       * FF_vtail* IF_vtail)/  Geometry.Swing ;

%% Now calculate Total CD_friction 
Cd_friction_2D  = Cd_F_fuselage_2D + Cd_F_wing_2D + Cd_F_Htail_2D + Cd_F_Vtail_2D;

% add something on top (leakage + protuberances, cooling) to get Cd0
k_misc                  = .07; %misc drag is 7 of total%
Cd0_misc_2D             = (Cd_friction_2D * k_misc) / (1- k_misc);
% of which
Cd0_leakage_protuberances_2D    = Cd0_misc_2D * .04/k_misc;
Cd0_cooling_2D                  = Cd0_misc_2D * .03/k_misc;

%--------------------------------------------------------------------------
Cd0_2D                  = Input_parameters.K_Cd0 * (Cd_friction_2D + Cd0_leakage_protuberances_2D + Cd0_cooling_2D);

if nargin == 6 % execute if this function was passed a cruise speed
    
    VbestLD_ms = varargin{1};
    h_cruise_index = find(h_vector_m == Input_parameters.h_cruise_abs);
    v_cruise_index = find(v_vector_ms == VbestLD_ms);
 
    Cd0_at_cruise = Cd0_2D(h_cruise_index,v_cruise_index);

    Cd0_components_at_cruise  = [Cd_F_fuselage_2D(h_cruise_index, v_cruise_index) Cd_F_wing_2D(h_cruise_index, v_cruise_index) Cd_F_Htail_2D(h_cruise_index, v_cruise_index)...
    Cd_F_Vtail_2D(h_cruise_index, v_cruise_index)];

    Cd0_percentages_at_cruise = Cd0_components_at_cruise./ sum(Cd0_components_at_cruise); % at assumed cruise
    % flat plate drag area at cruise point
    f_components_at_cruise = [Cd_F_fuselage_2D(h_cruise_index, v_cruise_index) Cd_F_wing_2D(h_cruise_index, v_cruise_index) Cd_F_Htail_2D(h_cruise_index, v_cruise_index)...
    Cd_F_Vtail_2D(h_cruise_index, v_cruise_index)]*Geometry.Swing;

    varargout{1} = Cd0_at_cruise;
    varargout{2} = Cd0_components_at_cruise; %
end