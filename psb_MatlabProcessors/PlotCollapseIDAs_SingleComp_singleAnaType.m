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
function[void] = PlotCollapseIDAs_SingleComp_singleAnaType(analysisType, eqNumberLIST, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This does collapse IDAs for a single analysisType
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize a vector - twice as long as the eqNumerLIST b/c I do two comp. per EQ
eqCompNumberLIST = eqNumberLIST; 
collapseLevelForAllComp = zeros(1,(length(eqCompNumberLIST)));   
eqCompInd = 1;

% Input what max drift value you want on X axis for the plot
maxXOnAxis = 0.15; %0.30;
figureNumAllComp = 1;         

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);

    
    %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    eqCompNumber = eqNumber;    % Must have passed in the component number

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
        figure(figureNumAllComp);
        plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1, markerTypeLine);
        
        % Plot the points for each run, if told to
        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
                hold on
                plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot);
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
            collapseLevelForAllComp(eqInd) = collapseLevelCompOne;

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
    


% Do collapse statistics - for all components
    analysisType
    meanCollapseSaTOneAllComp = mean(collapseLevelForAllComp);
    medianCollapseSaTOneAllComp = (median(collapseLevelForAllComp))
    meanLnCollapseSaTOneAllComp = mean(log(collapseLevelForAllComp))
    stDevCollapseSaTOneAllComp = std(collapseLevelForAllComp)
    stDevLnCollapseSaTOneAllComp = std(log(collapseLevelForAllComp))
    
    % Make a dulpicate copy called "chosen comp" because some processors
    % use an older naming scheme.
    meanCollapseSaTOneChosenComp = mean(collapseLevelForAllComp);
    medianCollapseSaTOneChosenComp = (median(collapseLevelForAllComp))
    meanLnCollapseSaTOneChosenComp = mean(log(collapseLevelForAllComp))
    stDevCollapseSaTOneChosenComp = std(collapseLevelForAllComp)
    stDevLnCollapseSaTOneChosenComp = std(log(collapseLevelForAllComp))
    
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
        analysisTypeFolderPath = [pwd];
        
    % Save results      
        colFileName = ['DATA_collapse_CollapseSaAndStats.mat'];

        collapseLevelForChosenComp = collapseLevelForAllComp;   % Just renaming so processors will work
        save(colFileName, 'analysisType', 'collapseLevelForAllComp', 'eqNumberLIST', 'meanCollapseSaTOneAllComp',...
            'medianCollapseSaTOneAllComp', 'meanLnCollapseSaTOneAllComp', 'stDevCollapseSaTOneAllComp',...
            'stDevLnCollapseSaTOneAllComp', 'eqCompNumberLIST', 'collapseLevelForChosenComp', 'meanCollapseSaTOneChosenComp',...
            'medianCollapseSaTOneChosenComp', 'meanLnCollapseSaTOneChosenComp', 'stDevCollapseSaTOneChosenComp',...
            'stDevLnCollapseSaTOneChosenComp')

    % Go back to the MatlabProcessor folder
        cd ..;
        cd ..;
        cd MatlabProcessors;
        matlabProccessorFolderPath = [pwd];

% Do final plot details - figure for all components
        figure(figureNumAllComp);
        hold on
        grid on
        titleText = sprintf('Incremental Dynamic Analysis, Single Component, %s', analysisType);
        title(titleText);
        hy = ylabel('Sa (T=1.0s) [g]');
        hx = xlabel('Maximum Interstory Drift Ratio');
        xlim([0, maxXOnAxis])
        FigureFormatScript
        
        % Save the figure in correect output folder and then go back to
        % Matlab processor folder
            % Go to folder
            cd(analysisTypeFolderPath);
        
            % Save the figure
            plotName = sprintf('CollapseIDA_SingleComp_%s.fig', analysisType);
            hgsave(plotName);
            % Export the plot as a .emf file (Matlab book page 455) - THIS folder
            exportName = sprintf('CollapseIDA_SingleComp_%s.emf', analysisType);
            print('-dmeta', exportName);        
            
            % Back to matlab processor folder
            cd(matlabProccessorFolderPath);
        
        hold off



