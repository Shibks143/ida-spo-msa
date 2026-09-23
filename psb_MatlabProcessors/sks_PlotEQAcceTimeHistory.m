clc; clear; close all; tic
% =========================================================================
% sks_PlotEQAcceTimeHistory.m  —  Ground Motion Time History: Parse → Scale → Plot
%
% FULLY SELF-CONTAINED — no external helper scripts needed.
%
% HOW TO USE — change only the TWO switches in BLOCK 1:
%
%   siteBlock  →  picks all folder paths and input files for that site/GMM
%   runMode    →  picks exactly what to do (4 clearly named options)
%
% ┌─────────────────────────────────┬────────────────────────────────────────────────────────┐
% │ runMode                         │ What it does                                           │
% ├─────────────────────────────────┼────────────────────────────────────────────────────────┤
% │ 'plot_original_unscaled'        │ Plot original records   — NO scaling                   │
% │ 'plot_curtailed_unscaled'       │ Plot curtailed records  — NO scaling                   │
% │ 'scale_and_plot_original'       │ Scale original records  by SF → save files → plot      │
% │ 'scale_and_plot_curtailed'      │ Scale curtailed records by SF → save files → plot      │
% └─────────────────────────────────┴────────────────────────────────────────────────────────┘
% ┌─────────────────────────┬──────────────────────────────────────────────┐
% │ execMode                │ What it does                                 │
% ├─────────────────────────┼──────────────────────────────────────────────┤
% │ 'full'                  │ Run all blocks (1–11)                        │
% │ 'compareOnly'           │ Parse maps (1–7) → Block 11 only             │
% └─────────────────────────┴──────────────────────────────────────────────┘

% Output folder constructed from pwd (no hardcoded output path):
%   <pwd>\..\Output\EQ_TimeHistory\<GMM>\<GMType>\
%
% Author : Shivakumar K S, IIT Madras  |  26-Mar-2026
% Units  : Time (s),  Acceleration (g)
% =========================================================================

%% ████████████████████  BLOCK 1 — ONLY TWO SWITCHES  █████████████████████

siteBlock = 'Guw_ASK14';                    % Guw_BCH16, Guw_CY14, Guw_ASK14   % <── SWITCH 1: site + GMM tag
runMode   = 'scale_and_plot_original';     % <── SWITCH 2: see table above
execMode  = 'compareOnly';                        % 'full'        → Blocks 1–11
                                           % 'compareOnly' → Blocks 1–7, then 11

%  runMode options  (copy-paste exactly):
%    'plot_original_unscaled'      → plot originalUnscaledGMs,  no SF
%    'plot_curtailed_unscaled'     → plot curtailedUnscaledGMs, no SF
%    'scale_and_plot_original'     → scale originalUnscaledGMs  → save to originalScaledGMs  → plot
%    'scale_and_plot_curtailed'    → scale curtailedUnscaledGMs → save to curtailedScaledGMs → plot

%% ████████████████████  BLOCK 2 — SITE BLOCKS  ███████████████████████████
% Each case defines rootDir, eqInfoFile, sfDatFile, GMM, siteID.
% Folder paths (unscaled/scaled) are built automatically in BLOCK 3.
% Add a new case here for every new site or GMM — nothing else changes.
% -------------------------------------------------------------------------

switch siteBlock
    
    case 'Guw_BCH16'
        rootDir    = 'E:\StaticDynamicAnalysis\ida-spo-msa\OpenSeesProcessingFiles\Site-Specifc-Guw_Time_Histories_BCH16-v4';
        eqInfoFile = fullfile(rootDir, 'defineEQInfoForMATLAB.m');
        sfDatFile  = fullfile(rootDir, '30GM_1p84_BCH16_SF5_Guw.dat');
        GMM        = 'BCH16';
        siteID     = 'Guw';

    case 'Guw_CY14'
        rootDir    = 'E:\StaticDynamicAnalysis\ida-spo-msa\OpenSeesProcessingFiles\Site-Specifc-Guw_Time_Histories_CY14';
        eqInfoFile = fullfile(rootDir, 'defineEQInfoForMATLAB.m');
        sfDatFile  = fullfile(rootDir, '30GM_1p84_CY14_SF5_Guw.dat');
        GMM        = 'CY14';
        siteID     = 'Guw';

    case 'Guw_ASK14'
        rootDir    = 'E:\StaticDynamicAnalysis\ida-spo-msa\OpenSeesProcessingFiles\Site-Specifc-Guw_Time_Histories_ASK14';
        eqInfoFile = fullfile(rootDir, 'defineEQInfoForMATLAB.m');
        sfDatFile  = fullfile(rootDir, '30GM_1p84_ASK14_SF5_Guw.dat');
        GMM        = 'ASK14';
        siteID     = 'Guw';

    otherwise
        error('Unknown siteBlock: ''%s''\nAdd a new case in BLOCK 2.', siteBlock);
