# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.0050
set minStoryDriftRatioForCollapseMATLAB 0.120
set elementUsedForColSensModelMATLAB clough
set sensModel ID2433_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 120122
set eqFormatForCollapseList PEER-NGA_geoMean
set currentSaLevel 1.48
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 6.6612
set periodUsedForScalingGroundMotionsFromMatlab 1.8400
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 1.14
set saGeoMeanScaled 1.48
set extraSecondsToRunAnalysis 0.00
set eqTimeHistoryPreFormatted 1
