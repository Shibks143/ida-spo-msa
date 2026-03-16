% %
% % Procedure: PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc.m
% % -------------------
% % This procedure is just the same as
% % PlotCollapseEmpiricalCDFWithFits_plotAllComp.m, but is a procedure.
% %
% % Assumptions and Notices: 
% %           - This must be run with the current directory started in the "MatlabProcessing" folder.
% %
% % Author: Curt Haselton 
% % Date Written: 3-24-05; modified 6-28-06
% %
% % Sources of Code: none
% %
% % Functions and Procedures called: none
% %
% % Variable definitions
% %   - not included here
% %
% % Units: Whatever OpenSees is using - just be consistent!
% %
% % -------------------
function sks_PlotCollapseEmpiricalCDFWithFits_plotAllComp_proc_MSA(analysisTypeLIST, analysisType, eqNumberLIST, figNum, isConvertToSaKircher)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select options 

    % Legend font size - overrides the figure formatting script
    legendTextFontSizeInThisFile = 12;
    
    % Plot normal CDF?
    %plotNormalCDF = 1;
    % plotNormalCDF = 0;
    
    % Say whether or not you want the CDF plotted with only RTR variability
         % plotCDFWithRTRVariability = 1;
%         plotCDFWithRTRVariability = 0;

    % Say whether or not you want to plot the individual EQ points
        % plotIndividualEQPoints = 1;
%         plotIndividualEQPoints = 0;
    
    % Plot with expanded variance for modeling uncertainty (just does SRSS
    % of sigmaLn for RTR and for modeling
      % plotCDFWithAdditionalUncertainty = 0;
%         plotCDFWithAdditionalUncertainty = 0;
    
    markerTypeForIndivColResults = 'rs';
    markerFaceColorForIndivColResults = 'w';
    markerTypeForLognormal = 'r-';
    markerTypeForLognormalExpandedVariance = 'b--';
    markerTypeForNormal = 'b:';
    minValueForPlot = 0.0;
    maxValueForPlot = 6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Calculations 
% Go to the correct folder to open the file that was created by the
% collapse MSA plotter.
    cd ..;
    cd Output
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);



    for analysisTypeNum = 1:length(analysisTypeLIST)
                analysisType = analysisTypeLIST{analysisTypeNum};
                % modelName = modelNameLIST{analysisTypeNum};
                
                cd ..
                fixedOutputDirectory = pwd;
                
    allSa = [];
    allCollapse = [];
           
        for eqNumNum = 1:length(eqNumberLIST)
                eqNumber = eqNumberLIST(eqNumNum);

                    cd(fixedOutputDirectory)
                    
                    % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
                    analysisTypeFolder = sprintf('%s', analysisType);
                    cd(analysisTypeFolder);

                    % EQ folder name
                    eqFolder = sprintf('EQ_%.0f', eqNumber);
                    cd(eqFolder);


load('DATA_CollapseResultsForThisSingleEQ.mat', 'saLevelForEachRun', 'isCollapsedForEachRun', 'periodUsedForScalingGroundMotions', 'dampingRatioUsedForSaDef');

saLevelForEachRun     = saLevelForEachRun(:);
isCollapsedForEachRun = isCollapsedForEachRun(:);

allSa       = [allSa; saLevelForEachRun(:)];
allCollapse = [allCollapse; isCollapsedForEachRun(:)];

        end

% =====================================================
% FINAL aggregation across ALL EQ folders
% =====================================================

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
fprintf('Raw runs loaded       = %d\n\n', length(allSa));



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
        exportName = 'CollapseCDF_AllComp_SaGeoMean';
    else
        exportName = 'CollapseCDF_AllComp_SaATC63';
    end
    
    % Save the figure in the correct folder
    savefig(fullfile(savePath, exportName));           % Matlab .fig
    print('-depsc', fullfile(savePath, exportName));  % .eps
    print('-dmeta', fullfile(savePath, exportName));  % .emf

% Go back to MatlabProcessors folder
    cd ..;
    cd ..;
    cd ..;
    cd psb_MatlabProcessors;

     end
    end






