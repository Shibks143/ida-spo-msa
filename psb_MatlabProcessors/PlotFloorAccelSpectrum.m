%
% Function: PlotFloorAccelSpectrum.m
% -------------------
% This function is just like the ComputeResponseNewmark.m, except that it returns all of the peak reponses (displ., vel., accel.).  Note that the LIST's are
%   the spectral values, so you can easily change this to give you the vectors of the maximum spectral responses.
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
function[] = PlotFloorAccelSpectrum(floorNum, analysisType, saTOneForRun, eqNumber, markerType, dtForSpectrum, maxPeriodForSpectrum, dampRatio)

g = 386.4;

disp('Processing Floor Spectrum...')


% Open the appropriate file to get the nodal acceleration data...

    % First change the directory to get into the correct folder for processing
        cd ..;
        cd Output;
        cd(analysisType);

    % Create Sa and EQ folder names for later use
        saFolder = sprintf('Sa_%.2f', saTOneForRun);
        eqFolder = sprintf('EQ_%.0f', eqNumber);

    % Open the .mat file that holds all of the data that we need, go into folder to get it
        cd(eqFolder);
        cd(saFolder);

    load('DATA_allDataForThisSingleRun.mat');


% Get the floor absAccelTH response
    floorAccelTH = floorAccel{floorNum}.absTH / g;
    
% Create empty vectors for the time step and the responses - just get all response, so that this can be easily extended to make other spectra
    periodLIST                  = (0.000001:dtForSpectrum:maxPeriodForSpectrum);
    numPeriods                  = length(periodLIST);
    maxRelDispReponseLIST       = zeros(1, numPeriods);
    maxRelVelReponseLIST        = zeros(1, numPeriods);
    maxAbsAccelReponseLIST      = zeros(1, numPeriods);
    maxPsuedoAccelReponseLIST   = zeros(1, numPeriods);
    
% For each period, call the Newmark funnction and get the responses...
%   Note that most of the input variables are from the file that was opened.
    for i = 1:numPeriods
        currentPeriod = periodLIST(i);
        
        % Compute response
            [maxRelDispReponse, maxRelVelReponse, maxAbsAccelReponse, maxPsuedoAccelReponse] = ComputeAllResponsesNewmark(floorAccelTH, timeVectorProcessed, dtForAnalysis, currentPeriod, dampRatio);

        % Put values into the vectors
            maxRelDispReponseLIST(i)       = maxRelDispReponse;
            maxRelVelReponseLIST(i)        = maxRelVelReponse;
            maxAbsAccelReponseLIST(i)      = maxAbsAccelReponse;
            maxPsuedoAccelReponseLIST(i)   = maxPsuedoAccelReponse;

    end
    
% Now, plot the floor spectrum
    % Plot - note that the psuedoTimeVector is from the file that was opened 
    
    plot(periodLIST, maxAbsAccelReponseLIST, markerType);
    
    hold on
%     dampPercent = dampRatio * 100.0;
    legendName = sprintf('Floor spectrum for damping of %.3f%', dampRatio);
    legend(legendName);
    grid on
    titleText = sprintf('Floor Absolute Acceleration Spectrum, Floor: %d, Sa: of %.2f, EQ: %d, Analysis: %s', floorNum, saTOneForRun, eqNumber, analysisType);
    title(titleText);
    yLabel = sprintf('Maximum Absolute Spectral Acceleration Response (g)');
    ylabel(yLabel);
    xlabel('Period (seconds)');
    hold off

    
% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd ..;
cd ..;
cd MatlabProcessors;


disp('Floor Spectrum DONE!')


























