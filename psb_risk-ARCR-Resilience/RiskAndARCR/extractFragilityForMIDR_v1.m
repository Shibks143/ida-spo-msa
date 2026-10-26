function [fragParamMuALL_mat, fragParamBetaALL_mat, fragParamImMinALL_mat, fragParamMuCtrl_mat, fragParamBetaCtrl_mat, fragParamImMinCtrl_mat] = ...
          extractFragilityForMIDR_v1(bldgIdLIST, outpFolderLIST, storyDriftLIST, eqLIST, eqLISTName, T1LIST, fileNameToSaveFragData)

%% Calculations start
baseFolder = pwd;
for storyDriftIndex = 1:length(storyDriftLIST)
    currentStoryDrift = storyDriftLIST(storyDriftIndex);

    cd(baseFolder); % now we are in the original directory
%% 2a. extract the old period and values of spectral acceleration corr. to story drift ratio as chosen above
    for j = 1:length(outpFolderLIST)
        if length(outpFolderLIST) ~= length(bldgIdLIST); error('Number of building IDs does not match the number of output folders'); end
        if mod(j-1, 5) == 0; fprintf('For (%i/%i) drift ratio value, executing (%i/%i) building...\n', storyDriftIndex, length(storyDriftLIST), j, length(outpFolderLIST)); end
        
        currBldgID = bldgIdLIST(1, j);
        eqNumberLIST = eqLIST; 
        matFileToLoad = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', eqLISTName);

        [T_old, saT_oldAllComp] = prak_util_extractFragDataPoints_v02(outpFolderLIST{j}, eqNumberLIST, currentStoryDrift, matFileToLoad);

%% 2b. depending on the intensity measure type, find ratio of scaling from old IM value to new value for each earthquake (NOT NEEDED in case of PGA)
% (6-28-19, PSB) extract fragility with PGA as Intensity Measure
        saT_newAllComp = zeros(1, length(eqNumberLIST));   % preallocate (one value per GM component)
        IM_newAllComp  = zeros(1, length(eqNumberLIST));

        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex);
            T_new = T1LIST(j);
            ratioOfSaTnewToSaTold1 = prak_util_ratioOfSaTnewToSaTold(eqNumber, T_old, T_new); % for PGA (modified the function for considering PGA)
            currentRatToScale = ratioOfSaTnewToSaTold1;
            saT_newAllComp(eqIndex) = currentRatToScale * saT_oldAllComp(eqIndex);
            IM_newAllComp(eqIndex) = saT_newAllComp(eqIndex); % (6-21-19, PSB) added this to extract the fragility for PGA
        end
        indFragDataAllComp{currBldgID, storyDriftIndex} = IM_newAllComp;
            
%% 2c. combine the new intensity measure values for different ground motions to find the fragility function parameters
    IM_newCtrlComp = zeros(1, length(eqNumberLIST)/2);

        for gmIndex = 1:length(eqNumberLIST)/2
            saT_newCompOne = IM_newAllComp(gmIndex * 2 - 1);
            saT_newCompTwo = IM_newAllComp(gmIndex * 2);
            IM_newCtrlComp(gmIndex) = min(saT_newCompOne, saT_newCompTwo);
        end
        indFragDataCtrlComp{currBldgID, storyDriftIndex} = IM_newCtrlComp;

        % Do collapse statistics - for all components
        meanCollapseSaTOneAllComp(j) = mean(IM_newAllComp);
        medianCollapseSaTOneAllComp(j) = (median(IM_newAllComp));
        meanLnCollapseSaTOneAllComp(j) = mean(log(IM_newAllComp));
        stDevCollapseSaTOneAllComp(j) = std(IM_newAllComp);
        stDevLnCollapseSaTOneAllComp(j) = std(log(IM_newAllComp));
        minColLevelSaAll(j) = min(IM_newAllComp);
        maxColLevelSaAll(j) = max(IM_newAllComp);

        % Do collapse statistics - for Ctrlling components
        meanCollapseSaTOneCtrlComp(j) = mean(IM_newCtrlComp);
        medianCollapseSaTOneCtrlComp(j) = (median(IM_newCtrlComp));
        meanLnCollapseSaTOneCtrlComp(j) = mean(log(IM_newCtrlComp));
        stDevCollapseSaTOneCtrlComp(j) = std(IM_newCtrlComp);
        stDevLnCollapseSaTOneCtrlComp(j) = std(log(IM_newCtrlComp));
        minColLevelSaCtrl(j) = min(IM_newCtrlComp);
        maxColLevelSaCtrl(j) = max(IM_newCtrlComp);

    % variables to store as a matrix in the .mat file
        fragParamMuALL_mat(j, storyDriftIndex) = exp(meanLnCollapseSaTOneAllComp(j));
        fragParamBetaALL_mat(j, storyDriftIndex) = stDevLnCollapseSaTOneAllComp(j);
        fragParamImMinALL_mat(j, storyDriftIndex) = minColLevelSaAll(j);
        fragParamImMaxALL_mat(j, storyDriftIndex) = maxColLevelSaAll(j);

        fragParamMuCtrl_mat(j, storyDriftIndex) = exp(meanLnCollapseSaTOneCtrlComp(j));
        fragParamBetaCtrl_mat(j, storyDriftIndex) = stDevLnCollapseSaTOneCtrlComp(j);
        fragParamImMinCtrl_mat(j, storyDriftIndex) = minColLevelSaCtrl(j);
        fragParamImMaxCtrl_mat(j, storyDriftIndex) = maxColLevelSaCtrl(j);
        
    end

	  fragParamMu_ALL = exp(meanLnCollapseSaTOneAllComp);
	  fragParamBetaRTR_ALL = stDevLnCollapseSaTOneAllComp;		

      fragParamMu_CTRL = exp(meanLnCollapseSaTOneCtrlComp);
	  fragParamBetaRTR_CTRL = stDevLnCollapseSaTOneCtrlComp;		

