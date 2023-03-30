%
% clear;
close all;


fn = '../../sandbox/station_520006_var_28_1967_2023.csv';

d = readtable(fn);


DAY = d.Fecha;
TIME = d.Hora_UTC_;

date_string = char(DAY);
time_string = char(TIME);

idx = 1;
IL = length([date_string(idx,:),' ',time_string(idx,:)]);

Ts = char(zeros(length(date_string),IL));


for idx = 1:length(date_string)
Ts(idx,:) = [date_string(idx,:),' ',time_string(idx,:)];
end

t = datenum(Ts,'dd-mm-yyyy HH:MM');


%%
V_ms = d.ff_kt_/1.943844;
V_ms(V_ms==0) = NaN;
wdir = d.dd___;

md = 270 - wdir;

Uw = V_ms.*cosd(md);
Vw = V_ms.*sind(md);


return;
figure
histogram2(wdir,V_ms,[36 12],'facecolor','flat','normalization','probability')
view(2)



addpath /Users/mew/Downloads/windrose_230215

Properties = {'anglenorth',0,'angleeast',90,'labels',{'N (0º)','S (180º)','E (90º)','W (270º)'},'freqlabelangle',45};
[figure_handle,count,speeds,directions,Table,Others] = WindRose(wdir,V_ms,Properties);


ix = find(t<datenum(1968,1,1));
figure
[figure_handle,count,speeds,directions,Table,Others] = WindRose(wdir(ix),V_ms(ix),Properties);
title('1967')

%%
clear BE
normhist = NaN(2023-1968,36);

year_range = 1967:2023;

for i = year_range(2:end)
ix = find(and(t<datenum(i,1,1),t>=datenum(i-1,1,1)));

figure(10)
H = histogram(wdir(ix),'BinWidth',10,'BinLimits',[0 360]);

figure(91)
plot(H.BinEdges(1:end-1)+H.BinWidth/2,H.Values/max(H.Values)), hold all

normhist(i-year_range(1),:) = H.Values/max(H.Values);
BE(i-1967,:) = H.BinEdges(1:end-1)+H.BinWidth/2;

vel.max(i-year_range(1)) = max(V_ms(ix));
vel.std(i-year_range(1)) = std(V_ms(ix),'omitnan');
vel.med(i-year_range(1)) = median(V_ms(ix),'omitnan');
vel.mode(i-year_range(1)) = mode(V_ms(ix));
vel.mean(i-year_range(1)) = mean(V_ms(ix),'omitnan');

vel.np(i-year_range(1)) = length(ix); % number of points in year.

vbp{i-year_range(1)} = V_ms(ix);% for velocity box plot
dirbp{i-year_range(1)} = wdir(ix); % for direction box plot

end


vbpg = NaN(max(vel.np),length(vbp));
dirbpg = vbpg;
for i = 1:length(vbp)
    vbpg(1:length(vbp{i}),i) = vbp{i};
    dirbpg(1:length(vbp{i}),i) = dirbp{i};

end

yearstrings = compose('%d',year_range(1:end-1));

figure
boxplot(vbpg,'Labels',yearstrings)


figure()
boxplot(dirbpg,'Labels',yearstrings)




% BE = H.BinEdges(1:end-1)+H.BinWidth/2;
[tt,bb] = meshgrid(1968:2023,BE(3,:));

% pcolor(1967:2017,BE,normhist')
pcolor(tt,bb,normhist')
% datestr(t(end))

imagesc(year_range,BE(3,:),normhist')
%%
normhistmo = NaN(12,36);

for im = 1:12
ix_month = find(month(t)==im);
H = histogram(wdir(ix_month),'BinWidth',10);
figure(92)

normhistmo(im,:) = H.Values/max(H.Values);
end

pcolor(1:12,BE(3,:),normhistmo')





