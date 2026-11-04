%% -------------------
% Scenario-based housing recovery and resilience analysis of a building.
%
% For a scenario earthquake (M, Rjb), this script:
%   1. gets the median and log-std of Sa(T1) from a GMPE and generates N1 realizations of Sa(T1),
%   2. loads (or extracts from the IDA/MSA output) the fragility functions for DS1-DS5 and adds
%      modelling, design-requirement and test-data uncertainty to the record-to-record dispersion,
%   3. computes the expected recovery function Q(t) for each Sa(T1) realization (Burton et al. 2015),
%   4. plots and saves the fragility, recovery and uncertainty figures (sks_plotResilience.m),
%   5. computes days to recover, robustness, rapidity and resilience (sks_ComputeRobRapRes.m),
%   6. saves the raw and processed results as .mat files,
%   7. computes mean repair time vs Sa(T1) on a fixed Sa grid (fun4meanRepTime_v1.m) and plots it
%      against Sa(T1)/Sa_MCE (sks_plotMeanRepairTime.m) - merged from sks_MasterDriver_MeanRepTimeVsSaMCE.m.
%
% Assumptions and Notices:
%   - If ..\RiskAndARCR\fragRes_<ID>_<GMSet>.mat exists, it is loaded and NOT recomputed. Delete it after
%     changing T1forIM, DS_StoryDriftLIST or the IDA/MSA results.
%
% Function files and scripts used:
%   ..\..\HazardAnalysis\gm-selection\GMPE\BA_2008_nga.m, BSSA_2014_nga.m - median and sigma of Sa(T1)
%   ..\RiskAndARCR\extractFragilityForMIDR_v1.m      - fragility extraction (only if fragRes_*.mat is missing)
%   fun3expctedRecovery_v1.m (calls fun2housingCapacity_v1.m) - expected recovery function Q(t)
%   sks_ComputeRobRapRes.m                           - days to recover, robustness, rapidity, resilience
%   fun4meanRepTime_v1.m                             - mean repair time vs Sa(T1)
%   sks_plotMeanRepairTime.m (script)                - mean repair time figures (run after the building loop)
%   sks_plotResilience.m (script)                    - all figures; uses PlotLogNormalCDF_current.m,
%                                                      sks_figureFormat.m, sks_figureExport.m (psb_MatlabProcessors)
%
% Units: Sa in g, time in days, rapidity in year^(-1)
%
% Reference: Burton, H. V., Deierlein, G., Lallemant, D., and Lin, T. (2015). Framework for incorporating
%            probabilistic building performance in the assessment of community seismic resilience. J. Struct. Eng.
%
% Author: Prakash S Badal
% Modified by Shivakumar K S, IIT Madras (22nd-Oct-2026): 
%% -------------------

clear;
tstart = tic;
close all;
baseFolder = pwd;

