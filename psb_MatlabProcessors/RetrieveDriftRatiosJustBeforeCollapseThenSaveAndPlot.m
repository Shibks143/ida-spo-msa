% Procedure: RetrieveDriftRatiosJustBeforeCollapseThenSaveAndPlot.m
% -------------------
%
% This loops through the collapse analysis results and loads the results
% for the highest SA level run just before collapse.  It saves the peak IDR
% over the full frame and the peak RDR.  It then saves a file and plots the
% results.
%
% Assumptions and Notices: 
%   - none
%
% Author: Curt Haselton 
% Date Written: 7-26-06
%
% Functions and Procedures called: none
%
% Variable definitions: 
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = RetrieveDriftRatiosJustBeforeCollapseThenSaveAndPlot(eqNumberLIST, eqListForCollapseIDAs_Name, analysisType, modelName)

% Loop over all EQs, load the data and save it.
numEQs = length(eqNumberLIST);
for eqIndex = 1:numEQs
    currentEQNum = eqNumberLIST(eqIndex);

    % Find the Se just before collapse for this EQ
    [saAtCollapse, saLevelsForIDAPlotLIST] = FindAndReturnCollapseSaForEQ_inPrimaryFolder(analysisType, modelName, currentEQNum);
    highestSaBeforeCollapse = 0;
    for saIndex = 1:length(saLevelsForIDAPlotLIST)
        currentSa = saLevelsForIDAPlotLIST(saIndex);
        if((currentSa < saAtCollapse) && (currentSa > highestSaBeforeCollapse))
            highestSaBeforeCollapse = currentSa;
        end
    end
    saAtCollapse;
    saLevelsForIDAPlotLIST;
    highestSaBeforeCollapse;
    
    % Go to the correct folder and load the data for this EQ record
    startingFolder = [pwd]; % Save the path to the starting folder
    cd ..;
    cd Output;
    analysisTypeFolder = sprintf('%s', analysisType);
    cd(analysisTypeFolder);
    eqFolder = sprintf('EQ_%.0f', currentEQNum);
    cd(eqFolder);
    saFolder = sprintf('Sa_%.2f', highestSaBeforeCollapse);
    cd(saFolder);
    
    % Load data and go back to starting folder
    load('DATA_reducedSensDataForThisSingleRun.mat', 'maxDriftRatioForFullStr', 'roofDriftRatioToSave');
    cd(startingFolder);
    
    % Save the data for this EQ in the vectors and clear the values that were just
    % opened
    maxDriftRatioForFullStr_allEQs.allEQs(eqIndex) = maxDriftRatioForFullStr;
    roofDriftRatioToSave_allEQs.allEQs(eqIndex) = roofDriftRatioToSave.AbsMax;
    clear maxDriftRatioForFullStr roofDriftRatioToSave
   
end

% Do summary statistics
    maxDriftRatioForFullStr_allEQs.MeanAllEQs       = mean(maxDriftRatioForFullStr_allEQs.allEQs);
    maxDriftRatioForFullStr_allEQs.MinAllEQs        = min(maxDriftRatioForFullStr_allEQs.allEQs);
    maxDriftRatioForFullStr_allEQs.MaxAllEQs        = max(maxDriftRatioForFullStr_allEQs.allEQs);
    maxDriftRatioForFullStr_allEQs.StDevAllEQs      = std(maxDriftRatioForFullStr_allEQs.allEQs);
    maxDriftRatioForFullStr_allEQs.MedianAllEQs     = median(maxDriftRatioForFullStr_allEQs.allEQs);
    maxDriftRatioForFullStr_allEQs.MeanLnAllEQs     = mean(log(maxDriftRatioForFullStr_allEQs.allEQs));
    maxDriftRatioForFullStr_allEQs.StDevLnAllEQs    = std(log(maxDriftRatioForFullStr_allEQs.allEQs));

    roofDriftRatioToSave_allEQs.MeanAllEQs       = mean(roofDriftRatioToSave_allEQs.allEQs);
    roofDriftRatioToSave_allEQs.MinAllEQs        = min(roofDriftRatioToSave_allEQs.allEQs);
    roofDriftRatioToSave_allEQs.MaxAllEQs        = max(roofDriftRatioToSave_allEQs.allEQs);
    roofDriftRatioToSave_allEQs.StDevAllEQs      = std(roofDriftRatioToSave_allEQs.allEQs);
    roofDriftRatioToSave_allEQs.MedianAllEQs     = median(roofDriftRatioToSave_allEQs.allEQs);
    roofDriftRatioToSave_allEQs.MeanLnAllEQs     = mean(log(roofDriftRatioToSave_allEQs.allEQs));
    roofDriftRatioToSave_allEQs.StDevLnAllEQs    = std(log(roofDriftRatioToSave_allEQs.allEQs));

