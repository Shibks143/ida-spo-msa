%
% Procedure: sks_ProcessFragilityParams_MSA.m
% -------------------
% Builds and saves DATA_FragilityParams_SaGeoMean_<name>.mat for MSA.
%
% For each demand type (MIDR, RDR, PFA) and each limit state level,
% computes stripe-level exceedance fractions nExc/nGM then calls
% sks_Mle_MSA — exactly the same function and interface used by
% sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA
% for building the collapse fragility.
%
% sks_Mle_MSA interface (Baker 2015):
%   [theta, beta] = sks_Mle_MSA(saLevelList, numOfGroundMotions, numOfCollapses)
%   saLevelList        — IM at each stripe (nStripes x 1)
%   numOfGroundMotions — integer count of GMs at each stripe (nStripes x 1)
%   numOfCollapses     — integer count of exceedances at each stripe (nStripes x 1)
%   GUARD: sum(numOfCollapses) must be > 0 and < sum(numOfGroundMotions)
%          otherwise initial guess x0 divides by zero or likelihood is degenerate
%
% Data sources — same files as sks_PlotCollapse_singleAnaType_MSA:
%   DATA_CollapseResultsForThisSingleEQ.mat  → saLevelForEachRun, isCollapsedForEachRun,
%                                              isSingularForEachRun, isNonConvForEachRun,
%                                              maxDriftForEachRun (MIDR), numSaLevels
%   DATA_collapseMSAPlotDataForThisEQ.mat    → maxResidualDriftRatioForPlotLIST (RDR),
%                                              maxPFAForPlotLIST (PFA)
%
% Filters applied — identical to existing MSA scatter plotter:
%   AllComp:     exclude non-collapse runs where isSingular OR isNonConv
%   ControlComp: exclude stripe if EITHER component has non-collapse singular/nonconv
%                demand for pair = max(comp1, comp2) at each stripe
%   Collapse runs → demand = Inf (exceed every finite limit state threshold)
%
% Saved variables in DATA_FragilityParams_SaGeoMean_<name>.mat:
%   midrLevels, midrLevelLabels
%   midrThetaControl(nLS x 1)    — MLE median Sa, ControlComp
%   midrBetaControl(nLS x 1)     — MLE lognormal std, ControlComp
%   midrThetaAllComp(nLS x 1)    — MLE median Sa, AllComp
%   midrBetaAllComp(nLS x 1)     — MLE lognormal std, AllComp
%   midrStripeSaControl(nStripes x 1) — unique Sa stripe levels, ControlComp
%   midrStripeSaAllComp(nStripes x 1) — unique Sa stripe levels, AllComp
%   midrExcProbControl(nStripes x nLS) — nExc/nGM per stripe per LS, ControlComp
%   midrExcProbAllComp(nStripes x nLS) — nExc/nGM per stripe per LS, AllComp
%   midrNumGMControl(nStripes x nLS)   — nGM per stripe per LS, ControlComp
%   midrNumGMAllComp(nStripes x nLS)   — nGM per stripe per LS, AllComp
%   midrNumExcControl(nStripes x nLS)  — nExc per stripe per LS, ControlComp
%   midrNumExcAllComp(nStripes x nLS)  — nExc per stripe per LS, AllComp
%   (same pattern for rdr* and pfa*)
%   periodUsedForScalingGroundMotions
%
% Author: Shivakumar KS, IIT Madras, Oct-2026
% -------------------
function sks_ProcessFragilityParams_MSA(msaInputs)

analysisTypeLIST           = msaInputs.analysisTypeLIST;
eqNumberLIST               = msaInputs.eqNumberLIST;
isConvertToSaKircher       = msaInputs.isConvertToSaKircher;
eqListForCollapseMSAs_Name = msaInputs.eqListForCollapseMSAs_Name;

midrLevels      = msaInputs.midrLevels;
midrLevelLabels = msaInputs.midrLevelLabels;
rdrLevels       = msaInputs.rdrLevels;
rdrLevelLabels  = msaInputs.rdrLevelLabels;
pfaLevels       = msaInputs.pfaLevels;
pfaLevelLabels  = msaInputs.pfaLevelLabels;

startDir = pwd;

