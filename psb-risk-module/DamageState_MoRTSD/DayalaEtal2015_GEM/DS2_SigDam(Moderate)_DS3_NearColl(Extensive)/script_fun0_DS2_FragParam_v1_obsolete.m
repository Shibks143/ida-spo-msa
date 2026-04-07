clear; tic
%% DS2 Significant Damage (Moderate Damage) % page 35 of D'ayala et al (2015)
    % the most critical column cntrols the state of the structure: the
    % limit state is attained when the rotation at one hinge of any column
    % exceeds 75% of the ultimate rotation.
       
bldgIDLIST = {'2211v03_sca2',	'2211v03_sca4',	'2213v04_sca2',	'2213v04_sca4',	'2215v03_sca2',	'2215v03_sca4',	...
              '2219v03_sca2',	'2219v03_sca4',	'2221v06_sca2',	'2221v06_sca4',	'2223v03_sca2',	'2223v03_sca4'};
% opensees model file and output directory are obtained using H:\DamageIndex\Automated\returnModelFolderInfo as a function of bldgID

%% Start of user input 
eqNumberLIST = [
        6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272; ...
        6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862; ...
        6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702; ...
        6001601	6001602	6003121	6003122	6003391	6003392	6003411	6003412	6005501	6005502	6006341	6006342	6007851	6007852	6009311	6009312	6009601	6009602	6009921	6009922	6010081	6010082	6011081	6011082	6013381	6013382	6014391	6014392	6014571	6014572	6014971	6014972	6016811	6016812	6017761	6017762	6021111	6021112	6024531	6024532	6032671	6032672	6033991	6033992; ...
        6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342; ...
        6000361	6000362	6000961	6000962	6005761	6005762	6007261	6007262	6007371	6007372	6008061	6008062	6008611	6008612	6008741	6008742	6010871	6010872	6011191	6011192	6011201	6011202	6012261	6012262	6012661	6012662	6013441	6013442	6014131	6014132	6015811	6015812	6016281	6016282	6024781	6024782	6027111	6027112	6027391	6027392	6027501	6027502	6032601	6032602; ...
        6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742; ...
        6000311	6000312	6000791	6000792	6000881	6000882	6001581	6001582	6001601	6001602	6002801	6002802	6003351	6003352	6003601	6003602	6004101	6004102	6004181	6004182	6006371	6006372	6007731	6007732	6007991	6007992	6008791	6008792	6009901	6009902	6009931	6009932	6011351	6011352	6014891	6014892	6015201	6015202	6032691	6032692	6034741	6034742	6035041	6035042; ...
        6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522; ...
        6001641	6001642	6003601	6003602	6005811	6005812	6005871	6005872	6006451	6006452	6007441	6007442	6007541	6007542	6007651	6007652	6009521	6009522	6009701	6009702	6009891	6009892	6009901	6009902	6010041	6010042	6010391	6010392	6011071	6011072	6011541	6011542	6012471	6012472	6014711	6014712	6015131	6015132	6018351	6018352	6026551	6026552	6031051	6031052; ...
        6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172; ...
        6000301	6000302	6000961	6000962	6001601	6001602	6003411	6003412	6003591	6003592	6005741	6005742	6005841	6005842	6007251	6007252	6007961	6007962	6008621	6008622	6009001	6009002	6009311	6009312	6010871	6010872	6011061	6011062	6012251	6012252	6013271	6013272	6014891	6014892	6015401	6015402	6016021	6016022	6026521	6026522	6033021	6033022	6034961	6034962; ...
        ];
    
% Do we need GMsuiteNameLIST?
% GMsuiteNameLIST = {'GMSetDel22_2211_Sca2', 'GMSetDel22_2211_Sca4', 'GMSetDel22_2213_Sca2', 'GMSetDel22_2213_Sca4', 'GMSetDel22_2215_Sca2', 'GMSetDel22_2215_Sca4', ...
%                    'GMSetGuw22_2219_Sca2', 'GMSetGuw22_2219_Sca4', 'GMSetGuw22_2221_Sca2', 'GMSetGuw22_2221_Sca4', 'GMSetGuw22_2223_Sca2', 'GMSetGuw22_2223_Sca4'};

chi_LimitStateDS2 = 0.75; % for DS2, limit over chi, the ratio of max rotation to ultimate rotation capacity
% chi = rotation Ratio = thetaM/thetaU

%%%%%%% END OF USER INPUT, I believe

%% Calculations start
baseFolder = pwd;

numBldgs = size(bldgIDLIST, 2);
numEqs = size(eqNumberLIST, 2);


    inputDetailsToSave.bldgIDLIST = bldgIDLIST;   inputDetailsToSave.eqLIST = eqNumberLIST;
%     inputDetailsToSave.saT1LIST = saT1LIST;           inputDetailsToSave.colIDLIST = colIDLIST;
    
%% 0. Execute the program for required building IDs
for i = 1%:2:numBldgs
%     clc; fprintf('Processing building- %i/%i ...\n', i, numBldgs);
    bldgID = bldgIDLIST{i};
        % read colIDLIST from MatlabInfo directory of output folder

% 		cd H:\DamageIndex\Automated
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
        [thetaU_p(i, colIndex), thetaU_n(i, colIndex)] = fun1_extractThetaU(bldgID, colID); % outputs are algebraic value
    end
    
%% 2. extract maximum rotation from output file from each scaled levels of the applied time history
    for eqIndex = 1:numEqs
%         fprintf('Processing EQ- %i/%i EQ...\n', eqIndex, numEqs);
        clc; fprintf('Processing building- %i/%i, EQ- %i/%i ...\n', i, numBldgs, eqIndex, numEqs);
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
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Also, return the critical column for each TH indicating its floor and bay numbers 
    % We can subsequently have a count on story failure mechanisms.
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
            saT1_ds2_ALL(eqIndex) = interp1([chiMax(ix-1), chiMax(ix)], ...
                                                     [saT1LIST(ix-1), saT1LIST(ix)], chi_LimitStateDS2, 'pchip');
        end
        
% plot ALL component IDAs
        figure(100 + i);
        plot([0, chiMax], [0, saT1LIST], 'b-o', 'LineWidth', 1); hold on; grid on;
        
        
% for odd time history TH, store chiMax and saT1LIST, in case it is controlling
        if mod(eqIndex, 2) == 1 
            chiMax_CompOne = chiMax;
            sasaT1LIST_CompOne = saT1LIST;
            % chiMax_CompTwo and sasaT1LIST_CompTwo need not be assigned since 
            % chiMax and saT1LIST from current eqIndex are available in next conditional statement
        end
        
% determine the controling component and plot it
        if mod(eqIndex, 2) == 0 % for every second TH, find controling component
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
    cd(analysisTypeFolder)
    figure(100+i); 
    hx = xlabel('\chi'); hy = ylabel('Sa(Ta)');
    psb_FigureFormatScript_paper; set(gca,'fontname','times');
    exportName = 'criticalColDamage_IDA_ALLComp';
    hgsave(exportName); print('-depsc', exportName); print('-dmeta', exportName);
    
    figure(200+i); 
    hx = xlabel('\chi'); hy = ylabel('Sa(Ta)');
    psb_FigureFormatScript_paper; set(gca,'fontname','times');
    exportName = 'criticalColDamage_IDA_CTRLComp';
    hgsave(exportName); print('-depsc', exportName); print('-dmeta', exportName);
    
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