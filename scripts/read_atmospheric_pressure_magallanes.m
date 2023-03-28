% march 2023
% m williams
% 
%



clear
close all


fn1 = '../external_data/meteorological/puntaarenas/PresAtm_NMM_202302.txt';
fid = fopen(fn1);

for i = 1:2
    fgetl(fid)
end

data = textscan(fid, '%s%s%f','Delimiter','\t','EmptyValue',NaN,'MultipleDelimsAsOne',true);
DAY = data{1};
TIME = data{2};
QFF_hpa = data{3};

date_string = char(DAY);
time_string = char(TIME);


for idx = 1:length(date_string)
    Ts(idx,:) = [date_string(idx,:),' ',time_string(idx,:)];
end

t = datenum(Ts,'dd-mm-yyyy HH:MM');

