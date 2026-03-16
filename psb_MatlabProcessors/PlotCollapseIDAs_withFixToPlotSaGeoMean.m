%
% Procedure: PlotCollapseIDAs_withFixToPlotSaGeoMean.m
% -------------------
% This is the same as PlotCollapseIDAs.m, but this file assumes that the
%   IDAs were run based on the Sa,comp., then this file adjusts to Sa,geoMean
%   and plots based on Sa,geoMean.  Therefore, ONLY USE THIS WHEN THE
%   RECORDS WERE RUN INCORRECTLY BASED ON SA,COMP!!!!!  The new algorithm
%   runs things bases on GeoMean and the normal processors work fine for
%   that!
% This was made b/c for the Benchmark models, I accidentally ran the
%   collapse IDAs based on Sa,comp.  See Benchmark hand notes on 9-28-05.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-24-04
% Modified: 9-28-05
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
% function[void] = PlotCollapseIDAs(analysisTypeLIST, eqNumberLIST,
% markerTypeLine, markerTypeDot, isPlotIndividualPoints)
function[void] = PlotCollapseIDAs_withFixToPlotSaGeoMean(analysisTypeLIST, eqNumberLIST, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);


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
            periodForSpectrum = 1.0;    % This is the period that we ran the analysis at
            dampRat = 0.05;             % This is the damping ratio assumed for the spectral values (always 5%)
            eqCompNumber_comp1 = eqNumber * 10.0 + 1.0;
            eqCompNumber_comp2 = eqNumber * 10.0 + 2.0;
            saComp_comp1 = RetrieveSaValueForAnEQ(eqCompNumber_comp1, periodForSpectrum, dampRat);
            saComp_comp2 = RetrieveSaValueForAnEQ(eqCompNumber_comp2, periodForSpectrum, dampRat);
            sa_geoMean = (saComp_comp1 * saComp_comp2) ^ 0.5;
            ratioOfSa_GeoMeanToComp_comp1 = sa_geoMean / saComp_comp1;
            ratioOfSa_GeoMeanToComp_comp2 = sa_geoMean / saComp_comp2;
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
        load('DATA_collapseIDAPlotDataForThisEQ.mat');
        collapseLevelFromFileOpened_adjForGeoMean = collapseSaLevel * ratioOfSa_GeoMeanToComp_comp1;        % Altered on 9-28-05
        saLevelsForIDAPlotLIST_adjForGeoMean = saLevelsForIDAPlotLIST * ratioOfSa_GeoMeanToComp_comp1;      % Added on 9-28-05
        
        clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
    
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
                saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(subLoopIndex) = saLevelsForIDAPlotLIST_adjForGeoMean(loopIndex);    % Altered on 9-28-05
                %isCollapseLISTPROCC1(subLoopIndex) = isCollapsedLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end
    
    
        end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
        figure(figureNumAllComp);
        plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1_adjForGeoMean, markerTypeLine);    % Altered on 9-28-05
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1_adjForGeoMean)
                hold on
                plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(i), markerTypeDot);    % Altered on 9-28-05
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
            if(max(abs(saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(index)), abs(saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(index - 1))) < 15.0);
                % Compute it the normal way
                collapseLevelCompOne_adjForGeoMean = (saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(index) + saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(index - 1)) / 2.0;
            else
                disp('***********************************');
                disp('******* Fixing error **************');
                disp('***********************************');
                % If this error has occured, just take the Sa value just
                % before the error and call this the collapse (the minimim
                % of the two values)
                collapseLevelCompOne_adjForGeoMean = min(abs(saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(index)), abs(saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(index - 1)));
            end

%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened. (removed
%             9-28-05)
%                 if(collapseLevelCompOne_adjForGeoMean > 50.0)
%                     collapseLevelCompOne_adjForGeoMean = collapseLevelFromFileOpened_adjForGeoMean;
%                 end

            collapseLevelCompOne_adjForGeoMean
            collapseLevelForAllComp_adjForGeoMean(eqCompInd) = collapseLevelCompOne_adjForGeoMean;

        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC1;
            saLevelsForIDAPlotPROCLIST_adjForGeoMean = saLevelsForIDAPlotPROCLISTC1_adjForGeoMean;
            % Save file
            eqCompColFileName = ['DATA_collapse_ProcessedIDADataForThisEQ.mat'];
            save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST_adjForGeoMean');        
            
        % Clear the results from the last loop
        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST
 
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
        load('DATA_collapseIDAPlotDataForThisEQ.mat');
        collapseLevelFromFileOpened_adjForGeoMean = collapseSaLevel * ratioOfSa_GeoMeanToComp_comp2;    % Altered on 9-28-05
        saLevelsForIDAPlotLIST_adjForGeoMean = saLevelsForIDAPlotLIST * ratioOfSa_GeoMeanToComp_comp2;  % Added on 9-28-05
        clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
        
    % Save collapse level for all EQs - this is from what is saved when the collapse run is done.
        eqCompNumber
