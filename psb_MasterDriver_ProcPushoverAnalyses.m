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

% fileNameLIST = {'ID35123_R5_12Story_v.03'};       % ID35053_R5_5Story_v.03 | ID35083_R5_8Story_v.03 | ID35123_R5_12Story_v.03 | ID46053_R5_5Story_v.04 | ID46083_R5_8Story_v.04 | ID46123_R5_12Story_v.04 
fileNameLIST = {'ID35053_R5_5Story_v.03'; 'ID35083_R5_8Story_v.03'; 'ID35123_R5_12Story_v.03'; 'ID46053_R5_5Story_v.04'; 'ID46083_R5_8Story_v.04'; 'ID46123_R5_12Story_v.04'};       

shearHingeOrNot = 0;                                                            % if there is a shear Hinge then different opensees file is used; using 1 would always work 
                                                                                % but may not be the fastest in case of haselton-type models with flexural-only hinges

% (26-Nov-2026, sks) lateral load pattern(s) to push each building with
pushoverPatternNameLIST = {'Parabolic Stiffness'};                              % 'Parabolic Stiffness' = design-sheet psb_DefinePushoverLoading.tcl as it is in the model folder: IS 1893 W h^2 floor forces split between column lines by column stiffness (original results/file names)
% pushoverPatternNameLIST = {'Parabolic', 'Linear', 'Mode Shape'};              % patterns from sks_computePushoverPatterns (W h^2, W h, W phi1); results saved as DATA_pushover_<SPO_index>.mat
                                                                                % a pattern needs MatlabInformation from an earlier run (run 'Parabolic Stiffness' once first)
allPatternNameLIST = {'Parabolic', 'Linear', 'Mode Shape'};                     % column order of sks_computePushoverPatterns -> SPO_index 1, 2, 3

%                          analyze  process  plotEach  combined  defoShape 
analyzeProcessPlotIndex = [   0        0        0         0          1  ];
                                                                                % analyze   : run OpenSees pushover (psb_RunMeanAnalysis.tcl) -- slow; set 0 if results already exist
                                                                                % process   : read OpenSees output files and build processed pushover data
                                                                                % plotEach  : per-building pushover + max story drift plots; refreshes DATA_pushover.mat
                                                                                % combined  : combined V and V/Vb,2D plots + summary table (reads DATA_pushover.mat if process = plotEach = 0)
                                                                                % defoShape : deformed shape at last pushover step


                                                
                                                
                                               
% (20-Nov-2026, sks) store the pushover curve of every building for the combined plot
numBuildings = size(fileNameLIST, 1);
numPatterns  = numel(pushoverPatternNameLIST);
pushoverCurveLIST = cell(numBuildings, numPatterns);    % each cell: [roofDriftRatio, baseShear (kN)]; column = pattern
mu_T_LIST = nan(numBuildings, numPatterns);             % period-based ductility of each building and pattern
pushoverPatternBuildingLIST = cell(numBuildings, 1);    % [numFloors x 3] patterns of each building (empty for 'Parabolic Stiffness' only)

% SPO_index of each pattern: -999 = 'Parabolic Stiffness' (single-pattern file names), 1/2/3 = column of sks_computePushoverPatterns
SPO_indexLIST = -999 * ones(1, numPatterns);
for patternIndex = 1:numPatterns
    if ~strcmp(pushoverPatternNameLIST{patternIndex}, 'Parabolic Stiffness')
        patternColumn = find(strcmp(allPatternNameLIST, pushoverPatternNameLIST{patternIndex}));
        if isempty(patternColumn)
            error('Unknown pattern "%s" - use Parabolic Stiffness, Parabolic, Linear or Mode Shape.', pushoverPatternNameLIST{patternIndex});
        end
        SPO_indexLIST(patternIndex) = patternColumn;
    end