end

%% ████████████████████  BLOCK 3 — RUNMODE RESOLVER  ██████████████████████
% Translates runMode into concrete settings:
%   sourceFolder  — where EQ files are READ from
%   scaledFolder  — where scaled files are WRITTEN  (only when scaling)
%   GMType        — label used in filenames and export folder
%   applyScale    — true = multiply accel × SF
%   saveSF_files  — true = write scaled TH files to scaledFolder
%
% Folder names follow your existing directory structure exactly:
%   originalUnscaledGMs\EQs   originalScaledGMs\EQs
%   curtailedUnscaledGMs\EQs  curtailedScaledGMs\EQs
% -------------------------------------------------------------------------

switch runMode

    % ── CONDITION 1: plot original unscaled — NO scaling ──────────────────
    case 'plot_original_unscaled'
        sourceFolder = fullfile(rootDir, 'originalUnscaledGMs',  'EQs');
        scaledFolder = '';                           % not used
        GMType       = 'originalUnscaledGMs';
        applyScale   = false;
        saveSF_files = false;

    % ── CONDITION 2: plot curtailed unscaled — NO scaling ─────────────────
    case 'plot_curtailed_unscaled'
        sourceFolder = fullfile(rootDir, 'curtailedUnscaledGMs', 'EQs');
        scaledFolder = '';                           % not used
        GMType       = 'curtailedUnscaledGMs';
        applyScale   = false;
        saveSF_files = false;

    % ── CONDITION 3: scale original records by SF → save → plot ───────────
    case 'scale_and_plot_original'
        sourceFolder = fullfile(rootDir, 'originalUnscaledGMs',  'EQs');
        scaledFolder = fullfile(rootDir, 'originalScaledGMs',    'EQs');
        GMType       = 'originalScaledGMs';
        applyScale   = true;
        saveSF_files = true;

    % ── CONDITION 4: scale curtailed records by SF → save → plot ──────────
    case 'scale_and_plot_curtailed'
        sourceFolder = fullfile(rootDir, 'curtailedUnscaledGMs', 'EQs');
        scaledFolder = fullfile(rootDir, 'curtailedScaledGMs',   'EQs');
        GMType       = 'curtailedScaledGMs';
        applyScale   = true;
        saveSF_files = true;

    otherwise
        error(['Unknown runMode: ''%s''\n' 'Choose one of:\n'  '  ''plot_original_unscaled''\n' ...
               '  ''plot_curtailed_unscaled''\n' '  ''scale_and_plot_original''\n' ...
               '  ''scale_and_plot_curtailed'''], runMode);
end

%% ████████████████████  BLOCK 4 — FIXED OPTIONS  █████████████████████████
% These rarely change — edit here only if needed.

formatMode   = 'report'; % 'default'|'paper'|'report'|'powerPoint'
closeFigures = 1;        % 1 = close figure after export, 0 = keep open
nCols        = 4;        % subplot columns per figure page
nRowsPerFig  = 5;        % subplot rows    per figure page

%% ████████████████████  BLOCK 5 — PARSE defineEQInfoForMATLAB.m  █████████

fprintf('==========================================================\n');
fprintf(' Site / GMM   : %s / %s\n', siteID, GMM);
fprintf(' Run mode     : %s\n', runMode);
fprintf(' GM type      : %s\n\n', GMType);
fprintf(' STEP 1 — Parsing EQ info file...\n  %s\n', eqInfoFile);

fid = fopen(eqInfoFile, 'r');
if fid < 0
    error('Cannot open eqInfoFile:\n  %s', eqInfoFile);
end
rawM = fread(fid, '*char')';
fclose(fid);

% Regex — matches every line produced by NBCC_RecordFormattingAPP:
%   dtForEQRecord(70011) = 0.005000;   numPointsForEQRecord(70011) = 6000;
%   database{70011} = 'NGA_W2';        EQID{70011} = '1166';
pat = ['dtForEQRecord\((\d+)\)\s*=\s*([\d.]+);\s*', ...
       'numPointsForEQRecord\(\d+\)\s*=\s*(\d+);\s*', ...
       'database\{\d+\}\s*=\s*''([^'']*)''\s*;\s*', ...
       'EQID\{\d+\}\s*=\s*''(\d+)''\s*;'];

tokens = regexp(rawM, pat, 'tokens');
if isempty(tokens)
    error(['No records matched in eqInfoFile.\n' ...
           'Expected NBCC app format per line:\n' ...
           '  dtForEQRecord(XXXXX)=Y; numPointsForEQRecord(XXXXX)=Z;\n' ...
           '  database{XXXXX}=''DB''; EQID{XXXXX}=''RSN'';']);
end

