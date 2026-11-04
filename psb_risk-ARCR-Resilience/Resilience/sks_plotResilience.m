function sks_plotResilience(Res, i)
% sks_plotResilience.m
% Per-building plots for sks_MasterDriver_ScenarioBasedHousingRecAndRes.m (called once per building, inside the loop).
% The figures of all buildings together are drawn after the loop by sks_plotResilienceCombined.m.
%
% Inputs: Res - struct of one building, Res(i) of the master. Fields used:
%               buildingID, T1forIM, legOn, Sa_MCE, meanSa, sigmaLn, nBldg, M, Rjb, GMPM, beta_MDL_DR_TD,
%               pcLIST, maximumHousingCapacity, rapidity_daysLIST, baseFolder, dirForFigures,
%               timeArray, meanHousingCapacityMatrix
%         i   - building index in the master loop (figure numbers and tile of figure 786)
% Calls : PlotLogNormalCDF_current.m, sks_ComputeRobRapRes.m, sks_figureFormat.m, sks_figureExport.m
% Saves : figures 100+i, 700+i, 800+i, 200+i, 400+i, 500+i (one per building) and tile i of 786, in dirForFigures
% Note  : sks_figureFormat sets the LaTeX interpreter on labels/legends and moves legends to northeast,
%         so labels use $...$ and legend locations are re-set after each sks_figureFormat call.

% inputs of this building (same names as in the master, so the plotting lines below are unchanged)
buildingID = Res.buildingID;  
T1forIM = Res.T1forIM;  
legOn = Res.legOn;
Sa_MCE = Res.Sa_MCE;  
meanSa = Res.meanSa;  
sigmaLn = Res.sigmaLn;  
beta_MDL_DR_TD = Res.beta_MDL_DR_TD;
M = Res.M;  
Rjb = Res.Rjb;  
GMPM = Res.GMPM;
pcLIST = Res.pcLIST;  
maximumHousingCapacity = Res.maximumHousingCapacity;  
rapidity_daysLIST = Res.rapidity_daysLIST;
timeArray = Res.timeArray;  
meanHousingCapacityMatrix = Res.meanHousingCapacityMatrix;
baseFolder = Res.baseFolder;  
dirForFigures = Res.dirForFigures;
colors = Res.colors;

oldDir = pwd;  cleanupDir = onCleanup(@() cd(oldDir));   % return to the calling folder, also after an error
figDir = fullfile(baseFolder, dirForFigures);
if ~exist(figDir, 'dir'); mkdir(figDir); end
strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');

%% combined fragility figure layout (created once, before the first building)
if i == 1
    figure(786); tiledlayout(1, Res.nBldg, 'TileSpacing','compact');   % one tile per building
    set(gcf, 'Position', [50 200 1500 460]);
end

nLS = numel(meanSa);                            % number of limit states (= numel(DS_StoryDriftLIST)); DS0..DSnLS gives nLS + 1 damage states
plotStyle = repmat({'-'}, 1, nLS);              % one solid style per LS; colors distinguish LS
legLS = compose('$LS_%d$', 1:nLS);              % legend labels LS_1 ... LS_nLS
legDS = compose('$DS_%d$', 1:nLS);              % legend labels DS_1 ... DS_nLS
colors = [colors; lines(max(0, max([nLS, numel(rapidity_daysLIST), Res.nBldg]) - size(colors, 1)))];   % extra colors only if more than 5 LS, control times or buildings

