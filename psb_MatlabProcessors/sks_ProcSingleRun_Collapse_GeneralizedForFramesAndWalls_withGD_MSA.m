% Procedure: ProcSingleRun_Collapse_GeneralizedForFramesAndWalls_Full.m
% -------------------
%
% This procedure processes the data that is output from a single run of analysis (one model, one EQ, one SaLevel), and is based
%   on the output file/folder structure that is created by the OpenSees model structure that I use.
%   The data is saved to the matlab file called "DATA_reducedSensDataForThisSingleRun.mat" (with the variable names substituted
%   in the correct locations.  Note that all of the data is saved into a .mat file that will be exactly the same for all runs.
%   This is done so that when looping through all runs (like to make an IDA curve), we can pull out the data that we want during
%   each loop, then on the next loop (for another run) the old data will be overwritten, so that the file size won't grow to
%   be too large when data from many runs are being processed.  This data file is saved in the EQ folder for the specific run.
% Notice that this file is made to only save the minimum things that need to be saved for the EDP data transfer (i.e. peaks and not TH's).
%
%
% Assumptions and Notices:
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%           - This saves the maximums and TH's.  If this becomes too much space on the computer. the loops can easily be changed
%               to compute the maximums and save them, but not to save the TH's.
%           - In the filtering of the floor aceleration data, it is assumed
%
%
% Author: Curt Haselton
% Date Written: 2-26-04
% Updated: 10-1-04
% Revised to include ground displacements, Abbie Liel, 12/12/05
% Sources of Code: Some information was taken from Paul Cordovas processing file called "ProcessData.m".
%
% Functions and Procedures called: none
%
% Variable definitions:
%
%   **NOTICE: These variables are for the processor that saves everything (older on), so I need to update the definitions for this processor.
%
%
%       Note: modelName is just needed to get the input accelTH data to compute the absolute floor accelerations.
%
%       nodeArray  - a cell array of structures holding all the node TH's and maximum values for the nodes in the list of nodes to record (time in col 1 and
%                           displ in col 2).  The node information in indexed in the array under the nodeNum.  This hold the displ
%                           and accel data.
%                           Size: TH fields are numTimeSteps x 2 (dof 1, 2 and 3 displacements)
%                           Fields: displTH, displMax, displMin, displAbsMax, accelTH, accelMax, accelMin, accelAbsMax
%                           Ex. nodeArray{15}.accelTH - acceleration TH's for node 15
%                           Ex. nodeArray{21}.displTH - displacement TH's for node 21

%       storyDriftRatio{storyNum} - cell array structure of story drift ratios
%                           Fields: TH, AbsMax
%                           Ex. storyDriftRatio{2}.AbsMax gives the
%                           absolute maximum story drift of story 2 (between floors 2 and 3).
%       floorAccel{floorNum}.AbsMax - cell array structure of floor accelerations
%                           Fields: TH, AbsMax, AbsMaxFiltered (filtered
%                           using Newmark)
%
%       pseudoTimeVector - a 1 x numTimeSteps vector holding the
%       pseudoTime.  This is mainly created for plotting and to see how long the EQ converged for.
%       maxConvergedTime = the maximum pseudotime that the EQ converged to.
%       dataSavingOption - options for how much data to save
%               = 1 - save all data (time histories, etc.) - these files
%               are used for making videos and plotting TH responses.
%               = 2 - save reduced amount of data (just peaks, etc.) -
%               these files are used to prepare results for Buffalo.
%               = 3 - save both of the above files (b/c different
%               processors use different files, so this may be useful)
%               = 4 - only process and save the drift data (useful for
%               collapse sensitivity studies)
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function [scaleFactorForRun, maxDriftRatioForFullStr, isNonConv, isSingular, isCollapsed] = sks_ProcSingleRun_Collapse_GeneralizedForFramesAndWalls_withGD_MSA(analysisType, currentSaLevel, eqNumber, dataSavingOption, extraSecondsToRunAnalysis)

% IMPORTANT: This is the only processing file that has been being updated
% for the archetype work (7-25-06, CBH)

% Differences:
%   - This saves a .mat file for each Sa level
%   - This computes PGA (for ground level equipment)

disp('Processing Starting...');

% saTOneForRun
% eqNumber

displayFrame = '----------------------------------------------------------';
tempDisplayForProcess = sprintf('%s \n------ EQ Number is %i, Sa(T1) for run is %3.2f ------- \n%s ', displayFrame, eqNumber, currentSaLevel, displayFrame);
disp(tempDisplayForProcess);

% For the PFA calculations, input g
% g = 386.4;
g = 9810;

% Input how many seconds at the end of the EQ should be used to compute residual drifts.  The residual drift is used as the average of the min and max
%   values over the last X seconds of the EQ (assuming that the dT is not split over these last few seconds, so if it is split, then it effectively
%   averages over a bit more time at the end.
secAtEndOfEQForResidual = 3.0; % have patience, this param is used far below of this code (PSB)

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;


% Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
analysisTypeFolder = sprintf('%s', analysisType);
cd(analysisTypeFolder);

% Create Sa and EQ folder names for later use
saFolder = sprintf('Sa_%.2f', currentSaLevel);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Create the prefix for all of the OpenSees output files - changed on
% 7-14-06 for new file naming
%filePrefix = sprintf('(%s)_EQ_(%.0f)_Sa_(%.2f)_', analysisType, eqNumber, saTOneForRun);
filePrefix = sprintf('');

% Get information in the RunInformation folder for this specific run
cd(eqFolder);
cd(saFolder);

    % If there is a RunInformation folder (i.e. if I didn't stop the running), then process the Run Information.
    runFolderName = 'RunInformation';
    cd(runFolderName)
    
    % New collapse items %%%%%%%%%%%%%%%%%%%%%%%%%
    isNonConv = load('isNonConvOUT.out');
    isCollapsed = load('isCollapsedOUT.out');
    isSingular = load('isSingularOUT.out');
    haveGroundDispl = load('findgroundDisplOUT.out');
    %  haveGroundDispl = 1;
    %  haveGroundDispl = 0; %% (9-21-15) Changed it for running the post processing properly! Check the details later- PSB
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    minutesToRunThisAnalysis = load('minutesToRunThisAnalysisOUT.out');
    
    %  disp('NOTICE - Old scale factor file is being loaded - ONLY use this when processing results from older models!');
    %  scaleFactorForRun = load('scaleFactorForRunOUT.out');
    scaleFactorForRun = load('scaleFactorAppliedToCompOUT.out');    % NOTICE - THIS MAY NOT WORK FOR RUNS DONE BEFORE .TCL FILES WERE UPDATED ON 8-30-05 (so you may need to alter this back and just accept the possible error in computing the floor accelerations)
    % Fixed on 8-30-05 to have this be the applied scale factor instead of the ratio of Sa,target and Sa,comp (so this works for any scaling method)
    % Scaled Sa values added on 9-13-05
    saCompScaled = load('saCompScaledOUT.out');
    saGeoMeanScaled = load('saGeoMeanScaledOUT.out');
    
    usedNormDisplIncr = load('usedNormDisplIncrOUT.out');
    nodeNumsAtEachFloorLIST = load('nodeNumsAtEachFloorLISTOUT.out');
    floorHeightsLIST = load('floorHeightListOUT.out');
    
    % Added 6-29-06
    buildingHeight = max(floorHeightsLIST);
    periodUsedForScalingGroundMotionsFromMatlab = load('periodUsedForScalingGroundMotionsFromMatlabOUT.out');
   
    dampingRatioUsedForSaDefFromMatlab = load('dampingRatioUsedForSaDefFromMatlabOUT.out');
    nodeNumToRecordLIST = load('nodeNumToRecordLISTOUT.out');
    %  eqNumberToRunLIST =  load('eqNumberToRunLISTOUT.out');
 
    
    %  numNodes = load('numNodesOUT.out');
    poControlNodeNum = load('poControlNodeNumOUT.out');
    columnNumsAtBaseLIST = load('columnNumsAtBaseLISTOUT.out');
    %  analysisType = load('analysisTypeOUT.out');
    dtForAnalysis = load('dtForAnalysisOUT.out');
    %    eqFullLength = load('eqFullLengthOUT.out');
    maxTolUsed = load('maxTolUsedOUT.out');
    
    cd ..;
    cd ..;
    cd ..;
    
    % Note that floors are numbered starting with one for the ground floor
    numStories = length(nodeNumsAtEachFloorLIST) - 1;
    numFloors = numStories + 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For the PFA calculations, we need to get the EQ TH vector so that we can add it with the relative accelerations to get absolute accelerations at each floor.
% Go into the EQ folder to open the sorted EQ file
startFolder = [pwd];
cd C:\Users\sks\OpenSeesProcessingFiles\EQs

% Make the name of the sorted EQ file to read, as well as dtFile and
% numPoints file (later two added by CBH on 12-17-08 to make things
% process faster).
sortedInputEQFileName = sprintf('SortedEQFile_(%d).txt', eqNumber);
dtFileName = sprintf('DtFile_(%d).txt', eqNumber);
numPointsFileName = sprintf('NumPointsFile_(%d).txt', eqNumber);

% Load the files - scale factor added on 8-9-05 (it wasn't scaled
% before, which was an error).  Later two files added by CBH on
% 12-17-08.
inputGroundAcceleration = load(sortedInputEQFileName) * scaleFactorForRun;
%inputGroundAcceleration = load(sortedInputEQFileName);
dtForCurrentEQ = load(dtFileName);
numPointsForCurrentEQ = load(numPointsFileName);

% Go back to original folder
cd(startFolder);

% Compute PGA - added on 8-9-05
max_temp = max(inputGroundAcceleration);
min_temp = min(inputGroundAcceleration);
PGA = max(abs(max_temp), abs(min_temp));
fprintf('PGA is: %.2fg\n', PGA);


% Make a timeVector for the EQ record
% Get max time for the EQ (for convergence stuff later)
eqTimeLength = numPointsForCurrentEQ * dtForCurrentEQ;

currentTime = 0;
timeVectorForEQRecord=zeros(length(inputGroundAcceleration),1);
for i = 1:length(inputGroundAcceleration)
    timeVectorForEQRecord(i) = currentTime;
    currentTime = currentTime + dtForCurrentEQ;
end

%    textToDisp = sprintf('currentTime is %d',currentTime);
%    disp(textToDisp);

% Format the input acceleration to get rid of the extra steps - only have one point for each dtForAnalysis
% First process the accel vector to not have any extra steps that subdivide dT...
evenStepNum = 1;
currentEvenlySpacedTimeStep = 0;
for inputAccelIndex = 1:length(inputGroundAcceleration)
    % Only save the accel point if it's the next evenly spaced time step, or past the next time step.
    if (timeVectorForEQRecord(inputAccelIndex) >= currentEvenlySpacedTimeStep)
        % Add the step to the processed vectors
        timeVectorForEQRecordProcessed(evenStepNum) = timeVectorForEQRecord(inputAccelIndex);
        inputGroundAccelerationProcessed(evenStepNum) = inputGroundAcceleration(inputAccelIndex);
        evenStepNum = evenStepNum + 1;
        currentEvenlySpacedTimeStep = currentEvenlySpacedTimeStep + dtForAnalysis;
    else
        % Don't do anything, just let the accelTH tick away until we get to the next time step.
    end
end

% Go back to original folder (for EQ's)
%cd ..;
cd ..;
cd ..;
cd Output;
cd(analysisTypeFolder);
%%%%%%%%%%%%%%%%%%


%%%%%%% Get node data, first get to node folder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Node data
cd(eqFolder);
cd(saFolder);
cd Nodes;

% Load node displacement TH data, and compute the max/min/absMax
cd DisplTH;
% Loop through the nodes and get the data

for nodeIndex = 1:length(nodeNumsAtEachFloorLIST)
    nodeNum = nodeNumsAtEachFloorLIST(nodeIndex);
    % Create file name
    if nodeNum == -1
        continue;   % skip ground placeholder
    end
    nodeFileName = sprintf('%sTHNodeDispl_%.0f.out', filePrefix, nodeNum);
    nodeArray{nodeNum}.displTH = load(nodeFileName);
    % Make a vector of the pseudoTime before removing time data (really doesn't need to be in the loop, but easier)
    pseudoTimeVector = nodeArray{nodeNum}.displTH(:, 1);
    % nodeArray{nodeNum}.displTH = nodeArray{nodeNum}.displTH(:, 2:4);    % removing time data, keep DOF 1,2,3
    nodeArray{nodeNum}.displTH = nodeArray{nodeNum}.displTH(:, 2);      % removing time data, keep DOF 1
    nodeArray{nodeNum}.displMax = max(nodeArray{nodeNum}.displTH);
    nodeArray{nodeNum}.displMin = min(nodeArray{nodeNum}.displTH);
    nodeArray{nodeNum}.displAbsMax = max(abs(nodeArray{nodeNum}.displMax), abs(nodeArray{nodeNum}.displMin)); % faster
    %         nodeArray{nodeNum}.displAbsMax = max(abs(nodeArray{nodeNum}.displTH));
end
cd ..;

if (haveGroundDispl ==1)
    %Load Ground Displacement Data
    cd GroundDisplTH;
    % Loop through the nodes in nodeNumToRecordLIST and get the data
    gdFileName = sprintf('%sGroundDispl_%.0f.out', filePrefix, 88002);
    ground.displTH = load(gdFileName);
    % Make a vector of the pseudoTime before removing time data (really doesn't need to be in the loop, but easier)
    psuedoTimeVector = ground.displTH(:, 1);
    % Remove time data from nod array
    ground.displTH = -ground.displTH(:, 2);
    ground.displMax = max(ground.displTH);
    ground.displMin = min(ground.displTH);
    %       displAbsMax has 3 comps, one for each dof (ux, uy, rz)
    ground.displAbsMax = max(abs(ground.displMax), abs(ground.displMin));
    cd ..;
end
% Save the AbsMax displacements for the nodes at each floor level
clear absMaxDisplOfFloor

%  nodeNumsAtEachFloorLIST;
%  nodeArray{nodeNumsAtEachFloorLIST(2)}.displAbsMax;


for floorIndex = 2:length(nodeNumsAtEachFloorLIST)
    absMaxDisplOfFloor{floorIndex} = nodeArray{nodeNumsAtEachFloorLIST(floorIndex)}.displAbsMax;
end

% Do this as long as we are not only saving drift data (for sens.
% studies)
if(dataSavingOption == 2)
    % Load node acceleration TH data, and compute the max/min/absMax
    cd AccelTH;
    % Loop through the nodes and get the data
   
    for nodeIndex = 1:length(nodeNumsAtEachFloorLIST)
        nodeNum = nodeNumsAtEachFloorLIST(nodeIndex);
        % Create file name
        if nodeNum == -1
            continue;
        end
        nodeFileName = sprintf('%sTHNodeAccel_%.0f.out', filePrefix, nodeNum);
        nodeArray{nodeNum}.accelTH = load(nodeFileName);
        % nodeArray{nodeNum}.accelTH = nodeArray{nodeNum}.accelTH(:,2:4);   % removing time data, keep DOF 1,2,3
        nodeArray{nodeNum}.accelTH = nodeArray{nodeNum}.accelTH(:, 2);      % removing time data, keep DOF 1, this will be used later for relTH
        nodeArray{nodeNum}.accelMax = max(nodeArray{nodeNum}.accelTH);
        nodeArray{nodeNum}.accelMin = min(nodeArray{nodeNum}.accelTH);
        nodeArray{nodeNum}.accelAbsMax = max(abs(nodeArray{nodeNum}.accelMax), abs(nodeArray{nodeNum}.accelMin)); % faster
        % nodeArray{nodeNum}.accelAbsMax = max(abs(nodeArray{nodeNum}.accelTH));
    end
    cd ..;
end
cd ..;
%%%%%%% End node data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  START DATA PROCESSING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Compute And Process Roof Drift Ratios And Residual Drift Ratios %%%%%%

% Compute roof drift ratio. This assumes that the displacement for drift is in dof 1 (x dof)
buildingHeight = max(floorHeightsLIST);
roofNodeNum = nodeNumsAtEachFloorLIST(end);

% Compute roof drift
roofDriftRatio.TH = (nodeArray{roofNodeNum}.displTH(:,1)) / buildingHeight;
roofDriftRatio.Max = max(roofDriftRatio.TH);
roofDriftRatio.Min = min(roofDriftRatio.TH);
roofDriftRatio.AbsMax = max(abs(roofDriftRatio.Max), abs(roofDriftRatio.Min)); % faster

% -------------------------------------------------------------------------
% Compute the residual drift ratio.
% After the end of the EQ, extra analysis is run. Ignore the first few seconds,
% then take the first two peaks (max/min) and compute their average.
% -------------------------------------------------------------------------

% Convert time durations to number of points
totalNumAnalysisPoints = length(roofDriftRatio.TH);                              % total analysis (EQ+Extra)
numPointsInExtraAnalysis  = round(extraSecondsToRunAnalysis / dtForAnalysis);    % total extra duration (5 sec)
numPointsToSkip = round(secAtEndOfEQForResidual / dtForAnalysis);                % points to ignore (3 sec)

% Determine the starting point after skipping initial seconds
pointNumAtStartOfResidualCalc = totalNumAnalysisPoints - numPointsInExtraAnalysis + numPointsToSkip;

% Do error check
if(pointNumAtStartOfResidualCalc < 1 || pointNumAtStartOfResidualCalc >= totalNumAnalysisPoints)
    % Not enough valid data → likely collapse or insufficient response
    roofDriftRatio.Residual = 999.0;
else
    % Extract response after skipping initial seconds
    driftSegmentAfterExclusion = roofDriftRatio.TH(pointNumAtStartOfResidualCalc:totalNumAnalysisPoints);

    % Find positive and negative peaks
    [maxPeaks, maxPeakIndices] = findpeaks(driftSegmentAfterExclusion);
    [minPeaks, minPeakIndices] = findpeaks(-driftSegmentAfterExclusion);
    minPeaks = -minPeaks;

    % Combine peaks and sort based on occurrence
    allPeakValues = [maxPeaks(:); minPeaks(:)];
    allPeakIndices  = [maxPeakIndices(:); minPeakIndices(:)];

    % Sort based on time (indices)
    [~, idx] = sort(allPeakIndices);
    sortedPeakValues = allPeakValues(idx);
   
   % Determine residual roof drift ratio
    numPeaks = numel(sortedPeakValues);
    
    % Check if signal crosses zero
    crossesZero = any(sortedPeakValues > 0) && any(sortedPeakValues < 0);
    
    if crossesZero
        % Crossing case: take first positive and first negative peaks
        firstPosPeak = sortedPeakValues(find(sortedPeakValues > 0, 1, 'first'));
        firstNegPeak = sortedPeakValues(find(sortedPeakValues < 0, 1, 'first'));
        roofDriftRatio.Residual = (firstPosPeak + firstNegPeak) / 2;
    else
        % No-crossing case: use first two peaks if available
        if numPeaks >= 2
            roofDriftRatio.Residual = (sortedPeakValues(1) + sortedPeakValues(2)) / 2;
        elseif numPeaks == 1
            roofDriftRatio.Residual = sortedPeakValues(1);
        else
            % No peaks found → likely collapse or insufficient data
            roofDriftRatio.Residual = 999.0;
        end
    end
end

% For saving - no TH results
roofDriftRatioToSave.Max = roofDriftRatio.Max;
roofDriftRatioToSave.Min = roofDriftRatio.Min;
roofDriftRatioToSave.AbsMax = roofDriftRatio.AbsMax;
roofDriftRatioToSave.Residual = roofDriftRatio.Residual;
roofDriftRatioToSave.ResidualAbs = abs(roofDriftRatio.Residual);

%%%% End Of Compute And Process Roof Drift And Residual Drift Ratios %%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Compute And Process Story Drift Ratios And Residual Drift Ratios %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute story drift ratios (note that the ground floor is floor 1)
% This assumes that the displacement for drift is in dof 1 (x dof)
maxDriftForFullFrame = 0;

numPointsToSkip = round(secAtEndOfEQForResidual / dtForAnalysis);
numPointsInExtraAnalysis  = round(extraSecondsToRunAnalysis / dtForAnalysis);

for floorNum = 2:length(floorHeightsLIST)
    storyNum = floorNum - 1;
    storyHeight = floorHeightsLIST(floorNum) - floorHeightsLIST(floorNum - 1);
    %disp(storyHeight)
    upperFloorNodeNum = nodeNumsAtEachFloorLIST(floorNum);
    lowerFloorNodeNum = nodeNumsAtEachFloorLIST(floorNum - 1);

    % Compute drift, for a nodeNum of -1, it's the ground node that has 0 displacement
    if(lowerFloorNodeNum == -1)
        % The lower floor is the ground, so it has zero displacement
        storyDriftRatio{storyNum}.TH = (nodeArray{upperFloorNodeNum}.displTH(:,1) - 0) / storyHeight;
    else
        % We are in an upper floor - do normal calculation
        storyDriftRatio{storyNum}.TH = (nodeArray{upperFloorNodeNum}.displTH(:,1) - nodeArray{lowerFloorNodeNum}.displTH(:,1)) / storyHeight;
    end
    storyDriftRatio{storyNum}.Max = max(storyDriftRatio{storyNum}.TH);
    storyDriftRatio{storyNum}.Min = min(storyDriftRatio{storyNum}.TH);
    storyDriftRatio{storyNum}.AbsMax = max(abs(storyDriftRatio{storyNum}.Max), abs(storyDriftRatio{storyNum}.Min));


    % If this story has higher drift, update max value
    if(storyDriftRatio{storyNum}.AbsMax > maxDriftForFullFrame)
        maxDriftForFullFrame = storyDriftRatio{storyNum}.AbsMax;
    end

    % -------------------------------------------------------------------------
    % Compute interstory residual drift ratio using peak-based method
    % Skip initial seconds after EQ, then use first two peaks
    % -------------------------------------------------------------------------

    totalNumAnalysisPoints = length(storyDriftRatio{storyNum}.TH);

    % Determine starting point after skipping initial seconds
    pointNumAtStartOfResidualCalc = totalNumAnalysisPoints - numPointsInExtraAnalysis + numPointsToSkip;

    % Error check
    if(pointNumAtStartOfResidualCalc < 1 || pointNumAtStartOfResidualCalc >= totalNumAnalysisPoints)
        storyDriftRatio{storyNum}.Residual = 999.0;
    else
        % Extract drift segment after exclusion
        driftSegmentAfterExclusion = storyDriftRatio{storyNum}.TH(pointNumAtStartOfResidualCalc:totalNumAnalysisPoints);

        % Find positive and negative peaks
        [maxPeaks, maxPeakIndices] = findpeaks(driftSegmentAfterExclusion);
        [minPeaks, minPeakIndices] = findpeaks(-driftSegmentAfterExclusion);
        minPeaks = -minPeaks;

        % Combine peaks and sort based on time
        allPeakValues  = [maxPeaks(:); minPeaks(:)];
        allPeakIndices = [maxPeakIndices(:); minPeakIndices(:)];

        [~, idx] = sort(allPeakIndices);
        sortedPeakValues = allPeakValues(idx);

    % Determine residual interstory drift ratio
        numPeaks = numel(sortedPeakValues);
        crossesZero = any(sortedPeakValues > 0) && any(sortedPeakValues < 0);
    
        if crossesZero
            % Crossing case → average first positive and first negative peaks
            firstPosPeak = sortedPeakValues(find(sortedPeakValues > 0, 1, 'first'));
            firstNegPeak = sortedPeakValues(find(sortedPeakValues < 0, 1, 'first'));
            storyDriftRatio{storyNum}.Residual = (firstPosPeak + firstNegPeak) / 2;
        else
            % No-crossing case → average first two peaks if available
            if numPeaks >= 2
                storyDriftRatio{storyNum}.Residual = (sortedPeakValues(1) + sortedPeakValues(2)) / 2;
            elseif numPeaks == 1
                storyDriftRatio{storyNum}.Residual = sortedPeakValues(1);
            else
                % No peaks found → likely collapse or insufficient data
                storyDriftRatio{storyNum}.Residual = 999.0;
            end
        end
    end

    % For saving - no TH results
    storyDriftRatioToSave{storyNum}.Max = storyDriftRatio{storyNum}.Max;
    storyDriftRatioToSave{storyNum}.Min = storyDriftRatio{storyNum}.Min;
    storyDriftRatioToSave{storyNum}.AbsMax = storyDriftRatio{storyNum}.AbsMax;
    storyDriftRatioToSave{storyNum}.Residual = storyDriftRatio{storyNum}.Residual;
    storyDriftRatioToSave{storyNum}.ResidualAbs = abs(storyDriftRatio{storyNum}.Residual);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Compute and Process Floor Accelerations %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(dataSavingOption == 2)
    % Make a cell structure of vectors of floor accelerations
    for floorNum = 2:numFloors
        floorNodeNum = nodeNumsAtEachFloorLIST(floorNum);
        floorAccel{floorNum}.relTH = nodeArray{floorNodeNum}.accelTH(:,1);
        floorAccel{floorNum}.relAbsMax = nodeArray{floorNodeNum}.accelAbsMax(1);

        % Format the response acceleration to get rid of intermediate steps (to just have one point for each dT)
        % First process the accel vector to not have any extra steps that subdivide dT...
        evenStepNum = 1;
        currentEvenlySpacedTimeStep = 0;
        floorAccel{floorNum}.relTHProcessed = zeros(1, length(floorAccel{floorNum}.relTH)); % Initialize to zeros, to erase data from last run

        for inputAccelIndex = 1:length(floorAccel{floorNum}.relTH)
            % Only save the accel point if it's the next evenly spaced time step, or past the next time step.
            if ((pseudoTimeVector(inputAccelIndex) >= currentEvenlySpacedTimeStep))
                % Add the step to the processed vector
                timeVectorProcessed(evenStepNum) = (pseudoTimeVector(inputAccelIndex));
                floorAccel{floorNum}.relTHProcessed(evenStepNum) = floorAccel{floorNum}.relTH(inputAccelIndex);
                evenStepNum = evenStepNum + 1;
                currentEvenlySpacedTimeStep = currentEvenlySpacedTimeStep + dtForAnalysis;
            else
                % Don't do anything, just let the accelTH tick away until we get to the next time step.
            end
        end

        % Add the input ground accelerations to get the absolute floor accelerations, b/c the data from the node recorders are relative accelerations.
        % Find shorter of two vectors, so we won't get errors when adding the vectors.
        % disp(length(floorAccel{floorNum}.relTH));
        % disp(length(inputGroundAccelerationProcessed));

        minLength = min(length(inputGroundAccelerationProcessed), length(floorAccel{floorNum}.relTH));
        % Add vectors
        floorAccel{floorNum}.absTH = floorAccel{floorNum}.relTH(1:minLength) + ((inputGroundAccelerationProcessed(1:minLength)') * g);
        % Find the abs max.
        floorAccel{floorNum}.absAbsMax = max(abs(floorAccel{floorNum}.absTH));

        % Filter the floor accelerations to remove strange numerical noise.  Use the Newmark scheme with T = 1/33 (Cornell) and no damping.
        % Note that the ComputeAllResponsesNewmark.m returns more information than I need (i.e. displ., vel., etc.), so I am storing those in junk variables!
        %function[maxRelDispReponse, maxRelVelReponse, maxAbsAccelReponse, maxPseudoAccelReponse] = ComputeAllResponsesNewmark(accelTH, timeVector, dT, period, dampRatio)
        % Go back to the Matlab folder to do the processing
        tempFolder2 = pwd;
        cd ..;
        cd ..;
        cd ..;
        cd ..;
        cd psb_MatlabProcessors;

        % Process
        % [junk1, junk2, maxFilteredFloorAccel, junk3] = ComputeAllResponsesNewmark((floorAccel{floorNum}.absTH / g), pseudoTimeVector, dtForAnalysis, period, dampRatio);
        % floorAccel{floorNum}.absAbsMaxFiltered = (maxFilteredFloorAccel * g);

        % Go back to initial folder
        cd(tempFolder2);

        % Just to save for later - no TH results
        % floorAccelToSave{floorNum}.relAbsMaxUnfiltered = floorAccel{floorNum}.relAbsMax;
        floorAccelToSave{floorNum}.absAbsMaxUnfiltered = floorAccel{floorNum}.absAbsMax;
        % floorAccelToSave{floorNum}.absAbsMaxFiltered = floorAccel{floorNum}.absAbsMaxFiltered;

    end
end

%%%%%%%%%%%%%%%%% End Of Compute And Process Floor Accelerations %%%%%%%%%%


%%%%%%%%%%%%%%%%%%% Convergence %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the maximum time of the EQ - to later see if it converged for the full EQ.
maxConvergedTime = max(pseudoTimeVector); %pseudoTimeVector is derived from displacement TH of nodes from nodeArray

% Check if it's converged for the full EQ (at least up to the last 2 seconds)
if(maxConvergedTime > (eqTimeLength - 2.0))
    % Fully converged
    isConvForFullEQ = 1;
else
    % Non-converged
    isConvForFullEQ = 0;
end
%%%%%%%%%%%%%%%%%%% End of Convergence %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%% Compute Max Drift Ratio for the Full Building %%%%%%%%%%%%%%%%%%%

% Compute the maximum drift ratio for the full building
% Loop through all stories and save the maximum
maxDriftRatioForFullStr = 0;
for i = 1:length(storyDriftRatioToSave)
    currentDriftRatio = storyDriftRatioToSave{i}.AbsMax;
    % Update maximum if needed
    if(currentDriftRatio > maxDriftRatioForFullStr)
        maxDriftRatioForFullStr = currentDriftRatio;
    end
end

%%%%%%%%% End of Computation of  Max Drift Ratio for the Full Building %%%%


% Save all of this data into the folder for the proper EQ, under the correct Sa level (we are already in the right folder)
% Only save the information that is needed so that it will be more "bug resistant".

if(dataSavingOption == 2)
    fileName = 'DATA_reducedSensDataForThisSingleRun.mat';

    save(fileName, 'eqNumber', 'scaleFactorForRun', 'currentSaLevel', 'PGA', 'saCompScaled', 'saGeoMeanScaled','floorAccelToSave', 'storyDriftRatioToSave', ...
        'roofDriftRatioToSave', 'maxDriftForFullFrame', 'maxDriftRatioForFullStr', 'absMaxDisplOfFloor', 'buildingHeight', 'numStories', 'maxConvergedTime', 'eqTimeLength', 'isConvForFullEQ', ...
        'maxTolUsed', 'periodUsedForScalingGroundMotionsFromMatlab');

end


%%%%%%%%%%%%%% Output Warnings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Output warnings if there is a problem with convergence or with the tolerance - put this in the output folder
% Go to Output folder
cd ..;
cd ..;
cd ..;
% Make a WARNING file, go into folder first
cd Conv_Warning_Files;

% Output a warnings if needed
if(isConvForFullEQ == 0)
    % Non-conv, issue warning
    disp('#####################');
    disp('WARNING - Convergence');
    disp('#####################');
    fileName1 = sprintf('WARNING_Conv_%s.txt', filePrefix);
    %myFileStream1 = fopen(fileName1, 'write');
    myFileStream1 = fopen(fileName1, 'w');
    fprintf(myFileStream1, 'Current analysis only converged to %.2f of %.2f seconds', maxConvergedTime, eqTimeLength);
    fclose(myFileStream1);
end

if(maxTolUsed > 0.0001)
    % Tolerance too wide, issue warning
    disp('###################');
    disp('WARNING - tolerance');
    disp('###################');
    fileName2 = sprintf('WARNING_Tolerance_%s.txt', filePrefix);
    %myFileStream2 = fopen(fileName2, 'write');
    myFileStream2 = fopen(fileName2, 'w');
    fprintf(myFileStream2, 'Maximum tolerance is %.8f', maxTolUsed);
    fclose(myFileStream2);
end

%%%%%%%%%%%%%% End of Warnings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd psb_MatlabProcessors;

disp('Processing Finished for this EQ.');

