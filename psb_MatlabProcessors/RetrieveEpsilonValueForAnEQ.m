%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function opens the precalculated epsilon file and retrieves the
% epsilon value for the EQ at the period of interest.  Note that the period
% value must be found in the file that is opened (T = 0-2sec).  This
% function does not interpolate, but just rounds the period to the nearest
% value found in the file; it returns an error in the input period is out
% of range.
%
% I checked this for one EQ (BJ with Sa,comp and Sa,geoMean) and it looks like it works well.
%
% Variable options:
%   - attenFuncNum = 1 for Boore-Joyner, 2 for Abrahamson-Silva
%   - saType = 1 for Sa,comp, 2 for Sa,geoMean
%
% Curt Haselton
% 5-11-06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[epsilon] = RetrieveEpsilonValueForAnEQ(eqCompNum, T, attenFuncNum, saType)

% Hard-code tolerances.  If the period or dampRat is found within this tolerance,
% it returns the value.
    periodTolerance = 0.01;

% Save the current folder location; to get back later
    currentFolderPath = [pwd];
    
% Go to Sorted_Eq_Files folder to get file (folder location is hard-coded)
    eqSpectraFolderPath = 'C:\Users\sks\OpenSeesProcessingFiles\Epsilon_Files_Saved';
    cd(eqSpectraFolderPath)

% Open the epsilon file for this EQ
    epsilonFileName = sprintf('EpsilonForRangeOfPeriod_EQ_%d.mat', eqCompNum);
    load(epsilonFileName);
    
% Loop through the opened matrix and find the correct Sa value...
    % Initialize indicators
        isPeriodFound = 0;
    % Loop for period...   
        for periodIndex = 1:length(periodVector)
            currentPeriod = periodVector(periodIndex);
            if(abs(currentPeriod - T) < periodTolerance)
                isPeriodFound = 1;
                periodIndex_found = periodIndex;
                break;
            end
        end
    % Do an error check to be sure we found the period
        if(isPeriodFound == 0) 
            dampRatioLIST;
            periodVector;            
            errorText = sprintf('ERROR: The period could not be found! (eqNum = %d; periodTried = %.4f)', eqNum, T);
            error(errorText);
        end
        
% Based on the input for attenFuncNum and saType, return the correct
% epsilon
if(attenFuncNum == 1)
   % Use the Boore-Joyner attenuation function 
   if(saType == 1)
        % Use component Sa
        epsilon = epsilon_BJ_SaComp(periodIndex_found);
   elseif(saType == 2)
       % Use geometric mean Sa
        epsilon = epsilon_BJ_SaGeoMean(periodIndex_found);
   else
        ERROR('Invalid value for saType');
   end
elseif(attenFuncNum == 2)
   % Use the Abrhamson-Silva attenuation function 
   if(saType == 1)
        % Use component Sa
        epsilon = epsilon_AS_SaComp(periodIndex_found);
   elseif(saType == 2)
       % Use geometric mean Sa
        epsilon = epsilon_AS_SaGeoMean(periodIndex_found);
   else
        ERROR('Invalid value for saType');
   end   
else
    ERROR('Invalid value for attenFuncNum');
end

% Go back to the original folder
    cd(currentFolderPath)



