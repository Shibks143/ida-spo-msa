function sks_RunIdaOrMsaOrCLOUD(IDA_or_MSA_or_CLOUD, idaInputs, msaInputs, cloudInputs)

    if strcmp(IDA_or_MSA_or_CLOUD, 'IDA')
        psb_RunCollapseAnaMATLAB_NEWER_proc(idaInputs);
    elseif strcmp(IDA_or_MSA_or_CLOUD, 'MSA')
        sks_RunCollapseAnaMATLAB_MSA(msaInputs);
    elseif strcmp(IDA_or_MSA_or_CLOUD, 'CLOUD')
        sks_RunCollapseAnaMATLAB_CLOUD(cloudInputs);          % one unscaled run per record (Step 3c)
    end



