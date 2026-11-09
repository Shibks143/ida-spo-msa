% -------------------
% Procedure: sks_RunCollapseAnaMATLAB_CLOUD.m
% Cloud analysis: runs each ground-motion record ONCE, unscaled (scale factor = 1),
% at its own Sa(T1). Based on sks_RunCollapseAnaMATLAB_MSA.m, with the stripe loop
% replaced by a single run per record.
%
% Output (same folder layout as MSA):
%   Output/<analysisType>/EQ_<eqNumber>/Sa_<own Sa, 2 decimals>/...   (OpenSees results)
%   Output/<analysisType>/EQ_<eqNumber>/DATA_CloudRunForThisEQ.mat     (summary for this record)
%
% Author: Shivakumar K S, IIT Madras (based on the IDA/MSA runners of C. Haselton and P. S. Badal)
% Date:   09-Nov-2026
% Units:  Whatever OpenSees is using - kN, mm, radians
% -------------------
function sks_RunCollapseAnaMATLAB_CLOUD(cloudInputs)

eqDataFolder                        = strrep(cloudInputs.eqDataFolder, '\', '/');
eqSpectraFolder                     = cloudInputs.eqSpectraFolder;
sensModelLIST                       = cloudInputs.sensModelLIST;
dtForCollapseMATLAB                 = cloudInputs.dtForCollapseMATLAB;
minStoryDriftRatioForCollapseMATLAB = cloudInputs.minStoryDriftRatioForCollapseMATLAB;
elementUsedForColSensModelMATLAB    = cloudInputs.elementUsedForColSensModelMATLAB;
eqFormatForCollapseList             = cloudInputs.eqFormatForCollapseList;
sensVariableNameLIST                = cloudInputs.sensVariableNameLIST;
sensVariableValueLIST               = cloudInputs.sensVariableValueLIST;
eqNumberLIST                        = cloudInputs.eqNumberLIST_forCloud;
flagForEQFileFormat                 = cloudInputs.flagForEQFileFormat;
periodUsedForScalingGroundMotions   = cloudInputs.periodUsedForScalingGroundMotions;
dampingRatioUsedForSaDef            = cloudInputs.dampingRatioUsedForSaDef;
extraSecondsToRunAnalysis           = cloudInputs.extraSecondsToRunAnalysis;
eqTimeHistoryPreFormatted           = cloudInputs.eqTimeHistoryPreFormatted;
imType                              = cloudInputs.imType;

if strcmp(imType, 'geoMean') && flagForEQFileFormat ~= 2
    error('sksCode:cloudIM', 'CLOUD with imType = ''geoMean'' needs flagForEQFileFormat = 2 (both components defined).');
end

numberOfRecords = numel(eqNumberLIST);
fprintf('CLOUD: %d record component(s), unscaled, IM = Sa_%s(T1 = %.2f s)\n', numberOfRecords, imType, periodUsedForScalingGroundMotions);

for sensModelIndex = 1:length(sensModelLIST)
    sensModel = sensModelLIST{sensModelIndex};

    for sensVariableIndex = 1:length(sensVariableNameLIST)
        sensVariableName   = sensVariableNameLIST{sensVariableIndex};
        sensVariableValue  = sensVariableValueLIST(sensVariableIndex);
        analysisFolderName = sprintf('(%s)_(%s)_(%.2f)_(%s)', sensModel, sensVariableName, sensVariableValue, elementUsedForColSensModelMATLAB);

        % --- Time step for each record (same rule as IDA/MSA) + length check of the time history ---
        dtForCollapseLIST = zeros(numberOfRecords, 1);
        for indexForEQ = 1:numberOfRecords
            eqNumber = eqNumberLIST(indexForEQ);
            numPointsFromLengthOfTH = size(load(fullfile(eqDataFolder, sprintf('SortedEQFile_(%d).txt', eqNumber))), 1);
            numPointsFromFile       = load(fullfile(eqDataFolder, sprintf('NumPointsFile_(%d).txt', eqNumber)));
            if numPointsFromLengthOfTH ~= numPointsFromFile
                error('sksCode:chkForLengthOfGM', 'Length of SortedEQFile is not same as value in NumPointsFile of EQ ID = %d', eqNumber);
            end
            dtOfTimeHistory = load(fullfile(eqDataFolder, sprintf('DtFile_(%d).txt', eqNumber)));
            if dtForCollapseMATLAB >= 1
                dtForCollapseLIST(indexForEQ) = dtOfTimeHistory / dtForCollapseMATLAB;
            else
                dtForCollapseLIST(indexForEQ) = dtForCollapseMATLAB;
            end
        end

        % --- Separate working folders per record (parfor workers cannot share one folder) ---
        sensDir  = pwd;                                   % Models/psb_Sensitivity_Analysis (driver cd's here)
        modelDir = fullfile(sensDir, '..', sensModel);
        for indexForEQ = 1:numberOfRecords
            specificSensFolderForSeparateEqs = fullfile(sensDir, sprintf('sens_%d', eqNumberLIST(indexForEQ)));
            psb_mkdir_if_not_exist(specificSensFolderForSeparateEqs);
            copyfile(fullfile(sensDir, 'psb_RunCollapseSensAnalysisMATLAB.tcl'), specificSensFolderForSeparateEqs);

            specificModelFolderForSeparateEqs = fullfile(modelDir, sprintf('model_%d', eqNumberLIST(indexForEQ)));
            psb_mkdir_if_not_exist(specificModelFolderForSeparateEqs);
            copyfile(fullfile(modelDir, '*.tcl'), specificModelFolderForSeparateEqs);
        end
        analysisFolderPath = fullfile(sensDir, '..', '..', 'Output', analysisFolderName);

        % --- One unscaled run per record ---
        parfor eqNumberIndex = 1:numberOfRecords
            eqNumber           = eqNumberLIST(eqNumberIndex);
            eqNumberForGeoMean = floor(eqNumber / 10.0);

            % Own Sa(T1) of this unscaled record
            saCompOwn = psb_RetrieveSaCompValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, eqSpectraFolder);
            if flagForEQFileFormat == 2
                saGeoMeanOwn = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumberForGeoMean, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, eqSpectraFolder);
            else
                saGeoMeanOwn = -1;                        % only one component defined
            end
            if strcmp(imType, 'geoMean')
                saOwn = saGeoMeanOwn;
            else
                saOwn = saCompOwn;
            end
            scaleFactorForRunFromMatlab = 1.0;            % CLOUD: the record is NOT scaled
            currentSaLevel              = saOwn;          % used for the Sa_x.xx folder name and logging only

            fprintf('##### CLOUD: EQ %d, own Sa_%s(T1) = %.4f g, scale factor = 1 #####\n', eqNumber, imType, saOwn);

            % Write the variables for OpenSees (same content as MSA, analysisMode = CLOUD)
            specificSensFolderForSeparateEqs = fullfile(sensDir, sprintf('sens_%d', eqNumber));
            myFileStream = fopen(fullfile(specificSensFolderForSeparateEqs, 'psb_VarDefinitionsFromMATLAB.tcl'), 'w');
            fprintf(myFileStream, '# This file was created by sks_RunCollapseAnaMATLAB_CLOUD.m for a single (unscaled) cloud run\n\n');
            fprintf(myFileStream, 'set dtForCollapseMATLAB %.6f\n', dtForCollapseLIST(eqNumberIndex));
            fprintf(myFileStream, 'set minStoryDriftRatioForCollapseMATLAB {%s}\n', sprintf('%.3f ', minStoryDriftRatioForCollapseMATLAB));
            fprintf(myFileStream, 'set elementUsedForColSensModelMATLAB %s\n', elementUsedForColSensModelMATLAB);
            fprintf(myFileStream, 'set sensModel %s\n', sensModel);
            fprintf(myFileStream, 'set sensVariableName %s\n', sensVariableName);
            fprintf(myFileStream, 'set sensVariableValue %.2f\n', sensVariableValue);
            fprintf(myFileStream, 'set %s %.2f\n', sensVariableName, sensVariableValue);
            fprintf(myFileStream, 'set eqNumber %d\n', eqNumber);
            fprintf(myFileStream, 'set eqFormatForCollapseList %s\n', eqFormatForCollapseList);
            fprintf(myFileStream, 'global eqDataFolder\n');
            fprintf(myFileStream, 'set eqDataFolder %s\n', eqDataFolder);
            fprintf(myFileStream, 'set currentSaLevel %.2f\n', currentSaLevel);
            fprintf(myFileStream, 'puts "currentSaLevel is $currentSaLevel"\n');
            fprintf(myFileStream, 'set scaleFactorForRunFromMatlab %6f\n', scaleFactorForRunFromMatlab);
            fprintf(myFileStream, 'set periodUsedForScalingGroundMotionsFromMatlab %.4f\n', periodUsedForScalingGroundMotions);
            fprintf(myFileStream, 'set dampingRatioUsedForSaDefFromMatlab %.4f\n', dampingRatioUsedForSaDef);
            fprintf(myFileStream, 'set saCompScaled %.2f\n', saCompOwn);
            fprintf(myFileStream, 'set saGeoMeanScaled %.2f\n', saGeoMeanOwn);
            fprintf(myFileStream, 'set extraSecondsToRunAnalysis %.2f\n', extraSecondsToRunAnalysis);
            fprintf(myFileStream, 'set eqTimeHistoryPreFormatted %i\n', eqTimeHistoryPreFormatted);
            fprintf(myFileStream, 'set analysisMode CLOUD\n');
            fclose(myFileStream);

            % Run OpenSees in this record's own folder
            cd(specificSensFolderForSeparateEqs);
            [status, cmdout] = system('OpenSees psb_RunCollapseSensAnalysisMATLAB.tcl');
            cd(sensDir);
            if status ~= 0
                fprintf('OpenSees execution failed for EQ %d (own Sa = %.2f):\n%s\n', eqNumber, saOwn, cmdout);
            end

            % Collect the run flags and drifts for this record
            eqFolder   = fullfile(analysisFolderPath, sprintf('EQ_%d', eqNumber));
            saFolder   = sprintf('Sa_%.2f', currentSaLevel);
            runInfoDir = fullfile(eqFolder, saFolder, 'RunInformation');

            cloudRun = struct('eqNumber', eqNumber, 'eqNumberForGeoMean', eqNumberForGeoMean, 'imType', imType, ...
                'saOwn', saOwn, 'saCompOwn', saCompOwn, 'saGeoMeanOwn', saGeoMeanOwn, ...
                'scaleFactor', scaleFactorForRunFromMatlab, 'saFolder', saFolder, 'openSeesStatus', status, ...
                'isRunError', 0, 'isCollapsed', NaN, 'isSingular', NaN, 'isNonConv', NaN, ...
                'maxStoryDriftRatioForFullStr', NaN, 'minStoryDriftRatioForFullStr', NaN);
            try
                cloudRun.isCollapsed                  = load(fullfile(runInfoDir, 'isCollapsedOUT.out'));
                cloudRun.isSingular                   = load(fullfile(runInfoDir, 'isSingularOUT.out'));
                cloudRun.isNonConv                    = load(fullfile(runInfoDir, 'isNonConvOUT.out'));
                cloudRun.maxStoryDriftRatioForFullStr = load(fullfile(runInfoDir, 'maxStoryDriftRatioForFullStrOUT.out'));
                cloudRun.minStoryDriftRatioForFullStr = load(fullfile(runInfoDir, 'minStoryDriftRatioForFullStrOUT.out'));
            catch readError
                cloudRun.isRunError = 1;
                fprintf('CLOUD: could not read results for EQ %d in %s (%s)\n', eqNumber, runInfoDir, readError.message);
            end
            sks_saveCloudRun(fullfile(eqFolder, 'DATA_CloudRunForThisEQ.mat'), cloudRun);
        end
    end
end

disp('CLOUD analyses - DONE')
end

% ---- helper: save inside parfor (save() cannot be called directly in a parfor body) ----
function sks_saveCloudRun(fileName, cloudRun)
    save(fileName, 'cloudRun');
end
