function [periodsForUHS, UHS_Sa_ALL, UHS_Table_ALL, T_H, Sa_IS_LIST] = sks_UHS_ISResponse_combined_v1(hazardInputs)


%% =========================================================================
%  COMBINED UHS AND IS DESIGN RESPONSE SPECTRUM
% =========================================================================
%
%  Combines:
%    1. Uniform Hazard Spectrum (UHS) from PSHA
%    2. IS Design Response Spectrum
%
%  The PSHA UHS is plotted as continuous curves, while the IS design
%  response spectrum is plotted for the specified earthquake zone(s) and
%  return period(s).
%
%  INPUT
%    hazardInputs - structure containing all hazard-related inputs
%
%  OUTPUT
%    periodsForUHS - periods used for UHS
%    UHS_Sa        - UHS spectral acceleration matrix
%                    Sa(period, return period)
%    UHS_Table     - UHS results as MATLAB table
%    T_H           - IS response-spectrum period vector
%    Sa_IS_LIST    - IS design response spectrum matrix
%
% =========================================================================


%% --- 1. Unpack inputs ---------------------------------------------------

if ~isfield(hazardInputs, 'locNames') || numel(hazardInputs.locNames) ~= 2
    error('sks_UHS_ISResponse_combined_v1:locNames', 'hazardInputs.locNames must be a 1x2 cell array of two location names.');
end
locNames = hazardInputs.locNames;
latLons  = hazardInputs.latLons;   % {latLon1, latLon2}, matching locNames order
nLoc = 2;

baseFolder = hazardInputs.baseFolder;
pshaVersion = hazardInputs.pshaVersion;
doSave = hazardInputs.doSave;
returnPeriods_UHS = hazardInputs.returnPeriods_UHS;

%% --- 2. Determine UHS periods -------------------------------------------

if isempty(hazardInputs.periodsForUHS)
    switch pshaVersion
        case 'old'
            periodsForUHS = hazardInputs.T1LIST;
        case 'new'
            [~, ~, periodsForUHS] = extractHazForLoc_20260818_v1(hazardInputs);
        otherwise
            error('Unknown pshaVersion: %s', pshaVersion);
    end
else
    periodsForUHS = hazardInputs.periodsForUHS;
end
% --- Add: define UHS sizing (needed before the location loop) ----------
nPerUHS = numel(periodsForUHS);
nRP_UHS = numel(returnPeriods_UHS);

%% ---Sections 3 & 4 ------------------------------------------------------
UHS_Sa_ALL    = cell(1, nLoc);
UHS_Table_ALL = cell(1, nLoc);

for L = 1:nLoc
    hazardInputs_L = hazardInputs;
    hazardInputs_L.locName = locNames{L};
    hazardInputs_L.latLon  = latLons{L};
    hazardInputs_L.locationLISTforPlot = {locNames{L}};

    UHS_Sa = nan(nPerUHS, nRP_UHS);

    for p = 1:nPerUHS
        Tcurr = periodsForUHS(p);
        switch pshaVersion
            case 'old'
                [imValLIST, afeLIST] = findHazValRaghukanth20200111_v4(hazardInputs_L, Tcurr);
            case 'new'
                [imValLIST, afeLIST] = findHazValRaghukanth20260818_v4(hazardInputs_L, Tcurr);
            otherwise
                error('Unknown pshaVersion: %s', pshaVersion);
        end

        [imValDisc, afeDisc, ~] = returnHazCurveRaghukanth20200111_v2(hazardInputs_L, imValLIST, afeLIST);
        [afeSorted, sortIdx] = sort(afeDisc);
        imValSorted = imValDisc(sortIdx);

        for r = 1:nRP_UHS
            targetAFE = 1 / returnPeriods_UHS(r);
            UHS_Sa(p, r) = interp1(log(afeSorted), imValSorted, log(targetAFE), 'linear', NaN);
        end
    end

    UHS_Sa_ALL{L} = UHS_Sa;

    rpVarNames = matlab.lang.makeValidName(strcat(string(returnPeriods_UHS), "yr"));
    UHS_Table_ALL{L} = array2table([periodsForUHS(:), UHS_Sa], ...
        'VariableNames', [{'Period_sec'}, cellstr(rpVarNames)]);
end

%% --- 5. Unpack IS Response Spectrum inputs ------------------------------

if isfield(hazardInputs, 'earthquakeZones')
    eqZones = hazardInputs.earthquakeZones;
elseif isfield(hazardInputs, 'earthquakeZone')
    eqZones = hazardInputs.earthquakeZone;
else
    error('sks_UHS_ISResponse_combined_v1:missingField', 'Specify earthquakeZone or earthquakeZones');
end

% Ensure cell array of strings
if ischar(eqZones) || isstring(eqZones)
    eqZones = cellstr(eqZones);
end

if isfield(hazardInputs, 'returnPeriods')
    rPeriods = hazardInputs.returnPeriods;
elseif isfield(hazardInputs, 'returnPeriod')
    rPeriods = hazardInputs.returnPeriod;
else
    error('sks_UHS_ISResponse_combined_v1:missingField', 'Specify returnPeriod or returnPeriods.');
end

THmax = hazardInputs.THmax;
dT_H  = hazardInputs.dT_H;

%% --- 6. Determine IS analysis mode --------------------------------------
nZones = numel(eqZones);
nRP_IS = numel(rPeriods);

