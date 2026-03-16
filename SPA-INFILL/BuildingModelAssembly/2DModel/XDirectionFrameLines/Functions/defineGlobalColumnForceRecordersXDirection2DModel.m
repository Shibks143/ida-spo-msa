% This function is used to generate the tcl file that defines global beam
% force recorders
function defineGlobalColumnForceRecordersXDirection2DModel(...
    buildingGeometry,columnObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generating Tcl File with Defined Global Beam Force Recorders      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd XDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)  

    % Opening and defining Tcl file
    fid = fopen('DefineGlobalColumnForceRecorders2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define global column force recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define force recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/GlobalColumnForces'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/GlobalColumnForces'));
        fprintf(fid,'%s\n','');
    end

    % Defining global force recorders for column elements
    fprintf(fid,'%s\n','# X-Direction beam element global force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('GlobalColumnForcesStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfXBays + 1)
            % Define beam force recorder
            fprintf(fid,'%s\t',columnObjects{i,j,FrameLineNumber}. ...
                openSeesTag);
        end
        % Leaning column
        if i ~= 1
            if buildingGeometry.numberOfStories > 8
                fprintf(fid,'%s\t',strcat(num2str(3),...
                    num2str(leaningColumnNodeObjects.startHingeNodes(i)...
                    ),num2str(leaningColumnNodeObjects.endHingeNodes(i))));
            else                
            fprintf(fid,'%s\t',strcat(num2str(3),num2str(j + 1),...
                num2str(i),num2str(4),num2str(j + 1),num2str(i + 1),...
                num2str(2)));
            end
        else
            if buildingGeometry.numberOfStories > 8
                fprintf(fid,'%s\t',strcat(num2str(3),...
                    num2str(leaningColumnNodeObjects.jointNodes(i)...
                    ),num2str(leaningColumnNodeObjects.endHingeNodes(i))));
            else                
            fprintf(fid,'%s\t',strcat(num2str(3),num2str(j + 1),...
                num2str(i),num2str(j + 1),num2str(i + 1),num2str(2)));
            end
            
        end        
        fprintf(fid,'%s\n','force');    
    end
    fprintf(fid,'%s\n','');
    % Closing and saving tcl file
    fclose(fid);
end

