%% =========================================================================
%  compute_EDP_SideBySide_final.m
%
%  Reads original and curtailed IDA-EDP XLSX files and produces a
%  formatted XLSX with Original | Curtailed | Delta(%) side-by-side
%  for every EQ component, story/floor, and Sa intensity level.
%
%  LAYOUT PER SHEET:
%    Row 1   : Full-width title bar
%    Row 2   : EQ component names  (merged over 3 sub-columns each)
%    Row 3   : "Original | Curtailed | Delta(%)"  sub-column labels
%    Row 4   : "value    | value     | %"         unit labels
%    Row 5+  : EDP section header (steel blue, full width)
%              then data rows:  Col A = blank,  Col B = Story/Floor label,
%              then 60 x [Original | Curtailed | Delta(%)] triplets
%
%  COLOUR SCHEME  (Delta column only):
%    Green  #C6EFCE  ->  Delta >  +0.05%  (Original > Curtailed)
%    Red    #FFCCCC  ->  Delta <  -0.05%  (Curtailed > Original)
%    Yellow #FFF2CC  ->  |Delta| <= 0.05%  (near-zero change)
%    Original / Curtailed columns  ->  plain white
%
%  BORDER SCHEME:
%    EQ header row  : thick box on left+right of each merged group,
%                     NONE on internal cells -> single clean rectangle
%    Data rows      : thick left on Original, thick right on Delta,
%                     thin grey between and within
%
%  FORMULA:
%    Delta(%) = (Original - Curtailed) / |Original| * 100
%
%  PATHS:
%    Input  : E:\StaticDynamicAnalysis\ida-spo-msa\Output\
%             (ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)\
%    Output : same folder
%
%  REQUIREMENTS:  MATLAB R2019b+
%                 Windows + Microsoft Excel installed (for COM formatting)
%% =========================================================================

clc; clear; close all;

%% ── 0.  PATHS ─────────────────────────────────────────────────────────────
%
%  Script location : E:\StaticDynamicAnalysis\ida-spo-msa\psb_MatlabProcessors\
%  Data folder     : ..\Output\(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)\
%
%  mfilename('fullpath') gives the absolute path of this script at runtime,
%  so the data directory is always found correctly regardless of MATLAB's
%  current working folder.

script_dir = fileparts(mfilename('fullpath'));          % …\psb_MatlabProcessors
data_dir   = fullfile(script_dir, '..', 'Output', ...
             '(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)');

orig_name = 'originalGMs_IDA_EDP_AllEQ_(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough).xlsx';
curt_name = 'curtaledGMs_IDA_EDP_AllEQ_(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough).xlsx';
out_name  = 'EDP_SideBySide_Comparison.xlsx';

orig_file = fullfile(data_dir, orig_name);
curt_file = fullfile(data_dir, curt_name);
out_file  = fullfile(data_dir, out_name);

fprintf('Data directory:\n  %s\n\n', data_dir);

if ~isfile(orig_file)
    error('Original file not found:\n  %s\nCheck that data_dir is correct.', orig_file);
end
if ~isfile(curt_file)
    error('Curtailed file not found:\n  %s\nCheck that data_dir is correct.', curt_file);
end

%% ── 1.  SETTINGS ──────────────────────────────────────────────────────────

sa_sheets    = {'Sa_0.11g','Sa_0.41g','Sa_0.71g','Sa_1.01g','Sa_1.31g'};
DELTA_THRESH = 0.05;
N_EQ         = 60;
FIXED_COLS   = 2;       % Col A (blank/label)  +  Col B (Story/Floor)
COLS_PER_EQ  = 3;       % Original | Curtailed | Delta

% EDP blocks  [source row indices in input XLSX]
edp(1).name      = 'IDR (%)';
edp(1).src_rows  = 3:7;
edp(1).sublabels = {'Story 1','Story 2','Story 3','Story 4','Story 5'};

edp(2).name      = 'RDR (%)';
edp(2).src_rows  = 11:15;
edp(2).sublabels = {'Story 1','Story 2','Story 3','Story 4','Story 5'};

edp(3).name      = 'PFA (g)';
edp(3).src_rows  = 19:24;
edp(3).sublabels = {'Floor 1','Floor 2','Floor 3','Floor 4','Floor 5','Floor 6'};

% (Colour constants moved to apply_formatting.py)

total_cols = FIXED_COLS + N_EQ * COLS_PER_EQ;   % 2 + 180 = 182

