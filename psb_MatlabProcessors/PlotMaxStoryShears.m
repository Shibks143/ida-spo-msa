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
% function[void] = PlotMaxStoryShears_proc(analysisType, eqNumber, saTOneForRun, lineWidth, markerType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
    analysisType = '(DesWA_ATC63_v.19dispEle)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
    eqNumber = 11102; %11011;
    saTOneForRun = 1.52; %1.12; %8.32;
    lineWidth = 1;
    markerType = 'b-';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('ERROR');
disp('ERROR: This is plotting LOCAL element shear right now; change processor to save GLOBAL element shear for all columns at each story and then adjust this processor to use GLOBAL shear!!!');
disp('This is actually using LOCAL for the wall and DOES NOT INLUDE the leaning column; simply due to how the output was!')
disp('ERROR');




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
    maxStoryShear = 0;
    for storyNum = 1:numStories
        
       % Loop to compute max story shear for this story
       for colIndex = 1:length(columnNumsAtEachStoryLIST(storyNum,:))
           colNum = columnNumsAtEachStoryLIST(storyNum, colIndex);
            % Compute TH of story shear
            if(colIndex == 1)
                % Set story shear to be shear in first column
                currentStoryShearTH = elementArray{colNum}.localForceTH(:,1);  % Frist column is the shear
                % USE GLOBAL - currentStoryShearTH = elementArray{colNum}.globalForceTH(:,1);  % Frist column is the shear

            else
                % Add story shear to previously computed shear
                
                % FIX THIS LATER
                % Don't add this right now, just use wall shear
                %currentStoryShearTH = currentStoryShearTH + elementArray{colNum}.localForceTH(:,1);  % Frist column is the shear
                
                
                % USE GLOBAL - currentStoryShearTH = currentStoryShearTH + elementArray{colNum}.globalForceTH(:,1);  % Frist column is the shear
            end
       end
            
        % Compute abs. max story shear
       currentMaxStoryShear= max(abs(currentStoryShearTH));;
       % Save for this story
       currentMaxStoryShear_allStories(storyNum) = currentMaxStoryShear;
       % Save the max of all stories
       maxStoryShear = max(abs(currentMaxStoryShear), abs(maxStoryShear));
       
       % Do plot stuff
       shearVector = [currentMaxStoryShear, currentMaxStoryShear];
       storyVector = [storyNum - 1, storyNum];
       plot(shearVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    
    % Plot horizontal lines
    for storyNum = 1:numStories - 1
        currentMaxStoryShear = currentMaxStoryShear_allStories(storyNum);
        nextMaxStoryShear = currentMaxStoryShear_allStories(storyNum+1);
        shearVector = [currentMaxStoryShear, nextMaxStoryShear];
        storyVector = [storyNum, storyNum];
        plot(shearVector, storyVector, markerType, 'LineWidth', lineWidth);
    end
    

    % Find what maximum drift to use for the x-axis scale (just rounding)
    maxX = maxStoryShear * 1.1;
    remainder = mod(maxX, 500.0);
    maxX = maxX - remainder;
    
    hold on
    grid on
    axis([0 maxX 0 numStories])
    titleText = sprintf('Story Shears: Sa of %.2f, EQ %.0f for %s', saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Floor Number');
    hy = ylabel(yLabel);
    hx = xlabel('Max. Wall Shear During Earthquake (kips) (local wall ele. coord., no leaning col. shear added)');
    box on
    FigureFormatScript
    hold off

    disp('done');
    
% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
