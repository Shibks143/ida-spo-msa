%
% Procedure: MAFCollapse_ALLUpdatedSubFiles.m
% -------------------
%   This is just a file full of scripts to compute MAF of collapse and
%   collapse probability.  NOTICE that these are updated from the other
%   seperate MAF script files but I have not used all of these script
%   options, so some may not work now (if I want to use them, I may just
%   need to update some variables; shouldn't be too hard).  I made this
%   updated file to compute the results for the archetype models;
%   therefore, this is set up to work for multiple sites and any period.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 8-26-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%       function [MAFofCollapse] = ComputeMAFofCollapse(mean, sigma,
%       distTypeForCDF, minSa, maxSa, numIntSteps)
%       OTHERS...
%
% Variable definitions:
%       siteNum = 1 for Benchmark site in LA (by Goulet and Stewart of UCLA)
%               = XX
%       OTHERS...
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 1a:
if(runScript1a == 1)

% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_1.m

    % Call function to compute MAF of collapse for LOGNORMAL collapse CDF
    % (only RTR variability)
    mean = meanLnCollapseSaTOneAllComp;
    sigma = stDevLnCollapseSaTOneAllComp;
    distTypeForCDF = 'lnrm';
    empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
    period = modelFundamentalPeriod;
    [MAFofCollapse_allComp_OnlyRTRVar, MAFofColDissag] = ComputeMAFofCollapse_newerGeneralForSiteAndPeriod(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF, siteNum, period);
    disp('Only including RTR variability and using LOGNORMAL collapse CDF, all comp., MAF is:')
    mean
    sigma
    MAFofCollapse_allComp_OnlyRTRVar
    %probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, mean, sigma);
    %probOfColAtTwoInFifty

        if(isDoCollapseDissagPlot == 1)
            % Plot the "PDF" of the contribution to the MAF of collapse
            figure(figNum);
            plot(MAFofColDissag(1,:), MAFofColDissag(3,:));
            tempTitle = sprintf('Relative Contribution to MAF of Collapse. Lognormal Collapse CDF. All Comp. Only RTR Var. %s', modelName);
            title(tempTitle);
            xlabel('Spectral Acceleration at First Mode Period (g)');
            ylabel('Relative Contribution Different Sa Levels to MAF of Collapse');
            grid on
            box on
            figNum = figNum + 1;
            figName = sprintf('%s.fig', tempTitle);
            cd Collapse_Uncertainty_Figures
            hgsave(figName);
            cd ..;
        end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 1b:
if(runScript1b == 1)

% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_1.m

    % Call function to compute MAF of collapse for LOGNORMAL collapse CDF
    % (only RTR variability)
    mean = meanLnCollapseSaTOneControlComp;
    sigma = stDevLnCollapseSaTOneControlComp;
    distTypeForCDF = 'lnrm';
    empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
    period = modelFundamentalPeriod;
    [MAFofCollapse_controlComp_OnlyRTRVar, MAFofColDissag] = ComputeMAFofCollapse_newerGeneralForSiteAndPeriod(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF, siteNum, period);
    disp('Only including RTR variability and using LOGNORMAL collapse CDF, control comp., MAF is:')
    mean 
    sigma
    MAFofCollapse_controlComp_OnlyRTRVar
    %probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, mean, sigma);
    %probOfColAtTwoInFifty

        if(isDoCollapseDissagPlot == 1)
            % Plot the "PDF" of the contribution to the MAF of collapse
            figure(figNum);
            plot(MAFofColDissag(1,:), MAFofColDissag(3,:));
            tempTitle = sprintf('Relative Contribution to MAF of Collapse. Lognormal Collapse CDF. Control. Comp. Only RTR Var. %s', modelName);
            title(tempTitle);
            xlabel('Spectral Acceleration at First Mode Period (g)');
            ylabel('Relative Contribution Different Sa Levels to MAF of Collapse');
            grid on
            box on
            figNum = figNum + 1;
            figName = sprintf('%s.fig', tempTitle);
            cd Collapse_Uncertainty_Figures
            hgsave(figName);
            cd ..;
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 2a:
if(runScript2a == 1)

% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_2.m

    % Call function to compute MAF of collapse for LOGNORMAL collapse CDF
    % (with FOSM in addition to RTR variability)
    meanLnCollapseSaTOneAllComp
    mean = meanLnCollapseSaTOneAllComp;
    sigma = sqrt(stDevLnCollapseSaTOneAllComp ^ 2 + stDevLnCollapseSaTOneFOSM ^ 2);
    distTypeForCDF = 'lnrm';
    empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
    period = modelFundamentalPeriod;
    [MAFofCollapse_allComp_RTRAndModelVar, MAFofColDissag] = ComputeMAFofCollapse_newerGeneralForSiteAndPeriod(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF, siteNum, period);
    disp('Only including RTR AND FOSM variability and using LOGNORMAL collapse CDF, control comp., MAF is:')
    period
    mean
    sigma
    MAFofCollapse_allComp_RTRAndModelVar
    %probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, mean, sigma);
    %probOfColAtTwoInFifty
    
            if(isDoCollapseDissagPlot == 1)
            % Plot the "PDF" of the contribution to the MAF of collapse
            figure(figNum);
            plot(MAFofColDissag(1,:), MAFofColDissag(3,:));
            tempTitle = sprintf('Relative Contribution to MAF of Collapse. Lognormal Collapse CDF. Control. Comp. With Model Uncert. %s', modelName);
            title(tempTitle);
            xlabel('Spectral Acceleration at First Mode Period (g)');
            ylabel('Relative Contribution Different Sa Levels to MAF of Collapse');
            grid on
            box on
            figNum = figNum + 1;
            figName = sprintf('%s.fig', tempTitle);
            cd Collapse_Uncertainty_Figures
            hgsave(figName);
            cd ..;
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 2b:
if(runScript2b == 1)

% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_2.m

    % Call function to compute MAF of collapse for LOGNORMAL collapse CDF
    % (with FOSM in addition to RTR variability)
    meanLnCollapseSaTOneControlComp
    mean = meanLnCollapseSaTOneControlComp;
    sigma = sqrt(stDevLnCollapseSaTOneControlComp ^ 2 + stDevLnCollapseSaTOneFOSM ^ 2);
    distTypeForCDF = 'lnrm';
    empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
    period = modelFundamentalPeriod;
    [MAFofCollapse_controlComp_RTRAndModelVar, MAFofColDissag] = ComputeMAFofCollapse_newerGeneralForSiteAndPeriod(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF, siteNum, period);
    disp('Only including RTR AND FOSM variability and using LOGNORMAL collapse CDF, all comp., MAF is:')
    period
    mean
    sigma
    MAFofCollapse_controlComp_RTRAndModelVar
    %probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, mean, sigma);
    %probOfColAtTwoInFifty
    
            if(isDoCollapseDissagPlot == 1)
            % Plot the "PDF" of the contribution to the MAF of collapse
            figure(figNum);
            plot(MAFofColDissag(1,:), MAFofColDissag(3,:));
            tempTitle = sprintf('Relative Contribution to MAF of Collapse. Lognormal Collapse CDF. All Comp. With Model Uncert. %s', modelName);
            title(tempTitle);
            xlabel('Spectral Acceleration at First Mode Period (g)');
            ylabel('Relative Contribution Different Sa Levels to MAF of Collapse');
            grid on
            box on
            figNum = figNum + 1;
            figName = sprintf('%s.fig', tempTitle);
            cd Collapse_Uncertainty_Figures
            hgsave(figName);
            cd ..;
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script 2c:
if(runScript2c == 1)

% Compute and plot the MAF of collapse and the P[collapse | 2 in 50] for
% the range of sigmaLnModeling that was input in the main script.

    index = 1;
    for currentStDevLnModeling = stDevLnCollapseSaTOneFOSM_low:stDevLnCollapseSaTOneFOSM_step:stDevLnCollapseSaTOneFOSM_high
        stDevLnModelingLIST(index) = currentStDevLnModeling;

        % Compute total sigma (modeling + RTR), then save
        stDevLnTotal = sqrt(stDevLnCollapseSaTOneControlComp ^ 2 + currentStDevLnModeling ^ 2);
        stDevLnTotalLIST(index) = stDevLnTotal;
    
        % Calculate prob and MAF and save
        mean = meanLnCollapseSaTOneControlComp;
        distTypeForCDF = 'lnrm';
        empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
        [MAFofCollapse] = ComputeMAFofCollapse(mean, stDevLnTotal, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
        MAFofCollapseLIST(index) = MAFofCollapse;
        probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, mean, stDevLnTotal);
        probOfColAtTwoInFiftyLIST(index) = probOfColAtTwoInFifty;

        index = index + 1;
    end
    
    % Now make the plots
        % Plot the MAF of collapse
        figure(figNum);
        plot(stDevLnModelingLIST, MAFofCollapseLIST);
        tempTitle = sprintf('Effect of Modeling Uncertainty on Collapse Risk %s', model);
        title(tempTitle);
        hx = xlabel('\sigma_{LN,modeling(Sa,col)}');
        hy = ylabel('\lambda_{collapse}');
        grid on
        box on
        FigureFormatScript
        figNum = figNum + 1;
    
        % Plot the P[collapse | 2/50]
        figure(figNum);
        plot(stDevLnModelingLIST, probOfColAtTwoInFiftyLIST);
        tempTitle = sprintf('Effect of Modeling Uncertainty on P[collapse] %s', model);
        title(tempTitle);
        hx = xlabel('\sigma_{LN,modeling(Sa,col)}');
        hy = ylabel('P[Collapse | Sa_{2/50}]');
        grid on
        box on
        FigureFormatScript
        figNum = figNum + 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 3:
