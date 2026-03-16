
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bldgID = 1;
% bldgID = 1000;
buildingInfo = DefineInfoForBuildings;
% analysisType = '(DesID3_v.9withGFrmWithCD)_(AllVar)_(0.00)_(clough)';
% saLevel = 2.69;
% eqNum = 941001;

% analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)';
% modelName = 'DesA_Buffalo_v.9noGFrm';
% saLevel = 4.39;
% eqNum = 11011;

% analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)';
% saLevel = 2.19;
% eqNum = 11091;

% analysisType = '(DesWA_ATC63_v.22dispEle)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
% saLevel = 2.26;
% eqNum = 11011;

% analysisType = '(DesWA_ATC63_v.25newer)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
% modelName = 'DesWA_ATC63_v.25newer';
% % saLevel = 2.46;
% % eqNum = 11011;
% % saLevel = 1.92;
% % eqNum = 11251;
% saLevel = 1.52;
% eqNum = 11141;

isEQOrPO = 1;   %EQ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% movieID = 1;
% ProcessSingleEQ_Collapse_findSaAtColAndMakeMovie_Frame(bldgID, analysisType, modelName, eqNum, movieID);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
movieID = 11;
saDefType = 3; %Type of Sa definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef)
eqNum = 11011; %11122;
saLevel = 4.92; %2.55;
analysisType = '(DesA_Buffalo_v.9noGFrm_grndDisp_Corot)_(AllVar)_(0.00)_(clough)';
modelName = 'DesA_Buffalo_v.9noGFrm_grndDisp_Corot';

