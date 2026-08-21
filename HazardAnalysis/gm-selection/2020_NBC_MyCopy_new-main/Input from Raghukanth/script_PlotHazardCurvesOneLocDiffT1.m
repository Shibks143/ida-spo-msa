clear;
tic
baseFolder = pwd;
cd ..\..\..\..\psb_MatlabProcessors
addpath(pwd)
cd(baseFolder)


%%% >>> START OF INPUT BLOCK HERE <<< %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pshaVersion = 'new'; % 'old' -> 20200111_v4, 'new' -> 20260818_v4

% input depending on the site (lat, lon) (Table 5.4 of NDMA, 2011 report)
% latLon = [13.05	  80.27]; locName = 'Chennai';
% latLon = [22.55	  88.37]; locName = 'Kolkata';
% latLon = [19.00   72.80]; locName = 'Mumbai';
% latLon = [28.62   77.22]; locName = 'Delhi';
latLon = [26.17   91.77]; locName = 'Guwahati';
% latLon = [27.10   92.10]; locName = 'ArunachalBorder';

%%% Start: added on 16 Aug 2026 %%%%%%%%%%%
Tcond = 0.71; % conditioning period for return-period-based Sa extraction
returnPeriods = [75 175 275 475 975 1275 2475 4975 9975]; % years
%%% End: added on 16 Aug 2026 %%%%%%%%%%%

% period for spectral accelerations for different hazard curves — depends on pshaVersion
switch pshaVersion
    case 'old'
        % 9 periods, capped at 2s (see timePIDsToProc = 1:8 anomaly note)
        T1LIST = [0 0.1:0.1:0.5 1 1.50 2];
    case 'new'
        % new Aug 2026 data: 27 periods available, up to 5s
        T1LIST = [0.01 0.05 0.5 1 1.50 2 3 5];
    otherwise
        error('Unknown pshaVersion: %s', pshaVersion);
end

% T1LIST = [0 0.1:0.1:0.5 1 1.50 2]; % period for spectral accelerations for different hazard curves
%  1a. inputs for extracting  hazard
doPlot = 0; plotType = 'loglog'; % 'semilog', 'loglog, 'linear'
imTypeForPlot = {'Sa_T1'}; % essentially fixed now
locationLISTforPlot = {}; legendName = {};
fitModel = '3param'; % {'2param', '3param'}; % Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)]
N = 21; % [11, 21, 51]; % number of points between consecutive imValLIST values
% plotStyle = {'k-', 'b--', 'r-.', 'm:', 'k-', 'b--', 'r-.', 'm:', 'k--'};
% lineW = [1.5*ones(1, 4) 0.8*ones(1, 5)];
nT = numel(T1LIST);
baseStyles = {'k-', 'b-', 'r-.', 'm:', 'k--', 'b--', 'r--', 'm-.'};
plotStyle = baseStyles(mod(0:nT-1, numel(baseStyles)) + 1);
lineW = [1.2*ones(1,4), 0.8*ones(1, max(nT-4,0))];
doSave = 1; % save the plot

%%% >>> END INPUT BLOCK <<< %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ============================================================
% MAIN HAZARD CURVES
% ============================================================