nRec     = numel(tokens);
EQID_arr = zeros(nRec,1);
RSN_arr  = zeros(nRec,1);
DT_arr   = zeros(nRec,1);
NP_arr   = zeros(nRec,1);

for k = 1:nRec
    t           = tokens{k};
    EQID_arr(k) = str2double(t{1});
    DT_arr(k)   = str2double(t{2});
    NP_arr(k)   = str2double(t{3});
    RSN_arr(k)  = str2double(t{5});
end

fprintf('  ✓ %d EQ records  |  %d unique RSNs\n', nRec, numel(unique(RSN_arr)));

%% ████████████████████  BLOCK 6 — PARSE SF .dat FILE  ████████████████████
% Skipped entirely when runMode does not need scaling (conditions 1 & 2).

if applyScale
    fprintf(' STEP 2 — Parsing SF dat file...\n  %s\n', sfDatFile);

    fid2 = fopen(sfDatFile, 'r');
    if fid2 < 0
        error('Cannot open sfDatFile:\n  %s', sfDatFile);
    end
    rawDat = fread(fid2, '*char')';
    fclose(fid2);

    sfTok = regexp(rawDat, '^\s*(\d+)\s+(\d+)\s+([\d.]+)\s*$', ...
                   'tokens', 'lineanchors');
    if isempty(sfTok)
        error('No SF entries found in sfDatFile.\nExpected: SNo  RSN  SF');
    end

    nSF    = numel(sfTok);
    RSN_sf = zeros(nSF,1);
    SF_val = zeros(nSF,1);
    for k = 1:nSF
        RSN_sf(k) = str2double(sfTok{k}{2});
        SF_val(k) = str2double(sfTok{k}{3});
    end
    SF_map = containers.Map(num2cell(RSN_sf), num2cell(SF_val));

    fprintf('  ✓ %d RSN→SF entries  |  SF range: %.4f – %.4f\n', ...
            nSF, min(SF_val), max(SF_val));
else
    fprintf(' STEP 2 — SF file skipped (no scaling for this runMode)\n');
    SF_map = containers.Map('KeyType','double','ValueType','double'); % empty
end

%% ████████████████████  BLOCK 7 — JOIN EQID + RSN + SF  ██████████████████

fprintf(' STEP 3 — Building lookup maps...\n');

SF_arr     = ones(nRec,1);   % default SF=1 (used as-is when not scaling)
missingRSN = false(nRec,1);

if applyScale
    for k = 1:nRec
        rsn = RSN_arr(k);
        if SF_map.isKey(rsn)
            SF_arr(k) = SF_map(rsn);
        else
            warning('RSN %d (EQID %d) not in SF file — defaulting SF=1.0', ...
                    rsn, EQID_arr(k));
            SF_arr(k)     = 1.0;
            missingRSN(k) = true;
        end
    end
    if any(missingRSN)
        fprintf('  *** WARNING: %d record(s) missing SF!\n', sum(missingRSN));
    else
        fprintf('  ✓ All RSNs matched — no missing SFs\n');
    end
else
    fprintf('  ✓ SF lookup skipped (plot-only mode)\n');
end

% O(1) lookup maps
EQID_SF_map  = containers.Map(num2cell(EQID_arr), num2cell(SF_arr));
EQID_RSN_map = containers.Map(num2cell(EQID_arr), num2cell(RSN_arr));
EQID_DT_map  = containers.Map(num2cell(EQID_arr), num2cell(DT_arr));
EQID_NP_map  = containers.Map(num2cell(EQID_arr), num2cell(NP_arr));

eqList = EQID_arr';
fprintf('==========================================================\n\n');


%% ████████████████████  BLOCK 7b — EXECMODE ROUTER  █████████████████████
% 'compareOnly' → maps already built above; skip Blocks 8–10, jump to 11.
% Guard: SF map needs real values — warn if runMode carries no scaling.
% -------------------------------------------------------------------------

% ---- execMode default (if commented out in Block 1) ---------------------
if ~exist('execMode','var') || isempty(execMode)
    execMode = 'full';     % safe default — full run, Blocks 1–11
end

% ---- Route -------------------------------------------------------------- 
switch execMode
    case 'full'
        fprintf(' execMode = full — continuing Blocks 8–10–11\n\n');

    case 'compareOnly'
        if ~applyScale
            warning(['execMode=''compareOnly'' but runMode=''%s'' loaded no SF.\n' ...
                'Panel 3 (Scaled) will show SF=1 for all records.\n' ...
                'Set runMode=''scale_and_plot_original'' for real SFs.'], runMode);
        end
        fprintf(' execMode = compareOnly — skipping Blocks 8–10, jumping to Block 11\n\n');

    otherwise
        error('Unknown execMode: ''%s''\nChoose ''full'' or ''compareOnly''.', execMode);
end

