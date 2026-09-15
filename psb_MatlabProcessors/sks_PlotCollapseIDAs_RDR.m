function[void] = sks_PlotCollapseIDAs_RDR(idaInputs)
% Plot Residual-Drift-Ratio IDAs (RDR vs Sa(T1)) for all analysis types.
% Follows the same pattern as PlotCollapseIDAs.

    analysisTypeLIST = idaInputs.analysisTypeLIST;

    % Loop and do for all types of analysis
    for analysisTypeIndex = 1:length(analysisTypeLIST)
        analysisType = analysisTypeLIST{analysisTypeIndex};
        idaInputs.analysisType = analysisType;      % set current analysis type

        % Call the function to do the RDR IDAs for a single analysisType
        sks_PlotCollapseIDAs_singleAnaType_RDR(idaInputs);
        sks_PlotCollapseEmpiricalCDFWithFits_allRDR_proc(idaInputs);


    end
end