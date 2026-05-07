# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.0025
set minStoryDriftRatioForCollapseMATLAB 0.080
set elementUsedForColSensModelMATLAB clough
set sensModel ID2433_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 120822
set eqFormatForCollapseList PEER-NGA_geoMean
set currentSaLevel 0.88
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 4.7601
set periodUsedForScalingGroundMotionsFromMatlab 0.7100
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 0.98
set saGeoMeanScaled 0.88
set extraSecondsToRunAnalysis 0.00
set eqTimeHistoryPreFormatted 1
