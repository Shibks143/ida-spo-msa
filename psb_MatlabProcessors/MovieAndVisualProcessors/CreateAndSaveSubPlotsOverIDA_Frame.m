%
% Procedure: CreateSubPlotsWithBuildingAndResponses_singleAnalysisStep_Frame.m
% -------------------
% This procedure creates a subplot for a single analysis step.  This plot shows the distorted building at the current analysis step, the max drift
%   levels up to this point in the EQ, and responses of two hinges showing
%   a dot for the current response point.  This makes 2 2x2 plots to show
%   all of the response.
%
% Variable definitions:
%           - Many variable definitions are defined in the
%           functions/procedures that this procedure calls.
%           - jointResponseToPlot_1 and _2 need to be vectors of the
%           [floorNum, colLineNum, jointNodeNum] for the joint response
%           plots that are to be used. 
%
% Assumptions and Notices: 
%       - NOTICE: This will NOT plot the response of the column base hinge
%       (b/c) I am using the joint data and I just haven't added the
%       feature yet to plot the column base hinge.
%
% Author: Curt Haselton 
% Date Written: 12-04-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[void] = CreateAndSaveSubPlotsOverIDA_Frame(buildingInfo, bldgID, analysisType, modelName, eqNumber, saDefType, processorToUse, driftPlotOption, isSaveFileForIndividualFrameOfScatterplot, titleOptionForDamagedBldgs, maxOnDemandCapacityRatioToPlot, startFigNum, subplotOption, colLineNum, floorNum, jointNodeNum)

% Set some plot options
    markerTypeLineForIDA = 'b-';
    markerTypeDotForIDA = 'bo';
    isPlotIndividualPointsForIDA = 1;

    maxXOnAxis = 15;    % 15% drift is the x-limit on the drift plot
    markerTypeForDriftPlot = 'b-';
    isHingesHighlighted = 0;        % No - don't highlight the hinges
    highlightedHingeColor_1 = 'k';  % Junk
    highlightedHingeColor_2 = 'k';  % Junk
    legendTextFontSize = 8;
    minSaValueToCallAnError = 30.0; % This is used to check for an error which occurs that causes one of the Sa values in the IDA plot list to be 100.0.
    
% Do some simple calcs.
    numStories = buildingInfo{bldgID}.numStories;
    firstFigNum = startFigNum;
    secondFigNum = startFigNum + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the collapse IDA
    figure(firstFigNum)
    subplot(2,2,1)
    PlotCollapseIDAs_SingleComp_ForVideosAndVisuals(buildingInfo, bldgID, analysisType, eqNumber, markerTypeLineForIDA, markerTypeDotForIDA, isPlotIndividualPointsForIDA, saDefType);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now get the collapse information and decide which 6 (or fewer) Sa levels
