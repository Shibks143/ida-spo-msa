% -------------------
% Procedure: sks_ProcessCloudRuns.m
% Cloud analysis processing: for each record (one unscaled run, see sks_RunCollapseAnaMATLAB_CLOUD.m)
% computes the maximum interstory drift ratio, residual drift ratio and peak floor acceleration with the
% existing single-run processor, and collects everything in one table.
%
% Reads : Output/<analysisType>/EQ_<n>/DATA_CloudRunForThisEQ.mat (written by the cloud runner)
% Writes: Output/<analysisType>/DATA_CloudData_<setName>.mat     (table cloudData, one row per record component)
%         Output/<analysisType>/CloudData_<setName>.csv          (same table, for Excel)
%         Output/<analysisType>/CloudData_<setName>_Sa_MIDR.txt  (2 columns Sa, MIDR of non-collapse runs; Robust Fragility Tool format)
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

    % Collapse case = collapsed, non-converged or singular (cloud definition)
    isCollapseCaseLIST = double(isCollapsedLIST == 1 | isNonConvLIST == 1 | isSingularLIST == 1);

    cloudData = table(eqNumberLIST(:), floor(eqNumberLIST(:)/10), saLevelForCloudLIST, saCompForCloudLIST, ...
        maxDriftRatioForCloudLIST, maxResidualDriftRatioForCloudLIST, maxPFAForCloudLIST, ...
        isCollapsedLIST, isNonConvLIST, isSingularLIST, isCollapseCaseLIST, isRunErrorLIST, isProcessedLIST, ...
        'VariableNames', {'eqNumber', 'eqNumberForGeoMean', 'saOwn', 'saCompOwn', ...
                          'maxDriftRatioForFullStr', 'maxResidualDriftRatioForFullStr', 'maxPFAForFullStr', ...
                          'isCollapsed', 'isNonConv', 'isSingular', 'isCollapseCase', 'isRunError', 'isProcessed'});

    % Save
    analysisTypeFolderPath    = fullfile(fixedOutputDirectory, analysisType);
    isNonCollapseAndProcessed = cloudData.isCollapseCase == 0 & cloudData.isProcessed == 1;

    fileNameToSave = fullfile(analysisTypeFolderPath, sprintf('DATA_CloudData_%s.mat', eqListForCloud_Name));
    save(fileNameToSave, 'cloudData', 'analysisType', 'eqListForCloud_Name', 'imType', 'periodUsedForScalingGroundMotions');
    writetable(cloudData, fullfile(analysisTypeFolderPath, sprintf('CloudData_%s.csv', eqListForCloud_Name)));
    writematrix([cloudData.saOwn(isNonCollapseAndProcessed) cloudData.maxDriftRatioForFullStr(isNonCollapseAndProcessed)], ...
        fullfile(analysisTypeFolderPath, sprintf('CloudData_%s_Sa_MIDR.txt', eqListForCloud_Name)), 'Delimiter', 'tab');

    % Summary
    fprintf('CLOUD processing summary (%s):\n', eqListForCloud_Name);
    fprintf('  records: %d, processed: %d, collapse cases: %d, run errors: %d\n', ...
        numberOfRecords, sum(isProcessedLIST), sum(isCollapseCaseLIST), sum(isRunErrorLIST));
    fprintf('  Sa range: %.3f - %.3f g;  MIDR range (non-collapse): %.4f - %.4f\n', ...
        min(saLevelForCloudLIST), max(saLevelForCloudLIST), ...
        min(cloudData.maxDriftRatioForFullStr(isNonCollapseAndProcessed)), max(cloudData.maxDriftRatioForFullStr(isNonCollapseAndProcessed)));
    fprintf('  saved: DATA_CloudData_%s.mat, CloudData_%s.csv, CloudData_%s_Sa_MIDR.txt\n', ...
        eqListForCloud_Name, eqListForCloud_Name, eqListForCloud_Name);
end

cd(startDir);
disp('CLOUD processing - DONE')
end
