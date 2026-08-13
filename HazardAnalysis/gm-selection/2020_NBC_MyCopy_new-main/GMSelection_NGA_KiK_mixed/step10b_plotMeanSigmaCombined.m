function step10b_plotMeanSigmaCombined(selectedRecordsComb, isEqualM_R_tuple)

medianColorLIST = {'k', 'm', 'b', 'r'};
numDB = size(selectedRecordsComb, 2); % number of databases

% when all M-R pairs are equal; plot a single combined mean and cov and otherwise, plot individually
if isEqualM_R_tuple == 1
    PerTgt  = selectedRecordsComb{1}.PerTgt; 
    meanReq = selectedRecordsComb{1}.meanReq;
    covReq  = selectedRecordsComb{1}.covReq;
    sampleSmall = [];
    for i = 1:size(selectedRecordsComb, 1)
        sampleSmall = [sampleSmall; selectedRecordsComb{i}.sampleSmall];
    end
% Sample and target means on 88
    figure(88)
    hTargetMedian = loglog(PerTgt, exp(meanReq), 'color', medianColorLIST{1}, 'LineStyle', '-','linewidth',3);    hold on
    hSelectedMedian = loglog(PerTgt, exp(mean(sampleSmall)),'color', medianColorLIST{1}, 'LineStyle', '--','linewidth',3);
% Sample and target standard deviations on 77
    figure(77)
    hTargetcov = semilogx(PerTgt, sqrt(diag(covReq))','color', medianColorLIST{1}, 'LineStyle', '-','linewidth',3);    hold on
    hSelectedcov = semilogx(PerTgt, std(sampleSmall),'color', medianColorLIST{1}, 'LineStyle', '--','linewidth',3);

    strForLegendMean = {'Target Mean', 'Achieved Mean'};
    plotHandleMedian = [hTargetMedian, hSelectedMedian];
    
    strForLegendcov = {'Target cov', 'Achieved cov'};
    plotHandlecov = [hTargetcov, hSelectedcov];
else
    for i = 1:numDB
        tectonic = selectedRecordsComb{i}.tectonic;
        PerTgt  = selectedRecordsComb{i}.PerTgt; 
        meanReq = selectedRecordsComb{i}.meanReq;
        covReq  = selectedRecordsComb{i}.covReq;
        sampleSmall = selectedRecordsComb{i}.sampleSmall;
    % Sample and target means on 88
        figure(88)
        hTargetMedian = loglog(PerTgt, exp(meanReq),'color', medianColorLIST{i}, 'LineStyle', '-','linewidth',3);    hold on
        hSelectedMedian = loglog(PerTgt, exp(mean(sampleSmall)),'color', medianColorLIST{i}, 'LineStyle', '--','linewidth',3);

    % Sample and target standard deviations on 77
        figure(77)
        hTargetcov = semilogx(PerTgt, sqrt(diag(covReq))','color', medianColorLIST{i}, 'LineStyle', '-','linewidth',3);    hold on
        hSelectedcov = semilogx(PerTgt, std(sampleSmall),'color', medianColorLIST{i}, 'LineStyle', '--','linewidth',3);

        plotHandleMedian(i, 1) = hTargetMedian;
        plotHandleMedian(numDB + i, 1) = hSelectedMedian;

        plotHandlecov(i, 1) = hTargetcov;
        plotHandlecov(numDB + i, 1) = hSelectedcov;

        if strcmp(tectonic, 'Interface/Subduction')
            strForLegendMean{i, 1} = sprintf('Target Mean %s', 'Subduction');
            strForLegendMean{numDB + i, 1} = sprintf('Achieved Mean %s', 'Subduction');

            strForLegendcov{i, 1} = sprintf('Target cov %s', 'Subduction');
            strForLegendcov{numDB + i, 1} = sprintf('Achieved cov %s', 'Subduction');
        else
            strForLegendMean{i, 1} = sprintf('Target Mean %s', tectonic);
            strForLegendMean{numDB + i, 1} = sprintf('Achieved Mean %s', tectonic);

            strForLegendcov{i, 1} = sprintf('Target cov %s', tectonic);
            strForLegendcov{numDB + i, 1} = sprintf('Achieved cov %s', tectonic);
        end
    end    
end

figure(88) 
xlim([min(PerTgt) max(PerTgt)]); ylim([0.01, 3]);
hx = xlabel('Period, $ T $ (s)', 'Interpreter','latex');     hy = ylabel('$\mu_{Sa(T)} $ (g)', 'Interpreter','latex');
%     legh = legend([h881, h882], {'exp(target mean ln Sa)','exp(selected mean lnSa)'});
legh = legend(plotHandleMedian, strForLegendMean, 'location', 'southwest');
htitle = title('Target and selected median Sa');
figureFormatScript_forReport

figure(77)
xlim([min(PerTgt) max(PerTgt)]); ylim([0, 0.7]);
hx = xlabel('Period, $ T $ (s)', 'Interpreter','latex');     hy = ylabel('$\sigma_{\ln Sa(T)}$', 'Interpreter','latex');
%     legh = legend([h771, h772], {'Target $\sigma_{\ln Sa}$','Selected $\sigma_{\ln Sa}$'}, 'Interpreter','latex');
legh = legend(plotHandlecov, strForLegendcov, 'location', 'southwest');
htitle = title('Target and selected \sigma(lnSa)');
figureFormatScript_forReport
