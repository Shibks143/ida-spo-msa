%
% Procedure: RetrieveAndStoreDataForRun.m
% -------------------
% This procedure is called by "CreateFileForCalTech.m" and stores the data into the correct structures, for the current analysis.  This file retrieves and stores (does
%   now or it will when it is completed) the PADIm for all elements, the PDAn for all floors, and the PTDna for all floors and column lines.
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% Go into the folder
    cd(baseFolder);
    cd Output;
    cd(modelFolderName);
    cd(eqFolderName);
    cd(saFolderName);
    
% Load the data file for this current run
    load('DATA_reducedSensDataForThisSingleRun.mat');   % Just the REDUCED sensitivity data (to reduce the data size and runtime).
    
% Display current processing
    disp('CURRENT ANALYSIS INFORMATION - ')
%     temp = sprintf('Analysis Type: %s', analysisType);
% %     disp('Analysis Type:')
%     disp(temp);
    temp = sprintf('VariantNum: %d', variantNum);
%     disp(variantNum)
    disp(temp);
    temp = sprintf('VariableNum: %d', variableNum);
%     disp(variantNum)
    disp(temp);
    temp = sprintf('VariableValue: %.2f', variableValue);
%     disp('VariableValue:')
    disp(temp);
%     disp('EQNum:')
%     disp(eqNum)
    temp = sprintf('EQNum: %d', eqNum);
    disp(temp);
%     disp('SaValue:')
%     disp(saValue)
    temp = sprintf('SaValue: %.2f', saValue);
    disp(temp);

    
