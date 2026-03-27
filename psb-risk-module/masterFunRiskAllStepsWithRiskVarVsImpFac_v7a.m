% clear; % if building fragility is already extracted, I am turning it off during the debugging phase 
% clearvars -except fragilityDataLIST
%% Master function (earlier, script) to load hazard curve, PGA fragility and calculate risk
% v2- putting together appropriate locations corresponding to the buildings design configurations
% 
% v3- Changes as follows-
% (1) uses new Data from Raghukanth as received on 2020, Jan 11
% (2) nine types of intensity measure values are now available (in data and hence in this script as well). 
% 
% v4- Additional changes as follows-
% (1) The fragility extraction step, i.e., step 2, now first attempts to find the stored .mat file, only if not found, it carries out the extraction.
% (2) using new version of risk computation function, computeRiskSingleSite_v3, where discretized hazard is already an input.
% (3) Updated version of computeRTGM_v2 that uses computeRiskSingleSite_v3 for risk calculations.
% 
% v5- parametric study for risk values to observe the effect of 
%     (a) Hazard fitting model- '2param', '3param'; 
%     (b) [imMin, imMax]- lower bound = 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
%     (c) [afeMin, afeMax]
%     (d) Number of points in each sub-interval 
%     (e) Intensity measure type
% 
% v6- Now calculating design return period for a specific RTGM value. (Refer analytical expressions on pp 12-13 of notebook no.-7
% 
% v7- Now all calculations are possible for any arbitrary time period (up to 2 sec). 
%     The limitation over period is imposed due to a anomaly in the hazard data for 5s for several sites)
%     to update or remove this limitation, see variable "timePIDsToProc" in function findHazValSaT1Raghukanth20200111_v1   
% 
% v7a- This version is different from v7 merely for plotting IMP_FACTOR VS RISK on the same plot.
%      It's a possibility that these plots is not pleasant and we switch to v7 version of separate plots. 
% 
%% scope for improvement (specially, for hazard module)
%  (1a + 1b)- For efficiency, we can use also use a script 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (i) to store discretized hazard data for all grid points corresponding to different combinations 
%     of fitModel and N values, e.g., 2param_N11, 3param_N11, 2param_N21, 3param_N21, 2param_N51, 3param_N51, etc.
% (ii) and subsequently, simply read the discretized data from corresponding file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
function tableWithAllInfo = masterFunRiskAllStepsWithRiskVarVsImpFac_v7a(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, ds, imType, ...
    T1LIST, TaLIST, fitModel, N, imOrAfeBound, boundRangeInp, lambda_tarLIST, impFacLIST, verbose, imScaleFac, codeIdealizedHazData, factorOnImMin)
% tic;
%% To plot effect of importance factor on risk, call the present function instead of the function masterFunRiskAllSteps_v7

%% These two variables should be generally ZERO, i.e., we are not scaling code-idealized hazard to match with PSHA at 475y or 2475y
% naturally, they make any difference to the program only when codeIdealizedHazData = 1
% I am equating one of them to 1, only while studying the the effect of shape of hazard curve on risk 
matchDBEWithPSHA475 = 0; % to observe the effect of shape of hazard curve on risk, we are matching code-idealized hazard at 475y/2475y with PSHA-based hazard
matchDBEWithPSHA2475 = 0;
legendText = [];
doPlotImpFacPlot = 1; % this variable plots variation of risk with importance factor

if nargin == 14
    imScaleFac = 1.00; % this optional variable is used to observe the impact of hazard variation on risk
    codeIdealizedHazData = 0; % optional variable when 1, the program uses code-idealized hazard using two-parameter model based on DBE and MCE values
    factorOnImMin = 1; % optional variable that reduces the imMin value
elseif nargin == 15
    codeIdealizedHazData = 0; % optional variable when 1, the program uses code-idealized hazard using two-parameter model based on DBE and MCE values
    factorOnImMin = 1; % optional variable that reduces the imMin value
elseif nargin == 16
    factorOnImMin = 1; % optional variable that reduces the imMin value
end
if abs(factorOnImMin - 1) > 1e-3
    fprintf('------------------------------------------------------------------- \n');
    fprintf('lower bound of intensity measure considered as %.2f times IM_min from analysis\n', factorOnImMin);
    fprintf('------------------------------------------------------------------- \n');
end

