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
isPlotIndividualPoints =     msaInputs.isPlotCollapseMSAs;
eqNumberLIST_forStripes =    msaInputs.eqNumberLIST_forStripes;
saLevelsForStripes =         msaInputs.saLevelsForStripes;
isCollapsedForEachRun =      msaInputs.isCollapsedForEachRun;
collapseDriftThreshold =     msaInputs.collapseDriftThreshold;
isConvertToSaKircher =       msaInputs.isConvertToSaKircher;


% Loop and do for all types of analysis
for analysisTypeIndex = 1:length(analysisTypeLIST)
    msaInputs.analysisType = analysisTypeLIST{analysisTypeIndex};

    % Call the function to do the collapse MSAs for a single analysisType
    sks_PlotCollapse_singleAnaType_MSA(msaInputs);

end




