# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.0025
set minStoryDriftRatioForCollapseMATLAB 0.120
set elementUsedForColSensModelMATLAB clough
set sensModel ID46053_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 80022
set eqFormatForCollapseList PEER-NGA_geoMean
global eqDataFolder
set eqDataFolder E:/StaticDynamicAnalysis/ida-spo-msa/OpenSeesProcessingFiles/EQs
set currentSaLevel 2.32
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 11.2870
set periodUsedForScalingGroundMotionsFromMatlab 0.7100
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 2.21
set saGeoMeanScaled 2.32
set extraSecondsToRunAnalysis 5.00
set eqTimeHistoryPreFormatted 1
