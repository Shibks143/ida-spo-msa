    function sks_fragilityCurvesBasedOnMIDRDamageStates(muCtrlEff, betaRTRCtrlMin, dsToPlotFragParam, damageMeasure, intensityMeasureType, baseFolder)
    
    Sa = linspace(0.01, 1, 500);
    frag = zeros(length(Sa), length(muCtrlEff));
    
    for i = 1:length(muCtrlEff)
        frag(:,i) = normcdf( log(Sa./muCtrlEff(i)) ./ betaRTRCtrlMin(i) );
    end
    
    figure; hold on; grid on;
    lineStyleList = {'k-','r--','b-.','m:','g-','c--'};
    
    for i = 1:length(muCtrlEff)
        styleID = mod(i-1, length(lineStyleList)) + 1;
        plot(Sa, frag(:,i), lineStyleList{styleID}, 'LineWidth',2)  
    end
    switch intensityMeasureType
        case 'PGA'
            xLab = '$PGA$ (g)';
        case 'SaTa'
            xLab = '$S_a(T_a)$ (g)';
        case 'SaT1'
            xLab = '$S_a(T_1)$ (g)';
        case 'SaTogm'
            xLab = '$S_a(T_{ogm})$ (g)';
        otherwise
            xLab = 'Intensity Measure';
    end

    xlabel(xLab,'Interpreter','latex')
    ylabel('$\mathrm{Pr}[DS \ge ds_k]$','Interpreter','latex')
    % ylabel('$\mathrm{Pr}[DS \ge ds_k]$','Interpreter','latex')
    title('Fragility Curves')
    sks_figureFormat('powerpoint')
    legend(dsToPlotFragParam,'Location','southeast','Box','off')
    %% save folder
    saveDir = fullfile(baseFolder, 'Output_Risk'); 
    exportName = fullfile(saveDir,sprintf('Fragility_%s', damageMeasure));
    sks_figureExport(exportName)
   
    end