% to use for plotting
    % Get the saCollapse and saLevelsRun information
    [saAtCollapse, saLevelsForIDAPlotLIST] = FindAndReturnCollapseSaForEQ(analysisType, modelName, eqNumber);

    % Now decide which Sa levels to use for plotting this scatterplot.  If
    % there are 6 or less Sa levels run, then use all of them, otherwise we
    % will need to chose some
    if((length(saLevelsForIDAPlotLIST)) <= 6)
        % We will use all of the Sa levels (and there are =< 6)
        saLevelsUsedForThisScatterPlotLIST = saLevelsForIDAPlotLIST;
        numSaLevelsUsedForPlot = length(saLevelsUsedForThisScatterPlotLIST);     
    else
        % There are more than 6 Sa levels, so we need to decide which ones
        % to use...
        numSaLevelsInIDAPlotLIST = length(saLevelsForIDAPlotLIST);
        saLevelsUsedForThisScatterPlotLIST = zeros(1,6);
        % Use the first (which is the second in the list because the first
        % is a zero) and the last (at the collapse level).  Note that often
        % there is a slight error that causes the last value in the saLIST
        % to be about 100.0, so do a loop to be sure we don't select this
        % large Sa level.
            saLevelsUsedForThisScatterPlotLIST(1) = saLevelsForIDAPlotLIST(2);
            
            % Find highest Sa level beneath the value that is an error and
            % often near 100.0g.
            saIndexToFindCollapsePoint = numSaLevelsInIDAPlotLIST;
            while (1==1)
                currentSaLevel = saLevelsForIDAPlotLIST(saIndexToFindCollapsePoint);
                % Break is we found a value small enough
                if(currentSaLevel < minSaValueToCallAnError)
                   break; 
                end
                saIndexToFindCollapsePoint = saIndexToFindCollapsePoint - 1;
            end
            % This now should be the index for the highest Sa level below 100.0 (i.e. the
            % collapse Sa level)
            saLevelsUsedForThisScatterPlotLIST(6) = saLevelsForIDAPlotLIST(saIndexToFindCollapsePoint);

        % Now fill in (error on the higher levels of damage).  Note that
        % the "min" is just making sure we don't go beyond the end of the
        % second-to-last entry in the list.
            saLevelsUsedForThisScatterPlotLIST(2) = saLevelsForIDAPlotLIST(min((numSaLevelsInIDAPlotLIST-1), (1 + round((1/5) * numSaLevelsInIDAPlotLIST))));
            saLevelsUsedForThisScatterPlotLIST(3) = saLevelsForIDAPlotLIST(min((numSaLevelsInIDAPlotLIST-1), (1 + round((2/5) * numSaLevelsInIDAPlotLIST))));
            saLevelsUsedForThisScatterPlotLIST(4) = saLevelsForIDAPlotLIST(min((numSaLevelsInIDAPlotLIST-1), (1 + round((3/5) * numSaLevelsInIDAPlotLIST))));
            saLevelsUsedForThisScatterPlotLIST(5) = saLevelsForIDAPlotLIST(min((numSaLevelsInIDAPlotLIST-1), (1 + round((4/5) * numSaLevelsInIDAPlotLIST))));
            saLevelsUsedForThisScatterPlotLIST
    end
    
    % Sometimes if the length of saLevelsForIDAPlotLIST is just slightly
    % larger than 6, it will replicate the collapse point in locations 5
    % and 6 of saLevelsUsedForThisScatterPlotLIST.  Check if it did this,
    % and if it did just use the last five entries in
    % saLevelsUsedForThisScatterPlotLIST be the same as the last five entries before and including collapse in 
    % saLevelsForIDAPlotLIST
    if(saLevelsUsedForThisScatterPlotLIST(5) == saLevelsUsedForThisScatterPlotLIST(6))
       % We got the error, so make the change 
       disp('Fixing the Sa levels so they do not duplicate at the end...');
       saLevelsUsedForThisScatterPlotLIST(2:6) = saLevelsForIDAPlotLIST((saIndexToFindCollapsePoint-4):(saIndexToFindCollapsePoint));
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now that we have the information about what Sa levels we want to use,
% let's process each Sa level.  Loop for all Sa levels and process.
    for saIndex =1:length(saLevelsUsedForThisScatterPlotLIST)
        saLevel = saLevelsUsedForThisScatterPlotLIST(saIndex);
        if(processorToUse == 1)
            % Use newer processor
            ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, saLevel, eqNumber);
        elseif(processorToUse == 2)
            % Use older processor for Benchmark report
            ProcSingleRun_Collapse_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, saLevel, eqNumber);
        else
            error('Invalid value for processorToUse!')
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now that we have processed, loop over the Sa levels, open the files, and
% plot the max drift level for each Sa level.
    for saIndex =1:length(saLevelsUsedForThisScatterPlotLIST)
        saLevel = saLevelsUsedForThisScatterPlotLIST(saIndex);
        % Open the Matlab file created
            startingPath = [pwd];
            cd ..;
            cd ..;
            cd Output;
            cd(analysisType);
            eqFolder = sprintf('EQ_%d', eqNumber);
            saFolder = sprintf('Sa_%.2f', saLevel);
            cd(eqFolder);
            cd(saFolder);
            load('DATA_allDataForThisSingleRun.mat', 'storyDriftRatioToSave');
            cd(startingPath);
        % Call the function to plot the peak drift levels
        figure(firstFigNum)
        subplot(2,2,2);
        PlotMaxDriftLevel_bothPosAndNeg_withDriftsPassedIn(storyDriftRatioToSave, numStories, analysisType, saLevel, eqNumber, markerTypeForDriftPlot, maxXOnAxis);
        hold on
    end

    % Now make a legend for the drift plot