% 
% 
% % Open the file that was created by the IDA processor - only load the
% % variables that I need
% %   NOTICE - if you are opening a file that has resutls from just single
% %   componnents, you will need to load "collapseLevelForChosenComp" instead of 
% %   "collapseLevelForAllControlComp".  Therefore this is now set up to plot
% %   the controling component for two horizontal components.
% 
% %     % ONLY CONTROLLING COMPONENTS
% %     load DATA_collapse_CollapseSaAndStats.mat collapseLevelForAllControlComp...
% %         meanCollapseSaTOneControlComp meanLnCollapseSaTOneControlComp...
% %         stDevCollapseSaTOneControlComp stDevLnCollapseSaTOneControlComp
% 
%     % % ALL COMPONENTS - altered on 9-16-05; change file name on 6-28-06
%     % if(isConvertToSaKircher == 0)
%     %     % Use Sa,GeoMean
%     %     fileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat');
%     % else
%     %     % Use Sa,Kircher
%     %     fileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63.mat');    
%     % end
%     % load(fileName, 'collapseLevelForAllComp','meanCollapseSaTOneAllComp', 'meanLnCollapseSaTOneAllComp','stDevCollapseSaTOneAllComp', 'stDevLnCollapseSaTOneAllComp', 'periodUsedForScalingGroundMotions')
%     % 
% % % Some calulations
% %     numEQs = length(collapseLevelForAllComp);
% % 
% % % Sort the vector of collapse capacities so that it is monotonically
% % % increasing
% %     collapseLevelForAllComp_sorted = sort(collapseLevelForAllComp);
% % 
% % % Created the cumm. prob values for each Sa,col
% %     cummulativeProbOfCollapseEmpirical = [(1/numEQs):(1/numEQs):1.0];
% 
% % % Plot the empirical CDF
% %     hold on
% %     if(plotIndividualEQPoints == 1)
% %         plot(collapseLevelForAllComp_sorted, cummulativeProbOfCollapseEmpirical, markerTypeForIndivColResults, 'MarkerFaceColor', markerFaceColorForIndivColResults);
% %     end
% 
% % % Plot the lognormal CDF or normal CDF with only RTR variability
% %     if(plotCDFWithRTRVariability == 1)
% %         PlotLogNormalCDF(meanLnCollapseSaTOneAllComp, stDevLnCollapseSaTOneAllComp, minValueForPlot, maxValueForPlot, markerTypeForLognormal)
% %         if(plotNormalCDF == 1)
% % %           figure(figNum)
% %             PlotNormalCDF(meanCollapseSaTOneAllComp, stDevCollapseSaTOneAllComp, minValueForPlot, maxValueForPlot, markerTypeForNormal)
% %         end
% 
% % (4-7-16, PSB) Added text for mean and beta_RTR values    
% 
%     limitsOfAxes = axis;
%     XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
%     YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
%     pos = [limitsOfAxes(1) + 0.55 * XdimOfAxis limitsOfAxes(3) + 0.70 * YdimOfAxis];
%     text(pos(1), pos(2), { ['$$\hat{\theta} = ' sprintf('%5.3f', theta_hat) '\, g$$'],['$$\hat{\beta} = ' sprintf('%5.3f', beta_hat) '$$'] }, 'Interpreter', 'latex','FontSize', 22,'FontWeight', 'bold','BackgroundColor', [0.875 0.875 0.875]);
%     % text(pos(1), pos(2), {['$$\hat{S}_{CT} = ' sprintf('%5.3f', round(exp(meanLnCollapseSaTOneAllComp)*1000)/1000) '$$' char(10) '$$\beta_{RTR} = ' sprintf('%5.3f', round(stDevLnCollapseSaTOneAllComp*1000)/1000) '$$']}, 'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', 'BackgroundColor', [0.875 0.875 0.875]);
%     % end
% 
% % Compute the variance expanded for modeling uncertainty and do lognormal
% % plot of the expanded variance
% % if(plotCDFWithAdditionalUncertainty == 1)
% %     expandedSigmaLn = sqrt(stDevLnCollapseSaTOneAllComp ^ 2 + sigmaLnModeling ^ 2);
% %     % plot
% %     PlotLogNormalCDF(meanLnCollapseSaTOneAllComp, expandedSigmaLn, minValueForPlot, maxValueForPlot, markerTypeForLognormalExpandedVariance)
% % end
% 
% 
% % Do final plot details
%     % if(plotNormalCDF == 1)
%     %     if(plotCDFWithAdditionalUncertainty == 1)
%     %         legh = legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Normal CDF (RTR Var.)', 'Lognormal CDF (RTR + Model.)', 'Location', 'Southeast');
%     %     else
%     %         legh = legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Normal CDF (RTR Var.)', 'Location', 'Southeast');
%     %     end
%     % else
%     %     if(plotCDFWithAdditionalUncertainty == 1)
%     %         legh = legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Lognormal CDF (RTR + Model.)', 'Location', 'Southeast');
%     %     else
%     %         legh = legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Location', 'Southeast');
%     %     end
%     % end
%     box on
%     grid on
%     %titleText = sprintf('Emp. CDF of SaCol (All Components) with Fitted Dist._%s', analysisType)
%     %title(titleText)
%     if(isConvertToSaKircher == 0)
%         temp = sprintf('Sa_{geoM}(T=%.2fs) (g)', periodUsedForScalingGroundMotions);
%     else
%         DefineSaKircherOverSaGeoMeanValues
%         temp = axisLabelForSaKircher;
%     end
%     hx = xlabel(temp);
% %     hy = ylabel('P[collapse]');
%     str2 = '${\rm I\!P} [collapse] $';
%     hy = ylabel(str2, 'Interpreter', 'latex');
% 
%     FigureFormatScript;
% 
%     % Make the legend text smaller
%         set(legh, 'FontSize', legendTextFontSizeInThisFile);
% 
%     % Make the x-axis correct
%     axis([minValueForPlot maxValueForPlot 0.0 1.0]);
% 
%     % Save the plot
%         if(isConvertToSaKircher == 0)
%             % Save the plot as a .fig file 
%            exportName = sprintf('CollapseCDF_AllComp_SaGeoMean');
%            hgsave(exportName); % .fig file for Matlab
%            print('-depsc', exportName); % .eps file for Linux (LaTeX)
%            print('-dmeta', exportName); % .emf file for Windows (MSWORD)
%     else
%             % Save the plot as a .fig file
%             %exportName = sprintf('CollapseCDF_AllComp_%s_%s_SaATC63.emf', analysisType, eqListForCollapseIDAs_Name);
%             exportName = sprintf('CollapseCDF_AllComp_SaATC63');
%            hgsave(exportName); % .fig file for Matlab
%            print('-depsc', exportName); % .eps file for Linux (LaTeX)
%            print('-dmeta', exportName); % .emf file for Windows (MSWORD)
%         end
% 
% % Go back to MatlabProcessors folder
%     cd ..;
%     cd ..;
%     cd psb_MatlabProcessors;
%     end