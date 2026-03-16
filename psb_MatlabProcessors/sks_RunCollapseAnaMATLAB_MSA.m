%
% Procedure: RunCollapseAnaMATLAB_MSA.m
% Assumptions and Notices: none
% Author: Curt Haselton 
% Date Written: 6-28-06
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function sks_RunCollapseAnaMATLAB_MSA(msaInputs)

sensModelLIST =                                  msaInputs.sensModelLIST;
dtForCollapseMATLAB =                            msaInputs.dtForCollapseMATLAB;
minStoryDriftRatioForCollapseMATLAB =            msaInputs.minStoryDriftRatioForCollapseMATLAB; 
elementUsedForColSensModelMATLAB =               msaInputs.elementUsedForColSensModelMATLAB; 
eqFormatForCollapseList =                        msaInputs.eqFormatForCollapseList; 
sensVariableNameLIST =                           msaInputs.sensVariableNameLIST; 
sensVariableValueLIST =                          msaInputs.sensVariableValueLIST; 
eqNumberLIST =                                   msaInputs.eqNumberLIST;
saLevelsForStripes =                             msaInputs.saLevelsForStripes; 
maxNumRuns =                                     msaInputs.maxNumRuns; 
flagForEQFileFormat =                            msaInputs.flagForEQFileFormat; 
periodUsedForScalingGroundMotions =              msaInputs.periodUsedForScalingGroundMotions; 
dampingRatioUsedForSaDef =                       msaInputs.dampingRatioUsedForSaDef; 
extraSecondsToRunAnalysis =                      msaInputs.extraSecondsToRunAnalysis; 
eqTimeHistoryPreFormatted =                      msaInputs.eqTimeHistoryPreFormatted;

% (11-3-15, PSB) added parameter extraSecondsToRunAnalysis. This is carried over to the varDefinitionsFromMATLAB.tcl file via RunSingleEQ_NEWER.m and 
% WritevarToFileForOSMATLAB.m 

% (4-30-16, PSB) added parameter eqTimeHistoryPreFormatted. This is carried over to the psb_varDefinitionsFromMATLAB.tcl file.
% It is used when curtailed time history length is used.

% Do the runs...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Start analysis

    % Loop through all models to run
    for sensModelIndex = 1:length(sensModelLIST)
        sensModel = sensModelLIST{sensModelIndex};
        numStories = str2double(regexp(sensModel,'_(\d+)Story','tokens','once'));
        % numFloors  = numStories + 1;

        % Loop through all 
        modelIndex = 1; % added on 11-18-05 by CBH for post-processing
        currentOutputFolderLIST = cell(1); % (11-23-15, PSB) pre-allocation
        modelNameLIST = cell(1);
        
        for sensVariableIndex = 1:length(sensVariableNameLIST)
            sensVariableName = sensVariableNameLIST{sensVariableIndex};
            sensVariableValue = sensVariableValueLIST(sensVariableIndex);

            % Make the name of the output folder and add it to the list
            % (used later for post-processing) - added on 11-18-05 by CBH
            % for post-processing
            currentOutputFolder = sprintf('(%s)_(%s)_(%.2f)_(%s)', sensModel, sensVariableName, sensVariableValue, elementUsedForColSensModelMATLAB);
            currentOutputFolderLIST{modelIndex} = currentOutputFolder;
            modelNameLIST{modelIndex} = sensModelLIST;
            
            % Loop through all EQ numbers
            isRunTimeError = 0; % Initialize the runtime error variable
            isStoppedDueToSingular = 0;

            % (11-15-15, PSB) creating the matrix of dtForCollapseMATLAB for all EQ records
                totalNumOfEqRecords = length(eqNumberLIST);
                dtOfTimeHistory = zeros(totalNumOfEqRecords, 1);
                matrixOfDtForCollapseMATLAB = zeros(totalNumOfEqRecords, 2);

            %  eqNumberLIST
            for indexForEQ = 1:totalNumOfEqRecords
                eqNumber = eqNumberLIST(1,indexForEQ);
                matrixOfDtForCollapseMATLAB(indexForEQ, 1) = eqNumber;
                sensDir = pwd;
                    
           %	(4-30-16, PSB) implemented to debug for the cases when curtailed ground motions are used and some goof up occurs.    
            numPointsFromLengthOfTH = size(load(fullfile('C:\Users\sks\OpenSeesProcessingFiles\EQs', sprintf('SortedEQFile_(%d).txt', eqNumber))), 1);
            numPointsFromFile = load(fullfile('C:\Users\sks\OpenSeesProcessingFiles\EQs', sprintf('NumPointsFile_(%d).txt', eqNumber)));

            if (numPointsFromLengthOfTH ~= numPointsFromFile) 
                error('psbCode:chkForLengthOfGM', 'Length of SortedEQFile is not same as value in NumPointsFile of EQ ID = %d \n', eqNumber);
            end 
                    
                dtOfTimeHistory(indexForEQ) = load(fullfile('C:\Users\sks\OpenSeesProcessingFiles\EQs', sprintf('DtFile_(%d).txt',eqNumber)));

                if (dtForCollapseMATLAB >= 1)
                    matrixOfDtForCollapseMATLAB(:, 2) = dtOfTimeHistory/dtForCollapseMATLAB;
                else
                    matrixOfDtForCollapseMATLAB(:, 2) = dtForCollapseMATLAB;
                end
                    cd(sensDir)
            end            
                    dtForCollapseLIST = matrixOfDtForCollapseMATLAB(:,2); 
                          
