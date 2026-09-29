%
% Procedure: sks_PlotCollapseCDF.m
% -------------------
% Controlled by idaInputs.cdfType:
%   'Collapse' - original collapse CDF, control comp + all comp
%   'MIDR'     - fragility CDF at each MIDR level
%   'RDR'      - fragility CDF at each RDR level
%   'PFA'      - fragility CDF at each PFA level
%
% Author: Curt Haselton (original files)
% Unified by: Shivakumar KS, IIT Madras on 25-Sep-2026
% -------------------
function sks_PlotCollapseCDF(idaInputs)

cdfTypeList = {'Collapse', 'MIDR', 'RDR', 'PFA'};

for cdfIdx = 1:length(cdfTypeList)

    cdfType = cdfTypeList{cdfIdx};

    sigmaLnModeling            = idaInputs.sigmaLnModeling;
    sigmaLnDesignReq           = idaInputs.sigmaLnDesignReq;
    sigmaLnTestData            = idaInputs.sigmaLnTestData;
    analysisType               = idaInputs.analysisType;
    eqListForCollapseIDAs_Name = idaInputs.eqListForCollapseIDAs_Name;
    isConvertToSaKircher       = idaInputs.isConvertToSaKircher;
    formatMode                 = idaInputs.formatMode;

    % Options
    plotNormalCDF                          = 0;
    plotCDFWithRTRVariability              = 1;
    plotIndividualEQPoints                 = 1;
    plotCDFWithAdditionalUncertainty       = 0;
    addTextAnnotations                     = 1;
    markerTypeForIndivColResults           = 'rs';
    markerFaceColorForIndivColResults      = 'w';
    markerTypeForLognormal                 = 'r-';
    markerTypeForLognormalExpandedVariance = 'b--';
    markerTypeForNormal                    = 'b:';
    minValueForPlot = 0.0;
    colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];

    % Navigate to Output folder
    cd(fullfile('..', 'Output'))
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);

    % File names
    if isConvertToSaKircher == 0
        colFileName  = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', eqListForCollapseIDAs_Name);
        fragFileName = sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', eqListForCollapseIDAs_Name);
    else
        colFileName  = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63.mat', eqListForCollapseIDAs_Name);
        fragFileName = sprintf('DATA_FragilityParams_SaATC63_%s.mat', eqListForCollapseIDAs_Name);
    end

    %% Collapse CDF at the building level, this will do as same by original two cdf files
   if strcmp(cdfType, 'Collapse')

    maxValueForPlot = 5.0;
    load(colFileName, 'collapseLevelForAllControlComp', 'collapseLevelForAllComp', ...
        'meanCollapseSaTOneControlComp', 'meanLnCollapseSaTOneControlComp', ...
        'stDevCollapseSaTOneControlComp', 'stDevLnCollapseSaTOneControlComp', ...
        'meanCollapseSaTOneAllComp', 'meanLnCollapseSaTOneAllComp', ...
        'stDevCollapseSaTOneAllComp', 'stDevLnCollapseSaTOneAllComp', ...
        'periodUsedForScalingGroundMotions');

    for figIdx = 1:2

        if figIdx == 1
            compStr = 'ControlComp';
            numEQs = length(collapseLevelForAllControlComp);
            collapseLevelSorted = sort(collapseLevelForAllControlComp);
            cummulativeProbOfCollapseEmpirical = (1/numEQs):(1/numEQs):1.0;

            figure(figIdx);
            hold on

            if plotIndividualEQPoints == 1
                plot(collapseLevelSorted, cummulativeProbOfCollapseEmpirical, markerTypeForIndivColResults, 'MarkerFaceColor', markerFaceColorForIndivColResults);
            end

            if plotCDFWithRTRVariability == 1
                    PlotLogNormalCDF(meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneControlComp, minValueForPlot, maxValueForPlot, markerTypeForLognormal)
                if plotNormalCDF == 1
                    PlotNormalCDF(meanCollapseSaTOneControlComp, stDevCollapseSaTOneControlComp, minValueForPlot, maxValueForPlot, markerTypeForNormal)
                end
                axis([minValueForPlot maxValueForPlot 0.0 1.0]);
                limitsOfAxes = axis;
                XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
                YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
                pos = [limitsOfAxes(1) + 0.71*XdimOfAxis, limitsOfAxes(3) + 0.65*YdimOfAxis];
                text(pos(1), pos(2), ...
                    {['$$\hat{S}_{CT} = ' sprintf('%5.3f', round(exp(meanLnCollapseSaTOneControlComp)*1000)/1000) '$$' char(10) ...
                      '$$\beta_{RTR} = ' sprintf('%5.3f', round(stDevLnCollapseSaTOneControlComp*1000)/1000) '$$']}, ...
                    'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', ...
                    'BackgroundColor', [0.875 0.875 0.875]);
            end

            if plotCDFWithAdditionalUncertainty == 1
                expandedSigmaLn = sqrt(stDevLnCollapseSaTOneControlComp^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2 + sigmaLnModeling^2);
                PlotLogNormalCDF(meanLnCollapseSaTOneControlComp, expandedSigmaLn, minValueForPlot, maxValueForPlot, markerTypeForLognormalExpandedVariance)
            end

        else
            compStr = 'AllComp';
            numEQs = length(collapseLevelForAllComp);
            collapseLevelSorted = sort(collapseLevelForAllComp);
            cummulativeProbOfCollapseEmpirical = (1/numEQs):(1/numEQs):1.0;

            figure(figIdx);
            hold on

            if plotIndividualEQPoints == 1
                plot(collapseLevelSorted, cummulativeProbOfCollapseEmpirical, markerTypeForIndivColResults, 'MarkerFaceColor', markerFaceColorForIndivColResults);
            end

            if plotCDFWithRTRVariability == 1
                    PlotLogNormalCDF(meanLnCollapseSaTOneAllComp, stDevLnCollapseSaTOneAllComp, minValueForPlot, maxValueForPlot, markerTypeForLognormal)
                if plotNormalCDF == 1
                    PlotNormalCDF(meanCollapseSaTOneAllComp, stDevCollapseSaTOneAllComp, minValueForPlot, maxValueForPlot, markerTypeForNormal)
                end
                axis([minValueForPlot maxValueForPlot 0.0 1.0]);
                limitsOfAxes = axis;
                XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
                YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
                pos = [limitsOfAxes(1) + 0.71*XdimOfAxis, limitsOfAxes(3) + 0.65*YdimOfAxis];
                text(pos(1), pos(2), ...
                    {['$$\hat{S}_{CT} = ' sprintf('%5.3f', round(exp(meanLnCollapseSaTOneAllComp)*1000)/1000) '$$' newline ...
                      '$$\beta_{RTR} = ' sprintf('%5.3f', round(stDevLnCollapseSaTOneAllComp*1000)/1000) '$$']}, ...
                    'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', ...
                    'BackgroundColor', [0.875 0.875 0.875]);
            end

            if plotCDFWithAdditionalUncertainty == 1
                expandedSigmaLn = sqrt(stDevLnCollapseSaTOneAllComp^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2 + sigmaLnModeling^2);
                PlotLogNormalCDF(meanLnCollapseSaTOneAllComp, expandedSigmaLn, minValueForPlot, maxValueForPlot, markerTypeForLognormalExpandedVariance)
            end

        end  

        if plotNormalCDF == 1
            if plotCDFWithAdditionalUncertainty == 1
                legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Normal CDF (RTR Var.)', 'Lognormal CDF (RTR + MDL + TD + DR)', 'Location', 'Southeast');
            else
                legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Normal CDF (RTR Var.)', 'Location', 'Southeast');
            end
        else
            if plotCDFWithAdditionalUncertainty == 1
                legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Lognormal CDF (RTR + MDL + TD + DR)', 'Location', 'Southeast');
            else
                legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Location', 'Southeast');
            end
        end

        box on
        grid on
        axis([minValueForPlot maxValueForPlot 0.0 1.0]);

        if isConvertToSaKircher == 0
            temp = sprintf('$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
        else
            DefineSaKircherOverSaGeoMeanValues
            temp = axisLabelForSaKircher;
        end
        xlabel(temp, 'Interpreter', 'latex');
        ylabel('$\mathrm{Pr}[\mathrm{collapse}]$', 'Interpreter', 'latex');
        sks_figureFormat(formatMode)

        if isConvertToSaKircher == 0
            exportName = sprintf('CollapseCDF_%s_SaGeoMean', compStr);
        else
            exportName = sprintf('CollapseCDF_%s_SaATC63', compStr);
        end
        sks_figureExport(exportName)
        hold off

    end   % end figIdx loop

    %% Fragility CDF - MIDR, RDR, PFA
  elseif strcmp(cdfType, 'MIDR') || strcmp(cdfType, 'RDR') || strcmp(cdfType, 'PFA')

    load(colFileName, 'periodUsedForScalingGroundMotions');

    if strcmp(cdfType, 'MIDR')
        maxValueForPlot = 5.0;
        exportSuffix    = 'MIDR';
        load(fragFileName, 'midrLevels', 'midrLevelLabels', 'meanLnSaVals', 'stDevLnSaVals', 'saValsControl', 'meanLnSaValsAllComp', 'stDevLnSaValsAllComp', 'saValsAll');
        numLimitStates = length(midrLevels);
        levelVals   = midrLevels;
        levelLabels = midrLevelLabels;

    elseif strcmp(cdfType, 'RDR')
        maxValueForPlot = 5.0;
        exportSuffix    = 'RDR';
        load(fragFileName, 'rdrLevels', 'rdrLevelLabels', 'rdrMeanLnSaVals', 'rdrStDevLnSaVals', 'rdrSaValsControl', 'rdrMeanLnSaValsAllComp', 'rdrStDevLnSaValsAllComp', 'rdrSaValsAll');
        numLimitStates = length(rdrLevels);
        levelVals   = rdrLevels;
        levelLabels = rdrLevelLabels;

    elseif strcmp(cdfType, 'PFA')
        maxValueForPlot = 4.0;
        exportSuffix    = 'PFA';
        load(fragFileName, 'pfaLevels', 'pfaLevelLabels', 'pfaMeanLnSaVals', 'pfaStDevLnSaVals', 'pfaSaValsControl', 'pfaMeanLnSaValsAllComp', 'pfaStDevLnSaValsAllComp', 'pfaSaValsAll');
        numLimitStates = length(pfaLevels);
        levelVals   = pfaLevels;
        levelLabels = pfaLevelLabels;
    end

    for figIdx = 1:2
        if figIdx == 1
            compStr = 'ControlComp';
            if strcmp(cdfType, 'MIDR')
                saCapacityMatrix = saValsControl;      meanLnSaCapacity = meanLnSaVals;            betaRTR = stDevLnSaVals;
            elseif strcmp(cdfType, 'RDR')
                saCapacityMatrix = rdrSaValsControl;   meanLnSaCapacity = rdrMeanLnSaVals;         betaRTR = rdrStDevLnSaVals;
            elseif strcmp(cdfType, 'PFA')
                saCapacityMatrix = pfaSaValsControl;   meanLnSaCapacity = pfaMeanLnSaVals;         betaRTR = pfaStDevLnSaVals;
            end
        else
            compStr = 'AllComp';
            if strcmp(cdfType, 'MIDR')
                saCapacityMatrix = saValsAll;          meanLnSaCapacity = meanLnSaValsAllComp;     betaRTR = stDevLnSaValsAllComp;
            elseif strcmp(cdfType, 'RDR')
                saCapacityMatrix = rdrSaValsAll;       meanLnSaCapacity = rdrMeanLnSaValsAllComp;  betaRTR = rdrStDevLnSaValsAllComp;
            elseif strcmp(cdfType, 'PFA')
                saCapacityMatrix = pfaSaValsAll;       meanLnSaCapacity = pfaMeanLnSaValsAllComp;  betaRTR = pfaStDevLnSaValsAllComp;
            end
        end

        figure;
        hold on;

        for limitStateIdx = 1:numLimitStates

            thisSaVals = saCapacityMatrix(:, limitStateIdx);
            thisSaVals = thisSaVals(isfinite(thisSaVals) & thisSaVals > 0);
            numEQs = length(thisSaVals);

            if numEQs < 2
                warning('%s - %s level %d (%s) has fewer than 2 valid points - skipping', ...
                    compStr, cdfType, limitStateIdx, levelLabels{limitStateIdx});
                continue
            end

            sortedVals = sort(thisSaVals);
            cummulativeProbEmpirical = (1/numEQs):(1/numEQs):1.0;
            thisColor = colors(mod(limitStateIdx-1, size(colors,1)) + 1, :);

            if plotIndividualEQPoints == 1
                plot(sortedVals, cummulativeProbEmpirical, 's', 'MarkerEdgeColor', thisColor, 'MarkerFaceColor', markerFaceColorForIndivColResults, 'HandleVisibility', 'off');
            end

            if plotCDFWithRTRVariability == 1
                PlotLogNormalCDF(meanLnSaCapacity(limitStateIdx), betaRTR(limitStateIdx), minValueForPlot, maxValueForPlot, '-');
                hLines = get(gca, 'Children');
                set(hLines(1), 'Color', thisColor, 'LineWidth', 3.0);
            end

            if plotCDFWithAdditionalUncertainty == 1
                expandedSigmaLn = sqrt(betaRTR(limitStateIdx)^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2 + sigmaLnModeling^2);
                PlotLogNormalCDF(meanLnSaCapacity(limitStateIdx), expandedSigmaLn, minValueForPlot, maxValueForPlot, markerTypeForLognormalExpandedVariance);
                hLines = get(gca, 'Children');
                set(hLines(1), 'Color', thisColor, 'LineWidth', 2.0);
            end

            if addTextAnnotations == 1
                xPosNorm = 0.50;
                yPosNorm = 0.35 - 0.08*(limitStateIdx-1);
                text(xPosNorm, yPosNorm, ...
                    sprintf('$$\\hat{S}_{%s} = %5.2f\\mathrm{g},\\ \\beta_{RTR} = %5.2f$$', levelLabels{limitStateIdx}, ...
                    round(exp(meanLnSaCapacity(limitStateIdx))*100)/100, round(betaRTR(limitStateIdx)*100)/100), ...
                    'Units', 'normalized', 'HorizontalAlignment', 'left', 'Interpreter', 'latex', 'FontSize', 12, 'Color', thisColor);
            end

        end   % end limitStateIdx loop

        %%%%%%%%%%% Final plot details for this component case %%%%%%%%%%%%%%%%
        axis([minValueForPlot maxValueForPlot 0.0 1.0]);
        box on
        grid on

        if isConvertToSaKircher == 0
            xLabelTemp = sprintf('${im} \\equiv \\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
        else
            DefineSaKircherOverSaGeoMeanValues
            xLabelTemp = axisLabelForSaKircher;
        end
        xlabel(xLabelTemp, 'Interpreter', 'latex');
        ylabel('$\mathrm{Pr}[\mathrm{LS} \ge ls_i \mid \mathrm{IM} = im]$', 'Interpreter', 'latex');
        sks_figureFormat(formatMode)

        if isConvertToSaKircher == 0
            exportName = sprintf('CollapseCDF_%s_SaGeoMean_%s', compStr, exportSuffix);
        else
            exportName = sprintf('CollapseCDF_%s_SaATC63_%s', compStr, exportSuffix);
        end
        sks_figureExport(exportName)
        hold off

    end   % end figIdx loop

end   % end cdfType block

% Return to MatlabProcessors folder
cd(fullfile('..', '..', 'psb_MatlabProcessors'));

fprintf('CDF plots (%s) - DONE\n', cdfType);

end   % end cdfTypeList loop

end