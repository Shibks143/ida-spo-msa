% This function is used to generate an array of leaning node objects 
% that include the node numbers for the leaning column joint nodes
% and column hinge nodes
% BNWF model
function leaningColumnNodeObjects = defineLeaningColumnNodes(...
    buildingGeometry)

    
    % Compute number of joint nodes (for 3D Model)
    numberOfJointNodes = (buildingGeometry.numberOfXBays + 1)* ...
        (buildingGeometry.numberOfZBays + 1)* ...
        (buildingGeometry.numberOfStories + 1);
    numberOfColumnHingeNodes = 2*(buildingGeometry.numberOfXBays + 1)* ...
        (buildingGeometry.numberOfZBays + 1)* ...
        (buildingGeometry.numberOfStories);
    numberOfXBeamnHingeNodes = 2*(buildingGeometry.numberOfXBays)* ...
        (buildingGeometry.numberOfZBays + 1)* ...
        (buildingGeometry.numberOfStories);
    numberOfZBeamnHingeNodes = 2*(buildingGeometry.numberOfXBays + 1)* ...
        (buildingGeometry.numberOfZBays)* ...
        (buildingGeometry.numberOfStories);
    totalNumberOfNodes = numberOfJointNodes + numberOfColumnHingeNodes ...
        + numberOfXBeamnHingeNodes + numberOfZBeamnHingeNodes;
    
    % Loop over the number of stories
    for i = 1:buildingGeometry.numberOfStories + 1
        % Leaning column joint nodes
        leaningColumnNodeObjects.jointNodes(i) = totalNumberOfNodes + 1;
        totalNumberOfNodes = totalNumberOfNodes + 1;
    end
    
    % Loop over the number of stories
    for i = 1:buildingGeometry.numberOfStories
        % Leaning column start hinge joint nodes
        leaningColumnNodeObjects.startHingeNodes(i) = ...
            totalNumberOfNodes + 1;
        totalNumberOfNodes = totalNumberOfNodes + 1;
    end
    
    % Loop over the number of stories
    for i = 1:buildingGeometry.numberOfStories
        % Leaning column end hinge joint nodes
        leaningColumnNodeObjects.endHingeNodes(i) = ...
            totalNumberOfNodes + 1;
        totalNumberOfNodes = totalNumberOfNodes + 1;
    end
end