end
% 'Parabolic Stiffness' is run LAST for each building, so the raw OpenSees files in EQ_9991 left after the loop are the Parabolic Stiffness
% ones (used by the defoShape block at the end); each pattern's deformed shape is plotted right after its own run
[~, patternOrder] = sort(SPO_indexLIST == -999);       % stable sort: patterns keep their order, 'Parabolic Stiffness' moves to the end
pushoverPatternNameLIST = pushoverPatternNameLIST(patternOrder);
SPO_indexLIST           = SPO_indexLIST(patternOrder);
if any(SPO_indexLIST > 0) && analyzeProcessPlotIndex(2) == 1 && analyzeProcessPlotIndex(1) == 0
    error(['process = 1 with a pattern needs analyze = 1: OpenSees output in EQ_9991 holds only the last pattern run. ' ...
           'Use process = 0 to re-plot already-processed patterns.']);
end


for buildingIndex = 1:size(fileNameLIST, 1)
    fileName = fileNameLIST{buildingIndex, 1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    baseFolder = pwd;
    analysisType_forPO = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
    modelFolder        = fullfile(baseFolder, 'Models', fileName);

    if any(SPO_indexLIST > 0)
        % (26-Nov-2026, sks) Parabolic / Linear / Mode Shape floor forces of this building
        pushoverPatternBuildingLIST{buildingIndex} = sks_computePushoverPatterns(modelFolder, fullfile(baseFolder, 'Output', analysisType_forPO, 'MatlabInformation'));
    end

for patternIndex = 1:numPatterns
    SPO_index = SPO_indexLIST(patternIndex);
    if SPO_index == -999
        pushoverDataFile = fullfile(baseFolder, 'Output', analysisType_forPO, 'DATA_pushover.mat');
    else
        pushoverDataFile = fullfile(baseFolder, 'Output', analysisType_forPO, sprintf('DATA_pushover_%d.mat', SPO_index));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---- (1) analyze: run OpenSees ----
if analyzeProcessPlotIndex(1) == 1
    cd(modelFolder)
    fprintf('Running %i/%i... Building: %s, pattern: %s  \n', buildingIndex, numBuildings, fileName, pushoverPatternNameLIST{patternIndex});
    if SPO_index == -999
        setenv('PUSHOVER_LATERALFORCE_ON_FLOORS', '');      % 'Parabolic Stiffness': psb_RunPushoverIfSpecified.tcl uses the design-sheet psb_DefinePushoverLoading.tcl
        [pushoverLateralForceOnFloors, loadedNodeLIST, forceOnNodeLIST] = readDesignSheetForceOnFloors(modelFolder);
        floorNumLIST = (numel(pushoverLateralForceOnFloors) + 1):-1:2;           % roof first
        fprintf('Lateral force on floors, %s pattern (design sheet, roof first, adds up to 1.0):\n', pushoverPatternNameLIST{patternIndex});
        fprintf('    Floor %2d: %.10f\n', [floorNumLIST; pushoverLateralForceOnFloors']);
        fprintf('Nodal lateral loads, %s pattern (as in psb_DefinePushoverLoading.tcl, split by column stiffness):\n', pushoverPatternNameLIST{patternIndex});
        printPushoverNodalLoads(loadedNodeLIST, forceOnNodeLIST);
        system('OpenSees psb_RunMeanAnalysis.tcl');
    else
        % (26-Nov-2026, sks) lateral force at each floor (roof first) of this pattern, passed to OpenSees as an environment
        % variable; psb_RunPushoverIfSpecified.tcl shares it 1/6, 2/6, 2/6, 1/6 between the column lines. No file is written.
        pushoverLateralForceOnFloors = pushoverPatternBuildingLIST{buildingIndex}(:, SPO_index);
        setenv('PUSHOVER_LATERALFORCE_ON_FLOORS', sprintf('%.10f ', pushoverLateralForceOnFloors));
        floorNumLIST = (numel(pushoverLateralForceOnFloors) + 1):-1:2;           % roof first
        fprintf('Lateral force on floors, %s pattern (SPO_index = %d, roof first, adds up to 1.0):\n', ...
            pushoverPatternNameLIST{patternIndex}, SPO_index);
        fprintf('    Floor %2d: %.10f\n', [floorNumLIST; pushoverLateralForceOnFloors']);
        [loadedNodeLIST, forceOnNodeLIST] = splitForceOnFloorsToNodes(pushoverLateralForceOnFloors);
        fprintf('Nodal lateral loads, %s pattern (split 1/6, 2/6, 2/6, 1/6 as in psb_RunPushoverIfSpecified.tcl):\n', pushoverPatternNameLIST{patternIndex});
        printPushoverNodalLoads(loadedNodeLIST, forceOnNodeLIST);

        % OpenSees screen output of each pattern saved in Output\<analysisType>\OpenSeesLog_SPO_<SPO_index>.txt
        openSeesLogFile = fullfile(baseFolder, 'Output', analysisType_forPO, sprintf('OpenSeesLog_SPO_%d.txt', SPO_index));
        system(sprintf('OpenSees psb_RunMeanAnalysis.tcl > "%s" 2>&1', openSeesLogFile));
        fprintf('OpenSees log: %s\n', openSeesLogFile);
        setenv('PUSHOVER_LATERALFORCE_ON_FLOORS', '');      % clear it, so nothing else run from this MATLAB session picks it up
    end
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
        storyNumLIST, isPlotPOMaxDriftLevel, determinePeriodBasedDuctility, SPO_index);
    cd(baseFolder)
    save(pushoverDataFile);                       % (6-1-16, PSB) store pushover results to plot together; DATA_pushover.mat or DATA_pushover_<SPO_index>.mat
    close all;

    % (26-Nov-2026, sks) (5) defoShape of a pattern: plotted here, right after its own run, because the hinge/joint
    % rotations are read from the raw OpenSees files in EQ_9991\Sa_0.00, which the next pattern run overwrites
    if SPO_index ~= -999 && analyzeProcessPlotIndex(1) == 1 && analyzeProcessPlotIndex(5) == 1
        plotPushoverDeformedShapeOfPattern(fileName, baseFolder, SPO_index);
    end

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
    continue;   % nothing to do for this building and pattern
end
    pushoverCurveLIST{buildingIndex, patternIndex} = plotArrayAndBaseShearArray;
    mu_T_LIST(buildingIndex, patternIndex) = mu_T;
end % patternIndex
end % buildingIndex



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% (21-Nov-2026, sks) combined pushover plots: V (kN) and V / Vb,2D, only when fileNameLIST has more than one building
buildingIDLIST = cell(numBuildings, 1);
for buildingIndex = 1:numBuildings
    buildingIDLIST{buildingIndex, 1} = extractBefore(fileNameLIST{buildingIndex, 1}, '_');   % 'ID35053_R5_5Story_v.03' -> 'ID35053'
end
mu_T_LIST(mu_T_LIST == 0) = NaN;   % 0 from processor means 0.8*Vmax not reached -> show NaN, not zero ductility
overstrengthLIST = nan(numBuildings, numPatterns);

% (26-Nov-2026, sks) one set of combined plots per pattern; 'Parabolic Stiffness' keeps the original file names
for patternIndex = 1:numPatterns
    if SPO_indexLIST(patternIndex) == -999
        patternSuffix = '';
    else
        patternSuffix = ['_', strrep(pushoverPatternNameLIST{patternIndex}, ' ', '')];   % e.g. _ModeShape
    end
if numBuildings > 1 && analyzeProcessPlotIndex(4) == 1
    % Design data per building -- SAME ORDER AS fileNameLIST
    seismicWeightBuildingLIST   = [116018; 178851; 270588; 112597; 186718; 282616];               % W, 3D building (kN)
    designBaseShearBuildingLIST = [5866.37; 6410.81; 7189.77; 17431.08; 20772.25; 23780.09];      % Vb, 3D building (kN)
    totalMassFrameLIST          = cellfun(@(modelName) sks_readFrameTotalMass(fullfile(baseFolder, 'Models', modelName)), fileNameLIST);   % m, 2D frame (kN-s^2/mm), read from "total mass is" line in each model's tcl
    gravityAccel                = 9810;                                                           % g (mm/s^2)

    designCoeffLIST          = designBaseShearBuildingLIST ./ seismicWeightBuildingLIST;          % Cs = Vb/W = Ah
    designBaseShearFrameLIST = designCoeffLIST .* totalMassFrameLIST * gravityAccel;              % Vb,2D = Cs x m x g (kN)

    combinedPushoverFolder = fullfile(baseFolder, 'Output', 'combinedPushover');   % all combined pushover figures go here
    sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST(:, patternIndex), [], plotRoofDriftRatio, lineWidth_PO, ...
         fullfile(combinedPushoverFolder, ['Pushover_Combined_AllBuildings', patternSuffix]));
    overstrengthLIST(:, patternIndex) = sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST(:, patternIndex), designBaseShearFrameLIST, plotRoofDriftRatio, lineWidth_PO, ...
        fullfile(combinedPushoverFolder, ['Normalised_BaseShear_by_DesignBaseShear', patternSuffix]));

    % (21-Nov-2026, sks) Badal & Sinha (2022) Fig. 6 style: V / W,2D with Cs,max and Cs,D marked
    seismicWeightFrameLIST = totalMassFrameLIST * gravityAccel;           % W,2D (kN)
    sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST(:, patternIndex), seismicWeightFrameLIST, plotRoofDriftRatio, lineWidth_PO, ...
        fullfile(combinedPushoverFolder, ['Normalised_BaseShear_by_SeismicWeight', patternSuffix]), designCoeffLIST);


    % (22-Nov-2026, sks) both normalization side by side: left V / Vb,2D, right V / W,2D
    sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST(:, patternIndex), {designBaseShearFrameLIST, seismicWeightFrameLIST}, plotRoofDriftRatio, lineWidth_PO, ...
        fullfile(combinedPushoverFolder, ['Normalised_BaseShear_by_DesignBaseShear_and_SeismicWeight', patternSuffix]), {[], designCoeffLIST});

    fprintf('\nPattern: %s\n', pushoverPatternNameLIST{patternIndex});
    disp(table(buildingIDLIST, mu_T_LIST(:, patternIndex), overstrengthLIST(:, patternIndex), 'VariableNames', {'buildingID', 'mu_T', 'Omega'}));
