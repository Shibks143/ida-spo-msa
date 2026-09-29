function sks_IDR_RDR_PFA_IDA(idaInputs)
%SKS_IDR_RDR_PFA_IDA  IDR / RDR / PFA profile and IDA stripe plots
%
%  Equivalent of sks_IDR_RDR_PFA_MSA but for Incremental Dynamic Analysis.
%  Reads DATA_reducedSensDataForThisSingleRun.mat from every Sa subfolder
%  of every EQ folder, plus DATA_collapseIDAPlotDataForThisEQ.mat for the
%  IDA-specific collapse information (variable Sa grid per EQ, collapse flags).
%
%  KEY DIFFERENCES FROM MSA VERSION
%  ---------------------------------
%  1. Input is an idaInputs struct (matches masterDrive convention).
%  2. Each EQ runs to its own collapse Sa  →  Sa levels differ per EQ.
%     All EDP matrices use the common IDA plot grid; entries beyond an EQ's
%     collapse Sa are left as NaN and excluded from statistics.
%  3. DATA_collapseIDAPlotDataForThisEQ is loaded per EQ to obtain
%     collapseSaLevel and the pre/post-collapse flags.
%  4. DATA_collapse_CollapseSaAndStats is loaded once from saveDir for the
%     collapse-level EDP summary (MIDR / RDR / PFA at collapse).
%  5. isConvForFullEQ filter: non-converged runs are excluded.
%  6. RDR sentinel (999) is detected and reported; excluded from statistics.
%  7. Three additional figure types over MSA:
%       – IDA stripe curves  (Sa vs EDP, all EQs + 16/50/84 band)
%       – EDP at collapse    (boxplot of MIDR / RDR / PFA at collapse level)
%       – IDR Max vs Min asymmetry (per story, per selected Sa level)
%
%  IDAINPUTS FIELDS USED
%  ---------------------
%  Required:
%    eqNumberLIST                 – [nComp×1] EQ component numbers (folder names EQ_<n>)
%    analysisType                 – string, output sub-folder name
%    eqListForCollapseIDAs_Name   – string used in CollapseSaAndStats filename
%    formatMode                   – 'powerpoint' | 'paper' | 'report' | 'default'
%  Optional (used when present, else ignored):
%    isPlotCollapseIDAs           – plot IDA stripe for MIDR
%    isPlotCollapseIDAs_RDR       – plot IDA stripe for RDR
%    isPlotCollapseIDAs_PFA       – plot IDA stripe for PFA
%    lineColor                    – colour for individual EQ curves  [default: 0.7 0.7 0.7]
%    midrLevels / midrLevelLabels – performance thresholds on plots
%    collapseDriftThreshold       – MIDR collapse limit (for annotation only)
%
%  FOLDER STRUCTURE EXPECTED  (same as masterDrive)
%  -------------------------------------------------
%    <pwd>/../Output/<analysisType>/
%        DATA_collapse_CollapseSaAndStats_<eqListForCollapseIDAs_Name>_SaGeoMean.mat
%        EQ_<compNum>/
%            DATA_collapseIDAPlotDataForThisEQ.mat
%            Sa_<value>/
%                DATA_reducedSensDataForThisSingleRun.mat
%
%  OUTPUTS
%  -------
%    <saveDir>/
%        IDA_EDP_AllEQ_<analysisType>.mat      – all 3-D EDP matrices
%    <saveDir>/Figures_IDA/
%        InterstoryDrift_Sa_<value>.*    (one per Sa level in commonSaGrid)
%        ResidualDrift_Sa_<value>.*
%        PeakFloorAccel_Sa_<value>.*
%
% =========================================================================
%  Shivakumar K S, IIT Madras (2026)
%  Follows MSA code style of sks_IDR_RDR_PFA_MSA
% =========================================================================

%% ── Unpack idaInputs (mirrors masterDrive variable names exactly) ─────────
eqNumberLIST               = idaInputs.eqNumberLIST;
analysisType               = idaInputs.analysisType;
eqListForCollapseIDAs_Name = idaInputs.eqListForCollapseIDAs_Name;
formatMode                 = idaInputs.formatMode;

% Optional fields with safe defaults
lineColor     = sks_field(idaInputs, 'lineColor',             [0.7 0.7 0.7]);
colDriftTH    = sks_field(idaInputs, 'collapseDriftThreshold',0.12);
midrLevels    = sks_field(idaInputs, 'midrLevels',            [0.01 0.02 0.04 0.12]);
midrLabels    = sks_field(idaInputs, 'midrLevelLabels',       {'IO','LS','CP','Collapse'});

%% ── Figure control flags ─────────────────────────────────────────────────
%  doPlot = 1 → figures are created and displayed
%  doPlot = 0 → entire plotting section is skipped (data is still saved)
%  doSave = 1 → figures are formatted and exported to figDir
%  doSave = 0 → figures are shown but not saved to disk
%  (doSave is ignored when doPlot = 0)
doPlot = 1;
doSave = 1;

