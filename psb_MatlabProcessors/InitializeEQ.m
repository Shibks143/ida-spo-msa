





% analysisType = '(MeanDesign_VarID1_v.13)_(AllVar)_(Mean)_(hystHinge)';
% analysisType = '(MeanDesign_VarID1_v.13)_(AllVar)_(Mean)_(dispBeamColumn)';
% analysisType = '(MeanDesign_VarID1_v.13)_(TEMP_TEST)_(Mean)_(hystHinge)';
% analysisType = '(DesID1_v.20)_(AllVar)_(Mean)_(dispBeamColumn)';
% analysisType = '(DesID1_v.31)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.31lowdT)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.29)_(AllVar)_(Mean)_(BeamWHinges)';
% analysisType = '(DesID1_v.26noGFrm)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.31)_(gTransf)_(Corotational)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.31)_(gTransf)_(LinearWithPDelta)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.32)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.33)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.33)_(gravSlabSofteningSlope)_(-1.0)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.33)_(gravSlabSofteningSlope)_(-0.1)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.34)_(AllVar)_(Mean)_(genYS)';
% analysisType = '(DesID1_v.44)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.51)_(slabHingeCapRotF)_(0.48)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.51FixSplice)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.52)_(AllVar)_(Mean)_(hystHinge)';
% analysisType = '(DesID1_v.53)_(AllVar)_(Mean)_(hystHinge)';
% analysisType = '(DesID1_v.56Corot)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.60)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.57LumpPlaNoCDNoGFrmCorot)_(AllVar)_(0.00)_(hystHinge)';
% analysisType = '(DesID1_v.63)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.63)_(AllVar)_(0.00)_(clough)';
% analysisType = '(DesID1_v.63)_(cappingRotationF)_(1.87)_(clough)';
% analysisType = '(DesID1_v.63)_(hingeStrColF)_(1.26)_(clough)';
% analysisType = '(DesID1_v.63)_(dampRatF)_(0.00)_(nonlinearBeamColumn)';

%analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'; 
% analysisType = '(DesWA_ATC63_v.22dispEle)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
analysisType = '(DesWA_ATC63_v.25newer)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.51)_(bmDesStrF)_(0.65)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.51)_(SCWBDesF)_(1.26)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.47pinchDmg)_(AllVar)_(Mean)_(pinchDmgHinge)';
% analysisType = '(DesID1_v.43noGFrm)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
% analysisType = '(DesID1_v.34)_(AllVar)_(Mean)_(genYS)';


% modelName = 'DesID1_v.51FixSplice';
% modelName = 'DesID1_v.52';
% modelName = 'DesID1_v.53';
% modelName = 'DesID1_v.56Corot';
% modelName = 'DesID1_v.63';
% modelName = 'DesID1_v.57LumpPlaNoCDNoGFrmCorot';
% modelName = 'DesA_Buffalo_v.9noGFrm';
% modelName = 'DesWA_ATC63_v.22dispEle';
modelName = 'DesWA_ATC63_v.25newer';


maxNumPoints = 100000000;
% markerType = 'r';
markerType = 'b';
% markerType = 'r--';

markerType1 = 'b';
markerType2 = 'r';

% saTOneForRun = 0.10;
% saTOneForRun = 0.19;
% saTOneForRun = 0.30;
% saTOneForRun = 0.44;
% saTOneForRun = 0.55;
% saTOneForRun = 0.82;
% saTOneForRun = 2.59;
saTOneForRun = 2.46; %2.26; %2.19; %4.39;



% eqNumber = 754;
% eqNumber = 941082;
% eqNumber = 100;
% eqNumber = 700;
% eqNumber = 601;
% eqNumber = 500;
eqNumber = 11011; %11091; 
% eqNumber = 407;
% eqNumber = 9999;






% eqNumber = 4;

eleNum = 2;
eleDofNum = 3;

% nodeNum = 72;
%nodeNum = 74;   % Roof 
nodeNum = 54;   % Floor 4
% nodeNum = 132;

dofNum = 1;

jointNum = 622;
jointNodeNum = 5;

hingeNum = 1150;

floorNum = 5;
dtForSpectrum = 0.05;
maxPeriodForSpectrum = 2.0;
dampRatio = 0.05;

dampRatioLIST = [0.01, 0.01, 0.02, 0.05, 0.10]; % NOTE that legend is manual











