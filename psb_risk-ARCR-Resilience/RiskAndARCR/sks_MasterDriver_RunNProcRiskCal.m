tic 
tStart= tic;

% -------------------
% This runs the seismic risk analyses, processes the analyses, then makes/saves all of the results.
%
% Author:  
% Modified by Prof. Prakash S Badal and Shivakumar K S at IIT Madras
%
% Units: Whatever OpenSees is using - kN, mm, radians
%
% -------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define Building Information Inputs

analysisTypeLIST = {'(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)'};
analysisType = analysisTypeLIST{1};         % Just renaming variable and changing variable format for some of the processors

BldgIdAndZoneLIST = {'46053v02', 'VI_proposed'; };
BldgIdLIST = BldgIdAndZoneLIST(:,1);
% BldgId = regexp(BldgIdLIST{1}, '^\d+', 'match', 'once');
BldgId = BldgIdLIST{1};

MIDR_or_PHR = 'MIDR'; % later on, maybe extended to include DI-based limits

eqListID = 'setC';  
% eqListID = 'setD' ;
% eqListID = 'setDNotC'; 
% eqListID = 'setG';
% eqListID = 'setTest';
% eqLIST =  'siteSpecific';

%                        fragDataGen   im_efficiency      RiskCal     RTGM     
analyzeProcessPlotIndex = [1               1                1           0];

%% Define the GM sets 
switch eqListID

    case 'setC'
        % ATC-63 Ground Motion Set C (Far-Field)SetTest
        eqNumberLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        eqFormatForCollapseList_SetC = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetC = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        MIDRInputs.GMsuiteName = 'GMSetC';
        
    case 'setD'
        % ATC-63 Ground Motion Set D (expanded Far-Field)
        eqNumberLIST = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
        eqFormatForCollapseList_SetD = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetD = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        MIDRInputs.GMsuiteName = 'GMSetD';

    case 'setDNotC'
        % ATC-63 Records that Are in Set D AND NOT IN C
        eqNumberLIST = [120131	120132	120141	120142	120151	120152	120161	120162	120631	120632	120641	120642	120731	120732	120741	120742	120931	120932	121031	121032	121041	121042	121051	121052	121061	121062	121231	121232	121431	121432	121441	121442	121451	121452	121461	121462];
        eqFormatForCollapseList_SetInDNotC = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetInDNotC = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        MIDRInputs.GMsuiteName = 'GMSetDNotC';

    case 'setG'
        % ATC-63 Ground Motion Set G (Near-Field)
        eqNumberLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
        eqFormatForCollapseList_SetG = 'PEER-NGA_Rotated_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetG = 2;                           % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        MIDRInputs.GMsuiteName = 'GMSetG';

    case 'setTest'
        % Test GM set
        eqNumberLIST =  [120121, 120122,	121221, 121222]; % replaced last 2 GMs by EQs of shorter duration
        eqFormatForCollapseList_SetTest = 'PEER-NGA_geoMean';  % This is the type of these records, and this is saying to scale them by Sa,geoMean
        flagForEQFileFormat_SetTest = 2;                       % 1 for scaling to Sa,component and 2 for scaling to Sa,geoMean
        MIDRInputs.GMsuiteName = 'GMSetTest';

    case 'siteSpecific'
        MIDRInputs.GMsuiteName = 'GMsiteSpecific';
        switch BldgId
            case '46053v02'
                eqNumberLIST= [6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272];
            case '36053v01'
                eqNumberLIST= [6000341	6000342	6001831	6001832	6003141	6003142	6004091	6004092	6004191	6004192	6004991	6004992	6005301	6005302	6006391	6006392	6007691	6007692	6009081	6009082	6009701	6009702	6009711	6009712	6009871	6009872	6010121	6010122	6010301	6010302	6012571	6012572	6016111	6016112	6017361	6017362	6023951	6023952	6029501	6029502	6032061	6032062	6032861	6032862];
        end
end
% end of ground motion definition...

%% Start of Inputs   
MIDRInputs.eqNumberLIST = eqNumberLIST;