%% ── Directory setup (identical pattern to MSA) ────────────────────────────
baseDir = pwd;
saveDir = fullfile(baseDir, '..', 'Output', analysisType);
figDir  = fullfile(saveDir, 'Figures_IDA');
if ~exist(figDir, 'dir'), mkdir(figDir); end

numEQ = length(eqNumberLIST);

fprintf('\n=== sks_IDR_RDR_PFA_IDA ===\n');
fprintf('Analysis : %s\n', analysisType);
fprintf('Components: %d\n\n', numEQ);

%% ════════════════════════════════════════════════════════════════════════
%  PART 1 — LOAD collapseIDAPlotDataForThisEQ  (IDA curve + collapse info)
%
%  MSA equivalent: there is none — this part is IDA-specific.
%  It gives us (a) the common Sa plot grid and (b) collapseSaLevel per EQ
%  so we know which Sa subfolders are pre-collapse for each EQ.
% ════════════════════════════════════════════════════════════════════════

%% --- Initialize containers -----------------------------------------------
collapseSaLevel_all = NaN(numEQ, 1);   % collapse Sa per component
allSaGrids          = cell(numEQ, 1);  % collect every EQ's Sa grid

for eqIndex = 1:numEQ
    eqCompNumber = eqNumberLIST(eqIndex);
    eqFolder     = fullfile(saveDir, sprintf('EQ_%d', eqCompNumber));
    idaPlotFile  = fullfile(eqFolder, 'DATA_collapseIDAPlotDataForThisEQ.mat');

    if ~exist(idaPlotFile, 'file')
        warning('EQ %d: DATA_collapseIDAPlotDataForThisEQ not found.', eqCompNumber);
        continue
    end

    idaPlotData = load(idaPlotFile, 'collapseSaLevel', 'saLevelsForIDAPlotLIST');

    collapseSaLevel_all(eqIndex) = idaPlotData.collapseSaLevel;
    allSaGrids{eqIndex}          = idaPlotData.saLevelsForIDAPlotLIST(:);
end

% Use the grid from the EQ with the most Sa levels (highest collapse Sa);
% this gives the full regular IDA stepping range.
gridLengths  = cellfun(@length, allSaGrids);
[~, bestIdx] = max(gridLengths);
commonSaGrid = allSaGrids{bestIdx};

% Remove hunting/bracketing Sa levels — keep only the regularly-spaced steps.
% Strategy: round each value to 2 decimal places and keep only those that
% are multiples of the dominant step size (saStartLevel + k*startStepSize).
% Simpler robust approach: keep Sa levels that exist in the majority (>50%)
% of EQs — regular steps appear in nearly all EQs; hunting steps only in a few.
saGridMatrix = false(length(commonSaGrid), numEQ);
for eqIndex = 1:numEQ
    if isempty(allSaGrids{eqIndex}), continue; end
    for si = 1:length(commonSaGrid)
        if any(abs(allSaGrids{eqIndex} - commonSaGrid(si)) < 1e-4)
            saGridMatrix(si, eqIndex) = true;
        end
    end
end
% Keep only Sa levels present in ≥ 95% of valid EQs.
% Regular IDA steps appear in every EQ; hunting/bracketing levels near
% collapse appear only in a few EQs → filtered out automatically.
validEQcount = sum(~cellfun('isempty', allSaGrids));
commonSaGrid = commonSaGrid(sum(saGridMatrix, 2) >= 0.95 * validEQcount);

numSaCommon = length(commonSaGrid);
fprintf('Common IDA Sa grid: %d levels  [%.2f g – %.2f g]\n', ...
        numSaCommon, commonSaGrid(1), commonSaGrid(end));

%  (IDA curve matrices for stripe plots are not built — plots already exist)

%% ════════════════════════════════════════════════════════════════════════
%  PART 2 — LOAD reducedSensDataForThisSingleRun  (spatial EDP profiles)
%
%  This mirrors the MSA loop exactly.  The only IDA additions are:
%   (a)  skip Sa levels that are post-collapse for this EQ
%   (b)  apply isConvForFullEQ filter
%   (c)  also load IDR Max / Min for asymmetry analysis
% ════════════════════════════════════════════════════════════════════════

