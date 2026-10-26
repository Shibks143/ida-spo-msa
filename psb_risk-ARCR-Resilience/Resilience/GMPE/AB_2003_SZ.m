function [Sa, sigma] = AB_2003_SZ(T,M,h,Df,Zt,Vs30,Zl)

% by James Bronder 06/09/2010
% Stanford University
% jbronder@stanford.edu

% Purpose: Computes the mean and standard deviation of the PGA
% or psuedoacceleration, PSA, 5% damping. Additional modifications are also
% included for the regions of Cascadia and Japan.

% Citation: "Empirical Ground-Motion Relations for Subduction-Zone
% Earthquakes and Their Application to Cascadia and Other Regions" by
% Atkinson, Gail M., David M. Boore. Bulletin of the Seismological Society
% of America, Vol. 93, No. 4, pp. 1703-1729, August 2003

% General Limitations: This equation is obtained from a global database of
% ground motions (~1200 horizontal records). It is highly recommended that
% a comparison be drawn using records that compare well with the region of
% interest.
%   The authors suggest applying the equation for these given bounds:

%   For Interface Events:
%   5.5 <= M < 6.5 and Df <= 80 km
%   6.5 <= M < 7.5 and Df <= 150 km
%   M >= 7.5 and Df <= 300 km

%   For Intraslab (In-slab) Events:
%   6.0 <= M < 6.5 and Df <= 100 km
%   M >= 6.5 and Df <= 200 km

%   The established bounds optimize the equations for seismic-hazard
%   analysis.

%------------------------------INPUTS-------------------------------------%

% T  = Period (sec)
% M  = Moment Magnitude
% h  = Focal (Hypocentral) Depth (km)
% Df = closest distance to the fault surface (km)
% Zt = Subduction Type Indicator: Zt = 0 for interface events
%                                 Zt = 1 for intraslab (in-slab) events
% Vs30 = Shear Wave Velocity averaged over the top 30 meters of soil of the
%      soil profile (m/sec)
% Zl = Cascadia or Japan indicator: Zl = 0 for General Cases
%                                   Zl = 1 for Cascadia
%                                   Zl = 2 for Japan

%------------------------------OUTPUTS------------------------------------%

% Sa    = Median spectral acceleration prediction (g)
% sigma = Logarithmic standard deviation of spectral acceleration
%         prediction

%-------------------------------Period------------------------------------%
period = [0 0.04 0.1 0.2 0.4 1 2 1/0.33];

%---------------------Interslab Events Coefficients-----------------------%

c1_it = [2.991 2.8753 2.7789 2.6638 2.5249 2.1442 2.1907 2.301];
c1_it_jp = [3.14 3.05 2.95 2.84 2.58 2.18 2.14 2.27];
c1_it_cas = [2.79 2.60 2.50 2.54 2.50 2.18 2.33 2.36];
c2_it = [0.03525 0.07052 0.09841 0.12386 0.1477 0.1345 0.07148 0.02237];
c3_it = [0.00759 0.01004 0.00974 0.00884 0.00728 0.00521 0.00224 0.00012];
c4_it = [-0.00206 -0.00278 -0.00287 -0.0028 -0.00235 -0.0011 0 0];
c5_it = [0.19 0.15 0.15 0.15 0.13 0.1 0.1 0.1];
c6_it = [0.24 0.2 0.23 0.27 0.37 0.3 0.25 0.25];
c7_it = [0.29 0.2 0.2 0.25 0.38 0.55 0.4 0.36];
sigma_it = [0.23 0.26 0.27 0.28 0.29 0.34 0.34 0.36];
sigma1_it = [0.2 0.22 0.25 0.25 0.25 0.28 0.29 0.31];
sigma2_it = [0.11 0.14 0.1 0.13 0.15 0.19 0.18 0.18];

%---------------------In-slab Events Coefficients-------------------------%

c1_in = [-0.04713 0.50697 0.43928 0.51589 0.005445 -1.02133 -2.39234 -3.70012];
c1_in_jp = [0.10 0.68 0.61 0.70 0.07 -0.98 -2.44 -3.73];
c1_in_cas = [-0.25 0.23 0.16 0.40 -0.01 -0.98 -2.25 -3.64];
c2_in = [0.6909 0.63273 0.66675 0.69186 0.7727 0.8789 0.9964 1.1169];
c3_in = [0.0113 0.01275 0.0108 0.00572 0.00173 0.0013 0.00364 0.00615];
c4_in = [-0.00202 -0.00234 -0.00219 -0.00192 -0.00178 -0.00173 -0.00118 -0.00045];
c5_in = [0.19 0.15 0.15 0.15 0.13 0.1 0.1 0.1];
c6_in = [0.24 0.2 0.23 0.27 0.37 0.3 0.25 0.25];
c7_in = [0.29 0.2 0.2 0.25 0.38 0.55 0.4 0.36];
sigma_in = [0.27 0.25 0.28 0.28 0.28 0.29 0.3 0.3];
sigma1_in = [0.23 0.24 0.27 0.26 0.26 0.27 0.28 0.29];
sigma2_in = [0.14 0.07 0.07 0.1 0.1 0.11 0.11 0.08];

% Preliminary Inital Conditions and Variables Computation
if h >= 100
    h = 100;
else
    h;
end

if Zt == 0 && M >= 8.5
    M = 8.5;
elseif Zt == 0 && M < 8.5
    M;
elseif Zt == 1 && M >= 8.0
    M = 8.0;