%% Inputs begin
% 1. Hazard-related inputs
% latLonLIST = [ % input depending on the site (lat, lon)
%     19.00   72.80; % Mumbai   (Table 5.4 of NDMA, 2011 report)
%     28.62   77.22; % Delhi
%     26.17   91.77; % Guwahati
%     27.10   92.10; % an arbitrary grid point near Arunachal border
% %     26.70   60.5;  % a grid point for validation
%     ];

% zoneOfLocLIST = {'III'; 'IV'; 'V'; 'V'}; % size of this input must match with the size of the latLonLIST 
if size(zoneOfLocLIST, 1) ~= size(latLonLIST, 1); error('number of entries in siteZoneLIST does not match with number of (lat, lon) entries.'); end
    
% ds = 'CP'; % possible damage states are 'DynInst' 'CP' 'LS' 'IO'
% lambda_tarLIST = [2.0e-4; ... % Luco et al. (2007) for ASCE 7-10 (US)
%                   0.5e-4; ... % Zizmond and Dolsek (2019); an example (trade-off)
%                   1.0e-5];   % Douglas et al. (2013) for France
% impFacLIST = [1.2; ... % business continuity structures (IS 1893-1, 2016)
%               1.5; ... % critical and lifeline structures  (IS 1893-1, 2016)
%               2.0];    % highly critical structures (dam etc.)
% imType = 'Sa_T1'; % available LIST 

% T1LIST = zeros(9, 1); % (period for Intensity measure, Sa(T1) 
% TaLIST = [0.61	0.91	1.35	0.61	0.91	1.35	0.61	0.91   1.35]'; % (approxiamte period as per code) 

%  1a. inputs for extracting  hazard 
doPlot = 0; plotType = 'semilog'; % 'semilog', 'loglog, 'linear'
imTypeForPlot = imType; locationLISTforPlot = {};
%  1b. inputs for discretizing hazard curve 
% fitModel = '3param'; % '2param' or '3param'; Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)]
% N = 21; % number of points between consecutive imValLIST values 
legendName = {}; curveNum = 0;
lineColors = {'k', 'k', 'k', 'b', 'b', 'b', 'r', 'r', 'r'};
lineStyles = repmat({'-', '--', '-.'}, [1 3]); 
% figure % commented out in v7a from v7

% 2. building data for fragility 
% BldgIdAndZoneLIST = {	
%     '2205v03',  'III';  '2207v09',	'III';	'2209v05',	'III'; ... % 4, 7, 12-story zone-III
%     '2213v04',	'IV';   '2215v03',	'IV';   '2217v03',	'IV';  ... % 4, 7, 12-story zone-IV
%     '2221v06',	'V';    '2223v03',	'V';    '2225v03',	'V'};      % 4, 7, 12-story zone-V

% (OPTIONAL inputs) in the absence of any input no bound is considered
% imOrAfeBound = 1; % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
% boundRangeInp = [99 5]; % range of bound (over im or afe, as may be the case) 

% printing 
% verbose = 1; % for debugging, set this to 2 
% imScaleFac = 1.00; 


% end of all inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eqNumberLIST_forProcessing_SetC = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
eqLIST = eqNumberLIST_forProcessing_SetC;    

if size(T1LIST, 1) ~= size(BldgIdAndZoneLIST, 1) 
    error('Number of buildings not same as the list of input time period vector.');
end

%% 0. calculations begin
baseFolder = pwd;
%% 0. Assign MIDR and some beta values for fragiliy
    betaDR = 0.20; % (6-6-19, PSB) SMRF- design requirements. 'Good' for SMRF (see Sec 6.2 of Denavit et al., 2016)
    betaMDL = 0.20; % (6-6-19, PSB) modeling; good; index model capturing full range of archetype design space
switch ds
    case 'DynInst'
        MIDR_ds = 0.00; % proxy for dynamic instability
        betaTD = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
    case 'CP'
        MIDR_ds = 0.04; betaTD = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
    case 'LS'
        MIDR_ds = 0.02; betaTD = 0.10; % superior rating of test data for lower damage states    
    case 'IO'
        MIDR_ds = 0.01; betaTD = 0.10; % superior rating of test data for lower damage states    
end

%% 1. Hazard stuff extraction, interpolation, and discretization
% in case of different IMs, we need to extract different hazard curves for each building
    
