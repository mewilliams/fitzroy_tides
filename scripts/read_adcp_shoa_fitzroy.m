clear
close all

fn = '../external_data/adcp_shoa_fitzroy/Angostura Santa Cruz_ canal Fitz Roy_2016.csv';

fid = fopen(fn);

for i = 1:61
    tline = fgetl(fid);
end

data = textscan(fid,repmat('%f',1,53),'Delimiter',',');
fclose(fid)

% 2016,4,11,12,20,13.7

NM_m = data{7};

% tvec = [data{1},data{2},data{3},data{4},data{5},data{6}];

t = datenum(data{1},data{2},data{3},data{4},data{5},data{6});

% from file: 
z = 2.1:1:24.1;
bin_prof_nmm = [23.80	22.80	21.80	20.80	19.80	18.80	17.80	16.80	15.80	14.80	13.80	12.80	11.80	10.80	9.80	8.80	7.80	6.80	5.80	4.80	3.80	2.80	1.80];

for ix = 8:30
    if ix == 8
        velmag = data{ix};
    elseif ix>8
        velmag = [velmag, data{ix}];
    end
end

for ix = 31:53
    if ix == 31
        veldir = data{ix};
    elseif ix>8
        veldir = [veldir, data{ix}];
    end
end


figure
plot(t,data{8})



u = velmag.*cosd(veldir);
v = velmag.*sind(veldir);

u = u./1000;
v = v./1000;


figure
subplot(2,1,1)
pcolor(t,z,u'), shading flat
caxis([-1.5 1.5])
cbax = colorbar;
ylabel(cbax, 'u = |U|cos(\theta)')
ylabel('z [m]')
title('ADCP, Fitzroy SHOA 2016')

subplot(2,1,2)
pcolor(t,z,v'), shading flat
caxis([-1.5 1.5])

cbax = colorbar;
ylabel(cbax,'v = |U|sin(\theta)')
ylabel('z [m]')
% datetick2('x')
colormap(cbrewer('div','RdYlBu',256/2))
datetick2('x','dd mmm')
subplot(2,1,2)
xlabel('2016')
journal_figure_size_bs(40,10)


figure
plot(u(:,5),v(:,5),'.')


figure
plot(t,mean(u,2,'omitnan'))
hold all
plot(t,mean(v,2,'omitnan'))
datetick2('x')
legend('<u> = |U|cos(\theta)','<v> = |U|sin(\theta)')
ylabel('Velocity [m/s]')
title('Depth-averaged Velocities, Fitzroy')



figure
plot(t,mean(u,2,'omitnan'))
ylabel('Velocity [m/s]')

yyaxis right
plot(t,NM_m), ylabel('Depth [m]')



figure
subplot(1,3,[1 2])
pcolor(t,z,(u-mean(u,2,'omitnan'))')

colorbar
shading flat
colormap(cbrewer('div','RdYlBu',256/2))
colormap(flipud(colormap))
cbax = colorbar;
ylabel(cbax,'U - depth-avg U [m/s]' )

ylabel('z [m]')
xlabel('2016')

datetick('x','dd mmm')

subplot(1,3,3)
plot(mean((u-mean(u,2,'omitnan')),'omitnan'),z)
xlabel('Velocity U - $\overline{U}$','interpreter','latex')
xlim([-.15 .15])
title('ADCP Fitzroy, U - $\overline{U}$','interpreter','latex')
xlabel('avg(Velocity U - $\overline{U}$)','interpreter','latex')




ubar = mean(u,2,'omitnan');
vbar = mean(v,2,'omitnan');
%%
clear i

[NAME,FREQ,TIDECON,XOUT]=t_tide(ubar + i*vbar); % ugly

%%
% with U_TIDE: 
% addpath('~/Research/general_scripts/matlabfunctions/UTideCurrentVersion/')


coef = ut_solv ( t, ubar, vbar, -52.734,'auto');
[ u_fit, v_fit ] = ut_reconstr( t, coef );

coef_wl = ut_solv ( t,NM_m,[], -52.734,'auto');
[ wl_fit ] = ut_reconstr( t, coef_wl );




figure
subplot(2,1,1)
plot(t,NM_m)
hold all
plot(t,wl_fit)
legend('Water level H','Tide(H)')
ylabel('Instrument Depth (m)')
datetick2('x','dd mmm')
subplot(2,1,2)
plot(t,ubar)
hold all
plot(t,u_fit)
legend('Depth-avg U','Tide(U)')
ylabel('velocity [m/s')
ylabel('velocity [m/s]')
xlabel('2016')
datetick2('x','dd mmm')


figure
plot(ubar-u_fit,NM_m-wl_fit,'.')
axis equal
xlabel('Tidal residual U (m/s)')
ylabel('Tidal residual water level (m)')
title('UTide analysis $\overline{U}$ and $H$','interpreter','latex')

% saveas(gcf,'~/Research/notes/images/202410/tidal_residual_Ubar_H.png')
