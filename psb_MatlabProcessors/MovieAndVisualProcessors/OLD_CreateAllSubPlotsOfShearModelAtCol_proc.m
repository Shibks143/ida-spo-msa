%
% Procedure: CreateAllSubPlotsOfShearModelAtCol_proc.m
% -------------------
% Same as CreateAllSubPlotsOfFrameAtCol.m, but made to plot driuft
% diagrams.
% 
% Variable definitions:
%
% Assumptions and Notices: 
%
% Author: Curt Haselton 
% Date Written: 9-3=-8
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Units: kips and inches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[void] = CreateAllSubPlotsOfShearModelAtCol_proc(analysisTypeLIST, modelNameLIST, bldgID, eqNumberLIST)

disp('Creating shear model subplots at collapse...')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some plotting options
saDefType = 2; %Type of SA definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef)
processorToUse = 1; %2;%1;     % Decide which data processor to use (1 for recent models, 2 for older Banchmark models)
driftPlotOption = 2;    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better)
isSaveFile = 0;         % Do not save a file for each individual frame of the scatterplot (but this does save each full scatterplot)
titleOption = 2;        % Use a shorter title
maxOnDemandCapacityRatioToPlot = 3.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load some information
%[buildingInfo] = DefineInfoForBuildings;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop over all analysisTypes and then for each analsyis type, create the
% appropriate scatter plots
    for analysisTypeIndex = 1:length(analysisTypeLIST)
        startFigNum = analysisTypeIndex * 100;      % Just start the figure numbers 100 apart for each analysis type so there is no overlap
        analysisType = analysisTypeLIST{analysisTypeIndex};
        modelName = modelNameLIST{analysisTypeIndex};
        %bldgID = bldgIDLIST(analysisTypeIndex);
        %eqNumberLIST = eqNumberLIST_forEachModel{analysisTypeIndex};

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
                
                
                
                % JASON/BRIAN - you can comment this out when just
                % reprocessing! (CBH 8-3-06)
                
                % Commented out on 9-3-08, assuming that we do not need it!
                %ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, saAtCollapse, eqNumber);
                
                
                
                
                
            elseif(processorToUse == 2)
               % Use older processor for Benchmark report
                ProcSingleRun_Collapse_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, saAtCollapse, eqNumber);
            else
               error('Invalid value for processorToUse!')
            end
            figure(figureNumForThisEQ);
            subplot(2,2,scatterPlotIndexForThisEQ);
            
            % Old function to draw the frame - commented out on 9-3-08
            %DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNumber, saAtCollapse, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType);
            
            % Call the new function to plot the drifts over height (added
            % 9-3-08 - THIS HAS NOT BEEN TESTED AS OF THIS DATE)
            cd ..;
            PlotMaxDriftLevel_bothPosAndNeg(analysisType, saAtCollapse, eqNumber, 'b-');
            cd MovieAndVisualProcessors
            
        end; % end of EQ loop
        
        % Now save all of the scatterplot files in the output folder
            % Go to folder
            startFolder = [pwd];
            cd ..;
            cd ..;
            cd Output
            cd(analysisType)
            %cd Figures_CollapseFailureModePlots
        
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
                
                close;
            
                idNum = idNum + 1;
            end; % end of saving loop
        
            % Go back to initial folder
            cd(startFolder)

    end; % end of analysisType loop




