function sks_PlotCollapseIDAsPDF(idaInputs)
% SKS_PLOTCOLLAPSEIDASPDF Iterates over analysis types to compute and plot
% Collapse IDAs overlaid with target drift probability density functions (PDFs).

analysisTypeLIST = idaInputs.analysisTypeLIST;

    for analysisTypeIndex = 1:length(analysisTypeLIST)
        analysisType = analysisTypeLIST{analysisTypeIndex};
        idaInputs.analysisType = analysisType;
    
        % Step 1: run the IDA + fragility processing for this analysisType
        % (this also saves saValsAtTargetDriftControl into fragFileName,
        %  once you've made the one-line edit to the save() call)
        sks_PlotCollapseIDAsPDF_singleAnaType(idaInputs);
    
        % Step 2: plot empirical CDFs across all MIDR levels for the same case
        PlotCollapseEmpiricalCDFWithFits_allMIDR_proc(idaInputs);
    end
end