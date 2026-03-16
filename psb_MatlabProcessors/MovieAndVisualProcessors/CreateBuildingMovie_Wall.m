%
% Procedure: CreateBuildingMovie_Wall.m
% -------------------
% This procedure creates a movie of the WALL building shaking (or during a PO).
% 
%
% Variable definitions:
%       bldgID - ID to determine which building to plot (as defined in
%               DefineInfoForBuildings.m)
%       movieID - just an ID that I add to the filename so we can make
%       mutiple movies (for testing)
%
%
% Assumptions and Notices: 
%       - The building information for the desired bldgID must be defined
%           in DefineInfoForBuildings.m.
%
%
% Author: Curt Haselton 
% Date Written: 12-04-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = CreateBuildingMovie_Wall(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieID, saDefType)

% Set options
    % Define the DOF # that corresponds to the lateral displacement of the
    % floors
    lateralDispDOF = 1;
    numFramesPerSecond = 50; %25; %50;   % The EQ analysis time step is 0.02, so 25 frames/second  makes the video TWICE as long as the EQ (for PO, I may need to revisit this number!)
    scaleFactorOnDisp = 6.0;        % Scales up the displacements
    numAnalysisStepsPerSample = 1; %5  % (NOTICE: Be sure this makes an even number for frames per second.)  This is how many analysis steps are needed in order to take one frame shot of the model (just to reduce frames to reduce processing time)  
    titleOption = 1; % Use the full title
    maxOnDemandCapacityRatioToPlot = 10000000.0;    % Just make this huge so we do not limit the demand/capacity ratio that can be plotted in the movie

    % Set some dummy variables to say that we do not want to highlight any
    % hinges differently (this highlighting is used when we make movies of
    % the building wiggling and other responses at the same time)
    %isHingesHighlighted = 0;        % No highlighting
    %hingeHighlighted_1 = [0,0,0];   % Dummy variable
    %hingeHighlighted_2 = [0,0,0];   % Dummy variable
    %highlightedHingeColor_1 = 'k';  % Dummy variable
    %highlightedHingeColor_2 = 'k';  % Dummy variable
    
% Set a flag to say that we have not been into the bottom loop yet (b/c the first time into the loop initializes the PHR variables)
    firstTimeIntoAnalysisLoop = 1;
    
% Set up the movie file
    movieName = sprintf('Movie_%s_EQ_%d_Sa_%.2f_%d.avi', analysisType, eqNum, saLevel, movieID);
        % Delete any old file that may use this name
        delete(movieName);
    numFramesPerSecond_Scaled = numFramesPerSecond / numAnalysisStepsPerSample;
    aviobj=avifile(movieName,'fps',numFramesPerSecond_Scaled);

% Open the file and load the information that we need to create the movie
    startingPath = [pwd];
    cd ..;
    cd ..;
    cd Output;
    cd(analysisType);
    eqFolder = sprintf('EQ_%d', eqNum);
    saFolder = sprintf('Sa_%.2f', saLevel);
    cd(eqFolder);
    cd(saFolder);
    load('DATA_allDataForThisSingleRun.mat', 'elementArray', 'nodeArray', 'nodeNumsAtEachFloorLIST', 'storyDriftRatio');
    cd(startingPath);
        
% Now loop through the TH and create the movie...
    % Loop and retrieve the floor displ TH's...
    numStories = buildingInfo{bldgID}.numStories;
    maxFloorNum = numStories + 1;
    for currentFloorNum = 2:maxFloorNum
        currentFloorNum
        nodeNumsAtEachFloorLIST(currentFloorNum)
        floorDisp{currentFloorNum}.TH = nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,lateralDispDOF);
    end

