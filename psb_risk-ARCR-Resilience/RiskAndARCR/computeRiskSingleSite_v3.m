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
% There are three outputs of the function-
%       riskVal             Evaluated risk values
%       highestContriIM     Highest contributing intensity measure
%       modalImRatio        Ratio of highestContriIM to median fragility
% 
% Revision
%       v3- no hazard discretization + IM-bounds + AFE-bound (Jan 14, 2020)
% 
% Author: Prakash S Badal, IIT Bombay
% Date: January 14, 2020
%
% -------------------
% 

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
% interpHazard = afeValues; % v3
interpHazard = exp(interp1(log(hazardData(1,:)), log(hazardData(2,:)), log(imValues)));

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

