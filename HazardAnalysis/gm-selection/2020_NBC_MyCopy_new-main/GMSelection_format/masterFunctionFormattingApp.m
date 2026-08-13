function processInfo = masterFunctionFormattingApp(userInputs)

% filePathName = matlab.desktop.editor.getActiveFilename; % returns active file's path. we need running file's (our app's) path
filePathName = mfilename('fullpath'); 
[filePath, ~, ~] = fileparts(filePathName); cd(filePath); 

% example inputs while programing (for debugging and documentation)
% userInputs.rawRecDir = 'ScaledRawCoding';
% userInputs.FormatST = 0;  % radio button option-1
% userInputs.FormatPSB = 1; % radio button option-2
% userInputs.fileNamingRule = 'H%dir_%i.dat';
% userInputs.eqIDinitial = 6001;
% userInputs.eqInfoFilename = 'defineEQInfoForMATLAB.m';
% userInputs.T1forEqInfoFile = 1.17;
% userInputs.formRecDir = 'ScaledRawCoding_formatted_psb';
% userInputs.secsAtEnd = 0;
% userInputs.saveResSpec = 0;
% userInputs.specDir = 'ScaledRawCoding_EQ_Spectra_psb';

linebreakStr = [newline, repmat('-', 1, 40), newline];

% read all records from rawRecDir
[formatInfo1, THInfo] = fun_readRecs(userInputs); 

% format records depending on the radio button selection % 1 file/record (.dat for ag) + EqInfo file (.tcl) % 3 files/record (.txt for dt, N, ag) + EqInfo file (.tcl)
[formatInfo2, eqNumLIST] = fun_writeRecs(userInputs, THInfo); 

% save the EQ info file
formatInfo3 = fun_writeEqInfoFile(userInputs, THInfo);

% save response spectra
formatInfo4 = fun_saveResSpec(userInputs, THInfo);

processInfo = [linebreakStr, formatInfo1, linebreakStr, formatInfo2, linebreakStr, formatInfo3, linebreakStr, formatInfo4, linebreakStr, num2str(eqNumLIST), linebreakStr, 'All done!', linebreakStr,];
fprintf('%s\n', processInfo);



