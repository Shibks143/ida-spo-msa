%
% Procedure: psb_CreatePlotOfFrameAtSpecifiedSa_proc.m
% -------------------
% Similar to psb_CreateAllSubPlotsOfFrameAtCol_proc.m, but this draws the distorted frame for a single Sa value.
% 
% Variable definitions:
%
% Assumptions and Notices: 
%
% Author: Prakash S Badal
% Date Written: 04-03-18
%
% Sources of Code: CreateAllSubPlotsOfFrameAtCol_proc by CBH
%
% Functions and Procedures called: none
%
% Units: kN, mm, radians
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[void] = psb_CreatePlotOfFrameAtSpecifiedSa_proc(analysisTypeLIST, modelNameLIST, bldgID, eqNumberLIST, saVal)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some plotting options
saDefType = 2; %Type of SA definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef)
processorToUse = 1; %2;%1;     % Decide which data processor to use (1 for recent models, 2 for older Banchmark models)
driftPlotOption = 2;    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better)
isSaveFile = 0;         % Do not save a file for each individual frame of the scatterplot (but this does save each full scatterplot)
titleOption = 2;        % Use a shorter title
maxOnDemandCapacityRatioToPlot = 2.5;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse. changed to 2.5 (5-7-18, PSB)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load some information
[buildingInfo] = psb_DefineInfoForBuildings;
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
%             figureNumForThisEQ = startFigNum + ceil(eqIndex / 4)         % Ceil just rounds the value to the next whole number
            figureNumForThisEQ = startFigNum + eqIndex;
%             if(mod(eqIndex,4) == 0)
%                 scatterPlotIndexForThisEQ = 4
%             else
%                 scatterPlotIndexForThisEQ = mod(eqIndex,4)     % Just finds the remainder after division
%             end
            
            
            % Now create this plot in the correct scatterplot location for
            % this EQ
                % Now do not plot the building for an Sa level above
                % collapse.  Plot it for the Sa level just before collapse.
                %  To do this, find the Sa at collapse and then loop over
                %  all Sa levels and find the highest Sa before collapse
                %  and use that.
                % Find Sa at collapse and Sa levels run

    %% not needed for this module, since we are now providing the value of Sa for which the deformed shape is required to be plotted.
%                 [saAtCollapse, saLevelsForIDAPlotLIST] = FindAndReturnCollapseSaForEQ(analysisType, modelName, eqNumber);
%                 % Find highest Sa before collapse
%                 highestSaBeforeCollapse = 0;
%                 for saIndex = 1:length(saLevelsForIDAPlotLIST)
%                     currentSa = saLevelsForIDAPlotLIST(saIndex);
%                     if((currentSa < saAtCollapse) && (currentSa > highestSaBeforeCollapse))
%                         highestSaBeforeCollapse = currentSa;
%                     end
%                 end
%                 saAtCollapse
%                 saLevelsForIDAPlotLIST
%                 highestSaBeforeCollapse
                saVal
                
            if(processorToUse == 1)
                % Use newer processor
                
                % JASON/BRIAN - you can comment this out when just
                % reprocessing! (CBH 8-3-06)
%                 ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, highestSaBeforeCollapse, eqNumber);
                ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, saVal, eqNumber);
                
            elseif(processorToUse == 2)
               % Use older processor for Benchmark report
%                 ProcSingleRun_Collapse_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, highestSaBeforeCollapse, eqNumber);
                ProcSingleRun_Collapse_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, saVal, eqNumber);
            else
               error('Invalid value for processorToUse!')
            end
            figure(figureNumForThisEQ);
%             subplot(2,2,scatterPlotIndexForThisEQ);
%             disp(buildingInfo{2225}.numBays)
%             psb_DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNumber, highestSaBeforeCollapse, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType);
            psb_DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNumber, saVal, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType);
            
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
                % plotName = sprintf('ScatterPlotsAt_%.2fg_%i_%s_plot%d.fig', saVal, eqNumber, analysisType, idNum);
                plotName = sprintf('ScatterPlotsAt_%.2fg_%i_%s.fig', saVal, eqNumber, analysisType);
                hgsave(plotName);
                % Export the plot as a .emf file (Matlab book page 455) - In this folder
                % exportName = sprintf('ScatterPlotsAt_%.2fg_%i_%s_plot%d.emf', saVal, eqNumber, analysisType, idNum);
                exportName = sprintf('ScatterPlotsAt_%.2fg_%i_%s.emf', saVal, eqNumber, analysisType);
                print('-dmeta', exportName);   
                
                fprintf('File saved in %s \n', pwd);
                close;
            
                idNum = idNum + 1;
            end; % end of saving loop
        
            % Go back to initial folder
            cd(startFolder)

    end; % end of analysisType loop




