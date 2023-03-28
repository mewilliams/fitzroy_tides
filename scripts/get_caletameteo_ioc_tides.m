% make text file of tides from caleta meteo (IOC sea level)
% warning: data are not QC'd
% Request data from SHOA for (hopefully) research quality.

clear
close all;


% cmet
% https://www.ioc-sealevelmonitoring.org/station.php?code=cmet
% pwil2 Puerto Williams
% ptar Punta Arenas
% ushu Ushuaia
% pedn Puerto Eden

addpath ~/Research/general_scripts/IOC_QQ_NOC/


datadir = '../external_data/caletameteo/';
mode = 'auto';
sitecode = 'cmet';

dateS = datenum(2021,11,1);
dateE = datenum(2022,8,1);
[sensornames]=readIOC(sitecode,dateS,dateE,datadir,mode);
%%
[sdate,slevel,sensorbasefile]=loadlocalIOC(datadir,sitecode,'prs',dateS,dateE);
plot(sdate,slevel,'.--'), hold on
[sdate,slevel,sensorbasefile]=loadlocalIOC(datadir,sitecode,'rad',dateS,dateE);
plot(sdate,slevel,'-')

legend('Pressure','Radar'), title('Caleta Meteo')


%%

[sdate,slevel,sensorbasefile]=loadlocalIOC(datadir,sitecode,'prs',dateS,dateE);

tunif = sdate(1):1/1440:sdate(end); % data every minute. 

% maybe better to use NaNs to generate an equal spacing time series.
wl1min = NaN(size(tunif));
for i = 1:length(wl1min)
    ix = find(sdate==tunif(i));
    if isfinite(ix)
        wl1min(i) = slevel(ix);
    end
end


figure
plot(sdate,slevel,'.-')
hold all
plot(tunif,wl1min)

readme = ['data created in get_caletameteo_ioc_tides.m on ',datestr(now)];

save('../external_data/caletameteo/cmet_prs_20211101_20220801.mat','sdate','slevel','tunif','wl1min','readme')


