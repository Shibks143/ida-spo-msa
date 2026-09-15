function sks_IDR_RDR_PFA(IDA_or_MSA, idaInputs, msaInputs)

    if strcmp(IDA_or_MSA, 'IDA')
        sks_IDR_RDR_PFA_IDA(idaInputs);
     
    elseif strcmp(IDA_or_MSA, 'MSA')
        sks_IDR_RDR_PFA_MSA(msaInputs);
        
    end
