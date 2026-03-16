% Procedure: ProcessAndPlotPushoverAnalyses_proc.m
% -------------------
%   This is a procedure to process all plot the monotonic and cyclic pushover analyses.
%
% Author: Curt Haselton 
% Date Written: 6-29-06
% -------------------
function [plotArrayAndBaseShearArray, mu_T] = ProcessAndPlotPushoverAnalyses_proc(analysisType_forPO, isProcessPOAnalysis, poModelType, saTOneForRun_PO, eqNumber_PO, isPlotPO, ...
    plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO, isPlotStoryPO, storyNumLIST, isPlotPOMaxDriftLevel, determinePeriodBasedDuctility, SPO_index)

if nargin == 14
    SPO_index = -999;
end
% on many occasions, I call this function with single expected output. Doing so will return only plotArrayAndBaseShearArraym, which is acceptable behavior. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing and plotting

    % Process PO analysis
    if(isProcessPOAnalysis == 1)
        % NOTICE: I could generalize this to use the same processor for both model types, but I didn't take the time to do it
        if(poModelType == 1)
            % Process with nlBmCol/dispBmCol processor
            ProcSingleRun_Generalized_NlBmCol_PO_Full(analysisType_forPO, saTOneForRun_PO, eqNumber_PO); 
        elseif(poModelType == 2)
            % Process with lumped plasticity processor
            processStoryPO = isPlotStoryPO; % i.e. if we want to plot it, then process it.
            ProcSingleRun_Generalized_LumpPla_PO_Full_simpleAvoidErrors(analysisType_forPO, saTOneForRun_PO, eqNumber_PO, processStoryPO, [], SPO_index);
        else
            error('Invalid value of poModelType!');
        end
        disp('Process Pushover - DONE')
    end

    % Set a dummy figure number to start
    figNum = 10;
    
    % Plot PO
    if(isPlotPO == 1)
        figure(figNum);
    %   plotArrayAndBaseShearArray = PlotPushover(analysisType_forPO, eqNumber_PO, saTOneForRun_PO, plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO, determinePeriodBasedDuctility);
        [plotArrayAndBaseShearArray, mu_T] = PlotPushover(analysisType_forPO, eqNumber_PO, saTOneForRun_PO, plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO, determinePeriodBasedDuctility, SPO_index);
        % on many occasions, I call this function with single expected output. Doing so will return only plotArrayAndBaseShearArraym, which is acceptable behavior. 
        disp('Plot Pushover - DONE')
        figNum = figNum + 1;
    end


    % Plot story PO
    if(isPlotStoryPO == 1)
        for storyIndex = 1:length(storyNumLIST)
            storyNum = storyNumLIST(storyIndex);
            figure(figNum);
            PlotStoryPushover(storyNum, analysisType_forPO, eqNumber_PO, saTOneForRun_PO, plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO);
            disp('Plot Story Pushover versus story shear - DONE')
            figNum = figNum + 1;

            figure(figNum);
            PlotStoryPushover_vsBaseShear(storyNum, analysisType_forPO, eqNumber_PO, saTOneForRun_PO, plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO);
            disp('Plot Story Pushover versus base shear - DONE')
            figNum = figNum + 1;
        end
    end
    
    % Plot PO max. drift level
    if(isPlotPOMaxDriftLevel == 1)
        figure(figNum);
        PlotMaxDriftLevel_justPosDrifts(analysisType_forPO, saTOneForRun_PO, eqNumber_PO, markerType_PO, [], SPO_index);
       % PlotMaxDriftLevel_bothPosAndNeg(analysisType_forPO, saTOneForRun_PO, eqNumber_PO, markerType_PO);
        disp('Plot Maximum Story Drift Level in Pushover - DONE')
        figNum = figNum + 1;

      
        % Change folder and save Max InterStory Drift ratio (needs to be moved to PlotMaxDriftLevel_)
        % Save as .emf (Enhanced Metafile)
        fnameEmf = fullfile('..', 'Output', '(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)', sprintf('POMaxDrift_SPO_%i.emf', SPO_index));
        print(gcf, '-dmeta', fnameEmf);
        disp(['Saved: ', fnameEmf]);
        
        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  