function [riskVal, highestContriIM, modalImRatio] = computeRiskSingleSite_v3(hazardData, fragilityData, imOrAfeBound, boundRange)
%%
% -------------------
% This function numerically evaluates risk for a single site
%
% There are four inputs of the function-
%       hazardData          The first row with IM values in arbitrary units (say, g) and second row with PoE 
%       fragilityData       Median and log-dispersion parameter, respectively we assume lognormal distribution.
%       imOrAfeBound        no bound (=0); bound over IM (= 1); bound over AFE (= 2)
%       boundRange          (optional) range of bound (over im or afe, as may be the case) 
%                           = [imMin, imMax]; in case, imOrAfeBound = 1 
%                           = [afeMin, afeMax]; in case, imOrAfeBound = 2
% 
%       The default values of [imMin, imMax] 
%                          or [afeMin, afeMax] are taken from hazardData.
% 
% Assumptions-
%       Fragility follows lognormal distribution.
% 
% There are three outputs of the function-
%       riskVal             Evaluated risk values
%       highestContriIM     Highest contributing intensity measure
%       modalImRatio        Ratio of highestContriIM to median fragility
% 
% Revision
%       v1- hazard curve was discretized inside this module (Dec 10, 2019)
%       v2- hazard curve is already well-discretized, hence no discretization here anymore (Jan 14, 2020)
%       v3- no hazard discretization + IM-bounds + AFE-bound (Jan 14, 2020)
% 
% Author: Prakash S Badal, IIT Bombay
% Date: January 14, 2020
%
% -------------------
% 
%% Sample inputs
% The first row with IM values in arbitrary units (say, g) and second row with PoE 
% hazardData = [imValDisc;
%               afeDisc]; 
% hazardData = [[0.01;0.0199474;0.0397897;0.07937;0.158322;0.315811;0.629961;1.25661;2.5066;5]'; 
% %               [4.93674E-02	1.56508E-02	4.34903E-03	9.92152E-04	1.48798E-04	2.17530E-05	3.58761E-06	4.85807E-07	5.13758E-08	3.77013E-09]]; % Mumbai
% %               [8.26856E-02	3.47746E-02	1.36577E-02	4.95679E-03	1.61090E-03	4.48673E-04	9.31284E-05	1.06942E-05	5.21429E-07	9.73072E-09]]; % Delhi
% %               [3.34288E-01	1.24668E-01	3.92776E-02	1.25620E-02	4.21525E-03	1.25712E-03	2.62249E-04	3.36570E-05	2.33463E-06	7.18762E-08]]; % Guwahati
%               [3.70651E-01	1.49167E-01	4.95066E-02	1.62939E-02	5.62982E-03	1.74907E-03	3.80267E-04	5.04012E-05	3.61580E-06	1.15167E-07]]; % Arunachal (27.1, 92.1)
              
% Median and log-dispersion parameter, respectively we assume lognormal distribution.
% fragilityData = [0.231665029035492, 0.280176831835109]; % values are median and log-dispersion parameter, respectively; we assume lognormal distribution.

% imOrAfeBound = 1; boundRange = [0.01 1.5];
% imOrAfeBound = 2; boundRange = [1e-6 4e-1];
% imOrAfeBound = 0;

%% calculation begins (set default values)
switch nargin 
    case 2 % no bound
        imOrAfeBound = 0; boundRange = [];
    case 3
        if imOrAfeBound == 1 % bound over im 
            boundRange = [min(hazardData(1, :)), max(hazardData(1, :))];
        elseif imOrAfeBound == 2 % bound over AFE
            boundRange = [min(hazardData(2, :)), max(hazardData(2, :))];
        end
end

% range of intensity measure values for risk computation
if imOrAfeBound == 0 % No bound
    imMin = min(hazardData(1, :)); imMax = max(hazardData(1, :));
elseif imOrAfeBound == 1 % bound over IM
    imMin = boundRange(1, 1); imMax = boundRange(1, 2); % range of intensity measure values for risk computation
elseif imOrAfeBound == 2 % bound over AFE
    afeMin = boundRange(1, 1); afeMax = boundRange(1, 2); 
end
Sa_median = fragilityData(1); betaTot = fragilityData(2);

%% number of points for numerical integration
% N = 1000; % good enough discretization
% imValues = logspace(log10(imMin), log10(imMax), N); % v1
% imValues = hazardData(1, :); % v2

