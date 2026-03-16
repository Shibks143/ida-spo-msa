% This function is used to generate a struct containing building
% geometry data
function buildingGeometry = defineBuildingGeometry(...
    GeometryParametersLocation)

    % Go to folder where building geometry data is stored
    cd(GeometryParametersLocation)
    
    % Define struct with building geometry data
    buildingGeometry.numberOfStories = load('numberOfStories.txt');
    buildingGeometry.storyHeights = load('storyHeights.txt'); % (inches)
    % Compute floor heights
    for i = 1:buildingGeometry.numberOfStories
        buildingGeometry.floorHeights(i) = ...
            sum(buildingGeometry.storyHeights(1:i));
    end
    buildingGeometry.numberOfXBays = load('numberOfXBays.txt');
    buildingGeometry.numberOfZBays = load('numberOfZBays.txt');
    buildingGeometry.XBayWidths = load('XBayWidths.txt'); % (inches)
    buildingGeometry.ZBayWidths = load('ZBayWidths.txt'); % (inches)
    buildingGeometry.foundationUplift = load('foundationUplift.txt');
end

