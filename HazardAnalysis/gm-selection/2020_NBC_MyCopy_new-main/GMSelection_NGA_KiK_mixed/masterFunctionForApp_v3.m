function selectionResult = masterFunctionForApp_v3(userInputs)

% This may seem redundant if starting from this directory, but since I am using an app 
% now, this command makes sure that other cd commands don't run into error

% filePathName = matlab.desktop.editor.getActiveFilename; % returns active file's path. we need running file's (our app's) path
filePathName = mfilename('fullpath'); 
[filePath, ~, ~] = fileparts(filePathName); cd(filePath); 

showIntermediatePlots = 0; % turn off/on additional plots, change to 1 while debugging

tectonicLIST = userInputs.tectonic;
databaseLIST = userInputs.DB_LIST;
nGMLIST = userInputs.nGM_LIST;
dirNameAndSuffix = userInputs.dirName;
Vs30 = userInputs.Vs30site;
mechLIST = userInputs.mech;

% deaggregation characteristics
magLIST = userInputs.magLIST; 
distLIST = userInputs.distLIST;
GMMLIST = userInputs.GMM_LIST;
T1_list = userInputs.T1; 
SaT1_list = userInputs.SaT1;
Tmin = userInputs.Tmin; 
Tmax = userInputs.Tmax;

% ground motion filtering characteristics
isScaled = userInputs.allowScaling;
maxScale = userInputs.maxSF; 
notAllowedFilters.magLimit = userInputs.magLimit; 
notAllowedFilters.R_min = userInputs.R_min; 
notAllowedFilters.Vs30Min = userInputs.Vs30Min; 
notAllowedFilters.Vs30Max = userInputs.Vs30Max; 

% app.targetWhat? MeanCOVButton or MeanButton 
useVar = userInputs.useVar; 

% app.meanTarget? CMS or UHS
GMSelectionInputs.meanTargetCMS = userInputs.meanTargetCMS;

% if isnan(magLimit) || isempty(magLimit); magLimit = 0; end
% if isnan(R_min)    ||  isempty(R_min);   R_min    = 0; end
% if isnan(Vs30Min)  ||  isempty(Vs30Min); Vs30Min  = 0; end
% if isnan(Vs30Max)  ||  isempty(Vs30Max); Vs30Max  = 0; end

% make directory for summary of combined selection results 
dirCombined = sprintf('Summary_%s', dirNameAndSuffix);
if ~exist(dirCombined, 'dir'); mkdir(dirCombined); end

tic; close all; format compact; baseFolder = pwd;

%% Instructions- (5-28-22, PSB)
% This script will give the list of RSNs to download from NGA or KiK-NET

%% Database and number of records to select
% databaseLIST = {'NGA_W2'; 'KiK_NET'};
% nGMLIST = [10; 5]; % Number of ground motions to be selected from each databaseLIST 
% databaseLIST = {'NGA_W2'};
% nGMLIST = [5]; % Number of ground motions to be selected from each databaseLIST 

%% suffix for result directory name (change it to reflect main inputs for GM selection)
% suffixForDirAndFileNames = 'temp40_1p68_bbbb_MpM_RpR_BCH16_maxSca2'; % Temp, 22 GMs, T* = 2.39 s, bldg ID- 2223, (M_bar, R_bar) = (7.60, 15.8 km), max scaling- 2.0
outputFile = [dirNameAndSuffix, '.dat']; % File name of the output file

%% address to GMM directory
gmmDir = fullfile(pwd, '..', filesep, 'GMM');

%% step-1 get the hazard curves, reponse spectra, and expected Intensity measure at the site of interest
fprintf('------------------------------------ \n');
fprintf('---------- Step-1/3 ---------------- \n');
% timeP = 1.68; % Now in use. For approximate hazard curve generation corresponding to this time period.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Caution: PLEASE UPDATE IM_PSHA. %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IM_PSHA = 0.308; % use H:\UniformRiskMap\Input from Raghukanth\scriptSeveralLocsSaT1_Tr_v1
% IM_PSHA = saMCE_timeP; % (9-11-20, PSB) commenting out the following line, since we have the complete hazard data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate colors with different intensities of gray 
% numDB = size(databaseLIST, 1); 
% colorRecLIST = repmat(linspace(0, 0.5, numDB)', 1, 3); % all colors gray 
colorRecLIST = [127 127 127; 255 50 255; 100 72 255; 27 82 27]/255;

% color for individual selected records in different databases

%% step-2 Use GMPM and target Sa (from PSHA) to obtain \eps_bar.
fprintf('------------------------------------ \n');
fprintf('---------- Step-2/3 ---------------- \n');
fprintf('Determining eps_bar and conditional mean spectrum ...\n');
% M_bar = 7.30; % 2475 years deaggregation; use H:\UniformRiskMap\DeaggProc\masterScript_deaggregationBatch_v1.m
% Rjb_bar = 30;
% eps_bar_Deagg = 0.00; % (NOT USED) informative only, 'cause the median IM won't match for this eps
% Vs30 = 450; % rock site 
% faultType = 'Normal'; % for Location-1
% faultType = 'Thrust'; % for Location-2
% For location-1, used BSSA14, CB14, CY14, ASK14, and SRNG with 0.2 for each.
% For location-2, used BYHydro16_Sub, Zhao2016, Kanno06, AB03_SZ, and Youngs97 with 0.2 for each.
% GMPM = 'CB14'; % I am using 'CB14' for Location-1 and 'BCH16' for Location-2 
% GMPM = 'BA08'; % 'CB08', 'BA08', 'BSSA14', 'CB14', 'BCH16' (for epsilon calculation) step-2 options 
                 % edit step 3 function to add more GMPMs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% step-3 Select ground motion recordings that will produce the intended target hazard.
fprintf('------------------------------------ \n');
fprintf('---------- Step-3/3 ---------------- \n');
fprintf('Selecting ground motion records ...\n');
% nGM        = 5; % Number of ground motions to be selected
% T1         = timeP; % Period at which spectra should be scaled and matched. Usually, the structure's fundamental period.
% T_range    = [0.2*T1, 2.0*T1];
numPtsInT1 = 20; % number of divisions in target period array. Error is calculated at these points.
% isScaled   = 1; % Should spectra be scaled before matching (1 -YES, 0-NO).
% maxScale   = 2; % Maximum allowable scale factor.
weights    = [1.0 5.0]; % [Weight for error in mean, Weight for error in standard deviation] e.g., [1.0,1.0] - equal weight for both errors.
nLoop      = 2; % This is a meta-variable of the algorithm. The greedy improvement technique does several passes over the available
                % data set and tries to improve the selected records. This variable denotes the number of passes. Recommended value: 2.
penalty    = 0; % If a penalty needs to be applied to avoid selecting spectra that have spectral acceleration values beyond 3 sigma at any
                % of the periods, set a value here. Use 0 otherwise.
% notAllowed = []; % List of record numbers that should not be considered for selection. Use [] to consider all available records. This can
                 % be used to prevent certain magnitude-distance-Vs30 records from being selected, if desired.
checkCorr  = 0; % If 1, this runs a code that compares the correlation structure of the selected ground motions to the correlations
                % published by Baker and Jayaram (2008).
seedValue  = 0; % For repeatability. For a particular seedValue not equal to zero, the code will output the same set of ground motions.
                % The set will change when the seedValue changes. If set to zero, the code randomizes the algorithm and different sets of
                % ground motions (satisfying the target mean and variance) are generated each time.
% dirNameForSaving = dirNameForSaving; % Folder name for storing .dat and figures
% M_bar = M_bar; % Magnitude of the target scenario earthquake
% R_bar     = Rjb_bar; % Distance corresponding to the target scenario earthquake
% eps_bar   = epsilon_bar; % Epsilon value for the target scenario
% Vs30 = Vs30; % Average shear wave velocity in the top 30m of the soil, used to model local site effects (m/s)
arb       = 0; % 1 for arbitrary component sigma; 0 for average component sigma
showPlots = 1; % 1 to display plots; 0 otherwise
% useVar    = 1; % 0 to set target variance to zero, 1 to compute target variance using ground-motion model

if ~isequal(size(databaseLIST), size(nGMLIST))
    error('The size of Array of numGroundMotion requested is not same size as the number of databases'); 
end
recSelected = []; scaleFactors = []; 
mag = []; Rjb = []; closest_D = []; Vs30_rec = [];

GMSelectionInputs.NGA_W2.forbiddenRecs = [];
GMSelectionInputs.KiK_NET.forbiddenRecs = [];

for i = 1:size(databaseLIST, 1)
    tectonic = tectonicLIST{i, 1};
    databaseToUse = databaseLIST{i, 1}; nGM = nGMLIST(i, 1);
    M_bar = magLIST(i, 1); Rjb_bar = distLIST(i, 1);
    GMPM = GMMLIST{i, 1};
    T1 = T1_list(i, 1); IM_PSHA = SaT1_list(i, 1); 
    T_range   = [Tmin(i, 1), Tmax(i, 1)];
    mech = mechLIST{i, 1};

    dirNameForSaving = sprintf('Results_%s_%s', dirNameAndSuffix, replace(tectonic, {'/', '-'}, {'_', '_'})); % Folder name for storing .dat and figures; 

    GMSelectionInputs.tectonic = tectonic; 
    GMSelectionInputs.IM_PSHA = IM_PSHA;
    GMSelectionInputs.nGM = nGM; 
    GMSelectionInputs.T1 = T1;
    GMSelectionInputs.numPtsInT1 = numPtsInT1; 
    GMSelectionInputs.isScaled = isScaled;
    GMSelectionInputs.maxScale = maxScale; 
    GMSelectionInputs.weights = weights;
    GMSelectionInputs.nLoop = nLoop; 
    GMSelectionInputs.penalty = penalty;
    GMSelectionInputs.notAllowedFilters = notAllowedFilters; 
    GMSelectionInputs.checkCorr = checkCorr;
    GMSelectionInputs.seedValue = seedValue; 
    GMSelectionInputs.outputFile = outputFile;
    GMSelectionInputs.folderNameForSaving = dirNameForSaving;
    GMSelectionInputs.M_bar = M_bar; 
    GMSelectionInputs.Rjb_bar = Rjb_bar;
    GMSelectionInputs.Vs30 = Vs30;
    GMSelectionInputs.arb = arb; 
    GMSelectionInputs.showPlots = showPlots;
    GMSelectionInputs.useVar = useVar; 
    GMSelectionInputs.faultType = mech;
    GMSelectionInputs.GMPM = GMPM; 
    GMSelectionInputs.gmmDir = gmmDir;
    GMSelectionInputs.T_range = T_range; 
    GMSelectionInputs.databaseToUse = databaseToUse;

%% find eps_bar; assign it to inputs and pass on to selection function  
    eps_bar = step2_compareMeanValsAndFindEps_v2(GMSelectionInputs);
    
    GMSelectionInputs.eps_bar = eps_bar; 
%% execute ground motion selection function
    selectedRecords = step3_Select_GMs_Baker_NGA_KiK(GMSelectionInputs);

    % for multiple tectonics, update forbiddenRecs before next selection
    switch databaseToUse
        case 'NGA_W2'
            GMSelectionInputs.NGA_W2.forbiddenRecs = [GMSelectionInputs.NGA_W2.forbiddenRecs; selectedRecords.ID];
        case 'KiK_NET'
            GMSelectionInputs.KiK_NET.forbiddenRecs = [GMSelectionInputs.KiK_NET.forbiddenRecs; selectedRecords.ID];
    end

    if showIntermediatePlots == 0
        all_figs = findobj(0, 'type', 'figure'); close(all_figs);
    end

    fprintf('---------------------------------------- \n');
    fprintf('--- Selected records are as follows: --- \n');
    disp(selectedRecords.ID')

    % store variables for the table in app
    recSelected = [recSelected; string(selectedRecords.ID)];
    scaleFactors = [scaleFactors; selectedRecords.scaleFactors];
    mag = [mag; selectedRecords.mag];
    Rjb = [Rjb; selectedRecords.Rjb];
    closest_D = [closest_D; selectedRecords.closest_D];
    Vs30_rec = [Vs30_rec; selectedRecords.Vs30];

    % store variables for combined plot
    selectedRecordsComb{i} = selectedRecords;

    % copy the summary of records (.dat files) for each tectonic to combined directory
    source = fullfile(dirNameForSaving, outputFile); destination = fullfile(dirCombined, ['SelectedRecs_' replace(tectonic, {'/', '-'}, {'_', '_'}) '.dat']);
    copyfile(source, destination);
end

% if M-R tuples are same for all rows, plot a single target mean-sigma 
isEqualM_R_tuple = 0;
if sum(abs(diff(magLIST))) < 1e-4 && sum(abs(diff(distLIST))) < 1e-4
    isEqualM_R_tuple = 1;
end

%% plot combined plot of individual response spectrum
    step10a_plotPSaRecordsCombined(selectedRecordsComb, colorRecLIST);

%% plot mean and sigma of different targets
    step10b_plotMeanSigmaCombined(selectedRecordsComb, isEqualM_R_tuple);
  

% save combine figures for the app
cd(dirCombined);

figure(99);
sks_figureExport('1_AllRecordsSa');
figure(88);
sks_figureExport('2_recordsMedian');
figure(77);
sks_figureExport('3_recordsSigma');


% send some info for the app
tectonic = repelem(databaseLIST, nGMLIST, 1); 
selectionResult = table(tectonic, recSelected, scaleFactors, mag, Rjb, closest_D, Vs30_rec);

cd(baseFolder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc