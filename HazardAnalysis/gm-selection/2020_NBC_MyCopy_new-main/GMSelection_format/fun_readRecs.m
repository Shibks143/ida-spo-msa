function [formatInfo, THInfo] = fun_readRecs(userInputs)
tStart = tic;  % TIC, pair
baseFolder = pwd;
linebreakStr = [newline, repmat('-', 1, 40), newline];

fprintf('Reading raw downloaded files ...');

%% Some error-handling (empty/missing directory)
try % get the info of directory and come back
    cd(userInputs.rawRecDir); dirContents = dir; cd ..;
catch
    cd(baseFolder); error('Missing directory. << %s >> does NOT exist.', userInputs.rawRecDir);
end
if size(dirContents, 1) == 2
    cd(baseFolder); error('Empty directory << %s >>', userInputs.rawRecDir);
end

%% Go into each directory and see what it got; 
% if it has a known file-type (.AT2, .zip, .tar.gz, .NS2, .EW2) process it. 
usefulRec = 0; zipCount = 0; boreHoleRecCount = 0;

for i = 3:size(dirContents, 1) % first two directories are root; error handled above for empty dir
    if dirContents(i).isdir % Is it a directory? Move on. 
        continue
    else % proceed if we recognize the extension
        filename = dirContents(i).name;
        [~, ~, ext] = fileparts(filename);
% if it is a zipped file, keep a count to send a message
        if strcmpi(ext, '.zip') || strcmpi(ext, '.gz')
            zipCount = zipCount + 1;
% else, format if it one of the files we want to process;
        elseif strcmpi(ext, '.AT2')
            fileData = readNGAW2File(userInputs.rawRecDir, filename);
            if fileData.horComp == 1
                usefulRec = usefulRec + 1; THInfo(usefulRec) = fileData; fprintf('.');
            end
        elseif strcmpi(ext, '.NS2') || strcmpi(ext, '.EW2')
            fileData = readKiKFile(userInputs.rawRecDir, filename);
            if fileData.horComp == 1
                usefulRec = usefulRec + 1; THInfo(usefulRec) = fileData; 
            end
        elseif strcmpi(ext, '.NS1') || strcmpi(ext, '.EW1')
            boreHoleRecCount = boreHoleRecCount + 1;
        else
            continue
        end
    end
end
boreHoleRecCount = boreHoleRecCount/2; % we counted each component once
infoStr = sprintf('%i bore hole records found but not processed.', boreHoleRecCount);
formatInfo = [infoStr, linebreakStr];

if ~exist('THInfo', 'var')
    error('No raw files to process. Make sure that the directory contains .AT2/.NS2/.EW2 files.');
end

% convert to a table and sort by EQID
THInfo = struct2table(THInfo); THInfo = sortrows(THInfo, 'EQID');

%% check here for two horizontal recordings with same EQID (for KiK) or RSN (for NGA-W2).
% repeated TH.EQID and two TH.horComp = 1
numRecs = size(THInfo, 1); uniqueIDs = unique(THInfo.EQID); 
numUniqueEQIDs = size(uniqueIDs, 1);
infoStr = sprintf('%i components processed. %i unique recordings.', numRecs, numUniqueEQIDs);
formatInfo = [formatInfo, infoStr, linebreakStr];
infoStr = sprintf('%s\t', uniqueIDs{:});
formatInfo = [formatInfo, 'Processed EQIDs are ', newline, infoStr, linebreakStr];

numRecs = size(THInfo, 1); numUniqueEQIDs = size(unique(THInfo.EQID), 1);
if abs(numUniqueEQIDs * 2 - numRecs ) < 0.1 % comparing integers
    infoStr = sprintf('all %i records have matching horizontal components', numUniqueEQIDs);
    formatInfo = [formatInfo, infoStr];
elseif numUniqueEQIDs * 2 < numRecs + 0.1
    warning('Program has detected some records with > 2 horizontal components. Check the %s file to find anomalies.', userInputs.eqInfoFilename);
elseif numUniqueEQIDs * 2 > numRecs + 0.1
    warning('Program has detected some records with 1 horizontal component. Check the %s file to find anomalies.', userInputs.eqInfoFilename);
end

cd(baseFolder);
tElapsed = toc(tStart);  % TOC, pair
formatInfo = sprintf('%s (%.1f sec).', formatInfo, tElapsed);
fprintf(' (%.1f sec) \n', tElapsed);
