if(runScript1 == 1)

% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_1.m

    % Call function to compute MAF of collapse for LOGNORMAL collapse CDF
    % (only RTR variability)
    mean = meanLnCollapseSaTOneControlComp;
    sigma = stDevLnCollapseSaTOneControlComp;
    distTypeForCDF = 'lnrm';
    empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
    [MAFofCollapse, MAFofColDissag] = ComputeMAFofCollapse(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
    disp('Only including RTR variability and using LOGNORMAL collapse CDF, MAF is:')
    MAFofCollapse
    probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, mean, sigma);
    probOfColAtTwoInFifty

    
        % Plot the "PDF" of the contribution to the MAF of collapse
        figure(figNum);
        plot(MAFofColDissag(1,:), MAFofColDissag(3,:));
        tempTitle = sprintf('Relative Contribution to MAF of Collapse. Lognormal Collapse CDF. Only RTR Var. %s', model);
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





