%
% Procedure: PlotCollapseIDAs_alteredToPlotSaCompAtOtherPeriod.m
% -------------------
% This plots Sa,component at a specified period.  We could have run the analysis with any type of scaling
% method (Sa,code' Sa,g.m., Sa,comp) and it doesn't matter.  This does
% all plots based on Sa,comp at the input period (input period is defined at start
% of code in this file, or is an input variable).
% 
% Assumptions and Notices: 
%           - NOTICE: The Sa calculation function may have some hard-wiring
%           to work on my computer only (CBH), so we may need to update the
%           function to make this work correctly on another computer.
%
% Author: Curt Haselton 
% Date Written: 12-14-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
%
%           % ADD THESE
%
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = PlotCollapseIDAs_alteredToPlotSaCompAtOtherPeriod(analysisTypeLIST, eqNumberLIST, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, periodUsedForAnalysisRun, periodToUseForIDAPlot, dampRat)


% Input needed information
    % NOTICE: We could have run the analysis with any type of scaling
    % method (Sa,code' Sa,g.m., Sa,comp) and it doesn't matter.  This does
    % all plots based on Sa,comp at the input period.
    %periodUsedForAnalysisRun = 1.0;        % This is the period that we ran the analysis at
    %periodToUseForIDAPlot = 2.0;    % This is the period
    %dampRat = 0.05;                 % This is the damping ratio assumed for the spectral values (always 5%)



% Input what max drift value you want on X axis for the plot
maxXOnAxis = 0.15; %0.30;
figureNumAllComp = 1;           % Plot of results for all components
figureNumControllingComp = 2;   % Plot of results for only controlling components
ControllingCompNumLIST =[];


for analysisTypeIndex = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeIndex}

% Initialize a vector - twice as long as the eqNumerLIST b/c I do two comp. per EQ
collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));   
collapseLevelForControllingComp = zeros(1,(length(eqNumberLIST)));   
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST))); 
eqCompInd = 1;

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Addition for Sa,geoMean fix - 9-28-05
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute the ratio between the Sa,geoMean and the Sa,comp...
            eqCompNumber_comp1 = eqNumber * 10.0 + 1.0;
            eqCompNumber_comp2 = eqNumber * 10.0 + 2.0;
            % Get Sa values at the period used for the analysis run
            saCompUsedForRun_comp1 = RetrieveSaValueForAnEQ(eqCompNumber_comp1, periodUsedForAnalysisRun, dampRat);
            saCompUsedForRun_comp2 = RetrieveSaValueForAnEQ(eqCompNumber_comp2, periodUsedForAnalysisRun, dampRat);
            % Get Sa values at the period that we want to use for the plot
            saCompUsedForIDAPlot_comp1 = RetrieveSaValueForAnEQ(eqCompNumber_comp1, periodToUseForIDAPlot, dampRat);
            saCompUsedForIDAPlot_comp2 = RetrieveSaValueForAnEQ(eqCompNumber_comp2, periodToUseForIDAPlot, dampRat);
            %sa_geoMean = (saComp_comp1 * saComp_comp2) ^ 0.5;
            %ratioOfSa_SaForPlotOverSaUsedForRun_comp1 = saCompUsedForIDAPlot_comp1 / saCompUsedForRun_comp1;
            %ratioOfSa_SaForPlotOverSaUsedForRun_comp2 = saCompUsedForIDAPlot_comp2 / saCompUsedForRun_comp2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    eqCompNumber = eqNumber * 10.0 + 1.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

    % Go to the correct folder
        cd ..;
        cd Output;
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        eqFolder = sprintf('EQ_%.0f', eqCompNumber);
        cd(eqFolder)

    % Open the file that has the collapse data
        load('DATA_collapseIDAPlotDataForThisEQ.mat', 'scaleFactorOnCompAtCollapse', 'collapseSaLevel', 'saLevelsForIDAPlotLIST', 'maxDriftRatioForPlotLIST', 'isCollapsedLIST', 'isSingularLIST', 'isNonConvLIST');        
        collapseSaLevel_saDefUsedForRun = collapseSaLevel;
        
        % These runs may have been done with any number of scaling methods,
        % so alter the results to be for the Sa,component no matter what.  
        collapseSaLevel_saComp_periodUsedForRun = scaleFactorOnCompAtCollapse * saCompUsedForRun_comp1;
        collapseSaLevel_saComp_periodUsedForIDAPlot = scaleFactorOnCompAtCollapse * saCompUsedForIDAPlot_comp1;

        % Now compute the sa levels over the IDA adjusted to be for
        % Sa,component and to be for the correct period that we want to
        % use.
        saLevelsForIDAPlotLIST_saComp_periodUsedForIDAPlot = saLevelsForIDAPlotLIST * (collapseSaLevel_saComp_periodUsedForIDAPlot / collapseSaLevel_saDefUsedForRun);      % Added on 12-14-05
        
        clear collapseSaLevel saLevelsForIDAPlotLIST scaleFactorOnCompAtCollapse;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
    
    % Save collapse level for all EQs - this is from what is saved when the collapse run is done - DO NOT USE THIS RESULT FOR COMPUTATIONS!!!
        eqCompNumber
