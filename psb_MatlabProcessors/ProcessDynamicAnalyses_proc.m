% Procedure: ProcessDynamicAnalyses_proc.m
% -------------------
%   This is a procedure to process all of the dynamic analyses.
%
% Author: Curt Haselton 
% Date Written: 6-28-06
% -------------------
function[void] = ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing
    % Process multiple collapse runs
    if(isProcessMultipleCollapseRuns == 1)
        %ProcessMultipleCollapseRuns_Generalized(analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, collapseDriftThreshold, dataSavingOption);
        ProcessMultipleCollapseRuns_Generalized_withGD(analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, collapseDriftThreshold, dataSavingOption);
        disp('Process Multiple Collapse Runs - DONE')
    end
    
    % Plot IDAs - both horizontal components
    if(isPlotCollapseIDAs == 1)
        PlotCollapseIDAs(analysisTypeLIST, eqNumberLIST_forCollapseIDAs, eqListForCollapseIDAs_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, isConvertToSaKircher);
        % For old Benchmark runs
        %PlotCollapseIDAs_withFixToPlotSaGeoMean(analysisTypeLIST, eqNumberLIST_forCollapseIDAs, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);
        disp('Plot Collapse IDAs - DONE')
    end
    
    % Plot IDAs - single horizontal component
    %if(isPlotCollapseIDAs_singleComp == 1)
    %    PlotCollapseIDAs_SingleComp(analysisTypeLIST, eqNumberLIST_forProcessing, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);
    %end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
























