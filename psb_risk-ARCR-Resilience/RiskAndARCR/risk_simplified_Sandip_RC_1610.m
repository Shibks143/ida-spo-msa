%% Sample inputs
clear; % clc;
% Vancouver hazard SA(1.17)
% hazardData = [0.01000000	0.01370730	0.01878890	0.02575440	0.03530220	0.04838970	0.06632900	0.09091880	0.12462470	0.17082630	0.23415600	0.32096360	0.43995300	0.60305490	0.82662280	1.13307300	1.55313220	2.12891800	2.91816250	4.00000000;
%               7.6696055E-02	5.6921295E-02	4.1331833E-02	2.9376718E-02	2.0445423E-02	1.3935098E-02	9.2901671E-03	6.0319097E-03	3.7802128E-03	2.2563405E-03	1.2626030E-03	6.5213725E-04	3.0687268E-04	1.3039845E-04	4.9834876E-05	1.7137018E-05	5.3218500E-06	1.4996212E-06	3.8469310E-07	8.9690141E-08;];
% Vancouver hazard SA(1.68)
hazardData = [0.0100000000000000	0.0137073000000000	0.0187889000000000	0.0257544000000000	0.0353022000000000	0.0483897000000000	0.0663290000000000	0.0909188000000000	0.124624700000000	0.170826300000000	0.234156000000000	0.320963600000000	0.439953000000000	0.603054900000000	0.826622800000000	1.13307300000000	1.55313220000000	2.12891800000000	2.91816250000000	4;
              0.0504353051781378	0.0365361880836281	0.0259279177827211	0.0180520222749806	0.0123484862610384	0.00830334342564606	0.00547797402107770	0.00352365118120327	0.00218406668561709	0.00128338575958382	0.000702095712324387	0.000351619471947200	0.000159068374999438	6.44072761950216e-05	2.32096219558321e-05	7.41794147633531e-06	2.09725595821998e-06	5.22916835991233e-07	1.14403727204714e-07	2.17648918432552e-08];

frag_FF    = [0.739	0.37];
frag_NF    = [0.676	0.33];

beta_MDL_DR_TD = sqrt(0.35^2 + 0.1^2 + 0.2^2);
frag_FF(2) = sqrt(frag_FF(2)^2 + beta_MDL_DR_TD^2);
frag_NF(2) = sqrt(frag_NF(2)^2 + beta_MDL_DR_TD^2);

risk3 = computeRiskSingleSite_v3(hazardData, frag_FF   );
risk4 = computeRiskSingleSite_v3(hazardData, frag_NF   );
fprintf('Risk_FF = %g.\n', risk3);
fprintf('Risk_NF = %g.\n', risk4);

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