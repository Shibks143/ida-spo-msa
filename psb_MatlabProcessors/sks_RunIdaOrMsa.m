function sks_RunIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs)

    if strcmp(IDA_or_MSA, 'IDA')
        psb_RunCollapseAnaMATLAB_NEWER_proc(idaInputs);
    elseif strcmp(IDA_or_MSA, 'MSA')
        sks_RunCollapseAnaMATLAB_MSA(msaInputs);
    end



