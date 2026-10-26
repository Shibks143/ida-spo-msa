% sks_plotResilience.m
% Plots for masterScriptRES_v3_CND_forR2_withUncInRES_AlsoFrags.m
% This is a SCRIPT (not a function): it runs inside the building loop and uses the master's workspace.
%
% Uses : i, buildingIDLIST, buildingID, GMsuiteName, legOn, Sa_MCE, meanSa, sigmaLn, T1forIM, timeArray,
%        meanHousingCapacityMatrix, meanExpectedHousingFunction, sigmaHouse, M, Rjb, GMPM, baseFolder, dirForFigures
% Calls: PlotLogNormalCDF_current.m, sks_figureFormat.m, sks_figureExport.m
% Saves: figures 100+, 786, 200+, 401, 301, 302 (.fig, .eps, .tiff, .emf) in dirForFigures
% Note : sks_figureFormat sets the LaTeX interpreter on labels/legends and moves legends to northeast,
%        so labels use $...$ and legend locations are re-set after each sks_figureFormat call.

%% combined fragility figure layout (created once, before the first building)
if i == 1
    figure(786); t = tiledlayout(1, 3, 'TileSpacing','compact'); 
    set(gcf, 'Position', [50 200 1500 460]);
end

if strcmp(GMsuiteName, 'GMSetC')
    plotStyle = {'r-', 'b-', 'g-', 'c-', 'm-'};
elseif strcmp(GMsuiteName, 'GMSetG')
    plotStyle = {'r--', 'b--', 'g--', 'c--', 'm--'};
end

