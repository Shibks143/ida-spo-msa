%
% Function: PlotEQAccelSpectrum.m
% -------------------
% This function is just like the ComputeResponseNewmark.m, except that it returns all of the peak reponses (displ., vel., accel.).  Note that the LIST's are
%   the spectral values, so you can easily change this to give you the vectors of the maximum spectral responses.
%
%
%
%
%
%
%  JUST MAKE THIS OPEN THE SAVED EQ_SPECTRUM File instead of computing a
%  new one!
%
%
%
%
%
%
% Assumptions and Notices: 
%           - This looks in the Sorted_EQ_.. folder for the sorted record, so be sure that it is there!
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
% Units: Input usnits from the EQ file are g; then they are converted to in/s, so the output is inches and seconds, except acceleration is output in g.
% -------------------
function[] = PlotEQAccelSpectrum(eqNumber, markerType, dtForSpectrum, maxPeriodForSpectrum, dampRatio)

g = 386.4;

disp('Processing EQ Spectrum...')

% First, load the file that has all of the EQ information (dT, numPonts, etc.)
    defineEQInfoForMATLAB

% Now, open the appropriate test file to get the SORTED EQ TH file (in units of g)

    % First change the directory to get into the correct folder for processing
        cd ..;
        cd Models;
        cd Sorted_EQ_Files
        
    % Create the filename and open the file      
        % Make the name of the sorted EQ file to read
        sortedInputEQFileName = sprintf('SortedEQFile_(%d).txt', eqNumber);
    
        % Load the file
        groundAccelerationTH = load(sortedInputEQFileName);
        
    % Make a timeVector for the EQ
        dtForCurrentEQ = dtForEQRecord(eqNumber);
        numPoints = length(groundAccelerationTH);   % Do this instead of using the information from the opensed file, just to be safe (to get the correct lengths)
        maxEQTime = dtForCurrentEQ * numPoints;
        eqTimeVector = [0:dtForCurrentEQ:maxEQTime];
        
    
% Create empty vectors for the time step and the responses - just get all response, so that this can be easily extended to make other spectra
    periodLIST                  = (0.00001:dtForSpectrum:maxPeriodForSpectrum);
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
            [maxRelDispReponse, maxRelVelReponse, maxAbsAccelReponse, maxPsuedoAccelReponse] = ComputeAllResponsesNewmark(groundAccelerationTH, eqTimeVector, dtForCurrentEQ, currentPeriod, dampRatio);

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
    dampPercent = dampRatio * 100.0;
    legendName = sprintf('Abs. Accel Spectrum, EQ %d, damping of %.3f%', eqNumber, dampRatio);
    legend(legendName);
    grid on
    titleText = sprintf('Ground Modtion Absolute Acceleration Spectrum, EQ %d, damping of %.3f%', eqNumber, dampRatio);
    title(titleText);
    yLabel = sprintf('Maximum Absolute Spectral Acceleration Response (g)');
    ylabel(yLabel);
    xlabel('Period (seconds)');
    hold off


    
    
% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd MatlabProcessors;

disp('EQ Spectrum DONE!')


return

























