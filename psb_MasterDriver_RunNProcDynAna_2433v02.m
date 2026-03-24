
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


%                           analyze  process   IDA/MSA      CDF    defoAtCol    defoJustBefCol     cordova    IDR/RDR/PFA   
    analyzeProcessPlotIndex = [0        1        1           1         0              0               0           1];


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
    
% Sa list for stripe processing - this is the list of Sa levels to make
% stripe files for
     saLevelsForStripes = [0.53  0.63  0.70  0.85  0.88  1.06  1.32  1.58];
    % saLevelsForStripes = [0.05	0.10	0.15	0.20	0.25	0.30	0.35	0.40	0.50	0.55	0.60	0.70	0.80	0.90	1.00	1.20	1.40	1.60	1.80   2.00   2.40   2.80];



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
   

eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
eqNumberLIST_forStripes    = eqNumberLIST_forProcessing_SetTest;
eqFormatForCollapseList = eqFormatForCollapseList_SetTest;
flagForEQFileFormat = flagForEQFileFormat_SetTest;
isProcessMultipleCollapseRuns = true;   % or false
isPlotCollapseIDAs = true;   % or false
eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetTest;
eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetTest;
isConvertToSaKircher = false;   % or true (depending on need)
isCollapsedForEachRun = false;   % or true (depending on logic)




idaInputs.dtForCollapseMATLAB =                 dtForCollapseMATLAB;
idaInputs.minStoryDriftRatioForCollapseMATLAB = minStoryDriftRatioForCollapseMATLAB; 
idaInputs.elementUsedForColSensModelMATLAB =    elementUsedForColSensModelMATLAB;
idaInputs.eqFormatForCollapseList =             eqFormatForCollapseList;
idaInputs.sensModelLIST =                       sensModelLIST;
idaInputs.sensVariableNameLIST =                sensVariableNameLIST;
idaInputs.sensVariableValueLIST =               sensVariableValueLIST;
idaInputs.eqNumberLIST =                        eqNumberLIST;
idaInputs.saStartLevel =                        saStartLevel;
idaInputs.startStepSize =                       startStepSize;
idaInputs.tolerance =                           tolerance; 
idaInputs.maxNumRuns =                          maxNumRuns;
idaInputs.perturbationForNonConvSingular =      perturbationForNonConvSingular;
idaInputs.flagForEQFileFormat =                 flagForEQFileFormat;
idaInputs.periodUsedForScalingGroundMotions =   periodUsedForScalingGroundMotions;
idaInputs.dampingRatioUsedForSaDef =            dampingRatioUsedForSaDef;
idaInputs.extraSecondsToRunAnalysis =           extraSecondsToRunAnalysis;
% idaInputs.timeTakenInMinsForEachAnalysis =      timeTakenInMinsForEachAnalysis;
idaInputs.eqTimeHistoryPreFormatted =           eqTimeHistoryPreFormatted;
% idaInputs.openseesFileToUse =                   openseesFileToUse;
idaInputs.collapseDriftThreshold =              collapseDriftThreshold;
idaInputs.dataSavingOption =                    dataSavingOption;
idaInputs.markerTypeLine =                      markerTypeLine;
idaInputs.markerTypeDot =                       markerTypeDot;
idaInputs.isPlotIndividualPoints =              isPlotIndividualPoints;
idaInputs.isProcessMultipleCollapseRuns =       isProcessMultipleCollapseRuns;
idaInputs.isPlotCollapseIDAs =                  isPlotCollapseIDAs;
idaInputs.analysisTypeLIST =                    analysisTypeLIST;
idaInputs.analysisType =                        analysisType;
idaInputs.modelNameLIST =                       modelNameLIST;
idaInputs.eqNumberLIST_forProcessing =          eqNumberLIST_forProcessing;
idaInputs.eqListForCollapseIDAs_Name =          eqListForCollapseIDAs_Name;
idaInputs.eqNumberLIST_forCollapseIDAs =        eqNumberLIST_forCollapseIDAs;
idaInputs.isConvertToSaKircher =                isConvertToSaKircher;
idaInputs.sigmaLnModeling =                     sigmaLnModeling;


