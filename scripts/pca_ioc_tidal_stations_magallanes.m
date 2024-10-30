

% clear
close all

load ../external_data/caletameteo/draft_cmetrad.mat
ix = isoutlier(wlss);
wlss(ix) = NaN;
tsscm = tss;
wlcm = wlss;
rcmet = fillmissing(wlss-sl_fit,'linear');  % residual.


load ../external_data/bahiagregorio/draft_gregrad.mat
ix = isoutlier(wlss);
wlss(ix) = NaN;
tssgreg = tss;
wlgreg = wlss;
rgreg = fillmissing(wlss-sl_fit,'linear');
ix = isoutlier(rgreg, 'threshold', 4);
rgreg(ix) = NaN;
rgreg = fillmissing(rgreg,'linear');

% ix = isoutlier(rgreg, 'movmedian', 1000);



load ../external_data/puertoeden/draft_pednrad.mat
ix = isoutlier(wlss);
wlss(ix) = NaN;
tsspedn = tss;
wlpedn = wlss;
rpedn = fillmissing(wlss-sl_fit,'linear');


load ../external_data/puntaarenas/draft_ptarrad.mat
ix = isoutlier(wlss);
wlss(ix) = NaN;
tssptar = tss;
wlptar = wlss;
rptar = fillmissing(wlss-sl_fit,'linear');
ix = isoutlier(rptar, 'threshold', 4);
rptar(ix) = NaN;
rptar = fillmissing(rptar,'linear');



%%  on inspection, time series ptar, pedn, and greg have the same time axis.

T = tssgreg;

WL = [wlpedn',wlptar',wlgreg'];
WL = detrend(WL,0,'omitnan');


for i = 1:3
    WL(:,i) = fillmissing(WL(:,i),'constant',0);
end

Resid = [rpedn',rptar',rgreg'];
R = detrend(Resid,0);


figure
subplot(211)

plot(T,WL)
subplot(212)
plot(T,R)

figure
[c,lags] = xcorr(detrend(rpedn),detrend(rptar));
plot(lags,c), title(num2str(lags(c==max(c))))

return;

[C,L] = eig(cov(R));
PC1 = R*C(:,1);
PC2 = R*C(:,2);
PC3 = R*C(:,3);

