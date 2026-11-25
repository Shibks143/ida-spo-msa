function mu_T_LIST = sks_PushoverPlots(analysisType_forPO, runDifferentPushoverPatterns, patternNames, rootFolder, SPO_indexLIST)
% ===============================================
% (11-Dec-2025) Shivakumar K S, IIT Madras
% (26-Nov-2026, sks) works for any building and any number of patterns: no hard-coded folder,
%                    base-shear cap or colours; no cd, clc or close all
% (26-Nov-2026, sks) 'Parabolic Stiffness' (design-sheet loading, SPO_index = -999) can be one of the patterns
%
% Combined plots of one building pushed with different lateral load patterns:
%   1. load pattern vs floor number
%   2. pushover curves (base shear vs roof drift ratio), one per pattern
%   3. maximum interstory drift ratio profile over the pushover, one per pattern
%
% Inputs:
%   analysisType_forPO           - '(<fileName>)_(AllVar)_(0.00)_(clough)'
%   runDifferentPushoverPatterns - [numFloors x numPatterns] floor forces, ROOF FIRST, one column per pattern
%   patternNames                 - e.g. {'Parabolic Stiffness', 'Parabolic', 'Linear', 'Mode Shape'}
%   rootFolder                   - ida-spo-msa folder; optional, default = current folder
%   SPO_indexLIST                - SPO_index of each column; optional, default = 1:numPatterns
%                                  (-999 = 'Parabolic Stiffness': DATA_pushover.mat / DATA_allDataForThisSingleRun.mat)
%
% Reads, for each SPO_index:
%   Output\<analysisType_forPO>\DATA_pushover_<SPO_index>.mat                         (plotArrayAndBaseShearArray, mu_T)
%   Output\<analysisType_forPO>\EQ_9991\Sa_0.00\DATA_allDataForThisSingleRun_<SPO_index>.mat (storyDriftRatioToSave)
% Saves the three figures in Output\<analysisType_forPO>\
%
% Output:
%   mu_T_LIST - [numPatterns x 1] period-based ductility of each pattern (NaN if 0.8 Vmax not reached)
% ===============================================

if nargin < 4 || isempty(rootFolder)
    rootFolder = pwd;
end

[numStories, numPatterns] = size(runDifferentPushoverPatterns);
if nargin < 5
    SPO_indexLIST = 1:numPatterns;
end
if numel(patternNames) ~= numPatterns || numel(SPO_indexLIST) ~= numPatterns
    error('%d pattern names and %d SPO_index values given for %d patterns.', numel(patternNames), numel(SPO_indexLIST), numPatterns);
end

cutRatioOfPeakBaseShear = 0.8;      % pushover curve is shown until base shear drops below 0.8 Vmax after the peak
driftCapLimit           = 0.15;     % interstory drift ratio shown is capped at 15%
axisMarginRatio         = 0.05;     % pushover curves: 5% empty space beyond the largest roof drift and base shear

buildingFolder = fullfile(rootFolder, 'Output', analysisType_forPO);
runFolder      = fullfile(buildingFolder, 'EQ_9991', 'Sa_0.00');
floorNumLIST   = (2:numStories + 1)';                                     % floor 2 ... roof (bottom to top)

% ---- same colour for a pattern in every figure: Parabolic black, Linear red, Mode Shape blue, Parabolic Stiffness grey dashed ----
% (Parabolic Stiffness is thinner, so a pattern drawn under it, e.g. Parabolic, stays visible)
curveColorLIST = lines(numPatterns);
lineStyleLIST  = repmat({'-'}, 1, numPatterns);
lineWidthLIST  = 3 * ones(1, numPatterns);
for patternIndex = 1:numPatterns
    switch patternNames{patternIndex}
        case 'Parabolic',  curveColorLIST(patternIndex, :) = [0 0 0];
        case 'Linear',     curveColorLIST(patternIndex, :) = [1 0 0];
        case 'Mode Shape', curveColorLIST(patternIndex, :) = [0 0 1];
        case 'Parabolic Stiffness', curveColorLIST(patternIndex, :) = [0.6 0.6 0.6];   lineStyleLIST{patternIndex} = '--';   lineWidthLIST(patternIndex) = 2;
    end
end

% ---- data file names of each pattern ----
pushoverDataFileLIST = cell(1, numPatterns);
runDataFileLIST      = cell(1, numPatterns);
for patternIndex = 1:numPatterns
    if SPO_indexLIST(patternIndex) == -999
        pushoverDataFileLIST{patternIndex} = 'DATA_pushover.mat';
        runDataFileLIST{patternIndex}      = 'DATA_allDataForThisSingleRun.mat';
    else
        pushoverDataFileLIST{patternIndex} = sprintf('DATA_pushover_%d.mat', SPO_indexLIST(patternIndex));
        runDataFileLIST{patternIndex}      = sprintf('DATA_allDataForThisSingleRun_%d.mat', SPO_indexLIST(patternIndex));
    end
end

