%
% Procedure: PlotLocalEleForceTH.m
% -------------------
% This procedure plots the local element force for an earthquake.
% 
% Assumptions and Notices: 
%           - 
%
% Author: Curt Haselton 
% Date Written: 3-12-04
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
%function[void] = PlotLocalEleForceTH(eleNum, eleDofNum, analysisType, saTOneForRun, eqNumber, maxNumPoints, markerType)

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);

% Create Sa and EQ folder names for later use
saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%d', eqNumber);

% Open the .mat file that holds all of the data that we need, go into folder to get it
cd(eqFolder);
cd(saFolder);
load('DATA_allDataForThisSingleRun.mat');

% Do plot
    eleForceArray = elementArray{eleNum}.localForceTH(:, eleDofNum);
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(eleForceArray);
    length2 = length(psuedoTimeVector);
    minLength = min(length1, length2);
  
    if(minLength < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = minLength;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
    plot(psuedoTimeVector(1:numDataPointsUsed), eleForceArray(1:numDataPointsUsed), markerType);
    
    hold on
    legendName = sprintf('Local Force in Element %d', eleNum);
    legend(legendName);
    grid on
    titleText = sprintf('Local Force in Element %d for DOF %d at Sa of %.2f for EQ %d for Analysis %s', eleNum, eleDofNum, saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Local Force in Element %d (units)', eleNum);
    ylabel(yLabel);
    xlabel('PseudoTime (seconds)');
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
