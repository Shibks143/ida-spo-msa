clear; tic; % close all;
baseFolder = pwd;

%% (Inputs- 1/2) Building-specific inputs
DS_StoryDriftLIST = [0.005, 0.01, 0.02, 0.04, 0.00]; % DS1, DS2, DS3, DS4 (0.00 indicates sidesway collapse or dynamic instability)
beta_MDL_DR_TD = sqrt(0.35^2 + 0.1^2 + 0.2^2);

plotMeanWithBound = 0;
buildingIDLIST = {'46053'};
figNameSuff = strjoin(buildingIDLIST, '_');   % export-name suffix from the building IDs, e.g. '46053' or '1310v1_FF_1310v1_NF'
% buildingIDLIST = {'1310v1_FF'; '1310v1_NF'; '1610v1_FF'; '1610v1_NF'; '1910v1_FF'; '1910v1_NF'}; figNameSuff = 'allSix_v2_R1';
% legStr = {'3-Story (FF)', '3-Story (NF)', '6-Story (FF)', '6-Story (NF)', '9-Story (FF)', '9-Story (NF)'}; plotStyle = {'k-', 'k--', 'b-', 'b--', 'r-', 'r--'}; 
% buildingIDLIST = {'1310v1_FF'; '1610v1_FF'; '1910v1_FF'};  legStr = {'3-Story', '6-Story', '9-Story'}; plotStyle = {'k-', 'b-', 'r-'}; figNameSuff = 'allFF'; % all far-field
% buildingIDLIST = {'1310v1_NF'; '1610v1_NF'; '1910v1_NF'}; legStr = {'3-Story', '6-Story', '9-Story'}; plotStyle = {'k-', 'b-', 'r-'}; figNameSuff = 'allNF'; % all near-field
% buildingIDLIST = {'1310v1_FF'; '1310v1_NF';}; legStr = {'Far-field', 'Near-field'}; plotStyle = {'k-', 'k--'}; figNameSuff = '3Story'; % 3-storied
% buildingIDLIST = {'1610v1_FF'; '1610v1_NF';}; legStr = {'Far-field', 'Near-field'}; plotStyle = {'k-', 'k--'}; figNameSuff = '6Story'; % 6-storied
% buildingIDLIST = {'1910v1_FF'; '1910v1_NF';}; legStr = {'Far-field', 'Near-field'}; plotStyle = {'k-', 'k--'}; figNameSuff = '9Story'; % 9-storied
% buildingIDLIST = {'1310v1_FF'}; figNameSuff = '1310_FF_withUnc';

doPrint = 1;
saveFigures = 1; % when running for optimal beta, do not saveFigures
dirForFigures = sprintf('figures_repTimeVsSa_%s', 'R1_betaTOT');
% end of user input

