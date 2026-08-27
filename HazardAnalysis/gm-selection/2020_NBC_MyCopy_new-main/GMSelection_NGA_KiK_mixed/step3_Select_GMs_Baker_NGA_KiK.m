%% function definition after BootCamp
function selectedRecords = step3_Select_GMs_Baker_NGA_KiK(GMSelectionInputs)

% assign fields to local variables for easy calls
    tectonic = GMSelectionInputs.tectonic;
    nGM = GMSelectionInputs.nGM;	T1 = GMSelectionInputs.T1;
    numPtsInT1 = GMSelectionInputs.numPtsInT1;	isScaled = GMSelectionInputs.isScaled;
    maxScale = GMSelectionInputs.maxScale;	weights = GMSelectionInputs.weights;
    nLoop = GMSelectionInputs.nLoop;	penalty = GMSelectionInputs.penalty;
    notAllowedFilters = GMSelectionInputs.notAllowedFilters;	checkCorr = GMSelectionInputs.checkCorr;
    seedValue = GMSelectionInputs.seedValue;	outputFile = GMSelectionInputs.outputFile;
    dirNameForSaving = GMSelectionInputs.folderNameForSaving;	   
    M_bar = GMSelectionInputs.M_bar;	Rjb_bar = GMSelectionInputs.Rjb_bar;
    eps_bar = GMSelectionInputs.eps_bar;	Vs30 = GMSelectionInputs.Vs30;
    arb = GMSelectionInputs.arb;	showPlots = GMSelectionInputs.showPlots;
    useVar = GMSelectionInputs.useVar;	faultType = GMSelectionInputs.faultType;
    GMPM = GMSelectionInputs.GMPM;	gmmDir = GMSelectionInputs.gmmDir;
    T_range = GMSelectionInputs.T_range;	databaseToUse = GMSelectionInputs.databaseToUse;
    forbiddenRecs_NGA = GMSelectionInputs.NGA_W2.forbiddenRecs;
    forbiddenRecs_KiK = GMSelectionInputs.KiK_NET.forbiddenRecs;

baseFolder = pwd;
%% Sample user inputs begins here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nGM        = 22; % T1         = 2.12; % numPtsInT1   = 20; % isScaled   = 1;
% maxScale   = 5; % weights    = [1.0 2.0];
% nLoop      = 1; % changed it to 1 for 250 GM selection (otherwise the runtime is over 5 hours).
%                 % 1 is good enough, if greedy algorithm is applied. There are a very good matches of median and correl
% penalty    = 0; % notAllowed = []; % checkCorr  = 0; % change it to 1, if correlation plots are required
% seedValue  = 1; 
% M_bar     = 6.36; % R_bar     = 22.5; % eps_bar   = 1.03;
% Vs30      = 760; % arb       = 0; % showPlots = 1; % useVar    = 1; % faultType = 'Reverse'; % GMPM = 'BA08';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample user inputs ends here

%%
% PerTgt = logspace(log10(0.2*T1), log10(2*T1), 20);
% PerTgt = logspace(log10(0.2*T1), log10(2*T1), numPtsInT1);
PerTgt = logspace(log10(T_range(1)), log10(T_range(2)), numPtsInT1);

Rrup_bar   = Rjb_bar; % Can be modified by the user
% Rjb_bar    = R_bar; % Can be modified by the user (renamed the variable, since the updated NGA database has Rjb as the variable)

