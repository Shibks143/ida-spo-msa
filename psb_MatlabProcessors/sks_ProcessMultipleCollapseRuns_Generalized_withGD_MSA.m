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
function sks_ProcessMultipleCollapseRuns_Generalized_withGD_MSA(analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, collapseDriftThreshold, dataSavingOption, eqListForCollapseMSAs_Name)

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
cd(startDir);
cd ..;
cd Output;
fixedOutputDirectory = pwd;

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
    for eqInd = 1:length(eqNumberLIST_forProcessing)

        eqNumber = eqNumberLIST_forProcessing(eqInd);

        eqFolderPath = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%d', eqNumber));
        fileNameToLoad = fullfile(eqFolderPath, 'DATA_CollapseResultsForThisSingleEQ.mat');

        if ~exist(fileNameToLoad, 'file')
            warning('Missing file: %s', fileNameToLoad);
            continue;
        end

        % ==========================================================
        % LOAD REQUIRED VARIABLES
        % ==========================================================
        S = load(fileNameToLoad, ...
            'saLevelForEachRun', ...
            'maxDriftForEachRun', ...
            'isCollapsedForEachRun', ...
            'isSingularForEachRun', ...
            'isNonConvForEachRun', ...
            'numSaLevels', ...
            'periodUsedForScalingGroundMotions', ...
            'minStoryDriftRatioForCollapseMATLAB');

        % Some older files may not have numSaLevels
        if isfield(S, 'numSaLevels')
            numSaLevels = S.numSaLevels;
        else
            numSaLevels = length(S.saLevelForEachRun);
        end

        % Safe truncation
        n = min([numSaLevels, ...
                 length(S.saLevelForEachRun), ...
                 length(S.maxDriftForEachRun), ...
                 length(S.isCollapsedForEachRun), ...
                 length(S.isSingularForEachRun), ...
                 length(S.isNonConvForEachRun)]);

        saAll    = S.saLevelForEachRun(1:n);
        driftAll = S.maxDriftForEachRun(1:n);
        colAll   = S.isCollapsedForEachRun(1:n);
        singAll  = S.isSingularForEachRun(1:n);
        noncAll  = S.isNonConvForEachRun(1:n);

        % Column vectors
        saAll    = saAll(:);
        driftAll = driftAll(:);
        colAll   = colAll(:);
        singAll  = singAll(:);
        noncAll  = noncAll(:);

        % ==========================================================
        % REMOVE PADDING ZEROS
        % ==========================================================
        valid = (saAll > 0);

        saAll    = saAll(valid);
        driftAll = driftAll(valid);
        colAll   = colAll(valid);
        singAll  = singAll(valid);
        noncAll  = noncAll(valid);

        % ==========================================================
        % FILTER RUNS (MATCHES YOUR PLOTTING EXACTLY)
        % ==========================================================
        keep = ~(colAll == 0 & (singAll == 1 | noncAll == 1));

        saAll    = saAll(keep);
        driftAll = driftAll(keep);
        colAll   = colAll(keep);
        singAll  = singAll(keep);
        noncAll  = noncAll(keep);

        % ==========================================================
        % OUTPUT VARIABLES FOR PLOTTING
        % ==========================================================
        saLevelsForMSAPlotLIST    = saAll;
        maxDriftRatioForPlotLIST  = driftAll;
        isCollapsedLIST           = colAll;
        isSingularLIST            = singAll;
        isNonConvLIST             = noncAll;

        % Needed by plot axis labels and collapse drift xline
        if isfield(S, 'periodUsedForScalingGroundMotions')
            periodUsedForScalingGroundMotions = S.periodUsedForScalingGroundMotions;
        else
            periodUsedForScalingGroundMotions = NaN;
        end

        if isfield(S, 'minStoryDriftRatioForCollapseMATLAB')
            minStoryDriftRatioForCollapseMATLAB = S.minStoryDriftRatioForCollapseMATLAB;
        else
            minStoryDriftRatioForCollapseMATLAB = NaN;
        end

        % ==========================================================
        % SAVE
        % ==========================================================
        fileNameToSave = fullfile(eqFolderPath, 'DATA_collapseMSAPlotDataForThisEQ.mat');

        save(fileNameToSave, ...
            'saLevelsForMSAPlotLIST', ...
            'maxDriftRatioForPlotLIST', ...
            'isCollapsedLIST', ...
            'isSingularLIST', ...
            'isNonConvLIST', ...
            'periodUsedForScalingGroundMotions', ...
            'minStoryDriftRatioForCollapseMATLAB', ...
            'eqNumber', ...
            'analysisType');

        fprintf('Saved MSA plot data: EQ_%d (%s)\n', eqNumber, analysisType);

    end