% =========================================================================
for analysisTypeIdx = 1:length(analysisTypeLIST)

    analysisType       = analysisTypeLIST{analysisTypeIdx};
    analysisTypeFolder = sprintf('%s', analysisType);

    fprintf('\n=================================================\n');
    fprintf('sks_ProcessFragilityParams_MSA: %s\n', analysisType);
    fprintf('=================================================\n');

    cd(startDir);
    cd(fullfile('..', 'Output'));
    fixedOutputDirectory = pwd;

    % =====================================================================
    % PASS 1 — AllComp
    % Loop over every EQ component folder independently.
    % Same filter as sks_plot_AllComp_MSA:
    %   exclude non-collapse runs that are singular OR non-convergent.
    % Collapse runs: set demand = Inf so they count as exceedance
    % at every finite limit state threshold.
    % =====================================================================
    allSaLevels_AllComp   = [];
    allMIDR_AllComp       = [];
    allRDR_AllComp        = [];
    allPFA_AllComp        = [];
    periodUsedForScalingGroundMotions = NaN;

    for eqComponentIdx = 1:length(eqNumberLIST)
        eqComponentFolder = fullfile(fixedOutputDirectory, analysisTypeFolder, ...
            sprintf('EQ_%d', eqNumberLIST(eqComponentIdx)));

        [saLevelsThisEQ, isCollapsedThisEQ, isSingularThisEQ, isNonConvThisEQ, ...
         midrThisEQ, rdrThisEQ, pfaThisEQ, periodThisEQ] = ...
            loadAndCleanSingleEQFolder(eqComponentFolder);

        if ~isnan(periodThisEQ)
            periodUsedForScalingGroundMotions = periodThisEQ;
        end

        % Filter — mirrors sks_plot_AllComp_MSA exactly:
        % keep run if it is a collapse OR if it is a valid non-collapse
        % (i.e. exclude non-collapse runs that are singular or non-convergent)
        validRunForAllComp = ~(isCollapsedThisEQ == 0 & ...
                               (isSingularThisEQ | isNonConvThisEQ));

        saLevelsThisEQ   = saLevelsThisEQ(validRunForAllComp);
        isCollapsedThisEQ = isCollapsedThisEQ(validRunForAllComp);
        midrThisEQ        = midrThisEQ(validRunForAllComp);
        rdrThisEQ         = rdrThisEQ(validRunForAllComp);
        pfaThisEQ         = pfaThisEQ(validRunForAllComp);

        % Collapse runs exceed every finite limit state threshold —
        % set demand to Inf so isExceedance = (demand >= threshold) = 1
        % for any finite threshold, for every collapse run
        midrThisEQ(isCollapsedThisEQ == 1) = Inf;
        rdrThisEQ(isCollapsedThisEQ == 1)  = Inf;
        pfaThisEQ(isCollapsedThisEQ == 1)  = Inf;

        allSaLevels_AllComp = [allSaLevels_AllComp; saLevelsThisEQ(:)];
        allMIDR_AllComp     = [allMIDR_AllComp;     midrThisEQ(:)];
        allRDR_AllComp      = [allRDR_AllComp;      rdrThisEQ(:)];
        allPFA_AllComp      = [allPFA_AllComp;       pfaThisEQ(:)];
    end

    % =====================================================================
    % PASS 2 — ControlComp
    % Loop over EQ pairs. Same combined filter as sks_plot_ControlComp_MSA:
    %   exclude stripe if EITHER component has a non-collapse singular/nonconv run.
    % Demand for the pair at each stripe = max(component1, component2)
    %   — worst component governs, consistent with collapse control logic.
    % =====================================================================
    allSaLevels_ControlComp = [];
    allMIDR_ControlComp     = [];
    allRDR_ControlComp      = [];
    allPFA_ControlComp      = [];

    for eqPairStartIdx = 1:2:length(eqNumberLIST)
        eqComponent1Folder = fullfile(fixedOutputDirectory, analysisTypeFolder, ...
            sprintf('EQ_%d', eqNumberLIST(eqPairStartIdx)));
        eqComponent2Folder = fullfile(fixedOutputDirectory, analysisTypeFolder, ...
            sprintf('EQ_%d', eqNumberLIST(eqPairStartIdx + 1)));

        [saLevelsComponent1, isCollapsedComponent1, isSingularComponent1, ...
         isNonConvComponent1, midrComponent1, rdrComponent1, pfaComponent1, ~] = ...
            loadAndCleanSingleEQFolder(eqComponent1Folder);

        [saLevelsComponent2, isCollapsedComponent2, isSingularComponent2, ...
         isNonConvComponent2, midrComponent2, rdrComponent2, pfaComponent2, ~] = ...
            loadAndCleanSingleEQFolder(eqComponent2Folder);

        % Stripe alignment check — same as existing MSA processors
        if length(saLevelsComponent1) ~= length(saLevelsComponent2) || ...
                any(abs(saLevelsComponent1 - saLevelsComponent2) > 1e-6)
            error('Stripe Sa mismatch between EQ_%d and EQ_%d', ...
                eqNumberLIST(eqPairStartIdx), eqNumberLIST(eqPairStartIdx + 1));
        end

        % Combined filter — mirrors sks_plot_ControlComp_MSA exactly:
        % exclude a stripe if EITHER component has a non-collapse run
        % that is singular or non-convergent at that stripe
        validRunForControlComp = ~( ...
            (isCollapsedComponent1 == 0 & (isSingularComponent1 | isNonConvComponent1)) | ...
            (isCollapsedComponent2 == 0 & (isSingularComponent2 | isNonConvComponent2)) );

        saLevelsPair    = saLevelsComponent1(validRunForControlComp);
        isCollapsedPair = max(isCollapsedComponent1(validRunForControlComp), ...
                              isCollapsedComponent2(validRunForControlComp));

        % Worst demand across the pair at each stripe
        midrPair = max(midrComponent1(validRunForControlComp), ...
                       midrComponent2(validRunForControlComp));
        rdrPair  = max(rdrComponent1(validRunForControlComp), ...
                       rdrComponent2(validRunForControlComp));
        pfaPair  = max(pfaComponent1(validRunForControlComp), ...
                       pfaComponent2(validRunForControlComp));

        % Collapse runs → Inf (same logic as AllComp above)
        midrPair(isCollapsedPair == 1) = Inf;
        rdrPair(isCollapsedPair == 1)  = Inf;
        pfaPair(isCollapsedPair == 1)  = Inf;

        allSaLevels_ControlComp = [allSaLevels_ControlComp; saLevelsPair(:)];
        allMIDR_ControlComp     = [allMIDR_ControlComp;     midrPair(:)];
        allRDR_ControlComp      = [allRDR_ControlComp;      rdrPair(:)];
        allPFA_ControlComp      = [allPFA_ControlComp;       pfaPair(:)];
    end

    % =====================================================================
    % PASS 3 — MLE fitting per demand type per limit state
    %
    % For each limit state threshold:
    %   isExceedanceForEachRun = (demandForEachRun >= threshold)  [0 or 1]
    %   aggregate to stripe level → numExceedancesPerStripe, numGMsPerStripe
    %   call sks_Mle_MSA(saStripeList, numGMsPerStripe, numExceedancesPerStripe)
    %
    % This is identical in pattern to the collapse CDF processor
    % sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA
    % which does:
    %   numOfCollapses(stripe) = sum(isCollapsedForEachRun at that stripe)
    %   [theta, beta] = sks_Mle_MSA(saStripeList, numGMs, numOfCollapses)
    % Here numOfCollapses is replaced by numOfExceedances for each LS.
    %
    % Guards required by sks_Mle_MSA (Baker 2015 MLE):
    %   Initial guess: x0(1) = sum(numExc .* log(sa)) / sum(numExc)
    %     → needs sum(numExc) > 0, else divide by zero → NaN x0
    %   Likelihood: uses log(p) and log(1-p) at each stripe
    %     → needs sum(numExc) < sum(numGM), else log(1-p)=log(0) everywhere
    %   So guard: 0 < sum(numExc) < sum(numGM)  AND  at least 2 stripes
    % =====================================================================

    % Package demand data for the loop — one row per demand type
    demandTypeNameList        = {'MIDR',            'RDR',            'PFA'          };
    demandLevelsList          = {midrLevels,         rdrLevels,        pfaLevels      };
    demandLevelLabelsList     = {midrLevelLabels,    rdrLevelLabels,   pfaLevelLabels };
    demandValues_ControlComp  = {allMIDR_ControlComp, allRDR_ControlComp, allPFA_ControlComp};
    demandValues_AllComp      = {allMIDR_AllComp,    allRDR_AllComp,   allPFA_AllComp };

    fragResults = struct();

    for demandTypeIdx = 1:length(demandTypeNameList)

        currentDemandName        = demandTypeNameList{demandTypeIdx};
        currentLimitStateLevels  = demandLevelsList{demandTypeIdx};
        currentLimitStateLabels  = demandLevelLabelsList{demandTypeIdx};
        demandPerRun_ControlComp = demandValues_ControlComp{demandTypeIdx};
        demandPerRun_AllComp     = demandValues_AllComp{demandTypeIdx};
        numLimitStates           = length(currentLimitStateLevels);
        fieldPrefix              = lower(currentDemandName);   % 'midr', 'rdr', or 'pfa'

        fprintf('\n--- %s fragility ---\n', currentDemandName);

        % Unique stripe Sa levels for each component case
        roundingTolerance              = 1e-4;
        uniqueStripeSa_ControlComp     = unique(round(allSaLevels_ControlComp / roundingTolerance) * roundingTolerance);
        uniqueStripeSa_ControlComp     = uniqueStripeSa_ControlComp(uniqueStripeSa_ControlComp > 0);
        uniqueStripeSa_AllComp         = unique(round(allSaLevels_AllComp / roundingTolerance) * roundingTolerance);
        uniqueStripeSa_AllComp         = uniqueStripeSa_AllComp(uniqueStripeSa_AllComp > 0);
        numStripes_ControlComp         = length(uniqueStripeSa_ControlComp);
        numStripes_AllComp             = length(uniqueStripeSa_AllComp);

        % Pre-allocate result arrays for this demand type
        mleMedianSa_ControlComp        = nan(numLimitStates, 1);
        mleBeta_ControlComp            = nan(numLimitStates, 1);
        mleMedianSa_AllComp            = nan(numLimitStates, 1);
        mleBeta_AllComp                = nan(numLimitStates, 1);
        exceedanceProbability_ControlComp = nan(numStripes_ControlComp, numLimitStates);
        exceedanceProbability_AllComp     = nan(numStripes_AllComp,     numLimitStates);
        numGMsPerStripe_ControlComp    = zeros(numStripes_ControlComp, numLimitStates);
        numGMsPerStripe_AllComp        = zeros(numStripes_AllComp,     numLimitStates);
        numExceedancesPerStripe_ControlComp = zeros(numStripes_ControlComp, numLimitStates);
        numExceedancesPerStripe_AllComp     = zeros(numStripes_AllComp,     numLimitStates);

        for limitStateIdx = 1:numLimitStates

            currentThreshold  = currentLimitStateLevels(limitStateIdx);
            currentStateLabel = currentLimitStateLabels{limitStateIdx};

            % ==============================================================
            % ControlComp — build stripe exceedance counts then call MLE
            % ==============================================================
            isExceedancePerRun_ControlComp = double(demandPerRun_ControlComp >= currentThreshold);

            [saStripeList_ControlComp, numGMsAtEachStripe_ControlComp, ...
             numExceedancesAtEachStripe_ControlComp, exceedanceFractionAtEachStripe_ControlComp] = ...
                buildStripeFractions(allSaLevels_ControlComp, isExceedancePerRun_ControlComp);

            % Fill into the full stripe grid (some stripes may not appear
            % in saStripeList after buildStripeFractions filtering)
            for stripeIdx = 1:numStripes_ControlComp
                matchIdx = abs(saStripeList_ControlComp - uniqueStripeSa_ControlComp(stripeIdx)) < roundingTolerance;
                if any(matchIdx)
                    numGMsPerStripe_ControlComp(stripeIdx, limitStateIdx)         = numGMsAtEachStripe_ControlComp(matchIdx);
                    numExceedancesPerStripe_ControlComp(stripeIdx, limitStateIdx) = numExceedancesAtEachStripe_ControlComp(matchIdx);
                    exceedanceProbability_ControlComp(stripeIdx, limitStateIdx)   = exceedanceFractionAtEachStripe_ControlComp(matchIdx);
                end
            end

            % Guard before calling sks_Mle_MSA — see header comments
            stripesWithData_ControlComp        = numGMsAtEachStripe_ControlComp > 0;
            totalExceedances_ControlComp       = sum(numExceedancesAtEachStripe_ControlComp(stripesWithData_ControlComp));
            totalNonExceedances_ControlComp    = sum(numGMsAtEachStripe_ControlComp(stripesWithData_ControlComp)) - ...
                                                 totalExceedances_ControlComp;

            if sum(stripesWithData_ControlComp) >= 2 && ...
                    totalExceedances_ControlComp > 0    && ...
                    totalNonExceedances_ControlComp > 0

                [theta_ControlComp, beta_ControlComp] = sks_Mle_MSA( ...
                    saStripeList_ControlComp(stripesWithData_ControlComp), ...
                    numGMsAtEachStripe_ControlComp(stripesWithData_ControlComp), ...
                    numExceedancesAtEachStripe_ControlComp(stripesWithData_ControlComp));

                if theta_ControlComp > 0 && isfinite(theta_ControlComp) && ...
                        beta_ControlComp > 0 && isfinite(beta_ControlComp)
                    mleMedianSa_ControlComp(limitStateIdx) = theta_ControlComp;
                    mleBeta_ControlComp(limitStateIdx)     = beta_ControlComp;
                    fprintf('  ControlComp  %-5s %-6s: theta = %6.3f g   beta = %.3f   (nStripes = %d   nExc = %d / %d)\n', ...
                        currentDemandName, currentStateLabel, ...
                        theta_ControlComp, beta_ControlComp, ...
                        sum(stripesWithData_ControlComp), ...
                        totalExceedances_ControlComp, ...
                        totalExceedances_ControlComp + totalNonExceedances_ControlComp);
                else
                    fprintf('  ControlComp  %-5s %-6s: MLE returned invalid params (theta = %.3f   beta = %.3f) — skipped\n', ...
                        currentDemandName, currentStateLabel, theta_ControlComp, beta_ControlComp);
                end

            else
                fprintf('  ControlComp  %-5s %-6s: skipped — nStripes = %d   nExc = %d   nNonExc = %d\n', ...
                    currentDemandName, currentStateLabel, ...
                    sum(stripesWithData_ControlComp), ...
                    totalExceedances_ControlComp, ...
                    totalNonExceedances_ControlComp);
            end

            % ==============================================================
            % AllComp — same pattern as ControlComp above
            % ==============================================================
            isExceedancePerRun_AllComp = double(demandPerRun_AllComp >= currentThreshold);

            [saStripeList_AllComp, numGMsAtEachStripe_AllComp, ...
             numExceedancesAtEachStripe_AllComp, exceedanceFractionAtEachStripe_AllComp] = ...
                buildStripeFractions(allSaLevels_AllComp, isExceedancePerRun_AllComp);

            for stripeIdx = 1:numStripes_AllComp
                matchIdx = abs(saStripeList_AllComp - uniqueStripeSa_AllComp(stripeIdx)) < roundingTolerance;
                if any(matchIdx)
                    numGMsPerStripe_AllComp(stripeIdx, limitStateIdx)         = numGMsAtEachStripe_AllComp(matchIdx);
                    numExceedancesPerStripe_AllComp(stripeIdx, limitStateIdx) = numExceedancesAtEachStripe_AllComp(matchIdx);
                    exceedanceProbability_AllComp(stripeIdx, limitStateIdx)   = exceedanceFractionAtEachStripe_AllComp(matchIdx);
                end
            end

            stripesWithData_AllComp      = numGMsAtEachStripe_AllComp > 0;
            totalExceedances_AllComp     = sum(numExceedancesAtEachStripe_AllComp(stripesWithData_AllComp));
            totalNonExceedances_AllComp  = sum(numGMsAtEachStripe_AllComp(stripesWithData_AllComp)) - ...
                                           totalExceedances_AllComp;

            if sum(stripesWithData_AllComp) >= 2 && ...
                    totalExceedances_AllComp > 0   && ...
                    totalNonExceedances_AllComp > 0

                [theta_AllComp, beta_AllComp] = sks_Mle_MSA( ...
                    saStripeList_AllComp(stripesWithData_AllComp), ...
                    numGMsAtEachStripe_AllComp(stripesWithData_AllComp), ...
                    numExceedancesAtEachStripe_AllComp(stripesWithData_AllComp));

                if theta_AllComp > 0 && isfinite(theta_AllComp) && ...
                        beta_AllComp > 0 && isfinite(beta_AllComp)
                    mleMedianSa_AllComp(limitStateIdx) = theta_AllComp;
                    mleBeta_AllComp(limitStateIdx)     = beta_AllComp;
                    fprintf('  AllComp      %-5s %-6s: theta = %6.3f g   beta = %.3f   (nStripes = %d   nExc = %d / %d)\n', ...
                        currentDemandName, currentStateLabel, ...
                        theta_AllComp, beta_AllComp, ...
                        sum(stripesWithData_AllComp), ...
                        totalExceedances_AllComp, ...
                        totalExceedances_AllComp + totalNonExceedances_AllComp);
                else
                    fprintf('  AllComp      %-5s %-6s: MLE returned invalid params (theta = %.3f   beta = %.3f) — skipped\n', ...
                        currentDemandName, currentStateLabel, theta_AllComp, beta_AllComp);
                end

            else
                fprintf('  AllComp      %-5s %-6s: skipped — nStripes = %d   nExc = %d   nNonExc = %d\n', ...
                    currentDemandName, currentStateLabel, ...
                    sum(stripesWithData_AllComp), ...
                    totalExceedances_AllComp, ...
                    totalNonExceedances_AllComp);
            end

        end   % limitStateIdx loop

        % Store all results for this demand type under fieldPrefix
        fragResults.([fieldPrefix 'Levels'])                      = currentLimitStateLevels;
        fragResults.([fieldPrefix 'LevelLabels'])                 = currentLimitStateLabels;
        fragResults.([fieldPrefix 'ThetaControl'])                = mleMedianSa_ControlComp;
        fragResults.([fieldPrefix 'BetaControl'])                 = mleBeta_ControlComp;
        fragResults.([fieldPrefix 'ThetaAllComp'])                = mleMedianSa_AllComp;
        fragResults.([fieldPrefix 'BetaAllComp'])                 = mleBeta_AllComp;
        fragResults.([fieldPrefix 'StripeSaControl'])             = uniqueStripeSa_ControlComp;
        fragResults.([fieldPrefix 'StripeSaAllComp'])             = uniqueStripeSa_AllComp;
        fragResults.([fieldPrefix 'ExceedanceProbControl'])       = exceedanceProbability_ControlComp;
        fragResults.([fieldPrefix 'ExceedanceProbAllComp'])       = exceedanceProbability_AllComp;
        fragResults.([fieldPrefix 'NumGMsPerStripeControl'])      = numGMsPerStripe_ControlComp;
        fragResults.([fieldPrefix 'NumGMsPerStripeAllComp'])      = numGMsPerStripe_AllComp;
        fragResults.([fieldPrefix 'NumExceedancesPerStripeControl']) = numExceedancesPerStripe_ControlComp;
        fragResults.([fieldPrefix 'NumExceedancesPerStripeAllComp']) = numExceedancesPerStripe_AllComp;

    end   % demandTypeIdx loop

    % =====================================================================
    % Save .mat — unpack struct to named variables first so workspace
    % variable names in the .mat are clean and descriptive
    % =====================================================================
    saveDir = fullfile(fixedOutputDirectory, analysisTypeFolder);
    if isConvertToSaKircher == 0
        fragFileName = sprintf('DATA_FragilityParams_SaGeoMean_%s.mat', ...
                               eqListForCollapseMSAs_Name);
    else
        fragFileName = sprintf('DATA_FragilityParams_SaATC63_%s.mat', ...
                               eqListForCollapseMSAs_Name);
    end

    % MIDR
    midrLevels                          = fragResults.midrLevels;
    midrLevelLabels                     = fragResults.midrLevelLabels;
    midrThetaControl                    = fragResults.midrThetaControl;
    midrBetaControl                     = fragResults.midrBetaControl;
    midrThetaAllComp                    = fragResults.midrThetaAllComp;
    midrBetaAllComp                     = fragResults.midrBetaAllComp;
    midrStripeSaControl                 = fragResults.midrStripeSaControl;
    midrStripeSaAllComp                 = fragResults.midrStripeSaAllComp;
    midrExceedanceProbControl           = fragResults.midrExceedanceProbControl;
    midrExceedanceProbAllComp           = fragResults.midrExceedanceProbAllComp;
    midrNumGMsPerStripeControl          = fragResults.midrNumGMsPerStripeControl;
    midrNumGMsPerStripeAllComp          = fragResults.midrNumGMsPerStripeAllComp;
    midrNumExceedancesPerStripeControl  = fragResults.midrNumExceedancesPerStripeControl;
    midrNumExceedancesPerStripeAllComp  = fragResults.midrNumExceedancesPerStripeAllComp;

    % RDR
    rdrLevels                           = fragResults.rdrLevels;
    rdrLevelLabels                      = fragResults.rdrLevelLabels;
    rdrThetaControl                     = fragResults.rdrThetaControl;
    rdrBetaControl                      = fragResults.rdrBetaControl;
    rdrThetaAllComp                     = fragResults.rdrThetaAllComp;
    rdrBetaAllComp                      = fragResults.rdrBetaAllComp;
    rdrStripeSaControl                  = fragResults.rdrStripeSaControl;
    rdrStripeSaAllComp                  = fragResults.rdrStripeSaAllComp;
    rdrExceedanceProbControl            = fragResults.rdrExceedanceProbControl;
    rdrExceedanceProbAllComp            = fragResults.rdrExceedanceProbAllComp;
    rdrNumGMsPerStripeControl           = fragResults.rdrNumGMsPerStripeControl;
    rdrNumGMsPerStripeAllComp           = fragResults.rdrNumGMsPerStripeAllComp;
    rdrNumExceedancesPerStripeControl   = fragResults.rdrNumExceedancesPerStripeControl;
    rdrNumExceedancesPerStripeAllComp   = fragResults.rdrNumExceedancesPerStripeAllComp;

    % PFA
    pfaLevels                           = fragResults.pfaLevels;
    pfaLevelLabels                      = fragResults.pfaLevelLabels;
    pfaThetaControl                     = fragResults.pfaThetaControl;
    pfaBetaControl                      = fragResults.pfaBetaControl;
    pfaThetaAllComp                     = fragResults.pfaThetaAllComp;
    pfaBetaAllComp                      = fragResults.pfaBetaAllComp;
    pfaStripeSaControl                  = fragResults.pfaStripeSaControl;
    pfaStripeSaAllComp                  = fragResults.pfaStripeSaAllComp;
    pfaExceedanceProbControl            = fragResults.pfaExceedanceProbControl;
    pfaExceedanceProbAllComp            = fragResults.pfaExceedanceProbAllComp;
    pfaNumGMsPerStripeControl           = fragResults.pfaNumGMsPerStripeControl;
    pfaNumGMsPerStripeAllComp           = fragResults.pfaNumGMsPerStripeAllComp;
    pfaNumExceedancesPerStripeControl   = fragResults.pfaNumExceedancesPerStripeControl;
    pfaNumExceedancesPerStripeAllComp   = fragResults.pfaNumExceedancesPerStripeAllComp;

    save(fullfile(saveDir, fragFileName), ...
        'periodUsedForScalingGroundMotions', ...
        'midrLevels',                         'midrLevelLabels', ...
        'midrThetaControl',                   'midrBetaControl', ...
        'midrThetaAllComp',                   'midrBetaAllComp', ...
        'midrStripeSaControl',                'midrStripeSaAllComp', ...
        'midrExceedanceProbControl',          'midrExceedanceProbAllComp', ...
        'midrNumGMsPerStripeControl',         'midrNumGMsPerStripeAllComp', ...
        'midrNumExceedancesPerStripeControl', 'midrNumExceedancesPerStripeAllComp', ...
        'rdrLevels',                          'rdrLevelLabels', ...
        'rdrThetaControl',                    'rdrBetaControl', ...
        'rdrThetaAllComp',                    'rdrBetaAllComp', ...
        'rdrStripeSaControl',                 'rdrStripeSaAllComp', ...
        'rdrExceedanceProbControl',           'rdrExceedanceProbAllComp', ...
        'rdrNumGMsPerStripeControl',          'rdrNumGMsPerStripeAllComp', ...
        'rdrNumExceedancesPerStripeControl',  'rdrNumExceedancesPerStripeAllComp', ...
        'pfaLevels',                          'pfaLevelLabels', ...
        'pfaThetaControl',                    'pfaBetaControl', ...
        'pfaThetaAllComp',                    'pfaBetaAllComp', ...
        'pfaStripeSaControl',                 'pfaStripeSaAllComp', ...
        'pfaExceedanceProbControl',           'pfaExceedanceProbAllComp', ...
        'pfaNumGMsPerStripeControl',          'pfaNumGMsPerStripeAllComp', ...
        'pfaNumExceedancesPerStripeControl',  'pfaNumExceedancesPerStripeAllComp');

    fprintf('\nSaved: %s\n', fullfile(saveDir, fragFileName));
    printFragilitySummaryTable(fragResults);

