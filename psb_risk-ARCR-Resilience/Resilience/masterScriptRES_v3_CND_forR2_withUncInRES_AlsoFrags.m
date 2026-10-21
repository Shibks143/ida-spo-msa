clear; tic; % close all; 
close all;
baseFolder = pwd;

figure(786); t = tiledlayout(1, 3, 'TileSpacing','compact'); 
set(gcf, 'Position', [50 200 1500 460]);
beta_MDL_DR_TD = sqrt(0.35^2 + 0.1^2 + 0.2^2);

%% (Inputs- 1/2) Building-specific inputs
DS_StoryDriftLIST = [0.005, 0.01, 0.02, 0.04, 0.00]; % DS1, DS2, DS3, DS4 (0.00 indicates sidesway collapse or dynamic instability)

buildingIDLIST = {'1310v1_NF'; '1310v1_FF'; '1610v1_NF'; '1610v1_FF'; '1910v1_NF'; '1910v1_FF'}; % legStr = {'3-Story (FF)', '3-Story (NF)', '6-Story (FF)', '6-Story (NF)', '9-Story (FF)', '9-Story (NF)'}; plotStyle = {'k-', 'k--', 'b-', 'b--', 'r-', 'r--'}; figNameSuff = 'allSix';

% buildingID = '1310v1_FF'; legOn = 1; close all; 
% buildingID = '1310v1_NF'; legOn = 0; try close (102); catch; end
% buildingID = '1610v1_FF'; legOn = 0; close all; 
% buildingID = '1610v1_NF'; legOn = 0; try close(101); catch; end; try close (102); catch; end
% buildingID = '1910v1_FF'; legOn = 0; close all; 
% buildingID = '1910v1_NF'; legOn = 0; try close(101); catch; end; try close (102); catch; end

doPrint = 1;
%% (Inputs- 2/2) Scenario/GMM inputs
% Generate random spectral accelerations for a scenario earthquake
M = 7.3;
Rjb = 30; % Joyner-Boore distance in km
% T1forIM = 1.68; 
N1 = 1e4; % realizations of spectral acceleration.
% GMPM = 'BA08'; % Boore Atkinson (2008) NGA
GMPM = 'BSSA14'; % Boore et al (2014) NGA (NRCan gives 0.25 weight to each of ASK14, BSSA14, CB14, CY14 for SWCan)
saveFigures = 1; % when running for optimal beta, do not saveFigures
dirForFigures = sprintf('figures_resCombined_M%g_R%g_R2_RESUnc', M, Rjb);
% end of user input

for i = 1:size(buildingIDLIST, 1)
    buildingID = buildingIDLIST{i, 1};

%% Defined directory addresses, earthquake IDs
    switch buildingID
        case '1310v1_FF'
            numStories = 3; legOn = 1;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1310_v.01_FF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
            GMsuiteName = 'GMSetC';
            T1forIM = 0.83;
        case '1310v1_NF'
            numStories = 3; legOn = 0;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1310_v.01_NF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
            GMsuiteName = 'GMSetG';
            T1forIM = 0.83;
        case '1610v1_FF'
            numStories = 6; legOn = 0;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1610_v.01_FF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
            GMsuiteName = 'GMSetC';
            T1forIM = 1.68;
        case '1610v1_NF'
            numStories = 6; legOn = 0;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1610_v.01_NF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
            GMsuiteName = 'GMSetG';
            T1forIM = 1.68;
        case '1910v1_FF'
            numStories = 9; legOn = 0;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1910_v.01_FF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
            GMsuiteName = 'GMSetC';
            T1forIM = 2.41;
        case '1910v1_NF'
            numStories = 9; legOn = 0;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1910_v.01_NF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
            GMsuiteName = 'GMSetG';
            T1forIM = 2.41;
    end

if numStories == 3; Sa_MCE = 0.435; elseif numStories == 6; Sa_MCE = 0.221;
elseif numStories == 9; Sa_MCE = 0.153; end

% Boore Atkinson (2008) NGA
Fault_Type    = 3; % 1 for unspecified fault; 2 for strike-slip fault; 3 for normal fault; 4 for reverse fault
% [Sa, sigma, period1] = BA_2008_nga (M, T, Rjb, Fault_Type, Vs30)
[Sa_T1_BA08, sigma_T1_BA08, ~] = BA_2008_nga(M, T1forIM, Rjb, Fault_Type, 450);

