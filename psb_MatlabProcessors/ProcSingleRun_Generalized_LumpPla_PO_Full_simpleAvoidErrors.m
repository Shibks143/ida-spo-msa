% Procedure: xxx.m
% -------------------
%
% Same as the ProcSingleRunNlBmColSens.m, but imports that data from the output from the lumped plasticity model.
%
% This procedure processes the data that is output from a single run of analysis (one model, one EQ, one SaLevel), and is based 
%   on the output file/folder structure that is created by the OpenSees model structure that I use.
%   The data is saved to the matlab file called "Data_analsisType_Sa_saLevel_EQ_eqName.mat" (with the varaible names substituted
%   in the correct locations.  Note that all of the data is saved into a .mat file that will be exactly the same for all runs.
%   This is done so that when looping through all runs (like to make an IDA curve), we can pull out the data that we want during
%   each loop, then on the next loop (for another run) the old data will be overwritten, so that the file size won't grow to 
%   be too large when data from many runs are being processed.  This data file is saved in the EQ folder for the specific run.
% Notice that this file is made to only save the minimum things that need to be saved for the EDP data transfer (i.e. peaks and not TH's).
% 
%
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%           - This saves the maximums and TH's.  If this becomes too much space on the computer. the loops can easily be changed
%               to compute the maximums and save them, but not to save the TH's.
%           - In the filtering of the floor aceleration data, it is assumed 
%
%           - NOTICE - nodeNumsAtEachFloorLIST is hard-coded right now!!! (10-26-15) No more (PSB) 
%
% Author: Curt Haselton 
% Date Written: 2-26-04
% Updated: 10-1-04
%
% Sources of Code: Some information was taken from Paul Cordovas processing file called "ProcessData.m".
%
% Functions and Procedures called: none
%
% Variable definitions: 
%
%
%
%   **NOTICE: These variables are for the processor that saves everything (older on), so I need to update the definitions for this processor.
%
%
%       Note: modelName is just needed to get the input accelTH data to compute the absolute floor accelerations.
%
%       nodeArray  - a cell array of structures holding all the node TH's and maximum values for the nodes in the list of nodes to record (time in col 1 and 
%                           displ in col 2).  The node information in indexed in the array under the nodeNum.  This hold the displ
%                           and accel data.  
%                           Size: TH fields are numTimeSteps x 2 (dof 1, 2 and 3 displacements)
%                           Fields: displTH, displMax, displMin, displAbsMax, accelTH, accelMax, accelMin, accelAbsMax
%                           Ex. nodeArray{15}.accelTH - acceleration TH's for node 15
%                           Ex. nodeArray{21}.displTH - displacement TH's for node 21
%
%       elementArray - same as above, but for elements.  The structure fields are globalForces, localForces, and PHR.
%                           Size: TH fields are numTimeSteps x 6 (3 dof forces at ends i and j), except for forceAndDeformation.endi/endj which has numTimeSteps x 4,
%                               where these four columns (axial strain, curvature, axial force, moment).  
%                               An exception is for the hinge element (when using the Hysteretic model with hinges) - for these element, they only return one force, 
%                               which is Moment, so the size is only one column.  For these hinge elements
%                               the fields are .momentTH, .rotTH, .momentMax, .momentMin, .momentAbsMax, .rotMax, .rotMin, .rotAbsMax.  THe realted information
%                               about the hinge with the max rotation (and what that rotation is) is found below.
%                           Fields: globalForceTH, globalForceMax, globalForceMin, globalForceAbsMax, localForceTH, localForceMax, localForceMin, 
%                               localForceAbsMax, PHRTH, PHRMax, PHRMin, PHRAbsMax, PHRAbsMaxEitherEnd, forceAndDeformation.endi/endj (if recorded),
%                               elementArray{eleNum}.JointForceAndDeformation (if recoderd and only for joints) - this filed is 10 columns: spring rotation of external
%                               nodes, then panel spring rotation, then force follow in the same order.
%                           Ex. elementArray{10}.globalForceTH - global force TH for element 10
%
%       storyDriftRatio{storyNum} - cell array structure of story drift ratios
%                           Fields: TH, AbsMax
%                           Ex. storyDriftRatio{2}.AbsMax gives the absolute maximum story drift of story 2 (between floors 2 and 3).
%
%       floorAccel{floorNum}.AbsMax - cell array structure of floor acceerations
%                           Fields: TH, AbsMax, AbsMaxFiltered (filtered using Newmark)
%
%       baseShear - a stucture of base shear
%                           Fields: TH, AbsMax
%
%       psuedoTimeVector - a 1 x numTimeSteps vector holding the psuedoTime.  This is mainly created for plotting and to see how long the EQ converged for.
%
%       maxConvergedTime = the maximum pseudotime that the EQ converged to. 
%
%
%   NOT used now for nlBmCol model (were for hyst hinge model):
%       maxRotation - the maximum rotation of any hinge in the frame
%       hingeWithMaxRotation - the hinge number for the hinge with the above rotation.
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function [void] = ProcSingleRun_Generalized_LumpPla_PO_Full_simpleAvoidErrors(analysisType, saTOneForRun, eqNumber, processStoryPO, analysisType_final, SPO_index)

% function[void] = ProcSingleRun_Generalized_LumpPla_PO_Full_simpleAvoidErrors(analysisType, saTOneForRun, eqNumber, processStoryPO)

% Tell if we want to process the story PO information.  This will only work
% for newer models that have the "columnNumsAtEachStoryLISTOUT.out" in the
% output.  Added 12-6-05.  Removed on 6-17-08 and made an input variable.
    %processStoryPO = 0;     

initialFolder = [pwd];
disp('Processing Starting...');

saTOneForRun
eqNumber

% For the PFA calculations, input g
% g = 386.4;
g = 9810; % units- mm/sec^2


% Input the paramters used to filter the floor acceleration, using Newmark integration.
    period = 1.0/33.0;  % From Cornell
    dampRatio = 0.05;    % To not make the value artificially high
    
% Input how many seconds at the end of the EQ should be used to comput residual drifts.  The residual drift is used as the avergae of the min and max
%   values over the last X seconds of the EQ (assuming that the dT is not split over these last few seconds, so if it is split, then it effectively 
%   averages over a bit more time at the end.
    secAtEnfOfEQForResidual = 3.0; 

   
% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
% Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
% REPLACE line 118:
analysisTypeFolder = analysisType;
cd(analysisTypeFolder);

% cd(analysisTypeFolder);

% Create Sa and EQ folder names for later use
saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Create the prefix for all of the OpenSees output files - updated on
% 7-14-06 for new file naming
%filePrefix = sprintf('(%s)_EQ_(%.0f)_Sa_(%.2f)_', analysisType, eqNumber, saTOneForRun);
filePrefix = sprintf('');


if(processStoryPO == 1)
% Go in and get information from the MatlabProcessor folder - Added 9-26-05
% for the story PO diagrams
    cd MatlabInformation
        columnNumsAtEachStoryLIST = load('columnNumsAtEachStoryLISTOUT.out');
    cd ..;
end
    

% Get information in the RunInformation folder for this specific run
    cd(eqFolder);
    cd(saFolder);
    
    % If there is a RunInformation folder (i.e. if I didn't stop the running), then process the Run Information.
    runFolderName = 'RunInformation';
        cd(runFolderName)
        
% (10-1-15) Commented out the eigenvaluesAfterEQ part since it threw errors 
% in post-capping region, due to negative stiffness- PSB
        
%  eigenvaluesAfterEQ = load('eigenvaluesAfterEQOUT.out');


    minutesToRunThisAnalysis = load('minutesToRunThisAnalysisOUT.out');
                    
                                                                        
                                                                        
        usedNormDisplIncr = load('usedNormDisplIncrOUT.out');
        nodeNumsAtEachFloorLIST = load('nodeNumsAtEachFloorLISTOUT.out'); 
        floorHeightsLIST = load('floorHeightListOUT.out');
        buildingHeight = max(floorHeightsLIST);

        
        nodeNumToRecordLIST = load('nodeNumToRecordLISTOUT.out');
%         eqNumberToRunLIST =  load('eqNumberToRunLISTOUT.out');
        elementNumToRecordLIST = load('elementNumToRecordLISTOUT.out');
        
        
        
%         numNodes = load('numNodesOUT.out');
        poControlNodeNum = load('poControlNodeNumOUT.out');
        columnNumsAtBaseLIST = load('columnNumsAtBaseLISTOUT.out');
%         elementBeingUsedForAnalysis = load('elementBeingUsedForAnalysisOUT.out');
%         analysisType = load('analysisTypeOUT.out');
%         usingLeaningColumn = load('usingLeaningColumnOUT.out');
        %numIntPointsDispEle = load('numIntPointsDispEleOUT.out');
        %numIntPointsForceEle = load('numIntPointsForceEleOUT.out');
        dtForAnalysis = load('dtForAnalysisOUT.out');
        defineHystHingeRecorders = load('defineHystHingeRecordersOUT.out');
        defineElementEndSectionRecorders = load('defineElementEndSectionRecordersOUT.out');
        hingeElementsToRecordLIST = load('hingeElementsToRecordLISTOUT.out');
        defineJointRecorders = load('defineJointRecordersOUT.out');
        if(defineJointRecorders == 1)
            jointNumToRecordLIST = load('jointNumToRecordLISTOUT.out');
        end
%         dtForAnalysis = load('dtForAnalysisOUT.out');

%         eqFullLength = load('eqFullLengthOUT.out');
%         maxTolUsed = load('maxTolUsedOUT.out');
        cd ..;
    
    cd ..;
    cd ..;


% Note that floors are numbered starting with one for the ground floor
numStories = length(nodeNumsAtEachFloorLIST) - 1;
numFloors = numStories + 1;



% %%%%%%%%%%%%%%%%%%   

%%%%%%% Get node data, first get to node folder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Node data
cd(eqFolder);
cd(saFolder);

cd Nodes;
    % Load node displacement TH data, and compute the max/min/absMax
    cd DisplTH;
    % Loop through the nodes in nodeNumToRecordLIST and get the data
    for nodeIndex = 1:length(nodeNumToRecordLIST)
        nodeNum = nodeNumToRecordLIST(nodeIndex);
        % Create file name
        nodeFileName = sprintf('%sTHNodeDispl_%.0f.out', filePrefix, nodeNum);
        nodeArray{nodeNum}.displTH = load(nodeFileName);
        % Make a vector of the psuedoTime before removing time data (really doesn't need to be in the loop, but easier)
        psuedoTimeVector = nodeArray{nodeNum}.displTH(:, 1);
        % Remove time data from node array
        nodeArray{nodeNum}.displTH = nodeArray{nodeNum}.displTH(:, 2:4);   
        nodeArray{nodeNum}.displMax = max(nodeArray{nodeNum}.displTH);
        nodeArray{nodeNum}.displMin = min(nodeArray{nodeNum}.displTH);
        nodeArray{nodeNum}.displAbsMax = max(abs(nodeArray{nodeNum}.displMax), abs(nodeArray{nodeNum}.displMin));
    end
    cd ..;
    cd ..;

    % Save the AbsMax displacments for the nodes at each floor level
    clear absMaxDisplOfFloor
    for floorIndex = 2:length(nodeNumsAtEachFloorLIST)
        absMaxDisplOfFloor{floorIndex} = nodeArray{nodeNumsAtEachFloorLIST(floorIndex)}.displAbsMax;
    end
    
%%%%%%% Get element data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Element data
cd Elements;
    % Load element global force TH data (for all elements), and compute the max/min/absMax
    cd EleGlobalTH;
    for eleIndex = 1:length(columnNumsAtBaseLIST)
%         disp('In element loop for EleGlobalTH');
        eleNum = columnNumsAtBaseLIST(eleIndex);
        % Create file name
        eleFileName = sprintf('%sTHEleGlobal_%.0f.out', filePrefix, eleNum);
        elementArray{eleNum}.globalForceTH = load(eleFileName);
        elementArray{eleNum}.globalForceMax = max(elementArray{eleNum}.globalForceTH);
        elementArray{eleNum}.globalForceMin = min(elementArray{eleNum}.globalForceTH);
        elementArray{eleNum}.globalForceAbsMax = max(abs(elementArray{eleNum}.globalForceMax), abs(elementArray{eleNum}.globalForceMin));
    end
    
    % Added on 12-6-05 for story POs
    if(processStoryPO == 1)
        for eleIndex1 = 1:length(columnNumsAtEachStoryLIST(:,1))
            for eleIndex2 = 1:length(columnNumsAtEachStoryLIST(1,:))
%               disp('In element loop for EleGlobalTH');
                eleNum = columnNumsAtEachStoryLIST(eleIndex1, eleIndex2);
                % Create file name
                eleFileName = sprintf('%sTHEleGlobal_%.0f.out', filePrefix, eleNum);
                elementArray{eleNum}.globalForceTH = load(eleFileName);
                elementArray{eleNum}.globalForceMax = max(elementArray{eleNum}.globalForceTH);
                elementArray{eleNum}.globalForceMin = min(elementArray{eleNum}.globalForceTH);
                elementArray{eleNum}.globalForceAbsMax = max(abs(elementArray{eleNum}.globalForceMax), abs(elementArray{eleNum}.globalForceMin));
            end
        end
    end
    
    cd ..;
    
    
    if(1==0)
    % Load element local force TH data (for all elements), and compute the max/min/absMax
    cd EleLocalTH;
    for eleIndex = 1:length(elementNumToRecordLIST)
%         disp('In element loop for EleLocalTH');
        eleNum = elementNumToRecordLIST(eleIndex);
        % Create file name
        eleFileName = sprintf('%sTHEleLocal_%.0f.out', filePrefix, eleNum);
        elementArray{eleNum}.localForceTH = load(eleFileName);
        elementArray{eleNum}.localForceMax = max(elementArray{eleNum}.localForceTH);
        elementArray{eleNum}.localForceMin = min(elementArray{eleNum}.localForceTH);
        elementArray{eleNum}.localForceAbsMax = max(abs(elementArray{eleNum}.localForceMax), abs(elementArray{eleNum}.localForceMin));
    end
    cd ..;
    end
    
    
    % Decide whther or not to load the element end recorders
    if(defineElementEndSectionRecorders == 1)
    
        if(1==0)
        % Load element forceAndDeformation for each end (ends i and j)
        cd EleForceDefTH;
        for eleIndex = 1:length(elementNumToRecordLIST)
%            disp('In element loop for EleForceDefTH');
            eleNum = elementNumToRecordLIST(eleIndex);
            % Create file name and load file - for end i
            eleFileName = sprintf('%sTHEleForceDef_endi_%.0f.out', filePrefix, eleNum);
            elementArray{eleNum}.forceAndDeformation.endi = load(eleFileName);
            % Create file name and load file - for end j
            eleFileName = sprintf('%sTHEleForceDef_endj_%.0f.out', filePrefix, eleNum);
            elementArray{eleNum}.forceAndDeformation.endj = load(eleFileName);
        end
        cd ..;
        end
    
    end
    
    
%     % Decide whther or not to load the hinge recorders - FOR ELASTIC WITH HYST HINGE MODEL, AND for the hinges of the gravity frame
%     if(defineHystHingeRecorders == 1)
%     
if(1==0)
        % Load hinge force and deformation files
        cd Hinges;
        for hingeIndex = 1:length(hingeElementsToRecordLIST)
%             disp('In element loop for Hinge recorders');
            hingeNum = hingeElementsToRecordLIST(hingeIndex);
            
            % Create file name and load file for hinge force (moment) TH
            hingeFileName = sprintf('%sHingeForceTH_%.0f.out', filePrefix, hingeNum);
            elementArray{hingeNum}.momentTH = load(hingeFileName);
            elementArray{hingeNum}.momentMax = max(elementArray{hingeNum}.momentTH);
            elementArray{hingeNum}.momentMin = min(elementArray{hingeNum}.momentTH);
            elementArray{hingeNum}.momentAbsMax = max(abs(elementArray{hingeNum}.momentMax), abs(elementArray{hingeNum}.momentMin));
            
            % Create file name and load file for hinge deformation (rotation) TH
            hingeFileName = sprintf('%sHingeRotTH_%.0f.out', filePrefix, hingeNum);
            elementArray{hingeNum}.rotTH = load(hingeFileName);
            elementArray{hingeNum}.rotMax = max(elementArray{hingeNum}.rotTH);
            elementArray{hingeNum}.rotMin = min(elementArray{hingeNum}.rotTH);
            elementArray{hingeNum}.rotAbsMax = max(abs(elementArray{hingeNum}.rotMax), abs(elementArray{hingeNum}.rotMin));

        end
        
        cd ..;
end
%         
if(1==0)
     % Decide whther or not to load the joint recorders
    if(defineJointRecorders == 1)
    
%         disp('Loading joint data...')
        
        % Load element forceAndDeformation for each end (ends i and j)
        cd Joints;
        for jointIndex = 1:length(jointNumToRecordLIST)
            jointNum = jointNumToRecordLIST(jointIndex);
            % Create file name and load file - for end i
            jointFileName = sprintf('Joint_ForceAndDef_%d.out', jointNum);
            elementArray{jointNum}.JointForceAndDeformation = load(jointFileName);
        end
        cd ..;
    
    end
end
    
cd ..;
%%%%%%% End element data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Compute drift ratios (note that the ground floor is floor 1)
%    This assumes that the displacement for drift is in dof 1 (x dof)
maxDriftForFullFrame = 0;
for floorNum = 2:length(floorHeightsLIST)
    storyNum = floorNum - 1;
    storyHeight = floorHeightsLIST(floorNum) - floorHeightsLIST(floorNum - 1);
    %disp(storyHeight)
    upperFloorNodeNum = nodeNumsAtEachFloorLIST(floorNum);
    lowerFloorNodeNum = nodeNumsAtEachFloorLIST(floorNum - 1);
  
    % Compute drift, for a nodeNum of -1, it's the ground node that has 0 displacement
    if(lowerFloorNodeNum == -1)
        % The lower floor is the ground, so it has zero displacement 
        storyDriftRatio{storyNum}.TH = (nodeArray{upperFloorNodeNum}.displTH(:,1) - 0) / storyHeight;  
    else
        % We are in an upper floor - do normal cacluation
        storyDriftRatio{storyNum}.TH = (nodeArray{upperFloorNodeNum}.displTH(:,1) - nodeArray{lowerFloorNodeNum}.displTH(:,1)) / storyHeight; 
    end
    storyDriftRatio{storyNum}.Max = max(storyDriftRatio{storyNum}.TH);
    storyDriftRatio{storyNum}.Min = min(storyDriftRatio{storyNum}.TH);
    storyDriftRatio{storyNum}.AbsMax = max(abs(max(storyDriftRatio{storyNum}.TH)), abs(min(storyDriftRatio{storyNum}.TH)));
    
    % If this story has higher drift, update max value
    if(storyDriftRatio{storyNum}.AbsMax > maxDriftForFullFrame)
        maxDriftForFullFrame = storyDriftRatio{storyNum}.AbsMax;
    end

    
    % Compute the residual drift ratios.  Take the average of the nax and min drifts over the last few seconds of the EQ.
        numPointsAtEndOfEQToUse = secAtEnfOfEQForResidual / dtForAnalysis;
        lastPointNumAtEndOfEQ = length(storyDriftRatio{storyNum}.TH);
        pointNumAtStartOfResidualCalc = lastPointNumAtEndOfEQ - numPointsAtEndOfEQToUse;
        
        % Do error check, so that if there are less than the numPointsAtEndOfEQToUse in the full EQ (like for some collapse cases), then we will not try to do the calc. and we will not have an error
            if(lastPointNumAtEndOfEQ < (numPointsAtEndOfEQToUse + 10))
                % If we get here, then just put "999" in for the residual drift, because there are not enough convergerged points, meaning that the building probably collapsed for this analysis!
                storyDriftRatio{storyNum}.Residual = 999.0;
            else
                % If we get here, we have enough at the end of the record to compute a residual drift, so do it...
                    % Compute the max and min drifts in this time range
                    maxDriftInResidRange = max(storyDriftRatio{storyNum}.TH(pointNumAtStartOfResidualCalc:lastPointNumAtEndOfEQ));
                    minDriftInResidRange = min(storyDriftRatio{storyNum}.TH(pointNumAtStartOfResidualCalc:lastPointNumAtEndOfEQ));
        
                    % Use the mean of these max and min values as the residual drift ratio
                    storyDriftRatio{storyNum}.Residual = (maxDriftInResidRange + minDriftInResidRange) / 2.0; 
            end

        % For saving - no TH results
        storyDriftRatioToSave{storyNum}.Max = storyDriftRatio{storyNum}.Max;
        storyDriftRatioToSave{storyNum}.Min = storyDriftRatio{storyNum}.Min;
        storyDriftRatioToSave{storyNum}.AbsMax = storyDriftRatio{storyNum}.AbsMax;
        storyDriftRatioToSave{storyNum}.Residual = storyDriftRatio{storyNum}.Residual;


end


% This was moved out of the story PO loop on 12-20-05

    % % % Compute base shear
    baseShear.TH = zeros(length(elementArray{columnNumsAtBaseLIST(1)}.globalForceTH(:, 1)), 1);    %Just initializing it to zero vector of correct length

    displayTemp = sprintf('Starting base shear is: %.2f', max(baseShear.TH));
    disp(displayTemp);
    disp('Starting base shear calculation...');
    for colIndex = 1:length(columnNumsAtBaseLIST)
        colEleNum = columnNumsAtBaseLIST(colIndex);
        baseShear.TH = baseShear.TH + elementArray{colEleNum}.globalForceTH(:, 1);
%         tempCurrentAbsMaxShear = max(abs(max(elementArray{colEleNum}.globalForceTH(:, 1))), abs(min(elementArray{colEleNum}.globalForceTH(:, 1))));
        tempCurrentAbsMaxShear = max(abs(elementArray{colEleNum}.globalForceTH(:, 1))); % (10-27-15) PSB
%       displayTemp = sprintf('Column number %d, has an AbsMax shear of %.2f\n', colEleNum, tempCurrentAbsMaxShear);
%       disp(displayTemp);
    end

%     baseShear.AbsMax = max(abs(max(baseShear.TH)), abs(min(baseShear.TH)));
    baseShear.AbsMax = max(abs(baseShear.TH)); % (10-27-15) PSB
    displayTemp = sprintf('Total AbsMax base shear is %.2f\n', baseShear.AbsMax);
    disp(displayTemp);


% Added on 12-6-05
if(processStoryPO == 1)

% Added 9-26-05 - compute the story shear THs for each story
    for storyNum = 1:length(columnNumsAtEachStoryLIST(:,1))
        clear currentStoryShearTH;
        currentStoryShearTH = -1;
%         columnNumsAtEachStoryLIST;
        for colIndex = 1:length(columnNumsAtEachStoryLIST(1,:))
            disp('In element loop for computing story shears');
            colNum = columnNumsAtEachStoryLIST(storyNum, colIndex);
            
            colShearTH = elementArray{colNum}.globalForceTH(:, 1);
            if(currentStoryShearTH == -1)
                % This is the first column shear to be added, so just the
                % cummulative story shear equal to the column shear
                clear currentStoryShearTH;
                currentStoryShearTH = colShearTH;
            else
                % This is not the first column shear to be added, so add it
                % to the storyShear vector
                currentStoryShearTH = currentStoryShearTH + colShearTH;
            end

        end
        storyShearTH{storyNum} = currentStoryShearTH;
    end
end

                
% Save all of this data into the folder for the proper EQ, under the correct Sa level (we are already in the right folder)
% Only save the information that is needed so that it will be more "bug resistant".
%fileName = ['DATA_reducedSensDataForThisSingleRun.mat'];

if SPO_index == -999
    fileName = ['DATA_allDataForThisSingleRun.mat'];
else
    fileName = sprintf('DATA_allDataForThisSingleRun_%i.mat', SPO_index);
end

save(fileName)

% Get back to the MatlabProcessors folder where we started
cd(initialFolder);

disp('Processing Finished for this PO.');

%     eigenvaluesAfterEQ = load('eigenvaluesAfterEQOUT.out');
%     minutesToRunThisAnalysis = load('minutesToRunThisAnalysisOUT.out');
%     scaleFactorForRun = load('scaleFactorForRunOUT.out');
%     usedNormDisplIncr = load('usedNormDisplIncrOUT.out');
    