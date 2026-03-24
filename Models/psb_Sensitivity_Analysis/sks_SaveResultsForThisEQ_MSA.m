function  sks_SaveResultsForThisEQ_MSA(analysisFolderName, currentOutputFolder, currentOutputFolderLIST, currentSaLevel, ...
                    dampingRatioUsedForSaDef, dtForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFolder, eqFormatForCollapseList, ...
                    eqNumber, eqNumberForGeoMean, eqNumberIndex, eqNumberLIST, flagForEQFileFormat, isCollapsed, isCollapsedForEachRun, ...
                    isNonConv, isNonConvForEachRun, isRunTimeError, isSingular, isSingularForEachRun, isStoppedDueToSingular, ...
                    maxDriftForEachRun, numSaLevels, maxStoryDriftRatioForFullStr, minDriftForEachRun, minStoryDriftRatioForCollapseMATLAB, ...
                    minStoryDriftRatioForFullStr,  modelIndex, modelNameLIST, ...
                    myFileStream, periodUsedForScalingGroundMotions, saCompScaled, saFolder, saGeoMeanScaled, saLevelForEachRun, saLevelIndex, ...
                    scaleFactorForEachRun, scaleFactorForRunFromMatlab, sensDir, sensModel, sensModelIndex, sensModelLIST, sensVariableIndex, ...
                    sensVariableName, sensVariableNameLIST, sensVariableValue, sensVariableValueLIST) 

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
        'minStoryDriftRatioForFullStr', ...
         'modelIndex',  'modelNameLIST',  'myFileStream', 'periodUsedForScalingGroundMotions', 'saCompScaled',  ...
        'saFolder','saGeoMeanScaled',  'saLevelForEachRun',  'saLevelIndex', 'scaleFactorForEachRun', 'scaleFactorForRunFromMatlab',  'sensDir', 'sensModel',  'sensModelIndex',  ...
        'sensModelLIST',  'sensVariableIndex',  'sensVariableName', 'sensVariableNameLIST', 'sensVariableValue', 'sensVariableValueLIST');


% Get back into the sensitivity analysis folder  
    cd(sensDir)    

   