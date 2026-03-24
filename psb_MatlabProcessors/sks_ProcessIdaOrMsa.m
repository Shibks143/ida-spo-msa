function sks_ProcessIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs)

if strcmp(IDA_or_MSA, 'IDA')
    Prak_ProcessDynamicAnalyses_proc(idaInputs);
elseif strcmp(IDA_or_MSA, 'MSA')
    sks_ProcessDynamicAnalyses_proc_MSA(msaInputs);
end




