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
   
    analysisTypeLIST = {'(ID2215_R5_7Story_v.03_CS_Del22_Sca2)_(AllVar)_(0.00)_(clough)'};

    analysisType = analysisTypeLIST{1};         % Just renaming variable and changing variable format for some of the processors

    modelNameLIST = {'ID2215_R5_7Story_v.03_CS_Del22_Sca2'};

    sensModelLIST = modelNameLIST;              % Just another variable name for a different processor

    bldgID = 2215;      % WARNING - When sensitivity analyses are run, this defines the PHR capacities of the original archetype 
                        % and not of the modified sensitivity model (this will not affect collapse capacities in any way, but will 
                        % affect the colors on the collapse mode plots, but more importantly affect the PADI or DDI values computed
                        % for loss analyses in the stripe files).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% UPDATE TIMEPERIODS IN DEFINEVARIABLE FILE AS WELL %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    periodUsedForScalingGroundMotions = 0.91;   % Note 1) input the proper period for scaling the ground motions for the building you would 
                                                % like to run (haselton used T1)
                                                % Note 2) This is sent to Opensees and used for the analysis.  A random detail is that the 
                                                % plots to do not use this as input; they open the files that Opensees creates 
                                                %(value will be same as this)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% ANALYSIS OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    eqListID = 'SetCS_22'; maxScalingTH = 2; 
%     eqListID = 'setC'; % 
%     eqListID = 'setD' ;
%     eqListID = 'setDNotC';
%     eqListID = 'setG';
%     eqListID = 'setTest';
    
%                           analyze  proess   IDA    CDF    defoAtCol    defoJustBefCol     cordova
%     analyzeProcessPlotIndex = [1        1       1     1         1              0               1  ];
    analyzeProcessPlotIndex = [0        0       0     0         1              0               1  ];
%     analyzeProcessPlotIndex = [0        0       0     0         0              0               1  ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
	extraSecondsToRunAnalysis = 0.00;   % (11-3-15, PSB) extra seconds added to the time history duration for extracting residual drift in the structure.
                                        % can as well be kept zero if conventional collapse analysis isbeing performed.
                                                
    dampingRatioUsedForSaDef = 0.05;            % This is always 5%.  This is sent to Opensees and used for the analysis.
    
    minStoryDriftRatioForCollapseMATLAB = 0.12; %0.12;              % Value above which record is considered collapsed (used when 
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
                                   
    dtForCollapseMATLAB = 2; 
%      dtForCollapseMATLAB = 2; % NOTE- 1) A value more than or equal to 1 implies that 
                             % ActualDtForCollapseMATLAB = dtForTimeHistory / (theNumberGivenHere i.e. dtForCollapseMATLAB)
                             % for ex- if dt for TH no 1, 2 and 3 are 0.01, 0.02 and 0.005 seconds then
                             % dtForCollapseMATLAB will be 0.005 0.01 0.0025 respectively
                             % NOTE- 2) A value less than 1 for dtForCollapseMATLAB implies it to be equal for all the EQ records
                             % and dt used is whatever is given here.
        
    elementUsedForColSensModelMATLAB = 'clough';                    % I do not think this is set up to vary
    sensVariableNameLIST    = {'AllVar'};                           % Do mean analysis
    sensVariableValueLIST   = [0.00];                               % Do mean analysis
    sigmaLnModeling = 0.50;                                         % This is used when making the collapse CDF plots
    
% Define information used for collapse analyses
    saStartLevel = 0.11;        % BE SURE that this has two significant figs!!! b/c datafile for sa is set up for the same
    startStepSize = 0.30;
    tolerance = 0.05;           % This is the step size for the second loop after the first collapse point is found
    maxNumRuns = 60;
    perturbationForNonConvSingular = 0.03;   

    
%     saStartLevel = 0.21;        % BE SURE that this has two significant figs!!! b/c datafile for sa is set up for the same
%     startStepSize = 0.40;
%     tolerance = 0.15;           % This is the step size for the second loop after the first collapse point is found
%     maxNumRuns = 15;
%     perturbationForNonConvSingular = 0.03;   % used to perturb the Sa value if singularity or non convergence is struck
    
    
% Sa list for stripe processing - this is the list of Sa levels to make
% stripe files for
    saLevelsForStripes = [0.05	0.10	0.15	0.20	0.25	0.30	0.35	0.40	0.50	0.55	0.60	0.70	0.80	0.90	1.00	1.20	1.40	1.60	1.80	2.00 2.4 2.8];
   
