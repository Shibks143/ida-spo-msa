function fragilityInfo = fun0_fragParam_DS2_v1(bldgIDLIST, eqNumberLIST, LimitStateVal, figUniqueSeedForParfor)

%% For faster processing, I have now replaced fun0 by splitting it into fun0a and fun0b
% fun0a processes and saves IDA for ALL component
% fun0b extracts fragility for different threshold values and saves IDA for CTRL components
% fun0 used to process IDA for each value of the threshold and thereby repeating tons of calculations 

% figUniqueSeedForParfor is used for plotting IDAs in different figure windows
% If executed in sequence, this problem never really arises, so a default value would suffice. 
if ~exist('figUniqueSeedForParfor', 'var')
    figUniqueSeedForParfor = 1;
end

% clear; tic
%% DS2 Significant Damage (Moderate Damage) % page 35 of D'ayala et al (2015)
    % the most critical column cntrols the state of the structure: the
    % limit state is attained when the rotation at one hinge of any column
    % exceeds 75% of the ultimate rotation.
       
%% Start of user input 
% bldgIDLIST = {'2211v03_sca2',	'2211v03_sca4',	'2213v04_sca2',	'2213v04_sca4',	'2215v03_sca2',	'2215v03_sca4',	...
%               '2219v03_sca2',	'2219v03_sca4',	'2221v06_sca2',	'2221v06_sca4',	'2223v03_sca2',	'2223v03_sca4'};
% % opensees model file and output directory are obtained using H:\DamageIndex\Automated\returnModelFolderInfo as a function of bldgID
% 
% eqNumberLIST = [
%         6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272; ...
%         6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862; ...
%         6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702; ...
%         6001601	6001602	6003121	6003122	6003391	6003392	6003411	6003412	6005501	6005502	6006341	6006342	6007851	6007852	6009311	6009312	6009601	6009602	6009921	6009922	6010081	6010082	6011081	6011082	6013381	6013382	6014391	6014392	6014571	6014572	6014971	6014972	6016811	6016812	6017761	6017762	6021111	6021112	6024531	6024532	6032671	6032672	6033991	6033992; ...
%         6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342; ...
%         6000361	6000362	6000961	6000962	6005761	6005762	6007261	6007262	6007371	6007372	6008061	6008062	6008611	6008612	6008741	6008742	6010871	6010872	6011191	6011192	6011201	6011202	6012261	6012262	6012661	6012662	6013441	6013442	6014131	6014132	6015811	6015812	6016281	6016282	6024781	6024782	6027111	6027112	6027391	6027392	6027501	6027502	6032601	6032602; ...
%         6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742; ...
%         6000311	6000312	6000791	6000792	6000881	6000882	6001581	6001582	6001601	6001602	6002801	6002802	6003351	6003352	6003601	6003602	6004101	6004102	6004181	6004182	6006371	6006372	6007731	6007732	6007991	6007992	6008791	6008792	6009901	6009902	6009931	6009932	6011351	6011352	6014891	6014892	6015201	6015202	6032691	6032692	6034741	6034742	6035041	6035042; ...
%         6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522; ...
%         6001641	6001642	6003601	6003602	6005811	6005812	6005871	6005872	6006451	6006452	6007441	6007442	6007541	6007542	6007651	6007652	6009521	6009522	6009701	6009702	6009891	6009892	6009901	6009902	6010041	6010042	6010391	6010392	6011071	6011072	6011541	6011542	6012471	6012472	6014711	6014712	6015131	6015132	6018351	6018352	6026551	6026552	6031051	6031052; ...
%         6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172; ...
%         6000301	6000302	6000961	6000962	6001601	6001602	6003411	6003412	6003591	6003592	6005741	6005742	6005841	6005842	6007251	6007252	6007961	6007962	6008621	6008622	6009001	6009002	6009311	6009312	6010871	6010872	6011061	6011062	6012251	6012252	6013271	6013272	6014891	6014892	6015401	6015402	6016021	6016022	6026521	6026522	6033021	6033022	6034961	6034962; ...
%         ];
%     
% LimitStateVal = 0.75; % for DS2, limit over chi, the ratio of max rotation to ultimate rotation capacity
% chi = rotation Ratio = thetaM/thetaU

