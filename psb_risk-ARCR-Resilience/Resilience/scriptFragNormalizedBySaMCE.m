clear; tic; % close all;
baseFolder = pwd;

%% (Inputs- 1/2) Building-specific inputs
DS_StoryDriftLIST = [0.005, 0.01, 0.02, 0.04, 0.00]; % DS1, DS2, DS3, DS4 (0.00 indicates sidesway collapse or dynamic instability)

% fragility is plotted independently.
buildingIDLIST = {'1310v1_NF'; '1310v1_FF'; '1610v1_NF'; '1610v1_FF'; '1910v1_NF'; '1910v1_FF'}; % legStr = {'3-Story (FF)', '3-Story (NF)', '6-Story (FF)', '6-Story (NF)', '9-Story (FF)', '9-Story (NF)'}; plotStyle = {'k-', 'k--', 'b-', 'b--', 'r-', 'r--'}; figNameSuff = 'allSix';
% buildingIDLIST = {'1310v1_FF'; '1610v1_FF'; '1910v1_FF'};  % legStr = {'3-Story', '6-Story', '9-Story'}; plotStyle = {'k-', 'b-', 'r-'}; figNameSuff = 'allFF'; % all far-field
% buildingIDLIST = {'1310v1_NF'; '1610v1_NF'; '1910v1_NF'}; % legStr = {'3-Story', '6-Story', '9-Story'}; plotStyle = {'k-', 'b-', 'r-'}; figNameSuff = 'allNF'; % all near-field
% buildingIDLIST = {'1310v1_FF'; '1310v1_NF';}; % legStr = {'Far-field', 'Near-field'}; plotStyle = {'k-', 'k--'}; figNameSuff = '3Story'; % 3-storied
% buildingIDLIST = {'1610v1_FF'; '1610v1_NF';}; % legStr = {'Far-field', 'Near-field'}; plotStyle = {'k-', 'k--'}; figNameSuff = '6Story'; % 6-storied
% buildingIDLIST = {'1910v1_FF'; '1910v1_NF';}; % legStr = {'Far-field', 'Near-field'}; plotStyle = {'k-', 'k--'}; figNameSuff = '9Story'; % 9-storied

doPrint = 1;
saveFigures = 1; % when running for optimal beta, do not saveFigures
dirForFigures = sprintf('frag_figures_normalizedBySa_combined_%s', '3inARow');
% dirForFigures = sprintf('frag_figures_normalizedBySa_%s', '');
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

    % end of inputs

    fileName = sprintf("fragRes_%s_%s.mat", buildingID, GMsuiteName);

    % I have copied these values from the design table for now.
    % To make the comparison fare, these are Sa_MCE values are for T1 from analysis, i.e., Sa(0.83) etc.
    if numStories == 3; Sa_MCE = 0.435; elseif numStories == 6; Sa_MCE = 0.221;
    elseif numStories == 9; Sa_MCE = 0.153; end

    cd ..\RiskAndARCR\
    load(fileName, 'fragParamMuCtrl_mat', 'fragParamBetaCtrl_mat');
    cd(baseFolder);

%     plotStyle = {'r-', 'b--', 'g-.', 'k:', 'm-', 'y--'};

    if strcmp(GMsuiteName, 'GMSetC')
        plotStyle = {'r-', 'b-', 'g-', 'c-', 'm-'};
    elseif strcmp(GMsuiteName, 'GMSetG')
        plotStyle = {'r--', 'b--', 'g--', 'c--', 'm--'};
    end

    minValue = 0; maxValue = 3.0;

%     figure
    figure(floor((i+1)/2));
    for LS = 1:5 %
        meanSa = fragParamMuCtrl_mat(LS);
        betaLn = fragParamBetaCtrl_mat(LS);
        h(LS) = PlotLogNormalCDF_current(log(meanSa/Sa_MCE), betaLn, minValue, maxValue, plotStyle{LS}); hold on; grid on;
    end

    cd(baseFolder);  mkdir(dirForFigures); cd(dirForFigures);
    if legOn == 1
        h(6) = plot(4, 1, 'k-', 'LineWidth', 1.5); h(7) = plot(4, 1, 'k--', 'LineWidth', 1.5); % dummy plots outside the range
        xlim([minValue, maxValue]);
        hlegend = legend([h], {'LS_1', 'LS_2', 'LS_3', 'LS_4', 'LS_5', 'FF', 'NF'}, 'Location', 'NorthEast');
    end
    str1 = 'Sa(T_1)/Sa_{MCE}'; str2 = 'F[LS_i|IM]'; hx = xlabel(str1); 
    
%     hy = ylabel(str2); psb_FigureFormatScript_paper

    if floor((i+1)/2) == 1 % y-axis label only for first figure
        hy = ylabel(str2);
%        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % Enlarge figure to full screen. x0-y0-delX-delY
    end

    if floor((i+1)/2) == 1 
        xx = gca;
    elseif floor((i+1)/2) >= 2
        set(gca, 'InnerPosition', xx.InnerPosition);
    end

    psb_FigureFormatScript_paper_3figsInOneRow

    if saveFigures == 1 && mod(i, 2) == 0
        strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
        exportName = sprintf('%s_Frag_%s_normalized', buildingID, strForIM);
        hgsave(exportName); % .fig file for Matlab
        print('-depsc', exportName); % .eps file for Linux (LaTeX)
        print('-dmeta', exportName); % .emf file for Windows (MSWORD)
    end

    % store to collect in the table
    periodT1(i, 1) = T1forIM;
    muCtrl(i, :) = fragParamMuCtrl_mat; 
    betaLnCtrl(i, :) = fragParamBetaCtrl_mat;

    cd(baseFolder)
end

T = table(buildingIDLIST, periodT1, muCtrl, betaLnCtrl);
disp(T);
toc