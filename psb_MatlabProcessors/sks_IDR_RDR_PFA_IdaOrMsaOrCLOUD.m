function sks_IDR_RDR_PFA_IdaOrMsaOrCLOUD(IDA_or_MSA_or_CLOUD, idaInputs, msaInputs, cloudInputs)

    if strcmp(IDA_or_MSA_or_CLOUD, 'IDA')
        sks_IDR_RDR_PFA_IDA(idaInputs);

    elseif strcmp(IDA_or_MSA_or_CLOUD, 'MSA')
        sks_IDR_RDR_PFA_MSA(msaInputs);

    elseif strcmp(IDA_or_MSA_or_CLOUD, 'CLOUD')
        disp('CLOUD: IDR/RDR/PFA plots not implemented yet')  % cloudInputs available for a later step

    end