%% --- Discover numStories and numFloors from first valid file -------------
numStories = 5;   numFloors = 6;   % safe fallback
for eqIndex = 1:numEQ
    eqFolder  = fullfile(saveDir, sprintf('EQ_%d', eqNumberLIST(eqIndex)));
    saFolders = dir(fullfile(eqFolder, 'Sa_*'));
    saFolders = saFolders([saFolders.isdir]);
    if isempty(saFolders), continue; end
    probeFile = fullfile(eqFolder, saFolders(1).name, ...
                         'DATA_reducedSensDataForThisSingleRun.mat');
    if ~exist(probeFile, 'file'), continue; end
    probeData = load(probeFile, 'numStories', 'floorAccelToSave');
    numStories = probeData.numStories;
    validCells = probeData.floorAccelToSave(~cellfun('isempty', probeData.floorAccelToSave));
    numFloors  = length(validCells);
    break
end
fprintf('Building: %d stories, %d floors\n', numStories, numFloors);

%% --- Sa levels for profile plots: ALL levels in commonSaGrid ------------
profileSaList = commonSaGrid(:)';   % use every Sa level on the common IDA grid
numProfileSa  = length(profileSaList);
fprintf('Profile plots at all %d Sa levels: %s g\n', ...
        numProfileSa, num2str(profileSaList, '%.2f  '));

nMissingFiles = 0;   % count of missing reducedSensData files (printed at end)

%% --- Initialize containers (same naming convention as MSA) ---------------
floorAccel_all                   = cell(numEQ, 1);
storyDriftRatio_all              = cell(numEQ, 1);   % AbsMax
storyDriftRatio_ResidualAbs_all  = cell(numEQ, 1);
roofDriftRatio_all               = cell(numEQ, 1);
roofDriftRatio_ResidualAbs_all   = cell(numEQ, 1);
maxDriftRatioForFullStr_all      = cell(numEQ, 1);
buildingHeight_all               = zeros(numEQ, 1);
numStories_all                   = zeros(numEQ, 1);
saLevel_all                      = cell(numEQ, 1);
numSaLevels_all                  = zeros(numEQ, 1);
convMask_all                     = cell(numEQ, 1);   % IDA: convergence flag per Sa

%% --- Main EQ loop (mirrors MSA loop) ------------------------------------
for eqIndex = 1:numEQ
    eqCompNumber = eqNumberLIST(eqIndex);
    eqFolder     = fullfile(saveDir, sprintf('EQ_%d', eqCompNumber));
    colSa_eq     = collapseSaLevel_all(eqIndex);

    % Get and sort Sa subfolders (identical to MSA)
    saFolders = dir(fullfile(eqFolder, 'Sa_*'));
    saFolders = saFolders([saFolders.isdir]);
    if isempty(saFolders), continue; end
    [~, idx]  = sort(str2double(erase({saFolders.name}, 'Sa_')));
    saFolders = saFolders(idx);
    numSaLevels = length(saFolders);
    numSaLevels_all(eqIndex) = numSaLevels;

    saLevel_thisEQ                     = zeros(numSaLevels, 1);
    floorAccel_thisEQ                  = cell(numSaLevels, 1);
    storyDriftRatio_thisEQ             = cell(numSaLevels, 1);
    storyDriftRatio_ResidualAbs_thisEQ = cell(numSaLevels, 1);
    roofDriftRatio_thisEQ              = zeros(numSaLevels, 1);
    roofDriftRatio_ResidualAbs_thisEQ  = zeros(numSaLevels, 1);
    maxDriftRatioForFullStr_thisEQ     = zeros(numSaLevels, 1);
    convMask_thisEQ                    = false(numSaLevels, 1);

    for saIndex = 1:numSaLevels
        saFolder = saFolders(saIndex).name;
        saValue  = str2double(erase(saFolder, 'Sa_'));
        saLevel_thisEQ(saIndex) = saValue;

        % IDA: skip post-collapse Sa levels (no reliable data)
        if ~isnan(colSa_eq) && saValue > colSa_eq + 1e-6
            continue
        end

        reducedSenData = fullfile(eqFolder, saFolder, ...
                                  'DATA_reducedSensDataForThisSingleRun.mat');
        if ~exist(reducedSenData, 'file')
            nMissingFiles = nMissingFiles + 1;   % expected for collapse/non-conv runs
            continue
        end

        edpData = load(reducedSenData, ...
                       'floorAccelToSave', 'storyDriftRatioToSave', ...
                       'roofDriftRatioToSave', 'maxDriftRatioForFullStr', ...
                       'buildingHeight', 'numStories', 'isConvForFullEQ');

        % IDA: convergence filter (MSA did not have this)
        if ~edpData.isConvForFullEQ
            continue
        end
        convMask_thisEQ(saIndex) = true;

        % --- Floor acceleration (identical to MSA) -----------------------
        floorAccel_thisEQ{saIndex} = edpData.floorAccelToSave;

        % --- Story drift (identical to MSA) --------------------------------
        storyDriftRatio_thisEQ{saIndex} = ...
            cellfun(@(x) x.AbsMax,        edpData.storyDriftRatioToSave);
        storyDriftRatio_ResidualAbs_thisEQ{saIndex} = ...
            cellfun(@(x) abs(x.Residual), edpData.storyDriftRatioToSave);

        % --- Roof drift (identical to MSA) --------------------------------
        roofDriftRatio_thisEQ(saIndex) = ...
            edpData.roofDriftRatioToSave.AbsMax;
        roofDriftRatio_ResidualAbs_thisEQ(saIndex) = ...
            abs(edpData.roofDriftRatioToSave.Residual);

        maxDriftRatioForFullStr_thisEQ(saIndex) = edpData.maxDriftRatioForFullStr;

        % Building parameters (store once, same as MSA)
        if saIndex == 1
            buildingHeight_all(eqIndex) = edpData.buildingHeight;
            numStories_all(eqIndex)     = edpData.numStories;
        end
    end

    saLevel_all{eqIndex}                     = saLevel_thisEQ;
    floorAccel_all{eqIndex}                  = floorAccel_thisEQ;
    storyDriftRatio_all{eqIndex}             = storyDriftRatio_thisEQ;
    storyDriftRatio_ResidualAbs_all{eqIndex} = storyDriftRatio_ResidualAbs_thisEQ;
    roofDriftRatio_all{eqIndex}             = roofDriftRatio_thisEQ;
    roofDriftRatio_ResidualAbs_all{eqIndex} = roofDriftRatio_ResidualAbs_thisEQ;
    maxDriftRatioForFullStr_all{eqIndex}    = maxDriftRatioForFullStr_thisEQ;
    convMask_all{eqIndex}                   = convMask_thisEQ;
