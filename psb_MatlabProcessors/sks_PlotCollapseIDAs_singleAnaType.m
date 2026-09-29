%
% Procedure: sks_PlotCollapseIDAs_singleAnaType.m
% -------------------
% Unified version of four separate _singleAnaType plotting functions.
% Controlled by idaInputs.plotType:
%   'MIDR'     - Max Interstory Drift Ratio vs Sa(T1), no PDF
%   'MIDR_PDF' - Max Interstory Drift Ratio vs Sa(T1), with PDF overlay
%   'RDR'      - Residual Drift Ratio vs Sa(T1), with PDF overlay
%   'PFA'      - Peak Floor Acceleration vs Sa(T1), with PDF overlay
%
% Collapse is ALWAYS defined by maxDriftRatio crossing collapseDriftThreshold.
% No new variables created. Code structure identical to PlotCollapseIDAs_singleAnaType.m.
% Only added blocks from MIDR_PDF, RDR, PFA files at exact insertion points.
%
% Author: Curt Haselton (original PlotCollapseIDAs_singleAnaType.m)
% Unified by: Shivakumar KS on 25-Sep-2026
% -------------------
function[void] = sks_PlotCollapseIDAs_singleAnaType(idaInputs)

eqSpectraFolder =                idaInputs.eqSpectraFolder;
analysisType =                   idaInputs.analysisType;
eqListForCollapseIDAs_Name =     idaInputs.eqListForCollapseIDAs_Name;
markerTypeLine =                 idaInputs.markerTypeLine;
markerTypeDot =                  idaInputs.markerTypeDot;
isPlotIndividualPoints =         idaInputs.isPlotIndividualPoints;
collapseDriftThreshold =         idaInputs.collapseDriftThreshold;
isConvertToSaKircher =           idaInputs.isConvertToSaKircher;
eqNumberLIST =                   idaInputs.eqNumberLIST_forCollapseIDAs;
formatMode =                     idaInputs.formatMode;
dampRat =                        idaInputs.dampingRatioUsedForSaDef;
lineColor =                      idaInputs.lineColor;
plotType =                       idaInputs.plotType;

% Added by Shivakumar KS on 25-Sep-2026 - read PDF-specific inputs if needed
if strcmp(plotType, 'MIDR_PDF')
    midrLevels =      idaInputs.midrLevels;
    midrLevelLabels = idaInputs.midrLevelLabels;
end
if strcmp(plotType, 'RDR_PDF')
    if isfield(idaInputs, 'rdrLevels')
        rdrLevels = idaInputs.rdrLevels;
    else
        rdrLevels = [0.002 0.005 0.01 0.02];
    end
    if isfield(idaInputs, 'rdrLevelLabels')
        rdrLevelLabels = idaInputs.rdrLevelLabels;
    else
        rdrLevelLabels = {'IO', 'LS', 'CP', 'Collapse'};
    end
end
if strcmp(plotType, 'PFA_PDF')
    if isfield(idaInputs, 'pfaLevels')
        pfaLevels = idaInputs.pfaLevels;
    else
        pfaLevels = [0.2 0.5 1.0 2.0];
    end
    if isfield(idaInputs, 'pfaLevelLabels')
        pfaLevelLabels = idaInputs.pfaLevelLabels;
    else
        pfaLevelLabels = {'Slight', 'Moderate', 'Extensive', 'Complete'};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This does collapse IDAs for a single analysisType
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DefineSaKircherOverSaGeoMeanValues

% Input what max drift value you want on X axis for the plot
maxXOnAxis = 12; % in percent
figureNumAllComp = 1;
figureNumControlComp = 2;
ControllingCompNumLIST = [];

% Added by Shivakumar KS on 25-Sep-2026 - initialize PDF arrays before EQ loop
if strcmp(plotType, 'MIDR_PDF')
    saValsAtTargetDriftAllComp =     nan(2*length(eqNumberLIST), length(midrLevels));
    saValsAtTargetDriftControlComp = nan(length(eqNumberLIST),   length(midrLevels));
    pdfIndex = 1;
    colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
end
if strcmp(plotType, 'RDR_PDF')
    saValsAtTargetDriftAllComp =     nan(2*length(eqNumberLIST), length(rdrLevels));
    saValsAtTargetDriftControlComp = nan(length(eqNumberLIST),   length(rdrLevels));
    pdfIndex = 1;
    colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
end
if strcmp(plotType, 'PFA_PDF')
    saValsAtTargetPFAAllComp =     nan(2*length(eqNumberLIST), length(pfaLevels));
    saValsAtTargetPFAControlComp = nan(length(eqNumberLIST),   length(pfaLevels));
    pdfIndex = 1;
    colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
end

figure(figureNumAllComp); clf; hold on;
figure(figureNumControlComp); clf; hold on;

collapseLevelForAllComp =        zeros(1,(2.0*length(eqNumberLIST)));
collapseLevelForAllControlComp = zeros(1,(length(eqNumberLIST)));
maxDriftRatioAtCollapseForAllComp =     zeros(1, 2.0*length(eqNumberLIST));
maxDriftRatioAtCollapseForControlComp = zeros(1, length(eqNumberLIST));
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST)));
eqCompInd = 1;

% Added by Shivakumar KS on 25-Sep-2026 - RDR/PFA specific initialisation
if strcmp(plotType, 'RDR_PDF')
    maxResidualDriftAtCollapseForAllComp     = zeros(1, 2*length(eqNumberLIST));
    maxResidualDriftAtCollapseForControlComp = zeros(1, length(eqNumberLIST));
end
if strcmp(plotType, 'PFA_PDF')
    maxPFAAtCollapseForAllComp     = zeros(1, 2*length(eqNumberLIST));
    maxPFAAtCollapseForControlComp = zeros(1, length(eqNumberLIST));
end


