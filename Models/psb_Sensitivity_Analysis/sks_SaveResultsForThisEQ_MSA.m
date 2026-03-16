function  sks_SaveResultsForThisEQ_MSA(analysisFolderName, currentOutputFolder, currentOutputFolderLIST, currentSaLevel, dampingRatioUsedForSaDef, dtForCollapseMATLAB, ...
                    elementUsedForColSensModelMATLAB, eqFolder, eqFormatForCollapseList, eqNumber, eqNumberForGeoMean, eqNumberIndex, eqNumberLIST, flagForEQFileFormat, ...
                    isCollapsed, isCollapsedForEachRun, isNonConv, isNonConvForEachRun, isRunTimeError, isSingular, isSingularForEachRun, isStoppedDueToSingular, ...
                    maxDriftForEachRun, numSaLevels, maxStoryDriftRatioForFullStr, minDriftForEachRun, minStoryDriftRatioForCollapseMATLAB, minStoryDriftRatioForFullStr, ...
                    maxResidualDriftForEachRun, maxStoryResidualDriftRatioForFullStr, minResidualDriftForEachRun, minStoryResidualDriftRatioForFullStr, ...
                    absResidualDriftForEachRun, absStoryResidualDriftRatioForFullStr, modelIndex, modelNameLIST, myFileStream, periodUsedForScalingGroundMotions, ...
                    saCompScaled, saFolder, saGeoMeanScaled, saLevelForEachRun, saLevelIndex, scaleFactorForEachRun, scaleFactorForRunFromMatlab, sensDir, ...
                    sensModel, sensModelIndex, sensModelLIST, sensVariableIndex, sensVariableName, ...
                    sensVariableNameLIST, sensVariableValue, sensVariableValueLIST,...     
                    maxStoryDriftRatioAtEachStoryAtEachRun, ...
                    minStoryDriftRatioAtEachStoryAtEachRun, ...
                    absStoryDriftRatioAtEachStoryAtEachRun, ...
                    maxStoryResidualDriftRatioAtEachStoryAtEachRun, ...
                    minStoryResidualDriftRatioAtEachStoryAtEachRun, ...
                    absStoryResidualDriftRatioAtEachStoryAtEachRun, ...
                    maxPeakFloorAccelerationAtEachFloorAtEachRun, ...
                    minPeakFloorAccelerationAtEachFloorAtEachRun, ...
                    absPeakFloorAccelerationAtEachFloorAtEachRun) 

% Get to the folder for the EQ run...                   

% Created the folder name that the data is in - this was tested and works correctly
analysisFolderName = sprintf('(%s)_(%s)_(%.2f)_(%s)', sensModel, sensVariableName, sensVariableValue, elementUsedForColSensModelMATLAB);
%disp(analysisFolderName)

sensDir = pwd;
while true
    
    [parent,currentFolder] = fileparts(pwd);
    
    if strcmpi(currentFolder,'Models')
        break
    end
    
    cd ..
    
end

cd ..           % go to project root
cd Output
cd(analysisFolderName)

eqFolder = sprintf('EQ_%d',eqNumber);
cd(eqFolder)

% % Save current folder location to get back to it easily
% sensDir = pwd;
% disp(sensDir)
% 
% % Go into the output folder for this EQ run
% cd ..;
% cd ..;
% %         cd ..;
% 
% 
% %         cd Output;
% 
% try
%     cd Output;
% catch
%     try
%         cd ..\Output;
%     catch
%         cd ..\..\Output;
%     end
% end
% 
% cd(analysisFolderName)
% eqFolder = sprintf('EQ_%d', eqNumber);
% cd(eqFolder);
% %         disp('datasaved???');

    
% Save the results
    fileName = 'DATA_CollapseResultsForThisSingleEQ.mat';

