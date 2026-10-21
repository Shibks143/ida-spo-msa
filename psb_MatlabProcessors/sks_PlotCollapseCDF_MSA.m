%
% Procedure: sks_PlotCollapseCDF_MSA.m
% -------------------
% MSA counterpart of sks_PlotCollapseCDF (IDA).
% Plots fragility CDFs for Collapse, MIDR, RDR, and PFA.
%
% cdfType = 'Collapse':
%   Reads collapseLevelForAllComp / collapseLevelForAllControlComp
%   from DATA_collapse_CollapseSaAndStats_<name>_SaGeoMean.mat.
%   Aggregates to stripe fractions → sks_Mle_MSA → MLE fragility curve.
%   Empirical points: nCollapse/nGM per stripe (same as
%   sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA).
%
% cdfType = 'MIDR' / 'RDR' / 'PFA':
%   Reads pre-fitted MLE params (thetaControl, betaControl, etc.) and
%   empirical stripe exceedance fractions (exceedanceProbControl, etc.)
%   from DATA_FragilityParams_SaGeoMean_<name>.mat built by
%   sks_ProcessFragilityParams_MSA.
%   Plots empirical stripe points + MLE normcdf curve per limit state.
%
% Variable names loaded from .mat files (confirmed from actual files):
%   Collapse .mat:
%     collapseLevelForAllComp(nRecords x 1)
%     collapseLevelForAllControlComp(nRecords x 1)
%     periodUsedForScalingGroundMotions
%   Fragility .mat:
%     midrLevels(4x1), midrLevelLabels(4x1 cell)
%     midrThetaControl(4x1), midrBetaControl(4x1)
%     midrThetaAllComp(4x1),  midrBetaAllComp(4x1)
%     midrStripeSaControl(13x1), midrStripeSaAllComp(13x1)
%     midrExceedanceProbControl(13x4), midrExceedanceProbAllComp(13x4)
%     midrNumGMsPerStripeControl(13x4), midrNumGMsPerStripeAllComp(13x4)
%     midrNumExceedancesPerStripeControl(13x4)
%     midrNumExceedancesPerStripeAllComp(13x4)
%     (same pattern for rdr* and pfa*)
%
% Author: Shivakumar KS, IIT Madras
% Created: Oct-2026, mirroring sks_PlotCollapseCDF (IDA)
% -------------------
function sks_PlotCollapseCDF_MSA(msaInputs)

cdfTypeList = {'Collapse', 'MIDR', 'RDR', 'PFA'};

