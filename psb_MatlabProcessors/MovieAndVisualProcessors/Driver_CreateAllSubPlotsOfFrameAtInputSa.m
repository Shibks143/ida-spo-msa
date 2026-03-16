%
% Procedure: Driver_CreateAllSubPlotsOfFrameAtInputSa.m
% -------------------
% This driver loops over a set of analysisType (with a parallel list of
% EQs).  For each analysisType it creates 2x2 scatter plots (as many as
% are needed to fit all of the results) showing the frame damage at the Sa
% value desired (so you can use it to show damage at the 2/50 event, etc.)
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
processorToUse = 1;%2;     % Decide which data processor to use (1 for recent models, 2 for older Banchmark models)
driftPlotOption = 2;    % (1 for undeformed, 2 for last time step, 3 for peak throughout TH)
isSaveFile = 0;         % Do not save a file for each individual frame of the scatterplot (but this does save each full scatterplot)
titleOption = 2;        % Use a shorter title
maxOnDemandCapacityRatioToPlot = 2.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.

% Define parallel lists for each analysisType
        analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm_grndDisp_Corot)_(AllVar)_(0.00)_(clough)'};
        modelNameLIST = {'DesA_Buffalo_v.9noGFrm_grndDisp_Corot'};
        bldgIDLIST = [1];
        saLevelLIST = [1.02];
        eqNumberLIST_forEachModel = { [11122] };

        %analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'};
        %modelNameLIST = {'DesA_Buffalo_v.9noGFrm'};
        %bldgIDLIST = [1];
        %saLevelLIST = [0.92];
        %eqNumberLIST_forEachModel = { [11011, 11012, 11021, 11022, 11031,
        %11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132, 11141, 11142, 11151, 11152, 11161, 11162, 11171, 11172, 11181, 11182, 11191, 11192, 11201, 11202, 11211, 11212, 11221, 11222, 11241, 11242, 11251, 11252, 11261, 11262, 11271, 11272, 11281, 11282, 11291, 11292, 11311, 11312, 11321, 11322] };
        
%         analysisTypeLIST = {'(DesID1_v.63)_(AllVar)_(Mean)_(clough)'};
%         modelNameLIST = {'DesID1_v.63'};
%         bldgIDLIST = [1];
%         saLevelLIST = [1.20];
%         eqNumberLIST_forEachModel = { [941051] };
        
%         analysisTypeLIST = {'(DesID1_v.63noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID3_v.9noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID5_v.2)_(AllVar)_(Mean)_(clough)', '(DesID6_v.4)_(AllVar)_(Mean)_(clough)', '(DesID9_v.3)_(AllVar)_(Mean)_(clough)', '(DesID9_v.3noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID10_v.3)_(AllVar)_(Mean)_(clough)', '(DesID11_v.1)_(AllVar)_(Mean)_(clough)', '(DesID1_v.63noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID3_v.9noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID5_v.2)_(AllVar)_(Mean)_(clough)', '(DesID6_v.4)_(AllVar)_(Mean)_(clough)', '(DesID9_v.3)_(AllVar)_(Mean)_(clough)', '(DesID9_v.3noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID10_v.3)_(AllVar)_(Mean)_(clough)', '(DesID11_v.1)_(AllVar)_(Mean)_(clough)'};
%         modelNameLIST = {'DesID1_v.63noGFrm', 'DesID3_v.9noGFrm', 'DesID5_v.2', 'DesID6_v.4', 'DesID9_v.3', 'DesID9_v.3noGFrm', 'DesID10_v.3', 'DesID11_v.1', 'DesID1_v.63noGFrm', 'DesID3_v.9noGFrm', 'DesID5_v.2', 'DesID6_v.4', 'DesID9_v.3', 'DesID9_v.3noGFrm', 'DesID10_v.3', 'DesID11_v.1'};
%         bldgIDLIST = [1, 3, 5, 6, 9, 9, 10, 11];
%         saLevelLIST = [0.82, 0.82, 0.82, 0.82, 0.82, 0.82, 0.82, 0.82, 1.20, 1.20, 1.20, 1.20, 1.20, 1.20, 1.20, 1.20];
%         eqNumberLIST_forEachModel = {   [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092], 
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092],
%                                         [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092] };
    
%         analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(0.40)_(clough)', '(DesA_Buffalo_v.9noGFrm_grndDisp)_(hingeStrBmF)_(0.60)_(clough)'};
%         modelNameLIST = {'DesA_Buffalo_v.9noGFrm_grndDisp', 'DesA_Buffalo_v.9noGFrm_grndDisp'};
%         bldgIDLIST = [1, 1];
%         saLevelLIST = [2.22, 2.58];
%         eqNumberLIST_forEachModel = { [941052], [941052] };
                                        
                                        
                                        
                                        
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
        saLevel = saLevelLIST(analysisTypeIndex);
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
            if(processorToUse == 1)
                % Use newer processor - tested and works!
                ProcSingleRun_NonCollapseStripeRun_GenFramesAndWalls_ForVisuals(bldgID, analysisType, modelName, saLevel, eqNumber);
            elseif(processorToUse == 2)
               % Use older processor for Benchmark report
                ProcSingleRun_NonCollapseStripeRun_OlderBenchmark_ForVisuals(bldgID, analysisType, modelName, saLevel, eqNumber);
            else
               error('Invalid value for processorToUse!')
            end
            figure(figureNumForThisEQ);
            subplot(2,2,scatterPlotIndexForThisEQ);
            DrawFrameWithMaxPHForEQ_withSaveOption(buildingInfo, bldgID, analysisType, eqNumber, saLevel, driftPlotOption, isSaveFile, titleOption, maxOnDemandCapacityRatioToPlot, saDefType);
        end; % end of EQ loop
        
        % Now save all of the scatterplot files
        idNum = 1;
        for figureNumForThisEQ = (startFigNum+1):(startFigNum+numScatterPlotsNeededForThisEQ)
            figure(figureNumForThisEQ);
            % Save the plots in this folder as a .fig and an .emf
            plotName = sprintf('ScatterPlotsAtGivenSa_%s_EQ_%d_Sa_%.2f_plot%d.fig', analysisType, eqNumber, saLevel, idNum);
            hgsave(plotName);
            % Export the plot as a .emf file (Matlab book page 455) - In this folder
            exportName = sprintf('ScatterPlotsAtGivenSa_%s_EQ_%d_Sa_%.2f_plot%d.emf', analysisType, eqNumber, saLevel, idNum);
            print('-dmeta', exportName);    
            
            idNum = idNum + 1;
        end; % end of saving loop

    end; % end of analysisType loop




