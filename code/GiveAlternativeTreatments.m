%% Give Alternative Treatments

% Load Patient Data
load('../data/TrialPatientData.mat')

% Load optimized parameters [yS(0), yR(0), alpha_RS, beta_SC]
load('../data/optimizedModelFits.mat')

% Create patient name vector
patientNames = {'P1001', 'P1002', 'P1003', 'P1004', 'P1005', 'P1006', 'P1007', 'P1009', 'P1010', 'P1011', 'P1012', 'P1014', 'P1015', 'P1016', 'P1017', 'P1018', 'P1020', ' C001', ' C002', ' C003', ' C004', ' C005', ' C006', ' C007', ' C008', ' C009', ' C010', ' C011', ' C012', ' C013', ' C014', ' C015'};

for patientIndex = 1:1:size(patientNames, 2)
    disp(patientIndex)
    
    % Extract data from named patient data
    patientName = char(patientNames(patientIndex));
    data = eval(patientName);
    
    % Create time vectors
    t = 1:1:floor(data(end,1));
    t_max = max(t);
    
    % Create vector u from patient data
    u_original = createU(data(:,1), data(:,3));
    
    % Extract all optimized parameters [yS(0), yR(0), alpha_RS, beta_SC]
    optimizationParams = optimizedModelFits(patientIndex, :);
    
    % Solve with original
    [yS_original, yR_original, modeledPSA_original] = solveSRODE(optimizationParams, t_max, u_original);
    
    % Extract time of first abiraterone administration
    t_firstAbi = find(u_original == 1, 1, 'first');
    
    %% Give SOC
    % Clear our variables
    clear yS_NewSOC yR_NewSOC modeledPSA_NewSOC u_newSOC t_newSOC
    
    % Run and plot with SOC
    [yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC, u_newSOC, t_newSOC] = solveSRODE_SOC(optimizationParams, t_max, t_firstAbi);
    PlotAlternateTreatmentsFunction(patientName, data, t, u_original, yS_original, yR_original, modeledPSA_original, t_newSOC, u_newSOC, yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC)
     
     %Save 
     savename = ['../results/PatientFigures/AlternateTreatment_SOC/' char(patientNames(patientIndex)) '_SOC.png'];
     saveas(gcf, savename)
     pause(1.0)
     close(gcf)
    
    %% Give IAT
    % Clear our variables
    clear yS_NewSOC yR_NewSOC modeledPSA_NewSOC u_newSOC t_newSOC
    
    % Run and plot with IAT
    [yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC, u_newSOC, t_newSOC] = solveSRODE_IAT(optimizationParams, t_max, t_firstAbi);
    PlotAlternateTreatmentsFunction(patientName, data, t, u_original, yS_original, yR_original, modeledPSA_original, t_newSOC, u_newSOC, yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC)
    
    savename = ['../results/PatientFigures/AlternateTreatment_IAT/' char(patientNames(patientIndex)) '_IAT.png'];
    saveas(gcf, savename)
    pause(1.0)
    close(gcf)
    
    %% Give Adaptive
    % Clear our variables
    clear yS_NewSOC yR_NewSOC modeledPSA_NewSOC u_newSOC t_newSOC
    
    % Run and plot with Adaptive
    adaptivePercent = 0.5;
     [yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC, u_newSOC, t_newSOC] = solveSRODE_Adaptive(optimizationParams, t_max, t_firstAbi, adaptivePercent);
     PlotAlternateTreatmentsFunction(patientName, data, t, u_original, yS_original, yR_original, modeledPSA_original, t_newSOC, u_newSOC, yS_NewSOC, yR_NewSOC, modeledPSA_NewSOC)
     
     savename = ['../results/PatientFigures/AlternateTreatment_Adaptive/' char(patientNames(patientIndex)) '_ADAPTIVE.png'];
     saveas(gcf, savename)
     pause(1.0)
     close(gcf)
    
    
end