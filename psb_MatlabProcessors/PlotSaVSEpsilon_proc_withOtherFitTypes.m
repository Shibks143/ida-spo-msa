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
function[void] = PlotSaVSEpsilon_proc_withOtherFitTypes(saCollapse_current, epsilonAtTOne_current, markerType_nonOutliers, markerSize_nonOutliers, lineWidthForDots, markerType_outliers, markerSize_outliers, epsilonStepSizeForPlotting, markerType_bestFit, lineWidthForBestFitLine, markerType_CI, lineWidthForCI, equationTextFontSize, orginLineType, orginLineSize, legendTextFontSizeInThisFile, plotNamePrefix, numEQComp, yLabel, xLabel, figNum, groundMotionSetUsed, numberOfBins)

% % Hard wired
% numberOfBins = 10;

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
            
                % OLD WAY NOT ACCOUNTING FOR CORRELATIONS BETWEEN ERRORS OF
                % SLOEP AND INTERCEPT - Fixed on 7-26-06 (CBH)
                % Get the 5% and 95% on the slope and intercept
                %slope_95CI = BINT(2,1);
                %slope_5CI = BINT(2,2);
                %intercept_95CI = BINT(1,2);
                %intercept_5CI = BINT(1,1);
                %% Do all combinations of the slope and intercept 5/95 CI's;
                %% then take the maximum and minimums to do the plots
                %sa_CI_1 = exp(bestFit_epsilon.* slope_95CI + intercept_95CI);
                %sa_CI_2 = exp(bestFit_epsilon.* slope_95CI + intercept_5CI);
                %sa_CI_3 = exp(bestFit_epsilon.* slope_5CI + intercept_95CI);
                %sa_CI_4 = exp(bestFit_epsilon.* slope_5CI + intercept_5CI);
                %% Take the min and max - note that the min/max functions
                %% will only let us do two at a time, so this takes a couple
                %% of steps
                %sa_CI_min_1 = min(sa_CI_1, sa_CI_2);
                %sa_CI_min_2 = min(sa_CI_3, sa_CI_4);
                %sa_CI_min = min(sa_CI_min_1, sa_CI_min_2);
                %sa_CI_max_1 = max(sa_CI_1, sa_CI_2);
                %sa_CI_max_2 = max(sa_CI_3, sa_CI_4);
                %sa_CI_max = max(sa_CI_max_1, sa_CI_max_2);
                
                % New correct way.  This is based on equations 2.39 and 2.40 in the
                % "Regression Analysis by Example" text by S. Chatterjee et
                % al.  Do this all in the LN domain and then transform
                % afterwards (CBH 7-26-06).
                confidenceLevel_high = 0.025;   % Note that these are divided by 2.0 to make the CIs be two-sided
                confidenceLevel_low = 0.975;    % Note that these are divided by 2.0 to make the CIs be two-sided
                    % Compute the sqrt(errorVariance); I will assume this
                    % the the same as the s.e. that is used in equation
                    % 2.40.
                    sigmaErrorOfPrediction = (errorVariance)^0.5;   % This is in log units
                    % Compute equation 2.39...
                    n = length(epsilonAtTOne_current);
                    epsilonBar = mean(epsilonAtTOne_current);
                    % Loop to get sum term
                    sumTerm = 0.0;
                    for i = 1:length(epsilonAtTOne_current)
                        sumTerm = sumTerm + (epsilonAtTOne_current(i) - epsilonBar)^2;
                    end
                    sumTerm;
                    % Loop and compute the standard error on the mean
                    % prediction for many values of epsilon
                    minEpsilon = min(epsilonAtTOne_current);
                    maxEpsilon = max(epsilonAtTOne_current);
                    epsilonVectorForCIPlots = minEpsilon:0.05:maxEpsilon;
                    for i = 1:length(epsilonVectorForCIPlots)
                        currentEpsilon = epsilonVectorForCIPlots(i);
                        seOfMeanPredictionVECTOR(i) = sigmaErrorOfPrediction * sqrt((1/n) + (((currentEpsilon-epsilonBar)^2) / sumTerm));
                    end
                    seOfMeanPredictionVECTOR;
                    % Compute the mean estimate for each of the points in
                    % epsilonVectorForCIPlots
                    meanSaEstimate = intercept + epsilonVectorForCIPlots.* slope;  % In LN units
                    meanSaEstimate;
                    % Compute the values for the student t-distribution for
                    % the 5/95% confidence levels
                    numDOF = n - 2;
                    tValueForHighConfidence = tinv(confidenceLevel_high, numDOF);
                    tValueForLowConfidence = tinv(confidenceLevel_low, numDOF);
                    % Compute the 5/95 CIs on the estimate of the mean
                    CIOnEstimateOfMeanForHighConfidence_LNSpace = meanSaEstimate + seOfMeanPredictionVECTOR.*tValueForHighConfidence;
                    CIOnEstimateOfMeanForLowConfidence_LNSpace = meanSaEstimate + seOfMeanPredictionVECTOR.*tValueForLowConfidence;
                    % Convert back to non-Ln space
                    CIOnEstimateOfMeanForHighConfidence_nonLNSpace = exp(CIOnEstimateOfMeanForHighConfidence_LNSpace);
                    CIOnEstimateOfMeanForLowConfidence_nonLNSpace = exp(CIOnEstimateOfMeanForLowConfidence_LNSpace);
                % Plot the 5/95 CIs on the estimate of the mean
                plot(epsilonVectorForCIPlots, CIOnEstimateOfMeanForHighConfidence_nonLNSpace, markerType_CI,'LineWidth', lineWidthForCI);
                plot(epsilonVectorForCIPlots, CIOnEstimateOfMeanForLowConfidence_nonLNSpace, markerType_CI,'LineWidth', lineWidthForCI);
            % Write needed information on the plot
                epsilonString = '\epsilon';
                sigmaString = '\sigma';
                string1 = sprintf('Best-Fit: LN(Sa) = %.4f + %.3f%s', intercept, slope, epsilonString);
                string2 = sprintf('p-value = %.3e', pValue);
                string3 = sprintf('%s_{error} = %.3f (LN units)', sigmaString, sigmaErrorOfPrediction);
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
             
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NEW        
        % Do binning and show binning line.
            % Sort the Sa and epsilon vectors by increasing epsilon.  Sort
            % the epsilon vector and then get the returned vector of sorted
            % indices, then use these to put the Sa,col matrix in the same
            % order as the epsilon matrix.
                % Sort the epsilon vector
                [epsilonAtTOne_current_sorted, indexVector] = sort(epsilonAtTOne_current, 'ascend')
                % Now use the indexVector to put the Sa vector in a
                % consistent order.
                for i = 1:length(saCollapse_current)
                    saCollapse_current_sorted(i) = saCollapse_current(indexVector(i));
                end
                
            % Now loop and create bins of epsilons and Sa's
                % The number of bins is an input variable, so now figure
                % out number of motions in each bin; round to nearest whole
                % number.
                numberOfMotionsPerBin = floor(length(epsilonAtTOne_current_sorted) / numberOfBins);
                % Since the bins may not encompass all of the motions, do
                % not use the motions at the start (so we can be sure to
                % use all of the +epsilon motions).
                startIndexOfBin = length(epsilonAtTOne_current_sorted) - numberOfMotionsPerBin * numberOfBins + 1;
                % Now loop and compute bins
                for binNum = 1:numberOfBins
                    endIndexOfBin = startIndexOfBin + numberOfMotionsPerBin - 1;
                    
                    epsilonAtTOne_current_sorted_currentBin = epsilonAtTOne_current_sorted(startIndexOfBin:endIndexOfBin);
                    epsilonAtTOne_current_sorted_allBins_average(binNum) = mean(epsilonAtTOne_current_sorted_currentBin);
                    
                    saCollapse_current_sorted_currentBin = saCollapse_current_sorted(startIndexOfBin:endIndexOfBin);
                    saCollapse_current_sorted_allBins_median(binNum) = exp(mean(log(saCollapse_current_sorted_currentBin)));
                    
                    startIndexOfBin = endIndexOfBin + 1;
                end
               
                % Plot the binned line
                hold on
                plot(epsilonAtTOne_current_sorted_allBins_average, saCollapse_current_sorted_allBins_median, 'rs:', 'MarkerSize', 5, 'LineWidth', 2);
                
                
        % Do seperate regressions for +epsilon and -epsilon.  
            % First, find the cut-of between the + and - epsilon values.
            indexOfFirstPosEpsilon = 0;
            for currentIndex = 1:length(epsilonAtTOne_current_sorted)
                currentEpsilon = epsilonAtTOne_current_sorted(currentIndex);
                if(currentEpsilon > 0)
                    break;
                end
            end
            indexOfFirstPosEpsilon = currentIndex;
            indexOfLastNegEpsilon = indexOfFirstPosEpsilon - 1;
            indexOfLastEpsilonEntry = length(epsilonAtTOne_current_sorted); 
                
            % Do regressions for + and - epsilons
                % Negative epsilon regression
                disp('Doing regression for only negative epsilon data points...')
                numNegEpsilons = indexOfLastNegEpsilon;
                yVector_negEpsilons = log(saCollapse_current_sorted(1:indexOfLastNegEpsilon))'
                %size(yVector)
                predictorMatrix_negEpsilons(1:indexOfLastNegEpsilon, 1) = ones(numNegEpsilons, 1);   % Use a leading column of ones to get the intercept
                predictorMatrix_negEpsilons(1:indexOfLastNegEpsilon, 2) = epsilonAtTOne_current_sorted(1:indexOfLastNegEpsilon)
                %size(predictorMatrix)
                % Do regression and get results
                [B,BINT,R,RINT,STATS,isOutlier] = Regression_LinearWithStats(yVector_negEpsilons, predictorMatrix_negEpsilons);
                intercept_forNegEpsilons = B(1);
                slope_forNegEpsilons = B(2);
                pValue_forNegEpsilons = STATS(3);  % Should be p-value on slope
                errorVariance_forNegEpsilons = STATS(4);
            
                % Positive epsilon regression
                disp('Doing regression for only positive epsilon data points...')
                numPosEpsilons = indexOfLastEpsilonEntry - indexOfFirstPosEpsilon + 1;
                yVector_posEpsilons = log(saCollapse_current_sorted(indexOfFirstPosEpsilon:indexOfLastEpsilonEntry))'
                predictorMatrix_posEpsilons(1:numPosEpsilons, 1) = ones(numPosEpsilons, 1);   % Use a leading column of ones to get the intercept
                predictorMatrix_posEpsilons(1:numPosEpsilons, 2) = epsilonAtTOne_current_sorted(indexOfFirstPosEpsilon:indexOfLastEpsilonEntry)
                % Do regression and get results
                [B,BINT,R,RINT,STATS,isOutlier] = Regression_LinearWithStats(yVector_posEpsilons, predictorMatrix_posEpsilons);
                intercept_forPosEpsilons = B(1);
                slope_forPosEpsilons = B(2);
                pValue_forPosEpsilons = STATS(3);  % Should be p-value on slope
                errorVariance_forPosEpsilons = STATS(4);
                
    
            % Plot the regression line for negative and positive epsilons;
            % with no confidence intervals
                hold on
                % Plot the best fit line: for Negative Epsilons
                bestFit_negEpsilons = minEpsilon:epsilonStepSizeForPlotting:0;
                bestFit_sa_forNegEpsilons = exp(bestFit_negEpsilons.* slope_forNegEpsilons + intercept_forNegEpsilons);
                plot(bestFit_negEpsilons, bestFit_sa_forNegEpsilons, 'b-','LineWidth', lineWidthForBestFitLine);
                % Plot the best fit line: for Negative Epsilons
                bestFit_posEpsilons = 0:epsilonStepSizeForPlotting:maxEpsilon;
                bestFit_sa_forPosEpsilons = exp(bestFit_posEpsilons.* slope_forPosEpsilons + intercept_forPosEpsilons);
                plot(bestFit_posEpsilons, bestFit_sa_forPosEpsilons, 'b-','LineWidth', lineWidthForBestFitLine);
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NEW        
                
            % Legend
                legh = legend('Observation', 'Outlier', 'Regression', '5/95% CIs on Mean', 'Location', 'Southeast');
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
                
            % Jump up one folder and save again (just to make it easier to
            % collect all of the figures)
            folder = [pwd];
            cd ..;
            cd('Sa-EpsilonPlotsToSave_new');
            hgsave(plotName);
            print('-dmeta', exportName);
            cd(folder)
                
    hold off








