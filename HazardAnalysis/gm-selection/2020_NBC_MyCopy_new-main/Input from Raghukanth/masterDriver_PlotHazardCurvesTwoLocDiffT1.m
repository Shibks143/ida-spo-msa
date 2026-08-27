clear;
tic
baseFolder = pwd;
cd ..\..\..\..\psb_MatlabProcessors
addpath(pwd)
cd(baseFolder)


%%% >>> START OF INPUT BLOCK HERE <<< %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pshaVersion = 'new';  % 'old' -> 20200111_v4, 'new' -> 20260818_v4

locName = 'Guwahati'; % input depending on the site (lat, lon) (Table 5.4 of NDMA, 2011 report)
switch locName      
    case 'Chennai'
        latLon = [13.05  80.27]; earthquakeZone = 'III';
    case 'Kolkata'
        latLon = [22.55  88.37]; earthquakeZone = 'IV';
    case 'Mumbai'
        latLon = [19.00  72.80]; earthquakeZone = 'III';
    case 'Delhi'
        latLon = [28.62  77.22]; earthquakeZone = 'IV';
    case 'Guwahati'
        latLon = [26.17  91.77]; earthquakeZone = 'VI';
    case 'ArunachalBorder'
        latLon = [27.10  92.10]; 
    otherwise
        error('Unknown locName: %s', locName);
end

locName2 = 'Delhi';   % second location for the combined UHS comparison
switch locName2
    case 'Delhi'
        latLon2 = [28.62  77.22]; earthquakeZone2 = 'IV';
    case 'Guwahati'
        latLon2 = [26.17  91.77]; earthquakeZone2 = 'VI';
    otherwise
        error('Unknown locName2: %s', locName2);
end

Tcond = 2; % conditioning period for return-period-based Sa extraction
returnPeriods_SaTcond = [75 175 275 475 975 1275 2475 4975 9975];
returnPeriods_UHS     = returnPeriods_SaTcond;
% returnPeriods_UHS     = [75 175 275 475 975 1275 2475 4975 9975]; 

% period for spectral accelerations for different hazard curves — depends on pshaVersion
switch pshaVersion
    case 'old'
        % 9 periods, capped at 2s (see timePIDsToProc = 1:8 anomaly note)
        T1LIST = [0 0.1:0.1:0.5 1 1.50 2];
    case 'new'
        % new Aug 2026 data: 27 periods available, up to 5s
        T1LIST = [0.01 0.1:0.1:0.5 1 1.50 2];
        % T1LIST = [0.01 0.05 0.1 0.5 1 1.50 2 3 5];
    otherwise
        error('Unknown pshaVersion: %s', pshaVersion);
end

%  1a. inputs for extracting  hazard
doPlot = 0; plotType = 'loglog'; % 'semilog', 'loglog, 'linear'
imTypeForPlot = {'Sa_T1'}; % essentially fixed now
locationLISTforPlot = {locName}; legendName = {};
fitModel = '3param'; % {'2param', '3param'}; % Basically, k0*a^(-k) OR k0*exp[-k2*ln^2(a) - k1*ln(a)]
N = 21; % [11, 21, 51]; % number of points between consecutive imValLIST values
% plotStyle = {'k-', 'b--', 'r-.', 'm:', 'k-', 'b--', 'r-.', 'm:', 'k--'};
% lineW = [1.5*ones(1, 4) 0.8*ones(1, 5)];
nT = numel(T1LIST);
baseStyles = {'k-', 'b-', 'r-.', 'm:', 'k--', 'b--', 'r--', 'm-.'};
plotStyle = baseStyles(mod(0:nT-1, numel(baseStyles)) + 1);
lineW = [1.2*ones(1,4), 0.8*ones(1, max(nT-4,0))];
doSave = 1; % save the plot
THmax = 10;   % max natural period (s) to evaluate the response spectrum over
dT_H  = 0.001; % period step (s) for evaluation/plotting

% Simplifying Hazard Input structures
% COMMON hazard inputs
hazardInputs.pshaVersion =           pshaVersion;
hazardInputs.latLon =                latLon;
hazardInputs.locName =               locName;
hazardInputs.doPlot =                doPlot;
hazardInputs.plotType =              plotType;
hazardInputs.imTypeForPlot =         imTypeForPlot;
hazardInputs.locationLISTforPlot =   locationLISTforPlot;
hazardInputs.legendName =            legendName;
hazardInputs.fitModel =              fitModel;
hazardInputs.N =                     N;
hazardInputs.doSave =                doSave;
hazardInputs.baseFolder =            baseFolder;

% Hazard curve inputs
hazardInputs.T1LIST =                T1LIST;
hazardInputs.plotStyle =             plotStyle;
hazardInputs.lineW =                 lineW;

% Target Sa inputs
hazardInputs.Tcond =                  Tcond;  % useful for multi-stripe analysis (MSA)
hazardInputs.returnPeriods_SaTcond =  returnPeriods_SaTcond;

% UHS inputs
hazardInputs.periodsForUHS =         [];
hazardInputs.returnPeriods_UHS =     returnPeriods_UHS;

