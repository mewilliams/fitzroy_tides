
% cmet
% https://www.ioc-sealevelmonitoring.org/station.php?code=cmet
% pwil2 Puerto Williams
% ptar Punta Arenas
% ushu Ushuaia
% pedn Puerto Eden
% greg Bahia Gregorio

addpath ~/Research/general_scripts/IOC_QQ_NOC/

mode = 'auto';
dateS = datenum(2019,1,1);
dateE = datenum(2023,3,1);

% 
% datadir = '../external_data/caletameteo/';
% sitecode = 'cmet';
% [sensornames]=readIOC(sitecode,dateS,dateE,datadir,mode);

% 
% datadir = '../external_data/puertowilliams/';
% sitecode = 'pwil2';
% [sensornames]=readIOC(sitecode,dateS,dateE,datadir,mode);

datadir = '../external_data/puntaarenas/';
sitecode = 'ptar';
[sensornames]=readIOC(sitecode,dateS,dateE,datadir,mode);

datadir = '../external_data/ushuaia/';
sitecode = 'ushu';
[sensornames]=readIOC(sitecode,dateS,dateE,datadir,mode);

datadir = '../external_data/puertoeden/';
sitecode = 'pedn';
[sensornames]=readIOC(sitecode,dateS,dateE,datadir,mode);

datadir = '../external_data/bahiagregorio/';
sitecode = 'greg';
[sensornames]=readIOC(sitecode,dateS,dateE,datadir,mode);