%   timeTakenInMinsForEachAnalysis = zeros(length(eqNumberLIST),1);
    sensDir = pwd;           
                
    % (11-21-15, PSB) copying the file for independent earthquake analyses corresponding to different GMs.
    % doing this operation outside parfor b/c parfor cannot access one file at many instances.
    for eqNumberIndex = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqNumberIndex);
        specificSensFolderForSeparateEqs = sprintf('sens_%d',eqNumber);
        psb_mkdir_if_not_exist(specificSensFolderForSeparateEqs); % matlab throws error if directory already exists, hence the function 

        currentFolderTemp = pwd;
        addressForSensDir = sprintf('%s\\%s',currentFolderTemp, specificSensFolderForSeparateEqs);
        copyfile('psb_RunCollapseSensAnalysisMATLAB.tcl', addressForSensDir);
    end
                 
        cd .. % back to the models folder
        cd(sensModel) % now in the models folder


    for eqNumberIndex = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqNumberIndex);
        specificModelFolderForSeparateEqs = sprintf('model_%d',eqNumber);
        psb_mkdir_if_not_exist(specificModelFolderForSeparateEqs); % matlab throws error if directory already exists, hence the function 

        currentFolderTemp = pwd;
        addressForModelDir = sprintf('%s\\%s',currentFolderTemp, specificModelFolderForSeparateEqs);
        copyfile('*.tcl', addressForModelDir); 
    end
    cd(sensDir)  
      
     

            parfor eqNumberIndex = 1:length(eqNumberLIST)
                   eqNumber = eqNumberLIST(eqNumberIndex);
                   numFloors  = numStories + 1;
                   numSaLevels = min(numel(saLevelsForStripes), maxNumRuns);
                   % maxNumRuns =  msaInputs.maxNumRuns; 
          
                   
                % For this single EQ, we need to run the analysis and find the collapse point...
                    
                    % --- Initialize per-run variables ---
                    saLevelForEachRun          = zeros(1,numSaLevels);
                    scaleFactorForEachRun      = zeros(1,numSaLevels);
                    isCollapsedForEachRun      = zeros(1,numSaLevels);
                    isSingularForEachRun       = zeros(1,numSaLevels);
                    isNonConvForEachRun        = zeros(1,numSaLevels);
                    maxDriftForEachRun         = zeros(1,numSaLevels);
                    minDriftForEachRun         = zeros(1,numSaLevels);
                    maxResidualDriftForEachRun = zeros(1,numSaLevels);
                    minResidualDriftForEachRun = zeros(1,numSaLevels);
                    absResidualDriftForEachRun = zeros(1,numSaLevels);


                    % saLevelForEachRun          = zeros(1,maxNumRuns);
                    % scaleFactorForEachRun      = zeros(1,maxNumRuns);
                    % isCollapsedForEachRun      = zeros(1,maxNumRuns);
                    % isSingularForEachRun       = zeros(1,maxNumRuns);
                    % isNonConvForEachRun        = zeros(1,maxNumRuns);
                    % maxDriftForEachRun         = zeros(1,maxNumRuns);
                    % minDriftForEachRun         = zeros(1,maxNumRuns);
                    % maxResidualDriftForEachRun = zeros(1,maxNumRuns);
                    % minResidualDriftForEachRun = zeros(1,maxNumRuns);
                    % absResidualDriftForEachRun = zeros(1,maxNumRuns);

                    % ---  INSERT NEW STORY-LEVEL ARRAYS HERE ---

                    % Story-level drift ratios
                    maxStoryDriftRatioAtEachStoryAtEachRun = zeros(numStories, numSaLevels);
                    minStoryDriftRatioAtEachStoryAtEachRun = zeros(numStories, numSaLevels);
                    absStoryDriftRatioAtEachStoryAtEachRun = zeros(numStories, numSaLevels);

                    % maxStoryDriftRatioAtEachStoryAtEachRun          = zeros(numStories, maxNumRuns);
                    % minStoryDriftRatioAtEachStoryAtEachRun          = zeros(numStories, maxNumRuns);
                    % absStoryDriftRatioAtEachStoryAtEachRun          = zeros(numStories, maxNumRuns);

                    % Story-level residual drift ratios, 
                    maxStoryResidualDriftRatioAtEachStoryAtEachRun = zeros(numStories, numSaLevels);
                    minStoryResidualDriftRatioAtEachStoryAtEachRun = zeros(numStories, numSaLevels);
                    absStoryResidualDriftRatioAtEachStoryAtEachRun = zeros(numStories, numSaLevels);

                    % maxStoryResidualDriftRatioAtEachStoryAtEachRun  = zeros(numStories, maxNumRuns);
                    % minStoryResidualDriftRatioAtEachStoryAtEachRun  = zeros(numStories, maxNumRuns);
                    % absStoryResidualDriftRatioAtEachStoryAtEachRun  = zeros(numStories, maxNumRuns);

                    % Story-level peak floor accelerations, 
                    maxPeakFloorAccelerationAtEachFloorAtEachRun = zeros(numFloors, numSaLevels);
                    minPeakFloorAccelerationAtEachFloorAtEachRun = zeros(numFloors, numSaLevels);
                    absPeakFloorAccelerationAtEachFloorAtEachRun = zeros(numFloors, numSaLevels);

                    % maxPeakFloorAccelerationAtEachFloorAtEachRun    = zeros(numFloors, maxNumRuns);
                    % minPeakFloorAccelerationAtEachFloorAtEachRun    = zeros(numFloors, maxNumRuns);
                    % absPeakFloorAccelerationAtEachFloorAtEachRun    = zeros(numFloors, maxNumRuns);
                    
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%% Start - runs to through every sa stripe value %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   
                        %% MSA loop for stripes

                        

                        % numSaLevels = numel(saLevelsForStripes);
                        for saLevelIndex = 1:numSaLevels
                            currentSaLevel = saLevelsForStripes(saLevelIndex);

                        % maxNumRuns = numel(saLevelsForStripes);
                        % for saLevelIndex = 1:maxNumRuns
                        %     currentSaLevel = saLevelsForStripes(saLevelIndex);

            fprintf('###########################################################################################\n');
            fprintf('############################# Current Sa Level is %.4f ############################\n', currentSaLevel);
            fprintf('###########################################################################################\n');
                           
                            % Compute the scale factor and the scaled Sa values (added 6-29-06)
                            eqNumberForGeoMean = floor(eqNumber / 10.0);
                            if (flagForEQFileFormat == 1)
                                % Scaling by component Sa
                                scaleFactorForRunFromMatlab = currentSaLevel / psb_RetrieveSaCompValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef);
                                saCompScaled = currentSaLevel;
                                saGeoMeanScaled = -1;       % Just put a dummy variable because likely we did not define both components of GM
                            elseif (flagForEQFileFormat == 2)
                                % Scaling by geometric mean Sa
                                scaleFactorForRunFromMatlab = currentSaLevel / psb_RetrieveSaGeoMeanValueForAnEQ(eqNumberForGeoMean, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef);
                                saCompScaled = scaleFactorForRunFromMatlab * psb_RetrieveSaCompValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef);
                                saGeoMeanScaled = currentSaLevel;
                            else
                                error('Invalid value for flagForEQFileFormat!!!')
                            end

