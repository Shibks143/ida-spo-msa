function [imValLIST, afeLISTLIST, periodList] = extractHazForLoc_20260818_v1(latLonLIST)

%% function returns interpolated hazard for any given (lat, lon) using the data file received from Raghukanth on Aug 18, 2026
% modified by shivakumar K S on Aug 20th 2026 for the new PSHA data.

narginchk(1, 5)
switch nargin
    case 1
        doPlot = 0; plotType = 'semilog'; imTypeForPlot = 'PGA'; locationLIST = {};
    case 2
        plotType = 'semilog'; imTypeForPlot = 'PGA'; locationLIST = {};
    case 3
        imTypeForPlot = 'PGA'; locationLIST = {};
    case 4
        locationLIST = {};
end

%% load the data
fileName = 'hazard_20260818.mat';
load(fileName, 'hazardCurveTable');
tbl = hazardCurveTable;
% tbl.Properties.VariableNames     % lists all column names
% head(tbl)                       % preview first few rows

int_g     = tbl.int_g;
c_0pt01s  = tbl.c_0pt01s;
c_0pt015s = tbl.c_0pt015s;
c_0pt02s  = tbl.c_0pt02s;
c_0pt03s  = tbl.c_0pt03s;
c_0pt04s  = tbl.c_0pt04s;
c_0pt05s  = tbl.c_0pt05s;
c_0pt06s  = tbl.c_0pt06s;
c_0pt075s = tbl.c_0pt075s;
c_0pt09s  = tbl.c_0pt09s;
c_0pt1s   = tbl.c_0pt1s;
c_0pt15s  = tbl.c_0pt15s;
c_0pt2s   = tbl.c_0pt2s;
c_0pt3s   = tbl.c_0pt3s;
c_0pt4s   = tbl.c_0pt4s;
c_0pt5s   = tbl.c_0pt5s;
c_0pt6s   = tbl.c_0pt6s;
c_0pt7s   = tbl.c_0pt7s;
c_0pt75s  = tbl.c_0pt75s;
c_0pt8s   = tbl.c_0pt8s;
c_0pt9s   = tbl.c_0pt9s;
c_1s      = tbl.c_1s;
c_1pt2s   = tbl.c_1pt2s;
c_1pt5s   = tbl.c_1pt5s;
c_2s      = tbl.c_2s;
c_2pt5s   = tbl.c_2pt5s;
c_3s      = tbl.c_3s;
c_5s      = tbl.c_5s;

imValLIST = int_g(:)'; % 1x15 fixed IM grid, same across all periods
nLoc = size(latLonLIST, 1);
periodList = [0.01, 0.015, 0.02, 0.03, 0.04, 0.05, 0.06, 0.075, 0.09, 0.1, 0.15, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.9, ...
    1.0, 1.2, 1.5, 2.0, 2.5, 3.0, 5.0]; % 27 periods (index 1 = PGA proxy, c_0pt01s)

if nLoc > 1
    warning('extractHazForLoc_20260818_v1:singleSiteOnly', ...
        'This .mat file currently contains data for ONE site only; replicating it for all %d requested locations.', nLoc);
end