% A given building can be location in a zone (say, V) for which we have actual hazard corresponding to one or more lat-lon
% For one building, find the locs matching to its zone, then find hazard for each of those locations with IM as Sa(T1 for given building) 
zoneOfAllBldgs = BldgIdAndZoneLIST(:, 2);
counter = 0;
if verbose == 2
    fprintf('--------------------------------------------------\n');
    fprintf('----------- For Damage state - %s ----------------\n', ds);
    fprintf('--------------------------------------------------\n');
    fprintf('S.No.\tZone\tBldgID\tH_475\tH_2475\t%s\t%s/H_475\t%s\tRT mu values\tImp factor margins\n', ['mu_' ds], ['mu_' ds], ['lambda_' ds]);
end

for locID = 1:size(latLonLIST, 1)
    latLonCurr = latLonLIST(locID, :);
    zoneOfLoc = zoneOfLocLIST{locID};
    matchingBldgIndices{locID, 1} = strcmp(zoneOfLoc, zoneOfAllBldgs);
    matchingBldgIds{locID, 1} = BldgIdAndZoneLIST(matchingBldgIndices{locID, 1});
    matchingTimeP{locID, 1} = T1LIST(matchingBldgIndices{locID, 1}); % T1 for intensity measure, Sa(T1)
    matchingTa{locID, 1} = TaLIST(matchingBldgIndices{locID, 1});    % approximate period as per code (design force)
    for bldgNum = 1:size(matchingBldgIds{locID, 1}, 1)
        bldgIdCurr = matchingBldgIds{locID, 1}{bldgNum, 1};
        T1Curr = matchingTimeP{locID, 1}(bldgNum, 1);
        TaCurr = matchingTa{locID, 1}(bldgNum, 1);
        
        cd('Input from Raghukanth')
        % 1a. extract hazard curve data (10-point-curve) from Raghukanth's file (received on Jan 11, 2020)
        [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(latLonCurr, doPlot, plotType, locationLISTforPlot, T1Curr);
        %  1b. discretize each hazard curve individually
        [imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST, afe_Sa_T1_LIST, N, doPlot, plotType, imTypeForPlot, legendName);
        %     imScaleFac = 1.00;
        
%% codeIdealizedHazData; when 1, program calculates risk using code-idealized hazard employing two-parameter model based on DBE and MCE values
        if codeIdealizedHazData == 1
            fprintf('---------------------------------------------------------------------------------------------------\n');
            fprintf('---- PLEASE NOTE THAT PROGRAM IS USING CODE-IDEALIZED HAZARD CURVE, AND NOT ACTUAL HAZARD DATA ----\n');
            switch zoneOfLoc
                case 'II';  zoneMCE_PGA = 0.10;
                case 'III'; zoneMCE_PGA = 0.16;
                case 'IV';  zoneMCE_PGA = 0.24;
                case 'V';   zoneMCE_PGA = 0.36;
            end
            switch T1Curr
                case 0;     SaByg = 1;
                otherwise;  SaByg = min(1+15*T1Curr, min(2.5, 1/TaCurr));
            end
            
            X = afeDisc; Y = imValDisc; % X- POE, Y- im values (used only for interpolation)
            xq = 1/475; ix = find(X <= xq, 1);
            H_475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
            xq = 1/2475; ix = find(X <= xq, 1);
            H_2475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        % to observe the effect of shape of hazard curve on risk, we are matching code-idealized hazard at 475y/2475y with PSHA-based hazard
            if matchDBEWithPSHA475 == 1 
                fprintf('---- MATCHING CODE-IDEALIZED HAZARD WITH PSHA AT Tr = 475y. ----\n');
                DBE = H_475;
            elseif matchDBEWithPSHA2475 == 1 
                fprintf('---- MATCHING CODE-IDEALIZED HAZARD WITH PSHA AT Tr = 2475y. ----\n');
                DBE = H_2475/2;
            else
                DBE = zoneMCE_PGA/2 * SaByg; % design hazard value as per IS 1893 (Z/2 * Sa/g)
            end
            MCE = 2*DBE;
            
            TrDBE = 475; TrMCE = 2475; 
            poeDBE = 1 / TrDBE; poeMCE = 1 / TrMCE; % prob of exceedance

            SaVector = [MCE; DBE];
            hazardVector = [poeMCE; poeDBE];

            X = log(SaVector); % based on EN 1998 -1 : 2004, section 2.1(4), H(a_gR) = k_0 * a_gR^(-k)
            Y = log(hazardVector);

            A = [X, ones(length(X), 1)];

            coeff = ((inv(A' * A)) * A') * Y;
            k_1893 = - coeff(1); k0_1893 = exp(coeff(2));
            
            afeDisc = k0_1893 * imValDisc.^(-k_1893);
            fprintf('---- PLEASE NOTE THAT PROGRAM IS USING CODE-IDEALIZED HAZARD CURVE, AND NOT ACTUAL HAZARD DATA ----\n');
            fprintf('---------------------------------------------------------------------------------------------------\n');
        end
%%
        afeScaleFac = 1.00;
        hazardDataCurr = [imValDisc * imScaleFac; afeDisc * afeScaleFac];
        hazardDataLIST{locID, 1}{bldgNum, 1} = hazardDataCurr;
        cd(baseFolder)
        %% 2. Load the fragility data for all archetypical buildings. (v21, P1_R2 buildings)
        dataDir = 'DATA_files';
        fragDataFile = sprintf('DATA_fragility_ALL.mat');
        fileWithPath = fullfile(pwd, dataDir, fragDataFile);
                
        %% At this point, define a variable imTypeT1 which is different from imType only if T1 is given as an input
        switch imType
            % imType is always 'Sa_T1' now; use different T1 values to consider all IM
            case 'Sa_T1' % the following piece basically equates imTypeT1 to imType if T_new is one of the above values, else to Sa_1p35, etc.
                % following condition makes sure that we do not end up getting two variables as Sa_1p2 and Sa_1p20
                if abs(T1Curr - 0) < 1e-6 % i.e., if it's PGA, assign 'PGA'
                    imTypeT1 = 'PGA';
                elseif abs(mod(T1Curr*100, 10)) < 1e-6 % i.e., if the second digit after decimal is zero, e.g., 1.4
                    imTypeT1 = sprintf('Sa_%ip%i', floor(T1Curr), int8(mod(T1Curr*10, 10))); % assign Sa_1p4
                else                    % i.e., if the second digit after decimal is non-zero, e.g., 1.35
                    imTypeT1 = sprintf('Sa_%ip%.2i', floor(T1Curr), int8(mod(T1Curr*100, 100))); % assign Sa_1p35
                end
        end

        if ~exist(fileWithPath, 'file')
            % if the data file doesn't exist (we don't want the program to usually go here).
            % Please execute scriptForFragilityDataGen_v2 as a one time operation.
            % If we are on an off chance anyway here, extract fragility on ad hoc basis.
            fprintf('------------------=------------------------------------------------------------------------\n');
            fprintf('-- EXECUTE script "scriptForFragilityDataGen_v2" to reduce run-time and avoid repetition --\n');
            fprintf('-------------------------------------------------------------------------------------------\n');
            cd H:\DamageIndex\Automated
            [~, analysisTypeFolder, ~, ~] = returnModelFolderInfo(bldgIdCurr);
            cd(baseFolder);
            [muDsIMAll, betaRTRAll, muDsIMCtrl, betaRTRCtrl, imMin] = extractFragilityForDifferentIM_v2(analysisTypeFolder, MIDR_ds, eqLIST, T1Curr);
            %     betaTot = sqrt(betaRTR^2 + betaDR^2 + betaTD^2 + betaMDL^2);
            fragilityDataCurr = [muDsIMCtrl, betaRTRCtrl, imMin];
            fragilityDataLIST{locID, 1}{bldgNum, 1} = fragilityDataCurr;
            %     fprintf('%s \t %f \t %f \n', bldgIdCurr, mu_im, betaRTR); % only for debugging
        else % when the file with the fragility data exists
            load(fileWithPath, 'fragAllData'); % load the data file with fragility information
            try
                % varName for storing building ID (same as in DATA file and as in scriptForFragilityDataGen_v2)
                bldgIdVar = ['ID' bldgIdCurr];
                
                % assign fields of the building-specific struct to new variables.
                timePDataVec = fragAllData.(bldgIdVar).timeP;
                dsDataVec = fragAllData.(bldgIdVar).ds;
                muAllMat = fragAllData.(bldgIdVar).muAll;
                betaRTRAllMat = fragAllData.(bldgIdVar).betaRTRAll;
                muCtrlMat = fragAllData.(bldgIdVar).muCtrl;
                betaRTRCtrlMat = fragAllData.(bldgIdVar).betaRTRCtrl;
                imMinMat = fragAllData.(bldgIdVar).imMin;
                
                % find matching time period and damage state
                rowId = find(abs(timePDataVec - T1Curr) < 1e-6);
                colId = find(strcmp(dsDataVec, ds));
                
                % use relevant matrix entries for fragility data
                muDsIMAll = muAllMat(rowId, colId);
                betaRTRAll = betaRTRAllMat(rowId, colId);
                muDsIMCtrl = muCtrlMat(rowId, colId);
                betaRTRCtrl = betaRTRCtrlMat(rowId, colId);
                imMin = imMinMat(rowId, colId);
                
                fragilityDataCurr = [muDsIMCtrl, betaRTRCtrl, imMin];
                fragilityDataLIST{locID, 1}{bldgNum, 1} = fragilityDataCurr;
            catch
                fprintf('--------------------------------------------------------------------------------\n');
                fprintf('--- Missing data for %s, corresponding to "%s" and %.2f drift ratio ---\n', bldgIdCurr, imTypeT1, MIDR_ds);
                warning('---- Execute "scriptForFragilityDataGeneration" with updated input ----');
                fprintf('--------------------------------------------------------------------------------\n');
                error('------------------------------ EXITING THE PROGRAM -----------------------------');
            end
        end
                
        %% 3. Calculate the risk value.
        % The first row with IM values in arbitrary units (say, g) and second row with AFE
        % 3a. loop over all sites
        counter = counter + 1;
        % 3b. (NOT needed anymore, unique hazard curve for each location) loop over locations matching to each zone
        % interpolate hazard values corresponding to 475 and 2475 years of RP
        X = hazardDataCurr(2, :); Y = hazardDataCurr(1, :); % X- POE, Y- im values (used only for interpolation)
        Xtemp = X; % temporary variable for AFE; used to remove NaN
        xq = 1/475;
%         ix = find(X <= xq, 1);
%         H_475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        X(isnan(Xtemp)) = []; Y(isnan(Xtemp)) = []; % remove all NaN values
        H_475 = interp1(X, Y, xq, 'pchip'); % to check if global interpolation results in different UHS, it turns out
                                            % that discretized hazard curves are so fine that results are almost identical.
        
        xq = 1/2475;
%         ix = find(X <= xq, 1);
%         H_2475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
        H_2475 = interp1(X, Y, xq, 'pchip'); % to check if global interpolation results in different UHS, it turns out
                                             % that discretized hazard curves are so fine that results are almost identical.
        
        % 3d. finally, calculate risk for each building in each matching location
        betaRTRCtrl = fragilityDataCurr(1, 2);
        betaTot = sqrt(betaRTRCtrl^2 + betaDR^2 + betaTD^2 + betaMDL^2);
        fragilityDataCurr(2) = betaTot;
        %         [riskVal, highestContriIM, modalImRatio] = computeRiskSingleSite_v1(hazardDataCurr, fragilityDataCurr);
        %%
        boundRangeCurr = boundRangeInp;
        if boundRangeInp(1) == 99 % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
            boundRangeCurr(1) = fragilityDataCurr(1, 3)*factorOnImMin; % factorOnImMin, ifgiven as input, reduces the imMin value (DEFAULT value = 1)

            if verbose == 2; fprintf('Lower intensity bound CHANGED TO the minimum of analyses as %f\n', boundRangeCurr(1)); end
        end
        %%
        [riskVal, highestContriIM, modalImRatio] = computeRiskSingleSite_v3(hazardDataCurr, fragilityDataCurr(1, 1:2), imOrAfeBound, boundRangeCurr);
        
        mu_ds = fragilityDataCurr(1, 1); omega = mu_ds/H_475;
        if verbose == 2; fprintf('%i\t%s\t%s\t%4.3f\t%4.3f\t%4.3f\t%4.3f\t%.2e\t', counter, zoneOfLoc, bldgIdCurr, H_475, H_2475, mu_ds, omega, riskVal); end
        
        Zone = cellstr(zoneOfLoc); BldgID = cellstr(bldgIdCurr);
        siteBldgDsT1 = cellstr(sprintf('%i-%i-%s-%.2fs', locID, bldgNum, ds, T1Curr));
        % storing all values in a structure
        %         tableWithAllInfo(counter, 1:8) = table(siteBldgCounter, Zone, BldgID, H_475, H_2475, mu_ds, omega, riskVal);
        tableWithAllInfo(counter, 1:10) = table(siteBldgDsT1, Zone, BldgID, boundRangeCurr(1), boundRangeCurr(2), H_475, H_2475, mu_ds, omega, riskVal);
        tableWithAllInfo.Properties.VariableNames{4} = sprintf('%s_Min', 'im'); % imTypeT1); % Since, IM changes with bldg now, we're identifying imType from the first var name
        tableWithAllInfo.Properties.VariableNames{5} = sprintf('%s_Max', 'im'); % imTypeT1); % Since, IM changes with bldg now, we're identifying imType from the first var name
        tableWithAllInfo.Properties.VariableNames{8} = sprintf('mu_%s', 'ds'); % ds); % Now identifying the ds from the first var name
        warning('off','MATLAB:table:RowsAddedExistingVars'); % suppressing warning
        
        %       for intermediate results to see how far off from median is imMin
        eps1 = (log(boundRangeCurr(1)) - log(fragilityDataCurr(1, 1))) / fragilityDataCurr(1, 2);
        eps1LIST(counter, 1) = eps1;
        
        %% 4. Calculate the risk-targeted ground motion value.
        % If I upodate lambda_tarLIST than defining a new variable name as lambda_tarLIST_forUse, then
        % the program uses riskVal for first building in this function.
        if lambda_tarLIST == 999 % proxy for targeting building-specific risk reduction ratios and not fixed risk values
            lambda_tarLIST_toUse = riskVal*(1./([1.5:0.5:10]))'; % overwriting the input lambda_tarLIST in order to extract revised tables for RTGM which target building specific risk ratios and not the reduction factors over statistic measure
        else
            lambda_tarLIST_toUse = lambda_tarLIST;
        end
        for k = 1:size(lambda_tarLIST_toUse, 1)
            lambda_tar = lambda_tarLIST_toUse(k, 1);
            %             riskTargetedMedianCap = computeRTGM_v1(lambda_tar, hazardDataCurr, betaTot);
            riskTargetedMedianCap = computeRTGM_v2(lambda_tar, hazardDataCurr, betaTot, imOrAfeBound, boundRangeCurr);
            %% calculate the risk-targeted design hazard (Refer analytical expressions on pp 12-13 of notebook no.-7
            RTGM_ReqFac = riskTargetedMedianCap/mu_ds; % required factor over current design force; fragility assumed to increase proportionately with the design force
            switch zoneOfLoc
                case 'II';  zoneMCE_PGA = 0.10;
                case 'III'; zoneMCE_PGA = 0.16;
                case 'IV';  zoneMCE_PGA = 0.24;
                case 'V';   zoneMCE_PGA = 0.36;
            end
            
%%% THIS IS DESIGN FORCE, calculated using a unique variable TaCurr
            switch TaCurr
                case 0;     SaByg = 1;
                otherwise;  SaByg = min(2.5, 1/TaCurr);
            end
            H_IM_d = zoneMCE_PGA/2 * SaByg; % design hazard value as per IS 1893 (Z/2 * Sa/g)
            RTGM_designHaz = H_IM_d * RTGM_ReqFac; % risk-targeted design hazard; assuming that design corresponds to DBE (Z/2*Sa/g)
            
            %% reverse calculate the design return period (assuming the original design to be for 475y) given the hazard curve and RTGM
            X = hazardDataCurr(1, :); Y = hazardDataCurr(2, :); % X- im values, Y- afe values (used only for interpolation)
            xq = RTGM_designHaz;
            if xq ~= 0
                ix = find(X >= xq, 1);
                if ix == 1 % even the first im in hazard curve is higher than hazard.
                    RTGM_RP = 0;
                else
                    yq = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
                    RTGM_RP = int32(1/yq); % A design corresponding to this the return period would result in target risk
                end
            else
                RTGM_RP = 0; % even the risk corresponding to imMin is less than target risk.
            end
            
            if verbose == 2; fprintf('RTGM-%4.3f;\t design RP-%i years.\n', riskTargetedMedianCap, int32(RTGM_RP)); end
%             tableWithAllInfo(counter, 10 + 2*k-1) = table(riskTargetedMedianCap);
%             tableWithAllInfo(counter, 10 + 2*k) = table(RTGM_RP);
            tableWithAllInfo(counter, 10 + k) = table(riskTargetedMedianCap);
            
            if counter == 1
%                 tableWithAllInfo.Properties.VariableNames{10 + 2*k - 1} = sprintf('RT_mu%i', k);
%                 tableWithAllInfo.Properties.VariableNames{10 + 2*k} = sprintf('RTGM_RP%i', k);
                tableWithAllInfo.Properties.VariableNames{10 + k} = sprintf('RT_mu%i', k);
            end
        end
        
        %% 5. Calculate the increased margin due to different importance factors.
        for p = 1:size(impFacLIST, 1)
            impFac = impFacLIST(p, 1);
%             additionalRiskMargin = increasedRiskMargin_v1(hazardDataCurr, fragilityDataCurr, impFac);
            additionalRiskMargin = increasedRiskMargin_v2(hazardDataCurr, fragilityDataCurr, impFac, imOrAfeBound, boundRangeCurr);
            if verbose == 2; fprintf('%4.3f\t', additionalRiskMargin ); end
%             tableWithAllInfo(counter, 10 + 2*k + p) = table(additionalRiskMargin);
            tableWithAllInfo(counter, 10 + k + p) = table(additionalRiskMargin);
            if counter == 1; tableWithAllInfo.Properties.VariableNames{end} = sprintf('riskFacImp%ip%i', floor(impFac), int32(mod(impFac*100, 100))); end
        end
        
        %% 6. (03-31-20) This is a standalone feature, I am making sure that this peace of the program does not interact with the rest of the program in any way.
        % it will simply plot lambda_ds versus importance factor for all buildings.

        impFacAll = 1:0.01:10;
        impFacPlotLim = 3;
        additionalRiskMarginTemp = zeros(size(impFacAll));
        for r = 1:size(impFacAll, 2)
            impFacCurr = impFacAll(1, r);
            additionalRiskMarginTemp(1, r) = increasedRiskMargin_v2(hazardDataCurr, fragilityDataCurr, impFacCurr, imOrAfeBound, boundRangeCurr);
        end

        actualRiskForI_1p0 = riskVal; % 0.81973891000707e-4    ; % copied for 2213 (Nst = 4, Delhi), with SaTi, Ti = 1.29 as IM
        riskWithImp = actualRiskForI_1p0./additionalRiskMarginTemp;
        
        %% 6a. SAVE all the IMP FAC versus lambda data in a structure
         cd ImpFacVersusLambdaData; save(['impFacVsLambdaData_' bldgIdCurr '_' ds], 'impFacAll', 'riskWithImp', 'actualRiskForI_1p0'); cd ..
                  
         switch ds 
             case 'CP'
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' 'DynInst']); cd ..
                 riskOneDsHigher = matObj.actualRiskForI_1p0;
                 beyondCodeFactorOneDsHigher = interp1(riskWithImp, impFacAll, riskOneDsHigher);
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' ds]); cd ..
                 matObj.Properties.Writable = true;
                 matObj.beyondCodeFactorOneDsHigher = beyondCodeFactorOneDsHigher;
             case 'LS'
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' 'CP']); cd ..
                 riskOneDsHigher = matObj.actualRiskForI_1p0;
                 beyondCodeFactorOneDsHigher = interp1(riskWithImp, impFacAll, riskOneDsHigher);
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' ds]); cd ..
                 matObj.Properties.Writable = true;
                 matObj.beyondCodeFactorOneDsHigher = beyondCodeFactorOneDsHigher;

                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' 'DynInst']); cd ..
                 riskTwoDsHigher = matObj.actualRiskForI_1p0;
                 beyondCodeFactorTwoDsHigher = interp1(riskWithImp, impFacAll, riskTwoDsHigher);
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' ds]); cd ..
                 matObj.Properties.Writable = true;
                 matObj.beyondCodeFactorTwoDsHigher = beyondCodeFactorTwoDsHigher;
             case 'IO'
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' 'LS']); cd ..
                 riskOneDsHigher = matObj.actualRiskForI_1p0;
                 beyondCodeFactorOneDsHigher = interp1(riskWithImp, impFacAll, riskOneDsHigher);
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' ds]); cd ..
                 matObj.Properties.Writable = true;
                 matObj.beyondCodeFactorOneDsHigher = beyondCodeFactorOneDsHigher;

                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' 'CP']); cd ..
                 riskTwoDsHigher = matObj.actualRiskForI_1p0;
                 beyondCodeFactorTwoDsHigher = interp1(riskWithImp, impFacAll, riskTwoDsHigher);
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' ds]); cd ..
                 matObj.Properties.Writable = true;
                 matObj.beyondCodeFactorTwoDsHigher = beyondCodeFactorTwoDsHigher;
                 
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' 'DynInst']); cd ..
                 riskThreeDsHigher = matObj.actualRiskForI_1p0;
                 beyondCodeFactorThreeDsHigher = interp1(riskWithImp, impFacAll, riskThreeDsHigher);
                 cd ImpFacVersusLambdaData; matObj = matfile(['impFacVsLambdaData_' bldgIdCurr '_' ds]); cd ..
                 matObj.Properties.Writable = true;
                 matObj.beyondCodeFactorThreeDsHigher = beyondCodeFactorThreeDsHigher;

         end

        % end of saving data, now plot
            
        %% 6b. Plot Imp fac versus lambda_ds data
        % plot(impFacAll, additionalRiskMargin, 'b-o', 'LineWidth', 1.5);
        if doPlotImpFacPlot == 1
            figure(101)
            hx = xlabel('Importance Factor');   set(hx, 'interpreter', 'Latex');
            hy = ylabel('$\lambda_{ds}$'); % hy = ylabel(['\lambda_{' ds, '}']);
            set(hy, 'interpreter', 'Latex');
            
            % hy = ylabel(['Annual Frequency of Exceedance, \lambda_{ds}']); % hy = ylabel(['\lambda_{' ds, '}']);
            switch ds
                case 'IO'; currPlotStyle = 'k--'; 
                case 'LS'; currPlotStyle = 'b-.';
                case 'CP'; currPlotStyle = 'm:';
                case 'DynInst'; currPlotStyle = 'r-'; % hy = ylabel('\lambda_{coll}');
            end
            
            % restrict the plots to impFacPlotLim
            riskWithImp(impFacAll > impFacPlotLim) = [];
            impFacAll(impFacAll > impFacPlotLim) = [];
            
            interv = 2.0001; % 2 or 2.1 depending on if we want space between two vertical plots
            
            % use this for six buildings
            if 1 == 0
                switch bldgIdCurr
                    case '2211v03_sca2'; impFacAll = impFacAll + 0;
                    case '2213v04_sca2'; impFacAll = impFacAll + 1*interv;
                    case '2215v03_sca2'; impFacAll = impFacAll + 2*interv;
                    case '2219v03_sca2'; impFacAll = impFacAll + 3*interv;
                    case '2221v06_sca2'; impFacAll = impFacAll + 4*interv;
                    case '2223v03_sca2'; impFacAll = impFacAll + 5*interv;
                end
                warning('Click here to change the x-axis overlap, if any'); % for easy navigation
            end
            
            % use this for two buildings
            if 1 == 1
                switch bldgIdCurr
                    case '2213v04_sca2'; impFacAll = impFacAll + 0;
                    case '2221v06_sca2'; impFacAll = impFacAll + 1*interv;
                end
                warning('Click here to change the x-axis overlap, if any'); % for easy navigation
            end
            semilogy(impFacAll, riskWithImp, currPlotStyle, 'LineWidth', 2); grid on; hold on;
            
%             legendText = [legendText; sprintf('%s-%i', bldgIdCurr, locID)];
%             legendText = [legendText; sprintf('ID-%s', bldgIdCurr(1:4))];
        end
        % end of #6
        
        if verbose == 2; fprintf('\n'); end
    end
    if verbose == 2; fprintf('--------------------------------------------------\n'); end
end
%     hleg = legend(legendText);
    psb_FigureFormatScript

cd(baseFolder);
%  (1a + 1b)- For efficiency, we can use also use a script 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (i) to store discretized hazard data for all grid points corresponding to different combinations 
%     of fitModel and N values, e.g., 2param_N11, 3param_N11, 2param_N21, 3param_N21, 2param_N51, 3param_N51, etc.
% (ii) and subsequently, simply read the discretized data from corresponding file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if verbose == 2; disp(tableWithAllInfo); end % later on move to outer loop or to the end of all nested loop

%% IMP- SAVE THE FOLLOWINGS IN A DATA FILE
% 1. the risk values associated with each buildings in each location
% 2. RTGM value for each location and each building with a specified risk target
% 3. Increased margin associated with each buildings in each location for given importance factor 

%%
% probably, write another function to estimate the dispersion in lambda
% arising out of variability in hazard and fragility, 
% Check if beta_lambda = SRSS(beta_H, beta_Frag)?

% toc