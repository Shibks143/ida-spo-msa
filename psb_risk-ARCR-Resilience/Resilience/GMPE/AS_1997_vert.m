function [sa, sigma] = AS_1997_vert(M, r_rup, T, is_soil, fault_type, HW);

% by Jack Baker, 2/1/05
% Stanford University
% bakerjw@stanford.edu
%
% Compute the Abrahamson and Silva attenuation prediction for spectral
% accelerations of the vertical component (1997 Seismological Research
% Letters, Vol 68, No 1, p94).  
%
% This script has been modified to correct an error in the function
% f_3 that occured in the printed version of the attenuation.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
%   M               = earthquake magnitude
%   R               = closest distance to fault rupture
%   T               = period of vibration
%   is_soil         = 1 for soil prediction
%                   = 0 for rock
%   fault_type      = 1 for Reverse
%                   = 0.5 for reverse/oblique
%                   = 0 otherwise
%   HW              = 1 for Hanging Wall sites
%                   = 0 otherwise
%
% OUTPUT   
%
%   sa              = median spectral acceleration prediction
%   sigma           = logarithmic standard deviation of spectral acceleration
%                     prediction FOR AN ARBITRARY OR AVERAGE COMPONENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% for the given period T, get the index for the constants
period = [0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.075, 0.09, 0.1, 0.12, 0.15, 0.17, 0.2, 0.24, 0.3, 0.36, 0.4, 0.46, 0.5, 0.6, 0.75, 0.85, 1, 1.5, 2, 3, 4, 5];

% fill in missing input parameters with default values
if (nargin < 4) % no soil type supplied
    is_soil = 1;
end

if (nargin < 5) % no fault type supplied
    fault_type = 0;
end

if (nargin < 6) % no Hanging wall indicator supplied
    HW = 0;
end

% interpolate between periods if neccesary    
if (length(find(period == T)) == 0)
    index_low = sum(period<T);
    T_low = period(index_low);
    T_hi = period(index_low+1);
    
    [sa_low, sigma_low] = AS_1997_vert(M, r_rup, T_low, is_soil, fault_type, HW);
    [sa_hi, sigma_hi] = AS_1997_vert(M, r_rup, T_hi, is_soil, fault_type, HW);
    
    x = [T_low T_hi];
    Y_sa = [log(sa_low) log(sa_hi)];
    Y_sigma = [sigma_low sigma_hi];
    sa = exp(interp1(x,Y_sa,T));
    sigma = interp1(x,Y_sigma,T);
else
    index = find(period == T);
    
    % get constants for the given index value
    V = get_abrahamson_silva_constants(index);
    R = sqrt(r_rup^2 + V.c4^2);
    

    % compute the PGA term, if we need it
    S = is_soil;
    if ((index ~= 0) | (is_soil ~= 0))
        pga_constants = get_abrahamson_silva_constants(1);
        rock_S = 0;
        pga_rock = exp(calc_val(M, R, pga_constants, fault_type, rock_S, HW, 0));
    else
        pga_rock = 0
    end
    
    sa = exp(calc_val(M, R, V, fault_type, S, HW, pga_rock));

    sigma = abrahamson_silva_sigma(M, index);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [f1] = f_1(M, R, V);
% value of f1
if (M <= V.c1) 
        f1 = V.a1 + V.a2 * (M - V.c1) + V.a12 * (8.5 - M) ^ V.n + (V.a3 + V.a13 * (M - V.c1)) * log(R);
else 
        f1 = V.a1 + V.a4 * (M - V.c1) + V.a12 * (8.5 - M) ^ V.n + (V.a3 + V.a13 * (M - V.c1)) * log(R);
end

function [f3] = f_3(M, V);
% value of f_3
if M <= 5.8 
        f3 = V.a5;
elseif M < V.c1
%         f3 = V.a5 + (V.a6 - V.a5) / (V.c1 - 5.8);
        f3 = V.a5 + (V.a6 - V.a5) / (V.c1 - 5.8) * (M-5.8);
else
        f3 = V.a6;
end

function [f4] = f_4(M, R, V);
% value of f_4
    if (M <= 5.5) f_HW_M = 0;
    elseif (M <= 6.5) f_HW_M = M - 5.5;
    else f_HW_M = 1;
    end
    
    if (R <= 4) f_HW_R = 0;
    elseif (R <= 8) f_HW_R = V.a9 * (R-4)/4;
    elseif (R <= 18) f_HW_R = V.a9;
    elseif (R <= 24) f_HW_R = V.a9 * (1- (R-18)/7);
    else f_HW_R = 0;
    end
f4 = f_HW_M*f_HW_R;

function [f5] = f_5(pga_rock, V);
% value of f_5
f5 = V.a10 + V.a11 * log(pga_rock + V.c5);

function [X] = calc_val(M, R, constants, F, S, HW, pga_rock)
% calculate predicted value

