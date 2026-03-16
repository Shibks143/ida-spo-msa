% %
% % Procedure: PlotCollapseEmpiricalCDFWithFits_controlComp_proc.m
% % -------------------
% % This procedure is the same as
% % PlotCollapseEmpiricalCDFWithFits_controlComp.m, but is just a procedure.
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
% % modified by Shivakumar K S on 13-Jan-2026 @iit madras
% % -------------------
function sks_PlotCollapseEmpiricalCDFWithFits_controlComp_proc_MSA(analysisTypeLIST, analysisType, eqNumberLIST, figNum,  isConvertToSaKircher)
startDir = pwd;

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Select options 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Legend font size - overrides the figure formatting script
       legendTextFontSizeInThisFile = 12;
% 
%     % Plot normal CDF?
%     %plotNormalCDF = 1;
       % plotNormalCDF = 0;  
% 
%     % Say whether or not you want the CDF plotted with only RTR variability
        % plotCDFWithRTRVariability = 1;
      % plotCDFWithRTRVariability = 0;
% 
%     % Say whether or not you want to plot the individual EQ points
        % plotIndividualEQPoints = 1;
        % plotIndividualEQPoints = 0;
% 
%     % Plot with expanded variance for modeling uncertainty (just does SRSS
%     % of sigmaLn for RTR and for modeling
      % plotCDFWithAdditionalUncertainty = 0;
%         plotCDFWithAdditionalUncertainty = 0;
% 
    % markerTypeForIndivColResults = 'rs';
    % markerFaceColorForIndivColResults = 'w';
    % markerTypeForLognormal = 'r-';
    % markerTypeForLognormalExpandedVariance = 'b--';
    % markerTypeForNormal = 'b:';
    minValueForPlot = 0.0;
    maxValueForPlot = 6;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -----------------------------
% MSA Post-processing Script
% -----------------------------
        

    for analysisTypeNum = 1:length(analysisTypeLIST)
            analysisType = analysisTypeLIST{analysisTypeNum};
            analysisTypeFolder = sprintf('%s', analysisType);
            % modelName = modelNameLIST{analysisTypeNum};
            
            cd ..
            cd Output
            fixedOutputDirectory = pwd;
                
            allSa = [];
            allCollapse = [];
           
        % for eqNumNum = 1:length(eqNumberLIST)
        %     eqNumber = eqNumberLIST(eqNumNum);
        % 
        %     cd(fixedOutputDirectory)
        % % 
        % %     % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
        %     analysisTypeFolder = sprintf('%s', analysisType);
        %     cd(analysisTypeFolder);
        % 
        %     % EQ folder name
        %     eqFolder = sprintf('EQ_%.0f', eqNumber);
        %     cd(eqFolder);
% 
% 
% % ============================================================
% % CONTROL COMPONENT SELECTION FOR MSA (MULTIPLE GROUND MOTIONS)
% % ============================================================
% 
% 
% load('DATA_CollapseResultsForThisSingleEQ.mat',  'saLevelForEachRun', 'isCollapsedForEachRun', 'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');
% % 
% % 
for eqNumNum = 1:2:length(eqNumberLIST)

    eqComp1 = eqNumberLIST(eqNumNum);
    eqComp2 = eqNumberLIST(eqNumNum+1);
   
    % --- Load component 1 ---
    eqFolder1 = sprintf('EQ_%d', eqComp1);
    load(fullfile(fixedOutputDirectory, analysisTypeFolder, eqFolder1, 'DATA_CollapseResultsForThisSingleEQ.mat'), 'saLevelForEachRun', 'isCollapsedForEachRun', 'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');

    sa1  = saLevelForEachRun(:);
    col1 = isCollapsedForEachRun(:);

    % --- Load component 2 ---
    eqFolder2 = sprintf('EQ_%d', eqComp2);
    load(fullfile(fixedOutputDirectory, analysisTypeFolder, eqFolder2, 'DATA_CollapseResultsForThisSingleEQ.mat'), 'saLevelForEachRun', 'isCollapsedForEachRun', 'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');

    sa2  = saLevelForEachRun(:);
    col2 = isCollapsedForEachRun(:);

   % Remove padding zeros separately
    valid1 = (sa1 > 0);
    valid2 = (sa2 > 0);

    sa1 = sa1(valid1);  col1 = col1(valid1);
    sa2 = sa2(valid2);  col2 = col2(valid2);


    % If no collapse in either component, still include it
    if ~any(col1==1) && ~any(col2==1)
        controlSa = min(sa1, sa2);          % conservative
        controlCollapse = zeros(size(sa1)); % no collapse
    else
        % Find first-collapse Sa for each component
        iCol1 = find(col1==1, 1, 'first');
        iCol2 = find(col2==1, 1, 'first');

        SaCol1 = sa1(iCol1);
        SaCol2 = sa2(iCol2);

        % Choose control component = earlier collapse
        if SaCol1 <= SaCol2
            controlSa = sa1;
            controlCollapse = col1;
        else
            controlSa = sa2;
            controlCollapse = col2;
        end
    end

    % Always add
    allSa       = [allSa; controlSa(:)];
    allCollapse = [allCollapse; controlCollapse(:)];
end


% % =====================================================
% % FINAL aggregation across ALL EQ folders
% % =====================================================
% 
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

% Remove bad rows (important)
    valid = saLevelList > 0 & numOfGroundMotions > 0;

    saLevelList        = saLevelList(valid);
    numOfGroundMotions = numOfGroundMotions(valid);
    numOfCollapses     = numOfCollapses(valid);
    collapseProbability = collapseProbability(valid);

    disp(table(saLevelList, numOfGroundMotions, numOfCollapses, collapseProbability))
    fprintf('\nTotal ground motions = %d\n', sum(numOfGroundMotions));
    fprintf('Total collapses       = %d\n', sum(numOfCollapses));



% estimate fragility function using MLE method
    [theta_hat, beta_hat] = sks_Mle_MSA(saLevelList, numOfGroundMotions, numOfCollapses);
    
    fprintf('θ̂ = %.3f g, β̂ = %.3f\n', theta_hat, beta_hat);

% compute fragility functions using estimated parameters
    IM_vals = 0.01:0.01:10; % IM levels to plot fragility function at
    
    P_Collapse = normcdf((log(IM_vals/theta_hat))/beta_hat); % compute fragility function using equation 1 and estimated parameters


%% plot resulting fragility functions
    figure
    plot(saLevelList, collapseProbability, 'rs', 'linewidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'r')
    set(gca, 'FontSize', 22);   
    
    hold on
    plot(IM_vals,P_Collapse, 'r-', 'linewidth', 4)
    legh = legend('Observed fractions of collapse', 'Fitted fragility function', 'location', 'southeast');
    
    xlim([minValueForPlot maxValueForPlot])
    ylim([0 1])


% (4-7-16, PSB) Added text for mean and beta_RTR values
    limitsOfAxes = [minValueForPlot maxValueForPlot 0 1];
    XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
    YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
    pos = [limitsOfAxes(1) + 0.70 * XdimOfAxis limitsOfAxes(3) + 0.70 * YdimOfAxis];
    text(pos(1), pos(2), { ['$$\hat{\theta} = ' sprintf('%5.3f', theta_hat) '\, g$$'],['$$\hat{\beta} = ' sprintf('%5.3f', beta_hat) '$$'] }, 'Interpreter', 'latex','FontSize', 22,'FontWeight', 'bold','BackgroundColor', [0.875 0.875 0.875]);

    % text(pos(1), pos(2), {['$$\hat{S}_{CT} = ' sprintf('%5.3f', round(exp(meanLnCollapseSaTOneControlComp)*1000)/1000) '$$' char(10) '$$\beta_{RTR} = ' sprintf('%5.3f', round(stDevLnCollapseSaTOneControlComp*1000)/1000) '$$']}, 'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', 'BackgroundColor', [0.875 0.875 0.875]);
    

    box on
    grid on
    % FigureFormatScript;
    set(gca,'Visible','on')
    

    if(isConvertToSaKircher == 0)
        temp = sprintf('$Sa_{geoM}(T=%.2f\\,s)\\,(g)$', periodUsedForScalingGroundMotions);
    else
        DefineSaKircherOverSaGeoMeanValues
        temp = axisLabelForSaKircher;
    end

    hx = xlabel(temp, 'Interpreter','latex','FontSize',22);
    hy = ylabel('$\mathrm{IP}[collapse]$', 'Interpreter','latex','FontSize',22);
    set([hx hy],'Color','k')
    
    % Force Space For Labels
    drawnow
    set(gca,'LooseInset', max(get(gca,'TightInset'), 0.08))

   
    % Make the legend text smaller
        set(legh, 'FontSize', legendTextFontSizeInThisFile);

% % Save the plot
    savePath = fullfile(fixedOutputDirectory, analysisTypeFolder); 
    
    if(isConvertToSaKircher == 0)
        exportName = 'CollapseCDF_ControlComp_SaGeoMean';
    else
        exportName = 'CollapseCDF_ControlComp_SaATC63';
    end
    
    % Save the figure in the correct folder
    savefig(fullfile(savePath, exportName));           % Matlab .fig
    print('-depsc', fullfile(savePath, exportName));  % .eps
    print('-dmeta', fullfile(savePath, exportName));  % .emf

% Go back to MatlabProcessors folder
    % cd ..;
    % cd ..;
    % cd ..;
    % cd psb_MatlabProcessors;
    cd(startDir);


   end   % ===== END analysisType LOOP =====

end   % ===== END function =====