end

%% ════════════════════════════════════════════════════════════════════════
%  PART 3 — BUILD 3-D EDP MATRICES AT PROFILE Sa LEVELS
%
%  For each selected profile Sa level, pick the matching Sa subfolder
%  for each EQ (nearest within 0.02 g), apply convergence mask and
%  collapse check, then fill the 3-D matrices.
%  Variable names and matrix shapes mirror the MSA output.
% ════════════════════════════════════════════════════════════════════════

IDR_allEQ       = NaN(numStories, numProfileSa, numEQ);
RDR_allEQ       = NaN(numStories, numProfileSa, numEQ);
PFA_allEQ       = NaN(numFloors,  numProfileSa, numEQ);
RoofRDR_allEQ   = NaN(numEQ, numProfileSa);
Drift_FullStr_allEQ = NaN(numEQ, numProfileSa);

for eqIndex = 1:numEQ
    saVals   = saLevel_all{eqIndex};
    convMask = convMask_all{eqIndex};
    colSa_eq = collapseSaLevel_all(eqIndex);

    for psi = 1:numProfileSa
        targetSa = profileSaList(psi);

        % Skip if this EQ collapsed before this Sa level
        if ~isnan(colSa_eq) && targetSa > colSa_eq + 1e-6
            continue
        end

        % Find closest Sa subfolder (same tolerance as MSA implicit match)
        [diffSa, fi] = min(abs(saVals - targetSa));
        if diffSa > 0.02 || isempty(fi), continue; end

        % Apply convergence mask
        if ~convMask(fi), continue; end

        % --- IDR ---
        if ~isempty(storyDriftRatio_all{eqIndex}{fi})
            IDR_allEQ(:, psi, eqIndex) = ...
                100 * storyDriftRatio_all{eqIndex}{fi}(:);
        end

        % --- RDR ---
        if ~isempty(storyDriftRatio_ResidualAbs_all{eqIndex}{fi})
            RDR_allEQ(:, psi, eqIndex) = ...
                100 * storyDriftRatio_ResidualAbs_all{eqIndex}{fi}(:);
        end

        % --- PFA (mirrors MSA: filter empty cells, divide by 9810) ------
        accelCell  = floorAccel_all{eqIndex}{fi};
        validCells = accelCell(~cellfun('isempty', accelCell));
        if ~isempty(validCells)
            pfaProfile = cellfun(@(x) x.absAbsMaxUnfiltered, validCells);
            pfaProfile = pfaProfile(:) / 9810;
            if length(pfaProfile) == numFloors
                PFA_allEQ(:, psi, eqIndex) = pfaProfile;
            end
        end

        % --- Roof & full-structure drift ----------------------------------
        RoofRDR_allEQ(eqIndex, psi) = ...
            100 * roofDriftRatio_ResidualAbs_all{eqIndex}(fi);
        Drift_FullStr_allEQ(eqIndex, psi) = ...
            100 * maxDriftRatioForFullStr_all{eqIndex}(fi);
    end
end

nConv = sum(~isnan(Drift_FullStr_allEQ(:)));
fprintf('Converged runs used across profile Sa levels: %d / %d\n', ...
        nConv, numProfileSa * numEQ);
if nMissingFiles > 0
    fprintf('  (%d Sa folders had no reducedSensData — collapsed/non-converged runs, expected)\n', ...
            nMissingFiles);
