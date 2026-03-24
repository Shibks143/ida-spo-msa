%
% Procedure: PlotCollapseMSAs.m
% -------------------
% This procedure computes opens the needed files and plots collapse MSA's with the EQ runs as dots, and with connecting lines.  It only plots the maximum drift level
%   for the full frame.  To get the data, it opens a file that is made by processing the collapse runs.
%
% This procedure has the option to plot the MSA and to save the final collapse results file using Sa,Kircher (used for
%  ATC-63).  This modification to the Sa levels is made just before
%  plotting and just before saving the final results file; the figures and resutls files that use Sa,Kircher have the names clearly labeled to indicate this.
% NOTICE: The smaller files saved for each record are not
%  affected by this.  The smaller files are always saved with the Sa
%  definition used when running the analysis (WHICH MUST ALWAYS BE
%  SA,GEOMEAN FOR THESE PROCESSORS TO WORK CORRECTLY).
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-24-04, 7-20-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%   - not added
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------


function sks_PlotCollapse_singleAnaType_MSA(msaInputs)

% analysisType =                msaInputs.analysisType;
analysisTypeLIST =            msaInputs.analysisTypeLIST;
eqNumberLIST =                msaInputs.eqNumberLIST;
markerTypeLine =              msaInputs.markerTypeLine;
markerTypeDot =               msaInputs.markerTypeDot;
isPlotIndividualPoints =      msaInputs.isPlotIndividualPoints;
% eqNumberLIST_forStripes =     msaInputs.eqNumberLIST_forStripes;
saLevelsForStripes =          msaInputs.saLevelsForStripes;
isCollapsedForEachRun =       msaInputs.isCollapsedForEachRun;
collapseDriftThreshold =      msaInputs.collapseDriftThreshold;
isConvertToSaKircher =        msaInputs.isConvertToSaKircher;



% ==============================================================
% sks_PlotMSA_AllComp_And_ControlComp
% ==============================================================
% Creates MSA scatter plot:
%   X = Max interstory drift ratio
%   Y = Sa stripe level
%
% Produces TWO plots:
%   1) ALL COMPONENTS (each EQ folder separately)
%   2) CONTROL COMPONENTS (paired EQs: OR collapse + max drift)
%
% Collapse dots follow Baker (2015) Fig 3a:
%   stacked dots from right edge moving left
%
% Folder structure assumed:
% startDir/../Output/<analysisType>/EQ_#/DATA_CollapseResultsForThisSingleEQ.mat
%
% Shivakumar K S (final combined version)
% 11-Feb-2026 IIT Madras
% ==============================================================
% ==========================================
% USER SETTINGS (Figure Output Control)
% ==========================================

formatMode    = 'powerpoint';    % 'default' | 'powerPoint' | 'report' | 'paper'

startDir = pwd;

% ======================================
% LOOP over analysis types
% ======================================
for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolder = sprintf('%s', analysisType);

    % Go to Output folder safely
    cd(startDir);
    cd ..;
    cd Output;
    fixedOutputDirectory = pwd;


    fprintf('\n=========================================\n');
    fprintf('Processing analysisType = %s\n', analysisTypeFolder);
    fprintf('=========================================\n');

    % ============================================================
    % ========== 1) ALL COMPONENTS PLOT ==========================
    % ============================================================
    fprintf('\n--- Plotting ALL COMPONENTS MSA scatter ---\n');

    sks_plot_AllComp_MSA(eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, isConvertToSaKircher,formatMode);

    % ============================================================
    % ========== 2) CONTROL COMPONENTS PLOT ======================
    % ============================================================
    fprintf('\n--- Plotting CONTROL COMPONENTS MSA scatter ---\n');

    sks_plot_ControlComp_MSA(eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, isConvertToSaKircher,formatMode);


end

cd(startDir);
fprintf('\nDone.\n');

end



% ========================================================================
% ===================== Helper 1: ALL COMPONENTS =========================
% ========================================================================
function sks_plot_AllComp_MSA(eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, isConvertToSaKircher, formatMode)

baseDir = fixedOutputDirectory;
figure; hold on;

% === Initialize arrays to collect all EQ data ===
allMaxDrift = [];
allSaLevels = [];
collapseSaVals = [];

periodUsedForScalingGroundMotions = NaN;
minStoryDriftRatioForCollapseMATLAB = NaN;

