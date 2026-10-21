%
% Procedure: sks_PlotCollapse_singleAnaType_MSA.m
% -------------------
% Unified MSA scatter plot function.
% Controlled by msaInputs.plotType:
%   'MIDR'       - Max Interstory Drift Ratio scatter vs Sa stripe
%   'MIDR_Sigma' - MIDR scatter + 16th/84th percentile band (FEMA P-695)
%   'MIDR_PDF'   - MIDR scatter + lognormal PDF overlay at EDP threshold levels
%   'RDR_PDF'    - Residual Drift Ratio scatter + PDF overlay vs Sa stripe
%   'PFA_PDF'    - Peak Floor Acceleration scatter + PDF overlay vs Sa stripe
%
% Collapse dots follow Baker (2015) Fig 3a — stacked from right edge.
% Data source:
%   MIDR/MIDR_Sigma/MIDR_PDF — DATA_CollapseResultsForThisSingleEQ.mat
%   RDR_PDF/PFA_PDF           — DATA_collapseMSAPlotDataForThisEQ.mat
%
% Units:
%   MIDR, RDR — plotted in % (multiplied by 100)
%   PFA       — plotted in g (divided by 9810)
%
% Author: Curt Haselton (original)
% Shivakumar K S — unified MSA version, IIT Madras
% -------------------
function sks_PlotCollapse_singleAnaType_MSA(msaInputs)

analysisTypeLIST           = msaInputs.analysisTypeLIST;
eqNumberLIST               = msaInputs.eqNumberLIST;
markerTypeLine             = msaInputs.markerTypeLine;
markerTypeDot              = msaInputs.markerTypeDot;
isPlotIndividualPoints     = msaInputs.isPlotIndividualPoints;
saLevelsForStripes         = msaInputs.saLevelsForStripes;
isCollapsedForEachRun      = msaInputs.isCollapsedForEachRun;
collapseDriftThreshold     = msaInputs.collapseDriftThreshold;
isConvertToSaKircher       = msaInputs.isConvertToSaKircher;
eqListForCollapseMSAs_Name = msaInputs.eqListForCollapseMSAs_Name;

% Read plotType
plotType = msaInputs.plotType;
% 'MIDR' | 'MIDR_Sigma' | 'MIDR_PDF' | 'RDR_PDF' | 'PFA_PDF'

formatMode = 'powerpoint';
startDir   = pwd;

% ======================================
% LOOP over analysis types
% ======================================
for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType       = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolder = sprintf('%s', analysisType);

    cd(fullfile(startDir, '..', 'Output'));
    fixedOutputDirectory = pwd;

    fprintf('\n=========================================\n');
    fprintf('Processing analysisType = %s\n', analysisTypeFolder);
    fprintf('=========================================\n');

    % ============================================================
    % 1) ALL COMPONENTS PLOT
    % ============================================================
    fprintf('\n--- Plotting ALL COMPONENTS MSA scatter (%s) ---\n', plotType);
    allCompStats = sks_plot_AllComp_MSA(...
        eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, ...
        isConvertToSaKircher, formatMode, plotType, msaInputs);

    % ============================================================
    % 2) CONTROL COMPONENTS PLOT
    % ============================================================
    fprintf('\n--- Plotting CONTROL COMPONENTS MSA scatter (%s) ---\n', plotType);
    controlCompStats = sks_plot_ControlComp_MSA(...
        eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, ...
        isConvertToSaKircher, formatMode, plotType, msaInputs);

    % Save stats file — only for MIDR
    if strcmp(plotType, 'MIDR')
        saveDir = fullfile(fixedOutputDirectory, analysisTypeFolder);
        if isConvertToSaKircher == 0
            colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', ...
                eqListForCollapseMSAs_Name);
        else
            colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63.mat', ...
                eqListForCollapseMSAs_Name);
        end
        collapseStatsFile              = fullfile(saveDir, colFileName);
        collapseLevelForAllComp        = allCompStats.collapseLevelForAllComp;
        collapseLevelForAllControlComp = controlCompStats.collapseLevelForAllControlComp;
        periodUsedForScalingGroundMotions = allCompStats.periodUsedForScalingGroundMotions;
        save(collapseStatsFile, ...
            'analysisType', 'eqNumberLIST', ...
            'collapseLevelForAllComp', 'collapseLevelForAllControlComp', ...
            'periodUsedForScalingGroundMotions');
        fprintf('Saved: %s\n', collapseStatsFile);
        fprintf('All Components:     %d collapse observations\n', numel(collapseLevelForAllComp));
        fprintf('Control Components: %d collapse observations\n', numel(collapseLevelForAllControlComp));
    end

end  % end for analysisTypeNum

cd(startDir);
fprintf('\nDone.\n');

end  % end sks_PlotCollapse_singleAnaType_MSA


% ========================================================================
% ===================== Helper 1: ALL COMPONENTS =========================
% ========================================================================
function allCompStats = sks_plot_AllComp_MSA(...
    eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, ...
    isConvertToSaKircher, formatMode, plotType, msaInputs)

baseDir = fixedOutputDirectory;
saveDir = fullfile(baseDir, analysisTypeFolder);
figure; hold on;

% Initialise global arrays
allSaLevelsForMSAPlot = [];
allEdpForMSAPlot      = [];
collapseSaLevels        = [];   % scatter plot red dots — drift threshold based
collapseSaLevelsForSave = [];   % Collapse CDF .mat — genuine OpenSees collapses only

periodUsedForScalingGroundMotions   = NaN;
minStoryDriftRatioForCollapseMATLAB = NaN;

tol = 1e-6;

