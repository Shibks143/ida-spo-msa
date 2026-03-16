%
% Procedure: PlotStoryPushover.m
% -------------------
% This plots the story pushover curves - story drift vs. story shear.  The base shear is computed in the "ProcessSingleRun" file and is the sum of the global shears in the
%   columns that are input as base columns in the "SetAnalysisOptions" file. THe node use is the poControlNode defined in the "SetAnalysisOptions" file.
% 
% COMMENT: This should work for you, but I am sorry that it is not clean
%   and commented; I did not have time to clean it up.  If you have any
%   questions, please let me know (Curt Haselton, haselton@stanford.edu)
%
% Assumptions and Notices: 
%           - none
%
% Author: Curt Haselton 
% Updated: 9-26-05
% Date Written: 3-9-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - not done
%
% Units: Whatever OpenSees is using - kips, inches, radians
%
% -------------------
function[void] = PlotStoryPushover_vsBaseShear(storyNum, analysisType, eqNumber, saTOneForRun, plotRoofDriftRatio, maxNumPoints, markerType, lineWidth,SPO_index)

% Define both of the following values to be consistent with the pushover
%   naming convention and to open the correct folders.
titleFontSize = 12;
% disp('Check');

% Define node dof as 1 (lateral)
dofNum = 1;

% First change the directory to get into the correct folder for processing
startFolder = [pwd];
cd ..;
cd Output;
cd(analysisType);

% Create Sa and EQ folder names for later use

saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Open the .mat file that holds all of the data that we need, go into folder to get it
cd(eqFolder);
cd(saFolder);

if SPO_index == -999
    fileName = ['DATA_allDataForThisSingleRun.mat'];
else
    fileName = sprintf('DATA_allDataForThisSingleRun_%i.mat', SPO_index);
end

load(fileName);


% load('DATA_allDataForThisSingleRun.mat', 'storyDriftRatio', 'buildingHeight', 'baseShear');
% load('DATA_reducedSensDataForThisSingleRun.mat');

% Do plot
    baseShearArray = -baseShear.TH;
    storyDriftArray = storyDriftRatio{storyNum}.TH;
    
    % Adjust for there not being the same number of data points in each column and for the numDataPoint inputted possible being higher than the actual number.
    length1 = length(storyDriftArray);
    length2 = length(baseShearArray);
    minLength = min(length1, length2);
  
    if(minLength < maxNumPoints)
        %Just use total number of entries for each data column
        numDataPointsUsed = minLength;
    else
        %Use the maxNumPoints provide by the caller
        numDataPointsUsed = maxNumPoints;
    end
    
%     % OLD - Plot - note that the psuedoTimeVector is from the file that was opened 
%     if(plotRoofDriftRatio == 1)
%         plotArray = nodeDisplArray / buildingHeight;
%     else
%         plotArray = nodeDisplArray;
%     end
% disp('Check1');

    plot(storyDriftArray(1:numDataPointsUsed), baseShearArray(1:numDataPointsUsed), markerType, 'LineWidth', lineWidth);

    hold on
    grid on
    %axes(haxes);
    %axes('FontSize', axisNumberFontSize)
    titleText = sprintf('Story Pushover %s: Story %d', analysisType, storyNum);
    title(titleText);
    %set(htitle, 'FontSize', titleFontSize);
    yLabel = sprintf('Base Shear (kips)');
    hy = ylabel(yLabel);
    %set(hy, 'FontSize', axisLabelFontSize);
    xLabel = sprintf('Story Drift Ratio, Story %d', storyNum);
    hx = xlabel(xLabel);
    %set(hx, 'FontSize', axisLabelFontSize);
    
    %legh = legend('Hello');
    %set(legh, 'FontSize', legendFontSize);
    FigureFormatScript
    
%     disp('Check2');
    
    % Save the plot
        % Go back to the output folder
        cd ..;
        cd ..;
        % Save the plot
        exportName = sprintf('Pushover_%s_Story_%d_baseShear', analysisType, storyNum);
        hgsave(exportName); % .fig file for Matlab
        print('-depsc', exportName); % .eps file for Linux (LaTeX)
        print('-dmeta', exportName); % .emf file for Windows (MSWORD)
%         print('-dpng', exportName); % .png file for small sized files

    hold off

% Get back to the folder where we started
cd(startFolder);