% Plot the values and save the plot
    % Plot options
    markerTypeForIndivColResults_storyDrift = 'rs';
    markerTypeForIndivColResults_roofDrift = 'bo';
    markerFaceColorForIndivColResults = 'w';
    markerTypeForLognormal_storyDrift = 'r-';
    markerTypeForLognormal_roofDrift = 'b--';
    minValueForPlot = 0.0;
    maxValueForPlot = 0.145;
    legendTextFontSizeInThisFile = 12;  % Legend font size - overrides the figure formatting script

    % Sort data and make athe probability vector
    maxDriftRatioForFullStr_allEQs.allEQs_sorted = sort(maxDriftRatioForFullStr_allEQs.allEQs);
    roofDriftRatioToSave_allEQs.allEQs_sorted = sort(roofDriftRatioToSave_allEQs.allEQs);
    cummulativeProb = [(1/numEQs):(1/numEQs):1.0];

    % Do plots
    hold on
    % Plot the empirical and lognormal fit CDF for ROOF drift
    plot(roofDriftRatioToSave_allEQs.allEQs_sorted, cummulativeProb, markerTypeForIndivColResults_roofDrift, 'MarkerFaceColor', markerFaceColorForIndivColResults);
    PlotLogNormalCDF(roofDriftRatioToSave_allEQs.MeanLnAllEQs, roofDriftRatioToSave_allEQs.StDevLnAllEQs, minValueForPlot, maxValueForPlot, markerTypeForLognormal_roofDrift);
    hold on
    % Plot the empirical and lognormal fit CDF for MAX STORY (for full bldg) drift
    plot(maxDriftRatioForFullStr_allEQs.allEQs_sorted, cummulativeProb, markerTypeForIndivColResults_storyDrift, 'MarkerFaceColor', markerFaceColorForIndivColResults);
    PlotLogNormalCDF(maxDriftRatioForFullStr_allEQs.MeanLnAllEQs, maxDriftRatioForFullStr_allEQs.StDevLnAllEQs, minValueForPlot, maxValueForPlot, markerTypeForLognormal_storyDrift);
    hold on    
    
    % Do final plot details
    legh = legend('Roof: Empirical', 'Roof: Lognormal', 'Max Story: Empirical', 'Max Story: Lognorm.', 'Location', 'Southeast');
    box on
    grid on
    hx = xlabel('Drift Ratio Preceding Collapse');
    hy = ylabel('P[collapse]');
    FigureFormatScript;
    % Make the x-axis correct
    axis([minValueForPlot maxValueForPlot 0.0 1.0]);
    % Make the legend text smaller
    set(legh, 'FontSize', legendTextFontSizeInThisFile);
    
% Go to the output folder for this model and save the figure
    cd ..;
    cd Output;
    analysisTypeFolder = sprintf('%s', analysisType)
    cd(analysisTypeFolder);
    
    % Save the plot as a .fig file
    plotName = sprintf('CollapseDrifts_%s_%s.fig', analysisType, eqListForCollapseIDAs_Name);
    hgsave(plotName);
    % Export the plot as a .emf file (Matlab book page 455)
    exportName = sprintf('CollapseDrifts_%s_%s.emf', analysisType, eqListForCollapseIDAs_Name);
    print('-dmeta', exportName);

% Save the results in a .mat file
    fileName = sprintf('DATA_collapse_DriftsPrecedingCollapse_%s.mat', eqListForCollapseIDAs_Name);        
    save(fileName, 'eqNumberLIST', 'eqListForCollapseIDAs_Name', 'analysisType', 'modelName',...
        'maxDriftRatioForFullStr_allEQs', 'roofDriftRatioToSave_allEQs');

% Go back to start folder
    cd(startingFolder);

    
