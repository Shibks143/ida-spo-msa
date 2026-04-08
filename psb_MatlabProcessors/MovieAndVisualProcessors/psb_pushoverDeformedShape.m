function [] = psb_pushoverDeformedShape(bldgID_LIST, analysisDirLIST, driftPlotOption, maxOnDemandCapacityRatioToPlot, pushoverStepNameIdentifier)
%
% Function: psb_pushoverDeformedShape.m
% -------------------
% This function plots the displaced shape for pushover analysis.
% 
% Variable definitions:
%       bldgID_LIST- ID to determine which building to plot (as defined in DefineInfoForBuildings.m); could contain a list
%       analysisDirLIST- Directory for analysis outputs; could contain a list
%       driftPlotOption- Plot the drifts at the last time step of the analysis (to show 
%                        the collapse mechanism better), 1- undeformed building
%       maxOnDemandCapacityRatioToPlot- Limit the demand/capacity ratio to 3, so the plots 
%                        won't be too crazy at collapse.
%
% Assumptions and Notices: 
%       - So far, I have only considered the deformed shape at the last step of the pushover 
%           analysis. If the analysis did not converge at the last step or it had already 
%           collapsed, then the deformed shape wouldn't be appropriate. I may consider 
%           plotting the deformed shape at different maximum base shear value, subsequently.
%       - The building information for the desired bldgID must be defined in DefineInfoForBuildings.m.
%
% Author: Prakash S Badal
% Date Written: 07-15-19
% Sources of Code: DrawDistortedFrame by Haselton
%
% Functions and Procedures called: none
%
% Units: kN and mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear;
% tic
baseFolder = pwd; 
%% sample input
% bldgID_LIST = [30401 30402 30421 30422 30441 30442 30451 30452 30471 30472];
% analysisDirLIST = { '(ID30401_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30402_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30421_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30422_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30441_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30442_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30451_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30452_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30471_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';
%                     '(ID30472_YZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)';};
% % bldgID_LIST = 30401;
% % analysisDirLIST = {'(ID30401_XZ_R0_4Story_v.02)_(AllVar)_(0.00)_(clough)'};
% 
% driftPlotOption = 2;    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better), 1- undeformed building
% maxOnDemandCapacityRatioToPlot = 3.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.
% pushoverStepNameIdentifier = 'lastStep'; 
% % subsequently, I plan to plot the deformed pushover shape at different base shear level. 
% % This text can be made to depend on the baseShear level. When it is an
% % empty text, we simply plot the deformed shape at the last analyzed step.
% % Later on, it may be assigned a string value on the lines of '0.80Vmax' etc.
% 
% % end of sample input

%% more inputs; can choose to change them for specific plots
lateralDispDOF = 1;
% Set some dummy variables to say that we do not want to highlight any
% hinges differently (this highlighting is used when we make movies of
% the building wiggling and other responses at the same time)
    isHingesHighlighted = 0;        % 0- No highlighting
    hingeHighlighted_1 = [3,2,2];   % [floorNum, colLineNum, jointNodeNum] floorNum starts from 1 at foundation; jointNodeNum from down around CCW direction
    hingeHighlighted_2 = [3,2,4];   % [floorNum, colLineNum, jointNodeNum]
    highlightedHingeColor_1 = 'm';  % 
    highlightedHingeColor_2 = 'c';  % 
    titleOption = 3;  % 2- Use a shorter title sa_gm; 3- use pushover titles
    saDefType = 0;    %Type of SA definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef); NOT required for pushover, i.e., if titleOption =3 
    periodUsedForScalingGroundMotionsFromMatlab = 0; % not needed if titleOption = 3
    figNumStart = 200;
% end of sample input

%% run over each building in the list
[buildingInfo] = psb_DefineInfoForBuildings;
for bldgIndex = 1:length(bldgID_LIST)
    bldgID = bldgID_LIST(bldgIndex);
    analysisDir = analysisDirLIST{bldgIndex};
    cd ..
    cd ..
    cd Output

    cd(analysisDir)
    cd EQ_9991
    cd Sa_0.00

    load('DATA_allDataForThisSingleRun.mat', 'nodeArray', 'nodeNumsAtEachFloorLIST', 'elementArray');