%% 2a. formatting the fragility curves for saving (ploted under fun3)
    minValue = 0; maxValue = 5.0;
    figure(100 + floor((i+1)/2));
    h1 = gobjects(1, 7);   % LS1-LS5 + two dummy lines (FF, NF)
    for LS = 1:5 %
        h1(LS) = PlotLogNormalCDF_current(log(meanSa(LS)/Sa_MCE), sigmaLn(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
    end

    if legOn == 1
        h1(6) = plot(4, 1, 'k-', 'LineWidth', 1.5); h1(7) = plot(4, 1, 'k--', 'LineWidth', 1.5); % dummy plots outside the range
        hlegend = legend(h1, {'$LS_1$', '$LS_2$', '$LS_3$', '$LS_4$', '$LS_5$', 'FF', 'NF'}, 'Location', 'NorthEast');
    end

    xlim([minValue, maxValue]);
    str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; xlabel(str1, 'Interpreter', 'latex');
    if floor((i+1)/2) == 1 % y-axis label only for first figure
        ylabel(str2, 'Interpreter', 'latex');
    end
    sks_figureFormat('paper');
    
    cd(baseFolder);  
    if ~exist(dirForFigures, 'dir'); mkdir(dirForFigures); end
    cd(dirForFigures);
    strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
    exportName = sprintf('%s_Frag_%s', buildingID, strForIM);
    sks_figureExport(exportName);   % .fig, .eps, .tiff, .emf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% start of the block for single figure with three fragilities and legend at top-outside
%%%% (CND_paper R1)

cd(baseFolder);
%% 2x. formatting the fragility curves for saving (ploted under fun3)
    minValue = 0; maxValue = 5;
    figure(786); nexttile(floor((i+1)/2));
    h1 = gobjects(1, 5);   % LS1-LS5 (2e uses h1(1:5) for the combined legend)
    for LS = 1:5 %
        h1(LS) = PlotLogNormalCDF_current(log(meanSa(LS)/Sa_MCE), sigmaLn(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
        xticks(1:5); % yticks(0:0.2:1);
    end

%     if legOn == 1
%         h1(6) = plot(4, 1, 'k-', 'LineWidth', 1.5); h1(7) = plot(4, 1, 'k--', 'LineWidth', 1.5); % dummy plots outside the range
%         hlegend = legend([h1], {'LS_1', 'LS_2', 'LS_3', 'LS_4', 'LS_5', 'FF', 'NF'}, 'Location', 'NorthEast');
%     end

    xlim([minValue, maxValue]);
    str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; xlabel(str1, 'Interpreter', 'latex');
    if i == 1 % y-axis label only for first building
        ylabel(str2, 'Interpreter', 'latex');
    end
    sks_figureFormat('paper');
    
%%%% end of the block for single figure with three fragiities and legend at top-outside
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2b. formatting the recovery curves for saving (plotted under fun3)
    figure(200 + floor((i+1)/2));
    h2 = gobjects(1, 5);   % DS1-DS5
    for LS = 1:5 %
        h2(LS) = plot(timeArray, meanHousingCapacityMatrix(LS+1, :), plotStyle{LS}, 'LineWidth', 1.5); hold on; grid on;
    end

    if legOn == 1
%         hlegend = legend([h2], {'LS_1', 'LS_2', 'LS_3', 'LS_4', 'LS_5'}, 'Location', 'SouthEast');
        hlegend = legend(h2, {'$DS_1$', '$DS_2$', '$DS_3$', '$DS_4$', '$DS_5$'}, 'Location', 'SouthEast'); % R2
    end

    xlim([0 700]);
%     str1 = 'Time (days)'; str2 = 'Normalized Occupancy, q(t)|LS_i'; hx = xlabel(str1); hy = ylabel(str2);
    str1 = 'Time (days)'; str2 = 'Normalized Occupancy, $q(t)|DS_i$'; xlabel(str1); ylabel(str2); % R2
    sks_figureFormat('paper');
    if legOn == 1; hlegend.Location = 'southeast'; end     % sks_figureFormat moves legends to northeast
    
    cd(baseFolder);  cd(dirForFigures);
    exportName = sprintf('%s_RecFun_M%ip%i_R%i_%s_%s', buildingID, floor(M), int8(mod(M*10, 10)), Rjb, GMPM, strForIM);
    sks_figureExport(exportName);   % .fig, .eps, .tiff, .emf

figure(401)
    colorList = {'r', 'b', 'g', 'c', 'm'}; % limit state specific 
    lineStyleList = {'-', '--', '-.'}; % building specific
    for LS = 1:5
        plot(timeArray, meanHousingCapacityMatrix(LS+1, :), [colorList{LS} lineStyleList{floor((i+1)/2)}], 'LineWidth', 1.5); hold on; grid on;
    end

    if i == size(buildingIDLIST, 1) && LS == 5
        h2(1) = plot(-1, 0, [colorList{1} lineStyleList{1}], 'LineWidth', 1.5);        h2(2) = plot(-1, 0, [colorList{2} lineStyleList{1}], 'LineWidth', 1.5);
        h2(3) = plot(-1, 0, [colorList{3} lineStyleList{1}], 'LineWidth', 1.5);        h2(4) = plot(-1, 0, [colorList{4} lineStyleList{1}], 'LineWidth', 1.5);
        h2(5) = plot(-1, 0, [colorList{5} lineStyleList{1}], 'LineWidth', 1.5);        
        h2(6) = plot(-1, 0, ['k' lineStyleList{1}], 'LineWidth', 1.5);
        h2(7) = plot(-1, 0, ['k' lineStyleList{2}], 'LineWidth', 1.5);        h2(8) = plot(-1, 0, ['k' lineStyleList{3}], 'LineWidth', 1.5);

%         legh = legend(h2, {'LS_1 ', 'LS_2 ', 'LS_3 ', 'LS_4 ', 'LS_5', '3-Story', '6-Story', '9-Story'}, 'Location', 'North', 'Interpreter', 'tex');
%         legh = legend(h2(1:5), {'LS_1 ', 'LS_2 ', 'LS_3 ', 'LS_4 ', 'LS_5'}, 'Location', 'North', 'Interpreter', 'tex');
        legh = legend(h2(1:5), {'$DS_1$ ', '$DS_2$ ', '$DS_3$ ', '$DS_4$ ', '$DS_5$'}, 'Location', 'North', 'Interpreter', 'latex'); % R2
        legh.NumColumns = 1; legh.Orientation = 'vertical'; legh.Location = 'eastoutside';
        % Figures with too many details need to be enlarged before saving
        set(gcf, 'Units', 'pixels', 'Position', [560,528,650,420]); % Enlarge figure. x0-y0-delX-delY
        set(gca, 'Units', 'pixels', 'Position', [73.8, 59.93,434,329.57]); % Enlarge axis. x0-y0-delX-delY
        
        xlim([0 700]);
        str1 = 'Time (days)'; str2 = 'Normalized Occupancy, $q(t)|DS_i$'; xlabel(str1); ylabel(str2);
        sks_figureFormat('paper');
        legh.Location = 'eastoutside';                                     % sks_figureFormat moves legends to northeast
        set(gca, 'Units', 'pixels', 'Position', [73.8, 59.93,434,329.57]); % keep enlarged axis after legend move

        cd(baseFolder);  cd(dirForFigures);
        exportName = sprintf('RecFunCombined_M%ip%i_R%i_%s_R2', floor(M), int8(mod(M*10, 10)), Rjb, GMPM);
        sks_figureExport(exportName);   % .fig, .eps, .tiff, .emf
    end


%% 2c. formatting the recovery trajectory for saving (ploted under fun3)
%     figure(300 + floor((i+1)/2));
    figure(301);
    if strcmp(GMsuiteName, 'GMSetC')
        plotStyleRec = {'r-', 'b-', 'g-'};
    elseif strcmp(GMsuiteName, 'GMSetG')
        plotStyleRec = {'r--', 'b--', 'g--'};
    end

    % arrays to plot the pre-earthquake occupancy
    h3(6) = plot(timeArray, meanExpectedHousingFunction, plotStyleRec{floor((i+1)/2)}, 'LineWidth', 1.5); hold on; grid on;
    
    A = [-100 0 0]; B = [1 1 meanExpectedHousingFunction(1, 1)]; 
    h3(7) = plot(A, B, 'k-', 'LineWidth', 1.5); 
    set(gca, 'XTick', 0:50:200);
    xlim([-50 200]); ylim([0 1.1]);
    
    if i == size(buildingIDLIST, 1) % add dummy legends in the last plot
    % dummy plots outside the range
        h3(1) = plot(2000, 1, plotStyleRec{1}, 'LineWidth', 1.5); h3(2) = plot(2000, 1, plotStyleRec{2}, 'LineWidth', 1.5);
        h3(3) = plot(2000, 1, plotStyleRec{3} , 'LineWidth', 1.5);

        h3(4) = plot(2000, 1, 'k-', 'LineWidth', 1.5); h3(5) = plot(2000, 1, 'k--', 'LineWidth', 1.5);
%         hlegend = legend(h3(1:5), {'3-Story', '6-Story', '9-Story', 'FF', 'NF'}, 'Location', 'SouthEast');
        hlegend = legend(h3(6), {'5-Story'}, 'Location', 'SouthEast');
% hlegend = legend(h3(1:3), {'3-Story', '6-Story', '9-Story'}, 'Location', 'SouthEast');

    end
    str1 = 'Time (days)'; str2 = 'Normalized Occupancy, $Q(t)$'; xlabel(str1); ylabel(str2);
    sks_figureFormat('paper');
    if i == size(buildingIDLIST, 1); hlegend.Location = 'southeast'; end   % sks_figureFormat moves legends to northeast
    
    cd(baseFolder);  cd(dirForFigures);
    exportName = sprintf('RecCur_Combined_M%ip%i_R%i_%s_R1', floor(M), int8(mod(M*10, 10)), Rjb, GMPM);
    sks_figureExport(exportName);   % .fig, .eps, .tiff, .emf


% (psb, 10-14-22 R2) plotting uncertainty in RESILIENCE. I am using normal distribution parameters and reporting only the standard deviation 
% in the data. Note that using lognormal here does not make sense, becase the parameter of interest is time versus the housing capacity.

%% 2d. uncertainty in the recovery trajectory (for R2 in Spectra)
    if strcmp(GMsuiteName, 'GMSetC')
        plotStyleRec = {'r-', 'b-', 'g-'};
    elseif strcmp(GMsuiteName, 'GMSetG')
        plotStyleRec = {'r--', 'b--', 'g--'};
    end

    figure(302);
    h4(i) = plot(timeArray, sigmaHouse, plotStyleRec{floor((i+1)/2)}, 'LineWidth', 1.5); hold on; grid on;

    set(gca, 'XTick', 0:50:200); xlim([0 200]); ylim([0 0.5]);
    
    if i == size(buildingIDLIST, 1) % add dummy legends in the last plot
        hlegend = legend(h4(i), {'5-Story'}, 'Location', 'NorthEast');
        % hlegend = legend(h4(2:2:6), {'3-Story', '6-Story', '9-Story'}, 'Location', 'NorthEast');
    end
    str1 = 'Time (days)'; str2 = 'Uncertainty, $\sigma_{Q(t)}$'; xlabel(str1); ylabel(str2);
    sks_figureFormat('paper');
    
    cd(baseFolder);  cd(dirForFigures);
    exportName = sprintf('RecCur_Combined_M%ip%i_R%i_%s_Uncertainty_R2', floor(M), int8(mod(M*10, 10)), Rjb, GMPM);
    sks_figureExport(exportName);   % .fig, .eps, .tiff, .emf


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2e. combined fragility figure with three fragilities and legend at top-outside (after the last building)
if i == size(buildingIDLIST, 1)
    figure(786);

    legTxt = {'$LS_1 \qquad$', '$LS_2 \qquad$', '$LS_3 \qquad$', '$LS_4 \qquad$', '$LS_5\,\,$'};
    legh = legend(h1(1:5), legTxt, 'Orientation', 'Horizontal', 'Interpreter','latex');

    sks_figureFormat('paper');
    legh.Layout.Tile = 'north';                             % after formatting: sks_figureFormat moves legends to northeast
    legh.Orientation = 'horizontal'; legh.NumColumns = 5;

% I am now adding the subfigures captions here. LaTeX cannot do this because I am drawing one figure for three subfigures
    text(-0.4, -0.2, '(c)', 'FontWeight','bold', 'FontSize', 16); % last tile is active, hence axis system follows that.
    text(-6.23, -0.2, '(b)', 'FontWeight','bold', 'FontSize', 16);
    text(-12.06, -0.2, '(a)', 'FontWeight','bold', 'FontSize', 16);

    cd(baseFolder);  if ~exist(dirForFigures, 'dir'); mkdir(dirForFigures); end
    cd(dirForFigures);
    exportName = sprintf('combined_Frag_%s', 'R2');
    sks_figureExport(exportName);   % .fig, .eps, .tiff, .emf
end
%%%% end of block for saving the combined fragility figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2f. histogram of the Sa(T1)/Sa_MCE realizations of all buildings (from scriptHistogramSaRealizations_v1.m)
Sa_relz(:, i) = Sa_realizations/Sa_MCE;                 % one column per building

if i == size(buildingIDLIST, 1)
    edges = 0:0.1:1.5;
    counts = zeros(length(edges)-1, size(Sa_relz, 2));
    for k = 1:size(Sa_relz, 2)
        counts(:, k) = histcounts(Sa_relz(:, k), edges)';
    end

    figure(303);
    b = bar(edges(1:end-1), counts, 'BarWidth', 1.0); grid on;
    colorList = {'r', 'b', 'g', 'c', 'm'};
    for k = 1:numel(b); b(k).FaceColor = colorList{k}; end

    yt = get(gca, 'YTick'); set(gca, 'YTick', yt, 'YTickLabel', yt/N1);    % counts -> fraction of simulations

    xlabel('$Sa(T_1)/Sa_{MCE}$'); ylabel('Fraction of Simulations');
    legend(strrep(buildingIDLIST, '_', '\_'));                      % building IDs (escape '_' for LaTeX)
    sks_figureFormat('paper');

    cd(baseFolder);  cd(dirForFigures);
    exportName = sprintf('histogramCombined_Sa_M%ip%i_R%i_%s', floor(M), int8(mod(M*10, 10)), Rjb, GMPM);
    sks_figureExport(exportName);   % .fig, .eps, .tiff, .emf
end
%%%% end of block for the Sa realization histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2g. fragility curves with record-to-record dispersion only (from scriptFragNormalizedBySaMCE.m)
% Plots P[DS_i | Sa(T1)/Sa_MCE] using beta_RTR only (no beta_MDL/DR/TD), saves <ID>_Frag_<T1>_normalized, 
% and prints a table of T1, median and beta_RTR for all buildings.
sigmaLnRTR = sqrt(sigmaLn.^2 - beta_MDL_DR_TD^2);       % master adds beta_MDL_DR_TD to beta_RTR; remove it again here

    minValue = 0; maxValue = 3.0;
    figure(500 + floor((i+1)/2));
    h5 = gobjects(1, 7);   % LS1-LS5 + two dummy lines (FF, NF)
    for LS = 1:5 %
        h5(LS) = PlotLogNormalCDF_current(log(meanSa(LS)/Sa_MCE), sigmaLnRTR(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
    end

    if legOn == 1
        h5(6) = plot(4, 1, 'k-', 'LineWidth', 1.5); h5(7) = plot(4, 1, 'k--', 'LineWidth', 1.5); % dummy plots outside the range
        hlegend = legend(h5, {'$LS_1$', '$LS_2$', '$LS_3$', '$LS_4$', '$LS_5$', 'FF', 'NF'}, 'Location', 'NorthEast');
    end

    xlim([minValue, maxValue]);
    str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; xlabel(str1, 'Interpreter', 'latex');
    if floor((i+1)/2) == 1 % y-axis label only for first figure
        ylabel(str2, 'Interpreter', 'latex');
    end

    if floor((i+1)/2) == 1      % same axis size for all buildings (side-by-side figures)
        xx = gca;
    elseif floor((i+1)/2) >= 2
        set(gca, 'InnerPosition', xx.InnerPosition);
    end
    sks_figureFormat('paper');

    cd(baseFolder);  cd(dirForFigures);
    strForIM = strrep(sprintf('Sa_%.2f', T1forIM), '.', 'p');
    exportName = sprintf('%s_Frag_%s_normalized', buildingID, strForIM);
    sks_figureExport(exportName);   % .fig, .eps, .tiff, .emf

    % store to collect in the table
    periodT1(i, 1) = T1forIM;
    muCtrl(i, :) = meanSa;
    betaLnCtrl(i, :) = sigmaLnRTR;

    if i == size(buildingIDLIST, 1)
        T = table(buildingIDLIST, periodT1, muCtrl, betaLnCtrl);
        disp(T);
    end
%%%% end of block for the record-to-record fragility curves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(baseFolder);