% Define the GM sets - - Brian/Jason - you do not need to change this
    % ATC-63 Ground Motion Set C (Far-Field)
        eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        eqListForCollapseIDAs_Name_SetC = 'GMSetC';
        eqNumberLIST_forCollapseIDAs_SetC = [12011	12012	12041	12052	12061	12062	12071	12072	12081	12082	12091	12092	12101	12102	12111	12121	12122	12132	12141	12142	12151	12171];
        eqFormatForCollapseList_SetC = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetC = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
    % ATC-63 Ground Motion Set D (expanded Far-Field)
        eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
%         eqNumberLIST_forProcessing_SetD = [120111	120112	120121	120122	120131	120132	120141	120142];
        eqListForCollapseIDAs_Name_SetD = 'GMSetD';
        eqNumberLIST_forCollapseIDAs_SetD = [12011	12012	12013	12014	12015	12016	12041	12052	12061	12062	12063	12064	12071	12072	12073	12074	12081	12082	12091	12092	12093	12101	12102	12103	12104	12105	12106	12111	12121	12122	12123	12132	12141	12142	12143	12144	12145	12146	12151	12171];
%         eqNumberLIST_forCollapseIDAs_SetD = [12011	12012	12013	12014];
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
        eqNumberLIST_forProcessing_SetTest = [120121, 120122,	121221, 121222]; % replaced last 2 GMs by EQs of shorter duration
        eqListForCollapseIDAs_Name_SetTest = 'GMSetTest';
        eqNumberLIST_forCollapseIDAs_SetTest = [12012, 12122];
        eqFormatForCollapseList_SetTest = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetTest = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean

    % Del22_2211_Sca4 22 pairs of conditional spectra targetted Ground Motion for Delhi  
        eqNumLIST_forProcessing_SetDel22_2211_Sca4 = [6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862];
        eqListForCollapseIDAs_Name_Del22_2211_Sca4 = 'GMSetDel22_2211_Sca4';
        eqNumberLIST_forCollapseIDAs_Del22_2211_Sca4 = [600034	600183	600314	600409	600419	600499	600530	600639	600769	600908	600970	600971	600987	601012	601030	601257	601611	601736	602395	602950	603206	603286];
        eqFormatForCollapseList_Del22_2211_Sca4 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Del22_2211_Sca4 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Del22_2211_Sca2 22 pairs of conditional spectra targetted Ground Motion for Delhi
        eqNumLIST_forProcessing_SetDel22_2211_Sca2 = [6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272];
        eqListForCollapseIDAs_Name_Del22_2211_Sca2 = 'GMSetDel22_2211_Sca2';
        eqNumberLIST_forCollapseIDAs_Del22_2211_Sca2 = [600031	600160	600183	600212	600285	600341	600352	600408	600409	600457	600458	600461	600633	600692	600786	600952	600968	600987	601135	601436	602395	602627];
        eqFormatForCollapseList_Del22_2211_Sca2 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Del22_2211_Sca2 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Del22_2213_Sca4 22 pairs of conditional spectra targetted Ground Motion for Delhi
        eqNumLIST_forProcessing_SetDel22_2213_Sca4 = [6001601	6001602	6003121	6003122	6003391	6003392	6003411	6003412	6005501	6005502	6006341	6006342	6007851	6007852	6009311	6009312	6009601	6009602	6009921	6009922	6010081	6010082	6011081	6011082	6013381	6013382	6014391	6014392	6014571	6014572	6014971	6014972	6016811	6016812	6017761	6017762	6021111	6021112	6024531	6024532	6032671	6032672	6033991	6033992];
        eqListForCollapseIDAs_Name_Del22_2213_Sca4 = 'GMSetDel22_2213_Sca4';
        eqNumberLIST_forCollapseIDAs_Del22_2213_Sca4 = [600160	600312	600339	600341	600550	600634	600785	600931	600960	600992	601008	601108	601338	601439	601457	601497	601681	601776	602111	602453	603267	603399];
        eqFormatForCollapseList_Del22_2213_Sca4 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Del22_2213_Sca4 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Del22_2213_Sca2 22 pairs of conditional spectra targetted Ground Motion for Delhi
        eqNumLIST_forProcessing_SetDel22_2213_Sca2 = [6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702];
        eqListForCollapseIDAs_Name_Del22_2213_Sca2 = 'GMSetDel22_2213_Sca2';
        eqNumberLIST_forCollapseIDAs_Del22_2213_Sca2 = [600230	600250	600339	600548	600720	600753	600832	600836	600850	600873	600931	600970	600989	601078	601158	601292	601316	601361	601532	602618	602661	603270];
        eqFormatForCollapseList_Del22_2213_Sca2 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Del22_2213_Sca2 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Del22_2215_Sca4 22 pairs of conditional spectra targetted Ground Motion for Delhi
        eqNumLIST_forProcessing_SetDel22_2215_Sca4 = [6000361	6000362	6000961	6000962	6005761	6005762	6007261	6007262	6007371	6007372	6008061	6008062	6008611	6008612	6008741	6008742	6010871	6010872	6011191	6011192	6011201	6011202	6012261	6012262	6012661	6012662	6013441	6013442	6014131	6014132	6015811	6015812	6016281	6016282	6024781	6024782	6027111	6027112	6027391	6027392	6027501	6027502	6032601	6032602];
        eqListForCollapseIDAs_Name_Del22_2215_Sca4 = 'GMSetDel22_2215_Sca4';
        eqNumberLIST_forCollapseIDAs_Del22_2215_Sca4 = [600036	600096	600576	600726	600737	600806	600861	600874	601087	601119	601120	601226	601266	601344	601413	601581	601628	602478	602711	602739	602750	603260];
        eqFormatForCollapseList_Del22_2215_Sca4 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Del22_2215_Sca4 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Del22_2215_Sca2 22 pairs of conditional spectra targetted Ground Motion for Delhi
        eqNumLIST_forProcessing_SetDel22_2215_Sca2 = [6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342];
        eqListForCollapseIDAs_Name_Del22_2215_Sca2 = 'GMSetDel22_2215_Sca2';
        eqNumberLIST_forCollapseIDAs_Del22_2215_Sca2 = [600158	600300	600571	600728	600737	600757	600884	600949	600988	601111	601120	601182	601193	601309	601344	601418	601475	601538	601628	602457	602509	602734];
        eqFormatForCollapseList_Del22_2215_Sca2 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Del22_2215_Sca2 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Guw22_2219_Sca4 22 pairs of conditional spectra targetted Ground Motion for Guwahati
        eqNumLIST_forProcessing_SetGuw22_2219_Sca4 = [6000311	6000312	6000791	6000792	6000881	6000882	6001581	6001582	6001601	6001602	6002801	6002802	6003351	6003352	6003601	6003602	6004101	6004102	6004181	6004182	6006371	6006372	6007731	6007732	6007991	6007992	6008791	6008792	6009901	6009902	6009931	6009932	6011351	6011352	6014891	6014892	6015201	6015202	6032691	6032692	6034741	6034742	6035041	6035042];
        eqListForCollapseIDAs_Name_Guw22_2219_Sca4 = 'GMSetGuw22_2219_Sca4';
        eqNumberLIST_forCollapseIDAs_Guw22_2219_Sca4 = [600031	600079	600088	600158	600160	600280	600335	600360	600410	600418	600637	600773	600799	600879	600990	600993	601135	601489	601520	603269	603474	603504];
        eqFormatForCollapseList_Guw22_2219_Sca4 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Guw22_2219_Sca4 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Guw22_2219_Sca2 22 pairs of conditional spectra targetted Ground Motion for Guwahati
        eqNumLIST_forProcessing_SetGuw22_2219_Sca2 = [6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742];
        eqListForCollapseIDAs_Name_Guw22_2219_Sca2 = 'GMSetGuw22_2219_Sca2';
        eqNumberLIST_forCollapseIDAs_Guw22_2219_Sca2 = [600096	600407	600639	600727	600728	600744	600773	600825	600879	600902	600952	600959	600987	601004	601050	601077	601087	601238	601546	601762	602739	603474];
        eqFormatForCollapseList_Guw22_2219_Sca2 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Guw22_2219_Sca2 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Guw22_2221_Sca4 22 pairs of conditional spectra targetted Ground Motion for Guwahati
        eqNumLIST_forProcessing_SetGuw22_2221_Sca4 = [6001641	6001642	6003601	6003602	6005811	6005812	6005871	6005872	6006451	6006452	6007441	6007442	6007541	6007542	6007651	6007652	6009521	6009522	6009701	6009702	6009891	6009892	6009901	6009902	6010041	6010042	6010391	6010392	6011071	6011072	6011541	6011542	6012471	6012472	6014711	6014712	6015131	6015132	6018351	6018352	6026551	6026552	6031051	6031052];
        eqListForCollapseIDAs_Name_Guw22_2221_Sca4 = 'GMSetGuw22_2221_Sca4';
        eqNumberLIST_forCollapseIDAs_Guw22_2221_Sca4 = [600164	600360	600581	600587	600645	600744	600754	600765	600952	600970	600989	600990	601004	601039	601107	601154	601247	601471	601513	601835	602655	603105];
        eqFormatForCollapseList_Guw22_2221_Sca4 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Guw22_2221_Sca4 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Guw22_2221_Sca2 22 pairs of conditional spectra targetted Ground Motion for Guwahati
        eqNumLIST_forProcessing_SetGuw22_2221_Sca2 = [6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522];
        eqListForCollapseIDAs_Name_Guw22_2221_Sca2 = 'GMSetGuw22_2221_Sca2';
        eqNumberLIST_forCollapseIDAs_Guw22_2221_Sca2 = [600006	600095	600096	600143	600150	600265	600359	600495	600529	600564	600727	600752	600766	600808	601004	601050	601120	601166	601292	601489	601492	602752];
        eqFormatForCollapseList_Guw22_2221_Sca2 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Guw22_2221_Sca2 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Guw22_2223_Sca4 22 pairs of conditional spectra targetted Ground Motion for Guwahati
        eqNumLIST_forProcessing_SetGuw22_2223_Sca4 = [6000301	6000302	6000961	6000962	6001601	6001602	6003411	6003412	6003591	6003592	6005741	6005742	6005841	6005842	6007251	6007252	6007961	6007962	6008621	6008622	6009001	6009002	6009311	6009312	6010871	6010872	6011061	6011062	6012251	6012252	6013271	6013272	6014891	6014892	6015401	6015402	6016021	6016022	6026521	6026522	6033021	6033022	6034961	6034962];
        eqListForCollapseIDAs_Name_Guw22_2223_Sca4 = 'GMSetGuw22_2223_Sca4';
        eqNumberLIST_forCollapseIDAs_Guw22_2223_Sca4 = [600030	600096	600160	600341	600359	600574	600584	600725	600796	600862	600900	600931	601087	601106	601225	601327	601489	601540	601602	602652	603302	603496];
        eqFormatForCollapseList_Guw22_2223_Sca4 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Guw22_2223_Sca4 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
    % Guw22_2223_Sca2 22 pairs of conditional spectra targetted Ground Motion for Guwahati
        eqNumLIST_forProcessing_SetGuw22_2223_Sca2 = [6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172];
        eqListForCollapseIDAs_Name_Guw22_2223_Sca2 = 'GMSetGuw22_2223_Sca2';
        eqNumberLIST_forCollapseIDAs_Guw22_2223_Sca2 = [600077	600160	600180	600495	600529	600753	600806	601042	601044	601054	601063	601086	601087	601101	601262	601477	601511	601521	601787	601792	603275	603317];
        eqFormatForCollapseList_Guw22_2223_Sca2 = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_Guw22_2223_Sca2 = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