%% Site-Specific Inputs
latLonLIST = [ % input depending on the site (lat, lon)
    %     13.05	80.27; % Chennai
    %     22.55	88.37; % Kolkata
    %     19.00   72.80; % Mumbai   (Table 5.4 of NDMA, 2011 report)
    % 28.62   77.22; % Delhi
    26.17   91.77; % Guwahati
    %     27.10   92.10; % an arbitrary grid point near Arunachal border
    ];
locName = 'Guwahati';
zoneOfLocLIST =  {'VI_proposed';}; % {'III'; 'IV'; 'V'; 'VI'}; % size of this input must match with the size of the latLonLIST 
imScaleFac = 1; % this is an optional variable; used for paramteric study to see the impact of hazard variation on risk 
impFacLIST = 0;


%% Hazard-Specific Inputs
fitModelLIST =  {'2param', '3param'}; %{'3param'};  Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)] the hazard fitting parameter
% fitModel = fitModelLIST{2};
NLIST = 21; % [11, 21, 51]; % number of points between consecutive imValLIST values
codeIdealizedHazData = 0; % 1, the program uses code-idealized hazard using two-parameter model based on DBE and MCE values (% 0 = PSHA hazard, 1 = code-idealized)


%% Building-Specific Inputs
timePLIST = [0,0.04:0.01:5]; % skipping 0.01, 0.02, and 0.03 because several response spectra has Inf for these periods
T1LIST = [1.56]'; % (eigenvalue analysis) geoM_Topt2 (<= 2sec), % Select list of period T1 for Intensity measure, Sa(T1), corresponding to each building
TaLIST = [0.71]; % (approximate period as per code)
TogmLIST =  [1.27]'; % (obtained from IM_efficiency) (optimization across timePLIST) and to be passed on to seismic risk calculation
isSinglePeriodAnalysis = true; 


%  %Intensity Measure Selection; 
intensityMeasureType = 'SaT1'; % Options:'PGA', 'SaTa', 'SaT1', 'SaTogm'
switch intensityMeasureType
    case 'PGA'
        imTypeLIST = {'PGA'};
    case 'SaTa'
        imTypeLIST = {'Sa_Ta'};
    case 'SaT1'
        imTypeLIST = {'Sa_T1'};     
    case 'SaTogm'
        imTypeLIST = {'Sa_Togm'};
    otherwise
        error('Unknown intensity measure option');
end
% imTypeLIST = {'PGA','Sa_0p1','Sa_0p2','Sa_0p5','Sa_0p9','Sa_1p0','Sa_1p2','Sa_2p0','Sa_5p0'}; % Multiple IMs

%% Damage-Specific Inputs,
switch MIDR_or_PHR
    case 'MIDR'

        damageMeasure = 'MIDR_based_4ds';
        % damageMeasure = 'MIDR_based_cont_ds';

        switch damageMeasure
            case 'MIDR_based_4ds'
                dsLIST = {'DynInst','CP','LS','IO'}; % Conventional MIDR-based damage states

            case 'MIDR_based_cont_ds'
                midrValues = 0.2:0.2:4.0; %% MIDR-based continuous damage states (0.2% to 4.0%)
                dsLIST = { ...
                    'midr_0p2pc', 'midr_0p4pc', 'midr_0p6pc', 'midr_0p8pc', 'midr_1p0pc', ...
                    'midr_1p2pc', 'midr_1p4pc', 'midr_1p6pc', 'midr_1p8pc', 'midr_2p0pc', ...
                    'midr_2p2pc', 'midr_2p4pc', 'midr_2p6pc', 'midr_2p8pc', 'midr_3p0pc', ...
                    'midr_3p2pc', 'midr_3p4pc', 'midr_3p6pc', 'midr_3p8pc', 'midr_4p0pc'};
            otherwise
                error('Unknown MIDR damage measure');
        end
    case 'PHR'
       damageMeasure = 'PHR_ds';
       dsLIST = {'DS4', 'DS3_normalizedByThetaCap', 'DS2a_0p50_normalizedByThetaCap', 'DS1',... 
            'DS2_normalizedByThetaCap', 'DS2a_0p60_normalizedByThetaCap', 'DS2a_0p40_normalizedByThetaCap'};
    otherwise
        error('Unknown MIDR_or_PHR option');
