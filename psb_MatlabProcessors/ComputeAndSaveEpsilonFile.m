%
% Procedure: ComputeAndSaveEpsilonFile.m
% -------------------
% This procedure computes the Epsilon values over a range of period and
% then saves the file.  I tried to make the periods consistent with the
% SaSpectrum files; however, the BJF Attenuation function only goes to 2.0
% seconds.  The AS function goes to 5 seconds, so we can continue this file out to
% 5 seconds and place NAN values for BJF espilon at periods > 2 seconds.
% If we try for a period over 5 seconds, it reports as error.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 3-13-06, 7-20-06
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%           - M - magnitude
%           - R - radius - Joyner-Boore distance from rupture to site
%           - Vs - soil shear-wave velocity on top 30m of soil (m/s), as
%               reported in PEER and PEER-NGA ground motion databases.
%           - fault-Type_BJ - 0 for non-specified, 1 for strike-slip, 2 for reverse
%           - fault_Type_AS - 1 for Reverse, 0.5 for reverse/oblique, 0 otherwise
%           - isSoilAS - 1 for soil prediction, 0 for rock [If PEER-NGA GMX C3 is
%               A/B, the site is rock.  C/D/E are soil sites (Polsak said this is how it
%               should be for thie atten. func.)]
%           - eqCompNum - the index number of this record
%           - minPeriod - min. period for spectrum [used from the Sa file opened]
%           - maxPeriod - max. period for spectrum [used from the Sa file opened]
%           - periodIncr - increment step size for period [used from the Sa file opened]
%           - periodVector - a vector of all periods for the spectrum
%           - dampRat - damping ratio at which to compute Sa (used 5%)
%           (associated with minPeriod, maxPeriod, and periodIncr) [used from the Sa file opened]
%           - epsilon - epsilon value from Boore-Joyner attentuation function (size
%               is length(periodVector)
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = ComputeAndSaveEpsilonFile(eqCompNum, M, Rjb, R_closest, faultType_BJ, faultType_AS, Vs, isSoilAS, HW, minPeriod, maxPeriod, periodIncr)

% Input come assumptions
dampRat = 0.05;     % Use 5% damping for Sa calculation

% Error check
if(maxPeriod > 5.0)
    error('ERROR: Neither BJF or AS work for periods over 5.0 seconds!');
end

temp = sprintf('**** Computing epsilon and saving file for record: %d', eqCompNum);
disp(temp);

% Read the file that has the dT info. for each EQ
% defineEQInfoForMATLAB

% Loop over all periods and compute the epsilon values
periodVector = minPeriod:periodIncr:maxPeriod;
numPeriods = length(periodVector);
epsilon_BJ_SaComp = zeros(numPeriods,1);
for periodIndex = 1:numPeriods
    currentPeriod = periodVector(periodIndex);
    
    % Compute the epsilon for the Sa,comp
        [currentSaCompValue] = RetrieveSaCompValueForAnEQ(eqCompNum, currentPeriod, dampRat);
        arb = 1; % for an arbitrary component
        % Boore-Joyner
            if(currentPeriod > 2.0)
                % The period is too high for the BJF function; save a NAN
                % and report a warning
                epsilon_BJ_SaComp(periodIndex) = nan;
                temp = sprintf('You tried to compute epsilon (Sa,comp) for T = %.2fs; the BJF attenuation function only goes to 2.0 seconds, so are saving a NAN!', currentPeriod);
                disp(temp);
            else
                % Compute the mean and sigma of Sa from the BJF attenutation function
                [sa_atten, sigma_atten] = BooreJoyner_Atten(M, Rjb, currentPeriod, faultType_BJ, Vs, arb);
                % Compute epsilon - from Baker's 2005 paper on vector IM with epsilon
                epsilon_BJ_SaComp(periodIndex) = (log(currentSaCompValue) - log(sa_atten)) / sigma_atten;
                clear sa_atten sigma_atten
            end
        % Abrahamson-Silva
            % Compute the mean and sigma of Sa from the BJF attenutation function
            %[sa_atten, sigma_atten] = BooreJoyner_Atten(M, Rjb, currentPeriod, faultType_BJ, Vs, arb);
            [sa_atten, sigma_atten] = Abrahamson_Atten(M, R_closest, currentPeriod, isSoilAS, faultType_AS, HW, arb);
            % Compute epsilon - from Baker's 2005 paper on vector IM with epsilon
            epsilon_AS_SaComp(periodIndex) = (log(currentSaCompValue) - log(sa_atten)) / sigma_atten;      
            clear sa_atten sigma_atten

    % Compute the epsilon for the Sa,geoMean
        % Get the EQ number (not component number)
        eqNum = floor(eqCompNum/10);
        [currentSaGeoMeanValue] = RetrieveSaGeoMeanValueForAnEQ(eqNum, currentPeriod, dampRat);
        arb = 0; % for average of two components (closer to geoMean definition)
        % Boore-Joyner
            if(currentPeriod > 2.0)
                % The period is too high for the BJF function; save a NAN
                % and report a warning
                epsilon_BJ_SaGeoMean(periodIndex) = nan;
                temp = sprintf('You tried to compute epsilon (Sa,geoMean) for T = %.2fs; the BJF attenuation function only goes to 2.0 seconds, so are saving a NAN!', currentPeriod);
                disp(temp);
            else
                % Compute the mean and sigma of Sa from the BJF attenutation function
                [sa_atten, sigma_atten] = BooreJoyner_Atten(M, Rjb, currentPeriod, faultType_BJ, Vs, arb);
                % Compute epsilon - from Baker's 2005 paper on vector IM with epsilon
                epsilon_BJ_SaGeoMean(periodIndex) = (log(currentSaGeoMeanValue) - log(sa_atten)) / sigma_atten;
                clear sa_atten sigma_atten
            end

        % Abrahamson-Silva
            % Compute the mean and sigma of Sa from the BJF attenutation function
            %[sa_atten, sigma_atten] = BooreJoyner_Atten(M, Rjb, currentPeriod, faultType_BJ, Vs, arb);
            [sa_atten, sigma_atten] = Abrahamson_Atten(M, R_closest, currentPeriod, isSoilAS, faultType_AS, HW, arb);
            % Compute epsilon - from Baker's 2005 paper on vector IM with epsilon
            epsilon_AS_SaGeoMean(periodIndex) = (log(currentSaCompValue) - log(sa_atten)) / sigma_atten;      
            clear sa_atten sigma_atten        
  
end
    
% Plot the results
    %plot(periodVector, epsilon);
    
% Go to the EQ_Spectra_Saved folder and save the results
    currentFolderPath = [pwd];
    eqSpectraFolderPath = 'C:\Users\sks\OpenSeesProcessingFiles\Epsilon_Files_Saved';
    cd(eqSpectraFolderPath)
    
	% Save results
        saveFileName = sprintf('EpsilonForRangeOfPeriod_EQ_%d.mat', eqCompNum);
        save(saveFileName, 'epsilon_BJ_SaComp', 'epsilon_BJ_SaGeoMean', 'epsilon_AS_SaComp', 'epsilon_AS_SaGeoMean', 'eqCompNum', 'eqNum', 'periodVector', 'dampRat', 'M', 'Rjb', 'R_closest', 'Vs', 'isSoilAS', 'faultType_BJ', 'faultType_AS', 'HW')
    
% Go back to the original folder
cd(currentFolderPath);

disp('Saved and done for this EQ.')