%         collapseLevelForAllComp(eqCompInd) = collapseSaLevel;    % ALTER THIS TO BE BASED ON OUTPUT DATA!!!! % NOTICE: This is the value from when the collapse algorithm ran (at least it's still this way as of 3-14-05)
%         collapseSaLevelCompOne = collapseSaLevel;
        
    % Process the vector of IDA results to remove the results for singular or non-converegd records...
        % Loop through the vectors from the file that was opened and only put the results in the 
        %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) & (isSingularLIST(loopIndex) | isNonConvLIST(loopIndex)))
                % If this is the case, don't add it to the plot list
            else
                % If we get here, we are okay, so add it to the plot list
                maxDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
                saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(subLoopIndex) = saLevelsForIDAPlotLIST_saComp_periodUsedForIDAPlot(loopIndex);    % Altered on 9-28-05
                %isCollapseLISTPROCC1(subLoopIndex) = isCollapsedLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end
    
    
        end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
        figure(figureNumAllComp);
        plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod, markerTypeLine);    % Altered on 9-28-05
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod)
                hold on
                plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(i), markerTypeDot);    % Altered on 9-28-05
                i = i + 1;    
            end 
        end
        
        % Find the collapse Sa level for the component and save it.  Loop to find the collapse point, then average the Sa level just 
        %   below and just above the collapse point.
            % Loop to get to the collapse point
            for index = 1:length(maxDriftRatioForPlotPROCLISTC1)
                if(maxDriftRatioForPlotPROCLISTC1(index) > collapseDriftThreshold) 
                    break;    
                end
            end
            
            % Take average and call that the collapse capacity.  If one
            % value is over 15 (this happens when there was a convergence
            % error it looks like), then just use the minimum of the two
            % values. (altered on 0-28-05)
            if(max(abs(saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(index)), abs(saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(index - 1))) < 15.0);
                % Compute it the normal way
                collapseLevelCompOne_adjForSaCompAtPeriod = (saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(index) + saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(index - 1)) / 2.0;
            else
                disp('***********************************');
                disp('******* Fixing error **************');
                disp('***********************************');
                % If this error has occured, just take the Sa value just
                % before the error and call this the collapse (the minimim
                % of the two values)
                collapseLevelCompOne_adjForSaCompAtPeriod = min(abs(saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(index)), abs(saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(index - 1)));
            end