end
%         disp(dataTable); 
        save(fileNameToSaveFragData, 'indFragDataAllComp', 'indFragDataCtrlComp', 'T1LIST', 'bldgIdLIST', 'eqNumberLIST', 'storyDriftLIST', 'fragParamMuALL_mat', 'fragParamBetaALL_mat', ...
            'fragParamImMinALL_mat', 'fragParamImMaxALL_mat', 'fragParamMuCtrl_mat', 'fragParamBetaCtrl_mat', 'fragParamImMinCtrl_mat', 'fragParamImMaxCtrl_mat');
        fprintf('Data file saved as: %s.mat\n', fullfile(pwd, fileNameToSaveFragData));
end

function [T_old, saT_old_AllComp] = prak_util_extractFragDataPoints_v02(analysisTypeFolder, eqNumberLIST, newStoryDrift, matFileToLoad)
baseFolder = pwd;

cd(analysisTypeFolder)
saT_old_AllComp = zeros(1, length(eqNumberLIST));

if abs(newStoryDrift - 0.00)<1e-5 % sidesway collapse
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
% GM spectra and time histories: ...\ida-spo-msa\OpenSeesProcessingFiles 
procFilesFolder = fullfile(fileparts(mfilename('fullpath')), '..', '..', 'OpenSeesProcessingFiles');
spectraFolder   = fullfile(procFilesFolder, 'EQ_Spectra_Saved');
eqTHFolder      = fullfile(procFilesFolder, 'EQs');

switch nargin 
    case 3
        dampRat = 0.05;
end

% We expect, T_old and T_new to be rounded to two decimal places, if not then let's do it now.
T_old = round(T_old *100)/100;
T_new = round(T_new *100)/100;


%% (6-28-19, PSB) Modifying to include ratio to PGA when T_new is entered as 0.00
if abs(T_new) < 0.001 % essentially, zero
    cd(spectraFolder)
    respSpecFile = sprintf('SaEQSpectrum_EQ_%i.mat', eqNumber);
    load(respSpecFile, 'dampRatioLIST', 'periodVector', 'SaAbs');
    
% find the old SaValue
    dampRatIndex = find(abs(dampRatioLIST - dampRat) < 1e-5);
    timePIndexOld = find(abs(periodVector - T_old) < 1e-4);
    SaT_old = SaAbs(timePIndexOld, dampRatIndex);    
    
% % find the PGA value (essentially, SaT_new)
    cd(eqTHFolder)
    timeHistoryFile = sprintf('SortedEQFile_(%i).txt', eqNumber);
    accnArray = load(timeHistoryFile);
    SaT_new = max(abs(min(accnArray)), abs(max(accnArray)));
    saRatNewToOld = SaT_new/SaT_old;

else
    cd(spectraFolder)
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
        