% ======================================
% LOOP over all EQ components
% ======================================
for eqInd = 1:length(eqNumberLIST)
    eqCompNumber = eqNumberLIST(eqInd);
    eqFolder     = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqCompNumber));
    loadFile     = fullfile(eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat');

    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        load(loadFile, ...
            'periodUsedForScalingGroundMotions', 'maxDriftForEachRun', ...
            'saLevelForEachRun', 'isCollapsedForEachRun', ...
            'isSingularForEachRun', 'isNonConvForEachRun', ...
            'numSaLevels', 'minStoryDriftRatioForCollapseMATLAB');
        maxDriftRatioForPlotPROCLIST = maxDriftForEachRun * 100;

    elseif strcmp(plotType, 'RDR_PDF')
        load(loadFile, ...
            'periodUsedForScalingGroundMotions', 'saLevelForEachRun', ...
            'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', ...
            'numSaLevels', 'minStoryDriftRatioForCollapseMATLAB');
        procFile = fullfile(eqFolder, 'DATA_collapseMSAPlotDataForThisEQ.mat');
        procData = load(procFile, 'maxResidualDriftRatioForPlotLIST');
        maxResidualDriftRatioForPlotPROCLIST = ...
            procData.maxResidualDriftRatioForPlotLIST(:) * 100;

    elseif strcmp(plotType, 'PFA_PDF')
        load(loadFile, ...
            'periodUsedForScalingGroundMotions', 'saLevelForEachRun', ...
            'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', ...
            'numSaLevels', 'minStoryDriftRatioForCollapseMATLAB');
        procFile = fullfile(eqFolder, 'DATA_collapseMSAPlotDataForThisEQ.mat');
        procData = load(procFile, 'maxPFAForPlotLIST');
        maxPFAForPlotPROCLIST = procData.maxPFAForPlotLIST(:) / 9810;
    end

    % Apply numSaLevels cap
    numSaLevels           = min(numSaLevels, length(saLevelForEachRun));
    saLevelForEachRun     = saLevelForEachRun(1:numSaLevels);
    isCollapsedForEachRun = isCollapsedForEachRun(1:numSaLevels);
    isSingularForEachRun  = isSingularForEachRun(1:numSaLevels);
    isNonConvForEachRun   = isNonConvForEachRun(1:numSaLevels);

    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLIST(1:numSaLevels);
    elseif strcmp(plotType, 'RDR_PDF')
        maxResidualDriftRatioForPlotPROCLIST = ...
            maxResidualDriftRatioForPlotPROCLIST(1:numSaLevels);
    elseif strcmp(plotType, 'PFA_PDF')
        maxPFAForPlotPROCLIST = maxPFAForPlotPROCLIST(1:numSaLevels);
    end

    % Remove padding zeros
    validSa               = (saLevelForEachRun > 0);
    saLevelForEachRun     = saLevelForEachRun(validSa);
    isCollapsedForEachRun = isCollapsedForEachRun(validSa);
    isSingularForEachRun  = isSingularForEachRun(validSa);
    isNonConvForEachRun   = isNonConvForEachRun(validSa);

    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLIST(validSa);
    elseif strcmp(plotType, 'RDR_PDF')
        maxResidualDriftRatioForPlotPROCLIST = ...
            maxResidualDriftRatioForPlotPROCLIST(validSa);
    elseif strcmp(plotType, 'PFA_PDF')
        maxPFAForPlotPROCLIST = maxPFAForPlotPROCLIST(validSa);
    end

    % Filter singular/non-conv non-collapse runs
    validRunIdx                = ~(isCollapsedForEachRun == 0 & ...
                                   (isSingularForEachRun | isNonConvForEachRun));
    saLevelsForMSAPlotPROCLIST = saLevelForEachRun(validRunIdx);
    isCollapsedPROCLIST        = isCollapsedForEachRun(validRunIdx);

    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLIST(validRunIdx);
        edpForPlot = maxDriftRatioForPlotPROCLIST;
    elseif strcmp(plotType, 'RDR_PDF')
        maxResidualDriftRatioForPlotPROCLIST = ...
            maxResidualDriftRatioForPlotPROCLIST(validRunIdx);
        edpForPlot = maxResidualDriftRatioForPlotPROCLIST;
    elseif strcmp(plotType, 'PFA_PDF')
        maxPFAForPlotPROCLIST = maxPFAForPlotPROCLIST(validRunIdx);
        edpForPlot = maxPFAForPlotPROCLIST;
    end

    % Separate non-collapse and collapse
    % saLevelsForMSAPlot_nonCollapse = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 0);
    % edpForPlot_nonCollapse         = edpForPlot(isCollapsedPROCLIST == 0);
    % saLevelsForMSAPlot_Collapse    = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 1);

    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        % Blue dots — non-collapse AND drift < collapseDriftThreshold
        saLevelsForMSAPlot_nonCollapse = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 0 & ...
            edpForPlot < msaInputs.collapseDriftThreshold * 100);
        edpForPlot_nonCollapse         = edpForPlot(isCollapsedPROCLIST == 0 & ...
            edpForPlot < msaInputs.collapseDriftThreshold * 100);
        % Red dots and collapseSaLevels — genuine OpenSees collapses only:
        % Red dots — drift >= collapseDriftThreshold OR genuine OpenSees collapse:
        saLevelsForMSAPlot_Collapse    = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 1 | edpForPlot >= msaInputs.collapseDriftThreshold * 100);
        % For saving to .mat — genuine OpenSees collapses only:
        saLevelsForMSAPlot_CollapseForSave = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 1);
    else
        saLevelsForMSAPlot_nonCollapse = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 0);
        edpForPlot_nonCollapse         = edpForPlot(isCollapsedPROCLIST == 0);
        saLevelsForMSAPlot_Collapse    = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 1);
        saLevelsForMSAPlot_CollapseForSave = []; 
    end
    
    % Separate non-collapse and collapse
    % if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
    %     % Use drift threshold for plot boundary — blue dots stay below collapseDriftThreshold even when analysis runs to 12%
    %     saLevelsForMSAPlot_nonCollapse = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 0 & edpForPlot < msaInputs.collapseDriftThreshold * 100);
    %     edpForPlot_nonCollapse         = edpForPlot(isCollapsedPROCLIST == 0 & edpForPlot < msaInputs.collapseDriftThreshold * 100);
    %     saLevelsForMSAPlot_Collapse    = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 1 | edpForPlot >= msaInputs.collapseDriftThreshold * 100);
    % else
    %     % RDR_PDF / PFA_PDF — use OpenSees flag only, no drift threshold
    %     saLevelsForMSAPlot_nonCollapse = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 0);
    %     edpForPlot_nonCollapse         = edpForPlot(isCollapsedPROCLIST == 0);
    %     saLevelsForMSAPlot_Collapse    = saLevelsForMSAPlotPROCLIST(isCollapsedPROCLIST == 1);
    % end

    collapseSaLevels      = [collapseSaLevels;      saLevelsForMSAPlot_Collapse(:)];
    collapseSaLevelsForSave = [collapseSaLevelsForSave; saLevelsForMSAPlot_CollapseForSave(:)]; 
    allEdpForMSAPlot      = [allEdpForMSAPlot;      edpForPlot_nonCollapse(:)];
    allSaLevelsForMSAPlot = [allSaLevelsForMSAPlot; saLevelsForMSAPlot_nonCollapse(:)];

end  % end for eqInd

% Sort by Sa
[allSaLevelsForMSAPlot, sortIdx] = sort(allSaLevelsForMSAPlot);
allEdpForMSAPlot = allEdpForMSAPlot(sortIdx);

% ======================================
% MIDR_Sigma — compute percentiles BEFORE drawing anything
% so patch can be drawn first (underneath scatter dots)
% ======================================
if strcmp(plotType, 'MIDR_Sigma')
    uniqueSaStripes = unique(allSaLevelsForMSAPlot);
    pct16_vals      = nan(size(uniqueSaStripes));
    pct50_vals      = nan(size(uniqueSaStripes));   % median — kept for future use
    pct84_vals      = nan(size(uniqueSaStripes));

    for stripeIdx = 1:length(uniqueSaStripes)
        currentSa       = uniqueSaStripes(stripeIdx);
        idxStripe       = abs(allSaLevelsForMSAPlot - currentSa) < tol;
        edpAtThisStripe = allEdpForMSAPlot(idxStripe);
        if numel(edpAtThisStripe) >= 2
            pct16_vals(stripeIdx) = prctile(edpAtThisStripe, 16);
            pct50_vals(stripeIdx) = prctile(edpAtThisStripe, 50);
            pct84_vals(stripeIdx) = prctile(edpAtThisStripe, 84);
        end
    end  % end for stripeIdx

    validIdx   = ~isnan(pct16_vals);
    pct16_plot = pct16_vals(validIdx);
    pct84_plot = pct84_vals(validIdx);
    saPlot     = uniqueSaStripes(validIdx);

    % Draw patch FIRST — underneath all scatter dots and lines
    % Cap 84th pct at collapse threshold so patch does not overlap collapse dots
    % collapseDriftThresholdForPatch = minStoryDriftRatioForCollapseMATLAB * 100;
    collapseDriftThresholdForPatch = msaInputs.collapseDriftThreshold * 100;
    pct84_plot_clipped = min(pct84_plot, collapseDriftThresholdForPatch * 0.98);

    xFill = [pct16_plot(:)', fliplr(pct84_plot_clipped(:)')];
    yFill = [saPlot(:)',     fliplr(saPlot(:)')];
    patch(xFill, yFill, [0.68 0.85 0.90], ...
        'FaceAlpha', 0.25, 'EdgeColor', 'none', 'HandleVisibility', 'off');
