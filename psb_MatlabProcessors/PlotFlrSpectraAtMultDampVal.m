%
% Function: PlotFloorAndGMSpectraForBothModels.m
% -------------------
% This just calls the other functions to do the plotting.  
%
% Assumptions and Notices: 
%           - none
%
% Author: Curt Haselton 
% Date Written: 10-6-04
%
% Sources of Code: Use Chopra text when creating (just for understanding)
%
% Functions and Procedures called: none
%
% Variable definitions: 
%
%
% Units: Input that it gets from the saved file are inches and seconds.  It then converts to g and sends the accel TH to the Newmark calculator.  The 
%       Newmark function returns all accel in g and all displ and vel in inches and seconds, so the output here is consistent with the Newmark function.
% -------------------
% function[] = PlotFlrSpectraAtMultDampVal(floorNum, analysisType, saTOneForRun, eqNumber, markerType, dtForSpectrum, maxPeriodForSpectrum, dampRatioLIST)


% Loop through dampRatioLIST and plot spectra
    for dampRatIndex = 1:length(dampRatioLIST)
        dampRatVal = dampRatioLIST(dampRatIndex);
        
        % Call the function to plot the spectrum    
        PlotFloorAccelSpectrum(floorNum, analysisType, saTOneForRun, eqNumber, markerType, dtForSpectrum, maxPeriodForSpectrum, dampRatVal)
        
        hold on
        
    end

% Make the legend
    legend('0.01% Damping', '1.0% Damping', '2.0% Damping', '5.0% Damping', '10.0% Damping')






        
