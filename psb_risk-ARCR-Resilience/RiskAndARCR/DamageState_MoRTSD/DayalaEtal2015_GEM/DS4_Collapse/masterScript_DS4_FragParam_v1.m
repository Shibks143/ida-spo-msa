clear; clc;
tic
whatToDo = '21g.extractFragility_SaTa_MultiRTSDPaper_CS'; % IM = same as 21f; with SaTa as IM
baseFolder = pwd;

switch whatToDo
    case '21g.extractFragility_SaTa_MultiRTSDPaper_CS' % IM = same as 21f; with SaTa as IM
        %%
%         bldgIdLIST = {'2211v03_sca2',	'2211v03_sca4',	'2213v04_sca2',	'2213v04_sca4',	'2215v03_sca2',	'2215v03_sca4',	...
%             '2219v03_sca2',	'2219v03_sca4',	'2221v06_sca2',	'2221v06_sca4',	'2223v03_sca2',	'2223v03_sca4'};

          bldgIdLIST = {'2433v02'};
          % {'2221v06_sca2',	'2223v03_sca2'};      

          outpFolderLIST = {
              'E:\OpenSees_PracticeExamples\ida-spo-msa\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'
%             'I:\PrakRuns_I\Output\(ID2211_R5_2Story_v.03_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2211_R5_2Story_v.03_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.04_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2213_R5_4Story_v.04_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2215_R5_7Story_v.03_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2215_R5_7Story_v.03_CS_Del22_Sca4)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2219_R5_2Story_v.03_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2219_R5_2Story_v.03_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.06_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
            % 'C:\psb\I_psb\PrakRuns_I\Output\(ID2221_R5_4Story_v.06_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2221_R5_4Story_v.06_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2223_R5_7Story_v.03_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
            % 'C:\psb\I_psb\PrakRuns_I\Output\(ID2223_R5_7Story_v.03_CS_Guw22_Sca2)_(AllVar)_(0.00)_(clough)';
%             'I:\PrakRuns_I\Output\(ID2223_R5_7Story_v.03_CS_Guw22_Sca4)_(AllVar)_(0.00)_(clough)';
            };
        
        storyDriftLIST = [0.00, 0.04, 0.02, 0.01]; %, 0.533, 0.08]; % (values in fraction). 0.00 indicates sidesway collapse (dynamic instability)
        
        % GM suite for 3040, 3042, 3044, 3045, and 3047 respectively.
        eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        
