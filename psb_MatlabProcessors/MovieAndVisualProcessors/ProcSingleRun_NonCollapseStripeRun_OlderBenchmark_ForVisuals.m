% Procedure: ProcSingleRun_NonCollapseStripeRun_OlderBenchmark_ForVisuals.m
% -------------------
%
% Same as the ProcSingleRun_Collapse_GeneralizedForFramesAndWalls_Full.m, but is in the movie folder instead (just so all the files are together).
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
%           - NOTICE - This does not save the PHR for nlBmCol elements
%           (12-6-05)
%
%
%
%
%
% Author: Curt Haselton 
% Date Written: 2-26-04
% Updated: 12-6-05
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
function[void] = ProcSingleRun_NonCollapseStripeRun_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, saTOneForRun, eqNumber)

%   - NOTICE - This does not save the PHR for nlBmCol elements; just curvatures if they are recorded (12-6-05)

% Differences:
%   - This saves a .mat file for each Sa level
%   - This computes PGA (for ground level equipment)

disp('Processing Starting...');

saTOneForRun
eqNumber

% For the PFA calculations, input g
g = 386.4;

% Input the paramters used to filter the floor acceleration, using Newmark integration.
    period = 1.0/33.0;  % From Cornell
    dampRatio = 0.05;    % To not make the value artificially high
    
