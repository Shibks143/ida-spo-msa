# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.0025
set minStoryDriftRatioForCollapseMATLAB 0.060
set elementUsedForColSensModelMATLAB clough
set sensModel ID46053_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 70132
set eqFormatForCollapseList PEER-NGA_geoMean
set currentSaLevel 5.02
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 7.2109
set periodUsedForScalingGroundMotionsFromMatlab 0.7100
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 4.89
set saGeoMeanScaled 5.02
set extraSecondsToRunAnalysis 5.00
set eqTimeHistoryPreFormatted 1
