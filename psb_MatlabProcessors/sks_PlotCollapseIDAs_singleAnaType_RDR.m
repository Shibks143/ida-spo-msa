%
% Procedure: sks_PlotCollapseIDAs_RDR.m
% -------------------
% This procedure mirrors PlotCollapseIDAs_singleAnaType.m, but plots
% Residual Interstory Drift Ratio (RDR) vs Sa(T1) instead of Max Drift
% Ratio vs Sa(T1).
%
% IMPORTANT DESIGN NOTE:
%   Collapse is NOT redefined using an RDR threshold. Collapse Sa level
%   is still determined from MAX DRIFT crossing collapseDriftThreshold,
%   exactly as in PlotCollapseIDAs_singleAnaType.m - this preserves a
%   single, consistent collapse definition across all plots. This script
%   only changes WHICH quantity is plotted on the x-axis (RDR instead of
%   max drift), and additionally reports the residual drift value AT the
%   already-established collapse point.
%
% Requires: DATA_collapseIDAPlotDataForThisEQ.mat to contain
%   'maxResidualDriftRatioForPlotLIST' (added via the updated
%   Prak_saveDATA_Collapse.m / Prak_ProcessMultipleCollapseRuns_Generalized_withGD.m)
%
% ADDED 15-Sep-2026: Fragility Functions block (compute + save only, for
% Control + All Comp), mirroring the block in
% sks_PlotCollapseIDAsPDF_singleAnaType.m. This saves
% DATA_FragilityParams_SaGeoMean_<name>_RDR.mat (or _SaATC63_..._RDR.mat)
% so that PlotCollapseEmpiricalCDFWithFits_allRDR_proc.m has something to load.
%
% Author: [shivakuamr K S] - adapted from PlotCollapseIDAs_singleAnaType.m (Curt Haselton)
% Date Written: 13-Sep-2026
% -------------------

function[void] = sks_PlotCollapseIDAs_singleAnaType_RDR(idaInputs)

eqSpectraFolder =                 idaInputs.eqSpectraFolder;
analysisType =                    idaInputs.analysisType;
eqListForCollapseIDAs_Name =      idaInputs.eqListForCollapseIDAs_Name;
markerTypeLine =                  idaInputs.markerTypeLine;
markerTypeDot =                   idaInputs.markerTypeDot;
isPlotIndividualPoints =          idaInputs.isPlotIndividualPoints;
collapseDriftThreshold =          idaInputs.collapseDriftThreshold;
isConvertToSaKircher =            idaInputs.isConvertToSaKircher;
eqNumberLIST =                    idaInputs.eqNumberLIST_forCollapseIDAs;
formatMode =                      idaInputs.formatMode;
dampRat =                         idaInputs.dampingRatioUsedForSaDef;

% Optional RDR-specific inputs, with sensible defaults if not provided
if(isfield(idaInputs, 'maxXOnAxis_RDR'))
    maxXOnAxis = idaInputs.maxXOnAxis_RDR;
else
    maxXOnAxis = 2;   % % CHANGED: was 0.02 (fraction) -> now 2.0 %
end
% Width of PDF shape on the RDR x-axis, in percent
scaleFactor = maxXOnAxis * 0.06;

if(isfield(idaInputs, 'maxYOnAxis_RDR'))
    maxYOnAxis = idaInputs.maxYOnAxis_RDR;
else
    maxYOnAxis = 5;
end



if(isfield(idaInputs, 'rdrPerformanceThresholds'))
    rdrPerformanceThresholds = idaInputs.rdrPerformanceThresholds;   % e.g. [0.002 0.005 0.01 0.02]
else
    rdrPerformanceThresholds = [];   % none plotted if not specified
end

if(isfield(idaInputs, 'rdrLevels'))
    rdrLevels = idaInputs.rdrLevels;
else
    rdrLevels = [0.002 0.005 0.01 0.02];   % IO, LS, CP, Collapse - 
end

if(isfield(idaInputs, 'rdrLevelLabels'))
    rdrLevelLabels = idaInputs.rdrLevelLabels;