%         eqNumberLIST_forProcessing_CS22_Mum_Guw = [
% %             6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272; ...
% %             6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862; ...
% %             6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702; ...
% %             6001601	6001602	6003121	6003122	6003391	6003392	6003411	6003412	6005501	6005502	6006341	6006342	6007851	6007852	6009311	6009312	6009601	6009602	6009921	6009922	6010081	6010082	6011081	6011082	6013381	6013382	6014391	6014392	6014571	6014572	6014971	6014972	6016811	6016812	6017761	6017762	6021111	6021112	6024531	6024532	6032671	6032672	6033991	6033992; ...
% %             6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342; ...
% %             6000361	6000362	6000961	6000962	6005761	6005762	6007261	6007262	6007371	6007372	6008061	6008062	6008611	6008612	6008741	6008742	6010871	6010872	6011191	6011192	6011201	6011202	6012261	6012262	6012661	6012662	6013441	6013442	6014131	6014132	6015811	6015812	6016281	6016282	6024781	6024782	6027111	6027112	6027391	6027392	6027501	6027502	6032601	6032602; ...
% %             6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742; ...
% %             6000311	6000312	6000791	6000792	6000881	6000882	6001581	6001582	6001601	6001602	6002801	6002802	6003351	6003352	6003601	6003602	6004101	6004102	6004181	6004182	6006371	6006372	6007731	6007732	6007991	6007992	6008791	6008792	6009901	6009902	6009931	6009932	6011351	6011352	6014891	6014892	6015201	6015202	6032691	6032692	6034741	6034742	6035041	6035042; ...
%             % 6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522; ...
% %             6001641	6001642	6003601	6003602	6005811	6005812	6005871	6005872	6006451	6006452	6007441	6007442	6007541	6007542	6007651	6007652	6009521	6009522	6009701	6009702	6009891	6009892	6009901	6009902	6010041	6010042	6010391	6010392	6011071	6011072	6011541	6011542	6012471	6012472	6014711	6014712	6015131	6015132	6018351	6018352	6026551	6026552	6031051	6031052; ...
%             % 6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172; ...
% %             6000301	6000302	6000961	6000962	6001601	6001602	6003411	6003412	6003591	6003592	6005741	6005742	6005841	6005842	6007251	6007252	6007961	6007962	6008621	6008622	6009001	6009002	6009311	6009312	6010871	6010872	6011061	6011062	6012251	6012252	6013271	6013272	6014891	6014892	6015401	6015402	6016021	6016022	6026521	6026522	6033021	6033022	6034961	6034962; ...
%             ];
%         GMsuiteNameLIST = {'GMSetDel22_2211_Sca2', 'GMSetDel22_2211_Sca4', 'GMSetDel22_2213_Sca2', 'GMSetDel22_2213_Sca4', 'GMSetDel22_2215_Sca2', 'GMSetDel22_2215_Sca4', ...
%             'GMSetGuw22_2219_Sca2', 'GMSetGuw22_2219_Sca4', 'GMSetGuw22_2221_Sca2', 'GMSetGuw22_2221_Sca4', 'GMSetGuw22_2223_Sca2', 'GMSetGuw22_2223_Sca4'};
       
        GMsuiteNameLIST = {'GMSetGuw22_2221_Sca2', 'GMSetGuw22_2223_Sca2'};
        
        % eqLIST_LIST = eqNumberLIST_forProcessing_CS22_Mum_Guw;
        eqLIST_LIST = eqNumberLIST_forProcessing_SetC;

        for storyDriftIndex = 1:length(storyDriftLIST)
            currentStoryDrift = storyDriftLIST(storyDriftIndex);
            
            cd(baseFolder); % now we are in the original directory
            %% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
            for j = 1:length(outpFolderLIST)
                if length(outpFolderLIST) ~= size(bldgIdLIST, 2); error('Number of building IDs does not match the number of output folders'); end
                if mod(j-1, 5) == 0; fprintf('For (%i/%i) drift ratio value, executing (%i/%i) building...\n', storyDriftIndex, length(storyDriftLIST), j, length(outpFolderLIST)); end
                
                currBldgID = bldgIdLIST{1, j};
                
                %         eqNumberLIST = eqLIST_LIST; % eqNumberLIST = eqLIST_LIST(floor((j+1)/2), :);
                eqNumberLIST = eqLIST_LIST(j, :);
                
                %         matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_GMSetMum20_%i_SaGeoMean.mat', floor(bldgIdLIST(j)/10));
                        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', 'GMSetC');
                % matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean', GMsuiteNameLIST{1, j});
                
                [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);
                
                %% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)
                % (6-28-19, PSB) extract fragility with PGA as Intensity Measure
                for eqIndex = 1:length(eqNumberLIST)
                    eqNumber = eqNumberLIST(eqIndex);
                    T_new1 = T_old;
                    ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new1); % for PGA (modified the function for considering PGA)
                    currentRatToScale = ratioOfSaTnewToSaTold1;
                    saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
                    IM_newAllComp(eqIndex) = saT_newAllComp(eqIndex); % (6-21-19, PSB) added this to extract the fragility for PGA
                end
                indFragDataAllComp{j, storyDriftIndex} = IM_newAllComp;
                
                %% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters
                IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);
                
                for gmIndex = 1:length(eqNumberLIST)/2
                    saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
                    saT_newCompTwo = IM_newAllComp(gmIndex * 2);
                    IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
                end
                indFragDataCtrlComp{j, storyDriftIndex} = IM_newCtrlComp;
                
                % Do collapse statistics - for all components
                meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
                medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
                meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
                stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
                stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));
                minColLevelSaAll(j) = min(IM_newAllComp);
                maxColLevelSaAll(j) = max(IM_newAllComp);
                
                
                % Do collapse statistics - for controlling components
                meanCollapseSaTOneControlComp(j) = mean(IM_newCtrlComp);
                medianCollapseSaTOneControlComp(j) = (median(IM_newCtrlComp));
                meanLnCollapseSaTOneControlComp(j) = mean(log(IM_newCtrlComp));
                stDevCollapseSaTOneControlComp(j) = std(IM_newCtrlComp);
                stDevLnCollapseSaTOneControlComp(j) = std(log(IM_newCtrlComp));
                minColLevelSaCtrl(j) = min(IM_newCtrlComp);
                maxColLevelSaCtrl(j) = max(IM_newCtrlComp);
                if storyDriftIndex == 1 && j == 1 % add building ID and time P only once
                    T = table(bldgIdLIST');
                    T.Properties.VariableNames{1} = 'Bldg_ID';
                end
            end
            %               fragParamMu = exp(meanLnCollapseSaTOneControlComp)';
            %               fragParamBetaRTR = stDevLnCollapseSaTOneControlComp';
            
            fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp);
            fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp;
            T(:, 8*storyDriftIndex-6:8*storyDriftIndex-5) = table(fragParamMu_ALL', fragParamBetaRTR_ALL');
            T(:, 8*storyDriftIndex-4:8*storyDriftIndex-3) = table(minColLevelSaAll', maxColLevelSaAll');
            T.Properties.VariableNames{8*storyDriftIndex-6} = sprintf('mu_%i_ALL', round(currentStoryDrift*100));
            T.Properties.VariableNames{8*storyDriftIndex-5} = sprintf('betaRTR_%i_ALL', round(currentStoryDrift*100));
            T.Properties.VariableNames{8*storyDriftIndex-4} = sprintf('minSa_%i_ALL', round(currentStoryDrift*100));
            T.Properties.VariableNames{8*storyDriftIndex-3} = sprintf('maxSa_%i_ALL', round(currentStoryDrift*100));
            
            fragParamMu_CTRL = exp(meanLnCollapseSaTOneControlComp);
            fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneControlComp;
            T(:, 8*storyDriftIndex-2:8*storyDriftIndex-1) = table(fragParamMu_CTRL', fragParamBetaRTR_CTRL');
            T(:, 8*storyDriftIndex-0:8*storyDriftIndex+1) = table(minColLevelSaCtrl', maxColLevelSaCtrl');
            T.Properties.VariableNames{8*storyDriftIndex-2} = sprintf('mu_%i_CTRL', round(currentStoryDrift*100));
            T.Properties.VariableNames{8*storyDriftIndex-1} = sprintf('betaRTR_%i_CTRL', round(currentStoryDrift*100));
            T.Properties.VariableNames{8*storyDriftIndex-0} = sprintf('minSa_%i_CTRL', round(currentStoryDrift*100));
            T.Properties.VariableNames{8*storyDriftIndex+1} = sprintf('maxSa_%i_CTRL', round(currentStoryDrift*100));
            
            %       format long
        end
        
        disp(T);
        clearvars -except T baseFolder indFragDataAllComp indFragDataCtrlComp bldgIdLIST eqNumberLIST storyDriftLIST
        
        fileNameToSave = 'DS4_fragDataCS22_SaTa';
