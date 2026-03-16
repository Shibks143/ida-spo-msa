%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function opens the precalculated spectra file and retrieves the Sa
% for the EQ at the period and damping of interest.  Note that the period
% value and damping value must be found in the file that is opened (i.e.
% this does not interpolate between points):
%   damping ratios: [0.0200, 0.0500, 0.1000, 0.1500, 0.2000, 0.2500, 0.3000]
%   periods = [0.01:0.01:5.00]
% This function was tested and results look good!
%
% Curt Haselton
% 9-26-05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[Sa_abs_psuedo] = psb_RetrieveSaCompValueForAnEQ(eqNum, T, dampRat)

% eqNum=120111; T=0.86; dampRat=0.05; %trial values

% Hard-code tolerances.  If the period or dampRat is found within this tolerance,
% it returns the value.
    periodTolerance = 0.005;
    dampRatTolerance = 0.005;

% Save the current folder location; to get back later
    currentFolderPath = [pwd];
    
% Go to Sorted_Eq_Files folder to get file (folder location is hard-coded)
    eqSpectraFolderPath = 'C:\Users\sks\OpenSeesProcessingFiles\EQ_Spectra_Saved';
    cd(eqSpectraFolderPath)

% Open the spectrum for this EQ
    eqSpectrumFileName = sprintf('SaEQSpectrum_EQ_%d.mat', eqNum);
    load(eqSpectrumFileName);
    
% Loop through the opened matrix and find the correct Sa value...
    % Initialize indicators
        isPeriodFound = 0;
        isDampRatFound = 0;
    % Loop for period...   
        for periodIndex = 1:length(periodVector)
            currentPeriod = periodVector(periodIndex);
            if(abs(currentPeriod - T) < periodTolerance)
                isPeriodFound = 1;
                periodIndex_found = periodIndex;
                break;
            end
        end
    % Loop for damping ratio...   
        for dampRatIndex = 1:length(dampRatioLIST)
            currentDampRat = dampRatioLIST(dampRatIndex);
            if(abs(currentDampRat - dampRat) < dampRatTolerance)
                isDampRatFound = 1;
                dampRatIndex_found = dampRatIndex;
                break;
            end
        end
    % Do an error check to be sure we found both
        if(isPeriodFound == 0 || isDampRatFound == 0) 
            dampRatioLIST;
            periodVector;            
            errorText = sprintf('ERROR: Either the period or the damping ratio could not be found! (eqNum = %d; periodTried = %.4f; dampRatTried = %.4f)', eqNum, T, dampRat);
            error(errorText);
        end
    % Return the correct Sa value
        Sa_abs_psuedo = SaAbs(periodIndex_found, dampRatIndex_found);
    
% Go back to the original folder
    cd(currentFolderPath)



