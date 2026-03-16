%
% Procedure: DrawNonDistortedFrameWithMaxPHForEQ.m
% -------------------
% This procedure plots a single clip of the non-distorted frame with the PHR levels that are
%   maximum for the full EQ.
% 
% Variable definitions:
%       bldgID - ID to determine which building to plot (as defined in
%               DefineInfoForBuildings.m)
%       floorDispVECTOR - vector of floor displacements (floor numbers are
%               same as defined in DefineInfoForBuildings.m; floor 1 in the
%               ground and floor 2 is the first raised floor)
%       plasticRotationARRAY - cell array - this is an array that defines the plastic
%               rotation demands at each joint (based on joint number;
%               joint numbers are from the OpenSees model and must be
%               consistent with those in DefineInfoForBuildings.m).
%               (e.g. plasticRotationARRAY{jointNum}.jointNodePHRDemand{1} =
%               0.035; means that the node at the bottom of this joint has
%               the 0.035 plastic rotation demand
%               Note that for the column bases, we use hingeNumber (for the column base hinge) instead
%               of joint number.
%       analysisType, eqNum, saLevel - just the normal definitions (to put
%               the title on the plot).
%       driftPlotOption - this tells the program which drift to plot 
%               =1 to plot the undeformed shape (good for a 2/50 event)
%               =2 to plot the drift at the last time step of the analysis (for collapse analyses)
%               =3 to plot the peak drift throughout the TH in each floor
%       isSaveFile - option to save this picture as a .fig and .emf 
%               =1 saves the files
%               =0 doesn't save any files
%       titleOption - option regarding title of the graph
%               =1 uses a full title including the analysis Type, EQ#, and Sa level
%               =2 uses a title that includes just EQID and Sa level
%       maxOnDemandCapacityRatioToPlot - This is simply a variable that allowes
%               the user to control the maximum demand-capacity ratio that will be
%               plotted on the frame.  This is useful when plotting
%               collapse modes because often the last time step is unstable
%               and can lead to huge circle/squares in the plot.  If you
%               don't want touse this, siply set it to be a huge number.
%       saDefType - type of SA definition we want to put on the titles
%               =1 for Sa,comp
%               =2 for Sa,geoMean
%               =3 for Sa,codeDef
%
%
%
%
% Assumptions and Notices: 
%       - This will only work for a regualr frame that has equal bay width
%           and has uniform story heights (other than first story being
%           different)
%       - The building information for the desired bldgID must be defined
%           in DefineInfoForBuildings.m.
%
%
% Author: Curt Haselton 
% Date Written: 12-04-04
% Updated: 12-07-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = psb_DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNum, saLevel, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType)

% Define the DOF # that corresponds to the lateral displacement of the
% floors (for getting the correct nodal displacements for plotting)
    lateralDispDOF = 1;

