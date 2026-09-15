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
function[void] = sks_PlotCollapseIDAsPDF_singleAnaType(idaInputs)

eqSpectraFolder =                idaInputs.eqSpectraFolder;
analysisType =                   idaInputs.analysisType;
% eqNumberLIST =                 idaInputs.eqNumberLIST;
eqListForCollapseIDAs_Name =     idaInputs.eqListForCollapseIDAs_Name;
midrLevels =                     idaInputs.midrLevels;                 %   1%, 2%, 4%. 8%.. IO, LS, CP, Collapse
midrLevelLabels =                idaInputs.midrLevelLabels;            % MIDR labels
% eqNumberLIST_forCollapseIDAs = idaInputs.eqNumberLIST_forCollapseIDAs;
markerTypeLine =                 idaInputs.markerTypeLine;
markerTypeDot =                  idaInputs.markerTypeDot;
isPlotIndividualPoints =         idaInputs.isPlotIndividualPoints;
collapseDriftThreshold =         idaInputs.collapseDriftThreshold;
isConvertToSaKircher =           idaInputs.isConvertToSaKircher;
eqNumberLIST =                   idaInputs.eqNumberLIST_forCollapseIDAs;
formatMode =                     idaInputs.formatMode;
dampRat =                        idaInputs.dampingRatioUsedForSaDef;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This does collapse IDAs for a single analysisType
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the file that defines the relationship between Sa,geoMean and
% Sa,Kricher at 1sec.
DefineSaKircherOverSaGeoMeanValues

% Input what max drift value you want on X axis for the plot
maxXOnAxis = 8; % in percent;
% Input limits for the Sa axis
minYOnAxis = 0.0;
maxYOnAxis = 6.0;      % Modify according to your analysis results

figureNumAllComp = 1;           % Plot of results for all components
figureNumControllingComp = 2;   % Plot of results for only controlling components
ControllingCompNumLIST =[];
figure(figureNumAllComp); clf; hold on;          
figure(figureNumControllingComp); clf; hold on;  

% %%%%%%% Start of PDF code added on 11-Apr-2026 %%%%%%%%%%%%%%%%%%%%%%%%%%%%            
saValsAtTargetDriftAllComp = nan(2*length(eqNumberLIST), length(midrLevels));
saValsAtTargetDriftControlComp = nan(length(eqNumberLIST), length(midrLevels)); 


pdfIndex = 1;
colors = [
    0.93 0.69 0.13   % IO   - orange/gold
    1.00 0.00 0.00   % LS   - red
    0.00 0.00 0.00   % CP   - black
    1.00 0.00 1.00   % Collapse - magenta
    ];


% %%%%%%% End of PDF code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize a vector - twice as long as the eqNumerLIST b/c I do two comp. per EQ
collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));   
collapseLevelForControllingComp = zeros(1,(length(eqNumberLIST)));   
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST))); 
eqCompInd = 1;

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);

    
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
        collapseLevelFromFileOpened = collapseSaLevel;
        clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
        load('DATA_CollapseResultsForThisSingleEQ.mat', 'toleranceAchieved', 'periodUsedForScalingGroundMotions');
        
    % Save collapse level for all EQs - this is from what is saved when the collapse run is done - DO NOT USE THIS RESULT FOR COMPUTATIONS!!!
        eqCompNumber;