% % Save all of the data  
    save(fileName, 'analysisFolderName',  'currentOutputFolder',  'currentOutputFolderLIST', 'currentSaLevel',  'dampingRatioUsedForSaDef',  'dtForCollapseMATLAB',  ...
        'elementUsedForColSensModelMATLAB',  'eqFolder', 'eqFormatForCollapseList',  'eqNumber',  'eqNumberForGeoMean',  'eqNumberIndex',  'eqNumberLIST',  'fileName',  ...
        'flagForEQFileFormat', 'isCollapsed',  'isCollapsedForEachRun',  'isNonConv',  'isNonConvForEachRun',  'isRunTimeError',  'isSingular',  'isSingularForEachRun', ...
        'isStoppedDueToSingular',  'maxDriftForEachRun',  'numSaLevels',  'maxStoryDriftRatioForFullStr',  'minDriftForEachRun', 'minStoryDriftRatioForCollapseMATLAB',  ...
        'minStoryDriftRatioForFullStr', 'maxResidualDriftForEachRun', 'maxStoryResidualDriftRatioForFullStr', 'minResidualDriftForEachRun','minStoryResidualDriftRatioForFullStr', ...
        'absResidualDriftForEachRun', 'absStoryResidualDriftRatioForFullStr', 'modelIndex',  'modelNameLIST',  'myFileStream', 'periodUsedForScalingGroundMotions', 'saCompScaled',  ...
        'saFolder','saGeoMeanScaled',  'saLevelForEachRun',  'saLevelIndex', 'scaleFactorForEachRun', 'scaleFactorForRunFromMatlab',  'sensDir', 'sensModel',  'sensModelIndex',  ...
        'sensModelLIST',  'sensVariableIndex',  'sensVariableName', 'sensVariableNameLIST', 'sensVariableValue', 'sensVariableValueLIST',...
        'maxStoryDriftRatioAtEachStoryAtEachRun', ...
        'minStoryDriftRatioAtEachStoryAtEachRun', ...
        'absStoryDriftRatioAtEachStoryAtEachRun', ...
        'maxStoryResidualDriftRatioAtEachStoryAtEachRun', ...
        'minStoryResidualDriftRatioAtEachStoryAtEachRun', ...
        'absStoryResidualDriftRatioAtEachStoryAtEachRun', ...
        'maxPeakFloorAccelerationAtEachFloorAtEachRun', ...
        'minPeakFloorAccelerationAtEachFloorAtEachRun', ...
        'absPeakFloorAccelerationAtEachFloorAtEachRun');


% Get back into the sensitivity analysis folder  
    cd(sensDir)    

    % % ---------------------------------------------------
    % % Save summary file for all EQs (outside EQ folders)  added on
    % % 15-mar-2026 by shivakuamr KS 
    % % ---------------------------------------------------
    % 
    % cd('..')   % go back to analysis folder (outside EQ_xxx)
    % 
    % summaryFolder = fullfile(sensDir, '..', '..', 'Output', analysisFolderName);
    % 
    % % Create the folder if it does not exist
    % if ~isfolder(summaryFolder)
    %     mkdir(summaryFolder);
    % end
    % 
    % % Full path to summary file
    % summaryFileName = fullfile(summaryFolder, 'DATA_CollapseResultsForAllEQ.mat');
    % 
    % if exist(summaryFileName,'file')
    % 
    %     % Load existing summary file
    %     summaryMsaResponse = load(summaryFileName);
    % 
    %     absStoryDrift_all    = summaryMsaResponse.absStoryDrift_all;
    %     absResidualDrift_all = summaryMsaResponse.absResidualDrift_all;
    %     absPFA_all           = summaryMsaResponse.absPFA_all;
    %     numSaLevels_all      = summaryMsaResponse.numSaLevels_all;
    % 
    % else
    % 
    %     % Initialize containers
    %     numEQ = length(eqNumberLIST);
    %     absStoryDrift_all    = cell(numEQ,1);
    %     absResidualDrift_all = cell(numEQ,1);
    %     absPFA_all           = cell(numEQ,1);
    %     numSaLevels_all      = zeros(numEQ,1);
    % 
    % end
    % 
    % % Store results for current EQ
    % absStoryDrift_all{eqNumberIndex}    = absStoryDriftRatioAtEachStoryAtEachRun;
    % absResidualDrift_all{eqNumberIndex} = absStoryResidualDriftRatioAtEachStoryAtEachRun;
    % absPFA_all{eqNumberIndex}           = absPeakFloorAccelerationAtEachFloorAtEachRun;
    % numSaLevels_all(eqNumberIndex)      = numSaLevels;
    % 
    % % Save summary file
    % save(summaryFileName, 'eqNumberLIST','numSaLevels_all','absStoryDrift_all', 'absResidualDrift_all','absPFA_all');
