% -------------------
% Procedure: sks_FitCloudFragility.m
% Cloud analysis fragility (Cornell et al. 2002; Jalayer et al. 2017), for both component cases used by IDA/MSA
% (ControlComp and AllComp):
%   AllComp     : one point per record component
%   ControlComp : one point per record pair, same rules as sks_ProcessFragilityParams_MSA.m:
%                 demand = max(component 1, component 2); collapse case if EITHER component is a collapse case;
%                 pair excluded if EITHER component is a non-collapse run that is singular or non-converged,
%                 or if a component is missing / had a run error
%   non-collapse runs : ln(EDP) = ln(a) + b*ln(Sa) + error,  betaEdpGivenSa = std of residuals (n-2 dof)
%   collapse cases    : P(C|Sa) = 1 / (1 + exp(-(alpha0 + alpha1*ln(Sa))))    (logistic regression)
%   limit state LS    : P(LS|Sa) = Phi( (ln(a*Sa^b) - ln(C_LS)) / betaEdpGivenSa ) * (1 - P(C|Sa)) + P(C|Sa)
%   lognormal summary : medianSa = (C_LS/a)^(1/b),  betaRecordToRecord = betaEdpGivenSa / b,
%                       betaTotal = sqrt(betaRecordToRecord^2 + sigmaLnModeling^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2)
%   (fragilityCurveWithTotalBeta uses the same formula with the EDP dispersion increased by the additional sigmas)
%
% Reads : Output/<analysisType>/EQ_<n>/DATA_collapseCLOUDPlotDataForThisEQ.mat   (written by sks_ProcessCloudRuns.m)
% Writes: Output/<analysisType>/DATA_FragilityParams_SaGeoMean_<setName>.mat     (same name as IDA/MSA; struct
%         cloudFragility.ControlComp / .AllComp, each with .MIDR, .RDR, .PFA and .collapseFit, plus the tables
%         cloudDataControlComp and cloudDataAllComp)
%
% Must be called from psb_MatlabProcessors. PFA is converted from mm/s^2 to g (/9810), as in sks_ProcessFragilityParams_MSA.m.
% Author: Shivakumar K S, IIT Madras
% Date:   09-Nov-2026
% -------------------
function sks_FitCloudFragility(cloudInputs)

analysisTypeLIST                  = cloudInputs.analysisTypeLIST;
eqNumberLIST                      = cloudInputs.eqNumberLIST_forCloud;
eqListForCloud_Name               = cloudInputs.eqListForCloud_Name;
imType                            = cloudInputs.imType;
periodUsedForScalingGroundMotions = cloudInputs.periodUsedForScalingGroundMotions;
sigmaLnModeling                   = cloudInputs.sigmaLnModeling;
sigmaLnDesignReq                  = cloudInputs.sigmaLnDesignReq;
sigmaLnTestData                   = cloudInputs.sigmaLnTestData;

gravityInMmPerSec2 = 9810;    % PFA from the single-run processor is in mm/s^2

% Settings shared by both component cases
fitSettings.collapseModel            = cloudInputs.collapseModel;
fitSettings.saGridForPlot            = cloudInputs.saGridForPlot(:);
fitSettings.minPointsAboveLS         = cloudInputs.minPointsAboveLS;
fitSettings.sigmaLnAdditionalSquared = sigmaLnModeling^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2;
fitSettings.demandNameList           = {'MIDR', 'RDR', 'PFA'};
fitSettings.demandColumnList         = {'maxDriftRatioForFullStr', 'maxResidualDriftRatioForFullStr', 'maxPFAForFullStr'};
fitSettings.demandUnitFactorList     = [1, 1, 1/gravityInMmPerSec2];
fitSettings.demandUnitLabelList      = {'-', '-', 'g'};
fitSettings.limitStateLevelsList     = {cloudInputs.midrLevels,      cloudInputs.rdrLevels,      cloudInputs.pfaLevels};
fitSettings.limitStateLabelsList     = {cloudInputs.midrLevelLabels, cloudInputs.rdrLevelLabels, cloudInputs.pfaLevelLabels};

