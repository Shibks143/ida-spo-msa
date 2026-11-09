% -------------------
% Procedure: sks_ProcessCloudRuns.m
% Cloud analysis processing: for each record (one unscaled run, see sks_RunCollapseAnaMATLAB_CLOUD.m)
% computes the maximum interstory drift ratio, residual drift ratio and peak floor acceleration with the
% existing single-run processor, and collects them for the two component cases used by IDA/MSA:
%   AllComp     : one point per record component
%   ControlComp : one point per record pair, same rules as sks_ProcessFragilityParams_MSA.m:
%                 demand = max(component 1, component 2); collapse case if EITHER component is a collapse case;
%                 pair excluded if EITHER component is a non-collapse run that is singular or non-converged,
%                 or if a component is missing / had a run error
%
% Reads : Output/<analysisType>/EQ_<n>/DATA_CloudRunForThisEQ.mat (written by the cloud runner)
% Writes: Output/<analysisType>/DATA_CloudData_<setName>.mat                  (tables cloudDataAllComp, cloudDataControlComp)
%         Output/<analysisType>/CloudData_<setName>_<AllComp|ControlComp>.csv          (same tables, for Excel)
%         Output/<analysisType>/CloudData_<setName>_<AllComp|ControlComp>_Sa_MIDR.txt  (2 columns Sa, MIDR of non-collapse
%                                                                                        points; Robust Fragility Tool format)
%
% Must be called from psb_MatlabProcessors (the driver cd's there before processing).
% Author: Shivakumar K S, IIT Madras
% Date:   09-Nov-2026
% -------------------
function sks_ProcessCloudRuns(cloudInputs)

analysisTypeLIST                  = cloudInputs.analysisTypeLIST;
modelNameLIST                     = cloudInputs.modelNameLIST;
eqNumberLIST                      = cloudInputs.eqNumberLIST_forCloud;
dataSavingOption                  = cloudInputs.dataSavingOption;
extraSecondsToRunAnalysis         = cloudInputs.extraSecondsToRunAnalysis;
eqDataFolder                      = cloudInputs.eqDataFolder;
eqListForCloud_Name               = cloudInputs.eqListForCloud_Name;
imType                            = cloudInputs.imType;
periodUsedForScalingGroundMotions = cloudInputs.periodUsedForScalingGroundMotions;

startDir             = pwd;
fixedOutputDirectory = fullfile(startDir, '..', 'Output');
numberOfRecords      = numel(eqNumberLIST);

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeNum};
    modelName    = modelNameLIST{analysisTypeNum};
    fprintf('\nCLOUD processing: %s, %d record component(s)\n', analysisType, numberOfRecords);

    % Per-record results (one entry per record component; filled inside parfor)
    saLevelForCloudLIST                = NaN(numberOfRecords, 1);
    saCompForCloudLIST                 = NaN(numberOfRecords, 1);
    maxDriftRatioForCloudLIST          = NaN(numberOfRecords, 1);
    maxResidualDriftRatioForCloudLIST  = NaN(numberOfRecords, 1);
    maxPFAForCloudLIST                 = NaN(numberOfRecords, 1);
    isCollapsedLIST                    = NaN(numberOfRecords, 1);
    isNonConvLIST                      = NaN(numberOfRecords, 1);
    isSingularLIST                     = NaN(numberOfRecords, 1);
    isRunErrorLIST                     = ones(numberOfRecords, 1);
    isProcessedLIST                    = zeros(numberOfRecords, 1);

    parfor eqNumberIndex = 1:numberOfRecords
        eqNumber       = eqNumberLIST(eqNumberIndex);
        fileNameToLoad = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%d', eqNumber), 'DATA_CloudRunForThisEQ.mat');
        if ~isfile(fileNameToLoad)
            warning('sks:cloudMissing', 'CLOUD: missing %s (run the analysis first)', fileNameToLoad);
            continue;
        end
        loadedCloudRunData = load(fileNameToLoad, 'cloudRun');
        cloudRun           = loadedCloudRunData.cloudRun;

        saLevelForCloudLIST(eqNumberIndex) = cloudRun.saOwn;
        saCompForCloudLIST(eqNumberIndex)  = cloudRun.saCompOwn;
        isCollapsedLIST(eqNumberIndex)     = cloudRun.isCollapsed;
        isNonConvLIST(eqNumberIndex)       = cloudRun.isNonConv;
        isSingularLIST(eqNumberIndex)      = cloudRun.isSingular;
        isRunErrorLIST(eqNumberIndex)      = cloudRun.isRunError;
        if cloudRun.isRunError == 1
            continue;
        end

        % Same rule as MSA: do not process non-collapse runs that are singular or non-converged
        if (cloudRun.isCollapsed == 0) && (cloudRun.isSingular == 1 || cloudRun.isNonConv == 1)
            continue;
        end

        % Existing single-run processor, for the Sa_%.2f folder of this record's own Sa
        [~, maxDriftRatioForFullStr, maxResidualDriftRatioForFullStr, maxPFAForFullStr] = ...
            sks_ProcSingleRun_Collapse_GeneralizedForFramesAndWalls_withGD_MSA( ...
                analysisType, modelName, cloudRun.saOwn, eqNumber, dataSavingOption, extraSecondsToRunAnalysis, eqDataFolder);

        maxDriftRatioForCloudLIST(eqNumberIndex)         = maxDriftRatioForFullStr;
        maxResidualDriftRatioForCloudLIST(eqNumberIndex) = maxResidualDriftRatioForFullStr;
        maxPFAForCloudLIST(eqNumberIndex)                = maxPFAForFullStr;
        isProcessedLIST(eqNumberIndex)                   = 1;
    end
    cd(startDir);   % the single-run processor changes folders; make sure we are back

    % ---------------- AllComp: one point per record component ----------------
    % Collapse case = collapsed, non-converged or singular (cloud definition)
    isCollapseCaseLIST = double(isCollapsedLIST == 1 | isNonConvLIST == 1 | isSingularLIST == 1);
    isExcludedLIST     = isRunErrorLIST;                       % component not usable at all

    cloudDataAllComp = table(eqNumberLIST(:), floor(eqNumberLIST(:)/10), saLevelForCloudLIST, saCompForCloudLIST, ...
        maxDriftRatioForCloudLIST, maxResidualDriftRatioForCloudLIST, maxPFAForCloudLIST, ...
        isCollapsedLIST, isNonConvLIST, isSingularLIST, isCollapseCaseLIST, isRunErrorLIST, isProcessedLIST, isExcludedLIST, ...
        'VariableNames', {'eqNumber', 'eqNumberForGeoMean', 'saOwn', 'saCompOwn', ...
                          'maxDriftRatioForFullStr', 'maxResidualDriftRatioForFullStr', 'maxPFAForFullStr', ...
                          'isCollapsed', 'isNonConv', 'isSingular', 'isCollapseCase', 'isRunError', 'isProcessed', 'isExcluded'});

    % ---------------- ControlComp: one point per record pair (same rules as MSA) ----------------
    if ~strcmp(imType, 'geoMean')
        warning('sks:cloudControlCompIM', ['CLOUD: ControlComp uses one Sa per pair; with imType = ''%s'' the two components ' ...
            'have different Sa, so the Sa of component 1 is used for the pair.'], imType);
    end
    eqNumberForGeoMeanLIST = unique(cloudDataAllComp.eqNumberForGeoMean, 'stable');
    numberOfPairs          = numel(eqNumberForGeoMeanLIST);

    saLevelForPairLIST               = NaN(numberOfPairs, 1);
    maxDriftRatioForPairLIST         = NaN(numberOfPairs, 1);
    maxResidualDriftRatioForPairLIST = NaN(numberOfPairs, 1);
    maxPFAForPairLIST                = NaN(numberOfPairs, 1);
    isCollapseCaseForPairLIST        = zeros(numberOfPairs, 1);
    isProcessedForPairLIST           = zeros(numberOfPairs, 1);
    isExcludedForPairLIST            = ones(numberOfPairs, 1);
    numberOfComponentsForPairLIST    = zeros(numberOfPairs, 1);

    for pairIndex = 1:numberOfPairs
        componentRowsOfPair = cloudDataAllComp(cloudDataAllComp.eqNumberForGeoMean == eqNumberForGeoMeanLIST(pairIndex), :);
        numberOfComponentsForPairLIST(pairIndex) = height(componentRowsOfPair);

        % Exclusion rules (as MSA ControlComp): both components present and run, and no non-collapse singular/non-converged run
        isAnyComponentMissingOrError = height(componentRowsOfPair) < 2 || any(componentRowsOfPair.isRunError == 1);
        isAnyNonCollapseBadRun       = any(componentRowsOfPair.isCollapsed == 0 & ...
                                           (componentRowsOfPair.isSingular == 1 | componentRowsOfPair.isNonConv == 1));
        if isAnyComponentMissingOrError || isAnyNonCollapseBadRun
            continue;
        end

        saLevelForPairLIST(pairIndex)               = componentRowsOfPair.saOwn(1);     % Sa_geoM is the same for both components
        maxDriftRatioForPairLIST(pairIndex)         = max(componentRowsOfPair.maxDriftRatioForFullStr);
        maxResidualDriftRatioForPairLIST(pairIndex) = max(componentRowsOfPair.maxResidualDriftRatioForFullStr);
        maxPFAForPairLIST(pairIndex)                = max(componentRowsOfPair.maxPFAForFullStr);
        isCollapseCaseForPairLIST(pairIndex)        = double(any(componentRowsOfPair.isCollapseCase == 1));
        isProcessedForPairLIST(pairIndex)           = double(all(componentRowsOfPair.isProcessed == 1));
        isExcludedForPairLIST(pairIndex)            = 0;
    end

    cloudDataControlComp = table(eqNumberForGeoMeanLIST(:), saLevelForPairLIST, ...
        maxDriftRatioForPairLIST, maxResidualDriftRatioForPairLIST, maxPFAForPairLIST, ...
        isCollapseCaseForPairLIST, isProcessedForPairLIST, isExcludedForPairLIST, numberOfComponentsForPairLIST, ...
        'VariableNames', {'eqNumberForGeoMean', 'saOwn', ...
                          'maxDriftRatioForFullStr', 'maxResidualDriftRatioForFullStr', 'maxPFAForFullStr', ...
                          'isCollapseCase', 'isProcessed', 'isExcluded', 'numberOfComponents'});

    % ---------------- Save ----------------
    analysisTypeFolderPath = fullfile(fixedOutputDirectory, analysisType);
    fileNameToSave = fullfile(analysisTypeFolderPath, sprintf('DATA_CloudData_%s.mat', eqListForCloud_Name));
    save(fileNameToSave, 'cloudDataAllComp', 'cloudDataControlComp', 'analysisType', 'eqListForCloud_Name', ...
        'imType', 'periodUsedForScalingGroundMotions');

    componentCaseList = {'ControlComp', 'AllComp'};
    cloudDataForCaseList = {cloudDataControlComp, cloudDataAllComp};
    fprintf('CLOUD processing summary (%s):\n', eqListForCloud_Name);
    for componentCaseIndex = 1:numel(componentCaseList)
        componentCase    = componentCaseList{componentCaseIndex};
        cloudDataForCase = cloudDataForCaseList{componentCaseIndex};
        isNonCollapseAndProcessed = cloudDataForCase.isExcluded == 0 & cloudDataForCase.isCollapseCase == 0 & cloudDataForCase.isProcessed == 1;

        writetable(cloudDataForCase, fullfile(analysisTypeFolderPath, sprintf('CloudData_%s_%s.csv', eqListForCloud_Name, componentCase)));
        writematrix([cloudDataForCase.saOwn(isNonCollapseAndProcessed) cloudDataForCase.maxDriftRatioForFullStr(isNonCollapseAndProcessed)], ...
            fullfile(analysisTypeFolderPath, sprintf('CloudData_%s_%s_Sa_MIDR.txt', eqListForCloud_Name, componentCase)), 'Delimiter', 'tab');

        fprintf('  %-11s: points: %d, used: %d, collapse cases: %d, excluded: %d\n', componentCase, height(cloudDataForCase), ...
            sum(cloudDataForCase.isExcluded == 0), sum(cloudDataForCase.isExcluded == 0 & cloudDataForCase.isCollapseCase == 1), ...
            sum(cloudDataForCase.isExcluded == 1));
        fprintf('               Sa range: %.3f - %.3f g;  MIDR range (non-collapse): %.4f - %.4f\n', ...
            min(cloudDataForCase.saOwn), max(cloudDataForCase.saOwn), ...
            min(cloudDataForCase.maxDriftRatioForFullStr(isNonCollapseAndProcessed)), ...
            max(cloudDataForCase.maxDriftRatioForFullStr(isNonCollapseAndProcessed)));
    end
    fprintf('  saved: DATA_CloudData_%s.mat, CloudData_%s_<ControlComp|AllComp>.csv / _Sa_MIDR.txt\n', eqListForCloud_Name, eqListForCloud_Name);
end

cd(startDir);
disp('CLOUD processing - DONE')
end