else
    rdrLevelLabels = {'IO', 'LS', 'CP', 'Collapse'};
end

colors = [
    0.93 0.69 0.13   % IO   - orange/gold
    1.00 0.00 0.00   % LS   - red
    0.00 0.00 0.00   % CP   - black
    1.00 0.00 1.00   % Collapse - magenta
    ];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This does RDR-based collapse IDAs for a single analysisType
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the file that defines the relationship between Sa,geoMean and Sa,Kircher at 1sec.
DefineSaKircherOverSaGeoMeanValues

figureNumAllComp = 1;           % RDR plot of results for all components
figureNumControllingComp = 2;   % RDR plot of results for only controlling components
ControllingCompNumLIST = [];
figure(figureNumAllComp); clf; hold on;
figure(figureNumControllingComp); clf; hold on;

% Initialize vectors - twice as long as eqNumberLIST b/c two comp. per EQ
collapseLevelForAllComp = zeros(1,(2.0*length(eqNumberLIST)));
collapseLevelForAllControlComp = zeros(1,(length(eqNumberLIST)));
maxResidualDriftAtCollapseForAllComp = zeros(1,(2.0*length(eqNumberLIST)));          % NEW - RDR-specific
maxResidualDriftAtCollapseForControlComp = zeros(1,(length(eqNumberLIST)));          % NEW - RDR-specific
eqCompNumberLIST = zeros(1,(2.0*length(eqNumberLIST)));
eqCompInd = 1;

saValsAtTargetDriftAllComp = nan(2*length(eqNumberLIST), length(rdrLevels));
saValsAtTargetDriftControlComp = nan(length(eqNumberLIST), length(rdrLevels));
pdfIndex = 1;

