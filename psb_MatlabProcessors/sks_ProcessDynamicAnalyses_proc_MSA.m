% Procedure: ProcessDynamicAnalyses_proc.m
% -------------------
% This is a procedure to process all of the dynamic analyses.
%
% Author: Curt Haselton 
% Date Written: 6-28-06
% Modified on 9th Jan 2026
% -------------------
function sks_ProcessDynamicAnalyses_proc_MSA(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseMSAs, analysisTypeLIST, modelNameLIST, eqNumberLIST,eqNumberLIST_forProcessing, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, isConvertToSaKircher, eqListForCollapseMSAs_Name)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing

    % Process multiple collapse runs
    if (isProcessMultipleCollapseRuns == 1)
        sks_ProcessMultipleCollapseRuns_Generalized_withGD_MSA(analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, collapseDriftThreshold, dataSavingOption, eqListForCollapseMSAs_Name);
        disp('Process Multiple Collapse Runs - DONE')

    end
    
    % Plot MSAs - both horizontal components
    if (isPlotCollapseMSAs ==1)
        sks_PlotCollapse_MSA(analysisTypeLIST, eqNumberLIST, markerTypeLine, markerTypeDot, isPlotIndividualPoints, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, collapseDriftThreshold, isConvertToSaKircher, eqListForCollapseMSAs_Name);
        disp('Plot Collapse MSAs - DONE')
    end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
























