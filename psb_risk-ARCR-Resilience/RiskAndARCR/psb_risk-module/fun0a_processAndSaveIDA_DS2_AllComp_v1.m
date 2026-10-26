function fun0a_processAndSaveIDA_DS2_AllComp_v1(bldgID, eqLIST, figUniqueSeedForParfor)
%% For faster processing, I have now replaced fun0 by splitting it into fun0a and fun0b
% fun0a processes and saves IDA for ALL component
% fun0b extracts fragility for different threshold values and saves IDA for CTRL components
% fun0 used to process IDA for each value of the threshold and thereby repeating tons of calculations 

% figUniqueSeedForParfor is used for plotting ALL Component IDAs in different figure windows
% If executed in sequence, this problem never really arises, so a default value would suffice. 
if ~exist('figUniqueSeedForParfor', 'var')
    figUniqueSeedForParfor = 1;
end
%% sample inputs
% bldgID = '2211v03_sca2'; % bldgIDLIST{2}
% eqLIST = [6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272];

% now input to fun0b_
% LimitStateVal = 0.75; % for DS2, limit over chi, the ratio of max rotation to ultimate rotation capacity

% clear; tic
%% DS2 Significant Damage (Moderate Damage) % page 35 of D'ayala et al (2015)
    % the most critical column cntrols the state of the structure: the
    % limit state is attained when the rotation at one hinge of any column
    % exceeds 75% of the ultimate rotation.

% LimitStateVal = 0.75; % for DS2, limit over chi, the ratio of max rotation to ultimate rotation capacity
% chi = rotation Ratio = thetaM/thetaU

% Do we need GMsuiteNameLIST?
% GMsuiteNameLIST = {'GMSetDel22_2211_Sca2', 'GMSetDel22_2211_Sca4', 'GMSetDel22_2213_Sca2', 'GMSetDel22_2213_Sca4', 'GMSetDel22_2215_Sca2', 'GMSetDel22_2215_Sca4', ...
%                    'GMSetGuw22_2219_Sca2', 'GMSetGuw22_2219_Sca4', 'GMSetGuw22_2221_Sca2', 'GMSetGuw22_2221_Sca4', 'GMSetGuw22_2223_Sca2', 'GMSetGuw22_2223_Sca4'};
%%%%%%% END OF USER INPUT, I believe

%% Calculations start
baseFolder = pwd;
numEqs = size(eqLIST, 2);
    
%% 0. Based on building ID, read colIDLIST from MatlabInfo directory of output folder
%     clc; fprintf('Processing building- %i/%i ...\n', i, numBldgs);
%     cd H:\DamageIndex\Automated
    % cd ..\..\..\DamageIndex\Automated\
    [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgID);
    cd(analysisTypeFolder); cd MatlabInformation
    colIDLIST = load('columnNumsAtEachStoryLISTOUT.out');
    colIDLIST = colIDLIST(:, 1:end-1); % remove leaning frame columns
    colIDLIST = reshape(colIDLIST, 1, numel(colIDLIST)); % reshape the matrix to an array 
    numCols = size(colIDLIST, 2); 
    cd(baseFolder);
    
%% 1. extract ultimate rotation from model file (.xlsm)
    for colIndex = 1:numCols
        colID = colIDLIST(colIndex);
        [thetaU_p(colIndex), thetaU_n(colIndex), thetaCap_p(colIndex), thetaCap_n(colIndex)] = fun1_extractThetaU(bldgID, colID); % outputs are algebraic value
    end
    