for eqInd = 1:(length(eqNumberLIST))
    eqNumber = eqNumberLIST(eqInd);

    %%%%%%%%%%%%% START: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eqCompNumber = eqNumber * 10.0 + 1.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

    % Go to the correct folder
        cd ..;
        cd Output;
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        eqFolder = sprintf('EQ_%.0f', eqCompNumber);
        cd(eqFolder)

    % Open the file that has the collapse data (now contains maxResidualDriftRatioForPlotLIST too)
        load('DATA_collapseIDAPlotDataForThisEQ.mat');
        load('DATA_CollapseResultsForThisSingleEQ.mat', 'toleranceAchieved', 'periodUsedForScalingGroundMotions');

    % Process the vectors to remove results for singular/non-converged, non-collapsed records
    % Build BOTH the max-drift filtered list (needed to find collapse point)
    % AND the RDR filtered list (what we actually plot), using the SAME
    % subLoopIndex so the two stay aligned point-for-point.
        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
                % Skip - not converged/singular and not collapsed
            else
                maxDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
                maxResidualDriftRatioForPlotPROCLISTC1(subLoopIndex) = maxResidualDriftRatioForPlotLIST(loopIndex);  
                saLevelsForIDAPlotPROCLISTC1(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end
        end

    % Plot RDR (not max drift) - note that Sa conversion logic is unchanged
        figure(figureNumAllComp);

        if(isConvertToSaKircher == 0)
            plot(maxResidualDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1, markerTypeLine);
        else
            saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
            saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
            saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC1.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
            plot(maxResidualDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine);
            clear saGeoMeanAtOneSec saGeoMeanAtTOne
        end

        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
                hold on
                if(isConvertToSaKircher == 0)
                    plot(maxResidualDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot);
                else
                    plot(maxResidualDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot);
                end
            end
        end

    % Find the collapse Sa level for the component - using MAX DRIFT, exactly
    % as in PlotCollapseIDAs_singleAnaType.m (collapse definition unchanged)
        for index = 1:length(maxDriftRatioForPlotPROCLISTC1)
            if(maxDriftRatioForPlotPROCLISTC1(index) > collapseDriftThreshold)
                break;
            end
        end

        if(max(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1))) < 15.0)
            collapseLevelCompOne = (saLevelsForIDAPlotPROCLISTC1(index) + saLevelsForIDAPlotPROCLISTC1(index - 1)) / 2.0;
        else
            disp('***********************************');
            disp('******* Fixing error **************');
            disp('***********************************');
            toleranceAchieved
            collapseLevelCompOne = min(abs(saLevelsForIDAPlotPROCLISTC1(index)), abs(saLevelsForIDAPlotPROCLISTC1(index - 1)));
        end

        collapseSaLevel = collapseLevelCompOne;
        collapseLevelForAllComp(eqCompInd) = collapseLevelCompOne;

        % NEW - record the RESIDUAL drift value at the point just before collapse
        % (i.e. the last non-collapsed point processed, index-1) - this tells
        % you how much permanent damage had accumulated right before the
        % structure lost dynamic stability.
        maxResidualDriftAtCollapseForAllComp(eqCompInd) = maxResidualDriftRatioForPlotPROCLISTC1(index - 1);
        indexAtCollapseC1 = index;

    % Save a file for this EQ component (RDR-specific)
        maxResidualDriftRatioForPlotPROCLIST = maxResidualDriftRatioForPlotPROCLISTC1;
        saLevelsForIDAPlotPROCLIST = saLevelsForIDAPlotPROCLISTC1;
        eqCompColFileName = sprintf('DATA_collapse_ProcessedRDR_IDADataForThisEQ.mat');
        save(eqCompColFileName, 'analysisType', 'maxResidualDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST', 'collapseSaLevel');

        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST maxResidualDriftRatioForPlotLIST

        cd(fullfile('..', '..', '..', 'psb_MatlabProcessors'));
        eqCompInd = eqCompInd + 1;


        % %%%%%%% RDR PDF data collection - Component 1 %%%%%%%%%%%%%%%%%%%%%%
            for driftIdx = 1:length(rdrLevels)
                driftTarget = rdrLevels(driftIdx);
            
                if max(maxResidualDriftRatioForPlotPROCLISTC1) >= driftTarget
                    [driftSorted, idx] = sort(maxResidualDriftRatioForPlotPROCLISTC1);
                    saSorted = saLevelsForIDAPlotPROCLISTC1(idx);
            
                    % Remove duplicate x-values (interp1 requires unique sample points).
                    % When multiple Sa levels give the same residual drift, keep the
                    % LOWEST Sa at that drift value (first/most conservative crossing).
                    [driftUniq, uIdx] = unique(driftSorted, 'first');
                    saUniq = saSorted(uIdx);
            
                    saValsAtTargetDriftAllComp(pdfIndex, driftIdx) = interp1(driftUniq, saUniq, driftTarget);
                end
            end
        pdfIndex = pdfIndex + 1;
        % %%%%%%% End RDR PDF data collection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%% END: Loop for component 1 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%% START: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    eqCompNumber = eqNumber * 10.0 + 2.0;
    eqCompNumberLIST(eqCompInd) = eqCompNumber;

        cd ..;
        cd Output;
        analysisTypeFolder = sprintf('%s', analysisType);
        cd(analysisTypeFolder);
        eqFolder = sprintf('EQ_%.0f', eqCompNumber);
        cd(eqFolder)

        load('DATA_collapseIDAPlotDataForThisEQ.mat');

        subLoopIndex = 1;
        for loopIndex = 1:length(maxDriftRatioForPlotLIST)
            if((isCollapsedLIST(loopIndex) == 0) && (isSingularLIST(loopIndex) || isNonConvLIST(loopIndex)))
                % Skip
            else
                maxDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxDriftRatioForPlotLIST(loopIndex);
                maxResidualDriftRatioForPlotPROCLISTC2(subLoopIndex) = maxResidualDriftRatioForPlotLIST(loopIndex);   
                saLevelsForIDAPlotPROCLISTC2(subLoopIndex) = saLevelsForIDAPlotLIST(loopIndex);
                subLoopIndex = subLoopIndex + 1;
            end
        end

        figure(figureNumAllComp);
        if(isConvertToSaKircher == 0)
            plot(maxResidualDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2, markerTypeLine);
        else
            saGeoMeanAtOneSec = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, 1.0, dampRat, eqSpectraFolder);
            saGeoMeanAtTOne = psb_RetrieveSaGeoMeanValueForAnEQ(eqNumber, periodUsedForScalingGroundMotions, dampRat, eqSpectraFolder);
            saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec = saLevelsForIDAPlotPROCLISTC2.* (saGeoMeanAtOneSec/saGeoMeanAtTOne) * saKircherAtOneSecOverSaGeoMeanAtOneSec{eqCompNumber};
            plot(maxResidualDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine);
            clear saGeoMeanAtOneSec saGeoMeanAtTOne
        end

        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
                hold on
                if(isConvertToSaKircher == 0)
                    plot(maxResidualDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot);
                else
                    plot(maxResidualDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot);
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
            disp('***********************************');
            disp('******* Fixing error **************');
            disp('***********************************');
            toleranceAchieved
            collapseLevelCompTwo = min(abs(saLevelsForIDAPlotPROCLISTC2(index)), abs(saLevelsForIDAPlotPROCLISTC2(index - 1)));
        end

        collapseSaLevel = collapseLevelCompTwo;
        collapseLevelForAllComp(eqCompInd) = collapseLevelCompTwo;
        maxResidualDriftAtCollapseForAllComp(eqCompInd) = maxResidualDriftRatioForPlotPROCLISTC2(index - 1);   % NEW
        indexAtCollapseC2 = index;

        maxResidualDriftRatioForPlotPROCLIST = maxResidualDriftRatioForPlotPROCLISTC2;
        saLevelsForIDAPlotPROCLIST = saLevelsForIDAPlotPROCLISTC2;
        eqCompColFileName = sprintf('DATA_collapse_ProcessedRDR_IDADataForThisEQ.mat');
        save(eqCompColFileName, 'analysisType', 'maxResidualDriftRatioForPlotPROCLIST', 'saLevelsForIDAPlotPROCLIST', 'collapseSaLevel');

        clear maxDriftRatioForPlotLIST saLevelsForIDAPlotLIST maxResidualDriftRatioForPlotLIST

        cd(fullfile('..', '..', '..', 'psb_MatlabProcessors'));
        eqCompInd = eqCompInd + 1;

        % %%%%%%% RDR PDF data collection - Component 2 %%%%%%%%%%%%%%%%%%%%%%
        for driftIdx = 1:length(rdrLevels)
            driftTarget = rdrLevels(driftIdx);

            if max(maxResidualDriftRatioForPlotPROCLISTC2) >= driftTarget
                [driftSorted, idx] = sort(maxResidualDriftRatioForPlotPROCLISTC2);
                saSorted = saLevelsForIDAPlotPROCLISTC2(idx);

                % Remove duplicate x-values (interp1 requires unique sample points).
                % When multiple Sa levels give the same residual drift, keep the
                % LOWEST Sa at that drift value (first/most conservative crossing).
                [driftUniq, uIdx] = unique(driftSorted, 'first');
                saUniq = saSorted(uIdx);

                saValsAtTargetDriftAllComp(pdfIndex, driftIdx) = interp1(driftUniq, saUniq, driftTarget);
            end
        end
        
        pdfIndex = pdfIndex + 1;
        % %%%%%%% End RDR PDF data collection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%% END: Loop for component 2 of the EQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%% START: Find controlling component and plot its RDR curve %%%%%%%%%
    if(collapseLevelCompTwo > collapseLevelCompOne)
        temp = sprintf('EQ: %d - component 1 controls (RDR view), SaCollapse = %0.2f', eqNumber, collapseLevelCompOne);
        disp(temp);

        figure(figureNumControllingComp);
        if(isConvertToSaKircher == 0)
            plot(maxResidualDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1, markerTypeLine);
        else
            plot(maxResidualDriftRatioForPlotPROCLISTC1 * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec, markerTypeLine);
        end

        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC1)
                hold on
                if(isConvertToSaKircher == 0)
                    plot(maxResidualDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1(i), markerTypeDot);
                else
                    plot(maxResidualDriftRatioForPlotPROCLISTC1(i) * 100, saLevelsForIDAPlotPROCLISTC1_KircherAtOneSec(i), markerTypeDot);
                end
            end
        end

        collapseLevelForAllControlComp(eqInd) = collapseLevelCompOne;
        maxResidualDriftAtCollapseForControlComp(eqInd) = maxResidualDriftRatioForPlotPROCLISTC1(indexAtCollapseC1 - 1);
        % maxResidualDriftAtCollapseForControlComp(eqInd) = maxResidualDriftRatioForPlotPROCLISTC1(index - 1);   
        ControllingCompNumLIST = [ControllingCompNumLIST (eqNumber*10+1)];
        saValsAtTargetDriftControlComp(eqInd, :) = saValsAtTargetDriftAllComp(2*eqInd - 1, :); 

    else
        temp = sprintf('EQ: %d - component 2 controls (RDR view), SaCollapse = %0.2f', eqNumber, collapseLevelCompTwo);
        disp(temp);

        figure(figureNumControllingComp);
        if(isConvertToSaKircher == 0)
            plot(maxResidualDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2, markerTypeLine);
        else
            plot(maxResidualDriftRatioForPlotPROCLISTC2 * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec, markerTypeLine);
        end

        if(isPlotIndividualPoints == 1)
            for i = 1:length(saLevelsForIDAPlotPROCLISTC2)
                hold on
                if(isConvertToSaKircher == 0)
                    plot(maxResidualDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2(i), markerTypeDot);
                else
                    plot(maxResidualDriftRatioForPlotPROCLISTC2(i) * 100, saLevelsForIDAPlotPROCLISTC2_KircherAtOneSec(i), markerTypeDot);
                end
            end
        end

        collapseLevelForAllControlComp(eqInd) = collapseLevelCompTwo;
        maxResidualDriftAtCollapseForControlComp(eqInd) = maxResidualDriftRatioForPlotPROCLISTC2(indexAtCollapseC2 - 1); 
        % maxResidualDriftAtCollapseForControlComp(eqInd) = maxResidualDriftRatioForPlotPROCLISTC2(index - 1);  
        ControllingCompNumLIST = [[ControllingCompNumLIST] (eqNumber*10+2)];
        saValsAtTargetDriftControlComp(eqInd, :) = saValsAtTargetDriftAllComp(2*eqInd, :);
    end
    %%%%%%%%%%%%%% END: Find controlling component %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    clear collapseLevelCompOne collapseLevelCompTwo maxDriftRatioForPlotPROCLISTC1 maxDriftRatioForPlotPROCLISTC2 ...
        maxResidualDriftRatioForPlotPROCLISTC1 maxResidualDriftRatioForPlotPROCLISTC2 saLevelsForIDAPlotPROCLISTC1 saLevelsForIDAPlotPROCLISTC2 ...
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