%% floorDispVECTOR 
    numColLines = buildingInfo{bldgID}.numBays + 1;
    maxFloorNum = buildingInfo{bldgID}.numStories + 1;
    fprintf('(%i/%i) Number of columns lines = %i; number of floor levels = %i. \n', bldgIndex, length(bldgID_LIST), numColLines, maxFloorNum);

    switch driftPlotOption
        case (1)
            % Plot undeformed building
            floorDispVECTOR = zeros(maxFloorNum);
        case (2)
            % Plot drifts at last time step of analysis
            for currentFloorNum = 2:maxFloorNum
                floorDisp{currentFloorNum}.TH = nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,lateralDispDOF);
                lastTimeStepNum = length(floorDisp{currentFloorNum}.TH);
                floorDispVECTOR(currentFloorNum) = floorDisp{currentFloorNum}.TH(lastTimeStepNum);
            end
        case (3)
            % Plot the absMax peak dispalcements of each floor for the full EQ (NOTE: this is
            % not an image of a distorted building, but absolute value of peak floor displacement in
            % each story at each time step)
            maxFloorNum = buildingInfo{bldgID}.numStories + 1;
            for currentFloorNum = 2:maxFloorNum
                floorDisp{currentFloorNum}.TH = nodeArray{nodeNumsAtEachFloorLIST(currentFloorNum)}.displTH(:,lateralDispDOF);
                floorDispVECTOR(currentFloorNum) = max(abs(floorDisp{currentFloorNum}.TH));
            end
        otherwise
            error('Invalid value for driftPlotOption');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plasticRotationARRAY
% Loop through and create the plastic rotation array from the opened analysis data. 
% Note that the first five columns in "elementArray" are the deformations and 6-10 are the forces.
for currentFloorNum = 2:maxFloorNum
    for currentColLineNum = 1:numColLines
        try % (11-11-20, PSB) adding this error handling piece to post-process for buildings (for now, diagrid) without joints
            currentJointNum = buildingInfo{bldgID}.jointNumber(currentFloorNum, currentColLineNum);
        catch 
            break
        end
        % Loop for the five joint nodes and compute the current and max ever plastic rotation demands
            cd Elements\Joints
            outpFileName = sprintf('Joint_ForceAndDef_%i.out', currentJointNum);
            elementArray{currentJointNum}.JointForceAndDeformation = load(outpFileName);
            cd ..\..
            for currentJointNodeNum = 1:5
                currentMaxPlasticRotationDemand_abs = max(abs(elementArray{currentJointNum}.JointForceAndDeformation(:, currentJointNodeNum)));
                plasticRotationARRAY{currentJointNum}.jointNodePHRDemand{currentJointNodeNum} = currentMaxPlasticRotationDemand_abs;
            end
%         end % end of for loop for jointNodeNums
    end % end of for loop for colLines
end % end of for loop for floorNums
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%% For non-ductile models, I have modeled a rigid joint2D with "elastic joint panel" 
% and instead used "4 ZLEs" shear LSM + flexural IMK at column top and only
% flexural IMK along beams/column bottom end.

% If hingeAroundJointToRecordMVLISTOUT.out file exists in Sa_0.00\RunInformation, 
% then it indicates that non-ductile model is in the use and hence, joint2D has rigid springs around it.
% Also, ZLEs are defined to simulate nonlinearity. 

