% -------------------
% Procedure: sks_ProcessCloudRuns.m
% Cloud analysis processing: for each record component (one unscaled run, see sks_RunCollapseAnaMATLAB_CLOUD.m)
% computes the maximum interstory drift ratio, residual drift ratio and peak floor acceleration with the
% existing single-run processor, and saves them per EQ, like the MSA processing does.
% (ControlComp/AllComp tables are built from these per-EQ files in sks_FitCloudFragility.m, as in
%  sks_ProcessFragilityParams_MSA.m for MSA.)
%
% Reads : Output/<analysisType>/EQ_<n>/DATA_CollapseResultsForThisSingleEQ.mat     (variable cloudRun, from the cloud runner)
% Writes: Output/<analysisType>/EQ_<n>/DATA_collapseCLOUDPlotDataForThisEQ.mat     (same name as MSA's ..._MSAPlotDataForThisEQ.mat)
%
% Must be called from psb_MatlabProcessors (the driver cd's there before processing).
% Author: Shivakumar K S, IIT Madras
% Date:   09-Nov-2026
% -------------------
function sks_ProcessCloudRuns(cloudInputs)

analysisTypeLIST          = cloudInputs.analysisTypeLIST;
modelNameLIST             = cloudInputs.modelNameLIST;
eqNumberLIST              = cloudInputs.eqNumberLIST_forCloud;
dataSavingOption          = cloudInputs.dataSavingOption;
extraSecondsToRunAnalysis = cloudInputs.extraSecondsToRunAnalysis;
eqDataFolder              = cloudInputs.eqDataFolder;
eqListForCloud_Name       = cloudInputs.eqListForCloud_Name;

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
        fileNameToLoad = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%d', eqNumber), 'DATA_CollapseResultsForThisSingleEQ.mat');
        if ~isfile(fileNameToLoad)
            warning('sks:cloudMissing', 'CLOUD: missing %s (run the cloud analysis first)', fileNameToLoad);
            continue;
        end
        loadedResultsForThisEQ = load(fileNameToLoad);
        if ~isfield(loadedResultsForThisEQ, 'cloudRun')
            warning('sks:cloudNotCloudResult', 'CLOUD: %s holds IDA/MSA results, not a cloud run; run the cloud analysis (flag 1) for EQ %d.', fileNameToLoad, eqNumber);
            continue;
        end
        cloudRun = loadedResultsForThisEQ.cloudRun;

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

    % ---------------- Save per EQ (like DATA_collapseMSAPlotDataForThisEQ.mat) ----------------
    numberOfSavedFiles = 0;
    for eqNumberIndex = 1:numberOfRecords
        eqNumber     = eqNumberLIST(eqNumberIndex);
        eqFolderPath = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%d', eqNumber));
        if ~isfolder(eqFolderPath)
            continue;
        end
        cloudPlotDataForThisEQ = struct( ...
            'eqNumber',                        eqNumber, ...
            'eqNumberForGeoMean',              floor(eqNumber / 10), ...
            'saOwn',                           saLevelForCloudLIST(eqNumberIndex), ...
            'saCompOwn',                       saCompForCloudLIST(eqNumberIndex), ...
            'maxDriftRatioForFullStr',         maxDriftRatioForCloudLIST(eqNumberIndex), ...
            'maxResidualDriftRatioForFullStr', maxResidualDriftRatioForCloudLIST(eqNumberIndex), ...
            'maxPFAForFullStr',                maxPFAForCloudLIST(eqNumberIndex), ...
            'isCollapsed',                     isCollapsedLIST(eqNumberIndex), ...
            'isNonConv',                       isNonConvLIST(eqNumberIndex), ...
            'isSingular',                      isSingularLIST(eqNumberIndex), ...
            'isCollapseCase',                  isCollapseCaseLIST(eqNumberIndex), ...
            'isRunError',                      isRunErrorLIST(eqNumberIndex), ...
            'isProcessed',                     isProcessedLIST(eqNumberIndex), ...
            'analysisType',                    analysisType);
        fileNameToSave = fullfile(eqFolderPath, 'DATA_collapseCLOUDPlotDataForThisEQ.mat');
        save(fileNameToSave, '-struct', 'cloudPlotDataForThisEQ');
        numberOfSavedFiles = numberOfSavedFiles + 1;
    end

    % Summary
    isNonCollapseAndProcessed = isCollapseCaseLIST == 0 & isProcessedLIST == 1;
    fprintf('CLOUD processing summary (%s):\n', eqListForCloud_Name);
    fprintf('  records: %d, processed: %d, collapse cases: %d, run errors: %d\n', ...
        numberOfRecords, sum(isProcessedLIST), sum(isCollapseCaseLIST), sum(isRunErrorLIST));
    fprintf('  Sa range: %.3f - %.3f g;  MIDR range (non-collapse): %.4f - %.4f\n', ...
        min(saLevelForCloudLIST), max(saLevelForCloudLIST), ...
        min(maxDriftRatioForCloudLIST(isNonCollapseAndProcessed)), max(maxDriftRatioForCloudLIST(isNonCollapseAndProcessed)));
    fprintf('  saved: DATA_collapseCLOUDPlotDataForThisEQ.mat in %d EQ folder(s)\n', numberOfSavedFiles);
end

cd(startDir);
disp('CLOUD processing - DONE')
end
