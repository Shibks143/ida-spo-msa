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
%% Initialize Containers
absStoryDrift_all    = cell(numEQ,1);
absResidualDrift_all = cell(numEQ,1);
absPFA_all           = cell(numEQ,1);

saLevel_all      = cell(numEQ,1);
numSaLevels_all  = zeros(numEQ,1);

%% Load results for each EQ
for eqIndex = 1:numEQ
    eqCompNumber = eqNumberLIST(eqIndex);

    eqFolder = fullfile(saveDir, sprintf('EQ_%d',eqCompNumber));

    loadFile = fullfile(eqFolder,'DATA_CollapseResultsForThisSingleEQ.mat');

    msaResponse = load(loadFile,'saLevelForEachRun','numSaLevels','absStoryDriftRatioAtEachStoryAtEachRun',...
        'absStoryResidualDriftRatioAtEachStoryAtEachRun','absPeakFloorAccelerationAtEachFloorAtEachRun');

    absStoryDrift_all{eqIndex}    = msaResponse.absStoryDriftRatioAtEachStoryAtEachRun;
    absResidualDrift_all{eqIndex} = msaResponse.absStoryResidualDriftRatioAtEachStoryAtEachRun;
    absPFA_all{eqIndex}           = msaResponse.absPeakFloorAccelerationAtEachFloorAtEachRun;

    saLevel_all{eqIndex}          = msaResponse.saLevelForEachRun;
    numSaLevels_all(eqIndex)      = msaResponse.numSaLevels;

end


%% FIGURE — Interstory Drift Profiles (per Sa level)

numSa   = numSaLevels_all(1);
validSa = saLevel_all{1}(1:numSa);

numStories = size(absStoryDrift_all{1},1);
storyLevel = 1:(numStories+1);

for saLevelIndex = 1:numSa

    figure
    hold on

    driftMatrix = zeros(numStories,numEQ);

    % ---- Individual EQ profiles ----
    for eqIndex = 1:numEQ

        driftMat = absStoryDrift_all{eqIndex};
        driftProfile = 100*driftMat(:,saLevelIndex);   % full values convert to %
        driftMatrix(:,eqIndex) = driftProfile;         % store original
        
        driftPlot = min(driftProfile,8);                % truncate at 8%
        driftStep  = repelem(driftPlot,2);
        heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);

        driftStep  = [driftStep; driftProfile(end)];
        heightStep = [heightStep; storyLevel(end)];

        if eqIndex == 1
            hEQ = plot(driftStep,heightStep,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        else
            plot(driftStep,heightStep,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        end

    end

    % ---- Percentiles ----
    medianDrift = median(driftMatrix,2);
    p16Drift    = prctile(driftMatrix,16,2);
    p84Drift    = prctile(driftMatrix,84,2);

    % ---- Truncate ONLY for plotting ----
    medianPlot = min(medianDrift,8);
    p16Plot    = min(p16Drift,8);
    p84Plot    = min(p84Drift,8);

    % ---- Convert to Step Profiles ----
    heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);
    heightStep = [heightStep; storyLevel(end)];

    medStep = repelem(medianPlot,2);
    medStep = [medStep; medianPlot(end)];

    p16Step = repelem(p16Plot,2);
    p16Step = [p16Step; p16Plot(end)];

    p84Step = repelem(p84Plot,2);
    p84Step = [p84Step; p84Plot(end)];
    
    % % ---- Convert to Step Profiles ----
    % heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);
    % heightStep = [heightStep; storyLevel(end)];
    % 
    % medStep = repelem(medianDrift,2);
    % medStep = [medStep; medianDrift(end)];
    % 
    % p16Step = repelem(p16Drift,2);
    % p16Step = [p16Step; p16Drift(end)];
    % 
    % p84Step = repelem(p84Drift,2);
    % p84Step = [p84Step; p84Drift(end)];


    % ---- Shaded Dispersion Band ----
    xFill = [p16Step; flipud(p84Step)];
    yFill = [heightStep; flipud(heightStep)];

    hBand = fill(xFill,yFill,[0.6 0.8 1],'EdgeColor','none','FaceAlpha',0.35);

    % ---- Median Line ----
    hMedian = plot(medStep,heightStep,'b','LineWidth',3);

    % ---- Formatting ----
    set(gca,'YDir','normal')

    xlabel('Interstory Drift Ratio (\%)')
    ylabel('Story Level')

    yticks(storyLevel)
    ylim([storyLevel(1) storyLevel(end)])

    xMax = 8;
    margin = 0.05 * xMax;   % 5% margin
    xlim([0 xMax + margin])
    xticks(0:1:8)

    % xlim([0 8])
    % xticks(0:1:8)
    xtickformat('%.0f')

    title(sprintf('Sa = %.2f g',validSa(saLevelIndex)))
    grid off

    % ---- Legend ----
    legend([hEQ hMedian hBand],{'IDR profiles','Median','$16$--$84$\% band'})

    % ---- Export ----
    exportName = fullfile(saveDir, sprintf('InterstoryDriftRatio_Sa_%.2f',validSa(saLevelIndex)));

    sks_figureFormat(formatMode);
    sks_figureExport(exportName);

end

%% FIGURE — Residual Drift Profiles (per Sa level)

numSa   = numSaLevels_all(1);
validSa = saLevel_all{1}(1:numSa);

numStories = size(absResidualDrift_all{1},1);
storyLevel = 1:(numStories+1);

