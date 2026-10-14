%
% Procedure: sks_PlotCollapse_MSA.m
% -------------------
% This procedure computes opens the needed files and plots collapse MSA's with the EQ runs as dots, and with connecting lines.  It only plots the maximum drift level
%   for the full frame.  To get the data, it opens a file that is made by processing the collapse runs.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-24-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
%
%           % ADD THESE
%
%
%
% Units: Whatever OpenSees is using - just be consistent!
% modified on 11-Jan-2026
% -------------------

function sks_PlotCollapse_MSA(msaInputs)

analysisTypeLIST =           msaInputs.analysisTypeLIST; 
eqNumberLIST =               msaInputs.eqNumberLIST;
markerTypeLine =             msaInputs.markerTypeLine;
markerTypeDot =              msaInputs.markerTypeDot;
isPlotIndividualPoints =     msaInputs.isPlotIndividualPoints;
eqNumberLIST_forStripes =    msaInputs.eqNumberLIST_forStripes;
saLevelsForStripes =         msaInputs.saLevelsForStripes;
isCollapsedForEachRun =      msaInputs.isCollapsedForEachRun;
collapseDriftThreshold =     msaInputs.collapseDriftThreshold;
isConvertToSaKircher =       msaInputs.isConvertToSaKircher;

% Unpack all 4 flags
isPlotCollapseMSAs =        msaInputs.isPlotCollapseMSAs;
isPlotCollapseMSAs_Sigma =  msaInputs.isPlotCollapseMSAs_Sigma;
isPlotCollapseMSAs_PDF =    msaInputs.isPlotCollapseMSAs_PDF;   
isPlotCollapseMSAs_RDR =    msaInputs.isPlotCollapseMSAs_RDR;
isPlotCollapseMSAs_PFA =    msaInputs.isPlotCollapseMSAs_PFA;

for analysisTypeIndex = 1:length(analysisTypeLIST)
    msaInputs.analysisType = analysisTypeLIST{analysisTypeIndex};

    % MIDR scatter — matches IDA plotType = 'MIDR'
    if isPlotCollapseMSAs == 1
        % PlotCollapse_singleAnaType_MSA(msaInputs); % conventional original file  
        msaInputs.plotType = 'MIDR';
        sks_PlotCollapse_singleAnaType_MSA(msaInputs);
        disp('Plot Collapse MSAs (MIDR) - DONE')
         % sks_PlotCollapse_singleAnaType_MSA_RDR(msaInputs);
    end

    % MIDR_Sigma — 16th/84th percentile response 
    if isPlotCollapseMSAs_Sigma == 1
        msaInputs.plotType = 'MIDR_Sigma';
        sks_PlotCollapse_singleAnaType_MSA(msaInputs);
        disp('Plot Collapse MSAs (MIDR_Sigma) - DONE')
    end

    % MIDR + PDF overlay — matches IDA plotType = 'MIDR_PDF'
    if isPlotCollapseMSAs_PDF == 1
        msaInputs.plotType = 'MIDR_PDF';
        sks_PlotCollapse_singleAnaType_MSA(msaInputs);
        disp('Plot Collapse MSAs (MIDR + PDF) - DONE')
    end

    % RDR scatter — matches IDA plotType = 'RDR_PDF'
    if isPlotCollapseMSAs_RDR == 1
        msaInputs.plotType = 'RDR_PDF';
        sks_PlotCollapse_singleAnaType_MSA(msaInputs);
        disp('Plot Collapse MSAs (RDR_PDF) - DONE')
    end

    % PFA scatter — matches IDA plotType = 'PFA_PDF'
    if isPlotCollapseMSAs_PFA == 1
        msaInputs.plotType = 'PFA_PDF';
        sks_PlotCollapse_singleAnaType_MSA(msaInputs);
        disp('Plot Collapse MSAs (PFA_PDF) - DONE')
    end

end

end
