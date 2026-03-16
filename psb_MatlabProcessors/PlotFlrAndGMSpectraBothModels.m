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
% function[] = PlotFloorAndGMSpectraForBothModels(floorNum, analysisTypeNlBmCol, analysisTypeHystHinge, saTOneForRun, eqNumber, markerType1, markerType2, dtForSpectrum, maxPeriodForSpectrum, dampRatio)

% Just input values here
    floorNum                = 2;
    analysisTypeNlBmCol     = '(DesID1_v.51)_(AllVar)_(Mean)_(nonlinearBeamColumn)';
    analysisTypeHystHinge   = '(DesID1_v.53)_(AllVar)_(Mean)_(hystHinge)';
    saTOneForRun            = 0.82;
    eqNumber                = 403;
    markerType1             = 'b';  % For GM and NlBmCol
    markerType2             = 'r';  % For hyst hinge
    dtForSpectrum           = 0.02;
    maxPeriodForSpectrum    = 2.0;
    dampRatio               = 0.05;
    

% Plot the GM spectrum on the bottom of the subplot
    subplot(2,1,2)
    PlotEQAccelSpectrum(eqNumber, markerType1, dtForSpectrum, maxPeriodForSpectrum, dampRatio)

% Plot the floor spectra

    % Plot for nlBmCol
        % Make the analysisTypeName
        analysisType = analysisTypeNlBmCol;
        subplot(2,1,1)
        PlotFloorAccelSpectrum(floorNum, analysisType, saTOneForRun, eqNumber, markerType1, dtForSpectrum, maxPeriodForSpectrum, dampRatio)
        hold on
        
    % Plot for hystHinge
        % Make the analysisTypeName
        analysisType = analysisTypeHystHinge;
        subplot(2,1,1)
        PlotFloorAccelSpectrum(floorNum, analysisType, saTOneForRun, eqNumber, markerType2, dtForSpectrum, maxPeriodForSpectrum, dampRatio)
        hold off

% Do final plot details
       subplot(2,1,1)
       legend('nonlinearBeamColumn', 'Lumped Plasticity');
        
        
