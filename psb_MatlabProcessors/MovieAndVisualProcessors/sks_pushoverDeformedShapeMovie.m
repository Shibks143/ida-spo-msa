
function [] = sks_pushoverDeformedShapeMovie(bldgID_LIST, analysisDirLIST, driftIncrementPerFrame, displScaleFactor, movieOutputFolder, showWhileRunning)
%
% Function: sks_pushoverDeformedShapeMovie.m
% -------------------
% This function makes a movie (MP4) of the pushover analysis. Each frame shows
% the deformed frame with plastic hinges (left) and the pushover curve with a
% marker at the current step (right). Hinges grow as plastic rotation increases
% and turn red once they pass the capping rotation, so the yield sequence can
% be watched step by step.
%
% Variable definitions:
%       bldgID_LIST- ID to determine which building to plot (as defined in psb_DefineInfoForBuildings.m); could contain a list
%       analysisDirLIST- Directory for analysis outputs; could contain a list
%       driftIncrementPerFrame- (optional) roof drift ratio between two frames; default 0.0005 (0.05% roof drift)
%       displScaleFactor- (optional) factor on floor displacements in the drawing only; default 1.0
%       movieOutputFolder- (optional) folder to save the movie; default is the building folder in Output
%
% Assumptions and Notices:
%       - Reads the same recorders as psb_pushoverDeformedShape.m:
%           Elements\Joints\Joint_ForceAndDef_<jointNum>.out and Elements\Hinges\HingeRotTH_<hingeNum>.out
%       - Frames are chosen by roof drift, not by analysis step, so the movie pace is the same for
%           buildings with very different numbers of analysis steps.
%       - Hinge demand at a frame is the largest plastic rotation reached up to that step.
%       - This function does not write anything to DATA_allDataForThisSingleRun.mat.
%
% Author: Shivakumar K S (based on psb_pushoverDeformedShape.m by Prakash S Badal and DrawDistortedFrame by Haselton)
% Date Written: 11-23-26
%
% Functions and Procedures called: psb_DefineInfoForBuildings, psb_DrawDistortedFrame
%
% Units: kN and mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3 || isempty(driftIncrementPerFrame), driftIncrementPerFrame = 0.0005; end
if nargin < 4 || isempty(displScaleFactor), displScaleFactor = 1.0; end
if nargin < 5, movieOutputFolder = ''; end
if nargin < 6 || isempty(showWhileRunning), showWhileRunning = true; end   % true- figure pops up and updates while frames are written

%% more inputs; can choose to change them for specific movies
lateralDispDOF = 1;
maxOnDemandCapacityRatioToPlot = 3.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.
framesPerSecond = 10;
yieldPlasticRotation = 0.0005;   % (rad) a hinge is counted as yielded once its plastic rotation exceeds this value
pauseSecondsAtEvent = 1.0;       % (s) the movie holds this long on each key event (first beam yield, Vmax, etc.)
% Set some dummy variables to say that we do not want to highlight any hinges differently
    isHingesHighlighted = 0;        % 0- No highlighting
    hingeHighlighted_1 = [3,2,2];   % [floorNum, colLineNum, jointNodeNum]
    hingeHighlighted_2 = [3,2,4];   % [floorNum, colLineNum, jointNodeNum]
    highlightedHingeColor_1 = 'm';
    highlightedHingeColor_2 = 'c';
    titleOption = 3;  % 3- use pushover titles
    saDefType = 0;    % NOT required for pushover
    periodUsedForScalingGroundMotionsFromMatlab = 0; % not needed if titleOption = 3

% Folders (absolute, so this function does not depend on the current folder)
visualProcessorsFolder = fileparts(mfilename('fullpath'));
rootFolder = fileparts(fileparts(visualProcessorsFolder));
baseFolder = pwd;

