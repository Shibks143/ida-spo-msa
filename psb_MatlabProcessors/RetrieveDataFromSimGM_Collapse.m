%
% Procedure: RetrieveAndStoreDataForRun_Collapse.m
% -------------------
% This procedure is called by "CreateFileForCalTech.m" and stores the data into the correct structures, for the current analysis.  This file retrieves and stores (does
%   now or it will when it is completed) the PADIm for all elements, the PDAn for all floors, and the PTDna for all floors and column lines.  This is the same as 
%   RetrieveAndStoreDataForRun.m, but was altered to retrieve the collapse data.
% 
% Assumptions and Notices: 
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-16-04
% Updated: 2-8-05
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
%     cd(eqFolderName);
    %cd(saFolderName);
    
% Load the data file for this current run
%     load('DATA_CollapseResultsForThisSingleEQ.mat');   % Just the collapse file that was made when we ran the collapse algorithm.
    load('DATA_collapse_CollapseSaAndStats.mat');   % This is the collapse file that was made by the collapse IDA plotter.  On 3-14-05, 
                                                        %   I fixed the collapse Sa level to be based on the actual output data rather than on the 
                                                        %   collapse algorithm.
    
% Retrieve the collapse Sa level for this component number (from the opened file)
      % Search through the eqNumber list, find the correct Eq number and then save the associated Sa collapse (for the controlling component)
      foundEQInList = 0;
      collapseSaLevel = -1;
      for colInd = 1:length(eqNumberLIST)
        tempEQNumInLIST = eqNumberLIST(colInd);
        if(tempEQNumInLIST == eqNumBothComp)
            collapseSaLevel = collapseLevelForAllControlComp(colInd);
            foundEQInList = 1;
        end
      end
           
      % Check to be sure it found the EQ in the list; if not give an error
      if(foundEQInList == 1)
          % ok - do nothing
      else
          error('We could not find the EQ in the collapse list.  Maybe you did not process the collapse data right when plotting the IDA (i.e. the wrong records numbers used?)')
      end
                                                        
                                                        

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
%     temp = sprintf('EQCompNum: %d', eqCompNum);
%     disp(temp);
%     disp('SaValue:')
%     disp(saValue)
    temp = sprintf('SaValue for collapse: %.2f', collapseSaLevel);
    disp(temp);

    