end   % analysisTypeIdx loop

cd(startDir);
fprintf('\nsks_ProcessFragilityParams_MSA — DONE\n');

end   % main function


% =========================================================================
% Local helper: load and clean one EQ folder
%
% Reads:
%   DATA_CollapseResultsForThisSingleEQ.mat  — sa, collapse flags, MIDR
%   DATA_collapseMSAPlotDataForThisEQ.mat    — RDR, PFA
% Applies numSaLevels cap and removes padding zeros (sa > 0).
% Returns demands in raw ratio (MIDR, RDR) and g (PFA).
% Same files and fields as sks_PlotCollapse_singleAnaType_MSA.
% =========================================================================
function [saLevelForEachRun, isCollapsedForEachRun, isSingularForEachRun, ...
          isNonConvForEachRun, maxMIDRForEachRun, maxRDRForEachRun, ...
          maxPFAForEachRun_g, periodUsedForScalingGroundMotions] = ...
        loadAndCleanSingleEQFolder(eqFolderPath)

    collapseResultsFile  = fullfile(eqFolderPath, 'DATA_CollapseResultsForThisSingleEQ.mat');
    msaPlotDataFile      = fullfile(eqFolderPath, 'DATA_collapseMSAPlotDataForThisEQ.mat');

    % Load collapse results — same fields as sks_plot_AllComp_MSA MIDR branch
    collapseData = load(collapseResultsFile, ...
        'saLevelForEachRun', 'isCollapsedForEachRun', ...
        'isSingularForEachRun', 'isNonConvForEachRun', ...
        'numSaLevels', 'periodUsedForScalingGroundMotions', ...
        'maxDriftForEachRun');

    periodUsedForScalingGroundMotions = collapseData.periodUsedForScalingGroundMotions;
    maxValidRuns = min(collapseData.numSaLevels, length(collapseData.saLevelForEachRun));

    saLevelForEachRun     = collapseData.saLevelForEachRun(1:maxValidRuns);
    isCollapsedForEachRun = collapseData.isCollapsedForEachRun(1:maxValidRuns);
    isSingularForEachRun  = collapseData.isSingularForEachRun(1:maxValidRuns);
    isNonConvForEachRun   = collapseData.isNonConvForEachRun(1:maxValidRuns);
    maxMIDRForEachRun     = collapseData.maxDriftForEachRun(1:maxValidRuns);   % raw ratio

    % Load RDR and PFA — same file as sks_plot_AllComp_MSA RDR_PDF/PFA_PDF branch
    if exist(msaPlotDataFile, 'file')
        msaPlotData  = load(msaPlotDataFile, ...
            'maxResidualDriftRatioForPlotLIST', 'maxPFAForPlotLIST');
        maxRDRForEachRun    = msaPlotData.maxResidualDriftRatioForPlotLIST(:);   % raw ratio
        maxPFAForEachRun_g  = msaPlotData.maxPFAForPlotLIST(:) / 9810;           % mm/s² → g
        maxRDRForEachRun    = maxRDRForEachRun(1:maxValidRuns);
        maxPFAForEachRun_g  = maxPFAForEachRun_g(1:maxValidRuns);
    else
        warning('MSA plot data file missing: %s — RDR and PFA set to zero', msaPlotDataFile);
        maxRDRForEachRun   = zeros(maxValidRuns, 1);
        maxPFAForEachRun_g = zeros(maxValidRuns, 1);
    end

    % Remove padding zeros — keyed on saLevelForEachRun > 0,
    % same guard used in sks_PlotCollapse_singleAnaType_MSA
    validStripeRuns       = saLevelForEachRun > 0;
    saLevelForEachRun     = saLevelForEachRun(validStripeRuns);
    isCollapsedForEachRun = isCollapsedForEachRun(validStripeRuns);
    isSingularForEachRun  = isSingularForEachRun(validStripeRuns);
    isNonConvForEachRun   = isNonConvForEachRun(validStripeRuns);
    maxMIDRForEachRun     = maxMIDRForEachRun(validStripeRuns);
    maxRDRForEachRun      = maxRDRForEachRun(validStripeRuns);
    maxPFAForEachRun_g    = maxPFAForEachRun_g(validStripeRuns);

    % Force column vectors
    saLevelForEachRun     = saLevelForEachRun(:);
    isCollapsedForEachRun = isCollapsedForEachRun(:);
    isSingularForEachRun  = isSingularForEachRun(:);
    isNonConvForEachRun   = isNonConvForEachRun(:);
    maxMIDRForEachRun     = maxMIDRForEachRun(:);
    maxRDRForEachRun      = maxRDRForEachRun(:);
    maxPFAForEachRun_g    = maxPFAForEachRun_g(:);
