function sks_DS2_DS3_Process_FragParam(PHRInputs)


tic
baseFolder = pwd;

%% User inputs begins  
bldgIDLIST =              PHRInputs.BldgIdLIST;
eqNumberLIST =            PHRInputs.eqNumberLIST;
LimitStateValLIST =       PHRInputs.LimitStateValLIST;
executeProcessingStep =   PHRInputs.executeProcessingStep;
executePrintAndSaveStep = PHRInputs.executePrintAndSaveStep;
executeHistogramStep =    PHRInputs.executeHistogramStep;
formatMode =        PHRInputs.formatMode; 

% further input for step (1/3), if executed for ALL components
allComponentsProcessed = 0; % if ALL Components already processed and executing for other values of LimitState, set this to 1 and fun0a won't be executed, the step that takes longest.
% End of user input

%% (1/3) carrying out parameterized study over the limit of chi (= thetaM/thetaU) of most critical column
numBldgs = size(bldgIDLIST, 2);

if executeProcessingStep == 1
    parfor i = 1:numBldgs
        fprintf('Processing building- %i/%i...\n', i, numBldgs);
        bldgID_curr = bldgIDLIST{1, i}; % current building ID
        eqNumberLIST_curr = eqNumberLIST(i, :); % EQ list for current building ID
        figSeed = i;
        
        if allComponentsProcessed == 0 % if already processed once and executing program for merely a different value of LimitState, then we do not need to execute fun0a
            fun0a_processAndSaveIDA_DS2_AllComp_v1(bldgID_curr, eqNumberLIST_curr, figSeed);
        end
        
        for j = 1:size(LimitStateValLIST, 2)
            fprintf('Processing building- %i/%i, chi- %i/%i...\n', i, numBldgs, j, size(LimitStateValLIST, 2));
            LimitStateVal = LimitStateValLIST(1, j);
            figSeed1 = i * 100 + j; % just a unique number to avoid overlapping plots on same figure id
            %         [~] = fun0_fragParam_DS2_v1(bldgID_curr, eqNumberLIST_curr, LimitStateVal, figUniqueSeedForParfor);
            fun0b_extractFragParam_DS2_v1(bldgID_curr, eqNumberLIST_curr, LimitStateVal, figSeed1);
        end
    end
end

