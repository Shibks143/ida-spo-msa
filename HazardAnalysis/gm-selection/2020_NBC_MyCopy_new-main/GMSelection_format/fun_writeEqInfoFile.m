function formatInfo = fun_writeEqInfoFile(userInputs, THInfo)
tStart = tic;  % TIC, pair
baseFolder = pwd;

T1 = userInputs.T1forEqInfoFile; 
currentDampRatio = userInputs.dampRatioForEqInfoFile; 
saT1_target = userInputs.SaT1forEqInfo; 

fprintf('Writing EQ infomation files ...');

if ~exist(userInputs.formRecDir, 'dir'); mkdir(userInputs.formRecDir); end
cd(userInputs.formRecDir);

if isfile(userInputs.eqInfoFilename)
    warning('%s already exists. Appending content at the end.', userInputs.eqInfoFilename);
    fid = fopen(userInputs.eqInfoFilename, 'at');
else
    fid = fopen(userInputs.eqInfoFilename, 'wt');
end
if fid == -1, error('Cannot open/write to file %s', fileName); end

eqInfo = []; % initialize info strings for writing
SFInfo = [];  dtInfo = [];  saT1Info = []; eqFilenameInfo = [];  numPtInfo = []; 

for i = 1:size(THInfo, 1)/2
    localEqID = userInputs.eqIDinitial + i - 1;
    if userInputs.FormatPSB == 1
        for k = 1:2 % write both component
            j = 2*i + k - 2;
            eqNumber = localEqID * 10 + k;
            dt = THInfo.dt(j);
            NumPoints = THInfo.NumPoints(j);
            database = THInfo.database{j};
            EQID = THInfo.EQID{j};
    
            eqInfo = [eqInfo, newline, sprintf('dtForEQRecord(%i) = %f;	\t numPointsForEQRecord(%i) = %i;', eqNumber, dt, eqNumber, NumPoints)];
            eqInfo = [eqInfo, sprintf('\t database{%i} = ''%s'';	\t EQID{%i} = ''%s'';', eqNumber, database, eqNumber, EQID)];
        end
    elseif userInputs.FormatST == 1

        % (10-31-22, psb) Biniam pointed out that scaling factors in ST's programs use SF_finalEQ(1) and SF_finalEQ(31) as two components
        % of the same ground motions and not (1) and (20). assuming 30 ground motions. 
        % Change the following snippet in the next update.

         for k = 1:2 % write both component
            j = 2*i + k - 2;
            eqNumber = userInputs.eqIDinitial + j - 1;
            dt = THInfo.dt(j); 
            NumPoints = THInfo.NumPoints(j); 
            THCell = THInfo.TH(j); TH = THCell{:};
            saT1_eq_currComp = elastic_Sa(T1, currentDampRatio, TH, dt); 
            
            % (read me) when k == 1; look for next i.e. j + 1; when k == 2; look for last i.e. j - 1
            % generalize this as, j + 3 - 2*k
            THOtherCompCell = THInfo.TH(j + 3 - 2*k); TH_otherComp = THOtherCompCell{:};
            saT1_eq_otherComp = elastic_Sa(T1, currentDampRatio, TH_otherComp, dt); 

            % scaling factor for geometric mean
            SF = saT1_target/sqrt(saT1_eq_currComp * saT1_eq_otherComp); 

            % update the TH with additional zeroes at the end
            numZeros = round(userInputs.secsAtEnd/dt); % floating point error would make this return non-integer sometimes.
            TH = [TH; zeros(numZeros, 1)];

        % replace %dir by 1 or 2 and %i by localEqID
            datFilename = strrep(userInputs.fileNamingRule, '%dir', num2str(k));
            datFilename = strrep(datFilename, '%i', num2str(localEqID));

            
            SFInfo = [SFInfo, newline, sprintf('set SF_finalEQ(%i)	%.9f', eqNumber, SF)];
            dtInfo = [dtInfo, newline, sprintf('set dtForEQ(%i)	%g', eqNumber, dt)];
            saT1Info = [saT1Info, newline, sprintf('set saTOneForEQ(%i)	%g', eqNumber, saT1_eq_currComp)];
            eqFilenameInfo = [eqFilenameInfo, newline, sprintf('set eqFileName(%i)	%s', eqNumber, datFilename)];
            numPtInfo = [numPtInfo, newline, sprintf('set numPointsForEQ(%i)	%i', eqNumber, NumPoints)];
         end
    end
end

if userInputs.FormatPSB == 1
    fprintf(fid, '%% Following information generated using NBCC_RecordFormattingAPP on %s by %s \n', datestr(now), getenv('username'));
    fprintf(fid, '%s', [eqInfo, newline]);
elseif userInputs.FormatST == 1
    headerTxt = ['#----------------------------------------------------------------------------------#', newline,  ... 
    '# DefineEarthquakeRecordInformation', newline,  ...  
    '#		In this module, information needs to be define for each EQ record.', newline,  ... 
    '#		This is used when running the EQ (things like filename, etc.)', newline, ...   
    '#----------------------------------------------------------------------------------#', newline, newline, ...
    '# Notice - the PO uses eqNumber = 999, so don''t use that!!!!', newline, newline, ...
    '# Note that we need filename, dtForEQ, numPointsForEQ, and saTOneForEQ;', newline];
    fprintf(fid, '%s', headerTxt);
    fprintf(fid, '# Following information generated using NBCC_RecordFormattingAPP on %s by %s \n\n', datestr(now), getenv('username'));
    fprintf(fid, 'set NGMs %i', size(THInfo, 1)/2);
    fprintf(fid, '%s', [newline, SFInfo, newline, repmat('#', 1, 40), newline]);
    fprintf(fid, '%s', [newline, dtInfo, newline, repmat('#', 1, 40), newline]);
    fprintf(fid, '%s', [newline, saT1Info, newline, repmat('#', 1, 40), newline]);
    fprintf(fid, '%s', [newline, eqFilenameInfo, newline, repmat('#', 1, 40), newline]);
    fprintf(fid, '%s', [newline, numPtInfo, newline, repmat('#', 1, 40), newline]);
end
fclose(fid);

cd(baseFolder);
tElapsed = toc(tStart);  % TOC, pair
formatInfo = sprintf('Generated the EQ information file, %s (%.1f sec).', userInputs.eqInfoFilename, tElapsed);
fprintf(' (%.1f sec) \n', tElapsed);




