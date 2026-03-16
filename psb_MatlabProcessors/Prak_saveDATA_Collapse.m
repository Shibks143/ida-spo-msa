% 
% 
function Prak_saveDATA_Collapse(fileName, saLevelsForIDAPlotLIST, maxDriftRatioForPlotLIST, collapseSaLevel, saLevelsRunForCollapseAnalysis, isNonConvLIST, isSingularLIST, isCollapsedLIST, scaleFactorOnCompAtCollapse)
save(fileName, 'saLevelsForIDAPlotLIST', 'maxDriftRatioForPlotLIST', 'collapseSaLevel', 'saLevelsRunForCollapseAnalysis', 'isNonConvLIST', 'isSingularLIST', 'isCollapsedLIST', 'scaleFactorOnCompAtCollapse');