function sks_ProcessIdaOrMsaOrCLOUD(IDA_or_MSA_or_CLOUD, idaInputs, msaInputs, cloudInputs)

    if strcmp(IDA_or_MSA_or_CLOUD, 'IDA')
        Prak_ProcessDynamicAnalyses_proc(idaInputs);
    elseif strcmp(IDA_or_MSA_or_CLOUD, 'MSA')
        sks_ProcessDynamicAnalyses_proc_MSA(msaInputs);
    elseif strcmp(IDA_or_MSA_or_CLOUD, 'CLOUD')
        if cloudInputs.isProcessMultipleCollapseRuns == 1
            sks_ProcessCloudRuns(cloudInputs);                  % flag 2: collect Sa, MIDR, RDR, PFA, collapse flags
        else
            disp('CLOUD: scatter and fragility plots are made in the CDF step (flag 4)');
        end
    end




