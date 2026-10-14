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
analysisTypeLIST =              msaInputs.analysisTypeLIST;
analysisType   =                msaInputs.analysisType;
modelNameLIST =                 msaInputs.modelNameLIST;
eqNumberLIST =                  msaInputs.eqNumberLIST;
saLevelsForStripes =            msaInputs.saLevelsForStripes;
isCollapsedForEachRun =         msaInputs.isCollapsedForEachRun;
isConvertToSaKircher =          msaInputs.isConvertToSaKircher;
extraSecondsToRunAnalysis =     msaInputs.extraSecondsToRunAnalysis;

isPlotCollapseMSAs =            msaInputs.isPlotCollapseMSAs;
isPlotCollapseMSAs_Sigma =      msaInputs.isPlotCollapseMSAs_Sigma;
isPlotCollapseMSAs_PDF =        msaInputs.isPlotCollapseMSAs_PDF;
isPlotCollapseMSAs_RDR =        msaInputs.isPlotCollapseMSAs_RDR;
isPlotCollapseMSAs_PFA =        msaInputs.isPlotCollapseMSAs_PFA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing

    % Process multiple collapse runs
    if (isProcessMultipleCollapseRuns == 1)
        sks_ProcessMultipleCollapseRuns_Generalized_withGD_MSA(msaInputs);
        disp('Process Multiple Collapse Runs - DONE')

    end
    

    % Plot MSAs - both horizontal components
    % Plot MSAs, MSAs_Sigma, MIDR_PDF, RDR_PDF, PFA_PDF
    if isPlotCollapseMSAs == 1 || isPlotCollapseMSAs_Sigma == 1 || isPlotCollapseMSAs_PDF  == 1 || isPlotCollapseMSAs_RDR   == 1 || isPlotCollapseMSAs_PFA  == 1
        sks_PlotCollapse_MSA(msaInputs);
        disp('Plot Collapse MSAs - DONE')
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      

    