msaInputs.dtForCollapseMATLAB                 = dtForCollapseMATLAB;
msaInputs.minStoryDriftRatioForCollapseMATLAB = minStoryDriftRatioForCollapseMATLAB ;
msaInputs.elementUsedForColSensModelMATLAB =    elementUsedForColSensModelMATLAB ;
msaInputs.eqFormatForCollapseList =             eqFormatForCollapseList ;
msaInputs.sensModelLIST =                       sensModelLIST ;
msaInputs.sensVariableNameLIST =                sensVariableNameLIST ;
msaInputs.sensVariableValueLIST =               sensVariableValueLIST ;
msaInputs.eqNumberLIST =                        eqNumberLIST ;
msaInputs.saStartLevel =                        saStartLevel ;
msaInputs.startStepSize =                       startStepSize ;
msaInputs.saLevelsForStripes =                  saLevelsForStripes ;
msaInputs.tolerance =                           tolerance ;
msaInputs.maxNumRuns =                          maxNumRuns ;
msaInputs.perturbationForNonConvSingular =      perturbationForNonConvSingular ;
msaInputs.flagForEQFileFormat =                 flagForEQFileFormat ;
msaInputs.periodUsedForScalingGroundMotions =   periodUsedForScalingGroundMotions ;
msaInputs.dampingRatioUsedForSaDef =            dampingRatioUsedForSaDef ;
msaInputs.extraSecondsToRunAnalysis =           extraSecondsToRunAnalysis ;
msaInputs.eqTimeHistoryPreFormatted =           eqTimeHistoryPreFormatted ;
msaInputs.collapseDriftThreshold =              collapseDriftThreshold;
msaInputs.dataSavingOption =                    dataSavingOption;
msaInputs.markerTypeLine =                      markerTypeLine;
msaInputs.markerTypeDot =                       markerTypeDot;
msaInputs.isPlotIndividualPoints =              isPlotIndividualPoints;
msaInputs.isProcessMultipleCollapseRuns =       isProcessMultipleCollapseRuns;
msaInputs.analysisTypeLIST =                    analysisTypeLIST;
msaInputs.analysisType =                        analysisType;                
msaInputs.modelNameLIST =                       modelNameLIST;
msaInputs.eqNumberLIST_forProcessing =          eqNumberLIST_forProcessing;
msaInputs.eqNumberLIST_forStripes =             eqNumberLIST_forStripes;
msaInputs.saLevelsForStripes =                  saLevelsForStripes;
msaInputs.isCollapsedForEachRun =               isCollapsedForEachRun;
msaInputs.isConvertToSaKircher =                isConvertToSaKircher;
 


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

    if strcmp(eqListID,'setC')
    % [STANDARD for JS - Summer of 2008 ATC-63-1 study] Run GM Set C
        eqNumberLIST = eqNumberLIST_forProcessing_SetC;
         eqFormatForCollapseList = eqFormatForCollapseList_SetC;
        flagForEQFileFormat = flagForEQFileFormat_SetC;
        [eqNumberLIST, timeTakenInMinsForEachAnalysisOld] = psb_RecoverInterruptedAnalysis(eqNumberLIST, analysisType); 
%         File for recovery being saved in RunCollapseAnaMATLAB_NEWER_proc towards the very end
%        psb_RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysisOld, eqTimeHistoryPreFormatted);
        sks_RunIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
    end         
    % [STANDARD] Run GM Set D (Set D is Set C plus some more records)
    if strcmp(eqListID,'setD')
        eqNumberLIST = eqNumberLIST_forProcessing_SetD;
        eqFormatForCollapseList = eqFormatForCollapseList_SetD;
        flagForEQFileFormat = flagForEQFileFormat_SetD;
        [eqNumberLIST, timeTakenInMinsForEachAnalysisOld] = psb_RecoverInterruptedAnalysis(eqNumberLIST, analysisType); 
                        % File for recovery being saved in RunCollapseAnaMATLAB_NEWER_proc towards the very end
%        psb_RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysisOld, eqTimeHistoryPreFormatted);
        sks_RunIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
    end
    % Run GMs that are in Set D but not in Set C
    if strcmp(eqListID,'setDNotC')
        eqNumberLIST = eqNumberLIST_forProcessing_SetInDNotC;
        eqFormatForCollapseList = eqFormatForCollapseList_SetInDNotC;
        flagForEQFileFormat = flagForEQFileFormat_SetInDNotC; 
        [eqNumberLIST, timeTakenInMinsForEachAnalysisOld] = psb_RecoverInterruptedAnalysis(eqNumberLIST, analysisType); 
                       % File for recovery being saved in RunCollapseAnaMATLAB_NEWER_proc towards the very end
%        psb_RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysisOld, eqTimeHistoryPreFormatted);
        sks_RunIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
    end
        % [OPTIONAL] Run GM Set G
    if strcmp(eqListID,'setG')
        eqNumberLIST = eqNumberLIST_forProcessing_SetG;
        eqFormatForCollapseList = eqFormatForCollapseList_SetG;
        flagForEQFileFormat = flagForEQFileFormat_SetG;
        [eqNumberLIST, timeTakenInMinsForEachAnalysisOld] = psb_RecoverInterruptedAnalysis(eqNumberLIST, analysisType); 
                       % File for recovery being saved in RunCollapseAnaMATLAB_NEWER_proc towards the very end
%        psb_RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysisOld, eqTimeHistoryPreFormatted);
        sks_RunIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
    end
    % Run GM Set TEST - Just for testing
    if strcmp(eqListID,'setTest')    
        eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
        eqFormatForCollapseList = eqFormatForCollapseList_SetTest;
        flagForEQFileFormat = flagForEQFileFormat_SetTest;
        % [eqNumberLIST, timeTakenInMinsForEachAnalysisOld] = psb_RecoverInterruptedAnalysis(eqNumberLIST, analysisType); 
                       % File for recovery being saved in RunCollapseAnaMATLAB_NEWER_proc towards the very end
