%
% Procedure: Driver_CreateAllSubPlotsOfFrameAtCol.m
% -------------------
% This driver loops over a set of analysisType (with a parallel list of
% EQs).  For each analysisType it creates 2x2 scatter plots (as many as
% are needed to fit all of the collapse results) showing the frame at the
% last time step at the Sa that first causes collapse.
% 
% Variable definitions:
%
%
% Assumptions and Notices: 
%
%
% Author: Curt Haselton 
% Date Written: 12-07-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some plotting options
saDefType = 2; %Type of SA definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef)
processorToUse = 1; %2;%1;     % Decide which data processor to use (1 for recent models, 2 for older Banchmark models)
driftPlotOption = 2;    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better)
isSaveFile = 0;         % Do not save a file for each individual frame of the scatterplot (but this does save each full scatterplot)
titleOption = 2;        % Use a shorter title
maxOnDemandCapacityRatioToPlot = 3.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.

% Define parallel lists for each analysisType
        analysisTypeLIST = {'(Arch_8story_ID1012_v58)_(AllVar)_(0.00)_(clough)'};
        modelNameLIST = {'Arch_8story_ID1012_v58'};
        bldgIDLIST = [1012];
        % Ground Motion Set C
        %eqNumberLIST_forEachModel = { [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712] };

        % temp
        eqNumberLIST_forEachModel = { [120111] };
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load some information
[buildingInfo] = DefineInfoForBuildings;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop over all analysisTypes and then for each analsyis type, create the
% appropriate scatter plots
    for analysisTypeIndex = 1:length(analysisTypeLIST)
        startFigNum = analysisTypeIndex * 100;      % Just start the figure numbers 100 apart for each analysis type so there is no overlap
        analysisType = analysisTypeLIST{analysisTypeIndex};
        modelName = modelNameLIST{analysisTypeIndex};
        bldgID = bldgIDLIST(analysisTypeIndex);
        eqNumberLIST = eqNumberLIST_forEachModel{analysisTypeIndex};

        % Find the number of scatterplots needed to pot everything from
        % this analysisType and EQLIST
        numScatterPlotsNeededForThisEQ = ceil(length(eqNumberLIST) / 4); % This just rounds to the next whole number
        
        % Now loop over the EQs and create the 2x2 scatter plots
        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex)
            % This EQ, select the figure number and scatter plot location
            % (based on the EQIndex)
            figureNumForThisEQ = startFigNum + ceil(eqIndex / 4)         % Ceil just rounds the value to the next whole number
            if(mod(eqIndex,4) == 0)
                scatterPlotIndexForThisEQ = 4
            else
                scatterPlotIndexForThisEQ = mod(eqIndex,4)     % Just finds the remainder after division
            end
            % Now create this plot in the correct scatterplot location for
            % this EQ
            [saAtCollapse, saLevelsForIDAPlotLIST] = FindAndReturnCollapseSaForEQ(analysisType, modelName, eqNumber);
            if(processorToUse == 1)
                % Use newer processor
                ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, saAtCollapse, eqNumber);
            elseif(processorToUse == 2)
               % Use older processor for Benchmark report
                ProcSingleRun_Collapse_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, saAtCollapse, eqNumber);
            else
               error('Invalid value for processorToUse!')
            end
            figure(figureNumForThisEQ);
            subplot(2,2,scatterPlotIndexForThisEQ);
            DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNumber, saAtCollapse, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType);
        end; % end of EQ loop
        
        % Now save all of the scatterplot files in the output folder
            % Go to folder
            startFolder = [pwd];
            cd ..;
            cd ..;
            cd Output
            cd(analysisType)
            cd Figures_CollapseFailureModePlots
        
            % Loop and save figures
            idNum = 1;
            for figureNumForThisEQ = (startFigNum+1):(startFigNum+numScatterPlotsNeededForThisEQ)
                figure(figureNumForThisEQ);
                % Save the plots in this folder as a .fig and an .emf
                plotName = sprintf('ScatterPlotsAtCollapeSa_%s_plot%d.fig', analysisType, idNum);
                hgsave(plotName);
                % Export the plot as a .emf file (Matlab book page 455) - In this folder
                exportName = sprintf('ScatterPlotsAtCollapeSa_%s_plot%d.emf', analysisType, idNum);
                print('-dmeta', exportName);    
            
                idNum = idNum + 1;
            end; % end of saving loop
        
            % Go back to initial folder
            cd(startFolder)

    end; % end of analysisType loop




