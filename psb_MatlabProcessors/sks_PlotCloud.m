% -------------------
% Procedure: sks_PlotCloud.m
% Cloud analysis figures for MIDR, RDR and PFA (axis labels follow the IDA/MSA plots; no titles):
%   CloudScatter_<demand>_<setName> : log-log cloud of EDP (x) vs Sa (y), like the IDA/MSA response plots:
%                                     non-collapse runs, collapse cases, fitted ln(EDP) = ln(a) + b ln(Sa),
%                                     +/- 1 beta band, limit-state levels as vertical lines
%   CloudFragility_<demand>_<setName>: Pr[LS >= ls_i | IM = im] for each limit state, like the IDA/MSA fragility plots
%                                     (solid: RTR Var., dashed: RTR + MDL + TD + DR), plus Pr[collapse] when fitted
%
% Reads : Output/<analysisType>/DATA_CloudFragility_<setName>.mat (written by sks_FitCloudFragility.m)
% Writes: figures in Output/<analysisType>/ via sks_figureFormat + sks_figureExport (same as the MSA CDF plots)
%
% All figure text is LaTeX, because sks_figureFormat sets 'Interpreter' = 'latex' for labels and legends.
% Must be called from psb_MatlabProcessors.
% Author: Shivakumar K S, IIT Madras
% Date:   09-Nov-2026
% -------------------
function sks_PlotCloud(cloudInputs)

analysisTypeLIST    = cloudInputs.analysisTypeLIST;
eqListForCloud_Name = cloudInputs.eqListForCloud_Name;
formatMode          = cloudInputs.formatMode;

demandNameList   = {'MIDR', 'RDR', 'PFA'};
demandAxisLabels = {'$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$', ...            % same strings as the IDA/MSA response plots
                    '$\mathrm{Max\ Interstory\ Residual\ Drift\ Ratio\ (\%)}$', ...
                    '$\mathrm{Peak\ Floor\ Acceleration\ (g)}$'};
