% This function is used to extract the base node reactions and base shear
% output data from a 2D model
function pushoverResults = extractPushoverResults2DModel(...
    buildingGeometry,BuildingModelDirectory,AnalysisDirection,...
    buildingLoads,FrameLineNumber)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Extracting Base Shear History                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define directory where base node reactions are stored
    if strcmp(AnalysisDirection,'XDirection') == 1
        FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
        BaseNodeReactionDataLocation = strcat(BuildingModelDirectory,...
        '\OpenSees2DModels\XDirectionFrameLines\',FrameLineModelFolder,...
        '\PushoverAnalysis\Static-Pushover-Output-Model2D\BaseReactions');
    else
       FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
        BaseNodeReactionDataLocation = strcat(BuildingModelDirectory,...
        '\OpenSees2DModels\ZDirectionFrameLines\',FrameLineModelFolder,...
        '\PushoverAnalysis\Static-Pushover-Output-Model2D\BaseReactions');
    end  

    cd(BaseNodeReactionDataLocation)

    % Extract base node reaction force data
    BaseReactionForceFile = load('XReactions.out');

    % Initializing Base Shear Vectors
    pushoverResults.baseShear = zeros(length(BaseReactionForceFile(:,...
        1)),1);
    
   % Generate matrix of base reaction for each node
    if strcmp(AnalysisDirection,'XDirection') == 1
        NBays = buildingGeometry.numberOfXBays;
    else
        NBays = buildingGeometry.numberOfZBays;
    end
    for j = 1:NBays + 2
        % Base shear
        pushoverResults.baseShear = pushoverResults.baseShear + ...
            BaseReactionForceFile(:,j);
    end
    % Normalize base shears 
    if strcmp(AnalysisDirection,'XDirection') == 1
        pushoverResults.baseShear = pushoverResults.baseShear/(sum(...
        buildingLoads.floorWeights*buildingLoads. ...
        xFrameLinesTributarySeismicMassRatios(FrameLineNumber)));
    else
        pushoverResults.baseShear = pushoverResults.baseShear/(sum(...
        buildingLoads.floorWeights*buildingLoads. ...
        zFrameLinesTributarySeismicMassRatios(FrameLineNumber)));
    end
        
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Extracting Roof Drift History                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define directory where story drifts are stored
    if strcmp(AnalysisDirection,'XDirection') == 1
        FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
        StoryDriftDataLocation = strcat(BuildingModelDirectory,...
        '\OpenSees2DModels\XDirectionFrameLines\',FrameLineModelFolder,...
        '\PushoverAnalysis\Static-Pushover-Output-Model2D\StoryDrifts');
    else
       FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
        StoryDriftDataLocation = strcat(BuildingModelDirectory,...
        '\OpenSees2DModels\ZDirectionFrameLines\',FrameLineModelFolder,...
        '\PushoverAnalysis\Static-Pushover-Output-Model2D\StoryDrifts');
    end   

    cd(StoryDriftDataLocation)

    % Extract roof drift history
    roofDriftFile = load('Roof.out');
    pushoverResults.roofDrift = roofDriftFile(:,2);

end

