%% Plot Optimized Model Fits.
% 
% Load Patient Data
load('../data/TrialPatientData.mat')

% Load optimized parameters [yS(0), yR(0), alpha_RS, beta_SC]
load('../data/optimizedModelFits.mat')


patientNames = {'P1001', 'P1002', 'P1003', 'P1004', 'P1005', 'P1006', 'P1007', 'P1009', 'P1010', 'P1011', 'P1012', 'P1014', 'P1015', 'P1016', 'P1017', 'P1018', 'P1020', ' C001', ' C002', ' C003', ' C004', ' C005', ' C006', ' C007', ' C008', ' C009', ' C010', ' C011', ' C012', ' C013', ' C014', ' C015'};

 for patientIndex = 1:size(patientNames, 2)

    disp(patientIndex)
    
    % Extract data from named patient data
    patientName = char(patientNames(patientIndex));
    data = eval(patientName);
    
    % Create time vectors
    t = 1:1:floor(data(end,1));
    t_max = max(t);
    
    % Create vector u from patient data
    u = createU(data(:,1), data(:,3));

    % Solve the ODE with optimal parameters
    [yS, yR, modeledPSA] = solveSRODE(optimizedModelFits(patientIndex, :), t_max, u);
    
    PlotRSFunction(patientName, data, t, u, yS, yR, modeledPSA./max(modeledPSA));
    
    savename = ['../results/PatientFigures/OptimizedModelFits/' char(patientNames(patientIndex)) '_WithOptimizedFit.png'];
    saveas(gcf, savename)
    
end

