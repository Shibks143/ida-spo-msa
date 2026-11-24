
function [] = sks_plotHingeYieldSequence(bldgID_LIST, analysisDirLIST, rootFolder, figureOutputFolder)
%
% Function: sks_plotHingeYieldSequence.m
% -------------------
% Plots the hinge yield sequence of a pushover analysis. For each building:
%   top panel    - pushover curve (base shear vs roof drift ratio)
%   bottom panel - every plastic hinge as a marker at the roof drift where it yielded
%                  (filled) and where it passed the capping rotation (x), against floor level.
% Both panels share the roof drift axis, so the knee of the curve can be read against the
% hinge yielding. All buildings are also put side by side in one comparison figure.
%
% Variable definitions:
%       bldgID_LIST- IDs as defined in psb_DefineInfoForBuildings.m
%       analysisDirLIST- analysis output folder names (cell array)
%       rootFolder- ida-spo-msa folder (contains Output and psb_MatlabProcessors)
%       figureOutputFolder- (optional) folder to save all figures. If empty or not given, each building's
%                           figure goes to its own Output\<analysisDir>\ folder and the comparison
%                           figure goes to Output\combinedPushover\, named after the building IDs.
%
% Notes:
%       - Figures are formatted with sks_figureFormat and saved with sks_figureExport (.fig, .eps, .tiff, .emf).
%       - Yield and capping are found as in sks_pushoverDeformedShapeMovie.m:
%           yield - plastic rotation (rotation change minus elastic part) >= yieldPlasticRotation
%           capping - |rotation| >= capping rotation from buildingInfo (same rule as the red colour in psb_DrawDistortedFrame)
%       - Floor 1 is the column base. Beam and column hinges at a joint are shown at that joint's floor,
%         shifted slightly by column line so that hinges at the same drift do not hide each other.
%
% Units: kN and mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 4, figureOutputFolder = ''; end
yieldPlasticRotation = 0.0005;   % (rad)
lateralDispDOF = 1;
hingeStyle.beam   = struct('marker', 'o', 'color', [0 0.45 0.74], 'name', 'Beam hinge');
hingeStyle.column = struct('marker', 'd', 'color', [0.49 0.18 0.56], 'name', 'Column hinge (above base)');
hingeStyle.base   = struct('marker', 's', 'color', [0.85 0.33 0.1], 'name', 'Column-base hinge');
hingeTypeNameLIST = {'beam', 'column', 'base'};
beamYieldBandColor = 1 - 0.15 * (1 - hingeStyle.beam.color);   % light blue, solid (vector .eps/.emf do not keep transparency)
singleFigureFormatMode = 'powerpoint';       % sks_figureFormat mode for each building's figure
comparisonFigureFormatMode = 'paper';        % smaller fonts, since the comparison has one column per building

addpath(fullfile(rootFolder, 'psb_MatlabProcessors', 'MovieAndVisualProcessors'));
buildingInfo = psb_DefineInfoForBuildings;
numBuildings = length(bldgID_LIST);
comparisonFigure = figure('Position', [50 50 420 * numBuildings, 950], 'Color', 'w', 'Name', 'Hinge yield sequence - comparison');
comparisonLayout = tiledlayout(comparisonFigure, 2, numBuildings, 'TileSpacing', 'compact', 'Padding', 'compact');
maxRoofDriftOverAllBuildings = 0;
comparisonAxesLIST = gobjects(2, numBuildings);

