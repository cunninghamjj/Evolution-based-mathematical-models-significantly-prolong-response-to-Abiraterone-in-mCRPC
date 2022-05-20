%function [] = PlotHypotheticalAlphaComparison(t_NewSOC, modeledPSA_NewSOC, yS_NewSOC, yR_NewSOC)

modeledPSA_NewSOC = modeledPSA_NewSOC./max(modeledPSA_NewSOC);

subplot(2, 1, 1)
hold on

for index = 1:size(t_NewSOC, 2)-1
    
    %% Plot modeled data
    if u_NewSOC(index) == 1
        
        plot([t_NewSOC(index),t_NewSOC(index+1)] ,[modeledPSA_NewSOC(index), modeledPSA_NewSOC(index+1)], 'Color',[255/255, 76/255, 76/255], 'LineWidth',5);
        
    else
        plot([t_NewSOC(index),t_NewSOC(index+1)] ,[modeledPSA_NewSOC(index), modeledPSA_NewSOC(index+1)], 'Color',[150/255 150/255 150/255], 'LineWidth',5);
    end

    
end
ylim([0, 1.1])
xlim([0 1750])
xlabel('Days')
ylabel({'Modeled PSA'})
set(gca,'FontSize', 16)
% legend(gca, modeledPSA_OriginalHandle, 'Modeled PSA');
box on



%% Plot population density of new treatment
subplot(2, 1, 2)
S = plot(t_NewSOC, yS_NewSOC, 'b', 'LineWidth',3);
hold on
R = plot(t_NewSOC, yR_NewSOC, 'r', 'LineWidth',3);
ylim([0 10000])
xlim([0 1750])
% title('Modeled 50% Adaptive Therapy Densities')
xlabel('Days')
ylabel({'Population Densities'})
legend([S, R], {'Sensitive', 'Resistant'})
set(gca,'FontSize', 16)