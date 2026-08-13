function [sa, sigma] = RI_2007_horiz_peninsular(M, Rjb, T, Soil, arb)

% by Prakash S Badal, 8/17/16 
% IIT Bombay
% aprakashn@gmail.com
%
% Compute the Raghukanth, Iyengar attenuation prediction 
% Estimation of seismic spectral acceleration in Peninsular India (2007,
% Journal of Earth Syst. Sciences, Vol 116, No 3, p199)
%
% This script modifies the Joyner-Boore distance to hypocentral distance based on the reference -
% On the Conversion of Source-to-Site Distance Measures for Extended Earthquake Source Models by
% Scherbaum, Schmedes, Cotton (2004, Bull. Seis. Society of Amerca, Vol 94,
% No 3, 1053-1069)
% 
% This script has been modified to include standard deviations for either
% arbitrary or average components of ground motion See Baker, JW, and 
% Cornell, CA (2006). "Which spectral acceleration are you using?" 
% Earthquake Spectra, 22(2), 293-312.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
%   M               = earthquake magnitude
%   Rjb             = Joyner Boore distance. We later on convert JB distance to hyposentral distance
%   T               = period of vibration
%   Soil            = 1 for NEHRP soil type A (Vs30 >= 1520 m/s)
%                   = 2 for NEHRP soil type B (Vs30 between 760 and 1520 m/s)
%                   = 3 for NEHRP soil type C (Vs30 between 360 and 760 m/s)
%                   = 4 for NEHRP soil type D (Vs30 between 180 and 360 m/s)
%   arb             = 1 for arbitrary component sigma
%                   = 0 for average component sigma
%
% OUTPUT   
%
%   sa              = median spectral acceleration prediction
%   sigma           = logarithmic standard deviation of spectral acceleration
%                     prediction FOR AN ARBITRARY OR AVERAGE COMPONENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revised on 09-12-2017 to include intermediate Time period values by interpolating.

% (Validated with Figure 5 in the paper for the M = 6.5 and Rhyp = 35 km case) 
% Note that R approx 25 km corresponds to Rhyp = 35 km for M = 6.5

% interpolate between periods if neccesary (PGA included)
period = [0.00, 0.01, 0.015, 0.02, 0.03, 0.04, 0.05, 0.06, 0.075, 0.09, 0.1, 0.15, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.9, 1, 1.2, 1.5, 2, 2.5, 3, 4];
if (isempty((period == T)))
    index_low = sum(period<T);
    T_low = period(index_low);
    T_hi = period(index_low+1);
    
    [sa_low, sigma_low] = RI_2007_horiz_peninsular(M, Rjb, T_low, Soil, arb);
    [sa_hi, sigma_hi] = RI_2007_horiz_peninsular(M, Rjb, T_hi, Soil, arb);
    
    x = [log(T_low) log(T_hi)];
    Y_sa = [log(sa_low) log(sa_hi)];
    Y_sigma = [sigma_low sigma_hi];
    sa = exp(interp1(x,Y_sa,log(T)));
    sigma = interp1(x,Y_sigma,log(T));
    
else % no interpolation needed

    % get coefficients
    [c1, c2, c3, c4, sigma_ln_br, a1, a2, sig_ln_delS]  = get_coefs(T, Soil);

    
    % convert R_JB to R_hyp
    
    if M <= 6.75 
        M1 = M;
        epireq = Rjb;
        Rhyp = 150.97204889064361 - 113.8656963720851 * M1 + 33.653157495617521 * M1 ^ 2 - 4.4627676599264507 * M1 ^ 3 + 0.2261174651846693 * M1 ^ 4 + 2.2152007788222 * epireq - 2.0293225252650409 * M1 * epireq + 0.64783683799676628 * M1 ^ 2 * epireq - 0.0908129272314918 * M1 ^ 3 * epireq + 0.0047798522703136554 * M1 ^ 4 * epireq - 0.02212116353009215 * epireq ^ 2 + 0.019970696876323871 * M1 * epireq ^ 2 - 0.0063440473123840867 * M1 ^ 2 * epireq ^ 2 + 0.00088079894246125749 * M1 ^ 3 * epireq ^ 2 - 0.000045677283848634718 * M1 ^ 4 * epireq ^ 2 + 0.000062064490461006885 * epireq ^ 3 - 0.000055345443500882272 * M1 * epireq ^ 3 + 0.000017471489056384371 * M1 ^ 2 * epireq ^ 3 - 2.4054893519645169 * 10 ^ (-6) * M1 ^ 3 * epireq ^ 3 + 1.2335308442315569 * 10 ^ (-7) * M1 ^ 4 * epireq ^ 3 + sqrt(9 + Rjb * Rjb);
    else
        M2 = M;