%% ████████████████████  BLOCK 8 — FOLDER SETUP  ██████████████████████████

if ~strcmp(execMode, 'compareOnly')
% Output folder — constructed from pwd, same logic as original code
    baseFolder   = fullfile(pwd, '..', 'Output', 'EQ_TimeHistory');
    exportFolder = fullfile(baseFolder, GMM, GMType);
    
    if ~exist(exportFolder,'dir'),  mkdir(exportFolder);  end
    if saveSF_files && ~exist(scaledFolder,'dir')
        mkdir(scaledFolder);
    end
    
    fprintf(' Source folder : %s\n', sourceFolder);
    fprintf(' Export folder : %s\n', exportFolder);
    if saveSF_files
        fprintf(' Scaled TH out : %s\n', scaledFolder);
    end
    fprintf('\n');

end  % execMode guard

%% ████████████████████  BLOCK 9 — PLOT LOOP  █████████████████████████████

if ~strcmp(execMode, 'compareOnly')

    N             = length(eqList);
    recordsPerFig = nCols * nRowsPerFig;
    nFigs         = ceil(N / recordsPerFig);
    
    % Pre-allocate summary storage
    allEqNums = zeros(N,1);  allRSNs  = zeros(N,1);
    allSFs    = zeros(N,1);  allDurs  = zeros(N,1);
    allPGA_u  = zeros(N,1);  allPGA_s = zeros(N,1);
    allDT     = zeros(N,1);  allNP    = zeros(N,1);
    allComp   = cell(N,1);
    eqIdx     = 0;

    for figIdx = 1:nFigs
    
        % Slice this figure's chunk of records
        startIdx = (figIdx-1)*recordsPerFig + 1;
        endIdx   = min(figIdx*recordsPerFig, N);
        eqSubset = eqList(startIdx:endIdx);
        nRows    = ceil(length(eqSubset) / nCols);
    
        
        hFig = figure('Units', 'normalized', 'Position', [0.05 0.05 0.9 0.9]);
        tiledlayout(nRows, nCols, 'TileSpacing','compact', 'Padding','compact');
    
        for i = 1:length(eqSubset)
            eqNumber = eqSubset(i);
    
            % ---- File paths -------------------------------------------------
            dtFile = fullfile(sourceFolder, sprintf('DtFile_(%d).txt',        eqNumber));
            npFile = fullfile(sourceFolder, sprintf('NumPointsFile_(%d).txt', eqNumber));
            eqFile = fullfile(sourceFolder, sprintf('SortedEQFile_(%d).txt',  eqNumber));
    
            % ---- Load dt & numPoints (file first; parsed fallback) ----------
            dt_csv = EQID_DT_map(eqNumber);
            np_csv = EQID_NP_map(eqNumber);
    
            if isfile(dtFile),  dt = load(dtFile);
            else
                warning('DtFile missing EQ %d — using parsed (%.6f s)', eqNumber, dt_csv);
                dt = dt_csv;
            end
            if isfile(npFile),  numPoints = load(npFile);
            else
                warning('NumPointsFile missing EQ %d — using parsed (%d)', eqNumber, np_csv);
                numPoints = np_csv;
            end
    
            % ---- Skip gracefully if acceleration file missing ---------------
            if ~isfile(eqFile)
                warning('SortedEQFile missing EQ %d — skipping.', eqNumber);
                nexttile; axis off; continue;
            end
    
            accel = load(eqFile);   accel = accel(:);
    
            if length(accel) ~= numPoints
                warning('EQ %d: length mismatch (file=%d, header=%d)', ...
                        eqNumber, length(accel), numPoints);
            end
    
            % ---- SF & RSN ---------------------------------------------------
            SF  = EQID_SF_map(eqNumber);
            RSN = EQID_RSN_map(eqNumber);
    
            % ---- Scale if required ------------------------------------------
            if applyScale
                accel_sc = SF .* accel;   % unscaled → scaled
            else
                accel_sc = accel;         % no scaling — same array
            end
    
            % ---- Derived quantities -----------------------------------------
            duration = round(dt * (numPoints - 1));
            time     = (0:length(accel)-1) * dt;
            PGA_u    = max(abs(accel));
            PGA_s    = max(abs(accel_sc));
    
            % ---- Write scaled files (OpenSees-ready) — only when scaling ----
            if saveSF_files
                writematrix(accel_sc,  fullfile(scaledFolder, sprintf('SortedEQFile_(%d).txt', eqNumber)));
                writematrix(dt,        fullfile(scaledFolder, sprintf('DtFile_(%d).txt',        eqNumber)));
                writematrix(numPoints, fullfile(scaledFolder, sprintf('NumPointsFile_(%d).txt', eqNumber)));
            end
    
            % ---- Collect summary row ----------------------------------------
            eqIdx            = eqIdx + 1;
            allEqNums(eqIdx) = eqNumber;
            allRSNs(eqIdx)   = RSN;
            allSFs(eqIdx)    = SF;
            allPGA_u(eqIdx)  = PGA_u;
            allPGA_s(eqIdx)  = PGA_s;
            allDurs(eqIdx)   = duration;
            allDT(eqIdx)     = dt;
            allNP(eqIdx)     = numPoints;
            if mod(eqNumber,10)==1,  allComp{eqIdx}='H1';
            else,                     allComp{eqIdx}='H2';
            end
    
            % ---- Plot tile --------------------------------------------------
            nexttile;
           
            if ~applyScale
                % ── CONDITIONS 1 & 2: plot only, no scaling ──────────────────
                plot(time, accel, 'k', 'LineWidth', 0.75);  hold on;
                yline(0, 'k-', 'LineWidth', 0.5);
                ylim([-0.5  0.5]);                             % fixed ylim (original style)
                hD = plot(nan, nan, 'k-', 'LineWidth', 0.8);   % Compact legend (same style as scaled case)
                lg = legend(hD, sprintf('%d', eqNumber), 'Location','northeast', 'Box','on', 'FontSize',7);
                lg.ItemTokenSize = [8, 4];   % [lineLength, height]
    
            else
                % ── CONDITIONS 3 & 4: blue = unscaled, red = scaled ──────────
                hU = plot(time, accel,    'b-', 'LineWidth', 0.50);  hold on;   % blue — Unscaled
                hS = plot(time, accel_sc, 'r-', 'LineWidth', 0.50);             % red  — Scaled
                hD = plot(nan, nan, 'k-', 'LineWidth', 0.8);                    % shorter, thinner swatch,     
                yline(0, 'k-', 'LineWidth', 0.4, 'HandleVisibility','off');     % zero line, hidden
                lg = legend(hD, sprintf('%d | SF=%.2f', eqNumber, SF), 'Location','northeast','Box','on','FontSize',7);
                lg.ItemTokenSize = [8, 4];   % [lineLength, height] in points
                ylim([-0.5  0.5]);
               
                % PGA annotation — top-left corner
                text(0.02, 0.97, ...
                     sprintf('$\\mathrm{PGA}_{\\mathrm{scaled}}=%.2f\\mathrm{g}$', PGA_s), ...
                     'Units','normalized','VerticalAlignment','top', ...
                     'FontSize',5.0,'Color',[0.75 0 0],'Interpreter','latex');
            end
    
            xlim([0, duration]);
            grid on;
           
            % Axis labels on outer edges only (same logic as original code)
            row = ceil(i / nCols);
            col = mod(i-1, nCols) + 1;
            if row == nRows || i > length(eqSubset) - nCols
                xlabel('Time (s)', 'Interpreter','latex');
            end
            if col == 1
                ylabel('$a_g$ (g)', 'Interpreter','latex');
            end
    
        end % record loop 
    
        % ---- Export ---------------------------------------------------------
        exportName = fullfile(exportFolder, sprintf('%s_%s_EQ_TimeHistory_Grid_%d', GMM, GMType, figIdx));
       
        % ── DIAGNOSTIC — print full path so you can confirm the folder ───────
        fprintf('\n>>> Saving to: %s\n', exportName);
        fprintf('>>> exportFolder exists: %d\n', exist(exportFolder,'dir'));
        fprintf('>>> hFig valid: %d\n', isgraphics(hFig,'figure'));
        % ─────────────────────────────────────────────────────────────────────
    
        if exist('sks_figureFormat','file')
            sks_figureFormat(formatMode);
            h_sgt.FontSize = 14;
        end
        if exist('sks_figureExport','file')
            figure(hFig);              % make hFig current so gcf inside sks_figureExport is correct
            sks_figureExport(exportName);
        else
            print(hFig, exportName, '-dpng', '-r300');
        end
    
        fprintf('Saved combined grid plot %d of %d in:\n%s\n', figIdx, nFigs, exportFolder);
        if closeFigures,  close(hFig);  end
    
    end % figure loop