%         collapseLevelForAllComp(eqCompInd) = collapseSaLevel;    % ALTER THIS TO BE BASED ON OUTPUT DATA!!!! % NOTICE: This is the value from when the collapse algorithm ran (at least it's still this way as of 3-14-05)
%         collapseSaLevelCompOne = collapseSaLevel;
        
    % Process the vector of IDA results to remove the results for singular or non-converged records...
        % Loop through the vectors from the file that was opened and only put the results in the 
        %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
                % If this is the case, don't add it to the plot list
            else
                % If we get here, we are okay, so add it to the plot list
                maxDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
                saLevelsForIDAPlotPROCLISTC1(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
                %isCollapseLISTPROCC1(subLoopIndex) = isCollapsedLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end
    
    
        end
    
    % Plot - note that the pseudoTimeVector is from the file that was opened 
        figure(figureNumAllComp);

%         hold off

        % Convert to Sa,Kircher if needed
        if(isConvertToSaKircher == 0)
            % We want to use Sa,goeMean(T1), so do not do a conversion
             plot(maxDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1, markerTypeLine);
        else
            % We want to plot with Sa,Kircher(T=1s), so do conversion and
            % plot
            saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
            saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
            saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC1.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
            plot(maxDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine);
            clear saGeoMeanAtOneSec saGeoMeanAtTOne
        end
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
                hold on
                % Convert to Sa,Kircher if needed
                if(isConvertToSaKircher == 0)
                    % We want to use Sa,geoMean(T1), so do not do a conversion
                    plot(maxDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot);
%                     pause(0.25)
                else
                    % We want to plot with Sa,Kircher(T=1s)
                    plot(maxDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot);
                end
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
            
            %%collapseLevelCompOne = (saLevelsForIDAPlotPROCLISTC1(index) +
            %%saLevelsForIDAPlotPROCLISTC1(index - 1)) / 2.0;
            % Take average and call that the collapse capacity.  If one
            % value is over 15 (this happens when there was a convergence
            % error it looks like), then just use the minimum of the two
            % values. (altered on 0-28-05)
            if(max(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1))) < 15.0);
                % Compute it the normal way
                collapseLevelCompOne = (saLevelsForIDAPlotPROCLISTC1(index) + saLevelsForIDAPlotPROCLISTC1(index - 1)) / 2.0;
            else
                disp('***********************************');
                disp('******* Fixing error **************');
                disp('***********************************');
                toleranceAchieved
                % If this error has occurred, just take the Sa value just
                % before the error and call this the collapse (the minimum
                % of the two values)
                collapseLevelCompOne = min(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1)));
            end
            
%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened.
%                 if(collapseLevelCompOne > 50.0)
%                     collapseLevelCompOne = collapseLevelFromFileOpened;
%                 end

            collapseLevelCompOne;
            collapseSaLevel = collapseLevelCompOne;
            collapseLevelForAllComp(eqCompInd) = collapseLevelCompOne;

        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC1;
            saLevelsForIDAPlotPROCLIST = saLevelsForIDAPlotPROCLISTC1;
            % Save file
            eqCompColFileName = sprintf('DATA_collapse_ProcessedIDADataForThisEQ.mat');
            save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST', 'collapseSaLevel');        
            
        % Clear the results from the last loop
        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST 
 
        % Go back to the Matlab folder
        cd(fullfile('..', '..', '..', 'psb_MatlabProcessors')); 
        
        eqCompInd = eqCompInd + 1;
        

    % %%%%%%% Start of PDF code added on 11-Apr-2026 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for driftIdx = 1:length(midrLevels)
        driftTarget = midrLevels(driftIdx);

        if max(maxDriftRatioForPlotPROCLISTC1) >= driftTarget
            % sort drift (required for interp1)
            [driftSorted, idx] = sort(maxDriftRatioForPlotPROCLISTC1);
            saSorted = saLevelsForIDAPlotPROCLISTC1(idx);

            % interpolate Sa at fixed drift
            saValsAtTargetDriftAllComp(pdfIndex,driftIdx) = interp1(driftSorted, saSorted, driftTarget);
        end
    end

    pdfIndex = pdfIndex + 1;

    % %%%%%%% End of PDF code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
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
        collapseLevelFromFileOpened = collapseSaLevel;
        clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
        
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
            plot(maxDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2, markerTypeLine);
        else
            % We want to plot with Sa,Kircher(T=1s), so do conversion and
            % plot
            saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
            saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
            saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC2.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
            plot(maxDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine);
            clear saGeoMeanAtOneSec saGeoMeanAtTOne
        end
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
                hold on
                % Convert to Sa,Kircher if needed
                if(isConvertToSaKircher == 0)
                    % We want to use Sa,goeMean(T1), so do not do a conversion
                    plot(maxDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot);
