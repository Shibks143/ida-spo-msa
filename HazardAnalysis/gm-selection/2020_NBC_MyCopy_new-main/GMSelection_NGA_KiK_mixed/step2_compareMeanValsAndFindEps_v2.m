
function [epsilon_bar] = step2_compareMeanValsAndFindEps_v2(GMSelectionInputs)

M_bar = GMSelectionInputs.M_bar; 
Rjb_bar = GMSelectionInputs.Rjb_bar;
IM_PSHA = GMSelectionInputs.IM_PSHA; 
T1 = GMSelectionInputs.T1;
Vs30 = GMSelectionInputs.Vs30; 
faultType = GMSelectionInputs.faultType;
GMPM = GMSelectionInputs.GMPM; 
gmmDir = GMSelectionInputs.gmmDir;
tectonic = GMSelectionInputs.tectonic;

baseFolder = pwd;
cd(gmmDir); % navigate to GMM directory

% M_bar = 6.36; % 2475 years deaggregation PGA
% Rjb_bar = 22.5;
% 
% % this is the value of intensity measure from PSHA corresponding to the same 
% % Return period for which M_bar and R_bar are mentioned above (2475 years in the present case)
% IM_PSHA = 0.042643;
% period = 2.56;
% 
% vs30 = 760; % rock site 
% 
% faultType = 'Strike-slip';
% 
% GMPM = 'BA08';

fprintf('GMPM \t TimeP \t PSHA_mean IM (g)\n');
fprintf('Actual \t %.3f \t\t %.3f \n', T1, IM_PSHA);
fprintf('----------------------------\n');
fprintf('GMPM \t TimeP \t pred_mean (g) \tsigma_Ln \t epsilon_bar \n');


%% BJF 97
try % Not each GMPMs is defined for all Spectral time periods.
% [sa, sigma] = BJF_1997_horiz(M, R, T, Fault_Type, Vs, arb);
% Fault_Type    = 1 for strike-slip fault 
%               = 2 for reverse-slip fault
%               = 0 for non-specified mechanism
    if(strcmp(faultType, 'Strike-slip'))
        Fault_Type = 1;
    elseif(strcmp(faultType, 'Thrust'))
        Fault_Type = 2;
    else
        Fault_Type = 0;
    end

[sa_BJF97, sigma_BJF97] = BJF_1997_horiz(M_bar, Rjb_bar, T1, Fault_Type, Vs30, 0);
eps_BJF97 = (log(IM_PSHA) - log(sa_BJF97)) / sigma_BJF97;

