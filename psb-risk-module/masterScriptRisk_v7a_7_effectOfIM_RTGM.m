clear; tic; baseFolder = pwd;
%% 0. With chosen parameters, this script gives one risk values to be used for the paper. 

latLonLIST = [ % input depending on the site (lat, lon)
%     13.05	80.27; % Chennai
%     22.55	88.37; % Kolkata
%     19.00   72.80; % Mumbai   (Table 5.4 of NDMA, 2011 report)
    28.62   77.22; % Delhi
    26.17   91.77; % Guwahati
%     27.10   92.10; % an arbitrary grid point near Arunachal border
    ];

%% 
zoneOfLocLIST = {'IV'; 'V';}; % {'III'}; {'IV'}; {'V'}; {'III'; 'IV'; 'V'; 'V'}; % size of this input must match with the size of the latLonLIST 
% imScaleFac = 1.00; % this is an optional variable; used for paramteric study to see the impact of hazard variation on risk

% Scale IS 1893 hazard such that it matches with site hazard at some Tr
imScaleFac = 1; % optional variable
% use matchDBEWithPSHA475 and matchDBEWithPSHA2475 in the beginning of masterFunRiskAllSteps_v7 to control these

% bldgLISTIdentifier = 'all'; % 'all', '4storied', '7storied', '12storied'
bldgLISTIdentifier = 'twoFourSeven_CS_GM'; % two, four, and seven storied buildings with GM matching Conditional Spectra
% bldgLISTIdentifier = '4storied'; % two, four, and seven storied buildings with GM matching Conditional Spectra
dsLIST = {'DynInst' 'CP' 'LS' 'IO'}; % {'DynInst' 'CP' 'LS' 'IO'};
imTypeLIST = {'Sa_T1'}; % essentially fixed now

% (approximate period as per code) 
% TaLIST = [0.61	0.91	1.35	0.61	0.91	1.35	0.61	0.91   1.35]'; % (approximate period as per code) 
TaLIST   = [0.37    0.61	0.91	0.37	0.61	0.91]'; % (approximate period as per code) 
TogmLIST = [1.44	1.56	1.87	1.15	1.57	1.64]'; % geoM_Topt2 (<= 2sec) for CS ground motion records (2, 4, and 7 storied bldgs in Zone-IV and V)

% (period for Intensity measure, Sa(T1) 
% T1LIST = [2.69	1.88	3.61	1.54	2.70	3.63	1.57	2.67	3.55]';
% T1LIST = [2.00	1.88	2.00	1.54	2.00	2.00	1.57	2.00	2.00]';
% T1LIST = [1.91	1.88	1.9	1.54	1.92	1.89	1.57	1.93 1.5]'; % T_opt2,CP (<= 2sec)
% T1LIST = [1.75	1.93	1.89	0.94	1.88	1.88	1.53	2	1.48]'; % T_opt2,LS (<= 2sec)
% T1LIST = [1.03	0.93	1.72	1.5	1.87	1.5	1.53	2	1.49]'; % T_opt2,IO (<= 2sec)
% T1LIST = [1.51	1.50	1.83	1.29	1.89	1.75	1.54	1.98	1.49]'; % geoM_Topt2 (<= 2sec)
% T1LIST = [1.44	1.56	1.87	1.15	1.57	1.64]'; % geoM_Topt2 (<= 2sec) for CS ground motion records (2, 4, and 7 storied bldgs in Zone-IV and V)

% T1LIST = zeros(6, 1);
% T1LIST = ones(9, 1);
% T1LIST = TaLIST; % (period for Intensity measure, Sa(T1) 
T1LIST = TogmLIST; % geoM_Topt2 (<= 2sec) for CS ground motion records (2, 4, and 7 storied bldgs in Zone-IV and V) 

% Both of the following cannot be 1 at the same time. Undefined one gets assigned zero subsequently.
% targetRiskBasedOnRecommendedRisk = 1; % if the target risk factors are based on Recommended risk which is rounded up from \mu + \sigma
% targetRiskBasedOnMeanRisk = 1; % if the target risk factors are based on mean risk 
lambda_tarLIST = 999; % proxy for targeting building-specific risk reduction ratios and not fixed risk values

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
codeIdealizedHazData = 0; % 1, the program uses code-idealized hazard using two-parameter model based on DBE and MCE values
% codeIdealizedHazData = 0; % 0 or NO input, would invoke the use of actual hazard curve for risk calculation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% We have now essentially fixed the hazard fitting parameter as well as the im bound parameters 
fitModelLIST = {'3param'}; % {'2param', '3param'}; % Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)]
NLIST = 21; % [11, 21, 51]; % number of points between consecutive imValLIST values

