function sks_seismicRiskCal(MIDR_or_PHR, MIDRInputs, PHRInputs)

if strcmp(MIDR_or_PHR, 'MIDR')
    sks_seismicRiskCal_MIDR(MIDRInputs);
elseif strcmp(MIDR_or_PHR, 'PHR')
    scriptAnnualizedRCR_v2_paper(PHRInputs);
end

