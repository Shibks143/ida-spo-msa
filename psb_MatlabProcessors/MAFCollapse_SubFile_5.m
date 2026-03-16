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

