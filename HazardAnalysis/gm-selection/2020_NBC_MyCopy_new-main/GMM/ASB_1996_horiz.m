function [sa, sigma] = ASB_1996_horiz(M, R, T, Soil, arb)

% by Prakash S Badal, 8/17/16
% IIT Bombay
% aprakashn@gmail.com
%
% Compute the Ambraseys, Simpson, Bommer attenuation prediction 
% PREDICTION OF HORIZONTAL RESPONSE SPECTRA IN EUROPE (1996, EARTHQUAKE
% ENGINEERING AND STRUCTURAL DYNAMICS, Vol 25, p371)
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
%   R               = closest distance to fault rupture
%   T               = period of vibration
%   Soil            = 0 for other kinds of soil
%                   = 1 for soft soil (Vs30 between 400 and 800 m/s)
%                   = 2 for stiff soil (Vs30 > 800 m/s)
%   arb             = 1 for arbitrary component sigma
%                   = 0 for average component sigma
%
% OUTPUT   
%
%   sa              = median spectral acceleration prediction
%   sigma           = logarithmic standard deviation of spectral acceleration
%                     prediction FOR AN ARBITRARY OR AVERAGE COMPONENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% interpolate between periods if neccesary (PGA included)
period = [0.0, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.22, 0.24, 0.26, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38, 0.4, 0.42, 0.44, 0.46, 0.48, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2];
if (isempty(find(period == T)))
    index_low = sum(period<T);
    T_low = period(index_low);
    T_hi = period(index_low+1);
    
    [sa_low, sigma_low] = ASB_1996_horiz(M, R, T_low, Soil, arb);
    [sa_hi, sigma_hi] = ASB_1996_horiz(M, R, T_hi, Soil, arb);
    
    x = [log(T_low) log(T_hi)];
    Y_sa = [log(sa_low) log(sa_hi)];
    Y_sigma = [sigma_low sigma_hi];
    sa = exp(interp1(x,Y_sa,log(T)));
    sigma = interp1(x,Y_sigma,log(T));
    
else % no interpolation needed

    % convert soil parameter
    S_A = 0;
    S_S = 0;
    if(Soil == 1)
        S_S = 1;
    elseif(Soil == 2)
        S_A = 1;
    end
    
    % get coefficients
    [c1, c2, h0, c4, ca, cs, sigma]  = get_coefs(T);
    
    % compute Sa (Equation 11)
    log10_Sa = c1 + c2 * M + c4 * log10(sqrt(R * R + h0 * h0)) + ca * S_A + cs * S_S;
    sa = 10^log10_Sa;
   
    if (arb) % inflate sigma to reflect arbitrary component standard deviation
        sigma = sigma * sqrt(2/(1.78-0.039*log(T))); % using Baker's empirical ratio
    end
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

function [c1, c2, h0, c4, ca, cs, sigma] = get_coefs(T)
	% horizontal Sa coefficients from Table 5
	
    period = [0.0, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2, 0.22, 0.24, 0.26, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38, 0.4, 0.42, 0.44, 0.46, 0.48, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2];

    c1 = [-1.48, -0.84, -0.86, -0.87, -0.87, -0.94, -0.98, -1.05, -1.08, -1.13, -1.19, -1.21, -1.28, -1.37, -1.4, -1.46, -1.55, -1.63, -1.65, -1.69, -1.82, -1.94, -1.99, -2.05, -2.11, -2.17, -2.25, -2.38, -2.49, -2.58, -2.67, -2.75, -2.86, -2.93, -3.03, -3.1, -3.17, -3.3, -3.38, -3.43, -3.52, -3.61, -3.68, -3.74, -3.79, -3.8, -3.79];
    c2 = [0.266, 0.219, 0.221, 0.231, 0.238, 0.244, 0.247, 0.252, 0.258, 0.268, 0.278, 0.284, 0.295, 0.308, 0.318, 0.326, 0.338, 0.349, 0.351, 0.354, 0.364, 0.377, 0.384, 0.393, 0.401, 0.41, 0.42, 0.434, 0.438, 0.451, 0.463, 0.477, 0.485, 0.492, 0.502, 0.503, 0.508, 0.513, 0.513, 0.514, 0.522, 0.524, 0.52, 0.517, 0.514, 0.508, 0.503];
    h0 = [3.5, 4.5, 4.5, 4.7, 5.3, 4.9, 4.7, 4.4, 4.3, 4, 3.9, 4.2, 4.1, 3.9, 4.3, 4.4, 4.2, 4.2, 4.4, 4.5, 3.9, 3.6, 3.7, 3.9, 3.7, 3.5, 3.3, 3.1, 2.5, 2.8, 3.1, 3.5, 3.7, 3.9, 4, 4, 4.3, 4, 3.6, 3.6, 3.4, 3, 2.5, 2.5, 2.4, 2.8, 3.2];
    c4 = [-0.922, -0.954, -0.945, -0.96, -0.981, -0.955, -0.938, -0.907, -0.896, -0.901, -0.907, -0.922, -0.911, -0.916, -0.942, -0.946, -0.933, -0.932, -0.939, -0.936, -0.9, -0.888, -0.897, -0.908, -0.911, -0.92, -0.913, -0.911, -0.881, -0.901, -0.914, -0.942, -0.925, -0.92, -0.92, -0.892, -0.885, -0.857, -0.851, -0.848, -0.839, -0.817, -0.781, -0.759, -0.73, -0.724, -0.728];
    sigma = [0.25, 0.27, 0.27, 0.27, 0.27, 0.27, 0.27, 0.27, 0.27, 0.27, 0.28, 0.27, 0.28, 0.28, 0.28, 0.29, 0.3, 0.31, 0.31, 0.31, 0.31, 0.31, 0.32, 0.32, 0.32, 0.32, 0.32, 0.32, 0.32, 0.32, 0.33, 0.32, 0.32, 0.32, 0.32, 0.32, 0.32, 0.32, 0.31, 0.31, 0.31, 0.31, 0.31, 0.31, 0.32, 0.32, 0.32];
    ca = [0.117, 0.078, 0.098, 0.111, 0.131, 0.136, 0.143, 0.152, 0.14, 0.129, 0.133, 0.135, 0.12, 0.124, 0.134, 0.134, 0.133, 0.125, 0.118, 0.124, 0.132, 0.139, 0.147, 0.153, 0.149, 0.15, 0.147, 0.134, 0.124, 0.122, 0.116, 0.113, 0.127, 0.124, 0.124, 0.121, 0.128, 0.123, 0.128, 0.115, 0.109, 0.109, 0.108, 0.105, 0.104, 0.103, 0.101];
    cs = [0.124, 0.027, 0.036, 0.052, 0.068, 0.077, 0.085, 0.101, 0.102, 0.107, 0.13, 0.142, 0.143, 0.155, 0.163, 0.158, 0.148, 0.161, 0.163, 0.16, 0.164, 0.172, 0.18, 0.187, 0.191, 0.197, 0.201, 0.203, 0.212, 0.215, 0.214, 0.212, 0.218, 0.218, 0.225, 0.217, 0.219, 0.206, 0.214, 0.2, 0.197, 0.204, 0.206, 0.206, 0.204, 0.194, 0.182];    
    
    index = find(period == T);
	c1 = c1(index);
	c2 = c2(index);
	h0 = h0(index);
	c4 = c4(index);
	ca = ca(index);
	cs = cs(index);
    sigma = sigma(index);
    
    
    
