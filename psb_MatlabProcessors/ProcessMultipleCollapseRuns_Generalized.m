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
function[void] = ProcessMultipleCollapseRuns_Generalized(analysisTypeLIST, modelNameLIST, eqNumberLIST, collapseDriftThreshold, dataSavingOption)


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
                
                    % Clear variable that still may be defined from the last processing
                    clear saLevelsForIDAPlotLIST maxDriftRatioForPlotLIST
                
                    % For this EQ, start the plot vectors with a (0, 0) in the first entry
                    listIndex = 1;
                    saLevelsForIDAPlotLIST(1, listIndex) = 0;
                    scaleFactorsForIDAPlotLIST(1, listIndex) = 0;
                    maxDriftRatioForPlotLIST(1, listIndex) = 0;
                    listIndex = 2;
                    maxSaLevelEverAddedToLIST = 0;
                    firstSaAboveCollapsePoint = 100.0;
                    maxDriftRatioForFirstSaAboveCollapsePoint = 100.0;
                    foundPointAboveCollapse = 0;
                    isNonConvAboveCollapse = -1;
                    isSingularAboveCollapse = -1;
                    isCollapsedAboveCollapse = -1;
                    
                    for saLevelNum = 1:length(saLevelsRunForCollapseAnalysis)
                        saTOneForRun = saLevelsRunForCollapseAnalysis(saLevelNum);
                
                        % If it's under the collapse point, within the tolerance that we allow, then process...This should save all of the non-collapsed points and only 
                        %   one collapsed point.  Note that the stop for Sa
                        %   = 0.0 is for when there are no more points to
                        %   get.
                        % Only do processing if it's not singular and fully converged (but if it's collapsed, allow it to be singular or non-converged)
                        if((saTOneForRun < (collapseLevelFromFileOpened + 0.6 * toleranceUsedInCollapseAlgo)) & (saTOneForRun ~= 0.0))
                            
                            % IF it's noncollapsed and singular or non-conv, then break from this loop and don't process this record
                            if((isCollapsedForEachRun(saLevelNum) == 0) & ((isSingularForEachRun(saLevelNum) == 1) | (isNonConvForEachRun(saLevelNum) == 1)))
                                % Don't do anything
                            else
                                % Process the run
                            
                                % Call the processing file to do the processing and to find the maxDriftLevel for each Sa level that was run...
                                    %ProcessSingleRunPinchDmgCol
                                    % Updated on 12-8-05 when cleaning-up
                                    % processors
                                    %[scaleFactorForRun, maxDriftRatioForFullStr, isNonConv, isSingular, isCollapsed] = ProcSingleRun_Collapse_Generalized(analysisType, modelName, saTOneForRun, eqNumber);     % I am using this so it saves the data for each run (good b/c it only takes 3kB per run to save the information) (for sending results to Buffalo)
                                    [scaleFactorForRun, maxDriftRatioForFullStr, isNonConv, isSingular, isCollapsed] = ProcSingleRun_Collapse_GeneralizedForFramesAndWalls(analysisType, modelName, saTOneForRun, eqNumber, dataSavingOption)
                                    %ProcSingleRun_Collapse_Generalized_Full;
                                    %ProcSingleRun_Collapse_Simple;          % This is a reduced processor that just computes what it needs and does not save a file for each Sa value
                                    %ProcSingleRunNlBmColFullPO_newGeneral_withSectionMCurv

                                    
                                % Look for the first point that is above the collapse point.  This point will be overwritten below, so we need to save it now
                                %   for the case that it is needed for the top point of the collapse IDA.  This portion of code ONLY saves the first point above
                                %   the collapse point (the one that was found in the first loop of the simple step collapse algorithm).
                                    % If this is the point above the collapse point, then save it
                                    if(saTOneForRun > collapseLevelFromFileOpened)
                                        % If this saLevel is lower than any collapsed Sa saved before, then save it
                                        if(saTOneForRun < firstSaAboveCollapsePoint)
                                            % Save point above collapsed
                                            firstSaAboveCollapsePoint = saTOneForRun;
                                            maxDriftRatioForFirstSaAboveCollapsePoint = maxDriftRatioForFullStr;
                                            isNonConvAboveCollapse = isNonConv;
                                            isSingularAboveCollapse = isSingular;
                                            isCollapsedAboveCollapse = isCollapsed;
                                        end
                                    else
                                        % Save information for non-collapsed run
                                        
    
                                        % Sometimes in the IDA, the collapse point gets run twice (i.e. when we step at 0.5g then hit the collapse point, then step at 0.05g and get
                                        %   the same collapse point).  When this happens, the IDA plot looks bad.  To fix this, we want to only plot increasing Sa values (i.e. not plot
                                        %   any collapse point found when doing the larger Sa step size, of something like 0.5g).  To do this, if this Sa level that we are at now is less
                                        %   than a previous level that we have already saved, then just write over the previous one that we have saved.
                            
                                        % NOTICE: This can have problems with not finding the right folder then rounding down to the tenths place.  I changed the order of checking
                                        %   for folders (looks fo two decimal places first), and I think that this should take care of the problem.
                                            % Check for maximum
                                            if(saTOneForRun > maxSaLevelEverAddedToLIST)
                                                % Update the maximum
                                                %disp('Max Sa updated')
                                                maxSaLevelEverAddedToLIST = saTOneForRun;
                                            end
                                            % Write over last value in lists if we are at a Sa level below the historic maximum Sa level
                                            if(saTOneForRun < maxSaLevelEverAddedToLIST)
                                                % If this is the case, then write over last entry in the plot LIST.  To do this, just decrement the listIndex.
                                                disp('Writing over value in LIST');
                                                listIndex = listIndex - 1;
