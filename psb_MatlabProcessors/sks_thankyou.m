%% sks_thankyou.m  (script)
% "THANK YOU!" speech-bubble slide graphic (16:9).
%   Formatting : sks_figureFormat('powerpoint')
%   Export     : sks_figureExport -> ..\Output\sks_thankyou.{fig,eps,tiff,emf}

clear; clc; close all;

%% 0. Paths (relative to this script, so it works from any current folder)
scriptFolder  = fileparts(mfilename('fullpath'));    % ...\psb_MatlabProcessors
projectFolder = fileparts(scriptFolder);             % ...\ida-spo-msa
outputFolder  = fullfile(projectFolder, 'Output');
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
exportName = fullfile(outputFolder, 'sks_thankyou');

%% 1. Canvas & studio-lit blue gradient background (16:9, 4K)
imageWidthPx  = 3840;
imageHeightPx = 2160;
[xGrid, yGrid] = meshgrid(linspace(0, 1, imageWidthPx), linspace(0, 1, imageHeightPx));

% Diagonal lighting gradient (brighter sky blue top-right, deeper blue bottom-left)
colorBottomLeft = [0.23, 0.44, 0.69];
colorTopRight   = [0.46, 0.70, 0.91];
gradientWeight  = 0.56 * xGrid + 0.44 * yGrid;

% Subtle radial key-light highlight at top-right
spotlight = 0.06 * exp(-((xGrid - 0.80).^2 / 0.18 + (yGrid - 0.78).^2 / 0.18));

backgroundRGB = zeros(imageHeightPx, imageWidthPx, 3);
for colorChannel = 1:3
    backgroundRGB(:,:,colorChannel) = (1 - gradientWeight) * colorBottomLeft(colorChannel) ...
                                    + gradientWeight * colorTopRight(colorChannel) + spotlight;
end
backgroundRGB = min(max(backgroundRGB, 0), 1);

%% 2. Speech-bubble polygon (normalized [0,1] space)
bubbleLeft   = 0.186;  bubbleRight = 0.814;
bubbleBottom = 0.365;  bubbleTop   = 0.735;
bottomBow = @(xVal) bubbleBottom + 0.004 * sin(pi * (xVal - bubbleLeft) / (bubbleRight - bubbleLeft));

% Top edge (left to right) with subtle paper-curl bow
xTopEdge = linspace(bubbleLeft, bubbleRight, 120)';
yTopEdge = bubbleTop - 0.005 * sin(pi * (xTopEdge - bubbleLeft) / (bubbleRight - bubbleLeft));

% Bottom edge, right of tail (right corner -> tail root 2)
xBottomRight = linspace(bubbleRight, 0.612, 50)';
yBottomRight = bottomBow(xBottomRight);

% Tail: quadratic Bezier curves out to a sharp tip and back
bezierParam = linspace(0, 1, 60)';
tailOutP0 = [0.612, bottomBow(0.612)];
tailOutP1 = [0.565, 0.295];
tailTip   = [0.495, 0.262];
tailOut   = (1-bezierParam).^2 .* tailOutP0 + 2*(1-bezierParam).*bezierParam .* tailOutP1 + bezierParam.^2 .* tailTip;

tailInP1 = [0.530, 0.305];
tailInP2 = [0.542, bottomBow(0.542)];
tailIn   = (1-bezierParam).^2 .* tailTip + 2*(1-bezierParam).*bezierParam .* tailInP1 + bezierParam.^2 .* tailInP2;

% Bottom edge, left of tail (tail root 1 -> left corner)
xBottomLeft = linspace(0.542, bubbleLeft, 70)';
yBottomLeft = bottomBow(xBottomLeft);

% Closed polygon
bubbleX = [xTopEdge; xBottomRight; tailOut(:,1); tailIn(:,1); xBottomLeft];
bubbleY = [yTopEdge; yBottomRight; tailOut(:,2); tailIn(:,2); yBottomLeft];