%        psb_RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysisOld, eqTimeHistoryPreFormatted);
        sks_RunIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
    end
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
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] Process GM Set C - tested/works(6-29-06)
        if strcmp(eqListID,'setC')	
            eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetC;
            eqNumberLIST               = eqNumberLIST_forProcessing;
            eqNumberLIST_forStripes = eqNumberLIST_forProcessing;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
            eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetC;
            eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetC;
            % eqListForCollapseMSAs_Name = eqListForCollapseMSAs_Name_SetC;
            isProcessMultipleCollapseRuns = 1;
            isPlotCollapseIDAs = 0;
            isPlotCollapseMSAs = 0;
             msaInputs.isPlotCollapseMSAs =  isPlotCollapseMSAs;
            isCollapsedForEachRun = 0;
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            sks_ProcessIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
        end
        % [STANDARD] Process GM Set D - tested/works(6-29-06)
        if strcmp(eqListID,'setD')    
            eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetD;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
            eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetD;
            isProcessMultipleCollapseRuns = 1;
            isPlotCollapseIDAs = 0;
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        end
        % [OPTIONAL] Process GM Set G
        if strcmp(eqListID,'setG')
            eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetG;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
            eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetG;
            isProcessMultipleCollapseRuns = 1;
            isPlotCollapseIDAs = 0;
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
           Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        end
        % Process GM Set TEST - just for testing
        if strcmp(eqListID,'setTest')    
            eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetTest;
            eqNumberLIST               = eqNumberLIST_forProcessing;
            eqNumberLIST_forStripes = eqNumberLIST_forProcessing;
            % eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetTest;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
            % eqListForCollapseMSAs_Name = eqListForCollapseMSAs_Name_SetTest;
            eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetTest;
            isProcessMultipleCollapseRuns = 1;
            isPlotCollapseMSAs = 0;
            msaInputs.isPlotCollapseMSAs =  isPlotCollapseMSAs;
            isCollapsedForEachRun = 0;
            isPlotCollapseIDAs = 0;
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            % Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            % sks_ProcessDynamicAnalyses_proc_MSA(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseMSAs, analysisTypeLIST, modelNameLIST, eqNumberLIST,eqNumberLIST_forProcessing, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, isConvertToSaKircher, eqListForCollapseMSAs_Name);
            sks_ProcessIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot and save IDAs/MSAs
    if analyzeProcessPlotIndex(3) == 1
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Plot and save IDAs for GM Set C  - Sa,GEOMEAN - tested/works(6-29-06)
        if strcmp(eqListID,'setC')	
            eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetC;
            eqNumberLIST               = eqNumberLIST_forProcessing;
            eqNumberLIST_forStripes = eqNumberLIST_forProcessing;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
            eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetC;
            eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetC;
            % eqListForCollapseMSAs_Name = eqListForCollapseMSAs_Name_SetC;
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

%         % [STANDARD] Plot and save IDAs for GM Set D - Sa,GEOMEAN
        if strcmp(eqListID,'setD')	
            eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetD;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
            eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetD;
            isProcessMultipleCollapseRuns = 0;
            isPlotCollapseIDAs = 1;
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            close;      close; % close figure 
        end
%  %          [OPTIONAL] Plot and save IDAs for GM Set D - Sa, ATC-63
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %         if strcmp(eqListID,'setD')	
            %             eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetD;
            %             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
            %             eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetD;
            %             isProcessMultipleCollapseRuns = 0;
            %             isPlotCollapseIDAs = 1;
            %             isConvertToSaKircher = 1;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
            % %             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            %             Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            %             close;      close; % close figure 
            %         end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        % [OPTIONAL] Plot and save IDAs for GM Set G - Sa,GEOMEAN
        if strcmp(eqListID,'setG')	
            eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetG;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
            eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetG;
            isProcessMultipleCollapseRuns = 0;
            isPlotCollapseIDAs = 1;
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            close;      close; % close figure 
        end
        % [OPTIONAL] Plot and save IDAs for GM Set G - Sa,ATC63
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %         if strcmp(eqListID,'setG')	
            %             eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetG;
            %             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
            %             eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetG;
            %             isProcessMultipleCollapseRuns = 0;
            %             isPlotCollapseIDAs = 1;
            %             isConvertToSaKircher = 1;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
            % %             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            %             Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            %             close;      close; % close figure 
            %         end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Plot and save IDAs for GM Set TEST - Sa,GEOMEAN - just for testing
        if strcmp(eqListID,'setTest')	
            eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetTest;
            eqNumberLIST_forStripes = eqNumberLIST_forProcessing;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
            % eqListForCollapseMSAs_Name = eqListForCollapseMSAs_Name_SetTest;
            eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetTest;
            isProcessMultipleCollapseRuns = 0;
            isPlotCollapseIDAs = 1;
            isPlotCollapseMSAs = 1;
            msaInputs.isPlotCollapseMSAs =  isPlotCollapseMSAs;
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
%             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            % Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            % sks_ProcessDynamicAnalyses_proc_MSA(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseMSAs, analysisTypeLIST, modelNameLIST, eqNumberLIST,eqNumberLIST_forProcessing, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, isConvertToSaKircher, eqListForCollapseMSAs_Name);
            % sks_ProcessDynamicAnalyses_proc_MSA(collapseDriftThreshold, dataSavingOption, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseMSAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqNumberLIST_forStripes, saLevelsForStripes, isConvertToSaKircher, eqListForCollapseMSAs_Name)
            sks_ProcessIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
            close;      close; % close figure 
        end
        % Plot and save IDAs for GM Set TEST - Sa,ATC63 - just for testing
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %         if strcmp(eqListID,'setTest')	
            %             eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetTest;
            %             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
            %             eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetTest;
            %             isProcessMultipleCollapseRuns = 0;
            %             isPlotCollapseIDAs = 1;
            %             isConvertToSaKircher = 1;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
            % %             ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            %             Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            %             close;      close; % close figure 
            %         end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Collapse CDF plots
    if analyzeProcessPlotIndex(4) == 1
