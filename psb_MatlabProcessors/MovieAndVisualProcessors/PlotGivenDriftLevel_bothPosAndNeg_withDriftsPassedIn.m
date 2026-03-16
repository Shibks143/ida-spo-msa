%
% Procedure: PlotGivenDriftLevel_bothPosAndNeg_withDriftsPassedIn.m
% -------------------
%
% This is the same as PlotMaxDriftLevel_bothPosAndNeg_withDriftsPassedIn.m,
% except that it is not for the amximum drift level.  Instead it plots the
% drift level that is sent into the function (it can be the current drift
% level or the currentMax from an EQ that is only partially over; useful
% for making the movies).
%
% This procedure plots the moment-rotation TH for a joint node for a given
% analysis run.  This file is the same as
% PlotMaxDriftLevel_bothPosAndNeg, except for this procedure accepts the
% story drifts and numStories as parameters instead of opening the .mat file (to reduce
% processing time).
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
%           - storyDriftRatio_Pos and storyDriftRatio_Neg are in units of
%           ratio and the first entry is for story one
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = PlotGivenDriftLevel_bothPosAndNeg_withDriftsPassedIn(storyDriftRatio_Neg, storyDriftRatio_Pos, numStories, analysisType, saTOneForRun, eqNumber, markerType, maxXOnAxis)

% Define line width to use
    lineWidth = 4;

% Do plot
    hold on
    absMaxStoryDrift = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot the positive maximum drifts
    for storyNum = 1:numStories
       currentStoryDrift = storyDriftRatio_Pos(storyNum) * 100;
       absMaxStoryDrift = max(abs(absMaxStoryDrift), abs(currentStoryDrift));
       driftVector = [currentStoryDrift, currentStoryDrift];
       storyVector = [storyNum - 1, storyNum];
       plot(driftVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    
    % Plot horizontal lines
    for storyNum = 1:numStories - 1
       currentStoryDrift = storyDriftRatio_Pos(storyNum) * 100;
       nextStoryDrift = storyDriftRatio_Pos(storyNum + 1) * 100;
       driftVector = [currentStoryDrift, nextStoryDrift];
       storyVector = [storyNum, storyNum];
       plot(driftVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot the negative maximum drifts
    for storyNum = 1:numStories
       currentStoryDrift = storyDriftRatio_Neg(storyNum) * 100;
       absMaxStoryDrift = max(abs(absMaxStoryDrift), abs(currentStoryDrift));
       driftVector = [currentStoryDrift, currentStoryDrift];
       storyVector = [storyNum - 1, storyNum];
       plot(driftVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    
    % Plot horizontal lines
    for storyNum = 1:numStories - 1
       currentStoryDrift = storyDriftRatio_Neg(storyNum) * 100;
       nextStoryDrift = storyDriftRatio_Neg(storyNum + 1) * 100;
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
    titleText = sprintf('');
    title(titleText);
    yLabel = sprintf('Floor Number');
    hy = ylabel(yLabel);
    hx = xlabel('Interstory Drift Ratios');
    box on
    FigureFormatScript_Movies
    hold off

    disp('done');