% Save the data from this run, ONLY if it's fully converged or the analysisOption defined in the "CreateFileForCalTech.m" file says to allow non-conv. results.
    % Find if it's converged or not
    isConv = isCurrentAnalysisConv;     

    % If the analysis is fully converged or the analysisOptions say to save the non-conv results anyways, then save the results
    if((isConv == 1) | (includeNonConvResults == 1))
        disp('Current results were saved!');

    
    
        % Write all of the needed data to the structures that are defined in "CreateFileForCalTech.m"
        %   Some of the data are from the file that 

            % Write information for structure S...
                S{strModelSimID}.SID        = strModelSimID;
                S{strModelSimID}.VID        = V{variantNum}.VID;
                S{strModelSimID}.S          = simIDWithinVID;
                S{strModelSimID}.Variable   = VariableLIST{variableNum}.Variable;
                S{strModelSimID}.Definition = VariableLIST{variableNum}.Definition;
                S{strModelSimID}.Units      = VariableLIST{variableNum}.Units;
                S{strModelSimID}.Value      = variableValue;

            % Write information for structure E...
                E{strModelSimID}.EID    = strModelSimID;
                E{strModelSimID}.RID    = eqNum;        
                E{strModelSimID}.RecX   = EQLIST{eqNum}.File;
                E{strModelSimID}.RecY   = '';   % Only 2D analyses - don't need
                E{strModelSimID}.VID    = V{variantNum}.VID;
                E{strModelSimID}.S      = S{strModelSimID}.S;
                E{strModelSimID}.T1     = V{variantNum}.T1;
                E{strModelSimID}.b      = V{variantNum}.b;
                E{strModelSimID}.Scale  = scaleFactorForRun;
                E{strModelSimID}.Sa     = saValue;
                E{strModelSimID}.SAID   = saINDEX;
                E{strModelSimID}.isConvForFullEQ = isConv;

            % Write information for structure Z... 
                % Initialize the EDPID number (Z{#}.EDPID)
                    EDPID = 1;
            
    
                % Write acceleration information for each floor 
                    g = 386.4;  % in/s^2 - to convert results from in/s^2 to g units
                    for floorNum = 2:5
                        % Input all of the information needed for table Z for this floor accel EDP
                        Z{simAndEDPID}.ZID      = simAndEDPID;  
                        Z{simAndEDPID}.VID      = V{variantNum}.VID;  
                        Z{simAndEDPID}.SID      = S{strModelSimID}.SID;  
                        Z{simAndEDPID}.EID      = E{strModelSimID}.EID;  
                        Z{simAndEDPID}.SAID     = E{strModelSimID}.SAID;  
                        Z{simAndEDPID}.Sa       = E{strModelSimID}.Sa; 
                        currentEDPName = sprintf('PDA%d', floorNum);
                        Z{simAndEDPID}.EDPname  = currentEDPName;  
                        Z{simAndEDPID}.EDPID    = EDPID;  
                        Z{simAndEDPID}.Z        = floorAccelToSave{floorNum}.absAbsMaxUnfiltered / g;   % CHANGED to unfiltered on 10-6-04!
                                
                        % Also create a structure that keeps track of the relationship of EDPID and EDPname - note that this is repeditively defined each time this proc is called, but easier to do here.
                        EDPLIST{EDPID}.Number   = EDPID;
                        EDPLIST{EDPID}.Name     = currentEDPName;
            
                        % Update the indices
                        simAndEDPID = simAndEDPID + 1;
                        EDPID = EDPID + 1;
                    end
    
                % Write drift information for each story 
                    for storyNum = 1:4
                        % Loop for column lines.  Notice that we are using column line 1-5, but putting the same data for each column line (assuming that the floors are rigid);
                        %   Note that I can give explicit information about drifts of each column line, but it doesn't seem like it's important. 
                        for colLineNum = 1:5
                            % Input all of the information needed for table Z for this floor accel EDP
                            Z{simAndEDPID}.ZID      = simAndEDPID;  
                            Z{simAndEDPID}.VID      = V{variantNum}.VID;  
                            Z{simAndEDPID}.SID      = S{strModelSimID}.SID;  
                            Z{simAndEDPID}.EID      = E{strModelSimID}.EID;  
                            Z{simAndEDPID}.SAID     = E{strModelSimID}.SAID;  
                            Z{simAndEDPID}.Sa       = E{strModelSimID}.Sa; 
                            currentEDPName = sprintf('PTD%d%d', storyNum, colLineNum);
                            Z{simAndEDPID}.EDPname  = currentEDPName;  
                            Z{simAndEDPID}.EDPID    = EDPID;  
                            Z{simAndEDPID}.Z        = storyDriftRatioToSave{storyNum}.AbsMax; 
                
                            % Also create a structure that keeps track of the relationship of EDPID and EDPname - note that this is repeditively defined each time this proc is called, but easier to do here.
                            EDPLIST{EDPID}.Number   = EDPID;
                            EDPLIST{EDPID}.Name     = currentEDPName;
            
                            % Update the indices
                            simAndEDPID = simAndEDPID + 1;
                            EDPID = EDPID + 1;
                        end
                    end
    
    
                % Write PADI information for each element 
                %   - NOTICE THAT THIS WILL NEED TO BE ALTERED TO COMPUTE THE PADI AND WILL NEED TO BE ALTERED TO WORK FOR OTHER MODELS (NOT JUST HYSTHINGE, which it is now for)
                    
                    % To correct the problem with the PHR's due to the splice location error, list what element numbers to use for the PHR's for the elements (a way of
                    %   fudging the numbers to make the PHR's be nearly what they should be based on the analysis results with the fixed model (v.51FixSplice).

                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Define the element numbers to use for the models that have the splice location error
                            % Columns - story 1
                            eleNumToUseForPHR(1) = 1;
                            eleNumToUseForPHR(2) = 1;
                            eleNumToUseForPHR(3) = 1;
                            eleNumToUseForPHR(4) = 1;
                            eleNumToUseForPHR(5) = 1;
                            % Columns - story 2
                            eleNumToUseForPHR(10) = 14;
                            eleNumToUseForPHR(11) = 14;
                            eleNumToUseForPHR(12) = 14;
                            eleNumToUseForPHR(13) = 14;
                            eleNumToUseForPHR(14) = 14;
                            % Columns - story 3
                            eleNumToUseForPHR(19) = 20;
                            eleNumToUseForPHR(20) = 20;
                            eleNumToUseForPHR(21) = 20;
                            eleNumToUseForPHR(22) = 20;
                            eleNumToUseForPHR(23) = 20;
                            % Columns - story 4
                            eleNumToUseForPHR(28) = 32;
                            eleNumToUseForPHR(29) = 32;
                            eleNumToUseForPHR(30) = 32;
                            eleNumToUseForPHR(31) = 32;
                            eleNumToUseForPHR(32) = 32;
                            % Beams - floor 2
                            eleNumToUseForPHR(6) = 9;
                            eleNumToUseForPHR(7) = 9;
                            eleNumToUseForPHR(8) = 9;
                            eleNumToUseForPHR(9) = 9;
                            % Beams - floor 3
                            eleNumToUseForPHR(15) = 18;
                            eleNumToUseForPHR(16) = 18;
                            eleNumToUseForPHR(17) = 18;
                            eleNumToUseForPHR(18) = 18;
                            % Beams - floor 4
                            eleNumToUseForPHR(24) = 24;
                            eleNumToUseForPHR(25) = 24;
                            eleNumToUseForPHR(26) = 24;
                            eleNumToUseForPHR(27) = 24;
                            % Beams - floor 5
                            eleNumToUseForPHR(33) = 36;                  
                            eleNumToUseForPHR(34) = 36;  
                            eleNumToUseForPHR(35) = 36;  
                            eleNumToUseForPHR(36) = 36;  
                            
                        % Define factors to multiply the PHR at the element being used approximate the PHR that should be in the element.  Please
                        %   see hand notes on 10-11-04 for these calclations (they are based on the 0.82g level).  These are only used when the splice 
                        %   error was in the model and alterations are made to account for this error.
                            % Columns - story 1
                            scaleFactorForElePHR(1) = 1.09;
                            scaleFactorForElePHR(2) = 0.83;
                            scaleFactorForElePHR(3) = 0.83;
                            scaleFactorForElePHR(4) = 0.83;
                            scaleFactorForElePHR(5) = 1.09;
                            % Columns - story 2
                            scaleFactorForElePHR(10) = 0.96;
                            scaleFactorForElePHR(11) = 0.96;
                            scaleFactorForElePHR(12) = 0.96;
                            scaleFactorForElePHR(13) = 0.96;
                            scaleFactorForElePHR(14) = 0.96;
                            % Columns - story 3
                            scaleFactorForElePHR(19) = 0.85;
                            scaleFactorForElePHR(20) = 0.96;
                            scaleFactorForElePHR(21) = 0.96;
                            scaleFactorForElePHR(22) = 0.96;
                            scaleFactorForElePHR(23) = 0.85;
                            % Columns - story 4
                            scaleFactorForElePHR(28) = 0.83;
                            scaleFactorForElePHR(29) = 1.00;
                            scaleFactorForElePHR(30) = 1.00;
                            scaleFactorForElePHR(31) = 1.00;
                            scaleFactorForElePHR(32) = 0.83;
                            % Beams - floor 2
                            scaleFactorForElePHR(6) = 1.14;
                            scaleFactorForElePHR(7) = 0.94;
                            scaleFactorForElePHR(8) = 0.94;
                            scaleFactorForElePHR(9) = 1.14;
                            % Beams - floor 3
                            scaleFactorForElePHR(15) = 1.09;
                            scaleFactorForElePHR(16) = 0.96;
                            scaleFactorForElePHR(17) = 0.96;
                            scaleFactorForElePHR(18) = 1.09;
                            % Beams - floor 4
                            scaleFactorForElePHR(24) = 0.97;
                            scaleFactorForElePHR(25) = 0.83;
                            scaleFactorForElePHR(26) = 0.83;
                            scaleFactorForElePHR(27) = 0.97;
                            % Beams - floor 5
                            scaleFactorForElePHR(33) = 0.33;
                            scaleFactorForElePHR(34) = 0.30;
                            scaleFactorForElePHR(35) = 0.30;
                            scaleFactorForElePHR(36) = 0.33;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        
                
                    numElements = 36;
                    for eleNum = 1:numElements
                        % Loop for each element end number.  Find the highest PADI for both ends and report this as the value for the element PADI
                        maxPHRForCurrentEle = 0;
                

                        % Load the data for the maximum PHR for this element
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            % If this is a Variant that has the splice location error, then alter then use the element numbers
                            %   defined above for the PHR for the current element.  If this is not a variant with the splice error, then
                            %   just use the element for it's own PHR (i.e. don't alter anything).  Note that variants 1,3 and 4 have the
                            %   splice error and variant 2 does not have the error b/c it's 
                                if ((variantNum == 1))
                                    % The splice error DOES exist in these models, so alter the element to use for the PHR
                                     maxPHRForCurrentEle = absMaxPHRToSave{eleNumToUseForPHR(eleNum)}.fullElement * scaleFactorForElePHR(eleNum);
                                elseif ((variantNum == 2) | (variantNum == 3) | (variantNum == 4))
                                    % The splice error DOES NOT exist in these models, so don't alter the element number to use
                                     maxPHRForCurrentEle = absMaxPHRToSave{eleNum}.fullElement;  
                                else
                                    % Say that there is an error, b/c I have not included some variant that is being used
                                    error('Error: Variant being used is not in possible variants (for potentially correcting the error from splices)');
                                end

                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                

                        %%%%%% COMPUTE PADI - this uses the ultimate PHR defined in the file that was sourced in.
                            currentPADI = maxPHRForCurrentEle / elementPHRCapacity{eleNum};
                        %%%%%% 


                
                        % Input all of the information needed for table Z for this floor accel EDP
                        Z{simAndEDPID}.ZID      = simAndEDPID;  
                        Z{simAndEDPID}.VID      = V{variantNum}.VID;  
                        Z{simAndEDPID}.SID      = S{strModelSimID}.SID;  
                        Z{simAndEDPID}.EID      = E{strModelSimID}.EID;  
                        Z{simAndEDPID}.SAID     = E{strModelSimID}.SAID;  
                        Z{simAndEDPID}.Sa       = E{strModelSimID}.Sa; 
                        currentEDPName = sprintf('PADI%d', eleNum);
                        Z{simAndEDPID}.EDPname  = currentEDPName;  
                        Z{simAndEDPID}.EDPID    = EDPID;  
                        Z{simAndEDPID}.Z        = currentPADI; 
                
                        % Also create a structure that keeps track of the relationship of EDPID and EDPname - note that this is repeditively defined each time this proc is called, but easier to do here.
                        EDPLIST{EDPID}.Number   = EDPID;
                        EDPLIST{EDPID}.Name     = currentEDPName;
            
                        % Update the indices
                        simAndEDPID = simAndEDPID + 1;
                        EDPID = EDPID + 1;
                    end
    

            
    else 
        disp('Current results were NOT saved!  Non-Conv!!');
    end
            
            
            

% Delete all of the variables from the data file that was previously opened - NOTE - probably add more to this list later
clear 'analysisType' 'saFolder' 'eqFolder' 'filePrefix' 'eigenValues' 'fundamentalPeriod' 'nodeNumsAtEachFloorLIST'... 
        'nodeNumToRecordLIST' 'elementNumToRecordLIST' 'numNodes' 'poControlNodeNum' 'floorHeightsLIST'...
        'columnNumsAtBaseLIST' 'eigenvaluesAfterEQ' 'minutesToRunThisAnalysis' 'scaleFactorForRun' 'usedNormDisplIncr' 'nodeArray'...
        'psuedoTimeVector' 'elementArray' 'storyDriftRatio' 'floorAccel' 'baseShear' 'numIntPointsDispEle'...
        'numIntPointsForceEle' 'dtForAnalysisLIST' 'defineHystHingeRecorders' 'defineElementEndSectionRecorders' 'hingeElementsToRecordLIST'...
        'maxRotation' 'hingeWithMaxRotation' 'maxConvergedTime' 'isCurrentAnalysisConv' 'isConvForFullEQ' 'absMaxPHRToSave'... 
        'floorAccelToSave' 'storyDriftRatioToSave' 'maxConvergedTime' 'eqTimeLength' 'maxColPHR' 'maxBmPHR' 'colWithMaxPHR'...
        'bmWithMaxPHR' 'eqNum' 'scaleFactorForRun' 'saValue' 'isCurrentAnalysisConv' 'maxTolUsed';



% Go back to the main folder
cd(baseFolder)



