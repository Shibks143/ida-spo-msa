clear; clc;


baseDir = 'E:\OpenSees_PracticeExamples\ida-spo-msa\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';

%% Get EQ folders
eqFolders = dir(fullfile(baseDir,'EQ_*'));
eqFolders = eqFolders([eqFolders.isdir]);

%% storage
columnPHR = struct();
beamPHR   = struct();

for iEQ = 1:length(eqFolders)
    eqName = eqFolders(iEQ).name;
    eqPath = fullfile(baseDir, eqName);
    saFolders = dir(fullfile(eqPath,'Sa_*'));
    saFolders = saFolders([saFolders.isdir]);

    for iSa = 1:length(saFolders)
        saName = saFolders(iSa).name;
        saPath = fullfile(eqPath, saName);
        saField = strrep(saName,'.','p');
        matFile = fullfile(saPath,'DATA_reducedSensDataForThisSingleRun.mat');

        if ~isfile(matFile)
            continue
        end

        S = load(matFile,'columnAbsMaxPHRPerStory','beamAbsMaxPHRPerFloor');
        columnPHR.(eqName).(saField) = S.columnAbsMaxPHRPerStory;
        beamPHR.(eqName).(saField)   = S.beamAbsMaxPHRPerFloor;

    end
end

%% save
save(fullfile(baseDir,'DATA_BeamAndColumn_PHR_allEQ.mat'),'columnPHR','beamPHR','-v7.3');


