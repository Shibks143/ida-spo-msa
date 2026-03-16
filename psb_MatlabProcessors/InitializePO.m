%function[void] = PlotPushover(analysisType, maxNumPoints, markerType)
%function[void] = ProcessSingleRun(analysisType, saLevel, eqName)
%function[void] = PlotPushoverLocalEleForce(eleNum, eleDofNum, analysisType, maxNumPoints, markerType)


% analysisType = '(DesID1_v.56Corot)_(useCrackedConc)_(1.00)_(nonlinearBeamColumn)';
% analysisType = '(DesA_Buffalo_v.6)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesA_Buffalo_v.10TRIALnoGFrm)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesB_Buffalo_v.2noGFrm)_(AllVar)_(Mean)_(clough)';
analysisType = '(DesWA_ATC63_v.25newPOAlgo)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(Des12StryFrmA_ATC63_v.16)_(AllVar)_(Mean)_(clough)';

buildingHeight = -1;

% analysisType = '(DesID1_v.57)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.57noGFrmnoJnts)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.57noGFrm)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.57noGFrmnoJntsnoStrainHard)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.60)_(AllVar)_(Mean)_(hystHinge)';
% analysisType = '(DesID1_v.60temp)_(AllVar)_(Mean)_(hystHinge)';
% analysisType = '(DesID1_v.63)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID1_v.62)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.63)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.63withGFrmHyst)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID1_v.63)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID1_v.63_PostCapCheck)_(postCapStiffRatF)_(1.00)_(clough)';
% analysisType = '(DesID1_v.63_PostCapCheck)_(postCapStiffRatF)_(3.00)_(clough)';
% analysisType = '(DesID1_v.62tempPO)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID1_v.62tempPO)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.60Conc01)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.60Conc01LinBondLinShear)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.60)_(AllVar)_(Mean)_(hystHinge)';
% analysisType = '(DesID1_v.60)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID2_v.4)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID3_v.7)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID3_v.9noGFrm)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID3_v.9withGFrmWithCD)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID5_v.2)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID6_v.4)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID9_v.3noGFrm)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID10_v.3)_(AllVar)_(Mean)_(clough)';
% analysisType = '(DesID11_v.1)_(AllVar)_(Mean)_(clough)';


% modelName = 'DesID1_v.56';
% modelName = 'DesA_Buffalo_v.5';
% modelName = 'DesA_Buffalo_v.6';
% modelName = 'DesA_Buffalo_v.9noGFrm';
% modelName = 'DesA_Buffalo_v.10TRIALnoGFrm';
% modelName = 'DesB_Buffalo_v.2noGFrm';
modelName = 'DesWA_ATC63_v.25newPOAlgo';
% modelName = 'Des12StryFrmA_ATC63_v.16';



% modelName = 'DesID1_v.57';
% modelName = 'DesID1_v.57noGFrmnoJnts';
% modelName = 'DesID1_v.57noGFrm';
% modelName = 'DesID1_v.57noGFrmnoJntsnoStrainHard';
% modelName = 'DesID1_v.62';
% modelName = 'DesID1_v.63';
% modelName = 'DesID1_v.63withGFrmHyst';
% modelName = 'DesID1_v.63_PostCapCheck';
% modelName = 'DesID1_v.62tempPO';
% modelName = 'DesID1_v.60temp';
% modelName = 'DesID1_v.60Conc01';
% modelName = 'DesID1_v.60Conc01LinBondLinShear';
% modelName = 'DesID1_v.60LumpPla';
% modelName = 'DesID3_v.7';
% modelName = 'DesID3_v.9withGFrmWithCD';
% modelName = 'DesID3_v.9noGFrm';
% modelName = 'DesID5_v.2';
% modelName = 'DesID6_v.4';
% modelName = 'DesID8_v.1';
% modelName = 'DesID9_v.3noGFrm';
% modelName = 'DesID10_v.3';
% modelName = 'DesID11_v.1';


% axisLabelFontSize = 22;
% legendFontSize = 16;
% axisNumberFontSize = 18;
lineWidth = 4;

% Option to plot roof drift ratio - this just divided displacement by
% height
plotRoofDriftRatio = 1;
% plotRoofDriftRatio = 0;
% buildingHeight = 12.0 * (14.0 + 3.0 * 13.0);





maxNumPoints = 100000000;
% markerType = 'b--';
markerType = 'b-';
% markerType = 'bo';
% markerType = 'r--';
% markerType = 'k--';
% markerType = 'k';


saTOneForRun = 0.00;

% eqNumber 9911;    % 
eqNumber = 9991;  % cyclic 

eleNum = 6;
eleEndNum = 2;

% Story number for story PO
storyNum = 1;

eleDofNum = 1;
responseNum = 1;    % Axial
% responseNum = 2;    % Flexural
% 
% % Joints
% % function[void] = PlotJointNodeMRotTH(jointNum, analysisType, saTOneForRun, eqNumber, jointNodeNum, maxNumPoints, markerType)
% jointNum = 100;




