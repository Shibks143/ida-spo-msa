function [fragParamMu_ALL, fragParamBetaRTR_ALL, fragParamMu_CTRL, fragParamBetaRTR_CTRL, imMin] = extractFragilityForDS_DayalaEtAl_v1(BldgId, GMsuiteName, eqLIST, damageState, T_new)
%% inputs
clc; tic
% damageState = 'DS4'; % DS1 Damage Limitation (Slight Damage) Operationability
%                      % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
%                          % DS2_normalizedByThetaU (based on chi) 
%                          % DS2_normalizedByThetaCap (based on xi) 
%                      % DS3 Near Collapse (Extensive Damage). Most critical column exceeds 100% of the ultimate rotation.
%                          % DS3_normalizedByThetaU  (based on chi) 
%                          % DS3_normalizedByThetaCap  (based on xi) 
%                      % DS4 Collapse 
% T_new = 0.37; % time period for spectral acceleration)
%               % 0.00 corresponds to PGA, 
%               % for truncated fragility the fragility function is zero for im < imMin

baseFolder = pwd;

%% extract period used for analysis (we cannot always assume it to be Ta)

[~, outpFolder, ~, ~] = returnModelFolderInfo(BldgId);
cd(baseFolder)

matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean', GMsuiteName);
load(fullfile(outpFolder, matFileToLoad), 'periodUsedForScalingGroundMotions');
T_ana = periodUsedForScalingGroundMotions;
T_old = T_ana; % T analysis is called here, T_old

%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
switch damageState
    case 'DS1' % DS1 Damage Limitation (Slight Damage) Operationability
        outFolder = fullfile(baseFolder, 'Output_Risk');
        % dirName = 'E:\OpenSees_PracticeExamples\ida-spo-msa\psb-risk-module';
        fileName = 'DS1_fragDataCS22_SaTa.mat';
        load(fullfile(outFolder, fileName), 'T');
        RDR_DS1 = T.RDR_DS1(strcmp(T.BldgID, BldgId), :);
        fileName = sprintf('DATA_roofDriftRat_%spc_SaAndStats.mat', strrep(num2str(round(RDR_DS1*100, 2), '%.2f'), '.', 'p'));
        load(fullfile(outpFolder, fileName), 'saT1_ds1_ALL');
        saT_oldAllComp = saT1_ds1_ALL;
        clearvars T saT1_ds1_ALL
        
    case 'DS2_normalizedByThetaU' % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
        % chi (= thetaM/thetaU) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_chi_%s_SaAndStats.mat', strrep(num2str(round(0.75, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL');
            saT_oldAllComp = saT1_ds2_ALL;
            clearvars saT1_ds2_ALL
    case 'DS2_normalizedByThetaCap' % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
        % xi (= thetaM/thetaCap) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_xi_%s_SaAndStats.mat', strrep(num2str(round(0.75, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL_xi');
            saT_oldAllComp = saT1_ds2_ALL_xi;
            clearvars saT1_ds2_ALL_xi

    case 'DS2a_0p60_normalizedByThetaU' % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
        % chi (= thetaM/thetaU) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_chi_%s_SaAndStats.mat', strrep(num2str(round(0.60, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL');
            saT_oldAllComp = saT1_ds2_ALL;
            clearvars saT1_ds2_ALL
    case 'DS2a_0p60_normalizedByThetaCap' % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
        % xi (= thetaM/thetaCap) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_xi_%s_SaAndStats.mat', strrep(num2str(round(0.60, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL_xi');
            saT_oldAllComp = saT1_ds2_ALL_xi;
            clearvars saT1_ds2_ALL_xi            
            
    case 'DS2a_0p50_normalizedByThetaU' % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
        % chi (= thetaM/thetaU) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_chi_%s_SaAndStats.mat', strrep(num2str(round(0.50, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL');
            saT_oldAllComp = saT1_ds2_ALL;
            clearvars saT1_ds2_ALL
    case 'DS2a_0p50_normalizedByThetaCap' % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
        % xi (= thetaM/thetaCap) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_xi_%s_SaAndStats.mat', strrep(num2str(round(0.50, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL_xi');
            saT_oldAllComp = saT1_ds2_ALL_xi;
            clearvars saT1_ds2_ALL_xi

    case 'DS2a_0p40_normalizedByThetaU' % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
        % chi (= thetaM/thetaU) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_chi_%s_SaAndStats.mat', strrep(num2str(round(0.40, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL');
            saT_oldAllComp = saT1_ds2_ALL;
            clearvars saT1_ds2_ALL
    case 'DS2a_0p40_normalizedByThetaCap' % DS2 Significant Damage (Moderate Damage). Most critical column exceeds 75% of the ultimate rotation.
        % xi (= thetaM/thetaCap) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_xi_%s_SaAndStats.mat', strrep(num2str(round(0.40, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL_xi');
            saT_oldAllComp = saT1_ds2_ALL_xi;
            clearvars saT1_ds2_ALL_xi
            
    case 'DS3_normalizedByThetaU' % DS3 Near Collapse (Extensive Damage). Most critical column exceeds 100% of the ultimate rotation.
        % chi (= thetaM/thetaU) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_chi_%s_SaAndStats.mat', strrep(num2str(round(1.00, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL');
            saT_oldAllComp = saT1_ds2_ALL;
            clearvars saT1_ds2_ALL
    case 'DS3_normalizedByThetaCap' % DS3 Near Collapse (Extensive Damage). Most critical column exceeds 100% of the ultimate rotation.        
        % xi (= thetaM/thetaCap) used as critical column parameter
            fileName = sprintf('DATA_criticalCol_xi_%s_SaAndStats.mat', strrep(num2str(round(1.00, 2), '%.2f'), '.', 'p'));
            load(fullfile(outpFolder, fileName), 'saT1_ds2_ALL_xi');
            saT_oldAllComp = saT1_ds2_ALL_xi;
            clearvars saT1_ds2_ALL_xi
        
    case 'DS4' % DS4 Collapse
        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', GMsuiteName);
        storyDrift = 0.00; % proxy for collapse
        [~, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolder, eqLIST, storyDrift, matFileToLoad); % T_old = T_ana is extracted for all damage states
