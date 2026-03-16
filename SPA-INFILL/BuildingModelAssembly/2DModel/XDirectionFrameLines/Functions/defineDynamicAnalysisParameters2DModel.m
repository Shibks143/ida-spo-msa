
% This function is used to generate the tcl file that defines dynamic
% analysis parameters for a 3D Model in OpenSees        

function defineDynamicAnalysisParameters2DModel(buildingGeometry,...
    FrameLineNumber,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodes                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd XDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType) 

    % Opening and defining Tcl file
    fid = fopen('DefineDynamicAnalysisParameters2DModel.tcl','wt');

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
            fprintf(fid,'%s\n',strcat(num2str(1),num2str(i),...
                num2str(FrameLineNumber),'];'));
        else
            fprintf(fid,'%s\t',strcat(num2str(1),num2str(i),...
                num2str(FrameLineNumber)));
        end
    end

    % Closing and saving tcl file
    fclose(fid);
end