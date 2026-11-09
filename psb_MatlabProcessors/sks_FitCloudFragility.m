% -------------------
% Procedure: sks_FitCloudFragility.m
% Cloud analysis fragility (Cornell et al. 2002; Jalayer et al. 2017):
%   non-collapse runs : ln(EDP) = ln(a) + b*ln(Sa) + error,  betaEdpGivenSa = std of residuals (n-2 dof)
%   collapse cases    : P(C|Sa) = 1 / (1 + exp(-(alpha0 + alpha1*ln(Sa))))    (logistic regression)
%   limit state LS    : P(LS|Sa) = Phi( (ln(a*Sa^b) - ln(C_LS)) / betaEdpGivenSa ) * (1 - P(C|Sa)) + P(C|Sa)
%   lognormal summary : medianSa = (C_LS/a)^(1/b),  betaRecordToRecord = betaEdpGivenSa / b,
%                       betaTotal = sqrt(betaRecordToRecord^2 + sigmaLnModeling^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2)
%   (fragilityCurveWithTotalBeta uses the same formula with the EDP dispersion increased by the additional sigmas)
%
% Reads : Output/<analysisType>/DATA_CloudData_<setName>.mat      (written by sks_ProcessCloudRuns.m)
% Writes: Output/<analysisType>/DATA_CloudFragility_<setName>.mat (struct cloudFragility)
%
% Must be called from psb_MatlabProcessors. PFA is converted from mm/s^2 to g (/9810), as in sks_ProcessFragilityParams_MSA.m.
% Author: Shivakumar K S, IIT Madras
% Date:   09-Nov-2026
% -------------------
function sks_FitCloudFragility(cloudInputs)

analysisTypeLIST                  = cloudInputs.analysisTypeLIST;
eqListForCloud_Name               = cloudInputs.eqListForCloud_Name;
imType                            = cloudInputs.imType;
periodUsedForScalingGroundMotions = cloudInputs.periodUsedForScalingGroundMotions;
collapseModel                     = cloudInputs.collapseModel;
saGridForPlot                     = cloudInputs.saGridForPlot(:);
minPointsAboveLS                  = cloudInputs.minPointsAboveLS;
sigmaLnModeling                   = cloudInputs.sigmaLnModeling;
sigmaLnDesignReq                  = cloudInputs.sigmaLnDesignReq;
sigmaLnTestData                   = cloudInputs.sigmaLnTestData;
sigmaLnAdditionalSquared          = sigmaLnModeling^2 + sigmaLnDesignReq^2 + sigmaLnTestData^2;

gravityInMmPerSec2 = 9810;    % PFA from the single-run processor is in mm/s^2

demandNameList       = {'MIDR', 'RDR', 'PFA'};
demandColumnList     = {'maxDriftRatioForFullStr', 'maxResidualDriftRatioForFullStr', 'maxPFAForFullStr'};
demandUnitFactorList = [1, 1, 1/gravityInMmPerSec2];
demandUnitLabelList  = {'-', '-', 'g'};
limitStateLevelsList = {cloudInputs.midrLevels,      cloudInputs.rdrLevels,      cloudInputs.pfaLevels};
limitStateLabelsList = {cloudInputs.midrLevelLabels, cloudInputs.rdrLevelLabels, cloudInputs.pfaLevelLabels};

startDir             = pwd;
fixedOutputDirectory = fullfile(startDir, '..', 'Output');