%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened. (removed
%             9-28-05)
%                 if(collapseLevelCompOne_adjForGeoMean > 50.0)
%                     collapseLevelCompOne_adjForGeoMean = collapseLevelFromFileOpened_adjForGeoMean;
%                 end

            collapseLevelCompOne_adjForSaCompAtPeriod
            collapseLevelForAllComp_adjForSaCompAtPeriod(eqCompInd) = collapseLevelCompOne_adjForSaCompAtPeriod;

        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC1;
            saLevelsForIDAPlotPROCLIST_adjForSaCompAtPeriod = saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod;
            % Save file
            eqCompColFileName = ['DATA_collapse_ProcessedIDADataForThisEQ_adjustedForSaCompAndPeriod.mat'];
            save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST_adjForSaCompAtPeriod', 'periodUsedForAnalysisRun', 'periodToUseForIDAPlot');        
            
        % Clear the results from the last loop
        clear maxDriftRatioForPlotPROCLIST saLevelsForIDAPlotPROCLIST_adjForSaCompAtPeriod
 
        % Go back to the Matlab folder
        cd ..;
        cd ..;
        cd ..;
        cd MatlabProcessors;
        
        eqCompInd = eqCompInd + 1;
        
    %%%%%%%%%%%%% END: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%% START: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eqCompNumber = eqNumber * 10.0 + 2.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

    % Go to the correct folder
        cd ..;
        cd Output;
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        eqFolder = sprintf('EQ_%.0f', eqCompNumber);
        cd(eqFolder)

    % Open the file that has the collapse data
        load('DATA_collapseIDAPlotDataForThisEQ.mat', 'scaleFactorOnCompAtCollapse', 'collapseSaLevel', 'saLevelsForIDAPlotLIST', 'maxDriftRatioForPlotLIST', 'isCollapsedLIST', 'isSingularLIST', 'isNonConvLIST');        
        collapseSaLevel_saDefUsedForRun = collapseSaLevel;
        
        % These runs may have been done with any number of scaling methods,
        % so alter the results to be for the Sa,component no matter what.  
        collapseSaLevel_saComp_periodUsedForRun = scaleFactorOnCompAtCollapse * saCompUsedForRun_comp2;
        collapseSaLevel_saComp_periodUsedForIDAPlot = scaleFactorOnCompAtCollapse * saCompUsedForIDAPlot_comp2;

        % Now compute the sa levels over the IDA adjusted to be for
        % Sa,component and to be for the correct period that we want to
        % use.
        saLevelsForIDAPlotLIST_saComp_periodUsedForIDAPlot = saLevelsForIDAPlotLIST * (collapseSaLevel_saComp_periodUsedForIDAPlot / collapseSaLevel_saDefUsedForRun);      % Added on 12-14-05
        
        clear collapseSaLevel saLevelsForIDAPlotLIST scaleFactorOnCompAtCollapse;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
    
    % Save collapse level for all EQs - this is from what is saved when the collapse run is done - DO NOT USE THIS RESULT FOR COMPUTATIONS!!!
        eqCompNumber
%         collapseLevelForAllComp(eqCompInd) = collapseSaLevel;    % ALTER THIS TO BE BASED ON OUTPUT DATA!!!! % NOTICE: This is the value from when the collapse algorithm ran (at least it's still this way as of 3-14-05)
%         collapseSaLevelCompOne = collapseSaLevel;
        
    % Process the vector of IDA results to remove the results for singular or non-converegd records...
        % Loop through the vectors from the file that was opened and only put the results in the 
        %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) & (isSingularLIST(loopIndex) | isNonConvLIST(loopIndex)))
                % If this is the case, don't add it to the plot list
            else
                % If we get here, we are okay, so add it to the plot list
                maxDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
                saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(subLoopIndex) = saLevelsForIDAPlotLIST_saComp_periodUsedForIDAPlot(loopIndex);    % Altered on 9-28-05
                %isCollapseLISTPROCC1(subLoopIndex) = isCollapsedLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end
    
    
        end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
        figure(figureNumAllComp);
        plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod, markerTypeLine);    % Altered on 9-28-05
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod)
                hold on
                plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(i), markerTypeDot);    % Altered on 9-28-05
                i = i + 1;    
            end 
        end
        
        % Find the collapse Sa level for the component and save it.  Loop to find the collapse point, then average the Sa level just 
        %   below and just above the collapse point.
            % Loop to get to the collapse point
            for index = 1:length(maxDriftRatioForPlotPROCLISTC2)
                if(maxDriftRatioForPlotPROCLISTC2(index) > collapseDriftThreshold) 
                    break;    
                end
            end
            
            % Take average and call that the collapse capacity.  If one
            % value is over 15 (this happens when there was a convergence
            % error it looks like), then just use the minimum of the two
            % values. (altered on 0-28-05)
            if(max(abs(saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(index)), abs(saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(index - 1))) < 15.0);
                % Compute it the normal way
                collapseLevelCompTwo_adjForSaCompAtPeriod = (saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(index) + saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(index - 1)) / 2.0;
            else
                disp('***********************************');
                disp('******* Fixing error **************');
                disp('***********************************');
                % If this error has occured, just take the Sa value just
                % before the error and call this the collapse (the minimim
                % of the two values)
                collapseLevelCompTwo_adjForSaCompAtPeriod = min(abs(saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(index)), abs(saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(index - 1)));
            end

