% 14 aug 2023
% m williams


clear
close all;

load tide_fvcom.mat

% check time interval, T_tide assumes 1 hour sampling interval (and evenly spaced) 
% start time: just the first time, not a vector. 

disp('the first 10 times in the SKYRING file are...:')
datestr(fvcom.sky.time(1:10)); % check the time vector




% [~,~,~,xoutfvcom.sky]=t_tide(fvcom.sky.level,'start time',fvcom.sky.time,'latitude',-52.670989,'output','t_tide_sky_fvcom.m');

% edited: 'start time',fvcom.sky.time(1)
[NAME,FREQ,TIDECON,XOUT]=t_tide(fvcom.sky.level,'interval',0.5,'start time',fvcom.sky.time(1),'latitude',-52.670989,'output','t_tide_sky_fvcom.txt');


figure
subplot(211)
plot(fvcom.sky.time,fvcom.sky.level), hold all
plot(fvcom.sky.time,XOUT)
title('Skyring FVCOM')


[NAME,FREQ,TIDECON,XOUT]=t_tide(fvcom.otway.level,'interval',0.5,'start time',fvcom.otway.time(1),'latitude',-52.670989,'output','t_tide_otway_fvcom.txt');
subplot(212)
plot(fvcom.otway.time,fvcom.otway.level), hold all
plot(fvcom.otway.time,XOUT)
title('Otway FVCOM')

%%

% find index for M2. (tiene que haber mejor manera de hacer esto...)
for i = 1:length(NAME)
    ism2 = strcmp(NAME(i,:),'M2  ');
    if ism2 == 1
        ixM2 = i;  
        return;
    end
end

ampM2 = TIDECON(ixM2,1);
phaseM2deg = TIDECON(ixM2,3);



% to specify tidal components (commented out, did not significantly improve
% things):
% 
% %% Force only a few constituents:
% 
% tide_names=['M2';'S2';'N2';'K2';'K1';'P1';'O1';'Q1';'S1';'M1'];
% shallow_comp = ['M4';'M6';'M8';'S4'];
% % t_tide(elevation,'start time',[2010,1,1,0,0,0],'rayleigh',tide_names);
% [NAME,FREQ,TIDECON,XOUT]=t_tide(fvcom.otway.level,'interval',0.5,'start time',fvcom.otway.time(1),'latitude',-52.670989,'rayleigh',tide_names,'shallow',shallow_comp,'output','t_tide_otway_fvcom_specific_constituents.txt');
% 
% figure
% plot(fvcom.otway.time,fvcom.otway.level), hold all
% plot(fvcom.otway.time,XOUT)