end

%% PHR Specific parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHR DS1 Inputs
deltaYieldBasisFlag = 'ASCE41'; % options: 'ASCE41', 'FEMAP695' 
switch deltaYieldBasisFlag
    case 'ASCE41'
        deltaYieldBasis = 'deltaYieldBasedOnASCE41'; % idealizing trilinear pushover curve as per ASCE 41-13 section 7.4.3.2.4 which in turn refers to FEMA 440 section 4.3
    case 'FEMAP695'
        deltaYieldBasis = 'deltaYieldBasedOnFEMAP695'; % delta Yield Effective as per FEMA P 695 Figure 6-5 
    otherwise
        error('Invalid deltaYieldBasisFlag');
end

% PHR DS2 Inputs
chi_LimitStateDS2 = 0.75; % for DS2, limit over chi, the ratio of max rotation to ultimate rotation capacity, chi = rotation Ratio = thetaM/thetaU

% PHR DS2-DS3 Inputs
% LimitStateValLIST = [0.75, 0.60, 0.50, 0.40]; % for DS2, limit over chi (thetaM / thetaU), or xi (thetaM / thetaCap) 
% LimitStateValLIST = [1.0]; % for DS3, limit over chi (thetaM / thetaU), or xi (thetaM / thetaCap) 
LimitStateValLIST = [1.0, 0.75, 0.60, 0.50, 0.40]; % DS2-DS3, limit over chi (thetaM / thetaU), or xi (thetaM / thetaCap) 
executeProcessingStep = 1; % set this to 1, if we are interested in processing the analysis data for finding out chi, xi, etc.
executePrintAndSaveStep = 1; % set this to 1, if we are interested in printing the fragility results 
executeHistogramStep = 1; % set this to 1, if we are interested in histogram for distribution of critical column ID
% chi_LimitState = 0.75; % merely to decide the controlling component


% PHR DS4 Inputs
storyDriftLIST= [0.00, 0.04, 0.02, 0.01]; % (values in fraction). 0.00 indicates sidesway collapse (dynamic instability)

%IM efficiency PHR %%%%%%%%%%%
dsToPlotFragParam = {'DS4', 'DS3_normalizedByThetaCap', 'DS2a_0p50_normalizedByThetaCap', 'DS1'};
dsLegForPlot = {'DS4', 'DS3', 'DS2', 'DS1'}; 
doPlotFragMedian = 1; % plot variation in median fragility parameter with the period of vibration
doPlotFragDispers = 1; % plot variation in dispersion fragility parameter with the period of vibration
doPlotFragBound = 1; % plot the bounds of fragility with the period of vibration
dsToPlotBound = {'DS4'}; %, {'DS4', 'DS3', 'DS2', 'DS1'}; % one damage state at a time here. 
doPlotT1LinesInFragDisp = 1; % adding a vertical line for T1 in IM-efficiency figures
saveMedianDispersionBound = [1 1 1];

%Risk Specific PHR %%%%%%%%%%%
consqModel = [2, 10, 40.4, 100]; % DS1, DS2, DS3, and DS4; repair cost ratio (% of building repair cost) (COM4 from HAZUS 2003)
factorOnImMin = 1; % optional variable that reduces the imMin value,
saveFigures = 1; % when running for optimal beta, do not saveFigures
pLIST = [0.20, 0.10, 0.02, 0.01, 0.005]; % (in fraction) i.e., 0.10 for 10% poe in 50 years.

%% Plot-Specific Inputs
formatMode = 'powerpoint';
verbose = 1; % for debugging, set this to 2; this will just print more intermediate results