% Input how many seconds at the end of the EQ should be used to comput residual drifts.  The residual drift is used as the avergae of the min and max
%   values over the last X seconds of the EQ (assuming that the dT is not split over these last few seconds, so if it is split, then it effectively 
%   averages over a bit more time at the end.
    secAtEnfOfEQForResidual = 3.0; 

   
% First change the directory to get into the correct folder for processing
startFolder = [pwd];
cd ..;
cd ..;
cd Output;
% Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
analysisTypeFolder = sprintf('%s', analysisType)
cd(analysisTypeFolder);

% Create Sa and EQ folder names for later use
saFolder = sprintf('Sa_%.2f', saTOneForRun);
eqFolder = sprintf('EQ_%.0f', eqNumber);

% Create the prefix for all of the OpenSees output files
filePrefix = sprintf('(%s)_EQ_(%.0f)_Sa_(%.2f)_', analysisType, eqNumber, saTOneForRun);


% Get information in the RunInformation folder for this specific run
    cd(eqFolder);
    cd(saFolder);
    
    % If there is a RunInformation folder (i.e. if I didn't stop the running), then process the Run Information.
    runFolderName = 'RunInformation';
        cd(runFolderName)
        
%         % New collapse items %%%%%%%%%%%%%%%%%%%%%%%%%
%         isNonConv = load('isNonConvOUT.out');
%         isCollapsed = load('isCollapsedOUT.out');
%         isSingular = load('isSingularOUT.out');
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        eigenvaluesAfterEQ = load('eigenvaluesAfterEQOUT.out');
        minutesToRunThisAnalysis = load('minutesToRunThisAnalysisOUT.out');
        
%         disp('NOTICE - Old scale factor file is being loaded - ONLY use this when processing results from older models!');
        scaleFactorForRun = load('scaleFactorForRunOUT.out');
        % REMOVED on 12-7-05 for the older Banchmark processing
        %scaleFactorForRun = load('scaleFactorAppliedToCompOUT.out');    % NOTICE - THIS MAY NOT WORK FOR RUNS DONE BEFORE .TCL FILES WERE UPDATED ON 8-30-05 (so you may need to alter this back and just accept the possible error in computing the floor accelerations)
                                                                        % Fixed on 8-30-05 to have this be the applied scale factor instead of the ratio of Sa,target and Sa,comp (so this works for any scaling method)
        
        % REMOVED on 12-7-05 for the older Banchmark processing
        % Scaled Sa values added on 9-13-05 
        %saCompScaled = load('saCompScaledOUT.out');
        %saGeoMeanScaled = load('saGeoMeanScaledOUT.out');
                                                                        
                                                                        
                                                                        
        usedNormDisplIncr = load('usedNormDisplIncrOUT.out');
        nodeNumsAtEachFloorLIST = load('nodeNumsAtEachFloorLISTOUT.out'); 
        floorHeightsLIST = load('floorHeightListOUT.out');

        
        
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%         % I AM HARD-CODING THAT THE NODES AND DRIFTS ARE FOR THE NODE AT THE BOTTOM OF THE BEAM.  THIS WAS DONE B/C 
%         %   THE NODE AT THE CENTER OF THE BEAM HAD PROBLEMS WITH ACCELERATIONS AND THE TOP NODE IS PROBLEMATIC FOR THE 
%         %   TOP FLOOR.
%         
% %         nodeNumsAtEachFloorLIST = load('nodeNumsAtEachFloorLISTOUT.out'); 
%         % This was hard-coded, b/c there was a problem with the PFA from the nodes that were originally used.
%         nodeNumsAtEachFloorLIST = [-1, 12, 32, 52, 72];
%         
% %         floorHeightsLIST = load('floorHeightListOUT.out');
%         floorHeightsLIST = [0, 124.0, 286.0, 447.0, 603.0]; 
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        
        
        
        
        nodeNumToRecordLIST = load('nodeNumToRecordLISTOUT.out');
%         eqNumberToRunLIST =  load('eqNumberToRunLISTOUT.out');
        elementNumToRecordLIST = load('elementNumToRecordLISTOUT.out');
        
        
%         %%%%% Hard -coded - for case with no gravity frame %%%%%%%%%%%%%%%
%         elementNumToRecordLIST = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1001, 1002, 1101, 1102, 1201, 1202, 1301, 1302, 1401, 1402, 15, 16, 17, 18, 1901, 1902, 2001, 2002, 2101, 2102, 2201, 2202, 2301, 2302, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Added 12-7-05 to make processor not read local element force
        % files
        onlyDefineLimitedRecForVariations = load('onlyDefineLimitedRecForVariationsOUT.out');
        
        
%         numNodes = load('numNodesOUT.out');
        poControlNodeNum = load('poControlNodeNumOUT.out');
        columnNumsAtBaseLIST = load('columnNumsAtBaseLISTOUT.out');
%         elementBeingUsedForAnalysis = load('elementBeingUsedForAnalysisOUT.out');
%         analysisType = load('analysisTypeOUT.out');
%         usingLeaningColumn = load('usingLeaningColumnOUT.out');
        %numIntPointsDispEle = load('numIntPointsDispEleOUT.out');
        numIntPointsForceEle = load('numIntPointsForceEleOUT.out');
        dtForAnalysis = load('dtForAnalysisOUT.out');
        defineHystHingeRecorders = load('defineHystHingeRecordersOUT.out');
        defineElementEndSectionRecorders = load('defineElementEndSectionRecordersOUT.out');
        hingeElementsToRecordLIST = load('hingeElementsToRecordLISTOUT.out');
        defineJointRecorders = load('defineJointRecordersOUT.out');
        if(defineJointRecorders == 1)
            jointNumToRecordLIST = load('jointNumToRecordLISTOUT.out');
        end
        dtForAnalysis = load('dtForAnalysisOUT.out');
%         eqFullLength = load('eqFullLengthOUT.out');
        maxTolUsed = load('maxTolUsedOUT.out');
        cd ..;
    
    cd ..;
    cd ..;


% Note that floors are numbered starting with one for the ground floor
numStories = length(nodeNumsAtEachFloorLIST) - 1;
numFloors = numStories + 1;






%%%%%%%%%%%%%%%%%%   
% For the PFA calculations, we need to get the EQ TH vector so that we can add it with the relative accelerations to get absolute accelerations at each floor.
    % Go into the EQ folder to open the sorted EQ file
        cd ..;
        cd ..;
        cd Models;
        cd(modelName)
        cd EQs;
    
    % Make the name of the sorted EQ file to read
        sortedInputEQFileName = sprintf('SortedEQFile_(%d).txt', eqNumber);
    
    % Load the file - scale factor added on 8-9-05 (it wasn't scaled
    % before, which was an error)
        inputGroundAcceleration = load(sortedInputEQFileName) * scaleFactorForRun; % For older Becnhmark runs this is COMPONENT Sa for collapse analyses and GEOMEAN Sa for stripe analyses (12-7-05)
        %inputGroundAcceleration = load(sortedInputEQFileName);
        
    % Compute PGA - added on 8-9-05
        max_temp = max(inputGroundAcceleration);
        min_temp = max(inputGroundAcceleration);
        PGA = max(abs(max_temp), abs(min_temp));
        temp = sprintf('PGA is: %.2fg', PGA);
        disp(temp);

    % Source in the EQInfo file do get the dT for the EQ.
        % Go to Matlab folder to do this
        tempFolder1 = [pwd];
        cd ..;
        cd ..;
        cd ..;
        cd MatlabProcessors;
        
        % Source file
        defineEQInfoForMATLAB;
        
        % Go back to initial folder
        cd(tempFolder1);
        
        dtForCurrentEQ = dtForEQRecord(eqNumber);
        % Get max time for the EQ (for convergence stuff later)
        eqTimeLength = numPointsForEQRecord(eqNumber) * dtForEQRecord(eqNumber);
        
    % Make a timeVector for the EQ record
        currentTime = 0;
        for i = 1:length(inputGroundAcceleration)
            timeVectorForEQRecord(i) = currentTime;
            currentTime = currentTime + dtForCurrentEQ;
        end
        
    % Format the input acceleration to get rid of the extra steps - only have one point for each dtForAnalysis
        % First process the accel vector to not have any extra steps that subdivide dT...
        evenStepNum = 1;
        currentEvenlySpacedTimeStep = 0;
        for inputAccelIndex = 1:length(inputGroundAcceleration)
            % Only save the accel point if it's the next evenly spaced time step, or past the next time step.
            if (timeVectorForEQRecord(inputAccelIndex) >= currentEvenlySpacedTimeStep)
                % Add the step to the processed vectors
                timeVectorForEQRecordProcessed(evenStepNum) = timeVectorForEQRecord(inputAccelIndex);
                inputGroundAccelerationProcessed(evenStepNum) = inputGroundAcceleration(inputAccelIndex);
                evenStepNum = evenStepNum + 1;
                currentEvenlySpacedTimeStep = currentEvenlySpacedTimeStep + dtForAnalysis;
            else
                % Don't do anything, just let the accelTH tick away until we get to the next time step.    
            end    
        end
        
    % Go back to original folder (for EQ's)
        cd ..;
        cd ..;
        cd ..;
        cd Output;
        cd(analysisTypeFolder);
    %%%%%%%%%%%%%%%%%%  


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
    
    % Save the AbsMax displacments for the nodes at each floor level
    clear absMaxDisplOfFloor
    for floorIndex = 2:length(nodeNumsAtEachFloorLIST)
        absMaxDisplOfFloor{floorIndex} = nodeArray{nodeNumsAtEachFloorLIST(floorIndex)}.displAbsMax;
    end
   
    
    % Load node acceleration TH data, and compute the max/min/absMax
    cd AccelTH;
    % Loop through the nodes in nodeNumToRecordLIST and get the data
    for nodeIndex = 1:length(nodeNumToRecordLIST)
        nodeNum = nodeNumToRecordLIST(nodeIndex);
        % Create file name
        nodeFileName = sprintf('%sTHNodeAccel_%.0f.out', filePrefix, nodeNum);
        nodeArray{nodeNum}.accelTH = load(nodeFileName);
        nodeArray{nodeNum}.accelTH = nodeArray{nodeNum}.accelTH(:, 2:4);    % removing time data
%         nodeArray{nodeNum}.accelTH = nodeArray{nodeNum}.accelTH(:, 1);    % removing dof 2 data
        nodeArray{nodeNum}.accelMax = max(nodeArray{nodeNum}.accelTH);
        nodeArray{nodeNum}.accelMin = min(nodeArray{nodeNum}.accelTH);
        nodeArray{nodeNum}.accelAbsMax = max(abs(nodeArray{nodeNum}.accelMax), abs(nodeArray{nodeNum}.accelMin));
    end
    cd ..;
cd ..;
%%%%%%% End node data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    cd ..;
    
    % Load element local force TH data (for all elements), and compute the max/min/absMax
    cd EleLocalTH;
    % Only read if using full processors - added on 12-7-05 for older
    % Benchmark processing
    if(onlyDefineLimitedRecForVariations == 0)
        for eleIndex = 1:length(elementNumToRecordLIST)
%             disp('In element loop for EleLocalTH');
            eleNum = elementNumToRecordLIST(eleIndex);
            % Create file name
            eleFileName = sprintf('%sTHEleLocal_%.0f.out', filePrefix, eleNum);
            elementArray{eleNum}.localForceTH = load(eleFileName);
            elementArray{eleNum}.localForceMax = max(elementArray{eleNum}.localForceTH);
            elementArray{eleNum}.localForceMin = min(elementArray{eleNum}.localForceTH);
            elementArray{eleNum}.localForceAbsMax = max(abs(elementArray{eleNum}.localForceMax), abs(elementArray{eleNum}.localForceMin));
        end
    end
    cd ..;
    
%     % Load element PHR TH data (for all elements), and compute the max/min/absMax -FOR FIBER MODELS ONLY
%     cd ElePHRTH;
%     maxPHRForFrame = 0;
%     eleWithMaxPHR = 0;
%     for eleIndex = 1:length(elementNumToRecordLIST)
% %         disp('In element loop for ElePHRTH');
%         eleNum = elementNumToRecordLIST(eleIndex);
%         % Create file name
%         eleFileName = sprintf('%sTHPHR_%.0f.out', filePrefix, eleNum);
%         elementArray{eleNum}.PHRTH = load(eleFileName);
%         elementArray{eleNum}.PHRMax = max(elementArray{eleNum}.PHRTH);
%         elementArray{eleNum}.PHRMin = min(elementArray{eleNum}.PHRTH);
%         elementArray{eleNum}.PHRAbsMax = max(abs(elementArray{eleNum}.PHRMax), abs(elementArray{eleNum}.PHRMin));
%         elementArray{eleNum}.PHRAbsMaxEitherEnd = max(elementArray{eleNum}.PHRAbsMax(2:3));
%         
%         % Find if this element has the max PHR of the frame
%         if(elementArray{eleNum}.PHRAbsMaxEitherEnd > maxPHRForFrame)
%             % If we get here, it' the new max.
%             maxPHRForFrame = elementArray{eleNum}.PHRAbsMaxEitherEnd;
%             eleWithMaxPHR = eleNum;
%         end
%         
%     end
%     cd ..;
    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Decide whther or not to load the element end recorders - for
    % nonlinearBeamColumn of dispBeamColumn elements
    if(defineElementEndSectionRecorders == 1)
        % Load element forceAndDeformation for each end (ends i and j)
        cd EleForceDefTH;
        for eleIndex = 1:length(elementNumToRecordLIST)
            disp('In ele end force-def TH loop');
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
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Added 11-03-05 - load the M-Curv results for all sections of all
        % elements
        cd EleForceDefTH;
        for eleIndex = 1:length(elementNumToRecordLIST)
            disp('In ele end force-def TH loop_loading all sections');
            eleNum = elementNumToRecordLIST(eleIndex);
            
            % Loop for all intration points...
            for currentIntPointNum = 1:numIntPointsForceEle
                % Create file name and load file for this intergation point
                eleFileName = sprintf('%sTHEleForceDef_(%d)_intPt_(%d).out', filePrefix, eleNum, currentIntPointNum);
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.allResponseTH = load(eleFileName);
                
                % Take out each piece and save
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.axialStrainTH = elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.allResponseTH(:,1);
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.flexCurvTH = elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.allResponseTH(:,2);
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.axialForceTH = elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.allResponseTH(:,3);
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.flexMomentTH = elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.allResponseTH(:,4);

                % Compute and save the absolute maximums
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.axialStrainAbsMax = max(abs(elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.axialStrainTH));
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.flexCurvAbsMax = max(abs(elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.flexCurvTH));
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.axialForceAbsMax = max(abs(elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.axialForceTH));
                elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.flexMomentAbsMax = max(abs(elementArray{eleNum}.forceAndDeformation.intPoint{currentIntPointNum}.flexMomentTH));
                
            end
        end
        cd ..;        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%











%     % Decide whther or not to load the hinge recorders - FOR ELASTIC WITH HYST HINGE MODEL, AND for the hinges of the gravity frame
%     if(defineHystHingeRecorders == 1)
%     
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
%         
% %         % Find the hinge with the max. Abs rotation and what the hinge number is
% %         maxRotation = 0.0;
% %         hingeWithMaxRotation = -1;  % A value to start, but this always should be overwritten.
% %         for hingeIndex = 1:length(hingeElementsToRecordLIST)
% %             
% %             hingeNum = hingeElementsToRecordLIST(hingeIndex);
% %             
% %             currentRotation = elementArray{hingeNum}.rotAbsMax;
% %             
% %             if(currentRotation > maxRotation)
% %                 % If the current hinge has the higest rotation, then update the values
% %                 maxRotation = currentRotation;
% %                 hingeWithMaxRotation = hingeElementsToRecordLIST(hingeIndex);
% %             end
% % 
% %         end
% %         
% %                 maxRotation
% %                 hingeWithMaxRotation
%         
%         
%         cd ..;
%     
%     end
    
    

%         defineJointRecorders = load('defineJointRecordersOUT.out');
%         jointNumToRecordLIST = load('jointNumToRecordLISTOUT.out');
%     
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

% Make a cell structure of vectors of floor accelerations
for floorNum = 2:numFloors
    floorNodeNum = nodeNumsAtEachFloorLIST(floorNum);
    floorAccel{floorNum}.relTH = nodeArray{floorNodeNum}.accelTH(:,1);
    floorAccel{floorNum}.relAbsMax = nodeArray{floorNodeNum}.accelAbsMax(1);
    
    % Format the response acceleration to get rid of intermeddiate steps (to just have one point for each dT)
        % First process the accel vector to not have any extra steps that subdivide dT...
        evenStepNum = 1;
        currentEvenlySpacedTimeStep = 0;
        floorAccel{floorNum}.relTHProcessed = zeros(1, length(floorAccel{floorNum}.relTH)); % Initialize to zeros, to erase data from last run
        for inputAccelIndex = 1:length(floorAccel{floorNum}.relTH)
            % Only save the accel point if it's the next evenly spaced time step, or past the next time step.
            if ((psuedoTimeVector(inputAccelIndex) >= currentEvenlySpacedTimeStep))
                % Add the step to the processed vector
                timeVectorProcessed(evenStepNum) = (psuedoTimeVector(inputAccelIndex));
                floorAccel{floorNum}.relTHProcessed(evenStepNum) = floorAccel{floorNum}.relTH(inputAccelIndex);
                evenStepNum = evenStepNum + 1;
                currentEvenlySpacedTimeStep = currentEvenlySpacedTimeStep + dtForAnalysis;
            else
                % Don't do anything, just let the accelTH tick away until we get to the next time step.    
            end    
        end

        
    % Add the input ground accelerations to get the absolute floor accelerations, b/c the data from the node recorders are relative accelerations.
        % Find shorter of two vectors, so we won't get errors when adding the vectors.
        minLength = min(length(inputGroundAccelerationProcessed), length(floorAccel{floorNum}.relTH));
        % Add vectors
        floorAccel{floorNum}.absTH = floorAccel{floorNum}.relTH(1:minLength) + ((inputGroundAccelerationProcessed(1:minLength)') * g);
        % Find the abs max.
        floorAccel{floorNum}.absAbsMax = max(abs(min(floorAccel{floorNum}.absTH)), abs(max(floorAccel{floorNum}.absTH)));
    
    % Filter the floor accelerations to remove strange numerical noise.  Use the Newmark schmeme with T = 1/33 (Cornell) and no damping.  
    %   Note that the ComputeAllResponsesNewmark.m returns more information than I need (i.e. displ., vel., etc.), so I am storing those in junk variables!
        %function[maxRelDispReponse, maxRelVelReponse, maxAbsAccelReponse, maxPsuedoAccelReponse] = ComputeAllResponsesNewmark(accelTH, timeVector, dT, period, dampRatio)
            % Go back to the Matlab folder to do the processing
            tempFolder2 = [pwd];
            cd ..;
            cd ..;
            cd ..;
            cd ..;
            cd MatlabProcessors;
            
            % Process
%             [junk1, junk2, maxFilteredFloorAccel, junk3] = ComputeAllResponsesNewmark((floorAccel{floorNum}.absTH / g), psuedoTimeVector, dtForAnalysis, period, dampRatio);
%             floorAccel{floorNum}.absAbsMaxFiltered = (maxFilteredFloorAccel * g);
            
            % Go back to initial folder
            cd(tempFolder2);

        % Just to save for later - no TH results
%         floorAccelToSave{floorNum}.relAbsMaxUnfiltered = floorAccel{floorNum}.relAbsMax;
        floorAccelToSave{floorNum}.absAbsMaxUnfiltered = floorAccel{floorNum}.absAbsMax;
%         floorAccelToSave{floorNum}.absAbsMaxFiltered = floorAccel{floorNum}.absAbsMaxFiltered;

end


% Compute base shear
% baseShear.TH = zeros(length(elementArray{columnNumsAtBaseLIST(1)}.globalForceTH(:, 1)), 1);    %Just initializing it to zero vector of correct length

% displayTemp = sprintf('Starting base shear is: %.2f', max(baseShear.TH));
% disp(displayTemp);
% displayTemp = sprintf('Starting base shear is: %.2f', min(baseShear.TH));
% disp(displayTemp);
% 
% % disp('Starting base shear calculation...');
% for colIndex = 1:length(columnNumsAtBaseLIST)
%     colEleNum = columnNumsAtBaseLIST(colIndex);
%     baseShear.TH = baseShear.TH + elementArray{colEleNum}.globalForceTH(:, 1);
%     tempCurrentAbsMaxShear = max(abs(max(elementArray{colEleNum}.globalForceTH(:, 1))), abs(min(elementArray{colEleNum}.globalForceTH(:, 1))));
% %     displayTemp = sprintf('Column number %d, has an AbsMax shear of %.2f\n', colEleNum, tempCurrentAbsMaxShear);
% %     disp(displayTemp);
% end
% 
% baseShear.AbsMax = max(abs(max(baseShear.TH)), abs(min(baseShear.TH)));
% displayTemp = sprintf('Total AbsMax base shear is %.2f\n', baseShear.AbsMax);
% disp(displayTemp);


% Find the maximum time of the EQ - to later see if it converged for the full EQ.
maxConvergedTime = max(psuedoTimeVector);

% Check if it's converged for the fuLL EQ (at least up to the last 2 seconds)
    if(maxConvergedTime > (eqTimeLength - 2.0))
        % Fully converged
        isConvForFullEQ = 1;
    else
        % Non-converged
        isConvForFullEQ = 0;   
    end
    

% % Find if it's converged for the full EQ
% isConvForFullEQ = 0;
% if(maxConvergedTime > (eqFullLength - 1))
%     % If we are here, it converged for the full EQ record
%     isConvForFullEQ = 1;
% end




% Delete data that causes problems later
% clear nodeNum;
% clear saFolder
% clear eqFolder
% clear nodeFileName
% clear eleNum
% clear eleFileName
% clear floorNum
% clear floorNodeNum
% clear storyNum
% clear storyHeight
% clear upperFloorNodeNum
% clear lowerFloorNodeNum
% clear colNum

% Compute Plastic hinge rotations for all elements (in the 1-36 numbering)
    % Naming: elementCombinedPHR{eleNum} - 
    %   - fields: .endi, .endj, .maxBothEnds; 
    %   - subFields: .bondTH, .bondAbsMax, .eleTH, .eleAbsMax, .combinedTH, .combinedAbsMax

                % Just use the length of the nonDispl vector for the last
                % node number so we know how long the EQ was
                thLength = length(nodeArray{nodeNum}.displTH(:,1)); % For use with zeros
                
                
%             % The lumped plasticity model only has PHR from the hinges in the joints, and the seperte hinges for the
%             %   column base springs.
%                 
%                 
%                 % Story 1 columns
%                 elementCombinedPHR{1}.endi.eleTotalTH = elementArray{706}.rotAbsMax;
%                 elementCombinedPHR{1}.endj.eleTotalTH = elementArray{621}.JointForceAndDeformation(:,1);
% 
%                 elementCombinedPHR{2}.endi.eleTotalTH = elementArray{707}.rotAbsMax;
%                 elementCombinedPHR{2}.endj.eleTotalTH = elementArray{622}.JointForceAndDeformation(:,1);
%                 
%                 elementCombinedPHR{3}.endi.eleTotalTH = elementArray{708}.rotAbsMax;
%                 elementCombinedPHR{3}.endj.eleTotalTH = elementArray{623}.JointForceAndDeformation(:,1);
%                 
%                 elementCombinedPHR{4}.endi.eleTotalTH = elementArray{709}.rotAbsMax;
%                 elementCombinedPHR{4}.endj.eleTotalTH = elementArray{624}.JointForceAndDeformation(:,1);
% 
%                 elementCombinedPHR{5}.endi.eleTotalTH = elementArray{710}.rotAbsMax;
%                 elementCombinedPHR{5}.endj.eleTotalTH = elementArray{625}.JointForceAndDeformation(:,1);
% 
%                 % Story 2 columns
%                 elementCombinedPHR{10}.endi.eleTotalTH = elementArray{621}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{10}.endj.eleTotalTH = elementArray{631}.JointForceAndDeformation(:,1);
% 
%                 elementCombinedPHR{11}.endi.eleTotalTH = elementArray{622}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{11}.endj.eleTotalTH = elementArray{632}.JointForceAndDeformation(:,1);
%                 
%                 elementCombinedPHR{12}.endi.eleTotalTH = elementArray{623}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{12}.endj.eleTotalTH = elementArray{633}.JointForceAndDeformation(:,1);
%                 
%                 elementCombinedPHR{13}.endi.eleTotalTH = elementArray{624}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{13}.endj.eleTotalTH = elementArray{634}.JointForceAndDeformation(:,1);
% 
%                 elementCombinedPHR{14}.endi.eleTotalTH = elementArray{625}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{14}.endj.eleTotalTH = elementArray{635}.JointForceAndDeformation(:,1);
% 
%                 % Story 3 columns
%                 elementCombinedPHR{19}.endi.eleTotalTH = elementArray{631}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{19}.endj.eleTotalTH = elementArray{641}.JointForceAndDeformation(:,1);
% 
%                 elementCombinedPHR{20}.endi.eleTotalTH = elementArray{632}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{20}.endj.eleTotalTH = elementArray{642}.JointForceAndDeformation(:,1);
%                 
%                 elementCombinedPHR{21}.endi.eleTotalTH = elementArray{633}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{21}.endj.eleTotalTH = elementArray{643}.JointForceAndDeformation(:,1);
%                 
%                 elementCombinedPHR{22}.endi.eleTotalTH = elementArray{634}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{22}.endj.eleTotalTH = elementArray{644}.JointForceAndDeformation(:,1);
% 
%                 elementCombinedPHR{23}.endi.eleTotalTH = elementArray{635}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{23}.endj.eleTotalTH = elementArray{645}.JointForceAndDeformation(:,1);
% 
%                 % Story 4 columns
%                 elementCombinedPHR{28}.endi.eleTotalTH = elementArray{641}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{28}.endj.eleTotalTH = elementArray{651}.JointForceAndDeformation(:,1);
% 
%                 elementCombinedPHR{29}.endi.eleTotalTH = elementArray{642}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{29}.endj.eleTotalTH = elementArray{652}.JointForceAndDeformation(:,1);
%                 
%                 elementCombinedPHR{30}.endi.eleTotalTH = elementArray{643}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{30}.endj.eleTotalTH = elementArray{653}.JointForceAndDeformation(:,1);
%                 
%                 elementCombinedPHR{31}.endi.eleTotalTH = elementArray{644}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{31}.endj.eleTotalTH = elementArray{654}.JointForceAndDeformation(:,1);
% 
%                 elementCombinedPHR{32}.endi.eleTotalTH = elementArray{645}.JointForceAndDeformation(:,3);
%                 elementCombinedPHR{32}.endj.eleTotalTH = elementArray{655}.JointForceAndDeformation(:,1);
% 
%                 % Floor 2 beams
%                 elementCombinedPHR{6}.endi.eleTotalTH = elementArray{621}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{6}.endj.eleTotalTH = elementArray{622}.JointForceAndDeformation(:,4);
% 
%                 elementCombinedPHR{7}.endi.eleTotalTH = elementArray{622}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{7}.endj.eleTotalTH = elementArray{623}.JointForceAndDeformation(:,4);
% 
%                 elementCombinedPHR{8}.endi.eleTotalTH = elementArray{623}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{8}.endj.eleTotalTH = elementArray{624}.JointForceAndDeformation(:,4);
%            
%                 elementCombinedPHR{9}.endi.eleTotalTH = elementArray{624}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{9}.endj.eleTotalTH = elementArray{625}.JointForceAndDeformation(:,4);
% 
%                 % Floor 3 beams
%                 elementCombinedPHR{15}.endi.eleTotalTH = elementArray{631}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{15}.endj.eleTotalTH = elementArray{632}.JointForceAndDeformation(:,4);
% 
%                 elementCombinedPHR{16}.endi.eleTotalTH = elementArray{632}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{16}.endj.eleTotalTH = elementArray{633}.JointForceAndDeformation(:,4);
% 
%                 elementCombinedPHR{17}.endi.eleTotalTH = elementArray{633}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{17}.endj.eleTotalTH = elementArray{634}.JointForceAndDeformation(:,4);
%            
%                 elementCombinedPHR{18}.endi.eleTotalTH = elementArray{634}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{18}.endj.eleTotalTH = elementArray{635}.JointForceAndDeformation(:,4);        
%                 
%                 % Floor 4 beams
%                 elementCombinedPHR{24}.endi.eleTotalTH = elementArray{641}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{24}.endj.eleTotalTH = elementArray{642}.JointForceAndDeformation(:,4);
% 
%                 elementCombinedPHR{25}.endi.eleTotalTH = elementArray{642}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{25}.endj.eleTotalTH = elementArray{643}.JointForceAndDeformation(:,4);
% 
%                 elementCombinedPHR{26}.endi.eleTotalTH = elementArray{643}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{26}.endj.eleTotalTH = elementArray{644}.JointForceAndDeformation(:,4);
%            
%                 elementCombinedPHR{27}.endi.eleTotalTH = elementArray{644}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{27}.endj.eleTotalTH = elementArray{645}.JointForceAndDeformation(:,4);           
%                 
%                 % Floor 5 beams
%                 elementCombinedPHR{33}.endi.eleTotalTH = elementArray{651}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{33}.endj.eleTotalTH = elementArray{652}.JointForceAndDeformation(:,4);
%                 
%                 elementCombinedPHR{34}.endi.eleTotalTH = elementArray{652}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{34}.endj.eleTotalTH = elementArray{653}.JointForceAndDeformation(:,4);
% 
%                 elementCombinedPHR{35}.endi.eleTotalTH = elementArray{653}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{35}.endj.eleTotalTH = elementArray{654}.JointForceAndDeformation(:,4);
%            
%                 elementCombinedPHR{36}.endi.eleTotalTH = elementArray{654}.JointForceAndDeformation(:,2);
%                 elementCombinedPHR{36}.endj.eleTotalTH = elementArray{655}.JointForceAndDeformation(:,4);   
%                 
%         % Now compute the min max and AbsMax, and combine all of the PHR response from the element and bond spring, to get the total PHR response.
%         %   I am multiplying the bond deformations by -1, so that the sings are consistent between the element and bond deformations.
%         %   Also, save the max for each element (total PHR).
% 
%                 for eleNum = 1:36
%               
%                     % Combine the bond + ele PHR
%                     elementCombinedPHR{eleNum}.endi.eleTotalMin    = min(elementCombinedPHR{eleNum}.endi.eleTotalTH);
%                     elementCombinedPHR{eleNum}.endi.eleTotalMax    = max(elementCombinedPHR{eleNum}.endi.eleTotalTH);
%                     elementCombinedPHR{eleNum}.endi.eleTotalAbsMax = max(abs(elementCombinedPHR{eleNum}.endi.eleTotalMin), abs(elementCombinedPHR{eleNum}.endi.eleTotalMax));
%                                         
%                     elementCombinedPHR{eleNum}.endj.eleTotalMin    = min(elementCombinedPHR{eleNum}.endj.eleTotalTH);
%                     elementCombinedPHR{eleNum}.endj.eleTotalMax    = max(elementCombinedPHR{eleNum}.endj.eleTotalTH);
%                     elementCombinedPHR{eleNum}.endj.eleTotalAbsMax = max(abs(elementCombinedPHR{eleNum}.endj.eleTotalMin), abs(elementCombinedPHR{eleNum}.endj.eleTotalMax));
%     
%                     % Save results
%                     absMaxPHRToSave{eleNum}.fullElement = max(elementCombinedPHR{eleNum}.endi.eleTotalAbsMax, elementCombinedPHR{eleNum}.endj.eleTotalAbsMax);
%                     absMaxPHRToSave{eleNum}.endi = elementCombinedPHR{eleNum}.endi.eleTotalAbsMax;
%                     absMaxPHRToSave{eleNum}.endj = elementCombinedPHR{eleNum}.endj.eleTotalAbsMax;
%                     
%                 end
% 
%                 % Find the beam and column with the highest PHR
%                     maxColPHR = 0.0;
%                     maxBmPHR = 0.0;
%                     colWithMaxPHR = -1;
%                     bmWithMaxPHR = -1;
%                 
%                     % Find column with maximum rotation
%                         for eleNum = 1:5
%                             if(absMaxPHRToSave{eleNum}.fullElement > maxColPHR)
%                                 % Update the max and the ele number with the max.
%                                 maxColPHR = absMaxPHRToSave{eleNum}.fullElement;
%                                 colWithMaxPHR = eleNum;
%                             end
%                         end
%                         for eleNum = 10:14
%                             if(absMaxPHRToSave{eleNum}.fullElement > maxColPHR)
%                                 % Update the max and the ele number with the max.
%                                 maxColPHR = absMaxPHRToSave{eleNum}.fullElement;
%                                 colWithMaxPHR = eleNum;
%                             end
%                         end
%                         for eleNum = 19:23
%                             if(absMaxPHRToSave{eleNum}.fullElement > maxColPHR)
%                                 % Update the max and the ele number with the max.
%                                 maxColPHR = absMaxPHRToSave{eleNum}.fullElement;
%                                 colWithMaxPHR = eleNum;
%                             end
%                         end                       
%                         for eleNum = 28:32
%                             if(absMaxPHRToSave{eleNum}.fullElement > maxColPHR)
%                                 % Update the max and the ele number with the max.
%                                 maxColPHR = absMaxPHRToSave{eleNum}.fullElement;
%                                 colWithMaxPHR = eleNum;
%                             end
%                         end                  
%                         
%                     % Find beam with maximum rotation
%                         for eleNum = 6:9
%                             if(absMaxPHRToSave{eleNum}.fullElement > maxBmPHR)
%                                 % Update the max and the ele number with the max.
%                                 maxBmPHR = absMaxPHRToSave{eleNum}.fullElement;
%                                 bmWithMaxPHR = eleNum;
%                             end
%                         end          
%                         for eleNum = 15:18
%                             if(absMaxPHRToSave{eleNum}.fullElement > maxBmPHR)
%                                 % Update the max and the ele number with the max.
%                                 maxBmPHR = absMaxPHRToSave{eleNum}.fullElement;
%                                 bmWithMaxPHR = eleNum;
%                             end
%                         end  
%                         for eleNum = 24:27
%                             if(absMaxPHRToSave{eleNum}.fullElement > maxBmPHR)
%                                 % Update the max and the ele number with the max.
%                                 maxBmPHR = absMaxPHRToSave{eleNum}.fullElement;
%                                 bmWithMaxPHR = eleNum;
%                             end
%                         end  
%                         for eleNum = 33:36
%                             if(absMaxPHRToSave{eleNum}.fullElement > maxBmPHR)
%                                 % Update the max and the ele number with the max.
%                                 maxBmPHR = absMaxPHRToSave{eleNum}.fullElement;
%                                 bmWithMaxPHR = eleNum;
%                             end
%                         end  
                        
                        
% Put together other things to save - for CalTech
    eqNum = eqNumber;  
    scaleFactorForRun = scaleFactorForRun;                    
    saValue = saTOneForRun;                    
    isCurrentAnalysisConv = isConvForFullEQ;                 
                        
 
% Compute the maximum drift ratio for the full building
    % Loop through all stories and save the maximum
    maxDriftRatioForFullStr = 0;
    for i = 1:length(storyDriftRatioToSave)
        currentDriftRatio = storyDriftRatioToSave{i}.AbsMax;    
        % Update maximum if needed
        if(currentDriftRatio > maxDriftRatioForFullStr)
            maxDriftRatioForFullStr = currentDriftRatio;
        end
    end

        
        
    
                
% Save all of this data into the folder for the proper EQ, under the correct Sa level (we are already in the right folder)
% Only save the information that is needed so that it will be more "bug resistant".
% fileName = ['DATA_reducedSensDataForThisSingleRun.mat'];
fileName = ['DATA_allDataForThisSingleRun.mat'];


% save(fileName, 'floorAccelToSave', 'storyDriftRatioToSave', 'maxConvergedTime', 'eqTimeLength',...
%     'eqNum', 'scaleFactorForRun', 'saValue', 'isCurrentAnalysisConv', 'maxTolUsed', 'maxDriftRatioForFullStr', 'PGA', 'absMaxDisplOfFloor',...
%     'saCompScaled', 'saGeoMeanScaled')

% save(fileName, 'floorAccelToSave', 'storyDriftRatioToSave', 'maxConvergedTime', 'eqTimeLength',...
%     'eqNum', 'scaleFactorForRun', 'saValue', 'isCurrentAnalysisConv', 'maxTolUsed', 'maxDriftRatioForFullStr', 'PGA', 'absMaxDisplOfFloor',...
%     'saCompScaled', 'saGeoMeanScaled', 'nodeNumsAtEachFloorLIST', 'elementArray', 'nodeArray', 'storyDriftRatioToSave', 'numStories', 'storyDriftRatio')

save(fileName, 'floorAccelToSave', 'storyDriftRatioToSave', 'maxConvergedTime', 'eqTimeLength',...
    'eqNum', 'saValue', 'isCurrentAnalysisConv', 'maxTolUsed', 'maxDriftRatioForFullStr', 'PGA', 'absMaxDisplOfFloor',...
    'nodeNumsAtEachFloorLIST', 'elementArray', 'nodeArray', 'storyDriftRatioToSave', 'numStories', 'storyDriftRatio', 'scaleFactorForRun')


 % Output warnings if there is a problem with convergence or with the tolerance - put this in the output folder
    % Go to Output folder
        cd ..;
        cd ..;
        cd ..;
    % Make a WARNING file, go into fodler first
        cd Conv_Warning_Files;
    
    % Output a warnings if needed
        if(isCurrentAnalysisConv == 0)
            % Non-conv, issue warning
            disp('#####################');
            disp('WARNING - Convergence');
            disp('#####################');
            fileName1 = sprintf('WARNING_Conv_%s.txt', filePrefix);
            %myFileStream1 = fopen(fileName1, 'write');
            myFileStream1 = fopen(fileName1, 'w');
            fprintf(myFileStream1, 'Current analysis only converged to %.2f of %.2f seconds', maxConvergedTime, eqTimeLength);
            fclose(myFileStream1);
        end
    
        if(maxTolUsed > 0.0001)
            % Tolerance too wide, issue warning
            disp('###################');
            disp('WARNING - tolerance');
            disp('###################');
            fileName2 = sprintf('WARNING_Tolerance_%s.txt', filePrefix);
            %myFileStream2 = fopen(fileName2, 'write');
            myFileStream2 = fopen(fileName2, 'w');
            fprintf(myFileStream2, 'Maximum tolerance is %.8f', maxTolUsed);
            fclose(myFileStream2);
        end
        
        
% Get back to the MatlabProcessors/VideoFolder folder where we started
cd(startFolder);

disp('Processing Finished for this EQ.');

%     eigenvaluesAfterEQ = load('eigenvaluesAfterEQOUT.out');
%     minutesToRunThisAnalysis = load('minutesToRunThisAnalysisOUT.out');
%     scaleFactorForRun = load('scaleFactorForRunOUT.out');
%     usedNormDisplIncr = load('usedNormDisplIncrOUT.out');
