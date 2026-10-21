clear; tic; % close all;
baseFolder = pwd;

%% (Inputs- 1/2) Building-specific inputs
DS_StoryDriftLIST = [0.005, 0.01, 0.02, 0.04, 0.00]; % DS1, DS2, DS3, DS4 (0.00 indicates sidesway collapse or dynamic instability)
beta_MDL_DR_TD = sqrt(0.35^2 + 0.1^2 + 0.2^2);

plotMeanWithBound = 0;

buildingIDLIST = {'1310v1_FF'; '1310v1_NF'; '1610v1_FF'; '1610v1_NF'; '1910v1_FF'; '1910v1_NF'}; figNameSuff = 'allSix_v2_R1';
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
        case '1310v1_FF'
            numStories = 3;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1310_v.01_FF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
            GMsuiteName = 'GMSetC';
            T1forIM = 0.83;
        case '1310v1_NF'
            numStories = 3;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1310_v.01_NF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
            GMsuiteName = 'GMSetG';
            T1forIM = 0.83;
        case '1610v1_FF'
            numStories = 6;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1610_v.01_FF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
            GMsuiteName = 'GMSetC';
            T1forIM = 1.68;
        case '1610v1_NF'
            numStories = 6;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1610_v.01_NF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
            GMsuiteName = 'GMSetG';
            T1forIM = 1.68;
        case '1910v1_FF'
            numStories = 9;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1910_v.01_FF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [120111, 120112, 120121, 120122,	120411, 120412,	120521, 120522,	120611, 120612,	120621, 120622,	120711, 120712,	120721, 120722,	120811, 120812,	120821, 120822,	120911, 120912,	120921, 120922,	121011, 121012,	121021, 121022,	121111, 121112,	121211, 121212,	121221, 121222,	121321, 121322,	121411, 121412,	121421, 121422,	121511, 121512,	121711, 121712];
            GMsuiteName = 'GMSetC';
            T1forIM = 2.41;
        case '1910v1_NF'
            numStories = 9;
            outpFolderLIST = {'E:\prak\ResilAnaOS_psb\Output\(ID1910_v.01_NF)_(AllVar)_(0.00)_(clough)';};
            eqLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];
            GMsuiteName = 'GMSetG';
            T1forIM = 2.41;
    end
    
    % end of inputs
    
    %% 1. Range of intensity measure values
    Sa_realizations = 0.01:0.01:2.0;

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
    [meanRepairTime, repairTimeAllData] = fun4meanRepTime_v1(meanSa, sigmaLn, Sa_realizations, numStories);
    
    % figure(1)
    % plot(Sa_realizations, meanRepairTime, plotStyle{i}, 'LineWidth', 1.5); grid on; hold on;
    % figure 1 is misleading (because it plots Sa(T1) for different buildings on the same figure, even though T1 are not the same.
    % figure 2 overcomes this problem by normalizing the Sa(T1) value with Sa_MCE
    
    % I have copied these values from the design table for now.
    % To make the comparison fare, these are Sa_MCE values are for T1 from analysis, i.e., Sa(0.83) etc.
    if numStories == 3; Sa_MCE = 0.435; elseif numStories == 6; Sa_MCE = 0.221;
    elseif numStories == 9; Sa_MCE = 0.153; end
    figure(2)
    plotStyle = {'r-', 'r--', 'b-', 'b--', 'g-', 'g--'}; 
    plot(Sa_realizations/Sa_MCE, meanRepairTime, plotStyle{i}, 'LineWidth', 1.5); grid on; hold on;
    
    if plotMeanWithBound == 1 % used for singe building in the reviewer report
        plot(Sa_realizations/Sa_MCE, quantile(repairTimeAllData, 0.16, 1), plotStyle{i+1}, 'LineWidth', 1.5); grid on; hold on;
        plot(Sa_realizations/Sa_MCE, quantile(repairTimeAllData, 0.84, 1), plotStyle{i+1}, 'LineWidth', 1.5); grid on; hold on;
        hlegend = legend(h(1:2), {'Mean', '\pm 1\sigma'}, 'Location', 'NorthWest');
        hx = xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex'); hy = ylabel('Repair Time (days)');
        set(gca, 'YScale', 'log'); ylim([10 500]); xlim([0.5 3]);
        exportName = sprintf('meanRepairTimeWithBound_%s', figNameSuff);
    else
        % dummy plots outside the range
        h(1) = plot(-1, 0, plotStyle{1}, 'LineWidth', 1.5); h(2) = plot(-1, 0, plotStyle{3}, 'LineWidth', 1.5);
        h(3) = plot(-1, 0, plotStyle{5} , 'LineWidth', 1.5);
        h(4) = plot(-1, 0, 'k-', 'LineWidth', 1.5); h(5) = plot(-1, 1, 'k--', 'LineWidth', 1.5);
    %     hlegend = legend(h(1:5), {'3-Story', '6-Story', '9-Story', 'FF', 'NF'}, 'Location', 'NorthWest');
        hlegend = legend(h(1:3), {'3-Story', '6-Story', '9-Story'}, 'Location', 'NorthWest');
        hx = xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex'); hy = ylabel('Mean Repair Time (days)');
        ylim([0 400]); xlim([0 3]);
        exportName = sprintf('meanRepairTime_%s', figNameSuff);
    end
    
    stdev_lin = std(repairTimeAllData, 0, 1)./meanRepairTime;
    stdev_log = std(log(repairTimeAllData), 0, 1);
    
    figure(3); 
%     plot(Sa_realizations/Sa_MCE, stdev_log, 'b-', 'LineWidth', 1.5); hold on; grid on;
    h1(i) = plot(Sa_realizations(2:end)/Sa_MCE, stdev_log(2:end), plotStyle{i}, 'LineWidth', 1.5); hold on; grid on;
    
    cd(baseFolder); 
    if ~exist(dirForFigures, 'dir'); mkdir(dirForFigures); end 
    cd(dirForFigures); matFileName = sprintf('MeanRepairTime_%s.mat', buildingID);
    save(matFileName, 'Sa_realizations', 'meanRepairTime','repairTimeAllData', 'stdev_log');
    % fprintf('Mat file for resilience saved in %s.\n', pwd);
    cd(baseFolder);
end
% figure(1)
% hx = xlabel('Sa(T_1) (g)'); hy = ylabel('Mean Repair Time (days)');
% xlim([0 2]); hleg = legend(legStr, 'location', 'NorthWest');
% psb_FigureFormatScript_paper

if saveFigures == 1 && i == size(buildingIDLIST, 1) % add dummy legends in the last plot
    figure(2)    
    fprintf('Pay attention to the normailzation factors (i.e. Sa_MCE) for different buildings.\n');
    psb_FigureFormatScript_paper
%     psb_FigureFormatScript_paper_3figsInOneRow
%     psb_FigureFormatScript

    cd(baseFolder);  cd(dirForFigures);
    extensions = {'fig', 'epsc', 'meta'};
    for k = 1:length(extensions)
	    saveas(gcf, exportName, extensions{k})
    end

    figure(3);
    hx = xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex'); hy = ylabel('\beta_{ln, Repair Time}');
    hlegend = legend(h1(1:2:5), {'3-Story', '6-Story', '9-Story'}, 'Location', 'NorthEast');

    xlim([0.001 3]); ylim([0 0.5]);
    psb_FigureFormatScript_paper
%     psb_FigureFormatScript_paper_3figsInOneRow
%     psb_FigureFormatScript

    exportName = sprintf('beta_ln_repairTime_%s', figNameSuff);
    for k = 1:length(extensions)
	    saveas(gcf, exportName, extensions{k})
    end
    
end

cd(baseFolder)

toc