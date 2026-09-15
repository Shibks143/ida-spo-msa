%
% Procedure: PlotCollapseEmpiricalCDFWithFits_allMIDR_proc.m
% -------------------
% Generalized version of PlotCollapseEmpiricalCDFWithFits_controlComp_proc.m
% that plots the EMPIRICAL CDF (+ lognormal fit) for EVERY midrLevel
% (IO, LS, CP, Collapse, ...) using per-EQ Sa data at each drift level.
% Produces TWO figures - one for the Controlling Component
% (saValsAtTargetDriftControlComp) and one for All Components
% (saValsAtTargetDriftAllComp) - by looping over both data sets rather
% than duplicating the plotting logic.
%
% REQUIRES: idaInputs.eqListForCollapseIDAs_Name must point to a
% DATA_FragilityParams_*.mat file that was saved WITH the raw matrices
% for both component types (see the "Fragility Functions - compute +
% save only (Control + All Comp)" block in
% sks_PlotCollapseIDAsPDF_singleAnaType.m):
%
%   save(fragFileName, 'midrLevels', 'midrLevelLabels', ...
%        'meanLnSaVals', 'stDevLnSaVals', 'saValsAtTargetDriftControlComp', ...
%        'meanLnSaValsAllComp', 'stDevLnSaValsAllComp', 'saValsAtTargetDriftAllComp');
%
% Author: (adapted from Curt Haselton's PlotCollapseEmpiricalCDFWithFits_controlComp_proc.m)
% -------------------
function PlotCollapseEmpiricalCDFWithFits_allMIDR_proc(idaInputs)

periodUsedForScalingGroundMotions = idaInputs.periodUsedForScalingGroundMotions;
sigmaLnModeling                   = idaInputs.sigmaLnModeling;
sigmaLnDesignReq                  = idaInputs.sigmaLnDesignReq;
sigmaLnTestData                   = idaInputs.sigmaLnTestData;
analysisType                      = idaInputs.analysisType;
eqListForCollapseIDAs_Name        = idaInputs.eqListForCollapseIDAs_Name;
isConvertToSaKircher              = idaInputs.isConvertToSaKircher;
formatMode                        = idaInputs.formatMode;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select options

plotCDFWithRTRVariability        = 1;   % empirical + lognormal (RTR only)
plotIndividualEQPoints           = 1;   % plot the raw EQ dots
plotCDFWithAdditionalUncertainty = 0;   % SRSS w/ modeling, design req, test data
addTextAnnotations               = 1;   % Sa_hat / beta_RTR text box per level (labels double as the legend)

markerFaceColorForIndivColResults = 'w';
markerTypeForLognormalExpandedVariance = '--';
minValueForPlot = 0.0;
maxValueForPlot = 5.0;

colors = [ ...
    0.00 0.00 1.00;   % Blue      (e.g. IO)
    1.00 0.00 1.00;   % Magenta   (e.g. LS)
    0.00 0.00 0.00;   % Black     (e.g. CP)
    1.00 0.00 0.00];  % Red       (e.g. Collapse)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Load data
cd ..;
cd Output
analysisTypeFolder = sprintf('%s', analysisType);
cd(analysisTypeFolder);

if(isConvertToSaKircher == 0)
    fragFileName = sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', eqListForCollapseIDAs_Name);
else
    fragFileName = sprintf('DATA_FragilityParams_SaATC63_%s.mat', eqListForCollapseIDAs_Name);
end

load(fragFileName, 'midrLevels', 'midrLevelLabels', 'meanLnSaVals', 'stDevLnSaVals', 'saValsAtTargetDriftControlComp', 'meanLnSaValsAllComp', 'stDevLnSaValsAllComp', 'saValsAtTargetDriftAllComp');


numLimitStates = length(midrLevels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Define the two component "cases" to plot - control comp and
%%%%%%%%%%% all comp - each with its own data, stats, and export name.

componentCases = struct( ...
    'label',       {'ControlComp',                    'AllComp'}, ...
    'saValsAll',   {saValsAtTargetDriftControlComp,    saValsAtTargetDriftAllComp}, ...
    'meanLnSa',    {meanLnSaVals,                      meanLnSaValsAllComp}, ...
    'stDevLnSa',   {stDevLnSaVals,                     stDevLnSaValsAllComp});

%%%%%%%%%%% Outer loop over component case - produces one figure each %%%%%

for caseIdx = 1:length(componentCases)

    thisCase        = componentCases(caseIdx);
    saValsAll        = thisCase.saValsAll;
    meanLnSaThisCase = thisCase.meanLnSa;
    stDevLnSaThisCase = thisCase.stDevLnSa;

    figure;
    hold on;

    %%%%%%%%%%% Plot loop - one empirical CDF (+ fit) per MIDR level %%%%%%
    for limitStateIdx = 1:numLimitStates

        thisSaVals = saValsAll(:, limitStateIdx);
        thisSaVals = thisSaVals(isfinite(thisSaVals) & thisSaVals > 0);
        numEQs = length(thisSaVals);

        if numEQs < 2
            warning('%s - MIDR level %d (%s) has fewer than 2 valid points - skipping', thisCase.label, limitStateIdx, midrLevelLabels{limitStateIdx});
            continue
        end

        % Sort so the empirical CDF is monotonically increasing
        sortedVals = sort(thisSaVals);
        cummulativeProbEmpirical = (1/numEQs):(1/numEQs):1.0;

        thisColor = colors(mod(limitStateIdx-1, size(colors,1)) + 1, :);

        % Plot the raw EQ points for this level
        if(plotIndividualEQPoints == 1)
            plot(sortedVals, cummulativeProbEmpirical, 's', 'MarkerEdgeColor', thisColor, 'MarkerFaceColor', markerFaceColorForIndivColResults, 'HandleVisibility', 'off');
        end

        % Plot the lognormal CDF fit (RTR variability only) using the
        % already-fitted mean/stDev for this level and this component case
        if(plotCDFWithRTRVariability == 1)
            PlotLogNormalCDF(meanLnSaThisCase(limitStateIdx), stDevLnSaThisCase(limitStateIdx), minValueForPlot, maxValueForPlot, '-');
            hLines = get(gca, 'Children');
            set(hLines(1), 'Color', thisColor, 'LineWidth', 3.0);
        end

        % Optional: expanded-variance CDF (SRSS with modeling/design/test unc.)
        if(plotCDFWithAdditionalUncertainty == 1)
            expandedSigmaLn = sqrt(stDevLnSaThisCase(limitStateIdx)^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2 + sigmaLnModeling^2);
            PlotLogNormalCDF(meanLnSaThisCase(limitStateIdx), expandedSigmaLn, minValueForPlot, maxValueForPlot, markerTypeForLognormalExpandedVariance);
            hLines = get(gca, 'Children');
            set(hLines(1), 'Color', thisColor, 'LineWidth', 2.0);
        end

        % Text annotation (median Sa and beta_RTR) 
           if(addTextAnnotations == 1)
                xPosNorm = 0.50;                              % left start, normalized axes units
                yPosNorm = 0.35 - 0.08*(limitStateIdx-1);     % stacked, normalized axes units
                text(xPosNorm, yPosNorm, ...
                    sprintf('$$\\hat{S}_{%s} = %5.2f\\mathrm{g},\\ \\beta_{RTR} = %5.2f$$', midrLevelLabels{limitStateIdx}, ...
                        round(exp(meanLnSaThisCase(limitStateIdx))*100)/100, round(stDevLnSaThisCase(limitStateIdx)*100)/100), ...
                        'Units', 'normalized', 'HorizontalAlignment', 'left', 'Interpreter', 'latex', 'FontSize', 12, 'Color', thisColor);
            end

    end

    %%%%%%%%%%% Final plot details for this component case %%%%%%%%%%%%%%%%

    axis([minValueForPlot maxValueForPlot 0.0 1.0]);
    box on
    grid on

    if(isConvertToSaKircher == 0)
        xLabelTemp = sprintf('${im} \\equiv \\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
    else
        DefineSaKircherOverSaGeoMeanValues
        xLabelTemp = axisLabelForSaKircher;
    end
    xlabel(xLabelTemp, 'Interpreter', 'latex');
    ylabel('$\mathrm{Pr}[\mathrm{LS} \ge ls_i \mid \mathrm{IM} = im]$', 'Interpreter', 'latex');
   
    sks_figureFormat(formatMode)

    % Save the plot - filename carries the component-case label
    if(isConvertToSaKircher == 0)
        exportName = sprintf('CollapseCDF_%s_SaGeoMean_MIDR', thisCase.label);
    else
        exportName = sprintf('CollapseCDF_%s_SaATC63_MIDR', thisCase.label);
    end
    sks_figureExport(exportName)

end

% Go back to MatlabProcessors folder
cd(fullfile('..', '..', 'psb_MatlabProcessors'));