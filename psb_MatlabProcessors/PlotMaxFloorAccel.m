%
% Procedure: PlotMaxFloorAccel.m
% -------------------
% This procedure plots the maximum (peak) floor acceleration for all floors.
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
%function[void] = PlotMaxFloorAccel(analysisType, saTOneForRun, eqNumber, markerType)

g = 386.4; % in/s^2

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
    %storyDriftRatio{storyNum}.AbsMax;
    
    numFloors = 5; % Includes the ground floor as floor one - Take this out later and make ProcessSingleRun save it!
    
    floorNumberVector = zeros(1,numFloors-1);
%     floorNumberVector(1, 1) = 1;
    
    maxFloorAccelVector = zeros(1,numFloors-1);

    
    hold on
    for floorNum = 2:numFloors
       floorNumberVector(1, floorNum-1) = floorNum;
       maxFloorAccelVector(1, floorNum-1) = floorAccel{floorNum}.AbsMax / g;  % Convert to g units
       
        
        

    end
    
           plot(maxFloorAccelVector, floorNumberVector, markerType);
    
    
    hold on
    grid on
    titleText = sprintf('Peak Floor Accelerations Over Building Height at Sa of %.2f for EQ Number %.0f for Analysis %s', saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Floor Number');
    ylabel(yLabel);
    xlabel('Peak Floor Acceleration (g)');
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
