clc
clear
close all
formatMode = 'powerpoint';

%% Load file
dataPath = 'E:\OpenSees_PracticeExamples\ida-spo-msa\HazardAnalysis\shiva-hazard-files.mat';
S = load(dataPath);

% ---- Read the hazard table ----
% tableAllHazard: col 1 = location name, cols 2:end = Sa(T1) values,
% one per return period, in the SAME order as TrLIST (9 values/row).
tbl = S.tableAllHazard;
TrLIST = S.TrLIST(:);   % 9x1: [75 175 275 475 975 1275 2475 4975 9975]
T1     = S.T1;          % scalar

nLoc = height(tbl);
locName = table2cell(tbl(:,1));
SaMatrix = table2array(tbl(:,2:end));

if size(SaMatrix,2) ~= numel(TrLIST)
    error('Number of Sa columns in tableAllHazard (%d) does not match numel(TrLIST) (%d).', ...
        size(SaMatrix,2), numel(TrLIST))
end

%% Annual frequency of exceedance (AFE) axis
AFE_full = 1 ./ TrLIST;   % AFE for every return period in TrLIST

%% Plot hazard curves for each city
figure
hold on
grid on
box on

for i = 1:nLoc
    Sa_i = SaMatrix(i,:)';       % Sa values for this location, all Tr
    [Sa_i, idx] = sort(Sa_i);    % sort for a monotonic hazard curve
    AFE_i = AFE_full(idx);       % keep AFE aligned to sorted Sa

    loglog(Sa_i, AFE_i, '-o', 'LineWidth', 2, 'DisplayName', locName{i})
end

set(gca, 'XScale', 'log', 'YScale', 'log')
xlabel('IM = Sa(T1) [g]')
ylabel('Annual Frequency of Exceedance, AFE')
title(sprintf('Hazard curves at T = %.2f s', T1))
legend('Location', 'northeast')

if exist('sks_figureFormat', 'file')
    sks_figureFormat(formatMode)
end
exportName = 'HazardCurves_T1';
if exist('sks_figureExport', 'file')
    sks_figureExport(exportName);
end