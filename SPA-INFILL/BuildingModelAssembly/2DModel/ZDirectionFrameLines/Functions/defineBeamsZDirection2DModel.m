% This function is used to generate the tcl file that defines the beams
% for a 3D Model in OpenSees     
function defineBeamsZDirection2DModel(buildingGeometry,zBeamObjects,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Generating Tcl File with Beams Defined                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd ZDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)
    
    % Opening and defining Tcl file
    fid = fopen('DefineBeams2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define beams');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining beams
    fprintf(fid,'%s\n','# Define beams');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\n',strcat('# Level',num2str(i + 1)));
        
        % Defining Z-Direction beams
        % Looping over the number of Z-direction bays
        for j = 1:buildingGeometry.numberOfZBays
            % Defining beams
            fprintf(fid,'%s\t','element');
            fprintf(fid,'%s\t','elasticBeamColumn');        
            fprintf(fid,'%s\t',zBeamObjects{i,FrameLineNumber,j}. ...
                openSeesTag);
            fprintf(fid,'%s\t',...
                    zBeamObjects{i,FrameLineNumber,j}. ...
                    startHingeNodeOpenSeesTag);
                fprintf(fid,'%s\t',...
                    zBeamObjects{i,FrameLineNumber,j}. ...
                    endHingeNodeOpenSeesTag);
                fprintf(fid,'%10.3f\t',zBeamObjects{i,FrameLineNumber,j...
                    }.area);
                fprintf(fid,'%10.3f\t',zBeamObjects{i,FrameLineNumber,j...
                    }.E);
                fprintf(fid,'%10.3f\t',zBeamObjects{i,FrameLineNumber,j...
                    }.Igtr*zBeamObjects{i,FrameLineNumber,j}.EIeffOverEIg);
                fprintf(fid,'%s','$LinearTransf'); 
                fprintf(fid,'%s\n',';');
        end
        % Rigid link connecting 2D frame to PDelta Columns    
        fprintf(fid,'%s\t','element');
        fprintf(fid,'%s\t','truss');    
%         fprintf(fid,'%s\t','node');
        if buildingGeometry.numberOfStories > 8
            fprintf(fid,'%s\t',strcat(num2str(2),...
                num2str(zBeamObjects{i,FrameLineNumber,...
                buildingGeometry.numberOfZBays}. ...
                endJointNodeOpenSeesTag),...
                num2str(leaningColumnNodeObjects.jointNodes(i + 1))));
            fprintf(fid,'%s\t',num2str(zBeamObjects{i,...
                FrameLineNumber,buildingGeometry.numberOfZBays}. ...
                endJointNodeOpenSeesTag));               
            fprintf(fid,'%s\t',num2str(...
                leaningColumnNodeObjects.jointNodes(i + 1)));
        else        
            fprintf(fid,'%s\t',strcat(num2str(2),...
                num2str(FrameLineNumber),num2str(i + 1),num2str(j + 1),...
                num2str(j + 2),num2str(i + 1)));
            fprintf(fid,'%s\t',strcat(num2str(FrameLineNumber),...
                num2str(i + 1),num2str(j + 1)));     
            fprintf(fid,'%s\t',strcat(num2str(j + 2),num2str(i + 1)));
        end
        fprintf(fid,'%10.3f\t',1e9);
        fprintf(fid,'%s','$TrussMatID'); 
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','puts "beams defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

