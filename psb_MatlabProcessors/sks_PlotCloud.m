% -------------------
% Procedure: sks_PlotCloud.m
% Cloud analysis figures for MIDR, RDR and PFA, for both component cases (ControlComp and AllComp, as in IDA/MSA);
% axis labels follow the IDA/MSA plots; no titles:
% File names as in IDA/MSA, with IDA/MSA replaced by CLOUD:
%   CollapseCLOUD_<ControlComp|AllComp>_SaGeoMean[_RDR|_PFA]   (like CollapseMSA_<comp>_SaGeoMean...):
%       log-log cloud of EDP (x) vs Sa (y): non-collapse points, collapse cases, fitted ln(EDP) = ln(a) + b ln(Sa),
%       16th-84th percentile band (no limit-state lines; no suffix = MIDR)
%   CollapseCDF_<ControlComp|AllComp>_SaGeoMean_CLOUD_<MIDR|RDR|PFA>   (like CollapseCDF_<comp>_SaGeoMean_MSA_<...>):
%       Pr[LS >= ls_i | IM = im] for each limit state (solid: RTR Var., dashed: RTR + MDL + TD + DR), plus Pr[collapse] when fitted
%
% Reads : Output/<analysisType>/CLOUD/DATA_FragilityParams_SaGeoMean_<setName>.mat (written by sks_FitCloudFragility.m)
% Writes: figures in Output/<analysisType>/CLOUD/ via sks_figureFormat + sks_figureExport (same as the MSA CDF plots)
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
responseFigureSuffixList = {'', '_RDR', '_PFA'};                                      % CollapseCLOUD_<comp>_SaGeoMean[...] (no suffix = MIDR, as in MSA)

