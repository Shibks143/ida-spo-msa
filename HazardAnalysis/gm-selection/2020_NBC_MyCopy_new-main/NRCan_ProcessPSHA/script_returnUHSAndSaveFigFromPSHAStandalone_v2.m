
% function [periods, imVals] = fun_returnUHSFromPSHAFiles_v1(dirName, lonLat, returnP50y)
% uniform hazard spectrum 
clear; tic;
baseFolder = pwd;

%% Sample inputs
dirName = 'AllOpenQuakeOutputs\Van_Haz_SaMult'; % dirName = 'Vic_Haz_SaMult'; 
lonLat = [-123.12 49.25]; % lonLat = [-123.37, 48.43]; 
returnP50yplot = [0.02 0.10]; % enter the return period as % in 50y, e.g., for 2475 y, enter 0.02
doSave = 1; % save the plot
exportName = sprintf('HazSpecVan_2_10pc_v1');
dirFig = 'Overleaf_hazSpec';
extensions = {'epsc', 'fig'}; % {'fig', 'epsc', 'png', 'jpeg', 'meta', 'pdf'};

for k = 1:size(returnP50yplot, 2)
    returnP50y = returnP50yplot(1, k);
%% navigate to the relevant directory
cd(dirName);

% delete the temp directory if exists
if exist('tempDir', 'dir'); rmdir('tempDir', 's'); end
mkdir('tempDir');

zipfileName = dir('*-uhs-csv.zip');
try 
    unzip(zipfileName.name, 'tempDir');
catch 
    error(['No zip file with suffix uhs-csv exists in the directory. \n' ...
        'Try either (a) copying relevant zip file from openquake results or \n' ...
        '(2) modifying the current function to read .csv or any other file or \n'...
        '(3) provide UHS data alternatively and comment out the call to this function.\n']);
end
cd tempDir

uhsMeanCsvFileName = sprintf('hazard_uhs-mean_*.csv');
fileWithData = dir(uhsMeanCsvFileName);
% rawDataInFile = readcell(fileWithData.name);
B = readcell(fileWithData.name);

if abs(B{3, 1} - lonLat(1)) + abs(B{3, 2} - lonLat(2)) > 1e-3
    error('The coordiantes of the site in .csv file do not match with the input coordinates.\n');
end

for i = 1:size(B, 2) - 2
    returnP_period_str = cell2mat(B(2, 2 + i));

    returnPStr = returnP_period_str(1:strfind(returnP_period_str, '~')-1);
    returnP50yLIST(i) = str2double(returnPStr);

    timePStr = returnP_period_str(strfind(returnP_period_str, '~')+1:end);
    if strcmp(timePStr, 'PGA')
        periodLIST(i) = 0;
    elseif strfind(timePStr, 'SA')
        periodLIST(i) = str2double(timePStr(4:end-1));
    end

    hazValLIST(i) = cell2mat(B(3, 2+i));
end

periods{k} = periodLIST(abs(returnP50yLIST - returnP50y) < 1e-6);
imVals{k} = hazValLIST(abs(returnP50yLIST - returnP50y) < 1e-6);
cd(baseFolder); 
end

%%  Plot the extracted spectra 
plotType = 'linear'; % 'semilog', 'loglog, 'linear'
plotStyle = {'k-', 'b--', 'r-.'};
lineW = [1.5*ones(1, 3)];

for j = 1:size(returnP50yplot, 2)
    plot(periods{j}, imVals{j}, plotStyle{j}, 'LineWidth', lineW(j)); hold on; grid on;
    ax = gca;
    switch plotType
        case 'semilog' ; ax.XScale = 'linear'; ax.YScale = 'log'; hold on;
        case 'loglog'  ; ax.XScale = 'log'; ax.YScale = 'log'; hold on;
    end
end
hx = xlabel('Period, $T$ (s)', 'Interpreter', 'latex'); hy = ylabel('$Sa(T)$ (g)', 'Interpreter', 'latex');
% legh = legend(strForLegend);
xlim([0 5]); ylim([0 1.2]);
% set(gca, 'YTick', 10.^[-6:0]);
% set(gca, 'XTick', 10.^[-2:0]);
legTxt = strcat(strsplit(num2str(returnP50yplot*100, '%g\t')), {'% in 50y'});
legh = legend(legTxt);
psb_FigureFormatScript_paper
% psb_FigureFormatScript_paper_3figsInOneRow

if doSave == 1
   cd(baseFolder); 
   if ~exist(dirFig, 'dir'); mkdir(dirFig); end
   cd(dirFig); 
   for k = 1:length(extensions)
       saveas(gcf, exportName, extensions{k})
   end
   fprintf('Figure(s) saved in %s\n', pwd);
end    

cd(baseFolder); 
toc;

