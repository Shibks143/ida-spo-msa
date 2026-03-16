%
% Procedure: CreateBuildingMovie_WithSubPlots_Frame_AndGD.m
% -------------------
% This procedure creates a movie of the building shaking (or during a PO).
% This now includes the subplots that show the building shaking, the drift
% level over the EQ, and responses of two hinges.
%
% Variable definitions:
%       bldgID - ID to determine which building to plot (as defined in
%               DefineInfoForBuildings.m)
%       saDefType - type of SA definition we want to put on the titles
%               =1 for Sa,comp
%               =2 for Sa,geoMean
%               =3 for Sa,codeDef%
%
% Assumptions and Notices: 
%       - This will only work for a regular frame that has equal bay width
%           and has uniform story heights (other than first story being
%           different)
%       - The building information for the desired bldgID must be defined
%           in DefineInfoForBuildings.m.
%
%
% Author: Curt Haselton 
% Date Written: 12-03-04
% Modified: Abbie Liel, 12/11/05
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = CreateBuildingMovie_WithSubPlots_Frame_AndGD_Traces(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieIndex, jointResponseToPlot_1, jointResponseToPlot_2, saDefType)

% Set options
    % Define the DOF # that corresponds to the lateral displacement of the
    % floors
    lateralDispDOF = 1;
    verticalDispDOF = 2;
    numFramesPerSecond = 50;        % The EQ analysis time step is 0.02, so this just makes the video as long as the EQ (for PO, I may need to revisit this number!)
    scaleFactorOnDisp = 3.0;        % Scales up the displacements
    numAnalysisStepsPerSample = 5;  % (NOTICE: Be sure this makes an even number for frames per second.)  This is how many analysis steps are needed in order to take one frame shot of the model (just to reduce frames to reduce processing time)  
    
    % Set some dummy variables to say that we do not want to highlight any
    % hinges differently (this highlighting is used when we make movies of
    % the building wiggling and other responses at the same time)
    isHingesHighlighted = 0;        % No highlighting
    hingeHighlighted_1 = [0,0,0];   % Dummy variable
    hingeHighlighted_2 = [0,0,0];   % Dummy variable
    highlightedHingeColor_1 = 'k';  % Dummy variable
    highlightedHingeColor_2 = 'k';  % Dummy variable
    
% Set a flag to say that we have not been into the bottom loop yet (b/c the first time into the loop initializes the PHR variables)
    firstTimeIntoAnalysisLoop = 1;
    
% Set up the movie file
    movieName = sprintf('Movie_WithSubPlots_%s_EQ_%d_Sa_%.2f_%d.avi', analysisType, eqNum, saLevel, movieIndex);
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
    load('DATA_allDataForThisSingleRun.mat', 'elementArray', 'nodeArray', 'ground', 'nodeNumsAtEachFloorLIST', 'storyDriftRatio');
    cd(startingPath);
        
% Now loop through the TH and create the movie...
    % Loop and retrieve the floor displ TH's...
    maxFloorNum = buildingInfo{bldgID}.numStories + 1;
    for currentFloorNum = 2:maxFloorNum
        floorDisp{currentFloorNum}.TH = nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,lateralDispDOF);
        % Compute Total Displacements
        floorDispTotal{currentFloorNum}.TH = floorDisp{currentFloorNum}.TH + ground.displTH; 
         verticalFloorDisp{currentFloorNum}.TH = nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,verticalDispDOF);
    end
    floorDispTotal{1}.TH = ground.displTH;
    roof.displTH = nodeArray{nodeNumsAtEachFloorLIST(maxFloorNum)}.displTH(:,lateralDispDOF);
    verticalFloorDisp{1}.TH = zeros(length(ground.displTH));
    

