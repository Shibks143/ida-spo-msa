
clear; close all; tic

%% Sample inputs
IdToAnalyze = '1610v01'; % In an ideal world, I'd like to interconnect 
                         % (a) Pick developed building's model based on Id.
                         % (b) Carry out NRCan's OpenQuake hazard analysis based on lon-lat and building ID (T1 or whatever we are using).
                         % (c) GM selection based on (b)
                         % (d) OpenSees IDA based on (c) and (a)
                         % (e) Post-process to get fragility, risk, and then resilience. 

T1forIM = 1.68; % Sa(T1) used as IM
% T1forIM = 99; % 99 meaning SaT1 = SaTa, 0 means PGA
imString = 'SA(1.68)'; % not defining based on T1. OpenQuake accepts both, SA(2) or SA(2.0)

% hazDirName = '..\NRCan_Van_Sa1p68_Haz'; 
hazDirName = '..\NRCan_Vic_Sa1p68_Haz'; 
outpFolderLIST = {'C:\ResilAnaOS_psb\Output\(ID1610_v.01_FF)_(AllVar)_(0.00)_(clough)';};
DS_StoryDriftLIST = [0.01, 0.02, 0.04, 0.00]; % DS1, DS2, DS3, DS4 (0.00 indicates sidesway collapse or dynamic instability)
consqModel = [2, 10, 40.4, 100]; % DS1, DS2, DS3, and DS4; repair cost ratio (% of building repair cost) (COM4 from HAZUS 2003)

imOrAfeBound = 1; % no bound (=0); bound over IM (= 1); bound over AFE (= 2)
boundRangeInp = [99, 4.0]; % lower and upper bound; 99 as lower bound indicates imMin from analysis to be considered

verbose = 1; % for debugging, set this to 2; this will just print more intermediate results 
factorOnImMin = 1; % optional variable that reduces the imMin value

saveFigures = 1; % when running for optimal beta, do not saveFigures
% dirForFigures = 'figures_1610_FF_Van';
dirForFigures = 'figures_1610_FF_Vic';

% end of inputs

%%  Assign precise BldgID, eqLIST, Ta
switch IdToAnalyze 
    case '1610v01'
        BldgId = '1610v01';
        GMsuiteName = 'GMSetC'; 
        eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
        
%         lonLat = [-123.12 49.25]; % lon first the lat (Vancouver) (source- NRCan)
%         locName = 'Vancouver';
        lonLat = [-123.37 48.43]; % lon first the lat (Vancouver) (source- NRCan)
        locName = 'Victoria';
        Ta = 0.76; 
end

if T1forIM == 99
    T1forIM = Ta;
end

%% fixed inputs (do NOT carry these as function arguments)
doPlotHaz = 0;
plotType = 'loglog'; % 'semilog', 'loglog, 'linear'
locationLegForPlot = [];

%% 0. calculations begin
baseFolder = pwd;

%% 1a. Import Hazard 
[imValLIST, poeVals] = extractHazCurves_fun_v1(hazDirName, lonLat, imString);

% discretize hazard curve 
imValDisc = 0:0.01:4;
afeDisc = interp1(imValLIST, poeVals, imValDisc, 'pchip');
% imValDisc = imValLIST; afeDisc = poeVals;
hazardDataCurr = [imValLIST; poeVals];

if T1forIM == 0; imStringForPlot = 'PGA (g)'; 
else; imStringForPlot = sprintf('%s (g)', imString); end

loglog(imValLIST, poeVals, 'b-', 'LineWidth', 2); grid on; hold on;
xlabel(imStringForPlot);  ylabel('Annual Frequency of Exceedance');
sks_figureFormat('report');

if saveFigures == 1
    cd(baseFolder);  cd(dirForFigures);
    strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
    exportNamehaz = sprintf('Haz_%s_%s_%s', BldgId, locName, strForIM);
    sks_figureExport(exportNamehaz);   % .fig, .eps, .pdf, .png, .tiff, .emf
    cd ..
end
    
%% 1b. Import Fragility Data from DamageState folder (valid for arbitrary SaT1 using variable T1forIM)
cd(baseFolder);
bldgNum = int32(str2double(IdToAnalyze(1:4))); % number
fileNameToSaveFragData = sprintf('frag_%s_%s', IdToAnalyze, GMsuiteName);
[~, ~, ~, muDS, betaRTR, imMin] = extractFragilityForMIDR_v1(bldgNum, outpFolderLIST, DS_StoryDriftLIST, eqLIST, GMsuiteName, T1forIM, fileNameToSaveFragData);

% 0a. Assign directory locations, datafile names, and beta values for fragiliy
    betaDR = 0.20; % (6-6-19, PSB) SMRF- design requirements. 'Good' for SMRF (see Sec 6.2 of Denavit et al., 2016)
    betaMDL = 0.20; % (6-6-19, PSB) modeling; good; index model capturing full range of archetype design space
    
    betaTD_DS1 = 0.10; % superior rating of test data for lower damage states
    betaTD_DS2 = 0.10; % superior rating of test data for lower damage states
    betaTD_DS3 = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
    betaTD_DS4 = 0.20; % Good rating of test data (Sec 9.2.3 of FEMA P695)
        
    mu_DS1 = muDS(1, 1); betaRTR_DS1 = betaRTR(1, 1); imMin_DS1 = imMin(1, 1);
    mu_DS2 = muDS(1, 2); betaRTR_DS2 = betaRTR(1, 2); imMin_DS2 = imMin(1, 2);
    mu_DS3 = muDS(1, 3); betaRTR_DS3 = betaRTR(1, 3); imMin_DS3 = imMin(1, 3);
    mu_DS4 = muDS(1, 4); betaRTR_DS4 = betaRTR(1, 4); imMin_DS4 = imMin(1, 4);
    
    betaTOT_DS1 = sqrt(betaRTR_DS1^2 + betaMDL^2 + betaDR^2 + betaTD_DS1^2); 
    betaTOT_DS2 = sqrt(betaRTR_DS2^2 + betaMDL^2 + betaDR^2 + betaTD_DS2^2);
    betaTOT_DS3 = sqrt(betaRTR_DS3^2 + betaMDL^2 + betaDR^2 + betaTD_DS3^2); 
    betaTOT_DS4 = sqrt(betaRTR_DS4^2 + betaMDL^2 + betaDR^2 + betaTD_DS4^2); 
    
