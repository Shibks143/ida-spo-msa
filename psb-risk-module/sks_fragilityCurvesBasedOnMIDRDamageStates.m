function sks_fragilityCurvesBasedOnMIDRDamageStates(muCtrlEff, betaRTRCtrlMin, dsToPlotFragParam)
    
    Sa = linspace(0.01, 1, 500);

    frag = zeros(length(Sa), length(muCtrlEff));

    for i = 1:length(muCtrlEff)
        frag(:,i) = normcdf( log(Sa./muCtrlEff(i)) ./ betaRTRCtrlMin(i) );
    end

    figure; hold on; grid on;
    lineStyleList = {'k-','r--','b-.','m:','g-','c--'};

for i = 1:length(muCtrlEff)
    plot(Sa, frag(:,i), lineStyleList{i}, 'LineWidth',2)
end

xlabel('$S_a(T_{ogm})$ (g)','Interpreter','latex')
ylabel('$P[DS \ge ds_k]$','Interpreter','latex')
title('Fragility Curves')
sks_figureFormat('powerpoint')
legend(dsToPlotFragParam,'Location','southeast','Box','off')
% exportName = sprintf('IM_efficiency_figures/Fragility_%s',strjoin(dsToPlotFragParam,'_'));
%% save folder
saveDir = 'E:\OpenSees_PracticeExamples\ida-spo-msa\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';

exportName = fullfile(saveDir, sprintf('Fragility_%s', strjoin(dsToPlotFragParam,'_')));
sks_figureExport(exportName)
% exportName = ['Fragility_' strjoin(dsLabels,'_')];

end