% Now loop through the node displacement TH, plot the displaced shape at
% each step and then create the movie
    numStepsInAnalysis = length(floorDisp{2}.TH);
    for currentAnalysisStepNum = 1:(numStepsInAnalysis)
        % Only compute and record a frame every several steps according to
        % "numAnalysisStepsPerSample".  To do this, only compute and save a
        % frame if the "currentAnalysisStepNum" is evenly divisible by "numAnalysisStepsPerSample".
        if((mod(currentAnalysisStepNum, numAnalysisStepsPerSample)) == 0)
            % For this analysis step, create the floorDisp vector needed to send to the frame plotting
            % function
            for currentFloorNum = 2:maxFloorNum
                floorDispVECTOR(currentFloorNum) = scaleFactorOnDisp * floorDisp{currentFloorNum}.TH(currentAnalysisStepNum);
            end
            
            % Loop through and create the curvature and shear
            % demand/capacity ratios for THIS STEP OF THE ANALYSIS
            for currentStoryNum = 1:numStories
                % Element numbers at this story
                currentFlexElementNumberAtThisStory = buildingInfo{bldgID}.flexElementNumAtStory(currentStoryNum);
                currentShearSpringElementNumberAtThisStory = buildingInfo{bldgID}.shearSpringElementNumAtStory(currentStoryNum);
                % Curvature damand/capacity ratio is the maximum ratio
                % between the two ends of the element at this story.  Note
                % that DOF 2 is the curvature in the
                % "elementArray{#}.forceAndDeformation.endi"
                currentPeakCurvatureDemand_absVal = max(abs(elementArray{currentFlexElementNumberAtThisStory}.forceAndDeformation.endi(currentAnalysisStepNum,2)), abs(elementArray{currentFlexElementNumberAtThisStory}.forceAndDeformation.endj(currentAnalysisStepNum,2)));
                % Shear spring damand/capacity ratio...
                currentPeakShearDispDemand_absVal = abs(elementArray{currentShearSpringElementNumberAtThisStory}.rotTH(currentAnalysisStepNum));

                % If this is the first time into this bottom loop,
                % then initialize the maximum ever demand/capacity ratios.  If we have
                % been into this loop before, then check to see if
                % the current demand/capacity ratios exceed the max., then adjust the
                % max. if appropriate.
                if (firstTimeIntoAnalysisLoop == 1)
                    % Initialize the max's to be the absolute value of the current value
                    curvatureDemandVECTOR{currentStoryNum} = currentPeakCurvatureDemand_absVal;
                    shearSpringDispDemandVECTOR{currentStoryNum} = currentPeakShearDispDemand_absVal;
                else
                    % Adjust the max. curvature demand only if the current is higher
                    % than the previous max.
                    if(currentPeakCurvatureDemand_absVal > curvatureDemandVECTOR{currentStoryNum})
                        curvatureDemandVECTOR{currentStoryNum} = currentPeakCurvatureDemand_absVal;
                    else
                        % Do nothing
                    end 
                    
                    % Adjust the max. shear displacement demand only if the current is higher
                    % than the previous max.
                    if(currentPeakShearDispDemand_absVal > shearSpringDispDemandVECTOR{currentStoryNum})
                        shearSpringDispDemandVECTOR{currentStoryNum} = currentPeakShearDispDemand_absVal;
                    else
                        % Do nothing
                    end 
                end; % end of if for first time into loop
                
                
                % Checks
                curvatureDemandVECTOR_Story1 = curvatureDemandVECTOR{1};
                
            end; % end of for loop for storyNums
                 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Now call the function and plot the displaced shape of the wall
            DrawDistortedWall(buildingInfo, bldgID, floorDispVECTOR, curvatureDemandVECTOR, shearSpringDispDemandVECTOR, analysisType, eqNum, saLevel, titleOption, maxOnDemandCapacityRatioToPlot, saDefType);
            hold on
        
            % Now save a frame of this into the movie and then close this
            % current figure
            frame = getframe(gca);
            aviobj=addframe(aviobj,frame);
            close all     
        
            % Set a flag to say that we have been in the loop already (b/c the
            % first time into this loop initializes the PHR variables)
            firstTimeIntoAnalysisLoop = 0;
            
        else
            % Don't do any frame for this analysis step
        end
        
    end

% Close the movie file
    aviobj=close(aviobj); 
    disp('Done with making movie!')