for j = 1:size(T1LIST, 2)
    T1Curr = T1LIST(1, j);
    % 1a. extract hazard curve data (10-point-curve) from Raghukanth's file (received on Jan 11, 2020)
    switch pshaVersion
        case 'old'
            % 10-point-curve, Raghukanth file received Jan 11, 2020 
              [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(latLon, doPlot, plotType, locationLISTforPlot, T1Curr);
        case 'new'
            % updated PSHA, Raghukanth file received Aug 18, 2026
            [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20260818_v4(latLon, doPlot, plotType, locationLISTforPlot, T1Curr);
        otherwise
            error('Unknown pshaVersion: %s', pshaVersion);
    end

    %  1b. discretize each hazard curve individually %% same for both old and new PSHA %
    [imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST, afe_Sa_T1_LIST, N, doPlot, plotType, imTypeForPlot, legendName);
    
    %     figure(1)
    hLine = plot(imValDisc, afeDisc, plotStyle{j}, 'LineWidth', lineW(j)); hold on; grid on;
    hLine.UserData = T1Curr; % stash T value on the line itself so the data cursor can read it back
    hLine.DisplayName = sprintf('T = %.2f s', T1Curr);

    % plot(imValDisc, afeDisc, plotStyle{j}, 'LineWidth', lineW(j)); hold on; grid on;
    ax = gca;
    switch plotType
        case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
        case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
    end
end

xlabel('$\mathrm{im}\,(\mathrm{g})$');
ylabel('$\mathrm{H}(\mathrm{im})$'); 
    xlim([1e-2 5]); ylim([1e-5 1e+0]);
    legTxt = strcat({'$\mathrm{T} = '}, strsplit(num2str(T1LIST,'%.2f\t')), {'\ \mathrm{s}$'});
    legend(legTxt)
    % --- custom data cursor: click a curve to see which T1 it belongs to ---
    dcm = datacursormode(gcf);
    dcm.Enable = 'on';
    dcm.UpdateFcn = @hazardCurveCursorText;
    sks_figureFormat('powerpoint')
    set(gca,'YTick',10.^(-4:0))
    cd(baseFolder)

if doSave == 1
   exportFolder = fullfile(baseFolder,'hazardCurves');
   cd hazardCurves
   exportName = sprintf('HazardCurvesSaT1_%s_%sPSHA', locName,pshaVersion);
   sks_figureExport(exportName);
   cd(baseFolder)
end

% =========================================================================
%%% Start:TARGET Sa AT Tcond, added on 16 Aug 2026 %%%%%%%%%%%%%%%%%%%%%%%%
%%% Independently compute hazard curve at Tcond (works for ANY period) %%%%
% =========================================================================

switch pshaVersion
    case 'old'
        [imValLIST_Tc, afe_Sa_Tc_LIST] = findHazValRaghukanth20200111_v4(latLon, doPlot, plotType, locationLISTforPlot, Tcond);
    case 'new'
        [imValLIST_Tc, afe_Sa_Tc_LIST] = findHazValRaghukanth20260818_v4(latLon, doPlot, plotType, locationLISTforPlot, Tcond);
    otherwise
        error('Unknown pshaVersion: %s', pshaVersion);
end

% Discretize hazard curve — same procedure for both PSHA versions %% need
[imValDisc_Tcond, afeDisc_Tcond, ~] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST_Tc, afe_Sa_Tc_LIST, N, doPlot, plotType, imTypeForPlot, legendName);

[afeSorted, sortIdx] = sort(afeDisc_Tcond);
imValSorted = imValDisc_Tcond(sortIdx);
fprintf('\nTarget Sa(%.2fs) at %s:\n', Tcond, locName);
targetSa_LIST = zeros(size(returnPeriods));

for i = 1:length(returnPeriods)
    Tr = returnPeriods(i);
    targetAFE = 1/Tr;
    targetSa_LIST(i) = interp1(log(afeSorted), imValSorted, log(targetAFE));
    fprintf('Return period %5d yr -> Sa(%.2fs) = %.4f g\n', Tr, Tcond, targetSa_LIST(i));
end

function txt = hazardCurveCursorText(~, event)
hLine = event.Target;
T1val = hLine.UserData;
pos = event.Position;
if isempty(T1val)
    txt = {sprintf('im = %.4g g', pos(1)), sprintf('H(im) = %.4g', pos(2))};
else
    txt = {sprintf('T = %.2f s', T1val), sprintf('im = %.4g g', pos(1)), sprintf('H(im) = %.4g', pos(2))};
end
end

%%% End: Target Sa at Tcond, added on 16 Aug 2026  %%%%%%%%%%%%%%%%%%%%%%%
toc

