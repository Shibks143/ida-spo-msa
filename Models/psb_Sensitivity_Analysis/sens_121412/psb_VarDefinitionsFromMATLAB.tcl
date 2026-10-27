# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse
#     run, so that Opensees can read the file and define the needed variables

set dtForCollapseMATLAB 0.0025
set minStoryDriftRatioForCollapseMATLAB 0.120
set elementUsedForColSensModelMATLAB clough
set sensModel ID35053_R5_5Story_v.02
set sensVariableName AllVar
set sensVariableValue 0.00
set AllVar 0.00
set eqNumber 121412
set eqFormatForCollapseList PEER-NGA_geoMean
global eqDataFolder
set eqDataFolder E:/StaticDynamicAnalysis/ida-spo-msa/OpenSeesProcessingFiles/EQs
set currentSaLevel 0.52
puts "currentSaLevel is $currentSaLevel"
set scaleFactorForRunFromMatlab 1.4765
set periodUsedForScalingGroundMotionsFromMatlab 1.5600
set dampingRatioUsedForSaDefFromMatlab 0.0500
set saCompScaled 0.68
set saGeoMeanScaled 0.52
set extraSecondsToRunAnalysis 5.00
set eqTimeHistoryPreFormatted 1
set analysisMode IDA
