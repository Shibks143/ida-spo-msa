% This function is used to generate a struct containing building loads
function buildingLoads = defineBuildingLoads(LoadParametersLocation)

    % Go to folder where building load data is stored
    cd(LoadParametersLocation)
    
    % Define struct with building loads
    buildingLoads.floorWeights = load('floorWeights.txt'); % (kips)
    buildingLoads.xDirectionBeamLoads = ...
        load('xDirectionBeamLoads.txt'); % (kips/in)
    buildingLoads.zDirectionBeamLoads = ...
        load('zDirectionBeamLoads.txt'); % (kips/in)
    buildingLoads.xFrameLinesTributarySeismicMassRatios = ...
        load('xFrameLinesTributarySeismicMassRatios.txt'); % (kips/in)
    buildingLoads.zFrameLinesTributarySeismicMassRatios = ...
        load('zFrameLinesTributarySeismicMassRatios.txt'); % (kips/in)
    buildingLoads.columnLoads = load('columnLoads.txt'); % (kips)
    buildingLoads.floorDeadLoad = load('floorDeadLoad.txt'); % (kips)
    buildingLoads.floorLiveLoad = load('floorLiveLoad.txt'); % (kips)
    buildingLoads.zFrameLineLeaningColumnLoads = ...
        load('zFrameLineLeaningColumnLoads.txt'); % (kips)
    buildingLoads.xFrameLineLeaningColumnLoads = ...
        load('xFrameLineLeaningColumnLoads.txt'); % (kips)
end

