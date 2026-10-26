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
%   6. saves the raw and processed results as .mat files.
%
% Assumptions and Notices:
%   - Run this script from the ...\psb_risk-ARCR-Resilience\Resilience folder (baseFolder = pwd).
%   - psb_FigureFormatScript_paper.m (psb_MatlabProcessors) must be on the MATLAB path.
%   - If ..\RiskAndARCR\fragRes_<ID>_<GMSet>.mat exists, it is loaded and NOT recomputed. Delete it after
%     changing T1forIM, DS_StoryDriftLIST or the IDA/MSA results.
%
% Function files and scripts used:
%   GMPE\BA_2008_nga.m, GMPE\BSSA_2014_nga.m       - median and sigma of Sa(T1)
%   ..\RiskAndARCR\extractFragilityForMIDR_v1.m      - fragility extraction (only if fragRes_*.mat is missing)
%   fun3expctedRecovery_v1.m (calls fun2housingCapacity_v1.m) - expected recovery function Q(t)
%   sks_ComputeRobRapRes.m                           - days to recover, robustness, rapidity, resilience
%   sks_plotResilience.m (script)                    - all figures; uses PlotLogNormalCDF_current.m,
%                                                      sks_figureFormat.m, sks_figureExport.m (psb_MatlabProcessors)
%
% Input .mat files:
%   ..\RiskAndARCR\fragRes_<ID>_<GMSet>.mat          - fragParamMuCtrl_mat, fragParamBetaCtrl_mat, fragParamImMinCtrl_mat
%
% Outputs (in dirForFigures):
%   ResData_raw_<ID>.mat                             - Sa realizations, fragility, recovery curves and metrics
%   ResData_proc_<ID>.mat                            - recovery curve and robustness/rapidity/resilience only
%   Figures (.fig, .eps, .emf)                       - <ID>_Frag_*, <ID>_RecFun_*, RecFunCombined_*, RecCur_Combined_*_R1,
%                                                      RecCur_Combined_*_Uncertainty_R2, combined_Frag_R2
%   Command window                                   - robustness, days to recover, rapidity and resilience table
%
% Units: Sa in g, time in days, rapidity in year^(-1)
%
% Reference: Burton, H. V., Deierlein, G., Lallemant, D., and Lin, T. (2015). Framework for incorporating
%            probabilistic building performance in the assessment of community seismic resilience. J. Struct. Eng.
%
% Author: Prakash S Badal
% Modified by Shivakumar K S, IIT Madras (22nd-Oct-2026): inputs grouped, plots moved to
% sks_plotResilience.m, metrics moved to sks_ComputeRobRapRes.m, raw/processed .mat files saved.
%% -------------------

clear; tic; % close all; 
close all;
baseFolder = pwd;


%% (Start Inputs)%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Inputs- 1/4) Building-specific inputs - change this for the building being used
buildingIDLIST = {'46053'}; %{1310v1_NF' '1310v1_FF'; '1610v1_NF'; '1610v1_FF'; '1910v1_NF'; '1910v1_FF'}; 
% legStr = {'3-Story (FF)', '3-Story (NF)', '6-Story (FF)', '6-Story (NF)', '9-Story (FF)', '9-Story (NF)'}; plotStyle = {'k-', 'k--', 'b-', 'b--', 'r-', 'r--'}; figNameSuff = 'allSix';

% buildingID = '1310v1_FF'; legOn = 1; close all; 
% buildingID = '1310v1_NF'; legOn = 0; try close (102); catch; end
% buildingID = '1610v1_FF'; legOn = 0; close all; 
% buildingID = '1610v1_NF'; legOn = 0; try close(101); catch; end; try close (102); catch; end
% buildingID = '1910v1_FF'; legOn = 0; close all; 
% buildingID = '1910v1_NF'; legOn = 0; try close(101); catch; end; try close (102); catch; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% SCENARIO / GMPE OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Inputs- 2/4) Scenario/GMM inputs
M = 7.3;
Rjb = 30;                   % Joyner-Boore distance in km
% T1forIM = 1.68;           % T1forIM is building specific (see building switch below)
N1 = 1e4;                   % realizations of spectral acceleration.
rngSeed = 3;                % random seed for realizations of Sa(T1)
% GMPM = 'BA08';            % Boore Atkinson (2008) NGA
GMPM = 'BSSA14';            % Boore et al (2014) NGA (NRCan gives 0.25 weight to each of ASK14, BSSA14, CB14, CY14 for SWCan)
Vs30 = 450;                 % m/s
Fault_Type_BA08   = 3;      % 1 for unspecified fault; 2 for strike-slip fault; 3 for normal fault; 4 for reverse fault
Fault_Type_BSSA14 = 2;      % 0 for unspecified fault, 1 for strike-slip fault, 2 for normal fault, 3 for reverse fault
region_BSSA14 = 0;          % BSSA14 region
z1_BSSA14 = 999;            % BSSA14 basin depth (999 = default)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% FRAGILITY OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (Inputs- 3/4) Fragility inputs
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
saveFigures = 1;            % when running for optimal beta, do not saveFigures
dirForFigures = sprintf('figures_resCombined_M%g_R%g_R2_RESUnc', M, Rjb);


% Ensure output directory exists before saving results
figureFolder = fullfile(baseFolder, dirForFigures);
for i = 1:size(buildingIDLIST, 1)
    buildingID = buildingIDLIST{i, 1};

