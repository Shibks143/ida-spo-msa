% Procedure: ProcessDynamicAnalyses_proc.m
% -------------------
% This is a procedure to process all of the dynamic analyses.
%
% Author: Curt Haselton 
% Date Written: 6-28-06
% Modified on 9th Jan 2026
% -------------------
function sks_ProcessDynamicAnalyses_proc_MSA(msaInputs)

collapseDriftThreshold =        msaInputs.collapseDriftThreshold;
dataSavingOption =              msaInputs.dataSavingOption;
markerTypeLine =                msaInputs.markerTypeLine;
markerTypeDot =                 msaInputs.markerTypeDot;
isPlotIndividualPoints =        msaInputs.isPlotIndividualPoints;
isProcessMultipleCollapseRuns = msaInputs.isProcessMultipleCollapseRuns;
isPlotCollapseMSAs =            msaInputs.isPlotCollapseMSAs;
analysisTypeLIST =              msaInputs.analysisTypeLIST;
analysisType   =                msaInputs.analysisType;
modelNameLIST =                 msaInputs.modelNameLIST;
eqNumberLIST =                  msaInputs.eqNumberLIST;
% eqNumberLIST_forProcessing =    msaInputs.eqNumberLIST_forProcessing;
% eqNumberLIST_forStripes =       msaInputs.eqNumberLIST_forStripes;
saLevelsForStripes =            msaInputs.saLevelsForStripes;
isCollapsedForEachRun =         msaInputs.isCollapsedForEachRun;
isConvertToSaKircher =          msaInputs.isConvertToSaKircher;
extraSecondsToRunAnalysis    =  msaInputs.extraSecondsToRunAnalysis;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing

    % Process multiple collapse runs
    if (isProcessMultipleCollapseRuns == 1)
        sks_ProcessMultipleCollapseRuns_Generalized_withGD_MSA(msaInputs);
        disp('Process Multiple Collapse Runs - DONE')

    end
    
    % Plot MSAs - both horizontal components
    if (isPlotCollapseMSAs ==1)
        sks_PlotCollapse_MSA(msaInputs);
        disp('Plot Collapse MSAs - DONE')
    end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
























