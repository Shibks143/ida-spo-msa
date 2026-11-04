function sks_seismicRiskCal(MIDR_or_PHR, MIDRInputs, PHRInputs)

if strcmp(MIDR_or_PHR, 'MIDR')
    sks_seismicRiskCal_MIDR(MIDRInputs);
elseif strcmp(MIDR_or_PHR, 'PHR')
    fprintf('PHR: risk (lambda_DS1-DS4) is computed together with ARCR in masterFunLambdaARCR_v2; set the ARCR flag.\n');
end

