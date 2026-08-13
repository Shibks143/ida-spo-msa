function fun_saveResSpecStandalone(eqCompNum, TH, dt)

minPeriod = 0.01; maxPeriod = 10.0; periodIncr = 0.01;
dampRatioLIST = [0.02, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30];

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
cd CorrectedTH_And_RespSpec\
save(saveFileName, 'SaAbs', 'eqCompNum', 'minPeriod', 'maxPeriod', 'periodIncr', 'periodVector', 'dampRatioLIST')
cd ..