for i = 1:size(buildingIDLIST, 1)
    buildingID = buildingIDLIST{i, 1};
    
    %% Defined directory addresses, earthquake IDs
    switch buildingID
        case '46053'
            analysisType = '(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';
            outputRoot   = fullfile(baseFolder, '..', '..', 'Output');   % ida-spo-msa\Output
            numStories = 5; legOn = 1;
            Sa_MCE = 0.27;
            outpFolderLIST = {fullfile(outputRoot, analysisType)};

            % GM suite, record list and T1, read from the IDA/MSA output
            statsFile = dir(fullfile(outpFolderLIST{1}, 'DATA_collapse_CollapseSaAndStats_*_SaGeoMean.mat'));
            if numel(statsFile) ~= 1
                error('Expected one DATA_collapse_CollapseSaAndStats_*_SaGeoMean.mat in %s, found %d', outpFolderLIST{1}, numel(statsFile));
            end
            S = load(fullfile(outpFolderLIST{1}, statsFile.name), 'eqListForCollapseIDAs_Name', 'eqCompNumberLIST', 'periodUsedForScalingGroundMotions');
            GMsuiteName = S.eqListForCollapseIDAs_Name;           % GM suite, e.g. 'GMSetC'
            eqLIST      = S.eqCompNumberLIST;                     % all GM components analysed
            T1forIM     = S.periodUsedForScalingGroundMotions;    % period used to scale the GMs
        case '1310v1_FF'
            numStories = 3;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1310_v.01_FF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
            GMsuiteName = 'GMSetC';
            T1forIM = 0.83;
            statsFile = [];     % no stats-file date for the old buildings: load fragRes if it exists
        case '1310v1_NF'
            numStories = 3;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1310_v.01_NF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
            GMsuiteName = 'GMSetG';
            T1forIM = 0.83;
            statsFile = [];     % no stats-file date for the old buildings: load fragRes if it exists
    end
    
    % end of inputs
    
    %% 1. Range of intensity measure values
    Sa_realizations = 0.01:0.01:2.0;

    %% 2. Import Fragility Data from DamageState folder (valid for arbitrary SaT1 using variable T1forIM)
    bldgNum = str2double(regexp(buildingID, '^\d+', 'match', 'once'));   % leading digits of the building ID
    fileNameToSaveFragData = sprintf('fragRes_%s_%s', buildingID, GMsuiteName);
    cd(fullfile(baseFolder, '..', 'RiskAndARCR'));

    fragInfo = dir([fileNameToSaveFragData '.mat']);
    if ~isempty(fragInfo) && (isempty(statsFile) || fragInfo.datenum > statsFile.datenum)   % fragRes newer than the IDA/MSA results -> reuse it
        load(fileNameToSaveFragData, 'fragParamMuCtrl_mat', 'fragParamBetaCtrl_mat', 'fragParamImMinCtrl_mat');
        meanSa = fragParamMuCtrl_mat;
        sigmaLn = fragParamBetaCtrl_mat;
        imMin = fragParamImMinCtrl_mat;
    else                                                              % missing or older than the IDA/MSA results -> re-extract
        [~, ~, ~, meanSa, sigmaLn, imMin] = extractFragilityForMIDR_v1(bldgNum, outpFolderLIST, DS_StoryDriftLIST, eqLIST, GMsuiteName, T1forIM, fileNameToSaveFragData);
    end

    sigmaLn = sqrt(sigmaLn.^2 + beta_MDL_DR_TD^2);

    cd(baseFolder)

    %% calculating the expected recovery function for each realization of the scenario earthquake
    [meanRepairTime, repairTimeAllData] = fun4meanRepTime_v1(meanSa, sigmaLn, Sa_realizations, numStories);
    
    % figure(1)
    % plot(Sa_realizations, meanRepairTime, plotStyle{i}, 'LineWidth', 1.5); grid on; hold on;
    % figure 1 is misleading (because it plots Sa(T1) for different buildings on the same figure, even though T1 are not the same.
    % figure 2 overcomes this problem by normalizing the Sa(T1) value with Sa_MCE
    
    % I have copied these values from the design table for now.
    % To make the comparison fare, these are Sa_MCE values are for T1 from analysis, i.e., Sa(0.83) etc. (5-story: set in the building case)
    if numStories == 3; Sa_MCE = 0.435; elseif numStories == 6; Sa_MCE = 0.221;
    elseif numStories == 9; Sa_MCE = 0.153; end

    stdev_log = std(log(repairTimeAllData), 0, 1);

    if ~exist(fullfile(baseFolder, dirForFigures), 'dir'); mkdir(fullfile(baseFolder, dirForFigures)); end
    matFileName = fullfile(baseFolder, dirForFigures, sprintf('MeanRepairTime_%s.mat', buildingID));
    save(matFileName, 'Sa_realizations', 'meanRepairTime', 'repairTimeAllData', 'stdev_log', 'Sa_MCE');
end

%% Plots: mean repair time and its dispersion vs Sa(T1)/Sa_MCE (read back from MeanRepairTime_<ID>.mat)
if saveFigures == 1
    plotStyle = {'r-', 'r--', 'b-', 'b--', 'g-', 'g--'};
    h2 = gobjects(1, numel(buildingIDLIST)); h1 = gobjects(1, numel(buildingIDLIST));
    for i = 1:numel(buildingIDLIST)
        load(fullfile(baseFolder, dirForFigures, sprintf('MeanRepairTime_%s.mat', buildingIDLIST{i})), ...
            'Sa_realizations', 'meanRepairTime', 'repairTimeAllData', 'stdev_log', 'Sa_MCE');

        figure(2);
        h2(i) = plot(Sa_realizations/Sa_MCE, meanRepairTime, plotStyle{i}, 'LineWidth', 1.5); grid on; hold on;
        if plotMeanWithBound == 1   % used for single building in the reviewer report
            hBound = plot(Sa_realizations/Sa_MCE, quantile(repairTimeAllData, 0.16, 1), plotStyle{i+1}, 'LineWidth', 1.5);
            plot(Sa_realizations/Sa_MCE, quantile(repairTimeAllData, 0.84, 1), plotStyle{i+1}, 'LineWidth', 1.5);
        end

        figure(3);
        h1(i) = plot(Sa_realizations(2:end)/Sa_MCE, stdev_log(2:end), plotStyle{i}, 'LineWidth', 1.5); grid on; hold on;
    end

    figure(2)
    fprintf('Pay attention to the normalization factors (i.e. Sa_MCE) for different buildings.\n');
    xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex');
    if plotMeanWithBound == 1
        hlegend = legend([h2(end), hBound], {'Mean', '$\pm 1\sigma$'}, 'Location', 'NorthWest');
        ylabel('Repair Time (days)'); set(gca, 'YScale', 'log'); ylim([10 500]); xlim([0.5 3]);
        exportName = sprintf('meanRepairTimeWithBound_%s', figNameSuff);
    else
        hlegend = legend(h2, strrep(buildingIDLIST, '_', '\_'), 'Location', 'NorthWest');   % one entry per building
        ylabel('Mean Repair Time (days)'); ylim([0 400]); xlim([0 3]);
        exportName = sprintf('meanRepairTime_%s', figNameSuff);
    end
    sks_figureFormat('paper');
    hlegend.Location = 'northwest';                     % sks_figureFormat moves legends to northeast
    sks_figureExport(fullfile(baseFolder, dirForFigures, exportName));   % .fig, .eps, .tiff, .emf

    figure(3);
    xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex'); ylabel('$\beta_{\ln,\ \mathrm{Repair\ Time}}$', 'Interpreter', 'latex');
    legend(h1, strrep(buildingIDLIST, '_', '\_'), 'Location', 'NorthEast');   % one entry per building
    xlim([0.001 3]); ylim([0 0.5]);
    sks_figureFormat('paper');

    exportName = sprintf('beta_ln_repairTime_%s', figNameSuff);
    sks_figureExport(fullfile(baseFolder, dirForFigures, exportName));   
end

cd(baseFolder)

toc