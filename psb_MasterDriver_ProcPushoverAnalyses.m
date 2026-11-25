% Procedure: MasterDriver_ProcessPushoverAnalyses.m
% -------------------
% This processes the pushover (monotonic and cyclic) analyses, then
% makes/saves all of the results.
%
% Assumptions and Notices: 
%   - none

clear; % keep: save stores the whole workspace, so start clean
tic 

baseFolder = pwd;

% Automatically detect current root directory (works on both Windows and Linux HPC)
rootDir = fileparts(mfilename('fullpath'));

% Add code folders to MATLAB search path
addpath(genpath(fullfile(rootDir, 'psb_MatlabProcessors')));
addpath(genpath(fullfile(rootDir, 'psb_IntensityMeasures')));
addpath(genpath(fullfile(rootDir, 'OpenSeesProcessingFiles')));
addpath(genpath(fullfile(rootDir, 'Models')));

%% This one for running script at HPC (Paramshakti); added on 02-sep-2026
if isunix
    setenv('PATH', ['/home/apps/MLDL/DL-CondaPy3/envs/opensees/bin:' getenv('PATH')]);
end


%% Conventional code starts from here

fileNameLIST = {'ID35123_R5_12Story_v.03'};       % ID35053_R5_5Story_v.03 | ID35083_R5_8Story_v.03 | ID35123_R5_12Story_v.03 | ID46053_R5_5Story_v.04 | ID46083_R5_8Story_v.04 | ID46123_R5_12Story_v.04 
% fileNameLIST = {'ID35053_R5_5Story_v.03'; 'ID35083_R5_8Story_v.03'; 'ID35123_R5_12Story_v.03'; 'ID46053_R5_5Story_v.04'; 'ID46083_R5_8Story_v.04'; 'ID46123_R5_12Story_v.04'};       

shearHingeOrNot = 0;                                                            % if there is a shear Hinge then different opensees file is used; using 1 would always work 
                                                                                % but may not be the fastest in case of haselton-type models with flexural-only hinges



%                          analyze  process  plotEach  combined  defoShape 
analyzeProcessPlotIndex = [   0        0        0         0          1  ];
                                                                                % analyze   : run OpenSees pushover (psb_RunMeanAnalysis.tcl) -- slow; set 0 if results already exist
                                                                                % process   : read OpenSees output files and build processed pushover data
                                                                                % plotEach  : per-building pushover + max story drift plots; refreshes DATA_pushover.mat
                                                                                % combined  : combined V and V/Vb,2D plots + summary table (reads DATA_pushover.mat if process = plotEach = 0)
                                                                                % defoShape : deformed shape at last pushover step


                                                
                                                
                                               
% (20-Nov-2026, sks) store the pushover curve of every building for the combined plot
numBuildings = size(fileNameLIST, 1);
pushoverCurveLIST = cell(numBuildings, 1);      % each cell: [roofDriftRatio, baseShear (kN)]
mu_T_LIST = nan(numBuildings, 1);               % period-based ductility of each building


