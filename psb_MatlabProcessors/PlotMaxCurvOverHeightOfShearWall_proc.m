%
% Procedure: ProcSingleRunNlBmColFullPO_newGeneral.m
% -------------------
%
%   Made for DesWA_ATC63_v.13dispEle...
%
%
%
%
%   This plots the abs(max(curvature)) for every section of every element
%   over the height of the shear wall (made for DesWA_v.12).  This uses the
%   floorHeightsLIST and columnNumbersAtBaseLIST to know the elements and
%   locations.  It then uses the
%   elementArray{eleNum}.forceAndDeformation.intPoint{intPtNum}.flexCurvAbsMax
%   to get the absMax curvature for each integration point.  It then plots this 
%   over the height of the building. 
%
%
% Assumptions and Notices: 
%       - NOTICE - must be using 5 intPts per element
%
% Author: Curt Haselton 
% Date Written: 11-03-05
%
% Sources of Code: Some information was taken from Paul Cordovas processing file called "ProcessData.m".
%
% Functions and Procedures called: none
%
% Variable definitions: 
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = PlotMaxCurvOverHeightOfShearWall_proc(analysisType, eqNumber, saTOneForRun, lineWidth, markerType)

disp('In curvature plotting proc...');
eqNumber
saTOneForRun



% disp('****NOTICE: If I used sections shear aggregated, I may need to change this!');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the information about the model and analysis run so we know what
% to plot
    %analysisType = '(DesWA_ATC63_v.12)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
    %analysisType = '(DesWA_ATC63_v.12)_(rebarModelToUse)_(1.00)_(nonlinearBeamColumn)';
    %analysisType = '(DesWA_ATC63_v.12)_(rebarModelToUse)_(2.00)_(nonlinearBeamColumn)';
    %analysisType = '(DesWA_ATC63_v.20dispEle)_(AllVar)_(Mean)_(nonlinearBeamColumn)';

    %eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052];  % 
    %eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032];  % 
    %eqNumberLIST = [11031];  % 
    %eqNumberLIST = [9991];

    %saTOneForRunLIST = [2.00];
    %saTOneForRunLIST = [0.00];

% Define the plot options
    %lineWidth = 2;
    %markerType = 'bo-'; %'b-';
    
% Input locations of integration points (this assumes five integration
% points and assumes that end i is the lower end of each element) - error
% check later to be sure 5 intPts are used
% NOTICE - must be using 5 intPts
    intPointLocations = [0.0, 0.382, 0.50, 0.673, 1.0];
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop and plot for all EQs and Sa levels
% for eqIndex = 1:length(eqNumberLIST)
%     eqNumber = eqNumberLIST(eqIndex);
%     
%     for saIndex = 1:length(saTOneForRunLIST)
%         saTOneForRun = saTOneForRunLIST(saIndex);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Open the file with analysis results

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

            % Load the file
            clear 'elementArray', 'columnNumsAtEachStoryLIST', 'floorHeightsLIST', 'numIntPointsForceEle'
            load('DATA_allDataForThisSingleRun.mat', 'elementArray', 'columnNumsAtEachStoryLIST', 'floorHeightsLIST', 'numIntPointsForceEle', 'dispElePerStory');
            % load('DATA_reducedSensDataForThisSingleRun.mat');
    
            % Do error check to be sure we are using 5 intPts
            if(numIntPointsForceEle == 5)
                % okay
            else
            error('ERROR: This is set up only for five integration points per element!') 
            end
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Loop over all elements over the building height and save the curvature at
        % each height level....
            numStories = length(floorHeightsLIST) - 1;
            counter = 1;
    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Do for correct number of element per story
            if(dispElePerStory == 1)
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for currentStoryNum = 1:numStories
                currentElevOfBottomOfStory = floorHeightsLIST(currentStoryNum);
                currentStoryHeight = floorHeightsLIST(currentStoryNum + 1) - floorHeightsLIST(currentStoryNum);
                currentEleNumAtStory = columnNumsAtEachStoryLIST(currentStoryNum, 1);    % Take number of wall element; not leaning column element
        
                    % Loop for all intergration points and save height and curvature...
                    for currentIntPtNum = 1:numIntPointsForceEle
                        % Compute
                        currentIntPtElevation = currentElevOfBottomOfStory + (currentStoryHeight * intPointLocations(currentIntPtNum));
                        currentAbsMaxCurvAtIntPt = elementArray{currentEleNumAtStory}.forceAndDeformation.intPoint{currentIntPtNum}.flexCurvAbsMax;
           
                        % Save in vector
                        intPtElevationVECTOR(counter) = currentIntPtElevation;
                        absMaxCurvAtIntPtVECTOR(counter) = currentAbsMaxCurvAtIntPt;
           
                        counter = counter + 1;
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               
            elseif(dispElePerStory == 2)
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for currentStoryNum = 1:numStories
                currentElevOfBottomOfStory = floorHeightsLIST(currentStoryNum);
                currentStoryHeight = floorHeightsLIST(currentStoryNum + 1) - floorHeightsLIST(currentStoryNum);
                currentEleNumAtStory = columnNumsAtEachStoryLIST(currentStoryNum, 1);    % Take number of wall element; not leaning column element
        
                    % Loop for all elements in the story.  Note that the
                    % bottom element in the story is always the
                    % "currentEleNumAtStory" and the next is
                    % "currentEleNumAtStory + 1" , etc. (e.g. at one story
                    % the bottom element is 10, then the next is 11 for two
                    % elements per story).
                    for currentEleIndex = 1:dispElePerStory
                        currentEleNum = currentEleNumAtStory + (currentEleIndex - 1);
                        currentElevOfBottomOfElement = currentElevOfBottomOfStory + (currentEleIndex - 1.0) * (currentStoryHeight / dispElePerStory);
                        currentElementLength = currentStoryHeight / dispElePerStory;
                
                
                        % Loop for all intergration points and save height and curvature...
                        for currentIntPtNum = 1:numIntPointsForceEle
                            % Compute
                            currentIntPtElevation = currentElevOfBottomOfElement + (currentElementLength * intPointLocations(currentIntPtNum));
                            currentAbsMaxCurvAtIntPt = elementArray{currentEleNum}.forceAndDeformation.intPoint{currentIntPtNum}.flexCurvAbsMax;
           
                            % Save in vector
                            intPtElevationVECTOR(counter) = currentIntPtElevation;
                            absMaxCurvAtIntPtVECTOR(counter) = currentAbsMaxCurvAtIntPt;
           
                            counter = counter + 1;
                            end
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
            else
                error('ERROR - Invalid number of elements per story');
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot the curvature over the building height
            plot(absMaxCurvAtIntPtVECTOR, intPtElevationVECTOR, markerType, 'LineWidth', lineWidth);
            hold on
            grid on
            hx = xlabel('Curvature (rad/inch)');
            hy = ylabel('Height (inches)');
            titleText = sprintf('%s-EQ-%d-Sa-%.2f', analysisType, eqNumber, saTOneForRun);
            title(titleText);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Go back to the original folder
            cd(startFolder);
            FigureFormatScript
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     end
% end







