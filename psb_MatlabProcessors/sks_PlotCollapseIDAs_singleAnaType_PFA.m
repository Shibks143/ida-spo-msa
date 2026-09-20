function[void] = sks_PlotCollapseIDAs_singleAnaType_PFA(idaInputs)
% ADDED 15-Sep-2026: Fragility Functions block (compute + save only, for
% Control + All Comp) at the end of this function, mirroring the block in
% sks_PlotCollapseIDAsPDF_singleAnaType.m (MIDR version). Saves
% DATA_FragilityParams_SaGeoMean_<name>_PFA.mat (or _SaATC63_..._PFA.mat)
% so that PlotCollapseEmpiricalCDFWithFits_allPFA_proc.m has something to load.

eqSpectraFolder =                 idaInputs.eqSpectraFolder;
analysisType =                    idaInputs.analysisType;
eqListForCollapseIDAs_Name =      idaInputs.eqListForCollapseIDAs_Name;
markerTypeLine =                  idaInputs.markerTypeLine;
markerTypeDot =                   idaInputs.markerTypeDot;
isPlotIndividualPoints =          idaInputs.isPlotIndividualPoints;
collapseDriftThreshold =          idaInputs.collapseDriftThreshold;   % collapse still defined by MIDR
isConvertToSaKircher =            idaInputs.isConvertToSaKircher;
eqNumberLIST =                    idaInputs.eqNumberLIST_forCollapseIDAs;
formatMode =                      idaInputs.formatMode;
dampRat =                         idaInputs.dampingRatioUsedForSaDef;
lineColor =                       idaInputs.lineColor; 

% PFA is in g, NOT percent - so no *100 scaling anywhere below
if(isfield(idaInputs, 'maxXOnAxis_PFA'))
    maxXOnAxis = idaInputs.maxXOnAxis_PFA;
else
    maxXOnAxis = 2.0;   % g - adjust to your building's expected PFA range
end

if(isfield(idaInputs, 'maxYOnAxis_PFA'))
    maxYOnAxis = idaInputs.maxYOnAxis_PFA;
else
    maxYOnAxis = 4;
end

% Width of PDF shape on the PFA x-axis, in g 
scaleFactor = maxXOnAxis * 0.06;

if(isfield(idaInputs, 'pfaPerformanceThresholds'))
    pfaPerformanceThresholds = idaInputs.pfaPerformanceThresholds;   % already in g 
else
    pfaPerformanceThresholds = [];
end

if(isfield(idaInputs, 'pfaLevels'))
    pfaLevels = idaInputs.pfaLevels;   % target PFA values (g) for the PDF fit
else
    pfaLevels = [0.2 0.5 1.0 2.0];
end

if(isfield(idaInputs, 'pfaLevelLabels'))
    pfaLevelLabels = idaInputs.pfaLevelLabels;
else
    pfaLevelLabels = {'Slight','Moderate','Extensive','Complete'};
end

colors = [
    0.93 0.69 0.13
    1.00 0.00 0.00
    0.00 0.00 0.00
    1.00 0.00 1.00
    ];

DefineSaKircherOverSaGeoMeanValues

figureNumAllComp = 1;
figureNumControllingComp = 2;
ControllingCompNumLIST = [];
figure(figureNumAllComp); clf; hold on;
figure(figureNumControllingComp); clf; hold on;

collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));
collapseLevelForAllControlComp = zeros(1,(length(eqNumberLIST)));
maxPFAAtCollapseForAllComp = zeros(1,(2.0*length(eqNumberLIST)));
maxPFAAtCollapseForControlComp = zeros(1,(length(eqNumberLIST)));
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST)));
eqCompInd = 1;