componentCaseList = {'ControlComp', 'AllComp'};   % same two cases as the IDA/MSA fragilities

startDir             = pwd;
fixedOutputDirectory = fullfile(startDir, '..', 'Output');

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType           = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolderPath = fullfile(fixedOutputDirectory, analysisType);
    % AllComp and ControlComp tables from the per-EQ processed files (as sks_ProcessFragilityParams_MSA.m does for MSA)
    [cloudDataAllComp, cloudDataControlComp] = sks_BuildCloudComponentCaseTables(eqNumberLIST, analysisTypeFolderPath, imType);
    cloudDataForCaseList = {cloudDataControlComp, cloudDataAllComp};

    cloudFragility = struct();
    for componentCaseIndex = 1:numel(componentCaseList)
        componentCase    = componentCaseList{componentCaseIndex};
        cloudDataForCase = cloudDataForCaseList{componentCaseIndex};
        fprintf('\nCLOUD fragility fit: %s, %s (%s)\n', eqListForCloud_Name, componentCase, analysisType);
        cloudFragility.(componentCase) = sks_FitCloudFragilityForOneComponentCase(cloudDataForCase, componentCase, fitSettings);
    end

    % ---------------- Save ----------------
    cloudFragility.saGridForPlot                     = fitSettings.saGridForPlot;
    cloudFragility.componentCaseList                 = componentCaseList;
    cloudFragility.analysisType                      = analysisType;
    cloudFragility.eqListForCloud_Name               = eqListForCloud_Name;
    cloudFragility.imType                            = imType;
    cloudFragility.periodUsedForScalingGroundMotions = periodUsedForScalingGroundMotions;
    cloudFragility.sigmaLnModeling                   = sigmaLnModeling;
    cloudFragility.sigmaLnDesignReq                  = sigmaLnDesignReq;
    cloudFragility.sigmaLnTestData                   = sigmaLnTestData;

    fileNameToSave = fullfile(analysisTypeFolderPath, sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', eqListForCloud_Name));
    save(fileNameToSave, 'cloudFragility', 'cloudDataControlComp', 'cloudDataAllComp');
    fprintf('  saved: DATA_FragilityParams_SaGeoMean_%s.mat (ControlComp and AllComp)\n', eqListForCloud_Name);
end

cd(startDir);
disp('CLOUD fragility fit - DONE')
end


% ---------------- AllComp and ControlComp tables from the per-EQ processed files ----------------
function [cloudDataAllComp, cloudDataControlComp] = sks_BuildCloudComponentCaseTables(eqNumberLIST, analysisTypeFolderPath, imType)

numberOfRecords = numel(eqNumberLIST);
cloudPlotDataLIST = cell(numberOfRecords, 1);
for eqNumberIndex = 1:numberOfRecords
    eqNumber       = eqNumberLIST(eqNumberIndex);
    fileNameToLoad = fullfile(analysisTypeFolderPath, sprintf('EQ_%d', eqNumber), 'DATA_collapseCLOUDPlotDataForThisEQ.mat');
    if isfile(fileNameToLoad)
        cloudPlotDataLIST{eqNumberIndex} = load(fileNameToLoad);
    else
        warning('sks:cloudPlotDataMissing', 'CLOUD: missing %s (run the processing step, flag 2); EQ %d is excluded.', fileNameToLoad, eqNumber);
        cloudPlotDataLIST{eqNumberIndex} = struct('eqNumber', eqNumber, 'eqNumberForGeoMean', floor(eqNumber / 10), ...
            'saOwn', NaN, 'saCompOwn', NaN, 'maxDriftRatioForFullStr', NaN, 'maxResidualDriftRatioForFullStr', NaN, ...
            'maxPFAForFullStr', NaN, 'isCollapsed', NaN, 'isNonConv', NaN, 'isSingular', NaN, 'isCollapseCase', 0, ...
            'isRunError', 1, 'isProcessed', 0, 'analysisType', '');
    end
end
cloudPlotDataArray = [cloudPlotDataLIST{:}];

% ---------------- AllComp: one point per record component ----------------
cloudDataAllComp = table([cloudPlotDataArray.eqNumber]', [cloudPlotDataArray.eqNumberForGeoMean]', ...
    [cloudPlotDataArray.saOwn]', [cloudPlotDataArray.saCompOwn]', ...
    [cloudPlotDataArray.maxDriftRatioForFullStr]', [cloudPlotDataArray.maxResidualDriftRatioForFullStr]', [cloudPlotDataArray.maxPFAForFullStr]', ...
    [cloudPlotDataArray.isCollapsed]', [cloudPlotDataArray.isNonConv]', [cloudPlotDataArray.isSingular]', ...
    [cloudPlotDataArray.isCollapseCase]', [cloudPlotDataArray.isRunError]', [cloudPlotDataArray.isProcessed]', ...
    'VariableNames', {'eqNumber', 'eqNumberForGeoMean', 'saOwn', 'saCompOwn', ...
                      'maxDriftRatioForFullStr', 'maxResidualDriftRatioForFullStr', 'maxPFAForFullStr', ...
                      'isCollapsed', 'isNonConv', 'isSingular', 'isCollapseCase', 'isRunError', 'isProcessed'});
cloudDataAllComp.isExcluded = cloudDataAllComp.isRunError;          % component not usable at all

% ---------------- ControlComp: one point per record pair (same rules as MSA) ----------------
if ~strcmp(imType, 'geoMean')
    warning('sks:cloudControlCompIM', ['CLOUD: ControlComp uses one Sa per pair; with imType = ''%s'' the two components ' ...
        'have different Sa, so the Sa of component 1 is used for the pair.'], imType);
end
eqNumberForGeoMeanLIST = unique(cloudDataAllComp.eqNumberForGeoMean, 'stable');
numberOfPairs          = numel(eqNumberForGeoMeanLIST);

saLevelForPairLIST               = NaN(numberOfPairs, 1);
maxDriftRatioForPairLIST         = NaN(numberOfPairs, 1);
maxResidualDriftRatioForPairLIST = NaN(numberOfPairs, 1);
maxPFAForPairLIST                = NaN(numberOfPairs, 1);
isCollapseCaseForPairLIST        = zeros(numberOfPairs, 1);
isProcessedForPairLIST           = zeros(numberOfPairs, 1);
isExcludedForPairLIST            = ones(numberOfPairs, 1);
numberOfComponentsForPairLIST    = zeros(numberOfPairs, 1);

for pairIndex = 1:numberOfPairs
    componentRowsOfPair = cloudDataAllComp(cloudDataAllComp.eqNumberForGeoMean == eqNumberForGeoMeanLIST(pairIndex), :);
    numberOfComponentsForPairLIST(pairIndex) = height(componentRowsOfPair);

    % Exclusion rules (as MSA ControlComp): both components present and run, and no non-collapse singular/non-converged run
    isAnyComponentMissingOrError = height(componentRowsOfPair) < 2 || any(componentRowsOfPair.isRunError == 1);
    isAnyNonCollapseBadRun       = any(componentRowsOfPair.isCollapsed == 0 & ...
                                       (componentRowsOfPair.isSingular == 1 | componentRowsOfPair.isNonConv == 1));
    if isAnyComponentMissingOrError || isAnyNonCollapseBadRun
        continue;
    end

    saLevelForPairLIST(pairIndex)               = componentRowsOfPair.saOwn(1);     % Sa_geoM is the same for both components
    maxDriftRatioForPairLIST(pairIndex)         = max(componentRowsOfPair.maxDriftRatioForFullStr);
    maxResidualDriftRatioForPairLIST(pairIndex) = max(componentRowsOfPair.maxResidualDriftRatioForFullStr);
    maxPFAForPairLIST(pairIndex)                = max(componentRowsOfPair.maxPFAForFullStr);
    isCollapseCaseForPairLIST(pairIndex)        = double(any(componentRowsOfPair.isCollapseCase == 1));
    isProcessedForPairLIST(pairIndex)           = double(all(componentRowsOfPair.isProcessed == 1));
    isExcludedForPairLIST(pairIndex)            = 0;
end

cloudDataControlComp = table(eqNumberForGeoMeanLIST(:), saLevelForPairLIST, ...
    maxDriftRatioForPairLIST, maxResidualDriftRatioForPairLIST, maxPFAForPairLIST, ...
    isCollapseCaseForPairLIST, isProcessedForPairLIST, isExcludedForPairLIST, numberOfComponentsForPairLIST, ...
    'VariableNames', {'eqNumberForGeoMean', 'saOwn', ...
                      'maxDriftRatioForFullStr', 'maxResidualDriftRatioForFullStr', 'maxPFAForFullStr', ...
                      'isCollapseCase', 'isProcessed', 'isExcluded', 'numberOfComponents'});

fprintf('\nCLOUD data: AllComp %d component(s) (%d used), ControlComp %d pair(s) (%d used)\n', ...
    height(cloudDataAllComp), sum(cloudDataAllComp.isExcluded == 0), height(cloudDataControlComp), sum(cloudDataControlComp.isExcluded == 0));
end


% ---------------- Fit for one component case (ControlComp or AllComp) ----------------
function caseFragility = sks_FitCloudFragilityForOneComponentCase(cloudDataForCase, componentCase, fitSettings)

saGridForPlot            = fitSettings.saGridForPlot;
sigmaLnAdditionalSquared = fitSettings.sigmaLnAdditionalSquared;
minPointsAboveLS         = fitSettings.minPointsAboveLS;

isValidPoint            = cloudDataForCase.isExcluded == 0 & isfinite(cloudDataForCase.saOwn) & cloudDataForCase.saOwn > 0;
isCollapseCase          = isValidPoint & cloudDataForCase.isCollapseCase == 1;
isNonCollapsePoint      = isValidPoint & cloudDataForCase.isCollapseCase == 0 & cloudDataForCase.isProcessed == 1;
numberOfCollapseCases   = sum(isCollapseCase);
numberOfNonCollapsePts  = sum(isNonCollapsePoint);
fprintf('  valid points: %d, non-collapse: %d, collapse cases: %d\n', sum(isValidPoint), numberOfNonCollapsePts, numberOfCollapseCases);

% ---------------- Collapse model: P(C|Sa) ----------------
collapseFit.collapseModel         = fitSettings.collapseModel;
collapseFit.isFitted              = 0;
collapseFit.alpha0                = NaN;
collapseFit.alpha1                = NaN;
collapseFit.medianSaCollapse      = NaN;
collapseFit.numberOfCollapseCases = numberOfCollapseCases;
collapseFit.saOfCollapseCases     = cloudDataForCase.saOwn(isCollapseCase);
collapseFit.probabilityOfCollapse = zeros(size(saGridForPlot));

if strcmp(fitSettings.collapseModel, 'logistic') && numberOfCollapseCases >= 3 && numberOfNonCollapsePts >= 3
    logisticCoefficients  = glmfit(log(cloudDataForCase.saOwn(isValidPoint)), double(isCollapseCase(isValidPoint)), 'binomial', 'link', 'logit');
    collapseFit.isFitted  = 1;
    collapseFit.alpha0    = logisticCoefficients(1);
    collapseFit.alpha1    = logisticCoefficients(2);
    collapseFit.medianSaCollapse      = exp(-collapseFit.alpha0 / collapseFit.alpha1);
    collapseFit.probabilityOfCollapse = 1 ./ (1 + exp(-(collapseFit.alpha0 + collapseFit.alpha1 * log(saGridForPlot))));
    fprintf('  collapse (logistic): alpha0 = %.3f, alpha1 = %.3f, median Sa at P(C) = 0.5: %.3f g\n', ...
        collapseFit.alpha0, collapseFit.alpha1, collapseFit.medianSaCollapse);
else
    warning('sks:cloudNoCollapseFit', ['CLOUD %s: collapse model not fitted (%d collapse case(s); need >= 3 collapse and >= 3 non-collapse points). ' ...
        'P(C|Sa) = 0 is used, so fragility at high Sa may be underestimated.'], componentCase, numberOfCollapseCases);
end
probabilityOfCollapse     = collapseFit.probabilityOfCollapse;
caseFragility.collapseFit = collapseFit;

% ---------------- Demand models and limit-state fragilities ----------------
for demandIndex = 1:numel(fitSettings.demandNameList)
    demandName          = fitSettings.demandNameList{demandIndex};
    demandValues        = cloudDataForCase.(fitSettings.demandColumnList{demandIndex}) * fitSettings.demandUnitFactorList(demandIndex);
    limitStateLevels    = fitSettings.limitStateLevelsList{demandIndex};
    limitStateLabels    = fitSettings.limitStateLabelsList{demandIndex};
    numberOfLimitStates = numel(limitStateLevels);

    isUsableForRegression = isNonCollapsePoint & isfinite(demandValues) & demandValues > 0;
    lnSa           = log(cloudDataForCase.saOwn(isUsableForRegression));
    lnDemand       = log(demandValues(isUsableForRegression));
    numberOfPoints = numel(lnSa);

    demandFit                             = struct();
    demandFit.demandName                  = demandName;
    demandFit.componentCase               = componentCase;
    demandFit.unitLabel                   = fitSettings.demandUnitLabelList{demandIndex};
    demandFit.numberOfPoints              = numberOfPoints;
    demandFit.saOfPoints                  = exp(lnSa);
    demandFit.demandOfPoints              = exp(lnDemand);
    demandFit.lnA                         = NaN;
    demandFit.a                           = NaN;
    demandFit.b                           = NaN;
    demandFit.betaEdpGivenSa              = NaN;
    demandFit.rSquared                    = NaN;
    demandFit.standardErrorLnA            = NaN;
    demandFit.standardErrorB              = NaN;
    demandFit.correlationAbsResidualLnSa  = NaN;
    demandFit.limitStateLevels            = limitStateLevels;
    demandFit.limitStateLabels            = limitStateLabels;
    demandFit.medianSaNoCollapse          = NaN(1, numberOfLimitStates);
    demandFit.betaRecordToRecord          = NaN(1, numberOfLimitStates);
    demandFit.betaTotal                   = NaN(1, numberOfLimitStates);
    demandFit.numberOfPointsAboveLevel    = zeros(1, numberOfLimitStates);
    demandFit.isMedianExtrapolated        = false(1, numberOfLimitStates);
    demandFit.fragilityCurve              = NaN(numel(saGridForPlot), numberOfLimitStates);
    demandFit.fragilityCurveWithTotalBeta = NaN(numel(saGridForPlot), numberOfLimitStates);

    if numberOfPoints < 3 || numel(unique(lnSa)) < 2
        warning('sks:cloudTooFewPoints', 'CLOUD %s %s: only %d usable point(s) (need >= 3, with >= 2 different Sa values); fit skipped.', ...
            componentCase, demandName, numberOfPoints);
        caseFragility.(demandName) = demandFit;
        continue;
    end

    % Linear regression in log space (ordinary least squares)
    designMatrix           = [ones(numberOfPoints, 1) lnSa];
    regressionCoefficients = designMatrix \ lnDemand;
    residuals              = lnDemand - designMatrix * regressionCoefficients;
    betaEdpGivenSa         = sqrt(sum(residuals.^2) / (numberOfPoints - 2));
    coefficientCovariance  = betaEdpGivenSa^2 * inv(designMatrix' * designMatrix); %#ok<MINV>
    correlationMatrix      = corrcoef(abs(residuals), lnSa);

    demandFit.lnA                        = regressionCoefficients(1);
    demandFit.a                          = exp(regressionCoefficients(1));
    demandFit.b                          = regressionCoefficients(2);
    demandFit.betaEdpGivenSa             = betaEdpGivenSa;
    demandFit.rSquared                   = 1 - sum(residuals.^2) / sum((lnDemand - mean(lnDemand)).^2);
    demandFit.standardErrorLnA           = sqrt(coefficientCovariance(1, 1));
    demandFit.standardErrorB             = sqrt(coefficientCovariance(2, 2));
    demandFit.correlationAbsResidualLnSa = correlationMatrix(1, 2);

    fprintf('  %-4s: ln(EDP) = %.3f + %.3f ln(Sa), beta(EDP|Sa) = %.3f, R^2 = %.2f, n = %d\n', ...
        demandName, demandFit.lnA, demandFit.b, betaEdpGivenSa, demandFit.rSquared, numberOfPoints);

    if demandFit.b <= 0
        warning('sks:cloudNegativeSlope', 'CLOUD %s %s: slope b = %.3f <= 0 (EDP does not increase with Sa); limit-state fragilities skipped. Use records covering a wider Sa range.', ...
            componentCase, demandName, demandFit.b);
        caseFragility.(demandName) = demandFit;
        continue;
    end
    if abs(demandFit.correlationAbsResidualLnSa) > 0.5
        warning('sks:cloudHeteroscedastic', 'CLOUD %s %s: scatter changes with Sa (corr(|residual|, ln Sa) = %.2f); constant beta assumption is questionable.', ...
            componentCase, demandName, demandFit.correlationAbsResidualLnSa);
    end

    medianDemandOnGrid = demandFit.lnA + demandFit.b * log(saGridForPlot);
    betaEdpTotal       = sqrt(betaEdpGivenSa^2 + demandFit.b^2 * sigmaLnAdditionalSquared);

    fprintf('        %-5s %10s %12s %10s %10s %8s\n', 'LS', 'capacity', 'median Sa', 'beta_RTR', 'beta_TOT', 'n>C');
    for limitStateIndex = 1:numberOfLimitStates
        limitStateCapacity = limitStateLevels(limitStateIndex);

        demandFit.numberOfPointsAboveLevel(limitStateIndex) = sum(demandFit.demandOfPoints > limitStateCapacity);
        demandFit.medianSaNoCollapse(limitStateIndex)       = exp((log(limitStateCapacity) - demandFit.lnA) / demandFit.b);
        demandFit.betaRecordToRecord(limitStateIndex)       = betaEdpGivenSa / demandFit.b;
        demandFit.betaTotal(limitStateIndex)                = sqrt(demandFit.betaRecordToRecord(limitStateIndex)^2 + sigmaLnAdditionalSquared);
        demandFit.isMedianExtrapolated(limitStateIndex)     = demandFit.medianSaNoCollapse(limitStateIndex) < min(demandFit.saOfPoints) || ...
                                                              demandFit.medianSaNoCollapse(limitStateIndex) > max(demandFit.saOfPoints);

        probabilityOfExceedanceNoCollapse = normcdf((medianDemandOnGrid - log(limitStateCapacity)) / betaEdpGivenSa);
        demandFit.fragilityCurve(:, limitStateIndex) = probabilityOfExceedanceNoCollapse .* (1 - probabilityOfCollapse) + probabilityOfCollapse;
        demandFit.fragilityCurveWithTotalBeta(:, limitStateIndex) = ...
            normcdf((medianDemandOnGrid - log(limitStateCapacity)) / betaEdpTotal) .* (1 - probabilityOfCollapse) + probabilityOfCollapse;

        extrapolationNote = '';
        if demandFit.isMedianExtrapolated(limitStateIndex), extrapolationNote = '  (median outside data Sa range)'; end
        fprintf('        %-5s %10.4f %10.3f g %10.3f %10.3f %8d%s\n', limitStateLabels{limitStateIndex}, limitStateCapacity, ...
            demandFit.medianSaNoCollapse(limitStateIndex), demandFit.betaRecordToRecord(limitStateIndex), ...
            demandFit.betaTotal(limitStateIndex), demandFit.numberOfPointsAboveLevel(limitStateIndex), extrapolationNote);

        if demandFit.numberOfPointsAboveLevel(limitStateIndex) < minPointsAboveLS
            warning('sks:cloudFewAboveLS', 'CLOUD %s %s %s: only %d point(s) above C = %.4f (recommended >= %d).', componentCase, demandName, ...
                limitStateLabels{limitStateIndex}, demandFit.numberOfPointsAboveLevel(limitStateIndex), limitStateCapacity, minPointsAboveLS);
        end
    end
    caseFragility.(demandName) = demandFit;
end
end
