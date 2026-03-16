%
% Procedure: PlotCollapseIDAs.m
% -------------------
% This procedure computes opens the needed files and plots collapse IDA's with the EQ runs as dots, and with connecting lines.  It only plots the maximum drift level
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
%
% -------------------
function[void] = PlotCollapseIDAs(analysisTypeLIST, eqNumberLIST, eqListForCollapseIDAs_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, isConvertToSaKircher)


% Loop and do for all types of analysis
for analysisTypeIndex = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeIndex};

    % Call the function to do the collapse IDAs for a single analysisType
    PlotCollapseIDAs_singleAnaType(analysisType, eqNumberLIST, eqListForCollapseIDAs_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, isConvertToSaKircher);

end