Fault_Type    = 2; % 0 for unspecified fault, 1 for strike-slip fault, 2 for normal fault, 3 for reverse fault
% [median, sigma, period1] = BSSA_2014_nga(M, T, Rjb, Fault_Type, region, z1, Vs30);
[Sa_T1_BSSA14 , sigma_T1_BSSA14, ~] = BSSA_2014_nga(M, T1forIM, Rjb, Fault_Type, 0, 999, 450);

% [Sa_T1_ASK14 , sigma_T1_ASK14 ] = ASK_2014_nga(M, Rjb, period) ;
% [Sa_T1_CB14  , sigma_T1_CB14  ] = CB_2014_nga(M, Rjb, period)  ;
% [Sa_T1_CY14  , sigma_T1_CY14  ] = CY_2014_nga(M, Rjb, period)  ;

% end of inputs

%% 1. generate 10,000 realizations of intensity measure (e.g., SaT1)
rng(3, 'twister')
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
% Sa_realizations = 0.25;

%% 2. Import Fragility Data from DamageState folder (valid for arbitrary SaT1 using variable T1forIM)
cd(baseFolder);
bldgNum = int32(str2double(buildingID(1:4))); % number
fileNameToSaveFragData = sprintf('fragRes_%s_%s', buildingID, GMsuiteName);
cd ..; cd('RiskAndARCR')
try 
    load(fileNameToSaveFragData, 'fragParamMuCtrl_mat', 'fragParamBetaCtrl_mat', 'fragParamImMinCtrl_mat');
    meanSa = fragParamMuCtrl_mat;
    sigmaLn = fragParamBetaCtrl_mat;
    imMin = fragParamImMinCtrl_mat;
catch 
    [~, ~, ~, meanSa, sigmaLn, imMin] = extractFragilityForMIDR_v1(bldgNum, outpFolderLIST, DS_StoryDriftLIST, eqLIST, GMsuiteName, T1forIM, fileNameToSaveFragData);
end

sigmaLn = sqrt(sigmaLn.^2 + beta_MDL_DR_TD^2);

cd(baseFolder)

%% calculating the expected recovery function for each realization of the scenario earthquake
if strcmp(GMsuiteName, 'GMSetC')
    plotStyle = {'r-', 'b-', 'g-', 'c-', 'm-'};
elseif strcmp(GMsuiteName, 'GMSetG')
    plotStyle = {'r--', 'b--', 'g--', 'c--', 'm--'};
end
[timeArray, expectedHousingFunction, meanExpectedHousingFunction, meanHousingCapacityMatrix] = fun3expctedRecovery_v1(meanSa, sigmaLn, Sa_realizations, numStories);
sigmaHouse = std(expectedHousingFunction, 0, 1);
sigmaLnHouse = std(log(expectedHousingFunction), 0, 1);

% figure(800 + floor((i+1)/2));
% plot(timeArray, sigmaHouse, 'r-', timeArray, sigmaLnHouse, 'b-'); xlim([1 200]); ylim([0 0.5]);