%% Building-specific inputs (only what cannot be read from the IDA/MSA output)
    switch buildingID
        case '46053'
            analysisType = '(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
            outputRoot   = fullfile(baseFolder, '..', '..', 'Output');   % ida-spo-msa\Output
            numStories = 5; legOn = 1;
            Sa_MCE = 0.27;
        case '1310v1_NF'
            analysisType = '(ID1310_v.01_NF)_(AllVar)_(0.00)_(clough)';
            outputRoot   = 'E:\prak\ResilAnaOS_psb\Output';
            numStories = 3; legOn = 0;
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

    % switch numStories
    %     case 3; Sa_MCE = 0.435;
    %     % case 5; Sa_MCE = 0.27;   % estimate at T1 = 1.36 s; replace with value from your site's MCE spectrum
    %     case 6; Sa_MCE = 0.221;
    %     case 9; Sa_MCE = 0.153;
    %     otherwise
    %         error('Sa_MCE not defined for numStories = %d', numStories);
    % end
    
%% GMPE: median and log-std of Sa(T1)
cd(fullfile(baseFolder, 'GMPE'));
% [Sa, sigma, period1] = BA_2008_nga (M, T, Rjb, Fault_Type, Vs30)
[Sa_T1_BA08, sigma_T1_BA08, ~] = BA_2008_nga(M, T1forIM, Rjb, Fault_Type_BA08, Vs30);
% [median, sigma, period1] = BSSA_2014_nga(M, T, Rjb, Fault_Type, region, z1, Vs30);
[Sa_T1_BSSA14, sigma_T1_BSSA14, ~] = BSSA_2014_nga(M, T1forIM, Rjb, Fault_Type_BSSA14, region_BSSA14, z1_BSSA14, Vs30);
% [Sa_T1_ASK14 , sigma_T1_ASK14 ] = ASK_2014_nga(M, Rjb, period) ;
% [Sa_T1_CB14  , sigma_T1_CB14  ] = CB_2014_nga(M, Rjb, period)  ;
% [Sa_T1_CY14  , sigma_T1_CY14  ] = CY_2014_nga(M, Rjb, period)  ;
cd(baseFolder);

% (End of Inputs) %%

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

%% 2. Import Fragility Data from DamageState folder (valid for arbitrary SaT1 using variable T1forIM)
cd(baseFolder);
bldgNum = str2double(regexp(buildingID, '^\d+', 'match', 'once')); % number
fileNameToSaveFragData = sprintf('fragRes_%s_%s', buildingID, GMsuiteName);
cd(fullfile('..', 'RiskAndARCR'));

fragInfo = dir([fileNameToSaveFragData '.mat']);
if ~isempty(fragInfo) && fragInfo.datenum > statsFile.datenum     % fragRes newer than the IDA/MSA results -> reuse it
    load(fileNameToSaveFragData, 'fragParamMuCtrl_mat', 'fragParamBetaCtrl_mat', 'fragParamImMinCtrl_mat');
    meanSa = fragParamMuCtrl_mat;
    sigmaLn = fragParamBetaCtrl_mat;
    imMin = fragParamImMinCtrl_mat;
else                                                              
    [~, ~, ~, meanSa, sigmaLn, imMin] = extractFragilityForMIDR_v1(bldgNum, outpFolderLIST, DS_StoryDriftLIST, eqLIST, GMsuiteName, T1forIM, fileNameToSaveFragData);
end

sigmaLn = sqrt(sigmaLn.^2 + beta_MDL_DR_TD^2);

cd(baseFolder)

%% 3. Calculating the expected recovery function for each realization of the scenario earthquake
[timeArray, expectedHousingFunction, meanExpectedHousingFunction, meanHousingCapacityMatrix] = fun3expctedRecovery_v1(meanSa, sigmaLn, Sa_realizations, numStories);
sigmaHouse = std(expectedHousingFunction, 0, 1);
sigmaLnHouse = std(log(expectedHousingFunction), 0, 1);

%% 4. Plots (figures 100+, 786, 200+, 401, 301, 302) - see sks_plotResilience.m
if saveFigures == 1
    sks_plotResilience
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Days to recover, robustness, rapidity, resilience
robRapRes = sks_ComputeRobRapRes(timeArray, meanExpectedHousingFunction, pcLIST, maximumHousingCapacity, rapidity_daysLIST, buildingID, doPrint);
RapResMatrix(i, :) = [robRapRes.rapidity, robRapRes.resilience];

robustness =                 robRapRes.robustness;                     
QtAfterDaysLIST =            robRapRes.QtAfterDays;
rapidity_average_afterDays = robRapRes.rapidity;       
ReselienceAfterDays =        robRapRes.resilience;

%% 6. Save raw results (recovery curves + metrics)
    rawDataMat  = fullfile(baseFolder, dirForFigures, sprintf('ResData_raw_%s.mat', buildingID));
    save(rawDataMat, 'buildingID', 'M', 'Rjb', 'GMPM', 'T1forIM', 'numStories', 'GMsuiteName', 'Sa_realizations', 'meanSa', 'sigmaLn', 'timeArray', 'expectedHousingFunction', ...
        'meanExpectedHousingFunction', 'meanHousingCapacityMatrix', 'sigmaHouse', 'sigmaLnHouse', 'robRapRes', 'robustness', 'rapidity_daysLIST', 'QtAfterDaysLIST', ...
        'rapidity_average_afterDays', 'ReselienceAfterDays');
    fprintf('Raw .mat file saved as %s.\n', rawDataMat);

%% 7. Save processed results (metrics only, replaces scriptPrintRobRapRes output)
    procDataMat = fullfile(baseFolder, dirForFigures, sprintf('ResData_proc_%s.mat', buildingID));
    save(procDataMat, 'buildingID', 'timeArray', 'meanExpectedHousingFunction', 'robustness', 'rapidity_daysLIST', 'QtAfterDaysLIST', 'rapidity_average_afterDays', 'ReselienceAfterDays', 'robRapRes');
    fprintf('Processed .mat file saved as %s.\n', procDataMat);

end 

cd(baseFolder);
toc