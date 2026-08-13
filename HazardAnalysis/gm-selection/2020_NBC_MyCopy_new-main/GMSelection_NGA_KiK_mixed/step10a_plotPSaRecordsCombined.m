function step10a_plotPSaRecordsCombined(selectedRecordsComb, colorRecLIST)

medianColorLIST = {'k', 'm', 'b', 'r'};
numDB = size(selectedRecordsComb, 2); % number of databases

for i = 1:numDB
    selectedRecords = selectedRecordsComb{i};
    colorRecs = colorRecLIST(i, :);

    tectonic = selectedRecords.tectonic;
    PerTgt  = selectedRecords.PerTgt;
    meanReq = selectedRecords.meanReq;
    covReq  = selectedRecords.covReq;
    perKnown = selectedRecords.perKnown;
    recPer  = selectedRecords.recPer;
%     sampleSmall = selectedRecords.sampleSmall; % not used here
    SaSelected  = selectedRecords.SaSelected;
    scaleFactors  = selectedRecords.scaleFactors;
    
% Plot selected GMs from all database
% plot Sa on 99
    figure(99)    
    perKnown(recPer) = PerTgt;

% plot individual records first to keep median and bounds at the top
    hSelRecs = loglog(perKnown, SaSelected.*repmat(scaleFactors,1,size(SaSelected,2)), 'color', colorRecs); hold on

% Median curve is plotted later to bring the CMS and bounds at the top. 
    hMeanCMS = loglog(PerTgt, exp(meanReq), 'color', medianColorLIST{i}, 'LineStyle', '-', 'linewidth', 3);
    hUpprCMS = loglog(PerTgt, exp(meanReq + 1.96*sqrt(diag(covReq))'), 'color', medianColorLIST{i}, 'LineStyle', '--', 'linewidth', 3);
    hLowrCMS = loglog(PerTgt, exp(meanReq - 1.96*sqrt(diag(covReq))'), 'color', medianColorLIST{i}, 'LineStyle', '--', 'linewidth', 3);

    axis([min(PerTgt) max(PerTgt) 1e-2 5])
    hx = xlabel('Period (s)');
    hx = xlabel('Period, $ T $ (s)', 'Interpreter','latex');     
    hy = ylabel('$ Sa(T) $ (g)', 'Interpreter','latex');
%     legend('Median response spectrum','2.5 and 97.5 percentile response spectra','Response spectra of selected ground motions');
    htitle = title('Response spectra of selected records (with 2.5/97.5%ile)');
    
    ylim([0.01, 3])

    plotHandle(i, 1) = hMeanCMS;
    plotHandle(numDB + i, 1) = hSelRecs(end);

    if strcmp(tectonic, 'Interface/Subduction')
        strForLegend{i, 1} = sprintf('Target CMS %s', 'Subduction');
        strForLegend{numDB + i, 1} = sprintf('Selected records %s', 'Subduction');
    else
        strForLegend{i, 1} = sprintf('Target CMS %s', tectonic);
        strForLegend{numDB + i, 1} = sprintf('Selected records %s', tectonic);
    end
end

%     strForLegend = {'Median response spectrum (CMS)'
%         '2.5 and 97.5 %ile response spectra'
%         'Selected GM Response spectra'};
% legh = legend([hMeanCMS, hUpprCMS, hSelRecs(end)], strForLegend, 'location', 'southwest');
    
legh = legend(plotHandle, strForLegend, 'location', 'southwest');

figureFormatScript_forReport