%%                                 Prak_RunSingleEQ_NEWER 

    % Reinitialize the variables that may have been retrieved from the last analysis, with a dummy variable that will show up if there is a problem with 
    %   the variables being defined again.
        isCollapsed                     = -1;
        isSingular                      = -1;
        isNonConv                       = -1;     
        maxStoryDriftRatioForFullStr    = -1;
        minStoryDriftRatioForFullStr    = -1;

    % Source in the M-file to write the variables to a file for opensees to read
%%    Prak_WriteVarToFileForOSMATLAB;         % suppressed the content of this file here

% (11-21-15, PSB) added
    specificSensFolderForSeparateEqs = sprintf('sens_%d',eqNumber);
    cd(sprintf('%s\\%s', sensDir, specificSensFolderForSeparateEqs))

sensModel
    myFileStream = fopen('psb_VarDefinitionsFromMATLAB.tcl', 'w'); % 'w' discards the existing content and starts writing (doesn't append), which is what we want (10-29-15, PSB)
    
% Make all of the strings to write to the file
    fprintf(myFileStream, '# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse\n'); 
    fprintf(myFileStream, '#     run, so that Opensees can read the file and define the needed variables\n');
    fprintf(myFileStream, '\n');   % new line

    dtForCollapseMATLAB1 = dtForCollapseLIST(eqNumberIndex);
    fprintf(myFileStream, 'set dtForCollapseMATLAB %.6f\n', dtForCollapseMATLAB1);
    fprintf(myFileStream, 'set minStoryDriftRatioForCollapseMATLAB %.3f\n', minStoryDriftRatioForCollapseMATLAB);
    fprintf(myFileStream, 'set elementUsedForColSensModelMATLAB %s\n', elementUsedForColSensModelMATLAB);
    fprintf(myFileStream, 'set sensModel %s\n', sensModel);
    fprintf(myFileStream, 'set sensVariableName %s\n', sensVariableName);
    fprintf(myFileStream, 'set sensVariableValue %.2f\n', sensVariableValue);
    % Added on 12-16-08 (CBH) so that it sets the sensitivity variable equal to
    % the value.  This makes it so this file also works for the new
    % sensitivity runs done for the shear rigs.
    fprintf(myFileStream, 'set %s %.2f\n', sensVariableName, sensVariableValue);
    fprintf(myFileStream, 'set eqNumber %d\n', eqNumber);
    fprintf(myFileStream, 'set eqFormatForCollapseList %s\n', eqFormatForCollapseList);
    % This was updated on 6-29-06 to output a scale factor for the run as well as the Sa level; also add some other information to transfer.
    fprintf(myFileStream, 'set currentSaLevel %.2f\n', currentSaLevel);
	fprintf(myFileStream, 'puts "currentSaLevel is $currentSaLevel"\n');
    fprintf(myFileStream, 'set scaleFactorForRunFromMatlab %6f\n', scaleFactorForRunFromMatlab);
    fprintf(myFileStream, 'set periodUsedForScalingGroundMotionsFromMatlab %.4f\n', periodUsedForScalingGroundMotions);
    fprintf(myFileStream, 'set dampingRatioUsedForSaDefFromMatlab %.4f\n', dampingRatioUsedForSaDef);
    fprintf(myFileStream, 'set saCompScaled %.2f\n', saCompScaled);
    fprintf(myFileStream, 'set saGeoMeanScaled %.2f\n', saGeoMeanScaled);
    fprintf(myFileStream, 'set extraSecondsToRunAnalysis %.2f\n', extraSecondsToRunAnalysis);
    fprintf(myFileStream, 'set eqTimeHistoryPreFormatted %i\n', eqTimeHistoryPreFormatted);
    
% Close the file
    fclose(myFileStream);

%%    
    disp(pwd)

!OpenSees psb_RunCollapseSensAnalysisMATLAB.tcl
                   
%% RetrieveCollapseRunResults;

% (11-21-15, PSB) pasting the content of RetrieveCollapseRunResults. Since it
% Created the folder name that the data is in - this was tested and works correctly
    analysisFolderName = sprintf('(%s)_(%s)_(%.2f)_(%s)', sensModel, sensVariableName, sensVariableValue, elementUsedForColSensModelMATLAB);
   
% Save current folder location to get back to it easily
    sensDirForComingBack = pwd;
    
% Go into the output folder for this EQ run
    cd(fullfile(sensDir, '..', '..', 'Output'))
    cd(analysisFolderName);
    eqFolder = sprintf('EQ_%d', eqNumber);
    cd(eqFolder);
    saFolder = sprintf('Sa_%.2f', currentSaLevel);
    cd(saFolder);
    cd RunInformation;
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LOAD FLOOR HEIGHTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    floorHeights = load('floorHeightLISTOUT.out');
    storyHeights = diff(floorHeights);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LOAD NODE LIST
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    allNodes = load('nodeNumToRecordLISTOUT.out');
    floorNodes = allNodes(mod(allNodes,1000) == 13); % Extract only nodes ending with 013 (top joint nodes)
    floorControlNodes = sort(floorNodes);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CREATE NODE PAIRS FOR STORY DRIFT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    nodePairs = [floorControlNodes(1:end-1) floorControlNodes(2:end)];

    % Safety check
    if size(nodePairs,1) ~= numStories
        error('Mismatch between number of stories and node pairs.');
    end


% Now, load the needed data for this run
   isCollapsed                               = load('isCollapsedOUT.out'); 
   isSingular                                = load('isSingularOUT.out'); 
   isNonConv                                 = load('isNonConvOUT.out');
   maxStoryDriftRatioForFullStr              = load('maxStoryDriftRatioForFullStrOUT.out'); 
   minStoryDriftRatioForFullStr              = load('minStoryDriftRatioForFullStrOUT.out'); 
   maxStoryResidualDriftRatioForFullStr      = load('maxStoryResidualDriftRatioForFullStrOUT.out');
   minStoryResidualDriftRatioForFullStr      = load('minStoryResidualDriftRatioForFullStrOUT.out');
   absStoryResidualDriftRatioForFullStr      = load('absStoryResidualDriftRatioForFullStrOUT.out');
    
   

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % EXTRACT STORY RESPONSES FROM TH NODE FILES added on (03-Mar-2026)
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Go back to Sa folder
   cd ..;        % Back to Sa_xx
   cd Nodes;
   cd DisplTH;
 
   % ------------------------------------------------------------------
   % Read all node displacement files into a struct for easier access
   % ------------------------------------------------------------------
   allNodeDisp = struct();  % store each node's displacement
   uniqueNodes = unique(nodePairs(:));

   for nodeNum = uniqueNodes'
       fileName = sprintf('THNodeDispl_%d.out', nodeNum);

       if exist(fileName,'file')
           allNodeDisp.(sprintf('node%d',nodeNum)) = load(fileName);
       else
           warning('File %s not found.',fileName);
       end
   end
   

% ------------------------------------------------------------------
% 1) STORY DRIFT FROM NODE DISPLACEMENTS
% ------------------------------------------------------------------
   
    for storyIndex = 1:numStories
        lowerStoryNode = nodePairs(storyIndex,1);
        upperStoryNode = nodePairs(storyIndex,2);
    
        % Use the pre-read data from allNodeData struct
        % Extract displacement matrices
        lowerStoryNodeDisp = allNodeDisp.(sprintf('node%d', lowerStoryNode));
        upperStoryNodeDisp = allNodeDisp.(sprintf('node%d', upperStoryNode));

        % Time and displacement
        timeVector = lowerStoryNodeDisp(:,1);      % used for residual drift extraction
        lowerStoryDisp = lowerStoryNodeDisp(:,2);  % DOF 1 assumed (X)
        upperStoryDisp = upperStoryNodeDisp(:,2);  % DOF 1 assumed (X)

        driftRatio = (upperStoryDisp - lowerStoryDisp) / storyHeights(storyIndex);
    
        maxStoryDriftRatioAtEachStoryAtEachRun(storyIndex, saLevelIndex) = max(driftRatio);
        minStoryDriftRatioAtEachStoryAtEachRun(storyIndex, saLevelIndex) = min(driftRatio);
        absStoryDriftRatioAtEachStoryAtEachRun(storyIndex, saLevelIndex) = max(abs(driftRatio));
    
        % ----------------------------------------------------
        % Residual drift from last extraSecondsToRunAnalysis
        % ----------------------------------------------------
        analysisEndTime = timeVector(end);
        residualStartTime = analysisEndTime - extraSecondsToRunAnalysis;

        residualIndices = timeVector >= residualStartTime;
        residualDrift = mean(driftRatio(residualIndices));

        maxStoryResidualDriftRatioAtEachStoryAtEachRun(storyIndex, saLevelIndex) = residualDrift;
        minStoryResidualDriftRatioAtEachStoryAtEachRun(storyIndex, saLevelIndex) = residualDrift;
        absStoryResidualDriftRatioAtEachStoryAtEachRun(storyIndex, saLevelIndex) = abs(residualDrift); % only value needed for further
       
    end

   cd ..

   % ------------------------------------------------------------------
   % 2) FLOOR ACCELERATION FROM NODE ACCEL FILES (FLOOR-WISE)
   % ------------------------------------------------------------------
   cd AccelTH

   numFloors = length(floorControlNodes);   % it includes ground floor
   % numFloors = length(floorControlNodes) - 1; % it does not includes ground floor

     % for floorIndex = 1:length(floorControlNodes)
   for floorIndex = 1:numFloors
       floorNode = floorControlNodes(floorIndex);
       accelTH = load(sprintf('THNodeAccel_%d.out', floorNode));
       accelX = accelTH(:,2);

       maxPeakFloorAccelerationAtEachFloorAtEachRun(floorIndex, saLevelIndex) = max(accelX);
       minPeakFloorAccelerationAtEachFloorAtEachRun(floorIndex, saLevelIndex) = min(accelX);
       absPeakFloorAccelerationAtEachFloorAtEachRun(floorIndex, saLevelIndex) = max(abs(accelX));
   end

   cd ..
   cd ..

 
