clear; clc; 
oqOutpDirDis = '..\AllOpenQuakeOutputs\Van_Dis_SaMult';
oqOutpDirHaz = '..\AllOpenQuakeOutputs\Van_Haz_SaMult';
lonLat = [-123.12 49.25]; % lonLat = [-123.37, 48.43];
imString = 'SA(4.37)'; % 'SA(2.0)' 'SA(1.0)'; 'PGA'; 
returnP = 2475; % 475 (corresponding results from OpenQuake deagg must be available)
deaggType = 'MagDistEps'; % 'MagDist'
doSave = 1;

fun_deagg_v2(oqOutpDirDis, oqOutpDirHaz, lonLat, imString, returnP, deaggType, doSave);