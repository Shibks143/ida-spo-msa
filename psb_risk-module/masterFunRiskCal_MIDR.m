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

%%
function tableWithAllInfo = masterFunRiskCal_MIDR(latLonLIST, zoneOfLocLIST, BldgIdAndZoneLIST, damageMeasure, intensityMeasureType, ds, imType, T1LIST, TaLIST, fitModel, N, imOrAfeBound, ...
boundRangeInp, verbose, imScaleFac, codeIdealizedHazData, factorOnImMin,BldgId)

baseFolder = pwd;
%% Inputs begin

% These two variables should be generally ZERO, i.e., we are not scaling code-idealized hazard to match with PSHA at 475y or 2475y
% naturally, they make any difference to the program only when codeIdealizedHazData = 1
% I am equating one of them to 1, only while studying the the effect of shape of hazard curve on risk
matchDBEWithPSHA475 = 0; % to observe the effect of shape of hazard curve on risk, we are matching code-idealized hazard at 475y/2475y with PSHA-based hazard
matchDBEWithPSHA2475 = 0;

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

% 1. Hazard-related inputs
if size(zoneOfLocLIST, 1) ~= size(latLonLIST, 1) 
    error('number of entries in siteZoneLIST does not match with number of (lat, lon) entries.'); 
end
    
%  1a. inputs for extracting  hazard 
doPlot = 1; 
plotType = 'loglog'; %'semilog'; 'loglog, 'linear'
imTypeForPlot = imType; 
locationLISTforPlot = {};
%  1b. inputs for discretizing hazard curve 
legendName = {}; 

% (OPTIONAL inputs) in the absence of any input no bound is considered
% imOrAfeBound = 1; % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
% boundRangeInp = [99 5]; % range of bound (over im or afe, as may be the case) 

% end of all inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%% 0. calculations begin
% 0. Assign MIDR and some beta values for fragility
betaDR = 0.20; % (6-6-19, PSB) SMRF- design requirements. 'Good' for SMRF (see Sec 6.2 of Denavit et al., 2016)
betaMDL = 0.20; % (6-6-19, PSB) modeling; good; index model capturing full range of archetype design space

