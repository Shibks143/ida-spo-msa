% This function is used to generate the OpenSees file that defines all base
% node supports
function defineFixitiesZDirection2DModel(buildingGeometry,jointNodes,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generating Tcl File with Fixity at all Column Bases Defined       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data directory
    cd(BuildingModelDirectory)
    
    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd ZDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineFixities2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define the fixity at all column bases');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining fixity at columns bases
    fprintf(fid,'%s\n','# Defining fixity at columns bases');
    % Looping over number of z-direction frame lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over Z-Direction column lines
                fprintf(fid,'%s\t','fix');
                fprintf(fid,'%s\t',jointNodes{1,FrameLineNumber,j}. ...
                    openSeesTag);
                fprintf(fid,'%u\t',1);  
                fprintf(fid,'%u\t',1);
                fprintf(fid,'%u',0);          
                fprintf(fid,'%s\n',';');
        end
        % Leaning column node
        fprintf(fid,'%s\t','fix');
        if buildingGeometry.numberOfStories > 8
            fprintf(fid,'%s\t',num2str(...
                    leaningColumnNodeObjects.jointNodes(1)));
        else
        fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(1)));
        end
        fprintf(fid,'%u\t',1);  
        fprintf(fid,'%u\t',1);  
        fprintf(fid,'%u',0);        
        fprintf(fid,'%s\n',';');
        fprintf(fid,'%s\n','');

    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','puts "all column base fixities have been defined"');

    % Closing and saving tcl file
    fclose(fid);
end

