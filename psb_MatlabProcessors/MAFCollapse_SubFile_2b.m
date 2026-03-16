if(runScript2b == 1)


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



