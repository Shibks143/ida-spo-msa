%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% plot a single frag for non-structural elements (reviewer during
%%%% acceptance of spectra paper)

meanLIST = [1.732979119	2.555865179	2.916223808];
betRTRLIST = [];
plotStyle = {'r-', 'b-', 'g-', 'c-', 'm-'};

figure(786); t = tiledlayout(1, 3, 'TileSpacing','compact');
set(gcf, 'Position', [50 200 1500 460]);

%% 2x. formatting the fragility curves for saving (ploted under fun3)
minValue = 0; maxValue = 5;
for LS = 1:3 %
    h1(LS) = PlotLogNormalCDF_current(log(), sigmaLn(LS), minValue, maxValue, plotStyle{LS}); hold on; grid on;
    xticks(1:5); % yticks(0:0.2:1);
end

xlim([minValue, maxValue]);
str1 = '$Sa(T_1)/Sa_{MCE}$'; str2 = '$F[LS_i|IM]$'; hx = xlabel(str1, 'Interpreter', 'latex');
hy = ylabel(str2, 'Interpreter', 'latex');
psb_FigureFormatScript_paper_3figsInOneRow

legTxt = {'$LS_1 \qquad$', '$LS_2 \qquad$', '$LS_3 \qquad$', '$LS_4 \qquad$', '$LS_5\,\,$'};
legh = legend(h1(1:5), legTxt, 'Orientation', 'Horizontal', 'Interpreter','latex');
legh.Layout.Tile = 'north';

psb_FigureFormatScript_paper_3figsInOneRow;

cd(baseFolder);  if ~exist(dirForFigures, 'dir'); mkdir(dirForFigures); end
cd(dirForFigures);
exportName = sprintf('combined_Frag_%s', 'R2');

extensions = {'fig', 'epsc', 'meta'};
for k = 1:length(extensions)
    saveas(gcf, exportName, extensions{k})
end