%% 1. Load pattern vs floor number
figure; hold on; grid on; box on;
for patternIndex = 1:numPatterns
    forceOnFloor = flipud(runDifferentPushoverPatterns(:, patternIndex));    % roof first -> bottom first
    plot(forceOnFloor, floorNumLIST, 'Marker', 'o', 'LineStyle', lineStyleLIST{patternIndex}, 'LineWidth', lineWidthLIST(patternIndex), 'MarkerSize', 6, ...
        'Color', curveColorLIST(patternIndex, :), 'DisplayName', patternNames{patternIndex});
end
xlabel('Normalised Floor Force');
ylabel('Floor Number');
ylim([min(floorNumLIST) max(floorNumLIST)]);
yticks(floorNumLIST);
legend('Location', 'southeast', 'Box', 'off');
sks_figureFormat('powerpoint');
sks_figureExport(fullfile(buildingFolder, 'PushoverPatterns_vs_FloorNumber_runDifferentPushoverPatterns'));

%% 2. Pushover curves
mu_T_LIST = nan(numPatterns, 1);
maxRoofDriftRatio = 0;                  % largest values over all plotted curves, for the axis limits
maxBaseShear      = 0;
figure; hold on; grid on; box on;
for patternIndex = 1:numPatterns
    pushoverData = load(fullfile(buildingFolder, pushoverDataFileLIST{patternIndex}), 'plotArrayAndBaseShearArray', 'mu_T');
    pushoverCurve = cutAfterPeak(pushoverData.plotArrayAndBaseShearArray, cutRatioOfPeakBaseShear);
    if isfield(pushoverData, 'mu_T') && pushoverData.mu_T > 0
        mu_T_LIST(patternIndex) = pushoverData.mu_T;                         % 0 from PlotPushover = 0.8 Vmax not reached -> NaN
    end
    plot(pushoverCurve(:, 1), pushoverCurve(:, 2), 'LineStyle', lineStyleLIST{patternIndex}, 'LineWidth', lineWidthLIST(patternIndex), ...
        'Color', curveColorLIST(patternIndex, :), 'DisplayName', patternNames{patternIndex});
    maxRoofDriftRatio = max(maxRoofDriftRatio, max(pushoverCurve(:, 1)));
    maxBaseShear      = max(maxBaseShear, max(pushoverCurve(:, 2)));
end
xlabel('Roof Drift Ratio');
ylabel('Base Shear (kN)');
xlim([0, (1 + axisMarginRatio) * maxRoofDriftRatio]);
ylim([0, (1 + axisMarginRatio) * maxBaseShear]);
legend('Location', 'southeast', 'Box', 'off');
sks_figureFormat('powerpoint');
sks_figureExport(fullfile(buildingFolder, 'PushoverCurves_DifferentLoadPatterns'));

%% 3. Maximum interstory drift ratio profile over the pushover
figure; hold on; grid on; box on;
for patternIndex = 1:numPatterns
    runData = load(fullfile(runFolder, runDataFileLIST{patternIndex}), 'storyDriftRatioToSave');
    storyDriftRatio = runData.storyDriftRatioToSave;
    driftOfStory = cellfun(@(storyDrift) storyDrift.Max, storyDriftRatio(1:numStories));   % Max = largest drift of the story over the pushover
    driftOfStory = min(driftOfStory(:), driftCapLimit);
    % step plot: constant drift over each story height
    driftVector = reshape([driftOfStory, driftOfStory]', [], 1);
    storyVector = reshape([(1:numStories)', (2:numStories + 1)']', [], 1);
    plot(driftVector, storyVector, 'LineStyle', lineStyleLIST{patternIndex}, 'LineWidth', lineWidthLIST(patternIndex), ...
        'Color', curveColorLIST(patternIndex, :), 'DisplayName', patternNames{patternIndex});
end
xlabel('Interstory Drift Ratio');
ylabel('Floor Number');
xlim([0 driftCapLimit + 0.1]);
ylim([1 numStories + 1]);
yticks(1:numStories + 1);
legend('Location', 'southeast', 'Box', 'off');
sks_figureFormat('powerpoint');
sks_figureExport(fullfile(buildingFolder, 'PushoverMaxDriftRatio_vs_FloorNumber_runDifferentPushoverPatterns'));

%% Ductility of each pattern
disp(table(patternNames(:), mu_T_LIST, 'VariableNames', {'pattern', 'mu_T'}));
end


function pushoverCurveCut = cutAfterPeak(pushoverCurve, cutRatioOfPeakBaseShear)
% keeps the curve up to (and including) the first point after the peak where base shear < ratio x Vmax
[peakBaseShear, peakIndex] = max(pushoverCurve(:, 2));
dropIndex = find(pushoverCurve(peakIndex+1:end, 2) < cutRatioOfPeakBaseShear * peakBaseShear, 1, 'first');
if isempty(dropIndex)
    pushoverCurveCut = pushoverCurve;
else
    pushoverCurveCut = pushoverCurve(1:peakIndex + dropIndex, :);
end
end
