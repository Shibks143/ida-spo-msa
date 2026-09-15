%
% Procedure: sks_PlotCollapse_singleAnaType_MSA_RDR.m
% -------------------
% Same as sks_PlotCollapse_singleAnaType_MSA.m (which plots MSA with
% X = Max Interstory Drift Ratio), EXCEPT the X-axis is replaced with the
% MAXIMUM (over all stories) RESIDUAL INTERSTORY DRIFT RATIO (RDR).
% Y-axis (Sa,geoMean(T1)) is unchanged.
%
% Collapse / no-collapse classification, filtering rules, and Sa-level
% stripe logic are taken EXACTLY from DATA_CollapseResultsForThisSingleEQ.mat
% (same as the original MIDR plotter), so "collapse" here still means
% "this run was flagged as collapsed by the MIDR-based collapse criterion".
% Only the quantity plotted on the X-axis has changed.
%
% RDR values are NOT stored in DATA_CollapseResultsForThisSingleEQ.mat.
% They live inside each EQ's Sa_* subfolders, in
% DATA_reducedSensDataForThisSingleRun.mat -> storyDriftRatioToSave, a
% per-story cell array whose .Residual field gives each story's residual
% drift ratio (see sks_IDR_RDR_PFA_MSA.m, where this per-story quantity is
% labeled "RDR" — distinct from "RoofRDR", the separate roof-only residual
% drift ratio, which is NOT used here). This function takes max(abs(...))
% over stories to get one envelope RDR value per run, matched by Sa-level
% order and value — mirroring how maxDriftRatioForFullStr gives one
% envelope MIDR value per run in the original collapse plotter.
%
% NOTE: There is no RDR-based collapse threshold defined anywhere in your
% processing chain (minStoryDriftRatioForCollapseMATLAB is an MIDR
% threshold), so the vertical dashed threshold line from the original
% plot is NOT drawn here. If you have/define an RDR collapse threshold,
% add an xline() call where indicated below.
%
% Shivakumar K S
% =========================================================================

function sks_PlotCollapse_singleAnaType_MSA_RDR(msaInputs)

analysisTypeLIST =            msaInputs.analysisTypeLIST;
eqNumberLIST =                msaInputs.eqNumberLIST;
isConvertToSaKircher =        msaInputs.isConvertToSaKircher;

formatMode = 'powerpoint';    % 'default' | 'powerpoint' | 'report' | 'paper'

startDir = pwd;

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolder = sprintf('%s', analysisType);

    cd(startDir);
    cd ..;
    cd Output;

    fprintf('\n=========================================\n');
    fprintf('Processing analysisType (RDR-MSA) = %s\n', analysisTypeFolder);
    fprintf('=========================================\n');

    % ============================================================
    % ========== 1) ALL COMPONENTS PLOT (RDR) =====================
    % ============================================================
    fprintf('\n--- Plotting ALL COMPONENTS MSA scatter (RDR) ---\n');
    sks_plot_AllComp_MSA_RDR(eqNumberLIST, pwd, analysisTypeFolder, isConvertToSaKircher, formatMode);

    % ============================================================
    % ========== 2) CONTROL COMPONENTS PLOT (RDR) ==================
    % ============================================================
    fprintf('\n--- Plotting CONTROL COMPONENTS MSA scatter (RDR) ---\n');
    sks_plot_ControlComp_MSA_RDR(eqNumberLIST, pwd, analysisTypeFolder, isConvertToSaKircher, formatMode);
end

cd(startDir);
fprintf('\nDone (RDR-MSA).\n');

end


