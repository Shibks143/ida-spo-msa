% This function is used to generate the tcl file that defines all 
% gravity loads for a 3D Model in OpenSees        

function defineGravityLoads3DModel(buildingGeometry,buildingLoads,...
    xBeamObjects,zBeamObjects,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generating Tcl File with Gravity Loads Defined              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)
        
    % Opening and defining Tcl file
    fid = fopen('DefineGravityLoads3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define gravity loads');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define beam uniform loads
    fprintf(fid,'%s\n','# Define uniform loads on beams');
    fprintf(fid,'%s\n','pattern Plain 101 Constant {');
    fprintf(fid,'%s\n','');

    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\n',strcat('# Beam Loading Level ', num2str(i + 1)));
        % Defining uniform loading on X-Direction beams
        fprintf(fid,'%s\n','# X-Direction Beam Loading');
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
           % Looping over the number of X-direction bays
           for k = 1:(buildingGeometry.numberOfXBays)
               fprintf(fid,'%s\t','eleLoad -ele');
               fprintf(fid,'%s\t',xBeamObjects{i,k,j}.openSeesTag);
               fprintf(fid,'%s\t','-type -beamUniform');
               fprintf(fid,'%10.3f\t',xBeamObjects{i,k,j}. ...
                   uniformXBeamLoads);
               fprintf(fid,'%10.3f',0);
               fprintf(fid,'%s\n',';');
           end
           fprintf(fid,'%s\n','');
        end

        % Defining uniform loading on Z-Direction beams
        fprintf(fid,'%s\n','# Z-Direction Beam Loading');
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays)
           % Looping over the number of X-direction column lines
           for k = 1:(buildingGeometry.numberOfXBays + 1)
               fprintf(fid,'%s\t','eleLoad -ele');
               fprintf(fid,'%s\t',zBeamObjects{i,k,j}.openSeesTag);
               fprintf(fid,'%s\t','-type -beamUniform');
               fprintf(fid,'%10.3f\t',zBeamObjects{i,k,j}. ...
                   uniformZBeamLoads);
               fprintf(fid,'%10.3f',0);
               fprintf(fid,'%s\n',';');
           end
           fprintf(fid,'%s\n','');
        end

    end
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    fprintf(fid,'%s\n','}');

    % Closing and saving tcl file
    fclose(fid);
end

