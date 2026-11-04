function sks_plotMeanRepairTime(baseFolder, buildingIDLIST, plotMeanWithBound,  colors)
% sks_plotMeanRepairTime.m
% Plots mean repair time and its log-std vs Sa(T1)/Sa_MCE for all buildings (figures 601 and 602).
% Called once by sks_MasterDriver_ScenarioBasedHousingRecAndRes.m after the building loop.
%
% Inputs: baseFolder        - Resilience folder of the master
%         buildingIDLIST    - building IDs (cell), same as the master
%         plotMeanWithBound - 1 = mean with 16/84% bounds (single building); 0 = mean only
% Reads : Output_Res\figures_repTimeVsSa_R1_betaTOT\MeanRepairTime_<ID>.mat (saved in step 6 of the master)
% Saves : meanRepairTime_<IDs> (or meanRepairTimeWithBound_<IDs>), beta_ln_repairTime_<IDs> in the same folder
% Calls : sks_figureFormat.m, sks_figureExport.m

repDir = fullfile(baseFolder, 'Output_Res', 'figures_repTimeVsSa_R1_betaTOT');
figNameSuff = strjoin(buildingIDLIST, '_');                 % export-name suffix, e.g. '46053_35053'
nBldg = numel(buildingIDLIST);
plotStyle = {'-', '--'};                                     % {mean, 16/84% bounds}; color from colors(building, :)
h2 = gobjects(1, nBldg); h1 = gobjects(1, nBldg);
for i = 1:nBldg
    load(fullfile(repDir, sprintf('MeanRepairTime_%s.mat', buildingIDLIST{i})), ...
        'Sa_realizations', 'meanRepairTime', 'repairTimeAllData', 'stdev_log', 'Sa_MCE');

    figure(601);
    h2(i) = plot(Sa_realizations/Sa_MCE, meanRepairTime, plotStyle{1}, 'Color', colors(i, :), 'LineWidth', 2.0); grid on; hold on;
    if plotMeanWithBound == 1   % used for single building in the reviewer report
        hBound = plot(Sa_realizations/Sa_MCE, quantile(repairTimeAllData, 0.16, 1), plotStyle{2}, 'Color', colors(i, :), 'LineWidth', 2.0);
        plot(Sa_realizations/Sa_MCE, quantile(repairTimeAllData, 0.84, 1), plotStyle{2}, 'Color', colors(i, :), 'LineWidth', 2.0);
    end

    figure(602);
    h1(i) = plot(Sa_realizations(2:end)/Sa_MCE, stdev_log(2:end), plotStyle{1}, 'Color', colors(i, :), 'LineWidth', 2.0); grid on; hold on;
end

figure(601)
xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex');
if plotMeanWithBound == 1
    hlegend = legend([h2(end), hBound], {'Mean', '$\pm 1\sigma$'}, 'Location', 'SouthEast');
    ylabel('Repair Time (days)'); set(gca, 'YScale', 'log');
    ylim([10 500]); xlim([0 2.5]);
    exportName = sprintf('meanRepairTimeWithBound_%s', figNameSuff);
else
    hlegend = legend(h2, replace(buildingIDLIST, {'46053v02', '35053v02'}, {'5S-Prop-VH', '5S-2016-VH'}), 'Location', 'SouthEast');   % building name used in paper
    % hlegend = legend(h2, strrep(buildingIDLIST, '_', '\_'), 'Location', 'SouthEast');   % one entry per building
    ylabel('Mean Repair Time (days)');
    ylim([0 400]); xlim([0 2.5]);
    exportName = sprintf('meanRepairTime_%s', figNameSuff);
end
sks_figureFormat('powerpoint');
hlegend.Location = 'SouthEast';                              % sks_figureFormat moves legends to northeast
sks_figureExport(fullfile(repDir, exportName));

figure(602);
xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex');
ylabel('$\beta_{\ln,\ \mathrm{Repair\ Time}}$', 'Interpreter', 'latex');
legend(h1, replace(buildingIDLIST, {'46053v02', '35053v02'}, {'5S-Prop-VH', '5S-2016-VH'}), 'Location', 'SouthEast');   % building name used in paper
% legend(h1, strrep(buildingIDLIST, '_', '\_'), 'Location', 'SouthEast');   % one entry per building
xlim([0.001 2.5]); ylim([0 0.5]);
sks_figureFormat('powerpoint');
sks_figureExport(fullfile(repDir, sprintf('beta_ln_repairTime_%s', figNameSuff)));
end