function sks_CDFIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs)

if strcmp(IDA_or_MSA, 'IDA')
    % figure(1); clf;
    % PlotCollapseEmpiricalCDFWithFits_controlComp_proc(idaInputs);  % at building level
    % figure(2); clf;
    % PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(idaInputs);  % at building level

    sks_PlotCollapseCDF(idaInputs);   % Added by Shivakumar KS on 25-Sep-2026 - unified CDF function
    disp('CDF plots - DONE')

elseif strcmp(IDA_or_MSA, 'MSA')
    sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA(msaInputs);
    %   sks_PlotRDR_EmpiricalCDFWithFits_MSA(msaInputs);
end

end