if saveFigures == 1
%% 2a. formatting the fragility curves for saving (ploted under fun3)
    minValue = 0; maxValue = 5.0;
    figure(100 + floor((i+1)/2));
    for LS = 1:5 %
        h1(LS) = PlotLogNormalCDF_current(log(meanSa(LS)/Sa_MCE), sigmaLn(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
    end

    if legOn == 1
        h1(6) = plot(4, 1, 'k-', 'LineWidth', 1.5); h1(7) = plot(4, 1, 'k--', 'LineWidth', 1.5); % dummy plots outside the range
        hlegend = legend([h1], {'LS_1', 'LS_2', 'LS_3', 'LS_4', 'LS_5', 'FF', 'NF'}, 'Location', 'NorthEast');
    end

    xlim([minValue, maxValue]);
    str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; hx = xlabel(str1, 'Interpreter', 'latex');
    if floor((i+1)/2) == 1 % y-axis label only for first figure
        hy = ylabel(str2, 'Interpreter', 'latex');
    end
    psb_FigureFormatScript_paper_3figsInOneRow
    
    cd(baseFolder);  
    if ~exist(dirForFigures, 'dir'); mkdir(dirForFigures); end
    cd(dirForFigures);
    strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
    exportName = sprintf('%s_Frag_%s', buildingID, strForIM);
    hgsave(exportName); % .fig file for Matlab
    print('-depsc', exportName); % .eps file for Linux (LaTeX)
    print('-dmeta', exportName); % .emf file for Windows (MSWORD)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% start of the block for single figure with three fragiities and legend at top-outside
%%%% (CND_paper R1)

cd(baseFolder);
%% 2x. formatting the fragility curves for saving (ploted under fun3)
    minValue = 0; maxValue = 5;
    figure(786); nexttile(floor((i+1)/2));
    for LS = 1:5 %
        h1(LS) = PlotLogNormalCDF_current(log(meanSa(LS)/Sa_MCE), sigmaLn(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
        xticks(1:5); % yticks(0:0.2:1);
    end

%     if legOn == 1
%         h1(6) = plot(4, 1, 'k-', 'LineWidth', 1.5); h1(7) = plot(4, 1, 'k--', 'LineWidth', 1.5); % dummy plots outside the range
%         hlegend = legend([h1], {'LS_1', 'LS_2', 'LS_3', 'LS_4', 'LS_5', 'FF', 'NF'}, 'Location', 'NorthEast');
%     end

    xlim([minValue, maxValue]);
    str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; hx = xlabel(str1, 'Interpreter', 'latex');
    if i == 1 % y-axis label only for first building
        hy = ylabel(str2, 'Interpreter', 'latex');
    end
    psb_FigureFormatScript_paper_3figsInOneRow
    
%%%% end of the block for single figure with three fragiities and legend at top-outside
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2b. formatting the recovery curves for saving (ploted under fun3)
    figure(200 + floor((i+1)/2));
    for LS = 1:5 %
        h2(LS) = plot(timeArray, meanHousingCapacityMatrix(LS+1, :), plotStyle{LS}, 'LineWidth', 1.5); hold on; grid on;
    end

    if legOn == 1
%         hlegend = legend([h2], {'LS_1', 'LS_2', 'LS_3', 'LS_4', 'LS_5'}, 'Location', 'SouthEast');
        hlegend = legend([h2], {'DS_1', 'DS_2', 'DS_3', 'DS_4', 'DS_5'}, 'Location', 'SouthEast'); % R2
    end

    xlim([0 700]);
%     str1 = 'Time (days)'; str2 = 'Normalized Occupancy, q(t)|LS_i'; hx = xlabel(str1); hy = ylabel(str2);
    str1 = 'Time (days)'; str2 = 'Normalized Occupancy, q(t)|DS_i'; hx = xlabel(str1); hy = ylabel(str2); % R2
    psb_FigureFormatScript_paper
    
    cd(baseFolder);  cd(dirForFigures);
    exportName = sprintf('%s_RecFun_M%ip%i_R%i_%s_%s', buildingID, floor(M), int8(mod(M*10, 10)), Rjb, GMPM, strForIM);
    hgsave(exportName); % .fig file for Matlab
    print('-depsc', exportName); % .eps file for Linux (LaTeX)
    print('-dmeta', exportName); % .emf file for Windows (MSWORD)

figure(401)
    colorList = {'r', 'b', 'g', 'c', 'm'}; % limit state specific 
    lineStyleList = {'-', '--', '-.'}; % building specific
    for LS = 1:5
        plot(timeArray, meanHousingCapacityMatrix(LS+1, :), [colorList{LS} lineStyleList{floor((i+1)/2)}], 'LineWidth', 1.5); hold on; grid on;
    end

    if i == size(buildingIDLIST, 1) && LS == 5
        h2(1) = plot(-1, 0, [colorList{1} lineStyleList{1}], 'LineWidth', 1.5);        h2(2) = plot(-1, 0, [colorList{2} lineStyleList{1}], 'LineWidth', 1.5);
        h2(3) = plot(-1, 0, [colorList{3} lineStyleList{1}], 'LineWidth', 1.5);        h2(4) = plot(-1, 0, [colorList{4} lineStyleList{1}], 'LineWidth', 1.5);
        h2(5) = plot(-1, 0, [colorList{5} lineStyleList{1}], 'LineWidth', 1.5);        
        h2(6) = plot(-1, 0, ['k' lineStyleList{1}], 'LineWidth', 1.5);
        h2(7) = plot(-1, 0, ['k' lineStyleList{2}], 'LineWidth', 1.5);        h2(8) = plot(-1, 0, ['k' lineStyleList{3}], 'LineWidth', 1.5);

%         legh = legend(h2, {'LS_1 ', 'LS_2 ', 'LS_3 ', 'LS_4 ', 'LS_5', '3-Story', '6-Story', '9-Story'}, 'Location', 'North', 'Interpreter', 'tex');
%         legh = legend(h2(1:5), {'LS_1 ', 'LS_2 ', 'LS_3 ', 'LS_4 ', 'LS_5'}, 'Location', 'North', 'Interpreter', 'tex');
        legh = legend(h2(1:5), {'DS_1 ', 'DS_2 ', 'DS_3 ', 'DS_4 ', 'DS_5'}, 'Location', 'North', 'Interpreter', 'tex'); % R2
        legh.NumColumns = 1; legh.Orientation = 'vertical'; legh.Location = 'eastoutside';
        % Figures with too many details need to be enlarged before saving
        set(gcf, 'Units', 'pixels', 'Position', [560,528,650,420]); % Enlarge figure. x0-y0-delX-delY
        set(gca, 'Units', 'pixels', 'Position', [73.8, 59.93,434,329.57]); % Enlarge axis. x0-y0-delX-delY
        
        xlim([0 700]);
        str1 = 'Time (days)'; str2 = 'Normalized Occupancy, q(t)|DS_i'; hx = xlabel(str1); hy = ylabel(str2);
        psb_FigureFormatScript_paper

        cd(baseFolder);  cd(dirForFigures);
        exportName = sprintf('RecFunCombined_M%ip%i_R%i_%s_R2', floor(M), int8(mod(M*10, 10)), Rjb, GMPM);
        hgsave(exportName); % .fig file for Matlab
        print('-depsc', exportName); % .eps file for Linux (LaTeX)
        print('-dmeta', exportName); % .emf file for Windows (MSWORD)
    end


%% 2c. formatting the recovery trajectory for saving (ploted under fun3)
%     figure(300 + floor((i+1)/2));
    figure(301);
    if strcmp(GMsuiteName, 'GMSetC')
        plotStyleRec = {'r-', 'b-', 'g-'};
    elseif strcmp(GMsuiteName, 'GMSetG')
        plotStyleRec = {'r--', 'b--', 'g--'};
    end

    % arrays to plot the pre-earthquake occupancy
    h3(6) = plot(timeArray, meanExpectedHousingFunction, plotStyleRec{floor((i+1)/2)}, 'LineWidth', 1.5); hold on; grid on;
    
    A = [-100 0 0]; B = [1 1 meanExpectedHousingFunction(1, 1)]; 
    h3(7) = plot(A, B, 'k-', 'LineWidth', 1.5); 
    set(gca, 'XTick', 0:50:200);
    xlim([-50 200]); ylim([0 1.1]);
    
    if i == size(buildingIDLIST, 1) % add dummy legends in the last plot
    % dummy plots outside the range
        h3(1) = plot(2000, 1, plotStyleRec{1}, 'LineWidth', 1.5); h3(2) = plot(2000, 1, plotStyleRec{2}, 'LineWidth', 1.5);
        h3(3) = plot(2000, 1, plotStyleRec{3} , 'LineWidth', 1.5);

        h3(4) = plot(2000, 1, 'k-', 'LineWidth', 1.5); h3(5) = plot(2000, 1, 'k--', 'LineWidth', 1.5);
%         hlegend = legend(h3(1:5), {'3-Story', '6-Story', '9-Story', 'FF', 'NF'}, 'Location', 'SouthEast');
        hlegend = legend(h3(1:3), {'3-Story', '6-Story', '9-Story'}, 'Location', 'SouthEast');

    end
    str1 = 'Time (days)'; str2 = 'Normalized Occupancy, Q(t)'; hx = xlabel(str1); hy = ylabel(str2);
    psb_FigureFormatScript_paper
    clearvars hx hy;
    
    cd(baseFolder);  cd(dirForFigures);
    exportName = sprintf('RecCur_Combined_M%ip%i_R%i_%s_R1', floor(M), int8(mod(M*10, 10)), Rjb, GMPM);
    extensions = {'fig', 'epsc', 'meta'};
    for k = 1:length(extensions)
	    saveas(gcf, exportName, extensions{k});
    end
end


% (psb, 10-14-22 R2) plotting uncertainty in RESILIENCE. I am using normal distribution parameters and reporting only the standard deviation 
% in the data. Note that using lognormal here does not make sense, becase the parameter of interest is time versus the housing capacity.

if saveFigures == 1 % plotting uncertainty in Resilience here (for R2 in Spectra)
%% 2a. formatting the fragility curves for saving (ploted under fun3)

    if strcmp(GMsuiteName, 'GMSetC')
        plotStyleRec = {'r-', 'b-', 'g-'};
    elseif strcmp(GMsuiteName, 'GMSetG')
        plotStyleRec = {'r--', 'b--', 'g--'};
    end

    figure(302);
    h4(i) = plot(timeArray, sigmaHouse, plotStyleRec{floor((i+1)/2)}, 'LineWidth', 1.5); hold on; grid on;

    set(gca, 'XTick', 0:50:200); xlim([0 200]); ylim([0 0.5]);
    
    if i == size(buildingIDLIST, 1) % add dummy legends in the last plot
        hlegend = legend(h4(2:2:6), {'3-Story', '6-Story', '9-Story'}, 'Location', 'NorthEast');
    end
    str1 = 'Time (days)'; str2 = 'Uncertainty, \sigma_{Q(t)}'; hx = xlabel(str1); hy = ylabel(str2);
    psb_FigureFormatScript_paper
    clearvars hx hy;
    
    cd(baseFolder);  cd(dirForFigures);
    exportName = sprintf('RecCur_Combined_M%ip%i_R%i_%s_Uncertainty_R2', floor(M), int8(mod(M*10, 10)), Rjb, GMPM);
    extensions = {'fig', 'epsc', 'meta'};
    for k = 1:length(extensions)
	    saveas(gcf, exportName, extensions{k});
    end
end


%% 3. Days to recover certain percentages
% pc = 50:5:95; 
pc = [75, 80, 90, 95, 99]; % percent recovery. Find out days to recover to 90% of the original housing capacity.
% maximumHousingCapacity = 65; %max(meanExpectedHousingFunction);
maximumHousingCapacity = 1;

for i = 1:length(pc)
    currentPc = pc(i);
%     daysForRecovery = interp1(meanExpectedHousingFunction, timeArray, currentPc/100 * maximumHousingCapacity, 'pchip');

    X = meanExpectedHousingFunction; Y = timeArray;
    xq = currentPc/100 * maximumHousingCapacity;
    
    ix = find(X >= xq, 1);
    daysForRecovery = interp1([X(ix-1), X(ix)], ...
        [Y(ix-1), Y(ix)], xq, 'pchip');

    fprintf('Days required to recover %i%% of the housing capacity- %i. \n', currentPc, round(daysForRecovery));
end

%% Calculations for robustness/rapidity/resilience
robustness = meanExpectedHousingFunction(1);
rapidity_daysLIST = [30, 180, 365, 545, 730];
QtAfterDaysLIST = interp1(timeArray, meanExpectedHousingFunction, rapidity_daysLIST, 'pchip');
rapidity_average_afterDays = (QtAfterDaysLIST - robustness) ./(rapidity_daysLIST/365);
for i = 1:length(rapidity_daysLIST)
    t0_plus_th = rapidity_daysLIST(i);
    timeArrayForInteg = [timeArray(timeArray < t0_plus_th), t0_plus_th];
    housingForInteg = [meanExpectedHousingFunction(timeArray < t0_plus_th), QtAfterDaysLIST(i)];
    ReselienceAfterDays(i) = trapz(timeArrayForInteg, housingForInteg)/t0_plus_th;
end

cd(baseFolder); cd(dirForFigures); rawDataMat = sprintf('ResData_raw_%s.mat', buildingID);
save(rawDataMat);
fprintf('Mat file for resilience saved in %s.\n', pwd);
cd(baseFolder); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% start of block for saving the combined fragility figure with three fragiities and legend at top-outside
    figure(786);

    legTxt = {'$LS_1 \qquad$', '$LS_2 \qquad$', '$LS_3 \qquad$', '$LS_4 \qquad$', '$LS_5\,\,$'};
    legh = legend(h1(1:5), legTxt, 'Orientation', 'Horizontal', 'Interpreter','latex');
    legh.Layout.Tile = 'north';

    psb_FigureFormatScript_paper_3figsInOneRow;

% I am now adding the subfigures captions here. LaTeX cannot do this because I am drawing one figure for three subfigures
    text(-0.4, -0.2, '(c)', 'FontWeight','bold', 'FontSize', 16); % last tile is active, hence axis system follows that.
    text(-6.23, -0.2, '(b)', 'FontWeight','bold', 'FontSize', 16);
    text(-12.06, -0.2, '(a)', 'FontWeight','bold', 'FontSize', 16);

    cd(baseFolder);  if ~exist(dirForFigures, 'dir'); mkdir(dirForFigures); end
    cd(dirForFigures);
    exportName = sprintf('combined_Frag_%s', 'R2');

    extensions = {'fig', 'epsc', 'meta'};
    for k = 1:length(extensions)
	    saveas(gcf, exportName, extensions{k})
    end
%%%% end of block for saving the combined fragility figure with three fragiities and legend at top-outside
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(baseFolder);
toc