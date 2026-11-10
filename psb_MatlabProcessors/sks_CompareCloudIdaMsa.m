% -------------------
% Procedure: sks_CompareCloudIdaMsa.m
% Phase 3: compares the fragility curves of the same building and ground-motion set obtained with
% IDA, MSA and Cloud analysis, plus a "converted" curve (Pang and Wang 2021), for MIDR only (RDR and PFA are
% not compared for now) and for both component cases (ControlComp and AllComp). Read-only: it only reads the results of
% the three methods and writes figures, a .mat file and a .csv table.
%
% How each method's fragility is defined (record-to-record variability only, so the methods are compared like for like):
%   IDA   : lognormal fitted by the method of moments to the Sa(T1) at which each record reaches the limit state
%           (median = exp(mean ln Sa), beta = std ln Sa); Vamvatsikos and Cornell (2002), FEMA P695 (2009).
%   MSA   : lognormal fitted by maximum likelihood to the fraction of records exceeding the limit state at each
%           stripe (binomial likelihood); Baker (2015). Observed fractions are also plotted as points.
%   Cloud : ln(EDP) = ln(a) + b ln(Sa) on non-collapse runs, combined with the logistic collapse probability:
%           P(LS|Sa) = Phi((ln(a Sa^b) - ln C)/beta)(1 - P(C|Sa)) + P(C|Sa); Cornell et al. (2002), Jalayer et al. (2017).
%   Converted (Pang and Wang 2021): a lognormal passed exactly through two fragility points:
%           ln(eta) = (ln IM1 z2 - ln IM2 z1)/(z2 - z1),  beta = (ln IM2 - ln IM1)/(z2 - z1),  z = Phi^-1(P).
%           The two IM levels are chosen from the Cloud fit, at the centres (in ln Sa) of the lower and upper
%           "IM boxes" of each limit state (Cloud P from 1% to 50% and from 50% to 99%), and the two P values are the
%           observed MSA exceedance fractions at the nearest MSA stripes. Note: in the paper the records are run at the
%           chosen IM levels; here the existing MSA stripes are reused, so no new analyses are needed.
%
% Reference for the comparison: MSA (maximum likelihood on stripes, no assumption on the shape of each record's
% response with Sa); differences are reported as median ratio to MSA, beta difference to MSA and the largest
% difference in probability between the curves over the Sa range.
%
% Reads : Output/<analysisType>/IDA/DATA_FragilityParams_SaGeoMean_<setName>.mat
%         Output/<analysisType>/MSA/DATA_FragilityParams_SaGeoMean_<setName>.mat
%         Output/<analysisType>/CLOUD/DATA_FragilityParams_SaGeoMean_<setName>.mat
% Writes: Output/<analysisType>/COMPARE/DATA_FragilityComparison_SaGeoMean_<setName>.mat and .csv
%         Output/<analysisType>/COMPARE/CollapseCDF_<ControlComp|AllComp>_SaGeoMean_COMPARE_MIDR
%
% References:
%   Cornell CA, Jalayer F, Hamburger RO, Foutch DA (2002) J Struct Eng 128(4):526-533
%   Vamvatsikos D, Cornell CA (2002) Earthq Eng Struct Dyn 31(3):491-514
%   Baker JW (2015) Earthq Spectra 31(1):579-599
%   Jalayer F, Ebrahimian H, Miano A, Manfredi G, Sezen H (2017) Earthq Eng Struct Dyn 46(15):2639-2663
%   Pang Y, Wang X (2021) J Struct Eng 147(6):04021070, doi 10.1061/(ASCE)ST.1943-541X.0002998
%
% Must be called from psb_MatlabProcessors. All figure text is LaTeX (sks_figureFormat sets the interpreter).
% Author: Shivakumar K S, IIT Madras
% Date:   10-Nov-2026
% -------------------
function sks_CompareCloudIdaMsa(cloudInputs)

analysisTypeLIST = cloudInputs.analysisTypeLIST;
setName          = cloudInputs.eqListForCloud_Name;      % same set name as IDA/MSA, e.g. 'GMSetC'
formatMode       = cloudInputs.formatMode;

% For now only MIDR is compared; add 'RDR' / 'PFA' (with prefixes 'rdr' / 'pfa') to compare those too
demandNameList     = {'MIDR'};
idaFieldPrefixList = {''};                                % IDA: meanLnSaVals (MIDR); rdrMeanLnSaVals, pfaMeanLnSaVals for RDR/PFA
msaFieldPrefixList = {'midr'};                            % MSA: midrThetaControl; rdrThetaControl, pfaThetaControl for RDR/PFA
componentCaseList  = {'ControlComp', 'AllComp'};
idaCaseSuffixList  = {'', 'AllComp'};                     % IDA: meanLnSaVals / meanLnSaValsAllComp
msaCaseSuffixList  = {'Control', 'AllComp'};              % MSA: midrThetaControl / midrThetaAllComp