end


cd(startDir);

fprintf('\n=========================================\n');
fprintf('MSA Processing finished.\n');
fprintf('=========================================\n');

end







% 
% 
% % Note that the Sa levels to use come from the file in the Collapse folder
% 
% % Input the tolerance that is used in the collapse algorithm, i.e. the step size that it used after it finds the first collapse point (usually 0.05).  
% %   This is used for making the vector for plotting, so that we plot all of the non-collapsed points and only the first collapsed point.
% 
% 
% temp = sprintf('Processing with dataSavingOption = %d...', dataSavingOption);
% disp(temp);
% 
%     for analysisTypeNum = 1:length(analysisTypeLIST)
%                 analysisType = analysisTypeLIST{analysisTypeNum};
% 
% 
%                 cd ..
%                 cd Output
%                 fixedOutputDirectory = pwd;
% 
% 
%         for eqNumNum = 1:length(eqNumberLIST_forProcessing)
%                 eqNumber = eqNumberLIST_forProcessing(eqNumNum);
% 
%                 % Get the Sa levels that were run for the collapse analysis
%                     % First change the directory to get into the correct folder for processing
% 
% %                     cd ..;
% %                     cd Output;
%                     % cd(fixedOutputDirectory)
%                     % 
%                     % % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
%                     % analysisTypeFolder = sprintf('%s', analysisType)
%                     % cd(analysisTypeFolder);
%                     % 
%                     % % EQ folder name
%                     % eqFolder = sprintf('EQ_%.0f', eqNumber);
%                     % cd(eqFolder);
% 
%                     % Get the variable information that I need from the
%                     % collapse .mat file that Matlab made when doing the
%                     % collapse analysis.
% 
%                     % Build full path to the collapse .mat file
%                     eqFolderPath = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%.0f', eqNumber));
%                     fileNameToLoad = fullfile(eqFolderPath, 'DATA_CollapseResultsForThisSingleEQ.mat');
% 
%                     % fileNameToLoad = 'DATA_CollapseResultsForThisSingleEQ.mat';
% 
%                     [saLevelForEachRun, isSingularForEachRun, isNonConvForEachRun, isCollapsedForEachRun] = sks_loadDATAForEachEq_MSA(fileNameToLoad);
% 
%                     % Determine collapse threshold
%                     collapsedIndices = find(isCollapsedForEachRun);
%                     if isempty(collapsedIndices)
%                         collapseLevelFromFileOpened = max(saLevelForEachRun); % no collapse happened
%                     else
%                         collapseLevelFromFileOpened = saLevelForEachRun(collapsedIndices(1)); % first collapsed Sa
%                     end
% 
%                     % Initialize outputs so they always exist
%                     if isempty(saLevelForEachRun)
%                         warning('saLevelForEachRun is empty. Assigning safe default 0.');
%                         saLevelForEachRun = 0;
%                     end
%                     if isempty(isSingularForEachRun)
%                         isSingularForEachRun = zeros(size(saLevelForEachRun));
%                     end
%                     if isempty(isNonConvForEachRun)
%                         isNonConvForEachRun = zeros(size(saLevelForEachRun));
%                     end
% 
%                     saLevelsRunForCollapseAnalysis = saLevelForEachRun;  % rename for clarity
% 
%                     % Assign collapsed flags for each run
%                     if isempty(saLevelForEachRun) || isempty(collapseLevelFromFileOpened)
%                         isCollapsedForEachRun = [];  % safe fallback
%                     else
%                         isCollapsedForEachRun = saLevelForEachRun >= collapseLevelFromFileOpened;
%                     end
% 
% 
%                     % collapseLevelFromFileOpened = saLevelsForStripes
%                     % saLevelsForStripes = [];
%                     % saLevelsRunForCollapseAnalysis = saLevelForEachRun; % Rename
%                     % isCollapsedForEachRun = saLevelForEachRun >= collapseLevelFromFileOpened;
%                     % toleranceUsedInCollapseAlgo = tolerance;    % Rename
% 
%                     % % Get back to initial folder
%                     % cd ..;
%                     % cd ..;
%                     % cd ..;
%                     % cd psb_MatlabProcessors;
% 
% 
%                 % Do processing for this EQ, for all the Sa levels that were run for the collapse analysis (actually only those that are below the collapse point)
% 
%                     % Clear variable that still may be defined from the last processing
% %                     clear saLevelsForIDAPlotLIST maxDriftRatioForPlotLIST
%                     saLevelsForMSAPlotLIST = [];
%                     maxDriftRatioForPlotLIST = [];
%                     isNonConvLIST = [];
%                     isSingularLIST = [];
%                     isCollapsedLIST = [];
% 
%                     % For this EQ, start the plot vectors with a (0, 0) in the first entry
%                     listIndex = 1;
%                     saLevelsForMSAPlotLIST(1, listIndex) = 0;
%                     maxDriftRatioForPlotLIST(1, listIndex) = 0;
%                     listIndex = 2;
%                     maxSaLevelEverAddedToLIST = 0;
%                     firstSaAboveCollapsePoint = 100.0;
%                     maxDriftRatioForFirstSaAboveCollapsePoint = 100.0;
%                     foundPointAboveCollapse = 0;
%                     isNonConvAboveCollapse = -1;
%                     isSingularAboveCollapse = -1;
%                     isCollapsedAboveCollapse = -1;
%                     toleranceUsedInCollapseAlgo = 0.05;
%                     maxDriftRatioForFullStr = 0;
%                     isNonConv = 0;
%                     isSingular = 0;
%                     isCollapsed = 0;
% 
%                     for saLevelNum = 1:length(saLevelsRunForCollapseAnalysis)
%                         saTOneForRun = saLevelsRunForCollapseAnalysis(saLevelNum);
%                         z = 'got here b'
% 
%                         % Only do processing if it's not singular and fully converged (but if it's collapsed, allow it to be singular or non-converged)
%                         if((saTOneForRun < (collapseLevelFromFileOpened + 2.0* toleranceUsedInCollapseAlgo)) && (saTOneForRun ~= 0.0))
% 
%                         % IF it's noncollapsed and singular or non-conv, then break from this loop and don't process this record
%                         % RunCollapseAnaMATLAB_NEWER_proc will take care of this by perturbing the Sa value for convergence.
%                             if((isCollapsedForEachRun(saLevelNum) == 0) && ((isSingularForEachRun(saLevelNum) == 1) || (isNonConvForEachRun(saLevelNum) == 1)))
%                                 % Don't do anything
%                             else
% 
%                                 % Look for the first point that is above the collapse point.  This point will be overwritten below, so we need to save it now
%                                 %   for the case that it is needed for the top point of the collapse IDA.  This portion of code ONLY saves the first point above
%                                 %   the collapse point (the one that was found in the first loop of the simple step collapse algorithm).
%                                     % If this is the point above the collapse point, then save it
%                                 if(saTOneForRun > collapseLevelFromFileOpened)
%                                         % If this saLevel is lower than any collapsed Sa saved before, then save it
%                                         disp('inside a')
%                                         if(saTOneForRun < firstSaAboveCollapsePoint)
%                                             % Save point above collapsed
%                                             firstSaAboveCollapsePoint = saTOneForRun; % indexed to the saLevelsForIDAPlotList in the end if no smaller Sa with collapse is found
%                                             maxDriftRatioForFirstSaAboveCollapsePoint = maxDriftRatioForFullStr;
%                                             isNonConvAboveCollapse = isNonConv;
%                                             isSingularAboveCollapse = isSingular;
%                                             isCollapsedAboveCollapse = isCollapsed;
%                                             disp('inside b')
%                                         end
%                                     else
%                                         % Save information for non-collapsed run
% 
% 
%                                         % NOTICE: This can have problems with not finding the right folder then rounding down to the tenths place.  I changed the order of checking
%                                         %   for folders (looks fo two decimal places first), and I think that this should take care of the problem.
%                                             % Check for maximum
%                                             if(saTOneForRun > maxSaLevelEverAddedToLIST)
%                                                 % Update the maximum
%                                                 disp('Max Sa updated')
%                                                 maxSaLevelEverAddedToLIST = saTOneForRun;
%                                             end
%                                             % Write over last value in lists if we are at a Sa level below the historic maximum Sa level
%                                             if(saTOneForRun < maxSaLevelEverAddedToLIST)
%                                                 % If this is the case, then write over last entry in the plot LIST.  To do this, just decrement the listIndex.
%                                                 disp('Writing over value in LIST');
%                                                 listIndex = listIndex - 1;
%                                             end
% 
%                                         % Now after the processing, there is defined a value of maxDriftForFullFrame, that I will store here to have the max drift level in the frame for this Sa level
%                                         saLevelsForMSAPlotLIST(1, listIndex) = saTOneForRun
% 
%                                         % (11-29-15, PSB) enable if there is any error later on
% 
%                                         maxDriftRatioForPlotLIST(1, listIndex) = maxDriftRatioForFullStr;
% 
% %                                         isNonConvLIST(1, listIndex) = isNonConv;
% %                                         isSingularLIST(1, listIndex) = isSingular;
% %                                         isCollapsedLIST(1, listIndex) = isCollapsed
%             % % % % % % % % % % % % % % % % % % % % % % % % OR % % % % % % % % % % % % % % % 
%                                           [a, b, c] =  Prak_assignValues(isNonConv, isSingular, isCollapsed, listIndex);
%                                         isNonConvLIST = a;
%                                         isSingularLIST = b;
%                                         isCollapsedLIST = c;
% 
%                                         % Update the index
%                                         listIndex = listIndex + 1;
% 
% 
%                                 end
%                             end
%                         end
%                     end
% 
%                     % If we do not have a data point above the collapse point, then add it...
%                     if(foundPointAboveCollapse == 0)
%                         % Add the point above the collapse point
%                             %disp('Adding point above the collapse point');
%                             saLevelsForMSAPlotLIST(1, listIndex) = firstSaAboveCollapsePoint;
%                             maxDriftRatioForPlotLIST(1, listIndex) = maxDriftRatioForFirstSaAboveCollapsePoint;
% 
% %                             isNonConvLIST(1, listIndex) = isNonConvAboveCollapse;
% %                             isSingularLIST(1, listIndex) = isSingularAboveCollapse;
% %                             isCollapsedLIST(1, listIndex) = isCollapsedAboveCollapse;
%             % % % % % % % % % % % % % % % % % % % % % % % % OR % % % % % % % % % % % % % % % 
%             % (11-30-15, PSB) following way around is done for PARFOR to be
%             % able to run. Sliced variables in picture. listIndex is passed to the function Prak_assignValues 
%             % as parameter which assigns d(1, listIndex) the value of isNonConvAboveCollapse etc.
%                                           [d, e, f] =  Prak_assignValues(isNonConvAboveCollapse, isSingularAboveCollapse, isCollapsedAboveCollapse, listIndex);
%                                         isNonConvLIST = d;
%                                         isSingularLIST = e;
%                                         isCollapsedLIST = f;
% 
%                     end
% 
% 
%         % For this EQ, save the information needed for an MSA plot
%             % === PARFOR SAFE SAVE PATH ===
%             eqFolderPath = fullfile(fixedOutputDirectory, analysisType, sprintf('EQ_%.0f', eqNumber));
% 
%             if ~exist(eqFolderPath, 'dir')
%                 mkdir(eqFolderPath);
%             end
% 
%             fileName = fullfile(eqFolderPath, 'DATA_collapseMSAPlotDataForThisEQ.mat');
% 
%             save(fileName, 'saLevelsForMSAPlotLIST', 'maxDriftRatioForPlotLIST', 'isCollapsedLIST', 'isNonConvLIST','isSingularLIST', 'eqNumber', ...
%             'analysisType', 'saLevelsRunForCollapseAnalysis', 'collapseLevelFromFileOpened', 'collapseDriftThreshold', 'toleranceUsedInCollapseAlgo', ...
%             'firstSaAboveCollapsePoint', 'maxSaLevelEverAddedToLIST');
% 
% 
% 
%             % % First change the directory to get into the correct folder for processing
%             % cd ..;
%             % cd Output;
%             % % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
%             % analysisTypeFolder = sprintf('%s', analysisType);
%             % cd(analysisTypeFolder);
%             % 
%             % % EQ folder name
%             % eqFolder = sprintf('EQ_%.0f', eqNumber);
%             % cd(eqFolder);
%             % 
%             % % Save results
%             % fileName = ['DATA_collapseMSAPlotDataForThisEQ.mat'];
%             % save(fileName, 'saLevelsForMSAPlotLIST', 'maxDriftRatioForPlotLIST','isCollapsedLIST','isNonConvLIST','isSingularLIST','eqNumber','analysisType', ...
%             % 'saLevelsRunForCollapseAnalysis', 'collapseLevelFromFileOpened', 'collapseDriftThreshold');
%             % 
%             % % Back to starting folder
%             % cd ..;
%             % cd ..;
%             % cd ..;
%             % cd psb_MatlabProcessors;
% 
%         end 
% 
%     end
% 
