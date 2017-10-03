
H= 0:0.1:10600;
[rho,temp,pres,a,kvisc] = stdatmo_mars(H);
figure(1)
plot(H/1000,temp); grid on
xlabel('Height(km)')
ylabel('Temperature(K)')
set(gcf,'Color',[1 1 1]);
figure(2)
plot(H/1000,rho); grid on
xlabel('Height(km)')
ylabel('Density(kg/m^3)')
set(gcf,'Color',[1 1 1]);
figure(3)
plot(H/1000,pres); grid on
xlabel('Height(km)')
ylabel('Pressue(Pa)')
set(gcf,'Color',[1 1 1]);
