%
% Procedure: RunCollapseAnaMATLAB_NEWER_proc.m
% -------------------
% This is the same as RunCollapseAnaMATLAB_NEWER.m, but it is just a
% procedure.
%
% Assumptions and Notices:
%           - none
%
% Author: Curt Haselton
% Date Written: 6-28-06
%
% Functions and Procedures called: none
%
% Variable definitions:
%       - not listed
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function psb_RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, ...
% eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, ...
% maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, ...
% extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysis, eqTimeHistoryPreFormatted, openseesFileToUse)

function psb_RunCollapseAnaMATLAB_NEWER_proc(idaInputs)

dtForCollapseMATLAB =                  idaInputs.dtForCollapseMATLAB ;
minStoryDriftRatioForCollapseMATLAB =  idaInputs.minStoryDriftRatioForCollapseMATLAB ;
elementUsedForColSensModelMATLAB =     idaInputs.elementUsedForColSensModelMATLAB ;
eqFormatForCollapseList =              idaInputs.eqFormatForCollapseList ;
sensModelLIST =                        idaInputs.sensModelLIST ;
sensVariableNameLIST =                 idaInputs.sensVariableNameLIST ;
sensVariableValueLIST =                idaInputs.sensVariableValueLIST ;
eqNumberLIST =                         idaInputs.eqNumberLIST ;
saStartLevel =                         idaInputs.saStartLevel ;
startStepSize =                        idaInputs.startStepSize ;
tolerance =                            idaInputs.tolerance ;
maxNumRuns =                           idaInputs.maxNumRuns ;
perturbationForNonConvSingular =       idaInputs.perturbationForNonConvSingular ;
flagForEQFileFormat =                  idaInputs.flagForEQFileFormat ;
periodUsedForScalingGroundMotions =    idaInputs.periodUsedForScalingGroundMotions ;
dampingRatioUsedForSaDef =             idaInputs.dampingRatioUsedForSaDef ;
extraSecondsToRunAnalysis =            idaInputs.extraSecondsToRunAnalysis ;
% timeTakenInMinsForEachAnalysisOld =       idaInputs.timeTakenInMinsForEachAnalysisOld ;
eqTimeHistoryPreFormatted =            idaInputs.eqTimeHistoryPreFormatted ;

% Fill in unset optional values.
switch nargin
    case 19
        % openseesFileToUse = 'default'; % USE OpenSees_2.5.0_64bit_downloaded_11-13-16, when Shear Limit State material is not in use
        %     case 20 % when there is 20th argument it has to be either 'default' or 'kNmmLimit'
        %         openseesFileToUse = 'kNmmLimit'; % USE OpenSees_64-kNmmMPa-PSB-11-01-16, when Shear LSM is in use in units of kN-mm
end

% some of the parameters to this function are shown as unused by the matlab e.g.-
% dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, eqFormatForCollapseList. However they are used in the script files called
% below in this function. For instance, in RunSingleEQ_NEWER.m and WriteVarToFileForOSMATLAB.m

% (11-3-15, PSB) added parameter extraSecondsToRunAnalysis. This is carried over to the varDefinitionsFromMATLAB.tcl file via RunSingleEQ_NEWER.m and
% WritevarToFileForOSMATLAB.m

% (4-30-16, PSB) added parameter eqTimeHistoryPreFormatted. This is carried over to the psb_varDefinitionsFromMATLAB.tcl file.
% It is used when curtailed time history length is used.

% Do the runs...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First, open the Matlab file that has all of the information about the EQs (e.g. the EQ lengths, to check for non-convergence)
%     defineEQInfoForMATLAB

% Start analysis

