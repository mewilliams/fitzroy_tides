% test tidal prediction - uses t_tide and Utide to get coefficients from a
% year-long water level dataset. 
% UTide has a prediction fit to a timeseries you give it. 
% 23 march 2023
% m. williams 
%
% requires toolboxes: T_Tide and UTide
% 
% http://www.po.gso.uri.edu/~codiga/utide/utide.htm
% Codiga, D.L., 2011. Unified Tidal Analysis and Prediction Using the UTide Matlab Functions. 
% Technical Report 2011-01. Graduate School of Oceanography, University of Rhode Island, Narragansett, RI. 59pp.
% U Tide package: https://www.mathworks.com/matlabcentral/fileexchange/46523-utide-unified-tidal-analysis-and-prediction-functions
%
% t_tide: 
%     R. Pawlowicz, B. Beardsley, and S. Lentz, "Classical tidal harmonic analysis including
%     error estimates in MATLAB using T_TIDE", Computers and Geosciences 28 (2002), 929-937.
%   https://www.eoas.ubc.ca/~rich/

close all
clear

%path to t_tide:
addpath ~/Research/general_scripts/matlabfunctions/t_tide/
% path to UTide:
addpath ~/Research/general_scripts/matlabfunctions/UTideCurrentVersion/

returnhere = pwd;
% some tidal data here:
cd /Users/mew/TeachingUC/BIO327M/matlab/timescales/
load talcahuano_waterlevel_2016.mat
cd(returnhere)

n = T.Level;
t = T.Time;

tunif = datetime(2016, 1, 1):hours(1):datetime(2016, 12, 31);
% nunif = interp1(t,n,tunif); %interpolate across gaps in time. 

% maybe better to use NaNs to generate an equal spacing time series.
nhourly = NaN(size(tunif));
for i = 1:length(nhourly)
    ix = find(t==tunif(i));
    if isfinite(ix)
        nhourly(i) = n(ix);
    end
end

%verify the data are the same:
plot(t,n,'.--')
hold all
plot(tunif,nhourly)

% x = first:hours(1):last;

clear T

% t_tide analysis
[NAME,FREQ,TIDECON,XOUT]=t_tide(nhourly,'interval',1);
%%

% U Tide - has a prediction:
% U Tide package: https://www.mathworks.com/matlabcentral/fileexchange/46523-utide-unified-tidal-analysis-and-prediction-functions

tdn = datenum(tunif); % make datenum - for formatting of utide

% coef = ut_solv ( t_raw, sl_raw, [], lat, cnstit , {options} ); 
lat_talcahuano = -36.700846;
cnstit = 'auto';

%try this to get rid of the longterm trend? (no, didn't change result)
nhourly_zeroed = nhourly - mean(nhourly,'omitnan');

% coef = ut_solv ( tdn, nhourly, [], lat_talcahuano, cnstit  ); 
%  coef = ut_solv ( tdn, nhourly_zeroed, [], lat_talcahuano, cnstit  ); 

% try with  NoTrend 
coef = ut_solv ( tdn, nhourly_zeroed, [], lat_talcahuano, cnstit ,'NoTrend' ); 
% this eliminated the giant trend that was showing up
% in the Talcahuano data.
 


% fit to original time
[ sl_fit, ~ ] = ut_reconstr ( tdn, coef );
figure
plot(tdn,sl_fit), datetick('x')
hold all
plot(tdn,nhourly,'.')

%compare t_tide and u_tide:
figure, 
ax(1) = subplot(211);
plot(tdn,XOUT,tdn,sl_fit), legend('T_Tide','UTide')
datetick('x'), title('Talcahuano tide'), ylabel('water level [m]')
ax(2) = subplot(212); 
plot(tdn,XOUT-sl_fit), legend('T_Tide - UTide')
datetick('x'), ylabel({'water level difference [m]'})

linkaxes(ax,'x')



% fit to extended time
tlong = datenum(2016,1,1):1/24:datenum(2045,1,1);
[ sl_fit_long, ~ ] = ut_reconstr ( tlong, coef );

figure
% not great... 
plot(tlong,sl_fit_long), datetick('x')

