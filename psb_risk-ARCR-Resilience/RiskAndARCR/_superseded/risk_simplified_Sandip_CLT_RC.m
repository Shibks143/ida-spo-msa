%% Sample inputs
clear; % clc;
% hazardData = [[0.01;0.0199474;0.0397897;0.07937;0.158322;0.315811;0.629961;1.25661;2.5066;5]'; 
%               [3.70651E-01	1.49167E-01	4.95066E-02	1.62939E-02	5.62982E-03	1.74907E-03	3.80267E-04	5.04012E-05	3.61580E-06	1.15167E-07]]; % Arunachal (27.1, 92.1)
% fragilityData = [1.0, 0.4]; % values are median and log-dispersion parameter, respectively; we assume lognormal distribution.

% Vancouver hazard SA(1.17)
hazardData = [0.01000000	0.01370730	0.01878890	0.02575440	0.03530220	0.04838970	0.06632900	0.09091880	0.12462470	0.17082630	0.23415600	0.32096360	0.43995300	0.60305490	0.82662280	1.13307300	1.55313220	2.12891800	2.91816250	4.00000000;
              7.6696055E-02	5.6921295E-02	4.1331833E-02	2.9376718E-02	2.0445423E-02	1.3935098E-02	9.2901671E-03	6.0319097E-03	3.7802128E-03	2.2563405E-03	1.2626030E-03	6.5213725E-04	3.0687268E-04	1.3039845E-04	4.9834876E-05	1.7137018E-05	5.3218500E-06	1.4996212E-06	3.8469310E-07	8.9690141E-08;];
frag_Unsca = [1.286	0.350]; % values are median and log-dispersion parameter, respectively; we assume lognormal distribution.
frag_Sca   = [1.103	0.335]; % values are median and log-dispersion parameter, respectively; we assume lognormal distribution.
frag_FF    = [1.42	0.445]; % values are median and log-dispersion parameter, respectively; we assume lognormal distribution.
frag_NF    = [1.192	0.342]; % values are median and log-dispersion parameter, respectively; we assume lognormal distribution.
frag_Flag_0p8_Sca = [1.43466 0.44337]; 
frag_Flag_0p6_Sca = [1.38669 0.44333];

beta_MDL_DR_TD = sqrt(0.35^2 + 0.1^2 + 0.2^2);
% beta_MDL_DR_TD = 0;

frag_Unsca(2) = sqrt(frag_Unsca(2)^2 + beta_MDL_DR_TD^2);
frag_Sca(2) = sqrt(frag_Sca(2)^2 + beta_MDL_DR_TD^2);
frag_FF(2) = sqrt(frag_FF(2)^2 + beta_MDL_DR_TD^2);
frag_NF(2) = sqrt(frag_NF(2)^2 + beta_MDL_DR_TD^2);
frag_Flag_0p8_Sca(2) = sqrt(frag_Flag_0p8_Sca(2)^2 + beta_MDL_DR_TD^2);
frag_Flag_0p6_Sca(2) = sqrt(frag_Flag_0p6_Sca(2)^2 + beta_MDL_DR_TD^2);

risk1 = computeRiskSingleSite_v3(hazardData, frag_Unsca);
risk2 = computeRiskSingleSite_v3(hazardData, frag_Sca  );
risk3 = computeRiskSingleSite_v3(hazardData, frag_FF   );
risk4 = computeRiskSingleSite_v3(hazardData, frag_NF   );
risk5 = computeRiskSingleSite_v3(hazardData, frag_Flag_0p8_Sca);
risk6 = computeRiskSingleSite_v3(hazardData, frag_Flag_0p6_Sca);

fprintf('Risk_Unsca = %g.\n', risk1);
fprintf('Risk_Sca = %g.\n', risk2);
fprintf('Risk_FF = %g.\n', risk3);
fprintf('Risk_NF = %g.\n', risk4);
fprintf('Risk_Flag_0p8_Sca = %g.\n', risk5);
fprintf('Risk_Flag_0p6_Sca = %g.\n', risk6);

% -------------------
function riskVal = computeRiskSingleSite_v3(hazardData, fragilityData)
%%
% -------------------
% This function numerically evaluates risk for a single site
%
% There are two inputs of the function-
%       hazardData          The first row with IM values in arbitrary units (say, g) and second row with PoE 
%       fragilityData       Median and log-dispersion parameter, respectivelywe assume lognormal distribution.
% 
% Assumptions-
%       Fragility follows lognormal distribution.
% 
% The output of the function is-
%       riskVal             Evaluated risk values
% 
% Revision
%       v4- descretized hazard + No truncation (Jun 30, 2022)
% 
% Author: Prakash S Badal, IIT Bombay
% Date: January 14, 2020
% Modified: June 30, 2022 simplified (psb, UBCO)
%
% -------------------
% 
%% range of intensity measure values for risk computation
fragMedian = fragilityData(1); beta = fragilityData(2);

%% Input hazard curve
imHaz = hazardData(1, :); afeHaz = hazardData(2, :); 

%% number of points for numerical integration
N = 50;
imMin = hazardData(1, 1); imMax = hazardData(1, end);

%% 1. interpolate the hazard curve
imInterp = logspace(log10(imMin), log10(imMax), N); % v1
afeInterp = exp(interp1(log(imHaz), log(afeHaz), log(imInterp), 'pchip')); % interpolate in logspace

%% 2. Fragility function discretizing (note the lognormal assumption here)
fragpdf = lognpdf(imInterp, log(fragMedian), beta); % due to truncation

%% 3. risk integrand
conv = fragpdf.*afeInterp;

%% 4. calculating the risk convolution 
conv(isnan(conv)) = 0; % converting the NaN values to zero
try
    riskVal = trapz(imInterp, conv);
catch
    error('could not calculate the area under the convoluted integrand.');
end

end