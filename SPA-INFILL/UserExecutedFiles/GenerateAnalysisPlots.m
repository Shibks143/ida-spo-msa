% Developed By: Henry Burton
% 
% Date Created: November 22, 2013
%
% Function Name: GenerateAnalysisPlots
% 
% Description of Script: This MATLAB Script extracts the results of the
%                        nonlinear static analysis and collapse performance
%                        and generates pushover curves and collapse
%                        fragility curves

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                User Defined Model Folder and Directory Paths            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

% String used to identify the name of the folder in which the relevant data
% for the current building being modeled is stored. The generated OpenSees
% models will also be stored in this folder.
BuildingID = 'Building1';

% Define path to where MFIMOS base directory
BaseDirectory = strcat('D:\hburton\SPA-INFILL');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  User Defined Analysis Plotting Options                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Indicate models for which collapse fragility curves will be generated.
% 'YES' or 'NO' (case sensitive)
generate3DModelCollapseFragilityCurves = 'YES';
generate2DXDirectionModelCollapseFragilityCurves = 'YES';
generate2DZDirectionModelCollapseFragilityCurves = 'YES';

% Indicate models for which pushover curves will be generated.
% 'YES' or 'NO' (case sensitive)
generate3DModelXDirectionPushoverCurves = 'YES';
generate3DModelZDirectionPushoverCurves = 'YES';
generate2DXDirectionModelPushoverCurves = 'YES';
generate2DZDirectionModelPushoverCurves = 'YES';

% User input ends here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Model Folder and Directory Paths                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%              Generate Analysis Plots (GAP) Functions Directory          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define path to functions used to generate pushover and collapse fragility 
% curves
GAPFunctionsDirectory = strcat(BaseDirectory,...
    '\GenerateAnalysisPlots\Functions');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Analysis Plots Directory                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define path to location where analysis plots will be stored
