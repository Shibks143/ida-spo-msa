%
% Procedure: PlotSaVSEpsilon_proc.m
% -------------------
% This plots Sa vs. epsilon for a certain Sa definition type and for a certain
% epsilon definition type.
%
% Assumptions and Notices: 
%   - none
%
% Author: Curt Haselton 
% Date Written: 6-28-06
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
function[void] = PlotSaVSEpsilon_proc(saCollapse_current, epsilonAtTOne_current, markerType_nonOutliers, markerSize_nonOutliers, lineWidthForDots, markerType_outliers, markerSize_outliers, epsilonStepSizeForPlotting, markerType_bestFit, lineWidthForBestFitLine, markerType_CI, lineWidthForCI, equationTextFontSize, orginLineType, orginLineSize, legendTextFontSizeInThisFile, plotNamePrefix, numEQComp, yLabel, xLabel, figNum, groundMotionSetUsed)

figure(figNum);

        % Find the slope and intercept with regression analysis between
        % LN(Sa) and epsilon.  Use regression analysis with the outlier
        % removed.
            % Make the input for regression
            yVector = log(saCollapse_current)';
            predictorMatrix(1:numEQComp, 1) = ones(numEQComp, 1);   % Use a leading column of ones to get the intercept
            predictorMatrix(1:numEQComp, 2) = epsilonAtTOne_current;
            % Do regression and get results
            [B,BINT,R,RINT,STATS,isOutlier] = Regression_LinearWithStats(yVector, predictorMatrix);
            intercept = B(1);
            slope = B(2);
            pValue = STATS(3);  % Should be p-value on slope
            errorVariance = STATS(4);
    
        % Make a vectors with and without outliers
            for i = 1:length(yVector)
               if(isOutlier(i) == 1)
                   % Outlier
                   yVector_outliersOnly(i) = yVector(i);
                   yVector_noOutliers(i) = nan;
               else
                   % Not an outlier
                   yVector_outliersOnly(i) = nan;
                   yVector_noOutliers(i) = yVector(i);
               end
            end
        
        % Make the plot
            % Plot points that are not outliers
                plot(epsilonAtTOne_current, exp(yVector_noOutliers), markerType_nonOutliers, 'MarkerSize', markerSize_nonOutliers, 'LineWidth', lineWidthForDots);
                hold on
            % Plot outliers
                plot(epsilonAtTOne_current, exp(yVector_outliersOnly), markerType_outliers, 'MarkerSize', markerSize_outliers, 'LineWidth', lineWidthForDots);
            % Get the max and min epsilon values for plotting the best fit line
                minEpsilon = min(epsilonAtTOne_current);
                maxEpsilon = max(epsilonAtTOne_current);
            % Plot the best fit line
                bestFit_epsilon = minEpsilon:epsilonStepSizeForPlotting:maxEpsilon;
                bestFit_sa = exp(bestFit_epsilon.* slope + intercept);
                plot(bestFit_epsilon, bestFit_sa, markerType_bestFit,'LineWidth', lineWidthForBestFitLine);
            % Plot the lines for the 5% and 95% CI on both the intercept
            % and the slope
                % Get the 5% and 95% on the slope and intercept
                slope_95CI = BINT(2,1);
                slope_5CI = BINT(2,2);
                intercept_95CI = BINT(1,2);
                intercept_5CI = BINT(1,1);
                % Do all combinations of the slope and intercept 5/95 CI's;
                % then take the maximum and minimums to do the plots
                sa_CI_1 = exp(bestFit_epsilon.* slope_95CI + intercept_95CI);
                sa_CI_2 = exp(bestFit_epsilon.* slope_95CI + intercept_5CI);
                sa_CI_3 = exp(bestFit_epsilon.* slope_5CI + intercept_95CI);
                sa_CI_4 = exp(bestFit_epsilon.* slope_5CI + intercept_5CI);
                % Take the min and max - note that the min/max functions
                % will only let us do two at a time, so this takes a couple
                % of steps
                sa_CI_min_1 = min(sa_CI_1, sa_CI_2);
                sa_CI_min_2 = min(sa_CI_3, sa_CI_4);
                sa_CI_min = min(sa_CI_min_1, sa_CI_min_2);
                sa_CI_max_1 = max(sa_CI_1, sa_CI_2);
                sa_CI_max_2 = max(sa_CI_3, sa_CI_4);
                sa_CI_max = max(sa_CI_max_1, sa_CI_max_2);
                % Plot the min and max values for the 5/95 CI on the
                % intercept and slope
                plot(bestFit_epsilon, sa_CI_min, markerType_CI,'LineWidth', lineWidthForCI);
                plot(bestFit_epsilon, sa_CI_max, markerType_CI,'LineWidth', lineWidthForCI);
            % Write needed information on the plot
                epsilonString = '\epsilon';
                sigmaString = '\sigma';
                string1 = sprintf('Best-Fit: Ln(Sa) = %.4f + %.3f%s', intercept, slope, epsilonString);
                string2 = sprintf('p-value = %.3e', pValue);
                sigmaError = (errorVariance)^0.5;
                string3 = sprintf('%s_{error} = %.3f', sigmaString, sigmaError);
                totalStringStructure = {string1, string2, string3};
                % Find location for the text
                xLoc = minEpsilon;
                yLoc = 0.85*max(exp(yVector_noOutliers));
                % Place the text and format the size
                hEquText = text(xLoc, yLoc, totalStringStructure);
                set(hEquText, 'FontSize', equationTextFontSize);
            % Add the axis labels
                hy = ylabel(yLabel);
                hx = xlabel(xLabel);
            % Legend
                legh = legend('Observation', 'Outlier', 'Regression', '5/95% CIs', 'Location', 'Southeast');
            % Get the size of the graph and plot a lines on the axes; at
            % the same time, make the x-limits balanced
                haxes = gca;
                axesInfo = get(haxes);
                minX = axesInfo.XLim(1);
                maxX = axesInfo.XLim(2);
                absMaxX = max(abs(minX), abs(maxX));
                plot([-absMaxX, absMaxX], [0, 0], orginLineType, 'LineWidth', orginLineSize);
                plot([0, 0], [0, axesInfo.YLim(2)], orginLineType, 'LineWidth', orginLineSize);
                % Save axis locations
                axesInfoNew = get(haxes);
            % Format the figure
                FigureFormatScript
                set(legh, 'FontSize', legendTextFontSizeInThisFile);
            % Make the graph size be hos it was before formatting
                xlim([axesInfoNew.XLim(1), axesInfoNew.XLim(2)]);
                ylim([0.0, axesInfoNew.YLim(2)]);
            % Final plot details
            grid on 
            box on
            % Save the plot
                % Save the plot as a .fig file
                plotName = sprintf('%s_%s.fig', plotNamePrefix, groundMotionSetUsed);
                hgsave(plotName);
                % Export the plot as a .emf file (Matlab book page 455)
                exportName = sprintf('%s_%s.emf', plotNamePrefix, groundMotionSetUsed);
                print('-dmeta', exportName);

    hold off