if nZones == 1
    plotMode = 'MultiRP';
elseif nRP_IS == 1
    plotMode = 'MultiZone';
else
    plotMode = 'Combined';
end

%% --- 7. Generate IS normalized spectrum -------------------------------

T_H = (0:dT_H:THmax)';
A_NH = nan(size(T_H));

% 0 < T <= 0.01 s
A_NH(T_H <= 0.01) = 1.0;

% 0.01 < T <= 0.1 s
idx = T_H > 0.01 & T_H <= 0.1;

A_NH(idx) = 1.0 + (50/3) .* (T_H(idx) - 0.01);

% 0.1 < T <= 0.4 s
idx = T_H > 0.1 & T_H <= 0.4;
A_NH(idx) = 2.5;

% 0.4 < T <= 6.0 s
idx = T_H > 0.4 & T_H <= 6.0;
A_NH(idx) = 1 ./ T_H(idx);


% 6.0 < T <= 10.0 s
idx = T_H > 6.0 & T_H <= 10.0;
A_NH(idx) = 6 ./ T_H(idx).^2;


%% --- 8. Calculate IS design spectra ------------------------------------
nCurves = nZones * nRP_IS;
Sa_IS_LIST = nan(numel(T_H), nCurves);
legendLabels_IS = cell(nCurves,1);
curveIdx = 1;

for z = 1:nZones
    for r = 1:nRP_IS
        Zone_factor = sks_getZoneFactor_v1(eqZones{z}, rPeriods(r));
        Sa_IS_LIST(:,curveIdx) = Zone_factor .* A_NH;

        switch plotMode
            case 'MultiRP'
                legendLabels_IS{curveIdx} = sprintf('IS Zone-%s, %d yr', eqZones{z}, rPeriods(r));

            case 'MultiZone'
                legendLabels_IS{curveIdx} = sprintf('IS Zone-%s', eqZones{z});

            case 'Combined'
                legendLabels_IS{curveIdx} = sprintf('IS Zone-%s, %d yr', eqZones{z}, rPeriods(r));
        end
        curveIdx = curveIdx + 1;
    end
end

%% --- 9. Plot combined UHS + IS Response Spectrum -----------------------
figure;
hold on;
grid on;
box on;

baseStyles = {'k-', 'b-', 'r-.', 'm:', 'k--', 'b--', 'r--', 'm-.'};
nStyles = numel(baseStyles);
nUHScurves = nLoc * nRP_UHS;   % first block of styles goes to UHS

% --- 9a. Plot UHS curves -----------------------------------------------
hUHS = gobjects(nUHScurves, 1);
k = 1;
for L = 1:nLoc
    for r = 1:nRP_UHS
        style_i = baseStyles{mod(k - 1, nStyles) + 1};
        hUHS(k) = plot(periodsForUHS, UHS_Sa_ALL{L}(:, r), style_i, 'LineWidth', 1.5, ...
            'DisplayName', sprintf('%s, %d yr (PSHA)', locNames{L}, returnPeriods_UHS(r)));
        k = k + 1;
    end
end

% --- 9b. Plot IS Response Spectrum curves ------------------------------
hIS = gobjects(nCurves, 1);
for i = 1:nCurves
    style_i = baseStyles{mod(nUHScurves + i - 1, nStyles) + 1};   % offset past UHS styles
    hIS(i) = plot(T_H, Sa_IS_LIST(:, i), style_i, 'LineWidth', 1.5, 'DisplayName', legendLabels_IS{i});
end

% % --- 9c. Add markers at selected periods -------------------------------
% markerPeriods = periodsForUHS;
% for i = 1:nCurves
%     Sa_marker = interp1(T_H, Sa_IS_LIST(:, i), markerPeriods, 'linear', NaN);
%     curveColor = hIS(i).Color;
%     plot(markerPeriods, Sa_marker, 'o', 'Color', curveColor, 'MarkerSize', 5, 'LineWidth', 1.0, 'HandleVisibility', 'off');
% end
%% --- 10. Formatting ----------------------------------------------------
xlabel('$\mathrm{Period},\,T\;(\mathrm{s})$', 'Interpreter', 'latex');
ylabel('Spectral Acceleration $(\mathrm{g})$', 'Interpreter', 'latex');
title(sprintf('UHS and IS Design Response Spectrum - %s vs %s', locNames{1}, locNames{2}), 'Interpreter', 'latex');
legend([hUHS; hIS], 'Location', 'eastoutside', 'Interpreter', 'latex');
xlim([min(periodsForUHS), max(periodsForUHS)]);
sks_figureFormat('powerpoint');

%% --- 11. Save combined figure ------------------------------------------

if doSave
    exportFolder = fullfile(baseFolder, 'hazardCurves');
    if ~exist(exportFolder, 'dir')
        mkdir(exportFolder);
    end
    oldFolder = pwd;
    cd(exportFolder);
    zonesStr = strjoin(eqZones, '&');
    rpStr = strjoin(string(rPeriods), '-'); % Return-period string for IS curves
    exportName = sprintf('UHS_ISResponse_combined_%svs%s_%sPSHA_Zones_%s_Tr%s', locNames{1}, locNames{2}, pshaVersion, zonesStr, rpStr);
    sks_figureExport(exportName);
    cd(oldFolder);

end

end
