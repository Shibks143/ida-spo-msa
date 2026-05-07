# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.0050
set minStoryDriftRatioForCollapseMATLAB 0.080
set elementUsedForColSensModelMATLAB clough
set sensModel ID2433_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 120711
set eqFormatForCollapseList PEER-NGA_geoMean
set currentSaLevel 2.44
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 2.6274
set periodUsedForScalingGroundMotionsFromMatlab 0.7100
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 2.12
set saGeoMeanScaled 2.44
set extraSecondsToRunAnalysis 0.00
set eqTimeHistoryPreFormatted 1