% ========================================================================
% ===== Helper: load MAX STORY residual drift ratio for one EQ folder ====
% ========================================================================
% Returns a vector (length numSaLevels) of the MAXIMUM (over all stories)
% |residual interstory drift ratio| (fraction, NOT percent), matched to
% saLevelForEachRun order. This mirrors how maxDriftRatioForFullStr gives
% one envelope MIDR value per run in the original collapse plotter — this
% is the residual-drift equivalent, taken across storyDriftRatioToSave
% (a per-story cell array), NOT roofDriftRatioToSave (which is a separate,
% roof-only quantity — see sks_IDR_RDR_PFA_MSA.m, where "RDR" = story-level
% and "RoofRDR" = roof-level are kept distinct). Entries that could not be
% found are NaN.

function rdrForEachRun = sks_loadMaxStoryRDR_forEQ(eqFolder, saLevelForEachRun, numSaLevels)

rdrForEachRun = nan(numSaLevels, 1);

saFolders = dir(fullfile(eqFolder, 'Sa_*'));
saFolders = saFolders([saFolders.isdir]);

if isempty(saFolders)
    warning('No Sa_* subfolders found in %s — cannot load RDR.', eqFolder);
    return;
end

saFolderValues = str2double(erase({saFolders.name}, 'Sa_'));
[saFolderValues, idxSort] = sort(saFolderValues);
saFolders = saFolders(idxSort);

for saIndex = 1:numSaLevels

    if saIndex > length(saFolders)
        continue;   % no matching folder (e.g. padded/extra stripe)
    end

    % Sanity check: folder's Sa value should match saLevelForEachRun(saIndex)
    targetSa = saLevelForEachRun(saIndex);
    folderSa = saFolderValues(saIndex);
    if targetSa > 0 && abs(folderSa - targetSa) > 0.02 * max(1, abs(targetSa))
        warning('Sa mismatch at index %d in %s: collapse-file Sa = %.4f, folder Sa = %.4f', ...
            saIndex, eqFolder, targetSa, folderSa);
    end

    reducedSenData = fullfile(eqFolder, saFolders(saIndex).name, 'DATA_reducedSensDataForThisSingleRun.mat');

    if exist(reducedSenData, 'file')
        edpData = load(reducedSenData, 'storyDriftRatioToSave');
        storyResidualAbs = cellfun(@(x) abs(x.Residual), edpData.storyDriftRatioToSave);
        rdrForEachRun(saIndex) = max(storyResidualAbs);
    end
end

end



% ========================================================================
% ===================== Helper 1: ALL COMPONENTS (RDR) ==================
% ========================================================================
function sks_plot_AllComp_MSA_RDR(eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, isConvertToSaKircher, formatMode)

baseDir = fixedOutputDirectory;
figure; hold on;

allRDR       = [];
allSaLevels  = [];
collapseSaVals = [];

periodUsedForScalingGroundMotions = NaN;

