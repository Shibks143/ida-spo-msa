% This function is used to generate the tcl file that defines the 
% rigid floor dipahragm for a 3D model

function defineRigidFloorDiaphragm3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,AnalysisType)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generating Tcl File with Rigid Floor Diaphragm Properties         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineRigidFloorDiaphragm3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define the rigid floor diaphram properties');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Setting rigid diaphragm constraints on
    fprintf(fid,'%s\n','# Setting rigid floor diaphragm constraint on');
    fprintf(fid,'%s\n','set RigidDiaphragm ON;');
    fprintf(fid,'%s\n','');

    % Defining variables used to define coordinates of master nodes
    Xa = 0.5*sum(buildingGeometry.XBayWidths);
    Za = 0.5*sum(buildingGeometry.ZBayWidths);

    % Defining master nodes
    % Looping over number of floor levels
    for i = 2:(buildingGeometry.numberOfStories + 1)
        fprintf(fid,'%s\t','node');
        fprintf(fid,'%s\t',strcat(num2str(i),num2str(9999)));
        fprintf(fid,'%10.3f\t',Xa);
        fprintf(fid,'%10.3f\t',buildingGeometry.floorHeights(i - 1));
        fprintf(fid,'%10.3f',Za);
        fprintf(fid,'%s\n',';');
    end
    fprintf(fid,'%s\n','');

    % Defining fixitiy of master nodes
    fprintf(fid,'%s\n','# Defining fixitiy of master nodes');
    % Looping over number of floor levels
    for i = 2:(buildingGeometry.numberOfStories + 1)
        fprintf(fid,'%s\t','fix');
        fprintf(fid,'%s\t',strcat(num2str(i),num2str(9999)));
        fprintf(fid,'%s\n','0 1 0 1 0 1;');
    end
    fprintf(fid,'%s\n','');

    % Define Rigid Diaphram, dof 2 is normal to floor
    fprintf(fid,'%s\n','# Define Rigid Diaphram, dof 2 is normal to floor');
    fprintf(fid,'%s\n','set perpDirn 2;');
    fprintf(fid,'%s\n','');

    % Looping over number of floor levels
    for i = 2:(buildingGeometry.numberOfStories + 1)
        fprintf(fid,'%s\t','rigidDiaphragm	$perpDirn');
        fprintf(fid,'%s\t',strcat(num2str(i),num2str(9999)));
        % Looping over number of Z-Direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over X-Direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                fprintf(fid,'%s\t',jointNodes{i,k,j}.openSeesTag);
            end        
        end
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','');

    fprintf(fid,'%s\n','puts "rigid diaphragm constraints defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);

end