demandPlotFactorList = [100, 100, 1];                                                 % drift ratios plotted in %, PFA in g

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

    % Sa axis labels in the same form as the IDA/MSA plots
    if strcmp(cloudFragility.imType, 'geoMean')
        saSubscript = 'geoM';
    else
        saSubscript = 'comp';
    end
    saAxisLabelForResponse = sprintf('$\\mathrm{Sa}_{\\mathrm{%s}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', ...
        saSubscript, cloudFragility.periodUsedForScalingGroundMotions);
    imAxisLabelForFragility = sprintf('${im} \\equiv \\mathrm{Sa}_{\\mathrm{%s}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', ...
        saSubscript, cloudFragility.periodUsedForScalingGroundMotions);
    fragilityAxisLabel = '$\mathrm{Pr}[\mathrm{LS} \ge ls_i \mid \mathrm{IM} = im]$';

    for demandIndex = 1:numel(demandNameList)
        demandName          = demandNameList{demandIndex};
        demandPlotFactor    = demandPlotFactorList(demandIndex);
        demandFit           = cloudFragility.(demandName);
        limitStateLevels    = demandFit.limitStateLevels;
        limitStateLabels    = demandFit.limitStateLabels;
        numberOfLimitStates = numel(limitStateLevels);
        limitStateColorOrder = [0.00 0.00 1.00;   % blue    - level 1 (IO / DS1)   same order as the IDA/MSA plots
                                1.00 0.00 1.00;   % magenta - level 2 (LS / DS2)
                                0.00 0.00 0.00;   % black   - level 3 (CP / DS3)
                                1.00 0.00 0.00];  % red     - level 4 (Coll / DS4)
        limitStateColors     = limitStateColorOrder(mod((1:numberOfLimitStates) - 1, size(limitStateColorOrder, 1)) + 1, :);
        isRegressionFitted  = isfinite(demandFit.b);

        % ---------------- Cloud scatter: EDP (x) vs Sa (y), log-log ----------------
        figure; hold on; box on; grid on;
        set(gca, 'XScale', 'log', 'YScale', 'log');
        legendHandles = []; legendEntries = {};

        legendHandles(end+1) = plot(demandFit.demandOfPoints * demandPlotFactor, demandFit.saOfPoints, 'o', ...
            'Color', [0.4 0.4 0.4], 'MarkerFaceColor', 'w'); %#ok<AGROW>
        legendEntries{end+1} = sprintf('no-collapse (n = %d)', demandFit.numberOfPoints); %#ok<AGROW>

        if collapseFit.numberOfCollapseCases > 0
            collapseMarkerDemand = 1.5 * max([limitStateLevels(:); demandFit.demandOfPoints(:)]);   % drawn to the right of all levels
            legendHandles(end+1) = plot(collapseMarkerDemand * demandPlotFactor * ones(size(collapseFit.saOfCollapseCases)), ...
                collapseFit.saOfCollapseCases, 'rx', 'LineWidth', 1.5, 'MarkerSize', 8); %#ok<AGROW>
            legendEntries{end+1} = sprintf('collapse (n = %d)', collapseFit.numberOfCollapseCases); %#ok<AGROW>
        end

        if isRegressionFitted
            saForFittedLine     = logspace(log10(0.8 * min(demandFit.saOfPoints)), log10(1.25 * max(demandFit.saOfPoints)), 100);
            demandForFittedLine = demandFit.a * saForFittedLine.^demandFit.b;
            legendHandles(end+1) = plot(demandForFittedLine * demandPlotFactor, saForFittedLine, 'k-', 'LineWidth', 1.5); %#ok<AGROW>
            legendEntries{end+1} = sprintf('$\\ln(\\mathrm{EDP}) = %.2f + %.2f \\ln(\\mathrm{Sa})$, $R^2$ = %.2f', ...
                demandFit.lnA, demandFit.b, demandFit.rSquared); %#ok<AGROW>
            legendHandles(end+1) = plot(demandForFittedLine * exp(demandFit.betaEdpGivenSa) * demandPlotFactor, saForFittedLine, 'k--'); %#ok<AGROW>
            plot(demandForFittedLine * exp(-demandFit.betaEdpGivenSa) * demandPlotFactor, saForFittedLine, 'k--');
            legendEntries{end+1} = sprintf('$\\pm 1\\beta$ ($\\beta$ = %.2f)', demandFit.betaEdpGivenSa); %#ok<AGROW>
        end

        for limitStateIndex = 1:numberOfLimitStates
            xline(limitStateLevels(limitStateIndex) * demandPlotFactor, ':', limitStateLabels{limitStateIndex}, ...
                'Color', limitStateColors(limitStateIndex, :), 'LineWidth', 1.2, ...
                'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
        end

        % x range: always show every limit-state level (and the collapse markers) with some margin
        demandValuesToShow = [limitStateLevels(:); demandFit.demandOfPoints(:)];
        if collapseFit.numberOfCollapseCases > 0
            demandValuesToShow = [demandValuesToShow; collapseMarkerDemand];
        end
        xAxisLimits = [0.7 * min(demandValuesToShow), 1.3 * max(demandValuesToShow)] * demandPlotFactor;
        xlim(xAxisLimits);

        % x ticks as plain numbers: the limit-state levels plus the powers of 10 inside the range (e.g. MIDR 1 2 4 8, PFA 0.2 0.5 1 2)
        powersOfTenInRange = 10.^(floor(log10(xAxisLimits(1))):ceil(log10(xAxisLimits(2))));
        xTickValues        = unique([limitStateLevels(:) * demandPlotFactor; powersOfTenInRange(:)]);
        xTickValues        = xTickValues(xTickValues >= xAxisLimits(1) & xTickValues <= xAxisLimits(2));
        xticks(xTickValues);
        xticklabels(arrayfun(@(tickValue) sprintf('%g', tickValue), xTickValues, 'UniformOutput', false));

        xlabel(demandAxisLabels{demandIndex}, 'Interpreter', 'latex');
        ylabel(saAxisLabelForResponse, 'Interpreter', 'latex');
        legend(legendHandles, legendEntries, 'Location', 'southeast');

        sks_figureFormat(formatMode);
        sks_figureExport(fullfile(analysisTypeFolderPath, sprintf('CloudScatter_%s_%s', demandName, eqListForCloud_Name)));
        close(gcf);

        % ---------------- Fragility curves: Pr[LS >= ls_i | IM = im] ----------------
        if ~isRegressionFitted || demandFit.b <= 0
            fprintf('CLOUD %s: no fragility figure (regression not available).\n', demandName);
            continue;
        end
        figure; hold on; box on; grid on;
        legendHandles = []; legendEntries = {};
        for limitStateIndex = 1:numberOfLimitStates
            legendHandles(end+1) = plot(saGridForPlot, demandFit.fragilityCurve(:, limitStateIndex), '-', ...
                'Color', limitStateColors(limitStateIndex, :), 'LineWidth', 1.8); %#ok<AGROW>
            legendEntries{end+1} = sprintf('%s: median %.2f g, $\\beta$ = %.2f', limitStateLabels{limitStateIndex}, ...
                demandFit.medianSaNoCollapse(limitStateIndex), demandFit.betaRecordToRecord(limitStateIndex)); %#ok<AGROW>
            plot(saGridForPlot, demandFit.fragilityCurveWithTotalBeta(:, limitStateIndex), '--', ...
                'Color', limitStateColors(limitStateIndex, :), 'LineWidth', 1.0);
        end
        if collapseFit.isFitted
            legendHandles(end+1) = plot(saGridForPlot, collapseFit.probabilityOfCollapse, '-.', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5); %#ok<AGROW>   % grey: distinct from CP (black) and Coll (red)
            legendEntries{end+1} = sprintf('$\\mathrm{Pr}[\\mathrm{collapse}]$, logistic: median %.2f g', collapseFit.medianSaCollapse); %#ok<AGROW>
        end
        % line-style key, worded as in the IDA/MSA CDF plots
        legendHandles(end+1) = plot(nan, nan, 'k-',  'LineWidth', 1.8); %#ok<AGROW>
        legendEntries{end+1} = '(RTR Var.)'; %#ok<AGROW>
        legendHandles(end+1) = plot(nan, nan, 'k--', 'LineWidth', 1.0); %#ok<AGROW>
        legendEntries{end+1} = '(RTR + MDL + TD + DR)'; %#ok<AGROW>

        ylim([0 1]);
        xlabel(imAxisLabelForFragility, 'Interpreter', 'latex');
        ylabel(fragilityAxisLabel, 'Interpreter', 'latex');
        legend(legendHandles, legendEntries, 'Location', 'southeast');

        sks_figureFormat(formatMode);
        sks_figureExport(fullfile(analysisTypeFolderPath, sprintf('CloudFragility_%s_%s', demandName, eqListForCloud_Name)));
        close(gcf);
    end
end

cd(startDir);
disp('CLOUD plots - DONE')
end
