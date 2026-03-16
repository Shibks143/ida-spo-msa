% This function is used to generate a 3D OpenSees model. See 
% Comp2PBEERootModule.m for input parameter descriptions

function generate3DOpenSeesModel(BuildingDataDirectory,...
    BuildingModelDirectory,OMA3DFunctionsDirectory,buildingGeometry,...
    buildingLoads,dynamicPropertiesObject,jointNodes,columnObjects,...
    columnHingeObjects,xBeamObjects,xBeamHingeObjects,zBeamObjects,...
    zBeamHingeObjects,xDirectionInfillObjects,zDirectionInfillObjects,...
    XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,seismicParametersObject,...
    pushoverAnalysisParameters,dynamicAnalysisParameters,...
    BuildingModelDataDirectory)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Create Model Folders                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go to directory with baseline tcl files
cd(BuildingModelDirectory)
mkdir OpenSees3DModels
cd(BuildingDataDirectory)
cd BaselineTclFiles

% Copy/create folders for new model
NewModelLocation = strcat(BuildingModelDirectory,'\OpenSees3DModels');
copyfile('OpenSees3DModels',NewModelLocation)

% Copy MCE scale factors to Ground Motion Info Folder
OriginFolder = strcat(BuildingDataDirectory,'\AnalysisParameters\',...
    'DynamicAnalysis');
DestinationFolder = strcat(BuildingModelDirectory,'\OpenSees3DModels',...
    '\DynamicAnalysis\GroundMotionInfo');
cd(OriginFolder)
copyfile('BiDirectionMCEScaleFactors.txt',DestinationFolder)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl Files Needed to Define Model Nodes, Rigid Floor        %
%                   Diaphragm Constraints and Fixities                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create tcl files with nodes defined
cd(OMA3DFunctionsDirectory)
defineNodes3DModel(BuildingModelDirectory,buildingGeometry,jointNodes,...
    columnHingeObjects,xBeamHingeObjects,zBeamHingeObjects,...
    'PushoverAnalysis');
cd(OMA3DFunctionsDirectory)
defineNodes3DModel(BuildingModelDirectory,buildingGeometry,jointNodes,...
    columnHingeObjects,xBeamHingeObjects,...
    zBeamHingeObjects,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory)
defineNodes3DModel(BuildingModelDirectory,buildingGeometry,jointNodes,...
    columnHingeObjects,xBeamHingeObjects,...
    zBeamHingeObjects,'EigenValueAnalysis');

% Call function that generates Tcl file where rigid diaphragm constraints
% are defined
cd(OMA3DFunctionsDirectory)
defineRigidFloorDiaphragm3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'PushoverAnalysis');
cd(OMA3DFunctionsDirectory)
defineRigidFloorDiaphragm3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'DynamicAnalysis');
cd(OMA3DFunctionsDirectory)
defineRigidFloorDiaphragm3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'EigenValueAnalysis');

% Call function that generates Tcl file where node fixities are assigned
cd(OMA3DFunctionsDirectory)
defineFixities3DModel(buildingGeometry,jointNodes,BuildingModelDirectory,...
    'PushoverAnalysis'); 
cd(OMA3DFunctionsDirectory)
defineFixities3DModel(buildingGeometry,jointNodes,BuildingModelDirectory,...
    'DynamicAnalysis'); 
cd(OMA3DFunctionsDirectory)
defineFixities3DModel(buildingGeometry,jointNodes,BuildingModelDirectory,...
    'EigenValueAnalysis'); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl Files Needed to Define Beam-Column Hinge Materials     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define column hinge 
% materials
cd(OMA3DFunctionsDirectory)
defineColumnHingeMaterials3DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineColumnHingeMaterials3DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineColumnHingeMaterials3DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,'EigenValueAnalysis')