end  % end patch first pass

% ======================================
% PLOT non-collapse scatter dots — on top of patch
% ======================================
plot(allEdpForMSAPlot, allSaLevelsForMSAPlot, 'o', ...
    'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', ...
    'MarkerSize', 5, 'LineStyle', 'none');

% ======================================
% AXIS LABELS
% ======================================
if isConvertToSaKircher == 0
    yLabelStr = sprintf('$\\mathrm{Sa_{geoM}(T=%.2f\\,s)\\,(g)}$', ...
        periodUsedForScalingGroundMotions);
else
    DefineSaKircherOverSaGeoMeanValues
    yLabelStr = axisLabelForSaKircher;
end

switch plotType
    case 'MIDR'
        xLabelStr    = '$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$';
        exportSuffix = '';
    case 'MIDR_Sigma'
        xLabelStr    = '$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$';
        exportSuffix = 'MIDR_Sigma';
    case 'MIDR_PDF'
        xLabelStr    = '$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$';
        exportSuffix = 'MIDR_PDF';
    case 'RDR_PDF'
        xLabelStr    = '$\mathrm{Max\ Residual\ Drift\ Ratio\ (\%)}$';
        exportSuffix = 'RDR_PDF';
    case 'PFA_PDF'
        xLabelStr    = '$\mathrm{Max\ Peak\ Floor\ Acceleration\ (g)}$';
        exportSuffix = 'PFA_PDF';
end

xlabel(xLabelStr, 'Interpreter', 'latex');
ylabel(yLabelStr, 'Interpreter', 'latex');

% ======================================
% AXIS LIMITS AND COLLAPSE DOTS
% ======================================
allSaForAxis = [allSaLevelsForMSAPlot; collapseSaLevels];
ylim([0, max(allSaForAxis) * 1.1]);

uniqueCollapseSaVals = unique(collapseSaLevels);

if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
    collapseDriftThreshold = msaInputs.collapseDriftThreshold * 100;
    % collapseDriftThreshold = minStoryDriftRatioForCollapseMATLAB * 100;
    dx = 0.02 * collapseDriftThreshold;

    if ~isempty(collapseSaLevels)
        [~,~,cidx] = unique(collapseSaLevels);
        maxStack   = max(accumarray(cidx, 1));
    else
        maxStack = 0;
    end

    xlim([0, (collapseDriftThreshold + maxStack * dx) * 1.05]);
    xline(collapseDriftThreshold, '--', 'LineWidth', 1.2, 'Color', 'k');

    ax = gca;
    xt = sort(unique([0:1:collapseDriftThreshold, collapseDriftThreshold]));
    ax.XTick      = sort(xt);
    ax.XTickLabel = compose('%.0f', ax.XTick);
    yticks(0:0.5:ax.YLim(2));

    xRight = ax.XLim(2);
    for k = 1:length(uniqueCollapseSaVals)
        currentSa      = uniqueCollapseSaVals(k);
        numOfCollapses = sum(abs(collapseSaLevels - currentSa) < tol);
        if numOfCollapses > 0
            xDots = xRight - (0:numOfCollapses-1) * dx;
            yDots = currentSa * ones(size(xDots));
            plot(xDots, yDots, 'o', ...
                'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
                'MarkerSize', 5, 'LineStyle', 'none');
        end
    end  % end for k

else
    if ~isempty(allEdpForMSAPlot)
        xlim([0, max(allEdpForMSAPlot) * 1.2]);
    end
    ax     = gca;
    dx     = ax.XLim(2) * 0.02;
    yticks(0:0.5:ax.YLim(2));
    xRight = ax.XLim(2);

    for k = 1:length(uniqueCollapseSaVals)
        currentSa      = uniqueCollapseSaVals(k);
        numOfCollapses = sum(abs(collapseSaLevels - currentSa) < tol);
        if numOfCollapses > 0
            xDots = xRight - (0:numOfCollapses-1) * dx;
            yDots = currentSa * ones(size(xDots));
            plot(xDots, yDots, 'o', ...
                'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
                'MarkerSize', 5, 'LineStyle', 'none');
        end
    end  % end for k

end  % end if MIDR axis

box on; grid on;

% ======================================
% MIDR_Sigma LINES — draw AFTER dots so lines are on top
% Patch already drawn before scatter dots above
% ======================================
if strcmp(plotType, 'MIDR_Sigma')

    % 16th percentile — magenta
    plot(pct16_vals(validIdx), uniqueSaStripes(validIdx), 'o--', ...
        'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'MarkerSize', 5, ...
        'MarkerFaceColor', [0.5 0.5 0.5], 'DisplayName', '16th pct');

    % Median — uncomment to plot
    % plot(pct50_vals(validIdx), uniqueSaStripes(validIdx), 'o-', ...
    %     'Color', [0.85 0.33 0.10], 'LineWidth', 2.5, 'MarkerSize', 5, ...
    %     'MarkerFaceColor', [0.85 0.33 0.10], 'DisplayName', 'Median');

    % 84th percentile — magenta
    plot(pct84_vals(validIdx), uniqueSaStripes(validIdx), 'o--', ...
        'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'MarkerSize', 5, ...
        'MarkerFaceColor', [0.5 0.5 0.5], 'DisplayName', '84th pct');

end  % end MIDR_Sigma lines

% ======================================
% LEGEND
% ======================================
h1 = plot(nan, nan, 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', ...
    'MarkerSize', 5, 'LineStyle', 'none');
h2 = plot(nan, nan, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
    'MarkerSize', 5, 'LineStyle', 'none');

if strcmp(plotType, 'MIDR_Sigma')
    h_16 = plot(nan, nan, 'o--', 'Color', [0.5 0.5 0.5], 'LineWidth', 2, ...
        'MarkerSize', 4, 'MarkerFaceColor', [0.5 0.5 0.5]);
    h_84 = plot(nan, nan, 'o--', 'Color', [0.5 0.5 0.5], 'LineWidth', 2, ...
        'MarkerSize', 4, 'MarkerFaceColor', [0.5 0.5 0.5]);
    legend([h1 h2 h_16 h_84], ...
        {'no-collapse', 'collapse', '16th pct', '84th pct'}, ...
        'Location', 'southeast', 'FontSize', 14);
    % When median is uncommented above update legend to:
    % legend([h1 h2 h_16 h_84], ...
    %     {'no-collapse','collapse','16th pct','Median','84th pct'}, ...
    %     'Location','southeast','FontSize',14);
else
    legend([h1 h2], {'no-collapse', 'collapse'}, ...
        'Location', 'southeast', 'FontSize', 14);
end
legend boxoff

