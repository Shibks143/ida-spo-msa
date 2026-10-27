% hazard curves
clear; baseFolder = pwd; tic;
hazDirName = 'NRCan_Van_Sa1p68_Haz'; 
lonLat = [-123.12 49.25]; % lon first the lat (Vancouver) (source- NRCan)
imString = 'SA(1.68)';

cd(hazDirName);
try 
    try 
        zipfileName = dir('*-hcurves-csv.zip');
        unzip(zipfileName.name, 'tempDir');
        cd tempDir
        hcurvMeanCsvFileName = sprintf('hazard_curve-mean-%s_*.csv', imString);
        hcurvefileName = dir(hcurvMeanCsvFileName);
    catch 
        hcurvefileName = dir(sprintf('*-hazard_curve-mean-%s*.csv', imString));
    end
    fprintf('Hazard analysis for the specified Intensity measure found...\n');
catch
    error('Hazard analysis for the specified Intensity measure NOT found.');
end
    % rawDataInFile = readcell(fileWithData.name);
    B = readcell(hcurvefileName.name);

if abs(B{3, 1} - lonLat(1)) + abs(B{3, 2} - lonLat(2)) > 1e-3
    error('The coordiantes of the site in .csv file does not match with the input coordinates.');
else 
    fprintf('Hazard analysis for the specified location found...\n');
end

imVals = cell2mat(B(2, 4:end)');
imVals = str2double(string(imVals(:, 5:end))); 
poeVals = cell2mat(B(3, 4:end)');

loglog(imVals, poeVals); hold on; grid on;

cd(baseFolder); toc;