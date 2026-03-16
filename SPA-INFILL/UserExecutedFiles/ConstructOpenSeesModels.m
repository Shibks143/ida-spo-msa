% Developed By: Henry Burton
% 
% Date Created: October 17, 2014
%
% Function Name: ConstructOpenSeesModels
% 
% Description of Script: This MATLAB Script uses the assembled building
%                        model data to construct the OpenSees Models i.e.
%                        all necessary tcl files are generated
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

% Define path to directory where all data related to a current building 
% is located
BuildingDataDirectory = strcat(BaseDirectory,'\BuildingData\',BuildingID);

% Define path to directory where the generated OpenSees models will be
% placed
BuildingModelDirectory = strcat(BaseDirectory,'\BuildingModels\',...
    BuildingID);

% Define location where the assembled data structures with building 
% modeling information will be stored
BuildingModelDataDirectory = strcat(BaseDirectory,'\BuildingData\',...
    BuildingID,'\BuildingModelData');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            OpenSees Model Assembly (OMA) Functions Directory            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define path to OpenSees analysis model assembly (OMA) functions
% 3D Models
OMA3DFunctionsDirectory = strcat(BaseDirectory,...
    '\BuildingModelAssembly\3DModel\Functions');
% X-Direction 2Dde Models
OMA2DFunctionsDirectory = strcat(BaseDirectory,...
    '\BuildingModelAssembly\2DModel\XDirectionFrameLines\Functions');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Load Relevant Building Model Data Structures             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go to location where building model information data structures are
% stored
cd(BuildingModelDataDirectory)

% Misc building information
load buildingGeometry
load buildingLoads
load dynamicPropertiesObject

% Nodes
load jointNodes
load leaningColumnNodes

% Columns and column hinges
load columnObjects
load columnHingeObjects

% Beams and beam hinges
load xBeamObjects
load zBeamObjects
load xBeamHingeObjects
load zBeamHingeObjects

% Infill 
load xDirectionInfillObjects
load zDirectionInfillObjects
load XDirectionInfillPropertiesLocation
load ZDirectionInfillPropertiesLocation

% Analysis options and parameters
load analysisOptions
load pushoverAnalysisParameters
load dynamicAnalysisParameters
load seismicParametersObject

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             3D Analysis Model                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calling root function used to generate tcl files for 3D OpenSees analysis
% model
cd(OMA3DFunctionsDirectory)
generate3DOpenSeesModel(BuildingDataDirectory,BuildingModelDirectory,...
    OMA3DFunctionsDirectory,buildingGeometry,buildingLoads,...
    dynamicPropertiesObject,jointNodes,columnObjects,columnHingeObjects,...
    xBeamObjects,xBeamHingeObjects,zBeamObjects,zBeamHingeObjects,...
    xDirectionInfillObjects,zDirectionInfillObjects,...
    XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,seismicParametersObject,...
    pushoverAnalysisParameters,dynamicAnalysisParameters,...
    BuildingModelDataDirectory)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     2D X-Frame Lines Analysis Models                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calling root function used to generate tcl files for 2D OpenSees analysis
% model
% X-Direction Frame Line Models
for i = 1:length(analysisOptions.XFrameLinesFor2DModels)
    % Generate OpenSees model for current frame line
    cd(OMA2DFunctionsDirectory)
    generateXDirectionFrameLineOpenSeesModels(BuildingDataDirectory,...
    BuildingModelDirectory,OMA2DFunctionsDirectory,buildingGeometry,...
    buildingLoads,seismicParametersObject,dynamicPropertiesObject,...
    jointNodes,columnObjects,columnHingeObjects,xBeamObjects,...
    xBeamHingeObjects,zBeamHingeObjects,xDirectionInfillObjects,...
    zDirectionInfillObjects,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,...
    analysisOptions.XFrameLinesFor2DModels(i),leaningColumnNodes,...
    BuildingModelDataDirectory,pushoverAnalysisParameters,...
    dynamicAnalysisParameters)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 3c. 2D Z-Frame Lines Analysis Models                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Z-Direction Frame Line Models
OMA2DFunctionsDirectory = strcat(BaseDirectory,...
    '\BuildingModelAssembly\2DModel\ZDirectionFrameLines\Functions');
for i = 1:length(analysisOptions.ZFrameLinesFor2DModels)
    % Generate OpenSees model for current frame line
    cd(OMA2DFunctionsDirectory)
    generateZDirectionFrameLineOpenSeesModels(BuildingDataDirectory,...
    BuildingModelDirectory,OMA2DFunctionsDirectory,buildingGeometry,...
    buildingLoads,seismicParametersObject,dynamicPropertiesObject,...
    jointNodes,columnObjects,columnHingeObjects,zBeamObjects,...
    zBeamHingeObjects,xBeamHingeObjects,xDirectionInfillObjects,...
    zDirectionInfillObjects,XDirectionInfillPropertiesLocation,...
    ZDirectionInfillPropertiesLocation,...
    analysisOptions.ZFrameLinesFor2DModels(i),leaningColumnNodes,...
    BuildingModelDataDirectory,pushoverAnalysisParameters,...
    dynamicAnalysisParameters)
end

