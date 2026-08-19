function sks_fun_deagg_fromTuples_v1(mag, dist, eps, weight, textStr, doSave, exportName, dirFig)
%% Plots a stacked 3D M-R-epsilon deaggregation bar chart from USER-SUPPLIED tuples,
%  Every unique combination of (mag, dist) should appear once per eps bin, i.e.
%  length(mag) = numMagBins * numDistBins * numEpsBins (a full grid). If some
%  (M,R,eps) combos are missing/zero, that's fine - just don't include the row.
%
%  weight can be in ANY units (raw rate/lambda, or already-normalized %); the
%  function normalizes internally so bars sum to 100% contribution.
%


narginchk(4, 8)
switch nargin
    case 4
        textStr = ''; doSave = 0; exportName = 'DeaggPlot'; dirFig = 'Output_Deagg_figs';
    case 5
        doSave = 0; exportName = 'DeaggPlot'; dirFig = 'Output_Deagg_figs';
    case 6
        exportName = 'DeaggPlot'; dirFig = 'Output_Deagg_figs';
    case 7
        dirFig = 'Output_Deagg_figs';
end

baseFolder = pwd;
mag = mag(:)'; dist = dist(:)'; eps = eps(:)'; weight = weight(:)'; % force row vectors
sumWeight = sum(weight);

%% expected (mean) deaggregation tuple (Mbar, Rbar, epsBar), McGuire (1995) convention
pWeight = weight/sumWeight; % normalized contribution of each (M,R,eps) bin
Mbar   = sum(mag  .* pWeight);
Rbar   = sum(dist .* pWeight);
epsBar = sum(eps  .* pWeight);
fprintf('Expected (mean) deaggregation tuple: (Mbar, Rbar, epsBar) = (%.2f, %.1f km, %.2f)\n', Mbar, Rbar, epsBar);

% find grid points for mag, dist, and eps
Mi = unique(mag); Rjb = unique(dist); epsk = unique(eps);
numEpsBins = size(epsk, 2);

if size(mag,2) ~= size(Mi,2)*size(Rjb,2)*numEpsBins
    warning(['Input length (%d) does not equal numMagBins*numDistBins*numEpsBins (%d). ' ...
        'Make sure every (M,R,eps) combination is present (use weight=0 for empty cells), ' ...
        'or the reshape below will error/misalign.'], size(mag,2), size(Mi,2)*size(Rjb,2)*numEpsBins);
end

% hot to cool gradual colors (courtesy- colorbrewer.org)
% NOTE: hotToCoolColorMap.m only supports n = 5,7,9,11,12 - use a generic
% interpolated version instead so ANY numEpsBins works.
colorLIST = localHotToCoolColorMap(numEpsBins);
fprintf('We got %i epsilon-bins. Assigning hot-to-cool color map accordingly.\n', numEpsBins);

% create a list of legends
legList = cell(1, numEpsBins);
if numEpsBins > 1
    epskForLeg = (epsk(1:end-1) + epsk(2:end))/2; % eps bin range values for legend
    legList{1, 1} = sprintf('$ \\varepsilon = (-\\infty, %.2f)  $', epskForLeg(1));
    for i = 2:numEpsBins-1
        legList{1, i} = sprintf('$ \\varepsilon = [%.2f, %.2f)  $', epskForLeg(i-1), epskForLeg(i));
    end
    legList{1, numEpsBins} = sprintf('$ \\varepsilon = [%.2f, \\infty)  $', epskForLeg(end));
