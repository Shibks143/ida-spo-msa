

function sks_ProcessIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs)

if strcmp(IDA_or_MSA, 'IDA')
    Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
elseif strcmp(IDA_or_MSA, 'MSA')
    sks_ProcessDynamicAnalyses_proc_MSA(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseMSAs, analysisTypeLIST, modelNameLIST, eqNumberLIST,eqNumberLIST_forProcessing, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, isConvertToSaKircher, eqListForCollapseMSAs_Name);
end




