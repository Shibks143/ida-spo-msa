% This function is used to generate the tcl file that defines the node
% displacement recorder for a 3D Model in OpenSees        

function defineNodeDisplacementRecorders3DModel(buildingGeometry,...
    jointNodes,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generating Tcl File with Defined Node Displacement Recorders       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)
    
    % Opening and defining Tcl file
    fid = fopen('DefineNodeDisplacementRecorders3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define node displacement recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/NodeDisplacements'));
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/NodeDisplacements'));
    end
    fprintf(fid,'%s\n','');

    % Defining recorders
    % Looping over number of floor levels
    for i = 1:(buildingGeometry.numberOfStories + 1)
        fprintf(fid,'%s\t','recorder Node -file');
        fprintf(fid,'%s\t',strcat('NodeDispLevel',num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -node');
        % Looping over number of Z-Direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over X-Direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1) 
                if (i == 1)
                    fprintf(fid,'%s\t',strcat(...
                        jointNodes{i,k,j}.openSeesTag,num2str(4)));
                else
                    fprintf(fid,'%s\t',jointNodes{i,k,j}.openSeesTag);
                end
            end
        end
        fprintf(fid,'%s\n','-dof 1 2 3 disp');
    end

    % Closing and saving tcl file
    fclose(fid);

end