%% 2. extract maximum rotation from output file from each scaled levels of the applied time history
for eqIndex = 1:numEqs
    %         fprintf('Processing EQ- %i/%i EQ...\n', eqIndex, numEqs);
    %         clc; fprintf('Processing building- %i/%i, EQ- %i/%i ...\n', i, numBldgs, eqIndex, numEqs);
    eqNumber = eqLIST(eqIndex);
    eqFolder = sprintf('EQ_%d', eqNumber);
    cd(analysisTypeFolder); cd(eqFolder);
    
    % this list containts 100 in saLevels for non-conv cases,
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
    xiMax = [];
    criticalColID_xi = []; % reset criticalColID for every earthquake
    
    for scalingIndex = 1:numSaLevels
        saT1Val = saT1LIST(scalingIndex);
        for colIndex = 1:numCols
            colID = colIDLIST(colIndex);
            
            cd(baseFolder);
            [thetaM_p, thetaM_n] = fun2_extractThetaMax(bldgID, eqNumber, saT1Val, colID); % outputs are algebraic value
            
            chi_p(colIndex) = thetaM_p/thetaU_p(colIndex);
            chi_n(colIndex) = thetaM_n/thetaU_n(colIndex);
            chi(colIndex) = max(chi_p(colIndex), chi_n(colIndex));
            
            xi_p(colIndex) = thetaM_p/thetaCap_p(colIndex);
            xi_n(colIndex) = thetaM_n/thetaCap_n(colIndex);
            xi(colIndex) = max(xi_p(colIndex), xi_n(colIndex));
            
            %                 thetaMToSave{eqIndex}(scalingIndex, colIndex) = max(thetaM_p, thetaM_n); % thetaM's are algebraic value
        end
        [chiMax(scalingIndex), idMax] = max(chi);
        criticalColID(scalingIndex) = colIDLIST(idMax);
        
        [xiMax(scalingIndex), idMax_xi] = max(xi);
        criticalColID_xi(scalingIndex) = colIDLIST(idMax_xi);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Also, return the critical column for each TH indicating its floor and bay numbers
        % We can subsequently have a count on story failure mechanisms.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %% save and plot EQ-specific processed results (IDA, i.e., critical column damage versus Sa(Ta)
    cd(analysisTypeFolder); cd(eqFolder);
    %     save('DATA_criticalColDamage_IDA_ForThisEQ.mat', 'chiMax', 'saT1LIST', 'criticalColID');
    %     thisEqDataFileName = sprintf('DATA_criticalColDamRat_%s_IDA_ForThisEQ.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
    thisEqDataFileName = sprintf('DATA_criticalColDamRat_IDA_ForThisEQ.mat');
    save(thisEqDataFileName, 'chiMax', 'saT1LIST', 'criticalColID', 'xiMax', 'criticalColID_xi');
    
%% 1. using theta_U as normalizing parameter
% 1.1 plot ALL component IDAs
%         figure(100 + i);
        figure(100 + figUniqueSeedForParfor);
        plot([0, chiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;

%% 2. using theta_cap as normalizing parameter    
% 2.1 plot ALL component IDAs
%         figure(300 + i);
        figure(300 + figUniqueSeedForParfor);
        plot([0, xiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
end
        
% steps 1.2 to 1.7 are now moved to fun0b_; same for 2.2 to 2.7

% 1.5a (ALL) save ALL component IDAs in analysis directory (chi, normalized by thetaU)
    cd(analysisTypeFolder)
%     figure(100 + i);
    figure(100+figUniqueSeedForParfor); 
    hx = xlabel('\chi'); hy = ylabel('Sa(Ta)');
    xlim([0 1]);
    psb_FigureFormatScript_paper; set(gca,'fontname','times');
%     exportName = sprintf('criticalColDamage_chi_%is_IDA_ALLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
    
    exportName = sprintf('criticalColDamage_chi_IDA_ALLComp');
    savefig(exportName); print('-depsc', exportName); print('-dmeta', exportName);
    
% 2.5a (ALL) save ALL component IDAs in analysis directory (xi, normalized by thetaCap)
    cd(analysisTypeFolder)
%     figure(300 + i);
    figure(300+figUniqueSeedForParfor); 
    hx = xlabel('\xi'); hy = ylabel('Sa(Ta)');
    xlim([0 1]);
    psb_FigureFormatScript_paper; set(gca,'fontname','times');
    exportName = sprintf('criticalColDamage_xi_IDA_ALLComp');
    savefig(exportName); print('-depsc', exportName); print('-dmeta', exportName);
cd(baseFolder);
% close figures to avoid plotting on the same figure in case the function is repeatedly called 

close all;

% toc