function [imValDisc, afeDisc, hazCurParams] = returnHazCurveRaghukanth20200111_v2(fitModel, imValLIST, afeLIST, N, doPlot, plotType, imTypeForPlot, legendName)

%% function develops digitized numerical hazard curve using four points derived from Raghukanth's data (received on Jan 11, 2020)
% 
%%%%%%%%%%%%%%%%%% Sample Inputs %%%%%%%%%%%%%%%%%%
% clear;
% fitModel = '2param'; % '2param' or '3param'; Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)]
% IM value list from Raghukanth data as received on Jan 11, 2020
% % % imValLIST = logspace(log10(0.01), log10(5.00), 10); % intention
% imValLIST = [0.01;0.0199474;0.0397897;0.07937;0.158322;0.315811;0.629961;1.25661;2.5066;5]'; % implementation (due to rounding)
% afeLIST = [4.93674E-02	1.56508E-02	4.34903E-03	9.92152E-04	1.48798E-04	2.17530E-05	3.58761E-06	4.85807E-07	5.13758E-08	3.77013E-09];% Mumbai
% afeLIST = [8.26856E-02	3.47746E-02	1.36577E-02	4.95679E-03	1.61090E-03	4.48673E-04	9.31284E-05	1.06942E-05	5.21429E-07	9.73072E-09]; % Delhi
% afeLIST = [3.34288E-01	1.24668E-01	3.92776E-02	1.25620E-02	4.21525E-03	1.25712E-03	2.62249E-04	3.36570E-05	2.33463E-06	7.18762E-08]; % Guwahati
% afeLIST = [3.70651E-01	1.49167E-01	4.95066E-02	1.62939E-02	5.62982E-03	1.74907E-03	3.80267E-04	5.04012E-05	3.61580E-06	1.15167E-07]; % Arunachal (27.1, 92.1)

% N = 21; % number of points for each sub-interval, i.e., between consecutive imValLIST values 
% doPlot = 1; 
% plotType = 'semilog'; % 'semilog', 'loglog, 'linear'
% imTypeForPlot = 'PGA'; % (used only for xlabel) 'PGA', 'Sa_0p1', 'Sa_0p2', 'Sa_0p5', 'Sa_0p9', 'Sa_1p0', 'Sa_1p2', 'Sa_2p0', 'Sa_5p0'
% legendName = {};
%%%%%%%%%%%%%%%%%% End of sample Inputs %%%%%%%%%%%%%%%%%%

narginchk(3, 8)
switch nargin
    case 3
        N = 21; doPlot = 0; plotType = 'semilog'; imTypeForPlot = 'im'; legendName = {};
    case 4
        doPlot = 0; plotType = 'semilog'; imTypeForPlot = 'im'; legendName = {};
    case 5
        plotType = 'semilog'; imTypeForPlot = 'im'; legendName = {};
    case 6
        imTypeForPlot = 'im'; legendName = {};
    case 7
        legendName = {};
end
   
%% Step 1 (fit a set of piecewise curves)
% For two-parameter model k0*a^(-k), find all (k0, k) for (n-1) intervals 
% For three-parameter model k0*exp[-k2*ln^2(a) - k1*ln(a)], find (k0, k1, k2) values for (n-2) intervals 
%% Step 2 (plot the hazard curve in the range of imVal, i.e., input range of im values)
% Use the calculated parameters to find numerical hazard curve. Only to show the fit. 

%% '2param' k0*a^(-k) 
% Fitting hazard curve based on EN 1998 -1 : 2004, section 2.1(4) H(a_gR) = k0 * a_gR^(-k)
%     log H = log k0 - k * log a_gR
% =>  y = b + a*x
% where y is log H and x is log a_gR. Find a and b using two datapoints. 
% Parameters a = -k and b = log k0, i.e., k = -a and k0 = exp(b)