else
    legList{1, 1} = sprintf('$ \\varepsilon = %.2f $', epsk(1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('units','normalized','outerposition',[0.5 0.25 0.5 0.55]);

% calculate the cumulative lambda
lambdaCum = zeros(size(Mi, 2), size(Rjb, 2), numEpsBins+1); % extra dimension with all zeros

for k = 1:numEpsBins
    epsCurr = epsk(1, k);
    lambdaCurr = weight(abs(eps - epsCurr) < 1e-10)/sumWeight*100;
    lambdaCurr = reshape(lambdaCurr, [size(Rjb, 2), size(Mi, 2)])'; % same resize convention as fun_deagg_v2
    lambdaCum(:, :, k + 1) = lambdaCum(:, :, k) + lambdaCurr;
end

tol = 0.05; % remove contributions less than 0.05%
for k = numEpsBins:-1:1
    barHandleId = k;
    h{barHandleId} = bar3(lambdaCum(:, :, k + 1)', 0.4); hold on;
    set(h{barHandleId}, 'faceColor', colorLIST(barHandleId, :));
    remove_empty_bars(h{barHandleId}, tol);
end

% define and move legend entries
hBarForLeg = []; for j = 1:size(h, 2); hBarForLeg = [hBarForLeg, h{j}(1)]; end
legh = legend(hBarForLeg, legList, 'Interpreter', 'latex');
set(legh, 'position', [0.8 0.55 0 0.25]); % L-B-dx-dy
ax = gca; ax.Projection = 'orthographic';

pbaspect([2.0 3.75 1]);
azNew = -60; elNew = 20;
view([azNew, elNew]);

% adjust ticks - auto-ranged from your actual M, R data (round to sensible steps)
magTick = ceil(min(Mi)):1:floor(max(Mi))+1;
distTick = 0:50:(50*ceil(max(Rjb)/50));
contTick = 0:5:25;

magTickIndex = interp1(Mi, 1:length(Mi), magTick, 'pchip');
distTickIndex = interp1(Rjb, 1:length(Rjb), distTick, 'pchip');

set(gca,'XTick', magTickIndex); set(gca,'XTickLabel', magTick);
set(gca,'YTick', distTickIndex); set(gca,'YTickLabel', distTick);
set(gca,'ZTick', contTick);

xlim([min(magTickIndex) max(magTickIndex)]); ylim([min(distTickIndex) max(distTickIndex)]);

hx = xlabel('Magnitude', 'Interpreter', 'latex');
hy = ylabel('Distance, $R_{jb}$ (km)', 'Interpreter', 'latex');
hz = zlabel('Contribution to Hazard (\%)', 'Interpreter', 'latex');
posx = hx.Position; posy = hy.Position;
set(hx, 'Position', posx.*[1.0,1,0.95],'Rotation', 35);
set(hy, 'Position', posy.*[0.8,0.8,0.5],'Rotation', -11);

zMax = zlim; zMax = zMax(2); zMax = 5*ceil(zMax/5);
if zMax == 0; zMax = 5; end
zlim([0 zMax]);
if ~isempty(textStr)
    htext = text(55, 4, 0.9 * zMax, textStr, 'Interpreter', 'latex', 'FontSize', 16, ...
        'FontWeight', 'bold', 'HorizontalAlignment','left', 'EdgeColor', 'k'); %#ok<NASGU>
end

% psb_FigureFormatScript_paper  % uncomment if this formatting script is on your path

if doSave == 1
    if ~exist(dirFig, 'dir'); mkdir(dirFig); end
    cd(dirFig);
    set(gcf,'renderer','Painters');
    saveas(gcf, exportName, 'fig');
    saveas(gcf, exportName, 'epsc');
    saveas(gcf, exportName, 'jpeg');
    fprintf('Figure(s) saved in %s\n', pwd);
    cd(baseFolder);
end

end

function cmap = localHotToCoolColorMap(n)
%% Generic hot-to-cool (red -> yellow -> blue) colormap for ANY n >= 1,
%  built by interpolating a fixed 11-point colorbrewer-style RdYlBu reference
%  palette. Row 1 = hottest (red), row n = coolest (blue) - same convention
%  as the original hotToCoolColorMap.m.
refColors = [ ...
    165   0  38;  % dark red
    215  48  39;
    244 109  67;
    253 174  97;
    254 224 144;
    255 255 191;  % pale yellow (middle)
    224 243 248;
    171 217 233;
    116 173 209;
     69 117 180;
     49  54 149]; % dark blue
refColors = refColors/255;

if n == 1
    cmap = refColors(6, :); % single bin -> neutral middle color
    return
end

refX = linspace(0, 1, size(refColors, 1));
qX   = linspace(0, 1, n);
cmap = zeros(n, 3);
for c = 1:3
    cmap(:, c) = interp1(refX, refColors(:, c), qX, 'linear')';
end
end