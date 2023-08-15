

clear
close all

% c = cbrewer('qual','Dark2',8);
c = [   0.1059    0.6196    0.4667
    0.8510    0.3725    0.0078
    0.4588    0.4392    0.7020
    0.9059    0.1608    0.5412
    0.4000    0.6510    0.1176
    0.9020    0.6706    0.0078
    0.6510    0.4627    0.1137
    0.4000    0.4000    0.4000];

load mag_puntos.mat
load time_puntos.mat
load u_puntos.mat
load v_puntos.mat

magnitude_velocity = sqrt(u_FR_prom.^2 + v_FR_prom.^2);
dens = 1015;

P = 0.5*dens*(magnitude_velocity.^3).*sign(atan2(v_FR_prom,u_FR_prom));

P_kW = P./1000;

% plot(time3,0.5*dens*(magU(i,:).^3).*sign(atan2(v_FR_prom(i,:),u_FR_prom(i,:))))

figure
subplot(3,1,1)
plot(time3,u_FR_prom(1,:),'color',c(1,:)), hold all
plot(time3,v_FR_prom(1,:),'color',c(2,:)), hold all
ylabel({'velocidad','[m/s]'})

subplot(3,1,2)
plot(time3,magnitude_velocity(1,:),'color',c(3,:))
ylabel({'velocidad','[m/s]'})


subplot(3,1,3)
plot(time3,P_kW(1,:),'k')
ylabel('P [kW/m^2]')
datetick2('x')

figure
figix = [1 2 3; 4 5 6; 7 8 9; 10 11 12; 13 14 15];

% for j = 1:3

for i = 1:5
   
    if i==5
subplot(5,3,figix(i,1))
    plot(time3,v_FR_prom(i,:),'color',c(2,:)), hold all
    plot(time3,u_FR_prom(i,:),'color',c(1,:))
ylabel({'velocidad','[m/s]'})
    ylim([-4 4])
    else

    subplot(5,3,figix(i,1))
    plot(time3,u_FR_prom(i,:),'color',c(1,:)), hold all
    plot(time3,v_FR_prom(i,:),'color',c(2,:))
ylabel({'velocidad','[m/s]'})
        ylim([-4 4])
if i==1
    title('(U,V)')
end

    end

    subplot(5,3,figix(i,2))
    plot(time3,magnitude_velocity(i,:),'color',c(3,:))
ylabel({'velocidad','[m/s]'})
    ylim([0 4.5])
    if i==1
title('$\sqrt{U^2 + V^2}$','Interpreter','latex')
end

    subplot(5,3,figix(i,3))
    plot(time3,P_kW(i,:),'k')
    ylabel('P [kW/m^2]')
   
    ylim([-50 20])
    if i==1
title('P')
end

end
% end
xlim([datenum(2021,4,2) datenum(2021,05,14)])


datetick2('x','keeplimits')

journal_figure_size_bs(15,15)


