% -------------------
% Procedure: sks_PlotCloud.m
% Cloud analysis figures for MIDR, RDR and PFA:
%   CloudScatter_<demand>_<setName> : ln-ln scatter of Sa vs EDP (non-collapse runs), fitted line ln(EDP) = ln(a) + b ln(Sa),
%                                     +/- 1 beta lines, limit-state levels, collapse cases marked at the top
%   CloudFragility_<demand>_<setName>: P(EDP > C_LS | Sa) for each limit state (solid: record-to-record beta,
%                                     dashed: with modelling/design/test-data sigmas), plus P(C|Sa) when fitted
%
% Reads : Output/<analysisType>/DATA_CloudFragility_<setName>.mat (written by sks_FitCloudFragility.m)
% Writes: figures in Output/<analysisType>/ via sks_figureFormat + sks_figureExport (same as the MSA CDF plots)
%
% Must be called from psb_MatlabProcessors.
% Author: Shivakumar K S, IIT Madras
% Date:   09-Nov-2026
% -------------------
function sks_PlotCloud(cloudInputs)

analysisTypeLIST    = cloudInputs.analysisTypeLIST;
eqListForCloud_Name = cloudInputs.eqListForCloud_Name;
formatMode          = cloudInputs.formatMode;

demandNameList   = {'MIDR', 'RDR', 'PFA'};
demandAxisLabels = {'Maximum interstory drift ratio, MIDR', 'Maximum residual drift ratio, RDR', 'Peak floor acceleration, PFA [g]'};

