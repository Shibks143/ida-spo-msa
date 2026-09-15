% =========================================================================
% Procedure: sks_PlotRDR_EmpiricalCDFWithFits_MSA.m
% -------------------------------------------------------------------------
% Calculates and plots empirical data points and fitted lognormal fragility 
% curves for Residual Interstory Drift Ratio (RDR) exceeding a specified 
% threshold rdrThreshold (e.g., 0.005 for 0.5% residual drift).
%
% Uses maximum likelihood estimation (sks_Mle_MSA.m) to fit lognormal CDFs
% for both CONTROL COMPONENTS and ALL COMPONENTS.
%
% Shivakumar K S
% =========================================================================

function sks_PlotRDR_EmpiricalCDFWithFits_MSA(msaInputs, rdrThreshold)

if nargin < 2
    rdrThreshold = 0.01; % Default threshold: 1% RDR
end

analysisTypeLIST     = msaInputs.analysisTypeLIST;
eqNumberLIST         = msaInputs.eqNumberLIST;
isConvertToSaKircher = msaInputs.isConvertToSaKircher;

startDir = pwd;

% Plot formatting options
minValueForPlot = 0.0;
maxValueForPlot = 3.0;

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolder = sprintf('%s', analysisType);

    cd(startDir);
    cd ..;
    cd Output;
    fixedOutputDirectory = pwd;

    fprintf('\n=========================================\n');
    fprintf('Processing RDR Fragility for analysisType = %s\n', analysisTypeFolder);
    fprintf('RDR Limit State Threshold = %.4f (%.2f%%)\n', rdrThreshold, rdrThreshold * 100);
    fprintf('=========================================\n');

    % ============================================================
    % ========== 1) CONTROL COMPONENT (paired EQs) ================
    % ============================================================
    allSa_control = [];
    allExceeded_control = [];

    saStripeList = [];
    nPairsPerStripe = [];
    nExceededControl_perStripe = [];
    isStripeListInitialized = false;

    for eqNum = 1:2:length(eqNumberLIST)
        eqComp1 = eqNumberLIST(eqNum);
        eqComp2 = eqNumberLIST(eqNum+1);

        % Component 1
        eqFolder1 = fullfile(fixedOutputDirectory, analysisTypeFolder, sprintf('EQ_%d', eqComp1));
        load(fullfile(eqFolder1, 'DATA_CollapseResultsForThisSingleEQ.mat'), ...
            'saLevelForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', ...
            'isNonConvForEachRun', 'numSaLevels', 'periodUsedForScalingGroundMotions');

        maxNumRuns1 = min(numSaLevels, length(saLevelForEachRun));
        sa1   = reshape(saLevelForEachRun(1:maxNumRuns1), [], 1);
        col1  = reshape(isCollapsedForEachRun(1:maxNumRuns1), [], 1);
        sing1 = reshape(isSingularForEachRun(1:maxNumRuns1), [], 1);
        nonc1 = reshape(isNonConvForEachRun(1:maxNumRuns1), [], 1);
        rdr1  = reshape(sks_loadMaxStoryRDR_forEQ(eqFolder1, sa1, maxNumRuns1), [], 1);

        % Component 2
        eqFolder2 = fullfile(fixedOutputDirectory, analysisTypeFolder, sprintf('EQ_%d', eqComp2));
        load(fullfile(eqFolder2, 'DATA_CollapseResultsForThisSingleEQ.mat'), ...
            'saLevelForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', ...
            'isNonConvForEachRun', 'numSaLevels');

        maxNumRuns2 = min(numSaLevels, length(saLevelForEachRun));
        sa2   = reshape(saLevelForEachRun(1:maxNumRuns2), [], 1);
        col2  = reshape(isCollapsedForEachRun(1:maxNumRuns2), [], 1);
        sing2 = reshape(isSingularForEachRun(1:maxNumRuns2), [], 1);
        nonc2 = reshape(isNonConvForEachRun(1:maxNumRuns2), [], 1);
        rdr2  = reshape(sks_loadMaxStoryRDR_forEQ(eqFolder2, sa2, maxNumRuns2), [], 1);

        % Clean padded zero rows
        v1 = (sa1 > 0); sa1 = sa1(v1); col1 = col1(v1); sing1 = sing1(v1); nonc1 = nonc1(v1); rdr1 = rdr1(v1);
        v2 = (sa2 > 0); sa2 = sa2(v2); col2 = col2(v2); sing2 = sing2(v2); nonc2 = nonc2(v2); rdr2 = rdr2(v2);

        % Filter non-converged/singular non-collapse runs
        validRun1 = ~(col1 == 0 & (sing1 | nonc1));
        validRun2 = ~(col2 == 0 & (sing2 | nonc2));

        sa1 = sa1(validRun1); col1 = col1(validRun1); rdr1 = rdr1(validRun1);
        sa2 = sa2(validRun2); col2 = col2(validRun2); rdr2 = rdr2(validRun2);

        % Control Component Logic: Governing RDR is the max of the pair; collapsed runs automatically exceed threshold
        sa_control  = sa1;
        rdr_control = max(rdr1, rdr2);
        col_control = max(col1, col2);

        % Exceedance: either actual residual drift >= limit OR the run collapsed
        isExceeded_control = (rdr_control >= rdrThreshold) | (col_control == 1);

        if ~isStripeListInitialized
            saStripeList = sa_control(:);
            nPairsPerStripe = zeros(length(saStripeList), 1);
            nExceededControl_perStripe = zeros(length(saStripeList), 1);
            isStripeListInitialized = true;
        end

        for k = 1:length(sa_control)
            nPairsPerStripe(k) = nPairsPerStripe(k) + 1;
            nExceededControl_perStripe(k) = nExceededControl_perStripe(k) + isExceeded_control(k);
        end

        allSa_control       = [allSa_control; sa_control(:)];
        allExceeded_control = [allExceeded_control; isExceeded_control(:)];
    end

    fprintf('\n--- CONTROL COMPONENT RDR (>= %.2f%%) STRIPE SUMMARY ---\n', rdrThreshold*100);
    Tcontrol = table(saStripeList, nPairsPerStripe, nExceededControl_perStripe, nExceededControl_perStripe./nPairsPerStripe, ...
        'VariableNames', {'Sa', 'nPairs', 'nExceeded', 'P_Exceedance'});
    disp(Tcontrol);

    exportNameControl = sprintf('RDR_Fragility_ControlComp_Limit_%.4f', rdrThreshold);
    sks_plotMSAFragilityFromRuns(allSa_control, allExceeded_control, minValueForPlot, maxValueForPlot, ...
        exportNameControl, fixedOutputDirectory, analysisTypeFolder, periodUsedForScalingGroundMotions, ...
        isConvertToSaKircher, rdrThreshold);

    % ============================================================
    % ========== 2) ALL COMPONENTS (all EQ folders) ==============
    % ============================================================
    allSa_all = [];
    allExceeded_all = [];

    for eqNum = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqNum);
        eqFolder = fullfile(fixedOutputDirectory, analysisTypeFolder, sprintf('EQ_%d', eqNumber));

        load(fullfile(eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat'), ...
            'saLevelForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', ...
            'isNonConvForEachRun', 'numSaLevels', 'periodUsedForScalingGroundMotions');

        maxNumRuns = min(numSaLevels, length(saLevelForEachRun));
        sa   = reshape(saLevelForEachRun(1:maxNumRuns), [], 1);
        col  = reshape(isCollapsedForEachRun(1:maxNumRuns), [], 1);
        sing = reshape(isSingularForEachRun(1:maxNumRuns), [], 1);
        nonc = reshape(isNonConvForEachRun(1:maxNumRuns), [], 1);
        rdr  = reshape(sks_loadMaxStoryRDR_forEQ(eqFolder, sa, maxNumRuns), [], 1);

        valid = (sa > 0) & ~(col == 0 & (sing | nonc));
        sa = sa(valid); col = col(valid); rdr = rdr(valid);

        isExceeded = (rdr >= rdrThreshold) | (col == 1);

        allSa_all       = [allSa_all; sa(:)];
        allExceeded_all = [allExceeded_all; isExceeded(:)];
    end

    fprintf('\n--- ALL COMPONENTS RDR (>= %.2f%%) SUMMARY ---\n', rdrThreshold*100);
    exportNameAll = sprintf('RDR_Fragility_AllComp_Limit_%.4f', rdrThreshold);
    sks_plotMSAFragilityFromRuns(allSa_all, allExceeded_all, minValueForPlot, maxValueForPlot, ...
        exportNameAll, fixedOutputDirectory, analysisTypeFolder, periodUsedForScalingGroundMotions, ...
        isConvertToSaKircher, rdrThreshold);
end

cd(startDir);
fprintf('\nDone (RDR Fragility Fits).\n');

end


% ========================================================================
% Helper 1: Fit and Plot Fragility Function using sks_Mle_MSA
% ========================================================================
function sks_plotMSAFragilityFromRuns(allSa, allExceeded, minValueForPlot, maxValueForPlot, ...
    exportName, fixedOutputDirectory, analysisTypeFolder, periodUsedForScalingGroundMotions, ...
    isConvertToSaKircher, rdrThreshold)

tol = 1e-4;
allSa = round(allSa/tol)*tol;

saLevelList = unique(allSa);
numOfStripes = length(saLevelList);
numOfGroundMotions = zeros(numOfStripes, 1);
numOfExceedances   = zeros(numOfStripes, 1);

for i = 1:numOfStripes
    idx = (allSa == saLevelList(i));
    numOfGroundMotions(i) = sum(idx);
    numOfExceedances(i)   = sum(allExceeded(idx));
end

exceedanceProbability = numOfExceedances ./ numOfGroundMotions;

valid = (saLevelList > 0) & (numOfGroundMotions > 0);
saLevelList           = saLevelList(valid);
numOfGroundMotions    = numOfGroundMotions(valid);
numOfExceedances      = numOfExceedances(valid);
exceedanceProbability = exceedanceProbability(valid);

% MLE Fitting via sks_Mle_MSA.m
[theta_hat, beta_hat] = sks_Mle_MSA(saLevelList, numOfGroundMotions, numOfExceedances);
fprintf('Exceedance MLE Parameters: theta = %.3f g, beta = %.3f\n', theta_hat, beta_hat);

IM_vals = 0.01:0.01:10;
P_Exceedance = normcdf((log(IM_vals/theta_hat))/beta_hat);

% Plotting
figure;
plot(saLevelList, exceedanceProbability, 'bs', 'LineWidth', 2, 'MarkerSize', 8, ...
    'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'b');
hold on;
plot(IM_vals, P_Exceedance, 'b-', 'LineWidth', 3);

legend('Empirical Data', 'Lognormal Fit', 'Location', 'southeast', 'Interpreter', 'latex');

xlim([minValueForPlot maxValueForPlot]);
ylim([0 1]);

limitsOfAxes = [minValueForPlot maxValueForPlot 0 1];
XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
pos = [limitsOfAxes(1) + 0.65 * XdimOfAxis, limitsOfAxes(3) + 0.25 * YdimOfAxis];

text(pos(1), pos(2), ...
    {['$$\hat{\theta} = ' sprintf('%5.3f', theta_hat) '\,\mathrm{g}$$'], ...
    ['$$\hat{\beta}_{\mathrm{ln}} = ' sprintf('%5.3f', beta_hat) '$$']}, ... 
    'Interpreter', 'latex', 'FontWeight', 'bold', 'BackgroundColor', [0.9 0.9 0.9]);

box on; grid on;

if (isConvertToSaKircher == 0)
    tempLabel = sprintf('$Sa_{geoM}(T=%.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
else
    DefineSaKircherOverSaGeoMeanValues
    tempLabel = axisLabelForSaKircher;
end

xlabel(tempLabel, 'Interpreter', 'latex');
ylabel(sprintf('$$\\mathrm{Pr}[\\mathrm{RDR} \\ge %.2f\\%%]$$', rdrThreshold*100), 'Interpreter', 'latex');

sks_figureFormat('powerpoint');
fullExportPath = fullfile(fixedOutputDirectory, analysisTypeFolder, exportName);
sks_figureExport(fullExportPath);

end

% ========================================================================
% Helper: load MAX STORY residual drift ratio for one EQ folder
% ========================================================================
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
        continue;   % no matching folder
    end

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