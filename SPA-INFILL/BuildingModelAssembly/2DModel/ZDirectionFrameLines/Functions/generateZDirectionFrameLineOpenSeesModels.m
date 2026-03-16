% This function is used to generate a 3D OpenSees model. See 
% Comp2PBEERootModule.m for input parameter descriptions

function generateZDirectionFrameLineOpenSeesModels(...
    BuildingDataDirectory,BuildingModelDirectory,OAMDFunctionsDirectory,...
    buildingGeometry,buildingLoads,seismicParametersObject,...
    dynamicPropertiesObject,jointNodes,columnObjects,columnHingeObjects,...
    zBeamObjects,zBeamHingeObjects,xBeamHingeObjects,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,...
    FrameLineNumber,leaningColumnNodeObjects,BuildingModelDataDirectory,...
    pushoverAnalysisParameters,dynamicAnalysisParameters)
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Create Model Folders                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create model folder
cd(BuildingModelDirectory)
mkdir OpenSees2DModels
cd OpenSees2DModels
mkdir 'ZDirectionFrameLines'
cd ZDirectionFrameLines
FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
mkdir(FrameLineModelFolder)
    
% Go to directory with baseline tcl files
cd(BuildingDataDirectory)    
cd BaselineTclFiles

% Copy/create folders for new model
NewModelLocation = strcat(BuildingModelDirectory,'\OpenSees2DModels\',...
    'ZDirectionFrameLines\',FrameLineModelFolder);
copyfile('OpenSees2DModels',NewModelLocation)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generate Tcl Files Needed to Define Model Nodes and Fixities       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create tcl files with nodes defined
cd(OAMDFunctionsDirectory)
defineNodes2DZDirectionModel(BuildingModelDirectory,buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,columnHingeObjects,...
    zBeamHingeObjects,FrameLineNumber,'PushoverAnalysis');
cd(OAMDFunctionsDirectory)
defineNodes2DZDirectionModel(BuildingModelDirectory,buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,columnHingeObjects,...
    zBeamHingeObjects,FrameLineNumber,'DynamicAnalysis');
cd(OAMDFunctionsDirectory)
defineNodes2DZDirectionModel(BuildingModelDirectory,buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,columnHingeObjects,...
    zBeamHingeObjects,FrameLineNumber,'EigenValueAnalysis');

% Call function that generates Tcl file where node fixities are assigned
cd(OAMDFunctionsDirectory)
defineFixitiesZDirection2DModel(buildingGeometry,jointNodes,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineFixitiesZDirection2DModel(buildingGeometry,jointNodes,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineFixitiesZDirection2DModel(buildingGeometry,jointNodes,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl Files Needed to Define Beam-Column Hinge Materials     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define column hinge 
% materials
cd(OAMDFunctionsDirectory)
defineColumnHingeMaterials2DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,FrameLineNumber,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnHingeMaterials2DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,FrameLineNumber,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnHingeMaterials2DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,FrameLineNumber,'EigenValueAnalysis')

% Call function used to generate tcl files that define beam hinge 
% materials
cd(OAMDFunctionsDirectory)
defineBeamHingeMaterials2DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,FrameLineNumber,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamHingeMaterials2DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,FrameLineNumber,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamHingeMaterials2DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,FrameLineNumber,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl Files Needed to Define Infill Strut Materials          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define spine infill strut 
% materials
cd(OAMDFunctionsDirectory)
defineInfillStrutMaterials2DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineInfillStrutMaterials2DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineInfillStrutMaterialsForEigenValueAnalysis2DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Beams                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define beams
cd(OAMDFunctionsDirectory)
defineBeamsZDirection2DModel(buildingGeometry,zBeamObjects,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamsZDirection2DModel(buildingGeometry,zBeamObjects,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamsZDirection2DModel(buildingGeometry,zBeamObjects,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Columns                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define columns
cd(OAMDFunctionsDirectory)
defineColumnsZDirection2DModel(buildingGeometry,columnObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnsZDirection2DModel(buildingGeometry,columnObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnsZDirection2DModel(buildingGeometry,columnObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Beam Hinges             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define beam hinges
cd(OAMDFunctionsDirectory)
defineBeamHingesZDirection2DModel(buildingGeometry,zBeamHingeObjects,...
    FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamHingesZDirection2DModel(buildingGeometry,zBeamHingeObjects,...
    FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamHingesZDirection2DModel(buildingGeometry,zBeamHingeObjects,...
    FrameLineNumber,BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Column Hinges           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define column hinges
cd(OAMDFunctionsDirectory)
defineColumnHingesZDirection2DModel(buildingGeometry,columnHingeObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnHingesZDirection2DModel(buildingGeometry,columnHingeObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnHingesZDirection2DModel(buildingGeometry,columnHingeObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Infill Struts           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define  infill struts
cd(OAMDFunctionsDirectory)
defineInfillStrutsZDirection2DModel(buildingGeometry,...
    zDirectionInfillObjects,BuildingModelDirectory,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineInfillStrutsZDirection2DModel(buildingGeometry,...
    zDirectionInfillObjects,BuildingModelDirectory,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineInfillStrutsZDirectionForEigenValueAnalysis2DModel(...
    buildingGeometry,zDirectionInfillObjects,BuildingModelDirectory,...
    ZDirectionInfillPropertiesLocation,FrameLineNumber,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl File Needed to Define Damping                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where damping defined
cd(OAMDFunctionsDirectory)
defineDampingZDirection2DModel(buildingGeometry,...
    dynamicPropertiesObject,BuildingModelDirectory,zBeamObjects,...
    columnObjects,jointNodes,FrameLineNumber,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Base Node Reaction Recorders     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where base node reaction recorders
% are defined
cd(OAMDFunctionsDirectory)
defineBaseReactionRecordersZDirection2DModel(buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,BuildingModelDirectory,...
    FrameLineNumber,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBaseReactionRecordersZDirection2DModel(buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,BuildingModelDirectory,...
    FrameLineNumber,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generate Tcl File Needed to Define Beam Hinge Recorders          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where beam hinge recorders are
% defined
cd(OAMDFunctionsDirectory)
defineBeamHingeRecordersZDirection2DModel(buildingGeometry,...
    zBeamHingeObjects,FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamHingeRecordersZDirection2DModel(buildingGeometry,...
    zBeamHingeObjects,FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generate Tcl File Needed to Define Column Hinge Recorders         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where column hinge recorders are
% defined
cd(OAMDFunctionsDirectory)
defineColumnHingeRecordersZDirection2DModel(buildingGeometry,...
    columnHingeObjects,FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnHingeRecordersZDirection2DModel(buildingGeometry,...
    columnHingeObjects,FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generate Tcl File Needed to Define Infill Strut Recorders       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where infill strut recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineInfillStrutRecordersZDirectionDModel(buildingGeometry,...
    zDirectionInfillObjects,ZDirectionInfillPropertiesLocation,...
    FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineInfillStrutRecordersZDirectionDModel(buildingGeometry,...
    zDirectionInfillObjects,ZDirectionInfillPropertiesLocation,...
    FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Global Beam Force Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where global beam force recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineGlobalBeamForceRecordersZDirection2DModel(buildingGeometry,...
    zBeamObjects,FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineGlobalBeamForceRecordersZDirection2DModel(buildingGeometry,...
    zBeamObjects,FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Generate Tcl File Needed to Define Global Column Force Recorders     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where global column force recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineGlobalColumnForceRecordersZDirection2DModel(buildingGeometry,...
    columnObjects,leaningColumnNodeObjects,FrameLineNumber,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineGlobalColumnForceRecordersZDirection2DModel(buildingGeometry,...
    columnObjects,leaningColumnNodeObjects,FrameLineNumber,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Displacement Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node displacement recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineNodeDisplacementRecordersZDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineNodeDisplacementRecordersZDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Acceleration Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node acceleration recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineNodeAccelerationRecordersZDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generate Tcl File Needed to Define Story Drift Recorders        % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where story drift recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineStoryDriftRecordersZDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineStoryDriftRecordersZDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl File Needed to Source All Recorders            % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where all recorders are sourced
cd(OAMDFunctionsDirectory)
defineAllRecordersZDirection2DModel(FrameLineNumber,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineAllRecordersZDirection2DModel(FrameLineNumber,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Gravity Loading            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where gravity loading defined
cd(OAMDFunctionsDirectory)
defineGravityLoadsZDirection2DModel(buildingGeometry,...
    jointNodes,buildingLoads,zBeamObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,columnObjects,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineGravityLoadsZDirection2DModel(buildingGeometry,...
    jointNodes,buildingLoads,zBeamObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,columnObjects,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineGravityLoadsZDirection2DModel(buildingGeometry,...
    jointNodes,buildingLoads,zBeamObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,columnObjects,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Masses                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where masses are defined
cd(OAMDFunctionsDirectory)
defineMassesZDirection2DModel(buildingGeometry,buildingLoads,...
    jointNodes,zBeamObjects,columnObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineMassesZDirection2DModel(buildingGeometry,buildingLoads,...
    jointNodes,zBeamObjects,columnObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineMassesZDirection2DModel(buildingGeometry,buildingLoads,...
    jointNodes,zBeamObjects,columnObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Generating Tcl File Defining Parameters Needed for Collapse Solver   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates file used to define collapse solver
% parameters
cd(OAMDFunctionsDirectory)
defineDynamicAnalysisParameters2DModel(buildingGeometry,...
    FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Pushover Loading           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates tcl file used to define pushover loading
% pattern
cd(OAMDFunctionsDirectory)
definePushoverLoading2DModel(buildingGeometry,seismicParametersObject,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
definePushoverLoading2DModel(buildingGeometry,seismicParametersObject,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'EigenValueAnalysis')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Define, Setup and Run Eigen Value Analysis Model            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up tcl files for eigen value analysis
cd(OAMDFunctionsDirectory)
define2DEigenValueAnalysisModel(FrameLineNumber,BuildingModelDirectory,...
    'EigenValueAnalysis')

%Run eigen value analysis
cd(OAMDFunctionsDirectory)
run2DEigenValueAnalysis(BuildingModelDirectory,FrameLineNumber,...
    BuildingModelDataDirectory,dynamicPropertiesObject) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Define and Setup Pushover Analysis Model               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates main tcl file used to define pushover
% analysis model
cd(OAMDFunctionsDirectory)
define2DPushoverAnalysisModel(FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')

% Call function that is used to setup root tcl files for running pushover
% analysis
cd(OAMDFunctionsDirectory)
setupPushoverAnalysis(BuildingModelDirectory,buildingGeometry,...
    pushoverAnalysisParameters,FrameLineNumber,jointNodes)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Define and Setup Dynamic Analysis Model               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates main tcl file used to define dynamic
% analysis model
cd(OAMDFunctionsDirectory)
define2DDynamicAnalysisModel(FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')

% Call function that is used to setup root tcl files for running dynamic
% analysis
cd(BuildingModelDataDirectory)
load dynamicPropertiesObject
cd(OAMDFunctionsDirectory)
setupDynamicAnalysis(BuildingModelDirectory,buildingGeometry,...
    dynamicAnalysisParameters,dynamicPropertiesObject,FrameLineNumber) 
end



