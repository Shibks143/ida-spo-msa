% This function is used to generate the tcl file that defines recorders for
% beam hinges
function defineBeamHingeRecordersXDirection2DModel(buildingGeometry,...
    xBeamHingeObjects,FrameLineNumber,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generating Tcl File with Defined Beam Hinge Recorders           %
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
    fid = fopen('DefineBeamHingeRecorders2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define beam hinge force-deformation recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define force recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/BeamHingeMoment'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/BeamHingeMoment'));
        fprintf(fid,'%s\n','');
    end

    % Defining recorders for X-Direction beam hinge elements
    fprintf(fid,'%s\n','# X-Direction beam hinge element force recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('XBeamHingeForcesLevel',...
            num2str(i + 1),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of X-direction column lines
        for j = 1:buildingGeometry.numberOfXBays
            % Define beam hinge at start node
            fprintf(fid,'%s\t',xBeamHingeObjects{i,j,FrameLineNumber}. ...
                startHingeOpenSeesTag);      
            % Define beam hinge at end node
            fprintf(fid,'%s\t',...
                    xBeamHingeObjects{i,j,FrameLineNumber}. ...
                    endHingeOpenSeesTag);
        end
        fprintf(fid,'%s\n','force');    
    end
    fprintf(fid,'%s\n','');

    % Define deformation recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/BeamHingeDeformations'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/BeamHingeDeformations'));
        fprintf(fid,'%s\n','');
    end

    % Defining recorders for X-Direction beam hinge elements
    fprintf(fid,'%s\n','# X-Direction beam hinge element deformation recorders');
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('XBeamHingeDeformationsLevel',...
            num2str(i + 1),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:buildingGeometry.numberOfXBays
            % Define beam hinge at start node
            fprintf(fid,'%s\t',xBeamHingeObjects{i,j,FrameLineNumber}. ...
                startHingeOpenSeesTag);      
            % Define beam hinge at end node
            fprintf(fid,'%s\t',xBeamHingeObjects{i,j,FrameLineNumber}. ...
                endHingeOpenSeesTag);
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');

    % Closing and saving tcl file
    fclose(fid);
end

