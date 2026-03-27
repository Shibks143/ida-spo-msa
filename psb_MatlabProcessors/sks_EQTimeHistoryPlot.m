clc; clear; close all;

% This code is useful for running EQ time history plots, here Dtfile, NumPointsFile and SortedEQFile are 
% loaded from OpenSeesProcessingFiles.
%
%
% Author: Shivakumar K S, Research scholar at IIT Madras on 26-Mar-2026
%
% Units: Time in (s) and acceleration in mm/s^(2) loaded from above files
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Folder path
folderPath = 'C:\Users\sks\OpenSeesProcessingFiles\EQs';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Inputs, needs to be changed based on format and also EQ_Number 
% Plot settings 
formatMode = 'powerpoint';   % 'default','paper','report','powerPoint'

% Specify earthquake number
eqNumber = 121221;  % <-- change this as needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% File names
dtFile        = fullfile(folderPath, sprintf('DtFile_(%d).txt', eqNumber));
numPointsFile = fullfile(folderPath, sprintf('NumPointsFile_(%d).txt', eqNumber));
sortedEQFile       = fullfile(folderPath, sprintf('SortedEQFile_(%d).txt', eqNumber));

% Load data
dt        = load(dtFile);          % time step
numPoints = load(numPointsFile);   % number of points
accel     = load(sortedEQFile);    % acceleration vector

% Ensure column vector
accel = accel(:);

% Compute duration
duration = dt * numPoints;

% Time vector
time = (0:length(accel)-1) * dt;

% (Optional) ensure consistency
if length(accel) ~= numPoints
    warning('Acceleration length and NumPoints do not match!');
end

% Plot
figure;
plot(time, accel, 'b', 'LineWidth', 1.5); hold on;

% X-axis line (y = 0)
yline(0, 'k-', 'LineWidth', 1.2);   % black horizontal axis

% Find peak (absolute max)
[peakVal, peakIndex] = max(abs(accel));
peakTime = time(peakIndex);

% Plot peak point
plot(peakTime, accel(peakIndex), 'ro', 'MarkerFaceColor', 'r');

% Annotate peak
text(peakTime, accel(peakIndex), sprintf('%.3f', accel(peakIndex)),'VerticalAlignment', 'bottom', 'FontSize', 10);

xlabel('Time (s)');
ylabel('Acceleration (mm/s^2)');
title(sprintf('Earthquake Time History (EQ_%d)', eqNumber), 'Interpreter', 'none');

grid on;

% Display duration
fprintf('Duration of EQ_%d = %.3f seconds\n', eqNumber, duration);

% Base export folder

baseFolder = 'E:\OpenSees_PracticeExamples\ida-spo-msa\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';

% Create subfolder "EQ_TimeHistory"
exportFolder = fullfile(baseFolder, 'EQ_TimeHistory');

if ~exist(exportFolder, 'dir')
    mkdir(exportFolder);
end

% Define export name
exportName = fullfile(exportFolder, sprintf('EQ_%d_TimeHistory', eqNumber));

% Apply formatting
sks_figureFormat(formatMode);

% Export safely
if exist('sks_figureExport', 'file')
    sks_figureExport(exportName);
else
    print(gcf, exportName, '-dpng', '-r300');
end

% Confirmation
fprintf('Saved in:\n%s\n', exportFolder);


