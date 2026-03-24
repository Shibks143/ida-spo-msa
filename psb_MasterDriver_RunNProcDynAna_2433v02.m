
tic 
tStart= tic;

%
% -------------------
% This runs the dynamic earthquake analyses, processes the analyses, then makes/saves all of the results.
%
% Assumptions and Notices: 
%   - Most of the post-processing assumes that the analyses were run with Sa,geoMean!
%
% Author: Curt Haselton 
% Modified extensively by Prakash S Badal, IIT Bombay
%
% Units: Whatever OpenSees is using - kN, mm, radians
%
% -------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define building information - change this for the building being used
   
   
    analysisTypeLIST = {'(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'};
    analysisType = analysisTypeLIST{1};         % Just renaming variable and changing variable format for some of the processors
    modelNameLIST = {'ID2433_R5_5Story_v.02'};
    sensModelLIST = modelNameLIST;              % Just another variable name for a different processor

    bldgID = 2433;      % WARNING - When sensitivity analyses are run, this defines the PHR capacities of the original archetype 
                        % and not of the modified sensitivity model (this will not affect collapse capacities in any way, but will 
                        % affect the colors on the collapse mode plots, but more importantly affect the PADI or DDI values computed
                        % for loss analyses in the stripe files).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% UPDATE TIMEPERIODS IN DEFINEVARIABLE FILE AS WELL %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    periodUsedForScalingGroundMotions = 0.71;   % Note 1) input the proper period for scaling the ground motions for the building you would 
                                                % like to run (haselton used T1)
                                                % Note 2) This is sent to Opensees and used for the analysis.  A random detail is that the 
                                                % plots to do not use this as input; they open the files that Opensees creates 
                                                %(value will be same as this)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% ANALYSIS OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
IDA_or_MSA = 'MSA';
    
    % eqListID = 'setC';  
    % eqListID = 'setD' ;
    % eqListID = 'setDNotC'; 
    % eqListID = 'setG';
    eqListID = 'setTest';


%                           analyze  process   IDA/MSA      CDF    defoAtCol    defoJustBefCol     IDR/RDR/PFA   
    analyzeProcessPlotIndex = [1        1        1           1         0              0               1];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
	extraSecondsToRunAnalysis = 5.00;   % (11-3-15, PSB) extra seconds added to the time history duration for extracting residual drift in the structure.
                                        % can as well be kept zero if conventional collapse analysis is being performed.
                                                
    dampingRatioUsedForSaDef = 0.05;    % This is always 5%.  This is sent to Opensees and used for the analysis.
    minStoryDriftRatioForCollapseMATLAB = 0.04;                     % Value above which record is considered collapsed (used when 
                                                                    % IDA was run); increased from 0.12 on 7-26-06 for the purpose
                                                                    % of making the collapse mode plots better.
    collapseDriftThreshold = minStoryDriftRatioForCollapseMATLAB;   % Just another naming used by a different processor 
    dataSavingOption = 2;                                           % Decide what data files to save (1 - save all data; 2 - save 
                                                                    % reduced amount of data; 3 - save both of the above files)
    markerTypeLine = 'b';
    markerTypeDot = 'bo';
    isPlotIndividualPoints = 1;
    % Change the variable called eqTimeHistoryPreFormatted in psb_DefineVariablesAtMeanValues.tcl (now included here in MATLAB itself)
    eqTimeHistoryPreFormatted = 1; 
                   % 1- GM TH are manually curtailed and we do not want opensees to format the ground motion.
                   % 0- GM TH to be formatted by opensees in RunEQLoadingForCollapse procedure of psb_DefineFunctionsAndProcedures.tcl  
                   %
                   % NOTE- 1) When eqTimeHistoryPreFormatted is 1, it implies that the user has already 
                   % sorted and curtailed the GM and these curtailed Ground Motion values are saved in  C:\OpenSeesProcessingFiles\EQs.
                   % 
                   % NOTE- 2) If new GM time history is to be included, 
                   %   a) run the analysis with a value of 0 first, i.e. let opensees create the DtFile, SortedEQFile and NumPointsFile,
                   %   b) use curtailGroundMotionBasedOnPGA module of prak_util_MULTIPLE_OPTIONS.m to curtail GM.
                   %      This saves the revised SortedEQFile and NumPointsFile in C:\OpenSeesProcessingFiles\EQs,
                   %   c) finally, run the analysis with a value of 1 i.e. with curtailed GM.
                                   
    dtForCollapseMATLAB = 2; % NOTE- 1) A value more than or equal to 1 implies that 
                             % ActualDtForCollapseMATLAB = dtForTimeHistory / (theNumberGivenHere i.e. dtForCollapseMATLAB)
                             % for ex- if dt for TH no 1, 2 and 3 are 0.01, 0.02 and 0.005 seconds then
                             % dtForCollapseMATLAB will be 0.005 0.01 0.0025 respectively
                             % NOTE- 2) A value less than 1 for dtForCollapseMATLAB implies it to be equal for all the EQ records
                             % and dt used is whatever is given here. 
                             
        
    elementUsedForColSensModelMATLAB = 'clough';                    % I do not think this is set up to vary
    sensVariableNameLIST    = {'AllVar'};                           % Do mean analysis
    sensVariableValueLIST   = 0.00;                                 % Do mean analysis
    sigmaLnModeling = 0.50;                                         % This is used when making the collapse CDF plots
                                                 
