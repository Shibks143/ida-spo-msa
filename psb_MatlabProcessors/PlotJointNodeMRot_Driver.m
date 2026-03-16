% analysisType = '(DesID1_v.60)_(AllVar)_(0.00)_(clough)';
% modelName = 'DesID1_v.60';

analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'; 
modelName = 'DesA_Buffalo_v.9noGFrm';



maxNumPoints = 100000000;
markerType = 'b';

saTOneForRun = 4.39;
eqNumber = 11011;

jointNum = 622;
jointNodeNum = 1;   % Shear panel





% Do plot
PlotJointNodeMRotTH(jointNum, analysisType, saTOneForRun, eqNumber, jointNodeNum, maxNumPoints, markerType)
