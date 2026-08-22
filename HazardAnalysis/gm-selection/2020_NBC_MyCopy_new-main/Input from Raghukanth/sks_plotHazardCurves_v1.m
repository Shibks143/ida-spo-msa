function fig = sks_plotHazardCurves_v1(imValDisc_LIST, afeDisc_LIST, T1LIST, hazardInputs)

%% Plot hazard curves
fig = figure;
hold on;
nT = numel(T1LIST);
hLine = gobjects(nT,1);

for j = 1:nT
    hLine(j) = plot(imValDisc_LIST{j}, afeDisc_LIST{j}, hazardInputs.plotStyle{j}, 'LineWidth', hazardInputs.lineW(j));
    % Store T value for data cursor
    hLine(j).UserData = T1LIST(j);
    hLine(j).DisplayName = sprintf('T = %.2f s', T1LIST(j));
end

xlabel('$\mathrm{im}\,(\mathrm{g})$');
ylabel('$\mathrm{H}(\mathrm{im})$');
xlim([1e-2 5]);
ylim([1e-5 1e+0]);

switch hazardInputs.plotType
    case 'semilog'
        ax = gca;
        ax.XScale = 'linear';
        ax.YScale = 'log';
    case 'loglog'
        ax = gca;
        ax.XScale = 'log';
        ax.YScale = 'log';
    case 'linear'
        ax = gca;
        ax.XScale = 'linear';
        ax.YScale = 'linear';
end
legend(hLine);

% Custom data cursor
dcm = datacursormode(fig);
dcm.Enable = 'on';
dcm.UpdateFcn = @hazardCurveCursorText;
sks_figureFormat('powerpoint');

set(gca,'YTick',10.^(-4:0));

%% Save figure
if hazardInputs.doSave
    exportFolder = fullfile(hazardInputs.baseFolder, 'hazardCurves');

    if ~exist(exportFolder, 'dir')
        mkdir(exportFolder);
    end
    oldFolder = pwd;
    cd(exportFolder);
    exportName = sprintf('HazardCurvesSaT1_%s_%sPSHA', hazardInputs.locName, hazardInputs.pshaVersion);

    sks_figureExport(exportName);
    cd(oldFolder);
end

end

%% ========================================================================
% Custom data cursor callback
% ========================================================================

function txt = hazardCurveCursorText(~, event)
hLine = event.Target;
T1val = hLine.UserData;
pos = event.Position;
if isempty(T1val)
    txt = {sprintf('im = %.4g g', pos(1)), sprintf('H(im) = %.4g', pos(2))};
else
    txt = {sprintf('T = %.2f s', T1val), sprintf('im = %.4g g', pos(1)), sprintf('H(im) = %.4g', pos(2))};
end
end