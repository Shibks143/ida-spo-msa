% Developed By: Henry Burton
% 
% Date Created: October 17, 2014
%
% Function Name: AssembleBuildingModelInformation
% 
% Description of Script: This MATLAB Script serves to assemble to necessary
%                        building model information and store it in the
%                        appropriate data structures
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Relevant Publications                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Burton, H. and Deierlein, G., 2014. Simulation of seismic collapse 
% in nonductile reinforced concrete frame buildings with masonry infills. 
% ASCE J. Struct. Eng., 10.1061/ (ASCE) ST.1943-541X.0000921, 
% 0733-9445/A4014016.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                User Defined Model Folder and Directory Paths            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

% String used to identify the name of the folder in which the relevant data
% for the current building being modeled is stored. The generated OpenSees
% models will also be stored in this folder.
BuildingID = 'Building1';

% Define path to where SPA-INFILL base directory
BaseDirectory = strcat('D:\hburton\SPA-INFILL');

% User input ends here

% Define path to directory where all data related to a currenr building 
% is located
BuildingDataDirectory = strcat(BaseDirectory,'\BuildingData\',BuildingID);

% Define location where the assembled data structures with building 
% modeling information will be stored
BuildingModelDataDirectory = strcat(BaseDirectory,'\BuildingData\',...
    BuildingID,'\BuildingModelData');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Building Data Assembly (BDA) Functions and Classes Directories     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define path to building data assembly functions
BDAFunctionsDirectory = strcat(BaseDirectory,'\BuildingDataAssembly\',...
    'Functions');

% Define path to building data assembly classes 
BDAClassesDirectory = strcat(BaseDirectory,'\BuildingDataAssembly\',...
    'Classes');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Defining Building Geometry                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define path to folder where building geometry data is stored
GeometryParametersLocation = strcat(BuildingDataDirectory,'\Geometry');

% Call function used to generate a struct containing building
% geometry data
cd(BDAFunctionsDirectory)
buildingGeometry = defineBuildingGeometry(GeometryParametersLocation);

% Save building geometry data 
cd(BuildingModelDataDirectory)
save('buildingGeometry.mat','buildingGeometry','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Defining Building Loads                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define path to folder where building load data is stored
LoadParametersLocation = strcat(BuildingDataDirectory,'\Loads');

% Call function used to generate a struct containing building loads
cd(BDAFunctionsDirectory)
buildingLoads = defineBuildingLoads(LoadParametersLocation);

% Save building loads data 
cd(BuildingModelDataDirectory)
save('buildingLoads.mat','buildingLoads','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Defining Seismic Parameters                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define string with path to folder where building seismic parameters are 
% stored
SeismicParametersLocation = strcat(BuildingDataDirectory,...
    '\SeismicDesignParameters');

% Create seismic parameters object
cd(BDAClassesDirectory)
seismicParametersObject = seismicParameters(SeismicParametersLocation,...
    buildingGeometry,buildingLoads);

% Save seismic parameters object
cd(BuildingModelDataDirectory)
seismicParametersObject = saveToStruct(seismicParametersObject);
save('seismicParametersObject.mat','seismicParametersObject','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Defining Dynamic Properties                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define string with path to folder where building dynamic properties are 
% stored
DynamicPropertiesLocation = strcat(BuildingDataDirectory,...
    '\DynamicProperties');

% Create dynamic properties object
cd(BDAClassesDirectory)
dynamicPropertiesObject = dynamicProperties(DynamicPropertiesLocation,...
    buildingLoads);

% Save dynamic properties object
cd(BuildingModelDataDirectory)
dynamicPropertiesObject = saveToStruct(dynamicPropertiesObject);
save('dynamicPropertiesObject.mat','dynamicPropertiesObject','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Defining Pushover Analysis Parameters                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define string with path to folder where pushover analysis parameters are 
% stored
PushoverAnalysisParametersLocation = strcat(BuildingDataDirectory,...
    '\AnalysisParameters\StaticAnalysis');

% Call function used to generate a struct containing pushover analysis
% parameters
cd(BDAFunctionsDirectory)
pushoverAnalysisParameters = definePushoverAnalysisParameters(...
    PushoverAnalysisParametersLocation);

% Save pushover analysis parameters
cd(BuildingModelDataDirectory)
save('pushoverAnalysisParameters.mat','pushoverAnalysisParameters','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Defining Dynamic Analysis Parameters                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define string with path to folder where dynamic analysis parameters are 
% stored
DynamicAnalysisParametersLocation = strcat(BuildingDataDirectory,...
    '\AnalysisParameters\DynamicAnalysis');

% Call function used to generate a struct containing dynamic analysis
% parameters
cd(BDAFunctionsDirectory)
dynamicAnalysisParameters = defineDynamicAnalysisParameters(...
    DynamicAnalysisParametersLocation);

% Save dynamic analysis parameters
cd(BuildingModelDataDirectory)
save('dynamicAnalysisParameters.mat','dynamicAnalysisParameters','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Defining Analysis Options                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define string with path to folder where analysis options are stored
AnalysisOptionsLocation = strcat(BuildingDataDirectory,...
    '\AnalysisOptions');

% Call function used to generate a structure containing analysis
% options
cd(BDAFunctionsDirectory)
analysisOptions = defineAnalysisOptions(AnalysisOptionsLocation);

% Save dynamic analysis options
cd(BuildingModelDataDirectory)
save('analysisOptions.mat','analysisOptions','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Defining Joint and Leaning Column Nodes                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call function used to generate an array of joint node objects where
% joint nodes are the nodes that are at the intersection of beam column
% joints. They do not include additional nodes for beam-column hinges or
% BNWF model
cd(BDAFunctionsDirectory)
jointNodes = defineJointNodes(buildingGeometry,BDAClassesDirectory);
cd(BDAFunctionsDirectory)
leaningColumnNodes = defineLeaningColumnNodes(buildingGeometry);

% Save joint and leaning column node objects
cd(BuildingModelDataDirectory)
save('jointNodes.mat','jointNodes','-mat')
save('leaningColumnNodes.mat','leaningColumnNodes','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Defining Columns and Column Hinges                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define string with path to folder where building column properties are 
% stored
ColumnPropertiesLocation = strcat(BuildingDataDirectory,...
    '\StructuralProperties\Columns');

% Define string with path to folder where building column hinge properties  
% are stored
ColumnHingePropertiesLocation = strcat(BuildingDataDirectory,...
    '\StructuralProperties\ColumnHinges');

% Call function used to generate an array of column and column hinge 
% objects 
cd(BDAFunctionsDirectory)
[columnObjects columnHingeObjects] = ...
    defineColumnsAndColumnHinges(buildingGeometry,BDAClassesDirectory,...
    jointNodes,ColumnPropertiesLocation,ColumnHingePropertiesLocation,...
    LoadParametersLocation);

% Save column and column hinge objects 
cd(BuildingModelDataDirectory)
save('columnObjects.mat','columnObjects','-mat')
save('columnHingeObjects.mat','columnHingeObjects','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Defining Beams and Beam Hinges                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define string with path to folder where building xBeam properties are 
% stored
XBeamPropertiesLocation = strcat(BuildingDataDirectory,...
    '\StructuralProperties\XBeams');

% Define string with path to folder where building xBeam hinge properties  
% are stored
XBeamHingePropertiesLocation = strcat(BuildingDataDirectory,...
    '\StructuralProperties\XBeamHinges');

% Define string with path to folder where building xBeam properties are 
% stored
ZBeamPropertiesLocation = strcat(BuildingDataDirectory,...
    '\StructuralProperties\ZBeams');

% Define string with path to folder where building zBeam hinge properties  
% are stored
ZBeamHingePropertiesLocation = strcat(BuildingDataDirectory,...
    '\StructuralProperties\ZBeamHinges');

% Call function used to generate an array of beam and beam hinge 
% objects 
cd(BDAFunctionsDirectory)
[xBeamObjects xBeamHingeObjects zBeamObjects zBeamHingeObjects]...
    = defineBeamsAndBeamHinges(buildingGeometry,BDAClassesDirectory,...
    jointNodes,XBeamPropertiesLocation,XBeamHingePropertiesLocation,...
    ZBeamPropertiesLocation,ZBeamHingePropertiesLocation,...
    LoadParametersLocation);

% Save beam and beam hinge objects 
cd(BuildingModelDataDirectory)
save('xBeamObjects.mat','xBeamObjects','-mat')
save('xBeamHingeObjects.mat','xBeamHingeObjects','-mat')
save('zBeamObjects.mat','zBeamObjects','-mat')
save('zBeamHingeObjects.mat','zBeamHingeObjects','-mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Defining Infill Panels                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define string with path to folder where building x-direction infill   
% properties are stored
XDirectionInfillPropertiesLocation = strcat(BuildingDataDirectory,...
    '\StructuralProperties\XDirectionInfill');

% Define string with path to folder where building z-direction infill   
% properties are stored
ZDirectionInfillPropertiesLocation = strcat(BuildingDataDirectory,...
    '\StructuralProperties\ZDirectionInfill');

% Call function used to generate an array of infill strut objects 
cd(BDAFunctionsDirectory)
[xDirectionInfillObjects zDirectionInfillObjects] = defineInfill(...
    buildingGeometry,BDAClassesDirectory,jointNodes,...
    XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,columnObjects);

% Save infill objects 
cd(BuildingModelDataDirectory)
save('xDirectionInfillObjects.mat','xDirectionInfillObjects','-mat')
save('zDirectionInfillObjects.mat','zDirectionInfillObjects','-mat')
save('XDirectionInfillPropertiesLocation.mat',...
    'XDirectionInfillPropertiesLocation','-mat')
save('ZDirectionInfillPropertiesLocation.mat',...
    'ZDirectionInfillPropertiesLocation','-mat')


