function [T_old, saT_old_AllComp] = prak_util_extractFragDataPoints_v02(analysisTypeFolder, eqNumberLIST, newStoryDrift, matFileToLoad)
baseFolder = pwd;
cd(analysisTypeFolder)
saT_old_AllComp = zeros(1, length(eqNumberLIST));

if abs(newStoryDrift - 0.00)<1e-5 % sidesway collapse
%     load DATA_collapse_CollapseSaAndStats_GMSetC_SaGeoMean collapseLevelForAllComp periodUsedForScalingGroundMotions
    load(matFileToLoad, 'collapseLevelForAllComp', 'periodUsedForScalingGroundMotions');
    
    fprintf('Length of collapseLevelForAllComp = %d\n', ...
        length(collapseLevelForAllComp));

    fprintf('Length of eqNumberLIST = %d\n', ...
        length(eqNumberLIST));
    
    
    
    saT_old_AllComp = collapseLevelForAllComp ;
    T_old = periodUsedForScalingGroundMotions;
else
    for eqIndex = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqIndex);
        eqFolder = sprintf('EQ_%d',eqNumber);
        cd(eqFolder)

        % load DATA_collapse_ProcessedIDADataForThisEQ ; % IDA related,added on 27 July 2026
        % saLevels = saLevelsForIDAPlotPROCLIST;
        % maxDriftRatio = maxDriftRatioForPlotPROCLIST;

        load DATA_collapseMSAPlotDataForThisEQ; % MSA related
        saLevels = saLevelsForMSAPlotLIST;
        maxDriftRatio = maxDriftRatioForPlotLIST;
        

        % simple interpolation may not work, since IDAs are non monotonous at times
    %     saCol_BasedOnDriftAllComp(eqIndex) = interp1(maxDriftRatio, saLevels, collapseDrift, 'pchip');
        ix = find(maxDriftRatio  > newStoryDrift, 1);
        if isempty(ix)
            saT_old_AllComp(eqIndex) = saLevels(end);
        else
            saT_old_AllComp(eqIndex) = interp1([maxDriftRatio(ix-1), maxDriftRatio(ix)],[saLevels(ix-1), saLevels(ix)], newStoryDrift, 'pchip');
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