%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened. (removed
%             9-28-05)
%                 if(collapseLevelCompOne_adjForGeoMean > 50.0)
%                     collapseLevelCompOne_adjForGeoMean = collapseLevelFromFileOpened_adjForGeoMean;
%                 end

            collapseLevelCompTwo_adjForSaCompAtPeriod
            collapseLevelForAllComp_adjForSaCompAtPeriod(eqCompInd) = collapseLevelCompTwo_adjForSaCompAtPeriod;

        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC2;
            saLevelsForIDAPlotPROCLIST_adjForSaCompAtPeriod = saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod;
            % Save file
            eqCompColFileName = ['DATA_collapse_ProcessedIDADataForThisEQ_adjustedForSaCompAndPeriod.mat'];
            save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST_adjForSaCompAtPeriod', 'periodUsedForAnalysisRun', 'periodToUseForIDAPlot');        
            
        % Clear the results from the last loop
        clear maxDriftRatioForPlotPROCLIST saLevelsForIDAPlotPROCLIST_adjForSaCompAtPeriod
 
        % Go back to the Matlab folder
        cd ..;
        cd ..;
        cd ..;
        cd MatlabProcessors;
        
        eqCompInd = eqCompInd + 1;
    %%%%%%%%%%%%% END: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% START: Find component that controls the buiding collapse capacity and plot this on the seconds plot
    
    % Find the EQ component that controls and plot the controlling component
    if(collapseLevelCompTwo_adjForSaCompAtPeriod > collapseLevelCompOne_adjForSaCompAtPeriod)
        temp = sprintf('EQ: %d - component 1 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompOne_adjForSaCompAtPeriod);
        disp(temp);
        
        % Plot - note that the psuedoTimeVector is from the file that was opened 
            figure(figureNumControllingComp);
            plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod, markerTypeLine);
        
            % Plot the points for each run, if told to
            if(isPlotIndividualPoints == 1)
                for i = 1:length(saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod)
                    hold on
                    plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod(i), markerTypeDot);
                    i = i + 1;    
                end 
            end

        % Save the collapse capacity for this controlling component
        collapseLevelForAllControlComp_adjForSaCompAtPeriod(eqInd) = collapseLevelCompOne_adjForSaCompAtPeriod;
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+1)];    
            
            
    else
        temp = sprintf('EQ: %d - component 2 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompTwo_adjForSaCompAtPeriod);
        disp(temp);

        % Plot - note that the psuedoTimeVector is from the file that was opened 
            figure(figureNumControllingComp);
            plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod, markerTypeLine);
        
            % Plot the points for each run, if told to
            if(isPlotIndividualPoints == 1)
                for i = 1:length(saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod)
                    hold on
                    plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod(i), markerTypeDot);
                    i = i + 1;    
                end 
            end

        % Save the collapse capacity for this controlling component
        collapseLevelForAllControlComp_adjForGeoMean(eqInd) = collapseLevelCompTwo_adjForSaCompAtPeriod;
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+2)];
            
            
    end
    
    
    
    
    %%%%%%%%%%%%%% END: Find component that controls the buiding collapse capacity and plot this on the seconds plot

    
    % Altered - 9-28-05.  It looks like some of these variable names may
    % not exist any more (may be old)
    clear collapseLevelCompOne_adjForSaCompAtPeriod collapseLevelCompTwo_adjForSaCompAtPeriod isCollapseLISTPROCC1 maxDriftRatioForPlotPROCLISTC1 saLevelsForIDAPlotPROCLISTC1_adjForSaCompAtPeriod isCollapseLISTPROCC2 maxDriftRatioForPlotPROCLISTC2 saLevelsForIDAPlotPROCLISTC2_adjForSaCompAtPeriod;
    
end


