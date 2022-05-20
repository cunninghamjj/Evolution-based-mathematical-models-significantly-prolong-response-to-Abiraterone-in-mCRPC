
%% Create a hypothetical patient to show the effect of alpha_RS. 

optimizationParams(1) = 5000;
optimizationParams(2) = 1000;
optimizationParams(4) = 8;

t_max = 1750;
t_firstAbi = 1;
adaptivePercent = 0.5;

%% For alpha_RS = 0.8
optimizationParams(3) = 0.8;

% Run and plot
[yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC, u_NewSOC, t_NewSOC] = solveSRODE_Adaptive(optimizationParams, t_max, t_firstAbi, adaptivePercent);
PlotHypotheticalAlphaComparison;

savename = ['../results/HypotheticalAlphaComparison/Alpha_08.png'];
saveas(gcf, savename)
pause(1.0)
close(gcf)


%% For alpha_RS = 2.0
optimizationParams(3) = 2.0;

[yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC, u_newSOC, t_newSOC] = solveSRODE_Adaptive(optimizationParams, t_max, t_firstAbi, adaptivePercent);
PlotHypotheticalAlphaComparison;

savename = ['../results/HypotheticalAlphaComparison/Alpha_2.png'];
saveas(gcf, savename)
pause(1.0)
close(gcf)


%% For alpha_RS = 6.0 
optimizationParams(3) = 6.0;

[yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC, u_newSOC, t_newSOC] = solveSRODE_Adaptive(optimizationParams, t_max, t_firstAbi, adaptivePercent);
PlotHypotheticalAlphaComparison;
     
savename = ['../results/HypotheticalAlphaComparison/Alpha_6.png'];
saveas(gcf, savename)
pause(1.0)
close(gcf)
