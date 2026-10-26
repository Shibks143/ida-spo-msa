function sks_DS4_FragParam(PHRInputs)

tic

eqLIST_LIST =    PHRInputs.eqNumberLIST;
GMsuiteName =    PHRInputs.GMsuiteName;
analysisType =   PHRInputs.analysisType;
bldgIdLIST =     PHRInputs.BldgIdLIST;
storyDriftLIST = PHRInputs.storyDriftLIST;

whatToDo = '21g.extractFragility_SaTa_MultiRTSDPaper_CS'; % IM = same as 21f; with SaTa as IM
baseFolder = pwd;
switch whatToDo
    case '21g.extractFragility_SaTa_MultiRTSDPaper_CS' % IM = same as 21f; with SaTa as IM

        outpFolderLIST = {fullfile(baseFolder, 'Output', analysisType) };
        % GMsuiteNameLIST = {'GMSetGuw22_2221_Sca2', 'GMSetGuw22_2223_Sca2'};
  
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
                matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', GMsuiteName);
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

        cd psb-risk-module
        cd('Output_Risk')
        fileNameToSave = 'DS4_fragDataCS22_SaTa';
        save(fileNameToSave, 'indFragDataAllComp', 'indFragDataCtrlComp', 'T', 'bldgIdLIST', 'eqNumberLIST', 'storyDriftLIST');
        fprintf('Data file saved in: %s\n', pwd);
end

cd(baseFolder);
toc

    function [T_old, saT_old_AllComp] = prak_util_extractFragDataPoints_v02(analysisTypeFolder, eqNumberLIST, newStoryDrift, matFileToLoad)
        baseFolder = pwd;
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

                data = load('DATA_collapse_ProcessedIDADataForThisEQ.mat', 'saLevelsForIDAPlotPROCLIST', 'maxDriftRatioForPlotPROCLIST');
                saLevels = data.saLevelsForIDAPlotPROCLIST;
                maxDriftRatio = data.maxDriftRatioForPlotPROCLIST;

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
end

