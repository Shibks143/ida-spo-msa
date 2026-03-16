%
% Procedure: DrawWallWithMaxPHForEQ_withSaveOption.m
% -------------------
% This procedure plots a single clip of the non-distorted or distorted wall with the PHR levels that are
%   maximum for the full EQ.% 
%
% Variable definitions:
%       bldgID - ID to determine which building to plot (as defined in
%               DefineInfoForBuildings.m)
%       floorDispVECTOR - vector of floor displacements (floor numbers are
%               same as defined in DefineInfoForBuildings.m; floor 1 in the
%               ground and floor 2 is the first raised floor)
%       curvatureDemandARRAY - cell array - this is an array that defines the curvature 
%               demands at each story.
%               (e.g. curvatureDemandARRAY{storyNum} = 0.0035; 
%       shearSpringDispDemandARRAY - cell array - this is an array that
%               defines the shear dispalcement (i.e. shear distortion angle
%               multiplied by story height) demands at each story.
%               (shearSpringDispDemandARRAY{storyNum})
%       analysisType, eqNum, saLevel - just the normal definitions (to put
%               the title on the plot).
%       titleOption - option regarding title of the graph
%               =1 uses a full title including the analysis Type, EQ#, and Sa level
%               =2 uses a title that includes just EQID and Sa level
%       maxOnDemandCapacityRatioToPlot - This is simply a variable that allowes
%               the user to control the maximum demand-capacity ratio that will be
%               plotted on the frame.  This is useful when plotting
%               collapse modes because often the last time step is unstable
%               and can lead to huge circle/squares in the plot.  If you
%               don't want touse this, siply set it to be a huge number.
%       driftPlotOption - this tells the program which drift to plot 
%               =1 to plot the undeformed shape (good for a 2/50 event)
%               =2 to plot the drift at the last time step of the analysis (for collapse analyses)
%               =3 to plot the peak drift throughout the TH in each floor
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
function[] = DrawWallWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNum, saLevel, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType)

% Set options
    % Define the DOF # that corresponds to the lateral displacement of the floors
    lateralDispDOF = 1;
    
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
        
% Now loop through the TH and get the displacements of interest
    numStories = buildingInfo{bldgID}.numStories;
    maxFloorNum = numStories + 1;
    
    for currentFloorNum = 2:maxFloorNum
        % Max displacements
        floorDispVECTOR_max(currentFloorNum) = max(abs(nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,lateralDispDOF)));
        % Displacements at last time step
        lastTimeStep = length(nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,lateralDispDOF));
        floorDispVECTOR_lastTimeStep(currentFloorNum) = nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(lastTimeStep,lateralDispDOF);
        % Also make a zero displacement vector for that plotting option
        % (doesn't need to be in loop but easier)
        floorDispVECTOR_zeroDisp(currentFloorNum) = 0.0;
    end
    
% Depending on the input for "driftPlotOption" decise with drift ratio to
% plot
floorDispVECTOR_toUse(1) = 0.0; % Say that the displacement of story one (ground) is zero
switch driftPlotOption
    case 1
        floorDispVECTOR_toUse = floorDispVECTOR_zeroDisp;
    case 2
        floorDispVECTOR_toUse = floorDispVECTOR_lastTimeStep;
    case 3
        floorDispVECTOR_toUse = floorDispVECTOR_max;
    otherwise
        error('Invalid driftPlotOption');
end

% Loop through and create the MAXIMUM curvature and shear
% demand/capacity ratios for entire EQ (absolute value)
    for currentStoryNum = 1:numStories
        % Element numbers at this story
        currentFlexElementNumberAtThisStory = buildingInfo{bldgID}.flexElementNumAtStory(currentStoryNum);
        currentShearSpringElementNumberAtThisStory = buildingInfo{bldgID}.shearSpringElementNumAtStory(currentStoryNum);
        % Curvature damand/capacity ratio is the maximum ratio between the two ends of the element at this story.  Note
        % that DOF 2 is the curvature in the "elementArray{#}.forceAndDeformation.endi"
        maximumCurvatureDemand_currentStory_absVal = max((max(abs(elementArray{currentFlexElementNumberAtThisStory}.forceAndDeformation.endi(:,2)))), max(abs(elementArray{currentFlexElementNumberAtThisStory}.forceAndDeformation.endj(:,2))));
        % Shear spring damand/capacity ratio...
        maximumShearDispDemand_currentStory_absVal = max(abs(elementArray{currentShearSpringElementNumberAtThisStory}.rotTH(:)));

        % Now save the results for each story
        curvatureDemandVECTOR{currentStoryNum} = maximumCurvatureDemand_currentStory_absVal;
        shearSpringDispDemandVECTOR{currentStoryNum} = maximumShearDispDemand_currentStory_absVal;
        
    end; % end of for loop for storyNums
                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now call the function and plot the displaced shape of the wall
    DrawDistortedWall(buildingInfo, bldgID, floorDispVECTOR_toUse, curvatureDemandVECTOR, shearSpringDispDemandVECTOR, analysisType, eqNum, saLevel, titleOption, maxOnDemandCapacityRatioToPlot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If told with input to the procedure, save the plots in this folder as a .fig and an .emf
    if (isSaveFile == 1)
        plotName = sprintf('MaxPHRForEQ_%s_EQ_%d_Sa_%.2f.fig', analysisType, eqNum, saLevel);
        hgsave(plotName);
        % Export the plot as a .emf file (Matlab book page 455) - In this folder
        exportName = sprintf('MaxPHRForEQ_%s_EQ_%d_Sa_%.2f.emf', analysisType, eqNum, saLevel);
        print('-dmeta', exportName);    
    end