% Define information used for collapse analyses
    saStartLevel = 0.11;        % BE SURE that this has two significant figs!!! b/c datafile for sa is set up for the same
    startStepSize = 0.30;
    tolerance = 0.05;           % This is the step size for the second loop after the first collapse point is found
    maxNumRuns = 60;
    perturbationForNonConvSingular = 0.03;   
    
% Sa list for stripe processing - this is the list of Sa levels to make stripe files for
     
    saLevelsForStripes = [0.53  0.63  0.70  0.85  0.88  1.06  1.32  1.58];
   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the GM sets - - Brian/Jason - you do not need to change this
    % ATC-63 Ground Motion Set C (Far-Field)SetTest
        eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        eqListForCollapseMSAs_Name_SetC = 'GMSetC';
        eqListForCollapseIDAs_Name_SetC = 'GMSetC';
        eqNumberLIST_forCollapseIDAs_SetC = [12011	12012	12041	12052	12061	12062	12071	12072	12081	12082	12091	12092	12101	12102	12111	12121	12122	12132	12141	12142	12151	12171];
        eqFormatForCollapseList_SetC = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetC = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
    % ATC-63 Ground Motion Set D (expanded Far-Field)
        eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
        % eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142];
        eqListForCollapseIDAs_Name_SetD = 'GMSetD';
        eqNumberLIST_forCollapseIDAs_SetD = [12011	12012	12013	12014	12015	12016	12041	12052	12061	12062	12063	12064	12071	12072	12073	12074	12081	12082	12091	12092	12093	12101	12102	12103	12104	12105	12106	12111	12121	12122	12123	12132	12141	12142	12143	12144	12145	12146	12151	12171];
        % eqNumberLIST_forCollapseIDAs_SetD = [12011	12012	12013	12014];
        eqFormatForCollapseList_SetD = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetD = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
    % ATC-63 Records that Are in Set D AND NOT IN C
        eqNumberLIST_forProcessing_SetInDNotC = [120131	120132	120141	120142	120151	120152	120161	120162	120631	120632	120641	120642	120731	120732	120741	120742	120931	120932	121031	121032	121041	121042	121051	121052	121061	121062	121231	121232	121431	121432	121441	121442	121451	121452	121461	121462];
        eqListForCollapseIDAs_Name_SetInDNotC = 'GMSetInDNotC';
        eqNumberLIST_forCollapseIDAs_SetInDNotC = [12013	12014	12015	12016	12063	12064	12073	12074	12093	12103	12104	12105	12106	12123	12143	12144	12145	12146];
        eqFormatForCollapseList_SetInDNotC = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetInDNotC = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
    % ATC-63 Ground Motion Set G (Near-Field)
        eqNumberLIST_forProcessing_SetG = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
        eqListForCollapseIDAs_Name_SetG = 'GMSetG';
        eqNumberLIST_forCollapseIDAs_SetG = [820181	820182	820292	820723	820802	820821	820828	820879	821063	821086	821165	821503	821529	821605	820126	820160	820165	820495	820496	820741	820753	820825	821004	821048	821176	821504	821517	822114];
        eqFormatForCollapseList_SetG = 'PEER-NGA_Rotated_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetG = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
    % Combined Set D and G, just for processing the collapse mode plots
        eqNumberLIST_forProcessing_SetDandG = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712 8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
        eqListForCollapseIDAs_Name_SetDandG = 'GMSetDandG';
        eqNumberLIST_forCollapseIDAs_SetDandG = [12011	12012	12013	12014	12015	12016	12041	12052	12061	12062	12063	12064	12071	12072	12073	12074	12081	12082	12091	12092	12093	12101	12102	12103	12104	12105	12106	12111	12121	12122	12123	12132	12141	12142	12143	12144	12145	12146	12151	12171 820181	820182	820292	820723	820802	820821	820828	820879	821063	821086	821165	821503	821529	821605	820126	820160	820165	820495	820496	820741	820753	820825	821004	821048	821176	821504	821517	822114];
        eqFormatForCollapseList_SetDandG = 'n/a';   % Multiple types
        flagForEQFileFormat_SetDandG = 2;               % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
    % Test GM set
        eqNumberLIST_forProcessing_SetTest =  [120121, 120122,	121221, 121222]; % replaced last 2 GMs by EQs of shorter duration
        % eqNumberLIST_forProcessing_SetTest = [121322]; % TEMPORARY for RUNNING ONLY ONE EQCOMPONENT
        eqListForCollapseMSAs_Name_SetTest = 'GMSetTest'; % included on 11-jan-2026
        eqListForCollapseIDAs_Name_SetTest = 'GMSetTest';
        eqNumberLIST_forCollapseIDAs_SetTest = [12012, 12122];
        eqNumberLIST_forCollapseMSAs_SetTest = [12012, 12122]; % included on 2-feb-2026
        % eqNumberLIST_forCollapseIDAs_SetTest = [12132];
        eqFormatForCollapseList_SetTest = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetTest = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
   