%     % Make part for the Sa
%     switch saDefType
%         case 1
%             saPartOfTitle = 'Sa_{comp}';
%         case 2
%             saPartOfTitle = 'Sa_{g.m.}';
%         case 3
%             saPartOfTitle = 'Sa_{code}';
%         otherwise
%             error('Invalid value for saDefType');
%     end
    % Make legend entries
    for saIndex = 1:length(saLevelsUsedForThisScatterPlotLIST)
        saLevel = saLevelsUsedForThisScatterPlotLIST(saIndex);    
        % Make legend entry
        currentLegendEntry = sprintf('%.2fg', saLevel);
        legendVECTOR{saIndex} = currentLegendEntry;
    end
    % Make legend
    legh = legend(legendVECTOR);
    set(legh, 'FontSize', legendTextFontSize);

    
    hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now loop and plot all damages buildings for the Sa levels in
% saLevelsUsedForThisScatterPlotLIST
    for saIndex = 1:length(saLevelsUsedForThisScatterPlotLIST)
        saLevel = saLevelsUsedForThisScatterPlotLIST(saIndex);    
        % Find the figure and subplot location needed for this current
        % plot.  
        switch saIndex
            case 1
                figure(firstFigNum)
                subplot(2,2,3)
            case 2
                figure(firstFigNum)
                subplot(2,2,4)
            case 3
                figure(secondFigNum)
                subplot(2,2,1)         
            case 4
                figure(secondFigNum)
                subplot(2,2,2)                
            case 5
                figure(secondFigNum)
                subplot(2,2,3)
            case 6
                figure(secondFigNum)
                subplot(2,2,4)                
            otherwise
                error('Invalid value fror saIndex!')
        end

        
        switch subplotOption
            case 1
                % Plot the damaged bldg. for this Sa level with the maximum
                % PHRs for the full EQ
                DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNumber, saLevel, driftPlotOption, isSaveFileForIndividualFrameOfScatterplot, titleOptionForDamagedBldgs, maxOnDemandCapacityRatioToPlot, saDefType)
            case 2
                % Plot the PH response if we use this option, we need to
                % open the data file here.
                PlotResponsesOverIDA_SubFile;   % Call this file just to make this script cleaner
            case 3
                % Plot the PH response if we use this option, we need to
                % open the data file here.
                PlotResponsesOverIDA_SubFile;   % Call this file just to make this script cleaner                
            case 4
                % Plot the PH response if we use this option, we need to
                % open the data file here.
                PlotResponsesOverIDA_SubFile;   % Call this file just to make this script cleaner
        otherwise
                error('Invalid value for subplotOption!')
        end
     
                
                
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %     DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisType, eqNum, saLevel, isHingesHighlighted, jointResponseToPlot_1, jointResponseToPlot_2, highlightedHingeColor_1, highlightedHingeColor_2, maxOnDemandCapacityRatioToPlot, saDefType);






    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot the deformed building
