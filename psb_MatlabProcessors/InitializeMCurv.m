%function[void] = PlotPushover(analysisType, maxNumPoints, markerType)
%function[void] = ProcessSingleRun(analysisType, saLevel, eqName)
%function[void] = PlotPushoverLocalEleForce(eleNum, eleDofNum, analysisType, maxNumPoints, markerType)
%(nodeNum, dofNum, analysisType, saLevel, eqName, maxNumPoints, markerType)
%function[void] = PlotMCurv(analysisType, sectionNum, axialLoad, markerType)


analysisType = '(DesWA_ATC63_v.15dispEleOrigConc)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
maxNumPoints = 100000000;
markerType = 'b';

% saLevel = 0.69;
% eqName = 'LP89g04CH';

% eleNum = 1;
% eleDofNum = 2;
% 
% nodeNum = 12;
% dofNum = 1;

sectionNum = 101;
axialLoad = -14400.00;
% axialLoad = 0.00;



% sectionNum = 207;
% axialLoad = 0.00;