for eqInd = 1:length(eqNumberLIST)
    eqCompNumber = eqNumberLIST(eqInd);
    eqFolder = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqCompNumber));
    loadFile = fullfile(eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat');

    load(loadFile, 'periodUsedForScalingGroundMotions', 'saLevelForEachRun', ...
        'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', 'numSaLevels');

    numSaLevels = min(numSaLevels, length(saLevelForEachRun));
    % Force column orientation on everything — the .mat file may store
    % these as row vectors, and mixing row/column vectors across EQ
    % iterations causes a vertcat dimension-mismatch error below.
    saLevelForEachRun      = reshape(saLevelForEachRun(1:numSaLevels), [], 1);
    isCollapsedForEachRun  = reshape(isCollapsedForEachRun(1:numSaLevels), [], 1);
    isSingularForEachRun   = reshape(isSingularForEachRun(1:numSaLevels), [], 1);
    isNonConvForEachRun    = reshape(isNonConvForEachRun(1:numSaLevels), [], 1);

    % === Load matching RDR values from this EQ's Sa_* subfolders ===
    rdrForEachRun = sks_loadMaxStoryRDR_forEQ(eqFolder, saLevelForEachRun, numSaLevels);
    rdrForEachRun = reshape(rdrForEachRun, [], 1);

    % === Filter runs (identical rule to the MIDR plotter) ===
    validIdx = ~(isCollapsedForEachRun == 0 & (isSingularForEachRun | isNonConvForEachRun));
    rdr      = rdrForEachRun(validIdx);
    saLevels = saLevelForEachRun(validIdx);
    isCol    = isCollapsedForEachRun(validIdx);

    % === Separate non-collapse and collapse ===
    rdr_nonCollapse      = rdr(isCol == 0);
    saLevels_nonCollapse = saLevels(isCol == 0);
    saLevels_Collapse    = saLevels(isCol == 1);

    collapseSaVals = [collapseSaVals; saLevels_Collapse(:)];

    % === Append to global arrays (drop NaN RDR entries) ===
    keepFinite = ~isnan(rdr_nonCollapse);
    rdrToAppend      = rdr_nonCollapse(keepFinite);
    saLevelsToAppend = saLevels_nonCollapse(keepFinite);
    allRDR      = [allRDR; rdrToAppend(:)];
    allSaLevels = [allSaLevels; saLevelsToAppend(:)];
end

% === Sort combined data by Sa for MSA stripe ===
[allSaLevels, idx] = sort(allSaLevels);
allRDR = allRDR(idx);

plot(allRDR, allSaLevels, 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'LineStyle', 'none');

% === Axis labels ===
if isConvertToSaKircher == 0
    temp = sprintf('$Sa_{geoM}(T=%.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
else
    DefineSaKircherOverSaGeoMeanValues
    temp = axisLabelForSaKircher;
end
xlabel('$\mathrm{Residual\ Drift\ Ratio}$', 'Interpreter', 'latex');
ylabel(temp, 'Interpreter', 'latex');

% === Y axis limits ===
allSaForAxis = [allSaLevels; collapseSaVals];
maxYOnAxis = max(allSaForAxis);
ylim([0, maxYOnAxis * 1.1]);

% ---- Base width for stacking spacing: derived from the RDR data itself
%      (no RDR collapse threshold exists, unlike the MIDR plot) ----
if isempty(allRDR) || all(isnan(allRDR))
    baseWidth = 0.01;
else
    baseWidth = max(allRDR);
end
if baseWidth <= 0
    baseWidth = 0.01;
end

dx = 0.05 * baseWidth;   % stacking spacing for collapse dots

% ---- Count collapses per Sa stripe ----
if ~isempty(collapseSaVals)
    [~, ~, idxU] = unique(collapseSaVals);
    counts = accumarray(idxU, 1);
    maxStack = max(counts);
else
    maxStack = 0;
end

% ---- Compute right boundary & set xlim ----
xRightLimit = baseWidth + maxStack * dx;
xlim([0, xRightLimit * 1.15]);

% ---- (No RDR collapse-threshold line — none is defined. If you define
%       one, e.g. rdrCollapseThreshold, uncomment: ----
% xline(rdrCollapseThreshold, '--', 'LineWidth', 1.2, 'Color', 'k');

yticks(0:0.5:max(ylim));

% === Collapse dots stacked from right edge (Baker 2015 style) ===
ax = gca;
xRight = ax.XLim(2);
uniqueSaVals = unique(collapseSaVals);
tol = 1e-6;

for k = 1:length(uniqueSaVals)
    currentSa = uniqueSaVals(k);
    numOfCollapses = sum(abs(collapseSaVals - currentSa) < tol);

    if numOfCollapses > 0
        xDots = xRight - (0:numOfCollapses-1) * dx;
        yDots = currentSa * ones(size(xDots));
        plot(xDots, yDots, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'LineStyle', 'none');
    end
end

box on;
grid on;

% === Legend (Baker-style) — ALL COMPONENTS ===
h1_all = plot(nan, nan, 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'LineStyle', 'none');
h2_all = plot(nan, nan, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'LineStyle', 'none');
legend([h1_all h2_all], {'no-collapse', 'collapse'}, 'Location', 'southeast', 'FontSize', 14);
legend boxoff

% === Save ===
saveDir = fullfile(baseDir, analysisTypeFolder);
if isConvertToSaKircher == 0
    exportName = fullfile(saveDir, 'CollapseMSA_AllComp_RDR_SaGeoMean');
else
    exportName = fullfile(saveDir, 'CollapseMSA_AllComp_RDR_SaATC63');
end

sks_figureFormat(formatMode);
sks_figureExport(exportName);

end


% ========================================================================
% =================== Helper 2: CONTROL COMPONENTS (RDR) ================
% ========================================================================
function sks_plot_ControlComp_MSA_RDR(eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, isConvertToSaKircher, formatMode)

baseDir = fixedOutputDirectory;
figure; hold on;

allRDR_control = [];
allSa_control  = [];
collapseSaVals_control = [];

periodUsedForScalingGroundMotions = NaN;

for eqNum = 1:2:length(eqNumberLIST)
    eqComp1 = eqNumberLIST(eqNum);
    eqComp2 = eqNumberLIST(eqNum+1);

    % --- Component 1: collapse data ---
    eqFolder1 = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqComp1));
    loadFile1 = fullfile(eqFolder1, 'DATA_CollapseResultsForThisSingleEQ.mat');
    load(loadFile1, 'periodUsedForScalingGroundMotions', 'saLevelForEachRun', ...
        'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', 'numSaLevels');

    maxNumRuns1 = min(numSaLevels, length(saLevelForEachRun));
    % Force column orientation (see note in sks_plot_AllComp_MSA_RDR).
    sa1   = reshape(saLevelForEachRun(1:maxNumRuns1), [], 1);
    col1  = reshape(isCollapsedForEachRun(1:maxNumRuns1), [], 1);
    sing1 = reshape(isSingularForEachRun(1:maxNumRuns1), [], 1);
    nonc1 = reshape(isNonConvForEachRun(1:maxNumRuns1), [], 1);
    rdr1  = reshape(sks_loadMaxStoryRDR_forEQ(eqFolder1, sa1, maxNumRuns1), [], 1);

    % --- Component 2: collapse data ---
    eqFolder2 = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqComp2));
    loadFile2 = fullfile(eqFolder2, 'DATA_CollapseResultsForThisSingleEQ.mat');
    load(loadFile2, 'saLevelForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', 'numSaLevels');

    maxNumRuns2 = min(numSaLevels, length(saLevelForEachRun));
    sa2   = reshape(saLevelForEachRun(1:maxNumRuns2), [], 1);
    col2  = reshape(isCollapsedForEachRun(1:maxNumRuns2), [], 1);
    sing2 = reshape(isSingularForEachRun(1:maxNumRuns2), [], 1);
    nonc2 = reshape(isNonConvForEachRun(1:maxNumRuns2), [], 1);
    rdr2  = reshape(sks_loadMaxStoryRDR_forEQ(eqFolder2, sa2, maxNumRuns2), [], 1);

    % === Remove padding zeros ===
    valid1 = (sa1 > 0);
    valid2 = (sa2 > 0);

    sa1 = sa1(valid1); col1 = col1(valid1); sing1 = sing1(valid1); nonc1 = nonc1(valid1); rdr1 = rdr1(valid1);
    sa2 = sa2(valid2); col2 = col2(valid2); sing2 = sing2(valid2); nonc2 = nonc2(valid2); rdr2 = rdr2(valid2);

    % === Filter runs (same rule as before) ===
    validRun1 = ~(col1 == 0 & (sing1 | nonc1));
    validRun2 = ~(col2 == 0 & (sing2 | nonc2));

    sa1 = sa1(validRun1); col1 = col1(validRun1); rdr1 = rdr1(validRun1);
    sa2 = sa2(validRun2); col2 = col2(validRun2); rdr2 = rdr2(validRun2);

    if length(sa1) ~= length(sa2)
        error('Stripe length mismatch after filtering between EQ_%d and EQ_%d', eqComp1, eqComp2);
    end

    % === CONTROL COMPONENT LOGIC (same as MIDR version): ===
    %   collapse flag = worse of the two components
    %   RDR = max residual drift ratio of the two components (governing)
    sa_control   = sa1;
    col_control  = max(col1, col2);
    rdr_control  = max(rdr1, rdr2);

    rdr_nonCollapse = rdr_control(col_control == 0);
    sa_nonCollapse  = sa_control(col_control == 0);
    sa_Collapse     = sa_control(col_control == 1);

    collapseSaVals_control = [collapseSaVals_control; sa_Collapse(:)];

    keepFinite = ~isnan(rdr_nonCollapse);
    rdrToAppend = rdr_nonCollapse(keepFinite);
    saToAppend  = sa_nonCollapse(keepFinite);
    allRDR_control = [allRDR_control; rdrToAppend(:)];
    allSa_control  = [allSa_control; saToAppend(:)];