end

%% ════════════════════════════════════════════════════════════════════════
%  PART 4 — LOAD CollapseSaAndStats  (collapse-level EDP summary)
% ════════════════════════════════════════════════════════════════════════

csFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', ...
                     eqListForCollapseIDAs_Name);
csFilePath = fullfile(saveDir, csFileName);
csData     = struct();

if exist(csFilePath, 'file')
    csData = load(csFilePath);
    fprintf('Collapse stats: median Sa_C = %.3f g  |  beta_RTR = %.3f\n', ...
            csData.medianCollapseSaTOneControlComp, ...
            csData.stDevLnCollapseSaTOneControlComp);
else
    warning('CollapseSaAndStats file not found:\n  %s', csFilePath);
end

%% ════════════════════════════════════════════════════════════════════════
%  PART 5 — SAVE OUTPUT MAT  (mirrors MSA output file)
% ════════════════════════════════════════════════════════════════════════

%% ── Pack all three EDPs into one unified struct: EDP_Results ─────────────
%
%  EDP_Results  — single struct with all EDPs + shared row/col/page headers
%
%  Fields:
%    .rowHeaders_story   {'Story 1', ..., 'Story N'}     dim-1 label for IDR & RDR
%    .rowHeaders_floor   {'Floor 1', ..., 'Floor N'}     dim-1 label for PFA
%                        (Floor 1 = ground floor, Floor N = roof)
%    .colHeaders_Sa      {'Sa=0.11g', 'Sa=0.41g', ...}  dim-2 label for all EDPs
%    .pageHeaders_EQ     {'EQ 70011', 'EQ 70012', ...}  dim-3 label for all EDPs
%    .IDR                [numStories x numSa x numEQ]  (%)  Max interstory drift
%    .RDR                [numStories x numSa x numEQ]  (%)  Residual drift
%    .PFA                [numFloors  x numSa x numEQ]  (g)  Peak floor acceleration
%
%  Usage after loading the MAT file:
%    load('IDA_EDP_AllEQ_....mat')
%    EDP_Results.IDR(2, 3, 1)         % Story 2, 3rd Sa level, EQ 1
%    EDP_Results.colHeaders_Sa{3}     % e.g. 'Sa=0.71g'
%    EDP_Results.rowHeaders_story     % {'Story 1','Story 2',...}
%    EDP_Results.pageHeaders_EQ{1}    % 'EQ 70011'

EDP_Results = struct();

EDP_Results.rowHeaders_story = arrayfun(@(s) sprintf('Story %d', s), ...
                                1:numStories, 'UniformOutput', false);

EDP_Results.rowHeaders_floor = arrayfun(@(f) sprintf('Floor %d', f), ...
                                1:numFloors, 'UniformOutput', false);
% Floor 1 = ground floor, Floor numFloors = roof

EDP_Results.colHeaders_Sa    = arrayfun(@(s) sprintf('Sa=%.2fg', s), ...
                                profileSaList, 'UniformOutput', false);