end


% =========================================================================
% Local helper: aggregate run-level binary flags to stripe-level fractions
%
% Identical aggregation pattern to
% sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA:
%   numOfCollapses(stripe) = sum(isCollapsedForEachRun at that stripe)
% Here isCollapsedForEachRun is replaced by isExceedanceForEachRun.
%
% Inputs:
%   saLevelsForAllRuns   — Sa level per run (nRuns x 1)
%   binaryFlagForAllRuns — 0/1 flag per run: 1 = exceedance/collapse
% Outputs:
%   uniqueSaStripeList        — unique Sa stripe levels (nStripes x 1)
%   numGMsAtEachStripe        — number of runs at each stripe (nStripes x 1)
%   numExceedancesAtEachStripe — number of exceedances at each stripe (nStripes x 1)
%   exceedanceFractionAtEachStripe — numExc/numGM per stripe (nStripes x 1)
% =========================================================================
function [uniqueSaStripeList, numGMsAtEachStripe, numExceedancesAtEachStripe, ...
          exceedanceFractionAtEachStripe] = ...
        buildStripeFractions(saLevelsForAllRuns, binaryFlagForAllRuns)

    roundingTolerance    = 1e-4;
    saLevelsRounded      = round(saLevelsForAllRuns / roundingTolerance) * roundingTolerance;
    uniqueSaStripeList   = unique(saLevelsRounded);
    numStripes           = length(uniqueSaStripeList);
    numGMsAtEachStripe           = zeros(numStripes, 1);
    numExceedancesAtEachStripe   = zeros(numStripes, 1);

    for stripeIdx = 1:numStripes
        runsAtThisStripe                   = saLevelsRounded == uniqueSaStripeList(stripeIdx);
        numGMsAtEachStripe(stripeIdx)      = sum(runsAtThisStripe);
        numExceedancesAtEachStripe(stripeIdx) = sum(binaryFlagForAllRuns(runsAtThisStripe));
    end

    exceedanceFractionAtEachStripe = numExceedancesAtEachStripe ./ numGMsAtEachStripe;

    % Remove degenerate rows — same guard as collapse CDF processor
    validStripes         = uniqueSaStripeList > 0 & numGMsAtEachStripe > 0;
    uniqueSaStripeList   = uniqueSaStripeList(validStripes);
    numGMsAtEachStripe           = numGMsAtEachStripe(validStripes);
    numExceedancesAtEachStripe   = numExceedancesAtEachStripe(validStripes);
    exceedanceFractionAtEachStripe = exceedanceFractionAtEachStripe(validStripes);
