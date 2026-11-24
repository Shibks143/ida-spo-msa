function [overstrengthLIST, normalizedCurveLIST] = sks_plotCombinedPushover(fileNameLIST, pushoverCurveLIST, baseShearDivisorLIST, plotRoofDriftRatio, lineWidth_PO, exportName, designCoeffLIST)
% ===============================================
% (21-Nov-2026) Shivakumar K S, IIT Madras
% Combined pushover curves of all buildings, with two legends:
%   Designs as per 2016 Standard (southeast) and Designs as per Proposed Standard (northeast)
%
% Single figure (numeric inputs):
%   baseShearDivisorLIST = [],     designCoeffLIST omitted -> plots V (kN)
%   baseShearDivisorLIST = Vb,2D,  designCoeffLIST omitted -> plots V / Vb,2D; Omega = Vmax / Vb,2D
%   baseShearDivisorLIST = W,2D,   designCoeffLIST = Cs,D  -> plots V / W,2D with Cs,max and Cs,D markers
%                                                             (Badal & Sinha 2022, Fig. 6 style); Omega = Cs,max / Cs,D
% Side-by-side panels (cell inputs, one cell per panel):
%   baseShearDivisorLIST = {Vb,2D, W,2D},  designCoeffLIST = {[], Cs,D}
%   -> left: V / Vb,2D,  right: V / W,2D with markers
% (all lists: one value per building, same order as fileNameLIST)
% Outputs are taken from the first panel.
% ===============================================

if nargin < 7, designCoeffLIST = []; end

% ---- one panel (numeric inputs) or several side-by-side panels (cell inputs) ----
if iscell(baseShearDivisorLIST)
    divisorPanelLIST = baseShearDivisorLIST;
    if iscell(designCoeffLIST)
        designCoeffPanelLIST = designCoeffLIST;
    else
        designCoeffPanelLIST = repmat({[]}, size(divisorPanelLIST));
    end
else
    divisorPanelLIST     = {baseShearDivisorLIST};
    designCoeffPanelLIST = {designCoeffLIST};
end
numPanels = numel(divisorPanelLIST);
if numel(designCoeffPanelLIST) ~= numPanels
    error('designCoeffLIST must have one cell per panel in baseShearDivisorLIST.');
end

% ---- figure ----
if numPanels == 1
    figure('Name', 'Combined pushover');
else
    figure('Name', 'Combined pushover - panels', 'Position', [100, 100, 900 * numPanels, 650]);
end

% ---- draw every panel ----
panelAxesLIST  = gobjects(numPanels, 1);
legendDataLIST = cell(numPanels, 1);
for panelIndex = 1:numPanels
    panelAxesLIST(panelIndex) = subplot(1, numPanels, panelIndex);
    [overstrengthPanel, normalizedCurvePanel, legendDataLIST{panelIndex}] = drawPushoverPanel(panelAxesLIST(panelIndex), ...
        fileNameLIST, pushoverCurveLIST, divisorPanelLIST{panelIndex}, designCoeffPanelLIST{panelIndex}, plotRoofDriftRatio, lineWidth_PO);
    if panelIndex == 1
        overstrengthLIST    = overstrengthPanel;
        normalizedCurveLIST = normalizedCurvePanel;
    end
end

sks_figureFormat('powerpoint');   % format first; legends below are created after, so our font size and locations win

for panelIndex = 1:numPanels
    addStandardLegends(panelAxesLIST(panelIndex), legendDataLIST{panelIndex}, lineWidth_PO);
end
set(gcf, 'CurrentAxes', panelAxesLIST(1));   % do NOT use axes(...): it brings it to the front and hides the overlay legend

% ---- export ----
sks_figureExport(exportName);
disp(['Saved: ', exportName]);

end


%% ========================================================================
function [overstrengthLIST, normalizedCurveLIST, legendData] = drawPushoverPanel(mainAxes, fileNameLIST, pushoverCurveLIST, baseShearDivisorLIST, designCoeffLIST, plotRoofDriftRatio, lineWidth_PO)
% Draws all pushover curves of one panel (no legends; see addStandardLegends)

isNormalized       = ~isempty(baseShearDivisorLIST);
isWeightNormalized = isNormalized && ~isempty(designCoeffLIST);   % V / W mode
numBuildings = numel(fileNameLIST);
if isNormalized && numel(baseShearDivisorLIST) ~= numBuildings
    error('baseShearDivisorLIST must have one value per building in fileNameLIST.');
end

% ---- design groups, colours, line styles ----
designs2016LIST     = {'ID35053_R5_5Story_v.03'; 'ID35083_R5_8Story_v.03'; 'ID35123_R5_12Story_v.03'};
designsProposedLIST = {'ID46053_R5_5Story_v.04'; 'ID46083_R5_8Story_v.04'; 'ID46123_R5_12Story_v.04'};
storyLabelLIST      = {'5-Story'; '8-Story'; '12-Story'};

