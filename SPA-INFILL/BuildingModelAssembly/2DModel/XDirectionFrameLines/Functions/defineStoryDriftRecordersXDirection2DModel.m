% This function is used to generate the tcl file that defines the story
% driftrecorder for a 3D Model in OpenSees  

function defineStoryDriftRecordersXDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,ModelDataDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generating Tcl File with Defined Story Drift Recorders           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(ModelDataDirectory)

    % Go to folder used to store OpenSees models
    cd OpenSees2DModels
    cd XDirectionFrameLines
    FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
    cd(FrameLineModelFolder)
    cd(AnalysisType)
    
    % Opening and defining Tcl file
    fid = fopen('DefineStoryDriftRecorders2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define story drift recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/StoryDrifts'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/StoryDrifts'));
        fprintf(fid,'%s\n','');
    end

    % Defining X-Direction Story Drift Recorders
    % Looping over number of floor levels
    for i = 1:buildingGeometry.numberOfStories
        if strcmp(AnalysisType,'PushoverAnalysis') == 1
            fprintf(fid,'%s\t','recorder Drift -file');
            fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/StoryDrifts/',...
                'Story',num2str(i),'.out'));
        else
            fprintf(fid,'%s\t','recorder Drift -file');
            fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
                        'EQ_$eqNumber/Scale_$scale/StoryDrifts/Story',...
                        num2str(i),'.out'));
        end
            
        fprintf(fid,'%s\t','-time -iNode');
        fprintf(fid,'%s\t',jointNodes{i,1,FrameLineNumber}.openSeesTag);
        fprintf(fid,'%s\t','-jNode');
        fprintf(fid,'%s\t',jointNodes{i + 1,1,FrameLineNumber}. ...
                openSeesTag);
        fprintf(fid,'%s\n','-dof 1 -perpDorn 2');
        fprintf(fid,'%s\n','');
    end

    % Looping over number of Z-Direction column lines
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\t','recorder Drift -file');
        fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/StoryDrifts/',...
            'Roof.out'));
    else
        fprintf(fid,'%s\t','recorder Drift -file');
        fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/StoryDrifts/',...
            'Roof.out'));
    end

    fprintf(fid,'%s\t','-time -iNode');
    fprintf(fid,'%s\t',jointNodes{1,1,FrameLineNumber}.openSeesTag);
    fprintf(fid,'%s\t','-jNode');
    fprintf(fid,'%s\t',jointNodes{buildingGeometry.numberOfStories + 1,...
                1,FrameLineNumber}.openSeesTag);
    fprintf(fid,'%s\n','-dof 1 -perpDorn 2');
    fprintf(fid,'%s\n','');   

    % Closing and saving tcl file
    fclose(fid);

end