methodNameList    = {'IDA', 'MSA', 'CLOUD', 'Converted'};
methodLineStyles  = {'-', '--', ':', '-.'};
methodLineWidths  = [1.8, 1.8, 2.2, 1.2];
methodLegendText  = {'(IDA)', '(MSA)', '(Cloud)', '(Converted, Pang and Wang 2021)'};
limitStateColorOrder = [0.00 0.00 1.00;   % blue    - level 1 (IO / DS1)   same order as the IDA/MSA plots
                        1.00 0.00 1.00;   % magenta - level 2 (LS / DS2)
                        0.00 0.00 0.00;   % black   - level 3 (CP / DS3)
                        1.00 0.00 0.00];  % red     - level 4 (Coll / DS4)
lowerBoxCentreZ = 0.5 * norminv(0.01);    % centre (in ln Sa) of the lower IM box, Cloud P from 1% to 50%  (z = -1.163, P = 0.12)
upperBoxCentreZ = 0.5 * norminv(0.99);    % centre of the upper IM box, Cloud P from 50% to 99%            (z = +1.163, P = 0.88)

startDir             = pwd;
fixedOutputDirectory = fullfile(startDir, '..', 'Output');

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType       = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolder = fullfile(fixedOutputDirectory, analysisType);
    fragilityFileName  = sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', setName);
    idaFile   = fullfile(analysisTypeFolder, 'IDA',   fragilityFileName);
    msaFile   = fullfile(analysisTypeFolder, 'MSA',   fragilityFileName);
    cloudFile = fullfile(analysisTypeFolder, 'CLOUD', fragilityFileName);
    missingFiles = {idaFile, msaFile, cloudFile};
    missingFiles = missingFiles(~cellfun(@isfile, missingFiles));
    if ~isempty(missingFiles)
        fprintf('COMPARE %s: skipped, missing %s\n', setName, strjoin(missingFiles, ', '));
        continue;
    end
    idaFragility   = load(idaFile);
    msaFragility   = load(msaFile);
    cloudLoaded    = load(cloudFile);
    if ~isfield(cloudLoaded, 'cloudFragility')
        error('sks_CompareCloudIdaMsa: %s does not hold Cloud results (no cloudFragility).', cloudFile);
    end
    cloudFragility = cloudLoaded.cloudFragility;
    saGridForPlot  = cloudFragility.saGridForPlot(:);
    compareFolderPath = fullfile(analysisTypeFolder, 'COMPARE');
    if ~isfolder(compareFolderPath)
        mkdir(compareFolderPath);
    end

    imAxisLabelForFragility = sprintf('${im} \\equiv \\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', ...
        cloudFragility.periodUsedForScalingGroundMotions);
    fragilityAxisLabel = '$\mathrm{Pr}[\mathrm{LS} \ge ls_i \mid \mathrm{IM} = im]$';

    comparisonRows = {};
    for componentCaseIndex = 1:numel(componentCaseList)
        componentCase = componentCaseList{componentCaseIndex};
        for demandIndex = 1:numel(demandNameList)
            demandName = demandNameList{demandIndex};
            cloudFit   = cloudFragility.(componentCase).(demandName);
            limitStateLevels    = cloudFit.limitStateLevels;
            limitStateLabels    = cloudFit.limitStateLabels;
            numberOfLimitStates = numel(limitStateLevels);

            % ---- medians and betas of IDA and MSA (record-to-record only) ----
            idaMeanLnField = sks_IdaFieldName(idaFieldPrefixList{demandIndex}, 'MeanLnSaVals', idaCaseSuffixList{componentCaseIndex});
            idaStDevField  = sks_IdaFieldName(idaFieldPrefixList{demandIndex}, 'StDevLnSaVals', idaCaseSuffixList{componentCaseIndex});
            idaMedianSa = exp(idaFragility.(idaMeanLnField)(:)');
            idaBeta     = idaFragility.(idaStDevField)(:)';
            msaPrefix   = msaFieldPrefixList{demandIndex};
            msaSuffix   = msaCaseSuffixList{componentCaseIndex};
            msaMedianSa = msaFragility.([msaPrefix 'Theta' msaSuffix])(:)';
            msaBeta     = msaFragility.([msaPrefix 'Beta' msaSuffix])(:)';
            msaStripeSa         = msaFragility.([msaPrefix 'StripeSa' msaSuffix])(:);
            msaExceedanceProb   = msaFragility.([msaPrefix 'ExceedanceProb' msaSuffix]);
            cloudMedianSa = cloudFit.medianSaNoCollapse(:)';
            cloudBeta     = cloudFit.betaRecordToRecord(:)';

            % ---- converted curve (Pang and Wang 2021) from the Cloud fit and the MSA stripes ----
            convertedMedianSa = NaN(1, numberOfLimitStates);
            convertedBeta     = NaN(1, numberOfLimitStates);
            convertedPoints   = NaN(numberOfLimitStates, 4);    % [Sa1, P1, Sa2, P2]
            for limitStateIndex = 1:numberOfLimitStates
                if ~(isfinite(cloudMedianSa(limitStateIndex)) && isfinite(cloudBeta(limitStateIndex)) && cloudBeta(limitStateIndex) > 0)
                    continue;
                end
                targetLowerSa = cloudMedianSa(limitStateIndex) * exp(lowerBoxCentreZ * cloudBeta(limitStateIndex));
                targetUpperSa = cloudMedianSa(limitStateIndex) * exp(upperBoxCentreZ * cloudBeta(limitStateIndex));
                isUsableStripe = msaExceedanceProb(:, limitStateIndex) > 0 & msaExceedanceProb(:, limitStateIndex) < 1;   % Phi^-1 needs 0 < P < 1
                usableStripeIndices = find(isUsableStripe);
                if numel(usableStripeIndices) < 2
                    continue;
                end
                [~, nearestLower] = min(abs(log(msaStripeSa(usableStripeIndices)) - log(targetLowerSa)));
                lowerStripeIndex  = usableStripeIndices(nearestLower);
                higherStripeIndices = usableStripeIndices(msaStripeSa(usableStripeIndices) > msaStripeSa(lowerStripeIndex));
                if isempty(higherStripeIndices)
                    continue;
                end
                [~, nearestUpper] = min(abs(log(msaStripeSa(higherStripeIndices)) - log(targetUpperSa)));
                upperStripeIndex  = higherStripeIndices(nearestUpper);
                lowerPoint = [msaStripeSa(lowerStripeIndex), msaExceedanceProb(lowerStripeIndex, limitStateIndex)];
                upperPoint = [msaStripeSa(upperStripeIndex), msaExceedanceProb(upperStripeIndex, limitStateIndex)];
                [convertedMedianSa(limitStateIndex), convertedBeta(limitStateIndex)] = sks_LognormalThroughTwoPoints(lowerPoint, upperPoint);
                convertedPoints(limitStateIndex, :) = [lowerPoint, upperPoint];
            end

            % ---- curves on one Sa grid ----
            curvesByMethod = cell(1, numel(methodNameList));
            curvesByMethod{1} = sks_LognormalCurves(saGridForPlot, idaMedianSa, idaBeta);
            curvesByMethod{2} = sks_LognormalCurves(saGridForPlot, msaMedianSa, msaBeta);
            curvesByMethod{3} = cloudFit.fragilityCurve;               % full Cloud model (includes P(C|Sa) when fitted)
            curvesByMethod{4} = sks_LognormalCurves(saGridForPlot, convertedMedianSa, convertedBeta);
            mediansByMethod = {idaMedianSa, msaMedianSa, cloudMedianSa, convertedMedianSa};
            betasByMethod   = {idaBeta, msaBeta, cloudBeta, convertedBeta};

            % ---- table rows: differences to MSA ----
            for limitStateIndex = 1:numberOfLimitStates
                for methodIndex = 1:numel(methodNameList)
                    medianSa = mediansByMethod{methodIndex}(limitStateIndex);
                    beta     = betasByMethod{methodIndex}(limitStateIndex);
                    maxProbabilityDifference = max(abs(curvesByMethod{methodIndex}(:, limitStateIndex) - curvesByMethod{2}(:, limitStateIndex)));
                    comparisonRows(end+1, :) = {componentCase, demandName, limitStateLabels{limitStateIndex}, limitStateLevels(limitStateIndex), ...
                        methodNameList{methodIndex}, medianSa, beta, medianSa / msaMedianSa(limitStateIndex), beta - msaBeta(limitStateIndex), ...
                        maxProbabilityDifference}; %#ok<AGROW>
                end
            end

            % ---- figure: four methods per limit state; colour = limit state, line style = method ----
            figure; hold on; box on; grid on;
            legendHandles = []; legendEntries = {};
            for limitStateIndex = 1:numberOfLimitStates
                limitStateColor = limitStateColorOrder(mod(limitStateIndex - 1, size(limitStateColorOrder, 1)) + 1, :);
                for methodIndex = 1:numel(methodNameList)
                    curveHandle = plot(saGridForPlot, curvesByMethod{methodIndex}(:, limitStateIndex), methodLineStyles{methodIndex}, ...
                        'Color', limitStateColor, 'LineWidth', methodLineWidths(methodIndex));
                    if methodIndex == 2
                        legendHandles(end+1) = curveHandle; %#ok<AGROW>
                        legendEntries{end+1} = sprintf('%s: MSA median %.2f g', limitStateLabels{limitStateIndex}, msaMedianSa(limitStateIndex)); %#ok<AGROW>
                    end
                end
                plot(msaStripeSa, msaExceedanceProb(:, limitStateIndex), 'o', 'Color', limitStateColor, 'MarkerSize', 5);
                if all(isfinite(convertedPoints(limitStateIndex, :)))
                    plot(convertedPoints(limitStateIndex, [1 3]), convertedPoints(limitStateIndex, [2 4]), 's', ...
                        'Color', limitStateColor, 'MarkerFaceColor', limitStateColor, 'MarkerSize', 6);
                end
            end
            % line-style key (black), worded as in the IDA/MSA CDF plots
            for methodIndex = 1:numel(methodNameList)
                legendHandles(end+1) = plot(nan, nan, ['k' methodLineStyles{methodIndex}], 'LineWidth', methodLineWidths(methodIndex)); %#ok<AGROW>
                legendEntries{end+1} = methodLegendText{methodIndex}; %#ok<AGROW>
            end
            legendHandles(end+1) = plot(nan, nan, 'ko', 'MarkerSize', 5); %#ok<AGROW>
            legendEntries{end+1} = '(MSA observed fraction)'; %#ok<AGROW>
            legendHandles(end+1) = plot(nan, nan, 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 6); %#ok<AGROW>
            legendEntries{end+1} = '(points used for Converted)'; %#ok<AGROW>

            xlim([0 max(saGridForPlot)]); ylim([0 1]);
            xlabel(imAxisLabelForFragility, 'Interpreter', 'latex');
            ylabel(fragilityAxisLabel, 'Interpreter', 'latex');
            legend(legendHandles, legendEntries, 'Location', 'southeast');
            sks_figureFormat(formatMode);
            sks_figureExport(fullfile(compareFolderPath, sprintf('CollapseCDF_%s_SaGeoMean_COMPARE_%s', componentCase, demandName)));
            close(gcf);
        end
    end

    comparisonTable = cell2table(comparisonRows, 'VariableNames', {'componentCase', 'demandName', 'limitStateLabel', 'limitStateLevel', ...
        'method', 'medianSa', 'beta', 'medianRatioToMSA', 'betaMinusMSA', 'maxProbabilityDifferenceToMSA'});
    comparisonFileName = sprintf('DATA_FragilityComparison_SaGeoMean_%s', setName);
    save(fullfile(compareFolderPath, [comparisonFileName '.mat']), 'comparisonTable', 'analysisType', 'setName');
    writetable(comparisonTable, fullfile(compareFolderPath, [comparisonFileName '.csv']));
    fprintf('COMPARE %s: saved %s (.mat, .csv) and %d figures in %s\n', setName, comparisonFileName, ...
        numel(componentCaseList) * numel(demandNameList), compareFolderPath);
end
cd(startDir);
end

% ---------------- local functions ----------------
function fieldName = sks_IdaFieldName(prefix, baseName, caseSuffix)
% IDA field names: meanLnSaVals / rdrMeanLnSaVals / pfaMeanLnSaVals, plus 'AllComp' for all components
if isempty(prefix)
    fieldName = [lower(baseName(1)) baseName(2:end) caseSuffix];
else
    fieldName = [prefix baseName caseSuffix];
end
end

function fragilityCurves = sks_LognormalCurves(saGridForPlot, medianSa, beta)
% Lognormal fragility for each limit state (columns); NaN where median or beta is not available
fragilityCurves = NaN(numel(saGridForPlot), numel(medianSa));
for limitStateIndex = 1:numel(medianSa)
    if isfinite(medianSa(limitStateIndex)) && isfinite(beta(limitStateIndex)) && beta(limitStateIndex) > 0
        fragilityCurves(:, limitStateIndex) = normcdf(log(saGridForPlot / medianSa(limitStateIndex)) / beta(limitStateIndex));
    end
end
end

function [medianSa, beta] = sks_LognormalThroughTwoPoints(lowerPoint, upperPoint)
% Pang and Wang (2021): lognormal passing exactly through two fragility points [Sa, P], 0 < P < 1
lowerZ = norminv(lowerPoint(2));
upperZ = norminv(upperPoint(2));
if upperZ <= lowerZ
    medianSa = NaN; beta = NaN;    % P must increase with Sa
    return;
end
medianSa = exp((log(lowerPoint(1)) * upperZ - log(upperPoint(1)) * lowerZ) / (upperZ - lowerZ));
beta     = (log(upperPoint(1)) - log(lowerPoint(1))) / (upperZ - lowerZ);
end
