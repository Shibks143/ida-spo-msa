function MultObjTable = masterFunLambdaARCR_v2(IdToAnalyze, T1forIM, ...
    normalizedByThetaU, DS2_threshold, consqModel, fitModel, N, imOrAfeBound, boundRangeInp,  ...
    verbose, imScaleFac, codeIdealizedHazData, factorOnImMin, saveFigures, dirForFigures)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% SCOPE FOR IMPROVEMENT %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imDescForFrag and imDescForRCR are defined on the fly 
% Consider changing them based on arguments for bounds, if needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sample inputs
% IdToAnalyze = '2211v03';
% IdToAnalyze = '2213v04';
% IdToAnalyze = '2215v03';
% IdToAnalyze = '2219v03';
% IdToAnalyze = '2221v06';
% IdToAnalyze = '2223v03';

% T1forIM = 0; % Sa(T1) used as IM
% T1forIM = 99; % 99 meaning SaT1 = SaTa

% normalizedByThetaU = 1; % chi (= thetaM/thetaU) used as critical column parameter for DS2 and DS3
% normalizedByThetaU = 0; % xi (= thetaM/thetaCap) used as critical column parameter for DS2 and DS3

% chi (= thetaM/thetaU) used as critical column parameter
% consqModel = [2, 10, 40.4, 100]; % DS1, DS2, DS3, and DS4; repair cost ratio (% of building repair cost) (COM4 from HAZUS 2003)
% fitModel = '3param';
% N = 21;
% imOrAfeBound = 1; % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
% boundRangeInp = [99, 5.0]; % lower and upper bound; 99 as lower bound indicates imMin from analysis to be considered


% verbose = 1; % for debugging, set this to 2; this will just print more intermediate results 
% imScaleFac = 1.00; % this is an optional variable; used for paramteric study to see the impact of hazard variation on risk
% codeIdealizedHazData = 1; % 1, the program uses code-idealized hazard using two-parameter model based on DBE and MCE values
% codeIdealizedHazData = 0; % 0 or NO input, would invoke the use of actual hazard curve for risk calculation 
% factorOnImMin = 1; % optional variable that reduces the imMin value
% saveFigures = 0; % when running for optimal beta, do not saveFigures
% dirForFigures = 'figures_revB';
% pLIST = [0.20, 0.10, 0.02, 0.01, 0.005]; % (in fraction) i.e., 0.10 for 10% poe in 50 years.

% end of inputs

