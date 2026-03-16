% This function is used to generate the tcl file that defines the node
% acceleration recorder for a 3D Model in OpenSees        

function defineNodeAccelerationRecordersZDirection2DModel(...
    buildingGeometry,jointNodes,FrameLineNumber,BuildingModelDirectory,...
    AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generating Tcl File with Defined Node Acceleration Recorders       %
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
    fid = fopen('DefineNodeAccelerationRecorders2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define node acceleration recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/NodeAccelerations'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/NodeAccelerations'));
        fprintf(fid,'%s\n','');
    end

    % Defining recorders
    % Looping over number of floor levels
    for i = 1:(buildingGeometry.numberOfStories + 1)
        fprintf(fid,'%s\t','recorder Node -file');
        fprintf(fid,'%s\t',strcat('NodeAccLevel',num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -node');
        % Looping over number of Z-Direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1) 
            if (i == 1)
                fprintf(fid,'%s\t',strcat(...
                        jointNodes{i,FrameLineNumber,j}.openSeesTag,...
                        num2str(4)));
            else
                fprintf(fid,'%s\t',jointNodes{i,FrameLineNumber,j}. ...
                    openSeesTag);
            end
        end
        fprintf(fid,'%s\n','-dof 1 2 3 accel');
    end

    % Closing and saving tcl file
    fclose(fid);

end