%         cd H:\UniformRiskMap\Results
%         cd H:\DamageState_MoRTSD\DayalaEtal2015_GEM\DS4_Collapse
        save(fileNameToSave, 'indFragDataAllComp', 'indFragDataCtrlComp', 'T', 'bldgIdLIST', 'eqNumberLIST', 'storyDriftLIST');
        fprintf('Data file saved in: %s\n', pwd);
end

cd(baseFolder);
toc

function [T_old, saT_old_AllComp] = prak_util_extractFragDataPoints_v02(analysisTypeFolder, eqNumberLIST, newStoryDrift, matFileToLoad)
baseFolder = pwd;
% % BuildingID = '2207v07';
% analysisTypeFolder = 'J:\Output\(ID2207_R5_7Story_v.07)_(AllVar)_(0.00)_(clough)';
% eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
% eqNumberLIST = eqNumberLIST_forProcessing_SetC;
% % eqListForCollapseIDAs_Name = 'GMSetC'; 
% newStoryDrift = 0.04;

cd(analysisTypeFolder)
saT_old_AllComp = zeros(1, length(eqNumberLIST));

if abs(newStoryDrift - 0.00)<1e-5 % sidesway collapse
%     load DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean collapseLevelForAllComp periodUsedForScalingGroundMotions
    load(matFileToLoad, 'collapseLevelForAllComp', 'periodUsedForScalingGroundMotions');
    saT_old_AllComp = collapseLevelForAllComp ;
    T_old = periodUsedForScalingGroundMotions;