baseFolder = [pwd];

if analyzeProcessPlotIndex(1) == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the analyses - checked 6/29/06 and works (both D and G checked)
    % Go to folder
    cd Models
    cd psb_Sensitivity_Analysis
    switch eqListID
        case 'setC'
            % [STANDARD for JS - Summer of 2008 ATC-63-1 study] Run GM Set C
            eqNumberLIST = eqNumberLIST_forProcessing_SetC;
            eqFormatForCollapseList = eqFormatForCollapseList_SetC;
            flagForEQFileFormat = flagForEQFileFormat_SetC;
            
        case 'setD'
            % [STANDARD] Run GM Set D (Set D is Set C plus some more records)
            eqNumberLIST = eqNumberLIST_forProcessing_SetD;
            eqFormatForCollapseList = eqFormatForCollapseList_SetD;
            flagForEQFileFormat = flagForEQFileFormat_SetD;
            
        case 'setDNotC'
            % Run GMs that are in Set D but not in Set C
            eqNumberLIST = eqNumberLIST_forProcessing_SetInDNotC;
            eqFormatForCollapseList = eqFormatForCollapseList_SetInDNotC;
            flagForEQFileFormat = flagForEQFileFormat_SetInDNotC;
            
        case 'setG'
            % [OPTIONAL] Run GM Set G
            eqNumberLIST = eqNumberLIST_forProcessing_SetG;
            eqFormatForCollapseList = eqFormatForCollapseList_SetG;
            flagForEQFileFormat = flagForEQFileFormat_SetG;
            
        case 'setTest'
            % Run GM Set TEST - Just for testing
            eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
            eqFormatForCollapseList = eqFormatForCollapseList_SetTest;
            flagForEQFileFormat = flagForEQFileFormat_SetTest;
            
        case 'SetCS_22'
            % Run site-specific conditional spectra matching 22 GMs
            switch bldgID
                case 2211
                    switch maxScalingTH
                        case 4
                            eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2211_Sca4;
                            eqFormatForCollapseList = eqFormatForCollapseList_Del22_2211_Sca4;
                            flagForEQFileFormat = flagForEQFileFormat_Del22_2211_Sca4;
                        case 2
                            eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2211_Sca2;
                            eqFormatForCollapseList = eqFormatForCollapseList_Del22_2211_Sca2;
                            flagForEQFileFormat = flagForEQFileFormat_Del22_2211_Sca2;
                    end
                case 2213
                    switch maxScalingTH
                        case 4
                            eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2213_Sca4;
                            eqFormatForCollapseList = eqFormatForCollapseList_Del22_2213_Sca4;
                            flagForEQFileFormat = flagForEQFileFormat_Del22_2213_Sca4;
                        case 2
                            eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2213_Sca2;
                            eqFormatForCollapseList = eqFormatForCollapseList_Del22_2213_Sca2;
                            flagForEQFileFormat = flagForEQFileFormat_Del22_2213_Sca2;
                    end
                case 2215
                    switch maxScalingTH
                        case 4
                            eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2215_Sca4;
                            eqFormatForCollapseList = eqFormatForCollapseList_Del22_2215_Sca4;
                            flagForEQFileFormat = flagForEQFileFormat_Del22_2215_Sca4;
                        case 2
                            eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2215_Sca2;
                            eqFormatForCollapseList = eqFormatForCollapseList_Del22_2215_Sca2;
                            flagForEQFileFormat = flagForEQFileFormat_Del22_2215_Sca2;
                    end
                case 2219
                    switch maxScalingTH
                        case 4
                            eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2219_Sca4;
                            eqFormatForCollapseList = eqFormatForCollapseList_Guw22_2219_Sca4;
                            flagForEQFileFormat = flagForEQFileFormat_Guw22_2219_Sca4;
                        case 2
                            eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2219_Sca2;
                            eqFormatForCollapseList = eqFormatForCollapseList_Guw22_2219_Sca2;
                            flagForEQFileFormat = flagForEQFileFormat_Guw22_2219_Sca2;
                    end
                case 2221
                    switch maxScalingTH
                        case 4
                            eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2221_Sca4;
                            eqFormatForCollapseList = eqFormatForCollapseList_Guw22_2221_Sca4;
                            flagForEQFileFormat = flagForEQFileFormat_Guw22_2221_Sca4;
                        case 2
                            eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2221_Sca2;
                            eqFormatForCollapseList = eqFormatForCollapseList_Guw22_2221_Sca2;
                            flagForEQFileFormat = flagForEQFileFormat_Guw22_2221_Sca2;
                    end
                case 2223
                    switch maxScalingTH
                        case 4
                            eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2223_Sca4;
                            eqFormatForCollapseList = eqFormatForCollapseList_Guw22_2223_Sca4;
                            flagForEQFileFormat = flagForEQFileFormat_Guw22_2223_Sca4;
                        case 2
                            eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2223_Sca2;
                            eqFormatForCollapseList = eqFormatForCollapseList_Guw22_2223_Sca2;
                            flagForEQFileFormat = flagForEQFileFormat_Guw22_2223_Sca2;
                    end
            end
    end

    [eqNumberLIST, timeTakenInMinsForEachAnalysisOld] = psb_RecoverInterruptedAnalysis(eqNumberLIST, analysisType); 