%         epireq = R;
        epireq = Rjb;
        Rhyp = -18280.584726531921 + 9293.83227399828 * M2 - 1749.4096026544551 * M2 ^ 2 + 143.99856788170939 * M2 ^ 3 - 4.3445748830658886 * M2 ^ 4 + 286.31532034962629 * epireq - 142.55323970133571 * M2 * epireq + 26.322919651043559 * M2 ^ 2 * epireq - 2.135730799381395 * M2 ^ 3 * epireq + 0.0642817910027026 * M2 ^ 4 * epireq - 6.774248542505676 * epireq ^ 2 + 3.5499144347297462 * M2 * epireq ^ 2 - 0.69536242814296223 * M2 ^ 2 * epireq ^ 2 + 0.060367425051172867 * M2 ^ 3 * epireq ^ 2 - 0.00196120056776834 * M2 ^ 4 * epireq ^ 2 + 0.02339136947906641 * epireq ^ 3 - 0.01234033062075008 * M2 * epireq ^ 3 + 0.002434979397402488 * M2 ^ 2 * epireq ^ 3 - 0.00021305042335023841 * M2 ^ 3 * epireq ^ 3 + 6.9779897014871137 * 10 ^ (-6) * M2 ^ 4 * epireq ^ 3 + sqrt(9 + Rjb * Rjb);
    end
    
    % compute Sa (Equation 8)
    SaMean_ln_bedRock = c1 + c2 * (M - 6) + c3 * (M - 6) * (M - 6) - log(Rhyp) - c4 * Rhyp;
    sa_bedRock = exp(SaMean_ln_bedRock);

    Fs = exp(a1 * sa_bedRock + a2); % soil modification factor
    sa = sa_bedRock * Fs; % spectral acceleration at the soil site
    
    % equation 11
    sigma = sqrt(sigma_ln_br^2 + sig_ln_delS^2);
   
    if (arb) % inflate sigma to reflect arbitrary component standard deviation
        sigma = sigma * sqrt(2/(1.78-0.039*log(T))); % using Baker's empirical ratio
    end
    
%     fprintf('Rjb = %f, => Rhyp = %f, Fs = %f \n', Rjb, Rhyp, Fs);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function [Ah, sigma_log10AH] = get_PGA(M, R, S_A, S_S)
% 	% from Equation 15
% 	
%     log10_Ah = -1.48 + 0.266*M - 0.922*log10(sqrt(R^2+3.5^2)) + 0.117*S_A + 0.124*S_S;
% 	Ah = 10^log10_Ah;
% 	
%     sigma_log10AH = 0.25;