% Do we need GMsuiteNameLIST?
% GMsuiteNameLIST = {'GMSetDel22_2211_Sca2', 'GMSetDel22_2211_Sca4', 'GMSetDel22_2213_Sca2', 'GMSetDel22_2213_Sca4', 'GMSetDel22_2215_Sca2', 'GMSetDel22_2215_Sca4', ...
%                    'GMSetGuw22_2219_Sca2', 'GMSetGuw22_2219_Sca4', 'GMSetGuw22_2221_Sca2', 'GMSetGuw22_2221_Sca4', 'GMSetGuw22_2223_Sca2', 'GMSetGuw22_2223_Sca4'};
%%%%%%% END OF USER INPUT, I believe

%% Calculations start
baseFolder = pwd;

numBldgs = size(bldgIDLIST, 2);
numEqs = size(eqNumberLIST, 2);


%     inputDetailsToSave.bldgIDLIST = bldgIDLIST;   inputDetailsToSave.eqLIST = eqNumberLIST;
%     inputDetailsToSave.saT1LIST = saT1LIST;           inputDetailsToSave.colIDLIST = colIDLIST;
    
%% 0. Execute the program for required building IDs
for i = 1:numBldgs
%     clc; fprintf('Processing building- %i/%i ...\n', i, numBldgs);
    bldgID = bldgIDLIST{i};
        % read colIDLIST from MatlabInfo directory of output folder

%    cd H:\DamageIndex\Automated
	cd ..\..\..\DamageIndex\Automated
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
        [thetaU_p(i, colIndex), thetaU_n(i, colIndex), thetaCap_p(i, colIndex), thetaCap_n(i, colIndex)] = fun1_extractThetaU(bldgID, colID); % outputs are algebraic value
    end
    
%% 2. extract maximum rotation from output file from each scaled levels of the applied time history
    for eqIndex = 1:numEqs
%         fprintf('Processing EQ- %i/%i EQ...\n', eqIndex, numEqs);
%         clc; fprintf('Processing building- %i/%i, EQ- %i/%i ...\n', i, numBldgs, eqIndex, numEqs);
        eqNumber = eqNumberLIST(i, eqIndex);
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
                
                chi_p(colIndex) = thetaM_p/thetaU_p(i, colIndex);
                chi_n(colIndex) = thetaM_n/thetaU_n(i, colIndex);
                chi(colIndex) = max(chi_p(colIndex), chi_n(colIndex)); 

                xi_p(colIndex) = thetaM_p/thetaCap_p(i, colIndex);
                xi_n(colIndex) = thetaM_n/thetaCap_n(i, colIndex);
                xi(colIndex) = max(xi_p(colIndex), xi_n(colIndex)); 
                
