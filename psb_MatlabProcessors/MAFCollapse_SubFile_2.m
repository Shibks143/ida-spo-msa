if(runScript2 == 1)


% Simply a script file used when computing probabilities of collapse
% MAFCollapse_SubFile_2.m

    % Call function to compute MAF of collapse for LOGNORMAL collapse CDF
    % (with FOSM in addition to RTR variability)
    meanLnCollapseSaTOneControlComp
    mean = meanLnCollapseSaTOneControlComp;
    sigma = sqrt(stDevLnCollapseSaTOneControlComp ^ 2 + stDevLnCollapseSaTOneFOSM ^ 2);
    distTypeForCDF = 'lnrm';
    empiricalCDF = 0.0; % Just junk because it is not use unless the empirical CDF option is being used
    [MAFofCollapse] = ComputeMAFofCollapse(mean, sigma, distTypeForCDF, minSa, maxSa, numIntSteps, empiricalCDF);
    disp('Only including RTR AND FOSM variability and using LOGNORMAL collapse CDF, MAF is:')
    MAFofCollapse
    %probOfColAtTwoInFifty = logncdf(twoPercentInFiftyYearSa, mean, sigma);
    %probOfColAtTwoInFifty

end