function [c1, c2, c3, c4, sigma_ln_br, a1, a2, sig_ln_delS] = get_coefs(T, soil_type)
    % sigma_ln_br stands for sigma in log of spectral acceleration at BedRock
    % sigma_ln_delS stands for sigma in log of spectral acceleration at soil
	% horizontal Sa coefficients from Table 3
	
    period = [0.00, 0.01, 0.015, 0.02, 0.03, 0.04, 0.05, 0.06, 0.075, 0.09, 0.1, 0.15, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 0.8, 0.9, 1, 1.2, 1.5, 2, 2.5, 3, 4];
    
    c1 = [1.6858, 1.751, 1.8602, 2.0999, 2.631, 2.8084, 2.78, 2.6986, 2.5703, 2.4565, 2.389, 2.12, 1.9192, 1.6138, 1.372, 1.6138, 0.977, 0.8061, 0.7254, 0.6476, 0.4996, 0.3604, 0.2904, -0.2339, -0.7096, -1.1064, -1.4468, -2.009];
    c2 = [0.9241, 0.9203, 0.9184, 0.9098, 0.8999, 0.9022, 0.909, 0.9173, 0.9308, 0.945, 0.9548, 1.007, 1.0619, 1.1708, 1.2716, 1.3615, 1.4409, 1.5111, 1.5432, 1.5734, 1.6291, 1.6791, 1.7464, 1.8695, 1.9983, 2.0919, 2.1632, 2.2644];
    c3 = [-0.0760, -0.0748, -0.0666, -0.063, -0.0582, -0.0583, -0.0605, -0.0634, -0.0687, -0.0748, -0.0791, -0.1034, -0.1296, -0.1799, -0.2219, -0.2546, -0.2791, -0.297, -0.304, -0.3099, -0.3188, -0.3248, -0.33, -0.329, -0.3144, -0.2945, -0.2737, -0.235];
    c4 = [0.0057, 0.0056, 0.0053, 0.0056, 0.006, 0.0059, 0.0055, 0.0052, 0.0049, 0.0046, 0.0044, 0.0038, 0.0034, 0.0028, 0.0024, 0.0021, 0.0019, 0.0017, 0.0016, 0.0016, 0.0015, 0.0014, 0.0013, 0.0011, 0.0011, 0.001, 0.0011, 0.0011];
    sigma_ln_br = [0.4648, 0.4636, 0.423, 0.4758, 0.5189, 0.4567, 0.413, 0.4201, 0.4305, 0.4572, 0.4503, 0.4268, 0.3932, 0.3984, 0.3894, 0.3817, 0.3744, 0.3676, 0.3645, 0.3616, 0.3568, 0.3531, 0.3748, 0.3479, 0.314, 0.3222, 0.3493, 0.3182];

