function [formatInfo, eqNumLIST] = fun_writeRecs(userInputs, THInfo)
tStart = tic;  % TIC, pair
baseFolder = pwd;

fprintf('Writing formatted files ...');

if ~exist(userInputs.formRecDir, 'dir'); mkdir(userInputs.formRecDir); end
cd(userInputs.formRecDir);
        
eqNumLIST = [];

for i = 1:size(THInfo, 1)/2
    localEqID = userInputs.eqIDinitial + i - 1;
    if userInputs.FormatPSB == 1
        fixedInfo = '3 files/record (.txt for dt, N, ag)';
        for k = 1:2 % write both component
            j = 2*i + k - 2;
            eqNumber = localEqID * 10 + k; 
            dt = THInfo.dt(j); 
            NumPoints = THInfo.NumPoints(j); 
            THCell = THInfo.TH(j); TH = THCell{:};
    
%             save(sprintf('DtFile_(%i).txt', eqNumber), 'dt', '-ascii');
%             save(sprintf('NumPointsFile_(%i).txt', eqNumber), 'NumPoints', '-ascii');
%             save(sprintf('SortedEQFile_(%i).txt', eqNumber), 'TH', '-ascii');
            writematrix(dt, sprintf('DtFile_(%i).txt', eqNumber));
            writematrix(NumPoints, sprintf('NumPointsFile_(%i).txt', eqNumber));
            writematrix(TH, sprintf('SortedEQFile_(%i).txt', eqNumber));
            eqNumLIST = [eqNumLIST, eqNumber];
        end
    elseif userInputs.FormatST == 1
        fixedInfo = '1 file/record (.dat for ag)';
        for k = 1:2 % write both component
            j = 2*i + k - 2;
            eqNumber = userInputs.eqIDinitial + j - 1;
            dt = THInfo.dt(j); 
%             NumPoints = THInfo.NumPoints(j); 
            THCell = THInfo.TH(j); TH = THCell{:};
            numZeros = round(userInputs.secsAtEnd/dt);  % floating point error would make this return non-integer sometimes.
            TH = [TH; zeros(numZeros, 1)];
    
        % replace %dir by 1 or 2 and %i by localEqID
            datFilename = strrep(userInputs.fileNamingRule, '%dir', num2str(k));
            datFilename = strrep(datFilename, '%i', num2str(localEqID));

            writematrix(TH, datFilename);
            eqNumLIST = [eqNumLIST, eqNumber];
        end
    end
end

cd(baseFolder);
tElapsed = toc(tStart);  % TOC, pair
formatInfo = sprintf('%i records saved as %s (%.1f sec).', size(THInfo, 1), fixedInfo, tElapsed);
fprintf(' (%.1f sec) \n', tElapsed);