for eqInd = 1:length(eqNumberLIST)

    eqCompNumber = eqNumberLIST(eqInd);
    eqFolder = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqCompNumber));

    loadFile = fullfile(eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat');

    load(loadFile, 'periodUsedForScalingGroundMotions', 'maxDriftForEachRun', 'saLevelForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', ...
        'isNonConvForEachRun', 'numSaLevels', 'minStoryDriftRatioForCollapseMATLAB');

    numSaLevels = min(numSaLevels, length(maxDriftForEachRun));
    maxDriftForEachRun = maxDriftForEachRun(1:numSaLevels);
    saLevelForEachRun  = saLevelForEachRun(1:numSaLevels);
    isCollapsedForEachRun = isCollapsedForEachRun(1:numSaLevels);
    isSingularForEachRun  = isSingularForEachRun(1:numSaLevels);
    isNonConvForEachRun   = isNonConvForEachRun(1:numSaLevels);

    % === Filter runs (vectorized) ===
    validIdx = ~(isCollapsedForEachRun == 0 & (isSingularForEachRun | isNonConvForEachRun));
    maxDrift = maxDriftForEachRun(validIdx);
    saLevels = saLevelForEachRun(validIdx);
    isCol    = isCollapsedForEachRun(validIdx);

    % === Separate non-collapse and collapse ===
    maxDrift_nonCollapse = maxDrift(isCol == 0);
    saLevels_nonCollapse = saLevels(isCol == 0);

    maxDrift_Collapse = maxDrift(isCol == 1);
    saLevels_Collapse = saLevels(isCol == 1);
    collapseSaVals = [collapseSaVals; saLevels_Collapse(:)];

    % === Append to global arrays ===
    allMaxDrift = [allMaxDrift; maxDrift_nonCollapse(:)];
    allSaLevels = [allSaLevels; saLevels_nonCollapse(:)];

end

% === Sort combined data by Sa for MSA stripe ===
[allSaLevels, idx] = sort(allSaLevels);
allMaxDrift = allMaxDrift(idx);

% === Plot points only ===
plot(allMaxDrift, allSaLevels, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'LineStyle', 'none');

% === Axis labels ===
if isConvertToSaKircher == 0
    temp = sprintf('$Sa_{geoM}(T=%.2f\\,s)\\,(g)$', periodUsedForScalingGroundMotions);
else
    DefineSaKircherOverSaGeoMeanValues
    temp = axisLabelForSaKircher;
end
xlabel('$\mathrm{Max\ Interstory\ Drift\ Ratio}$', 'Interpreter','latex');
ylabel(temp, 'Interpreter','latex');


% === Set axis limits: Compute limits only from all-component data ===
allSaForAxis = [allSaLevels; collapseSaVals];
maxYOnAxis = max(allSaForAxis);
ylim([0, maxYOnAxis * 1.1]);

% ---- Base width from collapse drift threshold ----
baseWidth = minStoryDriftRatioForCollapseMATLAB;

% ---- Adaptive stacking spacing ----
dx = 0.02 * baseWidth;   % 2% of collapse drift

% ---- Count collapses per Sa stripe ----
if ~isempty(collapseSaVals)
    [~,~,idx] = unique(collapseSaVals);
    counts = accumarray(idx,1);
    maxStack = max(counts);
else
    maxStack = 0;
end

% ---- Compute right boundary ----
xRightLimit = minStoryDriftRatioForCollapseMATLAB + maxStack*dx;
xlim([0, xRightLimit * 1.05]);

% ---- Collapse threshold line ----
xline(minStoryDriftRatioForCollapseMATLAB, '--', 'LineWidth', 1.2, 'Color', 'k');

% === Tick formatting ===
ax = gca;
xt = 0:0.02:minStoryDriftRatioForCollapseMATLAB;
xt = unique([xt, minStoryDriftRatioForCollapseMATLAB]);
ax.XTick = sort(xt);
ax.XTickLabel = compose('%.2f', ax.XTick);
yticks(0:0.5:ax.YLim(2));

% === Collapse dots stacked from right edge ===
xRight = ax.XLim(2);
uniqueSaVals = unique(collapseSaVals);
tol = 1e-6;

for k = 1:length(uniqueSaVals)
    currentSa = uniqueSaVals(k);
    numOfCollapses = sum(abs(collapseSaVals - currentSa) < tol);

    if numOfCollapses > 0
        xDots = xRight - (0:numOfCollapses-1)*dx;
        yDots = currentSa * ones(size(xDots));

        plot(xDots, yDots, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'LineStyle', 'none');
    end
end

box on;
grid on;

% === Legend (Baker-style) — ALL COMPONENTS ===
h1_all = plot(nan, nan, 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',5, 'LineStyle','none');
h2_all = plot(nan, nan, 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize',5, 'LineStyle','none');

legend([h1_all h2_all], {'MSA no-collapse','MSA collapse'}, 'Location','southeast', 'FontSize',14);
legend boxoff

% === Save ===
saveDir = fullfile(baseDir, analysisTypeFolder);
if isConvertToSaKircher == 0
    exportName = fullfile(saveDir,'CollapseMSA_AllComp_SaGeoMean');
else
    exportName = fullfile(saveDir,'CollapseMSA_AllComp_SaATC63');
end

% === Apply formatting + export ===
sks_figureFormat(formatMode);
sks_figureExport(exportName);

end



% ========================================================================
% =================== Helper 2: CONTROL COMPONENTS =======================
% ========================================================================
function sks_plot_ControlComp_MSA(eqNumberLIST, fixedOutputDirectory, analysisTypeFolder, isConvertToSaKircher, formatMode)

baseDir = fixedOutputDirectory;
figure; hold on;


% === Global arrays ===
allMaxDrift_control = [];
allSa_control = [];
collapseSaVals_control = [];

periodUsedForScalingGroundMotions = NaN;
minStoryDriftRatioForCollapseMATLAB = NaN;

for eqNum = 1:2:length(eqNumberLIST)
    eqComp1 = eqNumberLIST(eqNum);
    eqComp2 = eqNumberLIST(eqNum+1);

    % --- Load component 1 ---
    eqFolder1 = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqComp1));
    loadFile1 = fullfile(eqFolder1, 'DATA_CollapseResultsForThisSingleEQ.mat');

    load(loadFile1, 'periodUsedForScalingGroundMotions', 'maxDriftForEachRun', 'saLevelForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', ...
        'isNonConvForEachRun', 'numSaLevels', 'minStoryDriftRatioForCollapseMATLAB');

    maxNumRuns1 = min(numSaLevels, length(maxDriftForEachRun));
    drift1 = maxDriftForEachRun(1:maxNumRuns1);
    sa1    = saLevelForEachRun(1:maxNumRuns1);
    col1   = isCollapsedForEachRun(1:maxNumRuns1);
    sing1  = isSingularForEachRun(1:maxNumRuns1);
    nonc1  = isNonConvForEachRun(1:maxNumRuns1);

    % --- Load component 2 ---
    eqFolder2 = fullfile(baseDir, analysisTypeFolder, sprintf('EQ_%d', eqComp2));
    loadFile2 = fullfile(eqFolder2, 'DATA_CollapseResultsForThisSingleEQ.mat');

    load(loadFile2, 'maxDriftForEachRun', 'saLevelForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', 'numSaLevels');

    maxNumRuns2 = min(numSaLevels, length(maxDriftForEachRun));
    drift2 = maxDriftForEachRun(1:maxNumRuns2);
    sa2    = saLevelForEachRun(1:maxNumRuns2);
    col2   = isCollapsedForEachRun(1:maxNumRuns2);
    sing2  = isSingularForEachRun(1:maxNumRuns2);
    nonc2  = isNonConvForEachRun(1:maxNumRuns2);

    % === Remove padding zeros ===
    valid1 = (sa1 > 0);
    valid2 = (sa2 > 0);

    drift1 = drift1(valid1); sa1 = sa1(valid1); col1 = col1(valid1); sing1 = sing1(valid1); nonc1 = nonc1(valid1);
    drift2 = drift2(valid2); sa2 = sa2(valid2); col2 = col2(valid2); sing2 = sing2(valid2); nonc2 = nonc2(valid2);

    % === Filter runs (same rule you used) ===
    validRun1 = ~(col1 == 0 & (sing1 | nonc1));
    validRun2 = ~(col2 == 0 & (sing2 | nonc2));

    drift1 = drift1(validRun1); sa1 = sa1(validRun1); col1 = col1(validRun1);
    drift2 = drift2(validRun2); sa2 = sa2(validRun2); col2 = col2(validRun2);

    % === Must have same stripe length after filtering ===
    if length(sa1) ~= length(sa2)
        error('Stripe length mismatch after filtering between EQ_%d and EQ_%d', eqComp1, eqComp2);
    end

    % === CONTROL COMPONENT LOGIC ===
    sa_control   = sa1;
    col_control  = max(col1, col2);
    drift_control = max(drift1, drift2);

    % === Separate collapse vs non-collapse ===
    drift_nonCollapse = drift_control(col_control == 0);
    sa_nonCollapse    = sa_control(col_control == 0);

    drift_Collapse = drift_control(col_control == 1);
    sa_Collapse    = sa_control(col_control == 1);

    collapseSaVals_control = [collapseSaVals_control; sa_Collapse(:)];

    % === Append global arrays ===
    allMaxDrift_control = [allMaxDrift_control; drift_nonCollapse(:)];
    allSa_control       = [allSa_control; sa_nonCollapse(:)];

end

% === Sort combined data ===
[allSa_control, idx] = sort(allSa_control);
allMaxDrift_control = allMaxDrift_control(idx);

% === Plot non-collapse points ===
plot(allMaxDrift_control, allSa_control, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'LineStyle', 'none');

% === Axis labels ===
if isConvertToSaKircher == 0
    temp = sprintf('$Sa_{geoM}(T=%.2f\\,s)\\,(g)$', periodUsedForScalingGroundMotions); 
else
    DefineSaKircherOverSaGeoMeanValues
    temp = axisLabelForSaKircher;
end

xlabel('$\mathrm{Max\ Interstory\ Drift\ Ratio}$', 'Interpreter','latex');
ylabel(temp, 'Interpreter','latex');


% === Set axis limits: Compute limits only from control data ===
allSaForAxis_control = [allSa_control; collapseSaVals_control];
maxYOnAxis_control = max(allSaForAxis_control);
ylim([0, maxYOnAxis_control * 1.1]);

% ---- Base width from collapse drift threshold (more stable) ----
baseWidth = minStoryDriftRatioForCollapseMATLAB;

% ---- Adaptive stacking spacing ----
dx = 0.02 * baseWidth;   % 2% of collapse drift

% ---- Count collapses per Sa stripe ----
if ~isempty(collapseSaVals_control)
    [~,~,idx] = unique(collapseSaVals_control);
    counts = accumarray(idx,1);
    maxStack = max(counts);
else
    maxStack = 0;
end

% ---- Compute right boundary ----
xRightLimit = minStoryDriftRatioForCollapseMATLAB + maxStack*dx;
xlim([0, xRightLimit * 1.05]);

% ---- Collapse threshold line ----
xline(minStoryDriftRatioForCollapseMATLAB, '--', 'LineWidth', 1.2, 'Color', 'k');

% === Tick formatting ===
ax = gca;
xt = 0:0.02:minStoryDriftRatioForCollapseMATLAB;
xt = unique([xt, minStoryDriftRatioForCollapseMATLAB]);
ax.XTick = sort(xt);
ax.XTickLabel = compose('%.2f', ax.XTick);
yticks(0:0.5:ax.YLim(2));

% === Collapse dots stacked from right edge ===
xRight = ax.XLim(2);
uniqueSaVals = unique(collapseSaVals_control);
tol = 1e-6;

for k = 1:length(uniqueSaVals)
    currentSa = uniqueSaVals(k);
    numOfCollapses = sum(abs(collapseSaVals_control - currentSa) < tol);

    if numOfCollapses > 0
        xDots = xRight - (0:numOfCollapses-1)*dx;
        yDots = currentSa * ones(size(xDots));

        plot(xDots, yDots, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'LineStyle', 'none');
    end
end

grid on;

% === Legend (Baker-style) — CONTROL COMPONENTS ===
h1_ctrl = plot(nan, nan, 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',5, 'LineStyle','none');
h2_ctrl = plot(nan, nan, 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize',5, 'LineStyle','none');
legend([h1_ctrl h2_ctrl], {'MSA no-collapse','MSA collapse'}, 'Location','southeast', 'FontSize',14);
legend boxoff

% === Save ===
saveDir = fullfile(baseDir, analysisTypeFolder);
if isConvertToSaKircher == 0
    exportName = fullfile(saveDir,'CollapseMSA_ControlComp_SaGeoMean');
else
    exportName = fullfile(saveDir,'CollapseMSA_ControlComp_SaATC63');
end

% === Apply formatting + export ===
sks_figureFormat(formatMode);
sks_figureExport(exportName);

end






% 
% function sks_PlotCollapse_singleAnaType_MSA(analysisType, analysisTypeLIST, eqNumberLIST, markerTypeLine, markerTypeDot, isPlotIndividualPoints, eqNumberLIST_forStripes, saLevelsForStripes, isCollapsedForEachRun, collapseDriftThreshold, isConvertToSaKircher, eqListForCollapseMSAs_Name)
% 
% baseDir = pwd; figure; hold on;
% 
% % === Initialize arrays to collect all EQ data ===
% allMaxDrift = [];
% allSaLevels   = [];
% collapseSaVals   = [];
% 
% 
% for eqInd = 1:length(eqNumberLIST)
%     eqCompNumber = eqNumberLIST(eqInd);
% 
%     eqFolder = fullfile(baseDir, analysisType, sprintf('EQ_%d', eqCompNumber));
% 
%     % % === Load data of each EQ ===
%     loadFile = fullfile(eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat');
%     load(loadFile,'periodUsedForScalingGroundMotions', 'maxDriftForEachRun', 'saLevelForEachRun', 'isCollapsedForEachRun', 'isSingularForEachRun', 'isNonConvForEachRun', 'maxNumRuns', 'minStoryDriftRatioForCollapseMATLAB');
% 
%     maxNumRuns = min(maxNumRuns, length(maxDriftForEachRun));
%     maxDriftForEachRun = maxDriftForEachRun(1:maxNumRuns);
%     saLevelForEachRun  = saLevelForEachRun(1:maxNumRuns);
%     isCollapsedForEachRun = isCollapsedForEachRun(1:maxNumRuns);
%     isSingularForEachRun  = isSingularForEachRun(1:maxNumRuns);
%     isNonConvForEachRun   = isNonConvForEachRun(1:maxNumRuns);
% 
% 
%     % === Filter runs (vectorized) ===
%     validIdx = ~(isCollapsedForEachRun == 0 & (isSingularForEachRun | isNonConvForEachRun));
%     maxDrift = maxDriftForEachRun(validIdx);
%     saLevels   = saLevelForEachRun(validIdx);
%     isCol = isCollapsedForEachRun(validIdx);
% 
% 
%     % === Separate non-collapse and collapse ===
%     maxDrift_nonCollapse = maxDrift(isCol == 0);
%     saLevels_nonCollapse   = saLevels(isCol == 0);
% 
%     maxDrift_Collapse = maxDrift(isCol == 1);
%     saLevels_Collapse = saLevels(isCol == 1);
%     collapseSaVals = [collapseSaVals; saLevels_Collapse(:)];
% 
%     % === Append to global arrays ===
%     allMaxDrift = [allMaxDrift; maxDrift_nonCollapse(:)];
%     allSaLevels = [allSaLevels; saLevels_nonCollapse(:)];
% 
% end
% 
% 
% % === Sort combined data by Sa for MSA stripe ===
% [allSaLevels, idx] = sort(allSaLevels);
% allMaxDrift = allMaxDrift(idx);
% 
% % ===  Axis limits ===
% maxXOnAxis = max(allMaxDrift) * 1.1;
% % maxYOnAxis = max(allSaLevels) * 1.1;   % Add margin for Y-axis
% 
% % === Plot points only, no connecting lines ===
% plot(allMaxDrift, allSaLevels, markerTypeDot, 'LineStyle', 'none', 'MarkerSize', 4, 'MarkerFaceColor', 'k');
% 
% 
% % === Axis labels ===
% if isConvertToSaKircher == 0
%     titleTemp = sprintf('Sa_{geoM}(T_{1}=%.2fs) (g)', periodUsedForScalingGroundMotions);
% else
%     titleTemp = axisLabelForSaKircher;
% end
% 
% xlabel('Max Interstory Drift Ratio');
% ylabel(titleTemp);
% 
% % === Set axis limits ===
% maxYOnAxis = max(allSaLevels);
% xlim([0, maxXOnAxis*2]);
% ylim([0, maxYOnAxis*1.1]);
% xline(minStoryDriftRatioForCollapseMATLAB, '--', 'LineWidth', 2, 'Color', 'k'); % Vertical collapse drift line 
% 
% % --- Now force tick at collapse drift ---
% ax = gca;
% xt = 0:0.02:minStoryDriftRatioForCollapseMATLAB;
% xt = unique([xt, minStoryDriftRatioForCollapseMATLAB]);
% ax.XTick = sort(xt);
% ax.XTickLabel = compose('%.2f', ax.XTick);
% yticks(0:0.5:ax.YLim(2));
% 
% 
% % === Baker (2015) Fig 3a style: collapse count dots stacked from right edge ===
% xRight = ax.XLim(2);   % exact right edge of axis
% uniqueSaVals = unique(collapseSaVals);
% tol = 1e-6;
% dx = 0.002;   % Fixed horizontal step (adjust if needed)
% 
% for k = 1:length(uniqueSaVals)
%     currentSa = uniqueSaVals(k);
% 
%     % number of collapses at this Sa stripe
%     numOfCollapses = sum(abs(collapseSaVals - currentSa) < tol);
% 
%     if numOfCollapses > 0    % dots start at right edge and stack left
%         xDots = xRight - (0:numOfCollapses-1)*dx;
%         yDots = currentSa * ones(size(xDots));
% 
%         plot(xDots, yDots, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4);
%     end
% end
% box on
% grid off
% 
% % FigureFormatScript
%  % Save the plot
%  saveDir = fullfile(baseDir, analysisType);
% 
% if(isConvertToSaKircher == 0)
%     exportName = fullfile(saveDir,'CollapseMSA_AllComp_SaGeoMean');
%     print('-dmeta', exportName);            
%     savefig(exportName); % .fig file for Matlab
%     print('-depsc', exportName); % .eps file for Linux (LaTeX)
%     print('-dmeta', exportName); % .emf file for Windows (MSWORD
% 
% else
%     % This is Sa,ATC-63 (or Sa,Kircher)
%     % Save the plot as a .fig file
%     % File name shortened to make it save file correctly (1-14-09 CBH)
%     %plotName = sprintf('CollapseIDA_ControlComp_%s_%s_SaATC63.fig', analysisType, eqListForCollapseIDAs_Name);
%     exportName = fullfile(saveDir,'CollapseMSA_AllComp_SaATC63');
%     print('-dmeta', exportName);            
%     savefig(exportName); % .fig file for Matlab
%     print('-depsc', exportName); % .eps file for Linux (LaTeX)
%     print('-dmeta', exportName); % .emf file for Windows (MSWORD)            
% 
% end
% 
% % === Set font size for X and Y ticks ===
% ax.FontSize = 12;  
% 
% end








% 
% % Initialize
% controlCollapseSaVals = [];
% 
% for eqInd = 1:length(eqNumberLIST)
%     eqCompNumber = eqNumberLIST(eqInd);
%     eqFolder = fullfile(baseDir, analysisType, sprintf('EQ_%d', eqCompNumber));
% 
%     % Load data (assuming both components stored in maxDriftForEachRun matrix)
%     loadFile = fullfile(eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat');
%     load(loadFile, 'maxDriftForEachRun', 'saLevelForEachRun', 'isCollapsedForEachRun', 'maxNumRuns');
% 
%     maxNumRuns = min(maxNumRuns, size(maxDriftForEachRun,1));
%     maxDriftForEachRun = maxDriftForEachRun(1:maxNumRuns,:);
%     saLevelForEachRun  = saLevelForEachRun(1:maxNumRuns);
%     isCollapsedForEachRun = isCollapsedForEachRun(1:maxNumRuns,:);
% 
%     % Determine control component per run
%     for run = 1:maxNumRuns
%         % Find which component collapsed first
%         driftRun = maxDriftForEachRun(run,:);
%         colRun   = isCollapsedForEachRun(run,:);
% 
%         % Only consider collapsed components
%         driftRun(colRun==0) = inf;
% 
%         [minDrift, ctrlComp] = min(driftRun); % control component index
% 
%         if minDrift < inf
%             % Append corresponding Sa for control component
%             controlCollapseSaVals = [controlCollapseSaVals; saLevelForEachRun(run)];
%         end
%     end
% end
% % === Baker-style dots from right edge for control component ===
% ax = gca;
% xRight = ax.XLim(2);
% uniqueSaVals = unique(controlCollapseSaVals);
% tol = 1e-6;
% dx = 0.002;
% 
% for k = 1:length(uniqueSaVals)
%     currentSa = uniqueSaVals(k);
%     numOfCollapses = sum(abs(controlCollapseSaVals - currentSa) < tol);
% 
%     if numOfCollapses > 0
%         xDots = xRight - (0:numOfCollapses-1)*dx;
%         yDots = currentSa * ones(size(xDots));
%         plot(xDots, yDots, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 4);
%     end
% end
% 
% % === Format figure for Control Component collapse plot ===
% box on;
% grid off;
% 
% % Set axis font size
% ax.FontSize = 12;
% 
% % --- Save the figure ---
% saveDir = fullfile(baseDir, analysisType);
% 
% if(isConvertToSaKircher == 0)
%     % Control Component, Sa_geoM
%     exportName = fullfile(saveDir,'CollapseMSA_ControlComp_SaGeoMean');
%     print('-dmeta', exportName);            
%     savefig(exportName);       % MATLAB .fig
%     print('-depsc', exportName); % .eps for LaTeX
%     print('-dmeta', exportName);  % .emf for Windows
% 
% else
%     % Control Component, Sa_Kircher / ATC-63
%     exportName = fullfile(saveDir,'CollapseMSA_ControlComp_SaATC63');
%     print('-dmeta', exportName);            
%     savefig(exportName);        % MATLAB .fig
%     print('-depsc', exportName); % .eps for LaTeX
%     print('-dmeta', exportName);  % .emf for Windows
% end






% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% This does collapse MSAs for a single analysisType
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Load the file that defines the relationship between Sa,goeMean and
% % Sa,Kricher at 1sec.
% DefineSaKircherOverSaGeoMeanValues
% 
% % Input what max drift value you want on X axis for the plot
% maxXOnAxis = 0.08; %0.30;
% figureNumAllComp = 1;           % Plot of results for all components
% figureNumControllingComp = 2;   % Plot of results for only controlling components
% ControllingCompNumLIST =[];
% dampRat = 0.05; % This is used when converting to Sa,Kircher
% 
% % Initialize a vector - twice as long as the eqNumerLIST b/c I do two comp. per EQ
% collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));   
% collapseLevelForAllControlComp = zeros(1,(length(eqNumberLIST)));   
% eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST))); 
% eqCompInd = 1;
% 
% % Initialize cell arrays once (before loop)
% 
% maxDriftRatioForPlotPROCLIST_ALL = {};
% saLevelsForMSAPlotPROCLIST_ALL = {};
% 
% 
% for eqInd = 1:(length(eqNumberLIST))
%     eqNumber = eqNumberLIST(eqInd);
% 
% 
%     %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     % eqCompNumber = eqNumber * 10.0 + 1.0;
%     eqCompNumber = eqNumberLIST(eqInd);
%     eqCompNumberLIST(eqCompInd) = eqCompNumber;
% 
%     cd ..
%     cd Output
%     cd(analysisType)
%     cd(sprintf('EQ_%d', eqCompNumber))
% 
%     % process THIS component only
% 
%     eqCompInd = eqCompInd + 1;
% end
% 
%     % % Go to the correct folder
%     %     cd ..;
%     %     cd Output;
%     %     analysisTypeFolder = sprintf('%s', analysisType);
%     %     cd(analysisTypeFolder);
%     %     eqFolder = sprintf('EQ_%.0f', eqCompNumber);
%     %     cd(eqFolder)
% 
% 
% 
%     % Open the file that has the collapse data
%         load('DATA_collapseMSAPlotDataForThisEQ.mat');
%         % collapseLevelFromFileOpened = collapseSaLevel;
%         % clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
%         load('DATA_CollapseResultsForThisSingleEQ.mat', 'toleranceAchieved', 'periodUsedForScalingGroundMotions');
% 
%     % Save collapse level for all EQs - this is from what is saved when the collapse run is done - DO NOT USE THIS RESULT FOR COMPUTATIONS!!!
%         % eqCompNumber;
% %         collapseLevelForAllComp(eqCompInd) = collapseSaLevel;    % ALTER THIS TO BE BASED ON OUTPUT DATA!!!! % NOTICE: This is the value from when the collapse algorithm ran (at least it's still this way as of 3-14-05)
% %         collapseSaLevelCompOne = collapseSaLevel;
% 
%     % Process the vector of MSA results to remove the results for singular or non-converegd records...
%         % Loop through the vectors from the file that was opened and only put the results in the 
%         %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
%         maxDriftRatioForPlotPROCLISTC1 = [];
%         saLevelsForMSAPlotPROCLISTC1 = [];
% 
%         subLoopIndex = 1;
%         for loopIndex = 1:length(maxDriftRatioForPlotLIST)
%             if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
%                 % If this is the case, don't add it to the plot list
%             else
%                 % If we get here, we are okay, so add it to the plot list
%                 maxDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
%                 saLevelsForMSAPlotPROCLISTC1(subLoopIndex) = saLevelsForMSAPlotLIST(loopIndex);
%                 %isCollapseLISTPROCC1(subLoopIndex) = isCollapsedLIST(loopIndex);
%                 subLoopIndex = subLoopIndex + 1;
%             end
% 
% 
%         end
% 
%     % Plot - note that the psuedoTimeVector is from the file that was opened 
%         figure(figureNumAllComp);
% 
% %         hold off
% 
%         % Convert to Sa,Kircher if needed
%         if(isConvertToSaKircher == 0)
%             % We want to use Sa,goeMean(T1), so do not do a conversion
%              plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForMSAPlotPROCLISTC1, markerTypeLine);
%         else
%             % We want to plot with Sa,Kircher(T=1s), so do conversion and
%             % plot
%             saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat);
%             saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat);
%             saLevelsForMSAPlotPROCLISTC1_KircherAtOneSec = saLevelsForMSAPlotPROCLISTC1.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
%             plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForMSAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine);
%             clear saGeoMeanAtOneSec saGeoMeanAtTOne
%         end
% 
%         % Plot the points for each run, if told to
%         if(isPlotIndividualPoints == 1)
%             for i = 1:length(saLevelsForMSAPlotPROCLISTC1)
%                 hold on
%                 % Convert to Sa,Kircher if needed
%                 if(isConvertToSaKircher == 0)
%                     % We want to use Sa,goeMean(T1), so do not do a conversion
%                     plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForMSAPlotPROCLISTC1(i), markerTypeDot);
% %                     pause(0.25)
%                 else
%                     % We want to plot with Sa,Kircher(T=1s)
%                     plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForMSAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot);
%                 end
%             end 
%         end
% 
%        % Find collapse Sa as the first MSA stripe where max drift exceeds
%        % the collapse drift threshold (no interpolation).
% 
% 
%             collapseIndex = find(maxDriftRatioForPlotPROCLISTC1 > collapseDriftThreshold, 1, 'first');
% 
%                 if ~isempty(collapseIndex)
%                     collapseLevelCompOne = saLevelsForMSAPlotPROCLISTC1(collapseIndex);
%                 else
%                     collapseLevelCompOne = saLevelsForMSAPlotPROCLISTC1(end);
%                 end
% 
% 
%             % for index = 1:length(maxDriftRatioForPlotPROCLISTC1)
%             %     if(maxDriftRatioForPlotPROCLISTC1(index) > collapseDriftThreshold) 
%             %         break;    
%             %     end
%             % end
% 
%             % collapseLevelCompOne = (saLevelsForMSAPlotPROCLISTC1(index) + saLevelsForMSAPlotPROCLISTC1(index - 1)) / 2.0;
% 
%             % Take average and call that the collapse capacity.  If one
%             % value is over 15 (this happens when there was a convergence
%             % error it looks like), then just use the minimum of the two
%             % values. (altered on 0-28-05)
%             % if(max(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1))) < 15.0);
%             %     % Compute it the normal way
%             %     collapseLevelCompOne = (saLevelsForIDAPlotPROCLISTC1(index) + saLevelsForIDAPlotPROCLISTC1(index - 1)) / 2.0;
%             % else
%             %     disp('***********************************');
%             %     disp('******* Fixing error **************');
%             %     disp('***********************************');
%             %     toleranceAchieved
%             %     % If this error has occured, just take the Sa value just
%             %     % before the error and call this the collapse (the minimim
%             %     % of the two values)
%             %     collapseLevelCompOne = min(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1)));
%             % end
% 
% %             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
% %             %   collapse Sa level from the file that was opened.
% %                 if(collapseLevelCompOne > 50.0)
% %                     collapseLevelCompOne = collapseLevelFromFileOpened;
% %                 end
% 
%             collapseLevelCompOne;
%             collapseSaLevel = collapseLevelCompOne;
%             collapseLevelForAllComp(eqCompInd) = collapseLevelCompOne;
% 
%         % Save a file for this EQ component
%             % Rename variables to be general to either component 1 or 2
%             maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC1;
%             saLevelsForMSAPlotPROCLIST = saLevelsForMSAPlotPROCLISTC1;
%             % Save file
%             eqCompColFileName = sprintf('DATA_collapse_ProcessedMSADataForThisEQ.mat');
%             save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForMSAPlotPROCLIST', 'collapseSaLevel');        
% 
%         % Clear the results from the last loop
%         clear maxDriftRatioForPlotLIST saLevelsForMSAPlotLIST 
% 
%         % Go back to the Matlab folder
%         cd ..;
%         cd ..;
%         cd ..;
%         cd psb_MatlabProcessors;
% 
%         eqCompInd = eqCompInd + 1;
% 
%     %%%%%%%%%%%%% END: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     %%%%%%%%%%%%% START: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     eqCompNumber = eqNumber * 10.0 + 2.0;
%     eqCompNumberLIST(eqCompInd) = eqCompNumber;
% 
% 
%     % Go to the correct folder
%         cd ..;
%         cd Output;
%         analysisTypeFolder = sprintf('%s', analysisType);
%         cd(analysisTypeFolder);
%         eqFolder = sprintf('EQ_%.0f', eqCompNumber);
%         cd(eqFolder)
% 
%     % Open the file that has the collapse data
%         load('DATA_collapseMSAPlotDataForThisEQ.mat');
%         % collapseLevelFromFileOpened = collapseSaLevel;
%         % clear collapseSaLevel;  % I don't want to use this value in the file that comes from when I ran the collapse analysis.  This value is slightly inaccurate in some cases.
% 
%     % Save collapse level for all EQs - this is from what is saved when the collapse run is done.
%         % eqCompNumber;
% %         collapseSaLevel
% %         collapseLevelForAllComp(eqCompInd) = collapseSaLevel;    % ALTER THIS TO BE BASED ON OUTPUT DATA!!!! % NOTICE: This is the value from when the collapse algorithm ran (at least it's still this way as of 3-14-05)
% %         collapseSaLevelCompTwo = collapseSaLevel;
% 
%         % Process the vector of IDA results to remove the results for singular or non-converegd records...
%         % Loop through the vectors from the file that was opened and only put the results in the 
%         %   plot vector if they are converged (if it's not collapsed) and non-singular (if it's not collapsed)
%        maxDriftRatioForPlotPROCLISTC2 = [];
%        saLevelsForMSAPlotPROCLISTC2 = [];
% 
%         subLoopIndex = 1;
%         for loopIndex = 1:length(maxDriftRatioForPlotLIST)
%             if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
%                 % If this is the case, don't add it to th eplot list
%             else
%                 % If we get here, we are okay, so add it to the plot list
%                 maxDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
%                 saLevelsForMSAPlotPROCLISTC2(subLoopIndex) = saLevelsForMSAPlotLIST(loopIndex);
%                 %isCollapseLISTPROCC2(subLoopIndex) = isCollapsedLIST(loopIndex);
%                 subLoopIndex = subLoopIndex + 1;
%             end
% 
%         end
% 
%     % Plot - note that the psuedoTimeVector is from the file that was opened 
%         figure(figureNumAllComp);        
%         % Convert to Sa,Kircher if needed
%         if(isConvertToSaKircher == 0)
%             % We want to use Sa,goeMean(T1), so do not do a conversion
%             plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForMSAPlotPROCLISTC2, markerTypeLine);
%         else
%             % We want to plot with Sa,Kircher(T=1s), so do conversion and
%             % plot
%             saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat);
%             saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat);
%             saLevelsForMSAPlotPROCLISTC2_KircherAtOneSec = saLevelsForMSAPlotPROCLISTC2.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
%             plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForMSAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine);
%             clear saGeoMeanAtOneSec saGeoMeanAtTOne
%         end
% 
%         % Plot the points for each run, if told to
%         if(isPlotIndividualPoints == 1)
%             for i = 1:length(saLevelsForMSAPlotPROCLISTC2)
%                 hold on
%                 % Convert to Sa,Kircher if needed
%                 if(isConvertToSaKircher == 0)
%                     % We want to use Sa,goeMean(T1), so do not do a conversion
%                     plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForMSAPlotPROCLISTC2(i), markerTypeDot);
% %                         pause(0.5)
%                 else
%                     % We want to plot with Sa,Kircher(T=1s)
%                     plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForMSAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot);
%                 end
%             end 
%         end
% 
%         % Find the collapse Sa level for the component and save it.  Loop to find the collapse point, then average the Sa level just 
%         %   below and just above the collapse point.
%             % Loop to get to the collapse point
% 
%                 collapseIndex = find(maxDriftRatioForPlotPROCLISTC2 > collapseDriftThreshold, 1, 'first');
% 
%                 if ~isempty(collapseIndex)
%                     collapseLevelCompTwo = saLevelsForMSAPlotPROCLISTC2(collapseIndex);
%                 else
%                     collapseLevelCompTwo = saLevelsForMSAPlotPROCLISTC2(end);
%                 end
% 
% 
%             % for index = 1:length(maxDriftRatioForPlotPROCLISTC2)
%             %     if(maxDriftRatioForPlotPROCLISTC2(index) > collapseDriftThreshold) 
%             %         break;    
%             %     end
%             % end
% 
%             % Take average and call that the collapse capacity.  If one
%             % value is over 15 (this happens when there was a convergence
%             % error it looks like), then just use the minimum of the two
%             % values. (altered on 0-28-05)
%             % if(max(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index - 1))) < 15.0);
%             %     % Compute it the normal way
%             %     collapseLevelCompTwo = (saLevelsForIDAPlotPROCLISTC2(index) + saLevelsForIDAPlotPROCLISTC2(index - 1)) / 2.0;
%             % else
%             %     disp('***********************************');
%             %     disp('******* Fixing error **************');
%             %     disp('***********************************');
%             %     toleranceAchieved
%             %     % If this error has occured, just take the Sa value just
%             %     % before the error and call this the collapse (the minimim
%             %     % of the two values)
%             %     collapseLevelCompTwo = min(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index - 1)));
%             % end    
% 
% %             % Sometimes there is an error where the first value after collapse in the processor is 100, so if the collapse Sa level is over 50, then just use the 
% %             %   collapse Sa level from the file that was opened.
% %                 if(collapseLevelCompTwo > 50.0)
% %                     collapseLevelCompTwo = collapseLevelFromFileOpened;
% %                 end
% 
%             collapseLevelCompTwo;
%             collapseSaLevel = collapseLevelCompTwo;
%             collapseLevelForAllComp(eqCompInd) = collapseLevelCompTwo;
% 
%         % Save a file for this EQ component
%             % Rename variables to be general to either component 1 or 2
%             maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC2;
%             saLevelsForMSAPlotPROCLIST = saLevelsForMSAPlotPROCLISTC2;
%             % Save file
%             eqCompColFileName = sprintf('DATA_collapse_ProcessedMSADataForThisEQ.mat');
%             save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForMSAPlotPROCLIST', 'collapseSaLevel');  
% 
%         % Clear the results from the last loop
%         clear maxDriftRatioForPlotLIST saLevelsForMSAPlotLIST 
% 
%         % Go back to the Matlab folder
%         cd ..;
%         cd ..;
%         cd ..;
%         cd psb_MatlabProcessors;
% 
%         eqCompInd = eqCompInd + 1;
% 
%     %%%%%%%%%%%%% END: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     %%%%%%%%%%%%%% START: Find component that controls the buiding collapse capacity and plot this on the seconds plot
% 
%     % Find the EQ component that controls and plot the controlling component
%     % if(collapseLevelCompTwo > collapseLevelCompOne)
% 
%     if collapseLevelCompOne <= collapseLevelCompTwo
%         controllingComp = 1;
%         collapseLevelForAllControlComp(eqInd) = collapseLevelCompOne;
%         ControllingCompNumLIST(eqInd) = eqNumber*10 + 1;
%     else
%         controllingComp = 2;
%         collapseLevelForAllControlComp(eqInd) = collapseLevelCompTwo;
%         ControllingCompNumLIST(eqInd) = eqNumber*10 + 2;
%     end
% 
% 
%     % Plot - note that the psuedoTimeVector is from the file that was opened 
%         figure(figureNumControllingComp);
%         hold on
% 
%     if controllingComp == 1
%         if(isConvertToSaKircher == 0)
%             plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForMSAPlotPROCLISTC1, markerTypeLine);
%         else
%             plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForMSAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine);
%         end
%     else
%         if(isConvertToSaKircher == 0)
%             plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForMSAPlotPROCLISTC2, markerTypeLine);
%         else
%             plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForMSAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine);
%         end
%     end   
% 
% 
% %             if(isConvertToSaKircher == 0)
% %                 % We want to use Sa,goeMean(T1), so do not do a conversion
% %                 plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForMSAPlotPROCLISTC1, markerTypeLine);
% % %             pause(1)
% %             else
% %                 % We want to plot with Sa,Kircher(T=1s)
% %                 plot(maxDriftRatioForPlotPROCLISTC1, saLevelsForMSAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine);
% %             end
% 
%         %     % Plot the points for each run, if told to
%         %     if(isPlotIndividualPoints == 1)
%         %         for i = 1:length(saLevelsForMSAPlotPROCLISTC1)
%         %             hold on
%         %             if(isConvertToSaKircher == 0)
%         %                 % We want to use Sa,goeMean(T1), so do not do a conversion
%         %                 plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForMSAPlotPROCLISTC1(i), markerTypeDot);
%         %             else
%         %                 % We want to plot with Sa,Kircher(T=1s)
%         %                 plot(maxDriftRatioForPlotPROCLISTC1(i), saLevelsForMSAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot);
%         %             end                    
%         %         end 
%         %     end
%         % 
%         % % Save the collapse capacity for this controlling component
%         % collapseLevelForAllControlComp(eqInd) = collapseLevelCompOne;
%         % % ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+1)];    
% 
% 
%     % else
%     %     temp = sprintf('EQ: %d - component 2 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompTwo);
%     %     disp(temp);
% 
%     %     % Plot - note that the psuedoTimeVector is from the file that was opened 
%     %         figure(figureNumControllingComp);
%     %         if(isConvertToSaKircher == 0)
%     %             % We want to use Sa,goeMean(T1), so do not do a conversion
%     %             plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForMSAPlotPROCLISTC2, markerTypeLine);
%     %         else
%     %             % We want to plot with Sa,Kircher(T=1s)
%     %             plot(maxDriftRatioForPlotPROCLISTC2, saLevelsForMSAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine);
%     %         end
%     % 
%     %         % Plot the points for each run, if told to
%     %         if(isPlotIndividualPoints == 1)
%     %             for i = 1:length(saLevelsForMSAPlotPROCLISTC2)
%     %                 hold on
%     %                 if(isConvertToSaKircher == 0)
%     %                     % We want to use Sa,goeMean(T1), so do not do a conversion
%     %                     plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForMSAPlotPROCLISTC2(i), markerTypeDot);
%     %                 else
%     %                     % We want to plot with Sa,Kircher(T=1s)
%     %                     plot(maxDriftRatioForPlotPROCLISTC2(i), saLevelsForMSAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot);
%     %                 end                    
%     %             end 
%     %         end
%     % 
%     %     % Save the collapse capacity for this controlling component
%     %     collapseLevelForAllControlComp(eqInd) = collapseLevelCompTwo;
%     %     ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+2)];
%     % end
% 
% 
%     % Store component 1
%     maxDriftRatioForPlotPROCLIST_ALL{end+1} = maxDriftRatioForPlotPROCLISTC1;
%     saLevelsForMSAPlotPROCLIST_ALL{end+1} = saLevelsForMSAPlotPROCLISTC1;
% 
%     % Store component 2
%     maxDriftRatioForPlotPROCLIST_ALL{end+1} = maxDriftRatioForPlotPROCLISTC2;
%     saLevelsForMSAPlotPROCLIST_ALL{end+1} = saLevelsForMSAPlotPROCLISTC2;
% 
% 
%     %%%%%%%%%%%%%% END: Find component that controls the buiding collapse capacity and plot this on the seconds plot
%     clear collapseSaLevelCompOne collapseSaLevelCompTwo isCollapseLISTPROCC1 maxDriftRatioForPlotPROCLISTC1 saLevelsForMSAPlotPROCLISTC1 isCollapseLISTPROCC2 maxDriftRatioForPlotPROCLISTC2 saLevelsForMSAPlotPROCLISTC2 saLevelsForMSAPlotPROCLISTC1_KircherAtOneSec saLevelsForMSAPlotPROCLISTC2_KircherAtOneSec;
% % end
% 
% 
% % if we want are plotting and storing the results using Sa,Kircher(1s),
% % then convert the vectors now so everything is based on the correct
% % definition of Sa,Kricher(1s).  NOTE that if we modify the Sa values to 
% % report in the way for Kircher/ATC-63, the .mat results files will
% % clearly be labeled to say they are based on Sa,Kircher.
% 
%     % Convert to Sa,Kircher if needed
%     if(isConvertToSaKircher == 0)
%         % We want to use Sa,goeMean(T1), so do not do a conversion
%     else
%         % OLD WITH ERROR - NO LOOP; we were just using the conversion from
%         % the last EQ in the previous loop - totally wrong!
%         % We want to convert to Sa,Kircher(T=1s), so do conversion
%         %saGeoMeanAtOneSec = RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat);
%         %saGeoMeanAtTOne = RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat);
%         %collapseLevelForAllComp = collapseLevelForAllComp.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
%         %collapseLevelForAllControlComp = collapseLevelForAllControlComp.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
% 
%         % NEW - loop added so we loop over EQs and compute
%         % Loop for all components
%         for eqInd = 1:(length(eqCompNumberLIST))
%             eqCompNumber = eqCompNumberLIST(eqInd);
%             eqNumber = floor(eqCompNumber/10);
% 
%             saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat);
%             saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat);
%             collapseLevelForAllComp(eqInd) = collapseLevelForAllComp(eqInd) * (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
%         end
% 
%         % Loop for controling components
%         for eqInd = 1:(length(eqNumberLIST))
%             eqNumber = eqNumberLIST(eqInd);
%             % Just use component one because we need a dummy component
%             % number to do the Kircher converstion later
%             eqCompNumber = eqNumber * 10.0 + 1.0;
% 
%             saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat);
%             saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat);
%             collapseLevelForAllControlComp(eqInd) = collapseLevelForAllControlComp(eqInd) * (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
%         end    
% 
%         clear saGeoMeanAtOneSec saGeoMeanAtTOne
%     end
% 
% % Do collapse statistics - for all components
%     analysisType;
%     meanCollapseSaTOneAllComp = mean(collapseLevelForAllComp);
%     medianCollapseSaTOneAllComp = (median(collapseLevelForAllComp));
%     meanLnCollapseSaTOneAllComp = mean(log(collapseLevelForAllComp));
%     stDevCollapseSaTOneAllComp = std(collapseLevelForAllComp);
%     stDevLnCollapseSaTOneAllComp = std(log(collapseLevelForAllComp));
% 
% % Do collapse statistics - for controlling components
%     analysisType;
%     meanCollapseSaTOneControlComp = mean(collapseLevelForAllControlComp);
%     medianCollapseSaTOneControlComp = (median(collapseLevelForAllControlComp));
%     meanLnCollapseSaTOneControlComp = mean(log(collapseLevelForAllControlComp));
%     stDevCollapseSaTOneControlComp = std(collapseLevelForAllControlComp);
%     stDevLnCollapseSaTOneControlComp = std(log(collapseLevelForAllControlComp));
% 
% % Save collapse results file
%     % Go to the correct folder
%         cd ..
%         cd Output
%         analysisTypeFolder = sprintf('%s', analysisType);
%         cd(analysisTypeFolder);
% 
%     % Save results     
%     if(isConvertToSaKircher == 0)
%         % This is Sa,geoMean
%         colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', eqListForCollapseMSAs_Name);
%     else
%         % This is Sa,ATC-63 (or Sa,Kircher)
%         colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63.mat', eqListForCollapseMSAs_Name);        
%     end
% 
%         save(colFileName, 'analysisType', 'collapseLevelForAllComp', 'collapseLevelForAllControlComp', 'eqNumberLIST', 'meanCollapseSaTOneAllComp',...
%             'medianCollapseSaTOneAllComp', 'meanLnCollapseSaTOneAllComp', 'stDevCollapseSaTOneAllComp',...
%             'stDevLnCollapseSaTOneAllComp', 'meanCollapseSaTOneControlComp', 'medianCollapseSaTOneControlComp',...
%             'meanLnCollapseSaTOneControlComp', 'stDevCollapseSaTOneControlComp', 'stDevLnCollapseSaTOneControlComp', 'eqCompNumberLIST', 'ControllingCompNumLIST', 'periodUsedForScalingGroundMotions');
% 
% 
%         % Do final plot details - figure for all components
%         figure(figureNumAllComp)
%         hold on
%         grid on
% 
%         %titleText = sprintf('Incremental Dynamic Analysis, ALL Components, %s', analysisType);
%         %title(titleText);
%         if(isConvertToSaKircher == 0)
%             titleTemp = sprintf('Sa_{geoM}(T_{1}=%.2fs) (g)', periodUsedForScalingGroundMotions);
%         else
%             titleTemp = axisLabelForSaKircher;
%         end
%         hy = ylabel(titleTemp);
%         hx = xlabel('Max Interstory Drift Ratio');
% %         hx = xlabel('Maximum Interstory Drift Ratio');
%         xlim([0, maxXOnAxis])
%         FigureFormatScript
% 
%         % Save the plot
%         if(isConvertToSaKircher == 0)
%             % This is Sa,geoMean            
%             % Save the plot as a .fig file
%             % File name shortened to make it save file correctly (1-14-09 CBH)
%             %plotName = sprintf('CollapseIDA_AllComp_%s_%s_SaGeoMean.fig', analysisType, eqListForCollapseIDAs_Name);
%             exportName = sprintf('CollapseMSA_AllComp_SaGeoMean');
%             print('-dmeta', exportName);            
%            hgsave(exportName); % .fig file for Matlab
%            print('-depsc', exportName); % .eps file for Linux (LaTeX)
%            print('-dmeta', exportName); % .emf file for Windows (MSWORD)  
%         else
%             % This is Sa,ATC-63 (or Sa,Kircher)
%             % Save the plot as a .fig file
%             % File name shortened to make it save file correctly (1-14-09 CBH)
%             %plotName = sprintf('CollapseIDA_AllComp_%s_%s_SaATC63.fig', analysisType, eqListForCollapseIDAs_Name);
%             exportName = sprintf('CollapseMSA_AllComp_SaATC63');
%             print('-dmeta', exportName);            
%            hgsave(exportName); % .fig file for Matlab
%            print('-depsc', exportName); % .eps file for Linux (LaTeX)
%            print('-dmeta', exportName); % .emf file for Windows (MSWORD)     
%         end
% 
%         hold off
% 
% % Do final plot details - figure for controlling components
%         figure(figureNumControllingComp);
%         hold on
%         grid on
%         %titleText = sprintf('Incremental Dynamic Analysis, ONLY Controlling Component, %s', analysisType);
%         %title(titleText);
%         if(isConvertToSaKircher == 0)
% %             titleTemp = sprintf('Sa_{g.m.}(T_{1}=%.2fs) [g]', periodUsedForScalingGroundMotions);
%             titleTemp = sprintf('Sa_{geoM}(T_{1}=%.2fs) (g)', periodUsedForScalingGroundMotions);
%         else
%             titleTemp = axisLabelForSaKircher;
%         end
%         hy = ylabel(titleTemp);
%         hx = xlabel('Max Interstory Drift Ratio');
%         xlim([0, maxXOnAxis])
%         FigureFormatScript
% 
%         % Save the plot
%         if(isConvertToSaKircher == 0)
%             % This is Sa,geoMean  
%             % Save the plot as a .fig file
%             % File name shortened to make it save file correctly (1-14-09 CBH)
%             %plotName = sprintf('CollapseIDA_ControlComp_%s_%s_SaGeoMean.fig', analysisType, eqListForCollapseIDAs_Name);
%             exportName = sprintf('CollapseMSA_ControlComp_SaGeoMean');
%             % print('-dmeta', exportName);            
%            hgsave(exportName); % .fig file for Matlab
%            print('-depsc', exportName); % .eps file for Linux (LaTeX)
%            print('-dmeta', exportName); % .emf file for Windows (MSWORD)            
% 
%         else
%             % This is Sa,ATC-63 (or Sa,Kircher)
%             % Save the plot as a .fig file
%             % File name shortened to make it save file correctly (1-14-09 CBH)
%             %plotName = sprintf('CollapseIDA_ControlComp_%s_%s_SaATC63.fig', analysisType, eqListForCollapseIDAs_Name);
%             exportName = sprintf('CollapseMSA_ControlComp_SaATC63');
%             % print('-dmeta', exportName);            
%            hgsave(exportName); % .fig file for Matlab
%            print('-depsc', exportName); % .eps file for Linux (LaTeX)
%            print('-dmeta', exportName); % .emf file for Windows (MSWORD)            
% 
%         end
%         hold off  
% 
%        % Go back to the MatlabProcessor folder
%         cd ..;
%         cd ..;
%         cd ..;
%         cd psb_MatlabProcessors;
% 
% end  
% 
% 
% 
% 
% %         %% --- Plot for ALL Components (MSA style scatter) ---
% % figure(figureNumAllComp);
% % hold on; grid on;
% % 
% % % Loop over all EQ components
% % for eqInd = 1:length(eqCompNumberLIST)
% %     scatter(maxDriftRatioForPlotPROCLIST_ALL{eqInd}, saLevelsForMSAPlotPROCLIST_ALL{eqInd}, 25, 'b', 'filled'); % blue dots
% % end
% % 
% % % Collapse threshold line
% % xline(collapseDriftThreshold, '--r', 'Collapse Threshold');
% % 
% % xlabel('Max Interstory Drift Ratio');
% % if(isConvertToSaKircher == 0)
% %     ylabel(sprintf('Sa_{geoM}(T_1=%.2fs) (g)', periodUsedForScalingGroundMotions));
% % else
% %     ylabel(axisLabelForSaKircher);
% % end
% % title('MSA Collapse Scatter - All Components');
% % xlim([0, maxXOnAxis]);
% % FigureFormatScript;
% % 
% % % Save the plot
% % exportName = 'CollapseMSA_AllComp_Scatter';
% % hgsave(exportName); % .fig
% % print('-depsc', exportName); % .eps
% % print('-dmeta', exportName); % .emf
% % hold off;
% % 
% % %% --- Plot for Controlling Components (MSA style scatter) ---
% % figure(figureNumControllingComp);
% % hold on; grid on;
% % 
% % % Loop over all EQs, plot controlling component only
% % for eqInd = 1:length(eqNumberLIST)
% %     eqCompID = ControllingCompNumLIST(eqInd);   % e.g., 11, 12, 21, 22...
% % 
% %     % Convert EQ component ID → cell index
% %     compIndex = find(eqCompNumberLIST == eqCompID);
% %     scatter(maxDriftRatioForPlotPROCLIST_ALL{compIndex}, saLevelsForMSAPlotPROCLIST_ALL{compIndex}, 25, 'b', 'filled');
% % end
% % 
% % 
% % % Collapse threshold line
% % xline(collapseDriftThreshold, '--r', 'Collapse Threshold');
% % xlabel('Max Interstory Drift Ratio');
% % if(isConvertToSaKircher == 0)
% %     ylabel(sprintf('Sa_{geoM}(T_1=%.2fs) (g)', periodUsedForScalingGroundMotions));
% % else
% %     ylabel(axisLabelForSaKircher);
% % end
% % 
% % title('MSA Collapse Scatter - Controlling Components');
% % xlim([0, maxXOnAxis]);
% % FigureFormatScript;
% % 
% % % Save the plot
% % exportName = 'CollapseMSA_ControlComp_Scatter';
% % hgsave(exportName); % .fig
% % print('-depsc', exportName); % .eps
% % print('-dmeta', exportName); % .emf
% % hold off;
% 
% 
% 
% 
% 
% 
