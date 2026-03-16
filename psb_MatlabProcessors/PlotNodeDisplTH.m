%
% Procedure: PlotNodeDisplTH.m
% -------------------
% This procedure plots the displacement TH for a node for a given analysis run.  It opens the file that has already been processed.  If the .mat
%   file has not been made yet (using the ProcessSinglRum.m function), this function returns an error.
% 
% Assumptions and Notices: 
%           - dofNum can be either 1 or 2 (only 2D)
%
% Author: Curt Haselton 
% Date Written: 2-26-04
% Updated: 12-10-04
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
function[void] = PlotNodeDisplTH(nodeNum, dofNum, analysisType, saTOneForRun, eqNumber, maxNumPoints, markerType)

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
    nodeDisplArray = nodeArray{nodeNum}.displTH(:, dofNum);
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(nodeDisplArray);
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
    plot(psuedoTimeVector(1:numDataPointsUsed), nodeDisplArray(1:numDataPointsUsed), markerType);
    
    hold on
    legendName = sprintf('Displacement of Node %d', nodeNum);
    legend(legendName);
    grid on
    titleText = sprintf('Displacement of Node %d at Sa of %.2f for EQ Number %.0f for Analysis %s', nodeNum, saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Displacement of Node %d (units)', nodeNum);
    ylabel(yLabel);
    xlabel('PseudoTime (seconds)');
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