%% X. im bound
%% X.0. factorOnImMin kicks in only if lowerBound = 99, i.e. when imMin is used. 
% Since, it's possible that (true imMin) < (imMin obtained from analysis). 
    factorOnImMin = 1.00; % 1.00; % optional variable that reduces the imMin value (DEFAULT value = 1)

%% X.1. (UNBOUNDED CASE) 
%     imOrAfeBoundLIST = 0; % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
%     lowerBoundLIST = 0.01; 
%     upperBoundLIST = 5; % lower bound bound (over im or afe, as may be the case)

%% X.2. (LOWER-BOUNDED CASE) 
    imOrAfeBoundLIST = 1; % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
    lowerBoundLIST = 99; % 0.01; assign 99 to indicate that lowerBound is taken as the minimum im Value from fragility analysis
    upperBoundLIST = 5; % lower bound bound (over im or afe, as may be the case)

%% afe bound
% imOrAfeBoundLIST = 2*ones(1, 6); % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
% lowerBoundLIST = [1e-6, 1e-5, 1e-4, 1e-6, 1e-5, 1e-4]; % range of bound (over im or afe, as may be the case)
% upperBoundLIST = [2e-2, 2e-2, 2e-2, 1e-1, 1e-1, 1e-1]; % range of bound (over im or afe, as may be the case)

%% Importance Factor list
% impFacLIST = [1.2; ... % business continuity structures (IS 1893-1, 2016)
%               1.5; ... % critical and lifeline structures  (IS 1893-1, 2016)
%               2.0; ... % highly critical structures (dam etc.)
%               2.5; 3.0; 4.0; 5.0]; % two values for plotting proposed and calculated risk with importance factors 
% impFacLIST = [1.25; 1.5; 1.75; 2.0; 2.5; 3.0; 4.0; 5.0]; % for tables and figures
impFacLIST = (1.25:0.05:3.5)'; % for tables and figures

verbose = 1; % for debugging, set this to 2; this will just print more intermediate results 
saveImpFactVsRisk = 1; dirForFigures = 'FIG_ImpFactObservedVsRisk_revA\SaTogm'; 

%%
% lambda_tarLIST = [2.0e-4; ... % Luco et al. (2007) for ASCE 7-10 (US)
%                   0.5e-4; ... % Zizmond and Dolsek (2019); an example (trade-off)
%                   1.0e-5];   % Douglas et al. (2013) for France

% lambda_tarLIST = [10.0e-4; ... % \lambda_LS,1893
%                   2.5e-4; ...  % (1/4) x \lambda_LS,1893
%                   5.0e-5];     % (1/20) x \lambda_LS,1893            
              
% lambda_tarLIST = [20.0e-4; ... % \lambda_IO,1893
%                   5.0e-4; ...  % (1/4) x \lambda_IO,1893
%                   1.0e-4];     % (1/20) x \lambda_IO,1893  

% For IMPORTANCE FACTOR paper, I have now defined target risks based on the chosen intensity measure. 

%% NOTE- FOR RTGM, WE TARGET ONLY ONE ds. ERGO, dsLIST has just one ds in it.
if ~exist('targetRiskBasedOnRecommendedRisk', 'var'); targetRiskBasedOnRecommendedRisk= 0; end
if ~exist('targetRiskBasedOnMeanRisk', 'var'); targetRiskBasedOnMeanRisk = 0; end