% Call function used to generate tcl files that define beam hinge 
% materials
cd(OMA3DFunctionsDirectory)
defineBeamHingeMaterials3DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineBeamHingeMaterials3DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineBeamHingeMaterials3DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl Files Needed to Define Infill Strut Materials          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define infill strut 
% materials
cd(OMA3DFunctionsDirectory)
defineInfillStrutMaterials3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineInfillStrutMaterials3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineInfillStrutMaterialsForEigenValueAnalysis3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Beams                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define beams
cd(OMA3DFunctionsDirectory)
defineBeams3DModel(buildingGeometry,xBeamObjects,zBeamObjects,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineBeams3DModel(buildingGeometry,xBeamObjects,zBeamObjects,...
    BuildingModelDirectory,'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineBeams3DModel(buildingGeometry,xBeamObjects,zBeamObjects,...
    BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Columns                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define columns
cd(OMA3DFunctionsDirectory)
defineColumns3DModel(buildingGeometry,columnObjects,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineColumns3DModel(buildingGeometry,columnObjects,BuildingModelDirectory,...
    'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineColumns3DModel(buildingGeometry,columnObjects,BuildingModelDirectory,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Beam Hinges             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define beam hinges
cd(OMA3DFunctionsDirectory)
defineBeamHinges3DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineBeamHinges3DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineBeamHinges3DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Column Hinges           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define column hinges
cd(OMA3DFunctionsDirectory)
defineColumnHinges3DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineColumnHinges3DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineColumnHinges3DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl Files Needed to Define Infill Struts           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate tcl files that define infill struts
cd(OMA3DFunctionsDirectory)
defineInfillStruts3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineInfillStruts3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineInfillStrutsForEigenValueAnalysis3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    BuildingModelDirectory,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl File Needed to Define Damping                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where damping defined
cd(OMA3DFunctionsDirectory)
defineDamping3DModel(buildingGeometry,dynamicPropertiesObject,...
    BuildingModelDirectory,xBeamObjects,zBeamObjects,columnObjects,...
    jointNodes,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Base Node Reaction Recorders     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where base node reaction recorders
% are defined
cd(OMA3DFunctionsDirectory)
defineBaseReactionRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineBaseReactionRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generate Tcl File Needed to Define Beam Hinge Recorders          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where beam hinge recorders are
% defined
cd(OMA3DFunctionsDirectory)
defineBeamHingeRecorders3DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineBeamHingeRecorders3DModel(buildingGeometry,xBeamHingeObjects,...
    zBeamHingeObjects,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Generate Tcl File Needed to Define Column Hinge Recorders         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where column hinge recorders are
% defined
cd(OMA3DFunctionsDirectory)
defineColumnHingeRecorders3DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineColumnHingeRecorders3DModel(buildingGeometry,columnHingeObjects,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Generate Tcl File Needed to Define Infill Strut Recorders        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where infill strut recorders 
% are defined
cd(OMA3DFunctionsDirectory)
defineInfillStrutRecorders3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineInfillStrutRecorders3DModel(buildingGeometry,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,BuildingModelDirectory,...
    'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Global Beam Force Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where global beam force recorders 
% are defined
cd(OMA3DFunctionsDirectory)
defineGlobalBeamForceRecorders3DModel(buildingGeometry,xBeamObjects,...
    zBeamObjects,BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineGlobalBeamForceRecorders3DModel(buildingGeometry,xBeamObjects,...
    zBeamObjects,BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Generate Tcl File Needed to Define Global Column Force Recorders     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where global column force recorders 
% are defined
cd(OMA3DFunctionsDirectory)
defineGlobalColumnForceRecorders3DModel(buildingGeometry,columnObjects,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineGlobalColumnForceRecorders3DModel(buildingGeometry,columnObjects,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Displacement Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node displacement recorders 
% are defined
cd(OMA3DFunctionsDirectory)
defineNodeDisplacementRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineNodeDisplacementRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Generate Tcl File Needed to Define Node Acceleration Recorders      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where node acceleration recorders 
% are defined
cd(OMA3DFunctionsDirectory)
defineNodeAccelerationRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Generate Tcl File Needed to Define Story Drift Recorders        % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where story drift recorders 
% are defined
cd(OMA3DFunctionsDirectory)
defineStoryDriftRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineStoryDriftRecorders3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Generate Tcl File Needed to Source All Recorders            % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where all recorders are sourced
cd(OMA3DFunctionsDirectory)
defineAllRecorders3DModel(BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineAllRecorders3DModel(BuildingModelDirectory,'DynamicAnalysis')
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Gravity Loading            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where gravity loading defined
cd(OMA3DFunctionsDirectory)
defineGravityLoads3DModel(buildingGeometry,buildingLoads,...
    xBeamObjects,zBeamObjects,BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineGravityLoads3DModel(buildingGeometry,buildingLoads,...
    xBeamObjects,zBeamObjects,BuildingModelDirectory,'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineGravityLoads3DModel(buildingGeometry,buildingLoads,...
    xBeamObjects,zBeamObjects,BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Masses                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generate Tcl file where masses are defined
cd(OMA3DFunctionsDirectory)
defineMasses3DModel(buildingGeometry,buildingLoads,jointNodes,...
    xBeamObjects,zBeamObjects,columnObjects,BuildingModelDirectory,...
    'DynamicAnalysis')
cd(OMA3DFunctionsDirectory)
defineMasses3DModel(buildingGeometry,buildingLoads,jointNodes,...
    xBeamObjects,zBeamObjects,columnObjects,BuildingModelDirectory,...
    'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
defineMasses3DModel(buildingGeometry,buildingLoads,jointNodes,...
    xBeamObjects,zBeamObjects,columnObjects,BuildingModelDirectory,...
    'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Generating Tcl File Defining Parameters Needed for Collapse Solver   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates file used to define collapse solver
% parameters
cd(OMA3DFunctionsDirectory)
defineDynamicAnalysisParameters3DModel(buildingGeometry,jointNodes,...
    BuildingModelDirectory,'DynamicAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Generate Tcl File Needed to Define Pushover Loading           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates tcl file used to define pushover loading
% pattern
cd(OMA3DFunctionsDirectory)
definePushoverLoading3DModel(buildingGeometry,seismicParametersObject,...
    jointNodes,BuildingModelDirectory,'PushoverAnalysis')
cd(OMA3DFunctionsDirectory)
definePushoverLoading3DModel(buildingGeometry,seismicParametersObject,...
    jointNodes,BuildingModelDirectory,'EigenValueAnalysis')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Define, Setup and Run Eigen Value Analysis Model            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up tcl files for eigen value analysis
cd(OMA3DFunctionsDirectory)
define3DEigenValueAnalysisModel(BuildingModelDirectory,...
    'EigenValueAnalysis')

%Run eigen value analysis
cd(OMA3DFunctionsDirectory)
run3DEigenValueAnalysis(BuildingModelDirectory,...
    BuildingModelDataDirectory,dynamicPropertiesObject)   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Define and Setup Pushover Analysis Model               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates main tcl file used to define pushover
% analysis model
cd(OMA3DFunctionsDirectory)
define3DPushoverAnalysisModel(BuildingModelDirectory,'PushoverAnalysis')

% Call function that is used to setup root tcl files for running pushover
% analysis
cd(OMA3DFunctionsDirectory)
setupPushoverAnalysis(BuildingModelDirectory,buildingGeometry,...
    pushoverAnalysisParameters)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Define and Setup Dynamic Analysis Model               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function that generates main tcl file used to define dynamic
% analysis model
cd(OMA3DFunctionsDirectory)
define3DDynamicAnalysisModel(BuildingModelDirectory,...
    'DynamicAnalysis')

% Call function that is used to setup root tcl files for running dynamic
% analysis
cd(BuildingModelDataDirectory)
load dynamicPropertiesObject
cd(OMA3DFunctionsDirectory)
setupDynamicAnalysis(BuildingModelDirectory,buildingGeometry,...
    dynamicAnalysisParameters,dynamicPropertiesObject) 