%     File for recovery being saved in RunCollapseAnaMATLAB_NEWER_proc towards the very end
%     RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysis);
    psb_RunCollapseAnaMATLAB_NEWER_proc(dtForCollapseMATLAB, minStoryDriftRatioForCollapseMATLAB, elementUsedForColSensModelMATLAB, eqFormatForCollapseList, sensModelLIST, sensVariableNameLIST, sensVariableValueLIST, eqNumberLIST, saStartLevel, startStepSize, tolerance, maxNumRuns, perturbationForNonConvSingular, flagForEQFileFormat, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, extraSecondsToRunAnalysis, timeTakenInMinsForEachAnalysisOld, eqTimeHistoryPreFormatted);
    
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
        switch eqListID
            case 'setC'
                % [STANDARD for JS - Summer of 2008 ATC-63-1 study] Process GM Set C - tested/works(6-29-06)
                eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetC;
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetC;
                
            case 'setD'
                eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetD;
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetD;
                
            case 'setG'
                eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetG;
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetG;
                
            case 'setTest'
                eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetTest;
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetTest;
                
            case 'SetCS_22'
                % Run site-specific conditional spectra matching 22 GMs
                switch bldgID
                    case 2211
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2211_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2211_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2211_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2211_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2211_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2211_Sca2;
                        end
                    case 2213
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2213_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2213_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2213_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2213_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2213_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2213_Sca2;
                        end
                    case 2215
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2215_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2215_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2215_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2215_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2215_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2215_Sca2;
                        end
                    case 2219
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2219_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2219_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2219_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2219_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2219_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2219_Sca2;
                        end
                    case 2221
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2221_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2221_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2221_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2221_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2221_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2221_Sca2;
                        end
                    case 2223
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2223_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2223_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2223_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2223_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2223_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2223_Sca2;
                        end
                end
        end
        
        isProcessMultipleCollapseRuns = 1;
        isPlotCollapseIDAs = 0;
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
        %     ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot and save IDAs
    if analyzeProcessPlotIndex(3) == 1
        switch eqListID
            % Plot and save IDAs
            case 'setC'
                eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetC;
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetC;
                
            case 'setD'
                eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetD;
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetD;
                
            case 'setG'
                eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetG;
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetG;
                
            case 'setTest'
                eqNumberLIST_forProcessing = eqNumberLIST_forProcessing_SetTest;
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_SetTest;
                %             Delete_2ndCompOnly_Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
            
            case 'SetCS_22'
                % Run site-specific conditional spectra matching 22 GMs
                switch bldgID
                    case 2211
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2211_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2211_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2211_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2211_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2211_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2211_Sca2;
                        end
                    case 2213
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2213_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2213_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2213_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2213_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2213_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2213_Sca2;
                        end
                    case 2215
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2215_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2215_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2215_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetDel22_2215_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2215_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Del22_2215_Sca2;
                        end
                    case 2219
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2219_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2219_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2219_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2219_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2219_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2219_Sca2;
                        end
                    case 2221
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2221_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2221_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2221_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2221_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2221_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2221_Sca2;
                        end
                    case 2223
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2223_Sca4;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2223_Sca4;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2223_Sca4;
                            case 2
                                eqNumberLIST_forProcessing = eqNumLIST_forProcessing_SetGuw22_2223_Sca2;
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2223_Sca2;
                                eqNumberLIST_forCollapseIDAs = eqNumberLIST_forCollapseIDAs_Guw22_2223_Sca2;
                        end
                end
        end
        
        isProcessMultipleCollapseRuns = 0;
        isPlotCollapseIDAs = 1;
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
        % isConvertToSaKircher = 1;   % We can use this to instead plot Sa,Kircher; this only changes the plotting not the processing.
        % ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        Prak_ProcessDynamicAnalyses_proc(collapseDriftThreshold, dataSavingOption, markerTypeLine, markerTypeDot, isPlotIndividualPoints, isProcessMultipleCollapseRuns, isPlotCollapseIDAs, analysisTypeLIST, modelNameLIST, eqNumberLIST_forProcessing, eqListForCollapseIDAs_Name, eqNumberLIST_forCollapseIDAs, isConvertToSaKircher);
        close;      close; % close figure
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Collapse CDF plots
    if analyzeProcessPlotIndex(4) == 1
        switch eqListID
                % Make the collapse CDF plots 
            case 'setC'
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
                
            case 'setD'
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;

            case 'setG'
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetG;
                
            case 'setTest'
                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
                
            case 'SetCS_22'
                % Run site-specific conditional spectra matching 22 GMs
                switch bldgID
                    case 2211
                        switch maxScalingTH
                            case 4
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2211_Sca4;
                            case 2
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2211_Sca2;
                        end
                    case 2213
                        switch maxScalingTH
                            case 4
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2213_Sca4;
                            case 2
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2213_Sca2;
                        end
                    case 2215
                        switch maxScalingTH
                            case 4
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2215_Sca4;
                            case 2
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Del22_2215_Sca2;
                        end
                    case 2219
                        switch maxScalingTH
                            case 4
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2219_Sca4;
                            case 2
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2219_Sca2;
                        end
                    case 2221
                        switch maxScalingTH
                            case 4
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2221_Sca4;
                            case 2
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2221_Sca2;
                        end
                    case 2223
                        switch maxScalingTH
                            case 4
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2223_Sca4;
                            case 2
                                eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_Guw22_2223_Sca2;
                        end
                end                
        end
        isConvertToSaKircher = 0;   % We can use this to instead plot Sa,Kircher.
        figNum = 100; PlotCollapseEmpiricalCDFWithFits_controlComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
        close; % close figure
        figNum = 101; PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(sigmaLnModeling, analysisType, figNum, eqListForCollapseIDAs_Name, isConvertToSaKircher);
        close; % close figure
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
        switch eqListID
            % Create the collapse mode plots 
            case 'setC'
                eqNumberLIST = eqNumberLIST_forProcessing_SetC;
                
            case 'setD'
                eqNumberLIST = eqNumberLIST_forProcessing_SetD;
                
            case 'setG'
                eqNumberLIST = eqNumberLIST_forProcessing_SetG;
                
            case 'setDandG'
                eqNumberLIST = eqNumberLIST_forProcessing_SetDandG;
                
            case 'setTest'
                eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
                
            case 'SetCS_22'
                % Run site-specific conditional spectra matching 22 GMs
                switch bldgID
                    case 2211
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2211_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2211_Sca2;
                        end
                    case 2213
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2213_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2213_Sca2;
                        end
                    case 2215
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2215_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2215_Sca2;
                        end
                    case 2219
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2219_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2219_Sca2;
                        end
                    case 2221
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2221_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2221_Sca2;
                        end
                    case 2223
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2223_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2223_Sca2;
                        end
                end
        end
        psb_CreateAllSubPlotsOfFrameAtCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
        close;      close;  	close;      close; % close figure
        cd ..;
    end
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create diagrams of building failures JUST BEFORE collapse 
    if analyzeProcessPlotIndex(6) == 1
        cd MovieAndVisualProcessors
        
        switch eqListID
            case 'setC'
                eqNumberLIST = eqNumberLIST_forProcessing_SetC;
                
            case 'setD'
                eqNumberLIST = eqNumberLIST_forProcessing_SetD;
                
            case 'setG'
                eqNumberLIST = eqNumberLIST_forProcessing_SetG;
                
            case 'setDandG'
                eqNumberLIST = eqNumberLIST_forProcessing_SetDandG;
                
            case 'setTest'
                eqNumberLIST = eqNumberLIST_forProcessing_SetTest;
                
            case 'SetCS_22'
                % Run site-specific conditional spectra matching 22 GMs
                switch bldgID
                    case 2211
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2211_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2211_Sca2;
                        end
                    case 2213
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2213_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2213_Sca2;
                        end
                    case 2215
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2215_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetDel22_2215_Sca2;
                        end
                    case 2219
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2219_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2219_Sca2;
                        end
                    case 2221
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2221_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2221_Sca2;
                        end
                    case 2223
                        switch maxScalingTH
                            case 4
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2223_Sca4;
                            case 2
                                eqNumberLIST = eqNumLIST_forProcessing_SetGuw22_2223_Sca2;
                        end
                end
        end
        psb_CreateAllSubPlotsOfFrameJustBeforeCol_proc(analysisTypeLIST,modelNameLIST, bldgID, eqNumberLIST);
        close; % close figure
        cd ..;
    end
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Process stripes and create stripe files. This makes a stripe file for
    % each Sa level and then makes one summary file for all stripes.
        % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Process Stripes for GM Set C - Sa,GEOMEAN
