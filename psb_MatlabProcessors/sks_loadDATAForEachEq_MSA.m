% function [saLevelForEachRun, isSingularForEachRun, isNonConvForEachRun, isCollapsedForEachRun] = sks_loadDATAForEachEq()
% tempDir = pwd;
%                     cd ..;
%                     cd Output;
%                     % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
%                     analysisTypeLIST = {'(Arch_4story_ID1010_v.13_Alt_modForSF)_(AllVar)_(0.00)_(clough)'};
%                     analysisType = analysisTypeLIST{1};      
%                     
%                     analysisTypeFolder = sprintf('%s', analysisType);
%                     cd(analysisTypeFolder);
% 
%                     eqNumber = 120112;
% 
% 
%                     % EQ folder name
%                     eqFolder = sprintf('EQ_%.0f', eqNumber);
%                     cd(eqFolder);
%  fileNameToLoad = 'DATA_CollapseResultsForThisSingleEQ.mat';
                    % [saLevelForEachRun, isSingularForEachRun, isNonConvForEachRun, isCollapsedForEachRun] = Prak_loadDATAForEachEq(fileNameToLoad);    
% 
%     cd(tempDir);

% function [saLevelForEachRun, tolerance, isSingularForEachRun, isNonConvForEachRun, isCollapsedForEachRun] = sks_loadDATAForEachEq_MSA(fileNameToLoad)

function [saLevelForEachRun, maxDriftForEachRun, isCollapsedForEachRun, isSingularForEachRun, isNonConvForEachRun, ...
    numSaLevels, periodUsedForScalingGroundMotions, minStoryDriftRatioForCollapseMATLAB] = sks_loadDATAForEachEq_MSA(fileNameToLoad)

try 
    load(fileNameToLoad, 'saLevelForEachRun', 'maxDriftForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', ...
        'numSaLevels', 'periodUsedForScalingGroundMotions', 'minStoryDriftRatioForCollapseMATLAB')
catch 
    error('File name- %s not found here- %s!', fileNameToLoad, pwd);
end
 