% coded by Abhineet Gupta, 2014-12-22
%               Stanford University
%               abhineet@stanford.edu
% 
% Summary of the AWW14 Intensity Relation for North America
% Atkinson, G. M., Worden, C. B., and Wald, D. J. (2014). “Intensity 
% Prediction Equations for North America.” Bulletin of the Seismological 
% Society of America, 104(6), 3084–3093.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Variables
% M     = Moment Magnitude
% Dh    = Hypocentral distance (km)
% region        = 0 for Western North America (WNA) - default
%               = 1 for Eastern North America (ENA)
% Depi  = Epicentral distance (km) - required for intensity preiction in
%         Eastern North America. If Depi is not provided, it is used
%         by default as Depi = Dh, since Depi as used in the prediction
%         equation only becomes significant at Depi > 100 km for which the
%         difference in Dh and Depi is not significant.


% Output Variables
% mmi: Median Modified Mercalli Intensity (MMI) prediction

% Processing variables - calculated within the function
% R     = sqrt(Dh^2 + 14^2)
% B     = max(0, log10(R/50))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mmi] = AWW_2014_mmi(M, Dh, region, Depi)

% Lengths of M and Dh should be the same unless one of them is a scalar
if ~isscalar(M) && ~isscalar(Dh) && (length(M) ~= length(Dh))
    error('Length of vectors M and Dh should be the same.');
end

% set region to WNA by default
if nargin < 3 || isempty(region)
    region = 0;
end

% set Depi to Dh if not provided for ENA
if region == 1 && (nargin < 4 || isempty(Depi))
    Depi = Dh;
end

% For ENA, lengths of M, Dh and Depi should be the same unless it is a scalar
if region == 1 && ~isscalar(Depi) && ((~isscalar(M) && length(M) ~= length(Depi)) ...
        || (~isscalar(Dh) && length(Dh) ~= length(Depi)))
    error('Length of Depi should be the same as M and Dh.');
end

% Define processing variables
R = sqrt(Dh.^2 + 14^2);
B = max(0, log10(R/50));

% Define coefficients
c1 = 0.309;
c2 = 1.864;
c3 = -1.672;
c4 = -0.00219;
c5 = 1.77;
c6 = -0.383;

% Calculate mmi for WNA
mmi = c1 + c2.*M + c3.*log10(R) + c4.*R + c5.*B + c6.*(M.*log10(R));

% Modify mmi for ENA if region is ENA
if region == 1
    mmi = mmi + 0.7 + 0.001.*Depi + max(0, 0.8.*log10(min(Depi, 150)./50));
end