lineColorLIST = [0.00 0.00 1.00;    % blue    -> 2016, 5-story
                 1.00 0.00 1.00;    % magenta -> 2016, 8-story
                 0.00 0.00 0.00;    % black   -> 2016, 12-story
                 1.00 0.00 0.00;    % red     -> Proposed, 5-story
                 0.90 0.60 0.00;    % orange  -> Proposed, 8-story
                 0.00 0.60 0.00];   % green   -> Proposed, 12-story
numDesignsPerStandard = numel(designs2016LIST);   % 3 -> Proposed colours start at row 4

lineStyle2016     = '-';            % 2016 Standard
lineStyleProposed = '-';            % Proposed Standard ('--' for dashed)

% ---- plot settings ----
roofDriftLimit        = 0.09;       % x-axis upper limit (roof drift ratio)
baseShearLimit        = 5000;       % y-axis upper limit, V (kN)
normalizedLimit       = 4.0;        % y-axis upper limit, V / Vb,2D
weightNormalizedLimit = 0.40;       % y-axis upper limit, V / W,2D
legendFontSize        = 12;         % font size for both legends (text and title)

hold(mainAxes, 'on'); grid(mainAxes, 'on'); box(mainAxes, 'on');

legendHandles2016   = gobjects(0);  legendText2016     = {};
legendColorProposed = {};           legendTextProposed = {};   % rebuilt on overlay axes later
overstrengthLIST    = nan(numBuildings, 1);
normalizedCurveLIST = cell(numBuildings, 1);   % each cell: [roofDriftRatio, V (kN), V / divisor]

for buildingIndex = 1:numBuildings
    if isempty(pushoverCurveLIST{buildingIndex})
        continue;   % skip a building whose pushover did not finish
    end
    roofDeformation = pushoverCurveLIST{buildingIndex}(:, 1);   % drift ratio (or mm if plotRoofDriftRatio = 0)
    baseShear       = pushoverCurveLIST{buildingIndex}(:, 2);   % kN
    buildingName    = fileNameLIST{buildingIndex};
    buildingID      = extractBefore(buildingName, '_');         % 'ID35053_R5_5Story_v.03' -> 'ID35053'

    if isNormalized
        baseShearToPlot = baseShear / baseShearDivisorLIST(buildingIndex);       % V / Vb,2D  or  V / W,2D
        if isWeightNormalized
            overstrengthLIST(buildingIndex) = max(baseShearToPlot) / designCoeffLIST(buildingIndex);   % Omega = Cs,max / Cs,D
        else
            overstrengthLIST(buildingIndex) = max(baseShearToPlot);              % Omega = Vmax / Vb,2D
        end
        normalizedCurveLIST{buildingIndex} = [roofDeformation, baseShear, baseShearToPlot];
    else
        baseShearToPlot = baseShear;                                             % V (kN)
    end

    [is2016, storyIndex2016]         = ismember(buildingName, designs2016LIST);
    [isProposed, storyIndexProposed] = ismember(buildingName, designsProposedLIST);

    if is2016
        legendHandles2016(end+1) = plot(mainAxes, roofDeformation, baseShearToPlot, lineStyle2016, ...
            'Color', lineColorLIST(storyIndex2016, :), 'LineWidth', lineWidth_PO);
        legendText2016{end+1} = sprintf('%s (%s)', storyLabelLIST{storyIndex2016}, buildingID);
    elseif isProposed
        proposedColorIndex = storyIndexProposed + numDesignsPerStandard;
        plot(mainAxes, roofDeformation, baseShearToPlot, lineStyleProposed, ...
            'Color', lineColorLIST(proposedColorIndex, :), 'LineWidth', lineWidth_PO);
        legendColorProposed{end+1} = lineColorLIST(proposedColorIndex, :);
        legendTextProposed{end+1}  = sprintf('%s (%s)', storyLabelLIST{storyIndexProposed}, buildingID);
    else
        warning('Building %s is not in either design list - plotted grey, not in legend.', buildingName);
        plot(mainAxes, roofDeformation, baseShearToPlot, ':', 'Color', [0.5 0.5 0.5], 'LineWidth', lineWidth_PO);
    end

    % V / W mode: mark Cs,max (open diamond) and Cs,D (filled dot) on this curve, in its colour
    if isWeightNormalized
        curveColor = mainAxes.Children(1).Color;                                 % colour of the curve just plotted
        [maxBaseShearCoeff, peakIndex] = max(baseShearToPlot);                    % Cs,max
        designBaseShearCoeff = designCoeffLIST(buildingIndex);                    % Cs,D
        firstAboveIndex = find(baseShearToPlot(1:peakIndex) >= designBaseShearCoeff, 1);
        driftAtDesign = interp1(baseShearToPlot([firstAboveIndex-1, firstAboveIndex]), ...
            roofDeformation([firstAboveIndex-1, firstAboveIndex]), designBaseShearCoeff);
        plot(mainAxes, roofDeformation(peakIndex), maxBaseShearCoeff, 'd', 'MarkerSize', 10, 'LineWidth', 2, ...
            'MarkerEdgeColor', curveColor, 'MarkerFaceColor', 'w', 'HandleVisibility', 'off');
        plot(mainAxes, driftAtDesign, designBaseShearCoeff, 'o', 'MarkerSize', 8, ...
            'MarkerEdgeColor', curveColor, 'MarkerFaceColor', curveColor, 'HandleVisibility', 'off');
    end