for buildingIndex = 1:size(fileNameLIST, 1)
    fileName = fileNameLIST{buildingIndex, 1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    baseFolder = pwd;
    analysisType_forPO = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
    pushoverDataFile   = fullfile(baseFolder, 'Output', analysisType_forPO, 'DATA_pushover.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- (1) analyze: run OpenSees ----
if analyzeProcessPlotIndex(1) == 1
    cd(fullfile(baseFolder, 'Models', fileName))
    fprintf('Running %i/%i... Building: %s  \n', buildingIndex, numBuildings, fileName);
    system('OpenSees psb_RunMeanAnalysis.tcl');
    cd(baseFolder)
end


% Set the options for processing and plotting
    % Stuff to change
    eqNumber_PO = 9991;                     % 9991 for monotonic, 9992 for cyclic
    isProcessPOAnalysis = analyzeProcessPlotIndex(2);   % (2) process: 1 = read OpenSees output again, 0 = use already-processed data
  
    isPlotPO = 1;                           % keep 1: PlotPushover is what returns the curve and mu_T (0 -> error)
    plotRoofDriftRatio = 1;                 % Plot roof drift ratio instead of roof displacement.
    determinePeriodBasedDuctility = 1;      % (10-28-15, PSB) FEMA-P695 sec 6.3 to find out period-based ductility
    
    isPlotStoryPO = 0;                      % This plots the story POs versus story shear and base shear both.  The 
                                            % processors that this calls were fixed and updated by CBH on 6-16-08.
    storyNumLIST = [2];                     % Stories to plot story PO
    
    isPlotPOMaxDriftLevel = analyzeProcessPlotIndex(3); % (3) plotEach: interstory drift ratio vs floor number
    
    maxNumPoints = 10000000;                % Large number does not limit the length of the plot       
    markerType_PO = 'b-';
    lineWidth_PO = 3;
    
    % No need to change this stuff
    poModelType = 2;                        % Always use 2; 1 for nlBmCol/dispBmCol, 2 for lumpedPlasticity
    saTOneForRun_PO = 0.00;                 % Always use 0.00
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call the procedure to do the processing and plotting
% ---- (2)+(3) process and/or plot each building ----
if analyzeProcessPlotIndex(2) == 1 || analyzeProcessPlotIndex(3) == 1
    cd psb_MatlabProcessors
    [plotArrayAndBaseShearArray, mu_T] = ProcessAndPlotPushoverAnalyses_proc(analysisType_forPO, isProcessPOAnalysis, poModelType, saTOneForRun_PO, ...
        eqNumber_PO, isPlotPO, plotRoofDriftRatio, maxNumPoints, markerType_PO, lineWidth_PO, isPlotStoryPO, ...
        storyNumLIST, isPlotPOMaxDriftLevel, determinePeriodBasedDuctility);
    cd(baseFolder)
    cd(fullfile('Output', analysisType_forPO))
    save('DATA_pushover.mat');                    % (6-1-16, PSB) store pushover results to plot together
    cd(baseFolder)
    close all;

    % ---- (4) combined only: reuse saved results, no processing ----
elseif analyzeProcessPlotIndex(4) == 1
    if ~isfile(pushoverDataFile)
        error('%s not found - run once with process = 1 or plotEach = 1.', pushoverDataFile);
    end
    savedData = load(pushoverDataFile, 'plotArrayAndBaseShearArray', 'mu_T');   % only these two, not the whole saved workspace
    plotArrayAndBaseShearArray = savedData.plotArrayAndBaseShearArray;
    mu_T = NaN;
    if isfield(savedData, 'mu_T'), mu_T = savedData.mu_T; end                   % older DATA files may not contain mu_T
else
    continue;   % nothing to do for this building
end
    pushoverCurveLIST{buildingIndex, 1} = plotArrayAndBaseShearArray;
    mu_T_LIST(buildingIndex, 1) = mu_T;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% (21-Nov-2026, sks) combined pushover plots: V (kN) and V / Vb,2D, only when fileNameLIST has more than one building
buildingIDLIST = cell(numBuildings, 1);
for buildingIndex = 1:numBuildings
    buildingIDLIST{buildingIndex, 1} = extractBefore(fileNameLIST{buildingIndex, 1}, '_');   % 'ID35053_R5_5Story_v.03' -> 'ID35053'
end
mu_T_LIST(mu_T_LIST == 0) = NaN;   % 0 from processor means 0.8*Vmax not reached -> show NaN, not zero ductility

if numBuildings > 1 && analyzeProcessPlotIndex(4) == 1
    % Design data per building -- SAME ORDER AS fileNameLIST
    seismicWeightBuildingLIST   = [116018; 178851; 270588; 112597; 186718; 282616];               % W, 3D building (kN)
    designBaseShearBuildingLIST = [5866.37; 6410.81; 7189.77; 17431.08; 20772.25; 23780.09];      % Vb, 3D building (kN)
    totalMassFrameLIST          = cellfun(@(modelName) sks_readFrameTotalMass(fullfile(baseFolder, 'Models', modelName)), fileNameLIST);   % m, 2D frame (kN-s^2/mm), read from "total mass is" line in each model's tcl
    gravityAccel                = 9810;                                                           % g (mm/s^2)

    designCoeffLIST          = designBaseShearBuildingLIST ./ seismicWeightBuildingLIST;          % Cs = Vb/W = Ah
    designBaseShearFrameLIST = designCoeffLIST .* totalMassFrameLIST * gravityAccel;              % Vb,2D = Cs x m x g (kN)

    combinedPushoverFolder = fullfile(baseFolder, 'Output', 'combinedPushover');   % all combined pushover figures go here
    sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST, [], plotRoofDriftRatio, lineWidth_PO, ...
         fullfile(combinedPushoverFolder, 'Pushover_Combined_AllBuildings'));
    overstrengthLIST = sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST, designBaseShearFrameLIST, plotRoofDriftRatio, lineWidth_PO, ...
        fullfile(combinedPushoverFolder, 'Normalised_BaseShear_by_DesignBaseShear'));
   
    % (21-Nov-2026, sks) Badal & Sinha (2022) Fig. 6 style: V / W,2D with Cs,max and Cs,D marked
    seismicWeightFrameLIST = totalMassFrameLIST * gravityAccel;           % W,2D (kN)
    sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST, seismicWeightFrameLIST, plotRoofDriftRatio, lineWidth_PO, ...
        fullfile(combinedPushoverFolder, 'Normalised_BaseShear_by_SeismicWeight'), designCoeffLIST);

 
    % (22-Nov-2026, sks) both normalization side by side: left V / Vb,2D, right V / W,2D
    sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST, {designBaseShearFrameLIST, seismicWeightFrameLIST}, plotRoofDriftRatio, lineWidth_PO, ...
        fullfile(combinedPushoverFolder, 'Normalised_BaseShear_by_DesignBaseShear_and_SeismicWeight'), {[], designCoeffLIST});

    disp(table(buildingIDLIST, mu_T_LIST, overstrengthLIST, 'VariableNames', {'buildingID', 'mu_T', 'Omega'}));