% record filtering criteria
magLimit = notAllowedFilters.magLimit; R_min = notAllowedFilters.R_min; 
Vs30Min = notAllowedFilters.Vs30Min; Vs30Max = notAllowedFilters.Vs30Max; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This code is used to select conditional (structure- and site-
% specific) ground motions. The target means and covariances are
% obtained corresponding to a pre-defined target scenario earthquake, and
% are obtained based on the CMS method
%
% Nirmal Jayaram, Ting Lin, Jack W. Baker
% Department of Civil and Environmental Engineering
% Stanford University
% Last Updated: 27 March 2010
%
% Referenced manuscripts:
%
% N. Jayaram, T. Lin and and Baker, J. W. (2010). A computationally
% efficient ground-motion selection algorithm for matching a target
% response spectrum mean and variance, Earthquake Spectra, (in press).
%
% N. Jayaram and Baker, J. W. (2010). Ground-motion selection for PEER
% Transportation Systems Research Program, 7th CUEE and 5th ICEE Joint
% Conference, Tokyo, Japan.
%
% J. W. Baker and Jayaram, N. (2008). Correlation of spectral acceleration
% values from NGA ground motion models, Earthquake Spectra, 24 (1), 299-317
%
% Baker, J.W. (2010). The Conditional Mean Spectrum: A tool for ground
% motion selection, ASCE Journal of Structural Engineering, (in press).
%
%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% OUTPUT VARIABLES
% finalRecords      : Record numbers of selected records
% finalScaleFactors : Scale factors
%
% The final cell in this m file shows how to plot the selected spectra
% using this information.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load workspace containing ground-motion information. Here, the NGA
% database is used. Documentation of the NGA database workspace
% 'rec_selection_meta_data.mat' can be found at 'WorkspaceDocumentation.m'.
% For an alternate database, the minimum information to be provided
% includes the pseudo-acceleration spectra of the available, ground
% motions, periods at which the spectra are defined, and other information
% required to compute means and variances using ground-motion models.
% This cell can be modified by the user if desired.
%
% Variable definitions
% saKnown   : (N*P matrix)
%             This is a matrix of Sa values at different periods (P) for
%             available ground-motion time histories (N).
% perKnown  : The set of P periods.
% nGM       : Number of ground motions to be selected
% T1        : Period at which spectra should be scaled and matched.
%             Usually, the structure's fundamental period.
% isScaled  : Should spectra be scaled before matching (1 -YES, 0-NO).
% maxScale  : Maximum allowable scale factor.
% weights   : [Weight for error in mean, Weight for error in standard
%             deviation] e.g., [1.0,1.0] - equal weight for both errors.
% nLoop     : This is a meta-variable of the algorithm. The greedy
%             improvement technique does several passes over the available
%             data set and tries to improve the selected records. This
%             variable denotes the number of passes. Recommended value: 2.
% penalty   : If a penalty needs to be applied to avoid selecting spectra
%             that have spectral acceleration values beyond 3 sigma at any
%             of the periods, set a value here. Use 0 otherwise.
% notAllowed: List of record numbers that should not be considered for
%             selection. Use [] to consider all available records. This can
%             be used to prevent certain magnitude-distance-Vs30 records
%             from being selected, if desired. (see example below)
% checkCorr : If 1, this runs a code that compares the correlation
%             structure of the selected ground motions to the correlations
%             published by Baker and Jayaram (2008).
% seedValue : For repeatability. For a particular seedValue not equal to
%             zero, the code will output the same set of ground motions.
%             The set will change when the seedValue changes. If set to
%             zero, the code randomizes the algorithm and different sets of
%             ground motions (satisfying the target mean and variance) are
%             generated each time.
% outputFile: File name of the output file
%
% If a database other than the NGA database is used, also define the
% following variables:
%
% magnitude        : Magnitude of all the records
% distance_closest : Closest distance for all the records
% soil_Vs30        : Soil Vs30 values corresponding to all the records
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User inputs begin here
switch databaseToUse
    case 'NGA_W2'
        % always load as a structure to not mix up existing variables in this function
        NGA_data = load('..\Database\NGA_W2_meta_data'); % Load NGA-W2 database
        rec_ID_invalid = load('..\Database\NotExist_NGA_West2_RSN.txt'); % Load the invalid RSNs for non-downloadable records in NGA-West2 database
        rec_ID_invalid = [rec_ID_invalid; forbiddenRecs_NGA]; % update with records selected for previous tectonic, if any.

        NGA_data_valid = NGA_data;
        % remove invalid rows in all variables except for Periods, getTimeSeries, and readme
        % RSN is stored as NGA_data_valid.NGA_num
        NGA_data_valid.NGA_num(rec_ID_invalid, :) = []; 
        
        NGA_data_valid.Sa_1(rec_ID_invalid, :) = [];  NGA_data_valid.Sa_2(rec_ID_invalid, :) = [];  
        NGA_data_valid.soil_Vs30(rec_ID_invalid, :) = []; 
        NGA_data_valid.magnitude(rec_ID_invalid, :) = [];  NGA_data_valid.Rjb(rec_ID_invalid, :) = []; 
        NGA_data_valid.closest_D(rec_ID_invalid, :) = []; 

%         NGA_data_valid.EQID(rec_ID_invalid, :) = []; NGA_data_valid.EQ_name(rec_ID_invalid, :) = []; NGA_data_valid.EQ_year(rec_ID_invalid, :) = []; NGA_data_valid.Filename_1(rec_ID_invalid, :) = [];
%         NGA_data_valid.Filename_2(rec_ID_invalid, :) = []; NGA_data_valid.Filename_FN(rec_ID_invalid, :) = []; NGA_data_valid.Filename_FP(rec_ID_invalid, :) = [];
%         NGA_data_valid.Filename_vert(rec_ID_invalid, :) = []; NGA_data_valid.NGA_num(rec_ID_invalid, :) = []; NGA_data_valid.Rjb(rec_ID_invalid, :) = []; NGA_data_valid.Sa_1(rec_ID_invalid, :) = [];
%         NGA_data_valid.Sa_2(rec_ID_invalid, :) = []; NGA_data_valid.Sa_RotD100(rec_ID_invalid, :) = []; NGA_data_valid.Sa_RotD50(rec_ID_invalid, :) = []; NGA_data_valid.Sa_vert(rec_ID_invalid, :) = [];
%         NGA_data_valid.Tp_FN(rec_ID_invalid, :) = []; NGA_data_valid.Tp_FP(rec_ID_invalid, :) = []; NGA_data_valid.closest_D(rec_ID_invalid, :) = []; NGA_data_valid.combined_D(rec_ID_invalid, :) = [];
%         NGA_data_valid.dirLocation(rec_ID_invalid, :) = []; NGA_data_valid.eqid(rec_ID_invalid, :) = []; NGA_data_valid.fw_hw_indicator(rec_ID_invalid, :) = [];
%         NGA_data_valid.hypo_lat(rec_ID_invalid, :) = []; NGA_data_valid.hypo_long(rec_ID_invalid, :) = []; NGA_data_valid.is_pulse_FN(rec_ID_invalid, :) = [];
%         NGA_data_valid.is_pulse_FP(rec_ID_invalid, :) = []; NGA_data_valid.lowest_usable_freq(rec_ID_invalid, :) = []; NGA_data_valid.magnitude(rec_ID_invalid, :) = [];
%         NGA_data_valid.mechanism(rec_ID_invalid, :) = []; NGA_data_valid.soil_GMX_1(rec_ID_invalid, :) = []; NGA_data_valid.soil_GMX_2(rec_ID_invalid, :) = [];
%         NGA_data_valid.soil_GMX_3(rec_ID_invalid, :) = []; NGA_data_valid.soil_NEHRP(rec_ID_invalid, :) = []; NGA_data_valid.soil_Vs30(rec_ID_invalid, :) = [];
%         NGA_data_valid.station_lat(rec_ID_invalid, :) = []; NGA_data_valid.station_long(rec_ID_invalid, :) = []; NGA_data_valid.station_name(rec_ID_invalid, :) = [];
%         NGA_data_valid.station_seq_num(rec_ID_invalid, :) = [];
    
    % assign database variables to local variables
        NGA_num = NGA_data_valid.NGA_num;

        Periods = NGA_data_valid.Periods;
        Sa_1 = NGA_data_valid.Sa_1; Sa_2 = NGA_data_valid.Sa_2;
        soil_Vs30 = NGA_data_valid.soil_Vs30;
        mag = NGA_data_valid.magnitude; Rjb = NGA_data_valid.Rjb; closest_D = NGA_data_valid.closest_D;
    % mechanism in NGA_W2 is 0 for Strike Slip, 1 for Normal, 2 for Reverse, 3 for Reverse Oblique, 4 for Normal Oblique, and -999 for unknown

    case 'KiK_NET'
    % always load as a structure to not mix up existing variables in this function
        KiK_data = load('..\Database\KiK_NET_meta_data_surface'); % Load KiK-NET database for surface seismographs
    
    % remove forbidden records
        KiK_data_toUse = KiK_data; % create a copy of useable KiK records after removing forbidden records
        if ~isempty(forbiddenRecs_KiK)
            [~, b] = ismember(forbiddenRecs_KiK, KiK_data.EQID);
            KiK_data_toUse.EQID(b, :) = []; KiK_data_toUse.X(b, :) = []; 
            KiK_data_toUse.Sa_NS2(b, :) = []; KiK_data_toUse.Sa_EW2(b, :) = []; 
            KiK_data_toUse.soil_Vs30(b, :) = []; KiK_data_toUse.magnitude(b, :) = []; 
            KiK_data_toUse.Rjb(b, :) = []; KiK_data_toUse.rrup_0(b, :) = []; 
        end
        
    % assign database variables to local variables
        Periods = KiK_data_toUse.Periods;
        EQID_KiK = KiK_data_toUse.EQID; X_KiK = KiK_data_toUse.X; 
        Sa_1 = KiK_data_toUse.Sa_NS2; Sa_2 = KiK_data_toUse.Sa_EW2;
        soil_Vs30 = KiK_data_toUse.soil_Vs30; mag = KiK_data_toUse.magnitude; 
        Rjb = KiK_data_toUse.Rjb; closest_D = KiK_data_toUse.rrup_0;

    % Tectonic regime: 1 for Interface, 2 for Shallow Crustal, 3 for Intraslab, 4 for Upper Mantle (no data), 5 for Outer Subduction, and -99 for unknown [Garcia et al. 2012]
    % Mechanism: 1 for Reverse Slip, 2 for Strike Slip, 3 for Normal, -99 for unknown [Garcia et al. 2012]