%% 3. Soft drop shadow (baked into the background so the bubble stays pure vector)
% Mask on a coarse grid for speed, blur, then upsample
[xCoarse, yCoarse] = meshgrid(linspace(0, 1, 480), linspace(0, 1, 270));

ambientMask = double(inpolygon(xCoarse, yCoarse, bubbleX - 0.032, bubbleY - 0.058));
contactMask = double(inpolygon(xCoarse, yCoarse, bubbleX - 0.014, bubbleY - 0.025));

shadowAlphaCoarse = min(0.52 * gaussianBlur2D(ambientMask, 14) + 0.28 * gaussianBlur2D(contactMask, 5), 0.72);
shadowAlpha       = interp2(xCoarse, yCoarse, shadowAlphaCoarse, xGrid, yGrid, 'linear', 0);

shadowRGB = [0.06, 0.14, 0.26];
for colorChannel = 1:3
    backgroundRGB(:,:,colorChannel) = backgroundRGB(:,:,colorChannel) .* (1 - shadowAlpha) ...
                                    + shadowRGB(colorChannel) .* shadowAlpha;
end
backgroundRGB = uint8(round(255 * backgroundRGB));   % 8x smaller than double -> lighter .fig/.eps/.emf
clear xGrid yGrid gradientWeight spotlight shadowAlpha

%% 4. Figure: backdrop image + vector bubble
fig = figure('Units', 'pixels', 'Position', [100, 100, 1280, 720], 'Visible', 'on');
ax  = axes('Parent', fig, 'Position', [0 0 1 1]);
hold(ax, 'on');

image(ax, [0 1], [0 1], backgroundRGB);

paperWhite = [0.955, 0.955, 0.948];
patch(ax, bubbleX, bubbleY, paperWhite, 'EdgeColor', [0.88, 0.88, 0.87], 'LineWidth', 0.4);

% ---- Common figure formatting (fonts, line widths) ----
sks_figureFormat('powerpoint');

% sks_figureFormat turns on grid/box/ticks: this is a picture, so hide the axes again
% NOTE: no 'axis equal' - the normalized [0,1]x[0,1] space must stretch to the full 16:9
% figure, otherwise the bubble is squeezed to a square and the text overflows it
set(ax, 'YDir', 'normal', 'Visible', 'off', 'DataAspectRatioMode', 'auto', 'PlotBoxAspectRatioMode', 'auto');
xlim(ax, [0 1]); ylim(ax, [0 1]);

%% 5. Lettering (added AFTER sks_figureFormat so it keeps Arial bold + normalized size;
%     sks_figureFormat would otherwise force LaTeX font and a point FontSize on every text object)
textShadowColor = [0.15, 0.31, 0.50];   % paper-thickness shadow (light from top-right)
textCutoutColor = [0.33, 0.56, 0.79];   % matches the blue backdrop
textStyle = {'FontName', 'Arial', 'FontWeight', 'bold', 'Interpreter', 'none', ...
             'FontUnits', 'normalized', 'FontSize', 0.118, ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle'};

text(ax, 0.496, 0.547, 'THANK YOU!', textStyle{:}, 'Color', textShadowColor);
text(ax, 0.500, 0.552, 'THANK YOU!', textStyle{:}, 'Color', textCutoutColor);

%% 6. Export to ..\Output (.fig, .eps, .tiff 600 dpi, .emf)
figure(fig);   % sks_figureExport works on gcf
sks_figureExport(exportName);
fprintf('Saved: %s.{fig,eps,tiff,emf}\n', exportName);

%% Local function (must stay at the end of the script)
function blurredImage = gaussianBlur2D(inputImage, sigmaPx)
% Separable 2D Gaussian blur (base MATLAB, no toolbox)
kernelRadius  = ceil(3 * sigmaPx);
kernelOffsets = -kernelRadius:kernelRadius;
gaussKernel   = exp(-(kernelOffsets.^2) / (2 * sigmaPx^2));
gaussKernel   = gaussKernel / sum(gaussKernel);
blurredImage  = conv2(conv2(inputImage, gaussKernel, 'same'), gaussKernel', 'same');
end