for bldgIndex = 1:numBuildings
    bldgID = bldgID_LIST(bldgIndex);
    analysisDir = analysisDirLIST{bldgIndex};
    runFolder = fullfile(rootFolder, 'Output', analysisDir, 'EQ_9991', 'Sa_0.00');
    modelName = strtok(analysisDir, ')'); modelName = modelName(2:end);
    load(fullfile(runFolder, 'DATA_allDataForThisSingleRun.mat'), 'nodeArray', 'baseShear', 'poControlNodeNum', 'floorHeightsLIST');
    numColLines = buildingInfo{bldgID}.numBays + 1;
    maxFloorNum = buildingInfo{bldgID}.numStories + 1;

    % pushover curve (same definition as PlotPushover.m)
    roofDispTH = nodeArray{poControlNodeNum}.displTH(:, lateralDispDOF);
    baseShearTH = -baseShear.TH;
    firstPositiveDispIndex = find(roofDispTH >= 0, 1);
    if ~isempty(firstPositiveDispIndex) && firstPositiveDispIndex > 1
        offsetOfBaseShear = interp1(roofDispTH(firstPositiveDispIndex-1:firstPositiveDispIndex), ...
            baseShearTH(firstPositiveDispIndex-1:firstPositiveDispIndex), 0, 'pchip');
        baseShearTH = baseShearTH - offsetOfBaseShear;
    end
    numStepsInAnalysis = min(length(roofDispTH), length(baseShearTH));
    roofDriftTH = roofDispTH(1:numStepsInAnalysis) / max(floorHeightsLIST);
    baseShearTH = baseShearTH(1:numStepsInAnalysis);
    [maxBaseShear, vMaxStep] = max(baseShearTH);

    % yield and capping step of every hinge
    hingeTypeLIST = {}; hingeFloorLIST = []; hingeColLineLIST = []; hingeYieldStepLIST = []; hingeCapStepLIST = [];
    for currentFloorNum = 2:maxFloorNum
        for currentColLineNum = 1:numColLines
            currentJointNum = buildingInfo{bldgID}.jointNumber(currentFloorNum, currentColLineNum);
            jointForceAndDeformation = load(fullfile(runFolder, 'Elements', 'Joints', sprintf('Joint_ForceAndDef_%i.out', currentJointNum)));
            numRows = min(numStepsInAnalysis, size(jointForceAndDeformation, 1));
            for currentJointNodeNum = 1:4
                rotationCapacity = buildingInfo{bldgID}.plastHingeRotCapAtJoint(currentFloorNum, currentColLineNum).node(currentJointNodeNum);
                if rotationCapacity >= 1, continue; end   % 99/999 = no hinge at this joint node
                [yieldStep, capStep] = findHingeYieldAndCapSteps(jointForceAndDeformation(1:numRows, currentJointNodeNum), ...
                    jointForceAndDeformation(1:numRows, 5 + currentJointNodeNum), rotationCapacity, yieldPlasticRotation);
                if any(currentJointNodeNum == [2 4]), hingeTypeLIST{end+1} = 'beam'; else, hingeTypeLIST{end+1} = 'column'; end
                hingeFloorLIST(end+1) = currentFloorNum;
                hingeColLineLIST(end+1) = currentColLineNum;
                hingeYieldStepLIST(end+1) = yieldStep;
                hingeCapStepLIST(end+1) = capStep;
            end
        end
    end
    for currentColLineNum = 1:numColLines
        currentColBaseHingeNum = buildingInfo{bldgID}.hingeElementNumAtColBase(currentColLineNum);
        rotationCapacity = buildingInfo{bldgID}.plastHingeRotCapAtJoint(1, currentColLineNum).node(1);
        colBaseRotationTH = load(fullfile(runFolder, 'Elements', 'Hinges', sprintf('HingeRotTH_%i.out', currentColBaseHingeNum)));
        colBaseForceTH = load(fullfile(runFolder, 'Elements', 'Hinges', sprintf('HingeForceTH_%i.out', currentColBaseHingeNum)));
        numRows = min([numStepsInAnalysis, size(colBaseRotationTH, 1), size(colBaseForceTH, 1)]);
        [yieldStep, capStep] = findHingeYieldAndCapSteps(colBaseRotationTH(1:numRows), colBaseForceTH(1:numRows, 3), rotationCapacity, yieldPlasticRotation);
        hingeTypeLIST{end+1} = 'base';
        hingeFloorLIST(end+1) = 1;
        hingeColLineLIST(end+1) = currentColLineNum;
        hingeYieldStepLIST(end+1) = yieldStep;
        hingeCapStepLIST(end+1) = capStep;
    end

    % roof drift at yield / capping (NaN = did not happen) and a small vertical shift by column line
    hingeYieldDriftLIST = nan(size(hingeYieldStepLIST));
    hasYielded = isfinite(hingeYieldStepLIST);
    hingeYieldDriftLIST(hasYielded) = roofDriftTH(hingeYieldStepLIST(hasYielded));
    hingeCapDriftLIST = nan(size(hingeCapStepLIST));
    hasCapped = isfinite(hingeCapStepLIST);
    hingeCapDriftLIST(hasCapped) = roofDriftTH(hingeCapStepLIST(hasCapped));
    hingePlotLevelLIST = hingeFloorLIST + 0.12 * (hingeColLineLIST - (numColLines + 1) / 2);

    fprintf('%s: %i hinges, %i yielded, %i capped\n', modelName, numel(hingeTypeLIST), sum(hasYielded), sum(hasCapped));
    for hingeTypeIndex = 1:3
        isThisType = strcmp(hingeTypeLIST, hingeTypeNameLIST{hingeTypeIndex});
        if any(isThisType & hasYielded)
            fprintf('   %-7s yield drift range %.2f%% - %.2f%%  (%i of %i)\n', hingeTypeNameLIST{hingeTypeIndex}, ...
                100 * min(hingeYieldDriftLIST(isThisType)), 100 * max(hingeYieldDriftLIST(isThisType)), sum(isThisType & hasYielded), sum(isThisType));
        end
    end

    % draw: one figure per building, plus the same panels in the comparison figure
    singleFigure = figure('Position', [50 50 600 950], 'Color', 'w', 'Name', sprintf('Hinge yield sequence - %s', modelName));
    singleLayout = tiledlayout(singleFigure, 2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
    curveAxes = nexttile(singleLayout, 1);
    sequenceAxes = nexttile(singleLayout, 2);
    comparisonAxesLIST(1, bldgIndex) = nexttile(comparisonLayout, bldgIndex);
    comparisonAxesLIST(2, bldgIndex) = nexttile(comparisonLayout, numBuildings + bldgIndex);
    axesPairLIST = {[curveAxes, sequenceAxes], comparisonAxesLIST(:, bldgIndex)'};
    modelNameForLatex = strrep(modelName, '_', '\_');   % sks_figureFormat uses the LaTeX interpreter

    for axesPairIndex = 1:2
        curveAxesToUse = axesPairLIST{axesPairIndex}(1);
        sequenceAxesToUse = axesPairLIST{axesPairIndex}(2);

        % pushover curve, shaded from first beam yield until every floor has at least one yielded beam hinge
        hold(curveAxesToUse, 'on');
        isBeamYielded = strcmp(hingeTypeLIST, 'beam') & hasYielded;
        if any(isBeamYielded)
            beamFloorLIST = unique(hingeFloorLIST(strcmp(hingeTypeLIST, 'beam')));
            firstYieldDriftOfEachBeamFloor = arrayfun(@(floorNum) min(hingeYieldDriftLIST(strcmp(hingeTypeLIST, 'beam') & hingeFloorLIST == floorNum)), beamFloorLIST);
            beamYieldRange = [min(hingeYieldDriftLIST(isBeamYielded)), max(firstYieldDriftOfEachBeamFloor)];
            patch(curveAxesToUse, beamYieldRange([1 2 2 1]), [0 0 1.1 1.1] * maxBaseShear, beamYieldBandColor, 'EdgeColor', 'none');
            text(curveAxesToUse, beamYieldRange(2) + 0.002, 0.3 * maxBaseShear, ...
                sprintf('beams: %.2f-%.2f\\%%', 100 * beamYieldRange(1), 100 * beamYieldRange(2)), ...
                'HorizontalAlignment', 'left', 'FontName', 'times', 'FontSize', 10, 'Color', hingeStyle.beam.color, 'Interpreter', 'latex');
        end
        plot(curveAxesToUse, roofDriftTH, baseShearTH, 'k-', 'LineWidth', 1.5);
        plot(curveAxesToUse, roofDriftTH(vMaxStep), maxBaseShear, 'ko', 'MarkerFaceColor', 'k');
        xline(curveAxesToUse, roofDriftTH(vMaxStep), 'k:');
        ylim(curveAxesToUse, [0, 1.1 * maxBaseShear]);
        ylabel(curveAxesToUse, 'Base Shear (kN)');
        title(curveAxesToUse, modelNameForLatex, 'Interpreter', 'latex');
        grid(curveAxesToUse, 'on'); box(curveAxesToUse, 'on');

        % hinge yield (filled) and capping (x) against floor
        hold(sequenceAxesToUse, 'on');
        legendHandles = gobjects(0); legendText = {};
        for hingeTypeIndex = 1:3
            style = hingeStyle.(hingeTypeNameLIST{hingeTypeIndex});
            isThisType = strcmp(hingeTypeLIST, hingeTypeNameLIST{hingeTypeIndex});
            if ~any(isThisType), continue; end
            yieldHandle = plot(sequenceAxesToUse, hingeYieldDriftLIST(isThisType), hingePlotLevelLIST(isThisType), style.marker, ...
                'MarkerFaceColor', style.color, 'MarkerEdgeColor', 'k', 'MarkerSize', 6);
            if any(isThisType & hasYielded)
                legendHandles(end+1) = yieldHandle; legendText{end+1} = [style.name, ' yield'];
            end
            if any(isThisType & hasCapped)
                legendHandles(end+1) = plot(sequenceAxesToUse, hingeCapDriftLIST(isThisType), hingePlotLevelLIST(isThisType), 'x', ...
                    'Color', style.color, 'MarkerSize', 9, 'LineWidth', 2);
                legendText{end+1} = [style.name, ' capping'];
            end
        end
        xline(sequenceAxesToUse, roofDriftTH(vMaxStep), 'k:');
        ylim(sequenceAxesToUse, [0.4, maxFloorNum + 0.6]);
        yticks(sequenceAxesToUse, 1:maxFloorNum);
        yticklabels(sequenceAxesToUse, [{'Base'}, arrayfun(@(floorNum) sprintf('%i', floorNum), 2:maxFloorNum, 'UniformOutput', false)]);
        xlabel(sequenceAxesToUse, 'Roof Drift Ratio');
        ylabel(sequenceAxesToUse, 'Floor');
        grid(sequenceAxesToUse, 'on'); box(sequenceAxesToUse, 'on');
        legend(sequenceAxesToUse, legendHandles, legendText, 'Location', 'southoutside', 'NumColumns', 2, 'FontSize', 8);
        linkaxes([curveAxesToUse, sequenceAxesToUse], 'x');
        xlim(curveAxesToUse, [0, max(roofDriftTH) * 1.02]);
        set([curveAxesToUse, sequenceAxesToUse], 'FontName', 'times', 'FontSize', 11);
    end
    maxRoofDriftOverAllBuildings = max(maxRoofDriftOverAllBuildings, max(roofDriftTH));

    if isempty(figureOutputFolder)
        singleFigureFolder = fullfile(rootFolder, 'Output', analysisDir);   % next to Pushover_Num_9991 and PushoverDeformedShape
    else
        singleFigureFolder = figureOutputFolder;
    end
    formatAndExportFigure(singleFigure, singleFigureFormatMode, 2, fullfile(singleFigureFolder, sprintf('HingeYieldSequence_%s', modelName)));
    close(singleFigure);
end

% comparison figure: same roof drift axis for all buildings
for bldgIndex = 1:numBuildings
    xlim(comparisonAxesLIST(1, bldgIndex), [0, maxRoofDriftOverAllBuildings * 1.02]);
end
if isempty(figureOutputFolder)
    comparisonFigureFolder = fullfile(rootFolder, 'Output', 'combinedPushover');
else
    comparisonFigureFolder = figureOutputFolder;
end
comparisonFileName = ['HingeYieldSequence_comparison_', strjoin(arrayfun(@(bldgID) sprintf('ID%i', bldgID), bldgID_LIST, 'UniformOutput', false), '_')];
formatAndExportFigure(comparisonFigure, comparisonFigureFormatMode, 1, fullfile(comparisonFigureFolder, comparisonFileName));
% comparison figure is left open (like the combined pushover figures); close it when done
end

%% local function: format with sks_figureFormat, then save with sks_figureExport
function [] = formatAndExportFigure(figureHandle, formatMode, legendNumColumns, exportName)
    set(groot, 'CurrentFigure', figureHandle);   % both sks_ functions work on gcf
    sks_figureFormat(formatMode);
    % sks_figureFormat moves every legend to 'southeast' (on top of the base hinges); put them back below the axes
    legendHandleLIST = findobj(figureHandle, 'Type', 'Legend');
    set(legendHandleLIST, 'Location', 'southoutside', 'NumColumns', legendNumColumns);
    set(figureHandle, 'Renderer', 'painters');   % sks_figureExport switches to painters; do it first so the layout below uses painters text sizes
    drawnow;   % let the tiled layout make room for the larger fonts before saving
    sks_figureExport(exportName);
end

%% local function (same as in sks_pushoverDeformedShapeMovie.m)
function [yieldStep, capStep] = findHingeYieldAndCapSteps(hingeRotationTH, hingeMomentTH, rotationCapacity, yieldPlasticRotation)
    rotationChange = hingeRotationTH - hingeRotationTH(1);
    momentChange = hingeMomentTH - hingeMomentTH(1);
    yieldStep = Inf;
    elasticIndex = find(abs(momentChange) >= 0.2 * max(abs(momentChange)), 1, 'first');
    if ~isempty(elasticIndex) && rotationChange(elasticIndex) ~= 0
        elasticStiffness = momentChange(elasticIndex) / rotationChange(elasticIndex);
        plasticRotationTH = abs(rotationChange - momentChange / elasticStiffness);
        firstYieldIndex = find(plasticRotationTH >= yieldPlasticRotation, 1, 'first');
        if ~isempty(firstYieldIndex), yieldStep = firstYieldIndex; end
    end
    capStep = find(abs(hingeRotationTH) >= rotationCapacity, 1, 'first');
    if isempty(capStep), capStep = Inf; end
end