% Now loop through the node displacement TH, plot the displaced shape at
% each step and then create the movie
    numStepsInAnalysis = length(floorDispTotal{2}.TH);
    for currentAnalysisStepNum = 1:(numStepsInAnalysis)
        % Only compute and record a frame every several steps according to
        % "numAnalysisStepsPerSample".  To do this, only compute and save a
        % frame if the "currentAnalysisStepNum" is evenly divisible by "numAnalysisStepsPerSample".
        if((mod(currentAnalysisStepNum, numAnalysisStepsPerSample)) == 0)
            % For this analysis step, create the floorDisp vector needed to send to the frame plotting
            % function
            for currentFloorNum = 1:maxFloorNum
                floorDispTotalVECTOR(currentFloorNum) = scaleFactorOnDisp * floorDispTotal{currentFloorNum}.TH(currentAnalysisStepNum);
                verticalFloorDispVECTOR(currentFloorNum) = scaleFactorOnDisp * verticalFloorDisp{currentFloorNum}.TH(currentAnalysisStepNum);
            end
            
            % Compute the maximum and minimim story drift ratios to this
            % point in the analysis (so we can send them later to the drift
            % plotter).  NOTE: This was added for the scatterplot function
            % on 12-4-05.
            maxStoryNum = maxFloorNum - 1;
            for currentStoryNum = 1:maxStoryNum
                storyDriftRatio_Neg(currentStoryNum) = min(storyDriftRatio{currentStoryNum}.TH(1:currentAnalysisStepNum));
                storyDriftRatio_Pos(currentStoryNum) = max(storyDriftRatio{currentStoryNum}.TH(1:currentAnalysisStepNum));
            end
            
            % Loop through and create the plastic rotation array from the opened
            % analysis data.  Note that the first five columns in
            % "elementArray" are the deformations and 6-10 are the forces.
            numColLines = buildingInfo{bldgID}.numBays + 1;
            for currentFloorNum = 2:maxFloorNum
                for currentColLineNum = 1:numColLines
                    currentJointNum = buildingInfo{bldgID}.jointNumber(currentFloorNum, currentColLineNum);
            
                    % Loop for the five joint nodes and compute the current and max ever plastic rotation demands
                    for currentJointNodeNum = 1:5
                        currentPlasticRotationDemand_abs = abs(elementArray{currentJointNum}.JointForceAndDeformation(currentAnalysisStepNum, currentJointNodeNum));
                        
                        % If this is the first time into this bottom loop,
                        % then initialize the maximum ever PHR.  If we have
                        % been into this loop before, then check to see if
                        % the current PHR exceeds the max., then adjust the
                        % max. if appropriate.
                        if (firstTimeIntoAnalysisLoop == 1)
                            % Initialize the mas to be the absolute value of the current value
                            plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{currentJointNodeNum} = currentPlasticRotationDemand_abs;
                        else
                            % Adjust the max. only if the current is higher
                            % than the previous max.
                            if(currentPlasticRotationDemand_abs > plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{currentJointNodeNum})
                               plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{currentJointNodeNum} = currentPlasticRotationDemand_abs;
                            else
                                % Do nothing
                            end; % end of if for adjusting max.
                        end; % end of if for first time into loop
                    end; % end of for loop for jointNodeNums
                end; % end of for loop for colLines
            end; % end of for loop for floorNums
                 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Do a similar loop for the column base hinges at the
            % foundaiton level (the ones that are not assciated with any
            % joint)
                currentFloorNum = 1;
                currentJointNodeNum = 1;
                for currentColLineNum = 1:numColLines
                    currentColBaseHingeNum = buildingInfo{bldgID}.hingeElementNumAtColBase(currentColLineNum);

                    % Get the PHR demands from the elementArray
                    currentPlasticRotationDemand_abs = abs(elementArray{currentColBaseHingeNum}.rotTH(currentAnalysisStepNum));
                    
                    % If this is the first time into this bottom loop,
                    % then initialize the maximum ever PHR.  If we have
                    % been into this loop before, then check to see if
                    % the current PHR exceeds the max., then adjust the
                    % max. if appropriate.
                    if (firstTimeIntoAnalysisLoop == 1)
                        % Initialize the mas to be the absolute value of the current value
                        plasticRotationARRAY{currentColBaseHingeNum}.columnBasePHRDemand = currentPlasticRotationDemand_abs;
                    else
                        % Adjust the max. only if the current is higher
                        % than the previous max.
                        if(currentPlasticRotationDemand_abs > plasticRotationARRAY{currentColBaseHingeNum}.columnBasePHRDemand)
                            plasticRotationARRAY{currentColBaseHingeNum}.columnBasePHRDemand = currentPlasticRotationDemand_abs;
                        else
                            % Do nothing
                        end; % end of if for adjusting max.
                    end; % end of if for first time into loop
                end; % end of for loop for colLines
            
            % Now call the procedure to make the subplot for this time step
            CreateSubPlots_Frame_AndGD_Traces(buildingInfo, bldgID, analysisType, eqNum, saLevel, floorDispTotalVECTOR, plasticRotationARRAY, elementArray, storyDriftRatio_Neg, storyDriftRatio_Pos, currentAnalysisStepNum, jointResponseToPlot_1, jointResponseToPlot_2, saDefType, ground.displTH, roof.displTH, verticalFloorDispVECTOR)
            hold on
            
%             % Older - before subplot movie was made - Now call the function and plot the displaced shape of the frame
%             DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisType, eqNum, saLevel, isHingesHighlighted, hingeHighlighted_1, hingeHighlighted_2, highlightedHingeColor_1, highlightedHingeColor_2);
            
            % Now save a frame of this into the movie and then close this
            % current figure
            %frame = getframe(gca);  % Captures just the current portion of the figure (one subplot)
            frame = getframe(gcf);  % Captures the full figure with axes and everything
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







