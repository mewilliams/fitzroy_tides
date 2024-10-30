clear
close all

% purple-orange colormap. 
colmap = [    0.7020    0.3451    0.0235
    0.8784    0.5098    0.0784
    0.9922    0.7216    0.3882
    0.9961    0.8784    0.7137
    0.9686    0.9686    0.9686
    0.8471    0.8549    0.9216
    0.6980    0.6706    0.8235
    0.5020    0.4510    0.6745
    0.3294    0.1529    0.5333];

% folling these directions to get the data from the figure
% https://la.mathworks.com/matlabcentral/answers/100687-how-do-i-extract-data-from-matlab-figures
fig = openfig('~/Downloads/componentes fitz roy(1).fig');

% M2
subplot(2,2,1)
ampM2 = fig.CurrentAxes.Children.CData;
latM2 = fig.CurrentAxes.Children.LatitudeData;
lonM2 = fig.CurrentAxes.Children.LongitudeData;
% scatter(lonM2,latM2,10,ampM2,'filled')

% O1
subplot(2,2,2)
ampO1 = fig.CurrentAxes.Children.CData;
latO1 = fig.CurrentAxes.Children.LatitudeData;
lonO1 = fig.CurrentAxes.Children.LongitudeData;

% S2
subplot(2,2,3)
ampS2 = fig.CurrentAxes.Children.CData;
latS2 = fig.CurrentAxes.Children.LatitudeData;
lonS2 = fig.CurrentAxes.Children.LongitudeData;


% K1
subplot(2,2,4)
ampK1 = fig.CurrentAxes.Children.CData;
latK1 = fig.CurrentAxes.Children.LatitudeData;
lonK1 = fig.CurrentAxes.Children.LongitudeData;
%
% figure
% title('are these the same position?')
% plot(lonK1,latK1,'.'), hold all
% plot(lonM2,latM2,'o')
%
% figure
% plot(lonO1), hold all
% plot(lonM2)

F = (ampK1 + ampO1)./(ampM2 + ampS2);

figure
scatter(lonM2,latM2,10,F,'filled')
colormap(colmap) 

%%

figure
% compare amplitudes along the channel:
ax(1) = subplot(1,3,1);
plot(ampM2,latM2,'o')
hold all
plot(ampS2,latS2,'o')
plot(ampO1,latO1,'o')
plot(ampK1,latK1,'o')
legend('M2','S2','O1','K1','location','best')
xlabel('amplitude [m]')
ylabel('latitude')

ampM2max = max(ampM2);
ampS2max = max(ampS2);
ampO1max = max(ampO1);
ampK1max = max(ampK1);

ax(2) = subplot(1,3,2);
plot(ampM2./ampM2max,latM2,'p'), hold all
plot(ampS2./ampS2max,latS2,'p')
plot(ampO1./ampO1max,latO1,'p')
plot(ampK1./ampK1max,latK1,'p')
legend('M2','S2','O1','K1','location','best')
xlabel({'reduction from maximum','amplitude (amp/max)'})

% maybe better reduction from southernmost point: 
ix = find(latK1==min(latK1));
ampM2south = ampM2(ix);
ampS2south = ampS2(ix);
ampO1south = ampO1(ix);
ampK1south = ampK1(ix);

ax(3) = subplot(1,3,3);
plot(ampM2./ampM2south,latM2,'s'), hold all
plot(ampS2./ampS2south,latS2,'s')
plot(ampO1./ampO1south,latO1,'s')
plot(ampK1./ampK1south,latK1,'s')
legend('M2','S2','O1','K1','location','best')
xlabel({'reduction from southern-most',' amplitude (amp/amp_{south})'})

linkaxes(ax,'y')



figure
ax2(1) = subplot(1,3,1);
plot(ampM2,latM2,'o')
hold all
plot(ampS2,latS2,'o')
plot(ampO1,latO1,'o')
plot(ampK1,latK1,'o')
legend('M2','S2','O1','K1 ')
xlabel('amplitude [m]')
ylabel('latitude')


ax2(2) = subplot(1,3,2);
plot(ampM2south-ampM2,latM2,'s'), hold all
plot(ampS2south-ampS2,latS2,'s')
plot(ampO1south-ampO1,latO1,'s')
plot(ampK1south-ampK1,latK1,'s')
legend('M2','S2','O1','K1 ')
xlabel({'\Delta(amplitude) [m]'})

ax2(3) = subplot(1,3,3);

plot((ampM2south-ampM2)./ampM2south,latM2,'s'), hold all
plot((ampS2south-ampS2)./ampS2south,latS2,'s')
plot((ampO1south-ampO1)./ampO1south,latO1,'s')
plot((ampK1south-ampK1)./ampK1south,latK1,'s')
legend('M2','S2','O1','K1','location','best')
xlabel({'normalized \Delta(amplitude)'})
linkaxes(ax2,'y')

%
% axObjs = fig.Children;
% dataObjs = axObjs.Children;
%
% x = dataObjs(1).XData;
% y = dataObjs(1).YData;
% z = dataObjs(1).ZData;

