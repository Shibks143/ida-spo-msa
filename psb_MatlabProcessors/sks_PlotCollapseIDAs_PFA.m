% -------------------
% Procedure: sks_PlotCollapseIDAs_PFA.m
% -------------------
% Plot Peak-Floor-Acceleration IDAs (PFA vs Sa(T1)) for all analysis types.
% Follows the same pattern as sks_PlotCollapseIDAs_RDR.m.
%
% Author: [shivakuamr K S]
% Date Written: 14-Sep-2026
% -------------------

function[void] = sks_PlotCollapseIDAs_PFA(idaInputs)

analysisTypeLIST = idaInputs.analysisTypeLIST;

% Loop and do for all types of analysis
for analysisTypeIndex = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeIndex};
    idaInputs.analysisType = analysisType;      % set current analysis type

    % Call the function to do the PFA IDAs for a single analysisType
    sks_PlotCollapseIDAs_singleAnaType_PFA(idaInputs);
    sks_PlotCollapseEmpiricalCDFWithFits_allPFA_proc(idaInputs);
end

end