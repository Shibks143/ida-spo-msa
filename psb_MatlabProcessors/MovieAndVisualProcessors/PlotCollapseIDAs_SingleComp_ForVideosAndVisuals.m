%
% Procedure: PlotCollapseIDAs.m
% -------------------
% This procedure computes opens the needed files and plots collapse IDA's with the EQ runs as dots, and with connecting lines.  It only plots the maximum drift level
%   for the full frame.  To get the data, it opens a file that is made by processing the collapse runs.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-24-04
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
function[void] = PlotCollapseIDAs_SingleComp_ForVideosAndVisuals(buildingInfo, bldgID, analysisType, eqNumberLIST, markerTypeLine, markerTypeDot, isPlotIndividualPoints, saDefType)

% Input what max drift value you want on X axis for the plot
maxXOnAxis = 0.15; %0.30;
figureNumAllComp = 1;           % Plot of results for all components
figureNumControllingComp = 2;   % Plot of results for only controlling components
ControllingCompNumLIST =[];

% Get some information from the buildingInfo
collapseDriftThreshold = buildingInfo{bldgID}.collapseDriftThreshold;

% Initialize a vector - twice as long as the eqNumerLIST b/c I do two comp. per EQ
collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));   
collapseLevelForControllingComp = zeros(1,(length(eqNumberLIST)));   
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST))); 
eqCompInd = 1;

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);

    
    %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    eqCompNumber = eqNumber;    % Must have passed in the component number

    % Go to the correct folder
        startFolder = [pwd];
        cd ..;
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
        load('DATA_CollapseResultsForThisSingleEQ.mat', 'toleranceAchieved');
        
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
                saLevelsForIDAPlotPROCLISTC1(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
                %isCollapseLISTPROCC1(subLoopIndex) = isCollapsedLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end
    
    
        end
    
    % Plot - note that the psuedoTimeVector is from the file that was opened 
        plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1, markerTypeLine);
        hold on
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
                plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot);
                hold on
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
                % If this error has occured, just take the Sa value just
                % before the error and call this the collapse (the minimim
                % of the two values)
                collapseLevelCompOne = min(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1)));
            end
            
%             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
%             %   collapse Sa level from the file that was opened.
%                 if(collapseLevelCompOne > 50.0)
%                     collapseLevelCompOne = collapseLevelFromFileOpened;
%                 end

            collapseLevelCompOne
            collapseLevelForAllComp(eqCompInd) = collapseLevelCompOne;

        % Save a file for this EQ component
            % Rename variables to be general to either component 1 or 2
            %maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC1;
            %saLevelsForIDAPlotPROCLIST = saLevelsForIDAPlotPROCLISTC1;
            % Save file
            %eqCompColFileName = ['DATA_collapse_ProcessedIDADataForThisEQ.mat'];
            %save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST');        
            
        % Clear the results from the last loop
        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST 
 
        % Go back to the Matlab folder
        cd ..;
        cd ..;
        cd ..;
        cd MatlabProcessors;
        
        
    %%%%%%%%%%%%% END: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
    end
    
    
    clear collapseSaLevelCompOne collapseSaLevelCompTwo isCollapseLISTPROCC1 maxDriftRatioForPlotPROCLISTC1 saLevelsForIDAPlotPROCLISTC1 isCollapseLISTPROCC2 maxDriftRatioForPlotPROCLISTC2 saLevelsForIDAPlotPROCLISTC2;
    

% % Do collapse statistics - for all components
%     analysisType
%     meanCollapseSaTOneAllComp = mean(collapseLevelForAllComp);
%     medianCollapseSaTOneAllComp = (median(collapseLevelForAllComp))
%     meanLnCollapseSaTOneAllComp = mean(log(collapseLevelForAllComp))
%     stDevCollapseSaTOneAllComp = std(collapseLevelForAllComp)
%     stDevLnCollapseSaTOneAllComp = std(log(collapseLevelForAllComp))
%     
% % Do collapse statistics - for controlling components
%     analysisType
%     meanCollapseSaTOneControlComp = mean(collapseLevelForAllControlComp)
%     medianCollapseSaTOneControlComp = (median(collapseLevelForAllControlComp))
%     meanLnCollapseSaTOneControlComp = mean(log(collapseLevelForAllControlComp))
%     stDevCollapseSaTOneControlComp = std(collapseLevelForAllControlComp)
%     stDevLnCollapseSaTOneControlComp = std(log(collapseLevelForAllControlComp))
    

% Save collapse results file
    % Go to the correct folder
        cd ..;
        cd Output;
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        
%     % Save results      
%         colFileName = ['DATA_collapse_CollapseSaAndStats.mat'];
% 
%         save(colFileName, 'analysisType', 'collapseLevelForAllComp', 'eqNumberLIST', 'meanCollapseSaTOneAllComp',...
%             'medianCollapseSaTOneAllComp', 'meanLnCollapseSaTOneAllComp', 'stDevCollapseSaTOneAllComp',...
%             'stDevLnCollapseSaTOneAllComp', 'eqCompNumberLIST')

    % Go back to the starting folder
        cd(startFolder);

% Do final plot details - figure for all components
        hold on
        grid on
        %titleText = sprintf('Incremental Dynamic Analysis, Single Component, %s', analysisType);
        %title(titleText);
        switch saDefType
            case 1
                hy = ylabel('Sa_{comp.}(T=1.0s) [g]');
            case 2
                hy = ylabel('Sa_{g.m.}(T=1.0s) [g]');
            case 3
                hy = ylabel('Sa_{code}(T=1.0s) [g]');
            otherwise
                error('Invalid value for saDefType!');
        end
            
            
            
            
        hx = xlabel('Maximum Interstory Drift Ratio');
        xlim([0, maxXOnAxis])
        FigureFormatScript_Movies
        hold off

% % Call another function to plot the empirical collapse CDF with fits...
% PlotCollapseEmpiricalCDFWithFits




