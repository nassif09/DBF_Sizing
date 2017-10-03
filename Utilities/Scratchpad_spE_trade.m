% x = 0:.1:4*pi;
%  plot(x,sin(x));
%  addaxis(x,sin(x-pi/3));
%  addaxis(x,sin(x-pi/2),[-2 5],'linewidth',2);
%  addaxis(x,sin(x-pi/1.5),[-2 2],'v-','linewidth',2);
%  addaxis(x,5.3*sin(x-pi/1.3),':','linewidth',2);
% 
%  addaxislabel(1,'one');
%  addaxislabel(2,'two');
%  addaxislabel(3,'three');
%  addaxislabel(4,'four');
%  addaxislabel(5,'five');












SpE = [200:20:300];
TOGW=[1022 951 898 857 824 798];
E=[37.4 35.3 33.8 32.6 31.7 30.9];
plot(SpE, TOGW,'k-', 'linewidth',2)
addaxis(SpE,E,[30 40],'r--','linewidth',2)
addaxislabel(2,'Energy use in kW.h');

set(gcf,'color','w');
xlabel('Battery Specific Energy in W.hr/kg');
ylabel('Takeoff Gross Weight in kg');