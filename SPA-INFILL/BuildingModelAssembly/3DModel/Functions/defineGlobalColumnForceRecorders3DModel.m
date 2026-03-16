% This function is used to generate the tcl file that defines global beam
% force recorders
function defineGlobalColumnForceRecorders3DModel(buildingGeometry,...
    columnObjects,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generating Tcl File with Defined Global Beam Force Recorders      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineGlobalColumnForceRecorders3DModel.tcl','wt');

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
    fprintf(fid,'%s\n','');

    % Defining global force recorders for column elements
    fprintf(fid,'%s\n','# X-Direction beam element global force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('GlobalColumnForcesStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction column lines
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                % Define beam force recorder
                fprintf(fid,'%s\t',columnObjects{i,k,j}.openSeesTag);
            end
        end
        fprintf(fid,'%s\n','force');    
    end
    fprintf(fid,'%s\n','');
    % Closing and saving tcl file
    fclose(fid);
end

