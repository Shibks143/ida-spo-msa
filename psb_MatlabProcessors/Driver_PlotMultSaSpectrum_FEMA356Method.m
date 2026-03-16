%
% Procedure: PlotMultSaSpectrum_ScaledToSaLevel_GeoMean.m
% -------------------
% This is just like PlotMultSaSpectrum_ScaledToSaLevel.m except it scales
%   the geometric mean of the two components to the traget spectral value
%   instead of scaling each component individually.
% This procedure plots the Sa spectra for a list of records; scaled to an
%   Sa level at a given period (like how they are scaled for IDA analyses).
% This procedure also plots the median and median +/- stDev (assuming
%   lognormal) for the spectra (this is an option).
% 
% Assumptions and Notices: 
%           - This ASSUMES that all of the opened spectra files have the
%           same periodVector! (i.e. the SaAbs matrix must use the same
%           period for all EQs being plotted!)
%           - This ASSUMES that the period and damping ratio given are in
%           the EQ spectra files in EQ_Spectra_Saved.
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%           - For each EQ listed to plot, the Sa spectrum file must have
%           been previously computed and saved in the EQ_Spectra_Saved
%           file.
%
% Author: Curt Haselton 
% Date Written: 8-16-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%           - eqNumberLIST - list of EQ record numbers to plot spectra for.
%           - scaleFactorLIST - list of scale factors to apply to the
%           spectra when plotting (list must be parallel with
%           eqNumberLIST).
%
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the list of EQs 
    % ATC-63 Set A - First ten records only
    eqNumberLIST = [1101,	1102,	1103,	1104,	1105,	1106,	1107,	1108,	1109,	1110]; 

% Input the period range over which to scale the records
    periodForScaling = 1.0; % seconds - % This period MUST BE 1.0 to be consistent with the hazard curve below is anchored being 1.0 second!!!
    period_low = 0.2 * periodForScaling;        % As per FEMA 356
    period_high = 1.5 * periodForScaling;       % As per FEMA 356

% Define Sa level and period for scaling
    saLevelForPlot = 0.60; %0.82;   % g units.  This is what the hazard curve is scaled to and 
        