%          % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Make the collapse CDF plots for GM Set C - Sa,GeoMean - tested/works(6-29-06)
        if strcmp(eqListID,'setC')	
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
            % eqListForCollapseMSAs_Name = eqListForCollapseMSAs_Name_SetC;
            figNum = 100;
            % PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            % sks_PlotCollapseEmpiricalCDFWithFits_controlComp_proc_MSA(analysisTypeLIST, analysisType, eqNumberLIST, figNum, isConvertToSaKircher) %% not required anymore (11-Feb-2026)
            sks_CDFIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
            close; % close figure
            
            figNum = 101;
            % PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            % sks_PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc_MSA(analysisTypeLIST, analysisType, eqNumberLIST, figNum, isConvertToSaKircher) %% not required anymore (11-Feb-2026)
            close; % close figure
        end
%         % [OPTIONAL] Make the collapse CDF plots for GM Set C - Sa, ATC63
%         if strcmp(eqListID,'setC')	
%             isConvertToSaKircher = 1;   % We can use this to instead plot Sa,Kircher.
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
%             figNum = 100;
%             PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
%             close; % close figure
%             figNum = 101;
%             PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
%             close; % close figure
%         end

%         % [STANDARD] Make the collapse CDF plots for GM Set D - Sa,GEOMEAN
        if strcmp(eqListID,'setD')
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
            figNum = 102;
            PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            close; % close figure
            figNum = 103;
            PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            close; % close figure
        end
%         % [OPTIONAL] Make the collapse CDF plots for GM Set D - Sa, ATC63
%         if strcmp(eqListID,'setD')
%             isConvertToSaKircher = 1;   % We can use this to instead plot Sa,Kircher.
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
%             figNum = 102;
%             PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
%             close; % close figure
%             figNum = 103;
%             PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
%             close; % close figure
%         end

        % [STANDARD] Make the collapse CDF plots for GM Set G - Sa,GEOMEAN
        if strcmp(eqListID,'setG')
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
            figNum = 104;
            PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            close; % close figure
            figNum = 105;
            PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            close; % close figure   
        end
%         % [OPTIONAL] Make the collapse CDF plots for GM Set G - Sa,ATC63
%         if strcmp(eqListID,'setG')
            %isConvertToSaKircher = 1;   % We can use this to instead plot Sa,Kircher.
            %eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
            %figNum = 104;
            %PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            %close; % close figure
            %figNum = 105;
            %PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            %close; % close figure  
%         end

    % Make the collapse CDF plots for GM Set TEST - Sa,GEOMEAN - just for testing
        if strcmp(eqListID,'setTest')
            isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
            saLevelForEachRun =0;
            % eqListForCollapseMSAs_Name = eqListForCollapseMSAs_Name_SetTest;
            eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
            figNum = 104;
            % PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
            % sks_PlotCollapseEmpiricalCDFWithFits_controlComp_proc_MSA(analysisTypeLIST, analysisType, eqNumberLIST, figNum, isConvertToSaKircher)
            sks_CDFIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs);
            % close; % close figure
            % figNum = 105;
            % PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher)
             % sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA(analysisTypeLIST, eqNumberLIST, isConvertToSaKircher)
            % close; % close figure

        end
    end
%             
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create plots of Sa-epsilon for collapse capacity - SIMPLER PROCEDURE
    
    % (11-11-15, PSB) this works! by putting random-valued (as yet) mat files in the C:\OpenSeesProcessingFiles\Epsilon_Files_Saved directory
    
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] Create the Sa-Epsilon plots for GM Set C tested/works for GM Set C (6-29-06)
%             groundMotionSetUsed = 'GMSetC';
%             CreatePlotsOfSaVSEpsilon_proc(analysisType, groundMotionSetUsed, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef);
%             close;        close;      close;     close; % close figures  
        % [STANDARD] Create the Sa-Epsilon plots for GM Set D - tested/works for GM Set C (6-29-06)
%             groundMotionSetUsed = 'GMSetD';
%             CreatePlotsOfSaVSEpsilon_proc(analysisType, groundMotionSetUsed, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef);
%             close;        close;      close;     close; % close figures  
        % Create the Sa-Epsilon plots for GM Set TEST - just for testing
