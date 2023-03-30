


addpath ~/Research/general_scripts/matlabfunctions/m_map/

% fn = '../external_data/era5/test_8feb2023_era5.nc';
fn = '../external_data/era5/test_feb2023_era5.nc';
ncdisp(fn)


lat = ncread(fn,'latitude');
lon = ncread(fn,'longitude');
msl = ncread(fn,'msl'); 
sst = double(ncread(fn,'sst')); 
sst = sst-273.15; % convert K to degC
u10 = ncread(fn,'u10');
v10 = ncread(fn,'v10');

% return;


time = ncread(fn,'time');
time = convert_era5_matlab_time(time);



% lat/long table:
tll = readtable('../external_data/ioc_station_latlong.csv');

for i = 1:6
    [~,ix ] = min( abs( lat-tll.Latitude(i) ) );
    ix_lat(i) = ix;
    [~,ix ] = min( abs( lon-tll.Longitude(i) ) );
    ix_lon(i) = ix;
end

ix = find(strcmp(tll.Station,'pwil2'));
figure
plot(time,squeeze(msl(ix_lon(ix),ix_lat(ix),:)))
title(tll.Station(ix))

ix = find(strcmp(tll.Station,'cmet'));
pres_cmet = squeeze(msl(ix_lon(ix),ix_lat(ix),:));
u10_cmet = squeeze(u10(ix_lon(ix),ix_lat(ix),:));
v10_cmet = squeeze(v10(ix_lon(ix),ix_lat(ix),:));

ix = find(strcmp(tll.Station,'greg'));
pres_greg = squeeze(msl(ix_lon(ix),ix_lat(ix),:));
u10_greg = squeeze(u10(ix_lon(ix),ix_lat(ix),:));
v10_greg = squeeze(v10(ix_lon(ix),ix_lat(ix),:));

figure
plot(time,u10_greg,time,v10_greg), legend('U10 Bahia Gregorio','V10 BG')
return;




figure
subplot(211)
plot(time,pres_greg,time,pres_cmet), legend('Bahia Gregorio','Caleta Meteo'), title('Atmospheric Surface Pressure ERA5)')
ylabel('Surface Pressure [Pa]')
subplot(212)
plot(time,pres_greg - pres_cmet), legend('P_{Bahia Gregorio} - P_{Caleta Meteo}'), %title('Atmospheric Surface Pressure ERA5)')
ylabel('\DeltaP  [Pa]')
datetick2('x','keeplimits')


pg = normalize(pres_greg);
pcm = normalize(pres_cmet);
[c,lags] = xcorr(pg,pcm,200,'coeff' );
figure
subplot(211), plot(time,pg,time,pcm), legend('Gregorio','Caleta Meteo')
ylabel('Normalized P_{atm}')
subplot(212), plot(lags,c)
hold all
plot(lags(c==max(c))*ones(2,1),ylim,'k--'), legend('Gregorio lags C. Meteo...')
text(lags(c==max(c))+5,0,['lag = ',num2str(lags(c==max(c)))])
ylabel('R')







figure
for ix = 1:6
    plot(time,squeeze(msl(ix_lon(ix),ix_lat(ix),:))), hold all
end
legend(tll.Station)

figure
for ix = 2:4
    plot(time,squeeze(msl(ix_lon(ix),ix_lat(ix),:))), hold all
end
legend(tll.Station(2:4))



figure
subplot(2,1,1)
% m_proj('lambert','long',[-76 -60],'lat',[-56 -50]);
m_proj('utm','long',[-76 -60],'lat',[-56 -50]);
m_pcolor(lon,lat,msl(:,:,1)'), hold on
m_coast('line','color', 'k ','linewidth', 2)

% % add the stations - sea level:
% for i = 1:6
%     m_plot(tll.Longitude(i),tll.Latitude(i),'ro')
%     m_text(tll.Longitude(i)+.1,tll.Latitude(i),t.Station(i),'color','r')
%     hold all
% end

m_grid('box','fancy','tickdir','in');
title(['Mean Surface Pressure ', datestr(time(1),'dd mmm yyyy HH:MM')])
cbax = colorbar;
ylabel(cbax,'Surface Pressure [Pa]')
ca = caxis;




subplot(2,1,2)
m_proj('utm','long',[-76 -60],'lat',[-56 -50]);
m_pcolor(lon,lat,msl(:,:,13)')
m_coast('line','color', 'k ','linewidth', 2)
m_grid('box','fancy','tickdir','in');
title(['Mean Surface Pressure ', datestr(time(13),'dd mmm yyyy HH:MM')])
cbax = colorbar;
ylabel(cbax,'Surface Pressure [Pa]')
ca2 = caxis;
caxis([min(ca(1),ca2(1)) max(ca(2),ca2(2))])
subplot(211)
caxis([min(ca(1),ca2(1)) max(ca(2),ca2(2))])




figure
subplot(2,1,1)
m_proj('utm','long',[-76 -60],'lat',[-56 -50]);
m_pcolor(lon,lat,sst(:,:,1)')
m_coast('line','color', 'k ','linewidth', 2)
m_grid('box','fancy','tickdir','in');
title(['Sea Surface Temperature ', datestr(time(1),'dd mmm yyyy HH:MM')])
cbax = colorbar;
% ylabel(cbax,'Surface Pressure [Pa]')
% caxis([98930 101150])


subplot(2,1,2)
m_proj('utm','long',[-76 -60],'lat',[-56 -50]);
m_pcolor(lon,lat,sst(:,:,13)')
m_coast('line','color', 'k ','linewidth', 2)
m_grid('box','fancy','tickdir','in');
title(['Sea Surface Temperature ', datestr(time(13),'dd mmm yyyy HH:MM')])
cbax = colorbar;
% ylabel(cbax,'Surface Pressure [Pa]')
% caxis([98930 101150])



figure
ih = 5;
subplot(211)
m_proj('utm','long',[-76 -60],'lat',[-56 -50]);
m_coast('line','color', 'k ','linewidth', 2), hold all
[llon,llat] = meshgrid(lon,lat);
m_quiver(llon,llat,squeeze(u10(:,:,5))',squeeze(v10(:,:,ih))')
title(['10m Winds ', datestr(time(ih),'dd mmm yyyy HH:MM')])
m_grid('box','fancy','tickdir','in');

ih = ih+12;
subplot(212)
m_proj('utm','long',[-76 -60],'lat',[-56 -50]);
m_coast('line','color', 'k ','linewidth', 2), hold all
[llon,llat] = meshgrid(lon,lat);
m_quiver(llon,llat,squeeze(u10(:,:,5))',squeeze(v10(:,:,ih))')
title(['10m Winds ', datestr(time(ih),'dd mmm yyyy HH:MM')])
m_grid('box','fancy','tickdir','in');



function [time_datenum_matlab] = convert_era5_matlab_time(time_era5)

tncf = double(time_era5);  % time in hours since 1900,1,1 00:00
tncf_days = tncf/24;
time_datenum_matlab = tncf_days + datenum(1900,1,1,0,0,0);

end

