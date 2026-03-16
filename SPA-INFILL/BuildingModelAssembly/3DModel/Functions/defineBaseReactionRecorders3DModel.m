% This function is used to generate the tcl file that defines recorders for
% base node reactions
function defineBaseReactionRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generating Tcl File with Defined Base Reaction Recorders            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineBaseReactionRecorders3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# Define base node reaction recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Define base node reaction recorders
    % Changing directory to output location
    fprintf(fid,'%s\t','cd');
    if strcmp(AnalysisType,'PushoverAnalysis') == 1
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/BaseReactions'));
        fprintf(fid,'%s\n','');
    else
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale/BaseReactions'));
        fprintf(fid,'%s\n','');
    end
    % Define vertical base node vertical reactions
    fprintf(fid,'%s\n','# Vertical Reactions');
    fprintf(fid,'%s\t','recorder Node -file');
    fprintf(fid,'%s\t','VerticalReactions.out');
    fprintf(fid,'%s\t','-time -node');
    % Looping over number of Z-Direction column lines
    for j = 1:(buildingGeometry.numberOfZBays + 1)
        % Looping over X-Direction column lines
        for k = 1:(buildingGeometry.numberOfXBays + 1)
            fprintf(fid,'%s\t',jointNodes{1,k,j}.openSeesTag);
        end
    end
    fprintf(fid,'%s\n','-dof 2 reaction');
    fprintf(fid,'%s\n','');

    % Define X-Direction base node vertical reactions 
    fprintf(fid,'%s\n','# X-Direction Reactions');
    fprintf(fid,'%s\t','recorder Node -file');
    fprintf(fid,'%s\t','XReactions.out');
    fprintf(fid,'%s\t','-time -node');

    % Looping over number of Z-Direction column lines
    for j = 1:(buildingGeometry.numberOfZBays + 1)
        % Looping over X-Direction column lines
        for k = 1:(buildingGeometry.numberOfXBays + 1)
            fprintf(fid,'%s\t',jointNodes{1,k,j}.openSeesTag);
        end
    end
    fprintf(fid,'%s\n','-dof 1 reaction');
    fprintf(fid,'%s\n','');

    % Define Z-Direction base node vertical reactions 
    fprintf(fid,'%s\n','# Z-Direction Reactions');
    fprintf(fid,'%s\t','recorder Node -file');
    fprintf(fid,'%s\t','ZReactions.out');
    fprintf(fid,'%s\t','-time -node');

    % Looping over number of Z-Direction column lines
    for j = 1:(buildingGeometry.numberOfZBays + 1)
        % Looping over X-Direction column lines
        for k = 1:(buildingGeometry.numberOfXBays + 1)
            fprintf(fid,'%s\t',jointNodes{1,k,j}.openSeesTag);
        end
    end
    fprintf(fid,'%s\n','-dof 3 reaction');

    % Closing and saving tcl file
    fclose(fid);

end