isProcessMultipleCollapseRuns = true;   % or false
isPlotCollapseIDAs = true;   % or false
isConvertToSaKircher = false;   % or true (depending on need)
isCollapsedForEachRun = false;   % or true (depending on logic)


switch eqListID
    case 'setC'
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;                 eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetC;
        eqFormatForCollapseList = eqFormatForCollapseList_SetC;         flagForEQFileFormat = flagForEQFileFormat_SetC;
        eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetC;
        eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;   eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetC;
    case 'setD'
        eqNumberLIST = eqNumberLIST_forProcessing_SetD;                 eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetD;
        eqFormatForCollapseList = eqFormatForCollapseList_SetD;         flagForEQFileFormat = flagForEQFileFormat_SetD;
        eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetD;        
        eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;   eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetD;
    case 'setDNotC'
        eqNumberLIST = eqNumberLIST_forProcessing_SetDNotC;                 eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetDNotC;
        eqFormatForCollapseList = eqFormatForCollapseList_SetDNotC;         flagForEQFileFormat = flagForEQFileFormat_SetDNotC;
        eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetDNotC;
        eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetDNotC;   eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetDNotC;
    case 'setG'
        eqNumberLIST = eqNumberLIST_forProcessing_SetG;                 eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetG;
        eqFormatForCollapseList = eqFormatForCollapseList_SetG;         flagForEQFileFormat = flagForEQFileFormat_SetG;
        eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetG;        
        eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;   eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetG;
    case 'setTest'
        eqNumberLIST = eqNumberLIST_forProcessing_SetTest;                 eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetTest;
        eqFormatForCollapseList = eqFormatForCollapseList_SetTest;         flagForEQFileFormat = flagForEQFileFormat_SetTest;
        eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetTest;        
        eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;   eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetTest;