%% 1c. plot and save fragility 
    figure; imDescForFrag = 0:0.01:4;
    plot(imDescForFrag, normcdf(log(imDescForFrag), log(mu_DS1), betaTOT_DS1), '--', 'Color', [0.00 0.00 1.00], 'LineWidth', 1.5); hold on; grid on;
    plot(imDescForFrag, normcdf(log(imDescForFrag), log(mu_DS2), betaTOT_DS2), '-.', 'Color', [1.00 0.00 1.00], 'LineWidth', 1.5);
    plot(imDescForFrag, normcdf(log(imDescForFrag), log(mu_DS3), betaTOT_DS3), ':', 'Color', [0.00 0.00 0.00], 'LineWidth', 1.5);
    plot(imDescForFrag, normcdf(log(imDescForFrag), log(mu_DS4), betaTOT_DS4), '-', 'Color', [1.00 0.00 0.00], 'LineWidth', 1.5);
    
    legend('DS1', 'DS2', 'DS3', 'DS4');
    xlabel(imStringForPlot); ylabel('$P_{ds}$');
    xlim([0 2.0]); ylim([0 1]);
    sks_figureFormat('report');

    if saveFigures == 1
        cd(baseFolder);  cd(dirForFigures);
        strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
        exportNameFrag = sprintf('fragility_%s_%s_%s', BldgId, locName, strForIM);
        sks_figureExport(exportNameFrag);   % .fig, .eps, .pdf, .png, .tiff, .emf
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
    
    imDescForRCR = 0.01:0.01:4;
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
        
        dv_RCR1(counter) = (P_DS4_only * consq_DS4 + P_DS3_only * consq_DS3 + ...
                         P_DS2_only * consq_DS2 + P_DS1_only * consq_DS1)/100;

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
    
    plot(imDescForRCR, dv_RCR, '-', 'Color', [0.50 0.50 0.50], 'LineWidth', 1.5); hold on; grid on;
    plot(imDescForRCR, DS1_contr_LIST, '--', 'Color', [0.00 0.00 1.00], 'LineWidth', 1.5);
    plot(imDescForRCR, DS2_contr_LIST, '-.', 'Color', [1.00 0.00 1.00], 'LineWidth', 1.5);
    plot(imDescForRCR, DS3_contr_LIST, ':', 'Color', [0.00 0.00 0.00], 'LineWidth', 1.5);
    plot(imDescForRCR, DS4_contr_LIST, '-', 'Color', [1.00 0.00 0.00], 'LineWidth', 1.5);
%     plot(imDescForRCR, DS4_contr_LIST, 'color', [0.5, 0.5, 0.5], 'linestyle', '--', 'LineWidth', 1.5);
    
    hlegend = legend('Total', 'DS1 contribution', 'DS2 contribution', 'DS3 contribution', 'DS4 contribution');
    if T1forIM == 0; xlabel('PGA (g)');  else xlabel(sprintf('Sa(%.2f) (g)', T1forIM)); end
    ylabel('Repair Cost Ratio');
    xlim([0 0.9]); ylim([0 0.15]);
    sks_figureFormat('report');
    hlegend.Location = 'northwest';   % sks_figureFormat moves legends to northeast

    if saveFigures == 1
        cd(baseFolder);  cd(dirForFigures);
        strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
        exportNameRCR = sprintf('RCR_%s_%s_%s', BldgId, locName, strForIM);
        sks_figureExport(exportNameRCR);   % .fig, .eps, .pdf, .png, .tiff, .emf
        cd ..
    end
    
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

    lambda_RCR1 = trapz(imDescForRCR, lambda_RCR_integrand1);
    lambda_RCR2 = trapz(imDescForRCR, lambda_RCR_integrand2);
    % fprintf('lambda_RCR using two expressions are %g and %g.\n', lambda_RCR1, lambda_RCR2);

    figure
    % plot(imDescForRCR, lambda_RCR_integrand1, 'b--', 'LineWidth', 1.5); hold on; grid on; box on;
    plot(imDescForRCR, lambda_RCR_integrand2, 'k-', 'LineWidth', 1.5); hold on; grid on; box on;
    % theoretically, we condition the vulnerability over hazard, hence the slope of vulnerability is preferred (also, it's intergrand is smoother)

    if T1forIM == 0; xlabel('PGA (g)');  else xlabel(sprintf('Sa(%.2f) (g)', T1forIM)); end
    ylabel('Mean RCR Integrand');
    xlim([0 1]); % ylim([0 1]);
    sks_figureFormat('report');

    if saveFigures == 1
        cd(baseFolder);  cd(dirForFigures);
        strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
        exportNameRCR = sprintf('ARCRIntegrand_%s_%s_%s', BldgId, locName, strForIM);
        sks_figureExport(exportNameRCR);   % .fig, .eps, .pdf, .png, .tiff, .emf
        cd ..
    end
   
    MultObjTable = [MultObjTable, table(lambda_RCR2)];
    MultObjTable.Properties.VariableNames{end} = 'lambda_RCR';
    

disp(MultObjTable)
toc