else
    for eqIndex = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqIndex);
        eqFolder = sprintf('EQ_%d',eqNumber);
        cd(eqFolder)

        load DATA_collapse_ProcessedIDADataForThisEQ ;
        saLevels = saLevelsForIDAPlotPROCLIST;
        maxDriftRatio = maxDriftRatioForPlotPROCLIST;

        % simple interpolation may not work, since IDAs are non monotonous at times
    %     saCol_BasedOnDriftAllComp(eqIndex) = interp1(maxDriftRatio, saLevels, collapseDrift, 'pchip');
        ix = find(maxDriftRatio  > newStoryDrift, 1);
        if isempty(ix)
            saT_old_AllComp(eqIndex) = saLevels(end);
        else
            saT_old_AllComp(eqIndex) = interp1([maxDriftRatio(ix-1), maxDriftRatio(ix)], ...
                                                     [saLevels(ix-1), saLevels(ix)], newStoryDrift, 'pchip');
        end

        if eqIndex == 1 % loading only once
            load DATA_CollapseResultsForThisSingleEQ periodUsedForScalingGroundMotions % it is same for all the GMs. Can load only once for efficiency.
            T_old = periodUsedForScalingGroundMotions;
        end
        cd ..
    end
end       
    cd(baseFolder)
end

function saRatNewToOld = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new, dampRat)
%% (6-28-19, PSB) T_new = 0.00 will throw the ratio for PGA. Added this piece below on 6-28-19

baseFolder = pwd;
switch nargin 
    case 3
        dampRat = 0.05;
end

% We expect, T_old and T_new to be rounded to two decimal places, if not then let's do it now.

T_old = round(T_old *100)/100;
T_new = round(T_new *100)/100;


%% (6-28-19, PSB) Modifying to include ratio to PGA when T_new is entered as 0.00
if abs(T_new) < 0.001 % essentially, zero
    cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
% find the old SaValue
    dampRatIndex = find(abs(dampRatioLIST - dampRat) < 1e-5);
    timePIndexOld = find(abs(periodVector - T_old) < 1e-4);
    SaT_old = SaAbs(timePIndexOld, dampRatIndex);    
    
% % find the PGA value (essentially, SaT_new)
    cd C:\OpenSeesProcessingFiles\EQs
    timeHistoryFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    accnArray = load(timeHistoryFile);
    SaT_new = max(abs(min(accnArray)), abs(max(accnArray)));
    saRatNewToOld = SaT_new/SaT_old;

else
    cd C:\Users\sks\OpenSeesProcessingFiles\EQ_Spectra_Saved
    % cd C:\OpenSeesProcessingFiles\EQ_Spectra_Saved
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
% find the old SaValue
    dampRatIndex = find(abs(dampRatioLIST - dampRat) < 1e-5);
    timePIndexOld = find(abs(periodVector - T_old) < 1e-4);
    SaT_old = SaAbs(timePIndexOld, dampRatIndex);
    
% find the new SaValue
    timePIndexNew = find(abs(periodVector - T_new) < 1e-4);
    SaT_new = SaAbs(timePIndexNew, dampRatIndex);
   
    saRatNewToOld = SaT_new/SaT_old;
end

cd(baseFolder)
end

