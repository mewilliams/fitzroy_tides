% tidal analysis, IOC tides, Magallanes
%
%
% datadir = '../external_data/caletameteo/';
% mode = 'auto';
% sitecode = 'cmet';
%
% dateS = datenum(2021,11,1);
% dateE = datenum(2022,8,1);
%
% [sdate,slevel,sensorbasefile]=loadlocalIOC(datadir,sitecode,'prs',dateS,dateE);
%
% tunif = sdate(1):1/1440:sdate(end); % data every minute.
%
% % maybe better to use NaNs to generate an equal spacing time series.
% wl1min = NaN(size(tunif));
% for i = 1:length(wl1min)
%     ix = find(sdate==tunif(i));
%     if isfinite(ix)
%         wl1min(i) = slevel(ix);
%     end
% end


clear

%
% cmet
% Latitude 	-52.96
% Longitude 	-74.066
latcmet = -52.96;
% ptar
% Latitude 	-53.123727
% Longitude 	-70.861985
latptar =  -53.123727;
% greg
% Latitude 	-52.648185118271
% Longitude 	-70.209173709045
latgreg =  -52.648185118271;
% pwil2
% Latitude 	-54.933197
% Longitude 	-67.61057
latpwil2 = -54.933197;
% ushu
% Latitude 	-54.817
% Longitude 	-68.217
latushu = -54.817;
% pedn
% Latitude 	-49.129945
% Longitude 	-74.408953
latpedn = -49.129945;


addpath ~/Research/general_scripts/matlabfunctions/
addpath ~/Research/general_scripts/matlabfunctions/UTideCurrentVersion/
addpath ~/Research/general_scripts/matlabfunctions/t_tide/
addpath ~/Research/general_scripts/IOC_QQ_NOC/

close all

% clear
% load ../external_data/caletameteo/cmet_prs_20211101_20220801.mat
% cnstit = 'auto';
% lat_cmet=-52.96;
%
% coef = ut_solv ( tunif, wl1min, [], lat_cmet, cnstit ,'NoTrend' );
% [ sl_fit, ~ ] = ut_reconstr ( tunif, coef );

inst_type = 'rad';


datadir = '../external_data/caletameteo/';
mode = 'auto';
sitecode = 'cmet';
latstn = latcmet;
dateS = datenum(2021,11,1);
dateE = datenum(2022,8,1);
disp(['running ',sitecode])


[sl_fit,tss,wlss] = run_utide_ioc_data(datadir,sitecode,dateS,dateE,latstn,inst_type);
figure
subplot(211)
plot(tss,wlss,'.'), hold all
plot(tss,sl_fit)
title(sitecode)
subplot(212)
plot(tss,wlss-sl_fit)
datetick2('x')
save([datadir,'draft_',sitecode,inst_type],'tss','wlss','sl_fit')

% 
% datadir = '../external_data/puertowilliams/';
% mode = 'auto';
% sitecode = 'pwil2';
% latstn = latpwil2;
% dateS = datenum(2019,1,1);
% dateE = datenum(2023,3,1);
% disp(['running ',sitecode])
% 
% 
% [sl_fit,tss,wlss] = run_utide_ioc_data(datadir,sitecode,dateS,dateE,latstn);
% figure
% subplot(211)
% plot(tss,wlss,'.'), hold all
% plot(tss,sl_fit)
% title(sitecode)
% subplot(212)
% plot(tss,wlss-sl_fit)
% datetick2('x')
% save([datadir,'draft_',sitecode],'tss','wlss','sl_fit')

%%



datadir = '../external_data/puntaarenas/';
mode = 'auto';
sitecode = 'ptar';
latstn = latptar;
dateS = datenum(2019,1,1);
dateE = datenum(2023,3,1);
disp(['running ',sitecode])

[sl_fit,tss,wlss] = run_utide_ioc_data(datadir,sitecode,dateS,dateE,latstn,inst_type);
figure
subplot(211)
plot(tss,wlss,'.'), hold all
plot(tss,sl_fit)
title(sitecode)
subplot(212)
plot(tss,wlss-sl_fit)
datetick2('x')
save([datadir,'draft_',sitecode,inst_type],'tss','wlss','sl_fit')

datadir = '../external_data/bahiagregorio/';
mode = 'auto';
sitecode = 'greg';
latstn = latgreg;
dateS = datenum(2019,1,1);
dateE = datenum(2023,3,1);
disp(['running ',sitecode])


[sl_fit,tss,wlss] = run_utide_ioc_data(datadir,sitecode,dateS,dateE,latstn,inst_type);
figure
subplot(211)
plot(tss,wlss,'.'), hold all
plot(tss,sl_fit)
title(sitecode)
subplot(212)
plot(tss,wlss-sl_fit)
datetick2('x')
save([datadir,'draft_',sitecode,inst_type],'tss','wlss','sl_fit')

datadir = '../external_data/puertoeden/';
mode = 'auto';
sitecode = 'pedn';
latstn = latpedn;
dateS = datenum(2019,1,1);
dateE = datenum(2023,3,1);
disp(['running ',sitecode])

[sl_fit,tss,wlss] = run_utide_ioc_data(datadir,sitecode,dateS,dateE,latstn,inst_type);
figure
subplot(211)
plot(tss,wlss,'.'), hold all
plot(tss,sl_fit)
title(sitecode)
subplot(212)
plot(tss,wlss-sl_fit)
datetick2('x')
save([datadir,'draft_',sitecode,inst_type],'tss','wlss','sl_fit')

% 
% inst_type = 'prs'
% inst_type = 'rad'


function [sl_fit,tss, wlss] = run_utide_ioc_data(datadir,sitecode,dateS,dateE,latstn,inst_type)

tic
[sdate,slevel,~]=loadlocalIOC(datadir,sitecode,inst_type,dateS,dateE);
toc 

tic

tic
sp = 1/1440; % spacing
tunif = sdate(1):sp:sdate(end); % data every minute.
tunif = round(tunif/sp)*sp; % round to the spacing. 

sdater = round(sdate/sp)*sp; % round to spacing, so we can equate them and save time
ixnan = ~ismember(tunif,sdater);
wleqsp = interp1(sdater,slevel,tunif);
wleqsp(ixnan) = NaN;
toc


% smooth via convolution and subsample so the tides are faster
k = ones(5,1);
k = k./sum(k);
wlc5 = conv(wleqsp,k,'same');
ss = 1:15:length(tunif);
tss = tunif(ss);
wlss = wlc5(ss);



% % maybe better to use NaNs to generate an equal spacing time series.
% wl1min = NaN(size(tunif));
% for i = 1:length(wl1min)
%     ix = find(sdate==tunif(i));
%     if isfinite(ix)
%         wl1min(i) = slevel(ix);
%     end
% end
% toc

cnstit = 'auto';
% lat_cmet=-52.96;

tic
coef = ut_solv ( tss, wlss, [], latstn, cnstit ,'NoTrend' );
[ sl_fit, ~ ] = ut_reconstr ( tss, coef );

toc


end