%% run over each building in the list
[buildingInfo] = psb_DefineInfoForBuildings;
for bldgIndex = 1:length(bldgID_LIST)
    bldgID = bldgID_LIST(bldgIndex);
    analysisDir = analysisDirLIST{bldgIndex};
    runFolder = fullfile(rootFolder, 'Output', analysisDir, 'EQ_9991', 'Sa_0.00');

    load(fullfile(runFolder, 'DATA_allDataForThisSingleRun.mat'), 'nodeArray', 'nodeNumsAtEachFloorLIST', ...
        'baseShear', 'poControlNodeNum', 'floorHeightsLIST');

    numColLines = buildingInfo{bldgID}.numBays + 1;
    maxFloorNum = buildingInfo{bldgID}.numStories + 1;
    fprintf('(%i/%i) Movie for %s: %i column lines, %i floor levels.\n', bldgIndex, length(bldgID_LIST), analysisDir, numColLines, maxFloorNum);

%% pushover curve (same definition as PlotPushover.m)
    roofDispTH = nodeArray{poControlNodeNum}.displTH(:, lateralDispDOF);
    baseShearTH = -baseShear.TH;
    firstPositiveDispIndex = find(roofDispTH >= 0, 1);
    if firstPositiveDispIndex > 1
        offsetOfBaseShear = interp1([roofDispTH(firstPositiveDispIndex-1), roofDispTH(firstPositiveDispIndex)], ...
            [baseShearTH(firstPositiveDispIndex-1), baseShearTH(firstPositiveDispIndex)], 0, 'pchip');
        baseShearTH = baseShearTH - offsetOfBaseShear;
    end
    numStepsInAnalysis = min(length(roofDispTH), length(baseShearTH));
    roofDriftTH = roofDispTH(1:numStepsInAnalysis) / max(floorHeightsLIST);
    baseShearTH = baseShearTH(1:numStepsInAnalysis);

%% hinge rotation histories (read once)
    jointRotationTH = {};
    for currentFloorNum = 2:maxFloorNum
        for currentColLineNum = 1:numColLines
            currentJointNum = buildingInfo{bldgID}.jointNumber(currentFloorNum, currentColLineNum);
            jointRotationTH{currentJointNum} = load(fullfile(runFolder, 'Elements', 'Joints', sprintf('Joint_ForceAndDef_%i.out', currentJointNum)));
        end
    end
    colBaseRotationTH = {};
    for currentColLineNum = 1:numColLines
        currentColBaseHingeNum = buildingInfo{bldgID}.hingeElementNumAtColBase(currentColLineNum);
        colBaseRotationTH{currentColBaseHingeNum} = load(fullfile(runFolder, 'Elements', 'Hinges', sprintf('HingeRotTH_%i.out', currentColBaseHingeNum)));
    end

