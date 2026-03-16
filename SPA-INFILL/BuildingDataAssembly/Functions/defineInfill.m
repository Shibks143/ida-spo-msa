% This function is used to generate an array of infill strut objects
function [xDirectionInfillObjects zDirectionInfillObjects]...
    = defineInfill(buildingGeometry,ClassesDirectory,...
    jointNodes,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,columnObjects)
    
     % Create empty array to store infill strut objects
     xDirectionInfillObjects = cell(buildingGeometry.numberOfStories,...
        buildingGeometry.numberOfXBays,...
        buildingGeometry.numberOfZBays + 1);
    
    % Go to location where infill properties are located and 
    % extract x-direction infill location array
    cd(XDirectionInfillPropertiesLocation)
    xNonSpineInfillLocation = load('xInfillLocation.txt');
    
    % Variable used to count number of x-direction infill
    count = 1;
    % Loop over the number of stories
    for i = 1:buildingGeometry.numberOfStories
        % Loop over the number of Z-Direction column lines
        for j = 1:buildingGeometry.numberOfZBays + 1
            % Loop over number of X-Direction bays
            for k = 1:buildingGeometry.numberOfXBays
                cd(ClassesDirectory)
                if xNonSpineInfillLocation(i,(j - 1)*...
                        buildingGeometry.numberOfXBays + k) == 1
                    xDirectionInfillObjects{i,k,j} = saveToStruct(...
                        xInfill(count,i,k,j,jointNodes,...
                        XDirectionInfillPropertiesLocation,...
                        buildingGeometry,columnObjects,ClassesDirectory));
                    count = count + 1;
                end
            end
        end
    end
    
    % Create empty array to store nonspine infill strut objects
     zDirectionInfillObjects = cell(buildingGeometry.numberOfStories,...
        buildingGeometry.numberOfXBays + 1,...
        buildingGeometry.numberOfZBays);
    
    % Go to location where nonspine infill properties are located and 
    % extract z-nonspine infill location array
    cd(ZDirectionInfillPropertiesLocation)
    zNonSpineInfillLocation = load('zInfillLocation.txt');
    
    % Variable used to count number of z-nonspine infill
    count = 1;
    % Loop over the number of stories
    for i = 1:buildingGeometry.numberOfStories
        % Loop over the number of Z-Direction bays
        for j = 1:buildingGeometry.numberOfZBays
            % Loop over number of X-Direction column lines
            for k = 1:buildingGeometry.numberOfXBays + 1
                cd(ClassesDirectory)
                if zNonSpineInfillLocation(i,(j - 1)*...
                        (buildingGeometry.numberOfXBays + 1) + k) == 1
                    zDirectionInfillObjects{i,k,j} = saveToStruct(zInfill(...
                        count,i,k,j,jointNodes,...
                        ZDirectionInfillPropertiesLocation,...
                        buildingGeometry,columnObjects,ClassesDirectory));
                    count = count + 1;
                end
            end
        end
    end

    
end

