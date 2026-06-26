function sks_IM_efficieny(MIDR_or_PHR, MIDRInputs, PHRInputs)

if strcmp(MIDR_or_PHR, 'MIDR')
    sks_IM_efficieny_MIDR(MIDRInputs);
elseif strcmp(MIDR_or_PHR, 'PHR')
    sks_IM_efficiency_PHR(PHRInputs)
    % IM_efficiency_v3a_NewDSs_Dayala(PHRInputs);
end