%%  Assign precise BldgID, eqLIST, Ta
switch IdToAnalyze 
    case '2211v03'
        BldgId = '2211v03_sca2';
        GMsuiteName = 'GMSetDel22_2211_Sca2'; 
        eqLIST = [6000311	6000312	6001601	6001602	6001831	6001832	6002121	6002122	6002851	6002852	6003411	6003412	6003521	6003522	6004081	6004082	6004091	6004092	6004571	6004572	6004581	6004582	6004611	6004612	6006331	6006332	6006921	6006922	6007861	6007862	6009521	6009522	6009681	6009682	6009871	6009872	6011351	6011352	6014361	6014362	6023951	6023952	6026271	6026272];
        
        latLon = [28.62   77.22]; % Delhi (Table 5.4 of NDMA, 2011 report)
        locName = 'Delhi';
        zoneOfLoc = 'IV';
        Ta = 0.37;
    
    case '2213v04'
        BldgId = '2213v04_sca2';
        GMsuiteName = 'GMSetDel22_2213_Sca2';
        eqLIST = [6002301	6002302	6002501	6002502	6003391	6003392	6005481	6005482	6007201	6007202	6007531	6007532	6008321	6008322	6008361	6008362	6008501	6008502	6008731	6008732	6009311	6009312	6009701	6009702	6009891	6009892	6010781	6010782	6011581	6011582	6012921	6012922	6013161	6013162	6013611	6013612	6015321	6015322	6026181	6026182	6026611	6026612	6032701	6032702];
        latLon = [28.62   77.22]; % Delhi (Table 5.4 of NDMA, 2011 report)
        locName = 'Delhi';
        zoneOfLoc = 'IV';
        Ta = 0.61;

    case '2215v03'
        BldgId = '2215v03_sca2';
        GMsuiteName = 'GMSetDel22_2215_Sca2';
        eqLIST = [6001581	6001582	6003001	6003002	6005711	6005712	6007281	6007282	6007371	6007372	6007571	6007572	6008841	6008842	6009491	6009492	6009881	6009882	6011111	6011112	6011201	6011202	6011821	6011822	6011931	6011932	6013091	6013092	6013441	6013442	6014181	6014182	6014751	6014752	6015381	6015382	6016281	6016282	6024571	6024572	6025091	6025092	6027341	6027342];
        latLon = [28.62   77.22]; % Delhi (Table 5.4 of NDMA, 2011 report)
        locName = 'Delhi';
        zoneOfLoc = 'IV';
        Ta = 0.91;

    case '2219v03'
        BldgId = '2219v03_sca2'; 
        GMsuiteName = 'GMSetGuw22_2219_Sca2';
        eqLIST = [6000961	6000962	6004071	6004072	6006391	6006392	6007271	6007272	6007281	6007282	6007441	6007442	6007731	6007732	6008251	6008252	6008791	6008792	6009021	6009022	6009521	6009522	6009591	6009592	6009871	6009872	6010041	6010042	6010501	6010502	6010771	6010772	6010871	6010872	6012381	6012382	6015461	6015462	6017621	6017622	6027391	6027392	6034741	6034742];
        latLon = [26.17   91.77]; % Guwahati (Table 5.4 of NDMA, 2011 report)
        locName = 'Guwahati';
        zoneOfLoc = 'V';
        Ta = 0.37;

    case '2221v06'
        BldgId = '2221v06_sca2'; 
        GMsuiteName = 'GMSetGuw22_2221_Sca2';
        eqLIST = [6000061	6000062	6000951	6000952	6000961	6000962	6001431	6001432	6001501	6001502	6002651	6002652	6003591	6003592	6004951	6004952	6005291	6005292	6005641	6005642	6007271	6007272	6007521	6007522	6007661	6007662	6008081	6008082	6010041	6010042	6010501	6010502	6011201	6011202	6011661	6011662	6012921	6012922	6014891	6014892	6014921	6014922	6027521	6027522];
        latLon = [26.17   91.77]; % Guwahati (Table 5.4 of NDMA, 2011 report)
        locName = 'Guwahati';
        zoneOfLoc = 'V';
        Ta = 0.61;

    case '2223v03'
        BldgId = '2223v03_sca2'; 
        GMsuiteName = 'GMSetGuw22_2223_Sca2';
        eqLIST = [6000771	6000772	6001601	6001602	6001801	6001802	6004951	6004952	6005291	6005292	6007531	6007532	6008061	6008062	6010421	6010422	6010441	6010442	6010541	6010542	6010631	6010632	6010861	6010862	6010871	6010872	6011011	6011012	6012621	6012622	6014771	6014772	6015111	6015112	6015211	6015212	6017871	6017872	6017921	6017922	6032751	6032752	6033171	6033172];
        latLon = [26.17   91.77]; % Guwahati (Table 5.4 of NDMA, 2011 report)
        locName = 'Guwahati';
        zoneOfLoc = 'V';
        Ta = 0.91;
end

if T1forIM == 99
    T1forIM = Ta;
end

%% fixed inputs (do NOT carry these as function arguments)
doPlotHaz = 0;
plotType = 'loglog'; % 'semilog', 'loglog, 'linear'
locationLISTforPlot = [];

% Following two variables are generally ZERO, i.e., we are using code-idealized hazard to match with PSHA at 475y or 2475y
% They make any difference to the program only when codeIdealizedHazData = 1
% I am equating one of them to 1, only while studying the the effect of shape of hazard curve on risk 
matchDBEWithPSHA475 = 0; % to observe the effect of shape of hazard curve on risk, we are matching code-idealized hazard at 475y/2475y with PSHA-based hazard
matchMCEWithPSHA2475 = 1; % when these both are zero, we use unscaled code-idealized hazard curve

