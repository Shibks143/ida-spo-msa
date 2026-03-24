%
% Procedure: ProcessMultipleCollapseRuns.m
% -------------------
% This procedure simply calls "ProcessSingleRun.m" multiple times to process a lot of data.
%
% Assumptions and Notices:
%
% Author: Curt Haselton
% Date Written: 5-11-04
% Modified: Abbie Liel, 12/11/05
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function sks_ProcessMultipleCollapseRuns_Generalized_withGD_MSA(msaInputs)

analysisTypeLIST =           msaInputs.analysisTypeLIST;
modelNameLIST =              msaInputs.modelNameLIST;
saLevelsForStripes =         msaInputs.saLevelsForStripes;
isCollapsedForEachRun =      msaInputs.isCollapsedForEachRun;
collapseDriftThreshold =     msaInputs.collapseDriftThreshold;
dataSavingOption =           msaInputs.dataSavingOption;
eqNumberLIST              =  msaInputs.eqNumberLIST;
extraSecondsToRunAnalysis =  msaInputs.extraSecondsToRunAnalysis;
% modelName                  = msaInputs.modelName;
% =========================================================================
% sks_ProcessMultipleCollapseRuns_MSA_Only
% =========================================================================
% Clean MSA-only processor.
%
% For each EQ folder:
%   Output/<analysisType>/EQ_#/DATA_CollapseResultsForThisSingleEQ.mat
%
% This function creates:
%   Output/<analysisType>/EQ_#/DATA_collapseMSAPlotDataForThisEQ.mat
%
% Saved variables (used by MSA plotting):
%   saLevelsForMSAPlotLIST
%   maxDriftRatioForPlotLIST
%   isCollapsedLIST
%   isSingularLIST
%   isNonConvLIST
%   periodUsedForScalingGroundMotions
%   minStoryDriftRatioForCollapseMATLAB
%
% Collapse logic:
%   Uses isCollapsedForEachRun exactly as stored by your analysis.
%
% Filtering (EXACTLY consistent with your plotting):
%   - Removes padding zeros (Sa <= 0)
%   - Removes non-collapse runs that are singular or non-converged
%     (but keeps collapse even if singular/nonconv)
%
% Shivakumar K S (final clean MSA-only version)
% 11-Feb-2026 IIT Madras
% =========================================================================


startDir = pwd;

% ----------------------------
% Go to Output folder once
% ----------------------------
fixedOutputDirectory = fullfile(startDir, '..', 'Output');

% cd(startDir);
% cd ..;
% cd Output;
% fixedOutputDirectory = pwd;

fprintf('\n=========================================\n');
fprintf('MSA Processing started.\n');
fprintf('Output directory: %s\n', fixedOutputDirectory);
fprintf('=========================================\n');


