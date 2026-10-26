function [sa, sigma] = C_1997_vert(M, R, T, Fault_Type, Soil, D)

% by Jack Baker, 2/1/05
% Stanford University
% bakerjw@stanford.edu
%
% Compute the Campbell attenuation prediction for vertical motions (1997
% Seismological Research Letters, Vol 68, No 1, p128).   
%
% Note that this function makes a call to the external function
% "campbell_atten" to compute the horizontal attenuation prediction. Make
% sure that you have this function located in a directory accessible to
% Matlab.
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
    
    [sa_low, sigma_low] = C_1997_vert(M, R, T_low, Fault_Type, Soil, D);
    [sa_hi, sigma_hi] = C_1997_vert(M, R, T_hi, Fault_Type, Soil, D);
    
    x = [log(T_low) log(T_hi)];
    Y_sa = [log(sa_low) log(sa_hi)];
    Y_sigma = [sigma_low sigma_hi];
    sa = exp(interp1(x,Y_sa,log(T)));
    sigma = interp1(x,Y_sigma,log(T));
    
else % no interpolation needed

    % compute Sa horizontal
    [sa_H, sigma_H] = campbell_atten(M, R, T, Fault_Type, Soil, D, 0);
    
    % get coefficients
    [c1, c2, c3, c4, c5] = get_coefs(T);
    
    % compute Sa_vertical (Equation 13)
    ln_Sa = log(sa_H) + c1 - 0.1*M + c2*tanh(0.71*(M-4.7)) + c3*tanh(0.66*(M-4.7)) ...
        - 1.5*log(R+0.071*exp(0.661*M)) + 1.89*log(R+0.361*exp(0.576*M)) ...
        - 0.11*Fault_Type + c4*tanh(0.51*D) + c5*tanh(0.57*D);
    sa = exp(ln_Sa);
    sigma = sqrt(sigma_H^2 + 0.39^2);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    local function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c1, c2, c3, c4, c5] = get_coefs(T);
	% horizontal Sa coefficients from Table 6
	
    period = [0.05, 0.075, 0.10, 0.15, 0.20, 0.30, 0.50, 0.75, 1.00, 1.50, 2.00, 3.00, 4.00];
	c1 = [-1.32, -1.21, -1.29, -1.57, -1.73, -1.98, -2.03, -1.79, -1.82, -1.81, -1.65, -1.31, -1.35];
    c2 = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.46, 0.67, 1.13, 1.52, 1.65, 1.28, 1.15];
    c3 = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, -0.74, -1.23, -1.59, -1.98, -2.23, -2.39, -2.03];
    c4 = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.18, 0.57, 0.61, 1.07, 1.26];
    c5 = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, -0.18, -0.49, -0.63, -0.84, -1.17];
    
    index = find(period == T);
    c1 = c1(index);
	c2 = c2(index);
	c3 = c3(index);
	c4 = c4(index);
	c5 = c5(index);