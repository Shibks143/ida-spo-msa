%
% Procedure: PlotCollapseIDAs.m
% -------------------
% This procedure computes opens the needed files and plots collapse IDA's with the EQ runs as dots, and with connecting lines.  It only plots the maximum drift level
%   for the full frame.  To get the data, it opens a file that is made by processing the collapse runs.
%
% This procedure has the option to plot the IDA and to save the final collapse results file using Sa,Kircher (used for
%  ATC-63).  This modification to the Sa levels is made just before
%  plotting and just before saving the final results file; the figures and resutls files that use Sa,Kircher have the names clearly labeled to indicate this.
% NOTICE: The smaller files saved for each record are not
%  affected by this.  The smaller files are always saved with the Sa
%  definition used when running the analysis (WHICH MUST ALWAYS BE
%  SA,GEOMEAN FOR THESE PROCESSORS TO WORK CORRECTLY).
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-24-04, 7-20-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%   - not added
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = Delete_2ndCompOnly_PlotCollapseIDAs_singleAnaType(analysisType, eqNumberLIST, eqListForCollapseIDAs_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, isConvertToSaKircher)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This does collapse IDAs for a single analysisType
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the file that defines the relationship between Sa,goeMean and
% Sa,Kricher at 1sec.
DefineSaKircherOverSaGeoMeanValues

% Input what max drift value you want on X axis for the plot
maxXOnAxis = 0.10; %0.30;
figureNumAllComp = 1;           % Plot of results for all components
figureNumControllingComp = 2;   % Plot of results for only controlling components
ControllingCompNumLIST =[];
dampRat = 0.05; % This is used when converting to Sa,Kircher

% Initialize a vector - twice as long as the eqNumerLIST b/c I do two comp. per EQ
collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));   
collapseLevelForControllingComp = zeros(1,(length(eqNumberLIST)));   
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST))); 
eqCompInd = 1;

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);

    
    %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%  END: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        collapseLevelFromFileOpened = collapseSaLevel;
        clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
        load('DATA_CollapseResultsForThisSingleEQ.mat', 'toleranceAchieved', 'periodUsedForScalingGroundMotions');
        
    % Save collapse level for all EQs - this is from what is saved when the collapse run is done.
        eqCompNumber;
%         collapseSaLevel
%         collapseLevelForAllComp(eqCompInd) = collapseSaLevel;    % ALTER THIS TO BE BASED ON OUTPUT DATA!!!! % NOTICE: This is the value from when the collapse algorithm ran (at least it's still this way as of 3-14-05)
%         collapseSaLevelCompTwo = collapseSaLevel;
        
        % Process the vector of IDA results to remove the results for singular or non-converegd records...
        % Loop through the vectors from the file that was opened and only put the results in the 
        %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
                % If this is the case, don't add it to th eplot list
            else
                % If we get here, we are okay, so add it to the plot list
                maxDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
                saLevelsForIDAPlotPROCLISTC2(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
                %isCollapseLISTPROCC2(subLoopIndex) = isCollapsedLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end

        end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
        figure(figureNumAllComp);        
        % Convert to Sa,Kircher if needed
        if(isConvertToSaKircher == 0)
            % We want to use Sa,goeMean(T1), so do not do a conversion
            plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2, markerTypeLine);
        else
            % We want to plot with Sa,Kircher(T=1s), so do conversion and
            % plot
            saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat);
            saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat);
            saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC2.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
            plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine);
            clear saGeoMeanAtOneSec saGeoMeanAtTOne
        end
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
                hold on
                % Convert to Sa,Kircher if needed
                if(isConvertToSaKircher == 0)
                    % We want to use Sa,goeMean(T1), so do not do a conversion
                    plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot);
%                         pause(0.5)
                else
                    % We want to plot with Sa,Kircher(T=1s)
                    plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot);
                end
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
            if(max(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index - 1))) < 15.0);
                % Compute it the normal way
                collapseLevelCompTwo = (saLevelsForIDAPlotPROCLISTC2(index) + saLevelsForIDAPlotPROCLISTC2(index - 1)) / 2.0;
            else
                disp('***********************************');
                disp('******* Fixing error **************');
                disp('***********************************');
                toleranceAchieved
                % If this error has occured, just take the Sa value just
                % before the error and call this the collapse (the minimim
                % of the two values)
                collapseLevelCompTwo = min(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index - 1)));
            end    
            
%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened.
%                 if(collapseLevelCompTwo > 50.0)
%                     collapseLevelCompTwo = collapseLevelFromFileOpened;
%                 end
                
            collapseLevelCompTwo;
            collapseSaLevel = collapseLevelCompTwo;
            collapseLevelForAllComp(eqCompInd) = collapseLevelCompTwo;
        
        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC2;
            saLevelsForIDAPlotPROCLIST = saLevelsForIDAPlotPROCLISTC2;
            % Save file
            eqCompColFileName = sprintf('DATA_collapse_ProcessedIDADataForThisEQ.mat');
            save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST', 'collapseSaLevel');  
        
        % Clear the results from the last loop
        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST 
 
        % Go back to the Matlab folder
        cd ..;
        cd ..;
        cd ..;
        cd psb_MatlabProcessors;
        
        eqCompInd = eqCompInd + 1;
        
    %%%%%%%%%%%%% END: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


% if we want are plotting and storing the results using Sa,Kircher(1s),
% then convert the vectors now so everything is based on the correct
% definition of Sa,Kricher(1s).  NOTE that if we modify the Sa values to 
% report in the way for Kircher/ATC-63, the .mat results files will
% clearly be labeled to say they are based on Sa,Kircher.


% Save collapse results file
    % Go to the correct folder
        cd ..
        cd Output
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        
% Do final plot details - figure for all components
        figure(figureNumAllComp)
        hold on
        grid on
        %titleText = sprintf('Incremental Dynamic Analysis, ALL Components, %s', analysisType);
        %title(titleText);
        titleTemp = sprintf('Sa_{g.m.}(T_{1}=%.2fs) [g]', periodUsedForScalingGroundMotions);
        hy = ylabel(titleTemp);
        hx = xlabel('Maximum Interstory Drift Ratio');
        xlim([0, maxXOnAxis])
        FigureFormatScript
        
        % Save the plot
            % This is Sa,geoMean            
            % Save the plot as a .fig file
            % File name shortened to make it save file correctly (1-14-09 CBH)
            %plotName = sprintf('CollapseIDA_AllComp_%s_%s_SaGeoMean.fig', analysisType, eqListForCollapseIDAs_Name);
            plotName = sprintf('CollapseIDA_AllComp_SaGeoMean.fig');
            hgsave(plotName);
            % Export the plot as a .emf file (Matlab book page 455)
            % File name shortened to make it save file correctly (1-14-09 CBH)
            %exportName = sprintf('CollapseIDA_AllComp_%s_%s_SaGeoMean.emf', analysisType, eqListForCollapseIDAs_Name);
            exportName = sprintf('CollapseIDA_AllComp_SaGeoMean.emf');
            print('-dmeta', exportName);
        
        hold off

% Go back to the MatlabProcessor folder
        cd ..;
        cd ..;
        cd psb_MatlabProcessors;



