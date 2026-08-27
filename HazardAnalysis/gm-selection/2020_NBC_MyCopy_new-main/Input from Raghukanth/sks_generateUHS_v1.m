function [periodsForUHS, UHS_Sa, UHS_Table] = sks_generateUHS_v1(hazardInputs)

%% Generate Uniform Hazard Spectrum (UHS)
%
% INPUT
%   hazardInputs - structure containing all hazard-related inputs
%
% OUTPUT
%   periodsForUHS - periods used for UHS
%   UHS_Sa        - Sa(period, return period)
%   UHS_Table     - UHS results as MATLAB table

baseFolder =        hazardInputs.baseFolder;
pshaVersion =       hazardInputs.pshaVersion;
locName =           hazardInputs.locName;
doSave =            hazardInputs.doSave;
returnPeriods_UHS = hazardInputs.returnPeriods_UHS;


%% ------------------------------------------------------------------------
% Determine periods for UHS
% -------------------------------------------------------------------------
if isempty(hazardInputs.periodsForUHS)
    switch pshaVersion
        case 'old'
            periodsForUHS = hazardInputs.T1LIST;
        case 'new'
            [~, ~, periodsForUHS] = extractHazForLoc_20260818_v1(hazardInputs);
        otherwise
            error('Unknown pshaVersion: %s',pshaVersion);
    end
else
    periodsForUHS = hazardInputs.periodsForUHS;
end

%% ------------------------------------------------------------------------
% Initialize UHS matrix
% -------------------------------------------------------------------------
nPerUHS = numel(periodsForUHS);
nRP     = numel(returnPeriods_UHS);
UHS_Sa = nan(nPerUHS, nRP);

%% ------------------------------------------------------------------------
% Calculate UHS
% -------------------------------------------------------------------------
for p = 1:nPerUHS
    Tcurr = periodsForUHS(p);
    switch pshaVersion
        case 'old'
            [imValLIST, afeLIST] = findHazValRaghukanth20200111_v4(hazardInputs, Tcurr);
        case 'new'
            [imValLIST, afeLIST] = findHazValRaghukanth20260818_v4(hazardInputs, Tcurr);
        otherwise
            error('Unknown pshaVersion: %s', pshaVersion);
    end

    % Discretize hazard curve
    [imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(hazardInputs, imValLIST, afeLIST);

    % Sort AFE for interpolation
    [afeSorted, sortIdx] = sort(afeDisc);
    imValSorted = imValDisc(sortIdx);

    % Sa corresponding to each return period
    for r = 1:nRP
        targetAFE = 1 / returnPeriods_UHS(r);
        UHS_Sa(p,r) = exp(interp1(log(afeSorted), log(imValSorted), log(targetAFE), 'linear', NaN));
    end
end

%% ------------------------------------------------------------------------
% Create UHS table
% -------------------------------------------------------------------------
rpVarNames = matlab.lang.makeValidName(strcat(string(returnPeriods_UHS), "yr"));
UHS_Table = array2table([periodsForUHS(:), UHS_Sa], 'VariableNames', [{'Period_sec'}, cellstr(rpVarNames)]);


%% ------------------------------------------------------------------------
% Plot UHS
% -------------------------------------------------------------------------
figure;
hold on;
grid on;
box on;
hUHS = gobjects(nRP,1);

for r = 1:nRP
    hUHS(r) = plot(periodsForUHS, UHS_Sa(:,r), 'LineWidth', 1.5, 'DisplayName', sprintf('%d yr', returnPeriods_UHS(r)));
end

xlabel('$\mathrm{Period},\,T\;(\mathrm{s})$');
ylabel('$S_a\;(\mathrm{g})$');
title(sprintf('Uniform Hazard Spectrum - %s', locName));
legend(hUHS, 'Location', 'eastoutside');
xlim([min(periodsForUHS) max(periodsForUHS)]);
sks_figureFormat('powerpoint');

%% ------------------------------------------------------------------------
% Save UHS
% -------------------------------------------------------------------------
if doSave
    exportFolder = fullfile(baseFolder, 'hazardCurves');
    if ~exist(exportFolder, 'dir')
        mkdir(exportFolder);
    end
 
    % Save UHS figure
    oldFolder = pwd;
    cd(exportFolder);
    exportName = sprintf('UHS_%s_%sPSHA', locName, pshaVersion);
    sks_figureExport(exportName);
    cd(oldFolder);
end

end