%             groundMotionSetUsed = 'GMSetTest';
%             CreatePlotsOfSaVSEpsilon_proc(analysisType, groundMotionSetUsed, dampingRatioUsedForSaDef);
%             close;        close;      close;     close; % close figures  
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create plots of Sa-epsilon for collapse capacity - MORE COMPLEX
    % PROCEDURE WITH MANY FIT TYPES - This is not really needed; I was just
    % usind this to check some things for ATC-63.
        % [STANDARD] Create the Sa-Epsilon (for collapse) plots for GM Set D - tested/works for GM Set C (6-29-06)
%             groundMotionSetUsed = 'GMSetD';
%             % Use the NEW PROCEDURE with binning and other regression methods.
%             numberOfBins = 6;
%             CreatePlotsOfSaVSEpsilon_proc_withOtherFitTypes(analysisType, groundMotionSetUsed, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, numberOfBins);
%             close;        close;      close;     close; % close figures  
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create plots of Sa-epsilon for INTERSTORY DRIFT RESPONSE - Added on
    % 11-1-07
        % Create the Sa-Epsilon plots for INTERSTORY DRIFT RESPONSE for GM Set C
            %groundMotionSetUsed = 'GMSetC';
            % ADD this if desired.
        % Create the Sa-Epsilon plots for INTERSTORY DRIFT
        % RESPONSE for GM Set D
%             groundMotionSetUsed = 'GMSetD';
%             saLevel = 0.40;
%             CreatePlotsOfSaVSEpsilon_forMIDR_proc(analysisType, groundMotionSetUsed, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, saLevel);
%             close;        close;      close;     close; % close figures  
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create diagrams of building failures AT collapse
    if analyzeProcessPlotIndex(5) == 1
        cd MovieAndVisualProcessors
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] Create the collapse mode plots for Set C - just for testing
        if strcmp(eqListID,'setC')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetC;
            psb_CreateAllSubPlotsOfFrameAtCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close;      close;  	close;      close; % close figure
            cd ..;
        end
        % [STANDARD] Create the collapse mode plots for Set D tested/works (at least starts right) (6-29-06)
        if strcmp(eqListID,'setD')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetD;
            psb_CreateAllSubPlotsOfFrameAtCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close;      close;  	close;      close; % close figure
            cd ..;
        end
        % [STANDARD] Create the collapse mode plots for Set G tested/works (at least starts right) (6-29-06)
        if strcmp(eqListID,'setG')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetG;
            psb_CreateAllSubPlotsOfFrameAtCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close;      close;  	close;      close; % close figure
            cd ..;
        end
        % Create the collapse mode plots for Set D and G combined - tested/works (at least starts right) (6-29-06)
        if strcmp(eqListID,'setDandG')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetDandG;
            psb_CreateAllSubPlotsOfFrameAtCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close;      close;  	close;      close; % close figure
            cd ..;
        end
        % Create the collapse mode plots for Set Test - tested/works (at least starts right) (6-29-06)
        if strcmp(eqListID,'setTest')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
            psb_CreateAllSubPlotsOfFrameAtCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close;      close;  	close;      close; % close figure
            cd ..;            
        end
    end
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create diagrams of building failures JUST BEFORE collapse 
    if analyzeProcessPlotIndex(6) == 1
        cd MovieAndVisualProcessors
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] Create the plots of response just before collapse for Set C - just for testing
        if strcmp(eqListID,'setC')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetC;
            psb_CreateAllSubPlotsOfFrameJustBeforeCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close; % close figure   
            cd ..;
        end
        % [STANDARD] Create the plots of response just before collapse for Set D tested/works (at least starts right) (6-29-06)
        if strcmp(eqListID,'setD')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetD;
            psb_CreateAllSubPlotsOfFrameJustBeforeCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close; % close figure   
            cd ..;
        end
        % [STANDARD] Create the plots of response just before collapse for Set G tested/works (at least starts right) (6-29-06)
        if strcmp(eqListID,'setG')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetG;
            psb_CreateAllSubPlotsOfFrameJustBeforeCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close; % close figure   
            cd ..;
        end
        % Create the plots of response just before collapse for Set D and G combined - tested/works (at least starts right) (6-29-06)
        if strcmp(eqListID,'setDandG')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetDandG;
            psb_CreateAllSubPlotsOfFrameJustBeforeCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close; % close figure   
            cd ..;
        end
        % Create the plots of response just before collapse for Set TEST
        if strcmp(eqListID,'setTest')	
            eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
            psb_CreateAllSubPlotsOfFrameJustBeforeCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
            close; % close figure   
            cd ..;
        end
    end
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Process stripes and create stripe files. This makes a stripe file for
    % each Sa level and then makes one summary file for all stripes.
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Process Stripes for GM Set C - Sa,GEOMEAN
            % eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetC;
            % eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
            % saLevelsForStripes;           % Defined previously
            % isConvertToSaKircher = 0;     % We can use this to instead process and save files based on Sa,Kircher;
            % isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
            % ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent, dampingRatioUsedForSaDef);