else
    fprintf('\nPattern: %s\n', pushoverPatternNameLIST{patternIndex});
    disp(table(buildingIDLIST, mu_T_LIST(:, patternIndex), 'VariableNames', {'buildingID', 'mu_T'}));   % single building or combined = 0: print mu_T only

end
end % patternIndex

% (26-Nov-2026, sks) all selected patterns of one building in one figure (load shape, pushover curves, drift profile),
% e.g. Parabolic + Linear + Mode Shape + Parabolic Stiffness; 'Parabolic Stiffness' (drawn last, on top) uses the floor sums of the
% design-sheet psb_DefinePushoverLoading.tcl as its floor forces
if analyzeProcessPlotIndex(4) == 1 && numPatterns > 1
    for buildingIndex = 1:numBuildings
        fileName           = fileNameLIST{buildingIndex, 1};
        analysisType_forPO = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
        forceOnFloorsOfPatterns = zeros(size(pushoverPatternBuildingLIST{buildingIndex}, 1), numPatterns);   % roof first, one column per pattern
        for patternIndex = 1:numPatterns
            SPO_index = SPO_indexLIST(patternIndex);
            if SPO_index == -999
                forceOnFloorsOfPatterns(:, patternIndex) = readDesignSheetForceOnFloors(fullfile(baseFolder, 'Models', fileName));
            else
                forceOnFloorsOfPatterns(:, patternIndex) = pushoverPatternBuildingLIST{buildingIndex}(:, SPO_index);
            end
        end
        sks_PushoverPlots(analysisType_forPO, forceOnFloorsOfPatterns, pushoverPatternNameLIST, baseFolder, SPO_indexLIST);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call the procedure to plot the deformed shape
