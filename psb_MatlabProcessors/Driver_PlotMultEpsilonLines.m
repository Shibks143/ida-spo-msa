%
% Procedure: Driver_PlotMultEpsilonLines.m
% -------------------
% This procedure plots the Epsilon values for a set of EQs.  This opens
% previously computed .mat files and plots the results.  NOTICE: Right now
% this is only set up to plot the Abrahamson-Silva results for Sa,comp;
% this can easily be estended later to also make plots for BJF and Sa,gm.
% 
% Assumptions and Notices: 
%   - Note that some of the variables still say "spectra" since this
%   procedure was created by altering a spectra plotting function.
%
% Author: Curt Haselton 
% Date Written: 8-16-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%           - eqNumberLIST - list of EQ record numbers to plot Epsilon values for.
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the list of EQs -

    % % ATC-63 Set C 
        %eqNumberLIST = [120111	120112	120121	120122	120411	120412	120521	120522	120611	120612	120621	120622	120711	120712	120721	120722	120811	120812	120821	120822	120911	120912	120921	120922	121011	121012	121021	121022	121111	121112	121211	121212	121221	121222	121321	121322	121411	121412	121421	121422	121511	121512	121711	121712];
    
    % % ATC-63 Far-Field Set D (6-6-06)
        %eqNumberLIST = [120111	120112	120121	120122	120131	120132	120141	120142	120151	120152	120161	120162	120411	120412	120521	120522	120611	120612	120621	120622	120631	120632	120641	120642	120711	120712	120721	120722	120731	120732	120741	120742	120811	120812	120821	120822	120911	120912	120921	120922	120931	120932	121011	121012	121021	121022	121031	121032	121041	121042	121051	121052	121061	121062	121111	121112	121211	121212	121221	121222	121231	121232	121321	121322	121411	121412	121421	121422	121431	121432	121441	121442	121451	121452	121461	121462	121511	121512	121711	121712];
        
    % ATC-63 - NF Set G
        %eqNumberLIST = [8201811	8201812	8201821	8201822	8202921	8202922	8207231	8207232	8208021	8208022	8208211	8208212	8208281	8208282	8208791	8208792	8210631	8210632	8210861	8210862	8211651	8211652	8215031	8215032	8215291	8215292	8216051	8216052	8201261	8201262	8201601	8201602	8201651	8201652	8204951	8204952	8204961	8204962	8207411	8207412	8207531	8207532	8208251	8208252	8210041	8210042	8210481	8210482	8211761	8211762	8215041	8215042	8215171	8215172	8221141	8221142];

    % Temp - just one
        eqNumberLIST = [120821	120822];

        
        

% Decide if you want to plot individual and the median +/- stDev spectra (assuming
%   lognormal dist.)
    isPlotIndivSpectra = 1;    % Yes
    %isPlotIndivSpectra = 0;    % No

    %isPlotMedianLine = 1;    % Yes
    isPlotMedianLine = 0;    % No
    
    %isPlotMeanLine = 1;    % Yes
    isPlotMeanLine = 0;    % No
    
    %isStDevLines = 1;    % Yes
    isStDevLines = 0;    % No
    
    % Plot sigmaLn of the records for all T values if needed (seperate
    % plot)
    %isPlotSigmaLn = 1;  
    isPlotSigmaLn = 0;  
    
    % Plot AS or BJF 1997 function?
    isPlotAS = 1;
    
    
% Decide line types and size
    lineTypeForIndivSpectra = 'k-';
    lineSizeForIndivSpectra = 0.01; % This small line type is visible in the printout, but not on the screen
    %lineSizeForIndivSpectra = 4;
    lineTypeForMeanLnLine = 'b-';
    lineSizeForMeanLnLine = 3;
    lineTypeForSigmaLnLine = 'b-';
    lineSizeForSigmaLnLine = 4;
    lineTypeForMedianLine = 'r--';
    lineSizeForMedianLine = 4;
    lineTypeForStDevLines = 'b:';
    lineSizeForStDevLines = 1;
    
    