startDir             = pwd;
fixedOutputDirectory = fullfile(startDir, '..', 'Output');

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType           = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolderPath = fullfile(fixedOutputDirectory, analysisType, 'CLOUD');
    fileNameToLoad         = fullfile(analysisTypeFolderPath, sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', eqListForCloud_Name));
    if ~isfile(fileNameToLoad)
        error('sksCode:cloudFragility', 'CLOUD: %s not found; run the CLOUD fit (flag 4) first.', fileNameToLoad);
    end
    loadedFragilityData = load(fileNameToLoad);
    if ~isfield(loadedFragilityData, 'cloudFragility') || ~isfield(loadedFragilityData.cloudFragility, 'componentCaseList')
        error('sksCode:cloudFragilityNotCloud', ['CLOUD: %s does not hold CLOUD results (same file name as IDA/MSA; ' ...
            'the last analysis written was IDA/MSA). Rerun the CLOUD fit (flag 4).'], fileNameToLoad);
    end
    cloudFragility      = loadedFragilityData.cloudFragility;
    componentCaseList   = cloudFragility.componentCaseList;    % {'ControlComp', 'AllComp'}, as in the IDA/MSA plots
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

    % One scatter + one fragility figure per demand and component case
    numberOfFigureSets = numel(demandNameList) * numel(componentCaseList);
    for figureSetIndex = 1:numberOfFigureSets
        [demandIndex, componentCaseIndex] = ind2sub([numel(demandNameList), numel(componentCaseList)], figureSetIndex);
        componentCase       = componentCaseList{componentCaseIndex};
        collapseFit         = cloudFragility.(componentCase).collapseFit;
        demandName          = demandNameList{demandIndex};
        % For now only MIDR is plotted (scatter and fragility); RDR and PFA are still fitted and saved in the .mat file
        if ~strcmp(demandName, 'MIDR')
            continue;
        end
        demandPlotFactor    = demandPlotFactorList(demandIndex);
        demandFit           = cloudFragility.(componentCase).(demandName);
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
            'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'LineStyle', 'none'); %#ok<AGROW>   % same as MSA non-collapse
        legendEntries{end+1} = 'no-collapse';
        
        if collapseFit.numberOfCollapseCases > 0
            collapseMarkerDemand = 1.5 * max(demandFit.demandOfPoints(:));   % drawn to the right of the no-collapse points
            legendHandles(end+1) = plot(collapseMarkerDemand * demandPlotFactor * ones(size(collapseFit.saOfCollapseCases)), ...
                collapseFit.saOfCollapseCases, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'LineStyle', 'none'); %#ok<AGROW>   % same as MSA collapse
            legendEntries{end+1} = 'collapse';
           
        end

        % Sa range: the records and the collapse cases, with some margin
        saValuesToShow = demandFit.saOfPoints(:);
        if collapseFit.numberOfCollapseCases > 0
            saValuesToShow = [saValuesToShow; collapseFit.saOfCollapseCases(:)];
        end
        yAxisLimits = [0.7 * min(saValuesToShow), 1.3 * max(saValuesToShow)];

        if isRegressionFitted
            saForFittedLine     = logspace(log10(yAxisLimits(1)), log10(yAxisLimits(2)), 100);   % fit and +-1 beta lines span the full Sa axis
            demandForFittedLine = demandFit.a * saForFittedLine.^demandFit.b;
            legendHandles(end+1) = plot(demandForFittedLine * demandPlotFactor, saForFittedLine, 'k-', 'LineWidth', 1.5); %#ok<AGROW>
            legendEntries{end+1} = 'cloud regression'; %#ok<AGROW>   % wording as in Jalayer et al. (2017)
            % 16th-84th percentile band of EDP given Sa (lognormal: median x exp(-/+ beta)); same style as the IDR/RDR/PFA plots
            demandAt16thPercentile = demandForFittedLine * exp(-demandFit.betaEdpGivenSa) * demandPlotFactor;
            demandAt84thPercentile = demandForFittedLine * exp( demandFit.betaEdpGivenSa) * demandPlotFactor;
            percentileBand = fill([demandAt16thPercentile, fliplr(demandAt84thPercentile)], [saForFittedLine, fliplr(saForFittedLine)], ...
                [0.6 0.8 1], 'EdgeColor', 'none', 'FaceAlpha', 0.35);
            uistack(percentileBand, 'bottom');   % behind the points and the regression line
            legendHandles(end+1) = percentileBand; %#ok<AGROW>
            legendEntries{end+1} = '$16$--$84$\% band'; %#ok<AGROW>
        end

        % x range: the no-collapse points (and the collapse markers) with some margin
        demandValuesToShow = demandFit.demandOfPoints(:);
        if collapseFit.numberOfCollapseCases > 0
            demandValuesToShow = [demandValuesToShow; collapseMarkerDemand];
        end
        xAxisLimits = [0.7 * min(demandValuesToShow), 1.3 * max(demandValuesToShow)] * demandPlotFactor;
        xlim(xAxisLimits);

        % x ticks as plain numbers on a 1-2-5 sequence inside the x range (e.g. MIDR 0.5 1 2, PFA 0.2 0.5 1 2)
        decadesInXRange = 10.^(floor(log10(xAxisLimits(1))):ceil(log10(xAxisLimits(2))));
        xTickValues     = reshape([1; 2; 5] * decadesInXRange, [], 1);
        xTickValues     = xTickValues(xTickValues >= xAxisLimits(1) & xTickValues <= xAxisLimits(2));
        if numel(xTickValues) >= 2
            xticks(xTickValues);
            xticklabels(arrayfun(@(tickValue) sprintf('%g', tickValue), xTickValues, 'UniformOutput', false));
        end

        % y ticks (Sa) as plain numbers on a 1-2-5 sequence inside the y range (e.g. 0.1 0.2 0.5 1)
        ylim(yAxisLimits);
        decadesInYRange  = 10.^(floor(log10(yAxisLimits(1))):ceil(log10(yAxisLimits(2))));
        yTickValues      = reshape([1; 2; 5] * decadesInYRange, [], 1);
        yTickValues      = yTickValues(yTickValues >= yAxisLimits(1) & yTickValues <= yAxisLimits(2));
        if numel(yTickValues) >= 2
            yticks(yTickValues);
            yticklabels(arrayfun(@(tickValue) sprintf('%g', tickValue), yTickValues, 'UniformOutput', false));
        end

        xlabel(demandAxisLabels{demandIndex}, 'Interpreter', 'latex');
        ylabel(saAxisLabelForResponse, 'Interpreter', 'latex');
        scatterLegend = legend(legendHandles, legendEntries);

        sks_figureFormat(formatMode);
        scatterLegend.Location = 'northwest';   % after sks_figureFormat (it sets southeast); top-left is empty above the rising cloud
        sks_figureExport(fullfile(analysisTypeFolderPath, sprintf('CollapseCLOUD_%s_SaGeoMean%s', componentCase, responseFigureSuffixList{demandIndex})));
        close(gcf);

        % ---------------- Fragility curves: Pr[LS >= ls_i | IM = im] ----------------
        if ~isRegressionFitted || demandFit.b <= 0
            fprintf('CLOUD %s %s: no fragility figure (regression not available).\n', componentCase, demandName);
            continue;
        end
        figure; hold on;
        for limitStateIndex = 1:numberOfLimitStates
            plot(saGridForPlot, demandFit.fragilityCurve(:, limitStateIndex), '-', ...
                'Color', limitStateColors(limitStateIndex, :), 'LineWidth', 3.0);   % as the MSA fragility
            % Text annotation per limit state, as in sks_PlotCollapseCDF_MSA.m
            text(0.50, 0.35 - 0.08*(limitStateIndex - 1), ...
                sprintf('$$\\hat{\\theta}_{%s} = %5.2f\\,\\mathrm{g},\\ \\hat{\\beta}_{\\ln} = %5.2f$$', ...
                    limitStateLabels{limitStateIndex}, ...
                    round(demandFit.medianSaNoCollapse(limitStateIndex)*100)/100, ...
                    round(demandFit.betaRecordToRecord(limitStateIndex)*100)/100), ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'Interpreter', 'latex', 'FontSize', 12, ...
                'Color', limitStateColors(limitStateIndex, :));
            % plot(saGridForPlot, demandFit.fragilityCurveWithTotalBeta(:, limitStateIndex), '--', ...
                % 'Color', limitStateColors(limitStateIndex, :), 'LineWidth', 1.0);
        end
        if collapseFit.isFitted
            plot(saGridForPlot, collapseFit.probabilityOfCollapse, '-.', 'Color', [0.5 0.5 0.5], 'LineWidth', 2.0);   % grey: logistic Pr[collapse]
            text(0.50, 0.35 - 0.08*numberOfLimitStates, ...
                sprintf('$$\\hat{\\theta}_{C} = %5.2f\\,\\mathrm{g}$$ (logistic)', round(collapseFit.medianSaCollapse*100)/100), ...
                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                'Interpreter', 'latex', 'FontSize', 12, 'Color', [0.5 0.5 0.5]);
        end

        axis([0 max(saGridForPlot) 0.0 1.0]);
        box on;  grid on
        xlabel(imAxisLabelForFragility, 'Interpreter', 'latex');
        ylabel(fragilityAxisLabel, 'Interpreter', 'latex');

        sks_figureFormat(formatMode);
        sks_figureExport(fullfile(analysisTypeFolderPath, sprintf('CollapseCDF_%s_SaGeoMean_CLOUD_%s', componentCase, demandName)));
        close(gcf);
    end
end

cd(startDir);
disp('CLOUD plots - DONE')
end
