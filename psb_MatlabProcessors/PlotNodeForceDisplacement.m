
clear; clc; close all;

%% Inputs
modelName      = 'ID35123_R5_12Story_v.03';   % model folder name under Models\
analysisSuffix = '_(AllVar)_(0.00)_(clough)';
outputRootFolder     = 'E:\StaticDynamicAnalysis\ida-spo-msa\Output';
buildingOutputFolder = fullfile(outputRootFolder, ['(' modelName ')' analysisSuffix]);
nodeDisplFolder = fullfile(buildingOutputFolder, 'EQ_9991', 'Sa_0.00', 'Nodes', 'DisplTH');
nodeNum  = 202011;    % top of storey-1 column, column line 1 (bottom face of floor-2 joint)
savePlot = true;      % true = save PNG + FIG in buildingOutputFolder

%% Load recorder file
nodeFileName = fullfile(nodeDisplFolder, sprintf('THNodeDispl_%d.out', nodeNum));
if ~isfile(nodeFileName)
    error('Node displacement file not found: %s', nodeFileName);
end
nodeDisplData = load(nodeFileName);

baseShear    = nodeDisplData(:, 1);   % kN
lateralDispl = nodeDisplData(:, 4);   % mm

%% Peak point
[peakBaseShear, peakIndex] = max(baseShear);
displAtPeak = lateralDispl(peakIndex);
fprintf('Node %d: peak base shear = %.1f kN at %.2f mm\n', nodeNum, peakBaseShear, displAtPeak);
fprintf('Final point: %.1f kN at %.2f mm (%.0f%% of peak)\n', ...
    baseShear(end), lateralDispl(end), 100 * baseShear(end) / peakBaseShear);

%% Plot
figure('Color', 'w', 'Name', sprintf('Force-displacement, node %d', nodeNum));
plot(lateralDispl, baseShear, 'b-', 'LineWidth', 2);
hold on;
plot(displAtPeak, peakBaseShear, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
text(displAtPeak, 0.92 * peakBaseShear, ...
    sprintf('Peak %.0f kN at %.1f mm', peakBaseShear, displAtPeak), ...
    'VerticalAlignment', 'top', 'FontSize', 10);
hold off;

grid on; box on;
xlim([0, max(lateralDispl) * 1.05]);
ylim([0, peakBaseShear * 1.10]);
xlabel('Lateral displacement, DOF 1 (mm)');
ylabel('Base shear (kN)');
title(sprintf('Pushover force-displacement, %s, node %d', modelName, nodeNum), 'Interpreter', 'none');

%% Save (optional)
if savePlot
    plotFileName = fullfile(buildingOutputFolder, sprintf('%s_ForceDispl_Node%d', modelName, nodeNum));
    exportgraphics(gcf, [plotFileName '.png'], 'Resolution', 300);
    savefig(gcf, [plotFileName '.fig']);
    fprintf('Saved plot: %s.png and .fig\n', plotFileName);
end