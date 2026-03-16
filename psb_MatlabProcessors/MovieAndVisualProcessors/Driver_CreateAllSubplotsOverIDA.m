%
% Procedure: Driver_CreateAllSubplotsOverIDA.m
% -------------------
% This driver loops over a set of analysisType (with a parallel list of
% EQs).  FOr each EQ it creates a subplot diagram showing the IDA, how the
% drifts increase over the IDA, and six damaged buildings over the IDA (to
% show how damage accumulates).
% 
% Variable definitions:
%
%
% Assumptions and Notices: 
%       NOTICE: The titles on the figures say that we are using
%       Sa(1.0sec.), so I will need to change this for future models).
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
saDefType = 1; %Type of Sa definition we want to put on the titles (=1 for Sa,comp, =2 for Sa,geoMean, =3 for Sa,codeDef)
processorToUse = 2;%1;     % Decide which data processor to use (1 for recent models, 2 for older Banchmark models)
driftPlotOption = 1;    % Plot the building non-deformed
isSaveFileForIndividualFrameOfScatterplot = 0;         % Do not save a file for each individual frame of the scatterplot (but this does save each full scatterplot)
titleOption = 2;        % Use a shorter title
maxOnDemandCapacityRatioToPlot = 5.0;   % Limit the demand/capacity ratio, so the plots won't be too crazy at collapse.

% Subplot options - Tell what to pot for the six levels of Sa over the IDA.
%  NOTICE that options 2-4 all do the same thing but they just label the
%  figure files with what type of element is being plotted.
%subplotOption = 1;  % Draw building showing plastic hinging 
%subplotOption = 2;  % Joint response - COLUMN (if you use this, input joint location and hinge number information below)
%subplotOption = 3;  % Joint response - BEAM (if you use this, input joint location and hinge number information below)
subplotOption = 4;  % Joint response - JOINT (if you use this, input joint location and hinge number information below)

% Note that these values are needed even if not using this option
    % because the values are being sent to a function!!!!
    % Column hinge
    %colLineNum = 2;
    %floorNum = 4;
    %jointNodeNum = 1; 
    % Beam hinge
    %colLineNum = 2;
    %floorNum = 3;
    %jointNodeNum = 2; 
    % Joint response
    colLineNum = 4;
    floorNum = 3;
    jointNodeNum = 5; 

% Define parallel lists for each analysisType
        %analysisTypeLIST = {'(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)'};
        %modelNameLIST = {'DesA_Buffalo_v.9noGFrm'};
        %bldgIDLIST = [1];
        %eqNumberLIST_forEachModel = { [11011, 11012, 11021, 11022, 11031,
        %11032, 11041, 11042, 11051, 11052, 11061, 11062, 11071, 11072, 11081, 11082, 11091, 11092, 11101, 11102, 11111, 11112, 11121, 11122, 11131, 11132, 11141, 11142, 11151, 11152, 11161, 11162, 11171, 11172, 11181, 11182, 11191, 11192, 11201, 11202, 11211, 11212, 11221, 11222, 11241, 11242, 11251, 11252, 11261, 11262, 11271, 11272, 11281, 11282, 11291, 11292, 11311, 11312, 11321, 11322] };
        
        %analysisTypeLIST = {'(DesID1_v.64noGFrm)_(AllVar)_(0.00)_(clough)'};
        %modelNameLIST = {'DesID1_v.64noGFrm'};
        %bldgIDLIST = [1];
        %eqNumberLIST_forEachModel = { [941051] };
        
        analysisTypeLIST = {'(DesID1_v.64)_(AllVar)_(0.00)_(clough)'};
        modelNameLIST = {'DesID1_v.64'};
        bldgIDLIST = [1];
        eqNumberLIST_forEachModel = { [941031] };
        
%         analysisTypeLIST = {'(DesID1_v.63noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID3_v.9noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID5_v.2)_(AllVar)_(Mean)_(clough)', '(DesID6_v.4)_(AllVar)_(Mean)_(clough)', '(DesID9_v.3)_(AllVar)_(Mean)_(clough)', '(DesID9_v.3noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID10_v.3)_(AllVar)_(Mean)_(clough)', '(DesID11_v.1)_(AllVar)_(Mean)_(clough)', '(DesID1_v.63noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID3_v.9noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID5_v.2)_(AllVar)_(Mean)_(clough)', '(DesID6_v.4)_(AllVar)_(Mean)_(clough)', '(DesID9_v.3)_(AllVar)_(Mean)_(clough)', '(DesID9_v.3noGFrm)_(AllVar)_(Mean)_(clough)', '(DesID10_v.3)_(AllVar)_(Mean)_(clough)', '(DesID11_v.1)_(AllVar)_(Mean)_(clough)'};
%         modelNameLIST = {'DesID1_v.63noGFrm', 'DesID3_v.9noGFrm', 'DesID5_v.2', 'DesID6_v.4', 'DesID9_v.3', 'DesID9_v.3noGFrm', 'DesID10_v.3', 'DesID11_v.1', 'DesID1_v.63noGFrm', 'DesID3_v.9noGFrm', 'DesID5_v.2', 'DesID6_v.4', 'DesID9_v.3', 'DesID9_v.3noGFrm', 'DesID10_v.3', 'DesID11_v.1'};
%         bldgIDLIST = [1, 3, 5, 6, 9, 9, 10, 11];
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
%     
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
        analysisType = analysisTypeLIST{analysisTypeIndex};
        modelName = modelNameLIST{analysisTypeIndex};
        bldgID = bldgIDLIST(analysisTypeIndex);
        eqNumberLIST = eqNumberLIST_forEachModel{analysisTypeIndex};

        % Now loop over the EQs and create the 2x2 scatter plots
        for eqIndex = 1:length(eqNumberLIST)
            eqNumber = eqNumberLIST(eqIndex);
            startFigNum = analysisTypeIndex * 100 + eqIndex * 10;
            
            % Call the function to make the scatterplot
            CreateAndSaveSubPlotsOverIDA_Frame(buildingInfo, bldgID, analysisType, modelName, eqNumber, saDefType, processorToUse, driftPlotOption, isSaveFileForIndividualFrameOfScatterplot, titleOption, maxOnDemandCapacityRatioToPlot, startFigNum, subplotOption, colLineNum, floorNum, jointNodeNum);            

        end; % end of EQ loop
        
    end; % end of analysisType loop