end


% =========================================================================
% Local helper: print fragility summary table to console
% =========================================================================
function printFragilitySummaryTable(fragResults)

    demandTypeFieldPrefixes = {'midr',  'rdr',  'pfa' };
    demandTypeDisplayNames  = {'MIDR',  'RDR',  'PFA' };

    fprintf('\n========= Fragility Parameter Summary (MSA MLE) =========\n');
    fprintf('%-5s  %-6s  %-10s  %-10s  %-8s  %-10s  %-8s\n', ...
        'Type', 'Label', 'Threshold', 'theta_ctrl', 'beta_ctrl', 'theta_all', 'beta_all');
    fprintf('%s\n', repmat('-', 1, 68));

    for demandTypeIdx = 1:length(demandTypeFieldPrefixes)
        fieldPrefix  = demandTypeFieldPrefixes{demandTypeIdx};
        displayName  = demandTypeDisplayNames{demandTypeIdx};
        limitStateLevels = fragResults.([fieldPrefix 'Levels']);
        limitStateLabels = fragResults.([fieldPrefix 'LevelLabels']);
        thetaControl     = fragResults.([fieldPrefix 'ThetaControl']);
        betaControl      = fragResults.([fieldPrefix 'BetaControl']);
        thetaAllComp     = fragResults.([fieldPrefix 'ThetaAllComp']);
        betaAllComp      = fragResults.([fieldPrefix 'BetaAllComp']);

        for limitStateIdx = 1:length(limitStateLevels)
            fprintf('%-5s  %-6s  %-10.4f  %-10.3f  %-8.3f  %-10.3f  %-8.3f\n', ...
                displayName, ...
                limitStateLabels{limitStateIdx}, ...
                limitStateLevels(limitStateIdx), ...
                thetaControl(limitStateIdx), ...
                betaControl(limitStateIdx), ...
                thetaAllComp(limitStateIdx), ...
                betaAllComp(limitStateIdx));
        end
    end
    fprintf('%s\n', repmat('=', 1, 68));
end