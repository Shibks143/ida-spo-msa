%
% Procedure: PlotNodeAccelTH.m
% -------------------
% Just like the displacement plot file, but for accelerations.
% 
% Assumptions and Notices: 
%           - dofNum can be either 1 or 2 (only 2D)
%
% Author: Curt Haselton 
% Date Written: 2-26-04
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
% function[void] = PlotNodeAccelTH(nodeNum, dofNum, analysisType, saTOneForRun, eqNumber, maxNumPoints, markerType)

if dofNum == 1
    % Keep going - ok    
else
    disp('ERROR: You can only use dof 1')
    return;
end

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

% load('DATA_allDataForThisSingleRun.mat');
load('DATA_reducedSensDataForThisSingleRun.mat');


% Do plot
    nodeAccelArray = nodeArray{nodeNum}.accelTH(:, dofNum);
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(nodeAccelArray);
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
    plot(psuedoTimeVector(1:numDataPointsUsed), nodeAccelArray(1:numDataPointsUsed), markerType);
    
    hold on
    legendName = sprintf('Acceleration of Node %d', nodeNum);
    legend(legendName);
    grid on
    titleText = sprintf('Acceleration of Node %d, DOF %d, at Sa of %.2f for EQ Number %.0f for Analysis %s', nodeNum, dofNum, saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Acceleration of Node %d (units)', nodeNum);
    ylabel(yLabel);
    xlabel('PseudoTime (seconds)');
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
