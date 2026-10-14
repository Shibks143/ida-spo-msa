
function sks_ProcessMultipleCollapseRuns_Generalized_withGD_MSA(msaInputs)

analysisTypeLIST          = msaInputs.analysisTypeLIST;
modelNameLIST             = msaInputs.modelNameLIST;
saLevelsForStripes        = msaInputs.saLevelsForStripes;
% isCollapsedForEachRun from msaInputs is a FLAG (false) set in master script
% NOT unpacked here — actual per-run vector loaded inside parfor from file
collapseDriftThreshold    = msaInputs.collapseDriftThreshold;
dataSavingOption          = msaInputs.dataSavingOption;
eqNumberLIST              = msaInputs.eqNumberLIST;
extraSecondsToRunAnalysis = msaInputs.extraSecondsToRunAnalysis;
eqDataFolder              = msaInputs.eqDataFolder;

startDir             = pwd;
fixedOutputDirectory = fullfile(startDir, '..', 'Output');

fprintf('\n=========================================\n');
fprintf('MSA Processing started.\n');
fprintf('Output directory: %s\n', fixedOutputDirectory);
fprintf('=========================================\n');

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeNum};
    modelName    = modelNameLIST{analysisTypeNum};   % Extracted before parfor — matches IDA

    fprintf('\n-----------------------------------------\n');
    fprintf('Processing analysisType = %s\n', analysisType);
    fprintf('-----------------------------------------\n');

    parfor eqIndex = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqIndex);

        eqFolderPath   = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%d', eqNumber));
        fileNameToLoad = fullfile(eqFolderPath, 'DATA_CollapseResultsForThisSingleEQ.mat');

        if ~isfile(fileNameToLoad)
            warning('sks:missingFile', 'Missing: EQ_%d (%s)', eqNumber, analysisType);
            continue;
        end

        % Load per-EQ data written by sks_SaveResultsForThisEQ_MSA
        % saLevelForEachRun   — stripe Sa levels, one per stripe, written by analysis
        % isCollapsedForEachRun — actual per-run collapse flags 
        % numSaLevels         — may be < length(saLevelsForStripes) due to maxNumRuns cap
        [saLevelForEachRun, maxDriftForEachRun, isCollapsedForEachRun, isSingularForEachRun, isNonConvForEachRun, ...
            numSaLevels, periodUsedForScalingGroundMotions, minStoryDriftRatioForCollapseMATLAB] = sks_loadDATAForEachEq_MSA(fileNameToLoad);

        % Initialize plot LIST vectors as empty 
        saLevelsForMSAPlotLIST           = [];
        maxDriftRatioForPlotLIST         = [];
        maxResidualDriftRatioForPlotLIST = [];
        maxPFAForPlotLIST                = [];
        isNonConvLIST                    = [];
        isSingularLIST                   = [];
        isCollapsedLIST                  = [];

        % Defensive initialization — guards against all-skipped case
        % where no stripe passes the singular/non-conv filter
        currentSaLevel = NaN;
        unscaledSaLevelOfRecord_SaIsBasedOnScalingMethodUsed = NaN;

        % -----------------------------------------------------------------
        % Loop over stripe Sa levels for this EQ
        % numSaLevels from loaded file — respects maxNumRuns cap from analysis
        % saLevelForEachRun written by sks_SaveResultsForThisEQ_MSA
        % Matches IDA's saLevelNum loop over saLevelsRunForCollapseAnalysis
        % -----------------------------------------------------------------
        for saIndex = 1:numSaLevels
            currentSaLevel = saLevelForEachRun(saIndex);   

            % Skip padding zeros — matches IDA's (saTOneForRun ~= 0.0) check
            if currentSaLevel <= 0
                continue;
            end

            % Skip non-collapse runs that are singular or non-converged
            % Matches IDA's if/else block exactly —
            % sks_ProcSingleRun NOT called for bad runs, same as IDA
            if (isCollapsedForEachRun(saIndex) == 0) && ...
               (isSingularForEachRun(saIndex) == 1 || isNonConvForEachRun(saIndex) == 1)
               
            else
                % Process this single run — matches IDA's sks_ProcSingleRun call
                % Residual drift and PFA not in analysis file — computed here
                % dataSavingOption = 2 always from master script
                % Sa_%.2f folder navigation inside sks_ProcSingleRun matches
                % analysis file's saFolder = sprintf('Sa_%.2f', currentSaLevel)
                [scaleFactorForRun, maxDriftRatioForFullStr, maxResidualDriftRatioForFullStr, maxPFAForFullStr, isNonConv, isSingular, isCollapsed] = ...
                    sks_ProcSingleRun_Collapse_GeneralizedForFramesAndWalls_withGD_MSA(analysisType, modelName, currentSaLevel, eqNumber, dataSavingOption, extraSecondsToRunAnalysis, eqDataFolder);

                % Compute unscaled Sa — matches IDA's unscaledSaLevelOfRecord line
                unscaledSaLevelOfRecord_SaIsBasedOnScalingMethodUsed = currentSaLevel / scaleFactorForRun;

                % Grow LIST vectors — matches IDA's listIndex pattern
                % MSA uses end+1 since Sa levels are fixed and always
                % increasing — no bisection reordering possible unlike IDA
                saLevelsForMSAPlotLIST(1, end+1)           = currentSaLevel;
                maxDriftRatioForPlotLIST(1, end+1)         = maxDriftRatioForFullStr;
                maxResidualDriftRatioForPlotLIST(1, end+1) = maxResidualDriftRatioForFullStr;
                maxPFAForPlotLIST(1, end+1)                = maxPFAForFullStr;
                isNonConvLIST(1, end+1)                    = isNonConv;
                isSingularLIST(1, end+1)                   = isSingular;
                isCollapsedLIST(1, end+1)                  = isCollapsed;

            end
        end  % for saIndex

        % Compute scale factor at collapse — matches IDA's try/catch block
        % unscaledSaLevelOfRecord holds value from last processed stripe
        % Fallback 999 handles all-skipped case via defensive NaN init above
        try
            scaleFactorOnCompAtCollapse = currentSaLevel / ...
                unscaledSaLevelOfRecord_SaIsBasedOnScalingMethodUsed;
        catch
            scaleFactorOnCompAtCollapse = 999;   % Matches IDA fallback
        end

        % Guard NaN loaded variables — matches IDA pattern
        if isempty(periodUsedForScalingGroundMotions)
            periodUsedForScalingGroundMotions = NaN;
        end
        if isempty(minStoryDriftRatioForCollapseMATLAB)
            minStoryDriftRatioForCollapseMATLAB = NaN;
        end

        % Save per-EQ result
        % saLevelForEachRun passed as authoritative full stripe list
        fileNameToSave = fullfile(eqFolderPath, 'DATA_collapseMSAPlotDataForThisEQ.mat');

        sks_saveDATA_MSA(fileNameToSave, saLevelsForMSAPlotLIST, maxDriftRatioForPlotLIST, maxResidualDriftRatioForPlotLIST, maxPFAForPlotLIST, ...
            saLevelForEachRun, isCollapsedLIST, isSingularLIST, isNonConvLIST, scaleFactorOnCompAtCollapse, ...
            periodUsedForScalingGroundMotions, minStoryDriftRatioForCollapseMATLAB, eqNumber, analysisType);

        warning('sks:savedOK', 'Saved MSA plot data: EQ_%d (%s)', eqNumber, analysisType);

        % Clear per-EQ variables 
        sks_clearVarsForProcessing_MSA(saLevelsForMSAPlotLIST, maxDriftRatioForPlotLIST, maxResidualDriftRatioForPlotLIST, maxPFAForPlotLIST, ...
            saLevelForEachRun, isCollapsedLIST, isSingularLIST, isNonConvLIST, scaleFactorOnCompAtCollapse);

    end  % parfor over EQs