%     subplot(2,2,1)
%     DrawDistortedFrame(buildingInfo, bldgID, floorDispVECTOR, plasticRotationARRAY, analysisType, eqNum, saLevel, isHingesHighlighted, jointResponseToPlot_1, jointResponseToPlot_2, highlightedHingeColor_1, highlightedHingeColor_2, maxOnDemandCapacityRatioToPlot, saDefType);
%    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot the drift level
%     subplot(2,2,2)
%     PlotGivenDriftLevel_bothPosAndNeg_withDriftsPassedIn(storyDriftRatio_Neg, storyDriftRatio_Pos, numStories, analysisType, saLevel, eqNum, markerTypeForDriftPlot, maxXOnAxis);
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot the first hinge
%     subplot(2,2,3)
%     floorNum = jointResponseToPlot_1(1);
%     colLineNum = jointResponseToPlot_1(2);
%     jointNodeNum = jointResponseToPlot_1(3);
%     DrawJointResponseWithDot(buildingInfo, bldgID, analysisType, eqNum, saLevel, colLineNum, floorNum, jointNodeNum, elementArray, currentAnalysisStepNum, markerTypeForJointResponse, highlightedHingeColor_1);
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot the first hinge
%     subplot(2,2,4)
%     floorNum = jointResponseToPlot_2(1);
%     colLineNum = jointResponseToPlot_2(2);
%     jointNodeNum = jointResponseToPlot_2(3);
%     DrawJointResponseWithDot(buildingInfo, bldgID, analysisType, eqNum, saLevel, colLineNum, floorNum, jointNodeNum, elementArray, currentAnalysisStepNum, markerTypeForJointResponse, highlightedHingeColor_2);
%         



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save figure files

        figIdNum1 = 1;
        figIdNum2 = 2;
                
        switch subplotOption
            case 1
                % Damage of frame over IDA (i.e. plots of damaged frame)
                plotName1 = sprintf('ScatterPlotsOverIDA_%s_EQ_%d_plot%d.fig', analysisType, eqNumber, figIdNum1);
                plotName2 = sprintf('ScatterPlotsOverIDA_%s_EQ_%d_plot%d.fig', analysisType, eqNumber, figIdNum2);
                exportName1 = sprintf('ScatterPlotsOverIDA_%s_EQ_%d_plot%d.emf', analysisType, eqNumber, figIdNum1);
                exportName2 = sprintf('ScatterPlotsOverIDA_%s_EQ_%d_plot%d.emf', analysisType, eqNumber, figIdNum2);
            case 2
                % Column
                plotName1 = sprintf('ScatterPlotsOverIDA_ColumnResponse_%s_EQ_%d_plot%d.fig', analysisType, eqNumber, figIdNum1);
                plotName2 = sprintf('ScatterPlotsOverIDA_ColumnResponse_%s_EQ_%d_plot%d.fig', analysisType, eqNumber, figIdNum2);
                exportName1 = sprintf('ScatterPlotsOverIDA_ColumnResponse_%s_EQ_%d_plot%d.emf', analysisType, eqNumber, figIdNum1);
                exportName2 = sprintf('ScatterPlotsOverIDA_ColumnResponse_%s_EQ_%d_plot%d.emf', analysisType, eqNumber, figIdNum2);
            case 3
                % Beam
                plotName1 = sprintf('ScatterPlotsOverIDA_BeamResponse_%s_EQ_%d_plot%d.fig', analysisType, eqNumber, figIdNum1);
                plotName2 = sprintf('ScatterPlotsOverIDA_BeamResponse_%s_EQ_%d_plot%d.fig', analysisType, eqNumber, figIdNum2);
                exportName1 = sprintf('ScatterPlotsOverIDA_BeamResponse_%s_EQ_%d_plot%d.emf', analysisType, eqNumber, figIdNum1);
                exportName2 = sprintf('ScatterPlotsOverIDA_BeamResponse_%s_EQ_%d_plot%d.emf', analysisType, eqNumber, figIdNum2);
            case 4
                % Joint
                plotName1 = sprintf('ScatterPlotsOverIDA_JointResponse_%s_EQ_%d_plot%d.fig', analysisType, eqNumber, figIdNum1);
                plotName2 = sprintf('ScatterPlotsOverIDA_JointResponse_%s_EQ_%d_plot%d.fig', analysisType, eqNumber, figIdNum2);
                exportName1 = sprintf('ScatterPlotsOverIDA_JointResponse_%s_EQ_%d_plot%d.emf', analysisType, eqNumber, figIdNum1);
                exportName2 = sprintf('ScatterPlotsOverIDA_JointResponse_%s_EQ_%d_plot%d.emf', analysisType, eqNumber, figIdNum2);
        otherwise
                error('Invalid value for subplotOption!')
        end

    % Now save the first scatterplot file
        figure(firstFigNum);
        % Save the plots in this folder as a .fig and an .emf
        hgsave(plotName1);
        % Export the plot as a .emf file (Matlab book page 455) - In this folder
        print('-dmeta', exportName1);    
    % Now save the second scatterplot file
        figure(secondFigNum);
        % Save the plots in this folder as a .fig and an .emf
        hgsave(plotName2);
        % Export the plot as a .emf file (Matlab book page 455) - In this folder
        print('-dmeta', exportName2);    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






