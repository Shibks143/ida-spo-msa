% This function is used to generate the tcl file that defines the story
% driftrecorder for a 3D Model in OpenSees  

function defineStoryDriftRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generating Tcl File with Defined Story Drift Recorders           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)
    
    % Opening and defining Tcl file
    fid = fopen('DefineStoryDriftRecorders3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define story drift recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/StoryDrifts'));
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/StoryDrifts'));
    end
    fprintf(fid,'%s\n','');

    % Defining X-Direction Story Drift Recorders
    fprintf(fid,'%s\n','# X-Direction Story Drifts');
    % Looping over number of floor levels
    for i = 1:buildingGeometry.numberOfStories
        if strcmp(AnalysisType,'PushoverAnalysis') == 1
            fprintf(fid,'%s\t','recorder Drift -file');
            fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
                'StoryDrifts/StoryX',num2str(i),'.out'));
        else
            fprintf(fid,'%s\t','recorder Drift -file');
            fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
                'EQ_$eqNumber/Scale_$scale/StoryDrifts/StoryX',...
                num2str(i),'.out'));
        end
        fprintf(fid,'%s\t','-time -iNode');
        fprintf(fid,'%s\t',jointNodes{i,1,1}.openSeesTag);
        fprintf(fid,'%s\t','-jNode');
        fprintf(fid,'%s\t',jointNodes{i + 1,1,1}.openSeesTag);
        fprintf(fid,'%s\n','-dof 1 -perpDorn 2');
    end

    % Roof drift recorder
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\t','recorder Drift -file');
        fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
            'StoryDrifts/RoofX.out'));
    else
        fprintf(fid,'%s\t','recorder Drift -file');
        fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
            'EQ_$eqNumber/Scale_$scale/StoryDrifts/RoofX.out'));
    end
    fprintf(fid,'%s\t','-time -iNode');
    fprintf(fid,'%s\t',jointNodes{1,1,1}.openSeesTag);
    fprintf(fid,'%s\t','-jNode');
    fprintf(fid,'%s\t',jointNodes{buildingGeometry.numberOfStories + 1,...
                1,1}.openSeesTag);
    fprintf(fid,'%s\n','-dof 1 -perpDorn 2');
    fprintf(fid,'%s\n','');
        
        

    % Defining Z-Direction Story Drift Recorders
    fprintf(fid,'%s\n','# Z-Direction Story Drifts');
    % Looping over number of floor levels
    for i = 1:buildingGeometry.numberOfStories
        if strcmp(AnalysisType,'PushoverAnalysis') == 1
            fprintf(fid,'%s\t','recorder Drift -file');
            fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
                'StoryDrifts/StoryZ',num2str(i),'.out'));
        else
            fprintf(fid,'%s\t','recorder Drift -file');
            fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
                'EQ_$eqNumber/Scale_$scale/StoryDrifts/StoryZ',...
                num2str(i),'.out'));
        end
        fprintf(fid,'%s\t','-time -iNode');
        fprintf(fid,'%s\t',jointNodes{i,1,1}.openSeesTag);
        fprintf(fid,'%s\t','-jNode');
        fprintf(fid,'%s\t',jointNodes{i + 1,1,1}.openSeesTag);
        fprintf(fid,'%s\n','-dof 3 -perpDorn 2');
    end

    % Roof drift recorder
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\t','recorder Drift -file');
        fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
            'StoryDrifts/RoofZ.out'));
    else
        fprintf(fid,'%s\t','recorder Drift -file');
        fprintf(fid,'%s\t',strcat('$baseDir/$dataDir/',...
            'EQ_$eqNumber/Scale_$scale/StoryDrifts/RoofZ.out'));
    end
    fprintf(fid,'%s\t','-time -iNode');
    fprintf(fid,'%s\t',jointNodes{1,1,1}.openSeesTag);
    fprintf(fid,'%s\t','-jNode');
    fprintf(fid,'%s\t',jointNodes{buildingGeometry.numberOfStories + 1,...
                1,1}.openSeesTag);
    fprintf(fid,'%s\n','-dof 3 -perpDorn 2');

    % Closing and saving tcl file
    fclose(fid);

end

