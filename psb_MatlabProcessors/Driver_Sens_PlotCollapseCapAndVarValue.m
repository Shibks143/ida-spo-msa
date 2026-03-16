%
% Procedure: Driver_Sens_PlotCollapseCapAndVarValue.m
% -------------------
% Simply a script do plot the relationship between variable value and
% collapse capacity.  For use with sensitivity analysis results.  Note that
% this opens the file made by the collapse IDA plotting function and this
% saves the figure made.  This plot the collapse capacities and a line to
% connect the mean and mean +/- sigma (assuming lognormally distributed).
%
% Assumptions and Notices: 
%   - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 1-1-06
%
% Sources of Code: none
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
matlabProcessorPath = [pwd];

% Define the design and model to use
    model = 'DesA_Buffalo_v.9noGFrm_grndDisp';
    element = 'clough';

% Define the list of RVs that you would like to use...
    varNumberToPlot = 99999;

% Define the plotting options
    markerTypeForIndivColResults = 'bo';
    markerSize = 8;
    faceColor = 'b';   
    markerTypeForMeanLine = 'b-';
    lineWidthForMeanLine = 4;
    markerTypeForStDevLine = 'b--';
    lineWidthForStDevLine = 2;
    figureNumber = 100;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prelimary stuff
% Load the variable file to know what values the variables were run at 
    VariableLIST = DefineVariableInfo_Wall();
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the plot
    currentVariableNum = varNumberToPlot;

    % Loop for all variable values run
    numVarValuesRuns = length(VariableLIST{currentVariableNum}.ValuesRun);
    variableName = VariableLIST{currentVariableNum}.Variable;
    for varValIndex = 1:numVarValuesRuns
        % Open the file with the results for this analysis
        analysisType = sprintf('(%s)_(%s)_(%.2f)_(%s)', model, VariableLIST{currentVariableNum}.Variable, VariableLIST{currentVariableNum}.ValuesRun(varValIndex), element);
        % Go to the folder and open the correct file
        cd ..;
        cd Output;
        analysisTypeFolder = analysisType;
        cd(analysisTypeFolder);
        % Open the file, get the results, and go back to initial folder
        load DATA_collapse_CollapseSaAndStats.mat collapseLevelForChosenComp...
            meanCollapseSaTOneChosenComp meanLnCollapseSaTOneChosenComp...
            stDevCollapseSaTOneChosenComp stDevLnCollapseSaTOneChosenComp
        cd(matlabProcessorPath);
        % Save all the results
        allResults{varValIndex}.collapseLevelForChosenComp = collapseLevelForChosenComp;
        allResults{varValIndex}.meanCollapseSaTOneChosenComp = meanCollapseSaTOneChosenComp;
        allResults{varValIndex}.meanLnCollapseSaTOneChosenComp = meanLnCollapseSaTOneChosenComp;
        allResults{varValIndex}.stDevCollapseSaTOneChosenComp = stDevCollapseSaTOneChosenComp;
        allResults{varValIndex}.stDevLnCollapseSaTOneChosenComp = stDevLnCollapseSaTOneChosenComp;
        
        % Save some results in a good form to output the screen later
        meanCollapseCapLIST(varValIndex) = meanCollapseSaTOneChosenComp;
        meanLnCollapseCapLIST(varValIndex) = meanLnCollapseSaTOneChosenComp;
        stDevCollapseCapLIST(varValIndex) = stDevCollapseSaTOneChosenComp;
        stDevLnCollapseCapLIST(varValIndex) = stDevLnCollapseSaTOneChosenComp;
        
        % Do some calcs and save specific results for plotting - assumes a
        % lognormal distribution for the collapse Sa
        meanCollapseCapLIST_lognormal(varValIndex) = exp(meanLnCollapseSaTOneChosenComp); 
        meanMinusSigmaCollapseCapLIST(varValIndex) = exp(meanLnCollapseSaTOneChosenComp - stDevLnCollapseSaTOneChosenComp);
        meanPlusSigmaCollapseCapLIST(varValIndex) = exp(meanLnCollapseSaTOneChosenComp + stDevLnCollapseSaTOneChosenComp);
        variableValues(varValIndex) = VariableLIST{currentVariableNum}.ValuesRun(varValIndex);

    end
    
    % Now output the results to the screen
        model
        element 
        variableName
        variableValues
        meanCollapseCapLIST
        meanLnCollapseCapLIST
        stDevCollapseCapLIST
        stDevLnCollapseCapLIST
        
    % Now plot the values on the figure
        figure(figureNumber);
        hold on
        
        % Plot the mean line and +/- sigma lines
        plot(variableValues, meanCollapseCapLIST_lognormal, markerTypeForMeanLine, 'LineWidth', lineWidthForMeanLine);
        plot(variableValues, meanMinusSigmaCollapseCapLIST, markerTypeForStDevLine, 'LineWidth', lineWidthForStDevLine);
        plot(variableValues, meanPlusSigmaCollapseCapLIST, markerTypeForStDevLine, 'LineWidth', lineWidthForStDevLine);
    
        % Loop and plot all the EQ results
        for varValIndex = 1:numVarValuesRuns
            currentVariableValue = ones(1, numVarValuesRuns) * VariableLIST{currentVariableNum}.ValuesRun(varValIndex);
            plot(currentVariableValue, allResults{varValIndex}.collapseLevelForChosenComp, markerTypeForIndivColResults, 'MarkerSize', markerSize, 'MarkerFaceColor', faceColor);
    
        end
    

        % Create the legend and do plot details    
        legend('Mean', 'Mean - \sigma', 'Mean + \sigma', 'Individual Records', 'Location', 'SouthEast');
        box on
        grid on
        %titleText = sprintf('Emp. CDF of SaCol with Fitted Dist._%s', analysisType)
        %title(titleText)
        xText = sprintf('Random Variable: %s', variableName); 
        hx = xlabel(xText)
        hy = ylabel('Sa_{collapse}(T=1.0s) [g]')
        FigureFormatScript
        
        % Save figure
        % Go up a folder and into the Figures folder and save the plots
            cd Collapse_Uncertainty_Figures;
            % Save the plot as a .fig file - FIGURE folder
                plotName = sprintf('CollapseSens_CollapseCapityAndRVValue_%s_%s.fig', model, VariableLIST{currentVariableNum}.Variable);
                hgsave(plotName);
            % Export the plot as a .emf file (Matlab book page 455) - FIGURE
            % folder
                exportName = sprintf('CollapseSens_CollapseCapityAndRVValue_%s_%s.emf', model, VariableLIST{currentVariableNum}.Variable);
                print('-dmeta', exportName);
            % Go back to MatlabProcessors folder
                cd ..; 

        % Hold off
        hold off
        
        % Now save a file with all of the results in it
        cd ..;
        cd SensitivityAnaysisDataFiles;
        
        sensFileName = sprintf('DATA_Sensitivity_%s_%s_%s.mat', model, element, variableName);
        save(sensFileName, 'allResults', 'variableValues', 'model', 'element', 'varNumberToPlot', 'variableName')
        
        cd ..;
        cd MatlabProcessors
        
       