for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType           = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolderPath = fullfile(fixedOutputDirectory, analysisType);
    fileNameToLoad         = fullfile(analysisTypeFolderPath, sprintf('DATA_CloudData_%s.mat', eqListForCloud_Name));
    if ~isfile(fileNameToLoad)
        error('sksCode:cloudData', 'CLOUD: %s not found; run the processing step (flag 2) first.', fileNameToLoad);
    end
    loadedCloudData = load(fileNameToLoad, 'cloudData');
    cloudData       = loadedCloudData.cloudData;

    isValidRun              = cloudData.isRunError == 0 & isfinite(cloudData.saOwn) & cloudData.saOwn > 0;
    isCollapseCase          = isValidRun & cloudData.isCollapseCase == 1;
    isNonCollapseRun        = isValidRun & cloudData.isCollapseCase == 0 & cloudData.isProcessed == 1;
    numberOfCollapseCases   = sum(isCollapseCase);
    numberOfNonCollapseRuns = sum(isNonCollapseRun);

    fprintf('\nCLOUD fragility fit: %s (%s)\n', eqListForCloud_Name, analysisType);
    fprintf('  valid runs: %d, non-collapse: %d, collapse cases: %d\n', sum(isValidRun), numberOfNonCollapseRuns, numberOfCollapseCases);

    % ---------------- Collapse model: P(C|Sa) ----------------
    collapseFit.collapseModel         = collapseModel;
    collapseFit.isFitted              = 0;
    collapseFit.alpha0                = NaN;
    collapseFit.alpha1                = NaN;
    collapseFit.medianSaCollapse      = NaN;
    collapseFit.numberOfCollapseCases = numberOfCollapseCases;
    collapseFit.saOfCollapseCases     = cloudData.saOwn(isCollapseCase);
    collapseFit.probabilityOfCollapse = zeros(size(saGridForPlot));

    if strcmp(collapseModel, 'logistic') && numberOfCollapseCases >= 3 && numberOfNonCollapseRuns >= 3
        logisticCoefficients  = glmfit(log(cloudData.saOwn(isValidRun)), double(isCollapseCase(isValidRun)), 'binomial', 'link', 'logit');
        collapseFit.isFitted  = 1;
        collapseFit.alpha0    = logisticCoefficients(1);
        collapseFit.alpha1    = logisticCoefficients(2);
        collapseFit.medianSaCollapse      = exp(-collapseFit.alpha0 / collapseFit.alpha1);
        collapseFit.probabilityOfCollapse = 1 ./ (1 + exp(-(collapseFit.alpha0 + collapseFit.alpha1 * log(saGridForPlot))));
        fprintf('  collapse (logistic): alpha0 = %.3f, alpha1 = %.3f, median Sa at P(C) = 0.5: %.3f g\n', ...
            collapseFit.alpha0, collapseFit.alpha1, collapseFit.medianSaCollapse);
    else
        warning('sks:cloudNoCollapseFit', ['CLOUD: collapse model not fitted (%d collapse case(s); need >= 3 collapse and >= 3 non-collapse runs). ' ...
            'P(C|Sa) = 0 is used, so fragility at high Sa may be underestimated.'], numberOfCollapseCases);
    end
    probabilityOfCollapse = collapseFit.probabilityOfCollapse;

    % ---------------- Demand models and limit-state fragilities ----------------
    cloudFragility = struct();
    for demandIndex = 1:numel(demandNameList)
        demandName          = demandNameList{demandIndex};
        demandValues        = cloudData.(demandColumnList{demandIndex}) * demandUnitFactorList(demandIndex);
        limitStateLevels    = limitStateLevelsList{demandIndex};
        limitStateLabels    = limitStateLabelsList{demandIndex};
        numberOfLimitStates = numel(limitStateLevels);

        isUsableForRegression = isNonCollapseRun & isfinite(demandValues) & demandValues > 0;
        lnSa           = log(cloudData.saOwn(isUsableForRegression));
        lnDemand       = log(demandValues(isUsableForRegression));
        numberOfPoints = numel(lnSa);

        demandFit                             = struct();
        demandFit.demandName                  = demandName;
        demandFit.unitLabel                   = demandUnitLabelList{demandIndex};
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
            warning('sks:cloudTooFewPoints', 'CLOUD %s: only %d usable point(s) (need >= 3, with >= 2 different Sa values); fit skipped.', demandName, numberOfPoints);
            cloudFragility.(demandName) = demandFit;
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
            warning('sks:cloudNegativeSlope', 'CLOUD %s: slope b = %.3f <= 0 (EDP does not increase with Sa); limit-state fragilities skipped. Use records covering a wider Sa range.', demandName, demandFit.b);
            cloudFragility.(demandName) = demandFit;
            continue;
        end
        if abs(demandFit.correlationAbsResidualLnSa) > 0.5
            warning('sks:cloudHeteroscedastic', 'CLOUD %s: scatter changes with Sa (corr(|residual|, ln Sa) = %.2f); constant beta assumption is questionable.', demandName, demandFit.correlationAbsResidualLnSa);
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
                warning('sks:cloudFewAboveLS', 'CLOUD %s %s: only %d point(s) above C = %.4f (recommended >= %d).', demandName, ...
                    limitStateLabels{limitStateIndex}, demandFit.numberOfPointsAboveLevel(limitStateIndex), limitStateCapacity, minPointsAboveLS);
            end
        end
        cloudFragility.(demandName) = demandFit;
    end

    % ---------------- Save ----------------
    cloudFragility.collapseFit                       = collapseFit;
    cloudFragility.saGridForPlot                     = saGridForPlot;
    cloudFragility.analysisType                      = analysisType;
    cloudFragility.eqListForCloud_Name               = eqListForCloud_Name;
    cloudFragility.imType                            = imType;
    cloudFragility.periodUsedForScalingGroundMotions = periodUsedForScalingGroundMotions;
    cloudFragility.sigmaLnModeling                   = sigmaLnModeling;
    cloudFragility.sigmaLnDesignReq                  = sigmaLnDesignReq;
    cloudFragility.sigmaLnTestData                   = sigmaLnTestData;

    fileNameToSave = fullfile(analysisTypeFolderPath, sprintf('DATA_CloudFragility_%s.mat', eqListForCloud_Name));
    save(fileNameToSave, 'cloudFragility');
    fprintf('  saved: DATA_CloudFragility_%s.mat\n', eqListForCloud_Name);
end

cd(startDir);
disp('CLOUD fragility fit - DONE')
end