%         collapseSaLevel
%         collapseLevelForAllComp(eqCompInd) = collapseSaLevel;    % ALTER THIS TO BE BASED ON OUTPUT DATA!!!! % NOTICE: This is the value from when the collapse algorithm ran (at least it's still this way as of 3-14-05)
%         collapseSaLevelCompTwo = collapseSaLevel;
        
        % Process the vector of IDA results to remove the results for singular or non-converegd records...
        % Loop through the vectors from the file that was opened and only put the results in the 
        %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) & (isSingularLIST(loopIndex) | isNonConvLIST(loopIndex)))
                % If this is the case, don't add it to th eplot list
            else
                % If we get here, we are okay, so add it to the plot list
                maxDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
                saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(subLoopIndex) = saLevelsForIDAPlotLIST_adjForGeoMean(loopIndex);    % Altered on 9-28-05
                %isCollapseLISTPROCC2(subLoopIndex) = isCollapsedLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end

        end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
        figure(figureNumAllComp);
        plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_adjForGeoMean, markerTypeLine);
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC2_adjForGeoMean)
                hold on
                plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(i), markerTypeDot);
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
            if(max(abs(saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(index)), abs(saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(index - 1))) < 15.0);
                % Compute it the nromal way
                collapseLevelCompTwo_adjForGeoMean = (saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(index) + saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(index - 1)) / 2.0;
            else
                disp('***********************************');
                disp('******* Fixing error **************');
                disp('***********************************');
                % If this error has occured, just take the Sa value just
                % before the error and call this the collapse (the minimim
                % of the two values)
                collapseLevelCompTwo_adjForGeoMean = min(abs(saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(index)), abs(saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(index - 1)));
            end
            
%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened. (removed
%             %   9-28-05)
%                 if(collapseLevelCompTwo_adjForGeoMean > 50.0)
%                     collapseLevelCompTwo_adjForGeoMean = collapseLevelFromFileOpened_adjForGeoMean;
%                 end
                
            collapseLevelCompTwo_adjForGeoMean
            collapseLevelForAllComp_adjForGeoMean(eqCompInd) = collapseLevelCompTwo_adjForGeoMean;
        
        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC2;
            saLevelsForIDAPlotPROCLIST_adjForGeoMean = saLevelsForIDAPlotPROCLISTC2_adjForGeoMean;
            % Save file
            eqCompColFileName = ['DATA_collapse_ProcessedIDADataForThisEQ.mat'];
            save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST_adjForGeoMean');  
        
        % Clear the results from the last loop
        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST 
 
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
    if(collapseLevelCompTwo_adjForGeoMean > collapseLevelCompOne_adjForGeoMean)
        temp = sprintf('EQ: %d - component 1 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompOne_adjForGeoMean);
        disp(temp);
        
        % Plot - note that the psuedoTimeVector is from the file that was opened 
            figure(figureNumControllingComp);
            plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1_adjForGeoMean, markerTypeLine);
        
            % Plot the points for each run, if told to
            if(isPlotIndividualPoints == 1)
                for i = 1:length(saLevelsForIDAPlotPROCLISTC1_adjForGeoMean)
                    hold on
                    plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1_adjForGeoMean(i), markerTypeDot);
                    i = i + 1;    
                end 
            end

        % Save the collapse capacity for this controlling component
        collapseLevelForAllControlComp_adjForGeoMean(eqInd) = collapseLevelCompOne_adjForGeoMean;
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+1)];    
            
            
    else
        temp = sprintf('EQ: %d - component 2 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompTwo_adjForGeoMean);
        disp(temp);

        % Plot - note that the psuedoTimeVector is from the file that was opened 
            figure(figureNumControllingComp);
            plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_adjForGeoMean, markerTypeLine);
        
            % Plot the points for each run, if told to
            if(isPlotIndividualPoints == 1)
                for i = 1:length(saLevelsForIDAPlotPROCLISTC2_adjForGeoMean)
                    hold on
                    plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_adjForGeoMean(i), markerTypeDot);
                    i = i + 1;    
                end 
            end

        % Save the collapse capacity for this controlling component
        collapseLevelForAllControlComp_adjForGeoMean(eqInd) = collapseLevelCompTwo_adjForGeoMean;
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+2)];
            
            
    end
    
    
    
    
    %%%%%%%%%%%%%% END: Find component that controls the buiding collapse capacity and plot this on the seconds plot

    
    % Altered - 9-28-05.  It looks like some of these variable names may
    % not exist any more (may be old)
    clear collapseLevelCompOne_adjForGeoMean collapseLevelCompTwo_adjForGeoMean isCollapseLISTPROCC1 maxDriftRatioForPlotPROCLISTC1 saLevelsForIDAPlotPROCLISTC1_adjForGeoMean isCollapseLISTPROCC2 maxDriftRatioForPlotPROCLISTC2 saLevelsForIDAPlotPROCLISTC2_adjForGeoMean;
    
