%
% Procedure: ComputeAndSaveEpsilonFiles.m
% -------------------
% This procedure computes the Epsilon values over the range of period and
% then saves the file.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 3-13-06
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
%           - eqCompNum - the index number of this record
%           - minPeriod - min. period for spectrum
%           - maxPeriod - max. period for spectrum
%           - periodIncr - increment step size for period
%           - periodVector - a vector of all periods for the spectrum
%           (associated with minPeriod, maxPeriod, and periodIncr)
%           - epsilon - epsilon value from Boore-Joyner attentuation function (size
%               is length(periodVector)
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
function[void] = ComputeAndSaveOnlySaSpectrum(eqCompNum, minPeriod, maxPeriod, periodIncr, dampRatioLIST, indexForFivePercentDamping, dT)

tic
temp = sprintf('**** Computing spectrum for record: %d', eqCompNum);

% Read the file that has the dT info. for each EQ
%defineEQInfoForMATLAB

% Save the current folder location; to get back later
    currentFolderPath = [pwd];
    
% Go to Sorted_Eq_Files folder to get file (folder location is hard-coded)
    eqSpectraFolderPath = 'C:\Users\sks\OpenSeesProcessingFiles\EQs';
    cd(eqSpectraFolderPath)

% Simply call the function for all the time steps
    % Create the file name and open the TH file (must be in the same folder)
    accelTHFile = sprintf('SortedEQFile_(%d).txt', eqCompNum);
    accelTH = load(accelTHFile);
    
% Added on 6-28-07 to go back to original folder (so you do not need the
% path set to the MatlabProcessors folder)
    cd(currentFolderPath)
    
    % Make the time vector
    %dT = dtForEQRecord(eqCompNum);
    timeVector = [0:dT:length(accelTH)];
    
    % Make a vector of period for which to compute the response
    periodVector = [minPeriod:periodIncr:maxPeriod];
    
    % Loop through and compute the spectrum
        % Initialize vectors
        %SdRel = zeros(length(periodVector), length(dampRatioLIST));
        %SvRel = zeros(length(periodVector), length(dampRatioLIST));
        SaAbs = zeros(length(periodVector), length(dampRatioLIST));
        %PSaAbs = zeros(length(periodVector), length(dampRatioLIST));
        
disp('**** Starting period loop...')
        
    % Loop for all periods
    for periodNum = 1:length(periodVector)
        currentPeriod = periodVector(periodNum);
        
        % Loop for all damping ratios
        for dampRatioNum = 1:length(dampRatioLIST)
            currentDampRatio = dampRatioLIST(dampRatioNum);
            
            % Use function to compute reposponse
                [SaAbs(periodNum, dampRatioNum)] = elastic_Sa(currentPeriod, currentDampRatio, accelTH, dT);
                % OLD FUNCTION WITH BUG - [SdRel(periodNum, dampRatioNum), SvRel(periodNum, dampRatioNum), SaAbs(periodNum, dampRatioNum), PSaAbs(periodNum, dampRatioNum)] = ComputeAllResponsesNewmark(accelTH, timeVector, dT, currentPeriod, currentDampRatio);
        end
    end
    
disp('**** Finished period loop, starting to save and finish...')

    
% Plot the results
    %plot(periodVector, SaAbs);
    
% Go to Sorted_EQ Spectra folder to get file (folder location is hard-coded)
    eqSpectraFolderPath = 'C:\Users\sks\OpenSeesProcessingFiles\EQ_Spectra_Saved';
    cd(eqSpectraFolderPath)
    
%     % Save all results
%         saveFileName = sprintf('FullEQSpectrum_EQ_%d.mat', eqCompNum);
%         save(saveFileName, 'SdRel', 'SvRel', 'SaAbs', 'PSaAbs', 'eqCompNum', 'minPeriod', 'maxPeriod', 'periodIncr', 'periodVector', 'dampRatioLIST')
    
    % Save all results - i.e. Sa at all levels of damping
        saveFileName = sprintf('SaEQSpectrum_EQ_%d.mat', eqCompNum);
        save(saveFileName, 'SaAbs', 'eqCompNum', 'minPeriod', 'maxPeriod', 'periodIncr', 'periodVector', 'dampRatioLIST')
    
    % Save another file with only the Sa results for 5% damping
%         SaAbsAtFivePercentDamping = SaAbs(:, indexForFivePercentDamping);
%         dampingRatio = dampRatioLIST(indexForFivePercentDamping);   % Just for redundency; in case I made a mistake
%         saveFileName = sprintf('SaEQSpectrum_FivePercentDamp_EQ_%d.mat', eqCompNum);
%         save(saveFileName, 'SaAbsAtFivePercentDamping', 'eqCompNum', 'minPeriod', 'maxPeriod', 'periodIncr', 'periodVector', 'dampingRatio')    
    
% Go back to the initial folder
cd(currentFolderPath);

disp('**** All saved and DONE!')

clear
toc