%                         pause(0.5)
                else
                    % We want to plot with Sa,Kircher(T=1s)
                    plot(maxDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot);
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
                % If this error has occurred, just take the Sa value just
                % before the error and call this the collapse (the minimum
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
        cd(fullfile('..', '..', '..', 'psb_MatlabProcessors')); 
       
        eqCompInd = eqCompInd + 1;

    % %%%%%%% Start of PDF code added on 11-Apr-2026 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for driftIdx = 1:length(midrLevels)
        driftTarget = midrLevels(driftIdx);

        if max(maxDriftRatioForPlotPROCLISTC2) >= driftTarget
            [driftSorted,idx] = sort(maxDriftRatioForPlotPROCLISTC2);
            saSorted = saLevelsForIDAPlotPROCLISTC2(idx);
            saValsAtTargetDriftAllComp(pdfIndex,driftIdx) = interp1(driftSorted, saSorted, driftTarget);

        end
    end

    pdfIndex = pdfIndex + 1;
    
    % %%%%%%% End of PDF code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        
    %%%%%%%%%%%%% END: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       


    %%%%%%%%%%%%%% START: Find component that controls the building collapse capacity and plot this on the seconds plot
    
    % Find the EQ component that controls and plot the controlling component
    if(collapseLevelCompTwo > collapseLevelCompOne)
        temp = sprintf('EQ: %d - component 1 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompOne);
        disp(temp);
        
        % Plot - note that the pseudoTimeVector is from the file that was opened 
            figure(figureNumControllingComp);
            if(isConvertToSaKircher == 0)
                % We want to use Sa,geoMean(T1), so do not do a conversion
                plot(maxDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1, markerTypeLine);
%             pause(1)
            else
                % We want to plot with Sa,Kircher(T=1s)
                plot(maxDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine);
            end
            
            % Plot the points for each run, if told to
            if(isPlotIndividualPoints == 1)
                for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
                    hold on
                    if(isConvertToSaKircher == 0)
                        % We want to use Sa,goeMean(T1), so do not do a conversion
                        plot(maxDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot);
                    else
                        % We want to plot with Sa,Kircher(T=1s)
                        plot(maxDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot);
                    end                    
                end 
            end

        % Save the collapse capacity for this controlling component
        collapseLevelForAllControlComp(eqInd) = collapseLevelCompOne;
        ControllingCompNumLIST = [ControllingCompNumLIST (eqNumber*10+1)]; 

        % <-- ADDED LINE -->
        saValsAtTargetDriftControlComp(eqInd,:) = saValsAtTargetDriftAllComp(2*eqInd-1, :);
            
            
    else
        temp = sprintf('EQ: %d - component 2 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompTwo);
        disp(temp);

        % Plot - note that the psuedoTimeVector is from the file that was opened 
            figure(figureNumControllingComp);
            if(isConvertToSaKircher == 0)
                % We want to use Sa,geoMean(T1), so do not do a conversion
                plot(maxDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2, markerTypeLine);
            else
                % We want to plot with Sa,Kircher(T=1s)
                plot(maxDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine);
            end
            
            % Plot the points for each run, if told to
            if(isPlotIndividualPoints == 1)
                for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
                    hold on
                    if(isConvertToSaKircher == 0)
                        % We want to use Sa,geoMean(T1), so do not do a conversion
                        plot(maxDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot);
                    else
                        % We want to plot with Sa,Kircher(T=1s)
                        plot(maxDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot);
                    end                    
                end 
            end

        % Save the collapse capacity for this controlling component
        collapseLevelForAllControlComp(eqInd) = collapseLevelCompTwo;
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+2)];

        % <-- ADDED LINE -->
        saValsAtTargetDriftControlComp(eqInd,:) = saValsAtTargetDriftAllComp(2*eqInd, :);
    end
    
    %%%%%%%%%%%%%% END: Find component that controls the building collapse capacity and plot this on the seconds plot
    clear collapseSaLevelCompOne collapseSaLevelCompTwo isCollapseLISTPROCC1 maxDriftRatioForPlotPROCLISTC1 saLevelsForIDAPlotPROCLISTC1 isCollapseLISTPROCC2 maxDriftRatioForPlotPROCLISTC2 saLevelsForIDAPlotPROCLISTC2 saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec;
end


% if we want are plotting and storing the results using Sa,Kircher(1s),
% then convert the vectors now so everything is based on the correct
% definition of Sa,Kricher(1s).  NOTE that if we modify the Sa values to 
% report in the way for Kircher/ATC-63, the .mat results files will
% clearly be labeled to say they are based on Sa,Kircher.

    % Convert to Sa,Kircher if needed
    if(isConvertToSaKircher == 0)
        % We want to use Sa,geoMean(T1), so do not do a conversion
    else
        % OLD WITH ERROR - NO LOOP; we were just using the conversion from
        % the last EQ in the previous loop - totally wrong!
        % We want to convert to Sa,Kircher(T=1s), so do conversion
        %saGeoMeanAtOneSec = RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat);
        %saGeoMeanAtTOne = RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat);
        %collapseLevelForAllComp = collapseLevelForAllComp.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
        %collapseLevelForAllControlComp = collapseLevelForAllControlComp.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};

        % NEW - loop added so we loop over EQs and compute
        % Loop for all components
        for eqInd = 1:(length(eqCompNumberLIST))
            eqCompNumber = eqCompNumberLIST(eqInd);
            eqNumber = floor(eqCompNumber/10);
            
            saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
            saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
            collapseLevelForAllComp(eqInd) = collapseLevelForAllComp(eqInd) * (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
        end
        
        % Loop for controlling components
        for eqInd = 1:(length(eqNumberLIST))
            eqNumber = eqNumberLIST(eqInd);
            % Just use component one because we need a dummy component
            % number to do the Kircher conversion later
            eqCompNumber = eqNumber * 10.0 + 1.0;
        
            saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
            saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
            collapseLevelForAllControlComp(eqInd) = collapseLevelForAllControlComp(eqInd) * (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
        end    
            
        clear saGeoMeanAtOneSec saGeoMeanAtTOne
    end

% Do collapse statistics - for all components
    analysisType;
    meanCollapseSaTOneAllComp = mean(collapseLevelForAllComp);
    medianCollapseSaTOneAllComp = (median(collapseLevelForAllComp));
    meanLnCollapseSaTOneAllComp = mean(log(collapseLevelForAllComp));
    stDevCollapseSaTOneAllComp = std(collapseLevelForAllComp);
    stDevLnCollapseSaTOneAllComp = std(log(collapseLevelForAllComp));
    
% Do collapse statistics - for controlling components
    analysisType;
    meanCollapseSaTOneControlComp = mean(collapseLevelForAllControlComp);
    medianCollapseSaTOneControlComp = (median(collapseLevelForAllControlComp));
    meanLnCollapseSaTOneControlComp = mean(log(collapseLevelForAllControlComp));
    stDevCollapseSaTOneControlComp = std(collapseLevelForAllControlComp);
    stDevLnCollapseSaTOneControlComp = std(log(collapseLevelForAllControlComp));
    
% Save collapse results file
    % Go to the correct folder
        cd ..
        cd Output
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        
    % Save results     
    if(isConvertToSaKircher == 0)
        % This is Sa,geoMean
        colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', eqListForCollapseIDAs_Name);
    else
        % This is Sa,ATC-63 (or Sa,Kircher)
        colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63.mat', eqListForCollapseIDAs_Name);        
    end

        save(colFileName, 'analysisType', 'collapseLevelForAllComp', 'collapseLevelForAllControlComp', 'eqNumberLIST', 'meanCollapseSaTOneAllComp',...
            'medianCollapseSaTOneAllComp', 'meanLnCollapseSaTOneAllComp', 'stDevCollapseSaTOneAllComp','stDevLnCollapseSaTOneAllComp', 'meanCollapseSaTOneControlComp', ...
            'medianCollapseSaTOneControlComp','meanLnCollapseSaTOneControlComp', 'stDevCollapseSaTOneControlComp', 'stDevLnCollapseSaTOneControlComp', 'eqCompNumberLIST', ...
            'ControllingCompNumLIST', 'periodUsedForScalingGroundMotions');


        


    %% Start of PDF code added on 11-Apr-2026 %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    fprintf('\nSa values at fixed drift levels\n')
    fprintf('---------------------------------\n')

    saValsAtTargetDriftMat = saValsAtTargetDriftAllComp';   % transpose (rows = drift)
    driftPercent = midrLevels*100;
    % header
    fprintf('Drift(%%)\t')
    for i = 1:size(saValsAtTargetDriftMat,2)
        fprintf('Sa%d\t\t',i)
    end
    fprintf('\n')

    % rows
    for driftIdx = 1:length(driftPercent)
        fprintf('%6.0f\t', driftPercent(driftIdx))
        fprintf('%0.4f\t', saValsAtTargetDriftMat(driftIdx,:))
        fprintf('\n')
    end

    %%%%%%% End of PDF code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    



    %% ============================================================
    %  Plot LOG NORMAL PDF at drift locations (ALL COMPONENTS)
    % ============================================================
    figure(figureNumAllComp);
    hold on;

    hDriftLines = gobjects(length(midrLevels), 1);
    scaleFactor = maxXOnAxis * 0.06;

    for driftIdx = 1:length(midrLevels)
        targetDrift = midrLevels(driftIdx) * 100;

        % All components
        SaVals = saValsAtTargetDriftAllComp(:, driftIdx);

        % Retain only valid positive Sa values
        SaVals = SaVals(isfinite(SaVals) & SaVals > 0);

        if numel(SaVals) < 2
            continue
        end

        % Lognormal parameters
        muLn = mean(log(SaVals));
        sigmaLn = std(log(SaVals));


        % 16th, 50th, and 84th percentiles
        Sa16 = exp(muLn - sigmaLn);
        Sa50 = exp(muLn);
        Sa84 = exp(muLn + sigmaLn);
        
        % +/-3 sigma bounds used for the full PDF curve
        Sa_neg3 = exp(muLn - 3*sigmaLn);
        Sa_pos3 = exp(muLn + 3*sigmaLn);
        
        % Legend-visible 16th-84th range
        hDriftLines(driftIdx) = plot( [targetDrift targetDrift], [Sa16 Sa84], ...
            '-', 'LineWidth', 3.0, 'Color', colors(driftIdx,:), 'DisplayName', midrLevelLabels{driftIdx});
        
        % Median marker
        plot(targetDrift, Sa50, 'o', 'MarkerFaceColor', colors(driftIdx,:), ...
            'MarkerEdgeColor', colors(driftIdx,:), 'HandleVisibility', 'off');
        
        % Build each segment separately so Sa16/Sa84 are EXACT shared
        % endpoints between adjacent segments - no gap/seam.
        nPtsPerSeg = 150;
        saLower = linspace(Sa_neg3, Sa16, nPtsPerSeg);
        saMid   = linspace(Sa16,    Sa84, nPtsPerSeg);
        saUpper = linspace(Sa84,    Sa_pos3, nPtsPerSeg);

        pdfLower = lognpdf(saLower, muLn, sigmaLn);
        pdfMid   = lognpdf(saMid,   muLn, sigmaLn);
        pdfUpper = lognpdf(saUpper, muLn, sigmaLn);
        globalMax = max([pdfLower, pdfMid, pdfUpper]);
        pdfLower = pdfLower ./ globalMax * scaleFactor;
        pdfMid   = pdfMid   ./ globalMax * scaleFactor;
        pdfUpper = pdfUpper ./ globalMax * scaleFactor;

        segments = {saLower, saMid, saUpper};
        pdfSegs  = {pdfLower, pdfMid, pdfUpper};
        isFilled = [false, true, false];

        for s = 1:3
            saSeg = segments{s};
            pdfSeg = pdfSegs{s};
    
        if numel(saSeg) < 2
            continue
        end
    
        x_pdf = [targetDrift * ones(1, length(saSeg)), targetDrift - pdfSeg(end:-1:1)];
        y_pdf = [saSeg, saSeg(end:-1:1)];
    
        if isFilled(s)
            patch(x_pdf, y_pdf, colors(driftIdx,:), 'FaceAlpha', 0.30, ...
                'EdgeColor', colors(driftIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
        else
            patch(x_pdf, y_pdf, colors(driftIdx,:), 'FaceColor', 'none', ...
                'EdgeColor', colors(driftIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
        end
        end

    end

        validIdx = isgraphics(hDriftLines);
        if any(validIdx)
            legend(hDriftLines(validIdx), midrLevelLabels(validIdx), ...
                'Location', 'southeast', 'AutoUpdate', 'off');
        end

        % Do final plot details - figure for all components
        figure(figureNumAllComp) 
        hold on
        grid on

        if(isConvertToSaKircher == 0)
            titleTemp = sprintf('$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
        else
            titleTemp = axisLabelForSaKircher;
        end
        ylabel(titleTemp);
        xlabel('$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$', 'Interpreter','latex');
        % xlabel('$\mathrm{Max\ Interstory\ Drift\ Ratio}$', 'Interpreter','latex');
        xlim([0, maxXOnAxis])
        ylim([minYOnAxis maxYOnAxis]);
        sks_figureFormat(formatMode)

        % Save the plot
        if(isConvertToSaKircher == 0)
            % This is Sa,geoMean
            exportName = sprintf('CollapseIDA_AllComp_SaGeoMean_MIDR_PDF');
            sks_figureExport(exportName)  
        else
            % This is Sa,ATC-63 (or Sa,Kircher)
            exportName = sprintf('CollapseIDA_AllComp_SaATC63_MIDR_PDF');
            sks_figureExport(exportName)    
        end

        hold off

          

        %% ============================================================
        %  Plot LOG NORMAL PDF at drift locations (CONTROL COMPONENT)
        % ============================================================

        figure(figureNumControllingComp) 
        hold on
     
        hDriftLines = gobjects(length(midrLevels),1);
        scaleFactor = maxXOnAxis * 0.06;

        for driftIdx = 1:length(midrLevels)
            targetDrift = midrLevels(driftIdx) * 100;

            SaVals = saValsAtTargetDriftControlComp(:,driftIdx);
            SaVals = SaVals(~isnan(SaVals) & SaVals > 0);   % lognormal needs strictly positive data

            if numel(SaVals) < 2
                continue
            end

            % --- Lognormal parameters ---
            muLn = mean(log(SaVals));
            sigmaLn = std(log(SaVals));

           % 16th, 50th, and 84th percentiles
            Sa16 = exp(muLn - sigmaLn);
            Sa50 = exp(muLn);
            Sa84 = exp(muLn + sigmaLn);
            
            % +/-3 sigma bounds used for the full PDF curve
            Sa_neg3 = exp(muLn - 3*sigmaLn);
            Sa_pos3 = exp(muLn + 3*sigmaLn);
            
            % Legend-visible 16th-84th range
            hDriftLines(driftIdx) = plot( [targetDrift targetDrift], [Sa16 Sa84], ...
                '-', 'LineWidth', 3.0, 'Color', colors(driftIdx,:), 'DisplayName', midrLevelLabels{driftIdx});
            
            % Median marker
            plot(targetDrift, Sa50, 'o', 'MarkerFaceColor', colors(driftIdx,:), ...
                'MarkerEdgeColor', colors(driftIdx,:), 'HandleVisibility', 'off');
            
            % Build each segment separately so Sa16/Sa84 are EXACT shared
            % endpoints between adjacent segments - no gap/seam.
            nPtsPerSeg = 150;
            saLower = linspace(Sa_neg3, Sa16, nPtsPerSeg);
            saMid   = linspace(Sa16,    Sa84, nPtsPerSeg);
            saUpper = linspace(Sa84,    Sa_pos3, nPtsPerSeg);

            pdfLower = lognpdf(saLower, muLn, sigmaLn);
            pdfMid   = lognpdf(saMid,   muLn, sigmaLn);
            pdfUpper = lognpdf(saUpper, muLn, sigmaLn);
            globalMax = max([pdfLower, pdfMid, pdfUpper]);
            pdfLower = pdfLower ./ globalMax * scaleFactor;
            pdfMid   = pdfMid   ./ globalMax * scaleFactor;
            pdfUpper = pdfUpper ./ globalMax * scaleFactor;

            segments = {saLower, saMid, saUpper};
            pdfSegs  = {pdfLower, pdfMid, pdfUpper};
            isFilled = [false, true, false];

            for s = 1:3
                saSeg = segments{s};
                pdfSeg = pdfSegs{s};
            
                if numel(saSeg) < 2
                    continue
                end
            
                x_pdf = [targetDrift * ones(1, length(saSeg)), targetDrift - pdfSeg(end:-1:1)];
                y_pdf = [saSeg, saSeg(end:-1:1)];
            
                if isFilled(s)
                    patch(x_pdf, y_pdf, colors(driftIdx,:), 'FaceAlpha', 0.30, ...
                        'EdgeColor', colors(driftIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
                else
                    patch(x_pdf, y_pdf, colors(driftIdx,:), 'FaceColor', 'none', ...
                        'EdgeColor', colors(driftIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
                end
            end
        end

        validIdx = isgraphics(hDriftLines);
        if any(validIdx)
            legend(hDriftLines(validIdx), midrLevelLabels(validIdx), ...
                   'Location', 'southeast', 'AutoUpdate', 'off');
        end

        % Do final plot details - figure for controlling components
        figure(figureNumControllingComp);
        hold on
        grid on
        if(isConvertToSaKircher == 0)
            titleTemp = sprintf('$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
        else
            titleTemp = axisLabelForSaKircher;
        end
        ylabel(titleTemp, 'Interpreter', 'latex');
        xlabel('$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$', 'Interpreter','latex');
        % xlabel('$\mathrm{Max\ Interstory\ Drift\ Ratio}$', 'Interpreter','latex');
        xlim([0, maxXOnAxis])
        ylim([minYOnAxis maxYOnAxis]);
        sks_figureFormat(formatMode)
        
        % Save the plot
        if(isConvertToSaKircher == 0)
            % This is Sa,geoMean 
            exportName = sprintf('CollapseIDA_ControlComp_SaGeoMean_MIDR_PDF');
            sks_figureExport(exportName)     
        else
            % This is Sa,ATC-63 (or Sa,Kircher)
            exportName = sprintf('CollapseIDA_ControlComp_SaATC63_MIDR_PDF');
            sks_figureExport(exportName)   
        end
           
        hold off

      % Go back to the MatlabProcessor folder
      cd(fullfile('..', '..', 'psb_MatlabProcessors'));


  %%%%%%% End of PDF code added on 11-Apr-2026 %%%%%%%%%%%%%%%%%%%%%%%%%%%%








 %%%%%%%%%%%%% Fragility Functions - compute + save only (Control + All Comp) %%%%%%%%%%%%%%%%%%%%%%%

% Go to the correct folder to open the file that was created by the collapse IDA plotter.
  cd ..;
  cd Output
  analysisTypeFolder = sprintf('%s', analysisType);
  cd(analysisTypeFolder);

  numLimitStates = length(midrLevels);   % number of limit states (IO, LS, CP, Collapse)

  % ---- Controlling component ----
  meanLnSaVals   = nan(1, numLimitStates);
  stDevLnSaVals  = nan(1, numLimitStates);

  for limitStateIdx = 1:numLimitStates
      SaVals = saValsAtTargetDriftControlComp(:, limitStateIdx);
      SaVals = SaVals(isfinite(SaVals) & SaVals > 0);   % drop NaNs/invalid

      if numel(SaVals) < 2
          warning('Control comp - damage state %d has fewer than 2 valid points - skipping', limitStateIdx);
          continue
      end

      meanLnSaVals(limitStateIdx)  = mean(log(SaVals));   % median IM capacity for this damage state
      stDevLnSaVals(limitStateIdx) = std(log(SaVals));    % logarithmic dispersion (beta_RTR)
  end

  % ---- All components ----
  meanLnSaValsAllComp   = nan(1, numLimitStates);
  stDevLnSaValsAllComp  = nan(1, numLimitStates);

  for limitStateIdx = 1:numLimitStates
      SaVals = saValsAtTargetDriftAllComp(:, limitStateIdx);
      SaVals = SaVals(isfinite(SaVals) & SaVals > 0);   % drop NaNs/invalid

      if numel(SaVals) < 2
          warning('All comp - damage state %d has fewer than 2 valid points - skipping', limitStateIdx);
          continue
      end

      meanLnSaValsAllComp(limitStateIdx)  = mean(log(SaVals));
      stDevLnSaValsAllComp(limitStateIdx) = std(log(SaVals));
  end

% Save the fragility parameters (both control and all comp) so they survive after this function returns
if (isConvertToSaKircher == 0)
      fragFileName = sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', eqListForCollapseIDAs_Name);
else
      fragFileName = sprintf('DATA_FragilityParams_SaATC63_%s.mat', eqListForCollapseIDAs_Name);
end
  save(fragFileName, 'midrLevels', 'midrLevelLabels', 'meanLnSaVals', 'stDevLnSaVals', 'saValsAtTargetDriftControlComp', ...
       'meanLnSaValsAllComp', 'stDevLnSaValsAllComp', 'saValsAtTargetDriftAllComp');

% Return safely to MatlabProcessors folder
  cd(fullfile('..', '..', 'psb_MatlabProcessors'));
