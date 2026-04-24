% %
% % Procedure: sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA
% % ---------
% %
% % Assumptions and Notices:
% %   - none
% %
% % Author: Curt Haselton
% % Date Written: 3-24-05; updated to be a proc on 6-28-06
% %
% % Sources of Code: none
% %
% % Functions and Procedures called: none
% %
% % Variable definitions
% %   - none listed here
% %
% % Units: Whatever OpenSees is using - just be consistent!
% % modified by Shivakumar K S on 11-Feb-2026 at IIT Madras
% % -------------------
function sks_PlotCollapseEmpiricalCDFWithFits_ControlCompAndAllComp_proc_MSA(msaInputs)

analysisTypeLIST = msaInputs.analysisTypeLIST;
eqNumberLIST     = msaInputs.eqNumberLIST;
isConvertToSaKircher = msaInputs.isConvertToSaKircher;


% ==========================================
% USER SETTINGS (Figure Output Control)
% ==========================================

formatMode    = 'default';    % 'default' | 'powerPoint' | 'report' | 'paper'

startDir = pwd;

% =========================
% Plot formatting options
% =========================
legendTextFontSizeInThisFile = 12;
minValueForPlot = 0.0;
maxValueForPlot = 3.0;

% ======================================
% LOOP over analysis types
% ======================================
for analysisTypeNum = 1:length(analysisTypeLIST)
    analysisType = analysisTypeLIST{analysisTypeNum};
    analysisTypeFolder = sprintf('%s', analysisType);

    % Go to Output folder safely
    cd(startDir);
    cd ..;
    cd Output;
    fixedOutputDirectory = pwd;

    fprintf('\n=========================================\n');
    fprintf('Processing analysisType = %s\n', analysisTypeFolder);
    fprintf('=========================================\n');

    % ============================================================
    % ========== 1) CONTROL COMPONENT (paired EQs) ================
    % ============================================================
    allSa_control = [];
    allCollapse_control = [];
    % --- Stripe-wise summary containers (ControlComp) ---
    saStripeList = [];           % will be taken from first pair
    nPairsPerStripe = [];
    nColComp1_perStripe = [];
    nColComp2_perStripe = [];
    nColControl_perStripe = [];
    isStripeListInitialized = false;

    for eqNum = 1:2:length(eqNumberLIST)
        eqComp1 = eqNumberLIST(eqNum);
        eqComp2 = eqNumberLIST(eqNum+1);

        % --- Load component 1 ---
        eqFolder1 = sprintf('EQ_%d', eqComp1);
        load(fullfile(fixedOutputDirectory, analysisTypeFolder, eqFolder1, ...
            'DATA_CollapseResultsForThisSingleEQ.mat'), ...
            'saLevelForEachRun', 'isCollapsedForEachRun', ...
            'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');

        saStripe_comp1  = saLevelForEachRun(:);
        isCollapse_comp1 = isCollapsedForEachRun(:);

        % --- Load component 2 ---
        eqFolder2 = sprintf('EQ_%d', eqComp2);
        load(fullfile(fixedOutputDirectory, analysisTypeFolder, eqFolder2, ...
            'DATA_CollapseResultsForThisSingleEQ.mat'), ...
            'saLevelForEachRun', 'isCollapsedForEachRun', ...
            'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');

        saStripe_comp2  = saLevelForEachRun(:);
        isCollapse_comp2 = isCollapsedForEachRun(:);

        % Remove padding zeros
        valid1 = (saStripe_comp1 > 0);
        valid2 = (saStripe_comp2 > 0);

        saStripe_comp1 = saStripe_comp1(valid1);  isCollapse_comp1 = isCollapse_comp1(valid1);
        saStripe_comp2 = saStripe_comp2(valid2);  isCollapse_comp2 = isCollapse_comp2(valid2);

        % ===== Correct CONTROL COMP logic for MSA =====
        % Both components correspond to the same stripe levels.
        % Collapse for the pair at a stripe = collapse in either component.
        % ===== Ensure stripe alignment (length + values) =====
        if length(saStripe_comp1) ~= length(saStripe_comp2) || any(abs(saStripe_comp1 - saStripe_comp2) > 1e-6)
            error('Stripe mismatch between EQ_%d and EQ_%d', eqComp1, eqComp2);
        end
        
        % if length(saStripe_comp1) ~= length(saStripe_comp2)
        %     error('Stripe length mismatch between EQ_%d and EQ_%d', eqComp1, eqComp2);
        % end

        saStripe_control   = saStripe_comp1;     % stripe Sa values
        isCollapse_control = max(isCollapse_comp1, isCollapse_comp2); % OR collapse across components


        % --- Initialize stripe list once (from first pair) ---
        if ~isStripeListInitialized
            saStripeList = saStripe_control(:);
            nPairsPerStripe = zeros(length(saStripeList),1);
            nColComp1_perStripe = zeros(length(saStripeList),1);
            nColComp2_perStripe = zeros(length(saStripeList),1);
            nColControl_perStripe = zeros(length(saStripeList),1);
            isStripeListInitialized = true;
        end

        % --- Accumulate stripe-wise collapse counts ---
        for k = 1:length(saStripe_control)
            nPairsPerStripe(k) = nPairsPerStripe(k) + 1;
            nColComp1_perStripe(k) = nColComp1_perStripe(k) + isCollapse_comp1(k);
            nColComp2_perStripe(k) = nColComp2_perStripe(k) + isCollapse_comp2(k);
            nColControl_perStripe(k) = nColControl_perStripe(k) + isCollapse_control(k);
        end

        allSa_control       = [allSa_control; saStripe_control(:)];
        allCollapse_control = [allCollapse_control; isCollapse_control(:)];

    end
    fprintf('\n================ CONTROL COMP STRIPE SUMMARY ================\n');

    Tcontrol = table(saStripeList, nPairsPerStripe, nColComp1_perStripe, nColComp2_perStripe, nColControl_perStripe, nColControl_perStripe./nPairsPerStripe, ...
        'VariableNames', {'Sa', 'nPairs', 'nCol_Comp1', 'nCol_Comp2', 'nCol_Control', 'Pcollapse_Control'});

    disp(Tcontrol);

    fprintf('\n--- CONTROL COMP (Pairs) collapse summary ---\n');

    tol = 1e-4;
    saC = round(allSa_control/tol)*tol;
    saListC = unique(saC);

    for i = 1:length(saListC)
        idx = saC == saListC(i);
        nGM = sum(idx);
        nCol = sum(allCollapse_control(idx));

        fprintf('Sa = %.2f : nPairs = %2d, nCollapse = %2d, P = %.3f\n', saListC(i), nGM, nCol, nCol/nGM);
    end

    % Export name (CONTROL)
    if isConvertToSaKircher == 0
        exportName = 'CollapseCDF_ControlComp_SaGeoMean';
    else
        exportName = 'CollapseCDF_ControlComp_SaATC63';
    end

    sks_plotMSAFragilityFromRuns(allSa_control, allCollapse_control, minValueForPlot, maxValueForPlot, legendTextFontSizeInThisFile, exportName, fixedOutputDirectory, analysisTypeFolder, periodUsedForScalingGroundMotions, isConvertToSaKircher, formatMode);


    % ============================================================
    % ========== 2) ALL COMPONENTS (all EQ folders) ==============
    % ============================================================
    allSa_all = [];
    allCollapse_all = [];

    for eqNum = 1:length(eqNumberLIST)
        eqNumber = eqNumberLIST(eqNum);
        eqFolder = sprintf('EQ_%d', eqNumber);

        load(fullfile(fixedOutputDirectory, analysisTypeFolder, eqFolder, 'DATA_CollapseResultsForThisSingleEQ.mat'), 'saLevelForEachRun', 'isCollapsedForEachRun', ...
            'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');

        saStripe_allComp = saLevelForEachRun(:);
        isCollapse_allComp = isCollapsedForEachRun(:);

        valid = (saStripe_allComp > 0);
        saStripe_allComp = saStripe_allComp(valid);
        isCollapse_allComp = isCollapse_allComp(valid);

        allSa_all       = [allSa_all; saStripe_allComp(:)];
        allCollapse_all = [allCollapse_all; isCollapse_allComp(:)];
    end

    fprintf('\n--- ALL COMP (Components) collapse summary ---\n');

    tol = 1e-4;
    saA = round(allSa_all/tol)*tol;
    saListA = unique(saA);

    for i = 1:length(saListA)
        idx = saA == saListA(i);
        nGM = sum(idx);
        nCol = sum(allCollapse_all(idx));

        fprintf('Sa = %.2f : nComp = %2d, nCollapse = %2d, P = %.3f\n', saListA(i), nGM, nCol, nCol/nGM);
    end

    % Export name (ALL)
    if isConvertToSaKircher == 0
        exportName = 'CollapseCDF_AllComp_SaGeoMean';
    else
        exportName = 'CollapseCDF_AllComp_SaATC63';
    end

    sks_plotMSAFragilityFromRuns(allSa_all, allCollapse_all, minValueForPlot, maxValueForPlot, legendTextFontSizeInThisFile, exportName, fixedOutputDirectory, analysisTypeFolder, periodUsedForScalingGroundMotions, isConvertToSaKircher, formatMode);