% targetRiskRatio = [1; 1/2; 1/4; 1/10; 1/20];
% targetRiskRatio = [1; 1/1.5; 1./(2:10)']; % risk ratio of 1.5, 2, 3, ..., 10 
targetRiskRatio = [1; 1/1.5; 1./(2:0.5:10)']; % risk ratio of 1.5, 2, 3, ..., 10 

% (1/2) In the following conditional, targets are (\mu + \sigma) rounded up values. Ones, that we recommend as code-level risk. 
if targetRiskBasedOnRecommendedRisk == 1
    if T1LIST(1) == TogmLIST(1) || T1LIST(1) == TaLIST(1) % \lambda_1893_CS_SaTogm_SaTa (mu + sigma, roundup)
        switch dsLIST{1}
            case 'DynInst'; lambda_tarLIST = 1.0e-4 * targetRiskRatio; % targetRiskRatio x \lambda_Collapse,1893_CS
            case 'CP';      lambda_tarLIST = 2.0e-4 * targetRiskRatio; % targetRiskRatio x \lambda_CP,1893_CS
            case 'LS';      lambda_tarLIST = 6.0e-4 * targetRiskRatio; % targetRiskRatio x \lambda_LS,1893_CS
            case 'IO';      lambda_tarLIST = 20.0e-4 * targetRiskRatio; % targetRiskRatio x \lambda_IO,1893_CS
        end
    elseif T1LIST(1) == 0 % \lambda_1893_CS_PGA (mu + sigma, roundup)
        switch dsLIST{1}
            case 'DynInst'; lambda_tarLIST = 3.0e-4 * targetRiskRatio; % targetRiskRatio x \lambda_Collapse,1893_CS_PGA
            case 'CP';      lambda_tarLIST = 6.0e-4 * targetRiskRatio; % targetRiskRatio x \lambda_CP,1893_CS_PGA
            case 'LS';      lambda_tarLIST = 2.0e-3 * targetRiskRatio; % targetRiskRatio x \lambda_LS,1893_CS_PGA
            case 'IO';      lambda_tarLIST = 6.0e-3 * targetRiskRatio; % targetRiskRatio x \lambda_IO,1893_CS_PGA
        end
    end
elseif targetRiskBasedOnMeanRisk == 1
    % (2/2) In the following conditional, we target precisely \mu values.
    if T1LIST(1) == TogmLIST(1) % \lambda_1893_CS_SaTogm (MEAN)
        switch dsLIST{1}
            case 'DynInst'; lambda_tarLIST = 5.90e-5 * targetRiskRatio; % targetRiskRatio x \lambda_Collapse,1893_CS
            case 'CP';      lambda_tarLIST = 1.33e-4 * targetRiskRatio; % targetRiskRatio x \lambda_CP,1893_CS
            case 'LS';      lambda_tarLIST = 4.52e-4 * targetRiskRatio; % targetRiskRatio x \lambda_LS,1893_CS
            case 'IO';      lambda_tarLIST = 15.9e-4 * targetRiskRatio; % targetRiskRatio x \lambda_IO,1893_CS
        end
    elseif abs(T1LIST(1) - TaLIST(1)) + abs(T1LIST(2) - TaLIST(2)) < 1e-6 % I am checking only first and second value, safe to assume two Ta values cannot ever be either Togm or 0.
        switch dsLIST{1} % \lambda_1893_CS_SaTa (MEAN)
            case 'DynInst'; lambda_tarLIST = 5.80e-5 * targetRiskRatio; % targetRiskRatio x \lambda_Collapse,1893_CS
            case 'CP';      lambda_tarLIST = 1.34e-4 * targetRiskRatio; % targetRiskRatio x \lambda_CP,1893_CS
            case 'LS';      lambda_tarLIST = 4.71e-4 * targetRiskRatio; % targetRiskRatio x \lambda_LS,1893_CS
            case 'IO';      lambda_tarLIST = 16.6e-4 * targetRiskRatio; % targetRiskRatio x \lambda_IO,1893_CS
        end
    elseif T1LIST(1) == 0 % \lambda_1893_CS_PGA (MEAN)
        switch dsLIST{1}
            case 'DynInst'; lambda_tarLIST = 1.72e-4 * targetRiskRatio; % targetRiskRatio x \lambda_Collapse,1893_CS_PGA
            case 'CP';      lambda_tarLIST = 3.72e-4 * targetRiskRatio; % targetRiskRatio x \lambda_CP,1893_CS_PGA
            case 'LS';      lambda_tarLIST = 12.5e-4 * targetRiskRatio; % targetRiskRatio x \lambda_LS,1893_CS_PGA
            case 'IO';      lambda_tarLIST = 40.9e-4 * targetRiskRatio; % targetRiskRatio x \lambda_IO,1893_CS_PGA
        end
    end
end

%% Assign building list depending on the required results
BldgIdAndZoneLIST_All = {	
    '2205v03',  'III';  '2207v09',	'III';	'2209v05',	'III'; ... % 4, 7, 12-story zone-III
    '2213v04',	'IV';   '2215v03',	'IV';   '2217v03',	'IV';  ... % 4, 7, 12-story zone-IV
    '2221v06',	'V';    '2223v03',	'V';    '2225v03',	'V'};      % 4, 7, 12-story zone-V
BldgIdAndZoneLIST_4storied = {	
    '2205v03',  'III';     '2213v04',	'IV' ;     '2221v06',	'V' };  % 4-story zone-III, IV, and V
BldgIdAndZoneLIST_7storied = {	
    '2207v09',	'III';	    '2215v03',	'IV' ;     '2223v03',	'V' };  % 7-story zone-III, IV, and V
BldgIdAndZoneLIST_12storied = {	
    '2209v05',	'III';     '2217v03',	'IV' ;     '2225v03',	'V' };  % 12-story zone-III, IV, and V  
BldgIdAndZoneLIST_2_4_7_CS = {
    '2211v03_sca2', 'IV';  '2213v04_sca2', 'IV';   '2215v03_sca2', 'IV'; ... % 2, 4, 7-story zone-IV (matching CS records)
    '2219v03_sca2', 'V';   '2221v06_sca2', 'V';    '2223v03_sca2', 'V'}; % 2, 4, 7-story zone-V (matching CS records)

switch bldgLISTIdentifier
    case 'all';       BldgIdAndZoneLIST = BldgIdAndZoneLIST_All;
    case '4storied';  BldgIdAndZoneLIST = BldgIdAndZoneLIST_4storied;
    case '7storied';  BldgIdAndZoneLIST = BldgIdAndZoneLIST_7storied;
    case '12storied'; BldgIdAndZoneLIST = BldgIdAndZoneLIST_12storied;
    case 'twoFourSeven_CS_GM'; BldgIdAndZoneLIST = BldgIdAndZoneLIST_2_4_7_CS;
end

counterMax = size(dsLIST, 2) * size(fitModelLIST, 2) * size(NLIST, 2) * size(imOrAfeBoundLIST, 2);

%% Well, too many loops, but we always carry out parametric comparisons by varying only a few variables at a time.
counter = 0; tableWithAllInfo = table;
fprintf('Loop-ID, ds, imType, fitModel, N, imOrAfeBound, boundRange\n');
for i = 1:size(dsLIST, 2) % over damage states
    ds = dsLIST{1, i};
    imType = imTypeLIST{1, 1};  
    for k = 1:size(fitModelLIST, 2) % over hazard fit model
        fitModel = fitModelLIST{1, k};
        for p = 1:size(NLIST, 2) % over descretization
            N = NLIST(1, p);
            for q = 1:size(imOrAfeBoundLIST, 2) % over bounds
                counter = counter + 1; 
                imOrAfeBound = imOrAfeBoundLIST(1, q);
                boundRange = [lowerBoundLIST(1, q), upperBoundLIST(1, q)];
                fprintf('%i/%i, %s, %s, %s, %i, %i, [%f, %f]\n', counter, counterMax, ds, imType, fitModel, N, imOrAfeBound, boundRange(1), boundRange(2));
%                     tableCurr = masterFunRiskAllSteps_v5(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, ds, imType, fitModel, N, imOrAfeBound, boundRange, lambda_tarLIST, impFacLIST, verbose, imScaleFac);
%                     tableCurr = masterFunRiskAllSteps_v6(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, ds, imType, fitModel, N, imOrAfeBound, boundRange, lambda_tarLIST, impFacLIST, verbose, imScaleFac);
%                     tableCurr = masterFunRiskAllSteps_v7(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, ds, imType, T1LIST, TaLIST, fitModel, N, imOrAfeBound, boundRange, lambda_tarLIST, impFacLIST, verbose, imScaleFac, codeIdealizedHazData, factorOnImMin);
%                 tableCurr = masterFunRiskAllStepsWithRiskVarVsImpFac_v7(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, ds, imType, T1LIST, TaLIST, fitModel, N, imOrAfeBound, boundRange, lambda_tarLIST, impFacLIST, verbose, imScaleFac, codeIdealizedHazData, factorOnImMin);
                  tableCurr = masterFunRiskAllStepsWithRiskVarVsImpFac_v7a(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, ds, imType, T1LIST, TaLIST, fitModel, N, imOrAfeBound, boundRange, lambda_tarLIST, impFacLIST, verbose, imScaleFac, codeIdealizedHazData, factorOnImMin);
                % Here we convert it to the "required factor for targeted risk" 
                if lambda_tarLIST == 999; lambdaForSize = ([1.5:0.5:10])'; end
                for r = 1:size(lambdaForSize, 1)
                    RT_muVar = sprintf('RT_mu%i', r); mu_dsVar = sprintf('mu_%s', 'ds'); % ds); % Now identifying the ds from the first var name
                    tableCurr.(RT_muVar) = tableCurr.(RT_muVar)./tableCurr.(mu_dsVar); % update the value
                    tableCurr.Properties.VariableNames{10+r} = sprintf('RTGM_ReqFac%i', r); % change the variable name
                end
                tableWithAllInfo = [tableWithAllInfo; tableCurr];
            end
        end
    end
end

% for v7a, we save just one plot; use v7 for independent plots.
    a = get(gca,'OuterPosition'); set(gca,'OuterPosition',[a(1) a(2) + 0.02 a(3) + 0.05 a(4)]);
    b = get(gcf,'Position'); set(gcf,'Position',[100 100 1500 900]);
    formatAllSixBldgImpFactVsRiskPlot_v01;
if saveImpFactVsRisk == 1
    cd(dirForFigures); exportNamePlot = sprintf('impFactVsLambdaAllDamSta');
    hgsave(exportNamePlot); print('-depsc', exportNamePlot);
    print('-dmeta', exportNamePlot); print('-djpeg', exportNamePlot); cd(baseFolder);
else
%     close;

dsForBeyondCode = {'2211_CP'; '2211_LS'; '2211_IO'; '2213_CP'; '2213_LS'; '2213_IO'; '2215_CP'; '2215_LS'; '2215_IO'; 
                   '2219_CP'; '2219_LS'; '2219_IO'; '2221_CP'; '2221_LS'; '2221_IO'; '2223_CP'; '2223_LS'; '2223_IO'};

bldgIdForBeyondCode = {'2211v03_sca2';'2213v04_sca2'; '2215v03_sca2';
                       '2219v03_sca2'; '2221v06_sca2';'2223v03_sca2'};

dsLISTForBeyondCode = {'CP'; 'LS'; 'IO'};                   
count = 0;

cd ImpFacVersusLambdaData; 
for i = 1:size(bldgIdForBeyondCode, 1)
    bldgIdCurr = bldgIdForBeyondCode{i, 1};
    for j = 1:size(dsLISTForBeyondCode, 1) % over damage states
        count = count + 1;
        ds = dsLISTForBeyondCode{j, 1};
        matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' ds]);
        OneDsHigher_IF(count, 1) = matObj.beyondCodeFactorOneDsHigher;
        TwoDsHigher_IF(count, 1) = 0; ThreeDsHigher_IF(count, 1) = 0;
        if strcmp(ds, 'LS') || strcmp(ds, 'IO')
            TwoDsHigher_IF(count, 1) = matObj.beyondCodeFactorTwoDsHigher;
        end
        if strcmp(ds, 'IO')
            ThreeDsHigher_IF(count, 1) = matObj.beyondCodeFactorThreeDsHigher; 
        end
    end
end
cd ..
beyondCodeTable = table(dsForBeyondCode, OneDsHigher_IF, TwoDsHigher_IF, ThreeDsHigher_IF);
disp(beyondCodeTable)

end
disp(tableWithAllInfo)
toc
