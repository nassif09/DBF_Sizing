function [Geometry] = DBF_Geometry_Generation(Input_parameters,Geometry,MTOM,W_S,plotOption);


Geometry.AR  = Input_parameters.AR;   
Geometry.Swing = Input_parameters.nmax*MTOM*9.81/W_S;


Geometry.wingspan            = sqrt(Geometry.Swing*Geometry.AR);   %m
%Geometry.wing_mean_ac        = Geometry.wing_area / Geometry.wingspan;

%Root and tip chord
Geometry.c_root              = Geometry.Swing/Geometry.wingspan;
Geometry.c_tip               = Geometry.c_root * Geometry.wing_taper;

Geometry.mac_wing            = (2/3)*(Geometry.c_root+Geometry.c_tip ...
    - ((Geometry.c_root*Geometry.c_tip)/(Geometry.c_root+Geometry.c_tip))); %Kirschbaum



%wing coordinates
% x_wingroot_LE               = 0;
% x_wingtip_LE                =(Geometry.c_root - Geometry.c_tip)/2;
% x_wingtip_TE                = x_wingtip_LE + Geometry.c_tip;
% x_wingroot_TE               = Geometry.c_root;

% Fuselage assumptions
Geometry.max_fuse_width      =(2 + .5 + 2*Input_parameters.n_passenger_per_row)*.0254;        %in to m
Geometry.max_fuse_height     = 5*.0254; %in to m
n = Input_parameters.n_rows;
Geometry.l_cone                  = 4.5*.0254; %in to m
Geometry.l_fuselage_tube         = (0.25*(n-1)+(2*n) + .5)*.0254;  %in to m
Geometry.l_boom                  = 6*.0254; %in to m
Geometry.l_fuselage = Geometry.l_fuselage_tube + Geometry.l_boom + Geometry.l_cone;  %in to m
 




%tail moment arm
Geometry.l_tail              = 0.75*Geometry.l_fuselage;         %  based on raymer, 75% of fuselage length
%horiztonal tail
Geometry.Sht                 = Input_parameters.H_TVC * Geometry.mac_wing * Geometry.Swing / Geometry.l_tail;
Geometry.htail_AR            = 3.5;
Geometry.htailspan           = sqrt(Geometry.Sht * Geometry.htail_AR);
Geometry.c_ht                = Geometry.Sht / Geometry.htailspan;
%co ordinates
%fuselage co ordinates:
% x_fuselage_tip               = (x_wingroot_TE/2 - Input_parameters.aeroshell_dia/2);
% x_fuselage_conebase          = x_fuselage_tip+.2*Input_parameters.aeroshell_dia;
% x_fuselage_cuboidbase        = x_fuselage_conebase + .5*Input_parameters.aeroshell_dia;
% x_cylinder_cylinderbase      = x_wingroot_TE - .25*Geometry.c_root + Geometry.l_tail - .25*Geometry.c_ht;
% x_htail_LE                   = x_cylinder_cylinderbase;
% y_htail_LE                   = Geometry.htailspan /2;
% x_htail_TE                   = x_htail_LE + Geometry.c_ht;
% y_htail_TE                   = y_htail_LE;

%vtail
Geometry.Svt                 = Input_parameters.V_TVC * Geometry.wingspan * Geometry.Swing / Geometry.l_tail;
Geometry.vtail_AR            = 2;
Geometry.vtailspan           = sqrt(Geometry.Svt * Geometry.vtail_AR);
Geometry.c_vt                = Geometry.Svt / Geometry.vtailspan;

% Wetted areas 
Geometry.Swet_Fuselage       = pi * (Geometry.max_fuse_width/2) * (sqrt((Geometry.max_fuse_width*.5)^2 + (Geometry.l_cone*.0254)^2)) +...
    2*pi*(Geometry.max_fuse_width/2) * (Geometry.l_fuselage_tube) + 2*pi*.15*Geometry.l_boom;  
%assuming three parts = cone(.2*fuse _l) + cuboid(.65*fuse _ l) +
%tube(.55)
%* fuse _l)
Geometry.Swet_Wing      = 2.1 * Geometry.Swing - (Geometry.mac_wing * Geometry.max_fuse_width);
Geometry.Swet_Htail     = Geometry.Sht * 2;
Geometry.Swet_Vtail     = Geometry.Svt * 2;
Geometry.Swet_total = Geometry.Swet_Fuselage +Geometry.Swet_Wing + Geometry.Swet_Vtail +Geometry.Swet_Htail;
%Wing and emepennage assumptions
Geometry.tc_wing    = 0.18;
Geometry.tc_tail    = 0.12;
Geometry.fineness_ratio_fuse = (2 * Geometry.l_fuselage) / (Geometry.max_fuse_width + Geometry.max_fuse_height);


%Drawing the top configuration
% if strcmp(plotOption,'plotOn')
%  f=figure(1);
%     set(f,'name','Geometry','numbertitle','off');
%     hold on
%     plot([0,x_wingtip_LE,x_wingtip_TE,x_wingroot_TE,x_wingtip_TE,x_wingtip_LE,0],[0,Geometry.wingspan/2,Geometry.wingspan/2,0,-Geometry.wingspan/2,-Geometry.wingspan/2,0],'k-')
%     circle([x_wingroot_TE/2, 0],Input_parameters.aeroshell_dia /2,1000,'b-');
%     %plot([x_fuselage_tip,x_fuselage_conebase,x_fuselage_cuboidbase,x_fuselage_cuboidbase,x_cylinder_cylinderbase,x_htail_LE,x_htail_TE,x_htail_TE,x_htail_LE,x_cylinder_cylinderbase,x_fuselage_cuboidbase,x_fuselage_cuboidbase,x_fuselage_conebase,x_fuselage_tip],...
%     %[0,Geometry.max_fuse_width/2,Geometry.max_fuse_width/2,.05,.05,y_htail_LE,y_htail_TE,-y_htail_TE,-y_htail_LE,-.05,-.05,-Geometry.max_fuse_width/2,-Geometry.max_fuse_width/2,0],'r-')
%     plot([x_fuselage_cuboidbase,x_cylinder_cylinderbase,x_htail_LE,x_htail_TE,x_htail_TE,x_htail_LE,x_cylinder_cylinderbase,x_fuselage_cuboidbase],...
%         [.05,.05,y_htail_LE,y_htail_TE,-y_htail_TE,-y_htail_LE,-.05,-.05],'r-')
%         
%     ellipse(x_fuselage_tip + (.35*Input_parameters.aeroshell_dia),0,.35*Input_parameters.aeroshell_dia,Geometry.max_fuse_width/2);
%     
%     grid on
%     set(gcf,'Color',[1,1,1]);
%     axis equal
%     hold off
% end
 end