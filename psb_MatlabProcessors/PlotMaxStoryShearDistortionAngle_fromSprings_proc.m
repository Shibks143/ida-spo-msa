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
function[void] = PlotMaxStoryShearDistortionAngle_fromSprings_proc(analysisType, eqNumber, saTOneForRun, lineWidth, markerType)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Input
%     analysisType = '(DesWA_ATC63_v.19dispEle)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
%     eqNumber = 11011;
%     saTOneForRun = 8.32;
%     lineWidth = 1;
%     markerType = 'b-';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    %storyDriftRatio{storyNum}.AbsMax;
    
%     numStories = 4; %Take this out later and make ProcessSingleRun save it!
    
    hold on
    maxDistortionAngle = 0.0;
    for storyNum = 1:numStories

        % Find the shear spring number for this story
        currentShearSpringEleNum = hingeElementsToRecordLIST(storyNum); % I ASSUME that the spring numbers are in this list in order from bototm of wall to top.
        
        % Find story height
        currentStoryHeight = floorHeightsLIST(storyNum + 1) - floorHeightsLIST(storyNum);
        
        % Find the maximum shear deformation for this story
        currentMaxShearDispAtStory = elementArray{currentShearSpringEleNum}.rotAbsMax;  % Even though it is called "rot", it is "disp" in inches
        
        % Compute he maximum shear drift angle
        currentMaxShearDistortionAngle = currentMaxShearDispAtStory / currentStoryHeight;
       
       % Save for this story
       currentMaxShearDistortionAngle_allStories(storyNum) = currentMaxShearDistortionAngle;
       % Save the distrotion angle of all stories
       maxDistortionAngle = max(abs(maxDistortionAngle), abs(currentMaxShearDistortionAngle));
       
       % Do plot stuff
       shearDistortionVector = [currentMaxShearDistortionAngle, currentMaxShearDistortionAngle];
       storyVector = [storyNum - 1, storyNum];
       plot(shearDistortionVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    
    % Plot horizontal lines
    for storyNum = 1:numStories - 1
        currentMaxShearDistortionAngle = currentMaxShearDistortionAngle_allStories(storyNum);
        nextMaxShearDistortionAngle = currentMaxShearDistortionAngle_allStories(storyNum+1);
        shearDistortionVector = [currentMaxShearDistortionAngle, nextMaxShearDistortionAngle];
        storyVector = [storyNum, storyNum];
        plot(shearDistortionVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    

    % Find what maximum drift to use for the x-axis scale (just rounding)
    %maxX = maxDistortionAngle * 1.1;
    %remainder = mod(maxX, 0.01);
    %maxX = maxX - remainder;
    
    grid on
    %axis([0 maxX 0 numStories])
%     titleText = sprintf('Story Shears: Sa of %.2f, EQ %.0f for %s', saTOneForRun, eqNumber, analysisType);
%     title(titleText);
    yLabel = sprintf('Floor Number');
    hy = ylabel(yLabel);
    hx = xlabel('Maximum Shear Distrotion Angle (radians)');
    box on
    FigureFormatScript

    disp('done');
    
% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