for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);

    %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%

    eqCompNumber = eqNumber * 10.0 + 1.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

    % Go to the correct folder
    cd(fullfile('..','Output'));

    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);
    eqFolder = sprintf('EQ_%.0f', eqCompNumber);
    cd(eqFolder)

    load('DATA_collapseIDAPlotDataForThisEQ.mat');
    load('DATA_CollapseResultsForThisSingleEQ.mat', 'toleranceAchieved', 'periodUsedForScalingGroundMotions');

    eqCompNumber;

    subLoopIndex = 1;
    for loopIndex = 1:length(maxDriftRatioForPlotLIST)
        if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
            % skip
        else
            maxDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
            saLevelsForIDAPlotPROCLISTC1(subLoopIndex)   = saLevelsForIDAPlotLIST(loopIndex);
            % Added by Shivakumar KS on 25-Sep-2026 - also collect RDR and PFA alongside maxDrift
            if strcmp(plotType, 'RDR_PDF')
                maxResidualDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxResidualDriftRatioForPlotLIST(loopIndex);
            end
            if strcmp(plotType, 'PFA_PDF')
                maxPFAForPlotPROCLISTC1(subLoopIndex) = maxPFAForPlotLIST(loopIndex);
            end
            subLoopIndex = subLoopIndex + 1;
        end
    end

    figure(figureNumAllComp);

    % Added by Shivakumar KS on 25-Sep-2026 - switch x-axis variable for plot
    if isConvertToSaKircher == 0
        if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
            plot(maxDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1, markerTypeLine, 'Color', lineColor);
        elseif strcmp(plotType, 'RDR_PDF')
            plot(maxResidualDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1, markerTypeLine, 'Color', lineColor);
        elseif strcmp(plotType, 'PFA_PDF')
            plot(maxPFAForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1, markerTypeLine, 'Color', lineColor);
        end
    else
        saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
        saGeoMeanAtTOne   = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
        saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC1 .* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
        if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
            plot(maxDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        elseif strcmp(plotType, 'RDR_PDF')
            plot(maxResidualDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        elseif strcmp(plotType, 'PFA_PDF')
            plot(maxPFAForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        end
        clear saGeoMeanAtOneSec saGeoMeanAtTOne
    end

    if isPlotIndividualPoints == 1
        for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
            hold on
            if isConvertToSaKircher == 0
                if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                    plot(maxDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot, 'Color', lineColor);
                elseif strcmp(plotType, 'RDR_PDF')
                    plot(maxResidualDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot, 'Color', lineColor);
                elseif strcmp(plotType, 'PFA_PDF')
                    plot(maxPFAForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot, 'Color', lineColor);
                end
            else
                if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                    plot(maxDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                elseif strcmp(plotType, 'RDR_PDF')
                    plot(maxResidualDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                elseif strcmp(plotType, 'PFA_PDF')
                    plot(maxPFAForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                end
            end
        end
    end

    % Find collapse Sa - ALWAYS uses maxDriftRatioForPlotPROCLISTC1 - unchanged
    for index = 1:length(maxDriftRatioForPlotPROCLISTC1)
        if(maxDriftRatioForPlotPROCLISTC1(index) > collapseDriftThreshold)
            break;
        end
    end

    if(max(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index-1))) < 15.0)
        collapseLevelCompOne = (saLevelsForIDAPlotPROCLISTC1(index) + saLevelsForIDAPlotPROCLISTC1(index-1)) / 2.0;
    else
        disp('***********************************');
        disp('******* Fixing error **************');
        disp('***********************************');
        toleranceAchieved
        collapseLevelCompOne = min(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index-1)));
    end

    collapseLevelCompOne;
    collapseSaLevel = collapseLevelCompOne;
    collapseLevelForAllComp(eqCompInd) = collapseLevelCompOne;
    maxDriftRatioAtCollapseForAllComp(eqCompInd) = maxDriftRatioForPlotPROCLISTC1(index-1);
    indexAtCollapseC1 = index;

    % Added by Shivakumar KS on 25-Sep-2026 - RDR/PFA all-comp collapse tracking
    if strcmp(plotType, 'RDR_PDF')
        maxResidualDriftAtCollapseForAllComp(eqCompInd) = maxResidualDriftRatioForPlotPROCLISTC1(indexAtCollapseC1-1);
    end
    if strcmp(plotType, 'PFA_PDF')
        maxPFAAtCollapseForAllComp(eqCompInd) = maxPFAForPlotPROCLISTC1(indexAtCollapseC1-1);
    end

    
    % Save per-EQ file - single unified file for all plotTypes
    % Added by Shivakumar KS on 25-Sep-2026 - merged into one file
    maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC1;
    saLevelsForIDAPlotPROCLIST   = saLevelsForIDAPlotPROCLISTC1;
    eqCompColFileName = sprintf('DATA_collapse_ProcessedIDADataForThisEQ.mat');
    save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST', 'collapseSaLevel');
    if strcmp(plotType, 'RDR_PDF')
        maxResidualDriftRatioForPlotPROCLIST = maxResidualDriftRatioForPlotPROCLISTC1;
        save(eqCompColFileName, 'maxResidualDriftRatioForPlotPROCLIST', '-append');
    end
    if strcmp(plotType, 'PFA_PDF')
        maxPFAForPlotPROCLIST = maxPFAForPlotPROCLISTC1;
        save(eqCompColFileName, 'maxPFAForPlotPROCLIST', '-append');
    end

    clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST maxResidualDriftRatioForPlotLIST maxPFAForPlotLIST
    cd(fullfile('..', '..', '..', 'psb_MatlabProcessors'));
    eqCompInd = eqCompInd + 1;

    % Added by Shivakumar KS on 25-Sep-2026 - PDF data collection after cd back, component 1
    if strcmp(plotType, 'MIDR_PDF')
        for driftIdx = 1:length(midrLevels)
            driftTarget = midrLevels(driftIdx);
            if max(maxDriftRatioForPlotPROCLISTC1) >= driftTarget
                [driftSorted, idx] = sort(maxDriftRatioForPlotPROCLISTC1);
                saSorted = saLevelsForIDAPlotPROCLISTC1(idx);
                saValsAtTargetDriftAllComp(pdfIndex, driftIdx) = interp1(driftSorted, saSorted, driftTarget);
            end
        end
        pdfIndex = pdfIndex + 1;
    end
    if strcmp(plotType, 'RDR_PDF')
        for driftIdx = 1:length(rdrLevels)
            driftTarget = rdrLevels(driftIdx);
            if max(maxResidualDriftRatioForPlotPROCLISTC1) >= driftTarget
                [driftSorted, idx] = sort(maxResidualDriftRatioForPlotPROCLISTC1);
                saSorted = saLevelsForIDAPlotPROCLISTC1(idx);
                [driftUniq, uIdx] = unique(driftSorted, 'first');
                saUniq = saSorted(uIdx);
                saValsAtTargetDriftAllComp(pdfIndex, driftIdx) = interp1(driftUniq, saUniq, driftTarget);
            end
        end
        pdfIndex = pdfIndex + 1;
    end
    if strcmp(plotType, 'PFA_PDF')
        for pfaIdx = 1:length(pfaLevels)
            pfaTarget = pfaLevels(pfaIdx);
            if max(maxPFAForPlotPROCLISTC1) >= pfaTarget
                [pfaSorted, idx] = sort(maxPFAForPlotPROCLISTC1);
                saSorted = saLevelsForIDAPlotPROCLISTC1(idx);
                [pfaUniq, uIdx] = unique(pfaSorted, 'first');
                saUniq = saSorted(uIdx);
                saValsAtTargetPFAAllComp(pdfIndex, pfaIdx) = interp1(pfaUniq, saUniq, pfaTarget);
            end
        end
        pdfIndex = pdfIndex + 1;
    end

    %%%%%%%%%%%%% END: Loop for component 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%% START: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%
    eqCompNumber = eqNumber * 10.0 + 2.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

    cd(fullfile('..','Output'));
  
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);
    eqFolder = sprintf('EQ_%.0f', eqCompNumber);
    cd(eqFolder)

    load('DATA_collapseIDAPlotDataForThisEQ.mat');

    eqCompNumber;

    subLoopIndex = 1;
    for loopIndex = 1:length(maxDriftRatioForPlotLIST)
        if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
            % skip
        else
            maxDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
            saLevelsForIDAPlotPROCLISTC2(subLoopIndex)   = saLevelsForIDAPlotLIST(loopIndex);
            % Added by Shivakumar KS on 25-Sep-2026
            if strcmp(plotType, 'RDR_PDF')
                maxResidualDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxResidualDriftRatioForPlotLIST(loopIndex);
            end
            if strcmp(plotType, 'PFA_PDF')
                maxPFAForPlotPROCLISTC2(subLoopIndex) = maxPFAForPlotLIST(loopIndex);
            end
            subLoopIndex = subLoopIndex + 1;
        end
    end

    figure(figureNumAllComp);
    if isConvertToSaKircher == 0
        if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
            plot(maxDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2, markerTypeLine, 'Color', lineColor);
        elseif strcmp(plotType, 'RDR_PDF')
            plot(maxResidualDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2, markerTypeLine, 'Color', lineColor);
        elseif strcmp(plotType, 'PFA_PDF')
            plot(maxPFAForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2, markerTypeLine, 'Color', lineColor);
        end
    else
        saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
        saGeoMeanAtTOne   = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
        saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC2 .* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
        if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
            plot(maxDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        elseif strcmp(plotType, 'RDR_PDF')
            plot(maxResidualDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        elseif strcmp(plotType, 'PFA_PDF')
            plot(maxPFAForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
        end
        clear saGeoMeanAtOneSec saGeoMeanAtTOne
    end

    if isPlotIndividualPoints == 1
        for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
            hold on
            if isConvertToSaKircher == 0
                if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                    plot(maxDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot, 'Color', lineColor);
                elseif strcmp(plotType, 'RDR_PDF')
                    plot(maxResidualDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot, 'Color', lineColor);
                elseif strcmp(plotType, 'PFA_PDF')
                    plot(maxPFAForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot, 'Color', lineColor);
                end
            else
                if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                    plot(maxDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                elseif strcmp(plotType, 'RDR_PDF')
                    plot(maxResidualDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                elseif strcmp(plotType, 'PFA_PDF')
                    plot(maxPFAForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                end
            end
        end
    end

    for index = 1:length(maxDriftRatioForPlotPROCLISTC2)
        if(maxDriftRatioForPlotPROCLISTC2(index) > collapseDriftThreshold)
            break;
        end
    end

    if(max(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index-1))) < 15.0)
        collapseLevelCompTwo = (saLevelsForIDAPlotPROCLISTC2(index) + saLevelsForIDAPlotPROCLISTC2(index-1)) / 2.0;
    else
        disp('***********************************');
        disp('******* Fixing error **************');
        disp('***********************************');
        toleranceAchieved
        collapseLevelCompTwo = min(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index-1)));
    end

    collapseLevelCompTwo;
    collapseSaLevel = collapseLevelCompTwo;
    collapseLevelForAllComp(eqCompInd) = collapseLevelCompTwo;
    maxDriftRatioAtCollapseForAllComp(eqCompInd) = maxDriftRatioForPlotPROCLISTC2(index-1);
    indexAtCollapseC2 = index;

    % Added by Shivakumar KS on 25-Sep-2026 - RDR/PFA all-comp collapse tracking
    if strcmp(plotType, 'RDR_PDF')
        maxResidualDriftAtCollapseForAllComp(eqCompInd) = maxResidualDriftRatioForPlotPROCLISTC2(indexAtCollapseC2-1);
    end
    if strcmp(plotType, 'PFA_PDF')
        maxPFAAtCollapseForAllComp(eqCompInd) = maxPFAForPlotPROCLISTC2(indexAtCollapseC2-1);
    end

    % Save per-EQ file - single unified file for all plotTypes
    maxDriftRatioForPlotPROCLIST = maxDriftRatioForPlotPROCLISTC2;
    saLevelsForIDAPlotPROCLIST   = saLevelsForIDAPlotPROCLISTC2;
    eqCompColFileName = sprintf('DATA_collapse_ProcessedIDADataForThisEQ.mat');
    save(eqCompColFileName, 'analysisType', 'maxDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST', 'collapseSaLevel');
    if strcmp(plotType, 'RDR_PDF')
        maxResidualDriftRatioForPlotPROCLIST = maxResidualDriftRatioForPlotPROCLISTC2;
        save(eqCompColFileName, 'maxResidualDriftRatioForPlotPROCLIST', '-append');
    end
    if strcmp(plotType, 'PFA_PDF')
        maxPFAForPlotPROCLIST = maxPFAForPlotPROCLISTC2;
        save(eqCompColFileName, 'maxPFAForPlotPROCLIST', '-append');
    end

    clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST maxResidualDriftRatioForPlotLIST maxPFAForPlotLIST
    cd(fullfile('..', '..', '..', 'psb_MatlabProcessors'));
    eqCompInd = eqCompInd + 1;

    % Added by Shivakumar KS on 25-Sep-2026 - PDF data collection after cd back, component 2
    if strcmp(plotType, 'MIDR_PDF')
        for driftIdx = 1:length(midrLevels)
            driftTarget = midrLevels(driftIdx);
            if max(maxDriftRatioForPlotPROCLISTC2) >= driftTarget
                [driftSorted, idx] = sort(maxDriftRatioForPlotPROCLISTC2);
                saSorted = saLevelsForIDAPlotPROCLISTC2(idx);
                saValsAtTargetDriftAllComp(pdfIndex, driftIdx) = interp1(driftSorted, saSorted, driftTarget);
            end
        end
        pdfIndex = pdfIndex + 1;
    end
    if strcmp(plotType, 'RDR_PDF')
        for driftIdx = 1:length(rdrLevels)
            driftTarget = rdrLevels(driftIdx);
            if max(maxResidualDriftRatioForPlotPROCLISTC2) >= driftTarget
                [driftSorted, idx] = sort(maxResidualDriftRatioForPlotPROCLISTC2);
                saSorted = saLevelsForIDAPlotPROCLISTC2(idx);
                [driftUniq, uIdx] = unique(driftSorted, 'first');
                saUniq = saSorted(uIdx);
                saValsAtTargetDriftAllComp(pdfIndex, driftIdx) = interp1(driftUniq, saUniq, driftTarget);
            end
        end
        pdfIndex = pdfIndex + 1;
    end
    if strcmp(plotType, 'PFA_PDF')
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
    end

    %%%%%%%%%%%%% END: Loop for component 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
   %%%%%%%%%%%%%% START: Find controlling component %%%%%%%%%%%%%%%%%%%%%%%%%%
    if(collapseLevelCompTwo > collapseLevelCompOne)
        temp = sprintf('EQ: %d - component 1 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompOne);
        disp(temp);
        figure(figureNumControlComp);
        if isConvertToSaKircher == 0
            if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                plot(maxDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1, markerTypeLine, 'Color', lineColor);
            elseif strcmp(plotType, 'RDR_PDF')
                plot(maxResidualDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1, markerTypeLine, 'Color', lineColor);
            elseif strcmp(plotType, 'PFA_PDF')
                plot(maxPFAForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1, markerTypeLine, 'Color', lineColor);
            end
        else
            if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                plot(maxDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
            elseif strcmp(plotType, 'RDR_PDF')
                plot(maxResidualDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
            elseif strcmp(plotType, 'PFA_PDF')
                plot(maxPFAForPlotPROCLISTC1, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
            end
        end
        if isPlotIndividualPoints == 1
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
                hold on
                if isConvertToSaKircher == 0
                    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                        plot(maxDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot, 'Color', lineColor);
                    elseif strcmp(plotType, 'RDR_PDF')
                        plot(maxResidualDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot, 'Color', lineColor);
                    elseif strcmp(plotType, 'PFA_PDF')
                        plot(maxPFAForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot, 'Color', lineColor);
                    end
                else
                    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                        plot(maxDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                    elseif strcmp(plotType, 'RDR_PDF')
                        plot(maxResidualDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                    elseif strcmp(plotType, 'PFA_PDF')
                        plot(maxPFAForPlotPROCLISTC1(i), saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                    end
                end
            end
        end
        collapseLevelForAllControlComp(eqInd) = collapseLevelCompOne;
        maxDriftRatioAtCollapseForControlComp(eqInd) = maxDriftRatioForPlotPROCLISTC1(indexAtCollapseC1-1);
        % Added by Shivakumar KS on 25-Sep-2026 - RDR/PFA specific collapse tracking
        if strcmp(plotType, 'RDR_PDF')
            maxResidualDriftAtCollapseForControlComp(eqInd) = maxResidualDriftRatioForPlotPROCLISTC1(indexAtCollapseC1-1);
        end
        if strcmp(plotType, 'PFA_PDF')
            maxPFAAtCollapseForControlComp(eqInd) = maxPFAForPlotPROCLISTC1(indexAtCollapseC1-1);
        end
        ControllingCompNumLIST = [ControllingCompNumLIST (eqNumber*10+1)];
        % Added by Shivakumar KS on 25-Sep-2026
        if strcmp(plotType, 'MIDR_PDF')
            saValsAtTargetDriftControlComp(eqInd,:) = saValsAtTargetDriftAllComp(2*eqInd-1, :);
        end
        if strcmp(plotType, 'RDR_PDF')
            saValsAtTargetDriftControlComp(eqInd,:) = saValsAtTargetDriftAllComp(2*eqInd-1, :);
        end
        if strcmp(plotType, 'PFA_PDF')
            saValsAtTargetPFAControlComp(eqInd,:) = saValsAtTargetPFAAllComp(2*eqInd-1, :);
        end

    else
        temp = sprintf('EQ: %d - component 2 controls, SaCollapse = %0.2f', eqNumber, collapseLevelCompTwo);
        disp(temp);
        figure(figureNumControlComp);
        if isConvertToSaKircher == 0
            if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                plot(maxDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2, markerTypeLine, 'Color', lineColor);
            elseif strcmp(plotType, 'RDR_PDF')
                plot(maxResidualDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2, markerTypeLine, 'Color', lineColor);
            elseif strcmp(plotType, 'PFA_PDF')
                plot(maxPFAForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2, markerTypeLine, 'Color', lineColor);
            end
        else
            if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                plot(maxDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
            elseif strcmp(plotType, 'RDR_PDF')
                plot(maxResidualDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
            elseif strcmp(plotType, 'PFA_PDF')
                plot(maxPFAForPlotPROCLISTC2, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine, 'Color', lineColor);
            end
        end
        if isPlotIndividualPoints == 1
            for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
                hold on
                if isConvertToSaKircher == 0
                    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                        plot(maxDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot, 'Color', lineColor);
                    elseif strcmp(plotType, 'RDR_PDF')
                        plot(maxResidualDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot, 'Color', lineColor);
                    elseif strcmp(plotType, 'PFA_PDF')
                        plot(maxPFAForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot, 'Color', lineColor);
                    end
                else
                    if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
                        plot(maxDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                    elseif strcmp(plotType, 'RDR_PDF')
                        plot(maxResidualDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                    elseif strcmp(plotType, 'PFA_PDF')
                        plot(maxPFAForPlotPROCLISTC2(i), saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot, 'Color', lineColor);
                    end
                end
            end
        end
        collapseLevelForAllControlComp(eqInd) = collapseLevelCompTwo;
        maxDriftRatioAtCollapseForControlComp(eqInd) = maxDriftRatioForPlotPROCLISTC2(indexAtCollapseC2-1);
        % Added by Shivakumar KS on 25-Sep-2026 - RDR/PFA specific collapse tracking
        if strcmp(plotType, 'RDR_PDF')
            maxResidualDriftAtCollapseForControlComp(eqInd) = maxResidualDriftRatioForPlotPROCLISTC2(indexAtCollapseC2-1);
        end
        if strcmp(plotType, 'PFA_PDF')
            maxPFAAtCollapseForControlComp(eqInd) = maxPFAForPlotPROCLISTC2(indexAtCollapseC2-1);
        end
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+2)];
        % Added by Shivakumar KS on 25-Sep-2026
        if strcmp(plotType, 'MIDR_PDF')
            saValsAtTargetDriftControlComp(eqInd,:) = saValsAtTargetDriftAllComp(2*eqInd, :);
        end
        if strcmp(plotType, 'RDR_PDF')
            saValsAtTargetDriftControlComp(eqInd,:) = saValsAtTargetDriftAllComp(2*eqInd, :);
        end
        if strcmp(plotType, 'PFA_PDF')
            saValsAtTargetPFAControlComp(eqInd,:) = saValsAtTargetPFAAllComp(2*eqInd, :);
        end
    end

    clear maxDriftRatioForPlotPROCLISTC1 saLevelsForIDAPlotPROCLISTC1 ...
          maxResidualDriftRatioForPlotPROCLISTC1 maxPFAForPlotPROCLISTC1 ...
          maxDriftRatioForPlotPROCLISTC2 saLevelsForIDAPlotPROCLISTC2 ...
          maxResidualDriftRatioForPlotPROCLISTC2 maxPFAForPlotPROCLISTC2 ...
          saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec ...
          indexAtCollapseC1 indexAtCollapseC2;

end   % end EQ loop
    

% Sa,Kircher conversion - identical to original
if isConvertToSaKircher == 1
    for eqInd = 1:(length(eqCompNumberLIST))
        eqCompNumber = eqCompNumberLIST(eqInd);
        eqNumber = floor(eqCompNumber/10);
        saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
        saGeoMeanAtTOne   = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
        collapseLevelForAllComp(eqInd) = collapseLevelForAllComp(eqInd) * (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
    end
    for eqInd = 1:(length(eqNumberLIST))
        eqNumber = eqNumberLIST(eqInd);
        eqCompNumber = eqNumber * 10.0 + 1.0;
        saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
        saGeoMeanAtTOne   = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
        collapseLevelForAllControlComp(eqInd) = collapseLevelForAllControlComp(eqInd) * (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
    end
    clear saGeoMeanAtOneSec saGeoMeanAtTOne
end

% Collapse statistics - identical to original
meanCollapseSaTOneAllComp        = mean(collapseLevelForAllComp);
medianCollapseSaTOneAllComp      = median(collapseLevelForAllComp);
meanLnCollapseSaTOneAllComp      = mean(log(collapseLevelForAllComp));
stDevCollapseSaTOneAllComp       = std(collapseLevelForAllComp);
stDevLnCollapseSaTOneAllComp     = std(log(collapseLevelForAllComp));
meanCollapseSaTOneControlComp    = mean(collapseLevelForAllControlComp);
medianCollapseSaTOneControlComp  = median(collapseLevelForAllControlComp);
meanLnCollapseSaTOneControlComp  = mean(log(collapseLevelForAllControlComp));
stDevCollapseSaTOneControlComp   = std(collapseLevelForAllControlComp);
stDevLnCollapseSaTOneControlComp = std(log(collapseLevelForAllControlComp));

% Added by Shivakumar KS on 25-Sep-2026 - RDR/PFA specific statistics
if strcmp(plotType, 'RDR_PDF')
    meanResidualDriftAtCollapseAllComp       = mean(maxResidualDriftAtCollapseForAllComp);
    medianResidualDriftAtCollapseAllComp     = median(maxResidualDriftAtCollapseForAllComp);
    stDevResidualDriftAtCollapseAllComp      = std(maxResidualDriftAtCollapseForAllComp);
    meanResidualDriftAtCollapseControlComp   = mean(maxResidualDriftAtCollapseForControlComp);
    medianResidualDriftAtCollapseControlComp = median(maxResidualDriftAtCollapseForControlComp);
    stDevResidualDriftAtCollapseControlComp  = std(maxResidualDriftAtCollapseForControlComp);
end
if strcmp(plotType, 'PFA_PDF')
    meanPFAAtCollapseAllComp       = mean(maxPFAAtCollapseForAllComp);
    medianPFAAtCollapseAllComp     = median(maxPFAAtCollapseForAllComp);
    stDevPFAAtCollapseAllComp      = std(maxPFAAtCollapseForAllComp);
    meanPFAAtCollapseControlComp   = mean(maxPFAAtCollapseForControlComp);
    medianPFAAtCollapseControlComp = median(maxPFAAtCollapseForControlComp);
    stDevPFAAtCollapseControlComp  = std(maxPFAAtCollapseForControlComp);
end

% Save collapse results file - single unified file accumulating all plotTypes
% Added by Shivakumar KS on 25-Sep-2026
cd(fullfile('..', 'Output'));
analysisTypeFolder = sprintf('%s', analysisType);
cd(analysisTypeFolder);

if isConvertToSaKircher == 0
    colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', eqListForCollapseIDAs_Name);
else
    colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63.mat', eqListForCollapseIDAs_Name);
end

% MIDR - first run, creates the file with all common variables
% Common variables are identical across all plotTypes (collapse always defined by max drift)
if strcmp(plotType, 'MIDR')
    save(colFileName, 'analysisType', 'eqNumberLIST', 'eqCompNumberLIST', ...
        'ControllingCompNumLIST', 'periodUsedForScalingGroundMotions', ...
        'collapseLevelForAllComp', 'collapseLevelForAllControlComp', ...
        'maxDriftRatioAtCollapseForAllComp', 'maxDriftRatioAtCollapseForControlComp', ...
        'meanCollapseSaTOneAllComp', 'medianCollapseSaTOneAllComp', 'meanLnCollapseSaTOneAllComp', ...
        'stDevCollapseSaTOneAllComp', 'stDevLnCollapseSaTOneAllComp', ...
        'meanCollapseSaTOneControlComp', 'medianCollapseSaTOneControlComp', ...
        'meanLnCollapseSaTOneControlComp', 'stDevCollapseSaTOneControlComp', ...
        'stDevLnCollapseSaTOneControlComp');
end

% MIDR_PDF - appends nothing new, collapse stats identical to MIDR
% RDR_PDF - appends RDR specific variables only
if strcmp(plotType, 'RDR_PDF')
    save(colFileName, ...
        'maxResidualDriftAtCollapseForAllComp', 'maxResidualDriftAtCollapseForControlComp', ...
        'meanResidualDriftAtCollapseAllComp', 'medianResidualDriftAtCollapseAllComp', ...
        'stDevResidualDriftAtCollapseAllComp', 'meanResidualDriftAtCollapseControlComp', ...
        'medianResidualDriftAtCollapseControlComp', 'stDevResidualDriftAtCollapseControlComp', '-append');
end

% PFA_PDF - appends PFA specific variables only
if strcmp(plotType, 'PFA_PDF')
    save(colFileName, ...
        'maxPFAAtCollapseForAllComp', 'maxPFAAtCollapseForControlComp', ...
        'meanPFAAtCollapseAllComp', 'medianPFAAtCollapseAllComp', ...
        'stDevPFAAtCollapseAllComp', 'meanPFAAtCollapseControlComp', ...
        'medianPFAAtCollapseControlComp', 'stDevPFAAtCollapseControlComp', '-append');
end


%% Final plot details - figure for all components - identical to original for MIDR
%  Added by Shivakumar KS on 25-Sep-2026: PDF overlay block + RDR/PFA axis labels

% Added: PDF overlay on figure 1 (all components)
if strcmp(plotType, 'MIDR_PDF') || strcmp(plotType, 'RDR_PDF') || strcmp(plotType, 'PFA_PDF')
    figure(figureNumAllComp);
    hold on;
    if strcmp(plotType, 'MIDR_PDF')
        saValsForFig1 = saValsAtTargetDriftAllComp;
        levelValsForPlot = midrLevels;
        levelLabelsForPlot = midrLevelLabels;
        scaleFactor = maxXOnAxis * 0.06;
        colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
    elseif strcmp(plotType, 'RDR_PDF')
        saValsForFig1 = saValsAtTargetDriftAllComp;
        levelValsForPlot = rdrLevels;
        levelLabelsForPlot = rdrLevelLabels;
        if isfield(idaInputs, 'maxXOnAxis_RDR'), maxXOnAxis = idaInputs.maxXOnAxis_RDR; else, maxXOnAxis = 2; end
        scaleFactor = maxXOnAxis * 0.06;
        colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
    elseif strcmp(plotType, 'PFA_PDF')
        saValsForFig1 = saValsAtTargetPFAAllComp;
        levelValsForPlot = pfaLevels;
        levelLabelsForPlot = pfaLevelLabels;
        if isfield(idaInputs, 'maxXOnAxis_PFA'), maxXOnAxis = idaInputs.maxXOnAxis_PFA; else, maxXOnAxis = 2.0; end
        scaleFactor = maxXOnAxis * 0.06;
        colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
    end

    hDriftLines = gobjects(length(levelValsForPlot), 1);
    for driftIdx = 1:length(levelValsForPlot)
        if strcmp(plotType, 'PFA_PDF')
            targetDrift = levelValsForPlot(driftIdx);
        else
            targetDrift = levelValsForPlot(driftIdx) * 100;
        end
        SaVals = saValsForFig1(:, driftIdx);
        SaVals = SaVals(isfinite(SaVals) & SaVals > 0);
        if numel(SaVals) < 2, continue; end
        muLn = mean(log(SaVals));
        sigmaLn = std(log(SaVals));
        Sa16 = exp(muLn - sigmaLn);
        Sa50 = exp(muLn);
        Sa84 = exp(muLn + sigmaLn);
        Sa_neg3 = exp(muLn - 3*sigmaLn);
        Sa_pos3 = exp(muLn + 3*sigmaLn);
        hDriftLines(driftIdx) = plot([targetDrift targetDrift], [Sa16 Sa84], ...
            '-', 'LineWidth', 3.0, 'Color', colors(driftIdx,:), 'DisplayName', levelLabelsForPlot{driftIdx});
        plot(targetDrift, Sa50, 'o', 'MarkerFaceColor', colors(driftIdx,:), ...
            'MarkerEdgeColor', colors(driftIdx,:), 'HandleVisibility', 'off');
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
            saSeg  = segments{s};
            pdfSeg = pdfSegs{s};
            if numel(saSeg) < 2, continue; end
            x_pdf = [targetDrift * ones(1,length(saSeg)), targetDrift - pdfSeg(end:-1:1)];
            y_pdf = [saSeg, saSeg(end:-1:1)];
            if isFilled(s)
                patch(x_pdf, y_pdf, colors(driftIdx,:), 'FaceAlpha', 0.30, ...
                    'EdgeColor', colors(driftIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
            else
                patch(x_pdf, y_pdf, colors(driftIdx,:), 'FaceColor', 'none', ...
                    'EdgeColor', colors(driftIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
            end
        end
    end
    validIdx = isgraphics(hDriftLines);
    if any(validIdx)
        legend(hDriftLines(validIdx), levelLabelsForPlot(validIdx), 'Location', 'southeast', 'AutoUpdate', 'off');
    end
end

figure(figureNumAllComp)
hold on
grid on
if isConvertToSaKircher == 0
    titleTemp = sprintf('$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
else
    titleTemp = axisLabelForSaKircher;
end
ylabel(titleTemp, 'Interpreter', 'latex');
% Added by Shivakumar KS on 25-Sep-2026 - x label differs by plotType
if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
    xlabel('$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$', 'Interpreter', 'latex');
    xlim([0, maxXOnAxis])
elseif strcmp(plotType, 'RDR_PDF')
    xlabel('$\mathrm{Max\ Interstory\ Residual\ Drift\ Ratio\ (\%)}$', 'Interpreter', 'latex');
    if isfield(idaInputs, 'maxXOnAxis_RDR'), xlim([0, idaInputs.maxXOnAxis_RDR]); else, xlim([0, 2]); end
    if isfield(idaInputs, 'maxYOnAxis_RDR'), ylim([0, idaInputs.maxYOnAxis_RDR]); else, ylim([0, 5]); end
elseif strcmp(plotType, 'PFA_PDF')
    xlabel('$\mathrm{Peak\ Floor\ Acceleration\ (g)}$', 'Interpreter', 'latex');
    if isfield(idaInputs, 'maxXOnAxis_PFA'), xlim([0, idaInputs.maxXOnAxis_PFA]); else, xlim([0, 2]); end
    if isfield(idaInputs, 'maxYOnAxis_PFA'), ylim([0, idaInputs.maxYOnAxis_PFA]); else, ylim([0, 4]); end
end
sks_figureFormat(formatMode)
if isConvertToSaKircher == 0
    if strcmp(plotType, 'MIDR')
        exportName = sprintf('CollapseIDA_AllComp_SaGeoMean');
    elseif strcmp(plotType, 'MIDR_PDF')
        exportName = sprintf('CollapseIDA_AllComp_SaGeoMean_MIDR_PDF');
    elseif strcmp(plotType, 'RDR_PDF')
        exportName = sprintf('CollapseIDA_AllComp_SaGeoMean_RDR_PDF');
    elseif strcmp(plotType, 'PFA_PDF')
        exportName = sprintf('CollapseIDA_AllComp_SaGeoMean_PFA_PDF');
    end
else
    if strcmp(plotType, 'MIDR')
        exportName = sprintf('CollapseIDA_AllComp_SaATC63');
    elseif strcmp(plotType, 'MIDR_PDF')
        exportName = sprintf('CollapseIDA_AllComp_SaATC63_MIDR_PDF');
    elseif strcmp(plotType, 'RDR_PDF')
        exportName = sprintf('CollapseIDA_AllComp_SaATC63_RDR_PDF');
    elseif strcmp(plotType, 'PFA_PDF')
        exportName = sprintf('CollapseIDA_AllComp_SaATC63_PFA_PDF');
    end
end
sks_figureExport(exportName)
hold off


% Added: PDF overlay on figure 2 (controlling component)
if strcmp(plotType, 'MIDR_PDF') || strcmp(plotType, 'RDR_PDF') || strcmp(plotType, 'PFA_PDF')
    figure(figureNumControlComp);
    hold on;
    if strcmp(plotType, 'MIDR_PDF')
        saValsForFig2 = saValsAtTargetDriftControlComp;
        levelValsForPlot = midrLevels;
        levelLabelsForPlot = midrLevelLabels;
        scaleFactor = maxXOnAxis * 0.06;
        colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
    elseif strcmp(plotType, 'RDR_PDF')
        saValsForFig2 = saValsAtTargetDriftControlComp;
        levelValsForPlot = rdrLevels;
        levelLabelsForPlot = rdrLevelLabels;
        if isfield(idaInputs, 'maxXOnAxis_RDR'), maxXOnAxis = idaInputs.maxXOnAxis_RDR; else, maxXOnAxis = 2; end
        scaleFactor = maxXOnAxis * 0.06;
        colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
    elseif strcmp(plotType, 'PFA_PDF')
        saValsForFig2 = saValsAtTargetPFAControlComp;
        levelValsForPlot = pfaLevels;
        levelLabelsForPlot = pfaLevelLabels;
        if isfield(idaInputs, 'maxXOnAxis_PFA'), maxXOnAxis = idaInputs.maxXOnAxis_PFA; else, maxXOnAxis = 2.0; end
        scaleFactor = maxXOnAxis * 0.06;
        colors = [0.00 0.00 1.00; 1.00 0.00 1.00; 0.00 0.00 0.00; 1.00 0.00 0.00];
    end

    hDriftLines = gobjects(length(levelValsForPlot), 1);
    for driftIdx = 1:length(levelValsForPlot)
        if strcmp(plotType, 'PFA_PDF')
            targetDrift = levelValsForPlot(driftIdx);
        else
            targetDrift = levelValsForPlot(driftIdx) * 100;
        end
        SaVals = saValsForFig2(:, driftIdx);
        SaVals = SaVals(isfinite(SaVals) & SaVals > 0);
        if numel(SaVals) < 2, continue; end
        muLn = mean(log(SaVals));
        sigmaLn = std(log(SaVals));
        Sa16 = exp(muLn - sigmaLn);
        Sa50 = exp(muLn);
        Sa84 = exp(muLn + sigmaLn);
        Sa_neg3 = exp(muLn - 3*sigmaLn);
        Sa_pos3 = exp(muLn + 3*sigmaLn);
        hDriftLines(driftIdx) = plot([targetDrift targetDrift], [Sa16 Sa84], ...
            '-', 'LineWidth', 3.0, 'Color', colors(driftIdx,:), 'DisplayName', levelLabelsForPlot{driftIdx});
        plot(targetDrift, Sa50, 'o', 'MarkerFaceColor', colors(driftIdx,:), ...
            'MarkerEdgeColor', colors(driftIdx,:), 'HandleVisibility', 'off');
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
            saSeg  = segments{s};
            pdfSeg = pdfSegs{s};
            if numel(saSeg) < 2, continue; end
            x_pdf = [targetDrift * ones(1,length(saSeg)), targetDrift - pdfSeg(end:-1:1)];
            y_pdf = [saSeg, saSeg(end:-1:1)];
            if isFilled(s)
                patch(x_pdf, y_pdf, colors(driftIdx,:), 'FaceAlpha', 0.30, ...
                    'EdgeColor', colors(driftIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
            else
                patch(x_pdf, y_pdf, colors(driftIdx,:), 'FaceColor', 'none', ...
                    'EdgeColor', colors(driftIdx,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');
            end
        end
    end
    validIdx = isgraphics(hDriftLines);
    if any(validIdx)
        legend(hDriftLines(validIdx), levelLabelsForPlot(validIdx), 'Location', 'southeast', 'AutoUpdate', 'off');
    end
end

figure(figureNumControlComp);
hold on
grid on
if isConvertToSaKircher == 0
    titleTemp = sprintf('$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T}_{1} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
else
    titleTemp = axisLabelForSaKircher;
end
ylabel(titleTemp, 'Interpreter', 'latex');
if strcmp(plotType, 'MIDR') || strcmp(plotType, 'MIDR_PDF')
    xlabel('$\mathrm{Max\ Interstory\ Drift\ Ratio\ (\%)}$', 'Interpreter', 'latex');
    xlim([0, maxXOnAxis])
elseif strcmp(plotType, 'RDR_PDF')
    xlabel('$\mathrm{Max\ Interstory\ Residual\ Drift\ Ratio\ (\%)}$', 'Interpreter', 'latex');
    if isfield(idaInputs, 'maxXOnAxis_RDR'), xlim([0, idaInputs.maxXOnAxis_RDR]); else, xlim([0, 2]); end
    if isfield(idaInputs, 'maxYOnAxis_RDR'), ylim([0, idaInputs.maxYOnAxis_RDR]); else, ylim([0, 5]); end
elseif strcmp(plotType, 'PFA_PDF')
    xlabel('$\mathrm{Peak\ Floor\ Acceleration\ (g)}$', 'Interpreter', 'latex');
    if isfield(idaInputs, 'maxXOnAxis_PFA'), xlim([0, idaInputs.maxXOnAxis_PFA]); else, xlim([0, 2]); end
    if isfield(idaInputs, 'maxYOnAxis_PFA'), ylim([0, idaInputs.maxYOnAxis_PFA]); else, ylim([0, 4]); end
end
sks_figureFormat(formatMode)
if isConvertToSaKircher == 0
    if strcmp(plotType, 'MIDR')
        exportName = sprintf('CollapseIDA_ControlComp_SaGeoMean');
    elseif strcmp(plotType, 'MIDR_PDF')
        exportName = sprintf('CollapseIDA_ControlComp_SaGeoMean_MIDR_PDF');
    elseif strcmp(plotType, 'RDR_PDF')
        exportName = sprintf('CollapseIDA_ControlComp_SaGeoMean_RDR_PDF');
    elseif strcmp(plotType, 'PFA_PDF')
        exportName = sprintf('CollapseIDA_ControlComp_SaGeoMean_PFA_PDF');
    end
else
    if strcmp(plotType, 'MIDR')
        exportName = sprintf('CollapseIDA_ControlComp_SaATC63');
    elseif strcmp(plotType, 'MIDR_PDF')
        exportName = sprintf('CollapseIDA_ControlComp_SaATC63_MIDR_PDF');
    elseif strcmp(plotType, 'RDR_PDF')
        exportName = sprintf('CollapseIDA_ControlComp_SaATC63_RDR_PDF');
    elseif strcmp(plotType, 'PFA_PDF')
        exportName = sprintf('CollapseIDA_ControlComp_SaATC63_PFA_PDF');
    end
end
sks_figureExport(exportName)
hold off

cd(fullfile('..', '..', 'psb_MatlabProcessors'));

%% Added by Shivakumar KS on 25-Sep-2026 - Fragility function block
% Only for MIDR_PDF, RDR_PDF, PFA_PDF - not for plain MIDR
if strcmp(plotType, 'MIDR_PDF') || strcmp(plotType, 'RDR_PDF') || strcmp(plotType, 'PFA_PDF')

    cd(fullfile('..', 'Output'));
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);

    if strcmp(plotType, 'MIDR_PDF')
        numLimitStates = length(midrLevels);
        saValsControl  = saValsAtTargetDriftControlComp;
        saValsAll      = saValsAtTargetDriftAllComp;
    elseif strcmp(plotType, 'RDR_PDF')
        numLimitStates = length(rdrLevels);
        saValsControl  = saValsAtTargetDriftControlComp;
        saValsAll      = saValsAtTargetDriftAllComp;
    elseif strcmp(plotType, 'PFA_PDF')
        numLimitStates = length(pfaLevels);
        saValsControl  = saValsAtTargetPFAControlComp;
        saValsAll      = saValsAtTargetPFAAllComp;
    end

    meanLnSaVals         = nan(1, numLimitStates);
    stDevLnSaVals        = nan(1, numLimitStates);
    meanLnSaValsAllComp  = nan(1, numLimitStates);
    stDevLnSaValsAllComp = nan(1, numLimitStates);

    for limitStateIdx = 1:numLimitStates
        SaVals = saValsControl(:, limitStateIdx);
        SaVals = SaVals(isfinite(SaVals) & SaVals > 0);
        if numel(SaVals) >= 2
            meanLnSaVals(limitStateIdx)  = mean(log(SaVals));
            stDevLnSaVals(limitStateIdx) = std(log(SaVals));
        end
        SaVals = saValsAll(:, limitStateIdx);
        SaVals = SaVals(isfinite(SaVals) & SaVals > 0);
        if numel(SaVals) >= 2
            meanLnSaValsAllComp(limitStateIdx)  = mean(log(SaVals));
            stDevLnSaValsAllComp(limitStateIdx) = std(log(SaVals));
        end
    end

    % Single unified fragility file - accumulates all plotTypes
    if isConvertToSaKircher == 0
        fragFileName = sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', eqListForCollapseIDAs_Name);
    else
        fragFileName = sprintf('DATA_FragilityParams_SaATC63_%s.mat', eqListForCollapseIDAs_Name);
    end

    % MIDR_PDF - creates the file
    if strcmp(plotType, 'MIDR_PDF')
        save(fragFileName, 'midrLevels', 'midrLevelLabels', ...
            'meanLnSaVals', 'stDevLnSaVals', 'saValsControl', ...
            'meanLnSaValsAllComp', 'stDevLnSaValsAllComp', 'saValsAll');
    end

    % RDR_PDF - appends RDR specific variables
    if strcmp(plotType, 'RDR_PDF')
        rdrMeanLnSaVals         = meanLnSaVals;
        rdrStDevLnSaVals        = stDevLnSaVals;
        rdrSaValsControl        = saValsControl;
        rdrMeanLnSaValsAllComp  = meanLnSaValsAllComp;
        rdrStDevLnSaValsAllComp = stDevLnSaValsAllComp;
        rdrSaValsAll            = saValsAll;
        save(fragFileName, 'rdrLevels', 'rdrLevelLabels', ...
            'rdrMeanLnSaVals', 'rdrStDevLnSaVals', 'rdrSaValsControl', ...
            'rdrMeanLnSaValsAllComp', 'rdrStDevLnSaValsAllComp', 'rdrSaValsAll', '-append');
    end

    % PFA_PDF - appends PFA specific variables
    if strcmp(plotType, 'PFA_PDF')
        pfaMeanLnSaVals         = meanLnSaVals;
        pfaStDevLnSaVals        = stDevLnSaVals;
        pfaSaValsControl        = saValsControl;
        pfaMeanLnSaValsAllComp  = meanLnSaValsAllComp;
        pfaStDevLnSaValsAllComp = stDevLnSaValsAllComp;
        pfaSaValsAll            = saValsAll;
        save(fragFileName, 'pfaLevels', 'pfaLevelLabels', ...
            'pfaMeanLnSaVals', 'pfaStDevLnSaVals', 'pfaSaValsControl', ...
            'pfaMeanLnSaValsAllComp', 'pfaStDevLnSaValsAllComp', 'pfaSaValsAll', '-append');
    end

    cd(fullfile('..', '..', 'psb_MatlabProcessors'));
end

end