%
% Procedure: PlotMPlaRotTH.m
% -------------------
% This procedure plots the hysteretic responce of a "plastic hinge" for either element.
% 
% Assumptions and Notices: 
%           - endNum = 1 is end i, 2 if end j (these are only values that can be used!)
%
% Author: Curt Haselton 
% Date Written: 5-31-04
% Updated: 12-10-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - endNum = 1 is end i, 2 if end j (these are only values that can be used!)
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function[void] = PlotMPlaRotTH(eleNum, analysisType, saTOneForRun, eqNumber, endNum, maxNumPoints, markerType)

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
    rotIndex = endNum + 1;
    plasticRot = elementArray{eleNum}.PHRTH(:, rotIndex);
    dofIndex = endNum * 3;
    hingeMoment = elementArray{eleNum}.localForceTH(:, dofIndex);
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(plasticRot);
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
    plot(plasticRot(1:numDataPointsUsed), hingeMoment(1:numDataPointsUsed), markerType);
    
    hold on
%     legendName = sprintf('Moment-Plastic Rotation Responce of Element %d, end %d', eleNum, endNum);
%     legend(legendName);
    grid on
    titleText = sprintf('Moment-Plastic Rotation Responce of Element %d, end %d; Sa: %.2f; EQ: %.0f; Analysis: %s', eleNum, endNum, saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('End Moment (k-inch)');
    ylabel(yLabel);
    xlabel('Plastic Rotation (radians)');
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
