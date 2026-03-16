%
% Procedure: PlotHingeMomentRotTH.m
% -------------------
% This procedure plots the hysteretic responce of a hinge, when using the elastic elements with hysteretic hinges.
% 
% Assumptions and Notices: 
%           - 
%
% Author: Curt Haselton 
% Date Written: 5-31-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - 
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = PlotHingeMomentRotTH(hingeNum, analysisType, saTOneForRun, eqNumber, maxNumPoints, markerType)

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

% Do plot
    hingeRot = elementArray{hingeNum}.rotTH;
    hingeMoment = elementArray{hingeNum}.momentTH;
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(hingeRot);
    length2 = length(hingeMoment);
    minLength = min(length1, length2);
  
    if(minLength < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = minLength;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
    plot(hingeRot(1:numDataPointsUsed), hingeMoment(1:numDataPointsUsed), markerType);
    
    hold on
    legendName = sprintf('Hysteretic Responce of Hinge %d', hingeNum);
    legend(legendName);
    grid on
    titleText = sprintf('Hysteretic Responce of Hinge %d at Sa of %.2f for EQ Number %.0f for Analysis %s', hingeNum, saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Hinge Moment (units)');
    ylabel(yLabel);
    xlabel('Hinge Rotation (radians)');
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
