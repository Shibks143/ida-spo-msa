function sks_DS2_FragParam(PHRInputs)

tic
%% DS2 Significant Damage (Moderate Damage) % page 35 of D'ayala et al (2015)
    % the most critical column controls the state of the structure: the
    % limit state is attained when the rotation at one hinge of any column
    % exceeds 75% of the ultimate rotation.

%% Start of user input %%%%%%%%%%

bldgIDLIST =        PHRInputs.BldgIdLIST;
eqNumberLIST =      PHRInputs.eqNumberLIST;
chi_LimitStateDS2 = PHRInputs.chi_LimitStateDS2;
formatMode =        PHRInputs.formatMode; 

%%%%%%% End of user input %%%%%%% 

%% Calculations start
baseFolder = pwd;
numBldgs = size(bldgIDLIST, 2);
numEqs = size(eqNumberLIST, 2);
inputDetailsToSave.bldgIDLIST = bldgIDLIST;             inputDetailsToSave.eqLIST = eqNumberLIST;
%     inputDetailsToSave.saT1LIST = saT1LIST;           inputDetailsToSave.colIDLIST = colIDLIST;
    
%% 0. Execute the program for required building IDs
for i = 1%:2:numBldgs
%     clc; fprintf('Processing building- %i/%i ...\n', i, numBldgs);
    bldgID = bldgIDLIST{i};
        
    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID);
    cd(analysisTypeFolder); cd MatlabInformation                  % read colIDLIST from MatlabInfo directory of output folder
    colIDLIST = load('columnNumsAtEachStoryLISTOUT.out');
    colIDLIST = colIDLIST(:, 1:end-1); % remove leaning frame columns
    colIDLIST = reshape(colIDLIST, 1, numel(colIDLIST)); % reshape the matrix to an array 
    numCols = size(colIDLIST, 2); 
    cd(baseFolder);
    
%% 1. extract ultimate rotation from model file (.xlsm)
    for colIndex = 1:numCols
        colID = colIDLIST(colIndex);
        [thetaU_p(i, colIndex), thetaU_n(i, colIndex)] = fun1_extractThetaU(bldgID, colID); % outputs are algebraic value
    end
    
%% 2. extract maximum rotation from output file from each scaled levels of the applied time history
    for eqIndex = 1:numEqs
%         fprintf('Processing EQ- %i/%i EQ...\n', eqIndex, numEqs);
        clc; fprintf('Processing building- %i/%i, EQ- %i/%i ...\n', i, numBldgs, eqIndex, numEqs);
        eqNumber = eqNumberLIST(i, eqIndex);
        eqFolder = sprintf('EQ_%d', eqNumber);
        cd(analysisTypeFolder); cd(eqFolder);
        
% this list contains 100 in saLevels for non-conv cases, 
        load('DATA_collapseIDAPlotDataForThisEQ.mat', 'saLevelsForIDAPlotLIST');
        saT1LIST = saLevelsForIDAPlotLIST(2:end); % 2 to remove zero.
        saT1LIST(saT1LIST == 100) = [];
        saT1LIST = sort(saT1LIST, 'ascend');

%         load('DATA_CollapseResultsForThisSingleEQ.mat', 'saLevelForEachRun');
%         saLevelForEachRun(saLevelForEachRun == 0) = [];
%         saT1LIST = saLevelForEachRun;
        
        numSaLevels = size(saT1LIST, 2); 
        chiMax = []; % reset chiMax for every earthquake
        criticalColID = []; % reset criticalColID for every earthquake
        
        for scalingIndex = 1:numSaLevels
            saT1Val = saT1LIST(scalingIndex);
            for colIndex = 1:numCols
                colID = colIDLIST(colIndex);

                cd(baseFolder);
                [thetaM_p, thetaM_n] = fun2_extractThetaMax(bldgID, eqNumber, saT1Val, colID); % outputs are algebraic value
                
                chi_p(colIndex) = thetaM_p/thetaU_p(i, colIndex);
                chi_n(colIndex) = thetaM_n/thetaU_n(i, colIndex);
                chi(colIndex) = max(chi_p(colIndex), chi_n(colIndex)); 
                
                thetaMToSave{i, eqIndex}(scalingIndex, colIndex) = max(thetaM_p, thetaM_n); % thetaM's are algebraic value
            end
            [chiMax(scalingIndex), idMax] = max(chi); 
            criticalColID(scalingIndex) = colIDLIST(idMax);

        end