% Set some dummy variables to say that we do not want to highlight any
% hinges differently (this highlighting is used when we make movies of
% the building wiggling and other responses at the same time)
    isHingesHighlighted = 0;        % No highlighting
    hingeHighlighted_1 = [0,0,0];   % Dummy variable
    hingeHighlighted_2 = [0,0,0];   % Dummy variable
    highlightedHingeColor_1 = 'k';  % Dummy variable
    highlightedHingeColor_2 = 'k';  % Dummy variable

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
    load('DATA_allDataForThisSingleRun.mat', 'elementArray', 'nodeArray', 'nodeNumsAtEachFloorLIST', 'periodUsedForScalingGroundMotionsFromMatlab');
    cd(startingPath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop through and create the plastic rotation array from the opened
% analysis data.  Note that the first five columns in
% "elementArray" are the deformations and 6-10 are the forces.
    numColLines = buildingInfo{bldgID}.numBays + 1;
    maxFloorNum = buildingInfo{bldgID}.numStories + 1;
    fprintf('Number of columns lines = %i; number of floor levels = %i. \n', numColLines, maxFloorNum);

    for currentFloorNum = 2:maxFloorNum
        for currentColLineNum = 1:numColLines
           currentJointNum = buildingInfo{bldgID}.jointNumber(currentFloorNum, currentColLineNum);

            % Loop for the five joint nodes and compute the current and max ever plastic rotation demands
            for currentJointNodeNum = 1:5
                % Compute the max. PHR for this step in the loop and save it
                currentMaxPlasticRotationDemand_abs = max(abs(elementArray{currentJointNum}.JointForceAndDeformation(:, currentJointNodeNum)));
                plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{currentJointNodeNum} = currentMaxPlasticRotationDemand_abs;
            end; % end of for loop for jointNodeNums
            if (bldgID == 502) %fix for symmetry!
                if (currentColLineNum == 4)
                    currentMaxPlasticRotationDemand_abs = max(abs(elementArray{currentJointNum}.JointForceAndDeformation(:, 4)));
                    plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{2} = currentMaxPlasticRotationDemand_abs;
                end
                if (currentColLineNum == 7)
                    currentMaxPlasticRotationDemand_abs = max(abs(elementArray{currentJointNum}.JointForceAndDeformation(:, 2)));
                    plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{4} = currentMaxPlasticRotationDemand_abs;
                end
            end
        end; % end of for loop for colLines
    end; % end of for loop for floorNums
    
    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do a similar loop for the column base hinges at the
% foundation level (the ones that are not assciated with any
% joint)
    currentFloorNum = 1;
    currentJointNodeNum = 1;
    for currentColLineNum = 1:numColLines
        currentColBaseHingeNum = buildingInfo{bldgID}.hingeElementNumAtColBase(currentColLineNum);
        % Get the PHR demands from the elementArray
        currentMaxPlasticRotationDemand_abs = max(abs(elementArray{currentColBaseHingeNum}.rotTH));
        plasticRotationARRAY{currentColBaseHingeNum}.columnBasePHRDemand = currentMaxPlasticRotationDemand_abs;
    end; % end of for loop for colLines

% Now that we have computed all of the plastc rotation demands, now send
% this to the function to plot the frame with the plastic rotation demands
% shown.  When plotting the frame, decide how to do the drifts depending on
% the input for the "driftPlotOption" variable (see description at top of
% this file).
    switch driftPlotOption
        case (1)
            % Plot undeformed building
            floorDispVECTOR = zeros(maxFloorNum);
        case (2)
            % Plot drifts at last time step of analysis
            maxFloorNum = buildingInfo{bldgID}.numStories + 1;
            for currentFloorNum = 2:maxFloorNum
                floorDisp{currentFloorNum}.TH = nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,lateralDispDOF);
                lastTimeStepNum = length(floorDisp{currentFloorNum}.TH);
                floorDispVECTOR(currentFloorNum) = floorDisp{currentFloorNum}.TH(lastTimeStepNum);
            end
        case (3)
            % Plot the absMax peak dispalcements of each floor for the full EQ (NOTE: this is
            % not an image of a distorted building, but absolute value of peak floor displacement in
            % each story at each time step)
            maxFloorNum = buildingInfo{bldgID}.numStories + 1;
            for currentFloorNum = 2:maxFloorNum
                floorDisp{currentFloorNum}.TH = nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,lateralDispDOF);
                floorDispVECTOR(currentFloorNum) = max(abs(floorDisp{currentFloorNum}.TH));
            end
        otherwise
            error('Invalid value for driftPlotOption');
    end
    % Now plot the frame  
    psb_DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisType, eqNum, saLevel, isHingesHighlighted, hingeHighlighted_1, hingeHighlighted_2, highlightedHingeColor_1, highlightedHingeColor_2, titleOption, maxOnDemandCapacityRatioToPlot, saDefType, periodUsedForScalingGroundMotionsFromMatlab);

% Save the plots in this folder as a .fig and an .emf
    if (isSaveFile == 1)
        plotName = sprintf('MaxPHRForEQ_%s_EQ_%d_Sa_%.2f.fig', analysisType, eqNum, saLevel);
        hgsave(plotName);
        % Export the plot as a .emf file (Matlab book page 455) - In this folder
        exportName = sprintf('MaxPHRForEQ_%s_EQ_%d_Sa_%.2f.emf', analysisType, eqNum, saLevel);
        print('-dmeta', exportName);    
    end













