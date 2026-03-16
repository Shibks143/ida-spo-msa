%
% Procedure: ProcessMultipleCollapseRuns.m
% -------------------
% This procedure simply calls "ProcessSingleRun.m" multiple times to process a lot of data.
% 
% Assumptions and Notices: 
%
% Author: Curt Haselton 
% Date Written: 5-11-04
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = ProcessMultipleCollapseRuns(analysisTypeLIST, eqNumberLIST, processPushover)


% Note that the Sa levels to use come from the file in the Collapse folder

% Input the tolerance that is used in the collapse algorithm, i.e. the step size that it used after it finds the first collapse point (usually 0.05).  
%   This is used for making the vector for plotting, so that we plot all of the non-collapsed points and only the first collapased point.





    for analysisTypeNum = 1:length(analysisTypeLIST)
        
        for eqNumNum = 1:length(eqNumberLIST)
                
                analysisType = analysisTypeLIST{analysisTypeNum};
                modelName = modelNameLIST{analysisTypeNum};
                eqNumber = eqNumberLIST(eqNumNum);

                % Get the Sa levels that were run for the collapse analysis
                    % First change the directory to get into the correct folder for processing
                    cd ..;
                    cd Output;
                    % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
                    analysisTypeFolder = sprintf('%s', analysisType)
                    cd(analysisTypeFolder);

                    % EQ folder name
                    eqFolder = sprintf('EQ_%.0f', eqNumber);
                    cd(eqFolder);
                    
                    % Get the variable information that I need from the
                    % collapse .mat file that Matlab made when doing the
                    % collapse analysis.
                    load('DATA_CollapseResultsForThisSingleEQ.mat', 'collapseSaLevel', 'saLevelForEachRun', 'tolerance', 'isSingularForEachRun', 'isNonConvForEachRun', 'isCollapsedForEachRun')
                    collapseLevelFromFileOpened = collapseSaLevel;
                    clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
    
                    saLevelsRunForCollapseAnalysis = saLevelForEachRun; % Rename
                    toleranceUsedInCollapseAlgo = tolerance;    % Rename
                        
                    % Get back to initial folder
                    cd ..;
                    cd ..;
                    cd ..;
                    cd MatlabProcessors;

                    
                % Do processing for this EQ, for all the Sa levels that were run for the collapse analysis (actually only those that are below the collapse point)
                    
                    for saLevelNum = 1:length(saLevelsRunForCollapseAnalysis)
                        saTOneForRun = saLevelsRunForCollapseAnalysis(saLevelNum);

                        % As long as 0.05 < Sa < 45.0, delete the processed file for this EQ
                        if((saTOneForRun > 0.05) && (saTOneForRun < 45.0))
                            ProcessSingleCollapseRuns_deleteProcessedFiles
                        end
                    end
                   
                        
        end 

    end
    
    