%% 2a. fragility curves (one figure per building)
    minValue = 0; maxValue = 4.0;
    figure(100 + i);       % one figure per building
    h1 = gobjects(1, nLS);   % LS1-LSn
    for LS = 1:nLS
        h1(LS) = PlotLogNormalCDF_current(log(meanSa(LS)/Sa_MCE), sigmaLn(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
        h1(LS).Color = colors(LS, :);
    end

    if legOn == 1
        legend(h1, legLS, 'Location', 'NorthEast');
    end

    xlim([minValue, maxValue]);
    str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; xlabel(str1, 'Interpreter', 'latex');
    ylabel(str2, 'Interpreter', 'latex');
    sks_figureFormat('powerpoint');

    cd(figDir);
    exportName = sprintf('%s_Frag_%s', buildingID, strForIM);
    sks_figureExport(exportName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% start of the block for single figure with three fragilities and legend at top-outside
%%%% the legend and captions are added in sks_plotResilienceCombined.m (2e)

%% 2x-i. fragility curves in tile i of the combined figure 786
    figure(786); nexttile(i);       % tile i = building i
    h1 = gobjects(1, nLS);   % LS1-LSn (2e reads these lines from the tile for the combined legend)
    for LS = 1:nLS
        h1(LS) = PlotLogNormalCDF_current(log(meanSa(LS)/Sa_MCE), sigmaLn(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
        h1(LS).Color = colors(LS, :);
    end
    
    xticks(1:maxValue);
    xlim([minValue, maxValue]);
    str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; xlabel(str1, 'Interpreter', 'latex');
    if i == 1 % y-axis label only for first building
        ylabel(str2, 'Interpreter', 'latex');
    end
    sks_figureFormat('powerpoint');

%%%% end of the block for single figure with three fragiities and legend at top-outside
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2x-ii. damage-state probability curves P[DS_i|IM] from the 2x fragility curves (Cao & Feng 2025, Eq. 7, Fig. 6d-f) % added on 31-oct-2026 by shivakumar ks, which needs still deep assessment
PoE = vertcat(h1(1:nLS).YData);                                             % F[LS_i|IM] already computed in 2x (nLS x 1001)
ProbLS = -diff([ones(1, size(PoE, 2)); PoE; zeros(1, size(PoE, 2))], 1, 1); % DS0..DSn ((nLS+1) x 1001), same as ProbLS in fun3/fun4

figure(700 + i);         % one figure per building
h2 = gobjects(1, nLS);   % DS1-DSn (h2 is re-created in 2b)
for LS = 1:nLS
    h2(LS) = plot(h1(1).XData, ProbLS(LS+1, :), plotStyle{LS}, 'Color', colors(LS, :), 'LineWidth', 2.0); hold on; grid on;
end

if legOn == 1
    legend(h2, legDS, 'Location', 'NorthEast');
end

xlim([minValue, maxValue]);
str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$P[DS_i|IM]$';
xlabel(str1, 'Interpreter', 'latex');
ylabel(str2, 'Interpreter', 'latex');
sks_figureFormat('powerpoint');
cd(figDir);
exportName = sprintf('%s_ProbDS_%s', buildingID, strForIM);
sks_figureExport(exportName);


%% 2x-iii. mean resilience index vs Sa(T1) for each control time (Cao & Feng 2025, Fig. 11a / 13a mean curve) % added on 31-oct-2026 by shivakumar ks, which needs still deep assessment
resLS = zeros(nLS + 1, numel(rapidity_daysLIST));               % R_i of each recovery path q_i(t), LS0..LSn
for LS = 1:nLS + 1
    robRapResLS = sks_ComputeRobRapRes(timeArray, meanHousingCapacityMatrix(LS, :), pcLIST, maximumHousingCapacity, rapidity_daysLIST, buildingID, 0);
    resLS(LS, :) = robRapResLS.resilience;
end
resMean = resLS' * ProbLS;                                      % E[R|IM] = sum_i P[DS_i|IM] * R_i (one row per control time)

targetResLIST = [0.75, 0.85, 0.95];
figure(800 + i);       % one figure per building
hRes = gobjects(1, numel(rapidity_daysLIST));
for iTc = 1:numel(rapidity_daysLIST)
    hRes(iTc) = plot(h1(1).XData, resMean(iTc, :), '-', 'Color', colors(iTc, :), 'LineWidth', 2.0); hold on; grid on;
    for iTg = 1:numel(targetResLIST)
        iCross = find(resMean(iTc, :) <= targetResLIST(iTg), 1);   % Sa/Sa_MCE at which E[R|IM] drops to the target
        plot(h1(1).XData(iCross), targetResLIST(iTg), 'o', 'MarkerFaceColor', colors(iTc, :), 'MarkerEdgeColor', 'w');
    end
end

if legOn == 1
    legend(hRes, compose('$T_c = %i$ days', rapidity_daysLIST), 'Location', 'NorthEast');
end

xlim([0, 2]); ylim([0, 1.02]);
str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = 'Resilience index, $E[R|IM]$'; xlabel(str1, 'Interpreter', 'latex');
ylabel(str2, 'Interpreter', 'latex');
sks_figureFormat('powerpoint');
cd(figDir);
exportName = sprintf('%s_ResVsSa_%s', buildingID, strForIM);
sks_figureExport(exportName);   

%% 2b. recovery paths q(t)|DS_i (one figure per building)
    figure(200 + i);       % one figure per building
    h2 = gobjects(1, nLS);   % DS1-DSn
    for LS = 1:nLS
        h2(LS) = plot(timeArray, meanHousingCapacityMatrix(LS+1, :), plotStyle{LS}, 'Color', colors(LS, :), 'LineWidth', 2.0); hold on; grid on;
    end

    if legOn == 1
        hlegend = legend(h2, legDS, 'Location', 'SouthEast');
    end

    xlim([0 700]);
    str1 = 'Time (days)'; str2 = 'Normalized Occupancy, $q(t)|DS_i$'; xlabel(str1); ylabel(str2);
    sks_figureFormat('powerpoint');
    if legOn == 1; hlegend.Location = 'southeast'; end     % sks_figureFormat moves legends to northeast
    cd(figDir);
    exportName = strrep(sprintf('%s_RecFun_M%g_R%g_%s_%s', buildingID, M, Rjb, GMPM, strForIM), '.', 'p');
    sks_figureExport(exportName);   

%% 2b-ii. recovery curves of all DS with the legend outside (one figure per building)
figure(400 + i)       % one figure per building
    for LS = 1:nLS
        plot(timeArray, meanHousingCapacityMatrix(LS+1, :), plotStyle{LS}, 'Color', colors(LS, :), 'LineWidth', 2.0); hold on; grid on;
    end

    % dummy plots outside the range, for the legend
    for LS = 1:nLS
        h2(LS) = plot(-1, 0, plotStyle{LS}, 'Color', colors(LS, :), 'LineWidth', 2.0);
    end
    legh = legend(h2(1:nLS), compose('$DS_%d$ ', 1:nLS), 'Location', 'North', 'Interpreter', 'latex');
    legh.NumColumns = 1; legh.Orientation = 'vertical'; legh.Location = 'eastoutside';
    % Figures with too many details need to be enlarged before saving
    set(gcf, 'Units', 'pixels', 'Position', [560,528,650,420]); % Enlarge figure. x0-y0-delX-delY
    set(gca, 'Units', 'pixels', 'Position', [73.8, 59.93,434,329.57]); % Enlarge axis. x0-y0-delX-delY

    xlim([0 700]);
    str1 = 'Time (days)'; str2 = 'Normalized Occupancy, $q(t)|DS_i$'; xlabel(str1); ylabel(str2);
    sks_figureFormat('powerpoint');
    legh.Location = 'eastoutside';                                     % sks_figureFormat moves legends to northeast
    set(gca, 'Units', 'pixels', 'Position', [73.8, 59.93,434,329.57]); % keep enlarged axis after legend move
    cd(figDir);
    exportName = strrep(sprintf('%s_RecFunCombined_M%g_R%g_%s_R2', buildingID, M, Rjb, GMPM), '.', 'p');
    sks_figureExport(exportName);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2g. fragility curves with record-to-record dispersion only (from scriptFragNormalizedBySaMCE.m)
% Plots F[LS_i | Sa(T1)/Sa_MCE] using beta_RTR only (no beta_MDL/DR/TD) and saves <ID>_Frag_<T1>_normalized;
% the table of T1, median and beta_RTR for all buildings is printed in sks_plotResilienceCombined.m.
sigmaLnRTR = sqrt(sigmaLn.^2 - beta_MDL_DR_TD^2);       % master adds beta_MDL_DR_TD to beta_RTR; remove it again here

    minValue = 0; maxValue = 3.0;
    figure(500 + i);       % one figure per building
    h5 = gobjects(1, nLS);   % LS1-LSn
    for LS = 1:nLS
        h5(LS) = PlotLogNormalCDF_current(log(meanSa(LS)/Sa_MCE), sigmaLnRTR(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
        h5(LS).Color = colors(LS, :);
    end

    if legOn == 1
        legend(h5, legLS, 'Location', 'NorthEast');
    end

    xlim([minValue, maxValue]);
    str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; xlabel(str1, 'Interpreter', 'latex');
    ylabel(str2, 'Interpreter', 'latex');

    if i > 1      % same axis size for all buildings (side-by-side figures): take it from building 1 (figure 501)
        hFig1 = findobj('Type', 'figure', 'Number', 501);
        set(gca, 'InnerPosition', hFig1.CurrentAxes.InnerPosition);
    end
    
    sks_figureFormat('powerpoint');
    cd(figDir);
    exportName = sprintf('%s_Frag_%s_normalized', buildingID, strForIM);
    sks_figureExport(exportName);   
%%%% end of block for the record-to-record fragility curves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