% RDR-specific statistics: residual drift at the (already established) collapse point
meanResidualDriftAtCollapseAllComp = mean(maxResidualDriftAtCollapseForAllComp);
medianResidualDriftAtCollapseAllComp = median(maxResidualDriftAtCollapseForAllComp);
stDevResidualDriftAtCollapseAllComp = std(maxResidualDriftAtCollapseForAllComp);

meanResidualDriftAtCollapseControlComp = mean(maxResidualDriftAtCollapseForControlComp);
medianResidualDriftAtCollapseControlComp = median(maxResidualDriftAtCollapseForControlComp);
stDevResidualDriftAtCollapseControlComp = std(maxResidualDriftAtCollapseForControlComp);

% Save RDR collapse results file
    cd ..
    cd Output
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);

    if(isConvertToSaKircher == 0)
        colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean_RDR.mat', eqListForCollapseIDAs_Name);
    else
        colFileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63_RDR.mat', eqListForCollapseIDAs_Name);
    end

    save(colFileName, 'analysisType', 'collapseLevelForAllComp', 'collapseLevelForAllControlComp', 'eqNumberLIST', ...
        'maxResidualDriftAtCollapseForAllComp', 'maxResidualDriftAtCollapseForControlComp', ...
        'meanResidualDriftAtCollapseAllComp', 'medianResidualDriftAtCollapseAllComp', 'stDevResidualDriftAtCollapseAllComp', ...
        'meanResidualDriftAtCollapseControlComp', 'medianResidualDriftAtCollapseControlComp', 'stDevResidualDriftAtCollapseControlComp', ...
        'eqCompNumberLIST', 'ControllingCompNumLIST', 'periodUsedForScalingGroundMotions');

    %% ============================================================
    %  Plot LOG NORMAL PDF at RDR locations (ALL COMPONENTS)
    % ============================================================
    figure(figureNumAllComp);
    hold on;

    hDriftLines = gobjects(length(rdrLevels), 1);
  
    for driftIdx = 1:length(rdrLevels)
        targetDrift = rdrLevels(driftIdx) * 100;   % convert to PERCENT for x-axis position

        SaVals = saValsAtTargetDriftAllComp(:, driftIdx);
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

        hDriftLines(driftIdx) = plot([targetDrift targetDrift], [Sa16 Sa84], ...
            '-', 'LineWidth', 3.0, 'Color', colors(driftIdx,:), 'DisplayName', rdrLevelLabels{driftIdx});

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
            saSeg = segments{s};
            pdfSeg = pdfSegs{s};
            if numel(saSeg) < 2
                continue
            end
            x_pdf = [targetDrift * ones(1, length(saSeg)), ...
                targetDrift - pdfSeg(end:-1:1)];
            % x_pdf = [targetDrift * ones(1, length(saSeg)), targetDrift - pdfSeg(end:-1:1)];
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
        legend(hDriftLines(validIdx), rdrLevelLabels(validIdx), 'Location', 'southeast', 'AutoUpdate', 'off');
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
    xlabel('$\mathrm{Max\ Residual\ Drift\ Ratio\ (\%)}$', 'Interpreter','latex');
    xlim([0, maxXOnAxis])
    ylim([0, maxYOnAxis])

    % Optional performance-level reference lines
    for i = 1:length(rdrPerformanceThresholds)
        xline(rdrPerformanceThresholds(i), '--');
    end

    sks_figureFormat(formatMode)

    if(isConvertToSaKircher == 0)
        exportName = sprintf('CollapseIDA_AllComp_SaGeoMean_RDR_PDF');
        sks_figureExport(exportName)
    else
        exportName = sprintf('CollapseIDA_AllComp_SaATC63_RDR_PDF');
        sks_figureExport(exportName)
    end
    hold off

    %% ============================================================
    %  Plot LOG NORMAL PDF at RDR locations (CONTROL COMPONENT)
    % ============================================================
    figure(figureNumControllingComp);
    hold on;

    hDriftLines = gobjects(length(rdrLevels), 1);
  
    for driftIdx = 1:length(rdrLevels)
        targetDrift = rdrLevels(driftIdx) * 100;

        SaVals = saValsAtTargetDriftControlComp(:, driftIdx);
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

        hDriftLines(driftIdx) = plot([targetDrift targetDrift], [Sa16 Sa84], ...
            '-', 'LineWidth', 3.0, 'Color', colors(driftIdx,:), 'DisplayName', rdrLevelLabels{driftIdx});

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
            saSeg = segments{s};
            pdfSeg = pdfSegs{s};
            if numel(saSeg) < 2
                continue
            end
            x_pdf = [targetDrift * ones(1, length(saSeg)), ...
                targetDrift - pdfSeg(end:-1:1)];
            % x_pdf = [targetDrift * ones(1, length(saSeg)), targetDrift - pdfSeg(end:-1:1)];
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
        legend(hDriftLines(validIdx), rdrLevelLabels(validIdx), 'Location', 'southeast', 'AutoUpdate', 'off');
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
    xlabel('$\mathrm{Max\ Residual\ Drift\ Ratio\ (\%)}$', 'Interpreter','latex');
    xlim([0, maxXOnAxis])
    ylim([0, maxYOnAxis])

    for i = 1:length(rdrPerformanceThresholds)
        xline(rdrPerformanceThresholds(i), '--');
    end

    sks_figureFormat(formatMode)

    if(isConvertToSaKircher == 0)
        exportName = sprintf('CollapseIDA_ControlComp_SaGeoMean_RDR_PDF');
        sks_figureExport(exportName)
    else
        exportName = sprintf('CollapseIDA_ControlComp_SaATC63_RDR_PDF');
        sks_figureExport(exportName)
    end
    hold off