end

%% Simplifying Input structures
% COMMON inputs
idaInputs.dtForCollapseMATLAB =                 dtForCollapseMATLAB;
idaInputs.minStoryDriftRatioForCollapseMATLAB = minStoryDriftRatioForCollapseMATLAB; 
idaInputs.elementUsedForColSensModelMATLAB =    elementUsedForColSensModelMATLAB;
idaInputs.eqFormatForCollapseList =             eqFormatForCollapseList;
idaInputs.sensModelLIST =                       sensModelLIST;
idaInputs.sensVariableNameLIST =                sensVariableNameLIST;
idaInputs.sensVariableValueLIST =               sensVariableValueLIST;
idaInputs.eqNumberLIST =                        eqNumberLIST;
idaInputs.perturbationForNonConvSingular =      perturbationForNonConvSingular;
idaInputs.flagForEQFileFormat =                 flagForEQFileFormat;
idaInputs.periodUsedForScalingGroundMotions =   periodUsedForScalingGroundMotions;
idaInputs.dampingRatioUsedForSaDef =            dampingRatioUsedForSaDef;
idaInputs.extraSecondsToRunAnalysis =           extraSecondsToRunAnalysis;
idaInputs.eqTimeHistoryPreFormatted =           eqTimeHistoryPreFormatted;
idaInputs.collapseDriftThreshold =              collapseDriftThreshold;
idaInputs.dataSavingOption =                    dataSavingOption;
idaInputs.markerTypeLine =                      markerTypeLine;
idaInputs.markerTypeDot =                       markerTypeDot;
idaInputs.isPlotIndividualPoints =              isPlotIndividualPoints;
idaInputs.isProcessMultipleCollapseRuns =       isProcessMultipleCollapseRuns;
idaInputs.analysisTypeLIST =                    analysisTypeLIST;
idaInputs.analysisType =                        analysisType;
idaInputs.modelNameLIST =                       modelNameLIST;
idaInputs.eqNumberLIST_forProcessing =          eqNumberLIST_forProcessing;
idaInputs.isConvertToSaKircher =                isConvertToSaKircher;
idaInputs.isCollapsedForEachRun =               isCollapsedForEachRun;
idaInputs.sigmaLnModeling =                     sigmaLnModeling;
idaInputs.maxNumRuns =                          maxNumRuns;

msaInputs = idaInputs;

% IDA-specific inputs
idaInputs.saStartLevel =                        saStartLevel;
idaInputs.startStepSize =                       startStepSize;
idaInputs.tolerance =                           tolerance; 
idaInputs.isPlotCollapseIDAs =                  isPlotCollapseIDAs;
idaInputs.eqListForCollapseIDAs_Name =          eqListForCollapseIDAs_Name;
idaInputs.eqNumberLIST_forCollapseIDAs =        eqNumberLIST_forCollapseIDAs;

% MSA-specific inputs
msaInputs.eqNumberLIST_forStripes =             eqNumberLIST_forStripes;
msaInputs.saLevelsForStripes =                  saLevelsForStripes ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
baseFolder = pwd;

if analyzeProcessPlotIndex(1) == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Run the analyses 

% Go to folder
    cd Models
    cd psb_Sensitivity_Analysis
        [eqNumberLIST, timeTakenInMinsForEachAnalysisOld] = psb_RecoverInterruptedAnalysis(eqNumberLIST, analysisType); 
%        psb_RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysisOld, eqTimeHistoryPreFormatted);
        sks_RunIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
