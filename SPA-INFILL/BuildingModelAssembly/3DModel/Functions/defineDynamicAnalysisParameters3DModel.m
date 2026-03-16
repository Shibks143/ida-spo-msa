
% This function is used to generate the tcl file that defines dynamic
% analysis parameters for a 3D Model in OpenSees        

function defineDynamicAnalysisParameters3DModel(buildingGeometry,...
    jointNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodes                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineDynamicAnalysisParameters3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define all nodes');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');
    
    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define the parameters needed for the collapse analysis solver');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Number of building stories
    fprintf(fid,'%s\t','set NStories');
    fprintf(fid,'%s\n',strcat(...
        num2str(buildingGeometry.numberOfStories),';'));

    % Height of 1st story
    fprintf(fid,'%s\t','set HTypicalStory');
    fprintf(fid,'%s\n',strcat(num2str(buildingGeometry.storyHeights(1)),...
        ';'));

    % Height of typical story
    fprintf(fid,'%s\t','set HFirstStory');
    fprintf(fid,'%s\n',strcat(num2str(buildingGeometry.storyHeights(2)),...
        ';'));
    
    % Defining floor nodes for drift monitoring
    fprintf(fid,'%s\t','set FloorNodes [list');
    for i = 1:(buildingGeometry.numberOfStories + 1)
        if i == buildingGeometry.numberOfStories + 1
            fprintf(fid,'%s\t',strcat(jointNodes{i,1,1}.openSeesTag,'];'));
        else
            fprintf(fid,'%s\t',jointNodes{i,1,1}.openSeesTag);
        end
    end

    % Closing and saving tcl file
    fclose(fid);
end