function [sa, sigma] = C_1997_horiz(M, R, T, Fault_Type, Soil, D, arb)

% by Jack Baker, 2/1/05
% Stanford University
% bakerjw@stanford.edu
%
% Compute the Campbell attenuation prediction (1997 Seismological Research
% Letters, Vol 68, No 1, p180).   
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
%   Fault_Type      = 0 for strike-slip fault
%                   = 1 for reverse, thrust, reverse-oblique, and thrust-oblique fault 
%   Soil            = 0 for soil
%                   = 1 for soft rock
%                   = 2 for hard rock
%   D               = depth to basement bedrock (km)
%   arb             = 1 for arbitrary component sigma
%                   = 0 for average component sigma
%
% OUTPUT   
%
%   sa              = median spectral acceleration prediction
%   sigma           = logarithmic standard deviation of spectral acceleration
%                     prediction FOR AN ARBITRARY OR AVERAGE COMPONENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% interpolate between periods if neccesary    
period = [0.05, 0.075, 0.10, 0.15, 0.20, 0.30, 0.50, 0.75, 1.00, 1.50, 2.00, 3.00, 4.00];
if (length(find(period == T)) == 0)
    index_low = sum(period<T);
    T_low = period(index_low);
    T_hi = period(index_low+1);
    
    [sa_low, sigma_low] = C_1997_horiz(M, R, T_low, Fault_Type, Soil, D, arb);
    [sa_hi, sigma_hi] = C_1997_horiz(M, R, T_hi, Fault_Type, Soil, D, arb);
    
    x = [log(T_low) log(T_hi)];
    Y_sa = [log(sa_low) log(sa_hi)];
    Y_sigma = [sigma_low sigma_hi];
    sa = exp(interp1(x,Y_sa,log(T)));
    sigma = interp1(x,Y_sigma,log(T));
    
else % no interpolation needed

    % convert soil parameter
    S_SR = 0;
    S_HR = 0;
    if(Soil == 1)
        S_SR = 1;
    elseif(Soil == 2)
        S_HR = 1;
    end
    
    % Compute PGA
    [Ah, sigma_lnAH] = get_PGA(M, R, Fault_Type, S_SR, S_HR);
    
    % get coefficients
    [c1, c2, c3, c4, c5, c6, c7, c8] = get_coefs(T);
    
    % compute Sa (Equation 8)
    [depth_term] = f_SA(D, c6, S_HR, S_SR);
    ln_Sa = log(Ah) + c1 + c2*tanh(c3*(M-4.7)) + (c4+c5*M)*R + 0.5*c6*S_SR + c6*S_HR + c7*tanh(c8*D)*(1-S_HR) + depth_term;
    sa = exp(ln_Sa);
    
    % dispersion for geometric mean (Equation 10)
    sigma = sqrt(sigma_lnAH^2 + 0.27^2);
    if (arb) % inflate sigma to reflect arbitrary component standard deviation
        sigma = sigma * sqrt(2/(1.78-0.039*log(T))); % using Baker's emperical ratio
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Ah, sigma_lnAH] = get_PGA(M, R, F, S_SR, S_HR);
	% from Equation 3
	
    ln_Ah = -3.512 + 0.904*M - 1.328*log( sqrt(R^2 + (.149*exp(0.647*M))^2)) + (1.125-0.112*log(R)-0.0957*M)*F + (.44-.171*log(R))*S_SR + (.405-.222*log(R))*S_HR;
	Ah = exp(ln_Ah);
	
	if (Ah < 0.068)
        sigma_lnAH = 0.55;
	elseif (Ah <= 0.21)
        sigma_lnAH = 0.173 - 0.14 * ln_Ah;
	else
        sigma_lnAH = 0.39;
	end

function [c1, c2, c3, c4, c5, c6, c7, c8] = get_coefs(T);
	% horizontal Sa coefficients from Table 5
	
    period = [0.05, 0.075, 0.10, 0.15, 0.20, 0.30, 0.50, 0.75, 1.00, 1.50, 2.00, 3.00, 4.00];
	c1 = [.05 .27 .48 .72 .79 .77 -.28 -1.08 -1.79 -2.65 -3.28 -4.07 -4.26];
	c2 = [0.00	0.00 0.00 0.00 0.00 0.00 0.74 1.23 1.59 1.98 2.23 2.39 2.03];
	c3 = [0 0 0 0 0 0 0.66 0.66 0.66 0.66 0.66 0.66 0.66];
	c4 = [-0.0011 -0.0024 -0.0024 -0.001 0.0011 0.0035 0.0068 0.0077 0.0085 0.0094 0.01 0.0108 0.0112];
	c5 = [0.000055 0.000095 0.000007 -0.00027 -0.00053 -0.00072 -0.001 -0.001 -0.001 -0.001 -0.001 -0.001 -0.001];
	c6 = [0.2 0.22 0.14 -0.02 -0.18 -0.4 -0.42 -0.44 -0.38 -0.32 -0.36 -0.22 -0.3];
	c7 = [0 0 0 0 0 0 0.25 0.37 0.57 0.72 0.83 0.86 1.05];
	c8 = [0 0 0 0 0 0 0.62 0.62 0.62 0.62 0.62 0.62 0.62];
    
    index = find(period == T);
	c1 = c1(index);
	c2 = c2(index);
	c3 = c3(index);
	c4 = c4(index);
	c5 = c5(index);
	c6 = c6(index);
	c7 = c7(index);
	c8 = c8(index);

function [depth_term] = f_SA(D, c6, S_HR, S_SR);
	% from equations below Equation 8
	
    if (D >= 1)
        depth_term = 0;
    else
        depth_term = c6*(1-S_SR)*(1-D) + 0.5*c6*(1-D)*S_SR;
    end
