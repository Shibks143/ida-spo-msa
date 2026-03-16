if(runScript4 == 1)


% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_4.m

    % Compute MAF of collapse and probability of collapse at 2% in 50 level
    % for 84% and 95% confidence levels.  Use LOGNORMAL collapse CDF.  This
    % follows collapse and MAF hand notes, pg. 24, on 3-24-05.

    % Compute for all confidence levels...
    
    % Use the lognormal information with only RTR variability for this
    % distribution (although the modeling variability is being used).
    mean = meanLnCollapseSaTOneControlComp;
    sigma = stDevLnCollapseSaTOneControlComp;
    distTypeForCDF = 'lnrm';
    
        % 90% confidence level:
            confidenceLevel = 0.10;
            temp = abs(1.0 - confidenceLevel);
            temp2 = sprintf('Results for confidence level (using lognormal CDF): %.2f ...', temp);
            disp(temp2);
            % Compute the mean of the shifted distributions (the
            % distribution is the one for RTR variability, but the mean is
            % shifted using the distribution fof modeling variability).
                shiftedMean = logninv(confidenceLevel, meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneFOSM);
            % Compute the shiftedMeanLn...
                cov = stDevCollapseSaTOneControlComp / shiftedMean;
                shiftedMeanLn = log(shiftedMean) - 0.5 * log(cov ^ 2 + 1.0)
                approxShiftedMedian = exp(shiftedMeanLn)
            % Compute the probability of collapse at the 2% in 50 year
            % event for this confidence level
                probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, shiftedMeanLn, stDevLnCollapseSaTOneControlComp);
                probOfColAtTwoInFifty
            % Compute the MAF of collapse for this confidence level
                empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
                [AnnualFreqofCollapse] = ComputeMAFofCollapse(shiftedMeanLn, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
                AnnualFreqofCollapse

        % 50% confidence level:
            confidenceLevel = 0.45;
            temp = abs(1.0 - confidenceLevel);
            temp2 = sprintf('Results for confidence level (using lognormal CDF): %.2f ...', temp);
            disp(temp2);
            % Compute the mean of the shifted distributions (the
            % distribution is the one for RTR variability, but the mean is
            % shifted using the distribution fof modeling variability).
                shiftedMean = logninv(confidenceLevel, meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneFOSM);
            % Compute the shiftedMeanLn...
                cov = stDevCollapseSaTOneControlComp / shiftedMean;
                shiftedMeanLn = log(shiftedMean) - 0.5 * log(cov ^ 2 + 1.0)
                approxShiftedMedian = exp(shiftedMeanLn)
            % Compute the probability of collapse at the 2% in 50 year
            % event for this confidence level
                probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, shiftedMeanLn, stDevLnCollapseSaTOneControlComp);
                probOfColAtTwoInFifty
            % Compute the MAF of collapse for this confidence level
                empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
                [AnnualFreqofCollapse] = ComputeMAFofCollapse(shiftedMeanLn, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
                AnnualFreqofCollapse

        % 10% confidence level:
            confidenceLevel = 0.90
            temp = abs(1.0 - confidenceLevel);
            temp2 = sprintf('Results for confidence level (using lognormal CDF): %.2f ...', temp);
            disp(temp2);
            % Compute the mean of the shifted distributions (the
            % distribution is the one for RTR variability, but the mean is
            % shifted using the distribution fof modeling variability).
                shiftedMean = logninv(confidenceLevel, meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneFOSM)
            % Compute the shiftedMeanLn...
                cov = stDevCollapseSaTOneControlComp / shiftedMean;
                shiftedMeanLn = log(shiftedMean) - 0.5 * log(cov ^ 2 + 1.0)
                approxShiftedMedian = exp(shiftedMeanLn)
            % Compute the probability of collapse at the 2% in 50 year
            % event for this confidence level
                probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, shiftedMeanLn, stDevLnCollapseSaTOneControlComp);
                probOfColAtTwoInFifty
            % Compute the MAF of collapse for this confidence level
                empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
                [AnnualFreqofCollapse] = ComputeMAFofCollapse(shiftedMeanLn, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
                AnnualFreqofCollapse

%         % 10% confidence level:
%             confidenceLevel = 0.90;
%             temp = abs(1.0 - confidenceLevel);
%             temp2 = sprintf('Results for confidence level (using lognormal CDF): %.2f ...', temp);
%             disp(temp2);
%             % Compute the mean of the shifted distributions (the
%             % distribution is the one for RTR variability, but the mean is
%             % shifted using the distribution fof modeling variability).
%                 shiftedMean = logninv(confidenceLevel, meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneFOSM);
%             % Compute the shiftedMeanLn...
%                 cov = stDevCollapseSaTOneControlComp / shiftedMean;
%                 shiftedMeanLn = log(shiftedMean) - 0.5 * log(cov ^ 2 + 1.0);
%             % Compute the probability of collapse at the 2% in 50 year
%             % event for this confidence level
%                 probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, shiftedMeanLn, stDevLnCollapseSaTOneControlComp);
%                 probOfColAtTwoInFifty
%             % Compute the MAF of collapse for this confidence level
%                 empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
%                 [AnnualFreqofCollapse] = ComputeMAFofCollapse(shiftedMeanLn, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
%                 AnnualFreqofCollapse
% 
%         % 45.5% confidence level (to try to get around the median):
%             confidenceLevel = 0.545;
%             temp = abs(1.0 - confidenceLevel);
%             temp2 = sprintf('Results for confidence level (using lognormal CDF): %.2f ...', temp);
%             disp(temp2);
%             % Compute the mean of the shifted distributions (the
%             % distribution is the one for RTR variability, but the mean is
%             % shifted using the distribution fof modeling variability).
%                 shiftedMean = logninv(confidenceLevel, meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneFOSM);
%             % Compute the shiftedMeanLn...
%                 cov = stDevCollapseSaTOneControlComp / shiftedMean;
%                 shiftedMeanLn = log(shiftedMean) - 0.5 * log(cov ^ 2 + 1.0);
%             % Compute the probability of collapse at the 2% in 50 year
%             % event for this confidence level
%                 probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, shiftedMeanLn, stDevLnCollapseSaTOneControlComp);
%                 probOfColAtTwoInFifty
%             % Compute the MAF of collapse for this confidence level
%                 empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
%                 [AnnualFreqofCollapse] = ComputeMAFofCollapse(shiftedMeanLn, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
%                 AnnualFreqofCollapse                
                






    if(1==0)
        
        % Do plot of confidence interval vs. annual frequancy of collapse
        % and P[collapse|2% in 50 Sa]
        
            % Loop through the confidence levels and do the computation.
            confidenceLevelLIST = [0.01:0.03:0.99];
            for confLevelIndex = 1:length(confidenceLevelLIST)
                oneMinusConfLevel = confidenceLevelLIST(confLevelIndex);
                % Computet the prob, of collapse at 2% in 50 and the AF of
                % collapse for this confidence level.
                    confidenceLevel = abs(1.0 - oneMinusConfLevel);
                    % Compute the mean of the shifted distributions (the
                    % distribution is the one for RTR variability, but the mean is
                    % shifted using the distribution fof modeling variability).
                        shiftedMean = logninv(confidenceLevel, meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneFOSM);
                    % Compute the shiftedMeanLn...
                        cov = stDevCollapseSaTOneControlComp / shiftedMean;
                        shiftedMeanLn = log(shiftedMean) - 0.5 * log(cov ^ 2 + 1.0);
                    % Compute the probability of collapse at the 2% in 50 year
                    % event for this confidence level
                        probOfColAtTwoInFiftyLIST(confLevelIndex) = logncdf(twoPercentInFiftyYearSa, shiftedMeanLn, stDevLnCollapseSaTOneControlComp);
                    % Compute the MAF of collapse for this confidence level
                        empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
                        [AnnualFreqofCollapse] = ComputeMAFofCollapse(shiftedMeanLn, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
                        AnnualFreqofCollapseLIST(confLevelIndex) = AnnualFreqofCollapse;
            end
                
        % Do the plots
            % Annual Frequency of collapse
                figure(figNum);
                plot(AnnualFreqofCollapseLIST, confidenceLevelLIST);
                tempTitle = sprintf('Annual Frequency of Collapse and Prediction Confidence Level. %s', model);
                title(tempTitle);
                xlabel('Annual Frequency of Collapse');
                ylabel('Prediction Confidence Level');
                grid on
                box on
                figNum = figNum + 1;
                figName = sprintf('%s.fig', tempTitle);
                cd Collapse_Uncertainty_Figures
                hgsave(figName); 
                cd ..;
                
            % P[C|2% in 50]
                figure(figNum);
                plot(confidenceLevelLIST, probOfColAtTwoInFiftyLIST);
                tempTitle = sprintf('Probability of Collapse at the 2% in 50 year Hazard and Prediction Confidence Level. %s', model);
                title(tempTitle);
                ylabel('P[Collapse | Sa_{2/50} of 0.82g]');
                xlabel('Prediction Confidence Level');
                grid on
                box on
                figNum = figNum + 1;
                figName = sprintf('%s.fig', tempTitle);
                cd Collapse_Uncertainty_Figures
                hgsave(figName);   
                cd ..;
             
                
    end
    
end
    
    