end


% Do collapse statistics - for all components
    analysisType
    meanCollapseSaTOneAllComp_adjForGeoMean = mean(collapseLevelForAllComp_adjForGeoMean);
    medianCollapseSaTOneAllComp_adjForGeoMean = (median(collapseLevelForAllComp_adjForGeoMean))
    meanLnCollapseSaTOneAllComp_adjForGeoMean = mean(log(collapseLevelForAllComp_adjForGeoMean))
    stDevCollapseSaTOneAllComp_adjForGeoMean = std(collapseLevelForAllComp_adjForGeoMean)
    stDevLnCollapseSaTOneAllComp_adjForGeoMean = std(log(collapseLevelForAllComp_adjForGeoMean))
    
% Do collapse statistics - for controlling components
    analysisType
    meanCollapseSaTOneControlComp_adjForGeoMean = mean(collapseLevelForAllControlComp_adjForGeoMean)
    medianCollapseSaTOneControlComp_adjForGeoMean = (median(collapseLevelForAllControlComp_adjForGeoMean))
    meanLnCollapseSaTOneControlComp_adjForGeoMean = mean(log(collapseLevelForAllControlComp_adjForGeoMean))
    stDevCollapseSaTOneControlComp_adjForGeoMean = std(collapseLevelForAllControlComp_adjForGeoMean)
    stDevLnCollapseSaTOneControlComp_adjForGeoMean = std(log(collapseLevelForAllControlComp_adjForGeoMean))
    
    

% Save collapse results file
    % Go to the correct folder
        cd ..;
        cd Output;
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        
    % Save results      
        colFileName = ['DATA_collapse_CollapseSaAndStats.mat'];

        save(colFileName, 'analysisType', 'collapseLevelForAllComp_adjForGeoMean', 'collapseLevelForAllControlComp_adjForGeoMean', 'eqNumberLIST', 'meanCollapseSaTOneAllComp_adjForGeoMean',...
            'medianCollapseSaTOneAllComp_adjForGeoMean', 'meanLnCollapseSaTOneAllComp_adjForGeoMean', 'stDevCollapseSaTOneAllComp_adjForGeoMean',...
            'stDevLnCollapseSaTOneAllComp_adjForGeoMean', 'meanCollapseSaTOneControlComp_adjForGeoMean', 'medianCollapseSaTOneControlComp_adjForGeoMean',...
            'meanLnCollapseSaTOneControlComp_adjForGeoMean', 'stDevCollapseSaTOneControlComp_adjForGeoMean', 'stDevLnCollapseSaTOneControlComp_adjForGeoMean', 'eqCompNumberLIST', 'ControllingCompNumLIST')

    % Go back to the MatlabProcessor folder
        cd ..;
        cd ..;
        cd MatlabProcessors;

% Do final plot details - figure for all components
        figure(figureNumAllComp);
        hold on
        grid on
        titleText = sprintf('Incremental Dynamic Analysis, ALL Components (adjustment done so Sa is geoMean), %s', analysisType);
        title(titleText);
        hy = ylabel('Sa_{g.m.}(T=1.0s)[g]');
        hx = xlabel('Maximum Interstory Drift Ratio');
        xlim([0, maxXOnAxis])
        FigureFormatScript
        hold off

% Do final plot details - figure for controlling components
        figure(figureNumControllingComp);
        hold on
        grid on
        titleText = sprintf('Incremental Dynamic Analysis, ONLY Controlling Component(adjustment done so Sa is geoMean), %s', analysisType);
        title(titleText);
        hy = ylabel('Sa_{g.m.}(T=1.0s)[g]');
        hx = xlabel('Maximum Interstory Drift Ratio');
        xlim([0, maxXOnAxis])
        FigureFormatScript
        hold off

end

% % Call another function to plot the empirical collapse CDF with fits...
% PlotCollapseEmpiricalCDFWithFits




