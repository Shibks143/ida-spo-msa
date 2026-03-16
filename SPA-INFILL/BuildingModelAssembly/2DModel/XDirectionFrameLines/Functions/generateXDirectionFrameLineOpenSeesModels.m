% This function is used to generate a 3D OpenSees model. See 
% Comp2PBEERootModule.m for input parameter descriptions

function generateXDirectionFrameLineOpenSeesModels(...
    BuildingDataDirectory,BuildingModelDirectory,OAMDFunctionsDirectory,...
    buildingGeometry,buildingLoads,seismicParametersObject,...
    dynamicPropertiesObject,jointNodes,columnObjects,columnHingeObjects,...
    xBeamObjects,xBeamHingeObjects,zBeamHingeObjects,...
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
mkdir 'XDirectionFrameLines'
cd XDirectionFrameLines
FrameLineModelFolder = sprintf('Line_%d',FrameLineNumber);
mkdir(FrameLineModelFolder)
    
% Go to directory with baseline tcl files
cd(BuildingDataDirectory)    
cd BaselineTclFiles

% Copy/create folders for new model
NewModelLocation = strcat(BuildingModelDirectory,'\OpenSees2DModels\',...
    'XDirectionFrameLines\',FrameLineModelFolder);
copyfile('OpenSees2DModels',NewModelLocation)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Generate Tcl Files Needed to Define Model Nodes and Fixities       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create tcl files with nodes defined
cd(OAMDFunctionsDirectory)
defineNodes2DXDirectionModel(BuildingModelDirectory,buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,columnHingeObjects,...
    xBeamHingeObjects,FrameLineNumber,'PushoverAnalysis');
cd(OAMDFunctionsDirectory)
defineNodes2DXDirectionModel(BuildingModelDirectory,buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,columnHingeObjects,...
    xBeamHingeObjects,FrameLineNumber,'DynamicAnalysis');
cd(OAMDFunctionsDirectory)
defineNodes2DXDirectionModel(BuildingModelDirectory,buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,columnHingeObjects,...
    xBeamHingeObjects,FrameLineNumber,'EigenValueAnalysis');

% Call function that generates Tcl file where node fixities are assigned
cd(OAMDFunctionsDirectory)
defineFixitiesXDirection2DModel(buildingGeometry,jointNodes,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineFixitiesXDirection2DModel(buildingGeometry,jointNodes,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineFixitiesXDirection2DModel(buildingGeometry,jointNodes,...
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

% Call function used to generate tcl files that define infill strut 
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
defineBeamsXDirection2DModel(buildingGeometry,xBeamObjects,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamsXDirection2DModel(buildingGeometry,xBeamObjects,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamsXDirection2DModel(buildingGeometry,xBeamObjects,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Columns                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define columns
cd(OAMDFunctionsDirectory)
defineColumnsXDirection2DModel(buildingGeometry,columnObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnsXDirection2DModel(buildingGeometry,columnObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnsXDirection2DModel(buildingGeometry,columnObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Beam Hinges             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define beam hinges
cd(OAMDFunctionsDirectory)
defineBeamHingesXDirection2DModel(buildingGeometry,xBeamHingeObjects,...
    FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamHingesXDirection2DModel(buildingGeometry,xBeamHingeObjects,...
    FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamHingesXDirection2DModel(buildingGeometry,xBeamHingeObjects,...
    FrameLineNumber,BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Column Hinges           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define column hinges
cd(OAMDFunctionsDirectory)
defineColumnHingesXDirection2DModel(buildingGeometry,columnHingeObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnHingesXDirection2DModel(buildingGeometry,columnHingeObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnHingesXDirection2DModel(buildingGeometry,columnHingeObjects,...
    leaningColumnNodeObjects,FrameLineNumber,BuildingModelDirectory,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Infill Struts           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define infill struts
cd(OAMDFunctionsDirectory)
defineInfillStrutsXDirection2DModel(buildingGeometry,...
    xDirectionInfillObjects,BuildingModelDirectory,...
    XDirectionInfillPropertiesLocation,FrameLineNumber,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineInfillStrutsXDirection2DModel(buildingGeometry,...
    xDirectionInfillObjects,BuildingModelDirectory,...
    XDirectionInfillPropertiesLocation,FrameLineNumber,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineInfillStrutsXDirectionForEigenValueAnalysis2DModel(...
    buildingGeometry,xDirectionInfillObjects,BuildingModelDirectory,...
    XDirectionInfillPropertiesLocation,FrameLineNumber,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl File Needed to Define Damping                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where damping defined
cd(OAMDFunctionsDirectory)
defineDampingXDirection2DModel(buildingGeometry,...
    dynamicPropertiesObject,BuildingModelDirectory,xBeamObjects,...
    columnObjects,jointNodes,FrameLineNumber,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Base Node Reaction Recorders     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where base node reaction recorders
% are defined
cd(OAMDFunctionsDirectory)
defineBaseReactionRecordersXDirection2DModel(buildingGeometry,jointNodes,...
    leaningColumnNodeObjects,BuildingModelDirectory,FrameLineNumber,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBaseReactionRecordersXDirection2DModel(buildingGeometry,...
    jointNodes,leaningColumnNodeObjects,BuildingModelDirectory,...
    FrameLineNumber,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generate Tcl File Needed to Define Beam Hinge Recorders          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where beam hinge recorders are
% defined
cd(OAMDFunctionsDirectory)
defineBeamHingeRecordersXDirection2DModel(buildingGeometry,...
    xBeamHingeObjects,FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineBeamHingeRecordersXDirection2DModel(buildingGeometry,...
    xBeamHingeObjects,FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generate Tcl File Needed to Define Column Hinge Recorders         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where column hinge recorders are
% defined
cd(OAMDFunctionsDirectory)
defineColumnHingeRecordersXDirection2DModel(buildingGeometry,...
    columnHingeObjects,FrameLineNumber,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineColumnHingeRecordersXDirection2DModel(buildingGeometry,...
    columnHingeObjects,FrameLineNumber,BuildingModelDirectory,...
    'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generate Tcl File Needed to Define Infill Strut Recorders       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where infill strut recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineInfillStrutRecordersXDirectionDModel(buildingGeometry,...
    xDirectionInfillObjects,XDirectionInfillPropertiesLocation,...
    FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineInfillStrutRecordersXDirectionDModel(buildingGeometry,...
    xDirectionInfillObjects,XDirectionInfillPropertiesLocation,...
    FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Global Beam Force Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where global beam force recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineGlobalBeamForceRecordersXDirection2DModel(buildingGeometry,...
    xBeamObjects,FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineGlobalBeamForceRecordersXDirection2DModel(buildingGeometry,...
    xBeamObjects,FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Generate Tcl File Needed to Define Global Column Force Recorders     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where global column force recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineGlobalColumnForceRecordersXDirection2DModel(buildingGeometry,...
    columnObjects,leaningColumnNodeObjects,FrameLineNumber,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineGlobalColumnForceRecordersXDirection2DModel(buildingGeometry,...
    columnObjects,leaningColumnNodeObjects,FrameLineNumber,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Displacement Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node displacement recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineNodeDisplacementRecordersXDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineNodeDisplacementRecordersXDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Acceleration Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node acceleration recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineNodeAccelerationRecordersXDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generate Tcl File Needed to Define Story Drift Recorders        % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where story drift recorders 
% are defined
cd(OAMDFunctionsDirectory)
defineStoryDriftRecordersXDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineStoryDriftRecordersXDirection2DModel(buildingGeometry,...
    jointNodes,FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl File Needed to Source All Recorders            % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where all recorders are sourced
cd(OAMDFunctionsDirectory)
defineAllRecordersXDirection2DModel(FrameLineNumber,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineAllRecordersXDirection2DModel(FrameLineNumber,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Gravity Loading            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where gravity loading defined
cd(OAMDFunctionsDirectory)
defineGravityLoadsXDirection2DModel(buildingGeometry,...
    jointNodes,buildingLoads,xBeamObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,columnObjects,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineGravityLoadsXDirection2DModel(buildingGeometry,...
    jointNodes,buildingLoads,xBeamObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,columnObjects,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineGravityLoadsXDirection2DModel(buildingGeometry,...
    jointNodes,buildingLoads,xBeamObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,columnObjects,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Masses                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where masses are defined
cd(OAMDFunctionsDirectory)
defineMassesXDirection2DModel(buildingGeometry,buildingLoads,...
    jointNodes,xBeamObjects,columnObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,'DynamicAnalysis')
cd(OAMDFunctionsDirectory)
defineMassesXDirection2DModel(buildingGeometry,buildingLoads,...
    jointNodes,xBeamObjects,columnObjects,leaningColumnNodeObjects,...
    FrameLineNumber,BuildingModelDirectory,'PushoverAnalysis')
cd(OAMDFunctionsDirectory)
defineMassesXDirection2DModel(buildingGeometry,buildingLoads,...
    jointNodes,xBeamObjects,columnObjects,leaningColumnNodeObjects,...
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