% Go back to starting directory (sens. dir.)
    cd(sensDirForComingBack)

%%
                                % Save results in the vector
                                saLevelForEachRun(saLevelIndex)          =  currentSaLevel;
                                scaleFactorForEachRun(saLevelIndex)      =  scaleFactorForRunFromMatlab;
                                isCollapsedForEachRun(saLevelIndex)      =  isCollapsed;
                                isSingularForEachRun(saLevelIndex)       =  isSingular;
                                isNonConvForEachRun(saLevelIndex)        =  isNonConv;
                                maxDriftForEachRun(saLevelIndex)         =  maxStoryDriftRatioForFullStr;
                                minDriftForEachRun(saLevelIndex)         =  minStoryDriftRatioForFullStr;
                                maxResidualDriftForEachRun(saLevelIndex) =  maxStoryResidualDriftRatioForFullStr;
                                minResidualDriftForEachRun(saLevelIndex) =  minStoryResidualDriftRatioForFullStr;
                                absResidualDriftForEachRun(saLevelIndex) =  absStoryResidualDriftRatioForFullStr;

                                % disp(pwd)
                                % cd ..


                sks_SaveResultsForThisEQ_MSA(analysisFolderName, currentOutputFolder, currentOutputFolderLIST, currentSaLevel, ...
                    dampingRatioUsedForSaDef, dtForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFolder, eqFormatForCollapseList, ...
                    eqNumber, eqNumberForGeoMean, eqNumberIndex, eqNumberLIST, flagForEQFileFormat, isCollapsed, isCollapsedForEachRun, ...
                    isNonConv, isNonConvForEachRun, isRunTimeError, isSingular, isSingularForEachRun, isStoppedDueToSingular, ...
                    maxDriftForEachRun, numSaLevels, maxStoryDriftRatioForFullStr, minDriftForEachRun, minStoryDriftRatioForCollapseMATLAB, ...
                    minStoryDriftRatioForFullStr, maxResidualDriftForEachRun, maxStoryResidualDriftRatioForFullStr, minResidualDriftForEachRun, ...
                    minStoryResidualDriftRatioForFullStr, absResidualDriftForEachRun, absStoryResidualDriftRatioForFullStr, modelIndex, modelNameLIST, ...
                    myFileStream, periodUsedForScalingGroundMotions, saCompScaled, saFolder, saGeoMeanScaled, saLevelForEachRun, saLevelIndex, ...
                    scaleFactorForEachRun, scaleFactorForRunFromMatlab, sensDir, sensModel, sensModelIndex, sensModelLIST, sensVariableIndex, ...
                    sensVariableName, sensVariableNameLIST, sensVariableValue, sensVariableValueLIST,...     
                    maxStoryDriftRatioAtEachStoryAtEachRun, ...
                    minStoryDriftRatioAtEachStoryAtEachRun, ...
                    absStoryDriftRatioAtEachStoryAtEachRun, ...
                    maxStoryResidualDriftRatioAtEachStoryAtEachRun, ...
                    minStoryResidualDriftRatioAtEachStoryAtEachRun, ...
                    absStoryResidualDriftRatioAtEachStoryAtEachRun, ...
                    maxPeakFloorAccelerationAtEachFloorAtEachRun, ...
                    minPeakFloorAccelerationAtEachFloorAtEachRun, ...
                    absPeakFloorAccelerationAtEachFloorAtEachRun);
                    

                        end % End MSA loop here (7-Jan-2026)    
             end   % parfor_progress(0)
         end  % End of the sensitivity variable loop 
    end   % End of model loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
