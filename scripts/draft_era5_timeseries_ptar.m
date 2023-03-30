clear
close

fn = '../external_data/era5/era5_timeseries_ptar_point.nc';

ncdisp(fn)

lat = ncread(fn,'latitude');
lon = ncread(fn,'longitude');
msl = ncread(fn,'msl'); 
sst = double(ncread(fn,'sst')); 
sst = sst-273.15; % convert K to degC
u10 = ncread(fn,'u10');
v10 = ncread(fn,'v10');
u100 = ncread(fn,'u100');
v100 = ncread(fn,'v100');

time = ncread(fn,'time');

tncf = double(time);  % time in hours since 1900,1,1 00:00
tncf_days = tncf/24;
time_datenum_matlab = tncf_days + datenum(1900,1,1,0,0,0);
time = time_datenum_matlab;
% time = convert_era5_matlab_time(time);



% lat/long table:
tll = readtable('../external_data/ioc_station_latlong.csv');

for i = 1:6
    [~,ix ] = min( abs( lat-tll.Latitude(i) ) );
    ix_lat(i) = ix;
    [~,ix ] = min( abs( lon-tll.Longitude(i) ) );
    ix_lon(i) = ix;
end

ix = find(strcmp(tll.Station,'ptar'));

pres_ptar = squeeze(msl(ix_lon(ix),ix_lat(ix),:));
u10_ptar = squeeze(u10(ix_lon(ix),ix_lat(ix),:));
v10_ptar = squeeze(v10(ix_lon(ix),ix_lat(ix),:));
u100_ptar = squeeze(u100(ix_lon(ix),ix_lat(ix),:));
v100_ptar = squeeze(v100(ix_lon(ix),ix_lat(ix),:));
sst_ptar = squeeze(sst(ix_lon(ix),ix_lat(ix),:));
%%
figure
subplot(211)
plot(time,u100_ptar,time,u10_ptar), hold all
legend('U100','U10')
subplot(212)
plot(time,v100_ptar,time,v10_ptar), legend('V100','V10')



%%

% return;
addpath ~/Research/general_scripts/matlabfunctions/wavelet-coherence/
d = [time pres_ptar];
figure
[wave,period,scale,coi,sig95]=wt(d,'MakeFigure',1);

figure
[Wxy,period,scale,coi,sig95]=xwt(pres_ptar,sqrt(u10_ptar.^2 + v10_ptar.^2),'MakeFigure', 1,'ArrowDensity',[0 0]);

figure
sigmax = std(pres_ptar);
sigmay = std(sqrt(u10_ptar.^2 + v10_ptar.^2));
figure
subplot(4,1,1)
plot(time,pres_ptar)
subplot(4,1,2)
plot(time,sqrt(u10_ptar.^2 + v10_ptar.^2))

subplot(4,1,[3 4])
H=imagesc(time,log2(period),log2(abs(Wxy/(sigmax*sigmay))));%#ok

    clim=get(gca,'clim'); %center color limits around log2(1)=0
    clim=[-1 1]*max(clim(2),3);
    set(gca,'clim',clim)
set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',num2str(Yticks'), ...
        'layer','top')
    %xlabel('Time')
    ylabel('Period [hours]')
    hold on
t = time;
dt = 1;
        tt=[t([1 1])-dt*.5;t;t([end end])+dt*.5];
    hcoi=fill(tt,log2([period([end 1]) coi period([1 end])]),'w');
    set(hcoi,'alphadatamapping','direct','facealpha',.5)
% H=imagesc(time,log2(period),log2(abs(power/sigma2))); %#ok,log2(levels));  %*** or use 'contourfill'
        [c,h] = contour(t,log2(period),sig95,[1 1],'k','linewidth',1);%#ok


hold all
xl = xlim;
plot(xl,log2(515)*ones(2,1),'w--')
plot(xl,log2(324)*ones(2,1),'w--')