%% 0. calculations begin
baseFolder = pwd;

%% 1a. Import Hazard 
cd('Input from Raghukanth')
% 1a.1 extract hazard curve data (10-point-curve) from Raghukanth's file (received on Jan 11, 2020)
[imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(latLon, doPlotHaz, plotType, locationLISTforPlot, T1forIM);
% 1a.2 discretize hazard curve 
if T1forIM == 0; imNameForPlot = 'PGA (g)'; else imNameForPlot = sprintf('Sa(%.2f) (g)', T1forIM); end
[imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST, afe_Sa_T1_LIST, N, 1, plotType, imNameForPlot, locName);
    if saveFigures == 1
        cd(baseFolder);  cd(dirForFigures);
        strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
        exportNamehaz = sprintf('Haz_%s_%s_%s', BldgId, locName, strForIM);
        hgsave(exportNamehaz); % .fig file for Matlab
        print('-depsc', exportNamehaz); % .eps file for Linux (LaTeX)
        print('-dmeta', exportNamehaz); % .emf file for Windows (MSWORD)
        cd ..
    end
    
%% 1a.1 if codeIdealizedHazData; when 1, program calculates risk using code-idealized hazard employing two-parameter model based on DBE and MCE values
% calculate code-based hazard_DBE and hazard_MCE
switch zoneOfLoc
    case 'II';  zoneMCE_PGA = 0.10;
    case 'III'; zoneMCE_PGA = 0.16;
    case 'IV';  zoneMCE_PGA = 0.24;
    case 'V';   zoneMCE_PGA = 0.36;
end
switch T1forIM
    case 0;     SaByg = 1;
    otherwise;  SaByg = min(1 + 15*T1forIM, min(2.5, 1/T1forIM));
end

DBE = zoneMCE_PGA/2 * SaByg; % design hazard value as per IS 1893 (Z/2 * Sa/g)
MCE = 2 * DBE;

TrDBE = 475; TrMCE = 2475;
poeDBE = 1 / TrDBE; poeMCE = 1 / TrMCE; % prob of exceedance

SaVector = [MCE; DBE];
hazardVector = [poeMCE; poeDBE];

X = log(SaVector); % based on EN 1998 -1 : 2004, section 2.1(4), H(a_gR) = k_0 * a_gR^(-k)
Y = log(hazardVector);

A = [X, ones(length(X), 1)];
coeff = ((inv(A' * A)) * A') * Y;
k_1893 = - coeff(1); k0_1893 = exp(coeff(2));
% afeDisc = k0_1893 * imValDisc.^(-k_1893);
Sa_code_475 = (1/475/k0_1893)^(-1/k_1893);
Sa_code_2475 = (1/2475/k0_1893)^(-1/k_1893);

if codeIdealizedHazData == 1
    fprintf('---------------------------------------------------------------------------------------------------\n');
    fprintf('---- PLEASE NOTE THAT PROGRAM IS USING CODE-IDEALIZED HAZARD CURVE, AND NOT ACTUAL HAZARD DATA ----\n');

    
    X = afeDisc; Y = imValDisc; % X- POE, Y- im values (used only for interpolation)
    xq = 1/475; ix = find(X <= xq, 1);
    H_475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
    xq = 1/2475; ix = find(X <= xq, 1);
    H_2475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
    % to observe the effect of shape of hazard curve on risk, we are matching code-idealized hazard at 475y/2475y with PSHA-based hazard
    if matchDBEWithPSHA475 == 1
        warning('---- MATCHING CODE-BASED DBE WITH PSHA AT Tr = 475y. ----');
        DBE = H_475;
    elseif matchMCEWithPSHA2475 == 1
        warning('---- MATCHING CODE-BASED MCE WITH PSHA AT Tr = 2475y. ----');
        DBE = H_2475/2;
    else    % in this case, we use unscaled code-idealized hazard curve
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
afeScaleFac = 1.00;
hazardDataCurr = [imValDisc * imScaleFac; afeDisc * afeScaleFac];
    
%% 1b. Import Fragility Data from DamageState folder (valid for arbitrary SaT1 using variable T1forIM)
cd(baseFolder);
% 0a. Assign directory locations, datafile names, and beta values for fragiliy
    betaDR = 0.20; % (6-6-19, PSB) SMRF- design requirements. 'Good' for SMRF (see Sec 6.2 of Denavit et al., 2016)
    betaMDL = 0.20; % (6-6-19, PSB) modeling; good; index model capturing full range of archetype design space
    
% case 'DS1'
    damageState = 'DS1';
    betaTD_DS1 = 0.10; % superior rating of test data for lower damage states
    [mu_DS1_ALL, betaRTR_DS1_ALL, mu_DS1, betaRTR_DS1, imMin_DS1] = extractFragilityForDS_DayalaEtAl_v1(BldgId, GMsuiteName, eqLIST, damageState, T1forIM);
    betaTOT_DS1 = sqrt(betaRTR_DS1^2 + betaMDL^2 + betaDR^2 + betaTD_DS1^2); 
    
% case 'DS2'
    if normalizedByThetaU == 1 % chi (= thetaM/thetaU) used as critical column parameter
        if abs(DS2_threshold - 0.75) < 1e-6
            damageState = 'DS2_normalizedByThetaU';
        elseif abs(DS2_threshold - 0.60) < 1e-6
            damageState = 'DS2a_0p60_normalizedByThetaU';
        elseif abs(DS2_threshold - 0.50) < 1e-6
            damageState = 'DS2a_0p50_normalizedByThetaU';
        elseif abs(DS2_threshold - 0.40) < 1e-6
            damageState = 'DS2a_0p40_normalizedByThetaU';
        end
            betaTD_DS2 = 0.10; % superior rating of test data for lower damage states
            [mu_DS2_ALL, betaRTR_DS2_ALL, mu_DS2, betaRTR_DS2, imMin_DS2] = extractFragilityForDS_DayalaEtAl_v1(BldgId, GMsuiteName, eqLIST, damageState, T1forIM);
    elseif normalizedByThetaU == 0 % xi (= thetaM/thetaCap) used as critical column parameter
        if abs(DS2_threshold - 0.75) < 1e-6
            damageState = 'DS2_normalizedByThetaCap';
        elseif abs(DS2_threshold - 0.60) < 1e-6
            damageState = 'DS2a_0p60_normalizedByThetaCap';
        elseif abs(DS2_threshold - 0.50) < 1e-6
            damageState = 'DS2a_0p50_normalizedByThetaCap';
        elseif abs(DS2_threshold - 0.40) < 1e-6
            damageState = 'DS2a_0p40_normalizedByThetaCap';
        end
        betaTD_DS2 = 0.10; % superior rating of test data for lower damage states
        [mu_DS2_ALL, betaRTR_DS2_ALL, mu_DS2, betaRTR_DS2, imMin_DS2] = extractFragilityForDS_DayalaEtAl_v1(BldgId, GMsuiteName, eqLIST, damageState, T1forIM);
    end
    
    betaTOT_DS2 = sqrt(betaRTR_DS2^2 + betaMDL^2 + betaDR^2 + betaTD_DS2^2);
    
% case 'DS3'
if normalizedByThetaU == 1 % chi (= thetaM/thetaU) used as critical column parameter
    damageState = 'DS3_normalizedByThetaU';
    betaTD_DS3 = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
    [mu_DS3_ALL, betaRTR_DS3_ALL, mu_DS3, betaRTR_DS3, imMin_DS3] = extractFragilityForDS_DayalaEtAl_v1(BldgId, GMsuiteName, eqLIST, damageState, T1forIM);
elseif normalizedByThetaU == 0 % xi (= thetaM/thetaCap) used as critical column parameter
    damageState = 'DS3_normalizedByThetaCap';
    betaTD_DS3 = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
    [mu_DS3_ALL, betaRTR_DS3_ALL, mu_DS3, betaRTR_DS3, imMin_DS3] = extractFragilityForDS_DayalaEtAl_v1(BldgId, GMsuiteName, eqLIST, damageState, T1forIM);
end
    betaTOT_DS3 = sqrt(betaRTR_DS3^2 + betaMDL^2 + betaDR^2 + betaTD_DS3^2); 

% case 'DS4'
    damageState = 'DS4';
    betaTD_DS4 = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
    [mu_DS4_ALL, betaRTR_DS4_ALL, mu_DS4, betaRTR_DS4, imMin_DS4] = extractFragilityForDS_DayalaEtAl_v1(BldgId, GMsuiteName, eqLIST, damageState, T1forIM);
    betaTOT_DS4 = sqrt(betaRTR_DS4^2 + betaMDL^2 + betaDR^2 + betaTD_DS4^2); 
    
%% 1c. plot and save fragility 
    figure; imDescForFrag = 0:0.01:5;
    plot(imDescForFrag, normcdf(log(imDescForFrag), log(mu_DS1), betaTOT_DS1), 'k--', 'LineWidth', 1.5); hold on; grid on;
    plot(imDescForFrag, normcdf(log(imDescForFrag), log(mu_DS2), betaTOT_DS2), 'b-.', 'LineWidth', 1.5);
    plot(imDescForFrag, normcdf(log(imDescForFrag), log(mu_DS3), betaTOT_DS3), 'm:', 'LineWidth', 1.5);
    plot(imDescForFrag, normcdf(log(imDescForFrag), log(mu_DS4), betaTOT_DS4), 'r-', 'LineWidth', 1.5);
    
    hlegend = legend('DS1', 'DS2', 'DS3', 'DS4');
    if T1forIM == 0; hx = xlabel('PGA (g)');  else hx = xlabel(sprintf('Sa(%.2f) (g)', T1forIM)); end
    hy = ylabel('P_{ds}');
    xlim([0 2.0]); ylim([0 1]);
    psb_FigureFormatScript_paper
    
    if saveFigures == 1
        cd(baseFolder);  cd(dirForFigures);
        strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
        exportNameFrag = sprintf('fragility_%s_%s', BldgId, strForIM);
        hgsave(exportNameFrag); % .fig file for Matlab
        print('-depsc', exportNameFrag); % .eps file for Linux (LaTeX)
        print('-dmeta', exportNameFrag); % .emf file for Windows (MSWORD)
        cd ..
    end

%% 2a. calculations for risk corresponding to each damage state
    boundRange_DS1 = boundRangeInp; 
    boundRange_DS2 = boundRangeInp; 
    boundRange_DS3 = boundRangeInp; 
    boundRange_DS4 = boundRangeInp; 
    if boundRangeInp(1) == 99 % 99, to indicate that lowerBound is taken as the minimum im Value from fragility analysis
        boundRange_DS1(1) = imMin_DS1*factorOnImMin; % factorOnImMin, ifgiven as input, reduces the imMin value (DEFAULT value = 1)
        boundRange_DS2(1) = imMin_DS2*factorOnImMin; % factorOnImMin, ifgiven as input, reduces the imMin value (DEFAULT value = 1)
        boundRange_DS3(1) = imMin_DS3*factorOnImMin; % factorOnImMin, ifgiven as input, reduces the imMin value (DEFAULT value = 1)
        boundRange_DS4(1) = imMin_DS4*factorOnImMin; % factorOnImMin, ifgiven as input, reduces the imMin value (DEFAULT value = 1)
        if verbose == 2; fprintf('Lower intensity bound CHANGED TO the minimum of analyses as %f, %f, %f, and %f, for DS1 through DS4.\n', boundRange_DS1(1), boundRange_DS2(1), boundRange_DS3(1), boundRange_DS4(1)); end
    end
    [riskVal_DS1, highestContriIM_DS1, modalImRatio_DS1] = computeRiskSingleSite_v3(hazardDataCurr, [mu_DS1, betaTOT_DS1], imOrAfeBound, boundRange_DS1);
    [riskVal_DS2, highestContriIM_DS2, modalImRatio_DS2] = computeRiskSingleSite_v3(hazardDataCurr, [mu_DS2, betaTOT_DS2], imOrAfeBound, boundRange_DS2);
    [riskVal_DS3, highestContriIM_DS3, modalImRatio_DS3] = computeRiskSingleSite_v3(hazardDataCurr, [mu_DS3, betaTOT_DS3], imOrAfeBound, boundRange_DS3);
    [riskVal_DS4, highestContriIM_DS4, modalImRatio_DS4] = computeRiskSingleSite_v3(hazardDataCurr, [mu_DS4, betaTOT_DS4], imOrAfeBound, boundRange_DS4);
    
    BuildingID = cellstr(BldgId);
    IM = cellstr(strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p'));
    MultObjTable = table(BuildingID, IM, riskVal_DS1, riskVal_DS2, riskVal_DS3, riskVal_DS4);
    MultObjTable.Properties.VariableNames{end-3} = 'lambda_DS1';
    MultObjTable.Properties.VariableNames{end-2} = 'lambda_DS2';
    MultObjTable.Properties.VariableNames{end-1} = 'lambda_DS3';    
    MultObjTable.Properties.VariableNames{end} = 'lambda_DS4';
    
%% 2b. calculations for vulnerability begin
    consq_DS1 = consqModel(1, 1);   consq_DS2 = consqModel(1, 2);
    consq_DS3 = consqModel(1, 3);   consq_DS4 = consqModel(1, 4);
    
    imDescForRCR = 0.01:0.01:5;
    counter = 0; dv_RCR = zeros(size(imDescForRCR));
    for im = imDescForRCR
        counter = counter + 1;
        P_DS4 = normcdf(log(im), log(mu_DS4), betaTOT_DS4);
        P_DS3 = normcdf(log(im), log(mu_DS3), betaTOT_DS3);
        P_DS2 = normcdf(log(im), log(mu_DS2), betaTOT_DS2);
        P_DS1 = normcdf(log(im), log(mu_DS1), betaTOT_DS1);
        
        P_DS4_only = P_DS4;
        P_DS3_only = P_DS3 - P_DS4;
        P_DS2_only = P_DS2 - P_DS3;
        P_DS1_only = P_DS1 - P_DS2;
        
%         dv_RCR(counter) = (P_DS4_only * consq_DS4 + P_DS3_only * consq_DS3 + ...
%                          P_DS2_only * consq_DS2 + P_DS1_only * consq_DS1)/100;

% Revising the expression based on Consenza et al (2018)
        dv_RCR(counter) = (P_DS4_only * consq_DS4 + ...
                           P_DS3_only * (consq_DS3 + consq_DS4)/2 + ...
                           P_DS2_only * (consq_DS2 + consq_DS3)/2 + ...
                           P_DS1_only * (consq_DS1 + consq_DS2)/2)/100;
                     
        DS4_contr_LIST(counter) = (P_DS4_only * consq_DS4)/100;
        DS3_contr_LIST(counter) = (P_DS3_only * consq_DS3)/100;
        DS2_contr_LIST(counter) = (P_DS2_only * consq_DS2)/100;
        DS1_contr_LIST(counter) = (P_DS1_only * consq_DS1)/100;
    end
    
%% 2c. plot and save vulnerability 
    figure; 
    
    plot(imDescForRCR, dv_RCR, 'k-', 'LineWidth', 1.5); hold on; grid on;
    plot(imDescForRCR, DS1_contr_LIST, 'k--', 'LineWidth', 1.5);
    plot(imDescForRCR, DS2_contr_LIST, 'b-.', 'LineWidth', 1.5);
    plot(imDescForRCR, DS3_contr_LIST, 'm:', 'LineWidth', 1.5);
    plot(imDescForRCR, DS4_contr_LIST, 'r-', 'LineWidth', 1.5);
%     plot(imDescForRCR, DS4_contr_LIST, 'color', [0.5, 0.5, 0.5], 'linestyle', '--', 'LineWidth', 1.5);
    
    hlegend = legend('Total', 'DS1 contribution', 'DS2 contribution', 'DS3 contribution', 'DS4 contribution', 'Location', 'NorthWest');
    if T1forIM == 0; hx = xlabel('PGA (g)');  else hx = xlabel(sprintf('Sa(%.2f) (g)', T1forIM)); end
    hy = ylabel('Repair Cost Ratio');
    xlim([0 0.9]); ylim([0 0.15]);
    psb_FigureFormatScript_paper
    
    if saveFigures == 1
        cd(baseFolder);  cd(dirForFigures);
        strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
        exportNameRCR = sprintf('RCR_%s_%s', BldgId, strForIM);
        hgsave(exportNameRCR); % .fig file for Matlab
        print('-depsc', exportNameRCR); % .eps file for Linux (LaTeX)
        print('-dmeta', exportNameRCR); % .emf file for Windows (MSWORD)
        cd ..
    end
    
%% 2d. Print RCR for DBE and MCE
    X = hazardDataCurr(2, :); Y = hazardDataCurr(1, :); % X- POE, Y- im values (used only for interpolation)
    RP = -50/log(1-0.1); % almost 475 but not exactly (I made this precise to match H_475 with the subsequent estimates of H when the input is 10% in 50y)
%     xq = 1/RP; ix = find(X <= xq, 1);
%     H_475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
    H_475 = interp1(X, Y, 1/RP, 'pchip');
    
    RP = -50/log(1-0.02); % almost 2475 but not exactly (I made this precise to match H_2475 with the subsequent estimates of H when the input is 2% in 50y)
%     xq = 1/RP; ix = find(X <= xq, 1);
%     H_2475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
    H_2475 = interp1(X, Y, 1/RP, 'pchip');

    X = imDescForRCR; Y = dv_RCR; % X- im Values, Y- RCR values (used only for interpolation)
    xq = H_475; ix = find(X >= xq, 1);
    RCR_475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
    RCR_SaCode_475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], Sa_code_475, 'pchip');
    
    xq = H_2475; ix = find(X >= xq, 1);
    RCR_2475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
    RCR_SaCode_2475 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], Sa_code_2475, 'pchip');
    