% Define the damping level for the plot (this must be included in the
%   SaEQSpectrum_EQ_###.mat files
    dampingRatioToPlot = 0.05;  % This damping ratio MUST be in the spectrum file that is opened!
        
% Decide if you want to plot individual and the median +/- stDev spectra (assuming
%   lognormal dist.)
    isPlotIndivSpectra = 1;       % Yes
%     isPlotIndivSpectra = 0;         % No

    isPlotMeanLine = 1;    % Yes
%     isPlotMeanLine = 0;  % No

%     isPlotMedianLine = 1;    % Yes
    isPlotMedianLine = 0;  % No
    
    %     isPlotStDevLines = 1;    % Yes
    isPlotStDevLines = 0;  % No

% Decide line types and size
    lineTypeForIndivSpectra = 'k-';
    lineSizeForIndivSpectra = 0.01; % This small line type is visible in the printout, but not on the screen
    lineTypeForMeanLnLine = 'b--';
    lineSizeForMeanLnLine = 4;
    lineTypeForMedianLine = 'b:';
    lineSizeForMedianLine = 4;
    lineTypeForStDevLines = 'b-';
    lineSizeForStDevLines = 1;
    lineTypeForUHS = 'r-'
    lineSizeForUHS = 4;
    
% Title text
    % Maybe add if needed and put on graph at end of script
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize figures
    figure(1);
    hold on;
    figure(2)
    hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot a UHS on each plot (for comparison purposes)
    % Input Sa for Van Nuys site (from Baker)
        UHS_Period = [0.03	0.05	0.1	0.2	0.3	0.5	1	2	3	5];
        UHS_Sa = [0.620	0.737	1.076	1.343	1.332	1.142	0.800	0.478	0.282	0.154];     % 10% in 50 years
        %UHS_Sa = [0.889	1.078	1.562	1.981	1.974	1.721	1.199	0.690	0.397	0.197];     % 2% in 50 years
        scaleForUHS = saLevelForPlot / 0.8;        % Just to scale it all
        UHS_Sa_scaled = UHS_Sa * scaleForUHS;

    % Plot the UHS on Figure 1 and 1.4x the UHS in Figure 2
        ratioOfUHSToPutOnFig2ForSRSS = 1.4;     % from FEMA 356
        UHS_Sa_scaledMoreForSRSS = UHS_Sa_scaled * ratioOfUHSToPutOnFig2ForSRSS;
        figure(1)
        plot(UHS_Period, UHS_Sa_scaled, lineTypeForUHS, 'LineWidth', lineSizeForUHS);
        figure(2)
        plot(UHS_Period, UHS_Sa_scaledMoreForSRSS, lineTypeForUHS, 'LineWidth', lineSizeForUHS);
        
    % Compute the average of the scaled (by 1.4) hazard curve over the period range.  First
    % loop and save the spectral values in the period range and then take
    % the average.
    j = 1;
    for i = 1:length(UHS_Period)
        currentPeriod = UHS_Period(i);
        if((currentPeriod >= period_low) && (currentPeriod <= period_high))
            % Add Sa values to the vector
            hazardSaValuesInPeriodRange(j) = UHS_Sa_scaledMoreForSRSS(i);
            j = j + 1;
        end
    end
    % Now take the average
    averageScaledHazardCurveOverPeriodRange = mean(hazardSaValuesInPeriodRange);    % Note that this includes the 1.4 factor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop through and plot all spectra.  While doing this, populate a matrix
%   with all of the spectra in it, so we later can compute the mean +/-
%   stDev.
    recordIndex = 1;
    for eqIndex = 1:length(eqNumberLIST)
        currentEQNum_NotComp = eqNumberLIST(eqIndex);

        % Loop for EQ component
        for eqCompIndex = 1:2
            % Make the EQ compnent number
            currentEQNum = currentEQNum_NotComp * 10 + eqCompIndex;
        
            % Go to the folder to open the saved spectrum file
                cd ..;
                cd EQ_Spectra_Saved;
        
            % Open the saved spectrum file
                fileName = sprintf('SaEQSpectrum_EQ_%d.mat', currentEQNum);
                load(fileName);
            
            % Look through the damping ratio list and find the index that has
            %   the damping ratio that we want to plot.  If the damping ratio
            %   is not there, report an error!
                colIndexOfDampRatToPlot = -1;   % Initialize to a value to indicate an error if veriable is not redefined in loop
                for i = 1:length(dampRatioLIST)
                    if(dampRatioLIST(i) == dampingRatioToPlot)
                        colIndexOfDampRatToPlot = i;
                        break;
                    end
                end
            
                % Check to be sure we found the damping ratio value and report
                % an error if it was not found
                    if(colIndexOfDampRatToPlot == -1)
                        error('The damping ratio that you want use for the Sa plot can not be found in the spectrum file!') 
                    end
                
            % Find the row index for the periodForScaling
                rowIndexOfPeriodToScale = -1;   % Initialize to a value to indicate an error if veriable is not redefined in loop
                for i = 1:length(periodVector)
                    if(periodVector(i) == periodForScaling)
                        rowIndexOfPeriodToScale = i;
                        break;
                    end
                end
            
                % Check to be sure we found the damping ratio value and report
                % an error if it was not found
                    if(rowIndexOfPeriodToScale == -1)
                        error('The period that you want to use for scaling the spectrum can not be found in the spectrum file!') 
                    end      
                
            % Find the Sa(periodForScaling) and the scale factor
                saOfCurrentRecordAtPeriodForScaling(eqCompIndex) = SaAbs(rowIndexOfPeriodToScale, colIndexOfDampRatToPlot);
                %scaleFactorForCurrentRecord = saLevelForPlot /
                %saOfCurrentRecordAtPeriodForScaling; - used now in next
                %loop
                
            % Retrieve the acceleration spectrum for this damping ratio and
            %   scale it by the scale factor
                SaAbsUnScaled_forDesiredDampRat(:,eqCompIndex) = SaAbs(:, colIndexOfDampRatToPlot);
                
            % Go back to the Matlab processor folder
                cd ..;
                cd MatlabProcessors;
                
        end; % end for eqComp loops
        
        % Loop for all periods and make the SRSS spectrum for this EQ
            clear currentSaVector_SRSS
            for periodIndex = 1:length(periodVector)
                currentRowIndexOfPeriod = periodIndex;
                currentSaVector_SRSS(periodIndex,1) = ((SaAbsUnScaled_forDesiredDampRat(currentRowIndexOfPeriod, 1))^2 + (SaAbsUnScaled_forDesiredDampRat(currentRowIndexOfPeriod, 2))^2)^0.5;
                %currentScaleFactor = saLevelForPlot /
                %saOfCurrentRecordAtPeriodForScaling_GeoMean;
            end
            % Save the SRSS for this record
            eqCompIndex = 1;
            SaAbsUnScaled_forDesiredDampRat_SRSS(:,eqCompIndex) = currentSaVector_SRSS;
            eqCompIndex = 2;
            SaAbsUnScaled_forDesiredDampRat_SRSS(:,eqCompIndex) = currentSaVector_SRSS;            

        % Compute the scale factor for each record.  Take the average
        % spectral value in the period range of interest.
        % Loop and save the Sa values in the period range.
        j = 1;
        for i = 1:length(periodVector)
            currentPeriod = periodVector(i);
            if((currentPeriod >= period_low) && (currentPeriod <= period_high))
                % Add Sa values to the vector
                spectralValuesInPeriodRange(j) = currentSaVector_SRSS(i,1);
                j = j + 1;
            end
        end
        % Now take the average and compute the scale factor
        averageSaOverPeriodRange = mean(spectralValuesInPeriodRange);    % Note that this includes the 1.4 factor            
        currentScaleFactor = averageScaledHazardCurveOverPeriodRange / averageSaOverPeriodRange
            
        % Create scaled spectra
            eqCompIndex = 1;
            SaAbsScaled_forDesiredDampRat(:,eqCompIndex) = SaAbsUnScaled_forDesiredDampRat(:,eqCompIndex) * currentScaleFactor;
            SaAbsScaled_forDesiredDampRat_SRSS(:,eqCompIndex) = SaAbsUnScaled_forDesiredDampRat_SRSS(:,eqCompIndex) * currentScaleFactor;
            eqCompIndex = 2;
            SaAbsScaled_forDesiredDampRat(:,eqCompIndex) = SaAbsUnScaled_forDesiredDampRat(:,eqCompIndex) * currentScaleFactor;    
            SaAbsScaled_forDesiredDampRat_SRSS(:,eqCompIndex) = SaAbsUnScaled_forDesiredDampRat_SRSS(:,eqCompIndex) * currentScaleFactor;    
            
        % Plot the spectra on the current figure
          if(isPlotIndivSpectra == 1)
                % Plot the individual spectra
                figure(1)
                hold on
                eqCompIndex = 1;
                plot(periodVector, SaAbsScaled_forDesiredDampRat(:,eqCompIndex), lineTypeForIndivSpectra, 'LineWidth', lineSizeForIndivSpectra);
                eqCompIndex = 2;
                plot(periodVector, SaAbsScaled_forDesiredDampRat(:,eqCompIndex), lineTypeForIndivSpectra, 'LineWidth', lineSizeForIndivSpectra);
                hold on
                % Plot SRSS individual spectra
                figure(2)
                hold on
                eqCompIndex = 1;
                plot(periodVector, SaAbsScaled_forDesiredDampRat_SRSS(:,eqCompIndex), lineTypeForIndivSpectra, 'LineWidth', lineSizeForIndivSpectra);
                eqCompIndex = 2;
                plot(periodVector, SaAbsScaled_forDesiredDampRat_SRSS(:,eqCompIndex), lineTypeForIndivSpectra, 'LineWidth', lineSizeForIndivSpectra);   
                hold on
                
          end
            
            % Save the SaAbs spectrum in a matrix of spectra for all EQs (to
            % compute statistics later).  Also save the SRSS spectra.
            % Notice that the SRSS spectra are dupliated because it has the
            % same SRSS spectrun for both components; even so this will not
            % affect anything (i.e. plot will be the same with two lines
            % over each other and the summary statistics will be the same
            % because the data is just duplicated twice).
                eqCompIndex = 1;
                SaAbsScaled_forDesiredDampRat_ALLEQs(:, recordIndex) = SaAbsScaled_forDesiredDampRat(:, eqCompIndex);
                SaAbsScaled_forDesiredDampRat_ALLEQs_SRSS(:, recordIndex) = SaAbsScaled_forDesiredDampRat_SRSS(:, eqCompIndex);
                recordIndex = recordIndex + 1;
                eqCompIndex = 2;
                SaAbsScaled_forDesiredDampRat_ALLEQs(:, recordIndex) = SaAbsScaled_forDesiredDampRat_SRSS(:, eqCompIndex);
                SaAbsScaled_forDesiredDampRat_ALLEQs_SRSS(:, recordIndex) = SaAbsScaled_forDesiredDampRat_SRSS(:, eqCompIndex);
                recordIndex = recordIndex + 1;

    end; % end for EQ loop
    
% Now compute and plot the statistics of the spectra (if input says to do it)
    % Compute the Ln of all of the data points
        SaAbsScaled_forDesiredDampRat_ALLEQs_Ln = log(SaAbsScaled_forDesiredDampRat_ALLEQs);
        SaAbsScaled_forDesiredDampRat_ALLEQs_SRSS_Ln = log(SaAbsScaled_forDesiredDampRat_ALLEQs_SRSS);
        
    % Compute median, meanLn, and stdLn for each row
        medianSa = zeros(length(periodVector), 1);
        meanLnSa = zeros(length(periodVector), 1);
        stDevLnSa = zeros(length(periodVector), 1);

        for periodIndex = 1:length(periodVector)
            % Compute statistics for the individual spectra
            medianSa(periodIndex) = median(SaAbsScaled_forDesiredDampRat_ALLEQs(periodIndex, :));
            meanLnSa(periodIndex) = mean(SaAbsScaled_forDesiredDampRat_ALLEQs_Ln(periodIndex, :));
            stDevLnSa(periodIndex) = std(SaAbsScaled_forDesiredDampRat_ALLEQs_Ln(periodIndex, :));
            % Compute for the SRSS spectra statistics
            medianSa_SRSSspectra(periodIndex) = median(SaAbsScaled_forDesiredDampRat_ALLEQs_SRSS(periodIndex, :));
            meanLnSa_SRSSspectra(periodIndex) = mean(SaAbsScaled_forDesiredDampRat_ALLEQs_SRSS_Ln(periodIndex, :));
            stDevLnSa_SRSSspectra(periodIndex) = std(SaAbsScaled_forDesiredDampRat_ALLEQs_SRSS_Ln(periodIndex, :));
        end
  
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot all GM components
    % Compute the exp(meanLn +/- stDevLn) to plot on graph
        figure(1)
        sa_meanToPlot = exp(meanLnSa);
        sa_meanPlusSigmaToPlot = exp(meanLnSa + stDevLnSa);
        sa_meanMinusSigmaToPlot = exp(meanLnSa - stDevLnSa);
        
    % Plot mean +/- stDev
        if(isPlotMedianLine == 1)
            plot(periodVector, medianSa, lineTypeForMedianLine, 'LineWidth', lineSizeForMedianLine);
        end
        if(isPlotMeanLine == 1)
            plot(periodVector, sa_meanToPlot, lineTypeForMeanLnLine, 'LineWidth', lineSizeForMeanLnLine);
        end
        if(isPlotStDevLines == 1)
            plot(periodVector, sa_meanPlusSigmaToPlot, lineTypeForStDevLines, 'LineWidth', lineSizeForStDevLines);
            plot(periodVector, sa_meanMinusSigmaToPlot, lineTypeForStDevLines, 'LineWidth', lineSizeForStDevLines);
        end
            
    % Do final plot details
        grid on 
        box on
        title('FEMA 356 Scaling: Individual Component Spectra')
        hx = xlabel('Period (seconds)')
        hy = ylabel('Sa_{component} [g]')
        FigureFormatScript;
        hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot SRSS of all GM components
    % Compute the exp(meanLn +/- stDevLn) to plot on graph
        figure(2)
        sa_meanToPlot_SRSSspectra = exp(meanLnSa_SRSSspectra);
        sa_meanPlusSigmaToPlot_SRSSspectra = exp(meanLnSa_SRSSspectra + stDevLnSa_SRSSspectra);
        sa_meanMinusSigmaToPlot_SRSSspectra = exp(meanLnSa_SRSSspectra - stDevLnSa_SRSSspectra);
        
    % Plot mean +/- stDev
        if(isPlotMedianLine == 1)
            plot(periodVector, medianSa_SRSSspectra, lineTypeForMedianLine, 'LineWidth', lineSizeForMedianLine);
        end
        if(isPlotMeanLine == 1)
            plot(periodVector, sa_meanToPlot_SRSSspectra, lineTypeForMeanLnLine, 'LineWidth', lineSizeForMeanLnLine);
        end
        if(isPlotStDevLines == 1)
            plot(periodVector, sa_meanPlusSigmaToPlot_SRSSspectra, lineTypeForStDevLines, 'LineWidth', lineSizeForStDevLines);
            plot(periodVector, sa_meanMinusSigmaToPlot_SRSSspectra, lineTypeForStDevLines, 'LineWidth', lineSizeForStDevLines);
        end
            
    % Do final plot details
        grid on 
        box on
        title('FEMA 356 Scaling: SRSS of Spectra')
        hx = xlabel('Period (seconds)')
        hy = ylabel('Sa_{SRSS} [g]')
        FigureFormatScript;
        hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    
    
    
    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear












