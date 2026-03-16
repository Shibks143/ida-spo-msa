%
% Procedure: PlotCollapseEmpiricalCDFWithFits.m
% -------------------
% This procedure opens the file that was made when plotting collapse IDAs
% (PlotCollapseIDAs.m) and then plots the empirical collapse CDF with the normal and lognormal
% fits.  Be careful about what records you are plotting the collapse IDAs
% for; this opens the file created by the collapse IDA processor, so this
% will plot the records that you most recently plotted collapse IDAs for.
%
% Note that this processor plots the collapse capacity for the coltrolling
% component after running both components of the EQ record (for approx. 3D
% collapse).
%
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 3-24-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so
% they will be different for different Sa values): 
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function[void] = PlotCollapseEmpiricalCDFWithFits()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% INPUT 
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
      plotCDFWithAdditionalUncertainty = 1;
%         plotCDFWithAdditionalUncertainty = 0;
    
    % Define the sigmaLn for the modeling uncertainty (used for plot option
    % just above)
    sigmaLnModeling = 0.50;

% Input the analysis type for this plot (i.e. the output folder)
    analysisType = '(DesID1_v.64)_(AllVar)_(0.00)_(clough)';
%     analysisType = '(DesID3_v.9noGFrm)_(AllVar)_(0.00)_(clough)';
%     analysisType = '(DesID5_v.2)_(AllVar)_(0.00)_(clough)';
%     analysisType = '(DesID9_v.3noGFrm)_(AllVar)_(0.00)_(clough)';
%     analysisType = '(DesA_Buffalo_v.9noGFrm)_(AllVar)_(0.00)_(clough)';
%     analysisType = '(DesWA_ATC63_v.26)_(AllVar)_(0.00)_(nonlinearBeamColumn)';
%     analysisType = '(Des12StryFrmB_half_ATC63_v.1)_(AllVar)_(Mean)_(clough)';

    
    markerTypeForIndivColResults = 'bo';
    markerTypeForLognormal = 'b-';
    markerTypeForLognormalExpandedVariance = 'b--';
    markerTypeForNormal = 'b:';
    minValueForPlot = 0.0;
    maxValueForPlot = 5.0;
    figNum = 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Calculations 
% Go to the correct folder to open the file that was created by the
% collapse IDA plotter.
    cd ..;
    cd Output;
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);

% Open the file that was created by the IDA processor - only load the
% variables that I need
%   NOTICE - if you are opening a file that has resutls from just single
%   componnents, you will need to load "collapseLevelForChosenComp" instead of 
%   "collapseLevelForAllControlComp".  Therefore this is now set up to plot
%   the controling component for two horizontal components.
    load DATA_collapse_CollapseSaAndStats.mat collapseLevelForAllControlComp...
        meanCollapseSaTOneControlComp meanLnCollapseSaTOneControlComp...
        stDevCollapseSaTOneControlComp stDevLnCollapseSaTOneControlComp

% Some calulations
    numEQs = length(collapseLevelForAllControlComp);
        
% Sort the vector of collapse capacities so that it is monotonically
% increasing
    collapseLevelForAllControlComp_sorted = sort(collapseLevelForAllControlComp);

% Created the cumm. prob values for each Sa,col
    cummulativeProbOfCollapseEmpirical = [(1/numEQs):(1/numEQs):1.0];

% Plot the empirical CDF
    hold on
    if(plotIndividualEQPoints == 1)
        plot(collapseLevelForAllControlComp_sorted, cummulativeProbOfCollapseEmpirical, markerTypeForIndivColResults);
    end
    
% Plot the lognormal CDF or normal CDF with only RTR variability
    if(plotCDFWithRTRVariability == 1)
        PlotLogNormalCDF(meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneControlComp, minValueForPlot, maxValueForPlot, markerTypeForLognormal)
        if(plotNormalCDF == 1)
%           figure(figNum)
            PlotNormalCDF(meanCollapseSaTOneControlComp, stDevCollapseSaTOneControlComp, minValueForPlot, maxValueForPlot, markerTypeForNormal)
        end
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
            legh = legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Normal CDF (RTR Var.)', 'Lognormal CDF (RTR + Modeling Var.)');
        else
            legh = legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Normal CDF (RTR Var.)');
        end
    else
        if(plotCDFWithAdditionalUncertainty == 1)
            legh = legend('Empirical CDF', 'Lognormal CDF (RTR Var.)', 'Lognormal CDF (RTR + Modeling Var.)');
        else
            legh = legend('Empirical CDF', 'Lognormal CDF (RTR Var.)');
        end
    end
    box on
    grid on
    titleText = sprintf('Emp. CDF of SaCol with Fitted Dist._%s', analysisType)
    title(titleText)
    hx = xlabel('Sa_{code}(T=1.0s) [g]')
    hy = ylabel('P[collapse]')
    FigureFormatScript
    

% Go back to MatlabProcessors folder
    cd ..;
    cd ..;
    cd MatlabProcessors;

% Clear variables
    clear collapseLevelForAllControlComp meanCollapseSaTOneControlComp meanLnCollapseSaTOneControlComp...
        stDevCollapseSaTOneControlComp stDevLnCollapseSaTOneControlComp











    
    
    
    
    
    
    
    
    
    
    