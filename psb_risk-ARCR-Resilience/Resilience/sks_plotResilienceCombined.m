function sks_plotResilienceCombined(Res)
% sks_plotResilienceCombined.m
% Plots of all buildings together for sks_MasterDriver_ScenarioBasedHousingRecAndRes.m (called once, after the
% building loop). The per-building figures are drawn inside the loop by sks_plotResilience.m.
%
% Inputs: Res - struct array of the master, one element per building (Res(k)). Fields used:
%               buildingID, T1forIM, Sa_MCE, meanSa, sigmaLn, beta_MDL_DR_TD, N1, M, Rjb, GMPM, baseFolder, dirForFigures,
%               timeArray, meanExpectedHousingFunction, sigmaHouse, Sa_realizations
% Calls : sks_figureFormat.m, sks_figureExport.m
% Saves : figures 301, 302, 303 (all buildings, colour by building) and the legend/captions of 786, in dirForFigures;
%         prints the table of T1, median and beta_RTR of all buildings
% Note  : sks_figureFormat sets the LaTeX interpreter on labels/legends and moves legends to northeast,
%         so labels use $...$ and legend locations are re-set after each sks_figureFormat call.

% inputs common to all buildings (same names as in the master)
nBldg = numel(Res);
buildingIDLIST = {Res.buildingID}';
M = Res(1).M;  
Rjb = Res(1).Rjb;  
GMPM = Res(1).GMPM;  
N1 = Res(1).N1;  
beta_MDL_DR_TD = Res(1).beta_MDL_DR_TD;
baseFolder = Res(1).baseFolder;  
dirForFigures = Res(1).dirForFigures;
colors = Res.colors;

oldDir = pwd;  cleanupDir = onCleanup(@() cd(oldDir));   % return to the calling folder, also after an error
figDir = fullfile(baseFolder, dirForFigures);
if ~exist(figDir, 'dir'); mkdir(figDir); end

