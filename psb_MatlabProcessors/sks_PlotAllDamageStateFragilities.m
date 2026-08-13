clear;
clc;
close all;
pwd

%% for the IIT ROORKEE Conference paper
% Paths
currentFolder = pwd;
projectFolder = fileparts(currentFolder);

% Output folder
outputFolder = fullfile(projectFolder,'Output','AllDamageStatesFragility');

% Create folder if it does not exist
if ~exist(outputFolder,'dir')
    mkdir(outputFolder);
end


%% Input
im = linspace(0.1, 10, 500);

Bldg = 35053;
theta = [0.32, 0.67, 1.25, 1.52];  % as per excel data 30 july 2026
beta  = [0.52, 0.53, 0.51, 0.48];

% Bldg = 46053;
% theta = [0.35, 0.72, 1.54, 2.05];
% beta  = [0.55, 0.58, 0.56, 0.46];

% Custom colors (keep same everywhere)
colors = [ ...
    0.00 0.00 1.00;   % Blue (IO)
    1.00 0.00 1.00;   % Magenta (LS)
    0.00 0.00 0.00;   % Black (CP)
    1.00 0.00 0.00];  % Red (Collapse)

% Custom colors (keep same everywhere)
% colors = [ ...
%     0.93 0.69 0.13;   % Yellow (IO)
%     1.00 0.00 1.00;   % Magenta (LS)
%     0.00 0.00 0.00;   % Black (CP)
%     1.00 0.00 0.00];  % Red (Collapse)


figure; 
hold on;

for i = 1:length(theta)
    prob = normcdf(log(im./theta(i)) ./ beta(i));
    plot(im, prob, 'LineWidth', 3.0, 'Color', colors(i,:));

end

xlabel('${im} \equiv Sa_{geoM}(0.71\,\mathrm{s})\,(\mathrm{g})$', 'Interpreter','latex');
% xlabel('$Sa_{geoM}(T=0.71\,\mathrm{s})\,(\mathrm{g})$', 'Interpreter','latex');
ylabel('$\Pr(DS \ge ds_i \mid IM = im)$', 'Interpreter','latex');

% Legend with increased size 
lgd = legend({'$\mathrm{IO}$', ...
    '$\mathrm{LS}$', ...
    '$\mathrm{CP}$', ...
    '$\mathrm{Collapse}$'}, ...
    'Location','southeast', ...
    'Interpreter','latex');
lgd.ItemTokenSize = [30, 18];   % increase line sample size
lgd.Box = 'on';                 % optional: cleaner look

% Axis limits and ticks
xlim([0 2.5]);                 
ylim([0 1]);                 
xticks(0:0.5:2);
yticks(0:0.2:1);

grid on;
sks_figureFormat('powerpoint')


%% Export Figure
figName = sprintf('FragilityCurves_AllDamageStates_BldgID_%d', Bldg);

oldFolder = pwd;
cd(outputFolder)

sks_figureExport(figName)

cd(oldFolder)