%% save and plot EQ-specific processed results (IDA, i.e., critical column damage versus Sa(Ta)
    cd(analysisTypeFolder); cd(eqFolder);
    save('DATA_criticalColDamage_IDA_ForThisEQ.mat', 'chiMax', 'saT1LIST', 'criticalColID');
    
% calculate ALL components
    % interpolate the obtained IDA for this TH, i.e., chiMax vs. saT1LIST at chi_DS2 = 0.75
    % A simple interpolation may not work, since IDAs are non-monotonous at times
        ix = find(chiMax  > chi_LimitStateDS2, 1);
        if isempty(ix)
            saT1_ds2_ALL(eqIndex) = saT1LIST(end);
        else
            saT1_ds2_ALL(eqIndex) = interp1([chiMax(ix-1), chiMax(ix)], [saT1LIST(ix-1), saT1LIST(ix)], chi_LimitStateDS2, 'pchip');
        end
        
% plot ALL component IDAs
        figure(100 + i);
        plot([0, chiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
        
        
% for odd time history TH, store chiMax and saT1LIST, in case it is controlling
        if mod(eqIndex, 2) == 1 
            chiMax_CompOne = chiMax;
            sasaT1LIST_CompOne = saT1LIST;
            % chiMax_CompTwo and saT1LIST_CompTwo need not be assigned since 
            % chiMax and saT1LIST from current eqIndex are available in next conditional statement
        end
        
% determine the controlling component and plot it
        if mod(eqIndex, 2) == 0 % for every second TH, find controlling component
            gmIndex = eqIndex/2;
            saT1_ds2_CompOne = saT1_ds2_ALL(eqIndex - 1);
            saT1_ds2_CompTwo = saT1_ds2_ALL(eqIndex);
            saT1_ds2_CTRL(gmIndex) = min(saT1_ds2_CompOne, saT1_ds2_CompTwo);
            
            % plot CTRL component IDA
            figure(200 + i);
            if saT1_ds2_CompOne < saT1_ds2_CompTwo
                plot([0, chiMax_CompOne], [0, sasaT1LIST_CompOne], 'b-o', 'LineWidth', 1); hold on; grid on;
            else
                plot([0, chiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
            end
        end
    end
        
    
%% save ALL and CTRL component IDAs in analysis directory
% -------- ALL Components --------
    cd(analysisTypeFolder)
    figure(100+i);
    sks_figureFormat(formatMode)
    xlabel('$\chi$')
    ylabel('$S_a(T_a)$')
    exportName = 'criticalColDamage_IDA_ALLComp';
    sks_figureExport(exportName);
    
% -------- CTRL Components --------   
    figure(200+i);
    sks_figureFormat(formatMode)
    xlabel('$\chi$')
    ylabel('$S_a(T_a)$')
    exportName = 'criticalColDamage_IDA_CTRLComp';
    sks_figureExport(exportName);

%% Calculate statistics for ds2 for both ALL and CTRL components    
    meanLnDS2SaAllComp = exp(mean(log(saT1_ds2_ALL)));
    stDevLnDS2SaAllComp = std(log(saT1_ds2_ALL));
    minDS2LevelSaAll = min(saT1_ds2_ALL);
    maxDS2LevelSaAll = max(saT1_ds2_ALL);
    
    meanLnDS2SaCtrlComp = exp(mean(log(saT1_ds2_CTRL)));
    stDevLnDS2SaCtrlComp = std(log(saT1_ds2_CTRL));
    minDS2LevelSaCtrl = min(saT1_ds2_CTRL);
    maxDS2LevelSaCtrl = max(saT1_ds2_CTRL);
    
    saT1_ds2ALL_LIST(i, :) = saT1_ds2_ALL;
    saT1_ds2CTRL_LIST(i, :) = saT1_ds2_CTRL;
    
%% Save processed results 
    eqLIST = eqNumberLIST(i, :);
    save('DATA_criticalCol_ds2_SaAndStats.mat', 'saT1_ds2_ALL', 'saT1_ds2_CTRL', 'chi_LimitStateDS2', 'eqLIST', ...
        'meanLnDS2SaAllComp', 'stDevLnDS2SaAllComp', 'minDS2LevelSaAll', 'maxDS2LevelSaAll',...
        'meanLnDS2SaCtrlComp', 'stDevLnDS2SaCtrlComp', 'minDS2LevelSaCtrl', 'maxDS2LevelSaCtrl');
    
    cd(baseFolder);
end            
cd(baseFolder);

toc