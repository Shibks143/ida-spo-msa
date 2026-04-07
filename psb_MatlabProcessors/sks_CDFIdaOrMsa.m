function sks_CDFIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs)


if strcmp(IDA_or_MSA, 'IDA')
    figure(1); clf;
    PlotCollapseEmpiricalCDFWithFits_controlComp_proc(idaInputs);
    figure(2); clf;
    PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(idaInputs);
    
elseif strcmp(IDA_or_MSA, 'MSA')
    sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA(msaInputs);
end
 

  




    