%         % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Process Stripes for GM Set C - Sa,ATC63
%             eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetC;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
%             saLevelsForStripes;     % Defined previously
%             isConvertToSaKircher = 1;   % We can use this to instead process and save files based on Sa,Kircher;
%             isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
%             ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
%         % [STANDARD] Process Stripes for GM Set D - Sa,GEOMEAN
            % eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetD;
            % eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
            % saLevelsForStripes;         % Defined previously
            % isConvertToSaKircher = 0;   % We can use this to instead process and save files based on Sa,Kircher;
            % isConvertToSaComponent = 0;  % We can use this to instead process and save files based on Sa,Component;
            % ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
% %         % [NEW AND OPTIONAL] Process Stripes for GM Set D - Sa,COMPONENT -
% %         % I added this Sa,component option on 11-2-07.
% %         % NOTICE - I made this and it did not work since I did not have the
% %         % raw structural analysis data on my computer.  Therefore, this hsa
% %         % not been testing, though I do not see a problem with this working
% %         % if the raw data is available.
%             eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetD;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
%             saLevelsForStripes;     % Defined previously
%             isConvertToSaKircher = 0;   % We can use this to instead process and save files based on Sa,Kircher;
%             isConvertToSaComponent = 1;   % We can use this to instead process and save files based on Sa,Component;
%             ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
        % [OPTIONAL] Process Stripes for GM Set G - Sa,GEOMEAN
            %eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetG;
            %eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
            %saLevelsForStripes;     % Defined previously
            %isConvertToSaKircher = 0;   % We can use this to instead process and save files based on Sa,Kircher;
            %isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
            %ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
        % [OPTIONAL] Process Stripes for GM Set G - Sa,ATC63
            %eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetG;
            %eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
            %saLevelsForStripes;     % Defined previously
            %isConvertToSaKircher = 1;   % We can use this to instead process and save files based on Sa,Kircher;
            %isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
            %ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
        % Process Stripes for GM Set Test - Sa,GEOMEAN
            % eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetTest;
            % eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
            % saLevelsForStripes;     % Defined previously
            % isConvertToSaKircher = 0;   % We can use this to instead process and save files based on Sa,Kircher;
            % isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
            % ProcessStripeStatisticsForCollapseRuns_proc(analysisType,eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot stripe IDAs
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Plot Stripe IDAs - SaGeoMean and for GM Set C
%             saLevelsForStripes;     % Defined previously
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
%             saTypeForIDAPlotting = 'SaGeoMean';     % This corresponds to part of the stripe file name
%             isConvertToSaKircher = 0;   % This just controls the plot label and need to be =0 if we want to put Sa,geoMean(T1) on the plot and =1 if we want to put Sa,ATC(1s) on the plot
%             PlotIDAs_proc(analysisType, saLevelsForStripes, eqListForCollapseIDAs_Name, saTypeForIDAPlotting, isConvertToSaKircher);
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Plot Stripe IDAs - Sa,ATC63 and for GM Set C
%             saLevelsForStripes;     % Defined previously
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
%             saTypeForIDAPlotting = 'SaATC63';     % This corresponds to part of the stripe file name
%             isConvertToSaKircher = 1;   % This just controls the plot label and need to be =0 if we want to put Sa,geoMean(T1) on the plot and =1 if we want to put Sa,ATC(1s) on the plot
%             PlotIDAs_proc(analysisType, saLevelsForStripes, eqListForCollapseIDAs_Name, saTypeForIDAPlotting, isConvertToSaKircher);            
%         % [STANDARD] Plot Stripe IDAs - SaGeoMean and for GM Set D
%             saLevelsForStripes;     % Defined previously
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
%             saTypeForIDAPlotting = 'SaGeoMean';     % This corresponds to part of the stripe file name
%             isConvertToSaKircher = 0;   % This just controls the plot label and need to be =0 if we want to put Sa,geoMean(T1) on the plot and =1 if we want to put Sa,ATC(1s) on the plot
%             PlotIDAs_proc(analysisType, saLevelsForStripes, eqListForCollapseIDAs_Name, saTypeForIDAPlotting, isConvertToSaKircher);
        % [OPTIONAL] Plot Stripe IDAs - SaGeoMean and for GM Set G
%             saLevelsForStripes;     % Defined previously
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
%             saTypeForIDAPlotting = 'SaGeoMean';     % This corresponds to part of the stripe file name
%             isConvertToSaKircher = 0;   % This just controls the plot label and need to be =0 if we want to put Sa,geoMean(T1) on the plot and =1 if we want to put Sa,ATC(1s) on the plot
%             PlotIDAs_proc(analysisType, saLevelsForStripes, eqListForCollapseIDAs_Name, saTypeForIDAPlotting, isConvertToSaKircher);
        % [OPTIONAL] Plot Stripe IDAs - SaATC63 and for GM Set G
            %saLevelsForStripes;     % Defined previously
            %eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
            %saTypeForIDAPlotting = 'SaATC63';     % This corresponds to part of the stripe file name
            %isConvertToSaKircher = 1;   % This just controls the plot label and need to be =0 if we want to put Sa,geoMean(T1) on the plot and =1 if we want to put Sa,ATC(1s) on the plot
            %PlotIDAs_proc(analysisType, saLevelsForStripes, eqListForCollapseIDAs_Name, saTypeForIDAPlotting, isConvertToSaKircher);
         % Plot Stripe IDAs - SaGeoMean and for GM Set TEST - for testing only
%             saLevelsForStripes;     % Defined previously
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
%             saTypeForIDAPlotting = 'SaGeoMean';     % This corresponds to part of the stripe file name
%             isConvertToSaKircher = 0;   % This just controls the plot label and need to be =0 if we want to put Sa,geoMean(T1) on the plot and =1 if we want to put Sa,ATC(1s) on the plot
%             PlotIDAs_proc(analysisType, saLevelsForStripes, eqListForCollapseIDAs_Name, saTypeForIDAPlotting, isConvertToSaKircher);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot the drift ratios just before collapse (save data in a file also)
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Plot and for GM Set C
%             eqNumberLIST = eqNumberLIST_forProcessing_SetC;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
%             RetrieveDriftRatiosJustBeforeCollapseThenSaveAndPlot(eqNumberLIST, eqListForCollapseIDAs_Name, analysisType, modelNameLIST{1});
%             close; % close figure
        % [STANDARD] Plot and for GM Set D
%             eqNumberLIST = eqNumberLIST_forProcessing_SetD;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
%             RetrieveDriftRatiosJustBeforeCollapseThenSaveAndPlot(eqNumberLIST, eqListForCollapseIDAs_Name, analysisType, modelNameLIST{1});
%             close; % close figure
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Plot and for GM Set Test
%             eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
%             RetrieveDriftRatiosJustBeforeCollapseThenSaveAndPlot(eqNumberLIST, eqListForCollapseIDAs_Name, analysisType, modelNameLIST{1});
%             close; % close figure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot and save IDAs for CORDOVA INDEX. Collapse CDF plots
if analyzeProcessPlotIndex(7) == 1
    cd ..
    cd psb_IntensityMeasures

    optimizeCordovaParams = 1;
    alphaDefault = 0.50; % used ONLY IF optimizeCordovaParams is 1
    periodRatDefault = 2.00; % used ONLY IF optimizeCordovaParams is 0

%% [Find the optimum parameters for Cordvoa Intensity Measures] GM Set C
    if strcmp(eqListID,'setC')	
        eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_SetC;
        eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_SetC;
        T1 = periodUsedForScalingGroundMotions; dampRatForCordova = dampingRatioUsedForSaDef;
        doPlotSaveCDF = 1;  doPlotSaveCAlpha = 1; % 1- plot optimum C-alpha and optimum sigma graphs. WORKD ONLY IF optimizeCordovaParams = 1
    %%%%%%%%%%%%%%%%%
    %     processAllComp = 1; % 1- all component; 0- control component
    %     [alpha, periodRat] = psb_PlotCollapseIDAs_CordovaIndex(analysisType, eqNumberLIST_forCordovaIDA, eqListForCollapseIDAs_Cordova_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, T1, dampRatForCordova, optimizeCordovaParams, processAllComp, alphaDefault, periodRatDefault, doPlotSaveCAlpha);
    %     psb_PlotCDF_Cordova(analysisType, eqListForCollapseIDAs_Cordova_Name, processAllComp, T1, dampRatForCordova, alpha, periodRat, doPlotSaveCDF);
    %     disp(['Using All Components, optimized alpha = ' num2str(alpha) ', optimized periodRat = '  num2str(periodRat)]); 
    %     close;        close;        close;  
    %%%%%%%%%%%%%%%%%
        processAllComp = 0; % 1- all component; 0- control component
        [alpha, periodRat] = psb_PlotCollapseIDAs_CordovaIndex(analysisType, eqNumberLIST_forCordovaIDA, eqListForCollapseIDAs_Cordova_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, T1, dampRatForCordova, optimizeCordovaParams, processAllComp, alphaDefault, periodRatDefault, doPlotSaveCAlpha);
        psb_PlotCDF_Cordova(analysisType, eqListForCollapseIDAs_Cordova_Name, processAllComp, T1, dampRatForCordova, alpha, periodRat, doPlotSaveCDF);
        disp(['Using Control Components, optimized alpha = ' num2str(alpha) ', optimized periodRat = '  num2str(periodRat)]); 
        close;            close;            close;
    end

%% [Find the optimum parameters for Cordvoa Intensity Measures] GM Set D
    if strcmp(eqListID,'setD')	
        eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_SetD;
        eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_SetD;
        T1 = periodUsedForScalingGroundMotions; dampRatForCordova = dampingRatioUsedForSaDef;
        doPlotSaveCDF = 1;  doPlotSaveCAlpha = 1; % 1- plot optimum C-alpha and optimum sigma graphs. WORKD ONLY IF optimizeCordovaParams = 1
    %%%%%%%%%%%%%%%%%
    %     processAllComp = 1; % 1- all component; 0- control component
    %     [alpha, periodRat] = psb_PlotCollapseIDAs_CordovaIndex(analysisType, eqNumberLIST_forCordovaIDA, eqListForCollapseIDAs_Cordova_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, T1, dampRatForCordova, optimizeCordovaParams, processAllComp, alphaDefault, periodRatDefault, doPlotSaveCAlpha);
    %     psb_PlotCDF_Cordova(analysisType, eqListForCollapseIDAs_Cordova_Name, processAllComp, T1, dampRatForCordova, alpha, periodRat, doPlotSaveCDF);
    %     disp(['Using All Components, optimized alpha = ' num2str(alpha) ', optimized periodRat = '  num2str(periodRat)]); 
    %     close;        close;        close;  
    %%%%%%%%%%%%%%%%%
        processAllComp = 0; % 1- all component; 0- control component
        [alpha, periodRat] = psb_PlotCollapseIDAs_CordovaIndex(analysisType, eqNumberLIST_forCordovaIDA, eqListForCollapseIDAs_Cordova_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, T1, dampRatForCordova, optimizeCordovaParams, processAllComp, alphaDefault, periodRatDefault, doPlotSaveCAlpha);
        psb_PlotCDF_Cordova(analysisType, processAllComp, T1, dampRatForCordova, alpha, periodRat, doPlotSaveCDF);
        disp(['Using Control Components, optimized alpha = ' num2str(alpha) ', optimized periodRat = '  num2str(periodRat)]); 
        close;        close;        close;
    end
    
%% [Find the optimum parameters for Cordvoa Intensity Measures] GM Set G
    if strcmp(eqListID,'setG')	
        eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_SetG;
        eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_SetG;
        T1 = periodUsedForScalingGroundMotions; dampRatForCordova = dampingRatioUsedForSaDef;
        doPlotSaveCDF = 1;  doPlotSaveCAlpha = 1; % 1- plot optimum C-alpha and optimum sigma graphs. WORKD ONLY IF optimizeCordovaParams = 1
    %%%%%%%%%%%%%%%%%
    %     processAllComp = 1; % 1- all component; 0- control component
    %     [alpha, periodRat] = psb_PlotCollapseIDAs_CordovaIndex(analysisType, eqNumberLIST_forCordovaIDA, eqListForCollapseIDAs_Cordova_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, T1, dampRatForCordova, optimizeCordovaParams, processAllComp, alphaDefault, periodRatDefault, doPlotSaveCAlpha);
    %     psb_PlotCDF_Cordova(analysisType, processAllComp, T1, dampRatForCordova, alpha, periodRat, doPlotSaveCDF);
    %     disp(['Using All Components, optimized alpha = ' num2str(alpha) ', optimized periodRat = '  num2str(periodRat)]); 
    %     close;    close;    close;
    %%%%%%%%%%%%%%%%%
        processAllComp = 0; % 1- all component; 0- control component
        [alpha, periodRat] = psb_PlotCollapseIDAs_CordovaIndex(analysisType, eqNumberLIST_forCordovaIDA, eqListForCollapseIDAs_Cordova_Name, markerTypeLine, markerTypeDot, isPlotIndividualPoints, collapseDriftThreshold, T1, dampRatForCordova, optimizeCordovaParams, processAllComp, alphaDefault, periodRatDefault, doPlotSaveCAlpha);
        psb_PlotCDF_Cordova(analysisType, processAllComp, T1, dampRatForCordova, alpha, periodRat, doPlotSaveCDF);
        disp(['Using Control Components, optimized alpha = ' num2str(alpha) ', optimized periodRat = '  num2str(periodRat)]); 
        close;    close;    close;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IDR-RDR-PFA plots (added on 13-Mar-2026 by Shivakumar KS from IIT Madras)
if analyzeProcessPlotIndex(8) == 1
    %  % [STANDARD] Make the IDR-RDR-PFA plots for GM Set C - Sa,GEOMEAN
    if strcmp(eqListID,'setC')	
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
        
        sks_IDR_RDR_PFA_MSA(eqNumberLIST, analysisType)

        close all % close all figures  
    end

    %         % [STANDARD] Make the IDR-RDR-PFA plots for GM Set D - Sa,GEOMEAN
    if strcmp(eqListID,'setD')
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
       
        sks_IDR_RDR_PFA_MSA(eqNumberLIST, analysisType)

        close all % close all figures 
  
    end

    % [STANDARD] Make the IDR-RDR-PFA plots for GM Set G - Sa,GEOMEAN
    if strcmp(eqListID,'setDNotC')
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
        
        sks_IDR_RDR_PFA_MSA(eqNumberLIST, analysisType)

        close all % close all figures  
    end
   
    % [STANDARD] Make the IDR-RDR-PFA plots for GM Set G - Sa,GEOMEAN
    if strcmp(eqListID,'setG')
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.

        sks_IDR_RDR_PFA_MSA(eqNumberLIST, analysisType)

        close all % close all figures  
    end


    % Make the IDR-RDR-PFA plots for GM Set TEST - Sa,GEOMEAN - just for testing
    if strcmp(eqListID,'setTest')
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
        
        sks_IDR_RDR_PFA_MSA(eqNumberLIST, analysisType)
        
        close all % close all figures 
    end
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