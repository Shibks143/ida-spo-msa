function sks_plotMIDRvsSa_MSA(msaInputs)

analysisTypeLIST      = msaInputs.analysisTypeLIST;
eqNumberLIST          = msaInputs.eqNumberLIST;
isConvertToSaKircher  = msaInputs.isConvertToSaKircher;

formatMode = 'powerpoint';
startDir = pwd;

MIDRThreshold = 0.002:0.002:0.04;  
nThresh = length(MIDRThreshold);

% ======================================
% LOOP over analysis types
% ======================================
for analysisTypeNum = 1:length(analysisTypeLIST)

    analysisType = analysisTypeLIST{analysisTypeNum};

    cd(startDir);
    cd ..;
    cd Output;
    fixedOutputDirectory = pwd;

    fprintf('\n=========================================\n');
    fprintf('Processing analysisType = %s\n', analysisType);
    fprintf('=========================================\n');

    sks_plot_AllComp_MSA(eqNumberLIST, fixedOutputDirectory, analysisType, ...
        isConvertToSaKircher, formatMode, MIDRThreshold, nThresh);

end

cd(startDir);
fprintf('\nDone.\n');

end


% ========================================================================
% ===================== MAIN FUNCTION ====================================
% ========================================================================
function sks_plot_AllComp_MSA(eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, ...
    isConvertToSaKircher, formatMode, MIDRThreshold, nThresh)

baseDir = fixedOutputDirectory;

figure; hold on;

% =========================
% PASS 1: BUILD Sa GRID
% =========================
allSa = [];

for eqInd = 1:length(eqNumberLIST)

    eqFolder = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqNumberLIST(eqInd)));
    loadFile = fullfile(eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat');

    load(loadFile, 'saLevelForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun');

    validIdx = ~(isSingularForEachRun | isNonConvForEachRun);

    allSa = [allSa; saLevelForEachRun(validIdx)];
end

uniqueSa = unique(allSa(:));
nSa = length(uniqueSa);

% =========================
% COUNT MATRICES
% =========================
collapseCount_all = zeros(nThresh, nSa);
totalCount_all    = zeros(nThresh, nSa);

% =========================
% PASS 2: MIDR LOGIC ONLY
% =========================
for eqInd = 1:length(eqNumberLIST)

    eqFolder = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqNumberLIST(eqInd)));
    loadFile = fullfile(eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat');

    load(loadFile, 'saLevelForEachRun', 'maxDriftForEachRun', ...
        'isSingularForEachRun', 'isNonConvForEachRun');

    validIdx = ~(isSingularForEachRun | isNonConvForEachRun);

    MIDR = maxDriftForEachRun(validIdx);
    Sa   = saLevelForEachRun(validIdx);

    MIDR = MIDR(:);
    Sa   = Sa(:);

    for j = 1:length(MIDR)

        [~, saIdx] = min(abs(uniqueSa - Sa(j)));

        for t = 1:nThresh

            thr = MIDRThreshold(t);

            totalCount_all(t, saIdx) = totalCount_all(t, saIdx) + 1;

            if MIDR(j) >= thr
                collapseCount_all(t, saIdx) = collapseCount_all(t, saIdx) + 1;
            end

        end
    end
end


% =========================
% TABLE OUTPUT (MIDR)
% =========================
fprintf('\n\n================ MIDR COLLAPSE MATRIX ================\n');

header = cell(1, nThresh + 1);
header{1} = 'Sa';

for t = 1:nThresh
    header{t+1} = sprintf('%.3f', MIDRThreshold(t));
end

dataCell = cell(nSa, nThresh + 1);

for j = 1:nSa
    dataCell{j,1} = uniqueSa(j);

    for t = 1:nThresh
        if totalCount_all(t,j) > 0
            dataCell{j,t+1} = sprintf('%d/%d', ...
                collapseCount_all(t,j), totalCount_all(t,j));
        else
            dataCell{j,t+1} = '-';
        end
    end
end

fprintf('%12s', 'Sa');
for t = 1:nThresh
    fprintf('%12s', sprintf('%.3f', MIDRThreshold(t)));
end
fprintf('\n');

for j = 1:nSa
    fprintf('%12.4f', uniqueSa(j));
    for t = 1:nThresh
        fprintf('%12s', dataCell{j,t+1});
    end
    fprintf('\n');
end

fprintf('======================================================\n');


% =========================
% FINAL EXACT EXPORT (MATCH IMAGE)
% =========================

excelFile = fullfile(baseDir, analysisTypeFolder, 'MIDR_CollapseMatrix.xlsx');

% ---- Header ----
header = cell(1, nThresh + 1);
header{1} = 'Sa(g)\MIDR(%)';

for t = 1:nThresh
    header{t+1} = sprintf('%.1f%%', MIDRThreshold(t)*100);  % match your format
end

% ---- Combine header + dataCell ----
finalCell = [header; dataCell];

% ---- Write to Excel ----
writecell(finalCell, excelFile);

fprintf('\nExcel EXACT format saved at:\n%s\n', excelFile);

end