if(runScript3 == 1)
    
% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_3.m

    % Call function to compute MAF of collapse for NORMAL collapse CDF
    % (only RTR variability)
    mean = meanCollapseSaTOneControlComp;
    sigma = stDevCollapseSaTOneControlComp;
    distTypeForCDF = 'norm';
    empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
    [MAFofCollapse, MAFofColDissag] = ComputeMAFofCollapse(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
    disp('Only including RTR variability and using NORMAL collapse CDF, MAF is:')
    MAFofCollapse
    probOfColAtTwoInFifty = normcdf(twoPercentInFiftyYearSa, mean, sigma);
    probOfColAtTwoInFifty

        % Plot the "PDF" of the contribution to the MAF of collapse
        figure(figNum);
        plot(MAFofColDissag(1,:), MAFofColDissag(3,:));
        tempTitle = sprintf('Relative Contribution to MAF of Collapse. Normal Collapse CDF. Only RTR Var. %s', model);
        title(tempTitle);
        xlabel('Spectral Acceleration at First Mode Period (g)');
        ylabel('Relative Contribution Different Sa Levels to MAF of Collapse');
        grid on
        box on
        figNum = figNum + 1;
        figName = sprintf('%s.fig', tempTitle);
        cd Collapse_Uncertainty_Figures;
        hgsave(figName);
        cd ..;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 4:
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 5:
if(runScript5 == 1)

% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_5.m

    % Use the empirical CDF to compute the MAF of collapse and the
    % AnnulaFrequencies of collapse at different confidence levels...
    
        % Find the MAF of collapse using the empirical collapse CDF (no
        % shift of the meanLn)
            distTypeForCDF = 'empr';
            empiricalCDF = empCollapseCDF_unsorted;
            [MAFofCollapse, MAFofColDissag] = ComputeMAFofCollapse(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
            disp('Only including RTR variability and using EMPIRICAL collapse CDF, MAF is:')
            MAFofCollapse

        % Plot the "PDF" of the contribution to the MAF of collapse
        figure(figNum);
        plot(MAFofColDissag(1,:), MAFofColDissag(3,:));
        tempTitle = sprintf('Relative Contribution to MAF of Collapse. Empirical Collapse CDF. Only RTR Var. %s', model);
        title(tempTitle);
        xlabel('Spectral Acceleration at First Mode Period (g)');
        ylabel('Relative Contribution Different Sa Levels to MAF of Collapse');
        grid on
        box on
        figNum = figNum + 1;
        figName = sprintf('%s.fig', tempTitle);
        cd Collapse_Uncertainty_Figures
        hgsave(figName);    
        cd ..;
    
  % Note that I am not shifting this to compute confidence levels because I
  % would need to change the shape of the empirical CDF.  I tried to shift
  % the empirical CDF to get confidence levels, but it gave really strange
  % numbers because I did not alter the empirical CDF shape!
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 6:
if(runScript6 == 1)
% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_6.m

    % Compute the Annual Frequency of Collapse and the Prob. at 2% in 50
    % years for many difference confidence levels.

    % Loop for all confidence levels and all stDevLnCollapseSaTOneFOSM values...
            % Loop through the confidence levels and do the computation.
            confidenceLevelLIST = [0.01:0.03:0.99];
            stDevLnCollapseSaTOneFOSMLIST = [stDevLnCollapseSaTOneFOSM_low:stDevLnCollapseSaTOneFOSM_step:stDevLnCollapseSaTOneFOSM_high];
            for confLevelIndex = 1:length(confidenceLevelLIST)
                oneMinusConfLevel = confidenceLevelLIST(confLevelIndex);
                confidenceLevel = abs(1.0 - oneMinusConfLevel);
                
                % Loop through all signma levels and compute
                for sigmaLnFOSMIndex = 1:length(stDevLnCollapseSaTOneFOSMLIST)
                    stDevLnCollapseSaTOneFOSM = stDevLnCollapseSaTOneFOSMLIST(sigmaLnFOSMIndex);
                    
                    % Save the matrices of confidence level and sigma
                    confidenceLevelMATRIX(confLevelIndex, sigmaLnFOSMIndex) = confidenceLevel;
                    stDevLnCollapseSaTOneFOSMMATRIX(confLevelIndex, sigmaLnFOSMIndex) = stDevLnCollapseSaTOneFOSM;
                    
                    % Compute the prob, of collapse at 2% in 50 and the AF of
                    % collapse for this confidence level.
                        % Compute the mean of the shifted distributions (the
                        % distribution is the one for RTR variability, but the mean is
                        % shifted using the distribution fof modeling variability).
                            shiftedMean = logninv(oneMinusConfLevel, meanLnCollapseSaTOneControlComp, stDevLnCollapseSaTOneFOSM);
                        % Compute the shiftedMeanLn...
                            cov = stDevCollapseSaTOneControlComp / shiftedMean;
                            shiftedMeanLn = log(shiftedMean) - 0.5 * log(cov ^ 2 + 1.0);
                        % Compute the probability of collapse at the 2% in 50 year
                        % event for this confidence level
                            probOfColAtTwoInFiftyMATRIX(confLevelIndex, sigmaLnFOSMIndex) = logncdf(twoPercentInFiftyYearSa, shiftedMeanLn, stDevLnCollapseSaTOneControlComp);
                        % Compute the MAF of collapse for this confidence level
                            empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
                            distTypeForCDF = 'lnrm';
                            sigma = stDevLnCollapseSaTOneControlComp;
                            [AnnualFreqofCollapse] = ComputeMAFofCollapse(shiftedMeanLn, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
                            AnnualFreqofCollapseMATRIX(confLevelIndex, sigmaLnFOSMIndex) = AnnualFreqofCollapse;
                end

            end
    
    % Do plots of probability of collapse at 2% in 50 level and the annual
    % frequency of collapse
    
            % Probability of collapse at 2% in 50 year level
                figure(figNum);
                surf(stDevLnCollapseSaTOneFOSMMATRIX, confidenceLevelMATRIX, probOfColAtTwoInFiftyMATRIX)
                %%mesh(stDevLnCollapseSaTOneFOSMMATRIX, confidenceLevelMATRIX, probOfColAtTwoInFiftyMATRIX)
                % Make a lighted surface with color
                %%   surfl(stDevLnCollapseSaTOneFOSMMATRIX, confidenceLevelMATRIX, probOfColAtTwoInFiftyMATRIX);
                %%    shading interp
                %%    MAP = [.5 .5 .5];   % grey
                %%    %%colormap(MAP)
                %%    colomap pink
                
                tempTitle = sprintf('Collapse Prob. and 2 in 50, with Prediction Confidence and Modeling Uncertainty. %s', model);
                title(tempTitle);
                ylabel('Prediction Confidence Level');
                xlabel('Ln-Standard Deviation from Epistemic Uncertainty');
                zlabel('Probability of Collapse at 0.02 in 50 year hazard');
                grid on
                box on
                figNum = figNum + 1;
                figName = sprintf('%s.fig', tempTitle);
                cd Collapse_Uncertainty_Figures
                hgsave(figName);   
                cd ..;
            
            % Annual freq of collapse
                figure(figNum);
                surf(stDevLnCollapseSaTOneFOSMMATRIX, confidenceLevelMATRIX, AnnualFreqofCollapseMATRIX)
                
                tempTitle = sprintf('Annual Frequency of Collapse with Prediction Confidence and Modeling Uncertainty. %s', model);
                title(tempTitle);
                ylabel('Prediction Confidence Level');
                xlabel('Ln-Standard Deviation from Epistemic Uncertainty');
                zlabel('Annual Frequency of Collapse');
                grid on
                box on
                figNum = figNum + 1;
                figName = sprintf('%s.fig', tempTitle);
                cd Collapse_Uncertainty_Figures
                hgsave(figName);   
                cd ..;
             
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 1:


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 1:



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Script 1:










