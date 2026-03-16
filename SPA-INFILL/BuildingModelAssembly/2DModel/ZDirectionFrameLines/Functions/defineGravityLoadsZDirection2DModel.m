% This function is used to generate the tcl file that defines all 
% gravity loads for a 3D Model in OpenSees        

function defineGravityLoadsZDirection2DModel(buildingGeometry,...
    jointNodes,buildingLoads,zBeamObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,columnObjects,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generating Tcl File with Gravity Loads Defined              %
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
    fid = fopen('DefineGravityLoads2DModel.tcl','wt');

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
        fprintf(fid,'%s\n',strcat('# Level ',num2str(i + 1)));
        % Looping over the number of Z-direction bays
        for j = 1:(buildingGeometry.numberOfZBays)
            fprintf(fid,'%s\t','eleLoad -ele');
            fprintf(fid,'%s\t',zBeamObjects{i,FrameLineNumber,j}. ...
                openSeesTag);
            fprintf(fid,'%s\t','-type -beamUniform');
            fprintf(fid,'%10.3f',zBeamObjects{i,FrameLineNumber,j}. ...
                uniformZBeamLoads);
            fprintf(fid,'%s\n',';');
            fprintf(fid,'%s\n','');
        end
    end
    
    % Define column point loads from out-of-plane beams
    fprintf(fid,'%s\n','# Define column point loads from out-of-plane beams');
    % Looping over the number of Z-direction column lines
    for j = 1:(buildingGeometry.numberOfZBays + 1)
        fprintf(fid,'%s\n',strcat('# Pier',num2str(j)));
        % Looping over all stories
        for i = 1:buildingGeometry.numberOfStories
            fprintf(fid,'%s\t','load');
            fprintf(fid,'%s\t',jointNodes{i + 1,FrameLineNumber,j}. ...
                openSeesTag);
            fprintf(fid,'%u\t',0);
            fprintf(fid,'%10.3f\t',columnObjects{i,FrameLineNumber,j}. ...
                    pointLoadsFor2DModels);
            fprintf(fid,'%s\n',strcat(num2str(0),';')); 
        end
        fprintf(fid,'%s\n','');
    end
          
    % Define point loads on leaning columns
    fprintf(fid,'%s\n','# Point loads on leaning columns');
    for i = 1:buildingGeometry.numberOfStories
        fprintf(fid,'%s\t','load');
        if buildingGeometry.numberOfStories > 8
            fprintf(fid,'%s\t',...
                num2str(leaningColumnNodeObjects.jointNodes(i + 1)));
        else
            fprintf(fid,'%s\t',strcat(num2str(buildingGeometry. ...
            numberOfZBays + 2),num2str(i + 1)));
        end
        fprintf(fid,'%u\t',0);
        fprintf(fid,'%10.3f\t',buildingLoads. ...
            zFrameLineLeaningColumnLoads(i,...
            FrameLineNumber));
        fprintf(fid,'%s\n',strcat(num2str(0),';'));        
    end
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','}');
    % Closing and saving tcl file
    fclose(fid);
end