% Title text
    % Maybe add if needed and put on graph at end of script
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop through and plot all spectra.  While doing this, populate a matrix
%   with all of the spectra in it, so we later can compute the mean +/-
%   stDev.
    figure(1);
    hold on;

    for eqIndex = 1:length(eqNumberLIST)
        currentEQNum = eqNumberLIST(eqIndex);

        % Go to the folder to open the saved spectrum file
            currentFolderPath = [pwd];
            eqSpectraFolderPath = 'C:\Users\sks\OpenSeesProcessingFiles\Epsilon_Files_Saved';
            cd(eqSpectraFolderPath)
        
        % Open the saved spectrum file
            fileName = sprintf('EpsilonForRangeOfPeriod_EQ_%d.mat', currentEQNum);
            load(fileName);
            
        % Plot the spectum on the current figure
            if(isPlotIndivSpectra == 1)
                if(isPlotAS == 1)
                    plot(periodVector, epsilon_AS_SaComp, lineTypeForIndivSpectra, 'LineWidth', lineSizeForIndivSpectra);
                else
                    plot(periodVector, epsilon_BJ_SaComp, lineTypeForIndivSpectra, 'LineWidth', lineSizeForIndivSpectra);
                end
            end
            
        % Save the SaAbs spectrum in a matrix of spectra for all EQs (to
        % compute statistics later)
        if(isPlotAS == 1)
            Epsilon_SaComp_ALLEQs(:, eqIndex) = epsilon_AS_SaComp;
        else
            Epsilon_SaComp_ALLEQs(:, eqIndex) = epsilon_BJ_SaComp;
        end
            
        % Go back to the Matlab processor folder
            cd(currentFolderPath);
    end
    
% Now compute and plot the statistics of the spectra (if input says to do it)
    % Compute the Ln of all of the data points
        Epsilon_SaComp_ALLEQs_Ln = log(Epsilon_SaComp_ALLEQs);
        
    % Compute median, meanLn, and stdLn for each row
        medianEpsilon = zeros(length(periodVector), 1);
        meanLnEpsilon = zeros(length(periodVector), 1);
        stDevLnEpsilon = zeros(length(periodVector), 1);

        for periodIndex = 1:length(periodVector)
            medianEpsilon(periodIndex) = median(Epsilon_SaComp_ALLEQs(periodIndex, :));
            meanLnEpsilon(periodIndex) = mean(Epsilon_SaComp_ALLEQs_Ln(periodIndex, :));
            stDevLnEpsilon(periodIndex) = std(Epsilon_SaComp_ALLEQs_Ln(periodIndex, :));
        end
  
    % Compute the exp(meanLn +/- stDevLn) to plot on graph\
        epsilon_meanToPlot = exp(meanLnEpsilon);
        epsilon_meanPlusSigmaToPlot = exp(meanLnEpsilon + stDevLnEpsilon);
        epsilon_meanMinusSigmaToPlot = exp(meanLnEpsilon - stDevLnEpsilon);
        
    % Plot mean +/- stDev
        if(isPlotMedianLine == 1)
            plot(periodVector, medianEpsilon, lineTypeForMedianLine, 'LineWidth', lineSizeForMedianLine);
        end
        if(isPlotMeanLine == 1)
            plot(periodVector, epsilon_meanToPlot, lineTypeForMeanLnLine, 'LineWidth', lineSizeForMeanLnLine);
        end
        if(isStDevLines == 1)
            plot(periodVector, epsilon_meanPlusSigmaToPlot, lineTypeForStDevLines, 'LineWidth', lineSizeForStDevLines);
            plot(periodVector, epsilon_meanMinusSigmaToPlot, lineTypeForStDevLines, 'LineWidth', lineSizeForStDevLines);
        end
            
        % Do final plot details
        grid on 
        box on
        hx = xlabel('Period (sec)')
        if(isPlotAS == 1)
            hy = ylabel('\epsilon_{AS-SaComp}');
        else
            hy = ylabel('\epsilon_{BJF-SaComp}');
        end
        FigureFormatScript;
        
        % Save the figure
        plotFileName = sprintf('Epsilon_SaComp_temp');
        saveas(gca, plotFileName,'fig');
        saveas(gca, plotFileName,'emf');        
        
        hold off
    
    if(isPlotSigmaLn == 1)
        figure(2)
        hold on
        
        % Do plot
        plot(periodVector, stDevLnEpsilon, lineTypeForSigmaLnLine, 'LineWidth', lineSizeForSigmaLnLine);

        % Do final plot details
        grid on 
        box on
        hx = xlabel('Period (seconds)')
        hy = ylabel('\sigma_{LN(\epsilon)}');
        FigureFormatScript;
        
        % Save the figure
        plotFileName = sprintf('Epsilon_SaComp_SigmaLn_temp');
        saveas(gca, plotFileName,'fig');
        saveas(gca, plotFileName,'emf');    
        
        hold off        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear












