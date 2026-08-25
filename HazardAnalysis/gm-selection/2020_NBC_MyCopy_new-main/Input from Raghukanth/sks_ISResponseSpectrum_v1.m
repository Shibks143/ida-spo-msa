function [T_H, A_NH] = sks_ISResponseSpectrum_v1(hazardInputs)
%% =========================================================================
%  IS DESIGN RESPONSE SPECTRUM
%  Normalized Design Horizontal Elastic PSA, A_NH,5%(T_H)
%  Site Classes A and B
%  =========================================================================
%
%  The normalized response spectrum A_NH,5%(T_H) is defined according to
%  Fig. 2(b) (Response Spectrum Method) for Site Classes A and B.
%
%  The normalized spectrum is scaled by the Zone Factor Z(Zone, Tr)
%  to obtain the design horizontal elastic response spectrum:
%
%      Sa_design(T_H, Tr) = Z(Zone, Tr) * A_NH(T_H)
%
%  Normalized spectrum for Site Classes A and B:
%
%      1.0                         , 0        < T_H <= 0.01 s
%      1.0 + (50/3)*(T_H - 0.01)   , 0.01 s   < T_H <= 0.1 s
%      2.5                         , 0.1 s    < T_H <= 0.4 s
%      1/T_H                       , 0.4 s    < T_H <= 6.0 s
%      6/T_H^2                     , 6.0 s    < T_H <= 10.0 s
%
%  The function supports three analysis modes:
%
%      MultiRP   : Single earthquake zone, multiple return periods
%      MultiZone : Multiple earthquake zones, single return period
%      Combined  : Multiple earthquake zones, multiple return periods

%  OUTPUT
%      T_H
%          Natural period vector (s), returned as a column vector.
%
%      A_NH
%          Normalized design horizontal elastic PSA, A_NH,5%(T_H),
%          for Site Classes A and B.
%
%  NOTE
%      The function generates one design response spectrum curve for
%      every Zone–Return Period combination specified by the inputs.
%
% =========================================================================

% --- 1. Unpack Struct Fields & Standardize Inputs ---
if isfield(hazardInputs, 'earthquakeZones')
    eqZones = hazardInputs.earthquakeZones;
elseif isfield(hazardInputs, 'earthquakeZone')
    eqZones = hazardInputs.earthquakeZone;
else
    error('sks_ISResponseSpectrum_v1:missingField', 'Specify earthquakeZone or earthquakeZones');
end

% Ensure eqZones is a cell array of strings
if ischar(eqZones) || isstring(eqZones)
    eqZones = cellstr(eqZones);
end

if isfield(hazardInputs, 'returnPeriods')
    rPeriods = hazardInputs.returnPeriods;
elseif isfield(hazardInputs, 'returnPeriod')
    rPeriods = hazardInputs.returnPeriod;
else
    error('sks_ISResponseSpectrum_v1:missingField', 'Specify returnPeriod or returnPeriods.');
end

baseFolder = hazardInputs.baseFolder;
THmax =      hazardInputs.THmax;
dT_H =       hazardInputs.dT_H;

% --- 2. Period Vector & Piecewise Spectrum ---
T_H  = (0:dT_H:THmax)';
A_NH = nan(size(T_H));

A_NH(T_H <= 0.01) = 1.0;

idx = T_H > 0.01 & T_H <= 0.1;
A_NH(idx) = 1.0 + (50/3) * (T_H(idx) - 0.01);

idx = T_H > 0.1 & T_H <= 0.4;
A_NH(idx) = 2.5;

idx = T_H > 0.4 & T_H <= 6.0;
A_NH(idx) = 1 ./ T_H(idx);

idx = T_H > 6.0 & T_H <= 10.0;
A_NH(idx) = 6 ./ (T_H(idx) .^ 2);

% --- 3. Compute Spectra & Determine Plotting Mode ---
nZones = numel(eqZones);
nRP    = numel(rPeriods);

if nZones == 1
    plotMode = 'MultiRP';     % Single Zone, Multiple Return Periods
elseif nRP == 1
    plotMode = 'MultiZone';   % Multiple Zones, Single Return Period
else
    plotMode = 'Combined';    % Multiple Zones & Multiple Return Periods
end

nCurves = nZones * nRP;
Sa_design_LIST = nan(numel(T_H), nCurves);
legendLabels   = cell(nCurves, 1);

curveIdx = 1;
for z = 1:nZones
    for r = 1:nRP
        Zone_factor = sks_getZoneFactor_v1(eqZones{z}, rPeriods(r));
        Sa_design_LIST(:, curveIdx) = Zone_factor * A_NH;
        
        switch plotMode
            case 'MultiRP'
                legendLabels{curveIdx} = sprintf('$\\mathrm{T_r} = %d~\\mathrm{years}$', rPeriods(r));
            case 'MultiZone'
                legendLabels{curveIdx} = sprintf('$\\mathrm{Zone~%s}$', eqZones{z});
            case 'Combined'
                legendLabels{curveIdx} = sprintf('$\\mathrm{Zone~%s,~T_r} = %d~\\mathrm{yr}$', eqZones{z}, rPeriods(r));
        end
        curveIdx = curveIdx + 1;
    end
end

%% --- 4. Plotting ------------------------------------------------------%%
figure
hold on; grid on; box on;
baseStyles = {'k-', 'b-', 'r-', 'm-', 'g-', 'c-'};
nStyles = numel(baseStyles);

hRS = gobjects(nCurves, 1);
for i = 1:nCurves
    style_i = baseStyles{mod(i - 1, nStyles) + 1};
    hRS(i) = plot(T_H, Sa_design_LIST(:, i), style_i, 'LineWidth', 2, 'DisplayName', legendLabels{i});
end
xlabel('Natural Period (s)', 'Interpreter', 'latex');
ylabel('Spectral Acceleration (g)', 'Interpreter', 'latex');

switch plotMode
    case 'MultiRP'
        title(sprintf('IS Design Response Spectrum (Zone %s)', eqZones{1}), 'Interpreter', 'latex');
    case 'MultiZone'
        title(sprintf('IS Design Response Spectrum ($T_r = %d~\\mathrm{years}$)', rPeriods(1)), 'Interpreter', 'latex');
    case 'Combined'
        title('IS Design Response Spectrum Comparison', 'Interpreter', 'latex');
end

legend(hRS, 'Interpreter', 'latex');
xlim([0, THmax]);
sks_figureFormat('powerpoint');

% --- 5. Export Figure ---
if isfield(hazardInputs, 'doSave') && hazardInputs.doSave == 1
    exportFolder = fullfile(baseFolder, 'hazardCurves');
    if ~isfolder(exportFolder)
        mkdir(exportFolder);
    end
    cd(exportFolder);
    zonesStr = strjoin(eqZones, '&');

    if strcmp(plotMode, 'MultiRP')
        exportName = sprintf('ISDesignResponseSpectrum_Zone%s_%s', zonesStr);

    elseif strcmp(plotMode, 'MultiZone')
        exportName = sprintf('ISDesignResponseSpectrum_Zones_%s_Tr%d_%s', zonesStr, rPeriods(1));

    elseif strcmp(plotMode, 'Combined')
        rpStr = strjoin(string(rPeriods), '-');
        exportName = sprintf( 'ISDesignResponseSpectrum_Zones_%s_Tr%s_%s', zonesStr, rpStr);
    end
    sks_figureExport(exportName);
    cd(baseFolder);
end

end
