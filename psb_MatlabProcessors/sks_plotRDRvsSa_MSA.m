function sks_plotRDRvsSa_MSA(msaInputs)

% ============================
% INPUTS
% ============================
eqNumberLIST         = msaInputs.eqNumberLIST;
isConvertToSaKircher = msaInputs.isConvertToSaKircher;

formatMode  = 'powerpoint';

dataFile = 'E:\OpenSees_PracticeExamples\ida-spo-msa\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)\MSA_EDP_AllEQ_(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough).mat';
[saveFolder,~,~] = fileparts(dataFile);

% ============================
% LOAD DATA
% ============================
S = load(dataFile);
MSA_EdpData = S.MSA_EdpData;

% ============================
% EXTRACT Sa
% ============================
if isfield(S,'saLevels')
    Sa_global = S.saLevels;
elseif isfield(S,'saLevelLIST')
    Sa_global = S.saLevelLIST;
elseif isfield(S,'Sa_T1')
    Sa_global = S.Sa_T1;
elseif isfield(S,'Sa')
    Sa_global = S.Sa;
else
    error('Sa levels not found in MAT file');
end

Sa_global = Sa_global(:);

% ============================
% THRESHOLDS
% ============================
thresholdLIST = 0.05:0.05:2;   % (%)
nThresh = length(thresholdLIST);
nSa     = length(Sa_global);

% ============================
% PRECOMPUTE COLLAPSE COUNTS
% ============================
collapseCount_all = zeros(nThresh, nSa);
totalCount_all    = zeros(nThresh, nSa);

for i = 1:length(eqNumberLIST)

    fieldName = sprintf('EQ_%d', eqNumberLIST(i));
    RDR = MSA_EdpData.(fieldName).RDR;
    nRuns = size(RDR,2);
    maxRDR = max(RDR, [], 1)';
    maxRDR = maxRDR(:);

    for t = 1:nThresh

        thr = thresholdLIST(t);
        isCollapsed = (maxRDR >= thr) & ~isnan(maxRDR);

        for j = 1:nRuns
            totalCount_all(t,j) = totalCount_all(t,j) + 1;

            if isCollapsed(j)
                collapseCount_all(t,j) = collapseCount_all(t,j) + 1;
            end
        end

    end
end

% ============================
% TABULAR OUTPUT (PRINT + EXCEL)
% ============================

fprintf('\n\n================ TABULAR COLLAPSE MATRIX ================\n');
excelFile = fullfile(saveFolder, 'RDRvsSaCollapseMatrix.xlsx');

% ---- Header ----
header = cell(1, nThresh + 1);
header{1} = 'Sa\\Thr';

for t = 1:nThresh
    header{t+1} = thresholdLIST(t);
end
dataCell = cell(nSa, nThresh + 1);

for j = 1:nSa
    % First column = Sa
    dataCell{j,1} = Sa_global(j);
    for t = 1:nThresh
        if totalCount_all(t,j) > 0
            c = collapseCount_all(t,j);
            tot = totalCount_all(t,j);
            dataCell{j,t+1} = sprintf('%d/%d', c, tot);
        else
            dataCell{j,t+1} = '-';
        end

    end
end

% ============================
% PRINT TO COMMAND WINDOW
% ============================

fprintf('%10s', 'Sa\\Thr');
for t = 1:nThresh
    fprintf('%10.2f', thresholdLIST(t));
end
fprintf('\n');

for j = 1:nSa
    fprintf('%10.3f', Sa_global(j));
    for t = 1:nThresh
        fprintf('%10s', dataCell{j,t+1});
    end

    fprintf('\n');
end

fprintf('=========================================================\n');

% ============================
% EXPORT TO EXCEL
% ============================
finalCell = [header; dataCell];
writecell(finalCell, excelFile);
fprintf('\nExcel file saved at:\n%s\n', excelFile);



% ============================
% MSA PLOTS 
% ============================
for t = 1:nThresh
    thr = thresholdLIST(t);
    figure; hold on;
    allMaxRDR = [];
    allSa     = [];
    collapseSaVals = [];

    for i = 1:length(eqNumberLIST)
        fieldName = sprintf('EQ_%d', eqNumberLIST(i));
        RDR = MSA_EdpData.(fieldName).RDR;
        nRuns = size(RDR,2);
        Sa = Sa_global(1:nRuns);
        maxRDR = max(RDR, [], 1)';
        maxRDR = maxRDR(:);

        isCollapsed = (maxRDR >= thr) & ~isnan(maxRDR);

        allMaxRDR = [allMaxRDR; maxRDR(~isCollapsed)];
        allSa     = [allSa; Sa(~isCollapsed)];
        collapseSaVals = [collapseSaVals; Sa(isCollapsed)];
    end

    % ===== SORT =====
    [allSa, idx] = sort(allSa);
    allMaxRDR = allMaxRDR(idx);

    % ===== PLOT =====
    plot(allMaxRDR, allSa, 'o', 'MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',5);

    % Collapse stacking
    dx = 0.02 * thr;
    uniqueSaVals = unique(collapseSaVals);

    for k = 1:length(uniqueSaVals)
        saVal = uniqueSaVals(k);
        n = sum(abs(collapseSaVals - saVal) < 1e-6);
        xDots = thr + (0:n-1)*dx;
        yDots = saVal * ones(size(xDots));

        plot(xDots, yDots, 'o', 'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',5);
    end

    % ===== AXES =====
    xlabel('$\mathrm{Max\ RDR\ (\%)}$','Interpreter','latex');

    if isConvertToSaKircher == 0
        ylabel('$Sa\,(g)$','Interpreter','latex');
    else
        ylabel('$Sa_{Kircher}$','Interpreter','latex');
    end

    xline(thr,'--k','LineWidth',1.2);

    ylim([0 max([allSa; collapseSaVals])*1.1]);
    xlim([0 thr*1.3]);

    grid on; box on;

    % ===== LEGEND =====
    h1 = plot(nan,nan,'o','MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',5);
    h2 = plot(nan,nan,'o','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',5);

    legend([h1 h2], {'MSA no-collapse','MSA collapse'}, 'Location','southeast');
    legend boxoff

    sks_figureFormat(formatMode);

    exportName = fullfile(saveFolder, ...
        sprintf('MSA_AllComp_thr_%.2f',thr));
    sks_figureExport(exportName);

end

fprintf('\nDone: MSA plots generated for all thresholds.\n');

end