end

cd(baseFolder); % now we are in the original directory
        
%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)
% (6-28-19, PSB) extract fragility with PGA as Intensity Measure
for eqIndex = 1:length(eqLIST)
    eqNumber = eqLIST(eqIndex);
    if abs(T_new - T_old) < 1e-3 % when analysis and new time period are close
        ratioOfSaTnewToSaTold1 = 1;
    else
        ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new); % for PGA (modified the function for considering PGA)
    end
    saT_newAllComp(eqIndex) = ratioOfSaTnewToSaTold1* saT_oldAllComp(eqIndex);
end

%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters
    saT_newCtrlComp = zeros(1, length(eqLIST)/2);

    for gmIndex = 1:length(eqLIST)/2
        saT_newCompOne = saT_newAllComp(gmIndex * 2 - 1);
        saT_newCompTwo = saT_newAllComp(gmIndex * 2);
        saT_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
    end

    % Do collapse statistics - for all components
    meanCollapseSaTOneAllComp = mean(saT_newAllComp);
    medianCollapseSaTOneAllComp = (median(saT_newAllComp));
    meanLnCollapseSaTOneAllComp = mean(log(saT_newAllComp));
    stDevCollapseSaTOneAllComp = std(saT_newAllComp);
    stDevLnCollapseSaTOneAllComp = std(log(saT_newAllComp));
    imMin = min(saT_newAllComp); % same as imMinAll or imMinCtrl 
%     imMinAll = min(IM_newAllComp);
    
    % Do collapse statistics - for controlling components
    meanCollapseSaTOneControlComp = mean(saT_newCtrlComp);
    medianCollapseSaTOneControlComp = (median(saT_newCtrlComp));
    meanLnCollapseSaTOneControlComp = mean(log(saT_newCtrlComp));
    stDevCollapseSaTOneControlComp = std(saT_newCtrlComp);
    stDevLnCollapseSaTOneControlComp = std(log(saT_newCtrlComp));
%     imMinCtrl = min(IM_newAllComp);
    
%     fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
%     fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';

    fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp);
    fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp;		
    fragParamMu_CTRL = exp(meanLnCollapseSaTOneControlComp);
    fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneControlComp;	

% toc