%% ── 2.  HELPER: read numeric block ────────────────────────────────────────
function M = read_block(fname, sheet, row_indices)
    n = numel(row_indices);
    M = NaN(n, 60);
    for r = 1:n
        rng = sprintf('B%d:BI%d', row_indices(r), row_indices(r));
        raw = readmatrix(fname, 'Sheet', sheet, 'Range', rng, ...
                         'OutputType', 'double');
        if ~isempty(raw)
            nc = min(60, size(raw,2));
            M(r, 1:nc) = raw(1, 1:nc);
        end
    end
end

%% ── 3.  COLUMN INDEX HELPERS (1-based) ────────────────────────────────────
col_orig = @(j) FIXED_COLS + (j-1)*COLS_PER_EQ + 1;   % Original col
col_curt = @(j) FIXED_COLS + (j-1)*COLS_PER_EQ + 2;   % Curtailed col
col_delt = @(j) FIXED_COLS + (j-1)*COLS_PER_EQ + 3;   % Delta col

%% ── 4.  BUILD DATA & WRITE XLSX ───────────────────────────────────────────

if isfile(out_file), delete(out_file); end

for s = 1:numel(sa_sheets)
    sa = sa_sheets{s};
    fprintf('Writing data: %s ...\n', sa);

    % EQ names from row 2 of source file
    % NumHeaderLines cannot be used with a cell range — omit it
    eq_names = readcell(orig_file, 'Sheet', sa, 'Range', 'B2:BI2');
    eq_names = eq_names(1,:);   % 1x60

    % ── Row 1: title ──────────────────────────────────────────────────────
    title_str = sprintf( ...
        'EDP Comparison: Original vs Curtailed GMs | %s | Delta(pct) = (Original-Curtailed)/|Original|*100 | GREEN=Positive  RED=Negative  YELLOW=Near-zero(|D|<=%.2fpct)', ...
        sa, DELTA_THRESH);
    row1 = [ {title_str}, repmat({''}, 1, total_cols-1) ];

    % ── Row 2: EQ names — first of triplet carries name, others blank ─────
    eq_hdr = cell(1, N_EQ*3);
    for j = 1:N_EQ
        eq_hdr{(j-1)*3+1} = eq_names{j};
        eq_hdr{(j-1)*3+2} = '';
        eq_hdr{(j-1)*3+3} = '';
    end
    row2 = [ {'EDP'}, {'Story/Floor'}, eq_hdr ];

    % ── Row 3: sub-column type labels ─────────────────────────────────────
    col_type = repmat({'Original','Curtailed','Delta(%)'}, 1, N_EQ);
    row3     = [ {'',''}, col_type ];

    % ── Row 4: unit labels ─────────────────────────────────────────────────
    unit_lbl = repmat({'value','value','%'}, 1, N_EQ);
    row4     = [ {'',''}, unit_lbl ];

    out_cell = [ row1; row2; row3; row4 ];

    % ── EDP data ───────────────────────────────────────────────────────────
    for e = 1:numel(edp)
        % EDP section header (Col A = EDP name only here, rest blank)
        sec_hdr  = [ {edp(e).name}, repmat({''}, 1, total_cols-1) ];
        out_cell = [ out_cell; sec_hdr ]; %#ok<AGROW>

        O = read_block(orig_file, sa, edp(e).src_rows);
        C = read_block(curt_file, sa, edp(e).src_rows);

        denom          = abs(O);
        denom(denom < 1e-12) = NaN;
        D              = (O - C) ./ denom * 100;

        for r = 1:size(O,1)
            triplets = cell(1, N_EQ*3);
            for j = 1:N_EQ
                triplets{(j-1)*3+1} = O(r,j);   % Original
                triplets{(j-1)*3+2} = C(r,j);   % Curtailed
                triplets{(j-1)*3+3} = round(D(r,j), 2);   % Delta — 2 d.p.
            end
            % NaN -> 'N/A'
            nan_mask = cellfun(@(x) isnumeric(x)&&isnan(x), triplets);
            triplets(nan_mask) = {'N/A'};

            % Col A = BLANK (EDP name removed from data rows)
            % Col B = Story/Floor label
            data_row = [ {''}, {edp(e).sublabels{r}}, triplets ];
            out_cell = [ out_cell; data_row ]; %#ok<AGROW>
        end

        % Blank separator row between EDP blocks
        out_cell = [ out_cell; repmat({''}, 1, total_cols) ]; %#ok<AGROW>
    end

    writecell(out_cell, out_file, 'Sheet', sa);
    fprintf('  Data written: %d rows x %d cols\n', size(out_cell,1), size(out_cell,2));
end

