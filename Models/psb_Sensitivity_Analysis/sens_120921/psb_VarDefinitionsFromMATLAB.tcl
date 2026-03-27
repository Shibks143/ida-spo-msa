# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.001250
set minStoryDriftRatioForCollapseMATLAB 0.040
set elementUsedForColSensModelMATLAB clough
set sensModel ID2433_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 120921
set eqFormatForCollapseList PEER-NGA_geoMean
set currentSaLevel 1.58
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 2.156180
set periodUsedForScalingGroundMotionsFromMatlab 0.7100
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 0.97
set saGeoMeanScaled 1.58
set extraSecondsToRunAnalysis 8.00
set eqTimeHistoryPreFormatted 1