% v3 stuff here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if imOrAfeBound == 1 % 1. bound over IM
% 1a. Define imValues of interest
    if imMin < min(hazardData(1, :)) - 1e-6           % imMin is less than the data minimum (considering precision error)
        error('Minimum limit of IM is out of the range of hazard data (< %.2e); consider increasing the lower limit of IM value', min(hazardData(1, :)));
    elseif abs(imMin - min(hazardData(1, :))) < 1e-6  % imMin is same as the data minimum
        imValues = hazardData(1, :);
    else % imMin > min(hazardData(1, :)) + 1e-6        % imMin is more than the data minimum
        imValues = hazardData(1, :);              % assign values in hazard data to imValues 
        imValues(imValues < (imMin - 1e-6)) = []; % remove values lower than imMin (considering precision error)
        imValues = [imMin, imValues];             % add imMin as the first entry, i.e., smallest value
    end
    
    if imMax > max(hazardData(1, :)) + 1e-6           % imMax is more than the data maximum (considering precision error)
        error('Maximum limit of IM is out of the range of hazard data (> %.2e); consider reducing the upper limit of IM value', max(hazardData(1, :)));
    elseif abs(imMax - max(hazardData(1, :))) < 1e-6  % imMax is same as the data maximum
        % no change
    else % imMax < max(hazardData(1, :)) - 1e-6       % imMax is less than the data maximum
        imValues(imValues > (imMax + 1e-6)) = []; % remove values lower than imMin (considering precision error)
        imValues = [imValues, imMax];             % add imMax as the last entry, i.e., highest value
    end
% 1b. Define corresponding afeValues 
    afeValues = exp(interp1(log(hazardData(1, :)), log(hazardData(2, :)), log(imValues)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif imOrAfeBound == 2 % 2. bound over AFE
% 2a. Define afeValues of interest
    if afeMin < min(hazardData(2, :)) - 1e-12           % afeMin is less than the data minimum (considering precision error)
        error('Minimum limit of AFE is out of the range of hazard data (< %.2e); consider increasing the lower limit of AFE value', min(hazardData(2, :)));
    elseif abs(afeMin - min(hazardData(2, :))) < 1e-12  % afeMin is same as the data minimum
        afeValues = hazardData(2, :);
    else % afeMin > min(hazardData(2, :)) + 1e-12       % afeMin is more than the data minimum
        afeValues = hazardData(2, :);                % assign values in hazard data to afeValues 
        afeValues(afeValues < (afeMin - 1e-12)) = []; % remove values lower than afeMin (considering precision error)
        afeValues = [afeValues, afeMin];             % add afeMin as the LAST entry, i.e., smallest value
    end
    
    if afeMax > max(hazardData(2, :)) + 1e-12           % afeMax is more than the data maximum (considering precision error)
        error('Maximum limit of AFE is out of the range of hazard data (> %.2e); consider reducing the upper limit of AFE value', max(hazardData(2, :)));
    elseif abs(afeMax - max(hazardData(2, :))) < 1e-12  % afeMax is same as the data maximum
        % no change
    else % afeMax < max(hazardData(2, :)) - 1e-12        % afeMax is less than the data maximum
        afeValues(afeValues > (afeMax + 1e-12)) = []; % remove values lower than afeMin (considering precision error)
        afeValues = [afeMax, afeValues];                % add afeMax as the FIRST entry, i.e., highest value
    end
% 2b. Define corresponding imValues 
    imValues = exp(interp1(log(hazardData(2, :)), log(hazardData(1, :)), log(afeValues)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. No bound
elseif imOrAfeBound == 0 % no bound
    imValues = hazardData(1, :); 
    afeValues = hazardData(2, :); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Risk convolution
% 1. Hazard curve interpolating
% interpHazard = interp1(hazardData(1, :), hazardData(2, :), imValues); % v1 
% interpHazard = hazardData(2, :); % v2
interpHazard = afeValues; % v3

%% adjust for the im values truncated below imMin
if imOrAfeBound == 1 % exist(imMin, 1) % i.e., when there is a bound over im
    cdfAtImMin = logncdf(imMin, log(Sa_median), betaTot); % fragility curve cdf
    correctionFac = 1/(1 - cdfAtImMin); % corrected fragility 
% correctionFac = 1; % uncorrected fragility 
else
    correctionFac = 1;
end

%% 2. Fragility function discretizing
if Sa_median <= 0 % a simple error check (lognpdf can return complex values)
    error('------- ERROR. Sa_median is negative (%4.3fg) ------- ', Sa_median);
else
    fragpdf = lognpdf(imValues, log(Sa_median), betaTot)*correctionFac; % due to truncation
%     fragcdf = logncdf(imValues, log(Sa_median), betaTot); % fragility curve cdf
end

%% 3. risk integrand
conv = fragpdf.*interpHazard;

%% 4. calculating the risk integral
conv(isnan(conv)) = 0; % converting the NaN values to zero
try
    riskVal = trapz(imValues, conv);
catch
    xyz = 5;
end
% prob_in_50y = (1-(1-riskVal)^50)*100; % output not in use

% 5. deaggregation
[~, index] = max(conv);
highestContriIM = imValues(index);
modalImRatio = highestContriIM/Sa_median;

% 6. output list
% [riskVal, highestContriIM, modalImRatio]

%% (NOT IN USE) Alternate risk evaluation (using the slope of hazard and fragility cdf 
% dx = diff(imValues); dx = [dx dx(end)]; % Find differece in ‘x’ values
% hazSlope = gradient(interpHazard)./ dx; % slope of hazard
% fragcdf = logncdf(imValues, log(Sa_median), betaTot);
% conv1 = fragcdf.*abs(hazSlope);
% riskVal1 = trapz(imValues, conv1)