for saLevelIndex = 1:numSa

    figure
    hold on

    residualMatrix = zeros(numStories,numEQ);

    % ---- Individual EQ profiles ----
    for eqIndex = 1:numEQ
    
        residualDriftMat = absResidualDrift_all{eqIndex};
        residualProfile  = 100*residualDriftMat(:,saLevelIndex);  % FULL data
    
        residualMatrix(:,eqIndex) = residualProfile;              % store original
    
        % ---- Truncate ONLY for plotting ----
        residualPlot = min(residualProfile,4);
    
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


      % ---- Percentiles (FULL data) ----
    medianResidual = median(residualMatrix,2);
    p16Residual    = prctile(residualMatrix,16,2);
    p84Residual    = prctile(residualMatrix,84,2);
    
    % ---- Truncate ONLY for plotting ----
    medianPlot = min(medianResidual,4);
    p16Plot    = min(p16Residual,4);
    p84Plot    = min(p84Residual,4);
    
    % ---- Convert to Step Profiles ----
    heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);
    heightStep = [heightStep; storyLevel(end)];
    
    medStep = repelem(medianPlot,2);
    medStep = [medStep; medianPlot(end)];
    
    p16Step = repelem(p16Plot,2);
    p16Step = [p16Step; p16Plot(end)];
    
    p84Step = repelem(p84Plot,2);
    p84Step = [p84Step; p84Plot(end)];


    % heightStep = reshape([storyLevel(1:end-1); storyLevel(2:end)],[],1);
    % heightStep = [heightStep; storyLevel(end)];
    % 
    % medStep = repelem(medianResidual,2);
    % medStep = [medStep; medianResidual(end)];
    % 
    % p16Step = repelem(p16Residual,2);
    % p16Step = [p16Step; p16Residual(end)];
    % 
    % p84Step = repelem(p84Residual,2);
    % p84Step = [p84Step; p84Residual(end)];


    % ---- Shaded Dispersion Band ----
    xFill = [p16Step; flipud(p84Step)];
    yFill = [heightStep; flipud(heightStep)];

    hBand = fill(xFill,yFill,[0.6 0.8 1],'EdgeColor','none','FaceAlpha',0.35);

    % ---- Median Line ----
    hMedian = plot(medStep,heightStep,'b','LineWidth',3);

    % ---- Formatting ----
    set(gca,'YDir','normal')

    xlabel('Residual Interstory Drift Ratio (\%)')
    ylabel('Story Level')

    yticks(storyLevel)
    ylim([storyLevel(1) storyLevel(end)])

    xMax = 4;
    margin = 0.05 * xMax;

    xlim([0 xMax + margin])
    xticks(0:1:4)
    xtickformat('%.0f')

    title(sprintf('Sa = %.2f g',validSa(saLevelIndex)))

    grid off


    % ---- Legend ----
    legend([hEQ hMedian hBand],{'RDR profiles','Median','$16$--$84$\% band'})


    % ---- Export ----
    exportName = fullfile(saveDir, sprintf('ResidualInterstoryDriftRatio_Sa_%.2f',validSa(saLevelIndex)));

    sks_figureFormat(formatMode);
    sks_figureExport(exportName);

end


%% FIGURE 3 — Peak Floor Acceleration Profiles

numSa   = numSaLevels_all(1);
validSa = saLevel_all{1}(1:numSa);
numFloors = size(absPFA_all{1},1) - 1;
floors = 1:numFloors;

for saLevelIndex = 1:numSa

    figure
    hold on

    pfaMatrix = zeros(numFloors,numEQ);

    % ---- Individual EQ profiles ----
    for eqIndex = 1:numEQ

        pfaProfile = absPFA_all{eqIndex}(2:end,saLevelIndex) / 9810;
        pfaMatrix(:,eqIndex) = pfaProfile;

        if eqIndex == 1
            hEQ = plot(pfaProfile,floors,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        else
            plot(pfaProfile,floors,'Color',[0.7 0.7 0.7],'LineWidth',1.2);
        end

    end


    % ---- Percentiles ----
    medianPFA = median(pfaMatrix,2);
    p16PFA    = prctile(pfaMatrix,16,2);
    p84PFA    = prctile(pfaMatrix,84,2);


    % ---- Shaded Dispersion Band ----
    xFill = [p16PFA; flipud(p84PFA)];
    yFill = [floors'; flipud(floors')];
    hBand = fill(xFill,yFill,[0.6 0.8 1], 'EdgeColor','none','FaceAlpha',0.35);


    % ---- Median Line ----
    hMedian = plot(medianPFA,floors,'b','LineWidth',3);


    % ---- Formatting ----
    set(gca,'YDir','normal')

    xlim([0 3.5])
    xtickformat('%.1f')
    yticks(floors)

    ymin = floors(1);
    ymax = floors(end);
    yrange = ymax - ymin;
    margin = 0.05 * yrange;
    ylim([ymin - margin, ymax + margin])

    xlabel('Peak Floor Acceleration ($\mathrm{g}$)')
    ylabel('Floor Level')
    title(sprintf('Sa = %.2f g',validSa(saLevelIndex)))

    grid on


    % ---- Legend ----
    legend([hEQ hMedian hBand], {'PFA profiles','Median','$16$--$84$\% band'})


    % ---- Export ----
    exportName = fullfile(saveDir, sprintf('PeakFloorAcceleration_Sa_%.2f',validSa(saLevelIndex)));

    sks_figureFormat(formatMode);
    sks_figureExport(exportName);

end

end