% IS Response Spectrum inputs
hazardInputs.THmax =                 THmax;   
hazardInputs.dT_H  =                 dT_H; 

% ============================================================
% IS Response Spectrum analysis mode
% ============================================================
% modeIS = 'MultiRP';        % Single Zone, Multiple Return Periods
modeIS = 'MultiZone';       % Multiple Zones, Single Return Period % used for UHS_ISRes too
% modeIS = 'Combined';     % Multiple Zones, Multiple Return Periods

switch modeIS
    case 'MultiRP' 
        hazardInputs.earthquakeZone = earthquakeZone;
        hazardInputs.returnPeriods = [475 2475];
    case 'MultiZone'
        hazardInputs.earthquakeZones = {'IV','VI'};
        hazardInputs.returnPeriod = 475; %2475
    case 'Combined'
        hazardInputs.earthquakeZones = {'IV','VI'};
        hazardInputs.returnPeriods = [475 2475];
    otherwise
        error('Unknown modeIS: %s', modeIS);
end


%%% >>> END INPUT BLOCK <<< %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% ANALYSIS OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%                 HazCur    Sa(Tcond)      UHS      ISResSpec   UHS_ISRes
runHazardIndex =  [0          1            0          0            0  ];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hazard Curves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if runHazardIndex(1) == 1
    % Number of periods
    nT = numel(T1LIST);
    % Preallocate cell arrays for discretized hazard curves
    imValDisc_LIST = cell(1,nT);
    afeDisc_LIST   = cell(1,nT);

    for j = 1:size(T1LIST, 2)
        T1Curr = T1LIST(1, j);
        % 1a. extract hazard curve data (10-point-curve) from Raghukanth's file (received on Jan 11, 2020)
        switch pshaVersion
            case 'old'
                % 10-point-curve, Raghukanth file received Jan 11, 2020 
                [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20200111_v4(hazardInputs, T1Curr);
            case 'new'
                % updated PSHA, Raghukanth file received Aug 18, 2026
                [imValLIST, afe_Sa_T1_LIST] = findHazValRaghukanth20260818_v4(hazardInputs, T1Curr);
            otherwise
                error('Unknown pshaVersion: %s', pshaVersion);
        end

        %  1b. discretize each hazard curve individually %% same for both old and new PSHA %
        [imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(hazardInputs, imValLIST, afe_Sa_T1_LIST);

        % Store results
        imValDisc_LIST{j} = imValDisc;
        afeDisc_LIST{j}   = afeDisc;
    end

    % Plot all hazard curves
    sks_plotHazardCurves_v1(imValDisc_LIST, afeDisc_LIST, T1LIST, hazardInputs);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Target Sa at Tcond for specified return periods, added on 16 Aug 2026
% Independently compute hazard curve at Tcond (works for ANY period)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if runHazardIndex(2) == 1
    switch pshaVersion   
        case 'old'
            [imValLIST_Tc, afe_Sa_Tc_LIST] = findHazValRaghukanth20200111_v4(hazardInputs, Tcond);
        case 'new'
            [imValLIST_Tc, afe_Sa_Tc_LIST] = findHazValRaghukanth20260818_v4(hazardInputs, Tcond);
        otherwise
            error('Unknown pshaVersion: %s', pshaVersion);
    end

    % Discretize hazard curve — same procedure for both PSHA versions %% need
    [imValDisc_Tcond, afeDisc_Tcond, ~] = returnHazCurveRaghukanth20200111_v2(hazardInputs, imValLIST_Tc, afe_Sa_Tc_LIST);

    [afeSorted, sortIdx] = sort(afeDisc_Tcond);
    imValSorted = imValDisc_Tcond(sortIdx);
    fprintf('\nTarget Sa(%.2fs) at %s:\n', Tcond, locName);
    
    targetSa_LIST = zeros(size(returnPeriods_SaTcond));

    for i = 1:length(returnPeriods_SaTcond)
        Tr = returnPeriods_SaTcond(i);
        targetAFE = 1/Tr;
        targetSa_LIST(i) = exp(interp1(log(afeSorted), log(imValSorted), log(targetAFE)));
        fprintf('Return period %5d yr -> Sa(%.2fs) = %.4f g\n', Tr, Tcond, targetSa_LIST(i));
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uniform Hazard Spectrum (UHS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if runHazardIndex(3) == 1
    [periodsForUHS, UHS_Sa, UHS_Table] = sks_generateUHS_v1(hazardInputs); % Generate UHS
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IS Standard Response Spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if runHazardIndex(4) == 1
        [T_H, A_NH] = sks_ISResponseSpectrum_v1(hazardInputs);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combined UHS + IS Standard Response Spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if runHazardIndex(5) == 1
    hazardInputs.locNames = {locName, locName2};                % NEW: two locations
    hazardInputs.latLons = {latLon, latLon2};                    % NEW: latLon per location, matching locNames order
    hazardInputs.returnPeriods_UHS = 475;  %[475, 2475];     % NEW: restrict UHS to these two Tr
    [periodsForUHS, UHS_Sa_ALL, UHS_Table_ALL, T_H, Sa_IS_LIST] = sks_UHS_ISResponse_combined_v1(hazardInputs);
end

toc