%% yield and capping step of every hinge (for the hinge counters and the key events)
    % A joint node is a real hinge only if it has a capping rotation (99 or 999 means no hinge there).
    % Joint nodes: 1- column below, 2- beam right, 3- column above, 4- beam left, 5- shear panel (not counted).
    hingeTypeLIST = {};          % 'beam', 'column' (above the base) or 'base'
    hingeFloorLIST = [];
    hingeYieldStepLIST = [];
    hingeCapStepLIST = [];
    for currentFloorNum = 2:maxFloorNum
        for currentColLineNum = 1:numColLines
            currentJointNum = buildingInfo{bldgID}.jointNumber(currentFloorNum, currentColLineNum);
            for currentJointNodeNum = 1:4
                rotationCapacity = buildingInfo{bldgID}.plastHingeRotCapAtJoint(currentFloorNum, currentColLineNum).node(currentJointNodeNum);
                if rotationCapacity >= 1, continue; end
                numRows = min(numStepsInAnalysis, size(jointRotationTH{currentJointNum}, 1));
                hingeRotationTH = jointRotationTH{currentJointNum}(1:numRows, currentJointNodeNum);
                hingeMomentTH = jointRotationTH{currentJointNum}(1:numRows, 5 + currentJointNodeNum);
                [yieldStep, capStep] = findHingeYieldAndCapSteps(hingeRotationTH, hingeMomentTH, rotationCapacity, yieldPlasticRotation);
                if any(currentJointNodeNum == [2 4]), hingeTypeLIST{end+1} = 'beam'; else, hingeTypeLIST{end+1} = 'column'; end
                hingeFloorLIST(end+1) = currentFloorNum;
                hingeYieldStepLIST(end+1) = yieldStep;
                hingeCapStepLIST(end+1) = capStep;
            end
        end
    end
    for currentColLineNum = 1:numColLines
        currentColBaseHingeNum = buildingInfo{bldgID}.hingeElementNumAtColBase(currentColLineNum);
        rotationCapacity = buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, currentColLineNum).node(1);
        colBaseForceTH = load(fullfile(runFolder, 'Elements', 'Hinges', sprintf('HingeForceTH_%i.out', currentColBaseHingeNum)));
        numRows = min([numStepsInAnalysis, size(colBaseRotationTH{currentColBaseHingeNum}, 1), size(colBaseForceTH, 1)]);
        [yieldStep, capStep] = findHingeYieldAndCapSteps(colBaseRotationTH{currentColBaseHingeNum}(1:numRows), colBaseForceTH(1:numRows, 3), ...
            rotationCapacity, yieldPlasticRotation);
        hingeTypeLIST{end+1} = 'base';
        hingeFloorLIST(end+1) = 1;
        hingeYieldStepLIST(end+1) = yieldStep;
        hingeCapStepLIST(end+1) = capStep;
    end
    isBeamHinge = strcmp(hingeTypeLIST, 'beam');
    isColumnHinge = strcmp(hingeTypeLIST, 'column');
    isBaseHinge = strcmp(hingeTypeLIST, 'base');

%% key events on the pushover curve (Inf = event did not happen)
    beamFloorLIST = unique(hingeFloorLIST(isBeamHinge));
    firstYieldStepOfEachBeamFloor = arrayfun(@(floorNum) min(hingeYieldStepLIST(isBeamHinge & hingeFloorLIST == floorNum)), beamFloorLIST);
    [maxBaseShear, vMaxStep] = max(baseShearTH);
    postPeak80Step = find(baseShearTH(vMaxStep:end) <= 0.8 * maxBaseShear, 1, 'first') + vMaxStep - 1;
    if isempty(postPeak80Step), postPeak80Step = Inf; end
    eventNameLIST = {'First beam yield', 'All beam floors yielded', 'First column-base yield', 'First upper-column yield', ...
                     'First hinge capping', 'Vmax', '0.8 Vmax (post-peak)'};
    eventStepLIST = [min([hingeYieldStepLIST(isBeamHinge), Inf]), max(firstYieldStepOfEachBeamFloor), ...
                     min([hingeYieldStepLIST(isBaseHinge), Inf]), min([hingeYieldStepLIST(isColumnHinge), Inf]), ...
                     min([hingeCapStepLIST, Inf]), vMaxStep, postPeak80Step];
    eventMarkerLIST = {'v', '^', 's', 'd', 'p', 'o', 'h'};
    eventColorLIST = {[0 0.45 0.74], [0 0.6 0.3], [0.85 0.33 0.1], [0.49 0.18 0.56], [0.8 0 0], [0 0 0], [0.6 0.6 0.6]};
    eventHappened = isfinite(eventStepLIST);
    fprintf('   Key events (roof drift %%):');
    for eventIndex = find(eventHappened)
        fprintf('  %s %.2f;', eventNameLIST{eventIndex}, 100 * roofDriftTH(eventStepLIST(eventIndex)));
    end
    fprintf('\n');

%% pick the analysis steps for the frames (one frame per driftIncrementPerFrame of roof drift, plus every key event)
    driftsForFrames = 0:driftIncrementPerFrame:max(roofDriftTH);
    stepsForFrames = zeros(size(driftsForFrames));
    for frameIndex = 1:length(driftsForFrames)
        stepsForFrames(frameIndex) = find(roofDriftTH >= driftsForFrames(frameIndex), 1, 'first');
    end
    stepsForFrames = unique([stepsForFrames, eventStepLIST(eventHappened), numStepsInAnalysis]);   % always end with the last step