% Save the data from this run, ONLY if it's fully converged or the analysisOption defined in the "CreateFileForCalTech.m" file says to allow non-conv. results.
    % Find if it's converged or not
    %isConv = isCurrentAnalysisConv;     

    % If the analysis is fully converged or the analysisOptions say to save the non-conv results anyways, then save the results
    %if((isConv == 1) | (includeNonConvResults == 1))
        disp('Current results are being saved!');

    
    
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
                S{strModelSimID}.isConvForFullEQ = 1;
                S{strModelSimID}.isCollapsed = 1;
                
                
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
                ComputeSaTOneGM;                                                  % This uses Newmark to compute saTOne
                E{eqRecordTableIndex}.Scale  = collapseSaLevel / saTOneGMForCurrentRecord;     
                E{eqRecordTableIndex}.Sa     = collapseSaLevel;
                E{eqRecordTableIndex}.SAID   = -1;

            % Write information for structure Z... 
                % Initialize the EDPID number (Z{#}.EDPID)
                    EDPID = 99; % Use this EDP number for collapse
            
                        Z{simAndEDPID}.ZID      = simAndEDPID;  
                        Z{simAndEDPID}.VID      = V{variantNum}.VID;  
                        Z{simAndEDPID}.SID      = S{strModelSimID}.SID;  
                        Z{simAndEDPID}.EID      = E{eqRecordTableIndex}.EID; 
                        Z{simAndEDPID}.ECompID  = -1;   % This was made to be -1 because I am not distinguishing which component caused collapse! 
                        Z{simAndEDPID}.SAID     = -1;  
                        Z{simAndEDPID}.Sa       = collapseSaLevel; 
                        currentEDPName          = 'Collapse';
                        Z{simAndEDPID}.EDPname  = currentEDPName;  
                        Z{simAndEDPID}.EDPID    = EDPID;  
                        Z{simAndEDPID}.Z        = 1;    % To show that it's collapsed
                                
                        % Also create a structure that keeps track of the relationship of EDPID and EDPname - note that this is repeditively defined each time this proc is called, but easier to do here.
                        EDPLIST{EDPID}.Number   = EDPID;
                        EDPLIST{EDPID}.Name     = currentEDPName;
                    
                        % Update the index
                        simAndEDPID = simAndEDPID + 1;

                    
                    
    
%                 % Write acceleration information for each floor 
%                     g = 386.4;  % in/s^2 - to convert results from in/s^2 to g units
%                     for floorNum = 2:5
%                         % Input all of the information needed for table Z for this floor accel EDP
%                         Z{simAndEDPID}.ZID      = simAndEDPID;  
%                         Z{simAndEDPID}.VID      = V{variantNum}.VID;  
%                         Z{simAndEDPID}.SID      = S{strModelSimID}.SID;  
%                         Z{simAndEDPID}.EID      = E{eqRecordTableIndex}.EID; 
%                         Z{simAndEDPID}.ECompID  = eqCompID; 
%                         Z{simAndEDPID}.SAID     = E{eqRecordTableIndex}.SAID;  
%                         Z{simAndEDPID}.Sa       = E{eqRecordTableIndex}.Sa; 
%                         currentEDPName = sprintf('PDA%d', floorNum);
%                         Z{simAndEDPID}.EDPname  = currentEDPName;  
%                         Z{simAndEDPID}.EDPID    = EDPID;  
%                         Z{simAndEDPID}.Z        = floorAccelToSave{floorNum}.absAbsMaxUnfiltered / g;   % CHANGED to unfiltered on 10-6-04!
%                                 
%                         % Also create a structure that keeps track of the relationship of EDPID and EDPname - note that this is repeditively defined each time this proc is called, but easier to do here.
%                         EDPLIST{EDPID}.Number   = EDPID;
%                         EDPLIST{EDPID}.Name     = currentEDPName;
%             
%                         % Update the indices
%                         simAndEDPID = simAndEDPID + 1;
%                         EDPID = EDPID + 1;
%                     end
%     
%                 % Write drift information for each story 
%                     for storyNum = 1:4
%                         % Loop for column lines.  Notice that we are using column line 1-5, but putting the same data for each column line (assuming that the floors are rigid);
%                         %   Note that I can give explicit information about drifts of each column line, but it doesn't seem like it's important. 
%                         for colLineNum = 1:5
%                             % Input all of the information needed for table Z for this floor accel EDP
%                             Z{simAndEDPID}.ZID      = simAndEDPID;  
%                             Z{simAndEDPID}.VID      = V{variantNum}.VID;  
%                             Z{simAndEDPID}.SID      = S{strModelSimID}.SID;  
%                             Z{simAndEDPID}.EID      = E{eqRecordTableIndex}.EID; 
%                             Z{simAndEDPID}.ECompID  = eqCompID; 
%                             Z{simAndEDPID}.SAID     = E{eqRecordTableIndex}.SAID;  
%                             Z{simAndEDPID}.Sa       = E{eqRecordTableIndex}.Sa; 
%                             currentEDPName = sprintf('PTD%d%d', storyNum, colLineNum);
%                             Z{simAndEDPID}.EDPname  = currentEDPName;  
%                             Z{simAndEDPID}.EDPID    = EDPID;  
%                             Z{simAndEDPID}.Z        = storyDriftRatioToSave{storyNum}.AbsMax; 
%                 
%                             % Also create a structure that keeps track of the relationship of EDPID and EDPname - note that this is repeditively defined each time this proc is called, but easier to do here.
%                             EDPLIST{EDPID}.Number   = EDPID;
%                             EDPLIST{EDPID}.Name     = currentEDPName;
%             
%                             % Update the indices
%                             simAndEDPID = simAndEDPID + 1;
%                             EDPID = EDPID + 1;
%                         end
%                     end
%     
%     
%                 % Write PADI information for each element 
%                 %   - NOTICE THAT THIS WILL NEED TO BE ALTERED TO COMPUTE THE PADI AND WILL NEED TO BE ALTERED TO WORK FOR OTHER MODELS (NOT JUST HYSTHINGE, which it is now for)
%                     numElements = 36;
%                     for eleNum = 1:numElements
%                         % Loop for each element end number.  Find the highest PADI for both ends and report this as the value for the element PADI
%                         maxPHRForCurrentEle = 0;
%                 
% 
%                         % Load the data for the maximum PHR for this element
%                             maxPHRForCurrentEle = absMaxPHRToSave{eleNum}.fullElement;
% 
%                 
% 
%                         %%%%%% COMPUTE PADI - this uses the ultimate PHR defined in the file that was sourced in.
%                             currentPADI = maxPHRForCurrentEle / elementPHRCapacity{eleNum};
%                         %%%%%% 
% 
% 
%                 
%                         % Input all of the information needed for table Z for this floor accel EDP
%                         Z{simAndEDPID}.ZID      = simAndEDPID;  
%                         Z{simAndEDPID}.VID      = V{variantNum}.VID;  
%                         Z{simAndEDPID}.SID      = S{strModelSimID}.SID;  
%                         Z{simAndEDPID}.EID      = E{eqRecordTableIndex}.EID;  
%                         Z{simAndEDPID}.ECompID  = eqCompID; 
%                         Z{simAndEDPID}.SAID     = E{eqRecordTableIndex}.SAID;  
%                         Z{simAndEDPID}.Sa       = E{eqRecordTableIndex}.Sa; 
%                         currentEDPName = sprintf('PADI%d', eleNum);
%                         Z{simAndEDPID}.EDPname  = currentEDPName;  
%                         Z{simAndEDPID}.EDPID    = EDPID;  
%                         Z{simAndEDPID}.Z        = currentPADI; 
%                 
%                         % Also create a structure that keeps track of the relationship of EDPID and EDPname - note that this is repeditively defined each time this proc is called, but easier to do here.
%                         EDPLIST{EDPID}.Number   = EDPID;
%                         EDPLIST{EDPID}.Name     = currentEDPName;
%             
%                         % Update the indices
%                         simAndEDPID = simAndEDPID + 1;
%                         EDPID = EDPID + 1;
%                     end
    

            
        %else 
        %disp('Current results were NOT saved!  Non-Conv!!');
        %end
            
            
            

% % Delete all of the variables from the data file that was previously opened - NOTE - probably add more to this list later
% clear 'analysisType' 'saFolder' 'eqFolder' 'filePrefix' 'eigenValues' 'fundamentalPeriod' 'nodeNumsAtEachFloorLIST'... 
%         'nodeNumToRecordLIST' 'elementNumToRecordLIST' 'numNodes' 'poControlNodeNum' 'floorHeightsLIST'...
%         'columnNumsAtBaseLIST' 'eigenvaluesAfterEQ' 'minutesToRunThisAnalysis' 'scaleFactorForRun' 'usedNormDisplIncr' 'nodeArray'...
%         'psuedoTimeVector' 'elementArray' 'storyDriftRatio' 'floorAccel' 'baseShear' 'numIntPointsDispEle'...
%         'numIntPointsForceEle' 'dtForAnalysisLIST' 'defineHystHingeRecorders' 'defineElementEndSectionRecorders' 'hingeElementsToRecordLIST'...
%         'maxRotation' 'hingeWithMaxRotation' 'maxConvergedTime' 'isCurrentAnalysisConv' 'isConvForFullEQ' 'absMaxPHRToSave'... 
%         'floorAccelToSave' 'storyDriftRatioToSave' 'maxConvergedTime' 'eqTimeLength' 'maxColPHR' 'maxBmPHR' 'colWithMaxPHR'...
%         'bmWithMaxPHR' 'eqNum' 'scaleFactorForRun' 'saValue' 'isCurrentAnalysisConv' 'maxTolUsed';
clear 'collapseSaLevel', 'collapseLevelForAllControlComp';


% Go back to the main folder
cd(baseFolder)