end

SaKnown    = sqrt(Sa_1.*Sa_2);
perKnown   = Periods;
% % nGM        = 12;
% % T1         = 2.12;
% % isScaled   = 1;
% % maxScale   = 5;
% % weights    = [1.0 2.0];
% % nLoop      = 1; % changed it to 1 for 250 GM selection (otherwise the runtime is over 5 hours).
% %                 % 1 is good enough, if greedy algorithm is applied. There are a very good matches of median and correl
% % penalty    = 0;
% % notAllowed = [];
% % checkCorr  = 0; % change it to 1, if correlation plots are required
% % seedValue  = 1;

% NOTE: MORE user input required in the next cell

% Limiting the records to be considered using the `notAllowed' variable

% Only hard rock
%recInvalid = find(soil_Vs30<Vs30_min | soil_Vs30>Vs30_max);
%notAllowed = [notAllowed; recInvalid];

% Limits on magnitude, distance
%recInvalid = find(magnitude<6 | distance_closest>50);
%notAllowed = [notAllowed; recInvalid];

% Using a different ground-motion database:

% MORE user input in the next cell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Determination of target mean and covariances

% The Campbell and Bozorgnia (2008) ground-motion model is used in this
% code. The input variables defined below are the inputs required for this
% model. The user can change the ground-motion model as long as any
% additional information that may be required by the new model is provided.

% Please refer to Baker (2010) for details on the conditional mean spectrum
% method which is used for obtaining the target means and covariances in
% this example. Alternately, the details are summarized in Jayaram et al.
% (2010).

% The code provides the user an option to not match the target variance.
% This is done by setting the target variance to zero so that each selected
% response spectrum matches the target mean response spectrum (useVar).

% Variable definitions

% M_bar     : Magnitude of the target scenario earthquake
% R_bar     : Distance corresponding to the target scenario earthquake
% eps_bar   : Epsilon value for the target scenario
% Vs30      : Average shear wave velocity in the top 30m of the soil, used
%             to model local site effects (m/s)
% Ztor      : Depth to the top of coseismic rupture (km)
% delta     : Average dip of the rupture place (degree)
% lambda    : Rake angle (degree)
% Zvs       : Depth to the 2.5 km/s shear-wave velocity horizon (km)
% arb       : 1 for arbitrary component sigma
%             0 for average component sigma
% PerTgt    : Periods at which the target spectrum needs to be computed
% showPlots : 1 to display plots, 0 otherwise
% useVar    : 0 to set target variance to zero, 1 to compute target
%             variance using ground-motion model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User inputs begin here

% % M_bar     = 6.36;
% % R_bar     = 22.5;
% % eps_bar   = 1.03;
% % Vs30      = 760;
% % % Ztor      = 0;
% % % delta     = 90;
% % % lambda    = 180;
% % % Zvs       = 2;
% % arb       = 0;
% % PerTgt    = logspace(log10(0.2*T1),log10(2*T1),20);
% % showPlots = 1;
% % useVar    = 1;
% % 
% % Rrup   = R_bar; % Can be modified by the user
% % Rjb    = R_bar; % Can be modified by the user
% % 
% % faultType = 'Reverse';
% % 
% % %     GMPE = 'CB_2008_nga';
% %     GMPE = 'BA_2008_nga';
        

% specific to Boore Atkinson 2008 GMPM
% [sa, sigma] = BA_2008_nga (M, T, Rjb, Fault_Type, Vs30)
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

% Modify perTgt to include T1
if ~any(PerTgt == T1)
    PerTgt = [PerTgt(PerTgt<T1) T1 PerTgt(PerTgt>T1)];
end

% Determine target spectra using ground-motion model (replace ground-motion model code if desired)
cd(gmmDir); % navigate to GMM directory

sa = zeros(1,length(PerTgt));
sigma = zeros(1,length(PerTgt));
for i = 1:length(PerTgt)
    if strcmp(GMPM, 'CB08')
        [sa(1,i), sigma(1,i)] = CB_2008_nga (M_bar, PerTgt(i), Rrup_bar, Rjb_bar, Ztor, delta, lambda, Vs30, Zvs, arb);
    elseif strcmp(GMPM, 'BA08')
        [sa(1,i), sigma(1,i)] = BA_2008_nga(M_bar, PerTgt(i), Rjb_bar, Fault_Type, Vs30);
    elseif strcmp(GMPM, 'BSSA14')
        [sa(1,i), sigma(1,i), ~] = BSSA_2014_nga(M_bar, PerTgt(i), Rjb_bar, Fault_Type, 0, 999, Vs30);
    elseif strcmp(GMPM, 'CB14')
        [sa(1,i), sigma(1,i), ~] = CB_2014_nga(M_bar, PerTgt(i), Rjb_bar, Rjb_bar, Rjb_bar, 999, 999, 50, 45, 45, 0, Vs30, 999, 999, 0);
    elseif strcmp(GMPM, 'BCH16')
        [sa(1,i), sigma(1,i)] = bc_hydro_2016_subduction(PerTgt(i), M_bar, Rjb_bar, 0, Vs30, 0, 0);
    elseif strcmp(GMPM, 'AB03_Sub')
        if strcmp(tectonic, 'In-slab');  Zt = 1;  else; Zt  = 0; end
        Zl = 1; % cascadia
        if PerTgt(i) <= 3
            [sa(1,i), sigma(1,i)] = AB_2003_SZ(PerTgt(i), M_bar, Rjb_bar, Rjb_bar, Zt, Vs30, Zl);
        else
            % fprintf('T1 is more than the maximum period for GMM, ABS03. Extrapolating using the recommendations by Kolaj et al. (2019) GMM for 6th NHM. \n');
            % (1/3) calculate for 3.0 sec, T_max for ABS03_SZ
            Tmax_GMM = 3;
            [sa_AB03_Sub_Tmax, sigma_AB03_Sub_Tmax] = AB_2003_SZ(Tmax_GMM, M_bar, Rjb_bar, Rjb_bar, Zt, Vs30, Zl);

            % (2/3) find the corresponding ratio from Aea15 (Abrahamson et al., 2016, aka BCH16)
            [sa_BCHydro16_Sub_Tmax, ~] = bc_hydro_2016_subduction(Tmax_GMM, M_bar, Rjb_bar, 0, Vs30, 0, 0);
            [sa_BCHydro16_Sub_TCur, ~] = bc_hydro_2016_subduction(PerTgt(i), M_bar, Rjb_bar, 0, Vs30, 0, 0);

            % (3/3) assign the extrapolated values
            ratioSaT1_to_SaTmax = sa_BCHydro16_Sub_TCur/sa_BCHydro16_Sub_Tmax;
            sa(1,i) = ratioSaT1_to_SaTmax * sa_AB03_Sub_Tmax;
            sigma(1,i) = sigma_AB03_Sub_Tmax;
        end
        elseif strcmp(GMPM, 'Zhao06')
        if(strcmp(tectonic, 'Crustal')); FR = 1; SI = 0; SS = 0;
        elseif(strcmp(tectonic, ' Interface/Subduction')); FR = 0; SI = 1; SS = 0; 
        else; FR = 0; SI = 0; SS = 0; 
        end
        if PerTgt(i) <= 5
            [sa(1,i), sigma(1,i)] = Zhao_2006(PerTgt(i), M_bar,Rjb_bar,Rjb_bar,Vs30,FR,SI,SS,1);
        else % same procedure as for ABS03
            % fprintf('T1 is more than the maximum period for GMM, ABS03. Extrapolating using the recommendations by Kolaj et al. (2019) GMM for 6th NHM. \n');
            % (1/3)
            Tmax_GMM = 5;
            [sa_Zhao06_Tmax, sigma_Zhao06_Tmax] = Zhao_2006(Tmax_GMM, M_bar,Rjb_bar,Rjb_bar,Vs30,FR,SI,SS,1); % (1/3)

            % (2/3)
            [sa_BCHydro16_Sub_Tmax, ~] = bc_hydro_2016_subduction(Tmax_GMM, M_bar, Rjb_bar, 0, Vs30, 0, 0);
            [sa_BCHydro16_Sub_TCur, ~] = bc_hydro_2016_subduction(PerTgt(i), M_bar, Rjb_bar, 0, Vs30, 0, 0);

            % (3/3)
            ratioSaT1_to_SaTmax = sa_BCHydro16_Sub_TCur/sa_BCHydro16_Sub_Tmax;
            sa(1,i) = ratioSaT1_to_SaTmax * sa_Zhao06_Tmax;
            sigma(1,i) = sigma_Zhao06_Tmax;
        end
    else
        error('GMPE not in the list! Add the specific model here and execute again.')
    end
end
cd(baseFolder); % back home

% User inputs end here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use the CMS method to estimate target means and covariances

% (Log) Response Spectrum Mean: meanReq
rho = zeros(1,length(PerTgt));
for i = 1:length(PerTgt)
    rho(i) = step3a_baker_jayaram_correlation(PerTgt(i), T1);
end

if GMSelectionInputs.meanTargetCMS == 1
    meanReq = log(sa) + sigma.*eps_bar.*rho; % CMS, basically 
else % if GMSelectionInputs.meanTargetCMS == 0
    meanReq = log(sa) + sigma.*eps_bar; % UHS, basically (07-01-22, psb)
end

lnSa1 = meanReq(PerTgt == T1);

UHS = exp(log(sa) + sigma.*eps_bar);

% (Log) Response Spectrum Covariance: covReq
covReq = zeros(length(PerTgt));
for i=1:length(PerTgt)
    for j=1:length(PerTgt)
        
    % Periods
    Ti = PerTgt(i); 
    Tj = PerTgt(j);
    
    % Means and variances
    rec1 = find(PerTgt == Ti); 
    rec2 = find(PerTgt == Tj);
    var1 = sigma(rec1)^2; 
    var2 = sigma(rec2)^2;
    
    rec = find(PerTgt == T1);

% (8-5-16, PSB) replaced the following obsolete set of codes by one single line given by corresponding term in the equation (9)
% of Jayaram Lin Baker (2011) paper (first reference in this code)

%         varT = sigma(rec)^2;
%         sigma11 = [var1                                                 baker_jayaram_correlation(Ti, Tj)*sqrt(var1*var2);
%                    baker_jayaram_correlation(Ti, Tj)*sqrt(var1*var2)    var2                                            ];
%         sigma22 = varT;
%         sigma12 = [baker_jayaram_correlation(Ti, T1)*sqrt(var1*varT);
%                    baker_jayaram_correlation(T1, Tj)*sqrt(var2*varT)];
% %         sigmaCond = sigma11 - sigma12*inv(sigma22)*(sigma12)';
%         sigmaCond = sigma11 - (1/sigma22)*(sigma12*sigma12');
%         covReq(i,j) = sigmaCond(1,2);
        
        if useVar == 0 % either CMS or UHS, but only with mean is targeted
            covReq(i,j) = 0.0;
        elseif useVar == 1 && GMSelectionInputs.meanTargetCMS == 1 % CMS and COV are targeted
            % General conditional covariance term
            covReq(i,j) = step3a_baker_jayaram_correlation(Ti, Tj) * sqrt(var1*var2) - ...
                      step3a_baker_jayaram_correlation(Ti, T1) * step3a_baker_jayaram_correlation(Tj, T1) * sqrt(var1*var2);

        elseif useVar == 1 && GMSelectionInputs.meanTargetCMS == 0 % UHS and its dispersion aer targeted. Note- It is unconditional.
            covReq(i,j) = step3a_baker_jayaram_correlation(Ti, Tj) * sqrt(var1*var2);
        end
    end
end

%% Simulate response spectra using Monte Carlo Simulation

% 20 sets of response spectra are simulated and the best set (in terms of
% matching means, variances and skewness is chosen as the seed). The user
% can also optionally rerun this segment multiple times before deciding to
% proceed with the rest of the algorithm. It is to be noted, however, that
% the greedy improvement technique significantly improves the match between
% the means and the variances subsequently.

nTrials = 20;
% Setting initial seed for simulation
if seedValue ~= 0
%     randn('seed',seedValue);
    rng(seedValue, 'v5normal'); % updated the random number generator
else
%     randn('seed', sum(100*clock));
    rng(sum(100*clock), 'v5normal');
end
devTotalSim = zeros(nTrials,1);
for j=1:nTrials
    gmCell{j} = zeros(nGM,length(meanReq));
    for i=1:nGM
        gmCell{j}(i,:) = exp(mvnrnd(meanReq,covReq));
    end
    devMeanSim = mean(log(gmCell{j})) - meanReq;
    devSkewSim = skewness(log(gmCell{j}),1);
    devSigSim = std(log(gmCell{j})) - sqrt(diag(covReq))';
    devTotalSim(j) = weights(1) * sum(devMeanSim.^2) + weights(2) * sum(devSigSim.^2)+ 0.1 * (weights(1)+weights(2)) * sum(devSkewSim.^2);
%     devTotalSim(j) = weights(1) * sum(devMeanSim.^2) + weights(2) * sum(devSigSim.^2);
end
[tmp, recUse] = min(abs(devTotalSim));
gm = gmCell{recUse};

if showPlots == 1
    
    % Plot simulated response spectra
    figure
    h12 = loglog(PerTgt, exp(meanReq + 1.96*sqrt(diag(covReq))'), '--r', 'linewidth', 3);
    hold on
    for i=1:nGM
        h13 = loglog(PerTgt,gm,'color',[0.5 0.5 0.5]);
    end
% Median curve is plotted later to bring the CMS, UHS and bounds at the top. 
    h11 = loglog(PerTgt, exp(meanReq), '-r', 'linewidth', 3);
    h14 = loglog(PerTgt, exp(meanReq - 1.96*sqrt(diag(covReq))'), '--r', 'linewidth', 3);
    h15 = plot(PerTgt, UHS, 'b-', 'LineWidth', 3);
    
    axis([min(PerTgt) max(PerTgt) 1e-2 2])
    hx = xlabel('Period (s)');
    hy = ylabel('S_a (g)');
%     legend('Median response spectrum','2.5 and 97.5 percentile response spectra','Response spectra of simulated ground motions')
    strForLegend = {'Median response spectrum (CMS)'
                    '2.5 and 97.5 %ile response spectra'
                    'Simulated response spectra'
                    'Uniform Hazard Spectrum (UHS)'};

    legh = legend([h11, h12, h13(end), h15], strForLegend, 'location', 'southwest');

    htitle = title('Response spectra of simulated ground motions');
    
    figureFormatScript_forReport
    

    exportName = sprintf('3a_Fig1_SimulatedGMsWithCMS_%i',nGM);
    step3b_psb_SaveFigure(dirNameForSaving, exportName) % save .fig, .eps, .png, .emf files
    
    % Plot target and simulated means
    figure
    h21 = loglog(PerTgt,exp(meanReq), 'r-', 'LineWidth', 3);
    hold on
    h22 = loglog(PerTgt,exp(mean(log(gm))),'b--', 'LineWidth', 3);
    axis([min(PerTgt) max(PerTgt) 1e-2 5])
    hx = xlabel('Period (s)');
    hy = ylabel('Median S_a (g)');
    legh = legend([h21, h22], {'exp(target mean lnS_a)','exp(simulated mean lnS_a)'});
    htitle = title('Target and sample median Sa');
    ylim([0.01, 3])

    figureFormatScript_forReport

    exportName = sprintf('3b_Fig2_SimulatedMedian_%i', nGM);
    step3b_psb_SaveFigure(dirNameForSaving, exportName)
    
% Plot target and simulated standard deviations
    figure
    h31 = semilogx(PerTgt,sqrt(diag(covReq))', 'r-', 'LineWidth', 3);
    hold on
    h32 = semilogx(PerTgt,std(log(gm)), 'b--', 'LineWidth', 3);
    axis([min(PerTgt) max(PerTgt) 0 0.7])
    hx = xlabel('Period (s)');
    hy = ylabel('\sigma(lnS_a)');
    legh = legend([h31, h32], {'Target \sigma(lnS_a)','Simulated \sigma(lnS_a)'});
    htitle = title('Target and simulated \sigma(ln S_a)');

    figureFormatScript_forReport

    exportName = sprintf('3c_Fig3_SimulatedVar_%i',nGM);
    step3b_psb_SaveFigure(dirNameForSaving, exportName)
    
end

%% Arrange the available spectra in a usable format and check for invalid input

% Match periods (known periods and periods for error computations)
recPer = zeros(length(PerTgt),1);
for i=1:length(PerTgt)
    [tmp, recPer(i)] = min(abs(perKnown - PerTgt(i)));
end

% Check for invalid input
sampleBig = SaKnown(:,recPer);
if (any(any(isnan(sampleBig))))
    error ('NaNs found in input response spectra')
end

% Processing available spectra
sampleBig = log(sampleBig);
nBig = size(sampleBig,1);

%% Find best matches to the simulated spectra from ground-motion database

recID = zeros(nGM,1);
sampleSmall = [];
finalScaleFac = ones(nGM,1);
for i = 1:nGM
    err = zeros(nBig,1);
    
    scaleFac = ones(nBig,1);
    for j=1:nBig
        if (isScaled == 1)
            
            if exp(sampleBig(j,PerTgt == T1)) == 0
                scaleFac(j) = -1;
                err(j) = 1000000;
            else
                scaleFac(j) = exp(lnSa1)/exp(sampleBig(j,PerTgt == T1));
%                 if (scaleFac(j) > maxScale || soil_Vs30(j)==-1 || any(notAllowed==j)) % using notAllowed as struct now (06-13-22, psb) 
                if (scaleFac(j) > maxScale || soil_Vs30(j)==-1)
                    err(j) = 2000000; % using different indicators to backtrace the reasons behind removal of a time-history
% when any of the filtering criteria is -99, it's not active (6-13-22, psb)    
                elseif (magLimit ~= -99 && abs(M_bar - mag(j)) > abs(magLimit)) || (R_min ~= -99 && (Rjb(j) < R_min || isnan(Rjb(j)))) || (Vs30Min ~= -99 && (soil_Vs30(j) < Vs30Min || isnan(soil_Vs30(j)))) || (Vs30Max ~= -99 && soil_Vs30(j) > Vs30Max)
                    err(j) = 2000000; 
                else
                    err(j) = sum((log(exp(sampleBig(j,:))*scaleFac(j)) - log(gm(i,:))).^2);
                    % note that the scale factor are on the sa values and sampleBig is in log. 
                    % So use exp first, for converting to normal value. Then, 
                    % apply scale factor and then take log again.
                end
            end
        else
%             if (soil_Vs30(j)==-1 || any(notAllowed==j)) % using notAllowed as struct now (06-13-22, psb) 
            if soil_Vs30(j)==-1
                err(j) = 3000000;
            elseif (magLimit ~= -99 && abs(M_bar - mag(j)) > abs(magLimit)) || (R_min ~= -99 && (Rjb(j) < R_min || isnan(Rjb(j)))) || (Vs30Min ~= -99 && (soil_Vs30(j) < Vs30Min || isnan(soil_Vs30(j)))) || (Vs30Max ~= -99 && soil_Vs30(j) > Vs30Max)
                err(j) = 2000000; 
            else
                err(j) = sum((sampleBig(j,:) - log(gm(i,:))).^2);
                if err(j) == inf
                    err(j) = 4000000;
                end
            end
        end
        % if some record is already considered, don't consider it this time.
        if (any(recID == j))
%             fprintf('j = %i, error = %f\n', j, err(j));
            err(j) = 5000000;
        end
    end
    [tmp, recID(i)] = min(err);
    if tmp >= 1000000
        disp('Warning: Possible problem with simulated spectrum. No good matches found');
        disp(recID(i));
    end
    if (isScaled == 1)
        finalScaleFac(i) = scaleFac(recID(i));
    else
        finalScaleFac(i) = 1;
    end
    sampleSmall = [sampleSmall;log(exp(sampleBig(recID(i),:))*scaleFac(recID(i)))];
    
end

switch databaseToUse
    case 'NGA_W2'
        fprintf('As a result of primary algorithm, RSNs of the selected records from NGA-W2 database are \n');
        % disp(recID); % does not work with valid database where row number \neq RSN
        disp(sort(NGA_num(recID))'); % recID contains an indices for valid records only. Corresponding RSN are stored as NGA_num in valid database.
    case 'KiK_NET'
        fprintf('As a result of primary algorithm, code (X) of the selected records from KiK-NET database are \n');
        disp(X_KiK(recID)'); 
        fprintf('Corresponding record IDs (EQID) in KiK-NET database are \n');
        disp(EQID_KiK(recID)');
end

%% Greedy subset modification procedure

disp('Please wait...This algorithm takes a few minutes depending on the number of records to be selected');
f = waitbar(0,'1','Name','Greedy algorithm for GM selection.',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);

for k=1:nLoop % Number of passes
    for i=1:nGM % Selects nGM ground motions

        fractionComplete = ((k-1)*nGM + i-1)/(nLoop*nGM);
        waitbar(fractionComplete, f, sprintf('%i%% done', int32(fractionComplete * 100)));

        minDev = 100000;

        sampleSmall(i,:) = []; % eliminate the i'th gm from the list
        recID(i,:) = []; % also eliminate the i'th record ID
        
        % Try to add a new spectra to the subset list
        for j=1:nBig

            if isScaled == 1
                if exp(sampleBig(j,PerTgt == T1)) == 0
                    scaleFac(j) = 6000000;
                else
                    scaleFac(j) = exp(lnSa1)/exp(sampleBig(j,PerTgt == T1));
                end
                sampleSmall = [sampleSmall;sampleBig(j,:)+log(scaleFac(j))];
            else
                sampleSmall = [sampleSmall;sampleBig(j,:)];
                scaleFac(j) = 1;
            end
            % Compute deviations from target
            devMean = mean(sampleSmall) - meanReq;
            devSkew = skewness(sampleSmall,1);
            devSig = std(sampleSmall) - sqrt(diag(covReq))';
            %devTotal = weights(1) * sum(devMean.^2) + weights(2) * sum(devSig.^2)+ weights(3) * sum(devSkew.^2);
            devTotal = weights(1) * sum(devMean.^2) + weights(2) * sum(devSig.^2);

            % Penalize bad spectra (set penalty to zero if this is not required)
            for m=1:size(sampleSmall,1)
                devTotal = devTotal + sum(abs(exp(sampleSmall(m,:))>exp(meanReq+3*sqrt(diag(covReq))'))) * penalty;
            end

%             if (scaleFac(j) > maxScale || soil_Vs30(j)==-1 || any(notAllowed==j)) % using notAllowed as struct now (06-13-22, psb)  
            if isScaled == 1 && (scaleFac(j) > maxScale || soil_Vs30(j)==-1)
                devTotal = devTotal + 1000000;
            elseif (magLimit ~= -99 && abs(M_bar - mag(j)) > abs(magLimit)) || (R_min ~= -99 && (Rjb(j) < R_min || isnan(Rjb(j)))) || (Vs30Min ~= -99 && (soil_Vs30(j) < Vs30Min || isnan(soil_Vs30(j)))) || (Vs30Max ~= -99 && soil_Vs30(j) > Vs30Max)
                devTotal = devTotal + 1000000;
            end

            % Should cause improvement and record should not be repeated
            if (devTotal < minDev && ~any(recID == j))
                minID = j;
                minDev = devTotal;
            end
            sampleSmall = sampleSmall(1:end-1,:);

        end

        % Add new element in the right slot
        if isScaled == 1
            finalScaleFac(i) = scaleFac(minID);
        else
            finalScaleFac(i) = 1;
        end
%         sampleSmall = [sampleSmall(1:i-1,:);sampleBig(minID,:)+log(scaleFac(minID));sampleSmall(i:end,:)];
        sampleSmall = [sampleSmall(1:i-1,:);sampleBig(minID,:)+log(finalScaleFac(i));sampleSmall(i:end,:)];
        recID = [recID(1:i-1);minID;recID(i:end)];
    end
    disp(['Selected record IDs and scale factors after greedy technique loop no-', num2str(k) ' are as follows:']);
    switch databaseToUse
        case 'NGA_W2'
            fprintf('[NGA-W2] Record ID \t ScaleFac \n');
            [~, I] = sort(recID, 'ascend');    % Now printing it in the order of RSN values.
            for i = 1:length(recID)
                %             fprintf('%10i \t %.4f \n', recID(I(i)), finalScaleFac(I(i)));
                RSNID(i) = NGA_num(recID(I(i))); % recID contains an index for valid records only. Corresponding RSN are stored as NGA_num in valid database.
                fprintf('%10i \t %.4f \n', RSNID(i), finalScaleFac(I(i)));
            end
        case 'KiK_NET'
            fprintf('[KiK-NET] Code (X) \t Record ID \t ScaleFac \n');
            for i = 1:length(recID)
                X_curr = X_KiK(recID(i));
                EQID_curr = EQID_KiK(recID(i));
                fprintf('%i \t %s \t %.4f \n', X_curr, string(EQID_curr), finalScaleFac(i));
            end
    end
end

% disp('100% done');
f = waitbar(1, f, '100% done');
delete(f);

% Output information
finalRecords = recID;
finalScaleFactors = finalScaleFac;

%% Spectra Plots

if (showPlots)
    % Variables used here
    % SaKnown    : As before, it contains the response spectra of all the
    %              available ground motions (N*P matrix) - N ground motions,
    %              P periods
    % sampleBig  : Same as SaKnown, but is only defined at PerTgt, the
    %              periods at which the target response spectrum properties
    %              are computed
    % sampleSmall: The response spectra of the selected ground motions,
    %              defined at PerTgt
    % meanReq    : Target mean for the (log) response spectrum
    % covReq     : Target covariance for the (log) response spectrum
    %

    % Plot at all periods
    figure
    h42 = loglog(PerTgt, exp(meanReq + 1.96*sqrt(diag(covReq))'), '--r', 'linewidth', 3);
    hold on
    perKnown(recPer) = PerTgt;
    h44 = loglog(perKnown,SaKnown(finalRecords,:).*repmat(finalScaleFactors,1,size(SaKnown,2)),'color',[0.5 0.5 0.5]);
% Median curve is plotted later to bring the CMS and bounds at the top. 
    h41 = loglog(PerTgt, exp(meanReq), 'r', 'linewidth', 3);
    h43 = loglog(PerTgt, exp(meanReq - 1.96*sqrt(diag(covReq))'), '--r', 'linewidth', 3);
    axis([min(PerTgt) max(PerTgt) 1e-2 5])
    hx = xlabel('Period (s)');
    hy = ylabel('S_a (g)');
%     legend('Median response spectrum','2.5 and 97.5 percentile response spectra','Response spectra of selected ground motions');
    htitle = title('Response spectra of selected ground motions');
    
    strForLegend = {'Median response spectrum (CMS)'
        '2.5 and 97.5 %ile response spectra'
        'Selected GM Response spectra'};

    legh = legend([h41, h42, h44(end)], strForLegend, 'location', 'southwest');
    ylim([0.01, 3])

    figureFormatScript_forReport
    
    exportName = sprintf('3d_Fig4_SelectedGMsWithCMS_%i',nGM);
    step3b_psb_SaveFigure(dirNameForSaving, exportName)
    
    % Plot spectra only at periods where error is minimized
    figure
    loglog(PerTgt, exp(meanReq), 'r', 'linewidth', 3)
    hold on
    loglog(PerTgt, exp(meanReq + 1.96*sqrt(diag(covReq))'), '--r', 'linewidth', 3)
    loglog(PerTgt, exp(sampleBig(finalRecords,:)).*repmat(finalScaleFactors,1,length(PerTgt)),'color',[0.5 0.5 0.5],'linewidth',1)
    loglog(PerTgt, exp(meanReq - 1.96*sqrt(diag(covReq))'), '--r', 'linewidth', 3)
    axis([min(PerTgt) max(PerTgt) 1e-2 5])
    hx = xlabel('Period (s)');
    hy = ylabel('S_a (g)');
    legh = legend('Median response spectrum','2.5 and 97.5 percentile response spectra','Response spectra of selected ground motions', 'location', 'southwest');
    htitle = title ('Response spectra of selected ground motions at periods where error is minimized');
    ylim([0.01, 3])
    figureFormatScript_forReport
    
    % Sample and target means
    figure
    h61 = loglog(PerTgt,exp(meanReq),'r-','linewidth',3);
    hold on
    h62 = loglog(PerTgt,exp(mean(sampleSmall)),'b--','linewidth',3);
    axis([min(PerTgt) max(PerTgt) 1e-2 2])
    hx = xlabel('Period (s)');
    hy = ylabel('Median S_a (g)');
    legh = legend([h61, h62], {'exp(target mean lnS_a)','exp(selected mean lnS_a)'});
    htitle = title('Target and selected median Sa');
    ylim([0.01, 3])

    figureFormatScript_forReport

    exportName = sprintf('3f_Fig6_SelectedMedian_%i', nGM);
    step3b_psb_SaveFigure(dirNameForSaving, exportName)
    
    % Sample and target standard deviations
    figure
    h71 = semilogx(PerTgt,sqrt(diag(covReq))','r-','linewidth',3);
    hold on
    h72 = semilogx(PerTgt,std(sampleSmall),'b--','linewidth',3);
    axis([min(PerTgt) max(PerTgt) 0 0.7])
    hx = xlabel('Period (s)');
    hy = ylabel('\sigma(lnS_a)');
    legh = legend([h71, h72], {'Target \sigma(lnS_a)','Selected \sigma(lnS_a)'});
    htitle = title('Target and selected \sigma(lnS_a)');
    
    figureFormatScript_forReport

    exportName = sprintf('3g_Fig7_SelectedSigma_%i', nGM);
    step3b_psb_SaveFigure(dirNameForSaving, exportName)
    fprintf('Figures stored in %s \n', fullfile(pwd, dirNameForSaving));

end

if (checkCorr)
    step3c_conditionalCovariance
end

%% Output data to file (best viewed with textpad)
tempFolder = pwd;
cd(dirNameForSaving)
    fin = fopen(outputFile,'w');
    
switch databaseToUse
    case 'NGA_W2'
        fprintf(fin,'[NGA-W2]\n%s\t%s\t%s\n','SNo','RSN','SF');
        for i = 1 : length(finalRecords)
            rec = finalRecords(i);
            RSN_ID = NGA_num(rec);
            fprintf(fin,'%i\t%i\t%8.4f\n', i, RSN_ID, finalScaleFactors(i));
        end
    case 'KiK_NET'
        fprintf(fin,'[KiK-net]\n%s\t%s\t%s\n','Code_X','RecordID','SF');
        for i = 1 : length(finalRecords)
            rec = finalRecords(i);
            X_ID = X_KiK(rec);
            EQ_ID = EQID_KiK(rec);
            fprintf(fin,'%d\t%s\t%8.4f\n', X_ID, string(EQ_ID), finalScaleFactors(i));
        end
end
fprintf('Selected records stored as %s \n', fullfile(pwd, dirNameForSaving, outputFile));

cd(tempFolder)

%% output variables to the function 
switch databaseToUse
    case 'NGA_W2'
%         [sortedrec, index] = sort(finalRecords); % (06-06-22, psb) Not sorting any more. It messes with order of scaling factors, etc. 
%         ID = NGA_num(sortedrec);
%         finalScaleFactors = finalScaleFactors(index); % reorder scale factors 
        ID = NGA_num(finalRecords);
    case 'KiK_NET'
        ID = EQID_KiK(finalRecords);
        % scale factors are not required to reordered
end

% send data for selected records
selectedRecords.mag = mag(finalRecords);
selectedRecords.Rjb = Rjb(finalRecords);
selectedRecords.closest_D = closest_D(finalRecords);
selectedRecords.Vs30 = soil_Vs30(finalRecords);

% send some additional values for plot
selectedRecords.PerTgt = PerTgt;
selectedRecords.meanReq = meanReq;
selectedRecords.covReq = covReq;
selectedRecords.perKnown = perKnown;
selectedRecords.recPer = recPer;
selectedRecords.sampleSmall = sampleSmall;
selectedRecords.SaSelected = SaKnown(finalRecords,:);
selectedRecords.scaleFactors = finalScaleFactors;
selectedRecords.ID = ID;

% send some inputs to the output, so we can pass it on to plot functions
selectedRecords.GMPM = GMPM;
selectedRecords.T_range = T_range;
selectedRecords.databaseToUse = databaseToUse;

selectedRecords.tectonic = tectonic;

fclose(fin);
% toc
