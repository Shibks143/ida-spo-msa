%
% Procedure: Driver_CreatePlotsOfSaVSEpsilon_forMIDR.m
% -------------------
% This is the same as the PROC for plotting Sa_collapse vs. epsilon, but
% this instead opens the stripe files and make the plots for MIDR versus
% epsilon.
%
% Assumptions and Notices: 
%   - This assumes that the analysis was run with Sa_geoMean.
%
% Author: Curt Haselton 
% Date Written: 6-27-06, 7-20-06; modified for MIDR on 11-1-07
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - not done
%
% Units: Whatever OpenSees is using - kips, inches, radians
%
% -------------------
function[void] = CreatePlotsOfSaVSEpsilon_forMIDR_proc(analysisType, groundMotionSetUsed, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef, saLevel)

% Define some plotting options
    orginLineType = 'k-';               % Line through zero
    orginLineSize = 1;
    markerType_nonOutliers = 'b.';
    markerSize_nonOutliers = 15;        % Controls size of dots
    markerType_outliers = 'rx';
    markerSize_outliers = 6;   % Controls size of x's
    lineWidthForDots = 1;               % Controls line sixe of dots and x's
    markerType_bestFit = 'k-';
    lineWidthForBestFitLine = 2;
    markerType_CI = 'k--';
    lineWidthForCI = 2;
    epsilonStepSizeForPlotting = 0.01;  % Spacing of points when plotting best-fit line
    equationTextFontSize = 10;          % Size of font for equation and p-value on the plot
    legendTextFontSizeInThisFile = 10;            % This is used after the figure formatting script

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go to the correct folder and open the file of collapse results
    % Go to folder
    cd ..;
    cd Output
    cd(analysisType)
    % Open file
    fileName = sprintf('DATA_stripe_SaGeoMean_%s_Sa_%.2f.mat', groundMotionSetUsed, saLevel);
    load(fileName);

% Save the needed information from the file opened.
    MIDRLIST = IDR_maxAllStories.allEQs;
    eqCompNumberLIST = eqNumberLIST_forStripes;
    
% Loop through all of the EQs and compute Sa,component and the epsilon
% values.
disp('MIDR-Epsilon Plots - Loading the Information from Files');
numEQComp = length(eqCompNumberLIST);
for eqCompIndex = 1:numEQComp
   eqCompNum = eqCompNumberLIST(eqCompIndex);
    
   % Compute the EQ number (for the pair of GMs; the shorter number)
   eqNum = floor(eqCompNum/10);
   
   % Compute the component Sa value at collapse - NOT ANYMORE
   %saCollapse_component(eqCompIndex) = saCollapse_geoMean(eqCompIndex) * (RetrieveSaCompValueForAnEQ(eqCompNum, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef) / RetrieveSaGeoMeanValueForAnEQ(eqNum, periodUsedForScalingGroundMotions, dampingRatioUsedForSaDef));
   
   % Retrieve the epsilon values for this EQ at the correct period
   
        if(periodUsedForScalingGroundMotions < 2.0001)
            % Epsilon for Sa,component and BJF function
            attenFuncNum = 1;   % BJF
            saType = 1;         % Component Sa
            epsilonAtTOne_forSaComp_BJF(eqCompIndex) = RetrieveEpsilonValueForAnEQ(eqCompNum, periodUsedForScalingGroundMotions, attenFuncNum, saType);

            % Epsilon for Sa,geoMean and BJF function
            attenFuncNum = 1;   % BJF
            saType = 2;         % GeoMean Sa
            epsilonAtTOne_forSaGeoMean_BJF(eqCompIndex) = RetrieveEpsilonValueForAnEQ(eqCompNum, periodUsedForScalingGroundMotions, attenFuncNum, saType);
        end
        
        % Epsilon for Sa,component and AS function
        attenFuncNum = 2;   % AS
        saType = 1;         % Component Sa
        epsilonAtTOne_forSaComp_AS(eqCompIndex) = RetrieveEpsilonValueForAnEQ(eqCompNum, periodUsedForScalingGroundMotions, attenFuncNum, saType);
   
        % Epsilon for Sa,geoMean and AS function
        attenFuncNum = 2;   % AS
        saType = 2;         % GeoMean Sa
        epsilonAtTOne_forSaGeoMean_AS(eqCompIndex) = RetrieveEpsilonValueForAnEQ(eqCompNum, periodUsedForScalingGroundMotions, attenFuncNum, saType);

end