AnalysisPlotsDirectory = strcat(BaseDirectory,'\AnalysisPlots\',...
    BuildingID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Load Relevant Building Model Data Structures             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go to location where building model information data structures are
% stored
cd(BuildingModelDataDirectory)

% Analysis options and parameters
load analysisOptions
load dynamicAnalysisParameters
load buildingGeometry
load buildingLoads

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Extract Collapse Performance Results                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract collapse performance data for 3D model
if strcmp(generate3DModelCollapseFragilityCurves,'YES') == 1
    cd(GAPFunctionsDirectory)
    collapseResults3DModel = extractCollapseStatistics(...
        BuildingModelDirectory,dynamicAnalysisParameters,...
        '3DModel',1);
end

% Extract collapse performance data for 2D X-Direction Frame Line Models
if strcmp(generate2DXDirectionModelCollapseFragilityCurves,'YES') == 1
    for i = 1:length(analysisOptions.XFrameLinesFor2DModels)
        % Generate OpenSees model for current frame line
        cd(GAPFunctionsDirectory)
        collapseResultsXDirectionDModel{i} = extractCollapseStatistics(...
        BuildingModelDirectory,dynamicAnalysisParameters,...
        'XDirection2DModel',analysisOptions.XFrameLinesFor2DModels(i));
    end
end

% Extract collapse performance data for 2D X-Direction Frame Line Models
if strcmp(generate2DZDirectionModelCollapseFragilityCurves,'YES') == 1
    for i = 1:length(analysisOptions.ZFrameLinesFor2DModels)
        % Generate OpenSees model for current frame line
        cd(GAPFunctionsDirectory)
        collapseResultsZDirectionDModel{i} = extractCollapseStatistics(...
        BuildingModelDirectory,dynamicAnalysisParameters,...
        'ZDirection2DModel',analysisOptions.ZFrameLinesFor2DModels(i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Generate Collapse Fragiltiy Curves                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate collapse fragility curves for 3D model
if strcmp(generate3DModelCollapseFragilityCurves,'YES') == 1
    cd(GAPFunctionsDirectory)
    generateCollapseFragilityCurves(AnalysisPlotsDirectory,...
        collapseResults3DModel,'3DModel',1);
end

% Generate collapse fragility curves for 2D X-Direction Frame Line Models
if strcmp(generate2DXDirectionModelCollapseFragilityCurves,'YES') == 1    
    for i = 1:length(analysisOptions.XFrameLinesFor2DModels)
        cd(GAPFunctionsDirectory)
        generateCollapseFragilityCurves(AnalysisPlotsDirectory,...
            collapseResultsXDirectionDModel{i},'XDirection2DModel',...
            analysisOptions.XFrameLinesFor2DModels(i));
    end
end

% Generate collapse fragility curves for 2D Z-Direction Frame Line Models
if strcmp(generate2DZDirectionModelCollapseFragilityCurves,'YES') == 1
    for i = 1:length(analysisOptions.ZFrameLinesFor2DModels)
        cd(GAPFunctionsDirectory)
        generateCollapseFragilityCurves(AnalysisPlotsDirectory,...
            collapseResultsZDirectionDModel{i},'ZDirection2DModel',...
            analysisOptions.ZFrameLinesFor2DModels(i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Extract Pushover Analysis Results                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract X-Direction pushover analysis results for 3D model
if strcmp(generate3DModelXDirectionPushoverCurves,'YES') == 1
    cd(GAPFunctionsDirectory)
    pushoverResults3DModelXDirection = extractPushoverResults3DModel(...
        buildingGeometry,BuildingModelDirectory,buildingLoads,...
        'XDirection');
end

% Extract Z-Direction pushover analysis results for 3D model
if strcmp(generate3DModelZDirectionPushoverCurves,'YES') == 1
    cd(GAPFunctionsDirectory)
    pushoverResults3DModelZDirection = extractPushoverResults3DModel(...
        buildingGeometry,BuildingModelDirectory,buildingLoads,...
        'ZDirection');
end

% Extract pushover results for 2D X-Direction Frame Line Models
if strcmp(generate2DXDirectionModelPushoverCurves,'YES') == 1
    for i = 1:length(analysisOptions.XFrameLinesFor2DModels)
        % Generate OpenSees model for current frame line
        cd(GAPFunctionsDirectory)
        pushoverResultsXDirectionDModel{i} = ...
            extractPushoverResults2DModel(buildingGeometry,...
            BuildingModelDirectory,'XDirection',buildingLoads,...
            analysisOptions.XFrameLinesFor2DModels(i));
    end
end

% Extract pushover results for 2D Z-Direction Frame Line Models
if strcmp(generate2DZDirectionModelPushoverCurves,'YES') == 1
    for i = 1:length(analysisOptions.ZFrameLinesFor2DModels)
        % Generate OpenSees model for current frame line
        cd(GAPFunctionsDirectory)
        pushoverResultsZDirectionDModel{i} = ...
            extractPushoverResults2DModel(buildingGeometry,...
            BuildingModelDirectory,'ZDirection',buildingLoads,...
            analysisOptions.ZFrameLinesFor2DModels(i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Generate Pushover Curves                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate pushover curves for 3D model
if strcmp(generate3DModelXDirectionPushoverCurves,'YES') == 1
    cd(GAPFunctionsDirectory)
    generatePushoverCurves(AnalysisPlotsDirectory,...
        pushoverResults3DModelXDirection,'XDirection3DModel',1);
end

% Generate pushover curves for 3D model
if strcmp(generate3DModelZDirectionPushoverCurves,'YES') == 1
    cd(GAPFunctionsDirectory)
    generatePushoverCurves(AnalysisPlotsDirectory,...
        pushoverResults3DModelZDirection,'ZDirection3DModel',1);
end

% Generate pushover curves for 2D X-Direction Frame Line Models
if strcmp(generate2DXDirectionModelPushoverCurves,'YES') == 1
    for i = 1:length(analysisOptions.XFrameLinesFor2DModels)
        cd(GAPFunctionsDirectory)
        generatePushoverCurves(AnalysisPlotsDirectory,...
            pushoverResultsXDirectionDModel{i},'XDirection2DModel',...
            analysisOptions.XFrameLinesFor2DModels(i));
    end
end

% Generate pushover curves for 2D Z-Direction Frame Line Models
if strcmp(generate2DZDirectionModelPushoverCurves,'YES') == 1
    for i = 1:length(analysisOptions.ZFrameLinesFor2DModels)
        cd(GAPFunctionsDirectory)
        generatePushoverCurves(AnalysisPlotsDirectory,...
            pushoverResultsZDirectionDModel{i},'ZDirection2DModel',...
            analysisOptions.ZFrameLinesFor2DModels(i));
    end
end
