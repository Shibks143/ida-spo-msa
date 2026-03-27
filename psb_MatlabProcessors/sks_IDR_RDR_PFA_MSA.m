%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IDR, RDR, PFA plotting
% Modernized by Shivakumar K S, IIT Madras (2026)
% Uses modern graphics (HG2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function sks_IDR_RDR_PFA_MSA(eqNumberLIST, analysisType)


% Base directory setup
baseDir = pwd;                 % MatlabProcessors folder

cd(baseDir)
cd ..\
cd Output
cd(analysisType)
saveDir = pwd;                 % folder where plots will be saved

numEQ = length(eqNumberLIST);

%% Plot settings 
formatMode = 'powerpoint';   % 'default','paper','report','powerPoint'
% colors = lines(numEQ);       % color map for EQ curves
%% Initialize containers
floorAccel_all                    = cell(numEQ,1);
storyDriftRatio_all               = cell(numEQ,1);
storyDriftRatio_ResidualAbs_all   = cell(numEQ,1);
roofDriftRatio_all                = cell(numEQ,1);
roofDriftRatio_ResidualAbs_all    = cell(numEQ,1);
maxDriftRatioForFullStr_all       = cell(numEQ,1);
buildingHeight_all                = zeros(numEQ,1);
numStories_all                    = zeros(numEQ,1);
saLevel_all                       = cell(numEQ,1);
numSaLevels_all                   = zeros(numEQ,1);

%% Load reduced SA-level results for each EQ
for eqIndex = 1:numEQ
    eqCompNumber = eqNumberLIST(eqIndex);
    eqFolder = fullfile(saveDir, sprintf('EQ_%d', eqCompNumber));

    % --- Get list of Sa folders for this EQ ---
    saFolders = dir(fullfile(eqFolder,'Sa_*'));
    saFolders = saFolders([saFolders.isdir]);  % only directories
    numSaLevels = length(saFolders);
    numSaLevels_all(eqIndex) = numSaLevels;

    % Sort folders by Sa value 
    [~, idx] = sort( str2double(erase({saFolders.name},'Sa_')) );
    saFolders = saFolders(idx);

    saLevel_thisEQ = zeros(numSaLevels,1);
    floorAccel_thisEQ  = cell(numSaLevels,1);
    storyDriftRatio_thisEQ = cell(numSaLevels,1);
    roofDriftRatio_thisEQ  = zeros(numSaLevels,1);
    roofDriftRatio_ResidualAbs_thisEQ = zeros(numSaLevels,1);
    maxDriftRatioForFullStr_thisEQ = zeros(numSaLevels,1);
    storyDriftRatio_ResidualAbs_thisEQ = cell(numSaLevels,1);
    
    for saIndex = 1:numSaLevels
        saFolderName = saFolders(saIndex).name;
        saValue = str2double(erase(saFolderName,'Sa_'));
        saLevel_thisEQ(saIndex) = saValue;

        reducedSenData = fullfile(eqFolder, saFolderName, 'DATA_reducedSensDataForThisSingleRun.mat');

        if exist(reducedSenData,'file')
            edpData = load(reducedSenData, 'floorAccelToSave', 'storyDriftRatioToSave', 'roofDriftRatioToSave', 'maxDriftRatioForFullStr', 'buildingHeight', 'numStories');

            
            floorAccel_thisEQ{saIndex} = edpData.floorAccelToSave;
            storyDriftRatio_thisEQ{saIndex} = cellfun(@(x) x.AbsMax, edpData.storyDriftRatioToSave);
            storyDriftRatio_ResidualAbs_thisEQ{saIndex} = cellfun(@(x) x.ResidualAbs, edpData.storyDriftRatioToSave);
            roofDriftRatio_thisEQ(saIndex) = edpData.roofDriftRatioToSave.AbsMax;
            roofDriftRatio_ResidualAbs_thisEQ(saIndex) = edpData.roofDriftRatioToSave.ResidualAbs;
            maxDriftRatioForFullStr_thisEQ(saIndex) = edpData.maxDriftRatioForFullStr;

            % Store building parameters (same for all SA levels)
            if saIndex == 1
                buildingHeight_all(eqIndex) = edpData.buildingHeight;
                numStories_all(eqIndex)     = edpData.numStories;
            end
        else
            warning('File not found: %s', reducedSenData);
        end
    end

    saLevel_all{eqIndex} = saLevel_thisEQ;
    floorAccel_all{eqIndex} = floorAccel_thisEQ;
    storyDriftRatio_all{eqIndex} = storyDriftRatio_thisEQ;
    roofDriftRatio_all{eqIndex} = roofDriftRatio_thisEQ;
    roofDriftRatio_ResidualAbs_all{eqIndex} = roofDriftRatio_ResidualAbs_thisEQ;
    maxDriftRatioForFullStr_all{eqIndex} = maxDriftRatioForFullStr_thisEQ;
    storyDriftRatio_ResidualAbs_all{eqIndex} = storyDriftRatio_ResidualAbs_thisEQ;
end
%% ============================================================
% STORE ALL EQ DATA (NO REDUCTION) → 3D MATRICES
% ============================================================

numSa      = numSaLevels_all(1);
numStories = numStories_all(1);

% --- Get number of floors ---
tempCell = floorAccel_all{1}{1};
validCells = tempCell(~cellfun('isempty',tempCell));
numFloors = length(validCells);

% --- Initialize 3D matrices ---
IDR_allEQ             = zeros(numStories, numSa, numEQ);
RDR_allEQ             = zeros(numStories, numSa, numEQ);
RoofRDR_allEQ         = zeros(numEQ, numSa);
PFA_allEQ             = zeros(numFloors, numSa, numEQ);
Drift_FullStr_allEQ   = zeros(numEQ, numSa);

for eqIndex = 1:numEQ
    for saLevelIndex = 1:numSa

        % ---- IDR ----
        IDR_allEQ(:,saLevelIndex,eqIndex) = 100 * storyDriftRatio_all{eqIndex}{saLevelIndex};

        % ---- RDR ----
        RDR_allEQ(:,saLevelIndex,eqIndex) = 100 * storyDriftRatio_ResidualAbs_all{eqIndex}{saLevelIndex};
        RoofRDR_allEQ(eqIndex, saLevelIndex) = 100 * roofDriftRatio_ResidualAbs_all{eqIndex}(saLevelIndex);

        % ---- Full Structure Drift ----
        Drift_FullStr_allEQ(eqIndex, saLevelIndex) = 100 * maxDriftRatioForFullStr_all{eqIndex}(saLevelIndex);

        % ---- PFA ----
        accelCell = floorAccel_all{eqIndex}{saLevelIndex};
        validCells = accelCell(~cellfun('isempty',accelCell));

        pfaProfile = cellfun(@(x) x.absAbsMaxUnfiltered, validCells);
        pfaProfile = pfaProfile / 9810;

        if length(pfaProfile) ~= numFloors
            error('PFA size mismatch at EQ %d, Sa %d', eqIndex, saLevelIndex);
        end

        PFA_allEQ(:,saLevelIndex,eqIndex) = pfaProfile(:);

    end
end

% --- Sa Levels ---
saLevels = saLevel_all{1}(1:numSa);

% ============================================================
% SAVE .MAT FILE (OUTSIDE EQ FOLDERS)
% ============================================================
MSA_EdpData = struct();

for eqIndex = 1:numEQ

    eqID = eqNumberLIST(eqIndex);
    fieldName = sprintf('EQ_%d', eqID);

    MSA_EdpData.(fieldName).IDR       = IDR_allEQ(:,:,eqIndex);
    MSA_EdpData.(fieldName).RDR       = RDR_allEQ(:,:,eqIndex);
    MSA_EdpData.(fieldName).PFA       = PFA_allEQ(:,:,eqIndex);
    MSA_EdpData.(fieldName).RoofRDR   = RoofRDR_allEQ(eqIndex,:);
    MSA_EdpData.(fieldName).DriftFull = Drift_FullStr_allEQ(eqIndex,:);
end

outputFile = fullfile(saveDir, sprintf('MSA_EDP_AllEQ_%s.mat', analysisType));

save(outputFile, 'MSA_EdpData', 'IDR_allEQ', 'RDR_allEQ', 'RoofRDR_allEQ', ...
    'PFA_allEQ', 'Drift_FullStr_allEQ', 'saLevels', 'eqNumberLIST');

% save(outputFile, 'IDR_allEQ', 'RDR_allEQ','RoofRDR_allEQ','PFA_allEQ','Drift_FullStr_allEQ', 'SaLevels', 'eqNumberLIST');

fprintf('Saved ALL EQ MSA data to:\n%s\n', outputFile);


%% FIGURE — Interstory Drift Profiles (per Sa level)

numSa   = numSaLevels_all(1);
validSa = saLevel_all{1}(1:numSa);

numStories = numStories_all(1);
storyLevel = 1:(numStories+1);

for saLevelIndex = 1:numSa

    figure
    hold on

    interStoryDriftMatrix = zeros(numStories,numEQ);

    % ---- Individual EQ profiles ----
    for eqIndex = 1:numEQ
        driftProfile = 100 * storyDriftRatio_all{eqIndex}{saLevelIndex};
        driftProfile = driftProfile(:);   
        interStoryDriftMatrix(:,eqIndex) = driftProfile;

        % Step plot
        driftPlot  = min(driftProfile, 8);
        driftPlot  = driftPlot(:);      
        driftStep  = repelem(driftPlot,2);
        heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);
        driftStep  = [driftStep; driftPlot(end)];
        heightStep = [heightStep; storyLevel(end)];
        
        if eqIndex == 1
            hEQ = plot(driftStep,heightStep,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        else
            plot(driftStep,heightStep,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        end

    end

    % ---- Percentiles across EQs ----
    medianDrift = median(interStoryDriftMatrix,2);
    p16Drift    = prctile(interStoryDriftMatrix,16,2);
    p84Drift    = prctile(interStoryDriftMatrix,84,2);

    % ---- Truncate ONLY for plotting ----
    medianPlot = min(medianDrift,8);
    p16Plot    = min(p16Drift,8);
    p84Plot    = min(p84Drift,8);

    % ---- Step profiles for median and percentiles ----
    heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);
    heightStep = [heightStep; storyLevel(end)];

    medStep  = repelem(medianPlot,2);  medStep  = [medStep; medianPlot(end)];
    p16Step  = repelem(p16Plot,2);     p16Step  = [p16Step; p16Plot(end)];
    p84Step  = repelem(p84Plot,2);     p84Step  = [p84Step; p84Plot(end)];

    % ---- Shaded band ----
    xFill = [p16Step; flipud(p84Step)];
    yFill = [heightStep; flipud(heightStep)];
    hBand = fill(xFill,yFill,[0.6 0.8 1],'EdgeColor','none','FaceAlpha',0.35);

    % ---- Median line ----
    hMedian = plot(medStep,heightStep,'b','LineWidth',3);

    % ---- Formatting ----
    set(gca,'YDir','normal')
    xlabel('Interstory Drift Ratio (\%)')
    ylabel('Story Level')
    yticks(storyLevel)
    ylim([storyLevel(1) storyLevel(end)])
    xMax = 6;
    margin = 0.05 * xMax;   % 5% margin
    xlim([0 xMax + margin])
    xticks(0:1:6)
    xtickformat('%.0f')
    title(sprintf('$S_a(T_1) = %.2f\\,g$', validSa(saLevelIndex)), 'Interpreter','latex')
    grid off

    % ---- Legend ----
    legend([hEQ hMedian hBand], {'IDR profiles','Median','$16$--$84$\% band'})

    % ---- Export ----
    exportName = fullfile(saveDir, sprintf('InterstoryDriftRatio_Sa(T1)_%.2f', validSa(saLevelIndex)));
    sks_figureFormat(formatMode);
    sks_figureExport(exportName);

end


%% FIGURE — Residual Drift Profiles (per Sa level)

numSa   = numSaLevels_all(1);
validSa = saLevel_all{1}(1:numSa);

numStories = numStories_all(1);
storyLevel = 1:(numStories+1);

for saLevelIndex = 1:numSa

    figure
    hold on

    interStoryResidualDriftMatrix = zeros(numStories,numEQ);

    % ---- Individual EQ profiles ----
    for eqIndex = 1:numEQ

        residualProfile = 100 * storyDriftRatio_ResidualAbs_all{eqIndex}{saLevelIndex};
        residualProfile = residualProfile(:);   

        interStoryResidualDriftMatrix(:,eqIndex) = residualProfile;

        % ---- Step plot ----
        residualPlot = min(residualProfile,4);
        residualPlot = residualPlot(:);

        driftStep  = repelem(residualPlot,2);
        heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);

        driftStep  = [driftStep; residualPlot(end)];
        heightStep = [heightStep; storyLevel(end)];

        if eqIndex == 1
            hEQ = plot(driftStep,heightStep,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        else
            plot(driftStep,heightStep,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        end

    end

    % ---- Percentiles ----
    medianResidual = median(interStoryResidualDriftMatrix,2);
    p16Residual    = prctile(interStoryResidualDriftMatrix,16,2);
    p84Residual    = prctile(interStoryResidualDriftMatrix,84,2);

    % ---- Truncate ----
    medianPlot = min(medianResidual,4);
    p16Plot    = min(p16Residual,4);
    p84Plot    = min(p84Residual,4);

    % ---- Step ----
    heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);
    heightStep = [heightStep; storyLevel(end)];

    medStep = repelem(medianPlot,2);  medStep = [medStep; medianPlot(end)];
    p16Step = repelem(p16Plot,2);     p16Step = [p16Step; p16Plot(end)];
    p84Step = repelem(p84Plot,2);     p84Step = [p84Step; p84Plot(end)];

    % ---- Band ----
    xFill = [p16Step; flipud(p84Step)];
    yFill = [heightStep; flipud(heightStep)];
    hBand = fill(xFill,yFill,[0.6 0.8 1],'EdgeColor','none','FaceAlpha',0.35);

    % ---- Median ----
    hMedian = plot(medStep,heightStep,'b','LineWidth',3);

    % ---- Formatting ----
    set(gca,'YDir','normal')
    xlabel('Residual Interstory Drift Ratio (\%)')
    ylabel('Story Level')
    yticks(storyLevel)
    ylim([storyLevel(1) storyLevel(end)])
    xlim([0 2.5])
    xticks(0:0.5:2.5)
    title(sprintf('$S_a(T_1) = %.2f\\,g$',validSa(saLevelIndex)))
    grid off

    legend([hEQ hMedian hBand],{'RDR profiles','Median','$16$--$84$\% band'})

    exportName = fullfile(saveDir, sprintf('ResidualInterstoryDriftRatio_Sa(T1)_%.2f',validSa(saLevelIndex)));
    sks_figureFormat(formatMode);
    sks_figureExport(exportName);

end

%% FIGURE 3 — Peak Floor Acceleration Profiles

% Get floor count from first EQ & first Sa
tempCell = floorAccel_all{1}{1};
validCells = tempCell(~cellfun('isempty',tempCell));

numFloors = length(validCells);
floors = (1:numFloors)';

for saLevelIndex = 1:numSa

    figure
    hold on

    peakFloorAccelMatrix = zeros(numFloors,numEQ);

    % ---- Individual EQ profiles ----
    for eqIndex = 1:numEQ

        accelCell = floorAccel_all{eqIndex}{saLevelIndex};
        validCells = accelCell(~cellfun('isempty',accelCell));
     
        pfaProfile = cellfun(@(x) x.absAbsMaxUnfiltered, validCells);
        pfaProfile = pfaProfile / 9810;
        pfaProfile = pfaProfile(:);

        if length(pfaProfile) ~= numFloors
            error('PFA size mismatch at EQ %d, Sa %d', eqIndex, saLevelIndex);
        end

        peakFloorAccelMatrix(:,eqIndex) = pfaProfile;

        if eqIndex == 1
            hEQ = plot(pfaProfile,floors,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        else
            plot(pfaProfile,floors,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        end

    end
    
    % ---- Percentiles ----
    medianPFA = median(peakFloorAccelMatrix,2);
    p16PFA    = prctile(peakFloorAccelMatrix,16,2);
    p84PFA    = prctile(peakFloorAccelMatrix,84,2);

    % ---- Band ----
    xFill = [p16PFA; flipud(p84PFA)];
    yFill = [floors; flipud(floors)];
    hBand = fill(xFill,yFill,[0.6 0.8 1],'EdgeColor','none','FaceAlpha',0.35);

    % ---- Median ----
    hMedian = plot(medianPFA,floors,'b','LineWidth',3);

    % ---- Formatting ----
    set(gca,'YDir','normal')
    xlabel('Peak Floor Acceleration (g)')
    ylabel('Floor Level')
    xlim([0 3.5])
    yticks(floors)
    yticks(floors)
    ymin = floors(1);
    ymax = floors(end);
    yrange = max(ymax - ymin, 1);
    margin = 0.05 * yrange;
    ylim([ymin - margin, ymax + margin])
    title(sprintf('$S_a(T_1) = %.2f\\,g$',validSa(saLevelIndex)))
    grid on

    legend([hEQ hMedian hBand], {'PFA profiles','Median','$16$--$84$\% band'})

    exportName = fullfile(saveDir, sprintf('PeakFloorAcceleration_Sa(T1)_%0.2f_g', validSa(saLevelIndex)));
    sks_figureFormat(formatMode);
    sks_figureExport(exportName);

end

end