else
    disp(table(buildingIDLIST, mu_T_LIST, 'VariableNames', {'buildingID', 'mu_T'}));   % single building or combined = 0: print mu_T only
    
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call the procedure to plot the deformed shape
if analyzeProcessPlotIndex(5) == 1
    fprintf('Plotting deformed shape...\n');
        % Go to visual processors folder
        cd(fullfile('psb_MatlabProcessors', 'MovieAndVisualProcessors'))
       
    for buildingIndex = 1:size(fileNameLIST, 1)
        fileName = fileNameLIST{buildingIndex, 1};
        underscoreLocs = strfind(fileName, '_');
        bldgID_LIST(1, buildingIndex) = str2double(fileName(3:underscoreLocs(1)-1));
        analysisDirLIST{buildingIndex, 1} = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
    end
        driftPlotOption = 2;                    % Plot the drifts at the last time step of the analysis (to show the collapse mechanism better), 1- undeformed building
        maxOnDemandCapacityRatioToPlot = 3.0;   % Limit the demand/capacity ratio to 3, so the plots won't be too crazy at collapse.
        pushoverStepNameIdentifier = 'lastStep'; 

        % psb_pushoverDeformedShape(bldgID_LIST, analysisDirLIST, driftPlotOption, maxOnDemandCapacityRatioToPlot, pushoverStepNameIdentifier);

        % Movie of the pushover: hinges growing/turning red with roof drift (one frame per 0.05% roof drift)
        % sks_pushoverDeformedShapeMovie(bldgID_LIST, analysisDirLIST, 0.0005, 1.0);

        % Hinge yield sequence (floor vs roof drift at yield/capping) with the pushover curve
        sks_plotHingeYieldSequence(bldgID_LIST, analysisDirLIST, baseFolder);
        
        cd ..
        cd ..
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   toc