% ======================================
% PDF OVERLAY — outer guard ensures only runs for PDF plotTypes
% ======================================
if strcmp(plotType, 'MIDR_PDF') || strcmp(plotType, 'RDR_PDF') || strcmp(plotType, 'PFA_PDF')

    if strcmp(plotType, 'MIDR_PDF')
        if isfield(msaInputs, 'midrLevels')
            edpLevelsForPDF = msaInputs.midrLevels * 100;
        else
            edpLevelsForPDF = [1 2 4 12];
        end
        if isfield(msaInputs, 'midrLevelLabels')
            edpLevelLabelsForPDF = msaInputs.midrLevelLabels;
        else
            edpLevelLabelsForPDF = {'IO', 'LS', 'CP', 'Coll'};
        end

    elseif strcmp(plotType, 'RDR_PDF')
        if isfield(msaInputs, 'rdrLevels')
            edpLevelsForPDF = msaInputs.rdrLevels * 100;
        else
            edpLevelsForPDF = [0.2 0.5 1.0 2.0];
        end
        if isfield(msaInputs, 'rdrLevelLabels')
            edpLevelLabelsForPDF = msaInputs.rdrLevelLabels;
        else
            edpLevelLabelsForPDF = {'0.2%', '0.5%', '1%', '2%'};
        end

    elseif strcmp(plotType, 'PFA_PDF')
        if isfield(msaInputs, 'pfaLevels')
            edpLevelsForPDF = msaInputs.pfaLevels;
        else
            edpLevelsForPDF = [0.2 0.5 1.0 2.0];
        end
        if isfield(msaInputs, 'pfaLevelLabels')
            edpLevelLabelsForPDF = msaInputs.pfaLevelLabels;
        else
            edpLevelLabelsForPDF = {'Slight', 'Moderate', 'Extensive', 'Complete'};
        end
    end  % end if edpLevels setup

    colors = [0.00 0.00 1.00;
              1.00 0.00 1.00;
              0.00 0.00 0.00;
              1.00 0.00 0.00];

    ax          = gca;
    scaleFactor = ax.XLim(2) * 0.06;
    hPdfLines   = gobjects(length(edpLevelsForPDF), 1);

    for edpIdx = 1:length(edpLevelsForPDF)
        targetEdpLevel     = edpLevelsForPDF(edpIdx);
        saAtTargetEdpLevel = [];

        uniqueSaStripes = unique([allSaLevelsForMSAPlot; collapseSaLevels]);

        for stripeIdx = 1:length(uniqueSaStripes)
            currentSa       = uniqueSaStripes(stripeIdx);
            idxStripe       = abs(allSaLevelsForMSAPlot - currentSa) < tol;
            edpAtThisStripe = allEdpForMSAPlot(idxStripe);
            if ~isempty(edpAtThisStripe) && median(edpAtThisStripe) >= targetEdpLevel
                saAtTargetEdpLevel = [saAtTargetEdpLevel; ...
                    repmat(currentSa, sum(idxStripe), 1)];
            end
        end  % end for stripeIdx

        if numel(saAtTargetEdpLevel) < 2
            continue;
        end

        muLn    = mean(log(saAtTargetEdpLevel));
        sigmaLn = std(log(saAtTargetEdpLevel));
        Sa16    = exp(muLn - sigmaLn);
        Sa50    = exp(muLn);
        Sa84    = exp(muLn + sigmaLn);
        Sa_neg3 = exp(muLn - 3*sigmaLn);
        Sa_pos3 = exp(muLn + 3*sigmaLn);

        hPdfLines(edpIdx) = plot([targetEdpLevel targetEdpLevel], [Sa16 Sa84], '-', ...
            'LineWidth', 3.0, 'Color', colors(edpIdx,:), ...
            'DisplayName', edpLevelLabelsForPDF{edpIdx});
        plot(targetEdpLevel, Sa50, 'o', ...
            'MarkerFaceColor', colors(edpIdx,:), ...
            'MarkerEdgeColor', colors(edpIdx,:), ...
            'HandleVisibility', 'off');

        nPts    = 150;
        saLower = linspace(Sa_neg3, Sa16,    nPts);
        saMid   = linspace(Sa16,    Sa84,    nPts);
        saUpper = linspace(Sa84,    Sa_pos3, nPts);

        pdfLower = lognpdf(saLower, muLn, sigmaLn);
        pdfMid   = lognpdf(saMid,   muLn, sigmaLn);
        pdfUpper = lognpdf(saUpper, muLn, sigmaLn);

        globalMax = max([pdfLower, pdfMid, pdfUpper]);
        pdfLower  = pdfLower ./ globalMax * scaleFactor;
        pdfMid    = pdfMid   ./ globalMax * scaleFactor;
        pdfUpper  = pdfUpper ./ globalMax * scaleFactor;

        segments = {saLower, saMid,   saUpper};
        pdfSegs  = {pdfLower, pdfMid, pdfUpper};
        isFilled = [false,    true,   false];

        for s = 1:3
            saSeg  = segments{s};
            pdfSeg = pdfSegs{s};
            if numel(saSeg) < 2
                continue;
            end
            x_pdf = [targetEdpLevel * ones(1, length(saSeg)), ...
                     targetEdpLevel - pdfSeg(length(pdfSeg):-1:1)];
            y_pdf = [saSeg, saSeg(length(saSeg):-1:1)];
            if isFilled(s)
                patch(x_pdf, y_pdf, colors(edpIdx,:), ...
                    'FaceAlpha', 0.30, 'EdgeColor', colors(edpIdx,:), ...
                    'LineWidth', 1.5, 'HandleVisibility', 'off');
            else
                patch(x_pdf, y_pdf, colors(edpIdx,:), ...
                    'FaceColor', 'none', 'EdgeColor', colors(edpIdx,:), ...
                    'LineWidth', 1.5, 'HandleVisibility', 'off');
            end
        end  % end for s

    end  % end for edpIdx

    validPdf = isgraphics(hPdfLines);
    if any(validPdf)
        legend(hPdfLines(validPdf), edpLevelLabelsForPDF(validPdf), ...
            'Location', 'southeast', 'AutoUpdate', 'off');
    end

end  % end if PDF plotType

% ======================================
% EXPORT AND SAVE
% ======================================
if strcmp(plotType, 'MIDR')
    if isConvertToSaKircher == 0
        exportName = fullfile(saveDir, 'CollapseMSA_AllComp_SaGeoMean');
    else
        exportName = fullfile(saveDir, 'CollapseMSA_AllComp_SaATC63');
    end
else
    if isConvertToSaKircher == 0
        exportName = fullfile(saveDir, ...
            sprintf('CollapseMSA_AllComp_SaGeoMean_%s', exportSuffix));
    else
        exportName = fullfile(saveDir, ...
            sprintf('CollapseMSA_AllComp_SaATC63_%s', exportSuffix));
    end
end

sks_figureFormat(formatMode);
sks_figureExport(exportName);

% ======================================
% RETURN STATS
% ======================================
% allCompStats.collapseLevelForAllComp           = collapseSaLevels;
allCompStats.collapseLevelForAllComp = collapseSaLevelsForSave; 
allCompStats.periodUsedForScalingGroundMotions = periodUsedForScalingGroundMotions;

end  % end sks_plot_AllComp_MSA


% ========================================================================
% =================== Helper 2: CONTROL COMPONENTS =======================
% ========================================================================
function controlCompStats = sks_plot_ControlComp_MSA(...
    eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, ...
    isConvertToSaKircher, formatMode, plotType, msaInputs)

baseDir = fixedOutputDirectory;
saveDir = fullfile(baseDir, analysisTypeFolder);
figure; hold on;

% Initialise global arrays — control component versions
allSaLevelsForMSAPlot_control = [];
allEdpForMSAPlot_control      = [];
collapseSaLevels_control      = [];
collapseSaLevelsForSave_control = [];

periodUsedForScalingGroundMotions   = NaN;
minStoryDriftRatioForCollapseMATLAB = NaN;

tol = 1e-6;

% ======================================
% LOOP over EQ pairs
% ======================================
for eqNum = 1:2:length(eqNumberLIST)
    eqComp1   = eqNumberLIST(eqNum);
    eqComp2   = eqNumberLIST(eqNum+1);
    eqFolder1 = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqComp1));
    eqFolder2 = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqComp2));
    loadFile1 = fullfile(eqFolder1, 'DATA_CollapseResultsForThisSingleEQ.mat');
    loadFile2 = fullfile(eqFolder2, 'DATA_CollapseResultsForThisSingleEQ.mat');

    % Load component 1
    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        load(loadFile1, ...
            'periodUsedForScalingGroundMotions', 'maxDriftForEachRun', ...
            'saLevelForEachRun', 'isCollapsedForEachRun', ...
            'isSingularForEachRun', 'isNonConvForEachRun', ...
            'numSaLevels', 'minStoryDriftRatioForCollapseMATLAB');
        maxDriftRatioForPlotPROCLISTC1 = maxDriftForEachRun * 100;

    elseif strcmp(plotType, 'RDR_PDF')
        load(loadFile1, ...
            'periodUsedForScalingGroundMotions', 'saLevelForEachRun', ...
            'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', ...
            'numSaLevels', 'minStoryDriftRatioForCollapseMATLAB');
        procFile1      = fullfile(eqFolder1, 'DATA_collapseMSAPlotDataForThisEQ.mat');
        procData1      = load(procFile1, 'maxResidualDriftRatioForPlotLIST');
        maxResidualDriftRatioForPlotPROCLISTC1 = ...
            procData1.maxResidualDriftRatioForPlotLIST(:) * 100;

    elseif strcmp(plotType, 'PFA_PDF')
        load(loadFile1, ...
            'periodUsedForScalingGroundMotions', 'saLevelForEachRun', ...
            'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', ...
            'numSaLevels', 'minStoryDriftRatioForCollapseMATLAB');
        procFile1      = fullfile(eqFolder1, 'DATA_collapseMSAPlotDataForThisEQ.mat');
        procData1      = load(procFile1, 'maxPFAForPlotLIST');
        maxPFAForPlotPROCLISTC1 = procData1.maxPFAForPlotLIST(:) / 9810;
    end

    % Cap component 1
    maxNumRunsC1                 = min(numSaLevels, length(saLevelForEachRun));
    saLevelsForMSAPlotPROCLISTC1 = saLevelForEachRun(1:maxNumRunsC1);
    isCollapsedC1                = isCollapsedForEachRun(1:maxNumRunsC1);
    isSingularC1                 = isSingularForEachRun(1:maxNumRunsC1);
    isNonConvC1                  = isNonConvForEachRun(1:maxNumRunsC1);

    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        maxDriftRatioForPlotPROCLISTC1 = maxDriftRatioForPlotPROCLISTC1(1:maxNumRunsC1);
    elseif strcmp(plotType, 'RDR_PDF')
        maxResidualDriftRatioForPlotPROCLISTC1 = ...
            maxResidualDriftRatioForPlotPROCLISTC1(1:maxNumRunsC1);
    elseif strcmp(plotType, 'PFA_PDF')
        maxPFAForPlotPROCLISTC1 = maxPFAForPlotPROCLISTC1(1:maxNumRunsC1);
    end

    % Load component 2
    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        load(loadFile2, ...
            'maxDriftForEachRun', 'saLevelForEachRun', 'isCollapsedForEachRun', ...
            'isSingularForEachRun', 'isNonConvForEachRun', 'numSaLevels');
        maxDriftRatioForPlotPROCLISTC2 = maxDriftForEachRun * 100;

    elseif strcmp(plotType, 'RDR_PDF')
        load(loadFile2, ...
            'saLevelForEachRun', 'isCollapsedForEachRun', ...
            'isSingularForEachRun', 'isNonConvForEachRun', 'numSaLevels');
        procFile2      = fullfile(eqFolder2, 'DATA_collapseMSAPlotDataForThisEQ.mat');
        procData2      = load(procFile2, 'maxResidualDriftRatioForPlotLIST');
        maxResidualDriftRatioForPlotPROCLISTC2 = ...
            procData2.maxResidualDriftRatioForPlotLIST(:) * 100;

    elseif strcmp(plotType, 'PFA_PDF')
        load(loadFile2, ...
            'saLevelForEachRun', 'isCollapsedForEachRun', ...
            'isSingularForEachRun', 'isNonConvForEachRun', 'numSaLevels');
        procFile2      = fullfile(eqFolder2, 'DATA_collapseMSAPlotDataForThisEQ.mat');
        procData2      = load(procFile2, 'maxPFAForPlotLIST');
        maxPFAForPlotPROCLISTC2 = procData2.maxPFAForPlotLIST(:) / 9810;
    end

    % Cap component 2
    maxNumRunsC2                 = min(numSaLevels, length(saLevelForEachRun));
    saLevelsForMSAPlotPROCLISTC2 = saLevelForEachRun(1:maxNumRunsC2);
    isCollapsedC2                = isCollapsedForEachRun(1:maxNumRunsC2);
    isSingularC2                 = isSingularForEachRun(1:maxNumRunsC2);
    isNonConvC2                  = isNonConvForEachRun(1:maxNumRunsC2);

    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        maxDriftRatioForPlotPROCLISTC2 = maxDriftRatioForPlotPROCLISTC2(1:maxNumRunsC2);
    elseif strcmp(plotType, 'RDR_PDF')
        maxResidualDriftRatioForPlotPROCLISTC2 = ...
            maxResidualDriftRatioForPlotPROCLISTC2(1:maxNumRunsC2);
    elseif strcmp(plotType, 'PFA_PDF')
        maxPFAForPlotPROCLISTC2 = maxPFAForPlotPROCLISTC2(1:maxNumRunsC2);
    end

    % Remove padding zeros
    validSaC1 = (saLevelsForMSAPlotPROCLISTC1 > 0);
    validSaC2 = (saLevelsForMSAPlotPROCLISTC2 > 0);

    saLevelsForMSAPlotPROCLISTC1 = saLevelsForMSAPlotPROCLISTC1(validSaC1);
    isCollapsedC1 = isCollapsedC1(validSaC1);
    isSingularC1  = isSingularC1(validSaC1);
    isNonConvC1   = isNonConvC1(validSaC1);

    saLevelsForMSAPlotPROCLISTC2 = saLevelsForMSAPlotPROCLISTC2(validSaC2);
    isCollapsedC2 = isCollapsedC2(validSaC2);
    isSingularC2  = isSingularC2(validSaC2);
    isNonConvC2   = isNonConvC2(validSaC2);

    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        maxDriftRatioForPlotPROCLISTC1 = maxDriftRatioForPlotPROCLISTC1(validSaC1);
        maxDriftRatioForPlotPROCLISTC2 = maxDriftRatioForPlotPROCLISTC2(validSaC2);
    elseif strcmp(plotType, 'RDR_PDF')
        maxResidualDriftRatioForPlotPROCLISTC1 = ...
            maxResidualDriftRatioForPlotPROCLISTC1(validSaC1);
        maxResidualDriftRatioForPlotPROCLISTC2 = ...
            maxResidualDriftRatioForPlotPROCLISTC2(validSaC2);
    elseif strcmp(plotType, 'PFA_PDF')
        maxPFAForPlotPROCLISTC1 = maxPFAForPlotPROCLISTC1(validSaC1);
        maxPFAForPlotPROCLISTC2 = maxPFAForPlotPROCLISTC2(validSaC2);
    end

    % Stripe alignment check
    if length(saLevelsForMSAPlotPROCLISTC1) ~= length(saLevelsForMSAPlotPROCLISTC2) || ...
            any(abs(saLevelsForMSAPlotPROCLISTC1 - saLevelsForMSAPlotPROCLISTC2) > tol)
        error('Stripe mismatch between EQ_%d and EQ_%d', eqComp1, eqComp2);
    end

    % Combined filter
    validRunCombined = ~( (isCollapsedC1==0 & (isSingularC1|isNonConvC1)) | ...
                          (isCollapsedC2==0 & (isSingularC2|isNonConvC2)) );

    saLevelsForMSAPlot_control = saLevelsForMSAPlotPROCLISTC1(validRunCombined);
    isCollapsedControl         = max(isCollapsedC1(validRunCombined), ...
                                     isCollapsedC2(validRunCombined));

    % Worst EDP across pair
    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        maxEdpControl = max(maxDriftRatioForPlotPROCLISTC1(validRunCombined), ...
                            maxDriftRatioForPlotPROCLISTC2(validRunCombined));
    elseif strcmp(plotType, 'RDR_PDF')
        maxEdpControl = max(maxResidualDriftRatioForPlotPROCLISTC1(validRunCombined), ...
                            maxResidualDriftRatioForPlotPROCLISTC2(validRunCombined));
    elseif strcmp(plotType, 'PFA_PDF')
        maxEdpControl = max(maxPFAForPlotPROCLISTC1(validRunCombined), ...
                            maxPFAForPlotPROCLISTC2(validRunCombined));
    end

    % Separate collapse vs non-collapse
    % saLevelsForMSAPlot_nonCollapse_control = ...
    %     saLevelsForMSAPlot_control(isCollapsedControl == 0);
    % edpForPlot_nonCollapse_control = maxEdpControl(isCollapsedControl == 0);
    % saLevelsForMSAPlot_Collapse_control = ...
    %     saLevelsForMSAPlot_control(isCollapsedControl == 1);


    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
        % Blue dots — non-collapse AND drift < collapseDriftThreshold
        saLevelsForMSAPlot_nonCollapse_control = ...
            saLevelsForMSAPlot_control(isCollapsedControl == 0 & ...
            maxEdpControl < msaInputs.collapseDriftThreshold * 100);
        edpForPlot_nonCollapse_control = maxEdpControl(isCollapsedControl == 0 & ...
            maxEdpControl < msaInputs.collapseDriftThreshold * 100);
        % Red dots and collapseSaLevels — genuine OpenSees collapses only:
        % Red dots — drift >= collapseDriftThreshold OR genuine OpenSees collapse:
       saLevelsForMSAPlot_Collapse_control = saLevelsForMSAPlot_control(isCollapsedControl == 1 | maxEdpControl >= msaInputs.collapseDriftThreshold * 100);
       % For saving to .mat — genuine OpenSees collapses only:
       saLevelsForMSAPlot_CollapseForSave_control = saLevelsForMSAPlot_control(isCollapsedControl == 1);
    else
        saLevelsForMSAPlot_nonCollapse_control = ...
            saLevelsForMSAPlot_control(isCollapsedControl == 0);
        edpForPlot_nonCollapse_control = maxEdpControl(isCollapsedControl == 0);
        saLevelsForMSAPlot_Collapse_control = ...
            saLevelsForMSAPlot_control(isCollapsedControl == 1);
        saLevelsForMSAPlot_CollapseForSave_control = [];
    end

    % Separate collapse vs non-collapse
    % if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
    %     % Use drift threshold for plot boundary
    %     saLevelsForMSAPlot_nonCollapse_control = saLevelsForMSAPlot_control(isCollapsedControl == 0 & maxEdpControl < msaInputs.collapseDriftThreshold * 100);
    %     edpForPlot_nonCollapse_control = maxEdpControl(isCollapsedControl == 0 & maxEdpControl < msaInputs.collapseDriftThreshold * 100);
    %     saLevelsForMSAPlot_Collapse_control = saLevelsForMSAPlot_control(isCollapsedControl == 1 | maxEdpControl >= msaInputs.collapseDriftThreshold * 100);
    % else
    %     % RDR_PDF / PFA_PDF — use OpenSees flag only
    %     saLevelsForMSAPlot_nonCollapse_control = saLevelsForMSAPlot_control(isCollapsedControl == 0);
    %     edpForPlot_nonCollapse_control = maxEdpControl(isCollapsedControl == 0);
    %     saLevelsForMSAPlot_Collapse_control = saLevelsForMSAPlot_control(isCollapsedControl == 1);
    % end

    collapseSaLevels_control      = [collapseSaLevels_control; saLevelsForMSAPlot_Collapse_control(:)];
    collapseSaLevelsForSave_control = [collapseSaLevelsForSave_control; saLevelsForMSAPlot_CollapseForSave_control(:)];
    allEdpForMSAPlot_control      = [allEdpForMSAPlot_control; edpForPlot_nonCollapse_control(:)];
    allSaLevelsForMSAPlot_control = [allSaLevelsForMSAPlot_control; saLevelsForMSAPlot_nonCollapse_control(:)];

