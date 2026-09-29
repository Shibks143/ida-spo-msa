%
% Procedure: PlotCollapseIDAs.m
% -------------------
% This procedure opens the needed files and plots collapse IDAs:
%   1. MIDR (Max Interstory Drift Ratio) vs Sa(T1)
%   2. MIDR + PDF overlaid
%   3. RDR (Residual Drift Ratio) vs Sa(T1)
%   4. PFA (Peak Floor Acceleration) vs Sa(T1)
%
%
% Assumptions and Notices:
%   - This must be run with the current directory in the MatlabProcessors folder.
%
% Author: Curt Haselton
% Modified by: Shivakumar KS on 24-Sep-2026
% -------------------
function[void] = sks_PlotCollapseIDAs(idaInputs)

isPlotCollapseIDAs    = idaInputs.isPlotCollapseIDAs;
isPlotCollapseIDAsPDF = idaInputs.isPlotCollapseIDAsPDF;
isPlotCollapseIDAs_RDR = idaInputs.isPlotCollapseIDAs_RDR;
isPlotCollapseIDAs_PFA = idaInputs.isPlotCollapseIDAs_PFA;
analysisTypeLIST       = idaInputs.analysisTypeLIST;


    for analysisTypeIndex = 1:length(analysisTypeLIST)
        idaInputs.analysisType = analysisTypeLIST{analysisTypeIndex};

        if isPlotCollapseIDAs == 1
            % PlotCollapseIDAs_singleAnaType(idaInputs); % conventional original file
            idaInputs.plotType = 'MIDR';
            sks_PlotCollapseIDAs_singleAnaType(idaInputs);
            disp('Plot Collapse IDAs (MIDR) - DONE')
        end

        if isPlotCollapseIDAsPDF == 1
            idaInputs.plotType = 'MIDR_PDF';
            sks_PlotCollapseIDAs_singleAnaType(idaInputs);
            disp('Plot Collapse IDAs + MIDR_PDF - DONE')
        end

        if isPlotCollapseIDAs_RDR == 1
            idaInputs.plotType = 'RDR_PDF';
            sks_PlotCollapseIDAs_singleAnaType(idaInputs);
            disp('Plot Collapse IDAs + RDR_PDF - DONE')
        end
    
        if isPlotCollapseIDAs_PFA == 1
            idaInputs.plotType = 'PFA_PDF';
            sks_PlotCollapseIDAs_singleAnaType(idaInputs);
            disp('Plot Collapse IDAs + PFA_PDF - DONE')
        end

    end
end




