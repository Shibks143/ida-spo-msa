

 function sks_RunIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs)

% clear; clc;
% cd E:\OpenSees_PracticeExamples\ida-spo-temp\Models\psb_Sensitivity_Analysis
% 
% analysisTypeLIST = {'(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'};
% modelNameLIST = {'ID2433_R5_5Story_v.02'};
% analysisType = analysisTypeLIST{1}; 
% sensModelLIST = modelNameLIST;              % Just another variable name for a different processor
% IDA_or_MSA = 'MSA';

% minStoryDriftRatioForCollapseMATLAB = 0.12;
% dtForCollapseMATLAB = 2;
% saStartLevel = 0.11;
% startStepSize = 0.30;
% tolerance = 0.05;
% maxNumRuns = 60;
% perturbationForNonConvSingular = 0.03;
% elementUsedForColSensModelMATLAB = 'clough';
% sensVariableNameLIST    = {'AllVar'};
% sensVariableValueLIST   = [0.00];
% sigmaLnModeling = 0.50;
% periodUsedForScalingGroundMotions = 0.71;
% dampingRatioUsedForSaDef = 0.05;
% extraSecondsToRunAnalysis = 0.00;
% eqListID = 'setTest';
% saLevelsForStripes = [0.45 1.55];
% 
% % Test GM set
% eqNumberLIST_forProcessing_SetTest = [120121, 120122, 121221, 121222]; % replaced last 2 GMs by EQs of shorter duration
% eqListForCollapseIDAs_Name_SetTest = 'GMSetTest';
% eqNumberLIST_forCollapseIDAs_SetTest = [12012, 12122];
% % eqNumberLIST_forProcessing_SetTest = [120121]; % replaced last 2 GMs by EQs of shorter duration
% % eqListForCollapseIDAs_Name_SetTest = 'GMSetTest';
% % eqNumberLIST_forCollapseIDAs_SetTest = [12012];
% eqFormatForCollapseList_SetTest = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
% flagForEQFileFormat_SetTest = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
% eqTimeHistoryPreFormatted = 1; 
% 
% eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
% eqFormatForCollapseList = eqFormatForCollapseList_SetTest;
% flagForEQFileFormat = flagForEQFileFormat_SetTest;


% msaInputs.dtForCollapseMATLAB                 =  dtForCollapseMATLAB;
% msaInputs.minStoryDriftRatioForCollapseMATLAB =  minStoryDriftRatioForCollapseMATLAB ;
% msaInputs.elementUsedForColSensModelMATLAB =     elementUsedForColSensModelMATLAB ;
% msaInputs.eqFormatForCollapseList =              eqFormatForCollapseList ;
% msaInputs.sensModelLIST =                        sensModelLIST ;
% msaInputs.sensVariableNameLIST =                 sensVariableNameLIST ;
% msaInputs.sensVariableValueLIST =                sensVariableValueLIST ;
% msaInputs.eqNumberLIST =                         eqNumberLIST ;
% msaInputs.saStartLevel =                         saStartLevel ;
% msaInputs.startStepSize =                        startStepSize ;
% msaInputs.saLevelsForStripes =                   saLevelsForStripes ;
% msaInputs.tolerance =                            tolerance ;
% msaInputs.maxNumRuns =                           maxNumRuns ;
% msaInputs.perturbationForNonConvSingular =       perturbationForNonConvSingular ;
% msaInputs.flagForEQFileFormat =                  flagForEQFileFormat ;
% msaInputs.periodUsedForScalingGroundMotions =    periodUsedForScalingGroundMotions ;
% msaInputs.dampingRatioUsedForSaDef =             dampingRatioUsedForSaDef ;
% msaInputs.extraSecondsToRunAnalysis =            extraSecondsToRunAnalysis ;
% msaInputs.eqTimeHistoryPreFormatted =            eqTimeHistoryPreFormatted ;

if strcmp(IDA_or_MSA, 'IDA')
    psb_RunCollapseAnaMATLAB_NEWER_proc(idaInputs);
elseif strcmp(IDA_or_MSA, 'MSA')
    sks_RunCollapseAnaMATLAB_MSA(msaInputs);
end



