function [sa, sigma] = Sadigh_1997_horiz(M, R, T, Fault_Type, DS, arb)

% by Ting Lin 03/31/08
% Stanford University
% tinglin@stanford.edu

% Compute the Sadigh et al. ground motion prediction (1997 Seismological
% Research Letters, Vol 68, No. 1, p180).

% This script has been modified to include standard deviations for either
% arbitrary or average components of ground motion See Baker, JW, and
% Cornell, CA (2006). "Which spectral acceleration are you using?"
% Earthquake Spectra, 22(2), 293-312.
%
% This script has also been modified to correct an error in the prediction
% equation in Table 2 that occured in the original publication.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%
%   M               = earthquake magnitude
%   R               = closest distance to fault rupture surface
%   T               = period of vibration
%   Fault_Type      = 0 for strike-slip fault, rake angle < 45 degrees
%                   = 1 for reverse fault, rake angle > 45 degrees
%                       or thrust fault
%   DS              = 1 for deep soil
%                   = 0 for rock
%   arb             = 1 for arbitrary component sigma
%                   = 0 for average component sigma
%
% OUTPUT
%
%   sa              = median spectral acceleration prediction in g
%   sigma           = logarithmic standard deviation of spectral acceleration
%                     prediction FOR AN ARBITRARY OR AVERAGE COMPONENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% A common period vector is used for rock and deep soil sites with the
% second period entry 0.07 sec in Table 2 and 3 changed to 0.075 sec (to be
% consistent with Table 4).  This minor modification is believed to have
% little impact on the prediction results.
period = [0.001 0.075 0.10 0.20 0.30 0.40 0.50 0.75 1.00 1.50 2.00 3.00 4.00];

% Interpolate between periods if neccesary
if (length(find(period == T)) == 0)
    index_low = sum(period<T);
    T_low = period(index_low);
    T_hi = period(index_low+1);

    [sa_low, sigma_low] = Sadigh_1997_horiz(M, R, T_low, Fault_Type, DS, arb)
    [sa_hi, sigma_hi] = Sadigh_1997_horiz(M, R, T_hi, Fault_Type, DS, arb)

    x = [log(T_low) log(T_hi)];
    Y_sa = [log(sa_low) log(sa_hi)];
    Y_sigma = [sigma_low sigma_hi];
    sa = exp(interp1(x,Y_sa,log(T)));
    sigma = interp1(x,Y_sigma,log(T));
else
    i = find(period == T);

    % Get coefficients and compute sa and sigma
    
    % Check site condition: Rock or deep soil?
    % Rock (Table 2 and 3)
    if (DS == 0)
        c3 = [0.000 0.006 0.006 -0.004 -0.017 -0.028 -0.040 -0.050 -0.055 -0.065 -0.070 -0.080 -0.100];
        c4 = [-2.100 -2.128 -2.148 -2.080 -2.028 -1.990 -1.945 -1.865 -1.800 -1.725 -1.670 -1.610 -1.570];
        c7 = [0.0 -0.082 -0.041 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0];
        
        % Check magnitude: M <= 6.5?
        if (M <= 6.5)
            c1 = [-0.624 0.110 0.275 0.153 -0.057 -0.298 -0.588 -1.208 -1.705 -2.407 -2.945 -3.700 -4.230];
            c2 = 1.0;
            c5 = 1.29649;
            c6 = 0.250;
        else
            c1 = [-1.274 -0.540 -0.375 -0.497 -0.707 -0.948 -1.238 -1.858 -2.355 -3.057 -3.595 -4.350 -4.880];
            c2 = 1.1;
            c5 = -0.48451;
            c6 = 0.524;
        end

        % Calculate sa based on prediction relationships of horizontal response
        % spectral accelerations (5% damping) for rock sites (Table 2)
        % Include correction of error: change from (8.5*M) to (8.5-M)
        lny = c1(i) + c2*M + c3(i)*(8.5-M)^2.5 + c4(i)*log(R + exp(c5 + c6*M)) + c7(i)*log(R + 2); 
        sa = exp(lny);

        % Modification based on fault type:
        % Relationships for reverse/thrust faulting are obtained by multiplying the
        % above strike-slip amplitudes by 1.2
        if (Fault_Type == 1)
            sa = 1.2*sa;
        end

        % Calculate sigma based on dispersion relationships for horizontal rock
        % motion (Table 3)
        % Check magnitude: M < 7.21?
        if (M < 7.21)
            c8 = [1.39 1.40 1.41 1.43 1.45 1.48 1.50 1.52 1.53 1.53 1.53 1.53 1.53];
            sigma = c8(i) - 0.14*M;
        else
            c9 = [0.38 0.39 0.40 0.42 0.44 0.47 0.49 0.51 0.52 0.52 0.52 0.52 0.52];
            sigma = c9(i);
        end

    else
        % Deep Soil (Table 4)
        c2 = 1.0;
        c3 = 1.70;
        c7 = [0.0 0.005 0.005 -0.004 -0.014 -0.024 -0.033 -0.051 -0.065 -0.090 -0.108 -0.139 -0.160];
        
        % Check magnitude: M <= 6.5?
        if (M <= 6.5)
            c4 = 2.1863;
            c5 = 0.32;
        else
            c4 = 0.3825;
            c5 = 0.5882;
        end

        % Check fault type: strike-slip or reverse?
        if (Fault_Type == 0)
            c1 = -2.17; % Strike-slip
            c6 = [0.0 0.4572 0.6395 0.9187 0.9547 0.9251 0.8494 0.7010 0.5665 0.3235 0.1001 -0.2801 -0.6274]; % Strike-slip
        else
            c1 = -1.92; % Reverse and thrust
            c6 = [0.0 0.4572 0.6395 0.9187 0.9547 0.9005 0.8285 0.6802 0.5075 0.2215 -0.0526 -0.4905 -0.8907]; % Reverse
        end

        % Calculate sa based on prediction relationships for deep soil sites (Table 4)
        lny = c1 + c2*M - c3*log(R + c4*exp(c5*M)) + c6(i) + c7(i)*(8.5-M)^2.5; 
        sa = exp(lny);

        % Calculate standard error sigma
        c8 = [1.52 1.54 1.54 1.565 1.58 1.595 1.61 1.635 1.66 1.69 1.70 1.71 1.71];
        
        if (M<=7)
            sigma = c8(i) - 0.16*M;
        else
            % Modification based on magnitude:
            % Standard error for magnitudes greater than M7 set equal to the value for
            % M7
            sigma = c8(i) - 0.16*7;
        end
    end
end

if (arb) % Inflate the sigma using a functional fit developed by Baker
    sigma = sigma * sqrt(2/(1.78-0.039*log(T)));
end



