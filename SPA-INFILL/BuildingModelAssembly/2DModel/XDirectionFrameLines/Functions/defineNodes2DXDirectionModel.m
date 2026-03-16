
% This function is used to generate the tcl file that defines the nodes for
% a 3D Model in OpenSees        

function defineNodes2DXDirectionModel(BuildingModelDirectory,...
    buildingGeometry,jointNodes,leaningColumnNodeObjects,...
    columnHingeObjects,xBeamHingeObjects,FrameLineNumber,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Generating Tcl File with Defined Nodes                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees2DModels
    cd XDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineNodes2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define all nodes');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining nodes at corner of frames
    fprintf(fid,'%s\n','# Define nodes at corner of frames');
    % Looping over number of floor levels
    for i = 1:(buildingGeometry.numberOfStories + 1)
        fprintf(fid,'%s\n',strcat('# Level ', num2str(i)));
        % Looping over number of x-direction frame lines
        for j = 1:(buildingGeometry.numberOfXBays + 1)
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',jointNodes{i,j,FrameLineNumber} ...
                .openSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i,j,FrameLineNumber}. ...
                xCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i,j,FrameLineNumber}. ...
                yCoordinate);                 
            fprintf(fid,'%s\n',';');
        end
        % Leaning column node
        fprintf(fid,'%s\t','node');
        if buildingGeometry.numberOfStories > 8
            fprintf(fid,'%s\t',num2str(...
                leaningColumnNodeObjects.jointNodes(i)));
        else
            fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i)));
        end
        fprintf(fid,'%10.3f\t',jointNodes{i,j,FrameLineNumber}. ...
            xCoordinate + 120);
        fprintf(fid,'%10.3f',jointNodes{i,j,FrameLineNumber}. ...
            yCoordinate);        
        fprintf(fid,'%s\n',';');
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
        % Loop over the number of x-Direction column lines
        for j = 1:buildingGeometry.numberOfXBays + 1
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',columnHingeObjects{i,j,...
                FrameLineNumber}.startHingeNodeOpenSeesTag);
                fprintf(fid,'%10.3f\t',jointNodes{i,j,...
                    FrameLineNumber}.xCoordinate);
                fprintf(fid,'%10.3f',jointNodes{i,j,...
                    FrameLineNumber}.yCoordinate);
                fprintf(fid,'%s\n',';');
        end
        if i ~= 1
            % Leaning column node
            fprintf(fid,'%s\t','node');
            if buildingGeometry.numberOfStories > 8
                fprintf(fid,'%s\t',num2str(...
                    leaningColumnNodeObjects.startHingeNodes(i)));
            else
                fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i),...
                num2str(4)));
            end            
            fprintf(fid,'%10.3f\t',jointNodes{i,j,FrameLineNumber}. ...
            xCoordinate + 120);
            fprintf(fid,'%10.3f',jointNodes{i,j,FrameLineNumber}. ...
            yCoordinate);  
            fprintf(fid,'%s\n',';');
        end
        fprintf(fid,'%s\n','');

        % Defining column hinge nodes at top of story
        fprintf(fid,'%s\n',strcat('# Top of story ', num2str(i)));
        % Loop over the number of x-Direction column lines
        for j = 1:buildingGeometry.numberOfXBays + 1
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',columnHingeObjects{i,j,FrameLineNumber}. ...
                endHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,j,FrameLineNumber}. ...
                xCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i + 1,j,FrameLineNumber}. ...
                yCoordinate);
            fprintf(fid,'%s\n',';');
        end
        % Leaning column node
        fprintf(fid,'%s\t','node');
        if buildingGeometry.numberOfStories > 8
                fprintf(fid,'%s\t',num2str(...
                    leaningColumnNodeObjects.endHingeNodes(i)));
            else
                fprintf(fid,'%s\t',strcat(num2str(j + 1),num2str(i + 1),...
                num2str(2)));
        end   
        fprintf(fid,'%10.3f\t',jointNodes{i + 1,j,FrameLineNumber}. ...
            xCoordinate + 120);
        fprintf(fid,'%10.3f',jointNodes{i + 1,j,FrameLineNumber}. ...
            yCoordinate);  
        fprintf(fid,'%s\n',';');        
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
        % Loop over the number of x-Direction bays
        for j = 1:buildingGeometry.numberOfXBays
            % Define beam hinge node at start of beam
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',xBeamHingeObjects{i,j,FrameLineNumber}. ...
                startHingeNodeOpenSeesTag);
            fprintf(fid,'%10.3f\t',jointNodes{i + 1,j,FrameLineNumber}. ...
                xCoordinate);
            fprintf(fid,'%10.3f',jointNodes{i + 1,j,FrameLineNumber}. ...
                yCoordinate);
            fprintf(fid,'%s\n',';');

            % Define beam hinge node at end of beam
            fprintf(fid,'%s\t','node');
            fprintf(fid,'%s\t',...
                    xBeamHingeObjects{i,j,FrameLineNumber}. ...
                    endHingeNodeOpenSeesTag);
                fprintf(fid,'%10.3f\t',jointNodes{i + 1,j + 1,...
                    FrameLineNumber}.xCoordinate);
                fprintf(fid,'%10.3f',jointNodes{i + 1,j + 1,...
                    FrameLineNumber}.yCoordinate);
                fprintf(fid,'%s\n',';');            
        end
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','puts "extra nodes for beam hinges defined"');

    % Closing and saving tcl file
    fclose(fid);

end