%% (Start Inputs)%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Inputs- 1/4) Building-specific inputs - change this for the building being used
buildingIDLIST = {'46053v02'; '35053v02'}; %{1310v1_NF' '1310v1_FF'}
% legStr = {'3-Story (FF)', '3-Story (NF)', '6-Story (FF)', '6-Story (NF)', '9-Story (FF)', '9-Story (NF)'}; 
% plotStyle = {'k-', 'k--', 'b-', 'b--', 'r-', 'r--'}; figNameSuff = 'allSix';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% SCENARIO / GMPE OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Inputs- 2/4) Scenario/GMM inputs
M = 7.45;
Rjb = 13.9;                   % Joyner-Boore distance in km
% T1forIM = 1.68;           % T1forIM is building specific (see building switch below)
N1 = 1e4;                   % realizations of spectral acceleration.
rngSeed = 3;                % random seed for realizations of Sa(T1)
% GMPM = 'BA08';            % Boore Atkinson (2008) NGA
GMPM = 'BSSA14';            % Boore et al (2014) NGA (NRCan gives 0.25 weight to each of ASK14, BSSA14, CB14, CY14 for SWCan)
Vs30 = 760;                 % m/s
Fault_Type_BA08   = 3;      % 1 for unspecified fault; 2 for strike-slip fault; 3 for normal fault; 4 for reverse fault
Fault_Type_BSSA14 = 2;      % 0 for unspecified fault, 1 for strike-slip fault, 2 for normal fault, 3 for reverse fault
region_BSSA14 = 0;          % BSSA14 region
z1_BSSA14 = 999;            % BSSA14 basin depth (999 = default)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% FRAGILITY OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Inputs- 3/4) Fragility inputs
% DS_StoryDriftLIST = [0.01, 0.02, 0.04, 0.00];
DS_StoryDriftLIST = [0.005, 0.01, 0.02, 0.04, 0.00]; % DS1, DS2, DS3, DS4 (0.00 indicates sidesway collapse or dynamic instability)
sigmaLnModeling  = 0.35;    % βMDL
sigmaLnDesignReq = 0.1;     % βDR
sigmaLnTestData  = 0.2;     % βTD
beta_MDL_DR_TD = sqrt(sigmaLnModeling^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% RESILIENCE OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Inputs- 4/4) Resilience inputs
% pcLIST = 50:5:95;
pcLIST = [75, 80, 85, 90, 95, 99];              % percent recovery. Find out days to recover to 90% of the original housing capacity.
% maximumHousingCapacity = 65; %max(meanExpectedHousingFunction);
maximumHousingCapacity = 1;
rapidity_daysLIST = [30, 180, 365, 545, 730];   % control times for rapidity/resilience (days)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% PLOT / SAVE OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doPrint = 1;
saveFigures = 1;                                % when running for optimal beta, do not saveFigures
legOn = 1;    
colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00; 0.90 0.60 0.00];   % blue, magenta, black, red, orange (LS/DS/T_c or building 1-5)
colors = [colors; lines(max(0, max([numel(DS_StoryDriftLIST), numel(rapidity_daysLIST), size(buildingIDLIST, 1)]) - size(colors, 1)))];   % extra colors only if more than 5 LS, 
dirForFigures = fullfile('Output_Res', sprintf('figures_resCombined_M%g_R%g_R2_RESUnc', M, Rjb));   % relative to baseFolder (Resilience)
figureFolder  = fullfile(baseFolder, dirForFigures);
if ~exist(figureFolder, 'dir')                  % Actually create the folder on disk if it doesn't exist
    mkdir(figureFolder);
end
plotMeanWithBound = 0;                          % mean repair time plot: 1 = mean with 16/84% bounds (single building)
figNameSuff = strjoin(buildingIDLIST, '_');     % export-name suffix for the mean repair time figures, e.g. '46053'



%                         Resilience   meanRepTime
analyzeProcessPlotIndex = [1                1];