end  % end for eqNum pairs

% Sort by Sa
[allSaLevelsForMSAPlot_control, sortIdx] = sort(allSaLevelsForMSAPlot_control);
allEdpForMSAPlot_control = allEdpForMSAPlot_control(sortIdx);

% ======================================
% MIDR_Sigma — compute percentiles BEFORE drawing anything
% patch drawn first so scatter dots appear on top
% ======================================
if strcmp(plotType, 'MIDR_Sigma')
    uniqueSaStripes_ctrl = unique(allSaLevelsForMSAPlot_control);
    pct16_vals_ctrl      = nan(size(uniqueSaStripes_ctrl));
    pct50_vals_ctrl      = nan(size(uniqueSaStripes_ctrl));   % median — kept for future use
    pct84_vals_ctrl      = nan(size(uniqueSaStripes_ctrl));

    for stripeIdx = 1:length(uniqueSaStripes_ctrl)
        currentSa       = uniqueSaStripes_ctrl(stripeIdx);
        idxStripe       = abs(allSaLevelsForMSAPlot_control - currentSa) < tol;
        edpAtThisStripe = allEdpForMSAPlot_control(idxStripe);
        if numel(edpAtThisStripe) >= 2
            pct16_vals_ctrl(stripeIdx) = prctile(edpAtThisStripe, 16);
            pct50_vals_ctrl(stripeIdx) = prctile(edpAtThisStripe, 50);
            pct84_vals_ctrl(stripeIdx) = prctile(edpAtThisStripe, 84);
        end
    end  % end for stripeIdx

    validIdx_ctrl   = ~isnan(pct16_vals_ctrl);
    pct16_plot_ctrl = pct16_vals_ctrl(validIdx_ctrl);
    pct84_plot_ctrl = pct84_vals_ctrl(validIdx_ctrl);
    saPlot_ctrl     = uniqueSaStripes_ctrl(validIdx_ctrl);

    % Draw patch FIRST — underneath scatter dots
    % collapseDriftThresholdForPatch = minStoryDriftRatioForCollapseMATLAB * 100;
    collapseDriftThresholdForPatch = msaInputs.collapseDriftThreshold * 100;
    pct84_plot_ctrl_clipped = min(pct84_plot_ctrl, collapseDriftThresholdForPatch * 0.98);

    xFill = [pct16_plot_ctrl(:)', fliplr(pct84_plot_ctrl_clipped(:)')];
    yFill = [saPlot_ctrl(:)',     fliplr(saPlot_ctrl(:)')];
    patch(xFill, yFill, [0.68 0.85 0.90], ...
        'FaceAlpha', 0.25, 'EdgeColor', 'none', 'HandleVisibility', 'off');
