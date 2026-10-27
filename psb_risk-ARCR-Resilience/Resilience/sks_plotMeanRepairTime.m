%% -------------------
% Plots mean repair time and its log-std vs Sa(T1)/Sa_MCE for all buildings (figures 601 and 602).
% Script (not a function): called once by sks_MasterDriver_ScenarioBasedHousingRecoveryAndResilience.m
% AFTER the building loop; uses baseFolder, buildingIDLIST, plotMeanWithBound, figNameSuff from the master.
% Reads:  figures_repTimeVsSa_R1_betaTOT\MeanRepairTime_<ID>.mat (saved in step 8 of the master)
% Saves:  meanRepairTime_<suffix> (or meanRepairTimeWithBound_<suffix>), beta_ln_repairTime_<suffix>
%       in figures_repTimeVsSa_R1_betaTOT
% Moved unchanged from sks_MasterDriver_MeanRepTimeVsSaMCE.m (plot section).
%% -------------------

colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00; 0.50 0.50 0.50];   % blue, magenta, black, red, gray
plotStyle = {'-', '--'};                            % {mean, 16/84% bounds}; color from colors(building, :)
h2 = gobjects(1, numel(buildingIDLIST)); h1 = gobjects(1, numel(buildingIDLIST));
for i = 1:numel(buildingIDLIST)
    load(fullfile(baseFolder, 'figures_repTimeVsSa_R1_betaTOT', sprintf('MeanRepairTime_%s.mat', buildingIDLIST{i})), ...
        'Sa_realizations', 'meanRepairTime', 'repairTimeAllData', 'stdev_log', 'Sa_MCE');

    figure(601);
    h2(i) = plot(Sa_realizations/Sa_MCE, meanRepairTime, plotStyle{1}, 'Color', colors(i, :), 'LineWidth', 1.5); grid on; hold on;
    if plotMeanWithBound == 1   % used for single building in the reviewer report
        hBound = plot(Sa_realizations/Sa_MCE, quantile(repairTimeAllData, 0.16, 1), plotStyle{2}, 'Color', colors(i, :), 'LineWidth', 1.5);
        plot(Sa_realizations/Sa_MCE, quantile(repairTimeAllData, 0.84, 1), plotStyle{2}, 'Color', colors(i, :), 'LineWidth', 1.5);
    end

    figure(602);
    h1(i) = plot(Sa_realizations(2:end)/Sa_MCE, stdev_log(2:end), plotStyle{1}, 'Color', colors(i, :), 'LineWidth', 1.5); grid on; hold on;
end

figure(601)
fprintf('Pay attention to the normalization factors (i.e. Sa_MCE) for different buildings.\n');
xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex');
if plotMeanWithBound == 1
    hlegend = legend([h2(end), hBound], {'Mean', '$\pm 1\sigma$'}, 'Location', 'NorthWest');
    ylabel('Repair Time (days)'); set(gca, 'YScale', 'log'); 
    ylim([10 500]); xlim([0 2.5]);
    exportName = sprintf('meanRepairTimeWithBound_%s', figNameSuff);
else
    hlegend = legend(h2, strrep(buildingIDLIST, '_', '\_'), 'Location', 'NorthWest');   % one entry per building
    ylabel('Mean Repair Time (days)'); 
    ylim([0 400]); xlim([0 2.5]);
    exportName = sprintf('meanRepairTime_%s', figNameSuff);
end
sks_figureFormat('powerpoint');
hlegend.Location = 'northwest';                     % sks_figureFormat moves legends to northeast
sks_figureExport(fullfile(baseFolder, 'figures_repTimeVsSa_R1_betaTOT', exportName));   

figure(602);
xlabel('$Sa(T_1)/Sa_{MCE}$', 'Interpreter', 'latex'); ylabel('$\beta_{\ln,\ \mathrm{Repair\ Time}}$', 'Interpreter', 'latex');
legend(h1, strrep(buildingIDLIST, '_', '\_'), 'Location', 'NorthEast');   % one entry per building
xlim([0.001 2.5]); ylim([0 0.5]);
sks_figureFormat('powerpoint');

exportName = sprintf('beta_ln_repairTime_%s', figNameSuff);
sks_figureExport(fullfile(baseFolder, 'figures_repTimeVsSa_R1_betaTOT', exportName));
