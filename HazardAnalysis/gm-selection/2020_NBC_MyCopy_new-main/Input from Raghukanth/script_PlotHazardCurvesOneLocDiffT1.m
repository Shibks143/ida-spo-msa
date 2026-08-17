clear;
tic
baseFolder = pwd;
cd ..\..\..\..\psb_MatlabProcessors
addpath(pwd)
cd(baseFolder)

% input depending on the site (lat, lon) (Table 5.4 of NDMA, 2011 report)
% latLon = [13.05	  80.27]; locName = 'Chennai';
% latLon = [22.55	  88.37]; locName = 'Kolkata';
% latLon = [19.00   72.80]; locName = 'Mumbai';
% latLon = [28.62   77.22]; locName = 'Delhi';
latLon = [26.17   91.77]; locName = 'Guwahati';
% latLon = [27.10   92.10]; locName = 'ArunachalBorder';

%%% Start: added on 16 Aug 2026 %%%%%%%%%%%
Tcond = 0.71; % conditioning period for return-period-based Sa extraction
returnPeriods = [475 975 2475]; % years
%%% End: added on 16 Aug 2026 %%%%%%%%%%%


T1LIST = [0 0.1:0.1:0.5 1 1.50 2];% period for spectral accelerations for different hazard curves
%  1a. inputs for extracting  hazard
doPlot = 0; plotType = 'loglog'; % 'semilog', 'loglog, 'linear'
imTypeForPlot = {'Sa_T1'}; % essentially fixed now
locationLISTforPlot = {}; legendName = {};
fitModel = '3param'; % {'2param', '3param'}; % Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)]
N = 21; % [11, 21, 51]; % number of points between consecutive imValLIST values
plotStyle = {'k-', 'b--', 'r-.', 'm:', 'k-', 'b--', 'r-.', 'm:', 'k--'};
lineW = [1.5*ones(1, 4) 0.8*ones(1, 5)];
doSave = 1; % save the plot

for j = 1:size(T1LIST, 2)
    T1Curr = T1LIST(1, j);
    % 1a. extract hazard curve data (10-point-curve) from Raghukanth's file (received on Jan 11, 2020)
    [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(latLon, doPlot, plotType, locationLISTforPlot, T1Curr);
    %  1b. discretize each hazard curve individually
    [imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST, afe_Sa_T1_LIST, N, doPlot, plotType, imTypeForPlot, legendName);
    
 
    %     figure(1)
    plot(imValDisc, afeDisc, plotStyle{j}, 'LineWidth', lineW(j)); hold on; grid on;
    ax = gca;
    switch plotType
        case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
        case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
    end
end
xlabel('$\mathrm{im}\,(\mathrm{g})$');
ylabel('$\mathrm{H}(\mathrm{im})$'); 
    xlim([1e-2 3]); ylim([1e-5 1e+0]);
    legTxt = strcat({'$\mathrm{T} = '}, strsplit(num2str(T1LIST,'%.2f\t')), {'\ \mathrm{s}$'});
    legend(legTxt)
    sks_figureFormat('powerpoint')
    set(gca,'YTick',10.^(-4:0))
    cd(baseFolder)

if doSave == 1
   exportFolder = fullfile(baseFolder,'hazardCurves');
   cd hazardCurves
   exportName = sprintf('F2x_HazardCurvesSaT1_%s_revCv5', locName);
   sks_figureExport(exportName);
   cd(baseFolder)
  
end


%%% Start: added on 16 Aug 2026 (revised) %%%%%%%%%%%
%%% Independently compute hazard curve at Tcond (works for ANY period)
[imValLIST_Tc, afe_Sa_Tc_LIST] = findHazValRaghukanth20200111_v4(latLon, 0, plotType, {}, Tcond);
[imValDisc_Tcond, afeDisc_Tcond, ~] = returnHazCurveRaghukanth20200111_v2( ...
    fitModel, imValLIST_Tc, afe_Sa_Tc_LIST, N, 0, plotType, imTypeForPlot, {});
[afeSorted, sortIdx] = sort(afeDisc_Tcond);
imValSorted = imValDisc_Tcond(sortIdx);
fprintf('\nTarget Sa(%.2fs) at %s:\n', Tcond, locName);
for i = 1:length(returnPeriods)
    Tr = returnPeriods(i);
    targetAFE = 1/Tr;
    targetSa = interp1(log(afeSorted), imValSorted, log(targetAFE));
    fprintf('  Return period %5d yr -> Sa(%.2fs) = %.4f g\n', Tr, Tcond, targetSa);
end
%%% End: revised %%%%%%%%%%%

toc









