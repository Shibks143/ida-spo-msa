% This function is used to generate the tcl file that defines the beam
% hinges for a 3D Model in OpenSees     
function defineBeamHingesZDirection2DModel(buildingGeometry,...
    zBeamHingeObjects,FrameLineNumber,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Generating Tcl File with Beam Hinges Defined              %
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
    fid = fopen('DefineBeamHinges2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define beam hinges');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Defining beam hinge materials
    fprintf(fid,'%s\n','# Define beam hinges');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\n',strcat('# Level',num2str(i + 1)));        
        % Looping over the number of Z-direction bays
        for j = 1:buildingGeometry.numberOfZBays
            % Hinge at start of beam
            fprintf(fid,'%s\t','rotSpring2DModIKModel');
            fprintf(fid,'%s\t',zBeamHingeObjects{i,FrameLineNumber,j}. ...
                    startHingeOpenSeesTag);  
            fprintf(fid,'%s\t',zBeamHingeObjects{i,FrameLineNumber,j}. ...
                    startJointNodeOpenSeesTag);  
            fprintf(fid,'%s\t',zBeamHingeObjects{i,FrameLineNumber,j}. ...
                    startHingeNodeOpenSeesTag);  
            fprintf(fid,'%s',strcat('$ZDirectionBeamHingeMatLevel',...
                num2str(i + 1),'XColumnLine',num2str(FrameLineNumber),...
                'Bay',num2str(j))); 
%             fprintf(fid,'%s','$StiffMat');
            fprintf(fid,'%s\n',';'); 

            % Hinge at end of beam
            fprintf(fid,'%s\t','rotSpring2DModIKModel');
            fprintf(fid,'%s\t',zBeamHingeObjects{i,FrameLineNumber,j}. ...
                    endHingeOpenSeesTag);  
            fprintf(fid,'%s\t',zBeamHingeObjects{i,FrameLineNumber,j}. ...
                    endJointNodeOpenSeesTag);  
            fprintf(fid,'%s\t',zBeamHingeObjects{i,FrameLineNumber,j}. ...
                    endHingeNodeOpenSeesTag);  
            fprintf(fid,'%s',strcat('$ZDirectionBeamHingeMatLevel',...
                num2str(i + 1),'XColumnLine',num2str(FrameLineNumber),...
                'Bay',num2str(j))); 
%             fprintf(fid,'%s','$StiffMat');
            fprintf(fid,'%s\n',';'); 
       end
       fprintf(fid,'%s\n',''); 
    end
    fprintf(fid,'%s\n','puts "beam hinges defined"');
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

