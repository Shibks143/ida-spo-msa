% analysisType = '(DesID1_v.60)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.57LumpPlaNoCDNoGFrmCorot)_(AllVar)_(0.00)_(hystHinge)';
analysisType = '(DesID1_v.60)_(AllVar)_(0.00)_(clough)';

modelName = 'DesID1_v.60';
% modelName = 'DesID1_v.57LumpPlaNoCDNoGFrmCorot';


maxNumPoints = 100000000;
markerType = 'b';

saTOneForRun = 0.51;
eqNumber = 941001;

jointNum = 644;
jointNodeNum = 5;   % Shear panel






function[void] = PlotJointNodeMRotTH(jointNum, analysisType, saTOneForRun, eqNumber, jointNodeNum, maxNumPoints, markerType)