%assume no hanging walls
X = f_1(M, R, constants) + F*f_3(M, constants) + HW*f_4(M, R, constants) + S*f_5(pga_rock, constants);

    
function [contants] = get_abrahamson_silva_constants(index);
% get relevant constants

% arrays with values by index
period = [0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.075, 0.09, 0.1, 0.12, 0.15, 0.17, 0.2, 0.24, 0.3, 0.36, 0.4, 0.46, 0.5, 0.6, 0.75, 0.85, 1, 1.5, 2, 3, 4, 5];
c4 = [6.00, 6.00, 6.00, 6.00, 6.00, 6.00, 6.00, 6.00, 6.00, 6.00, 6.00, 5.72, 5.35, 4.93, 4.42, 4.01, 3.77, 3.45, 3.26, 2.85, 2.50, 2.50, 2.50, 2.50, 2.50, 2.50, 2.50, 2.50];
a1 = [1.642, 1.642, 2.100, 2.420, 2.620, 2.710, 2.750, 2.730, 2.700, 2.480, 2.170, 1.960, 1.648, 1.312, 0.878, 0.617, 0.478, 0.271, 0.145, -0.087, -0.344, -0.469, -0.602, -0.966, -1.224, -1.581, -1.857, -2.053];
a2 = 0.909;
a3 = [-1.2520, -1.2520, -1.3168, -1.3700, -1.3700, -1.3700, -1.3700, -1.3700, -1.3700, -1.2986, -1.2113, -1.1623, -1.0987, -1.0274, -0.9400, -0.9004, -0.8776, -0.8472, -0.8291, -0.7896, -0.7488, -0.7451, -0.7404, -0.7285, -0.7200, -0.7200, -0.7200, -0.7200];
a4 = 0.275;
a5 = [0.390, 0.390, 0.432, 0.469, 0.496, 0.518, 0.545, 0.567, 0.580, 0.580, 0.580, 0.580, 0.580, 0.580, 0.580, 0.571, 0.539, 0.497, 0.471, 0.416, 0.348, 0.309, 0.260, 0.260, 0.260, 0.260, 0.260, 0.260];
a6 = [-0.050, -0.050, -0.050, -0.050, -0.050, -0.050, -0.050, -0.050, -0.050, -0.017, 0.024, 0.047, 0.076, 0.109, 0.150, 0.150, 0.150, 0.150, 0.150, 0.150, 0.150, 0.150, 0.150, 0.058, -0.008, -0.100, -0.100, -0.100];
a9 = [0.630, 0.630, 0.630, 0.630, 0.630, 0.630, 0.630, 0.630, 0.630, 0.630, 0.630, 0.604, 0.571, 0.533, 0.488, 0.450, 0.428, 0.400, 0.383, 0.345, 0.299, 0.273, 0.240, 0.240, 0.240, 0.240, 0.240, 0.240];
a10 = [-0.140, -0.140, -0.140, -0.140, -0.140, -0.140, -0.129, -0.119, -0.114, -0.104, -0.093, -0.087, -0.078, -0.069, -0.057, -0.048, -0.043, -0.035, -0.031, -0.022, -0.010, -0.004, 0.004, 0.025, 0.040, 0.040, 0.040, 0.040];
a11 = [-0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220, -0.220];
a12 = [0.0000, 0.0000, 0.0000, 0.0000, -0.0002, -0.0004, -0.0007, -0.0009, -0.0010, -0.0015, -0.0022, -0.0025, -0.0030, -0.0035, -0.0042, -0.0047, -0.0050, -0.0056, -0.0060, -0.0068, -0.0083, -0.0097, -0.0115, -0.0180, -0.0240, -0.0431, -0.0565, -0.0670];
a13 = 0.06;
mag1 = 6.4;
c5 = 0.3;
n = 3;
NPer = 27;

contants.period = period(index);
contants.c4 = c4(index);
contants.a1 = a1(index);
contants.a2 = a2;
contants.a3 = a3(index);
contants.a4 = a4;
contants.a5 = a5(index);
contants.a6 = a6(index);
contants.a9 = a9(index);
contants.a10 = a10(index);
contants.a11 = a11(index);
contants.a12 = a12(index);
contants.a13 = a13;
contants.c1 = mag1;
contants.c5 = c5;
contants.n = n;


function [sigma] = abrahamson_silva_sigma(M, index)
% calculate the sigma

b5 = [0.76, 0.76, 0.76, 0.76, 0.76, 0.76, 0.76, 0.76, 0.76, 0.74, 0.72, 0.70, 0.69, 0.69, 0.69, 0.69, 0.69, 0.69, 0.69, 0.69, 0.69, 0.69, 0.69, 0.69, 0.69, 0.72, 0.75, 0.78];
b6 = [0.085, 0.085, 0.085, 0.085, 0.085, 0.085, 0.085, 0.085, 0.085, 0.075, 0.063, 0.056, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050, 0.050];

if M <= 5 
    sigma = b5(index);
elseif M <= 7
    sigma = b5(index) - b6(index) * (M - 5);
else
    sigma = b5(index) - 2 * b6(index);
end