% (26-Nov-2026, sks) this block is for 'Parabolic Stiffness'; patterns are plotted inside the pattern loop, right after their own run
if analyzeProcessPlotIndex(5) == 1 && any(SPO_indexLIST > 0) && analyzeProcessPlotIndex(1) == 0
    warning(['defoShape of a pattern needs analyze = 1 in the same run (raw OpenSees files in EQ_9991 hold only ' ...
             'the last pattern run) - deformed shape / hinge sequence of the patterns not plotted.']);
end
if analyzeProcessPlotIndex(5) == 1 && any(SPO_indexLIST == -999)
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotPushoverDeformedShapeOfPattern(fileName, baseFolder, SPO_index)
% (26-Nov-2026, sks) deformed shape at the last step + hinge yield sequence of ONE building for ONE pushover pattern;
% called right after that pattern's OpenSees run (raw OpenSees files in EQ_9991\Sa_0.00 hold only the last run)
underscoreLocs = strfind(fileName, '_');
bldgID         = str2double(fileName(3:underscoreLocs(1)-1));
analysisDir    = sprintf('(%s)_(AllVar)_(0.00)_(clough)', fileName);
driftPlotOption = 2;                    % drifts at the last step of the analysis
maxOnDemandCapacityRatioToPlot = 3.0;   % limit the demand/capacity ratio to 3
pushoverStepNameIdentifier = 'lastStep';

