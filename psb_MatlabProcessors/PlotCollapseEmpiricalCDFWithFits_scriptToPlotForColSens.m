%
% Procedure: PlotCollapseEmpiricalCDFWithFits_scriptToPlotForColSens.m
% -------------------
% Simply a script that will plot the collapse CDFs for the sensitivity
% analysis results.  Note that this runs off of variable number and opens
% the DefineVariableInfo.m file to know what values the variables were run
% at.
%
% Assumptions and Notices: 
%   - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 10-31-05
%
% Sources of Code: none
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the design and model to use
    model = 'DesA_Buffalo_v.9noGFrm_grndDisp';
    element = 'clough';

% Define the list of RVs that you would like to use...
    listOfVarNumbersToPlot = [1];

% Define the plotting options
    markerTypeForIndivColResults_low = 'ro--';
    markerTypeForIndivColResults_avg = 'bs-';
    markerTypeForIndivColResults_high = 'r^--';
    lineWidthForIndivColResults = 2;
    markerSize = 10;
    markerTypeForLognormal = 'b-';
    plotCDFWithRTRVariability = 0;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prelimary stuff
% Load the variable file to know what values the variables were run at 
    VariableLIST = DefineVariableInfo_Wall();
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop - make and save plots


    for currentVariableIndex = 1:length(listOfVarNumbersToPlot)
        currentVariableNum = listOfVarNumbersToPlot(currentVariableIndex);
        
        % Plot the low RV value results
        analysisType = sprintf('(%s)_(%s)_(%.2f)_(%s)', model, VariableLIST{currentVariableNum}.Variable, VariableLIST{currentVariableNum}.LowValue, element);
        markerTypeForIndivColResults = markerTypeForIndivColResults_low;
        PlotCollapseEmpiricalCDFWithFits_SingleComp_func(analysisType, markerTypeForIndivColResults, lineWidthForIndivColResults, markerSize, markerTypeForLognormal, plotCDFWithRTRVariability)
        hold on
        
        % Plot the mean RV value results
        analysisType = sprintf('(%s)_(AllVar)_(0.00)_(%s)', model, element);
        markerTypeForIndivColResults = markerTypeForIndivColResults_avg;
        PlotCollapseEmpiricalCDFWithFits_SingleComp_func(analysisType, markerTypeForIndivColResults, lineWidthForIndivColResults, markerSize, markerTypeForLognormal, plotCDFWithRTRVariability)
    
        % Plot the high RV value results
        analysisType = sprintf('(%s)_(%s)_(%.2f)_(%s)', model, VariableLIST{currentVariableNum}.Variable, VariableLIST{currentVariableNum}.HighValue, element);
        markerTypeForIndivColResults = markerTypeForIndivColResults_high;
        PlotCollapseEmpiricalCDFWithFits_SingleComp_func(analysisType, markerTypeForIndivColResults, lineWidthForIndivColResults, markerSize, markerTypeForLognormal, plotCDFWithRTRVariability)
     
        % Create the legend
        legend_1 = sprintf('Low RV Value (%.2f)', VariableLIST{currentVariableNum}.LowValue);
        legend_2 = sprintf('Mean RV Value (%.2f)', VariableLIST{currentVariableNum}.Mean);
        legend_3 = sprintf('High RV Value (%.2f)', VariableLIST{currentVariableNum}.HighValue);        
        legend(legend_1, legend_2, legend_3, 'Location', 'SouthEast');
        
        % Save figure
        % Go up a folder and into the Figures folder and save the plots
            cd Collapse_Uncertainty_Figures;
            % Save the plot as a .fig file - FIGURE folder
                plotName = sprintf('CollapseCDFs__Sens_WithVarPert_Var%d.fig', currentVariableNum);
                hgsave(plotName);
            % Export the plot as a .emf file (Matlab book page 455) - FIGURE
            % folder
                exportName = sprintf('CollapseCDFs__Sens_WithVarPert_Var%d.emf', currentVariableNum);
                print('-dmeta', exportName);
            % Go back to MatlabProcessors folder
                cd ..; 

        % Hold off
        hold off
        
        
        
        
    end










