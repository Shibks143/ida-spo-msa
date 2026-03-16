% This function is used to generate the tcl file that defines the beam
% hinges for a 3D Model in OpenSees     
function defineBeamHinges3DModel(buildingGeometry,...
    xBeamHingeObjects,zBeamHingeObjects,BuildingModelDirectory,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Generating Tcl File with Beam Hinges Defined              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)
    
    % Opening and defining Tcl file
    fid = fopen('DefineBeamHinges3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define beam hinges');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining beam hinge materials
    fprintf(fid,'%s\n','# Define beam hinges');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        % Defining X-Direction beam hinges
        fprintf(fid,'%s\n','# X-Direction beam hinges');
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:buildingGeometry.numberOfXBays
                % Hinge at start of beam
                fprintf(fid,'%s\t','rotXBeamSpring3DModIKModel');
                fprintf(fid,'%s\t',...
                    xBeamHingeObjects{i,k,j}.startHingeOpenSeesTag);  
                fprintf(fid,'%s\t',...
                    xBeamHingeObjects{i,k,j}.startJointNodeOpenSeesTag);  
                fprintf(fid,'%s\t',...
                    xBeamHingeObjects{i,k,j}.startHingeNodeOpenSeesTag);  
                fprintf(fid,'%s\t',strcat(...
                    '$XDirectionBeamHingeMatLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k))); 
                fprintf(fid,'%s','$StiffMat');
                fprintf(fid,'%s\n',';'); 

                % Hinge at start of beam
                fprintf(fid,'%s\t','rotXBeamSpring3DModIKModel');
                fprintf(fid,'%s\t',...
                    xBeamHingeObjects{i,k,j}.endHingeOpenSeesTag);  
                fprintf(fid,'%s\t',...
                    xBeamHingeObjects{i,k,j}.endJointNodeOpenSeesTag);  
                fprintf(fid,'%s\t',...
                    xBeamHingeObjects{i,k,j}.endHingeNodeOpenSeesTag);  
                fprintf(fid,'%s\t',strcat(...
                    '$XDirectionBeamHingeMatLevel',...
                num2str(i + 1),'ZColumnLine',num2str(j),'Bay',num2str(k))); 
                fprintf(fid,'%s','$StiffMat');
                fprintf(fid,'%s\n',';'); 
            end
        end
        fprintf(fid,'%s\n',';'); 

        % Defining Z-Direction beam hinges
        fprintf(fid,'%s\n','# Z-Direction beam hinges');
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays)
            % Looping over the number of X-direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                % Hinge at start of beam
                fprintf(fid,'%s\t','rotZBeamSpring3DModIKModel');
                fprintf(fid,'%s\t',...
                    zBeamHingeObjects{i,k,j}.startHingeOpenSeesTag);  
                fprintf(fid,'%s\t',...
                    zBeamHingeObjects{i,k,j}.startJointNodeOpenSeesTag);  
                fprintf(fid,'%s\t',...
                    zBeamHingeObjects{i,k,j}.startHingeNodeOpenSeesTag);  
                fprintf(fid,'%s\t',strcat(...
                    '$ZDirectionBeamHingeMatLevel',...
                num2str(i + 1),'XColumnLine',num2str(k),'Bay',num2str(j))); 
                fprintf(fid,'%s','$StiffMat');
                fprintf(fid,'%s\n',';'); 

                % Hinge at start of beam
                fprintf(fid,'%s\t','rotZBeamSpring3DModIKModel');
                fprintf(fid,'%s\t',...
                    zBeamHingeObjects{i,k,j}.endHingeOpenSeesTag);  
                fprintf(fid,'%s\t',...
                    zBeamHingeObjects{i,k,j}.endJointNodeOpenSeesTag);  
                fprintf(fid,'%s\t',...
                    zBeamHingeObjects{i,k,j}.endHingeNodeOpenSeesTag);  
                fprintf(fid,'%s\t',strcat(...
                    '$ZDirectionBeamHingeMatLevel',...
                num2str(i + 1),'XColumnLine',num2str(k),'Bay',num2str(j))); 
                fprintf(fid,'%s','$StiffMat');
                fprintf(fid,'%s\n',';'); 
            end
        end
    end
    fprintf(fid,'%s\n','puts "beam hinges defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

