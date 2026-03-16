%
% Procedure: PlotJointNodeMRotTH.m
% -------------------
% This procedure plots the moment-rotation of a node in a joint2D element.
% 
% Assumptions and Notices: 
%           - 
%
% Author: Curt Haselton 
% Date Written: 7-21-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - nodeNum - 1-4 are joint face nodes and node 5 is the node at the center (the shear spring).
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = PlotJointNodeMRotTH(jointNum, analysisType, saTOneForRun, eqNumber, jointNodeNum, maxNumPoints, markerType)

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);

% Create Sa and EQ folder names for later use
saFolder = sprintf('Sa_%.1f', saTOneForRun);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Open the .mat file that holds all of the data that we need, go into folder to get it
cd(eqFolder);
cd(saFolder);

load('DATA_allDataForThisSingleRun.mat');

% Do plot
    momentIndex = jointNodeNum + 5;
    moment = elementArray{jointNum}.JointForceAndDeformation(:, momentIndex);
    rotationIndex = jointNodeNum;
    rotation = elementArray{jointNum}.JointForceAndDeformation(:, rotationIndex);
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(moment);
    length2 = length(rotation);
    minLength = min(length1, length2);
  
    if(minLength < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = minLength;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
    plot(rotation(1:numDataPointsUsed), moment(1:numDataPointsUsed), markerType);
    
    hold on
%     legendName = sprintf('Moment-Plastic Rotation Responce of Element %d, end %d', eleNum, endNum);
%     legend(legendName);
    grid on
    titleText = sprintf('Moment-Rotation of JointNode %d of Joint %d; Sa: %.1f; EQ: %.0f; Analysis: %s', jointNodeNum, jointNum, saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Moment (k-inch)');
    ylabel(yLabel);
    xlabel('Rotation (radians)');
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
