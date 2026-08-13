function formatInfo = fun_saveResSpec(userInputs, THInfo)
tStart = tic;  % TIC, pair
baseFolder = pwd;

if userInputs.saveResSpec == 0
    formatInfo = 'Response spectra NOT requested';
    return
else
    fprintf('Generating PSa files ...');
end

if ~exist(userInputs.specDir, 'dir'); mkdir(userInputs.specDir); end

minPeriod = 0.01; maxPeriod = 10.0; periodIncr = 0.01;
dampRatioLIST = [0.02, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30];

% Loop and find dT for all EQ records
cd(userInputs.specDir);

for i = 1:size(THInfo, 1)/2
    localEqID = userInputs.eqIDinitial + i - 1;
    for k = 1:2 % write both component
        j = 2*i + k - 2;
        eqCompNum = localEqID * 10 + k;
        dt = THInfo.dt(j);
%         NumPoints = THInfo.NumPoints(j);
        THCell = THInfo.TH(j); TH = THCell{:};

%         timeVector = 0:dt:length(TH);
        periodVector = minPeriod:periodIncr:maxPeriod;

        % Loop through and compute the spectrum % Initialize vectors
        SaAbs = zeros(length(periodVector), length(dampRatioLIST));

        % Loop for all periods
        for periodNum = 1:length(periodVector)
            currentPeriod = periodVector(periodNum);

            % Loop for all damping ratios
            for dampRatioNum = 1:length(dampRatioLIST)
                currentDampRatio = dampRatioLIST(dampRatioNum);

                % Use function to compute response
                [SaAbs(periodNum, dampRatioNum)] = elastic_Sa(currentPeriod, currentDampRatio, TH, dt);
            end
        end
        saveFileName = sprintf('SaEQSpectrum_EQ_%d.mat', eqCompNum);
        save(saveFileName, 'SaAbs', 'eqCompNum', 'minPeriod', 'maxPeriod', 'periodIncr', 'periodVector', 'dampRatioLIST')
    end
     fprintf('.'); % Go back to the initial folder
end

cd(baseFolder);
tElapsed = toc(tStart);  % TOC, pair
formatInfo = sprintf('%i earthquake records processed for response spectra (%.1f sec).', size(THInfo, 1), tElapsed);
fprintf(' (%.1f sec) \n', tElapsed);
