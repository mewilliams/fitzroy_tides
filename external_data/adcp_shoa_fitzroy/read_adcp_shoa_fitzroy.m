clear
close all

fn = 'Angostura Santa Cruz_ canal Fitz Roy_2016.csv';

fid = fopen(fn);

for i = 1:61
    tline = fgetl(fid);
end

data = textscan(fid,repmat('%f',1,52),'Delimiter',',');
fclose(fid)

% 2016,4,11,12,20,13.7

NM_m = data{7};

% tvec = [data{1},data{2},data{3},data{4},data{5},data{6}];

t = datenum(data{1},data{2},data{3},data{4},data{5},data{6});

for ix = 8:29
    if ix == 8
        velmag = data{ix};
    elseif ix>8
        velmag = [velmag, data{ix}];
    end
end

for ix = 31:52
    if ix == 31
        veldir = data{ix};
    elseif ix>8
        veldir = [veldir, data{ix}];
    end
end


figure
plot(t,data{8})