%                                               % ERROR HERE - DON'T USE - Save the old value in case we need it at the end for the first point above the collapse point
%                                               firstSaAboveCollapsePoint = saLevelsForIDAPlotLIST(1, listIndex);
%                                                maxDriftRatioForFirstSaAboveCollapsePoint = maxDriftRatioForPlotLIST(1, listIndex);
                                            end
                                
                                        % Now after the processing, there is defined a value of maxDriftForFullFrame, that I will store here to have the max drift level in the frame for this Sa level
                                        saLevelsForIDAPlotLIST(1, listIndex) = saTOneForRun;
                                        scaleFactorsForIDAPlotLIST(1, listIndex) = scaleFactorForRun;
                                        % Compute ratio to use later to
                                        % compute the scale factor at
                                        % collapse.
                                            unscaledSaLevelOfRecord_SaIsBasedOnScalingMethodUsed = saTOneForRun / scaleFactorForRun;
                                        
                                        maxDriftRatioForPlotLIST(1, listIndex) = maxDriftRatioForFullStr;
                                        isNonConvLIST(1, listIndex) = isNonConv;
                                        isSingularLIST(1, listIndex) = isSingular;
                                        isCollapsedLIST(1, listIndex) = isCollapsed;
                            
                                        % Update the index
                                        listIndex = listIndex + 1;
                                
                                
                                end
                            end
                        end
                    end
                    
                    % If we do not have a data point above the collapse point, then add it...
                    if(foundPointAboveCollapse == 0)
                        % Add the point above the collapse point
                            %disp('Adding point above the collapse point');
                            saLevelsForIDAPlotLIST(1, listIndex) = firstSaAboveCollapsePoint;
                            maxDriftRatioForPlotLIST(1, listIndex) = maxDriftRatioForFirstSaAboveCollapsePoint;
                            isNonConvLIST(1, listIndex) = isNonConvAboveCollapse;
                            isSingularLIST(1, listIndex) = isSingularAboveCollapse;
                            isCollapsedLIST(1, listIndex) = isCollapsedAboveCollapse;
                    end
                    
                    % Now go through the IDA lists and find the
                    % collapseSaLevel - this is the average of the highest
                    % point with a drift below the maxDriftLevelForCollapse
                    % and the lowest points with a drift level higher than
                    % the maxDriftLevelForCollapse
                        % Loop to find the collapsed drift level
                        for i=1:length(maxDriftRatioForPlotLIST)
                            currentDriftLevel = maxDriftRatioForPlotLIST(i);
                            currentSaLevel = saLevelsForIDAPlotLIST(i);
                            % If we are past the collapse drift then stop
                            % looping
                            if(currentDriftLevel > collapseDriftThreshold)
                                break;
                            end
                            % Go to the next step
                            lastStepSaLevel = currentSaLevel;
                        end
                        % Average the two values to find the
                        % collapseSaLevel
                        collapseSaLevel = (currentSaLevel + lastStepSaLevel) / 2.0;
                        collapseSaLevel
                        
                    % Compute the scale factor at collapse (scale factor on
                    % the actual record)
                        scaleFactorOnCompAtCollapse = collapseSaLevel / unscaledSaLevelOfRecord_SaIsBasedOnScalingMethodUsed;

                        
                    % For this EQ, save the information needed for an IDA plot
                        % First change the directory to get into the correct folder for processing
                        cd ..;
                        cd Output;
                        % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
                        analysisTypeFolder = sprintf('%s', analysisType);
                        cd(analysisTypeFolder);

                        % EQ folder name
                        eqFolder = sprintf('EQ_%.0f', eqNumber);
                        cd(eqFolder);
                    
                        % Save results
                        fileName = ['DATA_collapseIDAPlotDataForThisEQ.mat'];
                        
                        save(fileName, 'saLevelsForIDAPlotLIST', 'maxDriftRatioForPlotLIST', 'collapseSaLevel', 'saLevelsRunForCollapseAnalysis', 'isNonConvLIST', 'isSingularLIST', 'isCollapsedLIST', 'scaleFactorOnCompAtCollapse');
                        
                        % Clear these variable for next time
                        clear saLevelsForIDAPlotLIST maxDriftRatioForPlotLIST collapseSaLevel saLevelsRunForCollapseAnalysis collapseSaLevel saLevelsRunForCollapseAnalysis

                        % Back to starting folder
                        cd ..;
                        cd ..;
                        cd ..;
                        cd MatlabProcessors;

                        
        end 

    end
    
    