%% 2c. formatting the recovery trajectory for saving (plotted under fun3)
    figure(301);
    plotStyleRec = {'-'};                        % solid for every building; colour from colors(building, :)
    h3 = gobjects(1, nBldg);
    for k = 1:nBldg
        plot(Res(k).timeArray, Res(k).meanExpectedHousingFunction, plotStyleRec{1}, 'Color', colors(k, :), 'LineWidth', 2.0); hold on; grid on;
        % pre-earthquake occupancy and the drop at t = 0
        A = [-100 0 0]; B = [1 1 Res(k).meanExpectedHousingFunction(1, 1)];
        plot(A, B, 'k-', 'LineWidth', 1.5);
    end
    set(gca, 'XTick', 0:50:200);
    xlim([-50 200]); ylim([0 1.1]);

    % dummy plots outside the range, one per building, for the legend
    for k = 1:nBldg
        h3(k) = plot(2000, 1, plotStyleRec{1}, 'Color', colors(k, :), 'LineWidth', 2.0);
    end
    % hlegend = legend(h3(1:nBldg), strrep(buildingIDLIST', '_', '\_'), 'Location', 'SouthEast');   % legend by building ID
    hlegend = legend(h3(1:nBldg), replace(buildingIDLIST', {'46053v02', '35053v02'}, {'5S-Prop-VH', '5S-2016-VH'}), 'Location', 'SouthEast');   % legend by building name used in paper

    str1 = 'Time (days)'; str2 = 'Normalized Occupancy, $Q(t)$';
    xlabel(str1);
    ylabel(str2);
    sks_figureFormat('powerpoint');
    hlegend.Location = 'southeast';              
    cd(figDir);
    exportName = strrep(sprintf('RecCur_Combined_M%g_R%g_%s_R1', M, Rjb, GMPM), '.', 'p');
    sks_figureExport(exportName);


% (psb, 10-14-22 R2) plotting uncertainty in RESILIENCE. I am using normal distribution parameters and reporting only the standard deviation
% in the data. Note that using lognormal here does not make sense, becase the parameter of interest is time versus the housing capacity.

%% 2d. uncertainty in the recovery trajectory (for R2 in Spectra)
    figure(302);
    h4 = gobjects(1, nBldg);
    for k = 1:nBldg
        h4(k) = plot(Res(k).timeArray, Res(k).sigmaHouse, plotStyleRec{1}, 'Color', colors(k, :), 'LineWidth', 2.0); hold on; grid on;
    end
    set(gca, 'XTick', 0:50:200); xlim([0 200]); ylim([0 0.5]);
    % legend(h4, strrep(buildingIDLIST', '_', '\_'), 'Location', 'NorthEast');   % legend by building ID
    legend(h4, replace(buildingIDLIST', {'46053v02', '35053v02'}, {'5S-Prop-VH', '5S-2016-VH'}), 'Location', 'NorthEast');   % legend by building name used in paper
    str1 = 'Time (days)'; str2 = 'Uncertainty, $\sigma_{Q(t)}$'; xlabel(str1); ylabel(str2);
    sks_figureFormat('powerpoint');
    cd(figDir);
    exportName = strrep(sprintf('RecCur_Combined_M%g_R%g_%s_Uncertainty_R2', M, Rjb, GMPM), '.', 'p');
    sks_figureExport(exportName);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2e. combined fragility figure with three fragilities and legend at top-outside (tiles drawn in sks_plotResilience.m)
    figure(786);
    axLast = nexttile(nBldg);                                                          % tile of the last building
    h1 = flipud(findobj(axLast, 'Type', 'line'));                                      % its LS1-LSn fragility lines, in plotting order
    nLS = numel(h1);                                                                   % number of limit states (= numel(DS_StoryDriftLIST))
    legTxt = [compose('$LS_%d \\qquad$', 1:nLS-1), {sprintf('$LS_%d\\,\\,$', nLS)}];   % {'$LS_1 \qquad$', ..., '$LS_n\,\,$'}, same as the hand-written labels
    legh = legend(h1, legTxt, 'Orientation', 'Horizontal', 'Interpreter','latex');
    sks_figureFormat('powerpoint');
    legh.Layout.Tile = 'north';                            
    legh.Orientation = 'horizontal'; legh.NumColumns = nLS;

% I am now adding the subfigures captions here. LaTeX cannot do this because I am drawing one figure for all subfigures
    for k = 1:nBldg          % (a), (b), ... one caption per building tile
        nexttile(k); text(-0.4, -0.2, sprintf('(%c)', 'a' + k - 1), 'FontWeight','bold', 'FontSize', 16);
    end

    cd(figDir);
    exportName = 'combined_Frag_R2';
    sks_figureExport(exportName);  
%%%% end of block for saving the combined fragility figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2f. histogram of the Sa(T1)/Sa_MCE realizations of all buildings (from scriptHistogramSaRealizations_v1.m)
    edges = 0:0.1:1.5;
    counts = zeros(length(edges)-1, nBldg);
    for k = 1:nBldg
        counts(:, k) = histcounts(Res(k).Sa_realizations/Res(k).Sa_MCE, edges)';
    end

    figure(303);
    b = bar(edges(1:end-1), counts, 'BarWidth', 1.0); grid on;
    for k = 1:numel(b); b(k).FaceColor = colors(k, :); end                 % colour by building
    yt = get(gca, 'YTick'); set(gca, 'YTick', yt, 'YTickLabel', yt/N1);    % counts -> fraction of simulations
    xlabel('$Sa(T_1)/Sa_{MCE}$'); ylabel('Fraction of Simulations');
    legend(replace(buildingIDLIST, {'46053v02', '35053v02'}, {'5S-Prop-VH', '5S-2016-VH'}));   % building name used in paper
    sks_figureFormat('powerpoint');
    cd(figDir);
    exportName = strrep(sprintf('histogramCombined_Sa_M%g_R%g_%s', M, Rjb, GMPM), '.', 'p');
    sks_figureExport(exportName);   
%%%% end of block for the Sa realization histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2g. table of T1, median and beta_RTR of all buildings (figures 500+i are drawn in sks_plotResilience.m)
    periodT1 = [Res.T1forIM]';
    muCtrl = vertcat(Res.meanSa);
    betaLnCtrl = sqrt(vertcat(Res.sigmaLn).^2 - beta_MDL_DR_TD^2);       % master adds beta_MDL_DR_TD to beta_RTR; remove it again here
    T = table(buildingIDLIST, periodT1, muCtrl, betaLnCtrl);
    disp(T);
%%%% end of block for the record-to-record fragility table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
