clear; clc;



baseDir = 'E:\OpenSees_PracticeExamples\ida-spo-msa\Output\(ID2433_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';

%% Get EQ folders
eqFolders = dir(fullfile(baseDir,'EQ_*'));
eqFolders = eqFolders([eqFolders.isdir]);

%% storage
columnPHR = struct();
beamPHR   = struct();
periodUsedForScalingGroundMotions = struct();
for iEQ = 1:length(eqFolders)
    eqNumber = eqFolders(iEQ).name;
    eqPath = fullfile(baseDir, eqNumber);
    saFolders = dir(fullfile(eqPath,'Sa_*'));
    saFolders = saFolders([saFolders.isdir]);

    for iSa = 1:length(saFolders)
        saVal = saFolders(iSa).name;
        saPath = fullfile(eqPath, saVal);
        saField = strrep(saVal,'.','p');
        matFile = fullfile(saPath,'DATA_reducedSensDataForThisSingleRun.mat');

        if ~isfile(matFile)
            continue
        end

        PHRData = load(matFile,'columnAbsMaxPHRPerStory','beamAbsMaxPHRPerFloor', 'periodUsedForScalingGroundMotionsFromMatlab');
        columnPHR.(eqNumber).(saField) = PHRData.columnAbsMaxPHRPerStory;
        beamPHR.(eqNumber).(saField)   = PHRData.beamAbsMaxPHRPerFloor;
        periodUsedForScalingGroundMotions.(eqNumber).(saField) = PHRData.periodUsedForScalingGroundMotionsFromMatlab;

    end
end

%% save
save(fullfile(baseDir,'DATA_BeamAndColumn_PHR_allEQ.mat'),'columnPHR','beamPHR', 'periodUsedForScalingGroundMotions','-v7.3');


