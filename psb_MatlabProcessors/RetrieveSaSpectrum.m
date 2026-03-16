%
% Procedure: RetrieveSaSpectrum.m
% -------------------
% This function returns the 5% damped spectrum and the period vector.
%
% Author: Curt Haselton 
% Date Written: 6-28-07
%
% Units: g, seconds
%
% -------------------
function[periodVector, saVector] = RetrieveSaSpectrum(eqCompNumber, dampingRatio)

    % Save the current folder location; to get back later
        currentFolderPath = [pwd];
    
    % Go to Sorted_Eq_Files folder to get file (folder location is hard-coded)
        eqSpectraFolderPath = 'C:\Users\sks\OpenSeesProcessingFiles\EQ_Spectra_Saved';
        cd(eqSpectraFolderPath)
        
    % Open the saved spectrum file
        fileName = sprintf('SaEQSpectrum_EQ_%d.mat', eqCompNumber);
        load(fileName);
            
        % Look through the damping ratio list and find the index that has
        %   the damping ratio that we want to plot.  If the damping ratio
        %   is not there, report an error!
            colIndexOfDampRatToPlot = -1;   % Initialize to a value to indicate an error if veriable is not redefined in loop
            for i = 1:length(dampRatioLIST)
               if(dampRatioLIST(i) == dampingRatio)
                   colIndexOfDampRatToPlot = i;
                   break;
               end
            end
            
            % Check to be sure we found the damping ratio value and report
            % an error if it was not found
                if(colIndexOfDampRatToPlot == -1)
                  error('The damping ratio that you want to plot can not be found in the spectrum file!') 
                end
            
        % Retrieve the acceleration spectrum for this damping ratio and
        %   scale it by the scale factor
            periodVector;
            saVector = SaAbs(:, colIndexOfDampRatToPlot);
   