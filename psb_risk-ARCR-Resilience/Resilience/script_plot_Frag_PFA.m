%     case '35.PlotPeakFloorAccnVsSa_IDA_Fragility'
%%
clear; close all; clc; baseFolder = pwd;

outpDir = 'C:\Users\aprak\Desktop\UBCO_AnalysisResults\Results_Spectra_small';
modelNameLIST = {'ID1310_v.01_FF';
    %                 'ID1310_v.01_NF';
    %                 'ID1610_v.01_FF';
    %                 'ID1610_v.01_NF';
    %                 'ID1910_v.01_FF';
    %                 'ID1910_v.01_NF';
    };
% PFA_threshold_Frag = [1, 1.17, 1.3, 1.58, 1.82, 2.25, 2.6]; % g
PFA_threshold_Frag = [1.17, 1.58, 1.82]; %, 1.5, 2.6, 1.5, 2.25, 1.1, 2.4, 1.2, 2.4]; % g
figDir = 'C:\Users\aprak\Drive_UBCO\WRITING_ubco\paper_sub_ResPaper_Spectra\Figures_reformat_resave\frag_MaxPFA_production';
plotStyle = {'r-', 'b-', 'g-', 'c-', 'm-'};
saveIDA = 0; saveFrag = 1;

%% (1/5) extract Data
for k = 1:size(modelNameLIST, 1)
    fprintf('Reading %i/%i...\n', k, size(modelNameLIST, 1));
    analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelNameLIST{k});

    % if analysis dir exists, make a dir with same name in WriteDir
    cd(fullfile(outpDir, analysisDir));

    % search for all EQ directories
    eqDirPattern = sprintf('EQ_*'); eqIndex = 0;
    allEqDirInfo = dir(eqDirPattern);

    % Loop over all EQ directories
    for i = 1 : length(allEqDirInfo)
        cd(allEqDirInfo(i).name);

        % copy all mat files outside except for EQ_9991 (pushover) when a large needless file is saved
        if strcmp(allEqDirInfo(i).name, 'EQ_9991') || strcmp(allEqDirInfo(i).name, 'EQ_9992')
            continue;
        else
            eqIndex = eqIndex + 1; count = 0; % reset the Sa-count
            eqStr = allEqDirInfo(i).name;
            eqNumberLISTAllBldgs{k}(eqIndex) = str2num(eqStr(4:end));
        end

        % search for all Sa files
        saDirPattern = sprintf('Sa_*');
        allSaDirInfo = dir(saDirPattern);

        % Loop over all Sa directories
        for j = 1:length(allSaDirInfo)
            cd(allSaDirInfo(j).name);

            % copy all mat files outside (skip if there isn't one)
            try
                load('DATA_reducedSensDataForThisSingleRun', 'saValue', 'floorAccelToSave', 'periodUsedForScalingGroundMotionsFromMatlab');
                count = count + 1;
                for p = 2:size(floorAccelToSave, 2);  PFA_temp(p) = floorAccelToSave{1, p}.absAbsMaxUnfiltered; end

                Sa_PFA_AllData{k}{eqIndex}(count, :) = [saValue, max(PFA_temp)];
                periodList(k) = periodUsedForScalingGroundMotionsFromMatlab;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% (10-17-22, psb) Note that taking maximum of PFA on each story distorts the
                %%% nonstructural fragility, which must be considered for each floor. I am
                %%% only doing this to get an idea of the fragility params for MaxPFA.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            catch
                %                 warning('No .mat file in %s', fullfile(analysisDir));
            end

            cd .. % come out to EQ-dir
        end
        cd .. % come out to analysis-Dir
    end
end

%% (2/5) plotting all components in a different loop to avoid analyzing repeatedly % close all;
PFA_tooHigh_threshold_in_g = 10;
for k = 1:size(modelNameLIST, 1)
    figure(100+k); % All components for IDA for MaxPFA
    for eqId = 1:size(Sa_PFA_AllData{k}, 2)
        Sa = Sa_PFA_AllData{k}{eqId}(:, 1); MaxPFA = Sa_PFA_AllData{k}{eqId}(:, 2);
        MaxPFA = MaxPFA./9810; % from mm/s2 to g

        % remove values over the threshold
        Sa(MaxPFA > PFA_tooHigh_threshold_in_g) = []; MaxPFA(MaxPFA > PFA_tooHigh_threshold_in_g) = [];

        % update Sa_PFA_AllData by removing Sa PFA for exorbitant PFAs
        Sa_PFA_AllData{k}{eqId} = [Sa, MaxPFA];

        %     figure;
        h(k) = plot([0; MaxPFA], [0; Sa], plotStyle{k}); hold on; grid on;
    end

    %     p = polyfit(MIDR, RIDR, 1); px = [min(MIDR) max(MIDR)]; py = polyval(p, px);
    %     plot(px, py, 'Color', colorLIST{k}, 'LineWidth', 2);

    %     clearvars Sa MaxPFA; % excuse 'em for the next plot
    xlim([0 5]); ylim([0 5]);

    str1 = '$PFA_{max}$ (g)'; str2 = sprintf('$Sa_{geoM}(T_1=%.2f)$ (g)', periodList(k));
    % strForLegend = {'Slit' 'Flag-Shaped, \beta_F = 0.8' 'Flag-Shaped, \beta_F = 0.6'};

    hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
    % legh = legend(h, strForLegend); % htitle = title(str3);
    set(hx, 'FontSize', 16); set(hy, 'FontSize', 16);
    % set(legh,'FontSize', 11, 'Location', 'northwest');
    set(gca, 'FontSize', 14);
    % set(htitle, 'FontSize', titleFontSize);

    exportName = sprintf('IDA_PFA_%s', strrep(modelNameLIST{k}, '.', '_'));
    extensions = {'fig', 'epsc'};
    if saveIDA == 1
        for p = 1:length(extensions)
            cd(figDir) ; saveas(gcf, exportName, extensions{p})
        end
    end
end

%% (3/5) calculated frag params for MaxPFA
for k = 1:size(modelNameLIST, 1) % for each building
    eqNumberLIST = eqNumberLISTAllBldgs{k};
    Sa_th = zeros(1, length(eqNumberLIST)); % for multiple buildings, it is crucial to initialize this variable

    for PFA_th_Index = 1:size(PFA_threshold_Frag, 2) % for each threshold
        PFA_th = PFA_threshold_Frag(1, PFA_th_Index);
        for eqId = 1:size(eqNumberLIST, 2) % iterate through all eqs to calculate frag
            Sa = Sa_PFA_AllData{k}{eqId}(:, 1); MaxPFA = Sa_PFA_AllData{k}{eqId}(:, 2);
            % interpolate for possibly non-monotonic data
            ix = find(MaxPFA >= PFA_th, 1); % or <=
            if ~isempty(ix)
                Sa_th(eqId) = interp1([MaxPFA(ix-1), MaxPFA(ix)], [Sa(ix-1), Sa(ix)], PFA_th, 'pchip');
            else
                Sa_th(eqId) = Sa(end);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% frag params calculation block begins
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% (unless debugging, close your eyes and move on to the end of this block)
        Sa_th_Ctrl = zeros(1, length(eqNumberLIST)/2); % for multiple buildings, it is crucial to initialize this variable

        for gmIndex = 1:length(eqNumberLIST)/2
            saT_CompOne = Sa_th(gmIndex * 2 - 1);
            saT_CompTwo = Sa_th(gmIndex * 2);

            Sa_th_Ctrl(gmIndex) = min(saT_CompOne, saT_CompTwo);
        end

        % variables to store as a matrix in the .mat file
        % Do collapse statistics - for all components
        fragParamMuALL_mat(k, PFA_th_Index) = exp(mean(log(Sa_th)));
        fragParamBetaALL_mat(k, PFA_th_Index) = std(log(Sa_th));

        % Do collapse statistics - for Ctrlling components
        fragParamMuCtrl_mat(k, PFA_th_Index) = exp(mean(log(Sa_th_Ctrl)));
        fragParamBetaCtrl_mat(k, PFA_th_Index) = std(log(Sa_th_Ctrl));

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% frag params calculation block ends
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
% fprintf('Buildings processed are: \n');
% disp(modelNameLIST);
T = table(PFA_threshold_Frag', fragParamMuCtrl_mat', fragParamBetaCtrl_mat');
T.Properties.VariableNames = {'PFA (g)', 'mu_Ctrl (g)', 'betaRTR_Ctrl'};
disp(T);

%% (4/5) Plot controling component IDA for MaxPFA
for k = 1:size(modelNameLIST, 1) % for each building
    figure(200 + k); % control component of IDA for MaxPFA
    eqNumberLIST = eqNumberLISTAllBldgs{k};

    for gmIndex = 1:length(eqNumberLIST)/2
        ctrlEqId = gmIndex * 2 - 1; % default; update if it has higher Sa at the end
        if Sa_PFA_AllData{k}{gmIndex * 2 - 1}(end, 2) > Sa_PFA_AllData{k}{gmIndex * 2}(end, 2)
            ctrlEqId = gmIndex * 2;
        end
        Sa_ctrl = Sa_PFA_AllData{k}{ctrlEqId}(:, 1); MaxPFA_ctrl = Sa_PFA_AllData{k}{ctrlEqId}(:, 2);
        plot([0; MaxPFA_ctrl], [0; Sa_ctrl], plotStyle{k}); hold on; grid on;
    end

    xlim([0 4]);
    switch k
        case {1 2}; ylim([0 4.0]);  case {3 4}; ylim([0 2.0]);   case {5 6}; ylim([0 1.0]);
    end

    str1 = '$PFA_{max}$ (g)'; str2 = sprintf('$Sa_{geoM}(T_1=%.2f)$ (g)', periodList(k));
    hx = xlabel(str1, 'Interpreter', 'latex'); hy = ylabel(str2, 'Interpreter', 'latex');
    set(hx, 'FontSize', 24); set(hy, 'FontSize', 24); set(gca, 'FontSize', 21);

    cd(baseFolder);  if ~exist(figDir, 'dir'); mkdir(figDir); end
    cd(figDir);
    exportName = sprintf('IDA_PFA_Ctrl_%s', strrep(modelNameLIST{k}, '.', '_'));
    extensions = {'fig', 'epsc'};
    if saveIDA == 1
        for p = 1:length(extensions)
            cd(figDir) ; saveas(gcf, exportName, extensions{p})
        end
    end
end
cd(baseFolder);
%% (5/5) plot fragility curves and save 
minValue = 0; maxValue = 3;
figure;
for LS = 1:3 %
    h1(LS) = PlotLogNormalCDF_current(log(T.("mu_Ctrl (g)")(LS)), T.betaRTR_Ctrl(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
    xticks(1:5); % yticks(0:0.2:1);
end

xlim([minValue, maxValue]);
str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; hx = xlabel(str1, 'Interpreter', 'latex');
hy = ylabel(str2, 'Interpreter', 'latex');

% legTxt = {'$LS_1 \qquad$', '$LS_2 \qquad$', '$LS_3\,\,$'};
legTxt = {'$LS_1$', '$LS_2$', '$LS_3$'};
% legh = legend(h1(1:end), legTxt, 'Orientation', 'Horizontal', 'Interpreter','latex');
legh = legend(h1(1:end), legTxt, 'Interpreter','latex', 'Location', 'southeast');
% legh.Layout.Tile = 'north';
set(hx, 'FontSize', 24); set(hy, 'FontSize', 24); set(gca, 'FontSize', 21); set(legh, 'FontSize', 16.5);

% psb_FigureFormatScript_paper_3figsInOneRow;
cd(figDir);
exportName = sprintf('Fig8b_frag_PFA_Ctrl_%s', 'ID1310_FF');

extensions = {'fig', 'epsc', 'meta'};
if saveFrag == 1
    for k = 1:length(extensions)
        saveas(gcf, exportName, extensions{k})
    end
end
cd(baseFolder)
