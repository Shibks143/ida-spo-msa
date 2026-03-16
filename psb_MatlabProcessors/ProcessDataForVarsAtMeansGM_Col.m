%
% Procedure: ProcessDataForVarsAtMeans_Collapse.m
% -------------------
% This procedure processes the data for when the variables are set tho thier mean values.  THis is almost the same as what is done for other
%   variables, but is a bit different because of a few details such as the "AllVarMean" not being evaluated at two values, etc.  
%   Modified from ProcessDataForVarsAtMeans.m for the collapse results.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-16-04
% Updated 2-8-05
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions: not done
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5





disp('############# PROCESSING STARTED FOR MEAN VALUES ######################')


% Create the name of the folder that we need to go into (this will be used when "RetrieveDataFromSim" is called.
    modelFolderName = sprintf('(%s)_(AllVar)_(0.00)_(%s)', V{variantNum}.modelName, V{variantNum}.eleName);
    disp('Got past here');

% Loop and get all of the data...


        % Note that we don't loop for Sa level, b/c it's a collapse analysis - I am only reporting the collapse point!
        
                    % Loop through all EQs for this variant
                    for eqINDEX = 1:length(eqNumberCollapseMeanLIST{variantINDEX})
                        disp('############# NEW EQ for collapse ######################')

                        %%%%%%%%%%%%%%%%%%%%%%%
                        % Component - Note that for collapse we are just using one component, so we dont need to adjust the numbering
                            % OLD
%                               saValue = saTOneForStripesLIST(saINDEX);
%                               eqNumBothComp = eqNumForCurrentStripeLIST(eqINDEX);
%                               eqCompID = 1;
%                               eqCompNum = eqNumBothComp * 10 + eqCompID;

%                         eqCompNum = eqNumberCollapseMeanLIST{variantINDEX}(eqINDEX);
%                         eqCompID = mod(eqCompNum, 10);
                        eqNumChosenComp = eqNumberCollapseMeanLIST{variantINDEX}(eqINDEX);     % Get the number that I used to describ the EQ (both components)
                        
                        
                        % Go into the Sa folder
                            % Create folder name
%                             saFolderName = sprintf('Sa_%.2f', saValue);

                        % Create the EQ folder name
                            % Create folder name
                            %eqFolderName = sprintf('EQ_%d', eqCompNum);

                        % Get the data for this Variant/Variable/EQ/SaLevel - source in the procedure
                            % Input some random stuff so that there are no errors when calling the procedure
                            variableNum = 99;
                            variableValue = -1;

                            % Call the proc.
                            RetrieveDataFromSimGM_Col_Sens

                        % TO DO - Get other data regarding collapse - have OpenSees make a file of the Sa's used for runs to find collapse, and used this to load the data here.

                        % Update the ID counters
                        strModelSimID = strModelSimID + 1;
                        simIDWithinVID = simIDWithinVID + 1;
                            %   eqRecordTableIndex = eqRecordTableIndex + 1; % Don't increment until after processing is done for both components of this record
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                         %%%%%%%%%%%%%%%%%%%%%%%
%                         % Component Two
%                         saValue = saTOneForStripesLIST(saINDEX);
%                         eqNumBothComp = eqNumForCurrentStripeLIST(eqINDEX);
%                         
%                         eqCompID = 2;
%                         eqCompNum = eqNumBothComp * 10 + eqCompID;
%                 
%                         % Go into the Sa folder
%                             % Create folder name
%                             saFolderName = sprintf('Sa_%.2f', saValue);
% 
%                         % Create the EQ folder name
%                             % Create folder name
%                             eqFolderName = sprintf('EQ_%d', eqCompNum);
% 
%                         % Get the data for this Variant/Variable/EQ/SaLevel - source in the procedure
%                             % Input some random stuff so that there are no errors when calling the procedure
%                             variableNum = 99;
%                             variableValue = -1;
% 
%                             % Call the proc.
%                             RetrieveDataFromSimGM
% 
%                         % TO DO - Get other data regarding collapse - have OpenSees make a file of the Sa's used for runs to find collapse, and used this to load the data here.
% 
%                         % Update the ID counters
%                         strModelSimID = strModelSimID + 1;
%                         simIDWithinVID = simIDWithinVID + 1;
%                         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        
                        % Increment the EQID
                        eqRecordTableIndex = eqRecordTableIndex + 1;
                    
                end;    % For EQ




disp('############# PROCESSING COMPLETED FOR MEAN VALUES ######################')







