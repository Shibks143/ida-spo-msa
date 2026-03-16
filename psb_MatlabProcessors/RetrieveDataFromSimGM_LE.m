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
    temp = sprintf('EQNum: %d', eqNumBothComp);
    disp(temp);
    temp = sprintf('EQCompNum: %d', eqCompNum);
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

        % Find if the building is collapse for this run - loop though all stories and compare drift to collapse drift
        isCollapsed = 0;
        for storyNum = 1:4
            if(storyDriftRatioToSave{storyNum}.AbsMax > collapseDriftLevel)
                isCollapsed = 1;
            end
        end
        
        
    
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
                S{strModelSimID}.isConvForFullEQ = isConv;
                S{strModelSimID}.isCollapsed = isCollapsed;


            % Write information for structure E...This doesn't write a new record each time, but only for each record
                E{eqRecordTableIndex}.EID    = eqRecordTableIndex;
                E{eqRecordTableIndex}.RID    = eqNumBothComp;        
                E{eqRecordTableIndex}.RCompXID    = eqNumBothComp * 10 + 1;         % ADDED for GeoMean Analysis     
                E{eqRecordTableIndex}.RCompYID    = eqNumBothComp * 10 + 2;         % ADDED for GeoMean Analysis
                E{eqRecordTableIndex}.RecX   = EQLIST{eqNumBothComp * 10 + 1}.File;
                E{eqRecordTableIndex}.RecY   = EQLIST{eqNumBothComp * 10 + 2}.File; % ADDED for GeoMean Analysis
                E{eqRecordTableIndex}.VID    = V{variantNum}.VID;
                E{eqRecordTableIndex}.S      = S{strModelSimID}.S;
                E{eqRecordTableIndex}.T1     = V{variantNum}.T1;
                E{eqRecordTableIndex}.b      = V{variantNum}.b;
                E{eqRecordTableIndex}.Scale  = scaleFactorForRun;
                E{eqRecordTableIndex}.Sa     = saValue;
                E{eqRecordTableIndex}.SAID   = saINDEX;
                %E{eqRecordTableIndex}.isConvForFullEQ = isConv;
                %E{eqRecordTableIndex}.isCollapsed = isCollapsed;

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
                        Z{simAndEDPID}.EID      = E{eqRecordTableIndex}.EID; 
                        Z{simAndEDPID}.ECompID  = eqCompID; 
                        Z{simAndEDPID}.SAID     = E{eqRecordTableIndex}.SAID;  
                        Z{simAndEDPID}.Sa       = E{eqRecordTableIndex}.Sa; 
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
                            Z{simAndEDPID}.EID      = E{eqRecordTableIndex}.EID; 
                            Z{simAndEDPID}.ECompID  = eqCompID; 
                            Z{simAndEDPID}.SAID     = E{eqRecordTableIndex}.SAID;  
                            Z{simAndEDPID}.Sa       = E{eqRecordTableIndex}.Sa; 
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
                    numElements = 36;
                    for eleNum = 1:numElements
                        % Loop for each element end number.  Find the highest PADI for both ends and report this as the value for the element PADI
                        maxPHRForCurrentEle = 0;
                

                        % Load the data for the maximum PHR for this element
                            maxPHRForCurrentEle = absMaxPHRToSave{eleNum}.fullElement;

                

                        %%%%%% COMPUTE PADI - this uses the ultimate PHR defined in the file that was sourced in.
                            currentPADI = maxPHRForCurrentEle / elementPHRCapacity{eleNum};
                        %%%%%% 


                
                        % Input all of the information needed for table Z for this floor accel EDP
                        Z{simAndEDPID}.ZID      = simAndEDPID;  
                        Z{simAndEDPID}.VID      = V{variantNum}.VID;  
                        Z{simAndEDPID}.SID      = S{strModelSimID}.SID;  
                        Z{simAndEDPID}.EID      = E{eqRecordTableIndex}.EID;  
                        Z{simAndEDPID}.ECompID  = eqCompID; 
                        Z{simAndEDPID}.SAID     = E{eqRecordTableIndex}.SAID;  
                        Z{simAndEDPID}.Sa       = E{eqRecordTableIndex}.Sa; 
                        currentEDPName = sprintf('PADI%d', eleNum);
                        Z{simAndEDPID}.EDPname  = currentEDPName;  
                        Z{simAndEDPID}.EDPID    = EDPID;  
                        Z{simAndEDPID}.Z        = 0.0; %currentPADI;    % MADE zero b/c it's LINEAR ELASTIC!
                        disp('Elastic Model - Putting PADI = 0.0!');
                
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



