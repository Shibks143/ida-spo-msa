% 
% 
function Prak_saveDATA_Collapse(fileName, saLevelsForIDAPlotLIST, maxDriftRatioForPlotLIST, maxResidualDriftRatioForPlotLIST, maxPFAForPlotLIST, collapseSaLevel, saLevelsRunForCollapseAnalysis, isNonConvLIST, isSingularLIST, isCollapsedLIST, scaleFactorOnCompAtCollapse)
save(fileName, 'saLevelsForIDAPlotLIST', 'maxDriftRatioForPlotLIST', 'maxResidualDriftRatioForPlotLIST', 'maxPFAForPlotLIST', 'collapseSaLevel', 'saLevelsRunForCollapseAnalysis', 'isNonConvLIST', 'isSingularLIST', 'isCollapsedLIST', 'scaleFactorOnCompAtCollapse');