%% MIDR inputs begin here
MIDRInputs.timePLIST =                timePLIST;
MIDRInputs.damageMeasure =            damageMeasure;
MIDRInputs.dsLIST =                   dsLIST;
MIDRInputs.BldgIdAndZoneLIST =        BldgIdAndZoneLIST;
MIDRInputs.BldgId =                   BldgId;
MIDRInputs.latLonLIST =               latLonLIST;
MIDRInputs.locName =                  locName; % selects the site in hazard_20260818.mat ('Guwahati' or 'Delhi')
MIDRInputs.zoneOfLocLIST =            zoneOfLocLIST;
MIDRInputs.imScaleFac =               imScaleFac;
MIDRInputs.intensityMeasureType =     intensityMeasureType;
MIDRInputs.imTypeLIST =               imTypeLIST;
MIDRInputs.impFacLIST =               impFacLIST; 
MIDRInputs.fitModelLIST =             fitModelLIST;
MIDRInputs.NLIST =                    NLIST;
MIDRInputs.TaLIST =                   TaLIST;
MIDRInputs.T1LIST =                   T1LIST; 
MIDRInputs.TogmLIST =                 TogmLIST;
MIDRInputs.isSinglePeriodAnalysis =   isSinglePeriodAnalysis;
MIDRInputs.codeIdealizedHazData =     codeIdealizedHazData;
MIDRInputs.factorOnImMin =            factorOnImMin;
MIDRInputs.verbose =                  verbose;
MIDRInputs.formatMode =               formatMode; 
MIDRInputs.baseFolder =               pwd;

PHRInputs = MIDRInputs;

% PHR inputs begin here
PHRInputs.analysisType =              analysisType;
PHRInputs.BldgIdLIST =                BldgIdLIST;
PHRInputs.dsLIST =                    dsLIST;
PHRInputs.locName =                   locName;
PHRInputs.deltaYieldBasis =           deltaYieldBasis;
PHRInputs.storyDriftLIST =            storyDriftLIST;
PHRInputs.chi_LimitStateDS2 =         chi_LimitStateDS2;
PHRInputs.LimitStateValLIST =         LimitStateValLIST; 
PHRInputs.executeProcessingStep =     executeProcessingStep;
PHRInputs.executePrintAndSaveStep =   executePrintAndSaveStep;
PHRInputs.executeHistogramStep =      executeHistogramStep;
PHRInputs.dsToPlotFragParam =         dsToPlotFragParam;
PHRInputs.dsLegForPlot =              dsLegForPlot;
PHRInputs.doPlotFragMedian =          doPlotFragMedian;
PHRInputs.doPlotFragDispers =         doPlotFragDispers;
PHRInputs.doPlotFragBound =           doPlotFragBound;
PHRInputs.dsToPlotBound =             dsToPlotBound;
PHRInputs.doPlotT1LinesInFragDisp =   doPlotT1LinesInFragDisp;
PHRInputs.saveMedianDispersionBound = saveMedianDispersionBound;
PHRInputs.consqModel =                consqModel;
PHRInputs.saveFigures =               saveFigures;
PHRInputs.pLIST =                     pLIST;
% End of Inputs



%% Run Fragility Data generation  
if analyzeProcessPlotIndex(1) == 1
    runFlags.runDS1       = 1;
    runFlags.runDS23      = 1;
    runFlags.runDS4       = 1;
    runFlags.runFragParam = 1;

sks_FragilityData(MIDR_or_PHR, MIDRInputs, PHRInputs, runFlags)
end
% End of fragility data generation


%% Start of intensity measure efficiency
if analyzeProcessPlotIndex(2) == 1
    sks_IM_efficieny(MIDR_or_PHR, MIDRInputs, PHRInputs);
end 
% End of intensity measure efficiency 


%% Start of Seismic Risk Calculation
if analyzeProcessPlotIndex(3) == 1
    sks_seismicRiskCal(MIDR_or_PHR, MIDRInputs, PHRInputs);
end 

%% Start of Seismic Risk Calculation
if analyzeProcessPlotIndex(4) == 1
    fprintf('RTGM not yet implemented.\n');
end 

% End of seismic risk calculation
 toc