end 

%% ████████████████████  BLOCK 10 — EXCEL SUMMARY  ████████████████████████
if ~strcmp(execMode, 'compareOnly')

    n = eqIdx;
    summaryTable = table( ...
        allEqNums(1:n), allRSNs(1:n), allComp(1:n), ...
        allDT(1:n),     allNP(1:n),   allDurs(1:n), ...
        allSFs(1:n),    allPGA_u(1:n), allPGA_s(1:n), ...
        'VariableNames',{'EQID','RSN','Component', ...
                         'dt_s','numPoints','Duration_s', ...
                         'ScaleFactor','PGA_Unscaled_g','PGA_Scaled_g'});
    
    xlsxName = fullfile(exportFolder, sprintf('%s_%s_EQ_Summary.xlsx', GMM, GMType));
    writetable(summaryTable, xlsxName);
    
    fprintf('\nSummary saved to:\n%s\n', xlsxName);
    if saveSF_files
        fprintf('Scaled TH files saved to:\n%s\n', scaledFolder);
    end
end

%% ████████████████████  BLOCK 11 — SIDE-BY-SIDE COMPARISON PLOTS  ████████
% Three panels per EQ record (one row), across figure pages:
%   Col 1 — originalUnscaledGMs   (blue)
%   Col 2 — curtailedUnscaledGMs  (black,  red dashed xline = curtail point)
%   Col 3 — originalScaledGMs     (blue = unscaled overlay, red = scaled)
%
% Reuses:  rootDir, GMM, siteID, eqList, formatMode, closeFigures
%          EQID_DT_map, EQID_NP_map, EQID_SF_map, EQID_RSN_map
% Exports: <pwd>\..\Output\EQ_TimeHistory\<GMM>\ComparisonPlots\
% -------------------------------------------------------------------------