%% set up the movie file
    modelName = strtok(analysisDir, ')'); modelName = modelName(2:end);
    if isempty(movieOutputFolder)
        movieFolderToUse = fullfile(rootFolder, 'Output', analysisDir);
    else
        movieFolderToUse = movieOutputFolder;
    end
    movieFileName = fullfile(movieFolderToUse, sprintf('PushoverMovie_%s.mp4', modelName));
    videoObject = VideoWriter(movieFileName, 'MPEG-4');
    videoObject.FrameRate = framesPerSecond;
    open(videoObject);
    if showWhileRunning, figureVisibility = 'on'; else, figureVisibility = 'off'; end
    figureHandle = figure('Position', [50 50 1300 850], 'Color', 'w', 'Visible', figureVisibility, 'Resize', 'off', ...
        'Name', sprintf('Pushover movie: %s', modelName), 'NumberTitle', 'off');
    

%% loop over the frames
    for stepToPlot = stepsForFrames
        % floor displacements at this step
        floorDispVECTOR = zeros(1, maxFloorNum);
        for currentFloorNum = 2:maxFloorNum
            floorDispVECTOR(currentFloorNum) = displScaleFactor * nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(stepToPlot, lateralDispDOF);
        end

        % hinge demand = largest plastic rotation reached up to this step
        plasticRotationARRAY = {};
        for currentFloorNum = 2:maxFloorNum
            for currentColLineNum = 1:numColLines
                currentJointNum = buildingInfo{bldgID}.jointNumber(currentFloorNum, currentColLineNum);
                rowsToUse = 1:min(stepToPlot, size(jointRotationTH{currentJointNum}, 1));
                for currentJointNodeNum = 1:5
                    plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{currentJointNodeNum} = ...
                        max(abs(jointRotationTH{currentJointNum}(rowsToUse, currentJointNodeNum)));
                end
            end
        end
        for currentColLineNum = 1:numColLines
            currentColBaseHingeNum = buildingInfo{bldgID}.hingeElementNumAtColBase(currentColLineNum);
            rowsToUse = 1:min(stepToPlot, size(colBaseRotationTH{currentColBaseHingeNum}, 1));
            plasticRotationARRAY{currentColBaseHingeNum}.columnBasePHRDemand = max(abs(colBaseRotationTH{currentColBaseHingeNum}(rowsToUse)));
        end

        clf(figureHandle);
        % left: deformed frame with hinges
        subplot(1, 2, 1);
        cd(visualProcessorsFolder);
        psb_DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisDir, 9991, 0, isHingesHighlighted, ...
            hingeHighlighted_1, hingeHighlighted_2, highlightedHingeColor_1, highlightedHingeColor_2, titleOption, ...
            maxOnDemandCapacityRatioToPlot, saDefType, periodUsedForScalingGroundMotionsFromMatlab);
        title(sprintf('%s,  roof drift = %.2f%%', modelName, 100 * roofDriftTH(stepToPlot)), 'Interpreter', 'none', 'FontName', 'times');

        % right: pushover curve with a marker at this step
        subplot(1, 2, 2);
        plot(roofDriftTH, baseShearTH, 'k-', 'LineWidth', 1.5); hold on
        plot(roofDriftTH(1:stepToPlot), baseShearTH(1:stepToPlot), 'b-', 'LineWidth', 2.5);
        % key events: hollow marker until reached, filled once passed
        eventLegendHandles = gobjects(0); eventLegendText = {};
        for eventIndex = find(eventHappened)
            eventStep = eventStepLIST(eventIndex);
            if eventStep <= stepToPlot, faceColor = eventColorLIST{eventIndex}; else, faceColor = 'w'; end
            eventLegendHandles(end+1) = plot(roofDriftTH(eventStep), baseShearTH(eventStep), eventMarkerLIST{eventIndex}, ...
                'MarkerSize', 10, 'MarkerEdgeColor', eventColorLIST{eventIndex}, 'MarkerFaceColor', faceColor, 'LineWidth', 1.5);
            eventLegendText{end+1} = sprintf('%s (%.2f%%)', eventNameLIST{eventIndex}, 100 * roofDriftTH(eventStep));
        end
        plot(roofDriftTH(stepToPlot), baseShearTH(stepToPlot), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
        hold off; grid on; box on
        xlim([0, max(roofDriftTH) * 1.02]); ylim([0, max(baseShearTH) * 1.1]);
        xlabel('Roof Drift Ratio'); ylabel('Base Shear (kN)');
        title(sprintf('V = %.0f kN  (V/Vmax = %.2f)', baseShearTH(stepToPlot), baseShearTH(stepToPlot) / max(baseShearTH)));
        legend(eventLegendHandles, eventLegendText, 'Location', 'south', 'FontSize', 10);
        set(gca, 'FontName', 'times', 'FontSize', 12);

        % hinge counters (and the event name when this frame is a key event)
        hingeCounterText = sprintf('Beam hinges yielded: %i/%i    Column hinges yielded: %i/%i (base %i/%i)    Hinges past capping: %i', ...
            sum(hingeYieldStepLIST(isBeamHinge) <= stepToPlot), sum(isBeamHinge), ...
            sum(hingeYieldStepLIST(isColumnHinge | isBaseHinge) <= stepToPlot), sum(isColumnHinge | isBaseHinge), ...
            sum(hingeYieldStepLIST(isBaseHinge) <= stepToPlot), sum(isBaseHinge), sum(hingeCapStepLIST <= stepToPlot));
        eventsAtThisStep = eventNameLIST(eventStepLIST == stepToPlot);
        if isempty(eventsAtThisStep)
            sgtitle(hingeCounterText, 'FontName', 'times', 'FontSize', 13);
        else
            sgtitle({hingeCounterText, ['EVENT: ', strjoin(eventsAtThisStep, ' + ')]}, 'FontName', 'times', 'FontSize', 13, 'Color', [0.8 0 0]);
        end

        drawnow;
        currentFrame = getframe(figureHandle);
        writeVideo(videoObject, currentFrame);
        if ~isempty(eventsAtThisStep)   % hold the movie on a key event
            for repeatIndex = 1:round(pauseSecondsAtEvent * framesPerSecond)
                writeVideo(videoObject, currentFrame);
            end
        end
    end

    close(videoObject);
    if ~showWhileRunning
        close(figureHandle);   % when shown, leave the last frame on screen
    end
    fprintf('Saved %s (%i frames)\n', movieFileName, length(stepsForFrames));
end
cd(baseFolder);
end

%% local function
function [yieldStep, capStep] = findHingeYieldAndCapSteps(hingeRotationTH, hingeMomentTH, rotationCapacity, yieldPlasticRotation)
% Plastic rotation = change in hinge rotation minus its elastic part. The elastic stiffness
% is taken from the step where the moment change first reaches 20% of its largest value
% (still elastic). Changes are measured from the first step, so the gravity moment is removed.
% yieldStep- first step where plastic rotation >= yieldPlasticRotation
% capStep- first step where |rotation| >= capping rotation (same rule as the red colour in psb_DrawDistortedFrame)
    rotationChange = hingeRotationTH - hingeRotationTH(1);
    momentChange = hingeMomentTH - hingeMomentTH(1);
    yieldStep = Inf;
    elasticIndex = find(abs(momentChange) >= 0.2 * max(abs(momentChange)), 1, 'first');
    if ~isempty(elasticIndex) && rotationChange(elasticIndex) ~= 0
        elasticStiffness = momentChange(elasticIndex) / rotationChange(elasticIndex);
        plasticRotationTH = abs(rotationChange - momentChange / elasticStiffness);
        firstYieldIndex = find(plasticRotationTH >= yieldPlasticRotation, 1, 'first');
        if ~isempty(firstYieldIndex), yieldStep = firstYieldIndex; end
    end
    capStep = find(abs(hingeRotationTH) >= rotationCapacity, 1, 'first');
    if isempty(capStep), capStep = Inf; end
end
