function [imValLIST, afe_PGA_LIST, afe_Sa0p1_LIST, afe_Sa0p2_LIST, afe_Sa0p5_LIST, ...
    afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, afe_Sa2p0_LIST, afe_Sa5p0_LIST] ...
    = extractHazForLoc_20200111_v1(latLonLIST, doPlot, plotType, imTypeForPlot, locationLIST)
%% function returns interpolated hazard for any given (lat, lon) using the data file received from Raghukanth on Jan 11, 2020
% 
%%%%%%%%%%%%%%%%%% Sample Inputs %%%%%%%%%%%%%%%%%%
% clear;
% % tic
% latLonLIST = [
%     19.00   72.80; % Mumbai   (Table 5.4 of NDMA, 2011 report)
%     28.62   77.22; % Delhi
%     26.17   91.77; % Guwahati
%     27.10   92.10; % an arbitrary grid point near Arunachal border
% %     26.70   60.5;  % a grid point for validation
%     ];
% doPlot = 0;
% plotType = 'semilog'; % 'semilog', 'loglog, 'linear'
% imTypeForPlot = 'PGA'; % 'PGA', 'Sa_0p1', 'Sa_0p2', 'Sa_0p5', 'Sa_0p9', 'Sa_1p0', 'Sa_1p2', 'Sa_2p0', 'Sa_5p0'
% locationLIST = {'Mumbai', 'Delhi', 'Guwahati', 'Arunachal'};
%%%%%%%%%%%%%%%%%% End of sample Inputs %%%%%%%%%%%%%%%%%%

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

latLIST = latLonLIST(:, 1);
lonLIST = latLonLIST(:, 2);

%% load the data
fileName = 'hazard_20200111.mat';
load(fileName, 'Y1', 'X1', 'int_g', ...
    'c_0s',    'c_pt1s',    'c_pt2s',   'c_pt5s',   'c_pt9s', ...
    'c_1s',    'c_1pt2s',   'c_2s',     'c_5s'); % keeping varnames here makes it easy to program

%% interpolate
imValLIST = int_g';
latVal = latLIST;%(i, 1);
lonVal = lonLIST;%(i, 1);

%% interpolate
%% Trial 1- Using GRDIDATA (takes ~15 s for four cities) (DISCARDED)
% tic
% for i = 1:size(c_0s, 2)
%     afe_PGA_LIST(:, i) = griddata(X1, Y1, c_0s(:, i), lonVal, latVal, 'cubic'); % C^2 continuity
%     afe_Sa0p1_LIST(:, i) = griddata(X1, Y1, c_pt1s(:, i), lonVal, latVal, 'cubic');
%     afe_Sa0p2_LIST(:, i) = griddata(X1, Y1, c_pt2s(:, i), lonVal, latVal, 'cubic');
%     afe_Sa0p5_LIST(:, i) = griddata(X1, Y1, c_pt5s(:, i), lonVal, latVal, 'cubic');
%     afe_Sa0p9_LIST(:, i) = griddata(X1, Y1, c_pt9s(:, i), lonVal, latVal, 'cubic');
%     afe_Sa1p0_LIST(:, i) = griddata(X1, Y1, c_1s(:, i), lonVal, latVal, 'cubic');
%     afe_Sa1p2_LIST(:, i) = griddata(X1, Y1, c_1pt2s(:, i), lonVal, latVal, 'cubic');
%     afe_Sa2p0_LIST(:, i) = griddata(X1, Y1, c_2s(:, i), lonVal, latVal, 'cubic');
%     afe_Sa5p0_LIST(:, i) = griddata(X1, Y1, c_5s(:, i), lonVal, latVal, 'cubic');
% end
% toc 

%% Trial 2- Using GRIDDEDINTERPOLANT (takes ~0.02 s for four cities) (IN USE)
% tic
[X_grid,Y_grid] = ndgrid(60.1:0.2:99.9, 2.1:0.2:39.9); 
% (transpose of X_grid) is same as reshape(X1, 190, 200) from the received data. Similarly, 
% (transpose of Y_grid) is same as reshape(Y1, 190, 200) from the received data
% One can check following two commands :
%     max(max(abs((X_grid - reshape(X1, 200, 190)))))  % is NON-zero;  we ain't using this
%     max(max(abs((X_grid' - reshape(X1, 190, 200))))) % is zero; we are using this
% Next, afe is also transposed to match with this transformation.

afe_PGA_LIST = zeros(size(latLonLIST, 1), size(imValLIST, 2));
afe_Sa0p1_LIST = afe_PGA_LIST; afe_Sa0p2_LIST = afe_PGA_LIST; afe_Sa0p5_LIST = afe_PGA_LIST;
afe_Sa0p9_LIST = afe_PGA_LIST; afe_Sa1p0_LIST = afe_PGA_LIST; afe_Sa1p2_LIST = afe_PGA_LIST;
afe_Sa2p0_LIST = afe_PGA_LIST; afe_Sa5p0_LIST = afe_PGA_LIST; 
for i = 1:size(c_0s, 2)
    afeCurrent = reshape(c_0s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic'); %  use scatteredInterpolant if data were scattered and not gridded
    afe_PGA_LIST(:, i) = F(lonVal, latVal);
    
    afeCurrent = reshape(c_pt1s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
    afe_Sa0p1_LIST(:, i) = F(lonVal, latVal);
    
    afeCurrent = reshape(c_pt2s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
    afe_Sa0p2_LIST(:, i) = F(lonVal, latVal);
    
    afeCurrent = reshape(c_pt5s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
    afe_Sa0p5_LIST(:, i) = F(lonVal, latVal);
    
    afeCurrent = reshape(c_pt9s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
    afe_Sa0p9_LIST(:, i) = F(lonVal, latVal);
    
    afeCurrent = reshape(c_1s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
    afe_Sa1p0_LIST(:, i) = F(lonVal, latVal);
    
    afeCurrent = reshape(c_1pt2s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
    afe_Sa1p2_LIST(:, i) = F(lonVal, latVal);
    
    afeCurrent = reshape(c_2s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
    afe_Sa2p0_LIST(:, i) = F(lonVal, latVal);
    
    afeCurrent = reshape(c_5s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
    F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
    afe_Sa5p0_LIST(:, i) = F(lonVal, latVal);    
end
% toc

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
            case 'PGA' 	 ; afeLIST = afe_PGA_LIST(i, :);
            case 'Sa_0p1'; afeLIST = afe_Sa0p1_LIST(i, :);
            case 'Sa_0p2'; afeLIST = afe_Sa0p2_LIST(i, :);
            case 'Sa_0p5'; afeLIST = afe_Sa0p5_LIST(i, :);
            case 'Sa_0p9'; afeLIST = afe_Sa0p9_LIST(i, :);
            case 'Sa_1p0'; afeLIST = afe_Sa1p0_LIST(i, :);
            case 'Sa_1p2'; afeLIST = afe_Sa1p2_LIST(i, :);
            case 'Sa_2p0'; afeLIST = afe_Sa2p0_LIST(i, :);
            case 'Sa_5p0'; afeLIST = afe_Sa5p0_LIST(i, :);
        end
        plot(imValLIST, afeLIST, currentPlotStyle, 'LineWidth', 2); hold on;
        ax = gca;
        switch plotType
            case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
            case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
        end
    end
    
    hx = xlabel([imTypeForPlot, '(g)']); hy = ylabel('Annual Frequency of Exceedance'); grid on;
    ylim([1e-5 1e0]);
    if ~isempty(locationLIST); legend(locationLIST); end
    psb_FigureFormatScript_forReport
end