% NOTE: No true PGA (T=0) field exists in this .mat file.
% Sa(T=0.01s) is used as a PGA approximation.
afe_PGA_LIST     = repmat(c_0pt01s(:)',  nLoc, 1); 
afe_Sa0p015_LIST = repmat(c_0pt015s(:)', nLoc, 1);
afe_Sa0p02_LIST  = repmat(c_0pt02s(:)',  nLoc, 1);
afe_Sa0p03_LIST  = repmat(c_0pt03s(:)',  nLoc, 1);
afe_Sa0p04_LIST  = repmat(c_0pt04s(:)',  nLoc, 1);
afe_Sa0p05_LIST  = repmat(c_0pt05s(:)',  nLoc, 1);
afe_Sa0p06_LIST  = repmat(c_0pt06s(:)',  nLoc, 1);
afe_Sa0p075_LIST = repmat(c_0pt075s(:)', nLoc, 1);
afe_Sa0p09_LIST  = repmat(c_0pt09s(:)',  nLoc, 1);
afe_Sa0p1_LIST   = repmat(c_0pt1s(:)',   nLoc, 1);
afe_Sa0p15_LIST  = repmat(c_0pt15s(:)',  nLoc, 1);
afe_Sa0p2_LIST   = repmat(c_0pt2s(:)',   nLoc, 1);
afe_Sa0p3_LIST   = repmat(c_0pt3s(:)',   nLoc, 1);
afe_Sa0p4_LIST   = repmat(c_0pt4s(:)',   nLoc, 1);
afe_Sa0p5_LIST   = repmat(c_0pt5s(:)',   nLoc, 1);
afe_Sa0p6_LIST   = repmat(c_0pt6s(:)',   nLoc, 1);
afe_Sa0p7_LIST   = repmat(c_0pt7s(:)',   nLoc, 1);
afe_Sa0p75_LIST  = repmat(c_0pt75s(:)',  nLoc, 1);
afe_Sa0p8_LIST   = repmat(c_0pt8s(:)',   nLoc, 1);
afe_Sa0p9_LIST   = repmat(c_0pt9s(:)',   nLoc, 1);
afe_Sa1p0_LIST   = repmat(c_1s(:)',      nLoc, 1);
afe_Sa1p2_LIST   = repmat(c_1pt2s(:)',   nLoc, 1);
afe_Sa1p5_LIST   = repmat(c_1pt5s(:)',   nLoc, 1);
afe_Sa2p0_LIST   = repmat(c_2s(:)',      nLoc, 1);
afe_Sa2p5_LIST   = repmat(c_2pt5s(:)',   nLoc, 1);
afe_Sa3p0_LIST   = repmat(c_3s(:)',      nLoc, 1);
afe_Sa5p0_LIST   = repmat(c_5s(:)',      nLoc, 1);

afeLISTLIST = [afe_PGA_LIST, afe_Sa0p015_LIST, afe_Sa0p02_LIST, afe_Sa0p03_LIST, afe_Sa0p04_LIST, afe_Sa0p05_LIST, afe_Sa0p06_LIST, ...
    afe_Sa0p075_LIST, afe_Sa0p09_LIST, afe_Sa0p1_LIST, afe_Sa0p15_LIST, afe_Sa0p2_LIST, afe_Sa0p3_LIST, afe_Sa0p4_LIST, afe_Sa0p5_LIST, ...
    afe_Sa0p6_LIST, afe_Sa0p7_LIST, afe_Sa0p75_LIST, afe_Sa0p8_LIST, afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, afe_Sa1p5_LIST, ...
    afe_Sa2p0_LIST, afe_Sa2p5_LIST, afe_Sa3p0_LIST, afe_Sa5p0_LIST];

% afeLISTLIST = [afe_PGA_LIST, afe_Sa0p015_LIST, afe_Sa0p02_LIST, afe_Sa0p03_LIST, afe_Sa0p04_LIST, afe_Sa0p05_LIST, afe_Sa0p06_LIST, ...
%     afe_Sa0p075_LIST, afe_Sa0p09_LIST, afe_Sa0p1_LIST, afe_Sa0p15_LIST, afe_Sa0p2_LIST, afe_Sa0p3_LIST, afe_Sa0p4_LIST, afe_Sa0p5_LIST, ...
%     afe_Sa0p6_LIST, afe_Sa0p7_LIST, afe_Sa0p75_LIST, afe_Sa0p8_LIST, afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, afe_Sa1p5_LIST, ...
%     afe_Sa2p0_LIST, afe_Sa2p5_LIST, afe_Sa3p0_LIST, afe_Sa5p0_LIST];

%% plot PGA hazard curve
if doPlot == 1
    lineColors = repmat({'r','b','m','k','c',[.5 .6 .7],'g'}, [1 4]); % Cell array of 28 colors.
    lineStyles = repmat({'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'}, [1 4]);
    markers = repmat({'o'}, [1 28]);
    figure
    for i = 1:size(latLonLIST, 1)
        currentPlotStyle = [lineColors{i} lineStyles{i} markers{i}];
        % figure(100 + i); % individual plots for each site.
        switch imTypeForPlot
            case 'PGA' 	 ;  afeLIST = afe_PGA_LIST(i, :);
            case 'Sa0p015'; afeLIST = afe_Sa0p015_LIST(i, :);
            case 'Sa0p02';  afeLIST = afe_Sa0p02_LIST(i, :);
            case 'Sa0p03';  afeLIST = afe_Sa0p03_LIST(i, :);
            case 'Sa0p04';  afeLIST = afe_Sa0p04_LIST(i, :);
            case 'Sa0p05';  afeLIST = afe_Sa0p05_LIST(i, :);
            case 'Sa0p06';  afeLIST = afe_Sa0p06_LIST(i, :);
            case 'Sa0p075'; afeLIST = afe_Sa0p075_LIST(i, :);
            case 'Sa0p09';  afeLIST = afe_Sa0p09_LIST(i, :);
            case 'Sa0p1';   afeLIST = afe_Sa0p1_LIST(i, :);
            case 'Sa0p15';  afeLIST = afe_Sa0p15_LIST(i, :);
            case 'Sa0p2';   afeLIST = afe_Sa0p2_LIST(i, :);
            case 'Sa0p3';   afeLIST = afe_Sa0p3_LIST(i, :);
            case 'Sa0p4';   afeLIST = afe_Sa0p4_LIST(i, :);
            case 'Sa0p5';   afeLIST = afe_Sa0p5_LIST(i, :);
            case 'Sa0p6';   afeLIST = afe_Sa0p6_LIST(i, :);
            case 'Sa0p7';   afeLIST = afe_Sa0p7_LIST(i, :);
            case 'Sa0p75';  afeLIST = afe_Sa0p75_LIST(i, :);
            case 'Sa0p8';   afeLIST = afe_Sa0p8_LIST(i, :);
            case 'Sa0p9';   afeLIST = afe_Sa0p9_LIST(i, :);
            case 'Sa1p0';   afeLIST = afe_Sa1p0_LIST(i, :);
            case 'Sa1p2';   afeLIST = afe_Sa1p2_LIST(i, :);
            case 'Sa1p5';   afeLIST = afe_Sa1p5_LIST(i, :);
            case 'Sa2p0';   afeLIST = afe_Sa2p0_LIST(i, :);
            case 'Sa2p5';   afeLIST = afe_Sa2p5_LIST(i, :);
            case 'Sa3p0';   afeLIST = afe_Sa3p0_LIST(i, :);
            case 'Sa5p0';   afeLIST = afe_Sa5p0_LIST(i, :);
     
        end
        plot(imValLIST, afeLIST, currentPlotStyle, 'LineWidth', 2); hold on;
        ax = gca;
        switch plotType
            case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
            case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
        end
    end
    
    xlabel([imTypeForPlot, '(g)']); 
    ylabel('Annual Frequency of Exceedance'); grid on;
    ylim([1e-5 1e0]);
    if ~isempty(locationLIST); legend(locationLIST); end
    sks_figureFormat('powerpoint')
end
