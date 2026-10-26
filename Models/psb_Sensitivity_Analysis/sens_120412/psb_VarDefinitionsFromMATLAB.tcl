# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.0050
set minStoryDriftRatioForCollapseMATLAB 0.120
set elementUsedForColSensModelMATLAB clough
set sensModel ID46053_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 120412
set eqFormatForCollapseList PEER-NGA_geoMean
global eqDataFolder
set eqDataFolder E:/StaticDynamicAnalysis/ida-spo-msa/OpenSeesProcessingFiles/EQs
set currentSaLevel 2.26
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 5.5304
set periodUsedForScalingGroundMotionsFromMatlab 1.3600
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 3.14
set saGeoMeanScaled 2.26
set extraSecondsToRunAnalysis 5.00
set eqTimeHistoryPreFormatted 1
set analysisMode IDA
