
function [imVals, afeVals, poeVals50y] = fun_returnHazCurFromPSHAFiles_v2(dirName, lonLat, imString)
% hazard curves
% clear; 
baseFolder = pwd; %tic;

%% Sample inputs
% dirName = 'VancouverCityHall_CNDPaper'; % dirName = 'VictoriaCombined'; 
% lonLat = [-123.12 49.25]; % lonLat = [-123.37, 48.43];
% imString = 'SA(0.2)';

%% navigate to the relevant directory
cd(dirName);

% delete the temp directory if exists
if exist('tempDir', 'dir')
    rmdir('tempDir', 's'); 
end
mkdir('tempDir');

zipfileName = dir('*-hcurves-csv.zip');
try 
    unzip(zipfileName.name, 'tempDir');
catch 
    error(['No zip file with suffix hcurves-csv exists in the directory. \n' ...
        'Try either (a) copying relevant zip file from openquake results or \n' ...
        '(2) modifying the current function to read .csv or any other file or \n'...
        '(3) provide hazard data alternatively and comment out the call to this function.\n']);
end
cd tempDir

hcurvMeanCsvFileName = sprintf('hazard_curve-mean-%s_*.csv', imString);
fileWithData = dir(hcurvMeanCsvFileName);
% rawDataInFile = readcell(fileWithData.name);
B = readcell(fileWithData.name);

if abs(B{3, 1} - lonLat(1)) + abs(B{3, 2} - lonLat(2)) > 1e-3
    error('The coordiantes of the site in .csv file do not match with the input coordinates.\n');
end

imVals = cell2mat(B(2, 4:end)');
imVals = str2double(string(imVals(:, 5:end))); 
poeVals50y = cell2mat(B(3, 4:end)');
afeVals = -log(1 - poeVals50y)/50;

% loglog(imVals, afeVals, 'k-', 'LineWidth', 2); hold on; grid on;
% hx = xlabel(imString, 'Interpreter', 'latex'); hy = ylabel('$ H_{IM} $', 'Interpreter', 'latex');
% % legh = legend(strForLegend);
% psb_FigureFormatScript_paper
% 
% im_475 = interp1(poeVals50y, imVals, 0.1);
% im_2475 = interp1(poeVals50y, imVals, 0.02);
% 
% fprintf('%s for 475 year return period is %gg.\n', imString, im_475);
% fprintf('%s for 2475 year return period is %gg.\n', imString, im_2475);

cd(baseFolder); % toc;