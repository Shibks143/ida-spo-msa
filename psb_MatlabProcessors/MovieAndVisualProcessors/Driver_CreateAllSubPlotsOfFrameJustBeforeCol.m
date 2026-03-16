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
driftPlotOption = 3     % Plot the absolute value of the peak drift throughout the TH in each floor
isSaveFile = 0;         % Do not save a file for each individual frame of the scatterplot (but this does save each full scatterplot)
titleOption = 2;        % Use a shorter title
maxOnDemandCapacityRatioToPlot = 999.0;   % Do not limit the demand/capacity ratio becuase we are plotting the distorted shape before collapse.

% Define parallel lists for each analysisType
        %analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'};
        %modelNameLIST = {'DesA_Buffalo_v.9noGFrm'};
        %bldgIDLIST = [1];
        %eqNumberLIST_forEachModel = { [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132, 11141, 11142, 11151, 11152, 11161, 11162, 11171, 11172, 11181, 11182, 11191, 11192, 11201, 11202, 11211, 11212, 11221, 11222, 11241, 11242, 11251, 11252, 11261, 11262, 11271, 11272, 11281, 11282, 11291, 11292, 11311, 11312, 11321, 11322] };

        analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(0.20)_(clough)', '(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(0.40)_(clough)', '(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(0.60)_(clough)', '(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(0.80)_(clough)', '(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(1.00)_(clough)', '(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(1.20)_(clough)', '(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(1.50)_(clough)', '(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(1.80)_(clough)'};
        modelNameLIST = {'DesA_Buffalo_v.9noGFrm_grndDisp', 'DesA_Buffalo_v.9noGFrm_grndDisp', 'DesA_Buffalo_v.9noGFrm_grndDisp', 'DesA_Buffalo_v.9noGFrm_grndDisp', 'DesA_Buffalo_v.9noGFrm_grndDisp', 'DesA_Buffalo_v.9noGFrm_grndDisp', 'DesA_Buffalo_v.9noGFrm_grndDisp', 'DesA_Buffalo_v.9noGFrm_grndDisp'};
        bldgIDLIST = [1, 1, 1, 1, 1, 1, 1, 1];
        eqNumberLIST_forEachModel = {   [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072],
                                        [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072],
                                        [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072],
                                        [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072],
                                        [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072],
                                        [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072],
                                        [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072],
                                        [941002, 941012, 941022, 941032, 941042, 941051, 941062, 941072]};
        
        %analysisTypeLIST = {'(DesID3_v.10)_(AllVar)_(0.00)_(clough)'};
        %modelNameLIST = {'DesID3_v.10'};
        %bldgIDLIST = [1];
        %eqNumberLIST_forEachModel = { [941052] }; %{ [941001] };
        
%         analysisTypeLIST = {'(DesID1_v.64noGFrm)_(AllVar)_(0.00)_(clough)', '(DesID1_v.64noGFrm)_(AllVar)_(0.00)_(clough)', '(DesID1_v.64)_(AllVar)_(0.00)_(clough)', '(DesID3_v.10)_(AllVar)_(0.00)_(clough)', '(DesID5_v.3)_(AllVar)_(0.00)_(clough)', '(DesID6_v.5)_(AllVar)_(0.00)_(clough)', '(DesID9_v.4)_(AllVar)_(0.00)_(clough)', '(DesID9_v.4noGFrm)_(AllVar)_(0.00)_(clough)', '(DesID10_v.4)_(AllVar)_(0.00)_(clough)', '(DesID11_v.2)_(AllVar)_(0.00)_(clough)'};
%         modelNameLIST = {'DesID1_v.64noGFrm', 'DesID1_v.64noGFrm', 'DesID1_v.64', 'DesID3_v.10', 'DesID5_v.3', 'DesID6_v.5', 'DesID9_v.4', 'DesID9_v.4noGFrm', 'DesID10_v.4', 'DesID11_v.2'};
%         bldgIDLIST = [1, 1, 1, 3, 5, 6, 9, 9, 10, 11];
%         eqNumberLIST_forEachModel = {   [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [943001, 943002, 943011, 943012, 943021, 943022, 943031, 943032, 943041, 943042, 943051, 943052, 943061, 943062, 943071, 943072, 943081, 943082, 943091, 943092, 943101, 943102, 943111, 943112, 943121, 943122, 943131, 943132, 943141, 943142, 943151, 943152, 943161, 943162, 943171, 943172, 943181, 943182, 943191, 943192, 943201, 943202, 943211, 943212, 943221, 943222, 943231, 943232, 943241, 943242, 943251, 943252],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092] };
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Lists to pick from...
        %% Full list of Bin 4A
        %eqNumberLIST = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092];
        %% Bin 4AEXTRA (4C) - all records
        %eqNumberLIST = [943001, 943002, 943011, 943012, 943021, 943022, 943031, 943032, 943041, 943042, 943051, 943052, 943061, 943062, 943071, 943072, 943081, 943082, 943091, 943092, 943101, 943102, 943111, 943112, 943121, 943122, 943131, 943132, 943141, 943142, 943151, 943152, 943161, 943162, 943171, 943172, 943181, 943182, 943191, 943192, 943201, 943202, 943211, 943212, 943221, 943222, 943231, 943232, 943241, 943242, 943251, 943252];
   
        %%%% ATC-63 FULL Set A (record 23 and 30 excluded)
        %eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132, 11141, 11142, 11151, 11152, 11161, 11162, 11171, 11172, 11181, 11182, 11191, 11192, 11201, 11202, 11211, 11212, 11221, 11222, 11241, 11242, 11251, 11252, 11261, 11262, 11271, 11272, 11281, 11282, 11291, 11292, 11311, 11312, 11321, 11322];
        %%% ATC-63 part of Set A that are PEER records
        %eqNumberLIST = [11011, 11012, 11021, 11022, 11031, 11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132];
        %%%% ATC-63 part of Set A that are PEER-NGA records
        %eqNumberLIST = [11141, 11142, 11151, 11152, 11161, 11162, 11171, 11172, 11181, 11182, 11191, 11192, 11201, 11202, 11211, 11212, 11221, 11222, 11241, 11242, 11251, 11252, 11261, 11262, 11271, 11272, 11281, 11282, 11291, 11292, 11311, 11312, 11321, 11322];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
                % Now do not plot the building for an Sa level above
                % collapse.  Plot it for the Sa level just before collapse.
                %  To do this, find the Sa at collapse and then loop over
                %  all Sa levels and find the highest Sa before collapse
                %  and use that.
                % Find Sa at collapse and Sa levels run
                [saAtCollapse, saLevelsForIDAPlotLIST] = FindAndReturnCollapseSaForEQ(analysisType, modelName, eqNumber);
                % Find highest Sa before collapse
                highestSaBeforeCollapse = 0;
                for saIndex = 1:length(saLevelsForIDAPlotLIST)
                    currentSa = saLevelsForIDAPlotLIST(saIndex);
                    if((currentSa < saAtCollapse) && (currentSa > highestSaBeforeCollapse))
                        highestSaBeforeCollapse = currentSa;
                    end
                end
                
                saAtCollapse
                saLevelsForIDAPlotLIST
                highestSaBeforeCollapse

            if(processorToUse == 1)
                % Use newer processor
                ProcSingleRun_Collapse_GeneralFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, highestSaBeforeCollapse, eqNumber);
            elseif(processorToUse == 2)
               % Use older processor for Benchmark report
                ProcSingleRun_Collapse_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, highestSaBeforeCollapse, eqNumber);
            else
               error('Invalid value for processorToUse!')
            end
            figure(figureNumForThisEQ);
            subplot(2,2,scatterPlotIndexForThisEQ);
            DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNumber, highestSaBeforeCollapse, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType);
       
            clear saLevelsForIDAPlotLIST;
        end; % end of EQ loop
        
        % Now save all of the scatterplot files
        idNum = 1;
        for figureNumForThisEQ = (startFigNum+1):(startFigNum+numScatterPlotsNeededForThisEQ)
            figure(figureNumForThisEQ);
            % Save the plots in this folder as a .fig and an .emf
            plotName = sprintf('ScatterPlotsJustBeforeCollapeSa_%s_plot%d.fig', analysisType, idNum);
            hgsave(plotName);
            % Export the plot as a .emf file (Matlab book page 455) - In this folder
            exportName = sprintf('ScatterPlotsJustBeforeCollapeSa_%s_plot%d.emf', analysisType, idNum);
            print('-dmeta', exportName);    
            
            idNum = idNum + 1;
        end; % end of saving loop

    end; % end of analysisType loop




