function [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(latLonLIST, doPlot, plotType, locationLIST, T1)
%% function returns interpolated hazard for any given (lat, lon) using the data file received from Raghukanth on Jan 11, 2020
%
%%%%%%%%%%%%%%%%%% Sample Inputs %%%%%%%%%%%%%%%%%%
% clear;
% latLonLIST = [
%     19.00   72.80; % Mumbai   (Table 5.4 of NDMA, 2011 report)
%     28.62   77.22; % Delhi
%     26.17   91.77; % Guwahati
% %     27.10   92.10; % an arbitrary grid point near Arunachal border
% %     26.70   60.5;  % a grid point for validation
%     ];
% T1 = 1.35;
% doPlot = 1; 
% plotType = 'loglog'; % 'semilog', 'loglog, 'linear'
% % following two inputs used for plotting only 
% imTypeForPlot = 'PGA'; % 'PGA', 'Sa_0p1', 'Sa_0p2', 'Sa_0p5', 'Sa_0p9', 'Sa_1p0', 'Sa_1p2', 'Sa_2p0', 'Sa_5p0'
% locationLIST = {'Mumbai', 'Delhi', 'Guwahati'};%, 'Arunachal'}; % used only for legend
%%%%%%%%%%%%%%%%%% End of sample Inputs %%%%%%%%%%%%%%%%%%

% [imValLIST, afe_PGA_LIST, afe_Sa0p1_LIST, afe_Sa0p2_LIST, afe_Sa0p5_LIST, ...
%     afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, afe_Sa2p0_LIST, afe_Sa5p0_LIST] ...
%     = findHazValRaghukanth20200111_v3(latLonLIST, 0, plotType, imTypeForPlot, locationLIST);

% latLIST = latLonLIST(:, 1);
% lonLIST = latLonLIST(:, 2);

%% load the data
% fileName = 'hazard_20200111.mat';
% load(fileName, 'Y1', 'X1', 'int_g', ...
%     'c_0s',    'c_pt1s',    'c_pt2s',   'c_pt5s',   'c_pt9s', ...
%     'c_1s',    'c_1pt2s',   'c_2s',     'c_5s'); % keeping varnames here makes it easy to program

%% interpolate
% imValLIST = int_g';
% latVal = latLIST;%(i, 1);
% lonVal = lonLIST;%(i, 1);

