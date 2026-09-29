% Procedure: ProcessDynamicAnalyses_proc.m
% -------------------
%   This is a procedure to process all of the dynamic analyses.
%
% Author: Curt Haselton 
% Date Written: 6-28-06
% -------------------
function[void] = Prak_ProcessDynamicAnalyses_proc(idaInputs)

isProcessMultipleCollapseRuns = idaInputs.isProcessMultipleCollapseRuns;
isPlotCollapseIDAs =            idaInputs.isPlotCollapseIDAs;
isPlotCollapseIDAsPDF =         idaInputs.isPlotCollapseIDAsPDF;
isPlotCollapseIDAs_RDR =        idaInputs.isPlotCollapseIDAs_RDR;
isPlotCollapseIDAs_PFA =        idaInputs.isPlotCollapseIDAs_PFA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing
    % Process multiple collapse runs
    if(isProcessMultipleCollapseRuns == 1)
        Prak_ProcessMultipleCollapseRuns_Generalized_withGD(idaInputs);
        disp('Process Multiple Collapse Runs - DONE')
    end
    
    % Plot IDAs - MIDR, MIDR+PDF, RDR, PFA - all handled in PlotCollapseIDAs
    if (isPlotCollapseIDAs == 1 || isPlotCollapseIDAsPDF == 1 || isPlotCollapseIDAs_RDR == 1 || isPlotCollapseIDAs_PFA == 1)
        sks_PlotCollapseIDAs(idaInputs);
    end




