end  % end patch first pass

% ======================================
% PLOT non-collapse scatter dots — on top of patch
% ======================================
plot(allEdpForMSAPlot_control, allSaLevelsForMSAPlot_control, 'o', ...
    'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', ...
    'MarkerSize', 5, 'LineStyle', 'none');

% ======================================
% AXIS LABELS
% ======================================
if isConvertToSaKircher == 0
    yLabelStr = sprintf('$\\mathrm{Sa_{geoM}(T=%.2f\\,s)\\,(g)}$', ...
        periodUsedForScalingGroundMotions);
else
    DefineSaKircherOverSaGeoMeanValues
    yLabelStr = axisLabelForSaKircher;
end

switch plotType
    case 'MIDR'
        xLabelStr    = '$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$';
        exportSuffix = '';
    case 'MIDR_Sigma'
        xLabelStr    = '$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$';
        exportSuffix = 'MIDR_Sigma';
    case 'MIDR_PDF'
        xLabelStr    = '$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$';
        exportSuffix = 'MIDR_PDF';
    case 'RDR_PDF'
        xLabelStr    = '$\mathrm{Max\ Residual\ Drift\ Ratio\ (\%)}$';
        exportSuffix = 'RDR_PDF';
    case 'PFA_PDF'
        xLabelStr    = '$\mathrm{Max\ Peak\ Floor\ Acceleration\ (g)}$';
        exportSuffix = 'PFA_PDF';
end

xlabel(xLabelStr, 'Interpreter', 'latex');
ylabel(yLabelStr, 'Interpreter', 'latex');

% ======================================
% AXIS LIMITS AND COLLAPSE DOTS
% ======================================
allSaForAxis_control = [allSaLevelsForMSAPlot_control; collapseSaLevels_control];
ylim([0, max(allSaForAxis_control) * 1.1]);

uniqueCollapseSaVals_control = unique(collapseSaLevels_control);

if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_Sigma') || strcmp(plotType, 'MIDR_PDF')
    collapseDriftThreshold = msaInputs.collapseDriftThreshold * 100;
    % collapseDriftThreshold = minStoryDriftRatioForCollapseMATLAB * 100;
    dx = 0.02 * collapseDriftThreshold;

    if ~isempty(collapseSaLevels_control)
        [~,~,cidx] = unique(collapseSaLevels_control);
        maxStack   = max(accumarray(cidx, 1));
    else
        maxStack = 0;
    end

    xlim([0, (collapseDriftThreshold + maxStack * dx) * 1.05]);
    xline(collapseDriftThreshold, '--', 'LineWidth', 1.2, 'Color', 'k');

    ax = gca;
    xt = sort(unique([0:1:collapseDriftThreshold, collapseDriftThreshold]));
    ax.XTick      = sort(xt);
    ax.XTickLabel = compose('%.0f', ax.XTick);
    yticks(0:0.5:ax.YLim(2));

    xRight = ax.XLim(2);
    for k = 1:length(uniqueCollapseSaVals_control)
        currentSa      = uniqueCollapseSaVals_control(k);
        numOfCollapses = sum(abs(collapseSaLevels_control - currentSa) < tol);
        if numOfCollapses > 0
            xDots = xRight - (0:numOfCollapses-1) * dx;
            yDots = currentSa * ones(size(xDots));
            plot(xDots, yDots, 'o', ...
                'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
                'MarkerSize', 5, 'LineStyle', 'none');
        end
    end  % end for k

else
    if ~isempty(allEdpForMSAPlot_control)
        xlim([0, max(allEdpForMSAPlot_control) * 1.2]);
    end
    ax     = gca;
    dx     = ax.XLim(2) * 0.02;
    yticks(0:0.5:ax.YLim(2));
    xRight = ax.XLim(2);

    for k = 1:length(uniqueCollapseSaVals_control)
        currentSa      = uniqueCollapseSaVals_control(k);
        numOfCollapses = sum(abs(collapseSaLevels_control - currentSa) < tol);
        if numOfCollapses > 0
            xDots = xRight - (0:numOfCollapses-1) * dx;
            yDots = currentSa * ones(size(xDots));
            plot(xDots, yDots, 'o', ...
                'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
                'MarkerSize', 5, 'LineStyle', 'none');
        end
    end  % end for k

end  % end if MIDR axis

grid on;

% ======================================
% MIDR_Sigma LINES — draw AFTER dots so lines are on top
% Patch already drawn before scatter dots above
% ======================================
if strcmp(plotType, 'MIDR_Sigma')

    % 16th percentile — magenta
    plot(pct16_vals_ctrl(validIdx_ctrl), uniqueSaStripes_ctrl(validIdx_ctrl), 'o--', ...
        'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'MarkerSize', 5, ...
        'MarkerFaceColor', [0.5 0.5 0.5], 'DisplayName', '16th pct');

    % Median — uncomment to plot
    % plot(pct50_vals_ctrl(validIdx_ctrl), uniqueSaStripes_ctrl(validIdx_ctrl), 'o-', ...
    %     'Color', [0.5 0.5 0.5], 'LineWidth', 2.5, 'MarkerSize', 5, ...
    %     'MarkerFaceColor', [0.85 0.33 0.10], 'DisplayName', 'Median');

    % 84th percentile — magenta
    plot(pct84_vals_ctrl(validIdx_ctrl), uniqueSaStripes_ctrl(validIdx_ctrl), 'o--', ...
        'Color', [0.5 0.5 0.5], 'LineWidth', 2, 'MarkerSize', 5, ...
        'MarkerFaceColor', [0.5 0.5 0.5], 'DisplayName', '84th pct');

end  % end MIDR_Sigma lines

% ======================================
% LEGEND
% ======================================
h1 = plot(nan, nan, 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', ...
    'MarkerSize', 5, 'LineStyle', 'none');
h2 = plot(nan, nan, 'o', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
    'MarkerSize', 5, 'LineStyle', 'none');

if strcmp(plotType, 'MIDR_Sigma')
    h_16 = plot(nan, nan, 'o--', 'Color', [0.5 0.5 0.5], 'LineWidth', 2, ...
        'MarkerSize', 4, 'MarkerFaceColor', [0.5 0.5 0.5]);
    h_84 = plot(nan, nan, 'o--', 'Color', [0.5 0.5 0.5], 'LineWidth', 2, ...
        'MarkerSize', 4, 'MarkerFaceColor', [0.5 0.5 0.5]);
    legend([h1 h2 h_16 h_84], ...
        {'no-collapse', 'collapse', '16th pct', '84th pct'}, ...
        'Location', 'southeast', 'FontSize', 14);
    % When median is uncommented above update legend to:
    % legend([h1 h2 h_16 h_84], ...
    %     {'no-collapse','collapse','16th pct','Median','84th pct'}, ...
    %     'Location','southeast','FontSize',14);
