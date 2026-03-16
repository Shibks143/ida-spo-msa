% This function is used to generate the tcl file that defines the Columns
% for a 3D Model in OpenSees     
function defineColumnsXDirection2DModel(buildingGeometry,columnObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Generating Tcl File with Columns Defined                %
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
    fid = fopen('DefineColumns2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define columns');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining Columns
    fprintf(fid,'%s\n','# Define Columns');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\n',strcat('# Story',num2str(i)));
        % Looping over the number of X-direction column lines
        for j = 1:(buildingGeometry.numberOfXBays + 1)
            % Defining Columns
            fprintf(fid,'%s\t','element');
            fprintf(fid,'%s\t','elasticBeamColumn');        
            fprintf(fid,'%s\t',columnObjects{i,j,FrameLineNumber}. ...
                openSeesTag);
            fprintf(fid,'%s\t',...
                    columnObjects{i,j,FrameLineNumber}. ...
                    startHingeNodeOpenSeesTag);
                fprintf(fid,'%s\t',...
                    columnObjects{i,j,FrameLineNumber}. ...
                    endHingeNodeOpenSeesTag);
                fprintf(fid,'%10.3f\t',columnObjects{i,j,...
                    FrameLineNumber}.area);
                fprintf(fid,'%10.3f\t',columnObjects{i,j,...
                    FrameLineNumber}.E);
                fprintf(fid,'%10.3f\t',columnObjects{i,j,...
                    FrameLineNumber}.IgtrZZ*...
                    columnObjects{i,j,FrameLineNumber}.EIeffOverEIg);
                fprintf(fid,'%s','$PDeltaTransf'); 
                fprintf(fid,'%s\n',';');
        end
        % Leaning column
        fprintf(fid,'%s\t','element');
        fprintf(fid,'%s\t','elasticBeamColumn');
        if i ~= 1
            if buildingGeometry.numberOfStories > 8
                fprintf(fid,'%s\t',strcat(num2str(3),...
                    num2str(leaningColumnNodeObjects.startHingeNodes(i)...
                    ),num2str(leaningColumnNodeObjects.endHingeNodes(i))));
                fprintf(fid,'%s\t',strcat(num2str(...
                    leaningColumnNodeObjects.startHingeNodes(i))));
            else                
            fprintf(fid,'%s\t',strcat(num2str(3),num2str(j + 1),...
                num2str(i),num2str(4),num2str(j + 1),num2str(i + 1),...
                num2str(2)));
            fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i),...
                num2str(4)));
            end
        else
            if buildingGeometry.numberOfStories > 8
                fprintf(fid,'%s\t',strcat(num2str(3),...
                    num2str(leaningColumnNodeObjects.jointNodes(i)...
                    ),num2str(leaningColumnNodeObjects.endHingeNodes(i))));
                fprintf(fid,'%s\t',strcat(num2str(...
                    leaningColumnNodeObjects.jointNodes(i))));
            else                
            fprintf(fid,'%s\t',strcat(num2str(3),num2str(j + 1),...
                num2str(i),num2str(j + 1),num2str(i + 1),num2str(2)));
            fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i)));
            end
            
        end
        if buildingGeometry.numberOfStories > 8
            fprintf(fid,'%s\t',...
                num2str(leaningColumnNodeObjects.endHingeNodes(i)));
        else                
            fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i + 1),...
            num2str(2)));
        end
        
        fprintf(fid,'%10.3f\t',1e6);
        fprintf(fid,'%10.3f\t',1);
        fprintf(fid,'%10.3f\t',1e6);
        fprintf(fid,'%s','$PDeltaTransf'); 
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','puts "Columns defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

