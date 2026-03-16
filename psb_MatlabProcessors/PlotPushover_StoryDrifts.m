%
% Procedure: PlotPushover_StoryDrifts.m
% -------------------
% This plots the story drifts against the base shear (I should rally change
%   this to story shear, but I did not save than information in the
%   reocrders).
%
% COMMENT: This should work for you, but I am sorry that it is not clean
%   and commented; I did not have time to clean it up.  If you have any
%   questions, please let me know (Curt Haselton, haselton@stanford.edu)
%
% Assumptions and Notices: 
%           - none
%
% Author: Curt Haselton 
% Updated: 8-31-05
% Date Written: 3-9-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - not done
%
% Units: Whatever OpenSees is using - kips, inches, radians
%
% -------------------
% function[void] = PlotPushover_StoryDrifts(storyNum, analysisType, eqNumber, saTOneForRun, plotRoofDriftRatio, buildingHeight, maxNumPoints, markerType, lineWidth)

% Define both of the following values to be consistent with the pushover
%   naming convention and to open the correct folders.
titleFontSize = 12;

% Define node dof as 1 (lateral)
dofNum = 1;

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);

% Create Sa and EQ folder names for later use

saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Open the .mat file that holds all of the data that we need, go into folder to get it
cd(eqFolder);
cd(saFolder);


load('DATA_allDataForThisSingleRun.mat');
% load('DATA_reducedSensDataForThisSingleRun.mat');

% Do plot
    storyDriftArray = storyDriftRatio{storyNum}.TH;
    baseShearArray = -baseShear.TH;
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(storyDriftArray);
    length2 = length(baseShearArray);
    minLength = min(length1, length2);
  
    if(minLength < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = minLength;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end

    %figureh = plot(plotArray(1:numDataPointsUsed), baseShearArray(1:numDataPointsUsed), markerType);
    figureh = plot(storyDriftArray(1:numDataPointsUsed), baseShearArray(1:numDataPointsUsed), markerType, 'LineWidth', lineWidth);

    hold on
    grid on
    %axes(haxes);
    %axes('FontSize', axisNumberFontSize)
    titleText = sprintf('Story Drift Pushover Curve for Analysis Model %s, for PO %d', analysisType, eqNumber);
    title(titleText);
    %set(htitle, 'FontSize', titleFontSize);
    yLabel = sprintf('Base Shear (kips)');
    hy = ylabel(yLabel);
    %set(hy, 'FontSize', axisLabelFontSize);
    xLabel = sprintf('Story Drift for Story %d', storyNum);
    hx = xlabel(xLabel);
    %set(hx, 'FontSize', axisLabelFontSize);
    
    %legh = legend('Hello');
    %set(legh, 'FontSize', legendFontSize);
    FigureFormatScript
    
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