end  % for over analysisTypes

cd(startDir);

fprintf('\n=========================================\n');
fprintf('MSA Processing finished.\n');
fprintf('=========================================\n');

end





































% %
% % Procedure: ProcessMultipleCollapseRuns.m
% % -------------------
% % This procedure simply calls "ProcessSingleRun.m" multiple times to process a lot of data.
% %
% % Assumptions and Notices:
% %
% % Author: Curt Haselton
% % Date Written: 5-11-04
% % Modified: Abbie Liel, 12/11/05
% % Units: Whatever OpenSees is using - just be consistent!
% %
% % -------------------
% function sks_ProcessMultipleCollapseRuns_Generalized_withGD_MSA(msaInputs)
% 
% analysisTypeLIST =           msaInputs.analysisTypeLIST;
% modelNameLIST =              msaInputs.modelNameLIST;
% saLevelsForStripes =         msaInputs.saLevelsForStripes;
% isCollapsedForEachRun =      msaInputs.isCollapsedForEachRun;
% collapseDriftThreshold =     msaInputs.collapseDriftThreshold;
% dataSavingOption =           msaInputs.dataSavingOption;
% eqNumberLIST              =  msaInputs.eqNumberLIST;
% extraSecondsToRunAnalysis =  msaInputs.extraSecondsToRunAnalysis;
% eqDataFolder =               msaInputs.eqDataFolder;
% % modelName                  = msaInputs.modelName;
% % =========================================================================
% % sks_ProcessMultipleCollapseRuns_MSA_Only
% % =========================================================================
% % Clean MSA-only processor.
% %
% % For each EQ folder:
% %   Output/<analysisType>/EQ_#/DATA_CollapseResultsForThisSingleEQ.mat
% %
% % This function creates:
% %   Output/<analysisType>/EQ_#/DATA_collapseMSAPlotDataForThisEQ.mat
% %
% % Saved variables (used by MSA plotting):
% %   saLevelsForMSAPlotLIST
% %   maxDriftRatioForPlotLIST
% %   isCollapsedLIST
% %   isSingularLIST
% %   isNonConvLIST
% %   periodUsedForScalingGroundMotions
% %   minStoryDriftRatioForCollapseMATLAB
% %
% % Collapse logic:
% %   Uses isCollapsedForEachRun exactly as stored by your analysis.
% %
% % Filtering (EXACTLY consistent with your plotting):
% %   - Removes padding zeros (Sa <= 0)
% %   - Removes non-collapse runs that are singular or non-converged
% %     (but keeps collapse even if singular/nonconv)
% %
% % Shivakumar K S (final clean MSA-only version)
% % 11-Feb-2026 IIT Madras
% % =========================================================================
% 
% 
% startDir = pwd;
% 
% % ----------------------------
% % Go to Output folder once
% % ----------------------------
% fixedOutputDirectory = fullfile(startDir, '..', 'Output');
% 
% % cd(startDir);
% % cd ..;
% % cd Output;
% % fixedOutputDirectory = pwd;
% 
% fprintf('\n=========================================\n');
% fprintf('MSA Processing started.\n');
% fprintf('Output directory: %s\n', fixedOutputDirectory);
% fprintf('=========================================\n');
% 
% 
% % ======================================
% % LOOP over analysis types
% % ======================================
% for analysisTypeNum = 1:length(analysisTypeLIST)
%     analysisType = analysisTypeLIST{analysisTypeNum};
% 
%     fprintf('\n-----------------------------------------\n');
%     fprintf('Processing analysisType = %s\n', analysisType);
%     fprintf('-----------------------------------------\n');
% 
%     % ======================================
%     % LOOP over EQs
%     % ======================================
%     parfor eqIndex = 1:length(eqNumberLIST)
%         eqNumber = eqNumberLIST(eqIndex);
%         modelName = modelNameLIST{analysisTypeNum};
% 
%         eqFolderPath = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%d', eqNumber));
%         fileNameToLoad = fullfile(eqFolderPath, 'DATA_CollapseResultsForThisSingleEQ.mat');
% 
%         % AFTER
%         if ~isfile(fileNameToLoad)
%             warning('sks:missingFile', 'Missing: EQ_%d (%s)', eqNumber, analysisType);
%             continue;
%         end
% 
%         % if ~exist(fileNameToLoad, 'file')
%         %     fprintf('Missing: EQ_%d (%s)\n', eqNumber, analysisType);
%         %     continue;
%         % end
% 
%         [saLevelForEachRun, maxDriftForEachRun, isCollapsedForEachRun, isSingularForEachRun, isNonConvForEachRun, ...
%             numSaLevels, periodUsedForScalingGroundMotions, minStoryDriftRatioForCollapseMATLAB] = sks_loadDATAForEachEq_MSA(fileNameToLoad);
% 
%         % ==========================================================
%         % LOAD REQUIRED VARIABLES
%         % ==========================================================
% 
%         % Preallocate structure array for all SA levels
%         allResultsForThisEQ = [];
% 
%         for saIndex = 1:numSaLevels
%             currentSaLevel = saLevelForEachRun(saIndex);
% 
%             if currentSaLevel <= 0
%                 continue;
%             end
% 
%             % Call single-run function and capture all outputs
%             [scaleFactorForRun, maxDriftRatioForFullStr, isNonConv, isSingular, isCollapsed] = ...
%                 sks_ProcSingleRun_Collapse_GeneralizedForFramesAndWalls_withGD_MSA(analysisType, currentSaLevel, eqNumber, dataSavingOption, extraSecondsToRunAnalysis, eqDataFolder);
% 
%             % Store directly into the structure
%             allResultsForThisEQ(saIndex).scaleFactorForRun       = scaleFactorForRun;
%             allResultsForThisEQ(saIndex).maxDriftRatioForFullStr = maxDriftRatioForFullStr;
%             allResultsForThisEQ(saIndex).isNonConv               = isNonConv;
%             allResultsForThisEQ(saIndex).isSingular              = isSingular;
%             allResultsForThisEQ(saIndex).isCollapsed             = isCollapsed;
%         end
% 
%         % Column vectors
%         % Extract vectors from the structure array for this EQ
%         saAll    = saLevelForEachRun(:);                                % SA levels
%         driftAll = [allResultsForThisEQ.maxDriftRatioForFullStr]';      % maximum story drift
%         collapseAll   = [allResultsForThisEQ.isCollapsed]';             % collapse flag
%         singularAll  = [allResultsForThisEQ.isSingular]';               % singular flag
%         nonconvegedAll  = [allResultsForThisEQ.isNonConv]';             % non-converged flag
%         % ==========================================================
%         % REMOVE PADDING ZEROS
%         % ==========================================================
%         valid = (saAll > 0);
%         saAll    = saAll(valid);
%         driftAll = driftAll(valid);
%         collapseAll   = collapseAll(valid);
%         singularAll  = singularAll(valid);
%         nonconvegedAll  = nonconvegedAll(valid);
% 
%         % ==========================================================
%         % FILTER RUNS (MATCHES YOUR PLOTTING EXACTLY)
%         % ==========================================================
%         keep = ~(collapseAll == 0 & (singularAll == 1 | nonconvegedAll == 1));
% 
%         saAll    = saAll(keep);
%         driftAll = driftAll(keep);
%         collapseAll   = collapseAll(keep);
%         singularAll  = singularAll(keep);
%         nonconvegedAll  = nonconvegedAll(keep);
% 
%         % ==========================================================
%         % OUTPUT VARIABLES FOR PLOTTING
%         % ==========================================================
%         saLevelsForMSAPlotLIST    = saAll;
%         maxDriftRatioForPlotLIST  = driftAll;
%         isCollapsedLIST           = collapseAll;
%         isSingularLIST            = singularAll;
%         isNonConvLIST             = nonconvegedAll;
% 
%         % Needed by plot axis labels and collapse drift xline
%         % if ~exist('periodUsedForScalingGroundMotions','var') || isempty(periodUsedForScalingGroundMotions)
%         %     periodUsedForScalingGroundMotions = NaN;
%         % end
%         % 
%         % if ~exist('minStoryDriftRatioForCollapseMATLAB','var') || isempty(minStoryDriftRatioForCollapseMATLAB)
%         %     minStoryDriftRatioForCollapseMATLAB = NaN;
%         % end
% 
% 
%         % AFTER
%         if isempty(periodUsedForScalingGroundMotions)
%             periodUsedForScalingGroundMotions = NaN;
%         end
% 
%         if isempty(minStoryDriftRatioForCollapseMATLAB)
%             minStoryDriftRatioForCollapseMATLAB = NaN;
%         end
% 
%         % ==========================================================
%         % SAVE
%         % ==========================================================
%         fileNameToSave = fullfile(eqFolderPath, 'DATA_collapseMSAPlotDataForThisEQ.mat');
% 
%         sks_saveDATA_MSA(fileNameToSave, saLevelsForMSAPlotLIST, maxDriftRatioForPlotLIST, isCollapsedLIST, isSingularLIST, isNonConvLIST, ...
%             periodUsedForScalingGroundMotions, minStoryDriftRatioForCollapseMATLAB, eqNumber, analysisType);
% 
%         % AFTER
%         warning('sks:savedOK', 'Saved MSA plot data: EQ_%d (%s)', eqNumber, analysisType);
%         % fprintf('Saved MSA plot data: EQ_%d (%s)\n', eqNumber, analysisType);
% 
%     end
% end
% 
% cd(startDir);
% 
% fprintf('\n=========================================\n');
% fprintf('MSA Processing finished.\n');
% fprintf('=========================================\n');
% 
% end
% 
% 
