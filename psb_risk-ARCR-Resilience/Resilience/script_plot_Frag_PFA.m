%     case '35.PlotPeakFloorAccnVsSa_IDA_Fragility'
%%
clear; close all; clc; cd(fileparts(mfilename('fullpath'))); baseFolder = pwd;   % always start in ...\Resilience

outputRoot   = fullfile(baseFolder, '..', '..', 'Output');
modelNameLIST = {'ID46053_R5_5Story_v.02'};

PFA_threshold_Frag = [1.17, 1.58, 1.82]; %, 1.5, 2.6, 1.5, 2.25, 1.1, 2.4, 1.2, 2.4]; % g
Sa_MCE = 0.27;              % MCE Sa(T1 = 1.36 s) for 46053 (same estimate as the master script); normalizes the fragility plot; need to work on this later 24-oct-2026
figDir = fullfile(baseFolder, 'figures_resCombined_M7.3_R30_R2_RESUnc');
plotStyle = {'r-', 'b-', 'g-', 'c-', 'm-'};
saveIDA = 1; saveFrag = 1;

%% (1/6) extract Data
for k = 1:size(modelNameLIST, 1)
    fprintf('Reading %i/%i...\n', k, size(modelNameLIST, 1));
    analysisDir = sprintf('(%s)_(AllVar)_(0.00)_(clough)', modelNameLIST{k});

    % search for all EQ directories
    eqIndex = 0; nMissingRuns = 0;
    allEqDirInfo = dir(fullfile(outputRoot, analysisDir, 'EQ_*'));

    % Loop over all EQ directories
    for i = 1 : length(allEqDirInfo)
        % skip EQ_9991 / EQ_9992 (pushover) where a large needless file is saved
        if strcmp(allEqDirInfo(i).name, 'EQ_9991') || strcmp(allEqDirInfo(i).name, 'EQ_9992')
            continue;
        else
            eqIndex = eqIndex + 1; count = 0; % reset the Sa-count
            eqStr = allEqDirInfo(i).name;
            eqNumberLISTAllBldgs{k}(eqIndex) = str2double(eqStr(4:end));
        end

        % search for all Sa directories
        allSaDirInfo = dir(fullfile(outputRoot, analysisDir, allEqDirInfo(i).name, 'Sa_*'));

        % Loop over all Sa directories
        for j = 1:length(allSaDirInfo)
            cd(fullfile(outputRoot, analysisDir, allEqDirInfo(i).name, allSaDirInfo(j).name));

            % read the run file (skip if there isn't one)
            try
                load('DATA_reducedSensDataForThisSingleRun', 'saTOneForRun', 'floorAccelToSave', 'periodUsedForScalingGroundMotionsFromMatlab');
                count = count + 1;
                for p = 2:size(floorAccelToSave, 2);  PFA_temp(p) = floorAccelToSave{1, p}.absAbsMaxUnfiltered; end

                Sa_PFA_AllData{k}{eqIndex}(count, :) = [saTOneForRun, max(PFA_temp)/9810];   % PFA from mm/s2 to g
                periodList(k) = periodUsedForScalingGroundMotionsFromMatlab;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%% (10-17-22, psb) Note that taking maximum of PFA on each story distorts the
                %%% nonstructural fragility, which must be considered for each floor. I am
                %%% only doing this to get an idea of the fragility params for MaxPFA.
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            catch
                nMissingRuns = nMissingRuns + 1;   % no run file (collapsed run at the top Sa level)
            end
        end

        % sort the runs of this record by Sa (folder-name order would break for e.g. Sa_10.00)
        if count > 0
            Sa_PFA_AllData{k}{eqIndex} = sortrows(Sa_PFA_AllData{k}{eqIndex});
        end
    end
    if nMissingRuns > 0
        fprintf('%d run files not found (collapsed runs at the top Sa level)\n', nMissingRuns);
    end
end
cd(baseFolder);   % back to the script folder after reading

%% (2/6) plotting all components in a different loop to avoid analyzing repeatedly % close all;
PFA_tooHigh_threshold_in_g = 10;
for k = 1:size(modelNameLIST, 1)
    figure(100+k); % All components for IDA for MaxPFA
    for eqId = 1:size(Sa_PFA_AllData{k}, 2)
        Sa = Sa_PFA_AllData{k}{eqId}(:, 1); MaxPFA = Sa_PFA_AllData{k}{eqId}(:, 2);   % PFA already in g (section 1/6)

        % remove values over the threshold
        Sa(MaxPFA > PFA_tooHigh_threshold_in_g) = []; MaxPFA(MaxPFA > PFA_tooHigh_threshold_in_g) = [];

        % update Sa_PFA_AllData by removing Sa PFA for exorbitant PFAs
        Sa_PFA_AllData{k}{eqId} = [Sa, MaxPFA];

        %     figure;
        h(k) = plot([0; MaxPFA], [0; Sa], plotStyle{k}); hold on; grid on;
    end

    xlim([0 5]); ylim([0 5]);
    str1 = '$PFA_{max}$ (g)'; str2 = sprintf('$Sa_{geoM}(T_1=%.2f)$ (g)', periodList(k));

    xlabel(str1, 'Interpreter', 'latex'); ylabel(str2, 'Interpreter', 'latex');
    sks_figureFormat('paper');

    exportName = sprintf('IDA_PFA_%s', strrep(modelNameLIST{k}, '.', '_'));
    if saveIDA == 1
        sks_figureExport(fullfile(figDir, exportName));   
    end
end

%% (3/6) calculated frag params for MaxPFA
for k = 1:size(modelNameLIST, 1) % for each building
    eqNumberLIST = eqNumberLISTAllBldgs{k};
    if mod(length(eqNumberLIST), 2) ~= 0
        error('Expected GM pairs (even number of components); found %d', length(eqNumberLIST));
    end
    Sa_th = zeros(1, length(eqNumberLIST)); % for multiple buildings, it is crucial to initialize this variable

    for PFA_th_Index = 1:size(PFA_threshold_Frag, 2) % for each threshold
        PFA_th = PFA_threshold_Frag(1, PFA_th_Index);
        for eqId = 1:size(eqNumberLIST, 2) % iterate through all eqs to calculate frag
            Sa = Sa_PFA_AllData{k}{eqId}(:, 1); MaxPFA = Sa_PFA_AllData{k}{eqId}(:, 2);
            % interpolate for possibly non-monotonic data
            ix = find(MaxPFA >= PFA_th, 1); % or <=
            if isempty(ix)
                Sa_th(eqId) = Sa(end);
            elseif ix == 1      % first run already above the threshold: interpolate from (0, 0)
                Sa_th(eqId) = interp1([0, MaxPFA(1)], [0, Sa(1)], PFA_th);
            else
                Sa_th(eqId) = interp1([MaxPFA(ix-1), MaxPFA(ix)], [Sa(ix-1), Sa(ix)], PFA_th, 'pchip');
            end
        end
        Sa_thLIST{k}(PFA_th_Index, :) = Sa_th;   % kept to pick the controlling component in section 4/6

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

T = table(PFA_threshold_Frag', fragParamMuCtrl_mat', fragParamBetaCtrl_mat', fragParamMuCtrl_mat'/Sa_MCE, fragParamMuALL_mat', fragParamBetaALL_mat');
T.Properties.VariableNames = {'PFA (g)', 'mu_Ctrl (g)', 'betaRTR_Ctrl', 'mu_Ctrl/Sa_MCE', 'mu_ALL (g)', 'betaRTR_ALL'};
disp(T);

% save the PFA fragility parameters (e.g. for script_plot_Fragility_Nonstructural.m)
if saveFrag == 1
    if ~exist(figDir, 'dir'); mkdir(figDir); end
    fragFilePFA = fullfile(figDir, sprintf('fragRes_PFA_%s.mat', strrep(modelNameLIST{1}, '.', '_')));
    save(fragFilePFA, 'modelNameLIST', 'periodList', 'Sa_MCE', 'PFA_threshold_Frag', 'fragParamMuCtrl_mat', 'fragParamBetaCtrl_mat', ...
        'fragParamMuALL_mat', 'fragParamBetaALL_mat', 'T');
    fprintf('PFA fragility parameters saved as %s\n', fragFilePFA);
end

%% (4/6) Plot controlling component IDA for MaxPFA
for k = 1:size(modelNameLIST, 1) % for each building
    figure(200 + k); % control component of IDA for MaxPFA
    eqNumberLIST = eqNumberLISTAllBldgs{k};

    for gmIndex = 1:length(eqNumberLIST)/2
        % controlling component = smaller Sa at the first PFA threshold (same rule as the fragility, section 3/6)
        ctrlEqId = gmIndex * 2 - 1;
        if Sa_thLIST{k}(1, gmIndex * 2) < Sa_thLIST{k}(1, gmIndex * 2 - 1)
            ctrlEqId = gmIndex * 2;
        end
        Sa_ctrl = Sa_PFA_AllData{k}{ctrlEqId}(:, 1); MaxPFA_ctrl = Sa_PFA_AllData{k}{ctrlEqId}(:, 2);
        plot([0; MaxPFA_ctrl], [0; Sa_ctrl], plotStyle{k}); hold on; grid on;
    end

    xlim([0 4]); ylim([0 4.0]);

    str1 = '$PFA_{max}$ (g)'; str2 = sprintf('$Sa_{geoM}(T_1=%.2f)$ (g)', periodList(k));
    xlabel(str1, 'Interpreter', 'latex'); ylabel(str2, 'Interpreter', 'latex');
    sks_figureFormat('powerpoint');

    exportName = sprintf('IDA_PFA_Ctrl_%s', strrep(modelNameLIST{k}, '.', '_'));
    if saveIDA == 1
        sks_figureExport(fullfile(figDir, exportName));   % .fig, .eps, .tiff, .emf
    end
end

%% (5/6) plot fragility curves (median normalized by Sa_MCE) and save
minValue = 0; maxValue = 3;
figure(301);
for LS = 1:3 %
    h1(LS) = PlotLogNormalCDF_current(log(T.("mu_Ctrl (g)")(LS)/Sa_MCE), T.betaRTR_Ctrl(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
    xticks(1:5); % yticks(0:0.2:1);
end

xlim([minValue, maxValue]);
str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; xlabel(str1, 'Interpreter', 'latex');
ylabel(str2, 'Interpreter', 'latex');

legTxt = {'$LS_1$', '$LS_2$', '$LS_3$'};
legh = legend(h1, legTxt, 'Interpreter','latex', 'Location', 'southeast');
sks_figureFormat('powerpoint');
legh.Location = 'southeast';                            % sks_figureFormat moves legends to northeast

exportName = sprintf('Frag_PFA_Ctrl_%s', strrep(modelNameLIST{1}, '.', '_'));
if saveFrag == 1
    sks_figureExport(fullfile(figDir, exportName));
end

%% (6/6) nonstructural (PFA) fragility in the 1x3 tiled layout (from script_plot_Fragility_Nonstructural.m)
minValue = 0; maxValue = 5;
figure(302); tiledlayout(1, 3, 'TileSpacing', 'compact');
set(gcf, 'Position', [50 200 1500 460]);
nexttile(1);
h6 = gobjects(1, 3);
for LS = 1:3
    h6(LS) = PlotLogNormalCDF_current(log(T.("mu_Ctrl (g)")(LS)/Sa_MCE), T.betaRTR_Ctrl(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
end
xticks(1:5); xlim([minValue, maxValue]);
xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex'); ylabel('$F[LS_i|IM]$', 'Interpreter', 'latex');

legTxt = {'$LS_1 \qquad$', '$LS_2 \qquad$', '$LS_3\,\,$'};
legh = legend(h6, legTxt, 'Orientation', 'Horizontal', 'Interpreter', 'latex');
sks_figureFormat('paper');
legh.Layout.Tile = 'north';                             % after formatting: sks_figureFormat moves legends to northeast
legh.Orientation = 'horizontal'; legh.NumColumns = 3;

if saveFrag == 1
    sks_figureExport(fullfile(figDir, 'Frag_Nonstructural'));   % .fig, .eps, .tiff, .emf
end
cd(baseFolder)
