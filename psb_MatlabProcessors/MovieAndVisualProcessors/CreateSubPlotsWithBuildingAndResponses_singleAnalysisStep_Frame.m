%
% Procedure: CreateSubPlotsWithBuildingAndResponses_singleAnalysisStep_Frame.m
% -------------------
% This procedure creates a subplot for a single analysis step.  This plot shows the distorted building at the current analysis step, the max drift
%   levels up to this point in the EQ, and responses of two hinges showing
%   a dot for the current response point.
%
% Variable definitions:
%           - Many variable definitions are defined in the
%           functions/procedures that this procedure calls.
%           - jointResponseToPlot_1 and _2 need to be vectors of the
%           [floorNum, colLineNum, jointNodeNum] for the joint response
%           plots that are to be used. 
%       saDefType - type of SA definition we want to put on the titles
%               =1 for Sa,comp
%               =2 for Sa,geoMean
%               =3 for Sa,codeDef
%
%
% Assumptions and Notices: 
%       - NOTICE: This will NOT plot the response of the column base hinge
%       (b/c) I am using the joint data and I just haven't added the
%       feature yet to plot the column base hinge.
%
% Author: Curt Haselton 
% Date Written: 12-04-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = CreateSubPlotsWithBuildingAndResponses_singleAnalysisStep_Frame(buildingInfo, bldgID, analysisType, eqNum, saLevel, floorDispVECTOR, plasticRotationARRAY, elementArray, storyDriftRatio_Neg, storyDriftRatio_Pos, currentAnalysisStepNum, jointResponseToPlot_1, jointResponseToPlot_2%       saDefType - type of SA definition we want to put on the titles
%               =1 for Sa,comp
%               =2 for Sa,geoMean
%               =3 for Sa,codeDef)

% Set some plot options
    maxXOnAxis = 15;    % 15% drift is the x-limit on the drift plot
    markerTypeForDriftPlot = 'b-';
    markerTypeForJointResponse = 'b-';
    isHingesHighlighted = 1;    % Yes - highlight the hinges
    highlightedHingeColor_1 = 'g';
    highlightedHingeColor_2 = 'c';

% Do some simple calcs.
    numStories = buildingInfo{bldgID}.numStories;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the deformed building
    subplot(2,2,1)
    DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisType, eqNum, saLevel, isHingesHighlighted, jointResponseToPlot_1, jointResponseToPlot_2, highlightedHingeColor_1, highlightedHingeColor_2%       saDefType - type of SA definition we want to put on the titles
%               =1 for Sa,comp
%               =2 for Sa,geoMean
%               =3 for Sa,codeDef);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the drift level
    subplot(2,2,2)
    PlotGivenDriftLevel_bothPosAndNeg_withDriftsPassedIn(storyDriftRatio_Neg, storyDriftRatio_Pos, numStories, analysisType, saLevel, eqNum, markerTypeForDriftPlot, maxXOnAxis);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the first hinge
    subplot(2,2,3)
    floorNum = jointResponseToPlot_1(1);
    colLineNum = jointResponseToPlot_1(2);
    jointNodeNum = jointResponseToPlot_1(3);
    DrawJointResponseWithDot(buildingInfo, bldgID, analysisType, eqNum, saLevel, colLineNum, floorNum, jointNodeNum, elementArray, currentAnalysisStepNum, markerTypeForJointResponse, highlightedHingeColor_1);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the first hinge
    subplot(2,2,4)
    floorNum = jointResponseToPlot_2(1);
    colLineNum = jointResponseToPlot_2(2);
    jointNodeNum = jointResponseToPlot_2(3);
    DrawJointResponseWithDot(buildingInfo, bldgID, analysisType, eqNum, saLevel, colLineNum, floorNum, jointNodeNum, elementArray, currentAnalysisStepNum, markerTypeForJointResponse, highlightedHingeColor_2);
        











