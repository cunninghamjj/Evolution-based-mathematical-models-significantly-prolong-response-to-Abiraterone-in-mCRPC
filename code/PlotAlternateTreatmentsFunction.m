
function [] = PlotAlternateTreatmentsFunction(patientName, data, t, u_original, yS_originalSOC, yR_OriginalSOC, modeledPSA_OriginalSOC, t_NewSOC, u_NewSOC, yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC)

maxPSAforScaling = max(modeledPSA_OriginalSOC);
modeledPSA_OriginalSOC = modeledPSA_OriginalSOC./maxPSAforScaling;
modeledPSA_NewSOC = modeledPSA_NewSOC./maxPSAforScaling;


figure;
set(gcf, 'Position', [10, 10, 1250, 700]) 
subplot(2, 2, 1)
title({['                                                                                                      ' patientName] ; ''}, 'FontSize', 30);
hold on


for index = 1:size(data, 1)-1
   
    
    %% Plot original data
    if data(index, 3) == 1
        
        plot([data(index,1),data(index+1,1)] ,[data(index,4), data(index+1,4)], 'r', 'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],...
            'MarkerSize',25,...
            'Marker','.',...
            'LineWidth',2,...
            'Color', 'r');
        xlim([0 1750])
        
    else
        plot([data(index,1),data(index+1,1)] ,[data(index,4), data(index+1,4)], 'k', 'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
            'MarkerSize',25,...
            'Marker','.',...
            'LineWidth',2,...
            'Color', 'k');
        
    end
    
end


for index = 1:size(t, 2)-1
    
    %% Plot modeled data
    if u_original(index) == 1
        
        plot([t(index),t(index+1)] ,[modeledPSA_OriginalSOC(index), modeledPSA_OriginalSOC(index+1)], 'Color',[255/255, 76/255, 76/255], 'LineWidth',5);
        
    else
        plot([t(index),t(index+1)] ,[modeledPSA_OriginalSOC(index), modeledPSA_OriginalSOC(index+1)], 'Color',[150/255 150/255 150/255], 'LineWidth',5);
    end
    
end

clinicalPSA = plot([-1, -1],[-1, -1], 'r', 'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
            'MarkerSize',25,...
            'Marker','.',...
            'LineWidth',2,...
            'Color', 'r');

modeledPSA_OriginalHandle = plot([-1, -1],[-1, -1], 'Color',[150/255 150/255 150/255], 'LineWidth',5);

legend([clinicalPSA, modeledPSA_OriginalHandle], 'Clinic PSA', 'Modeled PSA');

set(gca, 'FontSize', 16)
ylim([0, 1.1])
xlim([0 1750])
xlabel('Days', 'FontSize', 16)
ylabel({'Patient PSA and'; 'Optimized Model Fit PSA'}, 'FontSize', 16)
box on

%% Plot population density of original treatment.
subplot(2, 2, 3)
S = plot(t, yS_originalSOC, 'b', 'LineWidth',3);
hold on
R = plot(t, yR_OriginalSOC, 'r', 'LineWidth',3);
ylim([0 10000])
xlim([0 1750])
xlabel('Days')
ylabel({'Modeled';'Population Densities'})
set(gca,'FontSize', 16)
legend([S, R], {'Sensitive', 'Resistant'})





subplot(2, 2, 2)
% title(['50% Adaptive Therapy: ', patientName]);
% title('Modeled Intermittent Therapy PSA');
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
ylabel({'New Treatment Modeled';'PSA'})
set(gca,'FontSize', 16)
% legend(gca, modeledPSA_OriginalHandle, 'Modeled PSA');
box on



%% Plot population density of new treatment
subplot(2, 2, 4)
S = plot(t_NewSOC, yS_NewSOC, 'b', 'LineWidth',3);
hold on
R = plot(t_NewSOC, yR_NewSOC, 'r', 'LineWidth',3);
ylim([0 10000])
xlim([0 1750])
% title('Modeled Intermittent Therapy Densities')
xlabel('Days')
ylabel({'New Treatment Modeled';'Population Densities'})
legend([S, R], {'Sensitive', 'Resistant'})
set(gca,'FontSize', 16)