% Loop through all models to run
for sensModelIndex = 1:length(sensModelLIST)
    sensModel = sensModelLIST{sensModelIndex};

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

        %              eqNumberLIST
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



        % (11-23-15, PSB) removed temporarily. This implies that recover thing
        % won't work, however will store the array of timeTakenInEachAnalyses
        % numberOfAnalysesRun = length(timeTakenInMinsForEachAnalysis);
        %     timeTakenInMinsForEachAnalysis = zeros(length(eqNumberLIST),1);
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

            %         cd(specificSensFolderForSeparateEqs) % Now in the earthquake specific folder
            %         cd .. % back to the Prak_Sensitivity_Analysis folder
        end


        % (11-21-15, PSB) creating model specific files for parallel computing. This is to keep all the earthquake analyses independent of one another.

        cd .. % back to the models folder
        cd(sensModel) % now in the models folder

        for eqNumberIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqNumberIndex);
            specificModelFolderForSeparateEqs = sprintf('model_%d',eqNumber);
            psb_mkdir_if_not_exist(specificModelFolderForSeparateEqs); % matlab throws error if directory already exists, hence the function

            currentFolderTemp = pwd;
            addressForModelDir = sprintf('%s\\%s',currentFolderTemp, specificModelFolderForSeparateEqs);
            copyfile('*.tcl', addressForModelDir);
            % note that if *.* command is given for copying then it becomes a spiral and folders created in the last iterations get copied into the next one
            % if some other extension files are to be copied as well, it is recommended to give the command again, for ex- copyfile('*.m','.') etc

            %         cd(specificModelFolderForSeparateEqs) % Now in the earthquake specific folder
            %         cd .. % back to the Prak_Sensitivity_Analysis folder
        end

        cd(sensDir)
        %               dtForCollapseLIST = matrixOfDtForCollapseMATLAB(:,2);

        %     numberOfAnalyses = length(eqNumberLIST);
        %     parfor_progress(numberOfAnalyses); % Set the total number of iterations. Function added to path C:\Users\Prakash\Documents\MATLAB

        parfor eqNumberIndex = 1:length(eqNumberLIST)
            % (11-15-15, PSB) adding time taken for each Earthquake analysis to later on save in one file
            t0(eqNumberIndex,:) = clock;
            %                 sensDirLocalForParfor = pwd;
            eqNumber = eqNumberLIST(eqNumberIndex);

            % For this single EQ, we need to run the analysis and find the collapse point...

            % Initialize the variables
            saLevelForEachRun       = zeros(1,maxNumRuns);
            scaleFactorForEachRun   = zeros(1,maxNumRuns);
            isCollapsedForEachRun   = zeros(1,maxNumRuns);
            isSingularForEachRun    = zeros(1,maxNumRuns);
            isNonConvForEachRun     = zeros(1,maxNumRuns);
            maxDriftForEachRun      = zeros(1,maxNumRuns);
            minDriftForEachRun      = zeros(1,maxNumRuns);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%% Start - runs to find first collapse point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % First keep stepping up the analysis until you find the first collapse point.

            % Initialize loop variables
            saLevelIndex = 1;
            currentSaLevel = saStartLevel;

            % Initialize the bounds on the collapse point
            maxSaNoCollapse = 0;
            minSaCollapse   = 100.0;

            %% Loop until we find the first collapse point
            while (1 == 1)

                % Break is we have run too many EQ's (shouldn't ever control in this loop, but put in just in case)
                if (saLevelIndex > maxNumRuns)
                    break;
                end

                if(mod(currentSaLevel * 100, 10) <= 1e-4)    % this is theoretically a check for equality with zero, but due to precision error, it wont go through hence a small value
                    currentSaLevel = currentSaLevel + 0.01; % Changed to increase Sa due to convergence issued on 11-23-15
                end
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

                % Run the EQ for this single record
                % Run the EQ - this also initializes the variables

                %%                                 Prak_RunSingleEQ_NEWER
                % (11-21-15, PSB) pasting the content of Prak_RunSingleEQ_NEWER. Since it
                % is a script file (not a function) and parfor doesn't like it.

                % This file runs a single EQ record

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
                %     Prak_mkdir_if_not_exist(specificFolderForSeparateEqs); % matlab throws error if directory already exists, hence the function

                %      temp99 = sprintf('temp99 is %s', pwd);
                %      disp(temp99);

                %      disp(pwd)
                cd(sprintf('%s\\%s', sensDir, specificSensFolderForSeparateEqs))
                % try
                %     cd(specificSensFolderForSeparateEqs)
                % catch
                %     cd ..
                %     cd(specificSensFolderForSeparateEqs)
                % end

                myFileStream = fopen('psb_VarDefinitionsFromMATLAB.tcl', 'w'); % 'w' discards the existing content and starts writing (doesn't append), which is what we want (10-29-15, PSB)

                % Make all of the strings to write to the file
                fprintf(myFileStream, '# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse\n');
                fprintf(myFileStream, '#     run, so that Opensees can read the file and define the needed variables\n');
                fprintf(myFileStream, '\n');   % new line

                % (11-15-15, PSB) changing dtForCollapseMATLAB for being able to have variable dt across different EQ records
                % remember current directory to return easliy

                %     indexForTheRunningEQ = find(matrixOfDtForCollapseMATLAB(:,1)==eqNumber);
                %     dtForCollapseMATLAB = matrixOfDtForCollapseMATLAB(indexForTheRunningEQ, 2);
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

                % (11-22-15, PSB) removed. Since We want to anyway stay in the sens_eqNumber folder for running opensees
                %     cd ..

                %%
                % Run the EQ
                %!openSees_WithSecondFixFromArash_2005_11_28 RunCollapseSensAnalysisMATLAB.tcl
                %!openSees_FromWeb_2005_10_18 RunCollapseSensAnalysisMATLAB.tcl
                %!openSees-New_From_Frank_10_7_04 RunCollapseSensAnalysisMATLAB.tcl
                %!openSees-Arash-Farzin-1-8-05-Clough RunCollapseSensAnalysisMATLAB.tcl

                %     specificSensFolderForSeparateEqs = sprintf('sens_%d',eqNumber);
                %     cd(specificSensFolderForSeparateEqs) % Now in the earthquake specific folder
                disp(pwd)
                %     !OpenSees psb_RunCollapseSensAnalysisMATLAB.tcl
                %     !OpenSees_2.5.0 psb_RunCollapseSensAnalysisMATLAB.tcl

                !OpenSees psb_RunCollapseSensAnalysisMATLAB.tcl

                % if strcmp(openseesFileToUse, 'default') % USE OpenSees_2.5.0_64bit_downloaded_11-13-16, when Shear Limit State material is not in use
                %     !OpenSees psb_RunCollapseSensAnalysisMATLAB.tcl
                % elseif strcmp(openseesFileToUse, 'kNmmLimit') % USE OpenSees_64-kNmmMPa-PSB-11-01-16, when Shear LSM is in use in units of kN-mm
                %     !OpenSees_64-kNmmMPa-PSB-11-01-16 psb_RunCollapseSensAnalysisMATLAB.tcl
                % end


                % Retrieve the results
                %% RetrieveCollapseRunResults;

                % (11-21-15, PSB) pasting the content of RetrieveCollapseRunResults. Since it
                % is a script file (not a function) and parfor doesn't like it.

                % Created the folder name that the data is in - this was tested and works correctly
                analysisFolderName = sprintf('(%s)_(%s)_(%.2f)_(%s)', sensModel, sensVariableName, sensVariableValue, elementUsedForColSensModelMATLAB)
                %disp(analysisFolderName)

                % Save current folder location to get back to it easily
                sensDirForComingBack = pwd;

                % Go into the output folder for this EQ run
                cd ..;
                cd ..;
                cd ..;
                disp(pwd)
                cd Output;

                cd(analysisFolderName)
                % sprintf('Prakash \n')
                eqFolder = sprintf('EQ_%d', eqNumber)
                cd(eqFolder);

                % (11-23-15, PSB) replaced the adjustment for sig figs part by the simpler code below it.

                % We are now in the EQ folder, but the Sa folder is a bit more tricky, just due to the name having one or two decimal places.  Get into the Sa folder (this just
                %   looks like a lot b/c the code gets large for it to get into a folder with a name with either one or two decimal places.
                %         saFolderOneDecimalPlace = sprintf('Sa_%.1f', currentSaLevel);
                %         saFolderTwoDecimalPlace = sprintf('Sa_%.2f', currentSaLevel);
                %         if(exist(saFolderTwoDecimalPlace,'dir') == 7)
                %             % If we get here, then the directory with one decimal place is correct.
                %             %disp('Using one decimal place for folder names...')
                %             saFolder = sprintf('Sa_%.2f', currentSaLevel)
                %         elseif(exist(saFolderOneDecimalPlace,'dir') == 7)
                %             % If we get here, then the directory with two decimal places is correct.
                %             %disp('Using two decimal places for folder names...')
                %             saFolder = sprintf('Sa_%.1f', currentSaLevel)
                %         else
                %             error('ERROR: The Sa folder could not be found!!')
                %         end

                % (11-23-15, PSB) this (following commented code) will not work, b/c the Sa Value needs to be written in the VarDefinitionsFromMATLAB.tcl file as well.
                % Hence shifted the precision-handling part above to the place where VarDefinitionsFromMATLAB.tcl is written

                %         if(mod(currentSaLevel * 100, 10) <= 1e-4)    % this is theoretically a check for equality with zero, but due to precision error, it wont go through hence a small value
                %             saFolder = sprintf('Sa_%.2f', currentSaLevel + 0.01) % Changed to increase Ss due to convergence issued on 9-19-05
                %         else
                %             saFolder = sprintf('Sa_%.2f', currentSaLevel) % Changed to increase Ss due to convergence issued on 9-19-05
                %         end

                saFolder = sprintf('Sa_%.2f', currentSaLevel) % precision issue handled above while writing the VarDefinitionsFromMATLAB.tcl
                % Now go into the folder
                cd(saFolder)

                % Now get into the RunInformation folder to get the needed output data
                cd RunInformation;


                % Now, load the needed data for this run
                isCollapsed = load('isCollapsedOUT.out');
                isSingular = load('isSingularOUT.out');
                isNonConv = load('isNonConvOUT.out');
                maxStoryDriftRatioForFullStr = load('maxStoryDriftRatioForFullStrOUT.out');
                minStoryDriftRatioForFullStr = load('minStoryDriftRatioForFullStrOUT.out');


                % Checks
                % disp(isCollapsed)
                % disp(isSingular)
                % disp(maxStoryDriftRatioForFullStr)
                % disp(minStoryDriftRatioForFullStr)


                % Go back to starting directory (sens. dir.)
                cd(sensDirForComingBack)


                %%
                % Save results in the vector
                saLevelForEachRun(saLevelIndex)     = currentSaLevel;
                scaleFactorForEachRun(saLevelIndex) = scaleFactorForRunFromMatlab;
                isCollapsedForEachRun(saLevelIndex) = isCollapsed;
                isSingularForEachRun(saLevelIndex)  = isSingular;
                isNonConvForEachRun(saLevelIndex)   = isNonConv;
                maxDriftForEachRun(saLevelIndex)    = maxStoryDriftRatioForFullStr;
                minDriftForEachRun(saLevelIndex)    = minStoryDriftRatioForFullStr;

                % Put an error if any of the variables are still at thier initialized values of -1
                if (isCollapsed == -1 || isSingular == -1 || isNonConv == -1 || maxStoryDriftRatioForFullStr == -1 || minStoryDriftRatioForFullStr == -1)
                    error('ERROR: The variables are still equal to thier initialized values, even after running the EQ (first loop)!!!');
                end

                % If it collapsed, then break out of this loop
                if (isCollapsed == 1)
                    % It collapsed; update the variables, then brake from the while loop
                    disp('It collapsed!');
                    cd .. % note that cd .. in the end of this while loop doesnt get executed if collapse is found, so we need to give this command here for the collapse case
                    minSaCollapse = currentSaLevel;
                    saLevelIndex = saLevelIndex + 1;
                    break;
                else
                    % It did not collapse, so update the variable
                    disp('No collapse');
                    % Only update the lower bound if it is not singular and if it's fully converged
                    if (isSingular == 0 && isNonConv == 0)
                        maxSaNoCollapse = currentSaLevel;
                    end
                end

                % NOTICE: If we get here, then it didn't collapse

                % If it's singular or non-converged, then reduce Sa by perturbationForNonConvSingular and rerun.
                if (isSingular == 1 || isNonConv == 1)
                    % It is either singular or non-converged, so reduce Sa a litte and run it again
                    currentSaLevel = currentSaLevel + perturbationForNonConvSingular; % Changed to increase Ss due to convergence issued on 9-19-05
                    % Increment the Sa level index
                    saLevelIndex = saLevelIndex + 1;

                    %                                 % OLD WAY OR DOING IT - I JUST STOPPED THE ANALYSIS
                    %                                         % Set the collapse variables to dummies
                    %                                             minSaCollapse = 0.02;
                    %                                             maxSaNoCollapse = 0.01;
                    %                                         % Set the flag
                    %                                             isStoppedDueToSingular = 1;
                    %                                      % Stop the analysis for this EQ
                    %                                             break;
                else
                    % Not singular, so increment Sa level
                    currentSaLevel = currentSaLevel + startStepSize;
                    %                                     textToDisp=sprintf('currentSaLevel changed to %3.2f',currentSaLevel);
                    %                                     disp(textToDisp);
                    % Increment the Sa level index
                    saLevelIndex = saLevelIndex + 1;
                end

                % Due to a folder naming error, the Sa level needs to have two decimal places, so adjust it to have two decimal places is needed...
                %   Note that I effectively round to two decimal places when doing this (this is the compilcate "round" stuff)


                %	(11-4-15) commented out the following loop. Not necessary since rounding off to 2 sig figs is already done

                %                                 if((mod(((round(currentSaLevel * 100.0))/100.0), 0.10)) < 0.01)
                if mod(currentSaLevel * 100, 10) < 0.01
                    % If we get here, then we need to adjust Sa b/c it only had one sig fig.
                    currentSaLevel = currentSaLevel + 0.01;

                    %                                     textToDisp=sprintf('currentSaLevel changed to %3.2f',currentSaLevel);
                    %                                     disp(textToDisp);
                end
                fprintf('This is the end of the while loop\n');
                disp(pwd)
                cd ..
            end % End of loop to find first collapse point


            fprintf('This implies first collapse point has been found \n');
            % and hence the last command of cd ..  was not executed b/c program used break to come out of it.
            disp(pwd)
            %                                 cd ..
            %% After finding first collapse point

            % Compute the collapseRangeSize (i.e. the window that we have the collapse point isolated in)
            collapseRangeSize = minSaCollapse - maxSaNoCollapse;

            % Do a quick error check
            if (collapseRangeSize < 0)
                error('Collapse range is negative!!');
                %                                 break;
            end

            %%%%%%%%%%%%%%% End - runs to find first collapse point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%% Start - second phase to isolate the collapse point %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % When we start this loop, we should have the collapse point bounded by at least startStepSize, so for each new step, simply do the
            %   run at the center of the current bounds on the collapse point.

            % Initialize variables
            tolMetFlag = 0;
            ranTooManyEQsAndStoppedAnalysisFlag = 0;

            % Compute the Sa level to use for this run...
            % Just run at one tolerance over the highest non-collapsed Sa level from the first set of analyses above

            % (11-18-15, PSB) to eliminate error due to file name without 2 sig fig after decimal.
            if(mod((maxSaNoCollapse + tolerance) * 100, 10) < 0.01)
                currentSaLevel = maxSaNoCollapse + tolerance + 0.01; % Changed to increase Sa due to convergence issued on 9-19-05
            else
                currentSaLevel = maxSaNoCollapse + tolerance;
            end
            %                         currentSaLevel = maxSaNoCollapse + tolerance;   % Sa level index was incremeted before leaving the above loop and is also incremeted below in this loop

            % Loop an find the collapse point again
            while (1 == 1)

                %                         % If it is singular (also could be from the first loop above), then stop the analysis
                %                             if (isSingular == 1)
                %                                 % Set the flag
                %                                     isStoppedDueToSingular = 1;
                %                                 % Stop the analysis for this EQ
                %                                     break;
                %                             end

                % Break if we have run too many EQ's
                if (saLevelIndex >= maxNumRuns)
                    disp(['saLevelIndex = ' num2str(saLevelIndex) '. We ran the limit of runs for EqNum - ' num2str(eqNumber) ', so stop the analysis!!'])
                    ranTooManyEQsAndStoppedAnalysisFlag = 1;
                    toleranceAchieved = collapseRangeSize / 2;
                    collapseSaLevel = (minSaCollapse + maxSaNoCollapse) / 2;
                    cd ..
                    break;
                end

                % Due to a folder naming error, the Sa level needs to have two decimal places, so adjust it to have two decimal places is needed...
                %   Note that I effectively round to two decimal places when doing this (this is the compilcate "round" stuff)

                %	(11-4-15) commented out the following loop. Not necessary since rounding off to 2 sig figs is already done

                %                                 if((mod(((round(currentSaLevel * 100.0))/100.0), 0.10)) < 0.01)
                %                                    % If we get here, then we need to adjust Sa b/c it only had one sig fig.
                %                                     currentSaLevel = currentSaLevel + 0.01;
                %                                 end

                disp(currentSaLevel)
                %         if(mod(currentSaLevel * 100, 10) <= 1e-4)    % this is theoretically a check for equality with zero, but due to precision error, standard check won't go through hence a small value
                if(mod(round(currentSaLevel * 100), 10) < 0.01)    % this is theoretically a check for equality with zero, but due to precision error, standard check won't go through hence a small value
                    currentSaLevel = currentSaLevel + 0.01; % Changed to increase Sa due to convergence issued on 9-19-05
                end

                %%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%% (PSB, 01-01-17) Trying to make the model with shear hinges work.
                %%%% When the model with shear hinges does not converge after collapse, it falls in an infinite loop of analyzing by perturbing
                %%%% If first collapse point is exceeded in course of trying to find the second collapse point then break
                %%%%% And use the first collapse point and the last non-collapse points to find Sa_col
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %% If it exceeded first collapse poin, set some variables, then break
                % this was the not the real issue with the code, but the non-convergence is.
                % When an analysis does not converge after finding the first collapse point, it keeps on iterating

                %                         % (11-22-15, PSB) this is where we break off from this loop
                %                         if (currentSaLevel > minSaCollapse)
                %                             toleranceAchieved = collapseRangeSize / 2.0;
                %                             collapseSaLevel = (minSaCollapse + maxSaNoCollapse) / 2.0;
                %                             break;
                %                         end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                saLevelForEachRun(1:saLevelIndex)

                fprintf('###########################################################################################\n');
                fprintf('############################# Current Sa Level is %.4fg #################################\n', currentSaLevel);
                fprintf('###########################################################################################\n');

                if min(abs(saLevelForEachRun - currentSaLevel)) < 1e-4
                    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
                    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
                    fprintf('!!!!!!!!!!!!!Repeated Sa Level = %.2fg !!!!!!!!!!!!!!\n', currentSaLevel);
                    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
                    fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');

                    collapseRangeSize = minSaCollapse - maxSaNoCollapse;
                    toleranceAchieved = collapseRangeSize / 2.0;
                    collapseSaLevel = (minSaCollapse + maxSaNoCollapse) / 2.0;
                    break
                end
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

                % Run the EQ
                %%                             Prak_RunSingleEQ_NEWER
                % (11-21-15, PSB) pasting the content of Prak_RunSingleEQ_NEWER. Since it
                % is a scipt file (not a function) and parfor doesn't like it.

                % This file runs a single EQ record

                % Reinitialize the variables that may have been retireieved from the last analysis, with a dummay variable that will show up if there is a problem with
                %   the variables being defined again.
                isCollapsed                     = -1;
                isSingular                      = -1;
                isNonConv                       = -1;
                maxStoryDriftRatioForFullStr    = -1;
                minStoryDriftRatioForFullStr    = -1;

                % Source in the M-file to write the variables to a file for opensees to read
                %%    Prak_WriteVarToFileForOSMATLAB;
                % (11-21-15, PSB) added
                specificSensFolderForSeparateEqs = sprintf('sens_%d',eqNumber);
                %     Prak_mkdir_if_not_exist(specificFolderForSeparateEqs); % matlab throws error if directory already exists, hence the function
                cd(specificSensFolderForSeparateEqs)
                disp(pwd)

                myFileStream = fopen('psb_VarDefinitionsFromMATLAB.tcl', 'w'); % 'w' discards the existing content and starts writing (doesn't append), which is what we want (10-29-15, PSB)

                % Make all of the strings to write to the file
                fprintf(myFileStream, '# This file was created by the MATLAB function (WriteVariablesToFileForOpensees.m), for a single collapse\n');
                fprintf(myFileStream, '#     run, so that Opensees can read the file and define the needed variables\n');
                fprintf(myFileStream, '\n');   % new line

                % (11-15-15, PSB) changing dtForCollapseMATLAB for being able to have variable dt across different EQ records
                % remember current directory to return easliy

                %     indexForTheRunningEQ = find(matrixOfDtForCollapseMATLAB(:,1)==eqNumber);
                %     dtForCollapseMATLAB = matrixOfDtForCollapseMATLAB(indexForTheRunningEQ, 2);
                %     dtForCollapseMATLAB = matrixOfDtForCollapseMATLAB(eqNumberIndex, 2);
                dtForCollapseMATLAB1 = dtForCollapseLIST(eqNumberIndex);


                fprintf(myFileStream, 'set dtForCollapseMATLAB %.4f\n', dtForCollapseMATLAB1);
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
                fprintf(myFileStream, 'set scaleFactorForRunFromMatlab %.4f\n', scaleFactorForRunFromMatlab);
                fprintf(myFileStream, 'set periodUsedForScalingGroundMotionsFromMatlab %.4f\n', periodUsedForScalingGroundMotions);
                fprintf(myFileStream, 'set dampingRatioUsedForSaDefFromMatlab %.4f\n', dampingRatioUsedForSaDef);
                fprintf(myFileStream, 'set saCompScaled %.2f\n', saCompScaled);
                fprintf(myFileStream, 'set saGeoMeanScaled %.2f\n', saGeoMeanScaled);
                fprintf(myFileStream, 'set extraSecondsToRunAnalysis %.2f\n', extraSecondsToRunAnalysis);
                fprintf(myFileStream, 'set eqTimeHistoryPreFormatted %i\n', eqTimeHistoryPreFormatted);

                % Close the file
                fclose(myFileStream);

                % (11-21-15, PSB) added
                %     cd ..
                %     fprintf('prak1 \n');
                % (11-22-15, PSB) removed. Since We want to anyway stay in the sens_eqNumber folder for running opensees
                %     cd ..

                %%
                % Run the EQ
                %!openSees_WithSecondFixFromArash_2005_11_28 RunCollapseSensAnalysisMATLAB.tcl
                %!openSees_FromWeb_2005_10_18 RunCollapseSensAnalysisMATLAB.tcl
                %!openSees-New_From_Frank_10_7_04 RunCollapseSensAnalysisMATLAB.tcl
                %!openSees-Arash-Farzin-1-8-05-Clough RunCollapseSensAnalysisMATLAB.tcl

                %     specificSensFolderForSeparateEqs = sprintf('sens_%d',eqNumber);
                %     cd(specificSensFolderForSeparateEqs) % Now in the earthquake specific folder
                disp(pwd)
                %     disp('prak99 \n');

                %     !OpenSees psb_RunCollapseSensAnalysisMATLAB.tcl
                %     !OpenSees_2.5.0 psb_RunCollapseSensAnalysisMATLAB.tcl

                %     !OpenSees_64-kNmmMPa-PSB-11-01-16 psb_RunCollapseSensAnalysisMATLAB.tcl
                %     !OpenSees_2.5.0_64bit_downloaded_11-13-16 psb_RunCollapseSensAnalysisMATLAB.tcl


                !OpenSees psb_RunCollapseSensAnalysisMATLAB.tcl

                % if strcmp(openseesFileToUse, 'default') % USE OpenSees_2.5.0_64bit_downloaded_11-13-16, when Shear Limit State material is not in use
                %     !OpenSees psb_RunCollapseSensAnalysisMATLAB.tcl
                % elseif strcmp(openseesFileToUse, 'kNmmLimit') % USE OpenSees_64-kNmmMPa-PSB-11-01-16, when Shear LSM is in use in units of kN-mm
                %     !OpenSees_64-kNmmMPa-PSB-11-01-16 psb_RunCollapseSensAnalysisMATLAB.tcl
                % end

                % Retrieve the results
                %% RetrieveCollapseRunResults;

                % (11-21-15, PSB) pasting the content of RetrieveCollapseRunResults. Since it
                % is a scipt file (not a function) and parfor doesn't like it.

                % Created the folder name that the data is in - this was tested and works correctly
                analysisFolderName = sprintf('(%s)_(%s)_(%.2f)_(%s)', sensModel, sensVariableName, sensVariableValue, elementUsedForColSensModelMATLAB)
                %disp(analysisFolderName)

                % Save current folder location to get back to it easily
                sensDirForComingBack = pwd;

                % Go into the output folder for this EQ run

                cd ..;
                cd ..;
                cd ..;
                disp(pwd)
                cd Output;

                cd(analysisFolderName)
                % sprintf('Prakash \n');
                eqFolder = sprintf('EQ_%d', eqNumber)
                cd(eqFolder);

                % (11-23-15, PSB) replaced the adjustment for sig figs part by the simpler code below it.

                % We are now in the EQ folder, but the Sa folder is a bit more tricky, just due to the name having one or two decimal places.  Get into the Sa folder (this just
                %   looks like a lot b/c the code gets large for it to get into a folder with a name with either one or two decimal places.
                %         saFolderOneDecimalPlace = sprintf('Sa_%.1f', currentSaLevel);
                %         saFolderTwoDecimalPlace = sprintf('Sa_%.2f', currentSaLevel);
                %         if(exist(saFolderTwoDecimalPlace,'dir') == 7)
                %             % If we get here, then the directory with one decimal place is correct.
                %             %disp('Using one decimal place for folder names...')
                %             saFolder = sprintf('Sa_%.2f', currentSaLevel)
                %         elseif(exist(saFolderOneDecimalPlace,'dir') == 7)
                %             % If we get here, then the directory with two decimal places is correct.
                %             %disp('Using two decimal places for folder names...')
                %             saFolder = sprintf('Sa_%.1f', currentSaLevel)
                %         else
                %             error('ERROR: The Sa folder could not be found!!')
                %         end

                % (11-23-15, PSB) this (following commented code) will not work, b/c the Sa Value needs to be written in the VarDefinitionsFromMATLAB.tcl file as well.
                % Hence shifted the precision-handling part above to the place where VarDefinitionsFromMATLAB.tcl is written

                %         if(mod(currentSaLevel * 100, 10) <= 1e-4)    % this is theoretically a check for equality with zero, but due to precision error, it wont go through hence a small value
                %             saFolder = sprintf('Sa_%.2f', currentSaLevel + 0.01) % Changed to increase Ss due to convergence issued on 9-19-05
                %         else
                %             saFolder = sprintf('Sa_%.2f', currentSaLevel) % Changed to increase Ss due to convergence issued on 9-19-05
                %         end

                saFolder = sprintf('Sa_%.2f', currentSaLevel) % precision issue handled above while writing the VarDefinitionsFromMATLAB.tcl
                % Now go into the folder
                cd(saFolder)

                % Now get into the RunInformation folder to get the needed output data
                cd RunInformation;


                % Now, load the needed data for this run
                isCollapsed = load('isCollapsedOUT.out');
                isSingular = load('isSingularOUT.out');
                isNonConv = load('isNonConvOUT.out');
                maxStoryDriftRatioForFullStr = load('maxStoryDriftRatioForFullStrOUT.out');
                minStoryDriftRatioForFullStr = load('minStoryDriftRatioForFullStrOUT.out');


                % Checks
                % disp(isCollapsed)
                % disp(isSingular)
                % disp(maxStoryDriftRatioForFullStr)
                % disp(minStoryDriftRatioForFullStr)


                % Go back to starting directory (sens. dir.)
                cd(sensDirForComingBack)


                %%
                % Save the results of the EQ, in the vectors that will later be saved
                saLevelForEachRun(saLevelIndex)     = currentSaLevel;
                scaleFactorForEachRun(saLevelIndex) = scaleFactorForRunFromMatlab;
                isCollapsedForEachRun(saLevelIndex) = isCollapsed;
                isSingularForEachRun(saLevelIndex)  = isSingular;
                isNonConvForEachRun(saLevelIndex)   = isNonConv;
                maxDriftForEachRun(saLevelIndex)    = maxStoryDriftRatioForFullStr;
                minDriftForEachRun(saLevelIndex)    = minStoryDriftRatioForFullStr;

                % Put an error if any of the variables are still at their initialized values of -1
                if (isCollapsed == -1 || isSingular == -1 || isNonConv == -1 || maxStoryDriftRatioForFullStr == -1 || minStoryDriftRatioForFullStr == -1)
                    error('ERROR: The variables are still equal to thier initialized values, even after running the EQ!!!');
                end

                % Update the variable values for the collapse range, if the analysis is not singular and if it was fully converged
                if (isSingular == 0 && isNonConv == 0)
                    % If it's collapsed or not, then alter the appropriate bounds on the collapse window
                    if (isCollapsed == 1)
                        % It collapsed, so alter the upper bound on the collapse region
                        disp('It collapsed!');
                        minSaCollapse = currentSaLevel;
                    else
                        % No collapse, so alter the lower bound on the collapse window.
                        disp('No collapse');
                        maxSaNoCollapse = currentSaLevel;
                    end
                    % Increment the currentSaLevel to go to the next step
                    % (11-18-15, PSB) to eliminate error due to file name without 2 sig fig after decimal.
                    % following 'if...' conditions satisfies the purpose of renaming SaFolder
                    if(mod(round(maxSaNoCollapse + tolerance) * 100, 10) < 0.01)    % this is theoretically a check for equality with zero, but due to precision error, it wont go through hence a small value
                        currentSaLevel = maxSaNoCollapse + tolerance + 0.01; % Changed to increase Ss due to convergence issued on 9-19-05
                    else
                        currentSaLevel = maxSaNoCollapse + tolerance;
                    end

                    %                                     currentSaLevel = maxSaNoCollapse + tolerance;
                else
                    % If we get here, it was singular or non-conv, so reduce the Sa level and run again

                    %%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%% (PSB, 01-01-17) Trying to make the model with shear hinges work.
                    %%%% When the model with shear hinges does not converge after collapse, it falls in an infinite loop of analyzing by perturbing
                    %%%% If first collapse point is exceeded in course of trying to find the second collapse point then break
                    %%%%% And use the first collapse point and the last non-collapse points to find Sa_col
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    currentSaLevel = maxSaNoCollapse + perturbationForNonConvSingular;
                    %                                     if min(abs(saLevelForEachRun - currentSaLevel)) < 1e-4
                    %                                         saLevelForEachRun
                    %                                         fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
                    %                                         fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
                    %                                         fprintf('!!!!!!!!!!!!!Repeated Sa Level = %.2fg !!!!!!!!!!!!!!\n', currentSaLevel);
                    %                                         fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
                    %                                         fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n');
                    %
                    %                             collapseRangeSize = minSaCollapse - maxSaNoCollapse;
                    %                             toleranceAchieved = collapseRangeSize / 2.0;
                    %                             collapseSaLevel = (minSaCollapse + maxSaNoCollapse) / 2.0;
                    %                             cd ..
                    %                                         break
                    %                                     end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                end

                % Update the collapseRangeSize (i.e. the window that we have the collapse point isolated in)
                collapseRangeSize = minSaCollapse - maxSaNoCollapse;

                %% If it collapsed, set some variables, then break
                % (11-22-15, PSB) this is where we break off from this loop
                if (isCollapsed == 1)
                    toleranceAchieved = collapseRangeSize / 2.0;
                    collapseSaLevel = (minSaCollapse + maxSaNoCollapse) / 2.0;
                    cd .. % (11-22-15, PSB) to come back to the Prak_Sensitivity_Analysis folder for the next run
                    % b/c break will stop the next cd .. command from executing
                    break;
                end

                % Increment the Sa level index
                saLevelIndex = saLevelIndex + 1;
                cd .. % (11-22-15, PSB) to come back to the psb_Sensitivity_Analysis folder for the next run

            end    % End of second Sa while loop

            %%%%%%%%%%%%%%% End - seconds loop is done %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % Save results
            % SaveResultsForThisEQ
            psb_SaveResultsForThisEQ(analysisFolderName, collapseRangeSize, collapseSaLevel, currentOutputFolder, ...
                currentOutputFolderLIST, currentSaLevel, dampingRatioUsedForSaDef, dtForCollapseMATLAB, elementUsedForColSensModelMATLAB, ...
                eqFolder, eqFormatForCollapseList, eqNumber, eqNumberForGeoMean, eqNumberIndex, eqNumberLIST, flagForEQFileFormat, ...
                isCollapsed, isCollapsedForEachRun, isNonConv, isNonConvForEachRun, isRunTimeError, isSingular, isSingularForEachRun, ...
                isStoppedDueToSingular, maxDriftForEachRun, maxNumRuns, maxSaNoCollapse, maxStoryDriftRatioForFullStr, minDriftForEachRun, ...
                minSaCollapse, minStoryDriftRatioForCollapseMATLAB, minStoryDriftRatioForFullStr, modelIndex, modelNameLIST, myFileStream, ...
                periodUsedForScalingGroundMotions, perturbationForNonConvSingular, ranTooManyEQsAndStoppedAnalysisFlag, saCompScaled, saFolder, ...
                saGeoMeanScaled, saLevelForEachRun, saLevelIndex, saStartLevel, scaleFactorForEachRun, scaleFactorForRunFromMatlab, sensDir, ...
                sensModel, sensModelIndex, sensModelLIST, sensVariableIndex, sensVariableName, sensVariableNameLIST, sensVariableValue, ...
                sensVariableValueLIST, startStepSize, tolerance, toleranceAchieved, tolMetFlag);

            % (11-15-15, PSB) save a small file to restart the analysis from where it was interrupted. Restarts from the EQ
            % level and not the Sa level.
            %                 t1(eqNumberIndex,:) = clock;
            %                    timeTakenInMinsForThisAnalysis(eqNumberIndex) = etime(t1(eqNumberIndex,:), t0(eqNumberIndex,:))/60;
            %
            %                    timeTakenInMinsForEachAnalysis(numberOfAnalysesRun + eqNumberIndex) = timeTakenInMinsForThisAnalysis(eqNumberIndex);
            % %                    timeTakenInMinsForEachAnalysis(eqNumberIndex) = timeTakenInMinsForThisAnalysis(eqNumberIndex);
            %
            %                    textToDisplay = sprintf('time taken for the current EQ no. %d is %0.4g\n', eqNumber, timeTakenInMinsForThisAnalysis(eqNumberIndex));
            %                    disp(textToDisplay);
            % (11-15-15, PSB) save a small file to restart the analysis from where it was interrupted.
            %                     Prak_SaveTempFileForRecoveryAndTimeTakenForEachAnalysis(timeTakenInMinsForEachAnalysis, sensModel, sensVariableName, sensVariableValue, elementUsedForColSensModelMATLAB)

            %             parfor_progress; % Increment the progress counter
        end
        %         parfor_progress(0); % Reset the progress counter
    end    % End of the sensitivity variable loop
end    % End of model loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%