%% '3param' k0*exp[-k2*ln^2(a_gr) - k1*ln(a_gr)]
% Fitting hazard curve based on Vamvatsikos (2013) H(a_gR) = k0*exp[-k2*ln^2(a_gr) - k1*ln(a_gr)]
%    log H = log k0 - k1 * log a_gR - k2 * (log a_gR)^2
% => y = c + b*x + a*x^2
% where y is log H and x is log a_gR. Find a, b, c using three datapoints.
% Parameters a = -k2, b = -k1, c = log k0, i.e., k0 = exp(c), k1 = -b, k2 = -a;


%% Step 1 (fit a set of piecewise curves) Find model parameters for each interval
switch fitModel
    case '2param' % H(a_gR) = k0 * a_gR^(-k)
        k0 = zeros(1, size(afeLIST, 2)-1); k = k0; % initialize
        for i = 1:size(afeLIST, 2)-1
            afeVec = afeLIST(1, i:i+1); % annual freq prob of exceedances
            imVec = imValLIST(1, i:i+1); % intensity measure values for this interval
            X = log(imVec)'; Y = log(afeVec)';
            
            A = [X, ones(length(X), 1)]; % log H = -k*log a_gR + log k0 => y = ax + b
            coeff = ((inv(A' * A)) * A') * Y;
            
            k0(1, i) = exp(coeff(2)); % see explanations above
            k(1, i) = -coeff(1);
        end   
        hazCurParams = [k0; k]; % hazard curve parameters
    case '3param' % H(a_gR) = k0*exp[-k2*ln^2(a_gr) - k1*ln(a_gr)]
        k0 = zeros(1, size(afeLIST, 2)-2); k1 = k0; k2 = k0; % initialize
        for i = 1:size(afeLIST, 2)-2
            afeVec = afeLIST(1, i:i+2); % annual freq of exceedances
            imVec = imValLIST(1, i:i+2); % intensity measure values for this interval
            X = log(imVec)'; Y = log(afeVec)';
            
            A = [X.^2, X, ones(length(X), 1)]; %  log H = -k2*(log a_gR)^2 - k1*log a_gR + log k0 => y = ax^2 + bx + c
            coeff = ((inv(A' * A)) * A') * Y;
            
            k0(1, i) = exp(coeff(3)); % see explanations above
            k1(1, i) = -coeff(2); 
            k2(1, i) = -coeff(1);
        end        
        hazCurParams = [k0; k1; k2]; % hazard curve parameters
end

%% Step 2 (plot the hazard curve in the range of imVal, i.e., input range of im values)
% Use the calculated parameters to find numerical hazard curve. Only to show the fit. 
    %     currPoeInterp = []; % initialize interpolated probability of exceedance
    switch fitModel
        case '2param' % H(a_gR) = k0 * a_gR^(-k)
            plotStyle = 'b--';
            imValDisc = []; afeDisc = [];
            for i = 1:size(afeLIST, 2)-1
                imValDiscCurr = logspace(log10(imValLIST(1, i)), log10(imValLIST(1, i+1)), N); % discretized im values
                k0_curr = hazCurParams(1, i); k_curr = hazCurParams(2, i);
                afeDiscCurr = k0_curr*imValDiscCurr.^(-k_curr); % discretized AFE
                imValDisc = [imValDisc imValDiscCurr];
                afeDisc = [afeDisc afeDiscCurr];
                % remove repeated entry
                if i ~= 1 && (abs(imValDisc(end - N) - imValDisc(end - N + 1)) < 1e-6)
                    imValDisc(end - N + 1) = []; afeDisc(end - N + 1) = [];
                end
            end
        case '3param' % H(a_gR) = k0*exp[-k2*ln^2(a_gr) - k1*ln(a_gr)]
            plotStyle = 'r-';
       % Alternate 1. Single stroke (Repeated values in overlapping intervals)
%             for i = 1:size(afeLIST, 2)-2 % this results in duplicate values in overlapping intervals
%                 imValDisc = logspace(log10(imValLIST(1, i)), log10(imValLIST(1, i+2)), 2*N-1); % discretized im values
%                 k0_curr = hazCurParams(1, i); k1_curr = hazCurParams(2, i); k2_curr = hazCurParams(3, i);
%                 afeDisc = k0_curr*exp(-k2_curr*(log(imValDisc)).^2 - k1_curr*log(imValDisc));
%             end
            
        % Alternate 2. Split into three (averaged values in overlapping intervals)
            % 2a. first interval
            imValDiscA = logspace(log10(imValLIST(1, 1)), log10(imValLIST(1, 2)), N); % discretized im values
            k0_curr = hazCurParams(1, 1); k1_curr = hazCurParams(2, 1); k2_curr = hazCurParams(3, 1);
            afeDiscA = k0_curr*exp(-k2_curr*(log(imValDiscA)).^2 - k1_curr*log(imValDiscA));
            imValDiscA(end) = []; afeDiscA(end) = []; % removing the repeated points
            % 2b. overlapping intervals
            imValDiscB = []; afeDiscB = [];
            for i = 2:size(afeLIST, 2)-2
                imValDiscCurr = logspace(log10(imValLIST(1, i)), log10(imValLIST(1, i+1)), N); % discretized im values
                imValDiscB = [imValDiscB imValDiscCurr];
                k0_currPrev = hazCurParams(1, i-1); k1_currPrev = hazCurParams(2, i-1); k2_currPrev = hazCurParams(3, i-1);
                k0_curr = hazCurParams(1, i); k1_curr = hazCurParams(2, i); k2_curr = hazCurParams(3, i);
                currAfeDisc = (k0_currPrev*exp(-k2_currPrev*(log(imValDiscCurr)).^2 - k1_currPrev*log(imValDiscCurr)) + ...
                                  k0_curr*exp(-k2_curr*(log(imValDiscCurr)).^2 - k1_curr*log(imValDiscCurr)))/2;
                afeDiscB = [afeDiscB currAfeDisc];
                if i ~= 2 && (abs(imValDiscB(end - N) - imValDiscB(end - N + 1)) < 1e-6)
                    imValDiscB(end - N + 1) = []; afeDiscB(end - N + 1) = [];
                end
            end
            imValDiscB(end) = []; afeDiscB(end) = []; % removing the repeated points
            % 2c. last interval
            imValDiscC = logspace(log10(imValLIST(1, end-1)), log10(imValLIST(1, end)), N); % discretized im values
            k0_curr = hazCurParams(1, end); k1_curr = hazCurParams(2, end); k2_curr = hazCurParams(3, end);
            afeDiscC = k0_curr*exp(-k2_curr*(log(imValDiscC)).^2 - k1_curr*log(imValDiscC));
            
            imValDisc = [imValDiscA imValDiscB imValDiscC];
            afeDisc = [afeDiscA afeDiscB afeDiscC];
        % End of alternate 2
    end

if doPlot == 1
    figure
    plot(imValDisc, afeDisc, plotStyle, 'LineWidth', 2); hold on;
    ax = gca;
    switch plotType
        case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
        case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
    end
    plot(imValLIST, afeLIST, 'k.', 'MarkerSize', 8);
    hx = xlabel(imTypeForPlot); hy = ylabel('Annual Frequency of Exceedance'); grid on;
    if ~isempty(legendName); legend(legendName); end
    psb_FigureFormatScript_forReport
% using matlab's default cubic interpolation
%     plotStyle1 = 'm--';
%     imValDisc1 = logspace(log10(imValLIST(1, 1)), log10(imValLIST(1, end)), (N-1)*(size(imValLIST, 2))); % discretized im values
%     afeDisc1 = interp1(imValLIST, afeLIST, imValDisc1, 'pchip');
%     plot(imValDisc1, afeDisc1, plotStyle1, 'LineWidth', 1); hold on;
end






















        