for cdfIdx = 1:length(cdfTypeList)

    cdfType = cdfTypeList{cdfIdx};

    % Unpack inputs
    analysisTypeLIST           = msaInputs.analysisTypeLIST;
    isConvertToSaKircher       = msaInputs.isConvertToSaKircher;
    eqListForCollapseMSAs_Name = msaInputs.eqListForCollapseMSAs_Name;
    formatMode                 = msaInputs.formatMode;
    sigmaLnModeling            = msaInputs.sigmaLnModeling;
    sigmaLnDesignReq           = msaInputs.sigmaLnDesignReq;
    sigmaLnTestData            = msaInputs.sigmaLnTestData;

    % Plot options (mirror IDA defaults from sks_PlotCollapseCDF)
    plotCDFWithAdditionalUncertainty  = 0;
    addTextAnnotations                = 1;
    markerFaceColorForIndivColResults = 'w';
    minValueForPlot                   = 0.0;

    % One color per limit state — same order as IDA version
    colors = [0.00 0.00 1.00;   % blue     — level 1 (IO)
              1.00 0.00 1.00;   % magenta  — level 2 (LS)
              0.00 0.00 0.00;   % black    — level 3 (CP)
              1.00 0.00 0.00];  % red      — level 4 (Collapse)

    startDir = pwd;

    % ================================================================
    % Set demand-type parameters for this cdfType
    % ================================================================
    switch cdfType
        case 'Collapse'
            maxValueForPlot = 5.0;
            exportSuffix    = '';
        case 'MIDR'
            maxValueForPlot = 5.0;
            exportSuffix    = 'MIDR';
        case 'RDR'
            maxValueForPlot = 3.0;
            exportSuffix    = 'RDR';
        case 'PFA'
            maxValueForPlot = 3.0;
            exportSuffix    = 'PFA';
    end

    % ================================================================
    for analysisTypeIdx = 1:length(analysisTypeLIST)

        analysisType       = analysisTypeLIST{analysisTypeIdx};
        analysisTypeFolder = sprintf('%s', analysisType);

        % Navigate to Output
        cd(startDir);
        cd(fullfile('..', 'Output'));
        fixedOutputDirectory = pwd;

        % .mat file names — consistent with sks_ProcessFragilityParams_MSA
        if isConvertToSaKircher == 0
            collapseStatsFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', ...
                                            eqListForCollapseMSAs_Name);
            fragParamsFileName    = sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', ...
                                            eqListForCollapseMSAs_Name);
        else
            collapseStatsFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63.mat', ...
                                            eqListForCollapseMSAs_Name);
            fragParamsFileName    = sprintf('DATA_FragilityParams_SaATC63_%s.mat', ...
                                            eqListForCollapseMSAs_Name);
        end

        collapseStatsFilePath = fullfile(fixedOutputDirectory, analysisTypeFolder, collapseStatsFileName);
        fragParamsFilePath    = fullfile(fixedOutputDirectory, analysisTypeFolder, fragParamsFileName);

        % Period is always needed for axis label
        collapseStatsData = load(collapseStatsFilePath, 'periodUsedForScalingGroundMotions');
        periodUsedForScalingGroundMotions = collapseStatsData.periodUsedForScalingGroundMotions;

        % ================================================================
        % COLLAPSE CDF
        % Load collapseLevelForAllComp / collapseLevelForAllControlComp.
        % These are per-record collapse Sa values (one per EQ that collapsed).
        % Aggregate to stripe fractions → sks_Mle_MSA → MLE curve.
        % Mirrors exactly what sks_PlotCollapseEmpiricalCDFWithFits_proc_MSA
        % does: nCollapse/nGM per stripe, then MLE fit.
        % ================================================================
        if strcmp(cdfType, 'Collapse')

            collapseData = load(collapseStatsFilePath, ...
                'collapseLevelForAllComp', ...
                'collapseLevelForAllControlComp');

            collapseLevelForAllComp        = collapseData.collapseLevelForAllComp(:);
            collapseLevelForAllControlComp = collapseData.collapseLevelForAllControlComp(:);

            % ---- Plot loop: figIdx 1 = ControlComp, figIdx 2 = AllComp ----
            % Matches IDA version structure (sks_PlotCollapseCDF figIdx loop)
            for figIdx = 1:2

                if figIdx == 1
                    componentCaseLabel   = 'ControlComp';
                    collapseLevelPerRecord = collapseLevelForAllControlComp;
                else
                    componentCaseLabel   = 'AllComp';
                    collapseLevelPerRecord = collapseLevelForAllComp;
                end

                % Aggregate per-record collapse Sa values to stripe fractions.
                % collapseLevelPerRecord contains the Sa at collapse for each
                % record — these ARE the stripe Sa values for collapsed records.
                % To get nCollapse/nGM we need total nGM per stripe, which
                % requires loading the full stripe grid from fragility .mat.
                % Load stripe Sa grid from fragility .mat (same stripes as MIDR).
                fragDataForStripes = load(fragParamsFilePath, 'midrStripeSaControl', 'midrStripeSaAllComp', 'midrNumGMsPerStripeControl', 'midrNumGMsPerStripeAllComp');

                if figIdx == 1
                    stripeSaGrid        = fragDataForStripes.midrStripeSaControl(:);
                    numGMsPerStripeGrid = double(fragDataForStripes.midrNumGMsPerStripeControl(:, 1));
                else
                    stripeSaGrid        = fragDataForStripes.midrStripeSaAllComp(:);
                    numGMsPerStripeGrid = double(fragDataForStripes.midrNumGMsPerStripeAllComp(:, 1));
                end

                % Count collapses at each stripe
                roundingTolerance           = 1e-4;
                collapseLevelRounded        = round(collapseLevelPerRecord / roundingTolerance) * roundingTolerance;
                numCollapsePerStripe        = zeros(length(stripeSaGrid), 1);

                for stripeIdx = 1:length(stripeSaGrid)
                    numCollapsePerStripe(stripeIdx) = sum( ...
                        abs(collapseLevelRounded - stripeSaGrid(stripeIdx)) < roundingTolerance);
                end

                collapseFractionPerStripe = numCollapsePerStripe ./ numGMsPerStripeGrid;

                % Remove stripes with no GMs
                validStripes              = numGMsPerStripeGrid > 0;
                stripeSaForMLE            = stripeSaGrid(validStripes);
                numGMsForMLE              = numGMsPerStripeGrid(validStripes);
                numCollapseForMLE         = numCollapsePerStripe(validStripes);
                collapseFractionForPlot   = collapseFractionPerStripe(validStripes);

                % MLE fit — same function as collapse CDF processor
                totalCollapses    = sum(numCollapseForMLE);
                totalNonCollapses = sum(numGMsForMLE) - totalCollapses;

                if length(stripeSaForMLE) >= 2 && totalCollapses > 0 && totalNonCollapses > 0
                    [thetaHat_collapse, betaHat_collapse] = sks_Mle_MSA( ...
                        stripeSaForMLE, numGMsForMLE, numCollapseForMLE);
                    fprintf('Collapse (%s): theta = %.3f g   beta = %.3f\n', componentCaseLabel, thetaHat_collapse, betaHat_collapse);
                else
                    warning('Collapse (%s): insufficient data for MLE — nStripes=%d nCol=%d nNonCol=%d', componentCaseLabel, length(stripeSaForMLE), totalCollapses, totalNonCollapses);
                    thetaHat_collapse = NaN;
                    betaHat_collapse  = NaN;
                end

                % MLE fitted curve
                imLevelsForCurve    = (minValueForPlot + 0.001) : 0.001 : maxValueForPlot;
                if ~isnan(thetaHat_collapse)
                    collapseProbabilityMLE = normcdf(log(imLevelsForCurve / thetaHat_collapse) / betaHat_collapse);
                end

                % Expanded uncertainty curve
                if plotCDFWithAdditionalUncertainty == 1 && ~isnan(betaHat_collapse)
                    betaExpanded           = sqrt(betaHat_collapse^2 + sigmaLnDesignReq^2 + ...
                                                  sigmaLnTestData^2  + sigmaLnModeling^2);
                    collapseProbabilityExp = normcdf(log(imLevelsForCurve / thetaHat_collapse) / betaExpanded);
                end

                % always create fresh figure:
                figure; hold on

                % Empirical stripe points — nCollapse/nGM per stripe
                % (mirrors IDA empirical CDF points style)
                plot(stripeSaForMLE, collapseFractionForPlot, 'rs', ...
                    'LineWidth', 2, 'MarkerSize', 8, ...
                    'MarkerFaceColor', markerFaceColorForIndivColResults, ...
                    'MarkerEdgeColor', 'r');

                % MLE fitted curve
                if ~isnan(thetaHat_collapse)
                    plot(imLevelsForCurve, collapseProbabilityMLE, 'r-', 'LineWidth', 4);
                end

                % Expanded uncertainty curve
                if plotCDFWithAdditionalUncertainty == 1 && ~isnan(betaHat_collapse)
                    plot(imLevelsForCurve, collapseProbabilityExp, 'b--', 'LineWidth', 2);
                end

                % Annotation box — mirrors IDA text box exactly
                if addTextAnnotations == 1 && ~isnan(thetaHat_collapse)
                    limitsOfAxes = [minValueForPlot maxValueForPlot 0 1];
                    xDimOfAxis   = limitsOfAxes(2) - limitsOfAxes(1);
                    yDimOfAxis   = limitsOfAxes(4) - limitsOfAxes(3);
                    annotationPosition = [limitsOfAxes(1) + 0.71*xDimOfAxis, ...
                                          limitsOfAxes(3) + 0.65*yDimOfAxis];
                    text(annotationPosition(1), annotationPosition(2), ...
                        {['$$\hat{\theta} = '            sprintf('%5.3f', thetaHat_collapse) '\,\mathrm{g}$$'], ...
                         ['$$\hat{\beta}_{\ln} = ' sprintf('%5.3f', betaHat_collapse)  '$$']}, ...
                        'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', ...
                        'BackgroundColor', [0.875 0.875 0.875]);
                end

                % Legend
                if plotCDFWithAdditionalUncertainty == 1
                    legend('Empirical CDF', 'MLE fit', 'MLE fit (expanded $\beta$)', ...
                        'Location', 'Southeast', 'Interpreter', 'latex');
                else
                    legend('Empirical CDF', 'MLE fit', ...
                        'Location', 'Southeast', 'Interpreter', 'latex');
                end

                box on;  grid on
                axis([minValueForPlot maxValueForPlot 0.0 1.0]);
                xlabel(buildXAxisLabel(isConvertToSaKircher, periodUsedForScalingGroundMotions, false), ...
                    'Interpreter', 'latex');
                ylabel('$\mathrm{Pr}[\mathrm{collapse}]$', 'Interpreter', 'latex');
                sks_figureFormat(formatMode)

                if isConvertToSaKircher == 0
                    exportName = sprintf('CollapseCDF_%s_SaGeoMean', componentCaseLabel);
                else
                    exportName = sprintf('CollapseCDF_%s_SaATC63', componentCaseLabel);
                end
                sks_figureExport(fullfile(fixedOutputDirectory, analysisTypeFolder, exportName))
                hold off 

            end   % figIdx loop

        % ================================================================
        % MIDR / RDR / PFA FRAGILITY CDFs
        % Load pre-fitted MLE params and empirical exceedance fractions
        % from DATA_FragilityParams_SaGeoMean_<name>.mat.
        %
        % For each limit state:
        %   Empirical points: exceedanceProbControl(:, lsIdx) vs stripeSaControl
        %   MLE curve:        normcdf(log(IM/theta)/beta)
        %   Both ControlComp and AllComp — one figure each (figIdx 1 and 2)
        %
        % Mirrors exactly how sks_PlotCollapseCDF (IDA) uses:
        %   saCapacityMatrix(:, lsIdx) for empirical scatter
        %   meanLnSaVals(lsIdx), stDevLnSaVals(lsIdx) for lognormal curve
        % ================================================================
        elseif strcmp(cdfType, 'MIDR') || strcmp(cdfType, 'RDR') || strcmp(cdfType, 'PFA')

            % Load the complete fragility .mat
            % All variable names confirmed from actual file inspection
            fragData = load(fragParamsFilePath, ...
                'midrLevels',    'midrLevelLabels', ...
                'midrThetaControl',    'midrBetaControl', ...
                'midrThetaAllComp',    'midrBetaAllComp', ...
                'midrStripeSaControl', 'midrStripeSaAllComp', ...
                'midrExceedanceProbControl',          'midrExceedanceProbAllComp', ...
                'midrNumGMsPerStripeControl',         'midrNumGMsPerStripeAllComp', ...
                'midrNumExceedancesPerStripeControl', 'midrNumExceedancesPerStripeAllComp', ...
                'rdrLevels',     'rdrLevelLabels', ...
                'rdrThetaControl',    'rdrBetaControl', ...
                'rdrThetaAllComp',    'rdrBetaAllComp', ...
                'rdrStripeSaControl', 'rdrStripeSaAllComp', ...
                'rdrExceedanceProbControl',          'rdrExceedanceProbAllComp', ...
                'rdrNumGMsPerStripeControl',         'rdrNumGMsPerStripeAllComp', ...
                'rdrNumExceedancesPerStripeControl', 'rdrNumExceedancesPerStripeAllComp', ...
                'pfaLevels',     'pfaLevelLabels', ...
                'pfaThetaControl',    'pfaBetaControl', ...
                'pfaThetaAllComp',    'pfaBetaAllComp', ...
                'pfaStripeSaControl', 'pfaStripeSaAllComp', ...
                'pfaExceedanceProbControl',          'pfaExceedanceProbAllComp', ...
                'pfaNumGMsPerStripeControl',         'pfaNumGMsPerStripeAllComp', ...
                'pfaNumExceedancesPerStripeControl', 'pfaNumExceedancesPerStripeAllComp');

            % Select the right demand type variables
            switch cdfType
                case 'MIDR'
                    limitStateLevels              = fragData.midrLevels(:);
                    limitStateLabels              = fragData.midrLevelLabels(:);
                    thetaMLE_ControlComp          = fragData.midrThetaControl(:);
                    betaMLE_ControlComp           = fragData.midrBetaControl(:);
                    thetaMLE_AllComp              = fragData.midrThetaAllComp(:);
                    betaMLE_AllComp               = fragData.midrBetaAllComp(:);
                    stripeSa_ControlComp          = fragData.midrStripeSaControl(:);
                    stripeSa_AllComp              = fragData.midrStripeSaAllComp(:);
                    exceedanceProb_ControlComp    = fragData.midrExceedanceProbControl;
                    exceedanceProb_AllComp        = fragData.midrExceedanceProbAllComp;
                    numGMsPerStripe_ControlComp   = double(fragData.midrNumGMsPerStripeControl);
                    numGMsPerStripe_AllComp       = double(fragData.midrNumGMsPerStripeAllComp);
                    numExcPerStripe_ControlComp   = double(fragData.midrNumExceedancesPerStripeControl);
                    numExcPerStripe_AllComp       = double(fragData.midrNumExceedancesPerStripeAllComp);

                case 'RDR'
                    limitStateLevels              = fragData.rdrLevels(:);
                    limitStateLabels              = fragData.rdrLevelLabels(:);
                    thetaMLE_ControlComp          = fragData.rdrThetaControl(:);
                    betaMLE_ControlComp           = fragData.rdrBetaControl(:);
                    thetaMLE_AllComp              = fragData.rdrThetaAllComp(:);
                    betaMLE_AllComp               = fragData.rdrBetaAllComp(:);
                    stripeSa_ControlComp          = fragData.rdrStripeSaControl(:);
                    stripeSa_AllComp              = fragData.rdrStripeSaAllComp(:);
                    exceedanceProb_ControlComp    = fragData.rdrExceedanceProbControl;
                    exceedanceProb_AllComp        = fragData.rdrExceedanceProbAllComp;
                    numGMsPerStripe_ControlComp   = double(fragData.rdrNumGMsPerStripeControl);
                    numGMsPerStripe_AllComp       = double(fragData.rdrNumGMsPerStripeAllComp);
                    numExcPerStripe_ControlComp   = double(fragData.rdrNumExceedancesPerStripeControl);
                    numExcPerStripe_AllComp       = double(fragData.rdrNumExceedancesPerStripeAllComp);

                case 'PFA'
                    limitStateLevels              = fragData.pfaLevels(:);
                    limitStateLabels              = fragData.pfaLevelLabels(:);
                    thetaMLE_ControlComp          = fragData.pfaThetaControl(:);
                    betaMLE_ControlComp           = fragData.pfaBetaControl(:);
                    thetaMLE_AllComp              = fragData.pfaThetaAllComp(:);
                    betaMLE_AllComp               = fragData.pfaBetaAllComp(:);
                    stripeSa_ControlComp          = fragData.pfaStripeSaControl(:);
                    stripeSa_AllComp              = fragData.pfaStripeSaAllComp(:);
                    exceedanceProb_ControlComp    = fragData.pfaExceedanceProbControl;
                    exceedanceProb_AllComp        = fragData.pfaExceedanceProbAllComp;
                    numGMsPerStripe_ControlComp   = double(fragData.pfaNumGMsPerStripeControl);
                    numGMsPerStripe_AllComp       = double(fragData.pfaNumGMsPerStripeAllComp);
                    numExcPerStripe_ControlComp   = double(fragData.pfaNumExceedancesPerStripeControl);
                    numExcPerStripe_AllComp       = double(fragData.pfaNumExceedancesPerStripeAllComp);
            end

            numLimitStates   = length(limitStateLevels);
            imLevelsForCurve = (minValueForPlot + 0.001) : 0.001 : maxValueForPlot;

            % ---- figIdx 1 = ControlComp,  figIdx 2 = AllComp ----
            for figIdx = 1:2

                if figIdx == 1
                    componentCaseLabel          = 'ControlComp';
                    thetaMLEForThisCase         = thetaMLE_ControlComp;
                    betaMLEForThisCase          = betaMLE_ControlComp;
                    stripeSaForThisCase         = stripeSa_ControlComp;
                    exceedanceProbForThisCase   = exceedanceProb_ControlComp;
                    numGMsPerStripeForThisCase  = numGMsPerStripe_ControlComp;
                    numExcPerStripeForThisCase  = numExcPerStripe_ControlComp;
                else
                    componentCaseLabel          = 'AllComp';
                    thetaMLEForThisCase         = thetaMLE_AllComp;
                    betaMLEForThisCase          = betaMLE_AllComp;
                    stripeSaForThisCase         = stripeSa_AllComp;
                    exceedanceProbForThisCase   = exceedanceProb_AllComp;
                    numGMsPerStripeForThisCase  = numGMsPerStripe_AllComp;
                    numExcPerStripeForThisCase  = numExcPerStripe_AllComp;
                end

                figure; hold on

                for limitStateIdx = 1:numLimitStates

                    currentLimitStateLabel   = limitStateLabels{limitStateIdx};
                    currentThetaMLE          = thetaMLEForThisCase(limitStateIdx);
                    currentBetaMLE           = betaMLEForThisCase(limitStateIdx);
                    thisLimitStateColor      = colors(mod(limitStateIdx-1, size(colors,1)) + 1, :);

                    % Empirical stripe exceedance fraction points
                    % exceedanceProbForThisCase is (nStripes x nLimitStates)
                    % Column limitStateIdx gives nExc/nGM per stripe for this LS.
                    % Only plot stripes that have GMs
                    stripesWithData             = numGMsPerStripeForThisCase(:, limitStateIdx) > 0;
                    empiricalStripeSaToPlot     = stripeSaForThisCase(stripesWithData);
                    empiricalExcProbToPlot      = exceedanceProbForThisCase(stripesWithData, limitStateIdx);

                    if length(empiricalStripeSaToPlot) >= 1
                        plot(empiricalStripeSaToPlot, empiricalExcProbToPlot, 's', ...
                            'MarkerEdgeColor', thisLimitStateColor, ...
                            'MarkerFaceColor', markerFaceColorForIndivColResults, ...
                            'MarkerSize', 7, ...
                            'HandleVisibility', 'off');
                    end

                    % MLE fragility curve — normcdf(log(IM/theta)/beta)
                    % This is the MSA equivalent of PlotLogNormalCDF in IDA version
                    if isfinite(currentThetaMLE) && currentThetaMLE > 0 && ...
                            isfinite(currentBetaMLE) && currentBetaMLE > 0

                        exceedanceProbabilityMLECurve = normcdf( ...
                            log(imLevelsForCurve / currentThetaMLE) / currentBetaMLE);
                        plot(imLevelsForCurve, exceedanceProbabilityMLECurve, '-', ...
                            'LineWidth', 3.0, 'Color', thisLimitStateColor);

                        % Expanded uncertainty curve
                        if plotCDFWithAdditionalUncertainty == 1
                            betaExpanded = sqrt(currentBetaMLE^2 + sigmaLnDesignReq^2 + ...
                                               sigmaLnTestData^2  + sigmaLnModeling^2);
                            exceedanceProbabilityExpandedCurve = normcdf( ...
                                log(imLevelsForCurve / currentThetaMLE) / betaExpanded);
                            plot(imLevelsForCurve, exceedanceProbabilityExpandedCurve, '--', ...
                                'LineWidth', 2.0, 'Color', thisLimitStateColor);
                        end

                        % Text annotation per limit state
                        % Mirrors IDA version annotation inside limit state loop
                        if addTextAnnotations == 1
                            xPositionNormalized = 0.50;
                            yPositionNormalized = 0.35 - 0.08*(limitStateIdx - 1);
                            text(xPositionNormalized, yPositionNormalized, ...
                                sprintf('$$\\hat{\\theta}_{%s} = %5.2f\\,\\mathrm{g},\\ \\hat{\\beta}_{\\ln} = %5.2f$$', ...
                                    currentLimitStateLabel, ...
                                    round(currentThetaMLE*100)/100, ...
                                    round(currentBetaMLE*100)/100), ...
                                'Units', 'normalized', 'HorizontalAlignment', 'left', ...
                                'Interpreter', 'latex', 'FontSize', 12, ...
                                'Color', thisLimitStateColor);
                        end

                    else
                        warning('%s MSA - %s level %d (%s): invalid MLE params (theta=%.3f, beta=%.3f) — skipping curve', ...
                            componentCaseLabel, cdfType, limitStateIdx, currentLimitStateLabel, ...
                            currentThetaMLE, currentBetaMLE);
                    end

                end   % limitStateIdx loop

                axis([minValueForPlot maxValueForPlot 0.0 1.0]);
                box on;  grid on

                xlabel(buildXAxisLabel(isConvertToSaKircher, periodUsedForScalingGroundMotions, true), ...
                    'Interpreter', 'latex');
                ylabel('$\mathrm{Pr}[\mathrm{LS} \ge ls_i \mid \mathrm{IM} = im]$', ...
                    'Interpreter', 'latex');
                sks_figureFormat(formatMode)

                if isConvertToSaKircher == 0
                    exportName = sprintf('CollapseCDF_%s_SaGeoMean_MSA_%s', ...
                        componentCaseLabel, exportSuffix);
                else
                    exportName = sprintf('CollapseCDF_%s_SaATC63_MSA_%s', ...
                        componentCaseLabel, exportSuffix);
                end
                sks_figureExport(fullfile(fixedOutputDirectory, analysisTypeFolder, exportName))
                hold off

            end   % figIdx loop

        end   % cdfType block

    end   % analysisTypeIdx loop

    cd(startDir);
    fprintf('CDF plots MSA (%s) — DONE\n', cdfType);

end   % cdfTypeList loop

end   % main function


% =========================================================================
% Local helper: build x-axis label string
% Mirrors makeXLabel logic from sks_PlotCollapseCDF (IDA)
% isFragilityPlot = true  → uses ${im} \equiv ... notation (MIDR/RDR/PFA)
% isFragilityPlot = false → uses plain Sa notation (Collapse)
% =========================================================================
function labelString = buildXAxisLabel(isConvertToSaKircher, periodUsedForScalingGroundMotions, isFragilityPlot)
    if isConvertToSaKircher == 0
        if isFragilityPlot
            labelString = sprintf( ...
                '${im} \\equiv \\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', ...
                periodUsedForScalingGroundMotions);
        else
            labelString = sprintf( ...
                '$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', ...
                periodUsedForScalingGroundMotions);
        end
    else
        DefineSaKircherOverSaGeoMeanValues
        labelString = axisLabelForSaKircher;
    end
end