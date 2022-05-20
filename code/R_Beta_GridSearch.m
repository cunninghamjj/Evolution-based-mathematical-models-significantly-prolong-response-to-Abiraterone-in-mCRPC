%% Load in trial data.
%[Days, Raw PSA, Abi Status, Standardized to Patient Max PSA]
load('../data/TrialPatientData.mat')

%% Create patient name vector
patientNames = {'P1001', 'P1002', 'P1003', 'P1004', 'P1005', 'P1006', 'P1007', 'P1009', 'P1010', 'P1011', 'P1012', 'P1014', 'P1015', 'P1016', 'P1017', 'P1018', 'P1020', ' C001', ' C002', ' C003', ' C004', ' C005', ' C006', ' C007', ' C008', ' C009', ' C010', ' C011', ' C012', ' C013', ' C014', ' C015'};


% Intiate index for keeping track of all parameter combinations.
index = 0;
for beta_SC = 1:1:20
    for alpha_RS = 0:1:20
        
        disp(index)
        
        % Set total cohort RSME for this parameter combination to zero.
        totalRMSE = 0;

        for patientIndex = 1:size(patientNames, 2)
            
            % Extract data from named patient data
                patientName = char(patientNames(patientIndex));
                data = eval(patientName);
                
                % Create time vectors
                t = 1:1:floor(data(end,1));
                t_max = max(t);
                
                % Create vector u (treatment of abiraterone) from patient data
                u = createU(data(:,1), data(:,3));
                
                % Send in extra parameters
                f = @(optimizationParams)calculateRMSE(optimizationParams, data, t_max, u, beta_SC, alpha_RS);
            
                % Clear replicate data
                replicateData = [];
                
            for replicate = 1:1:1
                
                % Guess initial composition
                yS0guess = 1 + rand(1,1) * 9999;
                yR0Guess = 1 + rand(1,1) * 9999;
                
                % Form initial guess vector
                initialGuess = [yS0guess, yR0Guess];
                
                %     yS,    yR
                lb = [1,    1,];
                ub = [10000, 10000];
                
                options = optimoptions(@fmincon, 'Display', 'none');
                
                % Run optimal control to find optimized yS and yR.
                [optimalParameterValues, RMSE] = fmincon(f, initialGuess, [], [], [], [], lb, ub, [], options);
                
                % Save each replicate [RMSE, y(0):sensitive, y(0):resistant]
                replicateData(replicate,:) = [RMSE, optimalParameterValues];
                
            end
            
            %% Find index of the replicate data with the lowest RMSE
            bestFitIndex = find(replicateData(:,1) == min(replicateData(:,1)), 1);
            
            %% Add this lowest RMSE (best fit) to cohort wide (all 32 patients combined) total RMSE
            totalRMSE = totalRMSE + replicateData(bestFitIndex, 1);
            
            %% Save the best fit starting sensitive and resistant population densities of this patient
            bestFit_yS0_yR0(patientIndex,:) = replicateData(bestFitIndex, 2:3);
            
        end
        
        index = index + 1;

        % For this beta_SC and alpha_RS, save the cohort wide (all 32 patients combined) total RMSE
        allResults(index,:) = [beta_SC, alpha_RS, totalRMSE];
        
        % For this beta_SC and alpha_RS, save the best fit starting sensitive and resistant population densities for all patients [y(0):sensitive, y(0):resistant]
        saveName = ['../results/R_Beta_OptimalStartDensityData/r_' mat2str(beta_SC) 'beta_' mat2str(alpha_RS) '.mat'];
        save(saveName, 'bestFit_yS0_yR0');
                
    end
    
end

%% Save the matrix of [beta_SC, alpha_RS, totalRMSE]
save('../results/allGridSearchRMSE.mat', allResults)

%% Reshape for plotting
newX = reshape(allResults(:,1), 11, 10);
newY = reshape(allResults(:,2), 11, 10);
newZ = reshape(allResults(:,3), 11, 10);

%% Plotting for Figure 2
figure
surf(newX, newY, newZ)
axis equal

%% Save raw Figure 2
saveas(gcf, '../results/Figure2.png')



function [RMSE] = calculateRMSE(optimizationParams, data, t_max, u, beta_SC, alpha_RS)

[yS, yR, modeledPSA] = solveSRODE_GridSearch(optimizationParams, t_max, u, beta_SC, alpha_RS);

modeledPSA = modeledPSA./max(modeledPSA);

for dataTimePointsIndex = 1:size(data(:,1), 1)
    
    dataTimePoint = data(dataTimePointsIndex,1);
    
    if dataTimePoint == 0
        dataTimePoint = 1;
    end
    
    dataPSA = data(dataTimePointsIndex, 4) ;
    modelPSA = modeledPSA(floor(dataTimePoint));
    
    % Is this a change point?
    
    if (dataTimePointsIndex - 1 == 0)
        weight = 1;
    elseif (dataTimePointsIndex == size(data(:,1), 1))
        weight = 1;
    else
        
        currentU = data(dataTimePointsIndex, 3) ;
        previousU = data(dataTimePointsIndex - 1, 3) ;
        
        %% If same treatment as last time point: weight = 1. If this is a change point: weight = 5.
        if currentU == previousU
            weight = 1;
        else
            weight = 5;
        end
        
    end
    
    difference(dataTimePointsIndex) = (dataPSA - modelPSA) * weight;
    
end

RMSE = sqrt(sum (difference.^2 ./ size(difference(:,1), 1)));

end



