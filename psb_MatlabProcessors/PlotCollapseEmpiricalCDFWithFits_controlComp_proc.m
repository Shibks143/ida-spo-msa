%
% Procedure: PlotCollapseEmpiricalCDFWithFits_controlComp_proc.m
% -------------------
% This procedure is the same as
% PlotCollapseEmpiricalCDFWithFits_controlComp.m, but is just a procedure.
%
% Assumptions and Notices:
%   - none
%
% Author: Curt Haselton
% Date Written: 3-24-05; updated to be a proc on 6-28-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions
%   - none listed here
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function PlotCollapseEmpiricalCDFWithFits_controlComp_proc(idaInputs)

sigmaLnModeling =            idaInputs.sigmaLnModeling;
analysisType =               idaInputs.analysisType;
eqListForCollapseIDAs_Name = idaInputs.eqListForCollapseIDAs_Name;
isConvertToSaKircher =       idaInputs.isConvertToSaKircher;
formatMode =                 idaInputs.formatMode;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select options

% Plot normal CDF?
%plotNormalCDF = 1;
plotNormalCDF = 0;

% Say whether or not you want the CDF plotted with only RTR variability
plotCDFWithRTRVariability = 1;
%         plotCDFWithRTRVariability = 0;

% Say whether or not you want to plot the individual EQ points
plotIndividualEQPoints = 1;
%         plotIndividualEQPoints = 0;

% Plot with expanded variance for modeling uncertainty (just does SRSS
% of sigmaLn for RTR and for modeling
plotCDFWithAdditionalUncertainty = 0;
%         plotCDFWithAdditionalUncertainty = 0;

markerTypeForIndivColResults = 'rs';
markerFaceColorForIndivColResults = 'w';
markerTypeForLognormal = 'r-';
markerTypeForLognormalExpandedVariance = 'b--';
markerTypeForNormal = 'b:';
minValueForPlot = 0.0;
maxValueForPlot = 5.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Calculations
% Go to the correct folder to open the file that was created by the
% collapse IDA plotter.
cd ..;

cd Output

analysisTypeFolder = sprintf('%s', analysisType);
cd(analysisTypeFolder);

% Open the file that was created by the IDA processor - only load the
% variables that I need
%   NOTICE - if you are opening a file that has resutls from just single
%   components, you will need to load "collapseLevelForChosenComp" instead of
%   "collapseLevelForAllControlComp".  Therefore this is now set up to plot
%   the controlling component for two horizontal components.
if(isConvertToSaKircher == 0)
    % Use Sa,GeoMean
    fileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaGeoMean.mat', eqListForCollapseIDAs_Name);
else
    % Use Sa,Kircher
    fileName = sprintf('DATA_collapse_CollapseSaAndStats_%s_SaATC63.mat', eqListForCollapseIDAs_Name);
end
load(fileName, 'collapseLevelForAllControlComp',...
    'meanCollapseSaTOneControlComp', 'meanLnCollapseSaTOneControlComp',...
    'stDevCollapseSaTOneControlComp', 'stDevLnCollapseSaTOneControlComp', 'periodUsedForScalingGroundMotions');

% Some calculations
numEQs = length(collapseLevelForAllControlComp);

% Sort the vector of collapse capacities so that it is monotonically
% increasing
collapseLevelForAllControlComp_sorted = sort(collapseLevelForAllControlComp);

% Created the cumm. prob values for each Sa,col
cummulativeProbOfCollapseEmpirical = [(1/numEQs):(1/numEQs):1.0];

% Plot the empirical CDF
hold on
if(plotIndividualEQPoints == 1)
    plot(collapseLevelForAllControlComp_sorted, cummulativeProbOfCollapseEmpirical, markerTypeForIndivColResults, 'MarkerFaceColor', markerFaceColorForIndivColResults);
end

% Plot the lognormal CDF or normal CDF with only RTR variability
if(plotCDFWithRTRVariability == 1)
    PlotLogNormalCDF(meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneControlComp, minValueForPlot, maxValueForPlot, markerTypeForLognormal)
    if(plotNormalCDF == 1)
        %           figure(figNum)
        PlotNormalCDF(meanCollapseSaTOneControlComp, stDevCollapseSaTOneControlComp, minValueForPlot, maxValueForPlot, markerTypeForNormal)
    end


    % Make the x-axis correct
    axis([minValueForPlot maxValueForPlot 0.0 1.0]);


    % (4-7-16, PSB) Added text for mean and beta_RTR values
    limitsOfAxes = axis;
    XdimOfAxis = limitsOfAxes(2) - limitsOfAxes(1);
    YdimOfAxis = limitsOfAxes(4) - limitsOfAxes(3);
    pos = [limitsOfAxes(1) + 0.70 * XdimOfAxis limitsOfAxes(3) + 0.70 * YdimOfAxis];
    text(pos(1), pos(2), {['$$\hat{S}_{CT} = ' sprintf('%5.3f', round(exp(meanLnCollapseSaTOneControlComp)*1000)/1000) '$$' char(10) '$$\beta_{RTR} = ' sprintf('%5.3f', round(stDevLnCollapseSaTOneControlComp*1000)/1000) '$$']}, 'Interpreter', 'latex', 'FontSize', 20, 'FontWeight', 'bold', 'BackgroundColor', [0.875 0.875 0.875]);
end

% Compute the variance expanded for modeling uncertainty and do lognormal
% plot of the expanded variance
if(plotCDFWithAdditionalUncertainty == 1)
    expandedSigmaLn = sqrt(stDevLnCollapseSaTOneControlComp ^ 2 + sigmaLnModeling ^ 2);
    % plot
    PlotLogNormalCDF(meanLnCollapseSaTOneControlComp, expandedSigmaLn, minValueForPlot, maxValueForPlot, markerTypeForLognormalExpandedVariance)
end


% Do final plot details
if(plotNormalCDF == 1)
    if(plotCDFWithAdditionalUncertainty == 1)
        legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Normal CDF (RTR Var.)', 'Lognormal CDF (RTR + Model.)', 'Location', 'Southeast');
    else
        legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Normal CDF (RTR Var.)', 'Location', 'Southeast');
    end
else
    if(plotCDFWithAdditionalUncertainty == 1)
        legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Lognormal CDF (RTR + Model.)', 'Location', 'Southeast');
    else
        legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Location', 'Southeast');
    end
end
box on
grid on

if(isConvertToSaKircher == 0)
    temp = sprintf('$\\mathrm{Sa}_{\\mathrm{geoM}}(\\mathrm{T} = %.2f\\,\\mathrm{s})\\,(\\mathrm{g})$', periodUsedForScalingGroundMotions);
else
    DefineSaKircherOverSaGeoMeanValues
    temp = axisLabelForSaKircher;
end
xlabel(temp,'Interpreter','latex');
ylabel('$\mathrm{IP}[\mathrm{collapse}]$', 'Interpreter', 'latex');

sks_figureFormat(formatMode)

% Save the plot
if(isConvertToSaKircher == 0)
    exportName = sprintf('CollapseCDF_ControlComp_SaGeoMean');
    sks_figureExport(exportName)
else
    exportName = sprintf('CollapseCDF_ControlComp_SaATC63');
    sks_figureExport(exportName)
end

% Go back to MatlabProcessors folder
cd ..;
cd ..;
cd psb_MatlabProcessors;

% Clear variables
clear collapseLevelForAllControlComp meanCollapseSaTOneControlComp meanLnCollapseSaTOneControlComp stDevCollapseSaTOneControlComp stDevLnCollapseSaTOneControlComp





















