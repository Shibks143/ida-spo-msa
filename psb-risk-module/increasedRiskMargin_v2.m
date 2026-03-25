function additionalRiskMargin = increasedRiskMargin_v2(hazardData, fragilityData, impFac, imOrAfeBound, boundRange)

% [lambda_0, ~, ~] = computeRiskSingleSite_v1(hazardData, fragilityData);
[lambda_0, ~, ~] = computeRiskSingleSite_v3(hazardData, fragilityData, imOrAfeBound, boundRange);

fragilityData(1) = fragilityData(1) * impFac; % bump up the median im value
% [lambda_imp, ~, ~] = computeRiskSingleSite_v1(hazardData, fragilityData);
[lambda_imp, ~, ~] = computeRiskSingleSite_v3(hazardData, fragilityData, imOrAfeBound, boundRange);

additionalRiskMargin = lambda_0/lambda_imp;
