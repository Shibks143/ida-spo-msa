% This function is used to generate the tcl file that defines all recorders
% for a 3D Model in OpenSees  

function defineAllRecorders3DModel(BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generating Tcl File with All Recorders Defined                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Go to model data direction
    cd(BuildingModelDirectory)

    % Make folder used to store OpenSees models
    cd OpenSees3DModels
    cd(AnalysisType)

    % Opening and defining Tcl file
    fid = fopen('DefineAllRecorders3DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define all recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Setting up folders
    fprintf(fid,'%s\n','# Setting up folders');
    fprintf(fid,'%s\n','set baseDir [pwd];');
    fprintf(fid,'%s\t','cd');
    fprintf(fid,'%s\n','$baseDir/$dataDir/');
    fprintf(fid,'%s\n','');
    
    if strcmp(AnalysisType,'DynamicAnalysis') == 1
        fprintf(fid,'%s\n','file mkdir EQ_$eqNumber');
        fprintf(fid,'%s\t','cd');
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber'));
        fprintf(fid,'%s\n','file mkdir Scale_$scale');
        fprintf(fid,'%s\t','cd');
        fprintf(fid,'%s\n',strcat('$baseDir/$dataDir/EQ_$eqNumber/',...
            'Scale_$scale'));
    end
    fprintf(fid,'%s\n','');
    
    % Create output folders
    fprintf(fid,'%s\n','file mkdir BaseReactions');
    fprintf(fid,'%s\n','file mkdir BeamHingeMoment');
    fprintf(fid,'%s\n','file mkdir BeamHingeDeformations');
    fprintf(fid,'%s\n','file mkdir ColumnHingeMoment');
    fprintf(fid,'%s\n','file mkdir ColumnHingeDeformations');
    fprintf(fid,'%s\n','file mkdir GlobalBeamForces');
    fprintf(fid,'%s\n','file mkdir GlobalColumnForces');
    fprintf(fid,'%s\n','file mkdir InfillStrutForces');
    fprintf(fid,'%s\n','file mkdir InfillStrutDeformations');   
    fprintf(fid,'%s\n','file mkdir NodeDisplacements');
    fprintf(fid,'%s\n','file mkdir NodeAccelerations');
    fprintf(fid,'%s\n','file mkdir StoryDrifts');
%     fprintf(fid,'%s\n','cd StoryDrifts');
%     for i = 1:buildingGeometry.numberOfStories
%         fprintf(fid,'%s\n',strcat('file mkdir Story',num2str(i)));
%     end
%     fprintf(fid,'%s\n',strcat('file mkdir Roof'));
%     fprintf(fid,'%s\n','');
    
    % Source recorder files
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineBaseReactionRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineBeamHingeRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineColumnHingeRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineGlobalBeamForceRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineGlobalColumnForceRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineNodeDisplacementRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');    
    fprintf(fid,'%s\n','source DefineStoryDriftRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineInfillStrutRecorders3DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    if strcmp(AnalysisType,'DynamicAnalysis') == 1
        fprintf(fid,'%s\n','source DefineNodeAccelerationRecorders3DModel.tcl');
        fprintf(fid,'%s\n','cd $baseDir');
    end
        
    % Closing and saving tcl file
    fclose(fid);

end

