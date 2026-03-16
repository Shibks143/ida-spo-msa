
% This function is used to generate the tcl file that defines the nodes for
% a 3D Model in OpenSees        

function defineNodes3DModel(BuildingModelDirectory,buildingGeometry,...
    jointNodes,columnHingeObjects,xBeamHingeObjects,zBeamHingeObjects,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodes                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineNodes3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define all nodes');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining nodes at corner of frames
    fprintf(fid,'%s\n','# Define nodes at corner of frames');
    % Looping over number of floor levels
    for i = 1:(buildingGeometry.numberOfStories + 1)
        fprintf(fid,'%s\n',strcat('# Level ', num2str(i)));
        % Looping over number of Z-Direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over X-Direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                fprintf(fid,'%s\t','node');
                fprintf(fid,'%s\t',jointNodes{i,k,j}.openSeesTag);
                fprintf(fid,'%10.3f\t',jointNodes{i,k,j}.xCoordinate);
                fprintf(fid,'%10.3f\t',jointNodes{i,k,j}.yCoordinate);
                fprintf(fid,'%10.3f',jointNodes{i,k,j}.zCoordinate);
                fprintf(fid,'%s\n',';');
            end
            fprintf(fid,'%s\n','');
        end
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','puts "nodes at frame corners defined"');
    fprintf(fid,'%s\n','');

% Defining extra nodes used to define column hinge
fprintf(fid,'%s\n',strcat('# Define extra nodes needed to define column hinges'));
% Looping over number of stories
for i = 1:buildingGeometry.numberOfStories
    % Defining column hinge nodes at bottom of story
    fprintf(fid,'%s\n',strcat('# Bottom of story ', num2str(i)));
    % Loop over the number of Z-Direction column lines
    for j = 1:buildingGeometry.numberOfZBays + 1
        % Loop over number of X-Direction column lines
        for k = 1:buildingGeometry.numberOfXBays + 1
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',...
                columnHingeObjects{i,k,j}.startHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i,k,j}.xCoordinate);
            fprintf(fid,'%10.3f\t',jointNodes{i,k,j}.yCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i,k,j}.zCoordinate);
            fprintf(fid,'%s\n',';');
        end
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','');
    
    % Defining column hinge nodes at top of story
    fprintf(fid,'%s\n',strcat('# Top of story ', num2str(i)));
    % Loop over the number of Z-Direction column lines
    for j = 1:buildingGeometry.numberOfZBays + 1
        % Loop over number of X-Direction column lines
        for k = 1:buildingGeometry.numberOfXBays + 1
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',...
                columnHingeObjects{i,k,j}.endHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k,j}.xCoordinate);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k,j}.yCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i + 1,k,j}.zCoordinate);
            fprintf(fid,'%s\n',';');
        end
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','');
end
fprintf(fid,'%s\n','puts "extra nodes for column hinges defined"');
fprintf(fid,'%s\n','');

% Defining extra nodes used to define beam hinges
fprintf(fid,'%s\n',strcat('# Define extra nodes needed to define beam hinges'));
fprintf(fid,'%s\n','');
% Loop over the number of stories
for i = 1:buildingGeometry.numberOfStories
    fprintf(fid,'%s\n',strcat('# Level ', num2str(i + 1)));
    % Defining hinges for X-Direction beams
    fprintf(fid,'%s\n','# Hinges in X-Direction beams');
    % Loop over the number of Z-Direction column lines
    for j = 1:buildingGeometry.numberOfZBays + 1
        % Loop over number of X-Direction bays
        for k = 1:buildingGeometry.numberOfXBays
            % Define beam hinge node at start of beam
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',...
                xBeamHingeObjects{i,k,j}.startHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k,j}.xCoordinate);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k,j}.yCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i + 1,k,j}.zCoordinate);  
            fprintf(fid,'%s\n',';');
            
            % Define beam hinge node at end of beam
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',...
                xBeamHingeObjects{i,k,j}.endHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k + 1,j}.xCoordinate);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k + 1,j}.yCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i + 1,k + 1,j}.zCoordinate);  
            fprintf(fid,'%s\n',';');           
        end
        fprintf(fid,'%s\n','');
    end
    
    % Defining hinges for Z-Direction beams
    fprintf(fid,'%s\n','# Hinges in Z-Direction beams');
    % Loop over the number of Z-Direction bays
    for j = 1:buildingGeometry.numberOfZBays
        % Loop over number of X-Direction column lines
        for k = 1:buildingGeometry.numberOfXBays + 1
            % Define beam hinge node at start of beam
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',...
                zBeamHingeObjects{i,k,j}.startHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k,j}.xCoordinate);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k,j}.yCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i + 1,k,j}.zCoordinate);  
            fprintf(fid,'%s\n',';');
            
            % Define beam hinge node at end of beam
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',...
                zBeamHingeObjects{i,k,j}.endHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k,j + 1}.xCoordinate);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,k,j + 1}.yCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i + 1,k,j + 1}.zCoordinate);  
            fprintf(fid,'%s\n',';');            
        end
        fprintf(fid,'%s\n','');
    end
end
fprintf(fid,'%s\n','puts "extra nodes for beam hinges defined"');


% Closing and saving tcl file
fclose(fid);

end