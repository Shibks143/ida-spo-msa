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
%           - maxXOnAxis - the user can input this to control the axis
%           size.  A value of -1 will make this procedure size the axes
%           automatically (unit is drift ratio in %)
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = PlotMaxDriftLevel_bothPosAndNeg(analysisType, saTOneForRun, eqNumber, markerType, maxXOnAxis)

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);

% Create Sa and EQ folder names for later use
saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Define line width to use
    lineWidth = 4;
    maxXOnAxis = -1; %0.15;

% Open the .mat file that holds all of the data that we need, go into folder to get it
cd(eqFolder);
cd(saFolder);
%load('DATA_allDataForThisSingleRun.mat');
load('DATA_reducedSensDataForThisSingleRun.mat');


% Do plot
    %storyDriftRatio{storyNum}.AbsMax;
    
%     numStories = 4; %Take this out later and make ProcessSingleRun save it!
    
    hold on
    absMaxStoryDrift = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot the positive maximum drifts
    for storyNum = 1:numStories
       currentStoryDrift = storyDriftRatioToSave{storyNum}.Max * 100;
       absMaxStoryDrift = max(abs(absMaxStoryDrift), abs(currentStoryDrift));
       driftVector = [currentStoryDrift, currentStoryDrift];
       storyVector = [storyNum - 1, storyNum];
       plot(driftVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    
    % Plot horizontal lines
    for storyNum = 1:numStories - 1
       currentStoryDrift = storyDriftRatioToSave{storyNum}.Max * 100;
       nextStoryDrift = storyDriftRatioToSave{storyNum + 1}.Max * 100;
       driftVector = [currentStoryDrift, nextStoryDrift];
       storyVector = [storyNum, storyNum];
       plot(driftVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot the negative maximum drifts
    for storyNum = 1:numStories
       currentStoryDrift = storyDriftRatioToSave{storyNum}.Min * 100;
       absMaxStoryDrift = max(abs(absMaxStoryDrift), abs(currentStoryDrift));
       driftVector = [currentStoryDrift, currentStoryDrift];
       storyVector = [storyNum - 1, storyNum];
       plot(driftVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    
    % Plot horizontal lines
    for storyNum = 1:numStories - 1
       currentStoryDrift = storyDriftRatioToSave{storyNum}.Min * 100;
       nextStoryDrift = storyDriftRatioToSave{storyNum + 1}.Min * 100;
       driftVector = [currentStoryDrift, nextStoryDrift];
       storyVector = [storyNum, storyNum];
       plot(driftVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
        
    % Find what maximum drift to use for the x-axis scale (just rounding)
    maxX = absMaxStoryDrift + 1.0;
    remainder = mod(maxX, 1.0);
    maxX = maxX - remainder;
    
    % Plot a solid black line at zero drift so it's easier to see the zero
    % line
       driftVector = [0.0, 0.0];
       storyVector = [0, numStories];
       plot(driftVector, storyVector, 'k', 'LineWidth', lineWidth);    
    
    hold on
    
    % If the use input an axis scale to use, then use it.
    if(maxXOnAxis == -1)
        % User input to automatically size axis, so do it
        axis([-maxX maxX 0 numStories])
    else
        % Size axis from user input
        axis([-maxXOnAxis maxXOnAxis 0 numStories])    
    end
    grid on
    %titleText = sprintf('Drift Ratio: Sa of %.2f, EQ %.0f for %s', saTOneForRun, eqNumber, analysisType);
    %title(titleText);
    yLabel = sprintf('Floor Number');
    hy = ylabel(yLabel);
    hx = xlabel('Interstory Drift Ratio');
    box on
    FigureFormatScript
    
    % Save the plot
        % Save the plot as a .fig file
        %plotName = sprintf('PushoverMaxDriftLevel_Num_%d_%s.fig', eqNumber, analysisType);
        %hgsave(plotName);
        % Export the plot as a .emf file (Matlab book page 455)
        %exportName = sprintf('PushoverMaxDriftLevel_Num_%d_%s.emf', eqNumber, analysisType)
        %print('-dmeta', exportName);
    hold off

    disp('done');
    
% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
