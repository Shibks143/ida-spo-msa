%
% Function: Driver_ComputeAndPlotBooreJoynerSpectrum.m
% -------------------
% This function returns the full spectrum predicted by BJF (from BJF
% function from Jack).  
% 
% Assumptions and Notices: 
%       - This automatically gives the spectrum from 0.001 to 2.0 seconds
%       (because that is what BJF can do!).
%       - When computing median +/- sigma values, I am assuming that the
%       median(Sa) = exp(mean(Ln(Sa))) (standard lognormal assumption).
%       Therefore, (median +/- X*sigma) = exp(log(median) +/- X*sigmaLn). 
%
% Functions called:
%   - BooreJoyner_Atten(M, R, T, Fault_Type, Vs, arb); created by Jack W. Baker
%
% Author: Curt Haselton 
% Date Written: 9-14-05
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%       - SaResultsMatrix:
%               - Column 1 - Period (sec.)
%               - Column 2 - Median Prediction
%               - Column 3 - Median - sigma (assuming lognormal)
%               - Column 4 - Median + sigma (assuming lognormal)
%               - Column 5 - Median - 2*sigma (assuming lognormal)
%               - Column 6 - Median + 2*sigma (assuming lognormal)
%       - M             = Moment Magnitude
%       - R             = boore joyner distance (km)
%       - Fault_Type    = 1 for strike-slip fault 
%                       = 2 for reverse-slip fault
%                       = 0 for non-specified mechanism
%       - Vs            = shear wave velocity averaged over top 30 m (use 310 m/s for soil, 620 for rock m/s)
%       - arb           = 1 for arbitrary component sigma
%                       = 0 for average component sigma
%
% Units: 
%       - Sa in g units
%       - Vs in m/s
%       - R in km
% -------------------

clear
clc

% Input the data to use for the spectrum - this is set up for an
% approximate 2% in 50 year event at the LA Bulk Mail site used for the
% Benchmarking project (See hand notes in ATC-63 folder dated 9-14-05).
    M = 6.9; %6.9; %7.0;
    R = 11.0; %13.7; %28.0; %10.0;
    Fault_Type = 1; % strike-slip
    Vs = 360;       % soil
    arb = 1;        % arbitrary component
    
% Input line types to use
    lineTypeForMedian = 'b-';
    lineWidthForMedian = 4;
    lineTypeForMedianAndOneSigma = 'b--';
    lineTypeForMedianAndTwoSigma = 'b:';
    lineWidthForMedianAndSigmas = 2;
    
% Call the function
    [SaResultsMatrix] = BooreJoyner_ComputeFullPredictedSpectrum(M, R, Fault_Type, Vs, arb);

% Make the plot
    plot(SaResultsMatrix(1,:), SaResultsMatrix(2,:), lineTypeForMedian, 'LineWidth', lineWidthForMedian);   % Median
    hold on
    plot(SaResultsMatrix(1,:), SaResultsMatrix(3,:), lineTypeForMedianAndOneSigma, 'LineWidth', lineWidthForMedianAndSigmas);   % Median +/- one sigma
    plot(SaResultsMatrix(1,:), SaResultsMatrix(4,:), lineTypeForMedianAndOneSigma, 'LineWidth', lineWidthForMedianAndSigmas);   % Median +/- one sigma
    plot(SaResultsMatrix(1,:), SaResultsMatrix(5,:), lineTypeForMedianAndTwoSigma, 'LineWidth', lineWidthForMedianAndSigmas);   % Median +/- two sigma
    plot(SaResultsMatrix(1,:), SaResultsMatrix(6,:), lineTypeForMedianAndTwoSigma, 'LineWidth', lineWidthForMedianAndSigmas);   % Median +/- two sigma

% Finish and format the plot
    grid on
    box on
    hy = ylabel('Sa,_{component} [g]');
    hx = xlabel('Period [seconds]');
    %legend???

FigureFormatScript

    hold off

    % Save as temp file in this folder
    exportName = sprintf('TempPlot_1.emf');
    print('-dmeta', exportName);
    plotName = sprintf('TempPlot_1.fig');
    hgsave(plotName);
    
    