%                 thetaMToSave{i, eqIndex}(scalingIndex, colIndex) = max(thetaM_p, thetaM_n); % thetaM's are algebraic value
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
%     thisEqDataFileName = sprintf('DATA_criticalColDamRat_%ip%i_IDA_ForThisEQ.mat', floor(LimitStateVal), int8(LimitStateVal*100));
    thisEqDataFileName = sprintf('DATA_criticalColDamRat_%s_IDA_ForThisEQ.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
    save(thisEqDataFileName, 'chiMax', 'saT1LIST', 'criticalColID', 'xiMax', 'criticalColID_xi');
    
    
%% 1. using theta_U as normalizing parameter    
% 1.1 calculate ALL components
    % interpolate the obtained IDA for this TH, i.e., chiMax vs. saT1LIST at chi_DS2 = 0.75
    % A simple interpolation may not work, since IDAs are non-monotonous at times
        ix = find(chiMax  > LimitStateVal, 1);
        if isempty(ix)
            saT1_ds2_ALL(eqIndex) = saT1LIST(end);
        else
            saT1_ds2_ALL(eqIndex) = interp1([chiMax(ix-1), chiMax(ix)], ...
                                                     [saT1LIST(ix-1), saT1LIST(ix)], LimitStateVal, 'pchip');
        end
        
% 1.2 plot ALL component IDAs
%         figure(100 + i);
        figure(100 + figUniqueSeedForParfor);
        plot([0, chiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
        
        
% 1.3 for odd time history TH, store chiMax and saT1LIST, in case it is controlling
        if mod(eqIndex, 2) == 1 
            chiMax_CompOne = chiMax;
            saT1LIST_CompOne = saT1LIST;
            % chiMax_CompTwo and sasaT1LIST_CompTwo need not be assigned since 
            % chiMax and saT1LIST from current eqIndex are available in next conditional statement
        end
        
% 1.4 determine the controling component and plot it
        if mod(eqIndex, 2) == 0 % for every second TH, find controling component
            gmIndex = eqIndex/2;
            saT1_ds2_CompOne = saT1_ds2_ALL(eqIndex - 1);
            saT1_ds2_CompTwo = saT1_ds2_ALL(eqIndex);
            saT1_ds2_CTRL(gmIndex) = min(saT1_ds2_CompOne, saT1_ds2_CompTwo);
            
            % plot CTRL component IDA
%             figure(200 + i);
            figure(200 + figUniqueSeedForParfor);
            if saT1_ds2_CompOne < saT1_ds2_CompTwo
                plot([0, chiMax_CompOne], [0, saT1LIST_CompOne], 'b-o', 'LineWidth', 1); hold on; grid on;
            else
                plot([0, chiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
            end
        end

%% 2. using theta_cap as normalizing parameter    
% 2.1 calculate ALL components
    % interpolate the obtained IDA for this TH, i.e., xiMax vs. saT1LIST at xi_DS2 = 0.75
    % A simple interpolation may not work, since IDAs are non-monotonous at times
        ix_xi = find(xiMax  > LimitStateVal, 1);
        if isempty(ix_xi)
            saT1_ds2_ALL_xi(eqIndex) = saT1LIST(end);
        else
            saT1_ds2_ALL_xi(eqIndex) = interp1([xiMax(ix_xi-1), xiMax(ix)], ...
                                                     [saT1LIST(ix_xi-1), saT1LIST(ix_xi)], LimitStateVal, 'pchip');
        end
    
% 2.2 plot ALL component IDAs
%         figure(300 + i);
        figure(300 + figUniqueSeedForParfor);
        plot([0, xiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
        
% 2.3 for odd time history TH, store chiMax and saT1LIST, in case it is controlling
        if mod(eqIndex, 2) == 1 
            xiMax_CompOne = xiMax;
            saT1LIST_CompOne_xi = saT1LIST;
            % chiMax_CompTwo and sasaT1LIST_CompTwo need not be assigned since 
            % chiMax and saT1LIST from current eqIndex are available in next conditional statement
        end
        
% 2.4 determine the controling component and plot it
        if mod(eqIndex, 2) == 0 % for every second TH, find controling component
            gmIndex = eqIndex/2;
            saT1_ds2_CompOne_xi = saT1_ds2_ALL_xi(eqIndex - 1);
            saT1_ds2_CompTwo_xi = saT1_ds2_ALL_xi(eqIndex);
            saT1_ds2_CTRL_xi(gmIndex) = min(saT1_ds2_CompOne_xi, saT1_ds2_CompTwo_xi);
            
            % plot CTRL component IDA
%             figure(400 + i);
            figure(400 + figUniqueSeedForParfor);
            if saT1_ds2_CompOne_xi < saT1_ds2_CompTwo_xi
                plot([0, xiMax_CompOne], [0, saT1LIST_CompOne_xi], 'b-o', 'LineWidth', 1); hold on; grid on;
            else
                plot([0, xiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
            end
        end
        
        
    end
        
% 1.5 save ALL and CTRL component IDAs in analysis directory (chi, normalized by thetaU)
    cd(analysisTypeFolder)
%     figure(100 + i);
    figure(100+figUniqueSeedForParfor); 
    hx = xlabel('\chi'); hy = ylabel('Sa(Ta)');
    psb_FigureFormatScript_paper; set(gca,'fontname','times');
%     exportName = sprintf('criticalColDamage_chi_%ip%i_IDA_ALLComp', floor(LimitStateVal), int8(LimitStateVal*100));
    exportName = sprintf('criticalColDamage_chi_%s_IDA_ALLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
    hgsave(exportName); print('-depsc', exportName); print('-dmeta', exportName);
    
%     figure(200 + i);
    figure(200+figUniqueSeedForParfor); 
    hx = xlabel('\chi'); hy = ylabel('Sa(Ta)');
    psb_FigureFormatScript_paper; set(gca,'fontname','times');
%     exportName = sprintf('criticalColDamage_chi_%ip%i_IDA_CTRLComp', floor(LimitStateVal), int8(LimitStateVal*100));
    exportName = sprintf('criticalColDamage_chi_%s_IDA_CTRLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
    hgsave(exportName); print('-depsc', exportName); print('-dmeta', exportName);
    
% 2.5 save ALL and CTRL component IDAs in analysis directory (chi, normalized by thetaCap)
    cd(analysisTypeFolder)
%     figure(300 + i);
    figure(300+figUniqueSeedForParfor); 
    hx = xlabel('\xi'); hy = ylabel('Sa(Ta)');
    psb_FigureFormatScript_paper; set(gca,'fontname','times');
%     exportName = sprintf('criticalColDamage_xi_%ip%i_IDA_ALLComp', floor(LimitStateVal), int8(LimitStateVal*100));
    exportName = sprintf('criticalColDamage_xi_%s_IDA_ALLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
    
    hgsave(exportName); print('-depsc', exportName); print('-dmeta', exportName);
    
%     figure(400 + i);
    figure(400+figUniqueSeedForParfor); 
    hx = xlabel('\xi'); hy = ylabel('Sa(Ta)');
    psb_FigureFormatScript_paper; set(gca,'fontname','times');
%     exportName = sprintf('criticalColDamage_xi_%ip%i_IDA_CTRLComp', floor(LimitStateVal), int8(LimitStateVal*100));
    exportName = sprintf('criticalColDamage_xi_%s_IDA_CTRLComp', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));
    
    hgsave(exportName); print('-depsc', exportName); print('-dmeta', exportName);
    
%% 1.6 Calculate statistics for ds2 for both ALL and CTRL components    
    meanLnDS2SaAllComp = exp(mean(log(saT1_ds2_ALL)));
    stDevLnDS2SaAllComp = std(log(saT1_ds2_ALL));
    minDS2LevelSaAll = min(saT1_ds2_ALL);
    maxDS2LevelSaAll = max(saT1_ds2_ALL);
    
    meanLnDS2SaCtrlComp = exp(mean(log(saT1_ds2_CTRL)));
    stDevLnDS2SaCtrlComp = std(log(saT1_ds2_CTRL));
    minDS2LevelSaCtrl = min(saT1_ds2_CTRL);
    maxDS2LevelSaCtrl = max(saT1_ds2_CTRL);
    
%% 2.6 Calculate statistics for ds2 for both ALL and CTRL components    
    meanLnDS2SaAllComp_xi = exp(mean(log(saT1_ds2_ALL_xi)));
    stDevLnDS2SaAllComp_xi = std(log(saT1_ds2_ALL_xi));
    minDS2LevelSaAll_xi = min(saT1_ds2_ALL_xi);
    maxDS2LevelSaAll_xi = max(saT1_ds2_ALL_xi);
    
    meanLnDS2SaCtrlComp_xi = exp(mean(log(saT1_ds2_CTRL_xi)));
    stDevLnDS2SaCtrlComp_xi = std(log(saT1_ds2_CTRL_xi));
    minDS2LevelSaCtrl_xi = min(saT1_ds2_CTRL_xi);
    maxDS2LevelSaCtrl_xi = max(saT1_ds2_CTRL_xi);
    
%% 1.7 Save processed results 
    eqLIST = eqNumberLIST(i, :);
%     fileName = sprintf('DATA_criticalCol_chi_%3.2f_SaAndStats.mat', chi_LimitState);
%     fileName = sprintf('DATA_criticalCol_chi_%ip%i_SaAndStats.mat', floor(LimitStateVal), int8(LimitStateVal*100));
    fileName = sprintf('DATA_criticalCol_chi_%s_SaAndStats.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));

    save(fileName, 'saT1_ds2_ALL', 'saT1_ds2_CTRL', 'LimitStateVal', 'eqLIST', ...
        'meanLnDS2SaAllComp', 'stDevLnDS2SaAllComp', 'minDS2LevelSaAll', 'maxDS2LevelSaAll',...
        'meanLnDS2SaCtrlComp', 'stDevLnDS2SaCtrlComp', 'minDS2LevelSaCtrl', 'maxDS2LevelSaCtrl');
    fprintf('Data file saved as %s.\n', fullfile(pwd, fileName));
     
%% 2.7 Save processed results 
%     fileName_xi = sprintf('DATA_criticalCol_xi_%ip%i_SaAndStats.mat', floor(LimitStateVal), int8(LimitStateVal*100));
    fileName_xi = sprintf('DATA_criticalCol_xi_%s_SaAndStats.mat', strrep(num2str(round(LimitStateVal, 2), '%.2f'), '.', 'p'));

    save(fileName_xi, 'saT1_ds2_ALL_xi', 'saT1_ds2_CTRL_xi', 'LimitStateVal', 'eqLIST', ...
        'meanLnDS2SaAllComp_xi', 'stDevLnDS2SaAllComp_xi', 'minDS2LevelSaAll_xi', 'maxDS2LevelSaAll_xi',...
        'meanLnDS2SaCtrlComp_xi', 'stDevLnDS2SaCtrlComp_xi', 'minDS2LevelSaCtrl_xi', 'maxDS2LevelSaCtrl_xi');
    fprintf('Data file saved as %s.\n', fullfile(pwd, fileName_xi));
    
% assign output for the function (repeated data in the .mat file as well)
    fragilityInfo(i).saT1_ds2_ALL = saT1_ds2_ALL;
    fragilityInfo(i).saT1_ds2_CTRL = saT1_ds2_CTRL;
    fragilityInfo(i).chi_LimitStateDS2 = LimitStateVal;
    fragilityInfo(i).eqLIST = eqLIST;
    
    fragilityInfo(i).meanLnDS2SaAllComp = meanLnDS2SaAllComp;
    fragilityInfo(i).stDevLnDS2SaAllComp = stDevLnDS2SaAllComp;
    fragilityInfo(i).minDS2LevelSaAll = minDS2LevelSaAll;
    fragilityInfo(i).maxDS2LevelSaAll = maxDS2LevelSaAll;
        
    fragilityInfo(i).meanLnDS2SaCtrlComp = meanLnDS2SaCtrlComp;
    fragilityInfo(i).stDevLnDS2SaCtrlComp = stDevLnDS2SaCtrlComp;
    fragilityInfo(i).minDS2LevelSaCtrl = minDS2LevelSaCtrl;
    fragilityInfo(i).maxDS2LevelSaCtrl = maxDS2LevelSaCtrl;

% xi values
    fragilityInfo(i).saT1_ds2_ALL_xi = saT1_ds2_ALL_xi;
    fragilityInfo(i).saT1_ds2_CTRL_xi = saT1_ds2_CTRL_xi;
    fragilityInfo(i).chi_LimitStateDS2_xi = LimitStateVal;
%     fragilityInfo(i).eqLIST = eqLIST;
    
    fragilityInfo(i).meanLnDS2SaAllComp_xi = meanLnDS2SaAllComp_xi;
    fragilityInfo(i).stDevLnDS2SaAllComp_xi = stDevLnDS2SaAllComp_xi;
    fragilityInfo(i).minDS2LevelSaAll_xi = minDS2LevelSaAll_xi;
    fragilityInfo(i).maxDS2LevelSaAll_xi = maxDS2LevelSaAll_xi;
        
    fragilityInfo(i).meanLnDS2SaCtrlComp_xi = meanLnDS2SaCtrlComp_xi;
    fragilityInfo(i).stDevLnDS2SaCtrlComp_xi = stDevLnDS2SaCtrlComp_xi;
    fragilityInfo(i).minDS2LevelSaCtrl_xi = minDS2LevelSaCtrl_xi;
    fragilityInfo(i).maxDS2LevelSaCtrl_xi = maxDS2LevelSaCtrl_xi;
    
    cd(baseFolder);
end

% close figures to avoid plotting on the same figure in case the function is repeatedly called 

close all;

% toc