end   % for buildingIndex
uistack(findobj(mainAxes, 'Type', 'line', 'Marker', 'd'), 'top');   % Cs,max markers above all curves
uistack(findobj(mainAxes, 'Type', 'line', 'Marker', 'o'), 'top');   % Cs,D markers above all curves

% ---- axes ----
if plotRoofDriftRatio == 1
    xlabel(mainAxes, 'Roof Drift Ratio');
    xlim(mainAxes, [0, roofDriftLimit]);
    xticks(mainAxes, 0:0.02:0.08);
else
    xlabel(mainAxes, 'Roof Displacement (mm)');
    xlim(mainAxes, [0, inf]);   % mm: auto upper limit
end
if isWeightNormalized
    ylabel(mainAxes, '$V / W$', 'Interpreter', 'latex');
    ylim(mainAxes, [0, weightNormalizedLimit]);
    title(mainAxes, 'Normalised Base Shear by Seismic Weight');
    text(mainAxes, 0.02, 0.96, '$\diamond$ = $C_{s,max}$, \ $\bullet$ = $C_{s,D}$', 'Units', 'normalized', 'VerticalAlignment', 'top');
elseif isNormalized
    yline(mainAxes, 1.0, 'k--', 'LineWidth', 1.5);           % design base shear level
    ylabel(mainAxes, '$V / V_{b,design}$', 'Interpreter', 'latex');
    ylim(mainAxes, [0, normalizedLimit]);
    title(mainAxes, 'Normalised Base Shear by Design Base Shear');
else
    ylabel(mainAxes, 'Base Shear (kN)');
    ylim(mainAxes, [0, baseShearLimit]);
    title(mainAxes, 'Pushover curves - all buildings');
end
hold(mainAxes, 'off');

% ---- what addStandardLegends needs ----
legendData.handles2016       = legendHandles2016;
legendData.text2016          = legendText2016;
legendData.colorProposed     = legendColorProposed;
legendData.textProposed      = legendTextProposed;
legendData.lineStyleProposed = lineStyleProposed;
legendData.fontSize          = legendFontSize;

end


%% ========================================================================
function addStandardLegends(mainAxes, legendData, lineWidth_PO)
% Two legends on one panel: 2016 Standard (southeast) and Proposed Standard (northeast).
% Call AFTER sks_figureFormat, otherwise it resets legend location and font size.

% ---- Legend 1: 2016 Standard (main axes, southeast) ----
legend2016 = legend(mainAxes, legendData.handles2016, legendData.text2016, ...
    'Location', 'southeast', 'Interpreter', 'none', 'FontSize', legendData.fontSize);
legend2016.Title.String   = 'Designs as per 2016 Standard';
legend2016.Title.FontSize = legendData.fontSize;

% ---- Legend 2: Proposed Standard (transparent overlay axes, northeast) ----
% Overlay stays 'Visible','on' so exportgraphics keeps its legend; it is see-through with no axis lines.
overlayAxes = axes('Parent', mainAxes.Parent, 'Position', mainAxes.Position, 'Color', 'none', ...
    'XColor', 'none', 'YColor', 'none', 'XTick', [], 'YTick', [], 'HitTest', 'off');
hold(overlayAxes, 'on');
legendHandlesProposed = gobjects(numel(legendData.textProposed), 1);
for proposedIndex = 1:numel(legendData.textProposed)
    legendHandlesProposed(proposedIndex) = plot(overlayAxes, NaN, NaN, legendData.lineStyleProposed, ...
        'Color', legendData.colorProposed{proposedIndex}, 'LineWidth', lineWidth_PO);
end
legendProposed = legend(overlayAxes, legendHandlesProposed, legendData.textProposed, ...
    'Location', 'northeast', 'Interpreter', 'none', 'FontSize', legendData.fontSize);
legendProposed.Title.String   = 'Designs as per Proposed Standard';
legendProposed.Title.FontSize = legendData.fontSize;
legendProposed.FontName       = legend2016.FontName;   % match the 2016 legend's font

end