tempDir = pwd;
cd RunInformation
if isfile('hingeAroundJointToRecordMVLISTOUT.out') == 1
    colHingeWithShear = load('hingeAroundJointToRecordMVLISTOUT.out');
    hingesWithFlexure = load('hingeAroundJointToRecordMLISTOUT.out');
    cd ..\Elements\DamageIndex
    for currentFloorNum = 2:maxFloorNum
        for currentColLineNum = 1:numColLines
            newModelColDownHingeNum = colHingeWithShear(currentFloorNum - 1 , currentColLineNum);
            newModelBeamRightHingeNum = hingesWithFlexure(currentFloorNum - 1 , 3*currentColLineNum-2);
            newModelColUpHingeNum = hingesWithFlexure(currentFloorNum - 1 , 3*currentColLineNum-1);
            newModelBeamLeftHingeNum = hingesWithFlexure(currentFloorNum - 1 , 3*currentColLineNum);
            
        % Saving rotations of top end of column (shear LSM + IMK flexure)
            outpFileName1 = sprintf('HingeDefTH_%i.out', newModelColDownHingeNum);      defo1 = load(outpFileName1); % (shear LSM + rigid Axial + IMK flexure)
            outpFileName2 = sprintf('HingeDefTH_%i.out', newModelBeamRightHingeNum);    defo2 = load(outpFileName2); % IMK flexure
            outpFileName3 = sprintf('HingeDefTH_%i.out', newModelColUpHingeNum);        defo3 = load(outpFileName3); % IMK flexure
            outpFileName4 = sprintf('HingeDefTH_%i.out', newModelBeamLeftHingeNum);     defo4 = load(outpFileName4); % IMK flexure
            
            corrJointNumInOldModel = 40000 + (100 * currentFloorNum) + currentColLineNum;
            elementArray{corrJointNumInOldModel}.JointForceAndDeformation = [defo1(:, 3), defo2, defo3, defo4];
            
            for currentJointNodeNum = 1:4 % 5th is joint panel, the results of which are given by joint2D in both ductile and non-ductile model
                currentMaxPlasticRotationDemand_abs = max(abs(elementArray{corrJointNumInOldModel}.JointForceAndDeformation(:, currentJointNodeNum)));
                plasticRotationARRAY{corrJointNumInOldModel}.jointNodePHRDemand{currentJointNodeNum} = currentMaxPlasticRotationDemand_abs;
            end
        end
    end
    cd ..\.. % now we are in Sa_0.00, from where we started
end
cd(tempDir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Do a similar loop for the column base hinges at the
% foundation level (the ones that are not assciated with any
% joint)
    currentFloorNum = 1;
    currentJointNodeNum = 1;
    for currentColLineNum = 1:numColLines
        try % (11-11-20, PSB) adding this error handling piece to post-process for buildings (for now, diagrid) without joints
            currentColBaseHingeNum = buildingInfo{bldgID}.hingeElementNumAtColBase(currentColLineNum);
        catch 
            break
        end        
        % Get the PHR demands from the elementArray
        cd Elements\Hinges
        outpFileName = sprintf('HingeRotTH_%i.out', currentColBaseHingeNum);
        elementArray{currentColBaseHingeNum}.rotTH = load(outpFileName);
        cd ..\..
        
        currentMaxPlasticRotationDemand_abs = max(abs(elementArray{currentColBaseHingeNum}.rotTH));
        plasticRotationARRAY{currentColBaseHingeNum}.columnBasePHRDemand = currentMaxPlasticRotationDemand_abs;
    end % end of for loop for colLines

%% update elementArray in the existing .mat file.
% save('DATA_allDataForThisSingleRun.mat', 'elementArray', '-append')
m = matfile('DATA_allDataForThisSingleRun.mat', 'Writable', true);
m.elementArray = elementArray;

cd ..\..\..\.. % come back four levels to reach main folder
   
cd psb_MatlabProcessors\MovieAndVisualProcessors
figure(figNumStart + bldgIndex)
try % (as of now, distorted frame module is programmed for SMRF with concentrated plasticity. Not plotting for diagrid
    psb_DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisDir, 9991, 0, isHingesHighlighted, ...
                        hingeHighlighted_1, hingeHighlighted_2, highlightedHingeColor_1, highlightedHingeColor_2, titleOption, ...
                        maxOnDemandCapacityRatioToPlot, saDefType, periodUsedForScalingGroundMotionsFromMatlab);
catch 
    continue
end
cd(baseFolder);
end

%% save the deformed pushover shapes
for bldgIndex = 1:length(bldgID_LIST)
   figure(figNumStart + bldgIndex)
   set(gca,'fontname','times'); % change the font to New Times Roman from HELVETICA
   analysisDir = analysisDirLIST{bldgIndex};
   modelName = strtok(analysisDir, ')'); modelName = modelName(2:end);
   
   cd ..\..\Output
   cd(analysisDir)

   exportName = sprintf('PushoverDeformedShape_%s_%s', pushoverStepNameIdentifier, modelName);
   savefig([exportName '.fig']); % .fig file for Matlab % model names may contain period
   print('-depsc', [exportName '.eps']); % .eps file for Linux (LaTeX)
%    print('-djpeg', exportName); % .jpeg file for small sized files
   print('-djpeg', [exportName '.jpeg'], '-r300');
   cd(baseFolder)
   close;
end 
% toc