cd(fullfile('..', '..', 'psb_MatlabProcessors'));


%%%%%%%%%%%%% Fragility Functions - compute + save only (Control + All Comp) %%%%%%%%%%%%%%%%%%%%%%%
% ADDED 15-Sep-2026: mirrors the block in sks_PlotCollapseIDAsPDF_singleAnaType.m
% (MIDR version), but fit at each RDR level instead of each MIDR level, using
% the per-EQ Sa data already collected above in saValsAtTargetDriftAllComp /
% saValsAtTargetDriftControlComp. This is what lets
% PlotCollapseEmpiricalCDFWithFits_allRDR_proc.m produce the empirical CDF plots.

% Go to the correct folder to save the fragility params file
  cd ..;
  cd Output
  analysisTypeFolder = sprintf('%s', analysisType);
  cd(analysisTypeFolder);

  numLimitStates = length(rdrLevels);   % number of limit states (IO, LS, CP, Collapse)

  % ---- Controlling component ----
  meanLnSaVals   = nan(1, numLimitStates);
  stDevLnSaVals  = nan(1, numLimitStates);

  for limitStateIdx = 1:numLimitStates
      SaVals = saValsAtTargetDriftControlComp(:, limitStateIdx);
      SaVals = SaVals(isfinite(SaVals) & SaVals > 0);   % drop NaNs/invalid

      if numel(SaVals) < 2
          warning('Control comp - RDR level %d has fewer than 2 valid points - skipping', limitStateIdx);
          continue
      end

      meanLnSaVals(limitStateIdx)  = mean(log(SaVals));   % median IM capacity for this RDR level
      stDevLnSaVals(limitStateIdx) = std(log(SaVals));    % logarithmic dispersion (beta_RTR)
  end

  % ---- All components ----
  meanLnSaValsAllComp   = nan(1, numLimitStates);
  stDevLnSaValsAllComp  = nan(1, numLimitStates);

  for limitStateIdx = 1:numLimitStates
      SaVals = saValsAtTargetDriftAllComp(:, limitStateIdx);
      SaVals = SaVals(isfinite(SaVals) & SaVals > 0);   % drop NaNs/invalid

      if numel(SaVals) < 2
          warning('All comp - RDR level %d has fewer than 2 valid points - skipping', limitStateIdx);
          continue
      end

      meanLnSaValsAllComp(limitStateIdx)  = mean(log(SaVals));
      stDevLnSaValsAllComp(limitStateIdx) = std(log(SaVals));
  end

% Save the fragility parameters (both control and all comp) so they survive after this function returns
if (isConvertToSaKircher == 0)
      fragFileName = sprintf('DATA_FragilityParams_SaGeoMean_%s_RDR.mat', eqListForCollapseIDAs_Name);
else
      fragFileName = sprintf('DATA_FragilityParams_SaATC63_%s_RDR.mat', eqListForCollapseIDAs_Name);
end
  save(fragFileName, 'rdrLevels', 'rdrLevelLabels', 'meanLnSaVals', 'stDevLnSaVals', 'saValsAtTargetDriftControlComp', ...
       'meanLnSaValsAllComp', 'stDevLnSaValsAllComp', 'saValsAtTargetDriftAllComp');

% Return safely to MatlabProcessors folder
  cd(fullfile('..', '..', 'psb_MatlabProcessors'));

end