%% ── 5.  APPLY FORMATTING VIA PYTHON HELPER ────────────────────────────────
%
%  Calls apply_formatting.py (must be in the same folder as this script)
%  using MATLAB's built-in Python interface.  This applies all colours,
%  borders, fonts and fills — producing output.
%
%  Requirements:
%    - Python 3.x configured in MATLAB  (pyenv)
%    - openpyxl installed  (pip install openpyxl)
%    - apply_formatting.py in the same folder as this script
%
%  To check your Python setup in MATLAB:  >> pyenv

py_script = fullfile(script_dir, 'apply_formatting.py');

if ~isfile(py_script)
    fprintf('WARNING: apply_formatting.py not found at:\n  %s\n', py_script);
    fprintf('Data is written correctly but colours/borders are not applied.\n');
else
    fprintf('\nApplying formatting via Python (openpyxl) ...\n');

    % ── Step 1: ensure openpyxl is installed in MATLAB's Python env ───────
    fprintf('  Checking openpyxl installation ...\n');
    try
        % Try importing openpyxl — if it works, nothing to do
        pyrun('import openpyxl');
        fprintf('  openpyxl found.\n');
    catch
        fprintf('  openpyxl not found. Installing now ...\n');
        try
            % Install into MATLAB's Python environment
            py_exe = string(pyenv().Executable);
            cmd_install = sprintf('"%s" -m pip install openpyxl --quiet', py_exe);
            [st, res] = system(cmd_install);
            if st == 0
                fprintf('  openpyxl installed successfully.\n');
            else
                fprintf('  pip install output:\n%s\n', res);
            end
        catch ME_pip
            fprintf('  Auto-install failed: %s\n', ME_pip.message);
            fprintf('  Run manually in a terminal:\n');
            fprintf('    pip install openpyxl\n');
        end
    end

    % ── Step 2: run the formatting script ─────────────────────────────────
    try
        pyrunfile(py_script, out_file = out_file);
        fprintf('Formatting complete.\n');
    catch ME
        fprintf('pyrunfile failed: %s\n', ME.message);
        fprintf('Trying system Python as fallback ...\n');
        try
            % Detect Python executable from pyenv, else fall back to 'python'
            try
                py_exe = char(pyenv().Executable);
            catch
                py_exe = 'python';
            end
            cmd = sprintf('"%s" "%s" "%s"', py_exe, py_script, out_file);
            [status, result] = system(cmd);
            if status == 0
                fprintf('Formatting complete (system Python).\n');
            else
                fprintf('System Python also failed:\n%s\n', result);
                fprintf('Please run manually:\n  python "%s" "%s"\n', ...
                        py_script, out_file);
            end
        catch ME2
            fprintf('Fallback failed: %s\n', ME2.message);
        end
    end
end



%% ── 7.  CONSOLE SUMMARY ───────────────────────────────────────────────────
fprintf('\n=================================================================\n');
fprintf('  Median |Delta%%| across all 60 EQ components\n');
fprintf('=================================================================\n');
fprintf('%-10s  %-10s  %10s  %10s  %10s\n', ...
        'Sa Level','Label','|DIDR|(%%)','|DRDR|(%%)','|DPFA|(%%)');
fprintf('%s\n', repmat('-',1,58));

for s = 1:numel(sa_sheets)
    sa  = sa_sheets{s};
    O_I = read_block(orig_file, sa, edp(1).src_rows);
    C_I = read_block(curt_file, sa, edp(1).src_rows);
    O_R = read_block(orig_file, sa, edp(2).src_rows);
    C_R = read_block(curt_file, sa, edp(2).src_rows);
    O_P = read_block(orig_file, sa, edp(3).src_rows);
    C_P = read_block(curt_file, sa, edp(3).src_rows);

    dI = abs((O_I-C_I)./max(abs(O_I),1e-12)*100);
    dR = abs((O_R-C_R)./max(abs(O_R),1e-12)*100);
    dP = abs((O_P-C_P)./max(abs(O_P),1e-12)*100);

    for r = 1:max(size(O_I,1), size(O_P,1))
        if r <= size(O_I,1) && r <= size(O_P,1)
            fprintf('%-10s  %-10s  %10.4f  %10.4f  %10.4f\n', ...
                sa, edp(1).sublabels{r}, ...
                median(dI(r,:),'omitnan'), ...
                median(dR(r,:),'omitnan'), ...
                median(dP(r,:),'omitnan'));
        elseif r <= size(O_P,1)
            fprintf('%-10s  %-10s  %10s  %10s  %10.4f\n', ...
                sa, edp(3).sublabels{r}, '---','---', ...
                median(dP(r,:),'omitnan'));
        end
    end
    fprintf('%s\n', repmat('-',1,58));
end

fprintf('\nDone. Output saved to:\n  %s\n', out_file);