fprintf('BJF97 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_BJF97, sigma_BJF97, eps_BJF97);
catch
    
end

%% AS 97
try % Not each GMPMs is defined for all Spectral time periods.
% [sa, sigma] = AS_1997_horiz(M, r_rup, T, is_soil, fault_type, HW, arb);
%   R               = closest distance to fault rupture
%   is_soil         = 1 for soil prediction
%                   = 0 for rock
%   fault_type      = 1 for Reverse
%                   = 0.5 for reverse/oblique
%                   = 0 otherwise
%   HW              = 1 for Hanging Wall sites
%                   = 0 otherwise
        if (Vs30 >= 760)
            is_soil = 0;
        else
            is_soil = 1;
        end
        
        if(strcmp(faultType, 'Thrust'))
            Fault_Type = 1;
        elseif(strcmp(faultType, 'reverse/oblique'))
            Fault_Type = 0.5;
        else
            Fault_Type = 0;
        end    
        
        HW = 0;

[sa_AS97, sigma_AS97] = AS_1997_horiz(M_bar, Rjb_bar, T1, is_soil, Fault_Type, HW, 0);
eps_AS97 = (log(IM_PSHA) - log(sa_AS97)) / sigma_AS97;

fprintf('AS97 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_AS97, sigma_AS97, eps_AS97);
catch
    
end


%% BA08
try % Not each GMPMs is defined for all Spectral time periods.
% [sa, sigma] = BA_2008_nga (M, T, Rjb, Fault_Type, vs30)
% Rjb = Joyner-Boore distance (km)
% Fault_Type    = 1 for unspecified fault 
%               = 2 for strike-slip fault
%               = 3 for normal fault
%               = 4 for reverse fault

    if(strcmp(faultType, 'Strike-slip'))
        Fault_Type = 2;
    elseif(strcmp(faultType, 'Normal'))
        Fault_Type = 3;
    elseif(strcmp(faultType, 'Reverse') || strcmp(faultType, 'Thrust'))
        Fault_Type = 4;
    else
        Fault_Type = 1;
    end

[sa_BA08, sigma_BA08] = BA_2008_nga(M_bar, T1, Rjb_bar, Fault_Type, Vs30);
eps_BA08 = (log(IM_PSHA) - log(sa_BA08)) / sigma_BA08;

fprintf('BA08 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_BA08, sigma_BA08, eps_BA08);
catch
    
end


%% C97
try % Not each GMPMs is defined for all Spectral time periods.
% [sa, sigma] = C_1997_horiz(M, R, T, Fault_Type, Soil, D, arb)
%   R               = closest distance to fault rupture
%   T               = period of vibration
%   Fault_Type      = 0 for strike-slip fault
%                   = 1 for reverse, thrust, reverse-oblique, and thrust-oblique fault 
%   Soil            = 0 for soil
%                   = 1 for soft rock
%                   = 2 for hard rock
%   D               = depth to basement bedrock (km)

    if(strcmp(faultType, 'Strike-slip'))
        Fault_Type = 0;
    else %if(strcmp(faultType, 'Reverse') || strcmp(faultType, 'Thrust'))
        Fault_Type = 1;
    end

    if (Vs30 >= 365) && (Vs30 <= 760)
        is_soil = 1;
    elseif Vs30 >= 760
        is_soil = 2;
    else
        is_soil = 0;
    end
    
    
[sa_C97, sigma_C97] = C_1997_horiz(M_bar, Rjb_bar, T1, Fault_Type, is_soil, 50, 0);
% [sa_BA08, sigma_BA08] = BA_2008_nga(M_bar, timeP, Rjb_bar, Fault_Type, vs30);
eps_C97 = (log(IM_PSHA) - log(sa_C97)) / sigma_C97;

fprintf('C97 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_C97, sigma_C97, eps_C97);
catch
    
end

%% ASB96
try % Not each GMPMs is defined for all Spectral time periods.
% [sa, sigma] = ASB_1996_horiz(M, R, T, Soil, arb)
%   R               = closest distance to fault rupture
%   Soil            = 0 for other kinds of soil
%                   = 1 for soft soil (vs30 between 400 and 800 m/s)
%                   = 2 for stiff soil (vs30 > 800 m/s)

    if (Vs30 >= 400) && (Vs30 <= 800)
        is_soil = 1;
    elseif Vs30 >= 800
        is_soil = 2;
    else
        is_soil = 0;
    end
    
[sa_ASB96, sigma_ASB96] = ASB_1996_horiz(M_bar, Rjb_bar, T1, is_soil, 0);
eps_ASB96 = (log(IM_PSHA) - log(sa_ASB96)) / sigma_ASB96;

fprintf('ASB96 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_ASB96, sigma_ASB96, eps_ASB96);
catch
    
end

%% BSSA14
try % Not each GMPMs is defined for all Spectral time periods.
% [median, sigma, period1] = BSSA_2014_nga(M, T, Rjb, Fault_Type, region, z1, vs30)
%   z1              = Basin depth (km); depth from the groundsurface to the
%                   1km/s shear-wave horizon.
%                   = 999 if unknown
% region        = 0 for global (incl. Taiwan)
%               = 1 for California
%               = 2 for Japan
%               = 3 for China or Turkey
%               = 4 for Italy
    if(strcmp(faultType, 'Strike-slip'))
        Fault_Type = 1;
    elseif(strcmp(faultType, 'Normal'))
        Fault_Type = 2;
    elseif(strcmp(faultType, 'Reverse'))
        Fault_Type = 3;
    else
        Fault_Type = 0;
    end
        
[sa_BSSA14, sigma_BSSA14, ~] = BSSA_2014_nga(M_bar, T1, Rjb_bar, Fault_Type, 0, 999, Vs30);
eps_BSSA14 = (log(IM_PSHA) - log(sa_BSSA14)) / sigma_BSSA14;

fprintf('BSSA14 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_BSSA14, sigma_BSSA14, eps_BSSA14);
catch
    
end

%% CB14
try % Not each GMPMs is defined for all Spectral time periods.
% [Sa, sigma, period1] = CB_2014_nga(M, T, Rrup, Rjb, Rx, W, Ztor, Zbot, delta, lambda, Fhw, vs30, Z25, Zhyp, region)
%   z1              = Basin depth (km); depth from the groundsurface to the
%                   1km/s shear-wave horizon.
%                   = 999 if unknown
% region        = 0 for global (incl. Taiwan)
%               = 1 for California
%               = 2 for Japan
%               = 3 for China or Turkey
%               = 4 for Italy
W             = 999; % down-dip width of the fault rupture plane if unknown, input: 999
Ztor          = 999; % Depth to the top of coseismic rupture (km) if unknown, input: 999
Zbot          = 50; % Depth to the bottom of the seismogenic crust needed only when W is unknow;
delta         = 45; % average dip of the rupture place (degree)
lambda        = 45 ; % rake angle (degree) - average angle of slip measured in the plance of rupture
Fhw           = 0; % hanging wall effect; = 1 for including; = 0 for excluding
Z25           = 999; % Depth to the 2.5 km/s shear-wave velocity horizon (km); if in California or Japan and Z2.5 is unknow, then input: 999
Zhyp          = 999; % Hypocentral depth of the earthquake measured from sea level; if unknown, input: 999

[sa_CB14, sigma_CB14, ~] = CB_2014_nga(M_bar, T1, Rjb_bar, Rjb_bar, Rjb_bar, W, Ztor, Zbot, delta, lambda, Fhw, Vs30, Z25, Zhyp, 0);
eps_CB14 = (log(IM_PSHA) - log(sa_CB14)) / sigma_CB14;

fprintf('CB14 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_CB14, sigma_CB14, eps_CB14);
catch
    
end

%% BYHydro16_Sub
try % Not each GMPMs is defined for all Spectral time periods.
% [sa_int, sigma] = bc_hydro_2016_subduction(T, M, R, F_faba, vs30, F_event, Zh)

% F_faba  = 0 for forearc or unknown sites
%         = 1 for backarc sites
% vs30    = Average shear wave velocity over the top 30 m of the soil
%           profile
% F_event = 0 for interface events
%         = 1 for intraslab events
% Zh      = Hypocentral depth (km) (required only for intraslab events)

[sa_BCHydro16_Sub, sigma_BCHydro16_Sub] = bc_hydro_2016_subduction(T1, M_bar, Rjb_bar, 0, Vs30, 0, 0);
eps_BCHydro16_Sub = (log(IM_PSHA) - log(sa_BCHydro16_Sub)) / sigma_BCHydro16_Sub;

fprintf('BCH16 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_BCHydro16_Sub, sigma_BCHydro16_Sub, eps_BCHydro16_Sub);
catch
    
end

 %% AB03_Sub
try % Not each GMPMs is defined for all Spectral time periods.
% [Sa sigma] = AB_2003_SZ(T,M,h,Df,Zt,vs30,Zl)
% 
% h  = Focal (Hypocentral) Depth (km)
% Df = closest distance to the fault surface (km)
% Zt = Subduction Type Indicator: Zt = 0 for interface events
%                                 Zt = 1 for intraslab (in-slab) events
% vs30 = Shear Wave Velocity averaged over the top 30 meters of soil of the
%      soil profile (m/sec)
% Zl = Cascadia or Japan indicator: Zl = 0 for General Cases
%                                   Zl = 1 for Cascadia
%                                   Zl = 2 for Japan
    if strcmp(tectonic, 'In-slab') 
        Zt = 1; 
    else%if strcmp(tectonic, ' Interface/Subduction') || strcmp(tectonic, ' Interface')
        Zt  = 0; 
    end
        Zl = 1; % cascadia
    [sa_AB03_Sub, sigma_AB03_Sub] = AB_2003_SZ(T1, M_bar, Rjb_bar, Rjb_bar, Zt, Vs30, Zl);
    eps_AB03_Sub = (log(IM_PSHA) - log(sa_AB03_Sub)) / sigma_AB03_Sub;
    
    fprintf('AB03SZ \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_AB03_Sub, sigma_AB03_Sub, eps_AB03_Sub);
catch
    fprintf('T1 is probably more than the maximum period for GMM, ABS03. Extrapolating ... \n');
    fprintf('Using the recommendations by Kolaj et al. (2019) GMM for 6th NHM. \n');

    % (1/3) calculate for 3.0 sec, T_max for ABS03_SZ
    [sa_AB03_Sub_Tmax, sigma_AB03_Sub_Tmax] = AB_2003_SZ(3.0, M_bar, Rjb_bar, Rjb_bar, Zt, Vs30, Zl); 

    % (2/3) find the corresponding ratio from Aea15 (Abrahamson et al., 2016, aka BCH16)
    [sa_BCHydro16_Sub_3s, ~] = bc_hydro_2016_subduction(3, M_bar, Rjb_bar, 0, Vs30, 0, 0);
    [sa_BCHydro16_Sub_T1, ~] = bc_hydro_2016_subduction(T1, M_bar, Rjb_bar, 0, Vs30, 0, 0);
    
    % (3/3) assign the extrapolated values
    ratioSaT1_to_SaTmax = sa_BCHydro16_Sub_T1/sa_BCHydro16_Sub_3s;
    sa_AB03_Sub = ratioSaT1_to_SaTmax * sa_AB03_Sub_Tmax;
    sigma_AB03_Sub = sigma_AB03_Sub_Tmax;
    
    eps_AB03_Sub = (log(IM_PSHA) - log(sa_AB03_Sub)) / sigma_AB03_Sub;

end

%% Zhao06
try % Not each GMPMs is defined for all Spectral time periods.
% [Sa sigma] = Zhao_2006(T,M,x,h,Vs30,FR,SI,SS,MS)

% T  = Period (sec)
% M  = Moment Magnitude
% x  = Source to Site distance (km); Defines as the shortest distance from
%      the site to the rupture zone. NOTE: 'x' must be a positive,
%      non-negative value.
% h  = Focal (Hypocentral) Depth (km)
% Vs30  = Average Shear Velocity in the first 30 meters of the soil profile
%     (m/sec)
% FR = Reverse-Fault Parameter: FR = 1, For Crustal Earthquakes ONLY IF a
%                                       Reverse-Fault Exists
%                               FR = 0, Otherwise
% SI = Source-Type Indicator: SI = 1, For Interface Events
%                             SI = 0, Otherwise
% SS = Source-Type Indicator: SS = 1, For Subduction Slab Events
%                             SS = 0, Otherwise
% MS = Magnitude-Squared Term: MS = 1, Includes the Magnitude-squared term
%                              MS = 0, Does not include magnitude-squared
%                                      term

    if strcmp(tectonic, 'Crustal')
        FR = 1; SI = 0; SS = 0;
    elseif strcmp(tectonic, ' Interface/Subduction')
        FR = 0; SI = 1; SS = 0;
    else 
        FR = 0; SI = 0; SS = 0;
    end
    
    [sa_Zhao06, sigma_Zhao06] = Zhao_2006(T1,M_bar,Rjb_bar,Rjb_bar,Vs30,FR,SI,SS,1);
    eps_Zhao06 = (log(IM_PSHA) - log(sa_Zhao06)) / sigma_Zhao06;
    
    fprintf('Zhao06\t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_Zhao06, sigma_Zhao06, eps_Zhao06);
catch
    
end
%% ASK14 added by shivakumar ks, on 29-Aug-2026
try % Not each GMPMs is defined for all Spectral time periods.
    % Map fault mechanism parameters: Dip angle (delta) and Rake angle (lambda)
    if strcmp(faultType, 'Strike-slip')
        delta = 90;
        lambda = 0;
    elseif strcmp(faultType, 'Normal')
        delta = 50;
        lambda = -90;
    elseif strcmp(faultType, 'Reverse') || strcmp(faultType, 'Thrust')
        delta = 45;
        lambda = 90;
    else
        delta = 45;  % Default dip angle (degrees)
        lambda = 0;  % Default rake angle (degrees)
    end

    % Define distance, fault, and site parameters
    Rrup   = Rjb_bar; % Rupture distance (approx. Rjb when unknown)
    Rx     = 0;       % Horizontal distance perpendicular to fault strike
    Ry0    = 999;     % Horizontal distance parallel to strike off rupture end (999 = unknown)
    Ztor   = 999;     % Depth to top of rupture plane in km (999 = unknown)
    W      = 999;     % Down-dip rupture width in km (999 = unknown)
    Z10    = 999;     % Depth to Vs = 1.0 km/s horizon in km (999 = default empirical relation)
    fas    = 0;       % Event flag: 0 = Mainshock, 1 = Aftershock
    HW     = 0;       % Hanging-wall flag: 0 = Exclude, 1 = Include
    % Vs30          = shear wave velocity averaged over top 30 m in m/s
    % FVS30         = 1 for measured Vs30
    %               = 0 for Vs30 inferred from geology
    FVS30  = 1;       % 1 = Specified/measured Vs30
    region = 0;       % Tectonic region: 0 = Global (including Taiwan/Turkey)

    % Signature: (M, T, Rrup, Rjb, Rx, Ry0, Ztor, delta, lambda, fas, HW, W, Z10, Vs30, FVS30, region)
    [sa_ASK14, sigma_ASK14, ~] = ASK_2014_nga(M_bar, T1, Rrup, Rjb_bar, Rx, Ry0, Ztor, delta, lambda, fas, HW, W, Z10, Vs30, FVS30, region);
    eps_ASK14 = (log(IM_PSHA) - log(sa_ASK14)) / sigma_ASK14;

    fprintf('ASK14 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_ASK14, sigma_ASK14, eps_ASK14);

catch
    fprintf('T1 is outside the ASK14 valid range (0.01-10 sec). Cannot compute directly.\n');
end

%% CY14 added by shivakumar ks, on 29-Aug-2026
try % Not each GMPMs is defined for all Spectral time periods.
    % Map fault mechanism parameters: Dip angle (delta) and Rake angle (lambda)
    if strcmp(faultType, 'Strike-slip')
        delta = 90;
        lambda = 0;
    elseif strcmp(faultType, 'Normal')
        delta = 50;
        lambda = -90;
    elseif strcmp(faultType, 'Reverse') || strcmp(faultType, 'Thrust')
        delta = 45;
        lambda = 90;
    else
        delta = 45;  % Default dip angle (degrees)
        lambda = 0;  % Default rake angle (degrees)
    end

    % Define distance, fault, and site parameters
    Rup    = Rjb_bar;  % Rupture distance (approx. Rjb when unknown)
    Rx     = 0;        % Horizontal distance perpendicular to fault strike (km)
    Ztor   = 999;      % Depth to top of rupture plane in km (999 = default empirical relation)
    Z10    = 999;      % Depth to Vs = 1.0 km/s horizon in km (999 = default empirical relation)
    Fhw    = 0;        % Hanging-wall flag: 0 = Exclude, 1 = Include
    % FVS30            = 1 for measured Vs30
    %                  = 0 for Vs30 inferred from geology
    FVS30  = 1;        % 1 = Specified/measured Vs30
    region = 0;        % Tectonic region: 0 = Global 

    % Signature: (M, T, Rup, Rjb, Rx, Ztor, delta, lambda, Z10, Vs30, Fhw, FVS30, region)

    [sa_CY14, sigma_CY14, ~] = CY_2014_nga(M_bar, T1, Rup, Rjb_bar, Rx, Ztor, delta, lambda, Z10, Vs30, Fhw, FVS30, region);
    eps_CY14 = (log(IM_PSHA)- log(sa_CY14)) / sigma_CY14;

     fprintf('CY14 \t %.3f \t\t %.3f \t\t %.3f \t\t\t %.3f \n', T1, sa_CY14, sigma_CY14, eps_CY14);

catch
    fprintf('T1 is outside the CY14 valid range. Cannot compute directly.\n');
end



%% Select epsilon corresponding to the chosen GMM 
% Each GMM-specific block above computes its own epsilon value.
% This switch statement extracts the epsilon associated with the
% user-selected Ground Motion Prediction Model (GMPM) and assigns
% it to the output variable epsilon_bar.

switch GMPM
    case 'BJF97'
        epsilon_bar = eps_BJF97;
    case 'AS97'
        epsilon_bar = eps_AS97;
    case 'BA08'
        epsilon_bar = eps_BA08;
    case 'C97'
        epsilon_bar = eps_C97;
    case 'ABS96'
        epsilon_bar = eps_ASB96;
    case 'BSSA14'
        epsilon_bar = eps_BSSA14;
    case 'CB14'
        epsilon_bar = eps_CB14;
    case 'BCH16'
        epsilon_bar = eps_BCHydro16_Sub;
    case 'AB03_Sub'
        epsilon_bar = eps_AB03_Sub;
    case 'Zhao06'
        epsilon_bar = eps_Zhao06;
    case 'ASK14'
        epsilon_bar = eps_ASK14;
    case 'CY14'
        epsilon_bar = eps_CY14;
end

fprintf('----------------------------\n');
fprintf('GMPM \t TimeP \t PSHA_mean IM (g)\t eps_bar\n');
fprintf('%s \t %.3f \t\t %.3f \t\t\t %.3f \n', GMPM, T1, IM_PSHA, epsilon_bar);

cd(baseFolder) % back home