CreateBuildingMovie_Frame_AndGD(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieID, saDefType);
%ProcessSingleEQ_Collapse_makeMovieForSingleSa_Frame_AndGD(bldgID, analysisType, modelName, eqNum, saLevel, movieID, isEQOrPO, saDefType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% movieID = 3;
% 
% % numAnalyses = 4;
% % analysisTypeLIST = {'(DesWA_ATC63_v.25newer)_(AllVar)_(0.00)_(nonlinearBeamColumn)', '(DesWA_ATC63_v.25newer)_(AllVar)_(0.00)_(nonlinearBeamColumn)', '(DesWA_ATC63_v.25newer)_(AllVar)_(0.00)_(nonlinearBeamColumn)', '(DesWA_ATC63_v.25newPOAlgo)_(AllVar)_(0.00)_(nonlinearBeamColumn)'};
% % modelNameLIST = {'DesWA_ATC63_v.25newer', 'DesWA_ATC63_v.25newer', 'DesWA_ATC63_v.25newer', 'DesWA_ATC63_v.25newPOAlgo'};
% % saLevelLIST = [0.92, 1.52, 0.00, 0.00];
% % eqNumLIST = [11152, 11141, 9991, 9991];
% 
% % numAnalyses = 1;
% % analysisTypeLIST = {'(DesWA_ATC63_v.25newer)_(AllVar)_(Mean)_(nonlinearBeamColumn)'};
% % modelNameLIST = {'DesWA_ATC63_v.25newer'};
% % saLevelLIST = [0.00];
% % eqNumLIST = [9991];
% 
% % for index = 1:numAnalyses
% %     analysisType = analysisTypeLIST{index};
% %     modelName = modelNameLIST{index};
% %     saLevel = saLevelLIST(index);
% %     eqNum = eqNumLIST(index);
%     ProcessSingleEQ_Collapse_makeMovieForSingleSa_Wall(bldgID, analysisType, modelName, eqNum, saLevel, movieID, isEQOrPO)
% % end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% floorDispVECTOR = [0, 15, 30, 45, 60];
%     isHingesHighlighted = 0;        % No highlighting
%     hingeHighlighted_1 = [0,0,0];   % Dummy variable
%     hingeHighlighted_2 = [0,0,0];   % Dummy variable
%     highlightedHingeColor_1 = 'k';  % Dummy variable
%     highlightedHingeColor_2 = 'k';  % Dummy variable
% 
% for currentFloorNum = 2:5
%     for currentColLineNum = 1:5
%         for currentJointNodeNum = 1:4
%             currentJointNumber = 600 + 10*currentFloorNum + currentColLineNum;
%             plasticRotationARRAY{currentJointNumber}.jointNodePHRDemand{currentJointNodeNum} = 0.005; 
%         end
%         for currentJointNodeNum = 5
%             currentJointNumber = 600 + 10*currentFloorNum + currentColLineNum;
%             plasticRotationARRAY{currentJointNumber}.jointNodePHRDemand{currentJointNodeNum} = 0.01; 
%         end
%         
%     end
% end
% 
% currentFloorNum = 1;
% for colLineNum = 1:5
%     hingeNum = 705 + colLineNum;
%     plasticRotationARRAY{hingeNum}.columnBasePHRDemand = 0.005; 
% end
% 
% DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisType, eqNum, saLevel, isHingesHighlighted, hingeHighlighted_1, hingeHighlighted_2, highlightedHingeColor_1, highlightedHingeColor_2)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% floorDispVECTOR = 13*[0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13];
% 
% for currentStoryNum = 1:12
%     curvatureDemandVECTOR{currentStoryNum} = 0.01 / (126.0*0.8);
%     shearSpringDispDemandVECTOR{currentStoryNum} = 0.0025 * 12.0*12.0;
% end
% 
% DrawDistortedWall(buildingInfo, bldgID, floorDispVECTOR, curvatureDemandVECTOR, shearSpringDispDemandVECTOR, analysisType, eqNum, saLevel);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% movieID = 1;
% CreateBuildingMovie_Wall(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieID)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %driftPlotOption = 1;    % Undeformed
% driftPlotOption = 2;    % Last time step
% %driftPlotOption = 3;    % Absoute max. over EQ
% isSaveFile = 1; % Save the file
% % titleOption = 1;    % Long
% titleOption = 2;    % Short
% DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNum, saLevel, driftPlotOption, isSaveFile, titleOption)
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CreateBuildingMovie_Frame(analysisType, buildingInfo, bldgID, eqNum, saLevel)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% colLineNum = 2;
% floorNum = 3;
% jointNodeNum = 2;
% currentAnalysisStepNum = 1;
% markerTypeLine = 'b-';
% %elementArray - must be in memory when testing this
% DrawJointResponseWithDot(buildingInfo, bldgID, analysisType, eqNum, saLevel, colLineNum, floorNum, jointNodeNum, elementArray, currentAnalysisStepNum, markerTypeLine)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xLoc = 10;
% yLoc = 15;
% circleDiameter = 5;
% ratioOfPlasticDemandToCap = 0.5;
% circleLineWidth = 1;
% circleLineStyle = '-';
% circleInnerColor = 'b';
% PlotPlasticHinge(xLoc, yLoc, circleDiameter, ratioOfPlasticDemandToCap, circleLineWidth, circleLineStyle, circleInnerColor)
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maxXOnAxis = 15;
% markerType = 'b-';
% PlotMaxDriftLevel_bothPosAndNeg_withDriftsPassedIn(storyDriftRatioToSave, numStories, analysisType, saLevel, eqNum, markerType, maxXOnAxis)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% maxXOnAxis = 15;
% markerType = 'b-';
% storyDriftRatio_Pos = 0.01*[1,3,5,10];
% storyDriftRatio_Neg = 0.01*[-4, -2, -5, -1];
% numStories = 4;
% PlotGivenDriftLevel_bothPosAndNeg_withDriftsPassedIn(storyDriftRatio_Neg, storyDriftRatio_Pos, numStories, analysisType, saLevel, eqNum, markerType, maxXOnAxis)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('DATA_allDataForThisSingleRun_tempForTesting.mat', 'elementArray');
% floorDispVECTOR = [0, 1, -2, -3, 5];
% storyDriftRatio_Pos = 0.01*[1,3,5,10];
% storyDriftRatio_Neg = 0.01*[-4, -2, -5, -1];
% currentAnalysisStepNum = 1;
% jointResponseToPlot_1 = [2, 1, 1];
% jointResponseToPlot_2 = [2, 4, 5];
% 
% for currentFloorNum = 2:5
%     for currentColLineNum = 1:5
%         for currentJointNodeNum = 1:4
%             currentJointNumber = 600 + 10*currentFloorNum + currentColLineNum;
%             plasticRotationARRAY{currentJointNumber}.jointNodePHRDemand{currentJointNodeNum} = 0.1; 
%         end
%         for currentJointNodeNum = 5
%             currentJointNumber = 600 + 10*currentFloorNum + currentColLineNum;
%             plasticRotationARRAY{currentJointNumber}.jointNodePHRDemand{currentJointNodeNum} = 0.1; 
%         end
%         
%     end
% end
% 
% currentFloorNum = 1;
% for colLineNum = 1:5
%     hingeNum = 705 + colLineNum;
%     plasticRotationARRAY{hingeNum}.columnBasePHRDemand = 0.1; 
% end
% 
% CreateSubPlotsWithBuildingAndResponses_singleAnalysisStep_Frame(buildingInfo, bldgID, analysisType, eqNum, saLevel, floorDispVECTOR, plasticRotationARRAY, elementArray, storyDriftRatio_Neg, storyDriftRatio_Pos, currentAnalysisStepNum, jointResponseToPlot_1, jointResponseToPlot_2)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% movieIndex = 2;
% % jointResponseToPlot_1 = [2, 4, 1];  % EQ 11011
% % jointResponseToPlot_2 = [2, 3, 3];
% jointResponseToPlot_1 = [4, 2, 1];  % EQ 11091
% jointResponseToPlot_2 = [3, 2, 3];
% CreateBuildingMovie_WithSubPlots_Frame(analysisType, buildingInfo, bldgID, eqNum, saLevel, movieIndex, jointResponseToPlot_1, jointResponseToPlot_2)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








