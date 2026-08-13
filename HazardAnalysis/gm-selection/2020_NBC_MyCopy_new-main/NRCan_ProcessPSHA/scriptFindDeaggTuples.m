clear; tic; %close all;
baseFolder = pwd;

%% user inputs
oqOutpDirDis = '..\AllOpenQuakeOutputs\Van_Dis_SaMult';
oqOutpDirHaz = '..\AllOpenQuakeOutputs\Van_Haz_SaMult';
lonLat = [-123.12 49.25]; % lonLat = [-123.37, 48.43];
imString = 'SA(1.5)'; % 'PGA';
returnP = 4975; % 475 (corresponding results from OpenQuake deagg must be available)
deaggType = 'MagDistEps'; % 'MagDist'
% end of user inputs

%% read OpenQuake deaggaregation ouput file
% define poeT, poe target. Manual conversion to match with input to deagg
if returnP == 2475;    poeT = 0.02; elseif returnP == 475;    poeT = 0.10;
elseif returnP == 975;    poeT = 0.05; elseif returnP == 4975;    poeT = 0.01; end

%% program for deaggregation starts
cd(baseFolder); cd(oqOutpDirDis);

% delete the temp directory if exists
if exist('tempDir', 'dir')
    rmdir('tempDir', 's'); 
end
mkdir('tempDir');

zipfileName = dir('*-disagg-csv.zip');
unzip(zipfileName.name, 'tempDir');
cd tempDir

switch deaggType
    case 'MagDist' % M-R plot (ignore eps ranges)
        deaggFileName = sprintf('Mag_Dist-*.csv');
        fileWithData = dir(deaggFileName);
        allData = readcell(fileWithData.name);
        imt	= allData(3:end, 1)'; poe	= cell2mat(allData(3:end, 2)');
        mag	= cell2mat(allData(3:end, 3)'); dist = cell2mat(allData(3:end, 4)');
        rlz = cell2mat(allData(3:end, 5)');
    case 'MagDistEps'
        deaggFileName = sprintf('Mag_Dist_Eps-*.csv');
        fileWithData = dir(deaggFileName);
        allData = readcell(fileWithData.name);
        imt	= allData(3:end, 1)'; poe	= cell2mat(allData(3:end, 2)');
        mag	= cell2mat(allData(3:end, 3)'); dist = cell2mat(allData(3:end, 4)');
        eps	= cell2mat(allData(3:end, 5)'); rlz = cell2mat(allData(3:end, 6)');
end
cd(baseFolder);

% find matching data for imString AND return period of interest
indexMatchingIm_Tr = find(strcmp(imt, imString) & abs(poe - poeT) < 1e-4);

% filter the corresponding data for imString and Tr of interest
imt = imt(indexMatchingIm_Tr);  poe	= poe(indexMatchingIm_Tr);
mag	= mag(indexMatchingIm_Tr);	dist =dist(indexMatchingIm_Tr);
rlz = rlz(indexMatchingIm_Tr);  sumRlz = sum(rlz);
if strcmp(deaggType, 'MagDistEps');  eps	= eps(indexMatchingIm_Tr); end

% find grid points for mag, dist, and eps
Mi = unique(mag); Rj = unique(dist);
if strcmp(deaggType, 'MagDistEps');  epsk = unique(eps); end
numEpsBins = size(epsk, 2);

% calculate the cumulative lambda
lambdaCum = zeros(size(Mi, 2), size(Rj, 2), numEpsBins+1); % extra dimension with all zeros

for k = 1:numEpsBins
    epsCurr = epsk(1, k);
    lambdaCurr = rlz(abs(eps - epsCurr) < 1e-10)/sumRlz*100; % sum(lambdaCurr)
    lambdaCurr = reshape(lambdaCurr, [size(Rj, 2), size(Mi, 2)])'; % resizing cross-checked with excel data. All okay!
    lambdaCum(:, :, k + 1) = lambdaCum(:, :, k) + lambdaCurr;
end

lambdaContr = lambdaCum(:, :, numEpsBins + 1);
lambdaContr = lambdaContr./sum(sum(lambdaContr))*100;

lambdaContrWithZero = lambdaContr;
lambdaContrWithZero (lambdaContrWithZero < 0.1) = 0; % replace small numbers by zero for finding peaks.

lambdaContr (lambdaContr < 0.1) = nan; % replace small contributions (< 0.1%) by NaN for plotting

[mGrid,rGrid] = ndgrid(Mi, Rj);

griddedData.x = mGrid; griddedData.y = rGrid; griddedData.z = lambdaContrWithZero;

peakdata = fun_FindPeaks_2d(griddedData);
stem3(mGrid, rGrid, lambdaContr, 'b-'); hold on;
peakX = peakdata.peakX; peakY = peakdata.peakY; peakZ = peakdata.peakZ;
plot3(peakX, peakY, peakZ, 'r*','MarkerSize',20)

T = table(peakX, peakY, peakZ);
disp(T);  fprintf('%s \n', repmat('-', 60, 1));
fprintf('Use the plot to pick source-wise relevant disaggregated tuples.\n'); fprintf('%s \n', repmat('-', 60, 1));

%% program for deaggregation for source starts
cd(baseFolder); cd(oqOutpDirDis);
cd tempDir
deaggFileName = sprintf('TRT-*.csv');
fileWithData = dir(deaggFileName);
allData = readcell(fileWithData.name);
imt	= allData(3:end, 1); poe	= cell2mat(allData(3:end, 2));
trt	= allData(3:end, 3); rlz = cell2mat(allData(3:end, 4));

% find matching data for imString AND return period of interest
indexMatchingIm_Tr = find(strcmp(imt, imString) & abs(poe - poeT) < 1e-4);

% filter the corresponding data for imString and Tr of interest
imt = imt(indexMatchingIm_Tr);  poe	= poe(indexMatchingIm_Tr);
trt	= trt(indexMatchingIm_Tr);	
rlz = rlz(indexMatchingIm_Tr);  sumRlz = sum(rlz);
lambda_in_pc = round(rlz./sumRlz*100, 1);

T_sourceDeagg = table(trt, lambda_in_pc);
disp(T_sourceDeagg);  fprintf('%s \n', repmat('-', 60, 1));

cd(baseFolder)
% clearvars -except mGrid rGrid lambdaContr lambdaContrWithZero 
toc;
