
% testing reconstructing single component of water level:
% eta = a*sin(omega*t + phi) 
% phi: phase, omega angular frequency. 
% possibly should be omega*t - phi, but looks ok with the below. 

load('t_tideFitzRoy.mat')

figure
plot(time_xout.otway,xout.otway), hold all
am2 = 0.51; % amplitude of M2
pham2 = 1.82; % phase of M2
Tm2 = 12.4;

% time_xout.otway units are days, mulitply by 24 for hours
% water level M2:
wlm2 = am2*sin(2*pi*(time_xout.otway*24)/(Tm2) + pham2);
plot(time_xout.otway,wlm2)




%%

% find index for M2. (tiene que haber mejor manera de hacer esto...)
for i = 1:length(NAME)
    ism2 = strcmp(NAME(i,:),'M2  ');
    if ism2 == 1
        ixM2 = i;  
        return;
    end
end

%%

% from the internet
%tide_names=['S2';'M2';'N2';'K2';'K1'; 'P1';'O1';'Q1'];
%t_tide(elevation,'start time',[2010,1,1,0,0,0],'rayleigh',tide_names);