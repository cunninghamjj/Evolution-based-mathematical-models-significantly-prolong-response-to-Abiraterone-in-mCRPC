%% Plot Abi start densities at the time of initial treatment as a function of scan progression 

% Load Patient Data
load('../data/TrialPatientData.mat')

% Load optimized parameters [yS(0), yR(0), alpha_RS, beta_SC]
load('../data/optimizedModelFits.mat')

% TTP data from trial
TTP = [30.6;20;53.1;11;38;42.8;30.1;17;10.7;25.4;54;50;20.4;31.4;35.5;10.8;23;9;26;15;4.20;7;17.7;17.3;19.6;6.50;9;4;25;13.8;14.8;3.20];

patientNames = {'P1001', 'P1002', 'P1003', 'P1004', 'P1005', 'P1006', 'P1007', 'P1009', 'P1010', 'P1011', 'P1012', 'P1014', 'P1015', 'P1016', 'P1017', 'P1018', 'P1020', ' C001', ' C002', ' C003', ' C004', ' C005', ' C006', ' C007', ' C008', ' C009', ' C010', ' C011', ' C012', ' C013', ' C014', ' C015'};

% Exclude 1002 in analysis because progression data is unreliable. 16
% adaptive and only 15 SOC (31 total) because no PSA data available for one
% of the SOC patients so no model fits could be made. 
for patientIndex = 1:1:size(patientNames, 2)
   % Extract data from named patient data
    patientName = char(patientNames(patientIndex));
    data = eval(patientName);
    
    % Create time vectors
    t = 1:1:floor(data(end,1));
    t_max = max(t);
    
    % Create vector u from patient data
    u = createU(data(:,1), data(:,3));
    
    % Extract all optimized parameters [yS(0), yR(0), alpha_RS, beta_SC]
    optimizationParams = optimizedModelFits(patientIndex, :);
    
    % Solve with original
    [yS_original, yR_original, modeledPSA_original] = solveSRODE(optimizationParams, t_max, u);    
    
    % Extract densities at time of first Abiraterone Treatment.
    [ySAbiStart, yRAbiStart] = ExtractAbiStartDensities(u, yS_original, yR_original);
    
    all_YSAbiStart(patientIndex) = ySAbiStart;
    all_YRAbiStart(patientIndex) = yRAbiStart;

end


figure
hold on
hold on
    
% Fit for Adaptive patients
% Exclude P1002 because progression data is unreliable.
x = all_YRAbiStart([1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17])./all_YSAbiStart([1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]);
y = TTP([1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17])';

[p,S] = polyfit(x,y,1); 
[y_fit,delta] = polyval(p,x,S);
adaptiveTherapyPatients = plot(x,y,'^r', 'MarkerSize', 7, 'MarkerFaceColor', 'r');
hold on
AdaptiveFit = plot(x,y_fit,':r', 'LineWidth', 2)  ;
    
adaptiveR2 = 1 - (S.normr/norm(y - mean(y)))^2;


    
% Fit for SOC patients
% x = all_YRAbiStart(18:32);
x = all_YRAbiStart(18:32)./all_YSAbiStart(18:32);
y = TTP(18:32)';

[p,S] = polyfit(x,y,1);
[y_fit] = polyval(p,x,S);
SOCPatients = plot(x,y,'.k', 'MarkerSize', 16);
hold on
SOCPatientsFit = plot(x,y_fit,':k', 'LineWidth', 2);

SOCR2 = 1 - (S.normr/norm(y - mean(y)))^2;


xlabel('Ratio of Resistant/Sensitive Cells at the Time of Initial Abiraterone', 'FontSize', 22);
ylabel('Time to Scan Progression (Months)', 'FontSize', 22);
legend([SOCPatients, SOCPatientsFit, adaptiveTherapyPatients, AdaptiveFit], {'SOC Patients', 'SOC Linear Fit - R^2=0.76', 'Adaptive Therapy Patients', 'Adaptive Therapy Linear Fit - R^2=0.15'});

set(gca, 'FontSize', 12);

%% Save raw Figure 3
saveas(gcf, '../results/Figure3.png')
