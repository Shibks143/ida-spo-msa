clc
clear
close all

formatMode = 'powerpoint';


%% Load file
dataPath = 'E:\OpenSees_PracticeExamples\ida-spo-msa\HazardAnalysis\shiva-hazard-files.mat';
S = load(dataPath);

tbl = S.tableAllHazard;
Tr  = S.TrLIST(:);
T1  = S.T1;

%% annual frequency
H = 1./Tr;

figure
hold on
grid on
box on

%% Loop locations (Mumbai, Delhi, Guwahati)
for i = 1:height(tbl)

    % Sa(T1,Tr)
    Sa = table2array(tbl(i,2:end))';

    % sort for monotonic hazard curve
    [Sa,idx] = sort(Sa);
    Hplot = H(idx);

    loglog(Sa,Hplot,'LineWidth',2,...
        'DisplayName',tbl.locName{i})

end

xlabel('im (g)')
ylabel('H(im)')
title(sprintf('Hazard curves at T = %.2f s',T1))

legend('Location','northeast')



sks_figureFormat(formatMode)

exportName = 'HazardCurves_T1';
sks_figureExport(exportName);


