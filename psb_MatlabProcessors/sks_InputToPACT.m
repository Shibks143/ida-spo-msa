%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPORT FEMA P58 / PACT DEMAND SPREADSHEET FROM MSA_EDP_AllEQ.mat
%
% Intensity     = 1,2,3,... (Sa level number)
% DemandType    = Story Drift Ratio / Acceleration / Residual Drift Ratio
% Floor         = 1~5 for IDR/RDR
%                 1~6 for PFA (Ground=1, Roof=6)
% Dir           = 1 or 2
%
% Example:
% 120111 -> EQ ID = 12011 , Dir = 1
% 120112 -> EQ ID = 12011 , Dir = 2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

%% =======================================================================
% USER INPUTS
%% =======================================================================

analysisType = '(ID46053_R5_5Story_v.02)_(AllVar)_(0.00)_(clough)';

baseFolder = 'E:\OpenSees_PracticeExamples\ida-spo-msa\Output';

saveDir = fullfile(baseFolder,analysisType);

matFile = fullfile( ...
    saveDir,...
    ['MSA_EDP_AllEQ_' analysisType '.mat']);

%% =======================================================================
% LOAD DATA
%% =======================================================================

fprintf('\nLoading MAT file:\n%s\n\n',matFile);

S = load(matFile);

IDR_allEQ    = S.IDR_allEQ;
RDR_allEQ    = S.RDR_allEQ;
PFA_allEQ    = S.PFA_allEQ;


% Check how many collapse flags exist originally
fprintf('Number of 99900 values before replacement = %d\n', ...
    nnz(RDR_allEQ == 99900));

% Replace collapse flag values (99900) with zero
RDR_allEQ(RDR_allEQ == 99900) = 0;

% Verify replacement
fprintf('Number of 99900 values after replacement = %d\n', ...
    nnz(RDR_allEQ == 99900));


saLevels     = S.saLevels;
eqNumberLIST = S.eqNumberLIST;

%% =======================================================================
% BASIC INFORMATION
%% =======================================================================

numStories = size(IDR_allEQ,1);
numFloors  = size(PFA_allEQ,1);
numSa      = length(saLevels);
numEQ      = length(eqNumberLIST);

fprintf('Stories          = %d\n',numStories);
fprintf('PFA Floors       = %d\n',numFloors);
fprintf('Intensity Levels = %d\n',numSa);
fprintf('EQ Records       = %d\n\n',numEQ);

%% =======================================================================
% EXTRACT EQ IDs AND DIRECTIONS
%% =======================================================================

eqID  = floor(eqNumberLIST/10);
eqDir = mod(eqNumberLIST,10);

uniqueEQ = unique(eqID,'stable');
numRecords = length(uniqueEQ);

fprintf('Unique Ground Motions = %d\n\n',numRecords);

%% =======================================================================
% OUTPUT FILE
%% =======================================================================

outputExcel = fullfile( ...
    saveDir,...
    sprintf('PACT_Demands_%s.xlsx',analysisType));

%% =======================================================================
% CREATE HEADER
%% =======================================================================

header = {'Intensity','DemandType','Floor','Dir'};

for gm = 1:numRecords
    header{end+1} = sprintf('EQ%d',gm);
end

%% =======================================================================
% PREALLOCATE CELL
%% =======================================================================

outCell = {};
row = 1;

%% =======================================================================
% LOOP OVER INTENSITY LEVELS
%% =======================================================================

for saIndex = 1:numSa

    intensityID = saIndex;

    fprintf('Processing Intensity %d of %d\n', ...
        intensityID,numSa);

    %% ==============================================================
    % STORY DRIFT RATIO
    %% ==============================================================

    for story = 1:numStories

        for dir = 1:2

            rowData = cell(1,4+numRecords);

            rowData{1} = intensityID;
            rowData{2} = 'Story Drift Ratio';
            rowData{3} = story;
            rowData{4} = dir;

            for gm = 1:numRecords

                idx = find( ...
                    eqID == uniqueEQ(gm) & ...
                    eqDir == dir);

                if isempty(idx)

                    rowData{4+gm} = NaN;

                else

                    % convert % back to ratio
                    rowData{4+gm} = ...
                        IDR_allEQ(story,saIndex,idx)/100;

                end

            end

            outCell(row,:) = rowData;
            row = row + 1;

        end
    end

    %% ==============================================================
    % PEAK FLOOR ACCELERATION
    %
    % Ground floor = 1
    % Roof floor   = 6 (for 5-story building)
    %% ==============================================================

    for floorNum = 1:numFloors

        for dir = 1:2

            rowData = cell(1,4+numRecords);

            rowData{1} = intensityID;
            rowData{2} = 'Acceleration';
            rowData{3} = floorNum;
            rowData{4} = dir;

            for gm = 1:numRecords

                idx = find( ...
                    eqID == uniqueEQ(gm) & ...
                    eqDir == dir);

                if isempty(idx)

                    rowData{4+gm} = NaN;

                else

                    rowData{4+gm} = ...
                        PFA_allEQ(floorNum,saIndex,idx);

                end

            end

            outCell(row,:) = rowData;
            row = row + 1;

        end
    end

    %% ==============================================================
    % RESIDUAL DRIFT RATIO
    %% ==============================================================
    %% ==============================================================
    % MAXIMUM RESIDUAL STORY DRIFT RATIO
    %
    % For each EQ:
    % max over stories
    % then max over directions
    %
    % One value per EQ
    %% ==============================================================

    rowData = cell(1,4+numRecords);

    rowData{1} = intensityID;
    rowData{2} = 'Residual Drift';
    rowData{3} = 0;
    rowData{4} = 0;

    for gm = 1:numRecords

        maxRDR = NaN;

        for dir = 1:2

            idx = find( ...
                eqID == uniqueEQ(gm) & ...
                eqDir == dir);

            if ~isempty(idx)

                % maximum over all stories
                tempMax = max(RDR_allEQ(:,saIndex,idx));

                % keep maximum over both directions
                if isnan(maxRDR)
                    maxRDR = tempMax;
                else
                    maxRDR = max(maxRDR,tempMax);
                end

            end

        end

        % convert % to ratio
        rowData{4+gm} = maxRDR/100;

    end

    outCell(row,:) = rowData;
    row = row + 1;
   

end

%% =======================================================================
% CONVERT TO TABLE
%% =======================================================================

T = cell2table( ...
    outCell,...
    'VariableNames',header);

%% =======================================================================
% WRITE EXCEL
%% =======================================================================

fprintf('\nWriting Excel file...\n');

writetable(T,outputExcel);

fprintf('\nCompleted Successfully\n');
fprintf('\nExcel File:\n%s\n',outputExcel);

%% =======================================================================
% SUMMARY
%% =======================================================================

fprintf('\nRows Written = %d\n',height(T));
fprintf('Columns      = %d\n',width(T));

disp(' ')
disp('DONE')