%     index = find(period == T);
% 	c1 = c1(index);
% 	c2 = c2(index);
% 	c3 = c3(index);
% 	c4 = c4(index);
%     sigma_ln_br = sigma_ln_br(index);
    
	c1 = interp1(period, c1, T, 'pchip');
	c2 = interp1(period, c2, T, 'pchip');
	c3 = interp1(period, c3, T, 'pchip');
	c4 = interp1(period, c4, T, 'pchip');
	sigma_ln_br = interp1(period, sigma_ln_br, T, 'pchip');
    
    % horizontal Sa coefficients from Table 5
    FA_a1 = zeros(1, length(period));
    FA_a2 = [0.36, 0.35, 0.31, 0.26, 0.25, 0.31, 0.36, 0.39, 0.43, 0.46, 0.47, 0.50, 0.51, 0.53, 0.52, 0.51, 0.49, 0.49, 0.48, 0.47, 0.46, 0.45, 0.43, 0.39, 0.36, 0.34, 0.32, 0.31]; 
    FA_sig_delS = [0.030, 0.040, 0.060, 0.080, 0.040, 0.010, 0.010, 0.010, 0.010, 0.010, 0.010, 0.020, 0.020, 0.030, 0.030, 0.060, 0.010, 0.010, 0.020, 0.010, 0.010, 0.020, 0.010, 0.020, 0.030, 0.040, 0.040, 0.050]; 
    
    FB_a1 = zeros(1, length(period));
    FB_a2 = [0.49, 0.43, 0.36, 0.24, 0.18, 0.29, 0.40, 0.48, 0.56, 0.62, 0.71, 0.74, 0.76, 0.76, 0.74, 0.72, 0.69, 0.68, 0.66, 0.63, 0.61, 0.62, 0.57, 0.51, 0.44, 0.40, 0.38, 0.36]; 
    FB_sig_delS = [0.080, 0.11, 0.16, 0.090, 0.030, 0.010, 0.020, 0.020, 0.030, 0.020, 0.010, 0.010, 0.020, 0.020, 0.010, 0.020, 0.020, 0.020, 0.020, 0.010, 0.020, 0.11, 0.030, 0.040, 0.060, 0.080, 0.10, 0.11]; 
    
    FC_a1 = [-0.89, -0.89, -0.89, -0.91, -0.94, -0.87, -0.83, -0.83, -0.81, -0.83, -0.84, -0.93, -0.78, 0.060, -0.060, -0.17, -0.040, -0.25, 0.36, -0.34, -0.29, 0.24, -0.11, -0.10, -0.13, -0.15, -0.17, -0.19]; 
    FC_a2 = [0.66, 0.66, 0.54, 0.32, -0.010, -0.050, 0.11, 0.27, 0.50, 0.68, 0.79, 1.11, 1.16, 1.03, 0.99, 0.97, 0.93, 0.88, 0.86, 0.84, 0.81, 0.78, 0.67, 0.62, 0.47, 0.39, 0.32, 0.35]; 
    FC_sig_delS = [0.23, 0.23, 0.23, 0.19, 0.21, 0.21, 0.18, 0.18, 0.19, 0.18, 0.15, 0.16, 0.18, 0.13, 0.13, 0.12, 0.12, 0.12, 0.090, 0.12, 0.12, 0.10, 0.090, 0.090, 0.080, 0.080, 0.090, 0.080]; 
    
    FD_a1 = [-2.61, -2.62, -2.62, -2.61, -2.54, -2.44, -2.34, -2.78, -2.32, -2.27, -2.25, -2.38, -2.32, -1.86, -1.28, -0.69, -0.56, -0.42, -0.36, -0.18, 0.17, 0.53, 0.77, 1.13, 0.61, 0.37, 0.13, 0.12]; 
    FD_a2 = [0.80, 0.80, 0.69, 0.55, 0.42, 0.58, 0.65, 0.83, 0.93, 1.04, 1.12, 1.4, 1.57, 1.51, 1.43, 1.34, 1.32, 1.29, 1.28, 1.27, 1.25, 1.23, 1.14, 1.01, 0.79, 0.68, 0.60, 0.44]; 
    FD_sig_delS = [0.36, 0.37, 0.37, 0.34, 0.31, 0.31, 0.29, 0.29, 0.19, 0.29, 0.19, 0.28, 0.19, 0.16, 0.16, 0.21, 0.21, 0.21, 0.19, 0.21, 0.21, 0.15, 0.17, 0.17, 0.15, 0.15, 0.13, 0.15];
    
    if soil_type == 1
%         a1 = FA_a1(index); a2 = FA_a2(index); sig_ln_delS = FA_sig_delS(index);
        a1 = interp1(period, FA_a1, T, 'pchip'); a2 = interp1(period, FA_a2, T, 'pchip'); 
        sig_ln_delS = interp1(period, FA_sig_delS, T, 'pchip');
        
    elseif soil_type == 2
%         a1 = FB_a1(index); a2 = FB_a2(index); sig_ln_delS = FB_sig_delS(index);
        a1 = interp1(period, FB_a1, T, 'pchip'); a2 = interp1(period, FB_a2, T, 'pchip'); 
        sig_ln_delS = interp1(period, FB_sig_delS, T, 'pchip');
    elseif soil_type == 3
%         a1 = FC_a1(index); a2 = FC_a2(index); sig_ln_delS = FC_sig_delS(index);
        a1 = interp1(period, FC_a1, T, 'pchip'); a2 = interp1(period, FC_a2, T, 'pchip'); 
        sig_ln_delS = interp1(period, FC_sig_delS, T, 'pchip');
    else
%         a1 = FD_a1(index); a2 = FD_a2(index); sig_ln_delS = FD_sig_delS(index);
        a1 = interp1(period, FD_a1, T, 'pchip'); a2 = interp1(period, FD_a2, T, 'pchip'); 
        sig_ln_delS = interp1(period, FD_sig_delS, T, 'pchip');
    end
    
    


