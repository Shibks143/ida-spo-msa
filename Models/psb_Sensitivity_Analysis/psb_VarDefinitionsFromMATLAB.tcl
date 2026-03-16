# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.0500
set minStoryDriftRatioForCollapseMATLAB 0.180
set elementUsedForColSensModelMATLAB clough
set sensModel Arch_8story_ID1012_v.61_modForSF
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 120921
set eqFormatForCollapseList PEER-NGA_geoMean
set currentSaLevel 0.77
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 6.5534
set periodUsedForScalingGroundMotionsFromMatlab 1.8000
set dampingRatioUsedForSaDefFromMatlab 0.0650
set saCompScaled 0.65
set saGeoMeanScaled 0.77
set extraSecondsToRunAnalysis 0.00
