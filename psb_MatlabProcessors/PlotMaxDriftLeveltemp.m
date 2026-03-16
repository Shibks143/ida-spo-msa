%
% Procedure: PlotMaxDriftLevel.m
% -------------------
% This procedure plots the displacement TH for a node for a given analysis run.  It opens the file that has already been processed.  If the .mat
%   file has not been made yet (using the ProcessSinglRum.m function), this function returns an error.
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
%function[void] = PlotMaxDriftLevel(analysisType, saTOneForRun, eqNumber, markerType)

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
    %storyDriftRatio{storyNum}.AbsMax;
    
    numStories = 4; %Take this out later and make ProcessSingleRun save it!
    
    hold on
    maxStoryDrift = 0;
    for storyNum = 1:numStories
       currentStoryDrift = storyDriftRatio{storyNum}.AbsMax * 100;
       maxStoryDrift = max(maxStoryDrift, currentStoryDrift);
       driftVector = [currentStoryDrift, currentStoryDrift];
       storyVector = [storyNum - 1, storyNum];
       plot(driftVector, storyVector, markerType);
    end
    
    % Plot horizontal lines
    for storyNum = 1:numStories - 1
       currentStoryDrift = storyDriftRatio{storyNum}.AbsMax * 100;
       nextStoryDrift = storyDriftRatio{storyNum + 1}.AbsMax * 100;
       driftVector = [currentStoryDrift, nextStoryDrift];
       storyVector = [storyNum, storyNum];
       plot(driftVector, storyVector, markerType);
    end
    

    % Find what maximum drift to use for the x-axis scale (just rounding)
    maxX = maxStoryDrift + 0.05;
    remainder = mod(maxX, 0.05);
    maxX = maxX - remainder;
    
    hold on
    grid on
    axis([0 maxX 0 numStories])
    titleText = sprintf('Drift Ratio Over Building Height at Sa of %.2f for EQ Number %.0f for Analysis %s', saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Floor Number');
    ylabel(yLabel);
    xlabel('Drift Ratio (% drift)');
    box on
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
