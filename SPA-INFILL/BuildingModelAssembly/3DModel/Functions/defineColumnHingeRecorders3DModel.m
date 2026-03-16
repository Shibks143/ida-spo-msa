% This function is used to generate the tcl file that defines recorders for
% beam hinges
function defineColumnHingeRecorders3DModel(buildingGeometry,...
    columnHingeObjects,BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generating Tcl File with Defined Beam Hinge Recorders           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineColumnHingeRecorders3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define column hinge force-deformation recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define force recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/ColumnHingeMoment'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/ColumnHingeMoment'));
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','');

    % Defining recorders for column hinge elements
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('ColumnHingeForcesStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                % Define column hinge at bottom of story
                fprintf(fid,'%s\t',...
                    columnHingeObjects{i,k,j}.startHingeOpenSeesTag);      
                % Define column hinge at top of story
                fprintf(fid,'%s\t',...
                    columnHingeObjects{i,k,j}.endHingeOpenSeesTag);
            end
        end
        fprintf(fid,'%s\n','force');    
    end
    fprintf(fid,'%s\n','');

    % Define deformation recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/',...
            'ColumnHingeDeformations'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/ColumnHingeDeformations'));
        fprintf(fid,'%s\n','');
    end
    fprintf(fid,'%s\n','');

    % Defining recorders for column hinge elements
    % Looping over all stories
    for i = 1:buildingGeometry.numberOfStories 
        fprintf(fid,'%s\t','recorder Element -file'); 
        fprintf(fid,'%s\t',strcat('ColumnHingeDeformationsStory',...
            num2str(i),'.out'));
        fprintf(fid,'%s\t','-time -ele');     
        % Looping over the number of Z-direction column lines
        for j = 1:(buildingGeometry.numberOfZBays + 1)
            % Looping over the number of X-direction bays
            for k = 1:(buildingGeometry.numberOfXBays + 1)
                % Define column hinge at bottom of story
                fprintf(fid,'%s\t',...
                    columnHingeObjects{i,k,j}.startHingeOpenSeesTag);      
                % Define column hinge at top of story
                fprintf(fid,'%s\t',...
                    columnHingeObjects{i,k,j}.endHingeOpenSeesTag);
            end
        end
        fprintf(fid,'%s\n','deformation');    
    end
    fprintf(fid,'%s\n','');
    
    % Closing and saving tcl file
    fclose(fid);
end

