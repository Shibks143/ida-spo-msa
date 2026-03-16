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
    listOfVarNumbersToPlot = [99999];

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
        
%         % Plot the low RV value results
%         analysisType = sprintf('(%s)_(%s)_(%.2f)_(%s)', model, VariableLIST{currentVariableNum}.Variable, VariableLIST{currentVariableNum}.LowValue, element);
%         markerTypeForIndivColResults = markerTypeForIndivColResults_low;
%         PlotCollapseEmpiricalCDFWithFits_SingleComp_func(analysisType, markerTypeForIndivColResults, lineWidthForIndivColResults, markerSize, markerTypeForLognormal, plotCDFWithRTRVariability)
%         hold on
%         
%         % Plot the mean RV value results
%         analysisType = sprintf('(%s)_(AllVar)_(0.00)_(%s)', model, element);
%         markerTypeForIndivColResults = markerTypeForIndivColResults_avg;
%         PlotCollapseEmpiricalCDFWithFits_SingleComp_func(analysisType, markerTypeForIndivColResults, lineWidthForIndivColResults, markerSize, markerTypeForLognormal, plotCDFWithRTRVariability)
%     
%         % Plot the high RV value results
%         analysisType = sprintf('(%s)_(%s)_(%.2f)_(%s)', model, VariableLIST{currentVariableNum}.Variable, VariableLIST{currentVariableNum}.HighValue, element);
%         markerTypeForIndivColResults = markerTypeForIndivColResults_high;
%         PlotCollapseEmpiricalCDFWithFits_SingleComp_func(analysisType, markerTypeForIndivColResults, lineWidthForIndivColResults, markerSize, markerTypeForLognormal, plotCDFWithRTRVariability)
     
        % Loop for all variale values run
        for varValIndex = 1:length(VariableLIST{currentVariableNum}.ValuesRun)

            analysisType = sprintf('(%s)_(%s)_(%.2f)_(%s)', model, VariableLIST{currentVariableNum}.Variable, VariableLIST{currentVariableNum}.ValuesRun(varValIndex), element);
            markerTypeForIndivColResults = markerTypeForIndivColResults_avg;
            PlotCollapseEmpiricalCDFWithFits_SingleComp_func(analysisType, markerTypeForIndivColResults, lineWidthForIndivColResults, markerSize, markerTypeForLognormal, plotCDFWithRTRVariability)
            legendText{varValIndex} = sprintf('%s = %.2f', VariableLIST{currentVariableNum}.Variable, VariableLIST{currentVariableNum}.ValuesRun(varValIndex));
        end
        

        % Create the legend      
        %legend(legendText{1}, legendText{2}, legendText{3}, legendText{4},
        %legendText{5}, legendText{6}, legendText{7}, legendText{8}, 'Location', 'SouthEast');
        legend(legendText, 'Location', 'SouthEast');
        
        % Save figure
        % Go up a folder and into the Figures folder and save the plots
            cd Collapse_Uncertainty_Figures;
            % Save the plot as a .fig file - FIGURE folder
                plotName = sprintf('CollapseCDFs_Sens_DesA_Buffalo_v.9noGFrm_grndDisp_hingeStrBmF.fig');
                hgsave(plotName);
            % Export the plot as a .emf file (Matlab book page 455) - FIGURE
            % folder
                exportName = sprintf('CollapseCDFs_Sens_DesA_Buffalo_v.9noGFrm_grndDisp_hingeStrBmF.emf');
                print('-dmeta', exportName);
            % Go back to MatlabProcessors folder
                cd ..; 

        % Hold off
        hold off
        
        
        
        
    end