%     % Go back to starting folder
end
    cd(baseFolder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Process and plot for the collapse analyses
    % Go to Matlab Processor folder
        cd psb_MatlabProcessors
% Process analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if analyzeProcessPlotIndex(2) == 1
        isProcessMultipleCollapseRuns = 1;
        isPlotCollapseIDAs = 0;
        isPlotCollapseMSAs = 0;
         msaInputs.isPlotCollapseMSAs =  isPlotCollapseMSAs;
        isCollapsedForEachRun = 0;
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        sks_ProcessIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot and save IDAs/MSAs
if analyzeProcessPlotIndex(3) == 1
        isProcessMultipleCollapseRuns = 0;
        isPlotCollapseIDAs = 1;
        isPlotCollapseMSAs = 1;
        msaInputs.isPlotCollapseMSAs =  isPlotCollapseMSAs;
        isCollapsedForEachRun = 0;
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        % Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        % sks_ProcessDynamicAnalyses_proc_MSA(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseMSAs, analysisTypeLIST, modelNameLIST, eqNumberLIST,eqNumberLIST_forProcessing, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, isConvertToSaKircher, eqListForCollapseMSAs_Name);
        sks_ProcessIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
        close;      close; % close figure 
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collapse CDF plots
if analyzeProcessPlotIndex(4) == 1
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
        saLevelForEachRun =0;
        figNum = 104;
        % PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
        % sks_PlotCollapseEmpiricalCDFWithFits_controlComp_proc_MSA(analysisTypeLIST, analysisType, eqNumberLIST, figNum, isConvertToSaKircher)
        sks_CDFIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create diagrams of building failures AT collapse
if analyzeProcessPlotIndex(5) == 1
    cd MovieAndVisualProcessors
    psb_CreateAllSubPlotsOfFrameAtCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
    close;      close;  	close;      close; % close figure
    cd ..;
end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create diagrams of building failures JUST BEFORE collapse 
if analyzeProcessPlotIndex(6) == 1
    cd MovieAndVisualProcessors
        psb_CreateAllSubPlotsOfFrameJustBeforeCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
        close; % close figure   
        cd ..;
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Process stripes and create stripe files. This makes a stripe file for
    % each Sa level and then makes one summary file for all stripes.
        % ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent, dampingRatioUsedForSaDef);
    % Plot stripe IDAs
        % PlotIDAs_proc(analysisType, saLevelsForStripes, eqListForCollapseIDAs_Name, saTypeForIDAPlotting, isConvertToSaKircher);
        % RetrieveDriftRatiosJustBeforeCollapseThenSaveAndPlot(eqNumberLIST, eqListForCollapseIDAs_Name, analysisType, modelNameLIST{1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot and save IDAs for CORDOVA INDEX. Collapse CDF plots
    % [alpha, periodRat] = psb_PlotCollapseIDAs_CordovaIndex(analysisType, eqNumberLIST_forCordovaIDA, eqListForCollapseIDAs_Cordova_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, T1, dampRatForCordova, optimizeCordovaParams, processAllComp, alphaDefault, periodRatDefault, doPlotSaveCAlpha);
    % psb_PlotCDF_Cordova(analysisType, eqListForCollapseIDAs_Cordova_Name, processAllComp, T1, dampRatForCordova, alpha, periodRat, doPlotSaveCDF);
    % disp(['Using Control Components, optimized alpha = ' num2str(alpha) ', optimized periodRat = '  num2str(periodRat)]); 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IDR-RDR-PFA plots (added on 13-Mar-2026 by Shivakumar KS from IIT Madras)
if analyzeProcessPlotIndex(7) == 1
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
        sks_IDR_RDR_PFA_MSA(eqNumberLIST, analysisType)
        close all % close all figures  
end

%% If we reached here, save a file on desktop stating the same. Since, I am running two analyses back to back, I wouldn't be able to know if there 
% was any error in running the first analyses

    tElapsed = toc(tStart);
    
    fileName = sprintf('CheckFile %s.mat', analysisType);
    cd C:\Users\sks\Desktop
    save(fileName, 'tElapsed');

    % Go back to starting folder
    cd(baseFolder)
    toc