elseif Zt == 1 && M < 8.0
    M;
end

delta = 0.00724*(10^(0.507*M));
R = sqrt(Df^2 + delta^2);

if Zt == 0
    g = 10^(1.2 - 0.18*M);
elseif Zt == 1
    g = 10^(0.301 - 0.01*M);
end

if Vs30 > 760
    Sc = 0;
    Sd = 0;
    Se = 0;
elseif Vs30 > 360
    Sc = 1;
    Sd = 0;
    Se = 0;
elseif Vs30 >= 180
    Sc = 0;
    Sd = 1;
    Se = 0;
elseif Vs30 < 180
    Sc = 0;
    Sd = 0;
    Se = 1;
end

% Begin Computation of Ground Motion Parameter with the modifications
if Zt == 0
    
    if Zl == 0
        c1 = c1_it(1);
    elseif Zl == 1
        c1 = c1_it_cas(1);
    elseif Zl == 2
        c1 = c1_it_jp(1);
    end
    
    log_PGArx = c1 + c2_it(1)*M + c3_it(1)*h + c4_it(1)*R - ...
        g*log10(R);
    PGArx = 10^(log_PGArx);
    
    if PGArx <= 100 || (1/T) <= 1
        sl = 1;
    end
    
    if 1/T >= 2
        if PGArx < 500
            sl = 1 - (PGArx - 100)/400;
        elseif PGArx >= 500
            sl = 0;
        end
    elseif 1/T < 2
        if PGArx < 500
            sl = 1 - ((1/T)-1)*(PGArx - 100)/400;
        elseif PGArx >= 500
            sl = 1 - ((1/T)-1);
        end
    end
    
elseif Zt == 1
    
    if Zl == 0
        c1 = c1_in(1);
    elseif Zl == 1
        c1 = c1_in_cas(1);
    elseif Zl == 2
        c1 = c1_in_jp(1);
    end
    
    log_PGArx = c1 + c2_in(1)*M + c3_in(1)*h + c4_in(1)*R - ...
        g*log10(R);
    PGArx =10^(log_PGArx);
    
    if PGArx <= 100 || (1/T) <= 1
        sl = 1;
    end
    
    if 1/T >= 2
        if PGArx < 500
            sl = 1 - (PGArx - 100)/400;
        elseif PGArx >= 500
            sl = 0;
        end
    elseif 1/T < 2
        if PGArx < 500
            sl = 1 - ((1/T)-1)*(PGArx - 100)/400;
        elseif PGArx >= 500
            sl = 1 - ((1/T)-1);
        end
    end
end

if Zt == 0
    
    if length(find(period == T)) == 0
        
        i_lo = sum(period<T);
        T_lo = period(i_lo);
        T_hi = period(i_lo + 1);
        
        [Sa_hi sigma_hi] = AB_2003_SZ(T_hi,M,h,Df,Zt,Vs30,Zl);
        [Sa_lo sigma_lo] = AB_2003_SZ(T_lo,M,h,Df,Zt,Vs30,Zl);
        
        x = [T_lo T_hi];
        Y_Sa = [Sa_lo Sa_hi];
        Y_sigma = [sigma_lo sigma_hi];
        Sa = interp1(x,Y_Sa,T);
        sigma = interp1(x,Y_sigma,T);
        
    else
        i=find(period == T);
        
        if Zl == 0
            c1 = c1_it(i);
        elseif Zl == 1
            c1 = c1_it_cas(i);
        elseif Zl == 2
            c1 = c1_it_jp(i);
        end
        
        log_10_Y = c1 + c2_it(i)*M + c3_it(i)*h + c4_it(i)*R - ...
            g*log10(R) + c5_it(i)*sl*Sc + c6_it(i)*sl*Sd + ...
            c7_it(i)*sl*Se; % Log10 Sa in cm/s^2
        sigma_10 = sqrt((sigma1_it(i))^2 + (sigma2_it(i))^2);
        
        Sa = 10.^(log_10_Y)/981; % Median Sa in g
        sigma = log(10.^sigma_10);
    end
elseif Zt == 1
    if length(find(period == T)) == 0
        
        i_lo = sum(period<T);
        T_lo = period(i_lo);
        T_hi = period(i_lo + 1);
        
        [Sa_hi sigma_hi] = AB_2003_SZ(T_hi,M,h,Df,Zt,Vs30,Zl);
        [Sa_lo sigma_lo] = AB_2003_SZ(T_lo,M,h,Df,Zt,Vs30,Zl);
        
        x = [T_lo T_hi];
        Y_Sa = [Sa_lo Sa_hi];
        Y_sigma = [sigma_lo sigma_hi];
        Sa = interp1(x,Y_Sa,T);
        sigma = interp1(x,Y_sigma,T);
        
    else
        i=find(period == T);
        
        if Zl == 0
            c1 = c1_in(i);
        elseif Zl == 1
            c1 = c1_in_cas(i);
        elseif Zl == 2
            c1 = c1_in_jp(i);
        end
        
        log_10_Y = c1 + c2_in(i)*M + c3_in(i)*h + c4_in(i)*R - ...
            g*log10(R) + c5_in(i)*sl*Sc + c6_in(i)*sl*Sd + ...
            c7_in(i)*sl*Se; % Log10 Sa in cm/s^2
        sigma_10 = sqrt((sigma1_in(i))^2 + (sigma2_in(i))^2);
        
        Sa = 10.^(log_10_Y)/981; % Median Sa in g
        sigma = log(10.^sigma_10);
    end
end