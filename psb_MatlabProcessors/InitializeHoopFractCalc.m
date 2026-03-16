%function[void] = PlotPushover(analysisType, maxNumPoints, markerType)
%function[void] = ProcessSingleRun(analysisType, saLevel, eqName)
%function[void] = PlotPushoverLocalEleForce(eleNum, eleDofNum, analysisType, maxNumPoints, markerType)
%(nodeNum, dofNum, analysisType, saLevel, eqName, maxNumPoints, markerType)
%function[void] = PlotMCurv(analysisType, sectionNum, axialLoad, markerType)


analysisType = '(DesID1_v.25)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
maxNumPoints = 100000000;
markerType = 'b';

curvature = .00322;



% saLevel = 0.69;
% eqName = 'LP89g04CH';

% eleNum = 1;
% eleDofNum = 2;
% 
% nodeNum = 12;
% dofNum = 1;

sectionNum = 201;
% axialLoad = -925.00;
axialLoad = -218.0;



% sectionNum = 207;
% axialLoad = 0.00;


