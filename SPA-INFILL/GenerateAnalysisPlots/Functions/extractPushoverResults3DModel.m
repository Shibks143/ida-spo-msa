% This function is used to extract the base node reactions and base shear
% output data from a 3D model
function pushoverResults = extractPushoverResults3DModel(...
    buildingGeometry,BuildingModelDirectory,buildingLoads,...
    AnalysisDirection)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Extracting Base Shear History                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define directory where base node reactions are stored
    if strcmp(AnalysisDirection,'XDirection') == 1
        BaseNodeReactionDataLocation = strcat(BuildingModelDirectory,...
            '\OpenSees3DModels\PushoverAnalysis',...
            '\Static-Pushover-Output-Model3D-XPushoverDirection\',...
            'BaseReactions');
    else
        BaseNodeReactionDataLocation = strcat(BuildingModelDirectory,...
            '\OpenSees3DModels\PushoverAnalysis',...
            '\Static-Pushover-Output-Model3D-ZPushoverDirection\',...
            'BaseReactions');
    end  

    cd(BaseNodeReactionDataLocation)

    % Extract base node reaction force data
    if strcmp(AnalysisDirection,'XDirection') == 1
        BaseReactionForceFile = load('XReactions.out');
    else
        BaseReactionForceFile = load('ZReactions.out');
    end

    % Initializing Base Shear Vectors
    pushoverResults.baseShear = zeros(length(BaseReactionForceFile(:,...
        1)),1);
    
    % Loop over number of Z-Direction column lines
    count = 2;
    for j = 1:buildingGeometry.numberOfZBays + 1
        % Loop over number of X-Direction column lines
        for k = 1:buildingGeometry.numberOfXBays + 1
            % Base shear
            pushoverResults.baseShear = pushoverResults.baseShear + ...
                BaseReactionForceFile(:,count);
            count = count + 1;
        end
    end
    % Normalize base shears 
    pushoverResults.baseShear = pushoverResults.baseShear/sum(...
        buildingLoads.floorWeights);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Extracting Roof Drift History                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Define directory where story drifts are stored
    if strcmp(AnalysisDirection,'XDirection') == 1
        StoryDriftDataLocation = strcat(BuildingModelDirectory,...
        '\OpenSees3DModels\PushoverAnalysis','\Static-Pushover-Output-',...
        'Model3D-XPushoverDirection\StoryDrifts');
    else
        StoryDriftDataLocation = strcat(BuildingModelDirectory,...
        '\OpenSees3DModels\PushoverAnalysis','\Static-Pushover-Output-',...
        'Model3D-ZPushoverDirection\StoryDrifts');
    end  

    cd(StoryDriftDataLocation)

    % Extract roof drift history
    if strcmp(AnalysisDirection,'XDirection') == 1
        roofDriftFile = load('RoofX.out');
    else
        roofDriftFile = load('RoofZ.out');
    end
    pushoverResults.roofDrift = roofDriftFile(:,2);

end

