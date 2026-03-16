%function[void] = PlotPushover(analysisType, maxNumPoints, markerType)
%function[void] = ProcessSingleRun(analysisType, saLevel, eqName)
%function[void] = PlotPushoverLocalEleForce(eleNum, eleDofNum, analysisType, maxNumPoints, markerType)

% analysisType = '(MeanDesign_VarID1_v.11)_(AllVar)_(Mean)_(elasticEleWithHystHinges)';
% analysisType = '(MeanDesign_VarID1_v.13)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(MeanDesign_VarID1_v.13)_(AllVar)_(Mean)_(dispBeamColumn)';
% analysisType = '(MeanDesign_VarID1_v.14)_(AllVar)_(Mean)_(dispBeamColumn)';
% analysisType = '(DesID1_v.33)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.24noGFrm)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.23)_(AllVar)_(Mean)_(hystHinge)';
% analysisType = '(DesID1_v.33)_(gravSlabSofteningSlope)_(-1.0)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.33)_(gravSlabSofteningSlope)_(-0.1)_(nonlinearBeamColumn)';
analysisType = '(DesID1_v.47nlBmCol)_(AllVar)_(Mean)_(nonlinearBeamColumn)';


maxNumPoints = 100000000;
markerType = 'b';

% saTOneForRun = 0.85;
saTOneForRun = 0.95;
% eqNumber = 1;
eqNumber = 8;

hingeNum = 1182;

% endNum = 1;




% jointNum = 621;
% nodeNum = 1;



%function[void] = PlotHingeMomentRotTH(hingeNum, analysisType, saTOneForRun, eqNumber, maxNumPoints, markerType)