if executePrintAndSaveStep == 1
    
    %% (2/3) display fragility parameters
    T_all_chi = table(bldgIDLIST'); % initialize tables for display
    T_all_chi.Properties.VariableNames{1} = 'BldgID';
    
    T_ctrl_chi = T_all_chi;
    T_all_xi = T_all_chi;
    T_ctrl_xi = T_all_chi;
    
    %% 2.1 Extract fragility results
    for i = 1:numel(bldgIDLIST) 
        bldgID_curr = bldgIDLIST{i};
        % i = 1:size(bldgIDLIST, 2)  % can be used for multiple bldg IDs
        % bldgID_curr = bldgIDLIST{1, i}; % current building ID

        cd(baseFolder)
        [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID_curr);
        cd(analysisTypeFolder);
        
        for j = 1:size(LimitStateValLIST, 2)
            clc; fprintf('Processing building- %i/%i, chi- %i/%i...\n', i, size(bldgIDLIST, 2), j, size(LimitStateValLIST, 2));
            LimitStateVal = LimitStateValLIST(1, j);
            
            %% 2.2.1. using theta_U as normalizing parameter
%             fileName = sprintf('DATA_criticalCol_chi_%ip%i_SaAndStats.mat', floor(LimitStateVal), int8(LimitStateVal*100));
            fileName = sprintf('DATA_criticalCol_chi_%s_SaAndStats.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
            load(fileName, 'saT1_ds2_ALL', 'saT1_ds2_CTRL', 'LimitStateVal', 'eqLIST', ...
                'meanLnDS2SaAllComp', 'stDevLnDS2SaAllComp', 'minDS2LevelSaAll', 'maxDS2LevelSaAll',...
                'meanLnDS2SaCtrlComp', 'stDevLnDS2SaCtrlComp', 'minDS2LevelSaCtrl', 'maxDS2LevelSaCtrl');
            
            fragDataCurrAll = [meanLnDS2SaAllComp, stDevLnDS2SaAllComp];
            fragDataCurrCtrl = [meanLnDS2SaCtrlComp, stDevLnDS2SaCtrlComp];
            
            T_all_chi(i, j+1) = table(fragDataCurrAll);
            T_ctrl_chi(i, j+1) = table(fragDataCurrCtrl);
            
            if i == 1
                T_all_chi.Properties.VariableNames{j+1} = sprintf('fragParamsAll_chi_%s', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
                T_ctrl_chi.Properties.VariableNames{j+1} = sprintf('fragParamsCtrl_chi_%s', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
            end
            
            %% 2.2.2 using theta_cap as normalizing parameter
%             fileName1 = sprintf('DATA_criticalCol_xi_%ip%i_SaAndStats.mat', floor(LimitStateVal), int8(LimitStateVal*100));
            fileName1 = sprintf('DATA_criticalCol_xi_%s_SaAndStats.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
            load(fileName1, 'saT1_ds2_ALL_xi', 'saT1_ds2_CTRL_xi', 'LimitStateVal', 'eqLIST', ...
                'meanLnDS2SaAllComp_xi', 'stDevLnDS2SaAllComp_xi', 'minDS2LevelSaAll_xi', 'maxDS2LevelSaAll_xi',...
                'meanLnDS2SaCtrlComp_xi', 'stDevLnDS2SaCtrlComp_xi', 'minDS2LevelSaCtrl_xi', 'maxDS2LevelSaCtrl_xi');
            
            fragDataCurrAll_xi = [meanLnDS2SaAllComp_xi, stDevLnDS2SaAllComp_xi];
            fragDataCurrCtrl_xi = [meanLnDS2SaCtrlComp_xi, stDevLnDS2SaCtrlComp_xi];
            
            T_all_xi(i, j+1) = table(fragDataCurrAll_xi);
            T_ctrl_xi(i, j+1) = table(fragDataCurrCtrl_xi);
            
            if i == 1
                T_all_xi.Properties.VariableNames{j+1} = sprintf('fragParamsAll_xi_%s', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
                T_ctrl_xi.Properties.VariableNames{j+1} = sprintf('fragParamsCtrl_xi_%s', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
            end
            
        end
    end
    
    disp(T_all_chi);
    disp(T_ctrl_chi);
    disp(T_all_xi);
    disp(T_ctrl_xi);
    
    clearvars -except baseFolder bldgIDLIST eqNumberLIST LimitStateValLIST T_all_chi T_all_xi T_ctrl_chi T_ctrl_xi executeHistogramStep
    
  
    outFolder = fullfile(baseFolder, 'Output_Risk');
    fileNameToSave = 'DS2_DS3_fragDataCS22_SaTa';
    save(fullfile(outFolder, fileNameToSave), 'bldgIDLIST', 'eqNumberLIST', 'LimitStateValLIST', 'T_all_chi', 'T_all_xi', 'T_ctrl_chi', 'T_ctrl_xi');
    fprintf('Data file saved in: %s\n', outFolder);
end
cd(baseFolder)

%% (3/3) Histogram for failure mechanism
if executeHistogramStep == 1
    for i = 1:size(bldgIDLIST, 2)
        fprintf('Processing building- %i/%i...\n', i, size(bldgIDLIST, 2));
        bldgID_curr = bldgIDLIST{1, i}; % current building ID
        eqNumberLIST_curr = eqNumberLIST(i, :); % EQ list for current building ID
        for j = 1:size(LimitStateValLIST, 2)
%             fprintf('Processing building- %i/%i, chi- %i/%i...\n', i, size(bldgIDLIST, 2), j, size(LimitStateValLIST, 2));
            LimitStateVal = LimitStateValLIST(1, j);
            [a, b, c, d] = fun3_criticalColGivenLimitStateVal_v1(bldgID_curr, eqNumberLIST_curr, LimitStateVal);
            criticalColID_chi_LIST{i, 1}(j, :) = a;
            criticalColID_xi_LIST{i, 1}(j, :) = b;
            criticalFloorNum_chiBased{i, 1}(j, :) = c;
            criticalFloorNum_xiBased{i, 1}(j, :) = d;
        end
    end
    
    outFolder = fullfile(baseFolder, 'Output_Risk');
    fileNameToSave = 'DS2_DS3_criticalFloorDataCS22_SaTa';
    save(fullfile(outFolder, fileNameToSave), 'bldgIDLIST', 'eqNumberLIST', 'LimitStateValLIST', 'criticalColID_chi_LIST', 'criticalColID_xi_LIST', 'criticalFloorNum_chiBased', 'criticalFloorNum_xiBased');
    fprintf('Data file saved in: %s\n', outFolder);    
end
cd(baseFolder)

toc