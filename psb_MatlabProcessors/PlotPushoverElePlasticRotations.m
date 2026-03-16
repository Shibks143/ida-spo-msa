%
% Procedure: PlotPushoverElePlasticRotations.m
% -------------------
% This plots the element plastic rotations during the pushover.
% 
% COMMENT: This should work for you, but I am sorry that it is not clean
%   and commented; I did not have time to clean it up.  If you have any
%   questions, please let me know (Curt Haselton, haselton@stanford.edu)
%
% Assumptions and Notices: 
%           - none
%
% Author: Curt Haselton 
% Updated: 7-8-05
% Date Written: 5-11-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - not completed
%
% Units: Whatever OpenSees is using - kips, inches, and radians
%
% -------------------
function[void] = PlotPushoverElePlasticRotations(analysisType, saTOneForRun, eqNumber, eleNum, eleEndNum, plotRoofDriftRatio, buildingHeight, maxNumPoints, markerType, lineWidth)

% Define both of the following values to be consistent with the pushover
%   naming convention and to open the correct folders.
nodeDofNum = 1; % For PO displacement only - not for element values (just saying that we want lateral DOF for PO displacement)

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
    nodeDisplArray = nodeArray{poControlNodeNum}.displTH(:, nodeDofNum);
    plasticDefArray = elementCombinedPHR{eleNum}.endi.eleTotalTH;
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(nodeDisplArray);
    length2 = length(plasticDefArray);
    minLength = min(length1, length2);
  
    if(minLength < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = minLength;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
    if(plotRoofDriftRatio == 1)
        % Plot vs. roof drift ratio
        roofDriftRatioVector = nodeDisplArray(1:numDataPointsUsed) / buildingHeight;
        plot(roofDriftRatioVector, plasticDefArray(1:numDataPointsUsed), markerType, 'LineWidth', lineWidth);
    else
        % Plot vs. roof (control node) displacement
    plot(nodeDisplArray(1:numDataPointsUsed), plasticDefArray(1:numDataPointsUsed), markerType, 'LineWidth', lineWidth);
    end

    hold on
    grid on
    titleText = sprintf('Plastic Deformations: Element %d, End #%d, Model %s, PushoverID %d', eleNum, eleEndNum, analysisType, eqNumber);
    title(titleText);
    yLabel = sprintf('Element Plastic Deformations (radians)');
    hy = ylabel(yLabel);
    if(plotRoofDriftRatio == 1)
        xLabel = sprintf('Roof Drift Ratio');
    else
        xLabel = sprintf('Control Node Displacement (inches)');
    end
    hx = xlabel(xLabel);
    FigureFormatScript
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
