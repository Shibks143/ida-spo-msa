    function sks_fragilityCurvesBasedOnMIDRDamageStates(muCtrlEff, betaRTRCtrlMin, dsToPlotFragParam, damageMeasure, intensityMeasureType, baseFolder)
    
    Sa = linspace(0.01, 1, 500);
    frag = zeros(length(Sa), length(muCtrlEff));
    
    for i = 1:length(muCtrlEff)
        frag(:,i) = normcdf( log(Sa./muCtrlEff(i)) ./ betaRTRCtrlMin(i) );
    end
    
    figure; hold on; grid on;
    lineStyleList = {'-','--','-.',':','-','--'};          % line style by plot order
    colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00; 0.50 0.50 0.50];   % DS1-DS4 by severity: blue, magenta, black, red; 5th: gray
    
    for i = 1:length(muCtrlEff)
        styleID = mod(i-1, length(lineStyleList)) + 1;
        cRow = ceil(find(strcmp(dsToPlotFragParam{i}, {'IO','DS1','LS','DS2','CP','DS3','DynInst','DS4'}), 1) / 2);   % colour by severity (MIDR or PHR names)
        if isempty(cRow); cRow = mod(i-1, size(colors, 1)) + 1; end                                       % other names (e.g. midr_xpc): plot order
        plot(Sa, frag(:,i), lineStyleList{styleID}, 'Color', colors(cRow, :), 'LineWidth',2)  
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