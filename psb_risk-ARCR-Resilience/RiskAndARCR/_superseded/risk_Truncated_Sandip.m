%% Sample inputs
% The first row with IM values in arbitrary units (say, g) and second row with PoE 
hazardData = [[0.01;0.0199474;0.0397897;0.07937;0.158322;0.315811;0.629961;1.25661;2.5066;5]'; 
              [3.70651E-01	1.49167E-01	4.95066E-02	1.62939E-02	5.62982E-03	1.74907E-03	3.80267E-04	5.04012E-05	3.61580E-06	1.15167E-07]]; % Arunachal (27.1, 92.1)

% Median and log-dispersion parameter, respectivelywe assume lognormal distribution.
fragilityData = [1.103, 0.335]; % values are median and log-dispersion parameter, respectively; we assume lognormal distribution.

truncateIM = 0; boundRange = [];
% truncateIM = 1; boundRange = [0.01 5];
risk = computeRiskSingleSite_v3(hazardData, fragilityData, truncateIM, boundRange);
fprintf('Risk = %g.\n', risk);

% -------------------

function riskVal = computeRiskSingleSite_v3(hazardData, fragilityData, truncateIM, boundRange)
%%
% -------------------
% This function numerically evaluates risk for a single site
%
% There are four inputs of the function-
%       hazardData          The first row with IM values in arbitrary units (say, g) and second row with PoE 
%       fragilityData       Median and log-dispersion parameter, respectivelywe assume lognormal distribution.
%       truncateIM          do not truncate (= 0); yes, truncate IM using boundRange (= 1);
%       boundRange          (optional) range of bound (over im or afe, as may be the case) 
%                           = [imMin, imMax]; in case, truncateIM = 1 
% 
%       The default values of [imMin, imMax] 
%                          or [afeMin, afeMax] are taken from hazardData.
% 
% Assumptions-
%       Fragility follows lognormal distribution.
% 
% The output of the function is-
%       riskVal             Evaluated risk values
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
%% range of intensity measure values for risk computation
if truncateIM == 0 % No truncation
    imMin = min(hazardData(1, :)); imMax = max(hazardData(1, :));
elseif truncateIM == 1 % truncate using boundRange
    imMin = boundRange(1, 1); imMax = boundRange(1, 2); % range of intensity measure values for risk computation
end
Sa_median = fragilityData(1); betaTot = fragilityData(2);

%% number of points for numerical integration
% N = 1000; % good enough descritization
% imValues = logspace(log10(imMin), log10(imMax), N); % v1
% imValues = hazardData(1, :); % v2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if truncateIM == 0 % no truncation
    imValues = hazardData(1, :); 
    afeValues = hazardData(2, :); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Yes, truncate
elseif truncateIM == 1 % 1. bound over IM
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
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Risk convolution
% 1. Hazard curve interpolating
interpHazard = afeValues; % v3

%% adjust for the im values truncated below imMin
if truncateIM == 1 % exist(imMin, 1) % i.e., when truncating
    cdfAtImMin = logncdf(imMin, log(Sa_median), betaTot); % fragility curve cdf
    correctionFac = 1/(1 - cdfAtImMin); % corrected fragility 
else
    correctionFac = 1; % uncorrected fragility 
end

%% 2. Fragility function discretizing
if Sa_median <= 0 % a simple error check (lognpdf can return complex values)
    error('------- ERROR. Sa_median is negative (%4.3fg) ------- ', Sa_median);
else
    fragpdf = lognpdf(imValues, log(Sa_median), betaTot)*correctionFac; % due to truncation
end

%% 3. risk integrand
conv = fragpdf.*interpHazard;

%% 4. calculating the risk integral
conv(isnan(conv)) = 0; % converting the NaN values to zero
try
    riskVal = trapz(imValues, conv);
catch
    error('could not find area under imValues and convolution');
end
% prob_in_50y = (1-(1-riskVal)^50)*100; % output not in use

%% (NOT IN USE) Alternate risk evaluation (using the slope of hazard and fragility cdf 
% dx = diff(imValues); dx = [dx dx(end)]; % Find differece in ‘x’ values
% hazSlope = gradient(interpHazard)./ dx; % slope of hazard
% fragcdf = logncdf(imValues, log(Sa_median), betaTot);
% conv1 = fragcdf.*abs(hazSlope);
% riskVal1 = trapz(imValues, conv1)

end