function [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(hazardInputs, T1Curr)
%% function returns interpolated hazard for any given (lat, lon) using the data file received from Raghukanth on Jan 11, 2020

latLonLIST   = hazardInputs.latLon;
doPlot       = hazardInputs.doPlot;
plotType     = hazardInputs.plotType;
locationLIST = hazardInputs.locationLISTforPlot;

[imValLIST, afe_PGA_LIST, afe_Sa0p1_LIST, afe_Sa0p2_LIST, afe_Sa0p5_LIST, afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, ... 
    afe_Sa2p0_LIST, afe_Sa5p0_LIST] = extractHazForLoc_20200111_v1(latLonLIST);

afeLISTLIST = [afe_PGA_LIST, afe_Sa0p1_LIST, afe_Sa0p2_LIST, afe_Sa0p5_LIST, ...
    afe_Sa0p9_LIST, afe_Sa1p0_LIST, afe_Sa1p2_LIST, afe_Sa2p0_LIST, afe_Sa5p0_LIST]; % concatenate all afeLIST

numPtsOnInpHaz = size(imValLIST, 2); % number of points on input hazard
timePLIST = [0, 0.1, 0.2, 0.5, 0.9, 1.0, 1.2, 2.0, 5.0];

[M, I] = min(abs(T1Curr - timePLIST));
if M < 1e-6
%     fprintf('Hoorrayyy! T1 matches with one of the values in the list of input data.\n');
    matchColRef = numPtsOnInpHaz*(I - 1) + 1 : numPtsOnInpHaz*I;
    afe_Sa_T1_LIST = afeLISTLIST(:, matchColRef);
    return
end

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
        xq = T1Curr;
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
    xlabel(['Sa(', num2str(T1Curr), ') (g)']); 
    ylabel('Annual Frequency of Exceedance'); grid on;
    ylim([1e-6 1e0]);
    if ~isempty(locationLIST); legend(locationLIST); end
    sks_figureFormat('powerpoint')
end



