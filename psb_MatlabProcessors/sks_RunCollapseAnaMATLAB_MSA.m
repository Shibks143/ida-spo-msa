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
        % numStories = str2double(regexp(sensModel,'_(\d+)Story','tokens','once'));
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
                   numSaLevels = min(numel(saLevelsForStripes), maxNumRuns);
                   % numFloors  = numStories + 1;
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
    

% Now, load the needed data for this run
   isCollapsed                               = load('isCollapsedOUT.out'); 
   isSingular                                = load('isSingularOUT.out'); 
   isNonConv                                 = load('isNonConvOUT.out');
   maxStoryDriftRatioForFullStr              = load('maxStoryDriftRatioForFullStrOUT.out'); 
   minStoryDriftRatioForFullStr              = load('minStoryDriftRatioForFullStrOUT.out'); 

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
                            
                                % disp(pwd)
                                % cd ..


                sks_SaveResultsForThisEQ_MSA(analysisFolderName, currentOutputFolder, currentOutputFolderLIST, currentSaLevel, ...
                    dampingRatioUsedForSaDef, dtForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFolder, eqFormatForCollapseList, ...
                    eqNumber, eqNumberForGeoMean, eqNumberIndex, eqNumberLIST, flagForEQFileFormat, isCollapsed, isCollapsedForEachRun, ...
                    isNonConv, isNonConvForEachRun, isRunTimeError, isSingular, isSingularForEachRun, isStoppedDueToSingular, ...
                    maxDriftForEachRun, numSaLevels, maxStoryDriftRatioForFullStr, minDriftForEachRun, minStoryDriftRatioForCollapseMATLAB, ...
                    minStoryDriftRatioForFullStr,  modelIndex, modelNameLIST, ...
                    myFileStream, periodUsedForScalingGroundMotions, saCompScaled, saFolder, saGeoMeanScaled, saLevelForEachRun, saLevelIndex, ...
                    scaleFactorForEachRun, scaleFactorForRunFromMatlab, sensDir, sensModel, sensModelIndex, sensModelLIST, sensVariableIndex, ...
                    sensVariableName, sensVariableNameLIST, sensVariableValue, sensVariableValueLIST);
                    

                        end % End MSA loop here (7-Jan-2026)    
             end   % parfor_progress(0)
         end  % End of the sensitivity variable loop 
    end   % End of model loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