startDir             = pwd;
fixedOutputDirectory = fullfile(startDir, '..', 'Output');

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType           = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolderPath = fullfile(fixedOutputDirectory, analysisType);
    fileNameToLoad         = fullfile(analysisTypeFolderPath, sprintf('DATA_CloudFragility_%s.mat', eqListForCloud_Name));
    if ~isfile(fileNameToLoad)
        error('sksCode:cloudFragility', 'CLOUD: %s not found; run sks_FitCloudFragility first.', fileNameToLoad);
    end
    loadedFragilityData = load(fileNameToLoad, 'cloudFragility');
    cloudFragility      = loadedFragilityData.cloudFragility;
    collapseFit         = cloudFragility.collapseFit;
    saGridForPlot       = cloudFragility.saGridForPlot;
    % Figure text must be valid LaTeX: sks_figureFormat sets 'Interpreter' = 'latex' for labels, titles and legends
    saAxisLabel         = sprintf('$S_a$ %s($T_1$ = %.2f s) [g]', cloudFragility.imType, cloudFragility.periodUsedForScalingGroundMotions);
    setNameForFigures   = strrep(eqListForCloud_Name, '_', '\_');

    for demandIndex = 1:numel(demandNameList)
        demandName          = demandNameList{demandIndex};
        demandFit           = cloudFragility.(demandName);
        limitStateLevels    = demandFit.limitStateLevels;
        limitStateLabels    = demandFit.limitStateLabels;
        numberOfLimitStates = numel(limitStateLevels);
        limitStateColors    = lines(numberOfLimitStates);
        isRegressionFitted  = isfinite(demandFit.b);

        % ---------------- Cloud scatter ----------------
        figure; hold on; box on;
        set(gca, 'XScale', 'log', 'YScale', 'log');
        legendHandles = []; legendEntries = {};

        legendHandles(end+1) = plot(demandFit.saOfPoints, demandFit.demandOfPoints, 'o', 'Color', [0.4 0.4 0.4], 'MarkerFaceColor', 'w'); %#ok<AGROW>
        legendEntries{end+1} = sprintf('Non-collapse runs (n = %d)', demandFit.numberOfPoints); %#ok<AGROW>

        if collapseFit.numberOfCollapseCases > 0
            collapseMarkerLevel = 1.5 * max([limitStateLevels(:); demandFit.demandOfPoints(:)]);
            legendHandles(end+1) = plot(collapseFit.saOfCollapseCases, collapseMarkerLevel * ones(size(collapseFit.saOfCollapseCases)), ...
                'rx', 'LineWidth', 1.5, 'MarkerSize', 8); %#ok<AGROW>
            legendEntries{end+1} = sprintf('Collapse cases (n = %d)', collapseFit.numberOfCollapseCases); %#ok<AGROW>
        end

        if isRegressionFitted
            saForFittedLine     = logspace(log10(0.8 * min(demandFit.saOfPoints)), log10(1.25 * max(demandFit.saOfPoints)), 100);
            demandForFittedLine = demandFit.a * saForFittedLine.^demandFit.b;
            legendHandles(end+1) = plot(saForFittedLine, demandForFittedLine, 'k-', 'LineWidth', 1.5); %#ok<AGROW>
            legendEntries{end+1} = sprintf('$\\ln(EDP) = %.2f + %.2f \\ln(S_a)$, $R^2$ = %.2f', demandFit.lnA, demandFit.b, demandFit.rSquared); %#ok<AGROW>
            legendHandles(end+1) = plot(saForFittedLine, demandForFittedLine * exp(demandFit.betaEdpGivenSa), 'k--'); %#ok<AGROW>
            plot(saForFittedLine, demandForFittedLine * exp(-demandFit.betaEdpGivenSa), 'k--');
            legendEntries{end+1} = sprintf('$\\pm 1\\beta$ ($\\beta$ = %.2f)', demandFit.betaEdpGivenSa); %#ok<AGROW>
        end

        for limitStateIndex = 1:numberOfLimitStates
            yline(limitStateLevels(limitStateIndex), ':', limitStateLabels{limitStateIndex}, ...
                'Color', limitStateColors(limitStateIndex, :), 'LineWidth', 1.2, 'LabelHorizontalAlignment', 'left');
        end

        xlabel(saAxisLabel);
        ylabel(demandAxisLabels{demandIndex});
        title(sprintf('Cloud analysis: %s (%s)', demandName, setNameForFigures));
        legend(legendHandles, legendEntries, 'Location', 'northwest');

        sks_figureFormat(formatMode);
        sks_figureExport(fullfile(analysisTypeFolderPath, sprintf('CloudScatter_%s_%s', demandName, eqListForCloud_Name)));
        close(gcf);

        % ---------------- Fragility curves ----------------
        if ~isRegressionFitted || demandFit.b <= 0
            fprintf('CLOUD %s: no fragility figure (regression not available).\n', demandName);
            continue;
        end
        figure; hold on; box on;
        legendHandles = []; legendEntries = {};
        for limitStateIndex = 1:numberOfLimitStates
            legendHandles(end+1) = plot(saGridForPlot, demandFit.fragilityCurve(:, limitStateIndex), '-', ...
                'Color', limitStateColors(limitStateIndex, :), 'LineWidth', 1.8); %#ok<AGROW>
            legendEntries{end+1} = sprintf('%s (C = %.3g): median %.2f g, $\\beta$ = %.2f', limitStateLabels{limitStateIndex}, ...
                limitStateLevels(limitStateIndex), demandFit.medianSaNoCollapse(limitStateIndex), demandFit.betaRecordToRecord(limitStateIndex)); %#ok<AGROW>
            plot(saGridForPlot, demandFit.fragilityCurveWithTotalBeta(:, limitStateIndex), '--', ...
                'Color', limitStateColors(limitStateIndex, :), 'LineWidth', 1.0);
        end
        if collapseFit.isFitted
            legendHandles(end+1) = plot(saGridForPlot, collapseFit.probabilityOfCollapse, 'k-.', 'LineWidth', 1.5); %#ok<AGROW>
            legendEntries{end+1} = sprintf('$P(C \\mid S_a)$, logistic: median %.2f g', collapseFit.medianSaCollapse); %#ok<AGROW>
        end
        ylim([0 1]);
        xlabel(saAxisLabel);
        ylabel(sprintf('$P(%s > C \\mid S_a)$', demandName));
        title(sprintf('Cloud fragility: %s (%s), solid: $\\beta_{RTR}$, dashed: $\\beta_{TOT}$', demandName, setNameForFigures));
        legend(legendHandles, legendEntries, 'Location', 'southeast');

        sks_figureFormat(formatMode);
        sks_figureExport(fullfile(analysisTypeFolderPath, sprintf('CloudFragility_%s_%s', demandName, eqListForCloud_Name)));
        close(gcf);
    end
end

cd(startDir);
disp('CLOUD plots - DONE')
end
