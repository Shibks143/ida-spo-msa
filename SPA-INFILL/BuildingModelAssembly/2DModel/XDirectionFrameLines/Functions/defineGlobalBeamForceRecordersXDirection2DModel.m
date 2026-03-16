% This function is used to generate the tcl file that defines global beam
% force recorders
function defineGlobalBeamForceRecordersXDirection2DModel(...
    buildingGeometry,xBeamObjects,FrameLineNumber,BuildingModelDirectory,...
    AnalysisType)

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
    fid = fopen('DefineGlobalBeamForceRecorders2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define global beam force recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define force recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/GlobalBeamForces'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/GlobalBeamForces'));
        fprintf(fid,'%s\n','');
    end
    
    % Defining global force recorders for X-Direction beam elements
    fprintf(fid,'%s\n','# X-Direction beam element global force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('GlobalXBeamForcesLevel',...
            num2str(i + 1),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfXBays
            % Define beam force recorder
            fprintf(fid,'%s\t',xBeamObjects{i,j,FrameLineNumber}. ...
                openSeesTag);
        end
        fprintf(fid,'%s\n','force');    
    end
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

