# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.002500
set minStoryDriftRatioForCollapseMATLAB 0.040
set elementUsedForColSensModelMATLAB clough
set sensModel ID46053_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 121411
set eqFormatForCollapseList PEER-NGA_geoMean
set currentSaLevel 0.89
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 1.209847
set periodUsedForScalingGroundMotionsFromMatlab 0.7100
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 0.87
set saGeoMeanScaled 0.89
set extraSecondsToRunAnalysis 5.00
set eqTimeHistoryPreFormatted 1
