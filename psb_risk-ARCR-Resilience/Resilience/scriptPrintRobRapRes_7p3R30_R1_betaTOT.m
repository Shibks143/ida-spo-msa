clear;% tic; close all; 
baseFolder = pwd;

%% inputs
buildingIDLIST = {'1310v1_FF'; '1310v1_NF'; '1610v1_FF'; '1610v1_NF'; '1910v1_FF'; '1910v1_NF'};

% Scenario inputs
M = 7.3; Rjb = 30; % Joyner-Boore distance in km

for i = 1:size(buildingIDLIST, 1)
    buildingID = buildingIDLIST{i, 1};
    
    %% navigate to the directory and load resilience curve data
%     dirForFigures = sprintf('figures_res_%s_M%g_R%g', buildingID, M, Rjb);
    dirForFigures = sprintf('figures_resCombined_M%g_R%g_R1_betaTOT', M, Rjb);
    cd(dirForFigures);
%     load('ResData_raw.mat', 'timeArray', 'meanExpectedHousingFunction');
    rawDataMat = sprintf('ResData_raw_%s.mat', buildingID);
    load(rawDataMat, 'timeArray', 'meanExpectedHousingFunction');
    fprintf('Raw .mat file laoded from %s.\n', pwd);
    
    % calcualte robustness, rapidity, and Resilience
    robustness = meanExpectedHousingFunction(1);
    rapidity_daysLIST = [30, 180, 365, 545, 730];
    QtAfterDaysLIST = interp1(timeArray, meanExpectedHousingFunction, rapidity_daysLIST, 'pchip');
    rapidity_average_afterDays = (QtAfterDaysLIST - robustness) ./(rapidity_daysLIST/365);
    for i = 1:length(rapidity_daysLIST)
        t0_plus_th = rapidity_daysLIST(i);
        timeArrayForInteg = [timeArray(timeArray < t0_plus_th), t0_plus_th];
        housingForInteg = [meanExpectedHousingFunction(timeArray < t0_plus_th), QtAfterDaysLIST(i)];
        ReselienceAfterDays(i) = trapz(timeArrayForInteg, housingForInteg)/t0_plus_th;
    end
    
    cd(baseFolder); cd(dirForFigures);
    save('ResData_proc.mat');
    fprintf('Processed .mat file saved in %s.\n', pwd);
    cd(baseFolder);
    
    
    %% print robustness, rapidity, and resilience
    fprintf('------------------------------------------------\n');
    fprintf('For buildings ID- %s,\t robustness- %g%%\n', buildingID, robustness*100);
    fprintf('------------------------------------------------\n');
    
    daysLIST = rapidity_daysLIST'; Rapidity = rapidity_average_afterDays'; RES = ReselienceAfterDays';
    T = table(daysLIST, Rapidity, RES);
    disp(T);
    fprintf('Units of rapidity are year^(-1).\n');
    fprintf('------------------------------------------------\n');
    
    cd(baseFolder);RapResMatrix(i, :) = [Rapidity', RES'];
    clearvars -except 'baseFolder' 'M' 'Rjb' 'buildingIDLIST' 'i' 'RapResMatrix'
end