end

cd(startDir);
fprintf('\nDone.\n');

end



% ==========================================================
% Helper function (must be below main function in same file)
% ==========================================================
function sks_plotMSAFragilityFromRuns(allSa, allCollapse, minValueForPlot, maxValueForPlot, legendTextFontSizeInThisFile, exportName, fixedOutputDirectory, analysisTypeFolder, periodUsedForScalingGroundMotions, isConvertToSaKircher,formatMode)

% Round to avoid float mismatch
tol = 1e-4;
allSa = round(allSa/tol)*tol;

saLevelList = unique(allSa);
numOfStripes = length(saLevelList);
numOfGroundMotions = zeros(numOfStripes,1);
numOfCollapses     = zeros(numOfStripes,1);

for i = 1:numOfStripes
    idx = allSa == saLevelList(i);
    numOfGroundMotions(i) = sum(idx);
    numOfCollapses(i)     = sum(allCollapse(idx));
end

collapseProbability = numOfCollapses ./ numOfGroundMotions;

% Remove invalid rows
valid = saLevelList > 0 & numOfGroundMotions > 0;

saLevelList         = saLevelList(valid);
numOfGroundMotions  = numOfGroundMotions(valid);
numOfCollapses      = numOfCollapses(valid);
collapseProbability = collapseProbability(valid);

