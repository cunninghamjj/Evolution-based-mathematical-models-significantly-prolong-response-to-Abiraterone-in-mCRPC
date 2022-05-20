% Load Patient Data
load('../data/TrialPatientData.mat')

patientNames = {'P1001', 'P1002', 'P1003', 'P1004', 'P1005', 'P1006', 'P1007', 'P1009', 'P1010', 'P1011', 'P1012', 'P1014', 'P1015', 'P1016', 'P1017', 'P1018', 'P1020', ' C001', ' C002', ' C003', ' C004', ' C005', ' C006', ' C007', ' C008', ' C009', ' C010', ' C011', ' C012', ' C013', ' C014', ' C015'};

% For each patient.
for patientIndex = 1:size(patientNames, 2)
    
    % Extract data from trial data.
    data = eval(char(patientNames(patientIndex)));
    
    % Plot original data one section at a time.
    figure
    set(gca,'FontSize',20)
    hold on
    
    % Plot original data. Black when abi is off. Red when abi is on.
    for index = 1:size(data, 1)-1
        
        if data(index, 3) == 1
            
            plot([data(index,1),data(index+1,1)] ,[data(index,4), data(index+1,4)], 'r', 'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],...
                'MarkerSize',25,...
                'Marker','.',...
                'LineWidth',4,...
                'Color', 'r');
            
        else
            plot([data(index,1),data(index+1,1)] ,[data(index,4), data(index+1,4)], 'k', 'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
                'MarkerSize',25,...
                'Marker','.',...
                'LineWidth',4,...
                'Color', 'k');
            
        end
        
    end
    
    % Make it pretty.
    ylim([0, 1.1])
    xlim([0 1750])
    xlabel('Time (days)', 'FontSize', 20)
    ylabel('Normalized Clinical PSA', 'FontSize', 20)
    title(char(patientNames(patientIndex)));
    
    
     savename = ['../results/PatientFigures/OriginalTrialPSA/', char(patientNames(patientIndex)) '.png'];
     saveas(gcf, savename)
    
end