else
    legend([h1 h2], {'no-collapse', 'collapse'}, ...
        'Location', 'southeast', 'FontSize', 14);
end
legend boxoff

% ======================================
% PDF OVERLAY — outer guard ensures only runs for PDF plotTypes
% ======================================
if strcmp(plotType, 'MIDR_PDF') || strcmp(plotType, 'RDR_PDF') || strcmp(plotType, 'PFA_PDF')

    if strcmp(plotType, 'MIDR_PDF')
        if isfield(msaInputs, 'midrLevels')
            edpLevelsForPDF = msaInputs.midrLevels * 100;
        else
            edpLevelsForPDF = [1 2 4 12];
        end
        if isfield(msaInputs, 'midrLevelLabels')
            edpLevelLabelsForPDF = msaInputs.midrLevelLabels;
        else
            edpLevelLabelsForPDF = {'IO', 'LS', 'CP', 'Coll'};
        end

    elseif strcmp(plotType, 'RDR_PDF')
        if isfield(msaInputs, 'rdrLevels')
            edpLevelsForPDF = msaInputs.rdrLevels * 100;
        else
            edpLevelsForPDF = [0.2 0.5 1.0 2.0];
        end
        if isfield(msaInputs, 'rdrLevelLabels')
            edpLevelLabelsForPDF = msaInputs.rdrLevelLabels;
        else
            edpLevelLabelsForPDF = {'0.2%', '0.5%', '1%', '2%'};
        end

    elseif strcmp(plotType, 'PFA_PDF')
        if isfield(msaInputs, 'pfaLevels')
            edpLevelsForPDF = msaInputs.pfaLevels;
        else
            edpLevelsForPDF = [0.2 0.5 1.0 2.0];
        end
        if isfield(msaInputs, 'pfaLevelLabels')
            edpLevelLabelsForPDF = msaInputs.pfaLevelLabels;
        else
            edpLevelLabelsForPDF = {'Slight', 'Moderate', 'Extensive', 'Complete'};
        end
    end  % end if edpLevels setup

    colors = [0.00 0.00 1.00;
              1.00 0.00 1.00;
              0.00 0.00 0.00;
              1.00 0.00 0.00];

    ax          = gca;
    scaleFactor = ax.XLim(2) * 0.06;
    hPdfLines   = gobjects(length(edpLevelsForPDF), 1);

    for edpIdx = 1:length(edpLevelsForPDF)
        targetEdpLevel     = edpLevelsForPDF(edpIdx);
        saAtTargetEdpLevel = [];

        uniqueSaStripes = unique([allSaLevelsForMSAPlot_control; ...
                                   collapseSaLevels_control]);

        for stripeIdx = 1:length(uniqueSaStripes)
            currentSa       = uniqueSaStripes(stripeIdx);
            idxStripe       = abs(allSaLevelsForMSAPlot_control - currentSa) < tol;
            edpAtThisStripe = allEdpForMSAPlot_control(idxStripe);
            if ~isempty(edpAtThisStripe) && median(edpAtThisStripe) >= targetEdpLevel
                saAtTargetEdpLevel = [saAtTargetEdpLevel; ...
                    repmat(currentSa, sum(idxStripe), 1)];
            end
        end  % end for stripeIdx

        if numel(saAtTargetEdpLevel) < 2
            continue;
        end

        muLn    = mean(log(saAtTargetEdpLevel));
        sigmaLn = std(log(saAtTargetEdpLevel));
        Sa16    = exp(muLn - sigmaLn);
        Sa50    = exp(muLn);
        Sa84    = exp(muLn + sigmaLn);
        Sa_neg3 = exp(muLn - 3*sigmaLn);
        Sa_pos3 = exp(muLn + 3*sigmaLn);

        hPdfLines(edpIdx) = plot([targetEdpLevel targetEdpLevel], [Sa16 Sa84], '-', ...
            'LineWidth', 3.0, 'Color', colors(edpIdx,:), ...
            'DisplayName', edpLevelLabelsForPDF{edpIdx});
        plot(targetEdpLevel, Sa50, 'o', ...
            'MarkerFaceColor', colors(edpIdx,:), ...
            'MarkerEdgeColor', colors(edpIdx,:), ...
            'HandleVisibility', 'off');

        nPts    = 150;
        saLower = linspace(Sa_neg3, Sa16,    nPts);
        saMid   = linspace(Sa16,    Sa84,    nPts);
        saUpper = linspace(Sa84,    Sa_pos3, nPts);

        pdfLower = lognpdf(saLower, muLn, sigmaLn);
        pdfMid   = lognpdf(saMid,   muLn, sigmaLn);
        pdfUpper = lognpdf(saUpper, muLn, sigmaLn);

        globalMax = max([pdfLower, pdfMid, pdfUpper]);
        pdfLower  = pdfLower ./ globalMax * scaleFactor;
        pdfMid    = pdfMid   ./ globalMax * scaleFactor;
        pdfUpper  = pdfUpper ./ globalMax * scaleFactor;

        segments = {saLower, saMid,   saUpper};
        pdfSegs  = {pdfLower, pdfMid, pdfUpper};
        isFilled = [false,    true,   false];

        for s = 1:3
            saSeg  = segments{s};
            pdfSeg = pdfSegs{s};
            if numel(saSeg) < 2
                continue;
            end
            x_pdf = [targetEdpLevel * ones(1, length(saSeg)), ...
                     targetEdpLevel - pdfSeg(length(pdfSeg):-1:1)];
            y_pdf = [saSeg, saSeg(length(saSeg):-1:1)];
            if isFilled(s)
                patch(x_pdf, y_pdf, colors(edpIdx,:), ...
                    'FaceAlpha', 0.30, 'EdgeColor', colors(edpIdx,:), ...
                    'LineWidth', 1.5, 'HandleVisibility', 'off');
            else
                patch(x_pdf, y_pdf, colors(edpIdx,:), ...
                    'FaceColor', 'none', 'EdgeColor', colors(edpIdx,:), ...
                    'LineWidth', 1.5, 'HandleVisibility', 'off');
            end
        end  % end for s

    end  % end for edpIdx

    validPdf = isgraphics(hPdfLines);
    if any(validPdf)
        legend(hPdfLines(validPdf), edpLevelLabelsForPDF(validPdf), ...
            'Location', 'southeast', 'AutoUpdate', 'off');
    end

end  % end if PDF plotType

% ======================================
% EXPORT AND SAVE
% ======================================
if strcmp(plotType, 'MIDR')
    if isConvertToSaKircher == 0
        exportName = fullfile(saveDir, 'CollapseMSA_ControlComp_SaGeoMean');
    else
        exportName = fullfile(saveDir, 'CollapseMSA_ControlComp_SaATC63');
    end
else
    if isConvertToSaKircher == 0
        exportName = fullfile(saveDir, ...
            sprintf('CollapseMSA_ControlComp_SaGeoMean_%s', exportSuffix));
    else
        exportName = fullfile(saveDir, ...
            sprintf('CollapseMSA_ControlComp_SaATC63_%s', exportSuffix));
    end
end

sks_figureFormat(formatMode);
sks_figureExport(exportName);

% ======================================
% RETURN STATS
% ======================================
% controlCompStats.collapseLevelForAllControlComp    = collapseSaLevels_control;
controlCompStats.collapseLevelForAllControlComp    = collapseSaLevelsForSave_control;
controlCompStats.periodUsedForScalingGroundMotions = periodUsedForScalingGroundMotions;

end  % end sks_plot_ControlComp_MSA