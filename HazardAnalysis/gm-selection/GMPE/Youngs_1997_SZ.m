function [Sa, sigma] = Youngs_1997_SZ (M, T, r, H, Zt, Zr)

% by James Bronder 06/09/2010
% Stanford University
% jbronder@stanford.edu

% Purpose: Computes the median and logaritmic standard deviation of a
%          subduction zone earthquake with 5% damping.

% Citation: "Strong Ground Motion Attentuation Relationships for Subduction
% Zone Earthquakes" by Youngs, R.R., S.J. Chiou, W.J. Silva, J.R. Humphrey.
% Seismological Research Letters, vol. 68, no. 1, p. 58-73

% General Limitations: According to the authors, "The attenuation
% relationships developed in this study are considered appropriate for
% earthquakes of magnitude M 5 and greater and for distances to the rupture
% surface of 10 to 500km."

%----------------------------------INPUTS---------------------------------%

% M   = Moment Magnitude
% T   = Period of Interest (sec.). For PGA Computation, T = 0
%       For Rock Sites, 0<=T<=3
%       For Soil Sites, 0<=T<=4
% r   = Source to site distance to rupture surface (km)
% H   = Hypocentral (Focal) depth from surface to focus (km)
% Zt  = Subduction Zone Type: For Intraslab, Zt = 1
%                             For Interface, Zt = 0
% Zr  = Rock Site Indicator: For Rock Sites, Zr = 1
%                                 Otherwise, Zr = 0

%---------------------------------OUTPUTS---------------------------------%

% Sa    = Median spectral acceleration prediction (g)
% sigma = Logarithmic standard deviation of spectral acceleration
%         prediction

%--------------------------Generic Rock Period----------------------------%
period_rock = [0 0.075 0.10 0.20 0.30 0.40 0.50 0.75 1.00 1.50 2.00 3.00];

%-------------------------Generic Rock Coefficients-----------------------%
grc1  = [0.2418 1.5168 1.4298 0.9638 0.4878 0.1268 -0.1582 -0.9072 -1.4942 -2.3922 -3.0862 -4.2692];
grc2  = [1.414 1.414 1.414 1.414 1.414 1.414 1.414 1.414 1.414 1.414 1.414 1.414];
grc3  = [0.0000 0.0000 -0.0011 -0.0027 -0.0036 -0.0043 -0.0048 -0.0057 -0.0064 -0.0073 -0.0080 -0.0089];
grc4  = [-2.552 -2.707 -2.655 -2.528 -2.454 -2.401 -2.360 -2.286 -2.234 -2.160 -2.107 -2.033];
grc5  = [0.00607 0.00607 0.00607 0.00607 0.00607 0.00607 0.00607 0.00607 0.00607 0.00607 0.00607 0.00607];
grc6  = [0.3846 0.3846 0.3846 0.3846 0.3846 0.3846 0.3846 0.3846 0.3846 0.3846 0.3846 0.3846];
grc7  = [1.7818 1.7818 1.7818 1.7818 1.7818 1.7818 1.7818 1.7818 1.7818 1.7818 1.7818 1.7818];
grc8  = [0.554 0.554 0.554 0.554 0.554 0.554 0.554 0.554 0.554 0.554 0.554 0.554];
grc9  = [1.45 1.45 1.45 1.45 1.45 1.45 1.45 1.45 1.45 1.50 1.55 1.65];
grc10 = [-0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1];
grc11 = [0.650 0.650 0.650 0.650 0.650 0.650 0.650 0.650 0.650 0.700 0.750 0.850];


%--------------------------Generic Soil Period----------------------------%
period_soil = [0.0 0.075 0.10 0.20 0.30 0.40 0.50 0.75 1.00 1.50 2.00 3.00 4.00];

