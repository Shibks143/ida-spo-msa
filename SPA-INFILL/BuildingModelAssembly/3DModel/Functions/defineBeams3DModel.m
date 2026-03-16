% This function is used to generate the tcl file that defines the beams
% for a 3D Model in OpenSees     
function defineBeams3DModel(buildingGeometry,xBeamObjects,zBeamObjects,...
    ModelDataDirectory,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Generating Tcl File with Beams Defined                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(ModelDataDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)
    
    % Opening and defining Tcl file
    fid = fopen('DefineBeams3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define beams');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining beams
    fprintf(fid,'%s\n','# Define beams');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        % Defining X-Direction beams
        fprintf(fid,'%s\n','# X-Direction beams');
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:buildingGeometry.numberOfXBays
                % Defining beams
                fprintf(fid,'%s\t','element');
                fprintf(fid,'%s\t','elasticBeamColumn');        
                fprintf(fid,'%s\t',xBeamObjects{i,k,j}.openSeesTag);
                fprintf(fid,'%s\t',...
                    xBeamObjects{i,k,j}.startHingeNodeOpenSeesTag);
                fprintf(fid,'%s\t',...
                    xBeamObjects{i,k,j}.endHingeNodeOpenSeesTag);
                fprintf(fid,'%10.3f\t',xBeamObjects{i,k,j}.area);
                fprintf(fid,'%10.3f\t',xBeamObjects{i,k,j}.E);
                fprintf(fid,'%10.3f\t',1.0);
                fprintf(fid,'%10.3f\t',xBeamObjects{i,k,j}.GJ);
                fprintf(fid,'%10.3f\t',xBeamObjects{i,k,j}.Igtr*...
                    xBeamObjects{i,k,j}.EIeffOverEIg);
                fprintf(fid,'%10.3f\t',xBeamObjects{i,k,j}.Igtr*...
                    xBeamObjects{i,k,j}.EIeffOverEIg);
                fprintf(fid,'%s','$XBeamLinearTransf'); 
                fprintf(fid,'%s\n',';');
            end
        end
        
        % Defining Z-Direction beams
        fprintf(fid,'%s\n','# Z-Direction beams');
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays)
            % Looping over the number of X-direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                % Defining beams
                fprintf(fid,'%s\t','element');
                fprintf(fid,'%s\t','elasticBeamColumn');        
                fprintf(fid,'%s\t',zBeamObjects{i,k,j}.openSeesTag);
                fprintf(fid,'%s\t',...
                    zBeamObjects{i,k,j}.startHingeNodeOpenSeesTag);
                fprintf(fid,'%s\t',...
                    zBeamObjects{i,k,j}.endHingeNodeOpenSeesTag);
                fprintf(fid,'%10.3f\t',zBeamObjects{i,k,j}.area);
                fprintf(fid,'%10.3f\t',zBeamObjects{i,k,j}.E);
                fprintf(fid,'%10.3f\t',1.0);
                fprintf(fid,'%10.3f\t',zBeamObjects{i,k,j}.GJ);
                fprintf(fid,'%10.3f\t',zBeamObjects{i,k,j}.Igtr*...
                    zBeamObjects{i,k,j}.EIeffOverEIg);
                fprintf(fid,'%10.3f\t',zBeamObjects{i,k,j}.Igtr*...
                    zBeamObjects{i,k,j}.EIeffOverEIg);
                fprintf(fid,'%s','$ZBeamLinearTransf'); 
                fprintf(fid,'%s\n',';');
            end
        end
    end
    fprintf(fid,'%s\n','puts "beams defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