end

% === Sort combined data ===
[allSa_control, idx] = sort(allSa_control);
allRDR_control = allRDR_control(idx);

plot(allRDR_control, allSa_control, 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'LineStyle', 'none');

% === Axis labels ===
if isConvertToSaKircher == 0
    temp = sprintf('$Sa_{geoM}(T=%.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
else
    DefineSaKircherOverSaGeoMeanValues
    temp = axisLabelForSaKircher;
end
xlabel('$\mathrm{Residual\ Drift\ Ratio}$', 'Interpreter', 'latex');
ylabel(temp, 'Interpreter', 'latex');

% === Y axis limits ===
allSaForAxis_control = [allSa_control; collapseSaVals_control];
maxYOnAxis_control = max(allSaForAxis_control);
ylim([0, maxYOnAxis_control * 1.1]);

if isempty(allRDR_control) || all(isnan(allRDR_control))
    baseWidth = 0.01;
else
    baseWidth = max(allRDR_control);
end
if baseWidth <= 0
    baseWidth = 0.01;
end

dx = 0.05 * baseWidth;

if ~isempty(collapseSaVals_control)
    [~, ~, idxU] = unique(collapseSaVals_control);
    counts = accumarray(idxU, 1);
    maxStack = max(counts);
else
    maxStack = 0;
end

xRightLimit = baseWidth + maxStack * dx;
xlim([0, xRightLimit * 1.15]);

yticks(0:0.5:max(ylim));

ax = gca;
xRight = ax.XLim(2);
uniqueSaVals = unique(collapseSaVals_control);
tol = 1e-6;

for k = 1:length(uniqueSaVals)
    currentSa = uniqueSaVals(k);
    numOfCollapses = sum(abs(collapseSaVals_control - currentSa) < tol);

    if numOfCollapses > 0
        xDots = xRight - (0:numOfCollapses-1) * dx;
        yDots = currentSa * ones(size(xDots));
        plot(xDots, yDots, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'LineStyle', 'none');
    end
end

grid on;

h1_ctrl = plot(nan, nan, 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'LineStyle', 'none');
h2_ctrl = plot(nan, nan, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'LineStyle', 'none');
legend([h1_ctrl h2_ctrl], {'no-collapse', 'collapse'}, 'Location', 'southeast', 'FontSize', 14);
legend boxoff

% === Save ===
saveDir = fullfile(baseDir, analysisTypeFolder);
if isConvertToSaKircher == 0
    exportName = fullfile(saveDir, 'CollapseMSA_ControlComp_RDR_SaGeoMean');
else
    exportName = fullfile(saveDir, 'CollapseMSA_ControlComp_RDR_SaATC63');
end

sks_figureFormat(formatMode);
sks_figureExport(exportName);

end