%-------------------------Generic Soil Coefficients-----------------------%
gsc1  = [-0.6687 1.7313 1.8473 0.8803 0.1243 -0.5247 -1.1067 -2.3727 -3.5387 -5.7697 -7.1017 -7.3407 -8.2867];
gsc2  = [1.438 1.438 1.438 1.438 1.438 1.438 1.438 1.438 1.438 1.438 1.438 1.438 1.438];
gsc3  = [0.0000 -0.0019 -0.0019 -0.0019 -0.0020 -0.0020 -0.0035 -0.0048 -0.0066 -0.0114 -0.0164 -0.0221 -0.0235];
gsc4  = [-2.329 -2.697 -2.697 -2.464 -2.327 -2.230 -2.140 -1.952 -1.785 -1.470 -1.290 -1.347 -1.272];
gsc5  = [0.00648 0.00648 0.00648 0.00648 0.00648 0.00648 0.00648 0.00648 0.00648 0.00648 0.00648 0.00648 0.00648];
gsc6  = [0.3648 0.3648 0.3648 0.3648 0.3648 0.3648 0.3648 0.3648 0.3648 0.3648 0.3648 0.3648 0.3648];
gsc7  = [1.0970 1.0970 1.0970 1.0970 1.0970 1.0970 1.0970 1.0970 1.0970 1.0970 1.0970 1.0970 1.0970];
gsc8  = [0.617 0.617 0.617 0.617 0.617 0.617 0.617 0.617 0.617 0.617 0.617 0.617 0.617];
gsc9  = [1.45 1.45 1.45 1.45 1.45 1.45 1.45 1.45 1.45 1.50 1.55 1.65 1.65];
gsc10 = [-0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1 -0.1];
gsc11 = [0.650 0.650 0.650 0.650 0.650 0.650 0.650 0.650 0.650 0.700 0.750 0.850 0.850];


% Computation of Parameters
% For Sa Computation in Generic Soil
if Zr == 0
    
    if length(find(period_soil == T)) == 0
        
        i_low = sum(period_soil < T);
        T_low = period_soil(i_low);
        T_high = period_soil(i_low + 1);
        
        [Sa_high, sigma_high] = Youngs_1997_SZ(M, T_high, r, H, Zt, Zr);
        [Sa_low, sigma_low] = Youngs_1997_SZ(M, T_low, r, H, Zt, Zr);
        
        x = [T_low T_high];
        Y_Sa = [Sa_low Sa_high];
        Y_sigma = [sigma_low sigma_high];
        Sa = interp1(x,Y_Sa,T);
        sigma = interp1(x,Y_sigma,T);
        
    else
        i = find(period_soil == T);
        
        ln_Y = gsc1(i) + gsc2(i)*M + gsc3(i)*(10-M)^3 + gsc4(i)*(log((r)+...
            gsc7(i)*exp(gsc8(i)*M))) + gsc5(i)*H + gsc6(i)*Zt;
        
        sigma = max((gsc9(i) + gsc10(i)*M), gsc11(i));
        
        Sa = exp(ln_Y);
        
    end
    
end

% For Sa Computation in Generic Rock
if Zr == 1
    
    if length(find(period_rock == T)) == 0
        
        i_low = sum(period_rock < T);
        T_low = period_rock(i_low);
        T_high = period_rock(i_low + 1);
        
        [Sa_high, sigma_high] = Youngs_1997_SZ(M, T_high, r, H, Zt, Zr);
        [Sa_low, sigma_low] = Youngs_1997_SZ(M, T_low, r, H, Zt, Zr);
        
        x = [T_low T_high];
        Y_Sa = [Sa_low Sa_high];
        Y_sigma = [sigma_low sigma_high];
        Sa = interp1(x,Y_Sa,T);
        sigma = interp1(x,Y_sigma,T);
        
    else
        i = find(period_rock == T);
        
        ln_Y = grc1(i) + grc2(i)*M + grc3(i)*(10-M)^3 + grc4(i)*(log((r)+...
            grc7(i)*exp(grc8(i)*M))) + grc5(i)*H + grc6(i)*Zt;
        
        sigma = max((grc9(i) + grc10(i)*M), grc11(i));
        
        Sa = exp(ln_Y);
        
    end
end

