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
saDefType = 1; %Type of SA definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef)
processorToUse = 1;     % Decide which data processor to use (1 for recent models, 2 for older Banchmark models)
driftPlotOption = 2;    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better)
isSaveFile = 0;         % Do not save a file for each individual frame of the scatterplot (but this does save each full scatterplot)
titleOption = 2;        % Use a shorter title
maxOnDemandCapacityRatioToPlot = 8.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.

% Define parallel lists for each analysisType
        analysisTypeLIST = {'(DesWA_ATC63_v.26)_(AllVar)_(0.00)_(nonlinearBeamColumn)'};
        modelNameLIST = {'DesWA_ATC63_v.26'};
        bldgIDLIST = [1000];
        eqNumberLIST_forEachModel = { [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132, 11141, 11142, 11151, 11152, 11161, 11162, 11171, 11172, 11181, 11182, 11191, 11192, 11201, 11202, 11211, 11212, 11221, 11222, 11241, 11242, 11251, 11252, 11261, 11262, 11271, 11272, 11281, 11282, 11291, 11292, 11311, 11312, 11321, 11322] };
        
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
                error('Invalid value of processorToUse for wall models!!!');
                %ProcSingleRun_Collapse_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, saAtCollapse, eqNumber);
            else
               error('Invalid value for processorToUse!')
            end
            figure(figureNumForThisEQ);
            subplot(2,2,scatterPlotIndexForThisEQ);
            DrawWallWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNumber, saAtCollapse, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType);
        end; % end of EQ loop
        
        % Now save all of the scatterplot files
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

    end; % end of analysisType loop