%             eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetC;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
%             saLevelsForStripes;     % Defined previously
%             isConvertToSaKircher = 0;   % We can use this to instead process and save files based on Sa,Kircher;
%             isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
%             ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent, dampingRatioUsedForSaDef);
%         % [STANDARD for JS - Summer of 2008 ATC-63-1 study] [STANDARD] Process Stripes for GM Set C - Sa,ATC63
%             eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetC;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetC;
%             saLevelsForStripes;     % Defined previously
%             isConvertToSaKircher = 1;   % We can use this to instead process and save files based on Sa,Kircher;
%             isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
%             ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
%         % [STANDARD] Process Stripes for GM Set D - Sa,GEOMEAN
%             eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetD;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetD;
%             saLevelsForStripes;     % Defined previously
%             isConvertToSaKircher = 0;   % We can use this to instead process and save files based on Sa,Kircher;
%             isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
%             ProcessStripeStatisticsForCollapseRuns_proc(analysisType, eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
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
%             eqNumberLIST_forStripes = eqNumberLIST_forProcessing_SetTest;
%             eqListForCollapseIDAs_Name = eqListForCollapseIDAs_Name_SetTest;
%             saLevelsForStripes;     % Defined previously
%             isConvertToSaKircher = 0;   % We can use this to instead process and save files based on Sa,Kircher;
%             isConvertToSaComponent = 0;   % We can use this to instead process and save files based on Sa,Component;
%             ProcessStripeStatisticsForCollapseRuns_proc(analysisType,eqNumberLIST_forStripes, eqListForCollapseIDAs_Name, saLevelsForStripes, isConvertToSaKircher, isConvertToSaComponent);
            
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
        
        switch eqListID
            
            % [Find the optimum parameters for Cordvoa Intensity Measures]
            case 'setC'
                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_SetC;
                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_SetC;
                
            case 'setD'
                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_SetD;
                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_SetD;
                
            case 'setG'
                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_SetG;
                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_SetG;
                
            case 'SetCS_22'
                % Run site-specific conditional spectra matching 22 GMs
                switch bldgID
                    case 2211
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Del22_2211_Sca4;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Del22_2211_Sca4;
                            case 2
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Del22_2211_Sca2;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Del22_2211_Sca2;
                        end
                    case 2213
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Del22_2213_Sca4;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Del22_2213_Sca4;
                            case 2
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Del22_2213_Sca2;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Del22_2213_Sca2;
                        end
                    case 2215
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Del22_2215_Sca4;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Del22_2215_Sca4;
                            case 2
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Del22_2215_Sca2;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Del22_2215_Sca2;
                        end
                    case 2219
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Guw22_2219_Sca4;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Guw22_2219_Sca4;
                            case 2
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Guw22_2219_Sca2;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Guw22_2219_Sca2;
                        end
                    case 2221
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Guw22_2221_Sca4;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Guw22_2221_Sca4;
                            case 2
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Guw22_2221_Sca2;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Guw22_2221_Sca2;
                        end
                    case 2223
                        switch maxScalingTH
                            case 4
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Guw22_2223_Sca4;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Guw22_2223_Sca4;
                            case 2
                                eqNumberLIST_forCordovaIDA = eqNumberLIST_forCollapseIDAs_Guw22_2223_Sca2;
                                eqListForCollapseIDAs_Cordova_Name = eqListForCollapseIDAs_Name_Guw22_2223_Sca2;
                        end
                end
        end
        
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% If we reached here, save a file on desktop stating the same. Since, I am running two analyses back to back, I wouldn't be able to know if there 
% was any error in running the first analyses

    tElapsed = toc(tStart);
    
    fileName = sprintf('CheckFile %s.mat', analysisType);
    cd C:\Users\Prakash\Desktop
    save(fileName, 'tElapsed');

    % Go back to starting folder
    cd(baseFolder)
    toc