% Do collapse statistics - for all components
    analysisType
    meanCollapseSaTOneAllComp_adjForSaCompAtPeriod = mean(collapseLevelForAllComp_adjForSaCompAtPeriod);
    medianCollapseSaTOneAllComp_adjForSaCompAtPeriod = (median(collapseLevelForAllComp_adjForSaCompAtPeriod))
    meanLnCollapseSaTOneAllComp_adjForSaCompAtPeriod = mean(log(collapseLevelForAllComp_adjForSaCompAtPeriod))
    stDevCollapseSaTOneAllComp_adjForSaCompAtPeriod = std(collapseLevelForAllComp_adjForSaCompAtPeriod)
    stDevLnCollapseSaTOneAllComp_adjForSaCompAtPeriod = std(log(collapseLevelForAllComp_adjForSaCompAtPeriod))
    
% Do collapse statistics - for controlling components
    analysisType
    meanCollapseSaTOneControlComp_adjForSaCompAtPeriod = mean(collapseLevelForAllControlComp_adjForSaCompAtPeriod)
    medianCollapseSaTOneControlComp_adjForSaCompAtPeriod = (median(collapseLevelForAllControlComp_adjForSaCompAtPeriod))
    meanLnCollapseSaTOneControlComp_adjForSaCompAtPeriod = mean(log(collapseLevelForAllControlComp_adjForSaCompAtPeriod))
    stDevCollapseSaTOneControlComp_adjForSaCompAtPeriod = std(collapseLevelForAllControlComp_adjForSaCompAtPeriod)
    stDevLnCollapseSaTOneControlComp_adjForSaCompAtPeriod = std(log(collapseLevelForAllControlComp_adjForSaCompAtPeriod))
    
    

% Save collapse results file
    % Go to the correct folder
        cd ..;
        cd Output;
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        
    % Save results      
        colFileName = ['DATA_collapse_CollapseSaAndStats_adjForSaCompAtPeriod.mat'];

        save(colFileName, 'analysisType', 'collapseLevelForAllComp_adjForSaCompAtPeriod', 'collapseLevelForAllControlComp_adjForSaCompAtPeriod', 'eqNumberLIST', 'meanCollapseSaTOneAllComp_adjForSaCompAtPeriod',...
            'medianCollapseSaTOneAllComp_adjForSaCompAtPeriod', 'meanLnCollapseSaTOneAllComp_adjForSaCompAtPeriod', 'stDevCollapseSaTOneAllComp_adjForSaCompAtPeriod',...
            'stDevLnCollapseSaTOneAllComp_adjForSaCompAtPeriod', 'meanCollapseSaTOneControlComp_adjForSaCompAtPeriod', 'medianCollapseSaTOneControlComp_adjForSaCompAtPeriod',...
            'meanLnCollapseSaTOneControlComp_adjForSaCompAtPeriod', 'stDevCollapseSaTOneControlComp_adjForSaCompAtPeriod', 'stDevLnCollapseSaTOneControlComp_adjForSaCompAtPeriod', 'eqCompNumberLIST', 'ControllingCompNumLIST')

    % Go back to the MatlabProcessor folder
        cd ..;
        cd ..;
        cd MatlabProcessors;

% Do final plot details - figure for all components
        figure(figureNumAllComp);
        hold on
        grid on
        titleText = sprintf('Incremental Dynamic Analysis, ALL Components (adjustment done so Sa is Sa,comp at prescribed period), %s', analysisType);
        title(titleText);
        temp = sprintf('Sa_{comp}(T=%.1fs)[g]', periodToUseForIDAPlot);
        hy = ylabel(temp);
        hx = xlabel('Maximum Interstory Drift Ratio');
        xlim([0, maxXOnAxis])
        FigureFormatScript
        hold off

% Do final plot details - figure for controlling components
        figure(figureNumControllingComp);
        hold on
        grid on
        titleText = sprintf('Incremental Dynamic Analysis, ONLY Controlling Component(adjustment done so Sa is Sa,comp at prescribed period), %s', analysisType);
        title(titleText);
        temp = sprintf('Sa_{comp}(T=%.1fs)[g]', periodToUseForIDAPlot);
        hy = ylabel(temp);
        hx = xlabel('Maximum Interstory Drift Ratio');
        xlim([0, maxXOnAxis])
        FigureFormatScript
        hold off

end

% % Call another function to plot the empirical collapse CDF with fits...
% PlotCollapseEmpiricalCDFWithFits