switch ds  % it is for MIDR_drift based damage states
    case 'DynInst'
        MIDR_ds = 0.00; % proxy for dynamic instability
        betaTD = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
    case 'CP'
        MIDR_ds = 0.04; betaTD = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
    case 'LS'
        MIDR_ds = 0.02; betaTD = 0.10; % superior rating of test data for lower damage states
    case 'IO'
        MIDR_ds = 0.01; betaTD = 0.10; % superior rating of test data for lower damage states
    
    otherwise
        if startsWith(ds,'midr_')   % Continuous MIDR damage states
            temp = erase(ds,'midr_');
            temp = erase(temp,'pc');
            temp = strrep(temp,'p','.');
            MIDR_ds = str2double(temp)/100;

            if MIDR_ds <= 0.02    % assign betaTD for continuous damage states
                betaTD = 0.10;
            else
                betaTD = 0.20;
            end
        else
            error('Unknown damage state');
        end
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
        T1_eigenVal = matchingTimeP{locID, 1}(bldgNum, 1);
        T1_code = matchingTa{locID, 1}(bldgNum, 1);
        % T1_ogm = matchingTogm{locID, 1}(bldgNum, 1); % this needs to be
        % written, MIDR_input structure would need to be passed to this
        % function.

        inputDir = fullfile(baseFolder,'Input from Raghukanth');
        % 1a. extract hazard curve data (10-point-curve) from Raghukanth's file (received on Jan 11, 2020)
        switch imType
            case 'PGA'
                T1_im = 0; % T1 for the im 
            case 'Sa_Ta'
                T1_im = T1_code;
            case 'Sa_T1'
                T1_im = T1_eigenVal;
            case 'Sa_Togm'
                error('If this error appears, it means IM for risk is given as T_ogm, but the risk function is not yet set up for T_ogm.');
                % T1_im = 'T1_ogm';
        end
        [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(latLonCurr, doPlot, plotType, locationLISTforPlot, T1_im);

        %  1b. discretize each hazard curve individually
        [imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST, afe_Sa_T1_LIST, N, doPlot, plotType, imTypeForPlot, legendName);
      
        
%% codeIdealizedHazData; when 1, program calculates risk using code-idealized hazard employing two-parameter model based on DBE and MCE values
        if codeIdealizedHazData == 1
            fprintf('---------------------------------------------------------------------------------------------------\n');
            fprintf('---- PLEASE NOTE THAT PROGRAM IS USING CODE-IDEALIZED HAZARD CURVE, AND NOT ACTUAL HAZARD DATA ----\n');
            switch zoneOfLoc
                case 'II';  zoneMCE_PGA = 0.10; zoneDBE_PGA = zoneMCE_PGA/2;
                case 'III'; zoneMCE_PGA = 0.16; zoneDBE_PGA = zoneMCE_PGA/2;
                case 'IV';  zoneMCE_PGA = 0.24; zoneDBE_PGA = zoneMCE_PGA/2;
                case 'V';   zoneMCE_PGA = 0.36; zoneDBE_PGA = zoneMCE_PGA/2;
                case 'VI_proposed';   zoneMCE_PGA = 0.75; zoneDBE_PGA = 0.50;
            end
            switch T1_im
                case 0;     SaByg = 1;
                otherwise;  SaByg = min(1+15*T1_im, min(2.5, 1/T1_code));
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
            else % this is the default case now (2026)
                DBE = zoneDBE_PGA * SaByg; % design hazard value as per IS 1893 (Z/2 * Sa/g)
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
        fragDataFile = sprintf('DATA_fragility_%s_%s_%s.mat', damageMeasure, intensityMeasureType, BldgId);
        % fragDataFile = sprintf('DATA_fragility_ALL.mat');
        % fragDataFile = sprintf('DATA_fragility_%s_%s.mat', damageMeasure, intensityMeasureType); 
        fileWithPath = fullfile(dataDir, fragDataFile);

        % At this point, define a variable imTypeT1 which is different from imType only if T1 is given as an input
        switch imType
            % imType is always 'Sa_T1' now; use different T1 values to consider all IM
            case 'Sa_T1' % the following piece basically equates imTypeT1 to imType if T_new is one of the above values, else to Sa_1p35, etc.
                % following condition makes sure that we do not end up getting two variables as Sa_1p2 and Sa_1p20
                if abs(T1_im - 0) < 1e-6 % i.e., if it's PGA, assign 'PGA'
                    imTypeT1 = 'PGA';
                elseif abs(mod(T1_im*100, 10)) < 1e-6 % i.e., if the second digit after decimal is zero, e.g., 1.4
                    imTypeT1 = sprintf('Sa_%ip%i', floor(T1_im), int8(mod(T1_im*10, 10))); % assign Sa_1p4
                else                    % i.e., if the second digit after decimal is non-zero, e.g., 1.35
                    imTypeT1 = sprintf('Sa_%ip%.2i', floor(T1_im), int8(mod(T1_im*100, 100))); % assign Sa_1p35
                end
        end
          try
              load(fileWithPath, 'fragAllData'); 
                bldgIdVar = ['ID' bldgIdCurr]; % varName for storing building ID (same as in DATA file and as in scriptForFragilityDataGen_v2)
                
                % assign fields of the building-specific struct to new variables.
                timePDataVec = fragAllData.(bldgIdVar).timeP;
                dsDataVec = fragAllData.(bldgIdVar).ds;
                muAllMat = fragAllData.(bldgIdVar).muAll;
                betaRTRAllMat = fragAllData.(bldgIdVar).betaRTRAll;
                muCtrlMat = fragAllData.(bldgIdVar).muCtrl;
                betaRTRCtrlMat = fragAllData.(bldgIdVar).betaRTRCtrl;
                imMinMat = fragAllData.(bldgIdVar).imMin;
                
                % find matching time period and damage state
                [~, rowId] = min(abs(timePDataVec - T1_im)); % added on 22-Apr-2026
                colId = find(strcmp(dsDataVec, ds), 1);
                % rowId = find(abs(timePDataVec - T1Curr) < 1e-6,1);
                % colId = find(strcmp(dsDataVec, ds));
                
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
              
        %%
        boundRangeCurr = boundRangeInp;
        if boundRangeInp(1) == 99 % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
            boundRangeCurr(1) = fragilityDataCurr(1, 3)*factorOnImMin; % factorOnImMin, if given as input, reduces the imMin value (DEFAULT value = 1)

            if verbose == 2; fprintf('Lower intensity bound CHANGED TO the minimum of analyses as %f\n', boundRangeCurr(1)); end
        end
        %%
        [riskVal, highestContriIM, modalImRatio] = computeRiskSingleSite_v3(hazardDataCurr, fragilityDataCurr(1, 1:2), imOrAfeBound, boundRangeCurr);
        
        mu_ds = fragilityDataCurr(1, 1); 
        omega = mu_ds/H_475;
        if verbose == 2; fprintf('%i\t%s\t%s\t%4.3f\t%4.3f\t%4.3f\t%4.3f\t%.2e\t', counter, zoneOfLoc, bldgIdCurr, H_475, H_2475, mu_ds, omega, riskVal); end
        
        Zone = cellstr(zoneOfLoc); BldgID = cellstr(bldgIdCurr);
        siteBldgDsT1 = cellstr(sprintf('%i-%i-%s-%.2fs', locID, bldgNum, ds, T1_im));
        % storing all values in a structure
        tableWithAllInfo(counter, 1:10) = table(siteBldgDsT1, Zone, BldgID, boundRangeCurr(1), boundRangeCurr(2), H_475, H_2475, mu_ds, omega, riskVal);
        tableWithAllInfo.Properties.VariableNames{4} = sprintf('%s_Min', 'im'); % imTypeT1); % Since, IM changes with bldg now, we're identifying imType from the first var name
        tableWithAllInfo.Properties.VariableNames{5} = sprintf('%s_Max', 'im'); % imTypeT1); % Since, IM changes with bldg now, we're identifying imType from the first var name
        tableWithAllInfo.Properties.VariableNames{8} = sprintf('mu_%s', 'ds'); % ds); % Now identifying the ds from the first var name
        warning('off','MATLAB:table:RowsAddedExistingVars'); % suppressing warning
        
        %       for intermediate results to see how far off from median is imMin
        eps1 = (log(boundRangeCurr(1)) - log(fragilityDataCurr(1, 1))) / fragilityDataCurr(1, 2);
        eps1LIST(counter, 1) = eps1;
           
        if verbose == 2; fprintf('\n'); end
    end
    if verbose == 2; fprintf('--------------------------------------------------\n'); end
end
cd(baseFolder);

if verbose == 2; disp(tableWithAllInfo); 
end % later on move to outer loop or to the end of all nested loop
