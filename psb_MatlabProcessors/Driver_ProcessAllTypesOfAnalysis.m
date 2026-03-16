% Procedure: Driver_ProcessAllTypesOfAnalysis.m
% -------------------
%   This is just a driver script to process any kind of analysis.
%
% Author: Curt Haselton 
% Date Written: 12-8-05
% -------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Set Analysis Options
clear
clc

% General info
    collapseDriftThreshold = 0.12; %0.80; %0.15; %0.12;  % Value above which record is considered collapsed (used when IDA was run)
    dataSavingOption = 2;   % Decide what data files to save (1 - save all data; 2 - save reduced amount of data; 3 - save both of the above files)

% Infor for the IDA plotter
    markerTypeLine = 'b';
    markerTypeDot = 'bo';
    isPlotIndividualPoints = 1;
    
% Processing to do...
    isProcessMultipleCollapseRuns = 0;
    isPlotCollapseIDAs = 0;             % This plots collapse IDAs for two horizontal components
    isPlotCollapseIDAs_singleComp = 0;  % This plots collapse IDAs for a single horizontal component (uses eqNumberLIST_forProcessing)
    isProcessPOAnalysis = 1;
        % If processing PO, say what type of model (1 for nlBmCol/dispBmCol, 2 for lumpedPlast)
        % NOTICE: I could generalize this to use the same processor for both model types, but I didn't take the time to do it
        % NOTICE: Right now this is set up to process story POs, so this
        % information needs to be in the output files (I can set this up if needed; just a few more lines in the MatlabInfo output file) 
        % (see DesA_v.9noGFrm for the few lines at the bottom of WriteNeededInformationToFilesForMatlab.tcl)
        poModelType = 2;   % (1 for nlBmCol/dispBmCol, 2 for lumpedPlast)
        saTOneForRun_PO = 0.00; 
        eqNumber_PO = 9992; %9992; %9991;
    isPlotPO = 1;
        plotRoofDriftRatio = 1;                     % Plot roof drift ratio instead of roof displacement
        %buildingHeight = 1*14*12 + 11*12*10.5;     % 12 Story wall - Inches (needs to be same units as OpenSees model is using)
        %buildingHeight = 1*16*12 + 11*12*12.0;     % 12 Story frame (OMF/IMF) - Inches (needs to be same units as OpenSees model is using)
        %buildingHeight = 1*14*12 + 3*13*12;         % Benchmark 4 Story frame - Inches (needs to be same units as OpenSees model is using)   
        buildingHeight = 1*15*12 + 3*13*12;         % Archetype 4 Story frame - Inches (needs to be same units as OpenSees model is using)   
        %buildingHeight = 1*15*12 + 7*13*12;         % Archetype 8 Story frame - Inches (needs to be same units as OpenSees model is using)    
        maxNumPoints = 10000000;                % (i.e. don't limit length of plot)
        maxNumPoints = 10000000000.0; %1731; % 105 used for DesID9v.4noGFrm
        markerType_PO = 'b-';
        lineWidth_PO = 3;
    isPlotStoryPO = 0;
        storyNum = 1;
        % Note that more paramaters for the story PO plot are defined above
    isPlotPOMaxDriftLevel = 0; % Max drifts over PO
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Analysis type - for collapse processing and plotting IDAs    
    analysisTypeLIST = {'(Arch_8story_ID1012_v58)_(AllVar)_(0.00)_(clough)'};
    modelNameLIST = {'Arch_8story_ID1012_v58'};   
   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis type - for PO processing
    %analysisType_forPO = '(Arch_8story_ID1012_v58)_(AllVar)_(Mean)_(clough)';
    analysisType_forPO = '(Arch_8story_ID1011_v.131)_(AllVar)_(Mean)_(clough)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Earthquake records for processing or for plotting single component IDAs (component numbering)
    %%% Full list of Bin 4A
    %eqNumberLIST_forProcessing = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092];
    %%% Bin 4A - with EQs 94103 and 94107 excluded.
    %eqNumberLIST_forProcessing = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092];
    %%% Bin 4AEXTRA (4C) - all records
    %eqNumberLIST_forProcessing = [943001, 943002, 943011, 943012, 943021,
    %943022, 943031, 943032, 943041, 943042, 943051, 943052, 943061,
    %943062, 943071, 943072, 943081, 943082, 943091, 943092, 943101,
    %943102, 943111, 943112, 943121, 943122, 943131, 943132, 943141, 943142, 943151, 943152, 943161, 943162, 943171, 943172, 943181, 943182, 943191, 943192, 943201, 943202, 943211, 943212, 943221, 943222, 943231, 943232, 943241, 943242, 943251, 943252];
    %%% Bins 4A and 4C - all records
      %eqNumberLIST_forProcessing = [941001, 941002, 941011, 941012, 941021, 941022, 941031, 941032, 941041, 941042, 941051, 941052, 941061, 941062, 941071, 941072, 941081, 941082, 941091, 941092, 943001, 943002, 943011, 943012, 943021, 943022, 943031, 943032, 943041, 943042, 943051, 943052, 943061, 943062, 943071, 943072, 943081, 943082, 943091, 943092, 943101, 943102, 943111, 943112, 943121, 943122, 943131, 943132, 943141, 943142, 943151, 943152, 943161, 943162, 943171, 943172, 943181, 943182, 943191, 943192, 943201, 943202, 943211, 943212, 943221, 943222, 943231, 943232, 943241, 943242, 943251, 943252];

    %%% OLD - ATC-63 Set B (OLD Far-Field Set)
        % eqNumberLIST_forProcessing = [120111, 120112, 120121, 120122, 120211, 120212,
        % 120311, 120312,	120411, 120412,	120511, 120512,	120521, 120522,
        % 120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121121, 121122,	121211, 121212,	121221, 121222,	121311, 121312,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121611, 121612,	121621, 121622,	121711, 121712];
    
    %%% ATC-63 Set C (Far-Field Set)
        eqNumberLIST_forProcessing = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];

    %%% ATC-63 FULL Set G (Near-Field)
        %eqNumberLIST_forProcessing = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
    
    %%% ATC-63 COMBINED Set C (Far-Field) AND Set G (Near-Field)
        %eqNumberLIST_forProcessing = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712, 8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];

    % Temp
        %eqNumberLIST_forProcessing = [120111];
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Earthquake records for collapse IDAs with both horizontal GM components (numbering by record)
    %%% Bin 4A - ALL
    %eqNumberLIST_forCollapseIDAs = [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109];
    %%% Bin 4A - with EQs 94103 and 94107 excluded.
    %eqNumberLIST_forCollapseIDAs = [94100, 94101, 94102, 94104, 94105, 94106, 94108, 94109];
    %%%%% Bin 4AEXTRA (4C) - all records
    %eqNumberLIST_forCollapseIDAs = [94300, 94301, 94302, 94303, 94304, 94305, 94306, 94307, 94308, 94309, 94310, 94311, 94312, 94313, 94314, 94315, 94316, 94317, 94318, 94319, 94320, 94321, 94322, 94323, 94324, 94325];
    %%%% Bin 4A and 4C
    %eqNumberLIST_forCollapseIDAs = [94100, 94101, 94102, 94103, 94104, 94105, 94106, 94107, 94108, 94109, 94300, 94301, 94302, 94303, 94304, 94305, 94306, 94307, 94308, 94309, 94310, 94311, 94312, 94313, 94314, 94315, 94316, 94317, 94318, 94319, 94320, 94321, 94322, 94323, 94324, 94325];

    
    %%% OLD - ATC-63 Set B (OLD Far-Field Set)
        % eqNumberLIST_forCollapseIDAs = [12011	12012	12021	12031
        % 12041	12051	12052	12061	12062	12071	12072	12081	12082	12091	12092	12101	12102	12112	12121	12122	12131	12132	12141	12142	12151	12161	12162	12171];
    
    %%% ATC-63 Set C (Far-Field Set)
        eqListForCollapseIDAs_Name = 'GMSetC';
        eqNumberLIST_forCollapseIDAs = [12011	12012	12041	12052	12061	12062	12071	12072	12081	12082	12091	12092	12101	12102	12111	12121	12122	12132	12141	12142	12151	12171];
    
    %%% ATC-63 FULL Set G (Near-Field)
        %eqNumberLIST_forCollapseIDAs = [820181	820182	820292	820723	820802	820821	820828	820879	821063	821086	821165	821503	821529	821605	820126	820160	820165	820495	820496	820741	820753	820825	821004	821048	821176	821504	821517	822114];

    %%% ATC-63 COMBINED Set C (Far-Field) AND Set G (Near-Field)
        %eqNumberLIST_forCollapseIDAs = [12011	12012	12041	12052	12061	12062	12071	12072	12081	12082	12091	12092	12101	12102	12112	12121	12122	12132	12141	12142	12151	12171 820181	820182	820292	820723	820802	820821	820828	820879	821063	821086	821165	821503	821529	821605	820126	820160	820165	820495	820496	820741	820753	820825	821004	821048	821176	821504	821517	822114];

    % Temp
        %eqNumberLIST_forCollapseIDAs = [12011];
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing
    % Process multiple collapse runs
    if(isProcessMultipleCollapseRuns == 1)
        %ProcessMultipleCollapseRuns_Generalized(analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, collapseDriftThreshold, dataSavingOption);
        ProcessMultipleCollapseRuns_Generalized_withGD(analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, collapseDriftThreshold, dataSavingOption);
        disp('Process Multiple Collapse Runs - DONE')
    end
    
    % Plot IDAs - both horizontal components
    if(isPlotCollapseIDAs == 1)
        PlotCollapseIDAs(analysisTypeLIST, eqNumberLIST_forCollapseIDAs, eqListForCollapseIDAs_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);
        % For old Benchmark runs
        %PlotCollapseIDAs_withFixToPlotSaGeoMean(analysisTypeLIST, eqNumberLIST_forCollapseIDAs, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);
        disp('Plot Collapse IDAs - DONE')
    end
    
    % Plot IDAs - single horizontal component
    if(isPlotCollapseIDAs_singleComp == 1)
        PlotCollapseIDAs_SingleComp(analysisTypeLIST, eqNumberLIST_forProcessing, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold);
    end
    
    % Process PO analysis
    if(isProcessPOAnalysis == 1)
        % NOTICE: I could generalize this to use the same processor for both model types, but I didn't take the time to do it
        if(poModelType == 1)
            % Process with nlBmCol/dispBmCol processor
            %ProcSingleRun_Generalized_NlBmCol_PO_Full(analysisType_forPO, saTOneForRun_PO, eqNumber_PO); 
            % Older processor to use for older Becnhmark models that were
            % run using the "sensitivity option that saves fewer files
            ProcSingleRun_Generalized_NlBmCol_PO_Sens_OlderBench(analysisType_forPO, saTOneForRun_PO, eqNumber_PO); 
        elseif(poModelType == 2)
            % Process with lumped plasticity processor
            %ProcSingleRun_Generalized_LumpPla_PO_Full(analysisType_forPO, saTOneForRun_PO, eqNumber_PO);
            
            % Simplfied processor to avoid errors when the PO stopped due
            % to singularity (with NANS and things in the files).  Note
            % that even whe you use this, you will need to delete the IND
            % and NAN line from the bottom of the files that are opended;
            % this just opens fewer files.
            ProcSingleRun_Generalized_LumpPla_PO_Full_simpleAvoidErrors(analysisType_forPO, saTOneForRun_PO, eqNumber_PO);
            
            % Older processor to use for older Becnhmark models that were
            % run using the "sensitivity option that saves fewer files
            %ProcSingleRun_Generalized_LumpPla_PO_Sens_OlderBench(analysisType_forPO, saTOneForRun_PO, eqNumber_PO);

        else
            error('Invalid value of poModelType!');
        end
        disp('Process Pushover - DONE')
    end

    % Plot PO
    if(isPlotPO == 1)
        figure(10)
        PlotPushover(analysisType_forPO, eqNumber_PO, saTOneForRun_PO, plotRoofDriftRatio, buildingHeight, maxNumPoints, markerType_PO, lineWidth_PO);
        disp('Plot Pushover - DONE')
    end

    % Plot story PO
    if(isPlotStoryPO == 1)
        figure(11)
        PlotStoryPushover(storyNum, analysisType_forPO, eqNumber_PO, saTOneForRun_PO, plotRoofDriftRatio, buildingHeight, maxNumPoints, markerType_PO, lineWidth_PO);
        disp('Plot Story Pushover - DONE')
    end
    
    % Plot PO max. drift level
    if(isPlotPOMaxDriftLevel == 1)
        figure(12)
        PlotMaxDriftLevel_justPosDrifts(analysisType_forPO, saTOneForRun_PO, eqNumber_PO, markerType_PO);
        %PlotMaxDriftLevel_bothPosAndNeg(analysisType_forPO, saTOneForRun_PO, eqNumber_PO, markerType_PO);
        disp('Plot Maximum Story Drift Level in Pushover - DONE')
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
























