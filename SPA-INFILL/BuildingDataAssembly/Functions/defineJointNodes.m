% This function is used to generate an array of joint node objects where
% joint nodes are the nodes that are at the intersection of beam column
% joints. They do not include additional nodes for beam-column hinges or
% BNWF model
function jointNodes = defineJointNodes(buildingGeometry,ClassesDirectory)

    
    % Create empty array to store joint nodes
    cd(ClassesDirectory)
    jointNodes = cell(buildingGeometry.numberOfStories,...
        buildingGeometry.numberOfXBays + 1,...
        buildingGeometry.numberOfZBays + 1);

    % Variable used to count number of beam-column joint nodes
    count = 1;
    % Loop over the number of stories
    for i = 1:buildingGeometry.numberOfStories + 1
        % Loop over the number of Z-Direction column lines
        for j = 1:buildingGeometry.numberOfZBays + 1
            % Loop over number of X-Direction column lines
            for k = 1:buildingGeometry.numberOfXBays + 1
                jointNodes{i,k,j} = saveToStruct(jointNode(count,i,k,j,...
                    buildingGeometry.XBayWidths,buildingGeometry.ZBayWidths,...
                    buildingGeometry.storyHeights));
                count = count + 1;
            end
        end
    end
end