fprintf('Plotting deformed shape for pattern SPO_index = %d...\n', SPO_index);
cd(fullfile(baseFolder, 'psb_MatlabProcessors', 'MovieAndVisualProcessors'))
psb_pushoverDeformedShape(bldgID, {analysisDir}, driftPlotOption, maxOnDemandCapacityRatioToPlot, pushoverStepNameIdentifier, SPO_index);
sks_plotHingeYieldSequence(bldgID, {analysisDir}, baseFolder, '', SPO_index);
cd(baseFolder)
close all;
end


function [forceOnFloors, loadedNodeLIST, forceOnNodeLIST] = readDesignSheetForceOnFloors(modelFolder)
% (26-Nov-2026, sks) floor sums of the 'load' lines in the design-sheet <modelFolder>\psb_DefinePushoverLoading.tcl
% (the 'Parabolic Stiffness' pattern), roof first; node 2FFc3 -> floor FF; also the nodal loads themselves
loadTokens = regexp(fileread(fullfile(modelFolder, 'psb_DefinePushoverLoading.tcl')), '(?m)^\s*load\s+(\d+)\s+([0-9.eE+-]+)', 'tokens');
loadedNodeLIST  = cellfun(@(token) str2double(token{1}), loadTokens);
forceOnNodeLIST = cellfun(@(token) str2double(token{2}), loadTokens);
floorNumOfNode  = floor(loadedNodeLIST / 1000) - 200;                         % 206013 -> floor 6
forceOnFloors   = accumarray(floorNumOfNode(:) - 1, forceOnNodeLIST(:));      % floor 2 -> row 1
forceOnFloors   = flipud(forceOnFloors);                                      % roof first
end


function [loadedNodeLIST, forceOnNodeLIST] = splitForceOnFloorsToNodes(pushoverLateralForceOnFloors)
% (26-Nov-2026, sks) nodal loads exactly as psb_RunPushoverIfSpecified.tcl builds them from PUSHOVER_LATERALFORCE_ON_FLOORS
% (roof first; equal bays: end column lines 1/(2 x numBays), interior 1/numBays; load at node 2FFc3) - for printing only
numColumnLines = 4;                                     % 3 bays in all current models (same as in the Tcl file)
numBays        = numColumnLines - 1;
columnLineShareLIST = [1/(2*numBays), repmat(1/numBays, 1, numColumnLines - 2), 1/(2*numBays)];   % [1/6 2/6 2/6 1/6]
numFloors       = numel(pushoverLateralForceOnFloors);
loadedNodeLIST  = zeros(numFloors * numColumnLines, 1);
forceOnNodeLIST = zeros(numFloors * numColumnLines, 1);
for floorIndex = 1:numFloors
    floorNum = numFloors + 2 - floorIndex;              % roof first
    for columnLine = 1:numColumnLines
        nodeIndex = (floorIndex - 1) * numColumnLines + columnLine;
        loadedNodeLIST(nodeIndex)  = 200000 + floorNum*1000 + columnLine*10 + 3;     % 2FFc3
        forceOnNodeLIST(nodeIndex) = pushoverLateralForceOnFloors(floorIndex) * columnLineShareLIST(columnLine);
    end
end
end


function printPushoverNodalLoads(loadedNodeLIST, forceOnNodeLIST)
% (26-Nov-2026, sks) prints nodal pushover loads in the psb_DefinePushoverLoading.tcl format
fprintf('# node    FX      FY   MZ\n');
fprintf('load\t%d\t%.10f\t0.0\t0.0\n', [loadedNodeLIST(:)'; forceOnNodeLIST(:)']);
fprintf('# total = %.10f\n', sum(forceOnNodeLIST));
end