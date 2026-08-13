clear; tic;
baseFolder = pwd;

%% inputs depending on the site (lon, lat) (Table from NRCan)
dirName = 'AllOpenQuakeOutputs\Van_Haz_SaMult'; % dirName = 'AllOpenQuakeOutputs\Vic_Haz_SaMult'; 
lonLat = [-123.12 49.25]; % lonLat = [-123.37, 48.43];
locName = 'Vancouver'; % 1locName = 'Victoria';
% T1LIST = [0 0.1 0.2 0.5 1 2 5];% period for spectral accelerations for different hazard curves
T1LIST = [4.37]; % [0.83 1.68 2.41];% period for spectral accelerations for different hazard curves

exportName = 'Van_Haz_cur_SA_4p37_v1';
dirFig = 'hazardCurves_Sa4p37_Van';
extensions = {'epsc', 'fig'}; % {'fig', 'epsc', 'png', 'jpeg', 'meta', 'pdf'};

%%  1. Extracting hazard
plotType = 'loglog'; % 'semilog', 'loglog, 'linear'
plotStyle = {'k-', 'b--', 'r-.', 'm:', 'k-', 'b--', 'r-.', 'm:', 'k--'};
lineW = [1.5*ones(1, 4) 0.8*ones(1, 5)];
doSave = 1; % save the plot
doSaveHazDataAsMat = 1; % save the hazard data as a mat file

for j = 1:size(T1LIST, 2)
    T1Curr = T1LIST(1, j);
    
    if T1Curr == 0; imString = 'PGA';
    elseif T1Curr == round(T1Curr); imString = sprintf('SA(%.1f)', T1Curr);
    else; imString = sprintf('SA(%g)', T1Curr);
    end
    
    % 1a. extract hazard curve data from OpenQuake's result files (PSHA results to be copied to dirName)
    [imVals, afeVals, poeVals50y] = fun_returnHazCurFromPSHAFiles_v2(dirName, lonLat, imString);
    if doSaveHazDataAsMat == 1
        fileName = sprintf('HazCurve_%s_Sa%ip%i', locName, floor(T1Curr), int8(mod(T1Curr*100, 100)));
        cd(baseFolder); 

        if ~exist(dirFig, 'dir'); mkdir(dirFig); end
        cd(dirFig); % set(gca,'fontname','times');

        save(fileName, 'imVals', 'afeVals', 'poeVals50y');
        cd(baseFolder);
    end

    plot(imVals, afeVals, plotStyle{j}, 'LineWidth', lineW(j)); hold on; grid on;
    ax = gca;
    switch plotType
        case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
        case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
    end
end
hx = xlabel('$im = Sa(T) $ (g)', 'Interpreter', 'latex'); hy = ylabel('$H (im)$', 'Interpreter', 'latex');
% legh = legend(strForLegend);
xlim([1e-2 0.4]); ylim([0.999e-5 4e-2]); % change this, as need be
set(gca, 'YTick', 10.^[-10:0]); % generally no need to change these limits.
set(gca, 'XTick', 10.^[-10:0]); % generally no need to change these limits.
legTxt = strcat({'T = '}, strsplit(num2str(T1LIST, '%.2f\t')), {' s'});
legh = legend(legTxt);
psb_FigureFormatScript_paper
% psb_FigureFormatScript_paper_3figsInOneRow

if doSave == 1
   cd(baseFolder);
   if ~exist(dirFig, 'dir'); mkdir(dirFig); end
   cd(dirFig); % set(gca,'fontname','times');
   for k = 1:length(extensions)
       saveas(gcf, exportName, extensions{k}); 
   end
   fprintf('Figure(s) saved in %s\n', pwd);
end    
cd(baseFolder); toc