fprintf('\n==========================================================\n');
fprintf(' BLOCK 11 — Side-by-side comparison plots\n');
fprintf('==========================================================\n');

% ---- Source folders (read-only; no writing here) ------------------------
b11_origUnscFolder = fullfile(rootDir, 'originalUnscaledGMs',  'EQs');
b11_curtUnscFolder = fullfile(rootDir, 'curtailedUnscaledGMs', 'EQs');
b11_origScFolder   = fullfile(rootDir, 'originalScaledGMs',    'EQs');

% ---- Export folder -------------------------------------------------------
b11_exportFolder = fullfile(pwd, '..', 'Output', 'EQ_TimeHistory', GMM, 'comparisonPlots');
if ~exist(b11_exportFolder, 'dir'),  mkdir(b11_exportFolder);  end
fprintf(' Source  — origUnsc : %s\n', b11_origUnscFolder);
fprintf(' Source  — curtUnsc : %s\n', b11_curtUnscFolder);
fprintf(' Source  — origSc   : %s\n', b11_origScFolder);
fprintf(' Export             : %s\n\n', b11_exportFolder);

% ---- Layout (reuse existing scalars where sensible) ----------------------
b11_nColsComp    = 3;           % fixed — three conditions
b11_nRowsPerFig  = nRowsPerFig; % reuse from Block 4 (default 5)
b11_yLim         = [-0.5, 0.5]; % matches Block 9 fixed ylim

b11_colTitles = {'Original Unscaled', 'Curtailed Unscaled', 'Original & Scaled'};
b11_colColors = {[0 0 0.60], [0.10 0.10 0.10], [0.65 0 0]};

% ---- Pagination ----------------------------------------------------------
b11_N      = length(eqList);
b11_nFigs  = ceil(b11_N / b11_nRowsPerFig);

