clc; clear; close all; tic

% This code is useful for running EQ time history plots, here Dtfile, NumPointsFile and SortedEQFile are 
% loaded from OpenSeesProcessingFiles.
% Multi-record EQ time history plotting (grid of subplots)
%
% Author: Shivakumar K S, Research scholar at IIT Madras on 26-Mar-2026
%
% Units: Time in (s) and acceleration in mm/s^(2) loaded from above files
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%% Start Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folderPath = 'C:\Users\sks\OpenSeesProcessingFiles\EQs';
formatMode = 'report';   % 'default','paper','report','powerPoint'

% List of earthquake numbers to plot
% eqList = [70011, 70012];

eqList = [70011, 70012, 70021, 70022, 70031, 70032, 70041, 70042, ...
    70051, 70052, 70061, 70062, 70071, 70072, 70081, 70082, ...
    70091, 70092, 70101, 70102, 70111, 70112, 70121, 70122, ...
    70131, 70132, 70141, 70142, 70151, 70152, 70161, 70162, ...
    70171, 70172, 70181, 70182, 70191, 70192, 70201, 70202, ...
    70211, 70212, 70221, 70222, 70231, 70232, 70241, 70242, ...
    70251, 70252, 70261, 70262, 70271, 70272, 70281, 70282, ...
    70291, 70292, 70301, 70302];

nCols = 4;                     % fixed columns per figure
nRowsPerFig = 5;                % keep 5 rows per figure
recordsPerFig = nCols * nRowsPerFig;   % 20 records per figure
nFigs = ceil(length(eqList) / recordsPerFig);   % number of figures needed
%%%%%%%%% End of Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Base export folder
baseFolder = 'E:\OpenSees_PracticeExamples\ida-spo-msa\Output';
exportFolder = fullfile(baseFolder, 'EQ_TimeHistory');
if ~exist(exportFolder, 'dir')
    mkdir(exportFolder);
end

for figIdx = 1:nFigs

    % Slice out this figure's chunk of records
    startIdx = (figIdx - 1) * recordsPerFig + 1;
    endIdx   = min(figIdx * recordsPerFig, length(eqList));
    eqSubset = eqList(startIdx:endIdx);

    % nRows for this figure adapts if the last batch is a partial page
    nRows = ceil(length(eqSubset) / nCols);

    % Create tiled figure
    figure('Units', 'normalized', 'Position', [0.05 0.05 0.9 0.9]);
    t = tiledlayout(nRows, nCols, 'TileSpacing', 'compact', 'Padding', 'compact');

    for i = 1:length(eqSubset)
        eqNumber = eqSubset(i);

        % File names
        dtFile        = fullfile(folderPath, sprintf('DtFile_(%d).txt', eqNumber));
        numPointsFile = fullfile(folderPath, sprintf('NumPointsFile_(%d).txt', eqNumber));
        sortedEQFile  = fullfile(folderPath, sprintf('SortedEQFile_(%d).txt', eqNumber));

        % Skip missing files gracefully instead of crashing the whole loop
        if ~isfile(dtFile) || ~isfile(numPointsFile) || ~isfile(sortedEQFile)
            warning('Files for EQ_%d not found. Skipping.', eqNumber);
            nexttile; axis off;
            continue;
        end

        % Load data
        dt        = load(dtFile);
        numPoints = load(numPointsFile);
        accel     = load(sortedEQFile);
        accel     = accel(:);

        if length(accel) ~= numPoints
            warning('EQ_%d: Acceleration length and NumPoints do not match!', eqNumber);
        end

        time = (0:length(accel)-1) * dt;

        % Plot in the next tile
        nexttile;
        plot(time, accel, 'k', 'LineWidth', 0.75); hold on;
        yline(0, 'k-', 'LineWidth', 0.5);

        ylim([-0.5 0.5]);
        grid on;

        % Legend-style label box (mimics the boxed EQ number in your reference image)
        legend(sprintf('%d', eqNumber), 'Location', 'northeast', 'Box', 'on', 'FontSize', 7);

        % Only label outer axes to keep the grid clean
        row = ceil(i / nCols);
        col = mod(i-1, nCols) + 1;
        if row == nRows || i > length(eqSubset) - nCols
            xlabel('Time (s)', 'Interpreter', 'latex');
        end
        if col == 1
            ylabel('$a_g$ (g)', 'Interpreter', 'latex');
        end
    end

    % Overall figure formatting/export
    h_sgt = sgtitle(sprintf('Ground Motion Time Histories (Set %d of %d)', figIdx, nFigs), ...
        'FontWeight', 'bold', 'FontSize', 14);

    exportName = fullfile(exportFolder, sprintf('EQ_TimeHistory_Grid_%d', figIdx));
    if exist('sks_figureFormat', 'file')
        sks_figureFormat(formatMode);
        h_sgt.FontSize = 14;   % reassert after formatter runs
    end
    if exist('sks_figureExport', 'file')
        sks_figureExport(exportName);
    else
        print(gcf, exportName, '-dpng', '-r300');
    end

    fprintf('Saved combined grid plot %d of %d in:\n%s\n', figIdx, nFigs, exportFolder);

end

toc