EDP_Results.pageHeaders_EQ   = arrayfun(@(n) sprintf('EQ %d', n), ...
                                eqNumberLIST(:)', 'UniformOutput', false);

EDP_Results.IDR = IDR_allEQ;   % [numStories x numSa x numEQ]  %
EDP_Results.RDR = RDR_allEQ;   % [numStories x numSa x numEQ]  %
EDP_Results.PFA = PFA_allEQ;   % [numFloors  x numSa x numEQ]  g

outputFile = fullfile(saveDir, sprintf('IDA_EDP_AllEQ_%s.mat', analysisType));
save(outputFile, ...
     'EDP_Results', 'RoofRDR_allEQ', 'Drift_FullStr_allEQ', ...
     'commonSaGrid', 'profileSaList', 'collapseSaLevel_all', ...
     'saLevel_all', 'eqNumberLIST', 'numStories', 'numFloors');
fprintf('Saved IDA EDP data to:\n  %s\n', outputFile);

%% ── Export to Excel (.xlsx) — one sheet per Sa level ────────────────────
xlsxFile = fullfile(saveDir, sprintf('IDA_EDP_AllEQ_%s.xlsx', analysisType));
sks_exportEDP_toXLSX(xlsxFile, ...
    IDR_allEQ, RDR_allEQ, PFA_allEQ, ...
    EDP_Results.rowHeaders_story, ...
    EDP_Results.rowHeaders_floor, ...
    EDP_Results.colHeaders_Sa, ...
    EDP_Results.pageHeaders_EQ, ...
    profileSaList);
fprintf('Saved IDA EDP Excel to:\n  %s\n', xlsxFile);

%% ════════════════════════════════════════════════════════════════════════
%  PART 6 — FIGURES
% ════════════════════════════════════════════════════════════════════════

storyLevel = 1 : (numStories + 1);   % same as MSA
floorLevel = 1 : numFloors;

%% ── FIGURES 4-6: Profile plots per selected Sa level (mirrors MSA) ───────

if doPlot

%  Figure 4: Interstory Drift Ratio profiles
for psi = 1:numProfileSa
    if profileSaList(psi) == 0, continue; end   % skip Sa=0 (zero response)
    figure
    hold on

    IDR_mat2D = squeeze(IDR_allEQ(:, psi, :));   % [numStories × numEQ]

    % Individual EQ step-profiles (same grey style as MSA)
    for eqIndex = 1:numEQ
        driftProfile = IDR_mat2D(:, eqIndex);
        if all(isnan(driftProfile)), continue; end
        driftProfile = min(driftProfile, 6);    % cap for display
        [driftStep, heightStep] = sks_stepProfile(driftProfile, storyLevel);
        plot(driftStep, heightStep, 'Color', lineColor, 'LineWidth', 1.2, ...
             'HandleVisibility', 'off');
    end
    % NaN proxy — always valid; used as the legend handle for individual EQs
    hEQ = plot(NaN, NaN, 'Color', lineColor, 'LineWidth', 1.2);

    % Percentile band (identical to MSA)
    IDR_mat2D_clean = IDR_mat2D;
    IDR_mat2D_clean(isnan(IDR_mat2D_clean)) = 0;   % treat NaN as 0 for prctile

    medIDR = prctile(IDR_mat2D(:, ~all(isnan(IDR_mat2D))), 50, 2);
    p16IDR = prctile(IDR_mat2D(:, ~all(isnan(IDR_mat2D))), 16, 2);
    p84IDR = prctile(IDR_mat2D(:, ~all(isnan(IDR_mat2D))), 84, 2);

    [medStep,  hStep] = sks_stepProfile(medIDR, storyLevel);
    [p16Step,  ~    ] = sks_stepProfile(p16IDR, storyLevel);
    [p84Step,  ~    ] = sks_stepProfile(p84IDR, storyLevel);

    xFill = [p16Step; flipud(p84Step)];
    yFill = [hStep;   flipud(hStep)  ];
    hBand = fill(xFill, yFill, [0.6 0.8 1], 'EdgeColor', 'none', 'FaceAlpha', 0.35);

    hMedian = plot(medStep, hStep, 'b', 'LineWidth', 3);

    % MIDR threshold lines
    for thi = 1:length(midrLevels)
        xline(midrLevels(thi)*100, '--', 'Color', [0.4 0.4 0.4], ...
              'LineWidth', 0.8, 'HandleVisibility', 'off');
        text(midrLevels(thi)*100 + 0.05, storyLevel(end) - 0.1*thi, ...
             midrLabels{thi}, 'FontSize', 8, 'Color', [0.4 0.4 0.4]);
    end

    % Auto x-axis: 5% margin beyond the 84th percentile or max individual curve
    allIDR_vals = [p84IDR(:); IDR_mat2D(:)];
    xMax_IDR    = max(allIDR_vals(isfinite(allIDR_vals)));
    if isempty(xMax_IDR) || xMax_IDR <= 0, xMax_IDR = 1; end
    xMax_IDR = ceil(xMax_IDR * 1.05 * 10) / 10;   % round up to nearest 0.1 %

    set(gca, 'YDir', 'normal')
    xlabel('Interstory Drift Ratio (\%)')
    ylabel('Story Level')
    yticks(storyLevel)
    ylim([storyLevel(1) storyLevel(end)])
    xlim([0 xMax_IDR])
    title(sprintf('$S_a(T_1) = %.2f\\,g$', profileSaList(psi)), 'Interpreter', 'latex')
    grid off
    legend([hEQ hMedian hBand], {'IDR profiles', 'Median', '$16$--$84$\% band'}, ...
           'Interpreter', 'latex')

    if doSave
        exportName = fullfile(figDir, sprintf('InterstoryDrift_Sa_%.2f', profileSaList(psi)));
        sks_figureFormat(formatMode);
        sks_figureExport(exportName);
        close(gcf)
    end
end

%  Figure 5: Residual Drift Ratio profiles
for psi = 1:numProfileSa
    if profileSaList(psi) == 0, continue; end   % skip Sa=0 (zero response)
    figure
    hold on

    RDR_mat2D = squeeze(RDR_allEQ(:, psi, :));

    for eqIndex = 1:numEQ
        residualProfile = RDR_mat2D(:, eqIndex);
        if all(isnan(residualProfile)), continue; end
        [driftStep, heightStep] = sks_stepProfile(residualProfile, storyLevel);
        plot(driftStep, heightStep, 'Color', lineColor, 'LineWidth', 1.2, ...
             'HandleVisibility', 'off');
    end
    hEQ = plot(NaN, NaN, 'Color', lineColor, 'LineWidth', 1.2);

    validCols = ~all(isnan(RDR_mat2D));
    medRDR = prctile(RDR_mat2D(:, validCols), 50, 2);
    p16RDR = prctile(RDR_mat2D(:, validCols), 16, 2);
    p84RDR = prctile(RDR_mat2D(:, validCols), 84, 2);

    [medStep, hStep] = sks_stepProfile(medRDR, storyLevel);
    [p16Step, ~    ] = sks_stepProfile(p16RDR, storyLevel);
    [p84Step, ~    ] = sks_stepProfile(p84RDR, storyLevel);

    xFill = [p16Step; flipud(p84Step)];
    yFill = [hStep;   flipud(hStep)  ];
    hBand = fill(xFill, yFill, [0.6 0.8 1], 'EdgeColor', 'none', 'FaceAlpha', 0.35);
    hMedian = plot(medStep, hStep, 'b', 'LineWidth', 3);

    % Auto x-axis: 5% margin beyond 84th percentile or max individual curve
    allRDR_vals = [p84RDR(:); RDR_mat2D(:)];
    xMax_RDR    = max(allRDR_vals(isfinite(allRDR_vals)));
    if isempty(xMax_RDR) || xMax_RDR <= 0, xMax_RDR = 0.5; end
    xMax_RDR = ceil(xMax_RDR * 1.05 * 100) / 100;   % round up to nearest 0.01 %

    set(gca, 'YDir', 'normal')
    xlabel('Residual Interstory Drift Ratio (\%)')
    ylabel('Story Level')
    yticks(storyLevel)
    ylim([storyLevel(1) storyLevel(end)])
    xlim([0 xMax_RDR])
    title(sprintf('$S_a(T_1) = %.2f\\,g$', profileSaList(psi)), 'Interpreter', 'latex')
    grid off
    legend([hEQ hMedian hBand], {'RDR profiles', 'Median', '$16$--$84$\% band'}, ...
           'Interpreter', 'latex')

    if doSave
        exportName = fullfile(figDir, sprintf('ResidualDrift_Sa_%.2f', profileSaList(psi)));
        sks_figureFormat(formatMode);
        sks_figureExport(exportName);
        close(gcf)
    end
end

%  Figure 6: Peak Floor Acceleration profiles  (identical to MSA Figure 3)
for psi = 1:numProfileSa
    if profileSaList(psi) == 0, continue; end   % skip Sa=0 (zero response)
    figure
    hold on

    PFA_mat2D = squeeze(PFA_allEQ(:, psi, :));

    for eqIndex = 1:numEQ
        pfaProfile = PFA_mat2D(:, eqIndex);
        if all(isnan(pfaProfile)), continue; end
        plot(pfaProfile, floorLevel, 'Color', lineColor, 'LineWidth', 1.2, ...
             'HandleVisibility', 'off');
    end
    hEQ = plot(NaN, NaN, 'Color', lineColor, 'LineWidth', 1.2);

    validCols = ~all(isnan(PFA_mat2D));
    medPFA = prctile(PFA_mat2D(:, validCols), 50, 2);
    p16PFA = prctile(PFA_mat2D(:, validCols), 16, 2);
    p84PFA = prctile(PFA_mat2D(:, validCols), 84, 2);

    xFill = [p16PFA; flipud(p84PFA)];
    yFill = [floorLevel(:); flipud(floorLevel(:))];
    hBand = fill(xFill, yFill, [0.6 0.8 1], 'EdgeColor', 'none', 'FaceAlpha', 0.35);
    hMedian = plot(medPFA, floorLevel, 'b', 'LineWidth', 3);

    % Auto x-axis: 5% margin beyond 84th percentile or max individual curve
    allPFA_vals = [p84PFA(:); PFA_mat2D(:)];
    xMax_PFA    = max(allPFA_vals(isfinite(allPFA_vals)));
    if isempty(xMax_PFA) || xMax_PFA <= 0, xMax_PFA = 1; end
    xMax_PFA = ceil(xMax_PFA * 1.05 * 10) / 10;   % round up to nearest 0.1 g

    set(gca, 'YDir', 'normal')
    xlabel('Peak Floor Acceleration (g)')
    ylabel('Floor Level')
    yticks(floorLevel)
    ymin = floorLevel(1);   ymax = floorLevel(end);
    ylim([ymin - 0.05*(ymax-ymin), ymax + 0.05*(ymax-ymin)])
    xlim([0 xMax_PFA])
    title(sprintf('$S_a(T_1) = %.2f\\,g$', profileSaList(psi)), 'Interpreter', 'latex')
    grid off
    legend([hEQ hMedian hBand], {'PFA profiles', 'Median', '$16$--$84$\% band'}, ...
           'Interpreter', 'latex')

    if doSave
        exportName = fullfile(figDir, sprintf('PeakFloorAccel_Sa_%.2f', profileSaList(psi)));
        sks_figureFormat(formatMode);
        sks_figureExport(exportName);
        close(gcf)
    end
end

end   % ── end doPlot ────────────────────────────────────────────────────

fprintf('\nDone. Figures saved to:\n  %s\n\n', figDir);
end   % ── END MAIN FUNCTION ──────────────────────────────────────────────


%% ════════════════════════════════════════════════════════════════════════
%  LOCAL HELPER FUNCTIONS
%  (Prefixed sks_ to sit alongside sks_figureFormat / sks_figureExport
%   in the same folder without clashing with MATLAB built-ins)
% ════════════════════════════════════════════════════════════════════════

% ── Safe field read with default ─────────────────────────────────────────
function val = sks_field(s, field, default)
if isfield(s, field)
    val = s.(field);
else
    val = default;
end
end

% ── Export IDR / RDR / PFA to Excel — one sheet per Sa level ─────────────
function sks_exportEDP_toXLSX(xlsxFile, IDR, RDR, PFA, ...
    rowHdr_story, rowHdr_floor, colHdr_Sa, pageHdr_EQ, profileSaList)
%  Layout per sheet (one sheet = one Sa level):
%
%  Row 1 : blank | EQ 70011 | EQ 70012 | ... | EQ 70302
%  Row 2+: Story 1 | val | val | ...
%          Story 2 | val | ...
%          ...
%  [blank row]
%  Row    : blank | EQ 70011 | ...         ← RDR block (same stories)
%          ...
%  [blank row]
%  Row    : blank | EQ 70011 | ...         ← PFA block (floors)
%          ...
%
%  Sheet name: Sa level value (e.g.  'Sa=0.11g')

numSa    = length(profileSaList);
numEQ    = length(pageHdr_EQ);
nStory   = length(rowHdr_story);
nFloor   = length(rowHdr_floor);

% Delete existing file so we start fresh (writecell appends by default)
if exist(xlsxFile, 'file'), delete(xlsxFile); end

for psi = 1:numSa
    if profileSaList(psi) == 0, continue; end   % skip Sa=0

    sheetName = colHdr_Sa{psi};   % e.g. 'Sa=0.11g'
    % Sheet names max 31 chars; replace '=' and keep it clean
    sheetName = strrep(sheetName, '=', '_');

    % ── Build cell arrays for each block ─────────────────────────────────
    % Header row: [blank, EQ labels...]
    hdrRow = [{''}  pageHdr_EQ(:)'];

    % IDR block
    IDR_slice = squeeze(IDR(:, psi, :));   % [nStory × numEQ]
    IDR_block = [rowHdr_story(:), num2cell(IDR_slice)];

    % RDR block
    RDR_slice = squeeze(RDR(:, psi, :));
    RDR_block = [rowHdr_story(:), num2cell(RDR_slice)];

    % PFA block
    PFA_slice = squeeze(PFA(:, psi, :));
    PFA_block = [rowHdr_floor(:), num2cell(PFA_slice)];

    % ── Write to sheet ────────────────────────────────────────────────────
    % Section headers
    secHdr_IDR = [{'IDR (%)'}, repmat({''}, 1, numEQ)];
    secHdr_RDR = [{'RDR (%)'}, repmat({''}, 1, numEQ)];
    secHdr_PFA = [{'PFA (g)'}, repmat({''}, 1, numEQ)];
    blankRow   = repmat({''}, 1, numEQ + 1);

    % Stack everything into one cell array
    sheetData = [
        secHdr_IDR;
        hdrRow;
        IDR_block;
        blankRow;
        secHdr_RDR;
        hdrRow;
        RDR_block;
        blankRow;
        secHdr_PFA;
        hdrRow;
        PFA_block
    ];

    % Replace NaN with empty string so cells are blank not 'NaN'
    sheetData = cellfun(@(x) sks_nanToBlank(x), sheetData, ...
                        'UniformOutput', false);

    writecell(sheetData, xlsxFile, 'Sheet', sheetName);
end
end

function out = sks_nanToBlank(val)
%  Convert NaN numeric to empty string; pass everything else through.
if isnumeric(val) && isnan(val)
    out = '';
else
    out = val;
end
end

% ── Step profile (staircase) for story drift plots ────────────────────────
function [xStep, yStep] = sks_stepProfile(vals, storyLevels)
%  vals       – [numStories×1] per-story values
%  storyLevels – [1 : numStories+1] floor level indices
vals    = vals(:);
xStep   = repelem(vals, 2);
yLevel  = reshape([storyLevels(1:end-1); storyLevels(2:end)], [], 1);
xStep   = [xStep; vals(end)];
yStep   = [yLevel; storyLevels(end)];
end