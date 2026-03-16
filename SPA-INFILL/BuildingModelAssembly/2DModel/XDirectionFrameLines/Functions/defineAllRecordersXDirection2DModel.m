% This function is used to generate the tcl file that defines all recorders
% for a 3D Model in OpenSees  

function defineAllRecordersXDirection2DModel(FrameLineNumber,...
    BuildingModelDirectory,AnalysisType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generating Tcl File with All Recorders Defined                %
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
    fid = fopen('DefineAllRecorders2DModel.tcl','wt');

    % Writing file description into tcl file
    fprintf(fid,'%s\n','# This file will be used to define all recorders');
    fprintf(fid,'%s\n','');
    fprintf(fid,'%s\n','');

    % Setting up folders
    fprintf(fid,'%s\n','# Setting up folders');
    fprintf(fid,'%s\n','set baseDir [pwd];');
    fprintf(fid,'%s\n','cd	$baseDir/$dataDir/');
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
    
    % Source recorder files
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineBaseReactionRecorders2DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineBeamHingeRecorders2DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineColumnHingeRecorders2DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineGlobalBeamForceRecorders2DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineGlobalColumnForceRecorders2DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineNodeDisplacementRecorders2DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');    
    fprintf(fid,'%s\n','source DefineStoryDriftRecorders2DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    fprintf(fid,'%s\n','source DefineInfillStrutRecorders2DModel.tcl');
    fprintf(fid,'%s\n','cd $baseDir');
    if strcmp(AnalysisType,'DynamicAnalysis') == 1
        fprintf(fid,'%s\n','source DefineNodeAccelerationRecorders2DModel.tcl');
        fprintf(fid,'%s\n','cd $baseDir');
    end
        
    % Closing and saving tcl file
    fclose(fid);

end

