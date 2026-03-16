%
% Procedure: ProcessDataForVarsAtMeans.m
% -------------------
% This procedure processes the data for when the variables are set tho thier mean values.  THis is almost the same as what is done for other
%   variables, but is a bit different because of a few details such as the "AllVarMean" not being evaluated at two values, etc.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-16-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: not done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5





disp('############# PROCESSING STARTED FOR MEAN VALUES ######################')


% Create the name of the folder that we need to go into (this will be used when "RetrieveDataFromSim" is called.
%   Changed on 2-16-06 so that i can define variants
%   based on some sensitivty analyses.
    %modelFolderName = sprintf('(%s)_(%s)_(%.2f)_(%s)', V{variantNum}.modelName, VariableLIST{variableNum}.Variable, variableValue, V{variantNum}.eleName);
    modelFolderName = V{variantNum}.outputFolderName;

% Loop and get all of the data...

                % Loop through all of the EQ's
                eqRecordTableIndex = 1; % Reinitialize each time we loop through EQs again
                for saINDEX = 1:length(saTOneForStripesLIST)
                    disp('############# NEW EQ ######################')
                    eqNumForCurrentStripeLIST = eqNumberAllStripesLISTGeoMean{saINDEX};
            

            
                    % Loop through Sa levels to get stripe data
                    for eqINDEX = 1:length(eqNumForCurrentStripeLIST)
                        disp('############# NEW Sa LEVEL ######################')

                        %%%%%%%%%%%%%%%%%%%%%%%
                        % Component One
                        saValue = saTOneForStripesLIST(saINDEX);
                        eqNumBothComp = eqNumForCurrentStripeLIST(eqINDEX);
                        
                        eqCompID = 1;
                        eqCompNum = eqNumBothComp * 10 + eqCompID;
                
                        % Go into the Sa folder
                            % Create folder name
                            saFolderName = sprintf('Sa_%.2f', saValue);

                        % Create the EQ folder name
                            % Create folder name
                            eqFolderName = sprintf('EQ_%d', eqCompNum);

                        % Get the data for this Variant/Variable/EQ/SaLevel - source in the procedure
                            % Input some random stuff so that there are no errors when calling the procedure
                            variableNum = 99;
                            variableValue = -1;

                            % Call the proc.
                            RetrieveDataFromSimGM

                        % TO DO - Get other data regarding collapse - have OpenSees make a file of the Sa's used for runs to find collapse, and used this to load the data here.

                        % Update the ID counters
                        strModelSimID = strModelSimID + 1;
                        simIDWithinVID = simIDWithinVID + 1;
                            %   eqRecordTableIndex = eqRecordTableIndex + 1; % Don't increment until after processing is done for both components of this record
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        %%%%%%%%%%%%%%%%%%%%%%%
                        % Component Two
                        saValue = saTOneForStripesLIST(saINDEX);
                        eqNumBothComp = eqNumForCurrentStripeLIST(eqINDEX);
                        
                        eqCompID = 2;
                        eqCompNum = eqNumBothComp * 10 + eqCompID;
                
                        % Go into the Sa folder
                            % Create folder name
                            saFolderName = sprintf('Sa_%.2f', saValue);

                        % Create the EQ folder name
                            % Create folder name
                            eqFolderName = sprintf('EQ_%d', eqCompNum);

                        % Get the data for this Variant/Variable/EQ/SaLevel - source in the procedure
                            % Input some random stuff so that there are no errors when calling the procedure
                            variableNum = 99;
                            variableValue = -1;

                            % Call the proc.
                            RetrieveDataFromSimGM

                        % TO DO - Get other data regarding collapse - have OpenSees make a file of the Sa's used for runs to find collapse, and used this to load the data here.

                        % Update the ID counters
                        strModelSimID = strModelSimID + 1;
                        simIDWithinVID = simIDWithinVID + 1;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        
                        % Increment the EQID
                        eqRecordTableIndex = eqRecordTableIndex + 1;
                        
                
                    end;    % For Sa
                    
                end;    % For EQ




disp('############# PROCESSING COMPLETED FOR MEAN VALUES ######################')







