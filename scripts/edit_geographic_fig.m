
%
% open the figure: componentes fitz roy.fig
fig = openfig('~/Downloads/componentes fitz roy(1).fig');

% get the graphics handle for the current axis
gx = get(gcf); % gcf: "get current figure"


% for 4 subplots, remove the lat/long text (for space)
% add amplitud label to colorbar
for i = 1:4
    subplot(2,2,i)

    % get the graphics handle for the current axis
    gxa = get(gca);
    gxa.LongitudeLabel.String = ''; % just for space.
    gxa.LatitudeLabel.String = '';

    cbax = colorbar;
    ylabel(cbax,'amplitud [m]')
end
% 
% % EDIT THIS: clim: colorbar limits.
subplot(2,2,1)
caxis([0.15 .45])

subplot(2,2,2)
caxis([0.05 0.35])

subplot(2,2,3)
caxis([0.05 0.35])

subplot(2,2,4)
caxis([0.6 0.9])
% 
% %

