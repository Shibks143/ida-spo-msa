%
% Procedure: PlotMCurv.m
% -------------------
% This procedure plots the displacement TH for a node for a given analysis run.  It opens the file that has already been processed.  If the .mat
%   file has not been made yet (using the ProcessSinglRum.m function), this function returns an error.
% 
% Assumptions and Notices: 
%           - dofNum can be either 1 or 2 (only 2D)
%
% Author: Curt Haselton 
% Date Written: 2-26-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: 
%           - axialLoad - integer value
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
%function[void] = PlotMCurv(analysisType, sectionNum, axialLoad, markerType)

% First change the directory to get into the correct folder for processing
cd ..;
cd Output;
cd(analysisType);
cd MCurvOutput;

% Create filename strings
negMCurvFileName = sprintf('Mcurv_Sec_(%d)_(neg)_Axial_(%d).out', sectionNum, axialLoad)
posMCurvFileName = sprintf('Mcurv_Sec_(%d)_(pos)_Axial_(%d).out', sectionNum, axialLoad)

% Load files
negMCurv = load(negMCurvFileName);
posMCurv = load(posMCurvFileName);

% Plot
hold on
plot(negMCurv(:,2), negMCurv(:, 1), markerType);
plot(posMCurv(:,2), posMCurv(:, 1), markerType);
    

    titleText = sprintf('Moment Curvature of Section %d at Axial Load of %d kips, for %s', sectionNum, axialLoad, analysisType);
    title(titleText);
    grid on
    yLabel = sprintf('Moment');
    hy = ylabel(yLabel);
    hx = xlabel('Curvature');
    box on;
    FigureFormatScript;
    hold off

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;
