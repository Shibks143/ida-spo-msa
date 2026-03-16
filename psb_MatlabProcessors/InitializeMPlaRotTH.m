%function[void] = PlotPushover(analysisType, maxNumPoints, markerType)
%function[void] = ProcessSingleRun(analysisType, saLevel, eqName)
%function[void] = PlotPushoverLocalEleForce(eleNum, eleDofNum, analysisType, maxNumPoints, markerType)

% analysisType = '(MeanDesign_VarID1_v.11)_(AllVar)_(Mean)_(elasticEleWithHystHinges)';
% analysisType = '(MeanDesign_VarID1_v.13)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(MeanDesign_VarID1_v.13)_(AllVar)_(Mean)_(dispBeamColumn)';
% analysisType = '(MeanDesign_VarID1_v.14)_(AllVar)_(Mean)_(dispBeamColumn)';
% analysisType = '(DesID1_v.34b)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.24noGFrm)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.23)_(AllVar)_(Mean)_(hystHinge)';
analysisType = '(DesID1_v.47nlBmCol)_(AllVar)_(Mean)_(nonlinearBeamColumn)';


maxNumPoints = 100000000;
markerType = 'b';

% saTOneForRun = 0.10;
% saTOneForRun = 0.19;
% saTOneForRun = 0.26;
% saTOneForRun = 0.33;
% saTOneForRun = 0.44;
% saTOneForRun = 0.55;
saTOneForRun = 0.82;

% eqNumber = 300;
% eqNumber = 200;
% eqNumber = 100;
% eqNumber = 700;
% eqNumber = 600;
% eqNumber = 500;
% eqNumber = 400;
eqNumber = 404;

eleNum = 9;
endNum = 2;








%function[void] = PlotHingeMomentRotTH(hingeNum, analysisType, saTOneForRun, eqNumber, maxNumPoints, markerType)
