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
        %ProcessMultipleCollapseRuns_Generalized(analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, collapseDriftThreshold, dataSavingOption);
        Prak_ProcessMultipleCollapseRuns_Generalized_withGD(idaInputs);
        disp('Process Multiple Collapse Runs - DONE')
    end
    
% Plot IDAs - both horizontal components, MIDR
    if(isPlotCollapseIDAs == 1)
        PlotCollapseIDAs(idaInputs);
        %PlotCollapseIDAs_withFixToPlotSaGeoMean(analysisTypeLIST, eqNumberLIST_forCollapseIDAs, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);
        disp('Plot Collapse IDAs - DONE')
    end
    
% Plot IDAs+PDF - both horizontal components, added on 10-sep-2026
    if(isPlotCollapseIDAsPDF == 1)          
        sks_PlotCollapseIDAsPDF(idaInputs);
        disp('Plot Collapse IDAs+PDF - DONE')
    end
   

%  RDR  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot Residual-Drift-Ratio IDAs (RDR vs Sa(T1)) - NEW
    if(isPlotCollapseIDAs_RDR == 1)
        sks_PlotCollapseIDAs_RDR(idaInputs);
        disp('Plot Collapse RDR-IDAs - DONE')
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%  PFA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(isPlotCollapseIDAs_PFA == 1)
    sks_PlotCollapseIDAs_PFA(idaInputs);
    disp('Plot Collapse PFA-IDAs - DONE')
end






