% ======================================
% LOOP over analysis types
% ======================================
for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeNum};

    fprintf('\n-----------------------------------------\n');
    fprintf('Processing analysisType = %s\n', analysisType);
    fprintf('-----------------------------------------\n');

    % ======================================
    % LOOP over EQs
    % ======================================
    for eqIndex = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqIndex);
        modelName = modelNameLIST{analysisTypeNum};

        eqFolderPath = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%d', eqNumber));
        fileNameToLoad = fullfile(eqFolderPath, 'DATA_CollapseResultsForThisSingleEQ.mat');

        if ~exist(fileNameToLoad, 'file')
            fprintf('Missing: EQ_%d (%s)\n', eqNumber, analysisType);
            continue;
        end

        [saLevelForEachRun, maxDriftForEachRun, isCollapsedForEachRun, isSingularForEachRun, isNonConvForEachRun, ...
            numSaLevels, periodUsedForScalingGroundMotions, minStoryDriftRatioForCollapseMATLAB] = sks_loadDATAForEachEq_MSA(fileNameToLoad);

        % ==========================================================
        % LOAD REQUIRED VARIABLES
        % ==========================================================
        
        % Preallocate structure array for all SA levels
        allResultsForThisEQ = [];

        for saIndex = 1:numSaLevels
            currentSaLevel = saLevelForEachRun(saIndex);

            if currentSaLevel <= 0
                continue;
            end

            % Call single-run function and capture all outputs
            [scaleFactorForRun, maxDriftRatioForFullStr, isNonConv, isSingular, isCollapsed] = ...
                sks_ProcSingleRun_Collapse_GeneralizedForFramesAndWalls_withGD_MSA(analysisType, currentSaLevel, eqNumber, dataSavingOption, extraSecondsToRunAnalysis);

            % Store directly into the structure
            allResultsForThisEQ(saIndex).scaleFactorForRun       = scaleFactorForRun;
            allResultsForThisEQ(saIndex).maxDriftRatioForFullStr = maxDriftRatioForFullStr;
            allResultsForThisEQ(saIndex).isNonConv               = isNonConv;
            allResultsForThisEQ(saIndex).isSingular              = isSingular;
            allResultsForThisEQ(saIndex).isCollapsed             = isCollapsed;
        end
        
        % Column vectors
        % Extract vectors from the structure array for this EQ
        saAll    = saLevelForEachRun(:);                                % SA levels
        driftAll = [allResultsForThisEQ.maxDriftRatioForFullStr]';      % maximum story drift
        collapseAll   = [allResultsForThisEQ.isCollapsed]';             % collapse flag
        singularAll  = [allResultsForThisEQ.isSingular]';               % singular flag
        nonconvegedAll  = [allResultsForThisEQ.isNonConv]';             % non-converged flag
        % ==========================================================
        % REMOVE PADDING ZEROS
        % ==========================================================
        valid = (saAll > 0);
        saAll    = saAll(valid);
        driftAll = driftAll(valid);
        collapseAll   = collapseAll(valid);
        singularAll  = singularAll(valid);
        nonconvegedAll  = nonconvegedAll(valid);

        % ==========================================================
        % FILTER RUNS (MATCHES YOUR PLOTTING EXACTLY)
        % ==========================================================
        keep = ~(collapseAll == 0 & (singularAll == 1 | nonconvegedAll == 1));

        saAll    = saAll(keep);
        driftAll = driftAll(keep);
        collapseAll   = collapseAll(keep);
        singularAll  = singularAll(keep);
        nonconvegedAll  = nonconvegedAll(keep);

        % ==========================================================
        % OUTPUT VARIABLES FOR PLOTTING
        % ==========================================================
        saLevelsForMSAPlotLIST    = saAll;
        maxDriftRatioForPlotLIST  = driftAll;
        isCollapsedLIST           = collapseAll;
        isSingularLIST            = singularAll;
        isNonConvLIST             = nonconvegedAll;

        % Needed by plot axis labels and collapse drift xline
        if ~exist('periodUsedForScalingGroundMotions','var') || isempty(periodUsedForScalingGroundMotions)
            periodUsedForScalingGroundMotions = NaN;
        end

        if ~exist('minStoryDriftRatioForCollapseMATLAB','var') || isempty(minStoryDriftRatioForCollapseMATLAB)
            minStoryDriftRatioForCollapseMATLAB = NaN;
        end

        % ==========================================================
        % SAVE
        % ==========================================================
        fileNameToSave = fullfile(eqFolderPath, 'DATA_collapseMSAPlotDataForThisEQ.mat');

        save(fileNameToSave, ...
            'saLevelsForMSAPlotLIST', 'maxDriftRatioForPlotLIST', 'isCollapsedLIST', 'isSingularLIST', 'isNonConvLIST', ...
            'periodUsedForScalingGroundMotions', 'minStoryDriftRatioForCollapseMATLAB', 'eqNumber', 'analysisType');

        fprintf('Saved MSA plot data: EQ_%d (%s)\n', eqNumber, analysisType);

    end
end

cd(startDir);

fprintf('\n=========================================\n');
fprintf('MSA Processing finished.\n');
fprintf('=========================================\n');

end


