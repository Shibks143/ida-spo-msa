% Procedure: ProcessDynamicAnalyses_proc.m
% -------------------
%   This is a procedure to process all of the dynamic analyses.
%
% Author: Curt Haselton 
% Date Written: 6-28-06
% -------------------
function[void] = Prak_ProcessDynamicAnalyses_proc(idaInputs)

isProcessMultipleCollapseRuns = idaInputs.isProcessMultipleCollapseRuns;
isPlotCollapseIDAs = idaInputs.isPlotCollapseIDAs;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing
    % Process multiple collapse runs
    if(isProcessMultipleCollapseRuns == 1)
        %ProcessMultipleCollapseRuns_Generalized(analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, collapseDriftThreshold, dataSavingOption);
        Prak_ProcessMultipleCollapseRuns_Generalized_withGD(idaInputs);
        disp('Process Multiple Collapse Runs - DONE')
    end
    
% Plot IDAs - both horizontal components
    if(isPlotCollapseIDAs == 1)
        PlotCollapseIDAs(idaInputs);
        %PlotCollapseIDAs_withFixToPlotSaGeoMean(analysisTypeLIST, eqNumberLIST_forCollapseIDAs, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);
        disp('Plot Collapse IDAs - DONE')
    end
    
    % Plot IDAs - single horizontal component
    %if(isPlotCollapseIDAs_singleComp == 1)
    %    PlotCollapseIDAs_SingleComp(analysisTypeLIST, eqNumberLIST_forProcessing, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);
    %end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
























