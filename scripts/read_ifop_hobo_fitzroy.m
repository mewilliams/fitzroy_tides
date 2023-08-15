clear;
addpath ~/Research/general_scripts/matlabfunctions/
% 
% ../external_data/Agua_estanciaGloria.csv
% ../external_data/Aire_estanciaGloria.csv
% ../external_data/Otway_agua_feb21.csv
% ../external_data/otway_aire_feb_2021.csv


fn = '../external_data/Agua_estanciaGloria.csv';

fn2022 = '../external_data/Mareografos_Skyring_2020_2021_2022/mareografos_21_22/Agua_estanciaGloria_0.csv'
fn = fn2022;

opts = detectImportOptions(fn);
opts.VariableTypes(2) = {'char'};
T_hobo = readtable(fn,opts);%c%,'HeaderLines',2);

t_hobo = datenum(T_hobo.DateTime_GMT_00_00,'mm/dd/yy HH:MM:SS PM');
% t_hobo_utc = t_hobo; % units suggest this time is in GMT-4. 


p_hobo_kpa = T_hobo.AbsPres_KPa_LGRS_N_20389093_SENS_N_20389093_;
% p_hobo_pa = T_hobo.AbsPres_Pa_LGRS_N_20389093_SENS_N_20389093_;
temp_hobo_C = T_hobo.Temp__C_LGRS_N_20389093_SENS_N_20389093_;


figure, 
subplot(211)
plot(t_hobo,temp_hobo_C,'.')
datetick('x')

subplot(212)
% plot(t_hobo,p_hobo_pa,'.--')
plot(t_hobo,p_hobo_kpa,'.--')


datetick('x')


return;

fnair = '../external_data/Aire_estanciaGloria.csv';
opts = detectImportOptions(fnair);
opts.VariableTypes(2) = {'char'};
T_air = readtable(fnair,opts);%c%,'HeaderLines',2);

t_air = datenum(T_air.DateTime_GMT_00_00,'mm/dd/yy HH:MM:SS PM');
pres_air_kpa = T_air.AbsPres_KPa_LGRS_N_10766366_SENS_N_10766366_;
Temp_air = T_air.Temp__C_LGRS_N_10766366_SENS_N_10766366_;


figure
subplot(212)
plot(t_air,pres_air_kpa)
subplot(211)
plot(t_air,Temp_air)

% retur n;

figure
plot(t_air,pres_air_kpa,t_hobo,p_hobo_pa/1000);

Pres_air_Pa = pres_air_kpa*1000;



% time axis: 
figure
plot(t_air-t_hobo(2:6630));
datetick('x')

%%

% pres_air_Pa = pres_air_kpa*1000;
figure
plot(t_air,p_hobo_pa(2:6630)/1000 - pres_air_kpa);  
hold all
plot(t_hobo,p_hobo_pa/1000)


prel = p_hobo_pa(2:6630) - Pres_air_Pa;
%%
figure
subplot(211)
plot(t_air,prel);  % Pa
ylabel('p rel')
subplot(212)
plot(t_hobo,p_hobo_pa)
ylabel('p hobo Pa')


figure
% subplot(211)
plot(t_air,prel/(9.8*1010));  % H
hold on
% subplot(212)
plot(t_hobo,(p_hobo_pa)/(9.8*1010)-10)
            %%
            figure
            plot(t_air,Pres_air_Pa)


[NAME,FREQ,TIDECON,XOUT]=t_tide(prel(6:end));

%%
figure
plot(t_air(6:end),prel(6:end)), hold all
plot(t_air(6:end),XOUT + mean(prel))


figure
plot(t_air(6:end),prel(6:end)-XOUT), hold all