for i = 1:size(buildingIDLIST, 1)
    buildingID = buildingIDLIST{i, 1};

    %% Building-specific inputs (only what cannot be read from the IDA/MSA output)
    switch buildingID
        case '46053v02'
            analysisType = '(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
            outputRoot   = fullfile(baseFolder, '..', '..', 'Output');      % ida-spo-msa\Output
            numStories = 5; 
            Sa_MCE = 0.80;                                                  % from PSHA hazard

        case '35053v02'
            analysisType = '(ID35053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
            outputRoot   = fullfile(baseFolder, '..', '..', 'Output');      % ida-spo-msa\Output
            numStories = 5; 
            Sa_MCE = 0.68;

        case '1310v1_NF'
            analysisType = '(ID1310_v.01_NF)_(AllVar)_(0.00)_(clough)';
            outputRoot   = 'E:\prak\ResilAnaOS_psb\Output';
            numStories = 3; 
            Sa_MCE = 0.435;
        otherwise
            error('Building %s not defined', buildingID);
    end
    outpFolderLIST = {fullfile(outputRoot, analysisType)};

    %% GM suite, record list and T1, read from the IDA/MSA output
    statsFile = dir(fullfile(outpFolderLIST{1}, 'DATA_collapse_CollapseSaAndStats_*_SaGeoMean.mat'));
    if numel(statsFile) ~= 1
        error('Expected one DATA_collapse_CollapseSaAndStats_*_SaGeoMean.mat in %s, found %d', outpFolderLIST{1}, numel(statsFile));
    end
    S = load(fullfile(outpFolderLIST{1}, statsFile.name), 'eqListForCollapseIDAs_Name', 'eqCompNumberLIST', 'periodUsedForScalingGroundMotions');
    GMsuiteName = S.eqListForCollapseIDAs_Name;           % GM suite, e.g. 'GMSetC'
    eqLIST      = S.eqCompNumberLIST;                     % all GM components analysed
    T1forIM     = S.periodUsedForScalingGroundMotions;    % period used to scale the GMs
    fprintf('Building %s: %s, %d GM components, T1 = %.2f s\n', buildingID, GMsuiteName, numel(eqLIST), T1forIM);

    if analyzeProcessPlotIndex(1) == 1
        %% GMPE: median and log-std of Sa(T1)
        cd(fullfile(baseFolder, '..', '..', 'HazardAnalysis', 'gm-selection', 'GMPE'));   % original GMPE folder (no copy kept in Resilience)
        % [Sa, sigma, period1] = BA_2008_nga (M, T, Rjb, Fault_Type, Vs30)
        [Sa_T1_BA08, sigma_T1_BA08, ~] = BA_2008_nga(M, T1forIM, Rjb, Fault_Type_BA08, Vs30);
        % [median, sigma, period1] = BSSA_2014_nga(M, T, Rjb, Fault_Type, region, z1, Vs30);
        [Sa_T1_BSSA14, sigma_T1_BSSA14, ~] = BSSA_2014_nga(M, T1forIM, Rjb, Fault_Type_BSSA14, region_BSSA14, z1_BSSA14, Vs30);
        % [Sa_T1_ASK14 , sigma_T1_ASK14 ] = ASK_2014_nga(M, Rjb, period) ;
        % [Sa_T1_CB14  , sigma_T1_CB14  ] = CB_2014_nga(M, Rjb, period)  ;
        % [Sa_T1_CY14  , sigma_T1_CY14  ] = CY_2014_nga(M, Rjb, period)  ;
        cd(baseFolder);

        %% 1. generate 10,000 realizations of intensity measure (e.g., SaT1)
        rng(rngSeed, 'twister')
        epsList = randn(N1, 1);
        % epsList = 0;

        switch GMPM
            case 'BA08'
                Sa_realizations = Sa_T1_BA08 * exp(epsList * sigma_T1_BA08);
            case 'BSSA14'
                Sa_realizations = Sa_T1_BSSA14 * exp(epsList * sigma_T1_BSSA14);
            case 'ASK14'
                Sa_realizations = Sa_T1_ASK14 * exp(epsList * sigma_T1_ASK14);
            case 'CB14'
                Sa_realizations = Sa_T1_CB14 * exp(epsList * sigma_T1_CB14);
            case 'CY14'
                Sa_realizations = Sa_T1_CY14 * exp(epsList * sigma_T1_CY14);
        end
    end
    %% 2. Import Fragility Data from DamageState folder (valid for arbitrary SaT1 using variable T1forIM)
    cd(baseFolder);
    bldgNum = str2double(regexp(buildingID, '^\d+', 'match', 'once'));
    fileNameToSaveFragData = sprintf('fragRes_%s_%s', buildingID, GMsuiteName);
    cd(fullfile(baseFolder, 'DATA_files'));
    fragInfo = dir([fileNameToSaveFragData '.mat']);
    if ~isempty(fragInfo) && fragInfo.datenum > statsFile.datenum     % fragRes newer than the IDA/MSA results -> reuse it
        load(fileNameToSaveFragData, 'fragParamMuCtrl_mat', 'fragParamBetaCtrl_mat', 'fragParamImMinCtrl_mat');
        meanSa = fragParamMuCtrl_mat;
        sigmaLn = fragParamBetaCtrl_mat;
        imMin = fragParamImMinCtrl_mat;
    else
        [~, ~, ~, meanSa, sigmaLn, imMin] = extractFragilityForMIDR_v1(bldgNum, outpFolderLIST, DS_StoryDriftLIST, eqLIST, GMsuiteName, T1forIM, fileNameToSaveFragData);
    end
    disp(array2table([meanSa/Sa_MCE; sigmaLn], 'VariableNames', {'LS1','LS2','LS3','LS4','LS5'}, 'RowNames', {'mu/Sa_MCE', 'beta_RTR'}));

    sigmaLn = sqrt(sigmaLn.^2 + beta_MDL_DR_TD^2);
    disp(array2table(sigmaLn, 'VariableNames', {'LS1','LS2','LS3','LS4','LS5'}, 'RowNames', {'beta_TOT'}));

    Res(i).buildingID = buildingID;  Res(i).T1forIM = T1forIM;  Res(i).numStories = numStories;  Res(i).legOn = legOn;
    Res(i).GMsuiteName = GMsuiteName;  Res(i).Sa_MCE = Sa_MCE;  Res(i).meanSa = meanSa;  Res(i).sigmaLn = sigmaLn;
    Res(i).nBldg = size(buildingIDLIST, 1);  Res(i).M = M;  Res(i).Rjb = Rjb;  Res(i).GMPM = GMPM;  Res(i).N1 = N1; 
    Res(i).beta_MDL_DR_TD = beta_MDL_DR_TD;  Res(i).pcLIST = pcLIST;  Res(i).maximumHousingCapacity = maximumHousingCapacity;
    Res(i).rapidity_daysLIST = rapidity_daysLIST;  Res(i).baseFolder = baseFolder;  Res(i).dirForFigures = dirForFigures; Res(i).colors = colors;
    cd(baseFolder)


    if analyzeProcessPlotIndex(1) == 1
        %% 3. Calculating the expected recovery function for each realization of the scenario earthquake
        [timeArray, expectedHousingFunction, meanExpectedHousingFunction, meanHousingCapacityMatrix] = fun3expctedRecovery_v1(meanSa, sigmaLn, Sa_realizations, numStories);
        sigmaHouse = std(expectedHousingFunction, 0, 1);
        sigmaLnHouse = std(log(expectedHousingFunction), 0, 1);


        Res(i).Sa_realizations = Sa_realizations;  Res(i).timeArray = timeArray;  Res(i).meanHousingCapacityMatrix = meanHousingCapacityMatrix;
        Res(i).meanExpectedHousingFunction = meanExpectedHousingFunction;  Res(i).sigmaHouse = sigmaHouse;

        if saveFigures == 1  %Plots (figures 100+, 786, 200+, 401, 301, 302)
            sks_plotResilience(Res(i), i);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 4. Days to recover, robustness, rapidity, resilience
        robRapRes = sks_ComputeRobRapRes(timeArray, meanExpectedHousingFunction, pcLIST, maximumHousingCapacity, rapidity_daysLIST, buildingID, doPrint);
        RapResMatrix(i, :) = [robRapRes.rapidity, robRapRes.resilience];

        robustness =                 robRapRes.robustness;
        QtAfterDaysLIST =            robRapRes.QtAfterDays;
        rapidity_average_afterDays = robRapRes.rapidity;
        ReselienceAfterDays =        robRapRes.resilience;

        %% 5. Save raw results (recovery curves + metrics)
        rawDataMat  = fullfile(baseFolder, dirForFigures, sprintf('ResData_raw_%s.mat', buildingID));
        save(rawDataMat, 'buildingID', 'M', 'Rjb', 'GMPM', 'T1forIM', 'numStories', 'GMsuiteName', 'Sa_realizations', 'meanSa', 'sigmaLn', 'timeArray', 'expectedHousingFunction', 'meanExpectedHousingFunction', ...
        'meanHousingCapacityMatrix', 'sigmaHouse', 'sigmaLnHouse', 'robRapRes', 'robustness', 'rapidity_daysLIST', 'QtAfterDaysLIST', 'rapidity_average_afterDays', 'ReselienceAfterDays');
        fprintf('Raw .mat file saved as %s.\n', rawDataMat);
    end


    if analyzeProcessPlotIndex(2) == 1
        %% 6. Mean repair time vs Sa(T1) (merged from sks_MasterDriver_MeanRepTimeVsSaMCE.m)
        Sa_realizations = 0.01:0.01:2.0;   % Sa grid; the GMPE realizations above are already used and saved, and step 1 regenerates them for the next building
        [meanRepairTime, repairTimeAllData] = fun4meanRepTime_v1(meanSa, sigmaLn, Sa_realizations, numStories);
        stdev_log = std(log(repairTimeAllData), 0, 1);
        if ~exist(fullfile(baseFolder, 'Output_Res', 'figures_repTimeVsSa_R1_betaTOT'), 'dir')
            mkdir(fullfile(baseFolder, 'Output_Res', 'figures_repTimeVsSa_R1_betaTOT'));
        end
        save(fullfile(baseFolder, 'Output_Res', 'figures_repTimeVsSa_R1_betaTOT', sprintf('MeanRepairTime_%s.mat', buildingID)), 'Sa_realizations', 'meanRepairTime', 'repairTimeAllData', 'stdev_log', 'Sa_MCE');
    end
end

if analyzeProcessPlotIndex(1) == 1 && saveFigures == 1
    sks_plotResilienceCombined(Res);
end

       %% 7. Plots: mean repair time and its dispersion vs Sa(T1)/Sa_MCE (figures 601, 602) - see sks_plotMeanRepairTime.m
        if analyzeProcessPlotIndex(2) == 1 && saveFigures == 1
            sks_plotMeanRepairTime(baseFolder, buildingIDLIST, plotMeanWithBound,  colors);
        end

cd(baseFolder);
toc