clear; tic; baseFolder = pwd;

entryType = input('Enter the EQID to download. Direct entry (1) or File entry (2).\n');
if entryType == 1
    IDsToDownload = input('Input the list of records to download separated by comma (e.g., ''IBRH171103111515, CHBH161103111515, IKRH030309260450'').\n', 's');
    EQIDsToDownload = strsplit(IDsToDownload, [",", " ", ";"])';
elseif entryType == 2
    listOfRecordsFileName = input('Enter the .dat file name (with extension) saved by GM Selection module \n', 's');
    %     x = readtable('40GM_1p17_CB14_SF5_Van.dat');
    if isfile([listOfRecordsFileName, '.dat']) || isfile(listOfRecordsFileName)
        x = readtable(listOfRecordsFileName); EQIDsToDownload = x.RecordID;
    else
        error('File not found. Check if it exists on the same path.')
    end
else
    error('Invalid entry. Rerun the script. Enter 1 for Direct entry or 2 for File entry.')
end

dirToSave = input('Enter the directory to save the downloaded files.\n', 's');
if ~exist(dirToSave, 'dir'); mkdir(dirToSave); end
cd(dirToSave)

username = input('Enter your username for https://www.kyoshin.bosai.go.jp/ \n', 's');
password = input('Enter your password:\n', 's');


%% web options
webOptions = weboptions('Username', username, 'Password', password);

% example fileName- IBRH171103111515.tar.gz
% example eqID-     IBRH171103111515
% example URL:-     https://www.kyoshin.bosai.go.jp/kyoshin/download/kik/6comp/2011/03/20110311151500/IBRH171103111515.tar.gz

numRecs = size(EQIDsToDownload, 1);
f = waitbar(0,'1','Name','Downloading records from kyoshin ...', 'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);
succCount = 0; failCount = 0;
for i = 1:numRecs
    waitbar(i/numRecs, f, sprintf('%i%% done', int32(i/numRecs*100)))
    eqID = EQIDsToDownload{i, 1};
    fileNameToSave = sprintf('%s.tar.gz', eqID); 
    yyyy = 1900 + str2double(eqID(7:8)); % 2 bit for year
    if yyyy < 1990; yyyy = yyyy + 100; end % no recordings before 1990
    mm = str2double(eqID(9:10)); dd = str2double(eqID(11:12));
    hh = str2double(eqID(13:14)); xx = str2double(eqID(15:16));

    yyyymmddhhmmss = sprintf('%.4i%.2i%.2i%.2i%.2i00', yyyy, mm, dd, hh, xx);
    downloadURL = sprintf('https://www.kyoshin.bosai.go.jp/kyoshin/download/kik/6comp/%i/%.2i/%s/%s', yyyy, mm, yyyymmddhhmmss, fileNameToSave);
    try
        websave(fileNameToSave, downloadURL, webOptions);
        succCount = succCount + 1;
    catch
        deleteEmptyHtml = sprintf('%s.html', fileNameToSave);
        delete(deleteEmptyHtml); % delete empty html, update the failed message
        failCount = failCount + 1; errDownload{failCount, 1} = eqID;
    end
end
f = waitbar(1, f, '100% done'); delete(f); %close f force; 

fprintf('--------------------------------------\n');
fprintf('Successfully downloaded %i/%i records to %s.\n', succCount, numRecs, dirToSave);
if failCount ~= 0; fprintf('Failed to download the following:\n'); disp(errDownload); end
fprintf('--------------------------------------\n');

cd(baseFolder); toc