% This function is used to generate the OpenSees file that defines all base
% node supports
function defineFixities3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generating Tcl File with Fixity at all Column Bases Defined       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data directory
    cd(BuildingModelDirectory)
    
    % Go to folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineFixities3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define the fixity at all column bases');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining fixity at columns bases
    fprintf(fid,'%s\n','# Defining fixity at columns bases');
    % Looping over number of Z-Direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over X-Direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                fprintf(fid,'%s\t','fix');
                fprintf(fid,'%s\t',jointNodes{1,k,j}.openSeesTag);
                fprintf(fid,'%u\t',1);  
                fprintf(fid,'%u\t',1);  
                fprintf(fid,'%u\t',1);  
                fprintf(fid,'%u\t',0);    
                fprintf(fid,'%u\t',0);  
                fprintf(fid,'%u',0);          
                fprintf(fid,'%s\n',';');
            end
        end

    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','puts "all column base fixities have been defined"');

    % Closing and saving tcl file
    fclose(fid);
end

