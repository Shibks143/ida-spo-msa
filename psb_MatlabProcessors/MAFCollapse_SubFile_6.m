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
                %%mesh(stDevLnCollapseSaTOneFOSMMATRIX, confidenceLevelMATRIX, AnnualFreqofCollapseMATRIX)
                % Make a lighted surface with color
                %%   surfl(stDevLnCollapseSaTOneFOSMMATRIX, confidenceLevelMATRIX, probOfColAtTwoInFiftyMATRIX);
                %%    shading interp
                %%    MAP = [.5 .5 .5];   % grey
                %%    %%colormap(MAP)
                %%    colomap pink
                
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
    
    
    
%     % OLD FILE
%     
%                 
%             % Annual Frequency of collapse
%                 figure(figNum);
%                 plot(probOfColAtTwoInFiftyLIST, confidenceLevelLIST);
%                 tempTitle = sprintf('Probability of Collapse at the 2% in 50 year Hazard and Prediction Confidence Level. %s', model);
%                 title(tempTitle);
%                 xlabel('Probability of Collapse at the 2% in 50 year Hazard');
%                 ylabel('Prediction Confidence Level');
%                 grid on
%                 box on
%                 figNum = figNum + 1;
%                 figName = sprintf('%s.fig', tempTitle);
%                 cd Collapse_Uncertainty_Figures
%                 hgsave(figName);   
%                 cd ..;
%              
                
end
    
    
    