%% interpolate
% [X_grid,Y_grid] = ndgrid(60.1:0.2:99.9, 2.1:0.2:39.9); 
% afe_PGA_LIST = zeros(size(latLonLIST, 1), size(imValLIST, 2));
% afe_Sa0p1_LIST = afe_PGA_LIST; afe_Sa0p2_LIST = afe_PGA_LIST; afe_Sa0p5_LIST = afe_PGA_LIST;
% afe_Sa0p9_LIST = afe_PGA_LIST; afe_Sa1p0_LIST = afe_PGA_LIST; afe_Sa1p2_LIST = afe_PGA_LIST;
% afe_Sa2p0_LIST = afe_PGA_LIST; afe_Sa5p0_LIST = afe_PGA_LIST; 
% for i = 1:size(c_0s, 2)
%     afeCurrent = reshape(c_0s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic'); %  use scatteredInterpolant if data were scattered and not gridded
%     afe_PGA_LIST(:, i) = F(lonVal, latVal);
%     
%     afeCurrent = reshape(c_pt1s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
%     afe_Sa0p1_LIST(:, i) = F(lonVal, latVal);
%     
%     afeCurrent = reshape(c_pt2s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
%     afe_Sa0p2_LIST(:, i) = F(lonVal, latVal);
%     
%     afeCurrent = reshape(c_pt5s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
%     afe_Sa0p5_LIST(:, i) = F(lonVal, latVal);
%     
%     afeCurrent = reshape(c_pt9s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
%     afe_Sa0p9_LIST(:, i) = F(lonVal, latVal);
%     
%     afeCurrent = reshape(c_1s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
%     afe_Sa1p0_LIST(:, i) = F(lonVal, latVal);
%     
%     afeCurrent = reshape(c_1pt2s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
%     afe_Sa1p2_LIST(:, i) = F(lonVal, latVal);
%     
%     afeCurrent = reshape(c_2s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
%     afe_Sa2p0_LIST(:, i) = F(lonVal, latVal);
%     
%     afeCurrent = reshape(c_5s(:, i), [190, 200])'; % reshape 38000×1 to 190×200; transpose for ndgrid
%     F = griddedInterpolant(X_grid, Y_grid, afeCurrent, 'cubic');
%     afe_Sa5p0_LIST(:, i) = F(lonVal, latVal);    
% end

[imValLIST, afe_PGA_LIST, afe_Sa0p1_LIST, afe_Sa0p2_LIST, afe_Sa0p5_LIST, ...
afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, afe_Sa2p0_LIST, afe_Sa5p0_LIST] ...
= extractHazForLoc_20200111_v1(latLonLIST);

% now we have all the following LISTs from the raw data:
% [imValLIST, afe_PGA_LIST, afe_Sa0p1_LIST, afe_Sa0p2_LIST, afe_Sa0p5_LIST, ...
%     afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, afe_Sa2p0_LIST, afe_Sa5p0_LIST]

afeLISTLIST = [afe_PGA_LIST, afe_Sa0p1_LIST, afe_Sa0p2_LIST, afe_Sa0p5_LIST, ...
    afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, afe_Sa2p0_LIST, afe_Sa5p0_LIST]; % concatenate all afeLIST

numPtsOnInpHaz = size(imValLIST, 2); % number of points on input hazard

timePLIST = [0, 0.1, 0.2, 0.5, 0.9, 1.0, 1.2, 2.0, 5.0];

[M, I] = min(abs(T1 - timePLIST));
if M < 1e-6
%     fprintf('Hoorrayyy! T1 matches with one of the values in the list of input data.\n');
    matchColRef = numPtsOnInpHaz*(I - 1) + 1 : numPtsOnInpHaz*I;
    afe_Sa_T1_LIST = afeLISTLIST(:, matchColRef);
    return
end


% timePLIST = [0, 0.1, 0.2, 0.5, 0.9, 1.0, 1.2, 2.0, 5.0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% (WARNING) PSB, 2-26-20: We are not going beyond 2 sec as of now, because of anamolies in the data for Sa(5.0) as communicated to Prof. Raghukanth today.
timePIDsToProc = 1:8; % 1:8 indicates that we're processing spectral acceleration values up to 2 sec
% check the erroneous AFE values of the following graph after loading data dated 20200111
% plot(1:38000, c_5s(:, 10), 'bo'); xlabel('Site ID'); ylabel('AFE for Sa(5.0) \geq 5g');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

for locID = 1:size(latLonLIST, 1)
    for imValID = 1:numPtsOnInpHaz
        colRef = imValID + numPtsOnInpHaz*(0:(size(timePIDsToProc, 2) - 1)); % column numbers in afeLISTLIST for the relevant time periods 
    % interpolate hazard values corresponding to T1 natural period
        X = timePLIST(timePIDsToProc); Y = afeLISTLIST(locID, colRef); % X- AFE, Y- im values
        xq = T1;
        Xnew = X; Ynew = Y;
        Ynew(isnan(Y)) = []; Xnew(isnan(Y)) = [];
        if xq > max(Xnew) || xq < min(Xnew); fprintf('Attempting to extrapolate. Default dummy value assigned.\n'); end
        afe_Sa_T1_interp = interp1(Xnew, Ynew, xq, 'pchip', 0);
        afe_Sa_T1_LIST(locID, imValID) = afe_Sa_T1_interp;
%         ix = find(X >= xq, 1);
%         afe_Sa_T1_interp1 = interp1([X(ix-1), X(ix)], [Y(ix-1), Y(ix)], xq, 'pchip');
%         afe_Sa_T1_LIST1(locID, imValID) = afe_Sa_T1_interp1;
    end
end
%% plot PGA hazard curve
if doPlot == 1
    lineColors = repmat({'r','b','m','k','c',[.5 .6 .7],'g'}, [1 4]); % Cell array of 28 colors.
    lineStyles = repmat({'-','--', '-.', ':', '-','--', '-.', ':', '-','--', '-.', ':'}, [1 4]);
    markers = repmat({'o'}, [1 28]);
    figure
    for i = 1:size(latLonLIST, 1)
        currentPlotStyle = [lineColors{i} lineStyles{i} markers{i}];
        % figure(100 + i); % individual plots for each site.
        plot(imValLIST, afe_Sa_T1_LIST(i, :), currentPlotStyle, 'LineWidth', 1.25); hold on;
        ax = gca;
        switch plotType
            case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
            case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
        end
    end
    hx = xlabel(['Sa(', num2str(T1), ') (g)']); hy = ylabel('Annual Frequency of Exceedance'); grid on;
    ylim([1e-6 1e0]);
    if ~isempty(locationLIST); legend(locationLIST); end
    psb_FigureFormatScript_forReport
end

% loglog(imValLIST, afe_Sa_T1_LIST(i, :), 'ro-', imValLIST, afe_Sa_T1_LIST1(i, :), 'bo--');
% loglog(imValLIST, afe_Sa_T1_LIST(i, :), 'bo--');