disp(table(saLevelList, numOfGroundMotions, numOfCollapses, collapseProbability))

fprintf('\nTotal ground motions = %d\n', sum(numOfGroundMotions));
fprintf('Total collapses       = %d\n', sum(numOfCollapses));

% ===== MLE Fit =====
[theta_hat, beta_hat] = sks_Mle_MSA(saLevelList, numOfGroundMotions, numOfCollapses);
fprintf('θ^ = %.3f g, β^ = %.3f\n', theta_hat, beta_hat);

IM_vals = 0.01:0.01:10;
P_Collapse = normcdf((log(IM_vals/theta_hat))/beta_hat);

% ===== Plot =====
figure;
plot(saLevelList, collapseProbability, 'rs', 'linewidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'r');
hold on;
plot(IM_vals, P_Collapse, 'r-', 'linewidth', 4);

legh = legend('Observed fractions of collapse','Fitted fragility function','location', 'southeast');
    set(legh, 'FontSize', legendTextFontSizeInThisFile);

xlim([minValueForPlot maxValueForPlot]);
% xlim([0, max(saLevelList)*1.05]);
ylim([0 1]);

% Get actual axis limits
% limitsOfAxes = axis;   % [xmin xmax ymin ymax]
limitsOfAxes = [minValueForPlot maxValueForPlot 0 1];
XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
pos = [limitsOfAxes(1) + 0.70 * XdimOfAxis, limitsOfAxes(3) + 0.70 * YdimOfAxis];

text(pos(1), pos(2), ...
    {['$$\hat{\theta} = ' sprintf('%5.3f', theta_hat) '\, g$$'], ...
    ['$$\hat{\beta} = ' sprintf('%5.3f', beta_hat) '$$']}, ...
    'Interpreter', 'latex', 'FontSize', 22, 'FontWeight', 'bold', ...
    'BackgroundColor', [0.875 0.875 0.875]);

box on; grid on;

% Axis label
if(isConvertToSaKircher == 0)
    temp = sprintf('$Sa_{geoM}(T=%.2f\\,s)\\,(g)$', periodUsedForScalingGroundMotions);
else
    DefineSaKircherOverSaGeoMeanValues
    temp = axisLabelForSaKircher;
end

xlabel(temp, 'Interpreter','latex');
ylabel('$\mathrm{IP}[collapse]$', 'Interpreter','latex');

% === Apply formatting + export ===
sks_figureFormat(formatMode);
fullExportPath = fullfile(fixedOutputDirectory, analysisTypeFolder, exportName);
sks_figureExport(fullExportPath);
% sks_figureExport(exportName);

end





















%
%
%
% %
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % Select options
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     % Legend font size - overrides the figure formatting script
%        legendTextFontSizeInThisFile = 12;
% %
% %     % Plot normal CDF?
% %     %plotNormalCDF = 1;
%        % plotNormalCDF = 0;
% %
% %     % Say whether or not you want the CDF plotted with only RTR variability
%         % plotCDFWithRTRVariability = 1;
%       % plotCDFWithRTRVariability = 0;
% %
% %     % Say whether or not you want to plot the individual EQ points
%         % plotIndividualEQPoints = 1;
%         % plotIndividualEQPoints = 0;
% %
% %     % Plot with expanded variance for modeling uncertainty (just does SRSS
% %     % of sigmaLn for RTR and for modeling
%       % plotCDFWithAdditionalUncertainty = 0;
% %         plotCDFWithAdditionalUncertainty = 0;
% %
%     % markerTypeForIndivColResults = 'rs';
%     % markerFaceColorForIndivColResults = 'w';
%     % markerTypeForLognormal = 'r-';
%     % markerTypeForLognormalExpandedVariance = 'b--';
%     % markerTypeForNormal = 'b:';
%     minValueForPlot = 0.0;
%     maxValueForPlot = 6;
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % -----------------------------
% % MSA Post-processing Script
% % -----------------------------
%
%
%     for analysisTypeNum = 1:length(analysisTypeLIST)
%             analysisType = analysisTypeLIST{analysisTypeNum};
%             analysisTypeFolder = sprintf('%s', analysisType);
%             % modelName = modelNameLIST{analysisTypeNum};
%
%             cd ..
%             cd Output
%             fixedOutputDirectory = pwd;
%
%             allSa = [];
%             allCollapse = [];
%
%         % for eqNumNum = 1:length(eqNumberLIST)
%         %     eqNumber = eqNumberLIST(eqNumNum);
%         %
%         %     cd(fixedOutputDirectory)
%         % %
%         % %     % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
%         %     analysisTypeFolder = sprintf('%s', analysisType);
%         %     cd(analysisTypeFolder);
%         %
%         %     % EQ folder name
%         %     eqFolder = sprintf('EQ_%.0f', eqNumber);
%         %     cd(eqFolder);
% %
% %
% % % ============================================================
% % % CONTROL COMPONENT SELECTION FOR MSA (MULTIPLE GROUND MOTIONS)
% % % ============================================================
% %
% %
% % load('DATA_CollapseResultsForThisSingleEQ.mat',  'saLevelForEachRun', 'isCollapsedForEachRun', 'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');
% % %
% % %
% for eqNumNum = 1:2:length(eqNumberLIST)
%
%     eqComp1 = eqNumberLIST(eqNumNum);
%     eqComp2 = eqNumberLIST(eqNumNum+1);
%
%     % --- Load component 1 ---
%     eqFolder1 = sprintf('EQ_%d', eqComp1);
%     load(fullfile(fixedOutputDirectory, analysisTypeFolder, eqFolder1, 'DATA_CollapseResultsForThisSingleEQ.mat'), 'saLevelForEachRun', 'isCollapsedForEachRun', 'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');
%
%     sa1  = saLevelForEachRun(:);
%     col1 = isCollapsedForEachRun(:);
%
%     % --- Load component 2 ---
%     eqFolder2 = sprintf('EQ_%d', eqComp2);
%     load(fullfile(fixedOutputDirectory, analysisTypeFolder, eqFolder2, 'DATA_CollapseResultsForThisSingleEQ.mat'), 'saLevelForEachRun', 'isCollapsedForEachRun', 'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');
%
%     sa2  = saLevelForEachRun(:);
%     col2 = isCollapsedForEachRun(:);
%
%    % Remove padding zeros separately
%     valid1 = (sa1 > 0);
%     valid2 = (sa2 > 0);
%
%     sa1 = sa1(valid1);  col1 = col1(valid1);
%     sa2 = sa2(valid2);  col2 = col2(valid2);
%
%
%     % If no collapse in either component, still include it
%     if ~any(col1==1) && ~any(col2==1)
%         controlSa = min(sa1, sa2);          % conservative
%         controlCollapse = zeros(size(sa1)); % no collapse
%     else
%         % Find first-collapse Sa for each component
%         iCol1 = find(col1==1, 1, 'first');
%         iCol2 = find(col2==1, 1, 'first');
%
%         SaCol1 = sa1(iCol1);
%         SaCol2 = sa2(iCol2);
%
%         % Choose control component = earlier collapse
%         if SaCol1 <= SaCol2
%             controlSa = sa1;
%             controlCollapse = col1;
%         else
%             controlSa = sa2;
%             controlCollapse = col2;
%         end
%     end
%
%     % Always add
%     allSa       = [allSa; controlSa(:)];
%     allCollapse = [allCollapse; controlCollapse(:)];
% end
%
%
% % % =====================================================
% % % FINAL aggregation across ALL EQ folders
% % % =====================================================
% %
%     tol = 1e-4;
%     allSa = round(allSa/tol)*tol;
%     saLevelList = unique(allSa);
%     numOfStripes = length(saLevelList);
%     numOfGroundMotions = zeros(numOfStripes,1);
%     numOfCollapses     = zeros(numOfStripes,1);
%
% for i = 1:numOfStripes
%     idx = allSa == saLevelList(i);
%     numOfGroundMotions(i) = sum(idx);
%     numOfCollapses(i)     = sum(allCollapse(idx));
% end
%
% collapseProbability = numOfCollapses ./ numOfGroundMotions;
%
% % Remove bad rows (important)
%     valid = saLevelList > 0 & numOfGroundMotions > 0;
%
%     saLevelList        = saLevelList(valid);
%     numOfGroundMotions = numOfGroundMotions(valid);
%     numOfCollapses     = numOfCollapses(valid);
%     collapseProbability = collapseProbability(valid);
%
%     disp(table(saLevelList, numOfGroundMotions, numOfCollapses, collapseProbability))
%     fprintf('\nTotal ground motions = %d\n', sum(numOfGroundMotions));
%     fprintf('Total collapses       = %d\n', sum(numOfCollapses));
%
%
%
% % estimate fragility function using MLE method
%     [theta_hat, beta_hat] = sks_Mle_MSA(saLevelList, numOfGroundMotions, numOfCollapses);
%
%     fprintf('θ̂ = %.3f g, β̂ = %.3f\n', theta_hat, beta_hat);
%
% % compute fragility functions using estimated parameters
%     IM_vals = 0.01:0.01:10; % IM levels to plot fragility function at
%
%     P_Collapse = normcdf((log(IM_vals/theta_hat))/beta_hat); % compute fragility function using equation 1 and estimated parameters
%
%
% %% plot resulting fragility functions
%     figure
%     plot(saLevelList, collapseProbability, 'rs', 'linewidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'r')
%     set(gca, 'FontSize', 22);
%
%     hold on
%     plot(IM_vals,P_Collapse, 'r-', 'linewidth', 4)
%     legh = legend('Observed fractions of collapse', 'Fitted fragility function', 'location', 'southeast');
%
%     xlim([minValueForPlot maxValueForPlot])
%     ylim([0 1])
%
%
% % (4-7-16, PSB) Added text for mean and beta_RTR values
%     limitsOfAxes = [minValueForPlot maxValueForPlot 0 1];
%     XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
%     YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
%     pos = [limitsOfAxes(1) + 0.70 * XdimOfAxis limitsOfAxes(3) + 0.70 * YdimOfAxis];
%     text(pos(1), pos(2), { ['$$\hat{\theta} = ' sprintf('%5.3f', theta_hat) '\, g$$'],['$$\hat{\beta} = ' sprintf('%5.3f', beta_hat) '$$'] }, 'Interpreter', 'latex','FontSize', 22,'FontWeight', 'bold','BackgroundColor', [0.875 0.875 0.875]);
%
%     % text(pos(1), pos(2), {['$$\hat{S}_{CT} = ' sprintf('%5.3f', round(exp(meanLnCollapseSaTOneControlComp)*1000)/1000) '$$' char(10) '$$\beta_{RTR} = ' sprintf('%5.3f', round(stDevLnCollapseSaTOneControlComp*1000)/1000) '$$']}, 'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', 'BackgroundColor', [0.875 0.875 0.875]);
%
%
%     box on
%     grid on
%     % FigureFormatScript;
%     set(gca,'Visible','on')
%
%
%     if(isConvertToSaKircher == 0)
%         temp = sprintf('$Sa_{geoM}(T=%.2f\\,s)\\,(g)$', periodUsedForScalingGroundMotions);
%     else
%         DefineSaKircherOverSaGeoMeanValues
%         temp = axisLabelForSaKircher;
%     end
%
%     hx = xlabel(temp, 'Interpreter','latex','FontSize',22);
%     hy = ylabel('$\mathrm{IP}[collapse]$', 'Interpreter','latex','FontSize',22);
%     set([hx hy],'Color','k')
%
%     % Force Space For Labels
%     drawnow
%     set(gca,'LooseInset', max(get(gca,'TightInset'), 0.08))
%
%
%     % Make the legend text smaller
%         set(legh, 'FontSize', legendTextFontSizeInThisFile);
%
% % % Save the plot
%     savePath = fullfile(fixedOutputDirectory, analysisTypeFolder);
%
%     if(isConvertToSaKircher == 0)
%         exportName = 'CollapseCDF_ControlComp_SaGeoMean';
%     else
%         exportName = 'CollapseCDF_ControlComp_SaATC63';
%     end
%
%     % Save the figure in the correct folder
%     savefig(fullfile(savePath, exportName));           % Matlab .fig
%     print('-depsc', fullfile(savePath, exportName));  % .eps
%     print('-dmeta', fullfile(savePath, exportName));  % .emf
%
% % Go back to MatlabProcessors folder
%     % cd ..;
%     % cd ..;
%     % cd ..;
%     % cd psb_MatlabProcessors;
%     cd(startDir);
%
%
%    end   % ===== END analysisType LOOP =====
%
% end   % ===== END function =====
%
%
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Select options
%
%     % Legend font size - overrides the figure formatting script
%     legendTextFontSizeInThisFile = 12;
%
%     % Plot normal CDF?
%     %plotNormalCDF = 1;
%     % plotNormalCDF = 0;
%
%     % Say whether or not you want the CDF plotted with only RTR variability
%          % plotCDFWithRTRVariability = 1;
% %         plotCDFWithRTRVariability = 0;
%
%     % Say whether or not you want to plot the individual EQ points
%         % plotIndividualEQPoints = 1;
% %         plotIndividualEQPoints = 0;
%
%     % Plot with expanded variance for modeling uncertainty (just does SRSS
%     % of sigmaLn for RTR and for modeling
%       % plotCDFWithAdditionalUncertainty = 0;
% %         plotCDFWithAdditionalUncertainty = 0;
%
%     markerTypeForIndivColResults = 'rs';
%     markerFaceColorForIndivColResults = 'w';
%     markerTypeForLognormal = 'r-';
%     markerTypeForLognormalExpandedVariance = 'b--';
%     markerTypeForNormal = 'b:';
%     minValueForPlot = 0.0;
%     maxValueForPlot = 6;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%% Calculations
% % Go to the correct folder to open the file that was created by the
% % collapse MSA plotter.
%     cd ..;
%     cd Output
%     analysisTypeFolder = sprintf('%s', analysisType);
%     cd(analysisTypeFolder);
%
%
%
%     for analysisTypeNum = 1:length(analysisTypeLIST)
%                 analysisType = analysisTypeLIST{analysisTypeNum};
%                 % modelName = modelNameLIST{analysisTypeNum};
%
%                 cd ..
%                 fixedOutputDirectory = pwd;
%
%     allSa = [];
%     allCollapse = [];
%
%         for eqNumNum = 1:length(eqNumberLIST)
%                 eqNumber = eqNumberLIST(eqNumNum);
%
%                     cd(fixedOutputDirectory)
%
%                     % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
%                     analysisTypeFolder = sprintf('%s', analysisType);
%                     cd(analysisTypeFolder);
%
%                     % EQ folder name
%                     eqFolder = sprintf('EQ_%.0f', eqNumber);
%                     cd(eqFolder);
%
%
% load('DATA_CollapseResultsForThisSingleEQ.mat', 'saLevelForEachRun', 'isCollapsedForEachRun', 'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');
%
% saLevelForEachRun     = saLevelForEachRun(:);
% isCollapsedForEachRun = isCollapsedForEachRun(:);
%
% allSa       = [allSa; saLevelForEachRun(:)];
% allCollapse = [allCollapse; isCollapsedForEachRun(:)];
%
%         end
%
% % =====================================================
% % FINAL aggregation across ALL EQ folders
% % =====================================================
%
% saLevelList = unique(allSa);
% numOfStripes = length(saLevelList);
%
% numOfGroundMotions = zeros(numOfStripes,1);
% numOfCollapses     = zeros(numOfStripes,1);
%
% for i = 1:numOfStripes
%     idx = allSa == saLevelList(i);
%     numOfGroundMotions(i) = sum(idx);
%     numOfCollapses(i)     = sum(allCollapse(idx));
% end
%
% collapseProbability = numOfCollapses ./ numOfGroundMotions;
%
% % Remove bad rows (important)
% valid = saLevelList > 0 & numOfGroundMotions > 0;
%
% saLevelList        = saLevelList(valid);
% numOfGroundMotions = numOfGroundMotions(valid);
% numOfCollapses     = numOfCollapses(valid);
% collapseProbability = collapseProbability(valid);
%
% disp(table(saLevelList, numOfGroundMotions, numOfCollapses, collapseProbability))
% fprintf('\nTotal ground motions = %d\n', sum(numOfGroundMotions));
% fprintf('Total collapses       = %d\n', sum(numOfCollapses));
% fprintf('Raw runs loaded       = %d\n\n', length(allSa));
%
%
%
% % estimate fragility function using MLE method
% [theta_hat, beta_hat] = sks_Mle_MSA(saLevelList, numOfGroundMotions, numOfCollapses);
%
% fprintf('θ̂ = %.3f g, β̂ = %.3f\n', theta_hat, beta_hat);
%
% % compute fragility functions using estimated parameters
% IM_vals = 0.01:0.01:10; % IM levels to plot fragility function at
%
% P_Collapse = normcdf((log(IM_vals/theta_hat))/beta_hat); % compute fragility function using equation 1 and estimated parameters
%
%
% %% plot resulting fragility functions
% figure
% plot(saLevelList, collapseProbability, 'rs', 'linewidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'r')
% set(gca, 'FontSize', 22);
%
% hold on
% plot(IM_vals,P_Collapse, 'r-', 'linewidth', 4)
% legh = legend('Observed fractions of collapse', 'Fitted fragility function', 'location', 'southeast');
%
% xlim([minValueForPlot maxValueForPlot])
% ylim([0 1])
%
%
% % (4-7-16, PSB) Added text for mean and beta_RTR values
%     limitsOfAxes = [minValueForPlot maxValueForPlot 0 1];
%     XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
%     YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
%     pos = [limitsOfAxes(1) + 0.70 * XdimOfAxis limitsOfAxes(3) + 0.70 * YdimOfAxis];
%     text(pos(1), pos(2), { ['$$\hat{\theta} = ' sprintf('%5.3f', theta_hat) '\, g$$'],['$$\hat{\beta} = ' sprintf('%5.3f', beta_hat) '$$'] }, 'Interpreter', 'latex','FontSize', 22,'FontWeight', 'bold','BackgroundColor', [0.875 0.875 0.875]);
%
%     % text(pos(1), pos(2), {['$$\hat{S}_{CT} = ' sprintf('%5.3f', round(exp(meanLnCollapseSaTOneControlComp)*1000)/1000) '$$' char(10) '$$\beta_{RTR} = ' sprintf('%5.3f', round(stDevLnCollapseSaTOneControlComp*1000)/1000) '$$']}, 'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', 'BackgroundColor', [0.875 0.875 0.875]);
%
%
%     box on
%     grid on
%     % FigureFormatScript;
%     set(gca,'Visible','on')
%
%
%     if(isConvertToSaKircher == 0)
%         temp = sprintf('$Sa_{geoM}(T=%.2f\\,s)\\,(g)$', periodUsedForScalingGroundMotions);
%     else
%         DefineSaKircherOverSaGeoMeanValues
%         temp = axisLabelForSaKircher;
%     end
%
%     hx = xlabel(temp, 'Interpreter','latex','FontSize',22);
%     hy = ylabel('$\mathrm{IP}[collapse]$', 'Interpreter','latex','FontSize',22);
%     set([hx hy],'Color','k')
%
%     % Force Space For Labels
%     drawnow
%     set(gca,'LooseInset', max(get(gca,'TightInset'), 0.08))
%
%
%     % Make the legend text smaller
%         set(legh, 'FontSize', legendTextFontSizeInThisFile);
%
% % % Save the plot
%     savePath = fullfile(fixedOutputDirectory, analysisTypeFolder);
%
%     if(isConvertToSaKircher == 0)
%         exportName = 'CollapseCDF_AllComp_SaGeoMean';
%     else
%         exportName = 'CollapseCDF_AllComp_SaATC63';
%     end
%
%     % Save the figure in the correct folder
%     savefig(fullfile(savePath, exportName));           % Matlab .fig
%     print('-depsc', fullfile(savePath, exportName));  % .eps
%     print('-dmeta', fullfile(savePath, exportName));  % .emf
%
% % Go back to MatlabProcessors folder
%     cd ..;
%     cd ..;
%     cd ..;
%     cd psb_MatlabProcessors;
%
%      end
%     end