saValsAtTargetPFAAllComp = nan(2*length(eqNumberLIST), length(pfaLevels));
saValsAtTargetPFAControlComp = nan(length(eqNumberLIST), length(pfaLevels));
pdfIndex = 1;

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);

    %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eqCompNumber = eqNumber * 10.0 + 1.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

    cd ..; cd Output;
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);
    eqFolder = sprintf('EQ_%.0f', eqCompNumber);
    cd(eqFolder)

    load('DATA_collapseIDAPlotDataForThisEQ.mat');   % must now also contain maxPFAForPlotLIST
    load('DATA_CollapseResultsForThisSingleEQ.mat', 'toleranceAchieved', 'periodUsedForScalingGroundMotions');

    subLoopIndex = 1;
    for loopIndex = 1:length(maxDriftRatioForPlotLIST)
        if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
            % Skip
        else
            maxDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
            maxPFAForPlotPROCLISTC1(subLoopIndex) = maxPFAForPlotLIST(loopIndex);   % NEW
            saLevelsForIDAPlotPROCLISTC1(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
            subLoopIndex = subLoopIndex + 1;
        end
    end

    figure(figureNumAllComp);
    if(isConvertToSaKircher == 0)
        plot(maxPFAForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1, markerTypeLine, 'Color', lineColor);   %  PFA already in g
    else
        saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
        saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
        saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC1.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
        plot(maxPFAForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        clear saGeoMeanAtOneSec saGeoMeanAtTOne
    end

    if(isPlotIndividualPoints == 1)
        for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
            hold on
            if(isConvertToSaKircher == 0)
                plot(maxPFAForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot, 'Color', lineColor);
            else
                plot(maxPFAForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
            end
        end
    end

    % Collapse Sa level - still defined by MAX DRIFT (unchanged definition)
    for index = 1:length(maxDriftRatioForPlotPROCLISTC1)
        if(maxDriftRatioForPlotPROCLISTC1(index) > collapseDriftThreshold)
            break;
        end
    end

    if(max(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1))) < 15.0);
        collapseLevelCompOne = (saLevelsForIDAPlotPROCLISTC1(index) + saLevelsForIDAPlotPROCLISTC1(index - 1)) / 2.0;
    else
        disp('*** Fixing error ***'); toleranceAchieved
        collapseLevelCompOne = min(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1)));
    end

    collapseSaLevel = collapseLevelCompOne;
    collapseLevelForAllComp(eqCompInd) = collapseLevelCompOne;
    maxPFAAtCollapseForAllComp(eqCompInd) = maxPFAForPlotPROCLISTC1(index - 1);
    indexAtCollapseC1 = index;

    maxPFAForPlotPROCLIST = maxPFAForPlotPROCLISTC1;
    saLevelsForIDAPlotPROCLIST = saLevelsForIDAPlotPROCLISTC1;
    save('DATA_collapse_ProcessedPFA_IDADataForThisEQ.mat', 'analysisType', 'maxPFAForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST', 'collapseSaLevel');

    clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST maxPFAForPlotLIST
    cd(fullfile('..', '..', '..', 'psb_MatlabProcessors'));
    eqCompInd = eqCompInd + 1;

    % PDF data collection - Component 1
    % NOTE: PFA is generally more monotonic with Sa than RDR, but higher-mode
    % effects can still cause local non-monotonicity, so dedupe before interp1.
    for pfaIdx = 1:length(pfaLevels)
        pfaTarget = pfaLevels(pfaIdx);   % already in g - no /100 needed (unlike RDR)
        if max(maxPFAForPlotPROCLISTC1) >= pfaTarget
            [pfaSorted, idx] = sort(maxPFAForPlotPROCLISTC1);
            saSorted = saLevelsForIDAPlotPROCLISTC1(idx);
            [pfaUniq, uIdx] = unique(pfaSorted, 'first');
            saUniq = saSorted(uIdx);
            saValsAtTargetPFAAllComp(pdfIndex, pfaIdx) = interp1(pfaUniq, saUniq, pfaTarget);
        end
    end
    pdfIndex = pdfIndex + 1;

    %%%%%%%%%%%%% END: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%% START: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eqCompNumber = eqNumber * 10.0 + 2.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

    cd ..; cd Output;
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);
    eqFolder = sprintf('EQ_%.0f', eqCompNumber);
    cd(eqFolder)

    load('DATA_collapseIDAPlotDataForThisEQ.mat');

    subLoopIndex = 1;
    for loopIndex = 1:length(maxDriftRatioForPlotLIST)
        if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
        else
            maxDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
            maxPFAForPlotPROCLISTC2(subLoopIndex) = maxPFAForPlotLIST(loopIndex);
            saLevelsForIDAPlotPROCLISTC2(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
            subLoopIndex = subLoopIndex + 1;
        end
    end

    figure(figureNumAllComp);
    if(isConvertToSaKircher == 0)
        plot(maxPFAForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2, markerTypeLine, 'Color', lineColor);
    else
        saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
        saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
        saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC2.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
        plot(maxPFAForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        clear saGeoMeanAtOneSec saGeoMeanAtTOne
    end

    if(isPlotIndividualPoints == 1)
        for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
            hold on
            if(isConvertToSaKircher == 0)
                plot(maxPFAForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot, 'Color', lineColor);
            else
                plot(maxPFAForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
            end
        end
    end

    for index = 1:length(maxDriftRatioForPlotPROCLISTC2)
        if(maxDriftRatioForPlotPROCLISTC2(index) > collapseDriftThreshold)
            break;
        end
    end

    if(max(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index - 1))) < 15.0)
        collapseLevelCompTwo = (saLevelsForIDAPlotPROCLISTC2(index) + saLevelsForIDAPlotPROCLISTC2(index - 1)) / 2.0;
    else
        disp('*** Fixing error ***'); toleranceAchieved
        collapseLevelCompTwo = min(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index - 1)));
    end

    collapseSaLevel = collapseLevelCompTwo;
    collapseLevelForAllComp(eqCompInd) = collapseLevelCompTwo;
    maxPFAAtCollapseForAllComp(eqCompInd) = maxPFAForPlotPROCLISTC2(index - 1);
    indexAtCollapseC2 = index;

    maxPFAForPlotPROCLIST = maxPFAForPlotPROCLISTC2;
    saLevelsForIDAPlotPROCLIST = saLevelsForIDAPlotPROCLISTC2;
    save('DATA_collapse_ProcessedPFA_IDADataForThisEQ.mat', 'analysisType', 'maxPFAForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST', 'collapseSaLevel');

    clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST maxPFAForPlotLIST
    cd(fullfile('..', '..', '..', 'psb_MatlabProcessors'));
    eqCompInd = eqCompInd + 1;

    for pfaIdx = 1:length(pfaLevels)
        pfaTarget = pfaLevels(pfaIdx);
        if max(maxPFAForPlotPROCLISTC2) >= pfaTarget
            [pfaSorted, idx] = sort(maxPFAForPlotPROCLISTC2);
            saSorted = saLevelsForIDAPlotPROCLISTC2(idx);
            [pfaUniq, uIdx] = unique(pfaSorted, 'first');
            saUniq = saSorted(uIdx);
            saValsAtTargetPFAAllComp(pdfIndex, pfaIdx) = interp1(pfaUniq, saUniq, pfaTarget);
        end
    end
    pdfIndex = pdfIndex + 1;

    %%%%%%%%%%%%% END: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%% START: Find controlling component and plot its PFA curve %%%%%%%%%
    
    if(collapseLevelCompTwo > collapseLevelCompOne)
        figure(figureNumControllingComp);
        if(isConvertToSaKircher == 0)
            plot(maxPFAForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1, markerTypeLine, 'Color', lineColor);
        else
            plot(maxPFAForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        end

        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
                hold on
                if(isConvertToSaKircher == 0)
                    plot(maxPFAForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot, 'Color', lineColor);
                else
                    plot(maxPFAForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                end
            end
        end

        collapseLevelForAllControlComp(eqInd) = collapseLevelCompOne;
        maxPFAAtCollapseForControlComp(eqInd) = maxPFAForPlotPROCLISTC1(indexAtCollapseC1 - 1);
        ControllingCompNumLIST = [ControllingCompNumLIST (eqNumber*10+1)];
        saValsAtTargetPFAControlComp(eqInd, :) = saValsAtTargetPFAAllComp(2*eqInd - 1, :);
    else
        figure(figureNumControllingComp);
        if(isConvertToSaKircher == 0)
            plot(maxPFAForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2, markerTypeLine, 'Color', lineColor);
        else
            plot(maxPFAForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        end

        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
                hold on
                if(isConvertToSaKircher == 0)
                    plot(maxPFAForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot, 'Color', lineColor);
                else
                    plot(maxPFAForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                end
            end
        end

        collapseLevelForAllControlComp(eqInd) = collapseLevelCompTwo;
        maxPFAAtCollapseForControlComp(eqInd) = maxPFAForPlotPROCLISTC2(indexAtCollapseC2 - 1);
        ControllingCompNumLIST = [ControllingCompNumLIST (eqNumber*10+2)];
        saValsAtTargetPFAControlComp(eqInd, :) = saValsAtTargetPFAAllComp(2*eqInd, :);
    end
     
    %%%%%%%%%%%%%% END: Find controlling component %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    clear collapseLevelCompOne collapseLevelCompTwo maxDriftRatioForPlotPROCLISTC1 maxDriftRatioForPlotPROCLISTC2 ...
        maxPFAForPlotPROCLISTC1 maxPFAForPlotPROCLISTC2 saLevelsForIDAPlotPROCLISTC1 saLevelsForIDAPlotPROCLISTC2 ...
        saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec indexAtCollapseC1 indexAtCollapseC2;
end

% Sa,Kircher conversion for collapse-level summary vectors - identical to original
if(isConvertToSaKircher == 0)
    % Sa,geoMean - no conversion
else
    for eqInd = 1:(length(eqCompNumberLIST))
        eqCompNumber = eqCompNumberLIST(eqInd);
        eqNumber = floor(eqCompNumber/10);
        saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
        saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
        collapseLevelForAllComp(eqInd) = collapseLevelForAllComp(eqInd) * (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
    end
    for eqInd = 1:(length(eqNumberLIST))
        eqNumber = eqNumberLIST(eqInd);
        eqCompNumber = eqNumber * 10.0 + 1.0;
        saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
        saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
        collapseLevelForAllControlComp(eqInd) = collapseLevelForAllControlComp(eqInd) * (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
    end
    clear saGeoMeanAtOneSec saGeoMeanAtTOne
end

% PFA-specific statistics: PFA at the (already established) collapse point
meanPFAAtCollapseAllComp = mean(maxPFAAtCollapseForAllComp);
medianPFAAtCollapseAllComp = median(maxPFAAtCollapseForAllComp);
stDevPFAAtCollapseAllComp = std(maxPFAAtCollapseForAllComp);

meanPFAAtCollapseControlComp = mean(maxPFAAtCollapseForControlComp);
medianPFAAtCollapseControlComp = median(maxPFAAtCollapseForControlComp);
stDevPFAAtCollapseControlComp = std(maxPFAAtCollapseForControlComp);

% Save PFA collapse results file
    cd ..
    cd Output
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);

    if(isConvertToSaKircher == 0)
        colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean_PFA.mat', eqListForCollapseIDAs_Name);
    else
        colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63_PFA.mat', eqListForCollapseIDAs_Name);
    end

    save(colFileName, 'analysisType', 'collapseLevelForAllComp', 'collapseLevelForAllControlComp', 'eqNumberLIST', ...
        'maxPFAAtCollapseForAllComp', 'maxPFAAtCollapseForControlComp', ...
        'meanPFAAtCollapseAllComp', 'medianPFAAtCollapseAllComp', 'stDevPFAAtCollapseAllComp', ...
        'meanPFAAtCollapseControlComp', 'medianPFAAtCollapseControlComp', 'stDevPFAAtCollapseControlComp', ...
        'eqCompNumberLIST', 'ControllingCompNumLIST', 'periodUsedForScalingGroundMotions');

    %% ============================================================
    %  Plot LOG NORMAL PDF at PFA locations (ALL COMPONENTS)
    % ============================================================
    figure(figureNumAllComp);
    hold on;

    hPFALines = gobjects(length(pfaLevels), 1);

    for pfaIdx = 1:length(pfaLevels)
        targetPFA = pfaLevels(pfaIdx);   % already in g - no conversion needed for x-axis position

        SaVals = saValsAtTargetPFAAllComp(:, pfaIdx);
        SaVals = SaVals(isfinite(SaVals) & SaVals > 0);

        if numel(SaVals) < 2
            continue
        end

        muLn = mean(log(SaVals));
        sigmaLn = std(log(SaVals));

        Sa16 = exp(muLn - sigmaLn);
        Sa50 = exp(muLn);
        Sa84 = exp(muLn + sigmaLn);

        Sa_neg3 = exp(muLn - 3*sigmaLn);
        Sa_pos3 = exp(muLn + 3*sigmaLn);

        hPFALines(pfaIdx) = plot([targetPFA targetPFA], [Sa16 Sa84], ...
            '-', 'LineWidth', 3.0, 'Color', colors(pfaIdx,:), 'DisplayName', pfaLevelLabels{pfaIdx});

        plot(targetPFA, Sa50, 'o', 'MarkerFaceColor', colors(pfaIdx,:), ...
            'MarkerEdgeColor', colors(pfaIdx,:), 'HandleVisibility', 'off');

        nPtsPerSeg = 150;
        saLower = linspace(Sa_neg3, Sa16, nPtsPerSeg);
        saMid   = linspace(Sa16,    Sa84, nPtsPerSeg);
        saUpper = linspace(Sa84,    Sa_pos3, nPtsPerSeg);

        pdfLower = lognpdf(saLower, muLn, sigmaLn);
        pdfMid   = lognpdf(saMid,   muLn, sigmaLn);
        pdfUpper = lognpdf(saUpper, muLn, sigmaLn);
        globalMax = max([pdfLower, pdfMid, pdfUpper]);
        pdfLower = pdfLower ./ globalMax * scaleFactor;
        pdfMid   = pdfMid   ./ globalMax * scaleFactor;
        pdfUpper = pdfUpper ./ globalMax * scaleFactor;

        segments = {saLower, saMid, saUpper};
        pdfSegs  = {pdfLower, pdfMid, pdfUpper};
        isFilled = [false, true, false];

        for s = 1:3
            saSeg = segments{s};
            pdfSeg = pdfSegs{s};
            if numel(saSeg) < 2
                continue
            end
            x_pdf = [targetPFA * ones(1, length(saSeg)), targetPFA - pdfSeg(end:-1:1)];
            y_pdf = [saSeg, saSeg(end:-1:1)];
            if isFilled(s)
                patch(x_pdf, y_pdf, colors(pfaIdx,:), 'FaceAlpha', 0.30, ...
                    'EdgeColor', colors(pfaIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
            else
                patch(x_pdf, y_pdf, colors(pfaIdx,:), 'FaceColor', 'none', ...
                    'EdgeColor', colors(pfaIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
            end
        end
    end

    validIdx = isgraphics(hPFALines);
    if any(validIdx)
        legend(hPFALines(validIdx), pfaLevelLabels(validIdx), 'Location', 'southeast', 'AutoUpdate', 'off');
    end

    %% Final plot details - figure for all components
    figure(figureNumAllComp)
    hold on
    grid on

    if(isConvertToSaKircher == 0)
        titleTemp = sprintf('$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
    else
        titleTemp = axisLabelForSaKircher;
    end
    ylabel(titleTemp, 'Interpreter', 'latex');
    xlabel('$\mathrm{Peak\ Floor\ Acceleration\ (g)}$', 'Interpreter','latex');
    xlim([0, maxXOnAxis])
    ylim([0, maxYOnAxis])

    % Optional performance-level reference lines
    for i = 1:length(pfaPerformanceThresholds)
        xline(pfaPerformanceThresholds(i), '--');
    end

    sks_figureFormat(formatMode)

    if(isConvertToSaKircher == 0)
        exportName = sprintf('CollapseIDA_AllComp_SaGeoMean_PFA_PDF');
        sks_figureExport(exportName)
    else
        exportName = sprintf('CollapseIDA_AllComp_SaATC63_PFA_PDF');
        sks_figureExport(exportName)
    end
    hold off

    %% ============================================================
    %  Plot LOG NORMAL PDF at PFA locations (CONTROL COMPONENT)
    % ============================================================
    figure(figureNumControllingComp);
    hold on;

    hPFALines = gobjects(length(pfaLevels), 1);
    
    for pfaIdx = 1:length(pfaLevels)
        targetPFA = pfaLevels(pfaIdx);

        SaVals = saValsAtTargetPFAControlComp(:, pfaIdx);
        SaVals = SaVals(~isnan(SaVals) & SaVals > 0);

        if numel(SaVals) < 2
            continue
        end

        muLn = mean(log(SaVals));
        sigmaLn = std(log(SaVals));

        Sa16 = exp(muLn - sigmaLn);
        Sa50 = exp(muLn);
        Sa84 = exp(muLn + sigmaLn);

        Sa_neg3 = exp(muLn - 3*sigmaLn);
        Sa_pos3 = exp(muLn + 3*sigmaLn);

        hPFALines(pfaIdx) = plot([targetPFA targetPFA], [Sa16 Sa84], ...
            '-', 'LineWidth', 3.0, 'Color', colors(pfaIdx,:), 'DisplayName', pfaLevelLabels{pfaIdx});

        plot(targetPFA, Sa50, 'o', 'MarkerFaceColor', colors(pfaIdx,:), ...
            'MarkerEdgeColor', colors(pfaIdx,:), 'HandleVisibility', 'off');

        nPtsPerSeg = 150;
        saLower = linspace(Sa_neg3, Sa16, nPtsPerSeg);
        saMid   = linspace(Sa16,    Sa84, nPtsPerSeg);
        saUpper = linspace(Sa84,    Sa_pos3, nPtsPerSeg);

        pdfLower = lognpdf(saLower, muLn, sigmaLn);
        pdfMid   = lognpdf(saMid,   muLn, sigmaLn);
        pdfUpper = lognpdf(saUpper, muLn, sigmaLn);
        globalMax = max([pdfLower, pdfMid, pdfUpper]);
        pdfLower = pdfLower ./ globalMax * scaleFactor;
        pdfMid   = pdfMid   ./ globalMax * scaleFactor;
        pdfUpper = pdfUpper ./ globalMax * scaleFactor;

        segments = {saLower, saMid, saUpper};
        pdfSegs  = {pdfLower, pdfMid, pdfUpper};
        isFilled = [false, true, false];

        for s = 1:3
            saSeg = segments{s};
            pdfSeg = pdfSegs{s};
            if numel(saSeg) < 2
                continue
            end
            x_pdf = [targetPFA * ones(1, length(saSeg)), targetPFA - pdfSeg(end:-1:1)];
            y_pdf = [saSeg, saSeg(end:-1:1)];
            if isFilled(s)
                patch(x_pdf, y_pdf, colors(pfaIdx,:), 'FaceAlpha', 0.30, ...
                    'EdgeColor', colors(pfaIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
            else
                patch(x_pdf, y_pdf, colors(pfaIdx,:), 'FaceColor', 'none', ...
                    'EdgeColor', colors(pfaIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
            end
        end
    end

    validIdx = isgraphics(hPFALines);
    if any(validIdx)
        legend(hPFALines(validIdx), pfaLevelLabels(validIdx), 'Location', 'southeast', 'AutoUpdate', 'off');
    end

    %% Final plot details - figure for controlling components
    figure(figureNumControllingComp);
    hold on
    grid on
    if(isConvertToSaKircher == 0)
        titleTemp = sprintf('$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
    else
        titleTemp = axisLabelForSaKircher;
    end
    ylabel(titleTemp, 'Interpreter', 'latex');
    xlabel('$\mathrm{Peak\ Floor\ Acceleration\ (g)}$', 'Interpreter','latex');
    xlim([0, maxXOnAxis])
    ylim([0, maxYOnAxis])

    for i = 1:length(pfaPerformanceThresholds)
        xline(pfaPerformanceThresholds(i), '--');
    end

    sks_figureFormat(formatMode)

  
    if(isConvertToSaKircher == 0)
        exportName = sprintf('CollapseIDA_ControlComp_SaGeoMean_PFA_PDF');
        sks_figureExport(exportName)
    else
        exportName = sprintf('CollapseIDA_ControlComp_SaATC63_PFA_PDF');
        sks_figureExport(exportName)
    end
    hold off

cd(fullfile('..', '..', 'psb_MatlabProcessors'));


%%% DEBUG: check how many EQs and controlling components were processed
disp('eqNumberLIST:');
disp(eqNumberLIST);
disp('ControllingCompNumLIST at end:');
disp(ControllingCompNumLIST);
disp('collapseLevelForAllControlComp:');
disp(collapseLevelForAllControlComp);


%%%%%%%%%%%%% Fragility Functions - compute + save only (Control + All Comp) %%%%%%%%%%%%%%%%%%%%%%%
% ADDED 15-Sep-2026: mirrors the block in sks_PlotCollapseIDAsPDF_singleAnaType.m
% (MIDR version), but fit at each PFA level instead of each MIDR level, using
% the per-EQ Sa data already collected above in saValsAtTargetPFAAllComp /
% saValsAtTargetPFAControlComp. This is what lets
% PlotCollapseEmpiricalCDFWithFits_allPFA_proc.m produce the empirical CDF plots.

% Go to the correct folder to save the fragility params file
  cd ..;
  cd Output
  analysisTypeFolder = sprintf('%s', analysisType);
  cd(analysisTypeFolder);

  numLimitStates = length(pfaLevels);   % number of limit states (Slight, Moderate, Extensive, Complete)

  % ---- Controlling component ----
  meanLnSaVals   = nan(1, numLimitStates);
  stDevLnSaVals  = nan(1, numLimitStates);

  for limitStateIdx = 1:numLimitStates
      SaVals = saValsAtTargetPFAControlComp(:, limitStateIdx);
      SaVals = SaVals(isfinite(SaVals) & SaVals > 0);   % drop NaNs/invalid

      if numel(SaVals) < 2
          warning('Control comp - PFA level %d has fewer than 2 valid points - skipping', limitStateIdx);
          continue
      end

      meanLnSaVals(limitStateIdx)  = mean(log(SaVals));   % median IM capacity for this PFA level
      stDevLnSaVals(limitStateIdx) = std(log(SaVals));    % logarithmic dispersion (beta_RTR)
  end

  % ---- All components ----
  meanLnSaValsAllComp   = nan(1, numLimitStates);
  stDevLnSaValsAllComp  = nan(1, numLimitStates);

  for limitStateIdx = 1:numLimitStates
      SaVals = saValsAtTargetPFAAllComp(:, limitStateIdx);
      SaVals = SaVals(isfinite(SaVals) & SaVals > 0);   % drop NaNs/invalid

      if numel(SaVals) < 2
          warning('All comp - PFA level %d has fewer than 2 valid points - skipping', limitStateIdx);
          continue
      end

      meanLnSaValsAllComp(limitStateIdx)  = mean(log(SaVals));
      stDevLnSaValsAllComp(limitStateIdx) = std(log(SaVals));
  end

% Save the fragility parameters (both control and all comp) so they survive after this function returns
if (isConvertToSaKircher == 0)
      fragFileName = sprintf('DATA_FragilityParams_SaGeoMean_%s_PFA.mat', eqListForCollapseIDAs_Name);
else
      fragFileName = sprintf('DATA_FragilityParams_SaATC63_%s_PFA.mat', eqListForCollapseIDAs_Name);
end
  save(fragFileName, 'pfaLevels', 'pfaLevelLabels', 'meanLnSaVals', 'stDevLnSaVals', 'saValsAtTargetPFAControlComp', ...
       'meanLnSaValsAllComp', 'stDevLnSaValsAllComp', 'saValsAtTargetPFAAllComp');

% Return safely to MatlabProcessors folder
  cd(fullfile('..', '..', 'psb_MatlabProcessors'));

end