%     MultObjTable = [MultObjTable, table(H_475, H_2475, RCR_475, RCR_2475)];
    MultObjTable = [MultObjTable, table(H_475, H_2475, RCR_SaCode_475, RCR_SaCode_2475)];
    
%% 3. lambda_DV (annual repair cost ratio) = Convolution of hazard curve and vulnerability 
%% 3a. Descretized hazard; imValues for hazard are different from those for RCR.
% interpolate hazard for im values that were used for RCR.
    interpHazard = interp1(hazardDataCurr(1, :), hazardDataCurr(2, :), imDescForRCR, 'pchip');
    hazardGrad = abs(gradient(interpHazard) ./ gradient(imDescForRCR)); % slope of hazard

%% 3b. Vulnerability gradient if using the alternate expression
    vulnGrad = abs(gradient(dv_RCR)./ gradient(imDescForRCR));

%% 3c. lambda_DV integrand
    lambda_RCR_integrand1 = hazardGrad .* dv_RCR;
    lambda_RCR_integrand2 = interpHazard .* vulnGrad;

%% 3d. calculating the convolution integral
    lambda_RCR_integrand1(isnan(lambda_RCR_integrand1)) = 0; % converting the NaN values to zero
    lambda_RCR_integrand2(isnan(lambda_RCR_integrand2)) = 0; % converting the NaN values to zero

    lambda_RCR1_in_pc = trapz(imDescForRCR, lambda_RCR_integrand1)*1e4;
    lambda_RCR2_in_pc = trapz(imDescForRCR, lambda_RCR_integrand2)*1e4;
    % fprintf('lambda_RCR using two expressions are %g and %g.\n', lambda_RCR1, lambda_RCR2);

    figure
    % plot(imDescForRCR, lambda_RCR_integrand1, 'b--', 'LineWidth', 1.5); hold on; grid on; box on;
    plot(imDescForRCR, lambda_RCR_integrand2, 'k-', 'LineWidth', 1.5); hold on; grid on; box on;
    % theoretically, we condition the vulnerability over hazard, hence the slope of vulnerability is preferred (also, it's intergrand is smoother)

    if T1forIM == 0; hx = xlabel('PGA (g)');  else hx = xlabel(sprintf('Sa(%.2f) (g)', T1forIM)); end
    hy = ylabel('Mean RCR Integrand'); 
    xlim([0 2.5]); % ylim([0 1]);
    psb_FigureFormatScript_paper
    
    if saveFigures == 1
        cd(baseFolder);  cd(dirForFigures);
        strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
        exportNameRCR = sprintf('ARCRIntegrand_%s_%s', BldgId, strForIM);
        hgsave(exportNameRCR); % .fig file for Matlab
        print('-depsc', exportNameRCR); % .eps file for Linux (LaTeX)
        print('-dmeta', exportNameRCR); % .emf file for Windows (MSWORD)
        cd ..
    end
   
    MultObjTable = [MultObjTable, table(lambda_RCR2_in_pc)];
    MultObjTable.Properties.VariableNames{end} = 'lambda_RCR_in_pc';
    

%% Following piece is functional. It calculates deaggregation of lambda and contriution of each DS for different Levels of hazard. 
% But I am commenting these out for I don't need them in Multi-obj RTSD framework paper    
if 1 == 0 
%% 4. lambda_DV deaggregation
    [~, index_DV2] = max(lambda_RCR_integrand2); 
    highestContriIM_RCR2 = imDescForRCR(index_DV2); 
    RP_highestContriIM_RCR2 = 1/interp1(hazardDataCurr(1, :), hazardDataCurr(2, :), highestContriIM_RCR2, 'pchip');

%     fprintf('For bldg ID- %i, \n\tLambda_DV annual repair cost ratio is %.4e. \n', BldgId, lambda_RCR2);
%     fprintf('\tHighest contributing IM value to annual repair cost ratio is %.3fg (%iy). \n', highestContriIM_RCR2, int32(RP_highestContriIM_RCR2));
    MultObjTable = [MultObjTable, table(highestContriIM_RCR2, int32(RP_highestContriIM_RCR2))];
    MultObjTable.Properties.VariableNames{end-1} = 'modalIM_RCR';
    MultObjTable.Properties.VariableNames{end} = 'RP_modalIM_RCR';

%% contribution to vulnerability at DBE and MCE
    for i = 1:size(pLIST, 2)
        p = pLIST(1, i); % fraction poe in 50 year; i.e., 0.10 for 10%
        RP_p = -50/log(1-p); 
        im_RP = interp1(hazardDataCurr(2, :), hazardDataCurr(1, :), 1/RP_p, 'pchip');

        dv_RCR_RP = interp1(imDescForRCR, dv_RCR, im_RP, 'pchip');

        DS1_contr_RP = interp1(imDescForRCR, DS1_contr_LIST, im_RP, 'pchip')/dv_RCR_RP;
        DS2_contr_RP = interp1(imDescForRCR, DS2_contr_LIST, im_RP, 'pchip')/dv_RCR_RP;
        DS3_contr_RP = interp1(imDescForRCR, DS3_contr_LIST, im_RP, 'pchip')/dv_RCR_RP;
        DS4_contr_RP = interp1(imDescForRCR, DS4_contr_LIST, im_RP, 'pchip')/dv_RCR_RP;

    %     fprintf('At %.f-year-hazard (%.3fg), contribution from DS1- %.f%%, from DS2- %.f%%, from DS3- %.f%%, and from DS4- %.f%%.\n', RP_p, im_RP, ...
    %     DS1_contr_RP*100, DS2_contr_RP*100, DS3_contr_RP*100, DS4_contr_RP*100);
        DS1to4_Contr_in_pc = [DS1_contr_RP, DS2_contr_RP, DS3_contr_RP, DS4_contr_RP]*100;

        MultObjTable = [MultObjTable, table(im_RP, DS1to4_Contr_in_pc)];
        MultObjTable.Properties.VariableNames{end-1} = sprintf('SaT1_%iy', int32(RP_p));
        MultObjTable.Properties.VariableNames{end} = sprintf('DS1to4_Contr_in_pc_%iy', int32(RP_p));
    end
end

disp(MultObjTable)
% toc