% Make the figures and save them
    disp('Starting the plots');
    epsilonString = '\epsilon';

    % Do MIDR and epsilon_AS (CURRENTLY FOR A GIVEN VALUE OF SA,GEOMEAN) - call the procedure
    figNum = 1;
    %saCollapse_current = saCollapse_component;
    MIDRLIST;
    epsilonAtTOne_current = epsilonAtTOne_forSaComp_AS;
    yLabel = sprintf('MIDR');
    xLabel = sprintf('%s_{AS}(T_{1}=%.2fs)', epsilonString, periodUsedForScalingGroundMotions);
    plotNamePrefix = sprintf('MIDRVSEpsilon_ForSaGMOf_%.2f_ASEpsilon_%s', analysisType, saLevel);
    PlotSaVSEpsilon_proc(MIDRLIST, epsilonAtTOne_current, markerType_nonOutliers, markerSize_nonOutliers, lineWidthForDots, markerType_outliers, markerSize_outliers, epsilonStepSizeForPlotting, markerType_bestFit, lineWidthForBestFitLine, markerType_CI, lineWidthForCI, equationTextFontSize, orginLineType, orginLineSize, legendTextFontSizeInThisFile, plotNamePrefix, numEQComp, yLabel, xLabel, figNum, groundMotionSetUsed);
    
    % Do Sa_comp and epsilon_BJF - call the procedure
    if(periodUsedForScalingGroundMotions < 2.0001)
        figNum = 2;
        %saCollapse_current = saCollapse_component;
        MIDRLIST;
        epsilonAtTOne_current = epsilonAtTOne_forSaComp_BJF;
        yLabel = sprintf('MIDR');
        xLabel = sprintf('%s_{BJF}(T_{1}=%.2fs)', epsilonString, periodUsedForScalingGroundMotions);
        plotNamePrefix = sprintf('MIDRVSEpsilon_ForSaGMOf_%.2f_BJFEpsilon_%s', analysisType, saLevel);
        PlotSaVSEpsilon_proc(saCollapse_current, epsilonAtTOne_current, markerType_nonOutliers, markerSize_nonOutliers, lineWidthForDots, markerType_outliers, markerSize_outliers, epsilonStepSizeForPlotting, markerType_bestFit, lineWidthForBestFitLine, markerType_CI, lineWidthForCI, equationTextFontSize, orginLineType, orginLineSize, legendTextFontSizeInThisFile, plotNamePrefix, numEQComp, yLabel, xLabel, figNum, groundMotionSetUsed);
    end
    
%     % Do Sa_geoMean and epsilon_AS - call the procedure
%     figNum = 3;
%     saCollapse_current = saCollapse_geoMean;
%     epsilonAtTOne_current = epsilonAtTOne_forSaGeoMean_AS;
%     yLabel = sprintf('Sa_{g.m.}(T_{1}=%.2fs)', periodUsedForScalingGroundMotions);
%     xLabel = sprintf('%s_{AS}(T_{1}=%.2fs)', epsilonString, periodUsedForScalingGroundMotions);
%     plotNamePrefix = sprintf('SaVSEpsilon_Sagm_ASEpsilon_%s', analysisType);
%     PlotSaVSEpsilon_proc(saCollapse_current, epsilonAtTOne_current, markerType_nonOutliers, markerSize_nonOutliers, lineWidthForDots, markerType_outliers, markerSize_outliers, epsilonStepSizeForPlotting, markerType_bestFit, lineWidthForBestFitLine, markerType_CI, lineWidthForCI, equationTextFontSize, orginLineType, orginLineSize, legendTextFontSizeInThisFile, plotNamePrefix, numEQComp, yLabel, xLabel, figNum, groundMotionSetUsed);
%     
%     % Do Sa_geoMean and epsilon_BJF - call the procedure
%     if(periodUsedForScalingGroundMotions < 2.0001)
%         figNum = 4;
%         saCollapse_current = saCollapse_geoMean;
%         epsilonAtTOne_current = epsilonAtTOne_forSaGeoMean_BJF;
%         yLabel = sprintf('Sa_{g.m.}(T_{1}=%.2fs)', periodUsedForScalingGroundMotions);
%         xLabel = sprintf('%s_{BJF}(T_{1}=%.2fs)', epsilonString, periodUsedForScalingGroundMotions);
%         plotNamePrefix = sprintf('SaVSEpsilon_Sagm_BJFEpsilon_%s', analysisType);
%         PlotSaVSEpsilon_proc(saCollapse_current, epsilonAtTOne_current, markerType_nonOutliers, markerSize_nonOutliers, lineWidthForDots, markerType_outliers, markerSize_outliers, epsilonStepSizeForPlotting, markerType_bestFit, lineWidthForBestFitLine, markerType_CI, lineWidthForCI, equationTextFontSize, orginLineType, orginLineSize, legendTextFontSizeInThisFile, plotNamePrefix, numEQComp, yLabel, xLabel, figNum, groundMotionSetUsed);
%     end
    
% Back to Matlab processor folder
cd ..;
cd ..;
cd MatlabProcessors
                



