clear;
tic
baseFolder = pwd;


% input depending on the site (lat, lon) (Table 5.4 of NDMA, 2011 report)
% latLon = [13.05	  80.27]; locName = 'Chennai';
% latLon = [22.55	  88.37]; locName = 'Kolkata';
% latLon = [19.00   72.80]; locName = 'Mumbai';
% latLon = [28.62   77.22]; locName = 'Delhi';
latLon = [26.17   91.77]; locName = 'Guwahati';
% latLon = [27.10   92.10]; locName = 'ArunchalBorder';

T1LIST = [0 0.1:0.1:0.5 1 1.50 2];% period for spectral accelerations for different hazard curves
%  1a. inputs for extracting  hazard
doPlot = 0; plotType = 'loglog'; % 'semilog', 'loglog, 'linear'
imTypeForPlot = {'Sa_T1'}; % essentially fixed now
locationLISTforPlot = {}; legendName = {};
fitModel = '3param'; % {'2param', '3param'}; % Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)]
N = 21; % [11, 21, 51]; % number of points between consecutive imValLIST values
plotStyle = {'k-', 'b--', 'r-.', 'm:', 'k-', 'b--', 'r-.', 'm:', 'k--'};
lineW = [1.5*ones(1, 4) 0.8*ones(1, 5)];
doSave = 0; % save the plot

for j = 1:size(T1LIST, 2)
    T1Curr = T1LIST(1, j);
    % cd('H:\UniformRiskMap\Input from Raghukanth')
    % 1a. extract hazard curve data (10-point-curve) from Raghukanth's file (received on Jan 11, 2020)
    [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(latLon, doPlot, plotType, locationLISTforPlot, T1Curr);
    %  1b. discretize each hazard curve individually
    [imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST, afe_Sa_T1_LIST, N, doPlot, plotType, imTypeForPlot, legendName);
%     figure(1)
%     plot(imValDisc, afeDisc, '-', 'LineWidth', 1.6-j/10); hold on; grid on;
    plot(imValDisc, afeDisc, plotStyle{j}, 'LineWidth', lineW(j)); hold on; grid on;
    ax = gca;
    switch plotType
        case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
        case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
    end
end
    hx = xlabel('im (g)'); hy = ylabel('H(im)');
    xlim([1e-2 3]); ylim([1e-5 1e+0]);
    set(gca, 'YTick', 10.^[-4:0]);
    legTxt = strcat({'T = '}, strsplit(num2str(T1LIST, '%.2f\t')), {' s'});
    legend(legTxt)
    psb_FigureFormatScript_paper

if doSave == 1
   cd(baseFolder) 
   cd hazardCurves
%    set(gca,'fontname','times');
   exportName = sprintf('F2x_HazardCurvesSaT1_%s_revCv5', locName);
   hgsave(exportName); % .fig file for Matlab
   print('-depsc', exportName); % .eps file for Linux (LaTeX)
   print('-dmeta', exportName); % .emf file for Windows (MSWORD)
%    print('-dpng', exportName); % .png file for small sized files
%    print('-djpeg', exportName); % .jpeg file for small sized files
   print('-djpeg', [exportName '_r300'], '-r300');
%    print('-dpng','-r300',[exportName '-r300'])
    
end    
cd(baseFolder)
toc









