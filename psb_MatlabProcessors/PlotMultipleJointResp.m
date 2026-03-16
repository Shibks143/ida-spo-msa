



% analysisType = '(DesID1_v.63)_(AllVar)_(0.00)_(clough)';
% analysisType = '(DesID1_v.63)_(hingeStrColF)_(1.26)_(clough)';
% analysisType = '(DesID1_v.63_PostCapCheck)_(postCapStiffRatF)_(1.00)_(clough)';
% analysisType = '(DesID1_v.63_PostCapCheck)_(postCapStiffRatF)_(3.00)_(clough)';
analysisType = '(DesC_Buffalo_v.7noGFrm)_(AllVar)_(Mean)_(clough)'; 


maxNumPoints = 100000000;
markerType = 'b';

saTOneForRun = 0.25;
eqNumber = 11071;



% jointNumberLIST = [621];

% jointNumberLIST = [621, 622, 623, 624, 625, 631, 632, 633, 634, 635, 641, 642, 643, 644, 645, 651, 652, 653, 654, 655];
% jointNumberLIST = [621, 622, 623, 624, 625];
% jointNumberLIST = [631, 632, 633, 634, 635];
% jointNumberLIST = [641, 642, 643, 644, 645];
jointNumberLIST = [651, 652, 653, 654, 655];
% jointNumberLIST = [622];

nodeNumberLIST = [1,2,3,4,5];
% nodeNumberLIST = [5];
% nodeNumberLIST = [1];

figureNum = 1;

for jointIndex = 1:length(jointNumberLIST)
    for nodeIndex = 1:length(nodeNumberLIST)
        
        jointNodeNum = nodeNumberLIST(nodeIndex);        
        jointNum = jointNumberLIST(jointIndex);
        
        figure(figureNum)
        
        %%PlotJointNodeMRotTH
        PlotJointNodeMRotTH(jointNum, analysisType, saTOneForRun, eqNumber, jointNodeNum, maxNumPoints, markerType);

        figureNum = figureNum + 1;
        
    end
end







