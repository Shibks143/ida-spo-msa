function sks_CDFIdaOrMsa(IDA_or_MSA, idaInputs, msaInputs)

    if strcmp(IDA_or_MSA, 'IDA')
        % figure(1); clf;
        % PlotCollapseEmpiricalCDFWithFits_controlComp_proc(idaInputs);  % at building level - Original
        % figure(2); clf;
        % PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc(idaInputs);  % at building level - Original
    
        sks_PlotCollapseCDF(idaInputs);   % Added by Shivakumar KS on 25-Sep-2026 - unified CDF function
        disp('CDF plots - DONE')
    
    elseif strcmp(IDA_or_MSA, 'MSA')
       
        % sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA(msaInputs);   % at building level - Original
       
        % Step1: fragility params: reads raw EQ folders, fits MLE per demand type and limit state, saves DATA_FragilityParams_SaGeoMean_<name>.mat
        sks_ProcessFragilityParams_MSA(msaInputs)
    
        % Step2: fragility CDF plots: reads both saved .mat files, plots Collapse + MIDR + RDR + PFA CDFs for ControlComp and AllComp
        sks_PlotCollapseCDF_MSA(msaInputs);


    end

end