% =========================================================================
for b11_figIdx = 1:b11_nFigs

    b11_startIdx = (b11_figIdx-1)*b11_nRowsPerFig + 1;
    b11_endIdx   = min(b11_figIdx*b11_nRowsPerFig, b11_N);
    b11_subset   = eqList(b11_startIdx : b11_endIdx);
    b11_nRows    = length(b11_subset);

    hFigC = figure('Units','normalized','Position',[0.03 0.03 0.94 0.94]);
    tiledlayout(b11_nRows, b11_nColsComp, 'TileSpacing','compact', 'Padding','compact');

    sgtitle(sprintf('%s  |  %s  —  Comparison  Page %d / %d', ...
            GMM, siteID, b11_figIdx, b11_nFigs), ...
            'Interpreter','none', 'FontSize',11, 'FontWeight','bold');

    % ======================================================================
    for b11_row = 1:b11_nRows

        eqNumber = b11_subset(b11_row);

        % ---- Metadata from existing maps (Block 7) -----------------------
        dt_ref = EQID_DT_map(eqNumber);
        np_ref = EQID_NP_map(eqNumber);
        SF     = EQID_SF_map(eqNumber);
        RSN    = EQID_RSN_map(eqNumber);
        if mod(eqNumber,10) == 1,  compTag = 'H1';
        else,                       compTag = 'H2';
        end

        % ---- Inline load helper — replaces nested function ---------------
        % Returns: t_vec, a_vec, dur_s, pga, ok
        %   Uses dt_ref / np_ref as fallbacks if per-folder files are missing.

        % >>> Panel 1 — originalUnscaledGMs <
        b11_eqF = fullfile(b11_origUnscFolder, sprintf('SortedEQFile_(%d).txt', eqNumber));
        b11_dtF = fullfile(b11_origUnscFolder, sprintf('DtFile_(%d).txt',        eqNumber));
        b11_npF = fullfile(b11_origUnscFolder, sprintf('NumPointsFile_(%d).txt', eqNumber));
        b11_ok1 = isfile(b11_eqF);
        if b11_ok1
            if isfile(b11_dtF), b11_dt1 = load(b11_dtF); else, b11_dt1 = dt_ref; end
            if isfile(b11_npF), b11_np1 = load(b11_npF); else, b11_np1 = np_ref; end
            b11_a1   = load(b11_eqF);  b11_a1 = b11_a1(:);
            b11_t1   = (0 : length(b11_a1)-1) * b11_dt1;
            b11_dur1 = round(b11_dt1 * (b11_np1 - 1));
            b11_pga1 = max(abs(b11_a1));
        end

        % >>> Panel 2 — curtailedUnscaledGMs <
        b11_eqF = fullfile(b11_curtUnscFolder, sprintf('SortedEQFile_(%d).txt', eqNumber));
        b11_dtF = fullfile(b11_curtUnscFolder, sprintf('DtFile_(%d).txt',        eqNumber));
        b11_npF = fullfile(b11_curtUnscFolder, sprintf('NumPointsFile_(%d).txt', eqNumber));
        b11_ok2 = isfile(b11_eqF);
        if b11_ok2
            if isfile(b11_dtF), b11_dt2 = load(b11_dtF); else, b11_dt2 = dt_ref; end
            if isfile(b11_npF), b11_np2 = load(b11_npF); else, b11_np2 = np_ref; end
            b11_a2   = load(b11_eqF);  b11_a2 = b11_a2(:);
            b11_t2   = (0 : length(b11_a2)-1) * b11_dt2;
            b11_dur2 = round(b11_dt2 * (b11_np2 - 1));
            b11_pga2 = max(abs(b11_a2));
        end

        % >>> Panel 3 — originalScaledGMs <
        b11_eqF = fullfile(b11_origScFolder, sprintf('SortedEQFile_(%d).txt', eqNumber));
        b11_dtF = fullfile(b11_origScFolder, sprintf('DtFile_(%d).txt',        eqNumber));
        b11_npF = fullfile(b11_origScFolder, sprintf('NumPointsFile_(%d).txt', eqNumber));
        b11_ok3 = isfile(b11_eqF);
        if b11_ok3
            if isfile(b11_dtF), b11_dt3 = load(b11_dtF); else, b11_dt3 = dt_ref; end
            if isfile(b11_npF), b11_np3 = load(b11_npF); else, b11_np3 = np_ref; end
            b11_a3   = load(b11_eqF);  b11_a3 = b11_a3(:);  % already scaled (written by Block 9)
            b11_t3   = (0 : length(b11_a3)-1) * b11_dt3;
            b11_dur3 = round(b11_dt3 * (b11_np3 - 1));
            b11_pga3 = max(abs(b11_a3));
        end

        % ==================================================================
        % PANEL 1 — Original Unscaled (blue)
        % ==================================================================
        nexttile((b11_row-1)*b11_nColsComp + 1);

        if b11_ok1
            plot(b11_t1, b11_a1, 'b-', 'LineWidth', 0.55);  hold on;
            yline(0, 'k-', 'LineWidth', 0.4, 'HandleVisibility','off');
            text(0.02, 0.97, ...
                 sprintf('$\\mathrm{PGA}=%.2f\\mathrm{g}$', b11_pga1), ...
                 'Units','normalized', 'VerticalAlignment','top', ...
                 'FontSize',5.5, 'Color',[0 0 0.70], 'Interpreter','latex');
            xlim([0, b11_dur1]);
        else
            text(0.5, 0.5, 'File missing', 'Units','normalized', ...
                 'HorizontalAlignment','center', 'Color','r', 'FontSize',8);
        end
        ylim(b11_yLim);  grid on;
        % add dummy swatch before legend call
        hDummy1 = plot(nan, nan, 'b-', 'LineWidth', 0.8);
        hLg = legend(hDummy1, sprintf('%d | RSN %d', eqNumber, RSN), ...
            'Location','northeast', 'Box','on', 'FontSize',6);
        hLg.ItemTokenSize = [8, 4];

        % Column title on every page (first row of each figure)
        if b11_row == 1
            title(b11_colTitles{1}, 'FontSize',8.5, 'FontWeight','bold', ...
                  'Interpreter','none', 'Color', b11_colColors{1});
        end
        if b11_row == b11_nRows
            xlabel('Time (s)', 'Interpreter','latex', 'FontSize',7);
        end
        ylabel('$a_g$ (g)', 'Interpreter','latex', 'FontSize',7);

        % ==================================================================
        % PANEL 2 — Curtailed Unscaled (black, xline at curtail point)
        % ==================================================================
        nexttile((b11_row-1)*b11_nColsComp + 2);

        if b11_ok2
            plot(b11_t2, b11_a2, 'k-', 'LineWidth', 0.55);  hold on;
            yline(0, 'k-', 'LineWidth', 0.4, 'HandleVisibility','off');

            % Red dashed vertical at curtail point — only if shorter than original
            if b11_ok1 && (b11_dur2 < b11_dur1)
                xline(b11_dur2, 'r--', 'LineWidth', 0.8, 'HandleVisibility','off');
            end

            text(0.02, 0.97, ...
                 sprintf('$\\mathrm{PGA}=%.2f\\mathrm{g}$', b11_pga2), ...
                 'Units','normalized', 'VerticalAlignment','top', ...
                 'FontSize',5.5, 'Color',[0 0 0], 'Interpreter','latex');

            % Match x-axis to panel 1 so trimming is immediately visible
            if b11_ok1
                xlim([0, b11_dur1]);
            else
                xlim([0, b11_dur2]);
            end
        else
            text(0.5, 0.5, 'File missing', 'Units','normalized', ...
                 'HorizontalAlignment','center', 'Color','r', 'FontSize',8);
        end
        ylim(b11_yLim);  grid on;
        % add dummy swatch before legend call
        hDummy2 = plot(nan, nan, 'k-', 'LineWidth', 0.8);
        hLg = legend(hDummy2, sprintf('%d | RSN %d', eqNumber, RSN), ...
            'Location','northeast', 'Box','on', 'FontSize',6);
        hLg.ItemTokenSize = [8, 4];

        if b11_row == 1
            title(b11_colTitles{2}, 'FontSize',8.5, 'FontWeight','bold', ...
                  'Interpreter','none', 'Color', b11_colColors{2});
        end
        if b11_row == b11_nRows
            xlabel('Time (s)', 'Interpreter','latex', 'FontSize',7);
        end

        % ==================================================================
        % PANEL 3 — Original Scaled (blue = unscaled ref, red = scaled)
        % ==================================================================
        nexttile((b11_row-1)*b11_nColsComp + 3);

        if b11_ok3
            if b11_ok1
                % Underlay: original unscaled in blue (thin)
                plot(b11_t1, b11_a1, 'b-', 'LineWidth', 0.40);  hold on;
            end
            % Overlay: scaled record in red
            plot(b11_t3, b11_a3, 'r-', 'LineWidth', 0.55);      hold on;
            yline(0, 'k-', 'LineWidth', 0.4, 'HandleVisibility','off');

            text(0.02, 0.97, ...
                 sprintf('$\\mathrm{PGA}_{\\mathrm{sc}}=%.2f\\mathrm{g}$', b11_pga3), ...
                 'Units','normalized', 'VerticalAlignment','top', ...
                 'FontSize',5.5, 'Color',[0.75 0 0], 'Interpreter','latex');

            if b11_ok1
                xlim([0, b11_dur1]);
            else
                xlim([0, b11_dur3]);
            end

            % Compact legend: dummy black swatch + EQID & SF
            hDummy = plot(nan, nan, 'r-', 'LineWidth', 0.8);
            hLg = legend(hDummy, sprintf('%d | SF=%.2f', eqNumber, SF), 'Location','northeast', 'Box','on', 'FontSize',6);
            hLg.ItemTokenSize = [8, 4];
        else
            text(0.5, 0.5, 'File missing', 'Units','normalized', ...
                 'HorizontalAlignment','center', 'Color','r', 'FontSize',8);
        end
        ylim(b11_yLim);  grid on;

        if b11_row == 1
            title(b11_colTitles{3}, 'FontSize',8.5, 'FontWeight','bold', ...
                  'Interpreter','none', 'Color', b11_colColors{3});
        end
        if b11_row == b11_nRows
            xlabel('Time (s)', 'Interpreter','latex', 'FontSize',7);
        end

    end % row loop
    % ======================================================================

    % ---- Export ----------------------------------------------------------
    b11_exportName = fullfile(b11_exportFolder, ...
        sprintf('%s_%s_ComparisonPlot_Page%02d', GMM, siteID, b11_figIdx));

    fprintf('>>> Saving comparison page %d/%d\n    %s\n', ...
            b11_figIdx, b11_nFigs, b11_exportName);

    if exist('sks_figureFormat','file')
        sks_figureFormat(formatMode);        % reuse Block 4 variable
    end
    if exist('sks_figureExport','file')
        figure(hFigC);
        sks_figureExport(b11_exportName);
    else
        print(hFigC, b11_exportName, '-dpng', '-r300');
    end

    fprintf('    ✓ Saved.\n');
    if closeFigures,  close(hFigC);  end   % reuse Block 4 variable

end % figure loop
% =========================================================================

fprintf('\n✓ Block 11 complete — %d comparison figure(s) saved to:\n  %s\n', b11_nFigs, b11_exportFolder);

toc


