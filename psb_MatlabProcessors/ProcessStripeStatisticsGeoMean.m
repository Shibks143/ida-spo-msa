%
% Procedure: ProcessStripeStatisticsNLBmCol.m
% -------------------
% This procedure opens the output data (DATA_allDataForThisSingleRun.mat) for each IM level and each EQ (as defined in the MatlabInformation folders files - 
%           saTOneForRunLISTOUT.out and eqNumberToRunLISTOUT.out) for the given analysisType.  For each stripe (Each IM level in the list), the stripe information
%           is computed and saved in a file for that Sa level named DATA_stripe_Sa_#.mat.
%   
%           Right now this only processes drift ratios, PFA's and peak PHR's, but later will need to be updated to include more information.
% 
% Assumptions and Notices: 
%           _ This assumes that the same EQ's were run at each stipe level and will need to be altered if this is not the case.
%           - This assumes that the ProcessSingleRun has been called (many times) and saved all of the DATA for each EQ run.
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-1-04
% Updated on:   12-18-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
%       eqIndex - this is a value that is 1:numEQ's, so to get the actual EQ num, we need to look this up in the eqNumberToRunLIST
%
%       eqNumberLIST(eqIndex) - a list of the eqNumbers at the stripes - these are the numbers that are used in OpenSees (i.e. the .tcl input EQ numbers) - this is the number of the EQ - NOT the component
%       eqNumber
%
%       maxStoryDriftRatio{storyNum} - maximum story drift ratio for all EQ's (story num starts at 1 for ground level) - fields are: 
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe
%               - .allConvEQs(convEQIndex) - this is the value for only the CONVERGED EQ's of the stripe
%               - .MeanAllEQs
%               - .MeanConvEQs
%               - .MeanLnAllEQs
%               - .MeanLnConvEQs
%               - .StDevLnAllEQs
%               - .StDevLnConvEQs
%
%       maxAvgDriftRatio{storyNum} - maximum story drift ratio for all EQ's (story num starts at 1 for ground level) - fields are: 
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe
%               - .allConvEQs(convEQIndex) - this is the value for only the CONVERGED EQ's of the stripe
%               - .MeanAllEQs
%               - .MeanConvEQs
%               - .MeanLnAllEQs
%               - .MeanLnConvEQs
%               - .StDevLnAllEQs
%               - .StDevLnConvEQs
%
%       residualStoryDriftRatio{storyNum}.allEQs(eqIndex) - 
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe
%               - .allConvEQs(convEQIndex) - this is the value for only the CONVERGED EQ's of the stripe
%               - .MeanAllEQs
%               - .MeanConvEQs
%               - .MeanLnAllEQs
%               - .MeanLnConvEQs
%               - .StDevLnAllEQs
%               - .StDevLnConvEQs
%
%       residualStoryDriftRatioAbsVal{storyNum}.allEQs(eqIndex) - same as above, but all values are positive (Abs. Values)!
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe
%               - .allConvEQs(convEQIndex) - this is the value for only the CONVERGED EQ's of the stripe
%               - .MeanAllEQs
%               - .MeanConvEQs
%               - .MeanLnAllEQs
%               - .MeanLnConvEQs
%               - .StDevLnAllEQs
%               - .StDevLnConvEQs
%
%       residualStoryDriftRatioRatio{storyNum}.allEQs(eqIndex) - this is the ratio of the Abs value of the residual to the abs value of the maximum transient drift ratio
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe
%               - .allConvEQs(convEQIndex) - this is the value for only the CONVERGED EQ's of the stripe
%               - .MeanAllEQs
%               - .MeanConvEQs
%               - .MeanLnAllEQs
%               - .MeanLnConvEQs
%               - .StDevLnAllEQs
%               - .StDevLnConvEQs
%
%       maxFloorAccel{floorNum} - maximum floor accel. for all EQ's (floor num starts at 1 for ground level) - fields are: 
%               - .allEQsUnfiltered(eqIndex) - this is the value for all EQ's of the stripe, raw peak accel from analysis
%               - .allEQsFiltered(eqIndex) - this is the value for all EQ's of the stripe, filterd through the Newmark integration
%               - .allConvEQsUnfiltered(convEQIndex) - this is the value for only the CONVERGED EQ's of the stripe, raw peak accel from analysis
%               - .allConvEQsFiltered(convEQIndex) - this is the value for only the CONVERGED EQ's of the stripe, filterd through the Newmark integration
%               - .MeanAllEQsFiltered
%               - .MeanConvEQsFiltered
%               - .MeanLnAllEQsFiltered
%               - .MeanLnConvEQsFiltered
%               - .StDevLnAllEQsFiltered
%               - .StDevLnConvEQsFiltered
%               - .MeanAllEQsUnfiltered
%               - .MeanConvEQsUnfiltered
%               - .MeanLnAllEQsUnfiltered
%               - .MeanLnConvEQsUnfiltered
%               - .StDevLnAllEQsUnfiltered
%               - .StDevLnConvEQsUnfiltered
%
%       maxPHRForAllEle{eleNum} - THIS NEED TO BE UPDATED - PLEASE SEE BELOW!!! - maximum PH rotation for any element (i.e. max. of all elements in frame) for all EQ's (max of ends i and j - FOR NOW) - fields are: 
%               - .endi.allEqs(eqIndex) - this is the value for all EQ's of the stripe
%               - .endj.allEqs(eqIndex) - this is the value for all EQ's of the stripe
%               - .maxForEle.allEQs(eqIndex) - this is the value for all EQ's of the stripe
%               - .MeanAllEQs
%               - .MeanLnAllEQs
%                -.StDevLnAllEQs
%
%       Maximums for all elements in the frame - beams and columsn seperate
%           - maxColPHRInFullFrame.maxHingeRot
%               - .allEQs(eqIndex)
%               - .MeanAllEQs
%               - .MeanLnAllEQs
%                -.StDevLnAllEQs
%
%           - maxBmPHRInFullFrame.maxHingeRot.allEQs(eqIndex)
%               - .allEQs(eqIndex)
%               - .MeanAllEQs
%               - .MeanLnAllEQs
%                -.StDevLnAllEQs
%
%           - maxColPHRInFullFrame.eleNumWithMaxRot.allEQs(eqIndex)
%           - maxBmPHRInFullFrame.eleNumWithMaxRot.allEQs(eqIndex)
%
%           - maxColPHRInFullFrame.maxHingeRot.allConvEQs(convEQIndex)
%               - .allConvEQs(eqIndex)
%               - .MeanConvEQs
%               - .MeanLnConvEQs
%                -.StDevLnConvEQs
%
%           - maxBmPHRInFullFrame.maxHingeRot.allConvEQs(convEQIndex)
%               - .allConvEQs(eqIndex)
%               - .MeanConvEQs
%               - .MeanLnConvEQs
%                -.StDevLnConvEQs
%
%           - maxColPHRInFullFrame.eleNumWithMaxRot.allConvEQs(convEQIndex)
%           - maxBmPHRInFullFrame.eleNumWithMaxRot.allConvEQs(convEQIndex)
%
%       isAnalysisConv(eqNumber) - max. conv. time (sec.)
%
%       MeanAllEQs = exp(mean(log(maxPHRForAllEle{eleNum}.maxForEle.allEQs)));
%                 maxPHRForAllEle{eleNum}.maxForEle.MeanLnAllEQs       = mean(log(maxPHRForAllEle{eleNum}.maxForEle.allEQs));
%                 maxPHRForAllEle{eleNum}.maxForEle.StDevLnAllEQs 
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function[void] = ProcessStripeStatisticsGeoMean(analysisType, eqNumberLIST, saTOneForStripe)

disp('Stripe Processing Starting...');

% First open the MatlabInformation folder and load the information about that SaLevels where used for stripe and what EQ's were run at each stipe level.
    cd ..;
    cd Output;
    % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
    analysisTypeFolder = sprintf('%s', analysisType)
    cd(analysisTypeFolder);

    cd MatlabInformation;

%     eqNumberToRunLIST = load('eqNumberToRunLISTOUT.out');
%     saTOneForRunLIST = load('saTOneForRunLISTOUT.out');


%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      % NOTICE - this is hard-coded!!!
        nodeNumsAtEachFloorLIST = [-1, 12, 32, 52, 72];
%     nodeNumsAtEachFloorLIST = load('nodeNumsAtEachFloorLISTOUT.out');   % Just to know how many floors and stories there are.

        elementNumHardCodedLIST = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    cd ..; % We are now in the Output\analysisTypeFolder folder

% Compute numbers of floors and stories
numFloors = length(nodeNumsAtEachFloorLIST) - 1;
maxStoryNum = numFloors;        % 4 in this case
maxFloorNum = numFloors + 1;    % 5 in this case - the groung floor is floor 1 and the roof is floor 5

% Do the processing and save a .mat file
        
        % Create empty matrices for the EQ loop to use
            maxAvgDriftRatio.allEQs = zeros(2*length(eqNumberLIST), 1); % CHECK THIS FORMAT

            for storyNum = 1:maxStoryNum
                maxStoryDriftRatio{storyNum}.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                residualStoryDriftRatio{storyNum}.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                residualStoryDriftRatioAbsVal{storyNum}.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                residualStoryDriftRatioRatio{storyNum}.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
            end

            for floorNum = 2:maxFloorNum
                maxFloorAccel{floorNum}.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
            end
        
                    for eleIndex = 1:length(elementNumHardCodedLIST)
                        eleNum = elementNumHardCodedLIST(eleIndex);
                        maxPHRForAllEle{eleNum}.endi.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                        maxPHRForAllEle{eleNum}.endj.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                        maxPHRForAllEle{eleNum}.maxForEle.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                    end
                    
                        maxColPHRInFullFrame.maxHingeRot.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                        maxColPHRInFullFrame.eleNumWithMaxRot.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                        maxBmPHRInFullFrame.maxHingeRot.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
                        maxBmPHRInFullFrame.eleNumWithMaxRot.allEQs = zeros(2.0*length(eqNumberLIST), 1); % CHECK THIS FORMAT
            
                        
        % Do loop for each EQ and fill up the vectors with values from all EQ's
        numEQs = length(eqNumberLIST);      % This is the number of records, where we have TWO components per record
        eqComponentIndex = 1;
        for eqRecordIndex = 1:numEQs   

            
            
            % NOTICE: The eqRecordIndex is for each PAIR of components (like 1-20), while the eqComponentIndex is for all of the components (like 1-40)
            

            % Loop for each EQ component
            for compNum = 1:2
                disp('At start of EQ loop...');
            
                % Get the Eq number for this EQ  
                    if (compNum == 1)
                        eqNumber = eqNumberLIST(eqRecordIndex) * 10 + 1;
                    elseif (compNum == 2)
                        eqNumber = eqNumberLIST(eqRecordIndex) * 10 + 2;
                    else
                        error('ERROR: Invalid component number!')
                    end
                    
            % Save EQ number
            eqNumberLISTToSave(eqComponentIndex) = eqNumber;
                
                % Go into the correct folder and open the DATA file for this run
                    saFolder = sprintf('Sa_%.2f', saTOneForStripe);
                    eqFolder = sprintf('EQ_%.0f', eqNumber);
                    cd(eqFolder);
                    cd(saFolder);
                
                % Open the DATA file
                    load('DATA_reducedSensDataForThisSingleRun.mat'); % SHOULD I use this or the full data file?
%                     load('DATA_allDataForThisSingleRun.mat'); % Use full data file - use for UCLA stuff

                % Find maxConverged time for the EQ (used to see if it converged for the full time) - LATER replace this with direnctly loading if it's converged or not.
                    isAnalysisConv(eqComponentIndex) = isCurrentAnalysisConv;
                    
%                 % Get the maximum toerance used to converge
%                     currentMaxTol = maxTolUsed;
%                     maxToleranceUsed.allEQs(eqIndex) = currentMaxTol;

                    
                % Copy the information that we need for this EQ run
                    for storyNum = 1:maxStoryNum
                        maxStoryDriftRatio{storyNum}.allEQs(eqComponentIndex) = storyDriftRatioToSave{storyNum}.AbsMax;
                        residualStoryDriftRatio{storyNum}.allEQs(eqComponentIndex) = storyDriftRatioToSave{storyNum}.Residual;
                        residualStoryDriftRatioAbsVal{storyNum}.allEQs(eqComponentIndex) = abs(storyDriftRatioToSave{storyNum}.Residual);
                        residualStoryDriftRatioRatio{storyNum}.allEQs(eqComponentIndex) = abs(storyDriftRatioToSave{storyNum}.Residual) / storyDriftRatioToSave{storyNum}.AbsMax;
                    end 

                    for floorNum = 2:maxFloorNum
                        maxFloorAccel{floorNum}.allEQsUnfiltered(eqComponentIndex) = floorAccelToSave{floorNum}.absAbsMaxUnfiltered;   % Changed to DOF 1 on 9-2-04
                        %maxFloorAccel{floorNum}.allEQsFiltered(eqComponentIndex) = floorAccelToSave{floorNum}.absAbsMaxFiltered;   % Changed to DOF 1 on 9-2-04                     
                    end
                    
                    % Load the PGA
                    peakGroundAccel(eqComponentIndex) = PGA;

                % Element PHR's - NEW for nlBmCol model - NOTE - this only includes rotations that are in the element (i.e. no bond slip)
                    for eleIndex = 1:length(elementNumHardCodedLIST)
                        eleNum = elementNumHardCodedLIST(eleIndex);
                        maxPHRForAllEle{eleNum}.endi.allEQs(eqComponentIndex) = absMaxPHRToSave{eleNum}.endi;
                        maxPHRForAllEle{eleNum}.endj.allEQs(eqComponentIndex) = absMaxPHRToSave{eleNum}.endj;
                        maxPHRForAllEle{eleNum}.maxForEle.allEQs(eqComponentIndex) = absMaxPHRToSave{eleNum}.fullElement;
                    end
                    
                    % Save the max PHR for the beams and columns
                        maxColPHRInFullFrame.maxHingeRot.allEQs(eqComponentIndex) = maxColPHR;
                        maxColPHRInFullFrame.eleNumWithMaxRot.allEQs(eqComponentIndex) = colWithMaxPHR;
                        maxBmPHRInFullFrame.maxHingeRot.allEQs(eqComponentIndex) = maxBmPHR;
                        maxBmPHRInFullFrame.eleNumWithMaxRot.allEQs(eqComponentIndex) = bmWithMaxPHR;  
                    

                        
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                    % Compute the average max. story drift ratio for all stories (I will just say
                    % this is the roof drift ratio becaus ei tis close
                    % enough)
            
                        % Loop for all stories and sum story drift ratios (divided by number of stories of course) to get approx. roof
                        % drift ratio 
                        numStories = length(maxStoryDriftRatio);
                        for i = 1:numStories
                            maxAvgDriftRatio.allEQs(eqComponentIndex) = maxAvgDriftRatio.allEQs(eqComponentIndex) + (maxStoryDriftRatio{i}.allEQs(eqComponentIndex) / numStories);
                        end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
                        
%                 % Delete all of the data that was opened for this run (from DATA_allDataForThisSingleRun.mat) - what I want to save has already been saved into other variables
%                 %       These are all of the data that are in the file that was opened earlier.
%                     clear saFolder eqFolder filePrefix eigenValues fundamentalPeriod nodeNumsAtEachFloorLIST... 
%                         nodeNumToRecordLIST numNodes poControlNodeNum floorHeightsLIST... 
%                         columnNumsAtBaseLIST eigenvaluesAfterEQ minutesToRunThisAnalysis scaleFactorForRun usedNormDisplIncr nodeArray...
%                         psuedoTimeVector elementArray storyDriftRatio floorAccel baseShear numIntPointsDispEle...
%                         numIntPointsForceEle dtForAnalysisLIST defineHystHingeRecorders defineElementEndSectionRecorders hingeElementsToRecordLIST...
%                         maxRotation hingeWithMaxRotation maxConvergedTime isConvForFullEQ;
                
                % Go back to the "Output\analysisTypeFolder" folder
                    cd ..;
                    cd ..;

                    
                    % Increment counter
                    eqComponentIndex = eqComponentIndex + 1;
                end;    % End for component           
                    

        end;    % End for record

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        % Find which EQ's are converged for the full record
        
%             % First zero the arrays
%                 % Drifts
%                     for storyNum = 1:maxStoryNum
%                         maxStoryDriftRatio{storyNum}.allConvEQs(1) = 0.0001;
%                         residualStoryDriftRatio{storyNum}.allConvEQs(1) = 0.0001;
%                     end 
% 
%                     % PFA
%                     for floorNum = 2:maxFloorNum
%                         maxFloorAccel{floorNum}.allConvEQsFiltered(1) = 0.0001;
%                         maxFloorAccel{floorNum}.allConvEQsUnfiltered(1) = 0.0001;
%                     end
%                     
%                     % PHR
%                     for eleIndex = 1:length(elementNumHardCodedLIST)
%                         eleNum = elementNumHardCodedLIST(eleIndex);
%                         maxPHRForAllEle{eleNum}.endi.allConvEQs(1) = 0.0001;
%                         maxPHRForAllEle{eleNum}.endj.allConvEQs(1) = 0.0001;
%                         maxPHRForAllEle{eleNum}.maxForEle.allConvEQs(1) = 0.0001;
%                     end
%                     maxColPHRInFullFrame.maxHingeRot.allConvEQs = 0.0001;
%                     maxBmPHRInFullFrame.maxHingeRot.allConvEQs = 0.0001;
        
        
        %%%%%%% Now find the conv. EQs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        convEQIndex = 1;
        for eqIndex = 1:numEQs
            
            % Loop for each EQ component
            for compNum = 1:2
                disp('At start of EQ loop...');
            
                % Get the Eq number for this EQ  
                    if (compNum == 1)
                        eqNumber = eqNumberLIST(eqIndex) * 10 + 1;
                    elseif (compNum == 2)
                        eqNumber = eqNumberLIST(eqIndex) * 10 + 2;
                    else
                        error('ERROR: Invalid component number!')
                    end
            
                if (isAnalysisConv(eqIndex) == 1)
                % If it's converged, put the eqResults into a vector of converged results
                    % Drifts
                    maxAvgDriftRatio.allConvEQs(convEQIndex) = maxAvgDriftRatio.allEQs(eqIndex);
                    for storyNum = 1:maxStoryNum
                        maxStoryDriftRatio{storyNum}.allConvEQs(convEQIndex) = maxStoryDriftRatio{storyNum}.allEQs(eqIndex);
                        residualStoryDriftRatio{storyNum}.allConvEQs(convEQIndex) = residualStoryDriftRatio{storyNum}.allEQs(eqIndex);
                        residualStoryDriftRatioAbsVal{storyNum}.allConvEQs(convEQIndex) = abs(residualStoryDriftRatio{storyNum}.allEQs(eqIndex));
                        residualStoryDriftRatioRatio{storyNum}.allConvEQs(convEQIndex) = abs(residualStoryDriftRatio{storyNum}.allEQs(eqIndex)) / maxStoryDriftRatio{storyNum}.allEQs(eqIndex);
                    end 

                    % PFA
                    for floorNum = 2:maxFloorNum
                        %maxFloorAccel{floorNum}.allConvEQsFiltered(convEQIndex) = maxFloorAccel{floorNum}.allEQsFiltered(eqIndex);
                        maxFloorAccel{floorNum}.allConvEQsUnfiltered(convEQIndex) = maxFloorAccel{floorNum}.allEQsUnfiltered(eqIndex);
                    end
                    
                    % PHR
                    for eleIndex = 1:length(elementNumHardCodedLIST)
                        eleNum = elementNumHardCodedLIST(eleIndex);
                        maxPHRForAllEle{eleNum}.endi.allConvEQs(convEQIndex) = maxPHRForAllEle{eleNum}.endi.allEQs(eqIndex);
                        maxPHRForAllEle{eleNum}.endj.allConvEQs(convEQIndex) = maxPHRForAllEle{eleNum}.endj.allEQs(eqIndex);
                        maxPHRForAllEle{eleNum}.maxForEle.allConvEQs(convEQIndex) = maxPHRForAllEle{eleNum}.maxForEle.allEQs(eqIndex);
                    end
                    
                    % Max PHR's
                        maxColPHRInFullFrame.maxHingeRot.allConvEQs(convEQIndex) = maxColPHRInFullFrame.maxHingeRot.allEQs(eqIndex);
                        maxColPHRInFullFrame.eleNumWithMaxRot.allConvEQs(convEQIndex) = maxColPHRInFullFrame.eleNumWithMaxRot.allEQs(eqIndex);
                        maxBmPHRInFullFrame.maxHingeRot.allConvEQs(convEQIndex) = maxBmPHRInFullFrame.maxHingeRot.allEQs(eqIndex);
                        maxBmPHRInFullFrame.eleNumWithMaxRot.allConvEQs(convEQIndex) = maxBmPHRInFullFrame.eleNumWithMaxRot.allEQs(eqIndex);  
                    
%                 % Save convergence information for convergence EQ's
%                 maxToleranceUsed.allConvEQs(convEQIndex) = maxToleranceUsed.allEQs(eqIndex);
                
                convEQIndex = convEQIndex + 1;
                
                end;    % End of if statement
            end;    % End of component loop
        end;    % End of record loop
        
        numConvEQs = convEQIndex - 1;
        


        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        % Now, do all of the computations for the means and Standard deviations for all of the EQ's - NOT JUST THE CONVERGED EQ's.  If you also want just the conevrged 
            % NOTICE: These are all done in the lognormal domain, then transformed back into the normal domain!
           
            % Drifts
                maxAvgDriftRatio.MeanAllEQs     = exp(mean(log(maxAvgDriftRatio.allEQs)));
                maxAvgDriftRatio.MeanConvEQs    = exp(mean(log(maxAvgDriftRatio.allConvEQs)));
                maxAvgDriftRatio.MeanLnAllEQs     = mean(log(maxAvgDriftRatio.allEQs));
                maxAvgDriftRatio.MeanLnConvEQs    = mean(log(maxAvgDriftRatio.allConvEQs));
                maxAvgDriftRatio.StDevLnAllEQs    = std(log(maxAvgDriftRatio.allEQs));
                maxAvgDriftRatio.StDevLnConvEQs   = std(log(maxAvgDriftRatio.allConvEQs));            
            
            for storyNum = 1:maxStoryNum
                maxStoryDriftRatio{storyNum}.MeanAllEQs     = exp(mean(log(maxStoryDriftRatio{storyNum}.allEQs)));
                maxStoryDriftRatio{storyNum}.MeanConvEQs    = exp(mean(log(maxStoryDriftRatio{storyNum}.allConvEQs)));
                maxStoryDriftRatio{storyNum}.MeanLnAllEQs     = mean(log(maxStoryDriftRatio{storyNum}.allEQs));
                maxStoryDriftRatio{storyNum}.MeanLnConvEQs    = mean(log(maxStoryDriftRatio{storyNum}.allConvEQs));
                maxStoryDriftRatio{storyNum}.StDevLnAllEQs    = std(log(maxStoryDriftRatio{storyNum}.allEQs));
                maxStoryDriftRatio{storyNum}.StDevLnConvEQs   = std(log(maxStoryDriftRatio{storyNum}.allConvEQs));
                
                % Residuals - when doing means and stDev's, take the absoute values, as the residuals may be negative
                residualStoryDriftRatio{storyNum}.MeanAllEQs     = exp(mean(log(abs(residualStoryDriftRatio{storyNum}.allEQs))));
                residualStoryDriftRatio{storyNum}.MeanConvEQs    = exp(mean(log(abs(residualStoryDriftRatio{storyNum}.allConvEQs))));
                residualStoryDriftRatio{storyNum}.MeanLnAllEQs     = mean(log(abs(residualStoryDriftRatio{storyNum}.allEQs)));
                residualStoryDriftRatio{storyNum}.MeanLnConvEQs    = mean(log(abs(residualStoryDriftRatio{storyNum}.allConvEQs)));
                residualStoryDriftRatio{storyNum}.StDevLnAllEQs    = std(log(abs(residualStoryDriftRatio{storyNum}.allEQs)));
                residualStoryDriftRatio{storyNum}.StDevLnConvEQs   = std(log(abs(residualStoryDriftRatio{storyNum}.allConvEQs)));
                
                % Abs(Residuals)
                residualStoryDriftRatioAbsVal{storyNum}.MeanAllEQs     = exp(mean(log(abs(residualStoryDriftRatio{storyNum}.allEQs))));
                residualStoryDriftRatioAbsVal{storyNum}.MeanConvEQs    = exp(mean(log(abs(residualStoryDriftRatio{storyNum}.allConvEQs))));
                residualStoryDriftRatioAbsVal{storyNum}.MeanLnAllEQs     = mean(log(abs(residualStoryDriftRatio{storyNum}.allEQs)));
                residualStoryDriftRatioAbsVal{storyNum}.MeanLnConvEQs    = mean(log(abs(residualStoryDriftRatio{storyNum}.allConvEQs)));
                residualStoryDriftRatioAbsVal{storyNum}.StDevLnAllEQs    = std(log(abs(residualStoryDriftRatio{storyNum}.allEQs)));
                residualStoryDriftRatioAbsVal{storyNum}.StDevLnConvEQs   = std(log(abs(residualStoryDriftRatio{storyNum}.allConvEQs)));

                % RATIO of residual drift to peak transient drift
                residualStoryDriftRatioRatio{storyNum}.MeanAllEQs     = exp(mean(log(abs(residualStoryDriftRatioRatio{storyNum}.allEQs))));
                residualStoryDriftRatioRatio{storyNum}.MeanConvEQs    = exp(mean(log(abs(residualStoryDriftRatioRatio{storyNum}.allConvEQs))));
                residualStoryDriftRatioRatio{storyNum}.MeanLnAllEQs     = mean(log(abs(residualStoryDriftRatioRatio{storyNum}.allEQs)));
                residualStoryDriftRatioRatio{storyNum}.MeanLnConvEQs    = mean(log(abs(residualStoryDriftRatioRatio{storyNum}.allConvEQs)));
                residualStoryDriftRatioRatio{storyNum}.StDevLnAllEQs    = std(log(abs(residualStoryDriftRatioRatio{storyNum}.allEQs)));
                residualStoryDriftRatioRatio{storyNum}.StDevLnConvEQs   = std(log(abs(residualStoryDriftRatioRatio{storyNum}.allConvEQs)));
                
            end 

            % Floor accelerations
            for floorNum = 2:maxFloorNum
                %maxFloorAccel{floorNum}.MeanAllEQsFiltered      = exp(mean(log(maxFloorAccel{floorNum}.allEQsFiltered)));
                %maxFloorAccel{floorNum}.MeanConvEQsFiltered     = exp(mean(log(maxFloorAccel{floorNum}.allConvEQsFiltered)));
                %maxFloorAccel{floorNum}.MeanLnAllEQsFiltered      = mean(log(maxFloorAccel{floorNum}.allEQsFiltered));
                %maxFloorAccel{floorNum}.MeanLnConvEQsFiltered     = mean(log(maxFloorAccel{floorNum}.allConvEQsFiltered));
                %maxFloorAccel{floorNum}.StDevLnAllEQsFiltered     = std(log(maxFloorAccel{floorNum}.allEQsFiltered));
                %maxFloorAccel{floorNum}.StDevLnConvEQsFiltered    = std(log(maxFloorAccel{floorNum}.allConvEQsFiltered));
                
                maxFloorAccel{floorNum}.MeanAllEQsUnfiltered    = exp(mean(log(maxFloorAccel{floorNum}.allEQsUnfiltered)));
                maxFloorAccel{floorNum}.MeanConvEQsUnfiltered   = exp(mean(log(maxFloorAccel{floorNum}.allConvEQsUnfiltered)));
                maxFloorAccel{floorNum}.MeanLnAllEQsUnfiltered    = mean(log(maxFloorAccel{floorNum}.allEQsUnfiltered));
                maxFloorAccel{floorNum}.MeanLnConvEQsUnfiltered   = mean(log(maxFloorAccel{floorNum}.allConvEQsUnfiltered));
                maxFloorAccel{floorNum}.StDevLnAllEQsUnfiltered   = std(log(maxFloorAccel{floorNum}.allEQsUnfiltered));
                maxFloorAccel{floorNum}.StDevLnConvEQsUnfiltered  = std(log(maxFloorAccel{floorNum}.allConvEQsUnfiltered));
    
            end
                
            % Plastic rotations - all elements
            for eleIndex = 1:length(elementNumHardCodedLIST)
                eleNum = elementNumHardCodedLIST(eleIndex);
                
                % All EQ's
                maxPHRForAllEle{eleNum}.endi.MeanAllEQs         = exp(mean(log(maxPHRForAllEle{eleNum}.endi.allEQs)));
                maxPHRForAllEle{eleNum}.endi.MeanLnAllEQs       = mean(log(maxPHRForAllEle{eleNum}.endi.allEQs));
                maxPHRForAllEle{eleNum}.endi.StDevLnAllEQs      = std(log(maxPHRForAllEle{eleNum}.endi.allEQs));
                
                maxPHRForAllEle{eleNum}.endj.MeanAllEQs         = exp(mean(log(maxPHRForAllEle{eleNum}.endj.allEQs)));
                maxPHRForAllEle{eleNum}.endj.MeanLnAllEQs       = mean(log(maxPHRForAllEle{eleNum}.endj.allEQs));
                maxPHRForAllEle{eleNum}.endj.StDevLnAllEQs      = std(log(maxPHRForAllEle{eleNum}.endj.allEQs));         
                
                maxPHRForAllEle{eleNum}.maxForEle.MeanAllEQs         = exp(mean(log(maxPHRForAllEle{eleNum}.maxForEle.allEQs)));
                maxPHRForAllEle{eleNum}.maxForEle.MeanLnAllEQs       = mean(log(maxPHRForAllEle{eleNum}.maxForEle.allEQs));
                maxPHRForAllEle{eleNum}.maxForEle.StDevLnAllEQs      = std(log(maxPHRForAllEle{eleNum}.maxForEle.allEQs));           
                
                % All Conv. EQ's
                maxPHRForAllEle{eleNum}.endi.MeanConvEQs         = exp(mean(log(maxPHRForAllEle{eleNum}.endi.allConvEQs)));
                maxPHRForAllEle{eleNum}.endi.MeanLnConvEQs       = mean(log(maxPHRForAllEle{eleNum}.endi.allConvEQs));
                maxPHRForAllEle{eleNum}.endi.StDevLnConvEQs      = std(log(maxPHRForAllEle{eleNum}.endi.allConvEQs));
                
                maxPHRForAllEle{eleNum}.endj.MeanConvEQs         = exp(mean(log(maxPHRForAllEle{eleNum}.endj.allConvEQs)));
                maxPHRForAllEle{eleNum}.endj.MeanLnConvEQs       = mean(log(maxPHRForAllEle{eleNum}.endj.allConvEQs));
                maxPHRForAllEle{eleNum}.endj.StDevLnConvEQs      = std(log(maxPHRForAllEle{eleNum}.endj.allConvEQs));         
                
                maxPHRForAllEle{eleNum}.maxForEle.MeanConvEQs         = exp(mean(log(maxPHRForAllEle{eleNum}.maxForEle.allConvEQs)));
                maxPHRForAllEle{eleNum}.maxForEle.MeanLnConvEQs       = mean(log(maxPHRForAllEle{eleNum}.maxForEle.allConvEQs));
                maxPHRForAllEle{eleNum}.maxForEle.StDevLnConvEQs      = std(log(maxPHRForAllEle{eleNum}.maxForEle.allConvEQs));            

            end
            

            % Plastic rotations - max for beams and columns
            
                % All EQs
                maxColPHRInFullFrame.maxHingeRot.MeanAllEQs     = exp(mean(log(maxColPHRInFullFrame.maxHingeRot.allEQs)));
                maxColPHRInFullFrame.maxHingeRot.MeanLnAllEQs   = mean(log(maxColPHRInFullFrame.maxHingeRot.allEQs));
                maxColPHRInFullFrame.maxHingeRot.StDevLnAllEQs  = std(log(maxColPHRInFullFrame.maxHingeRot.allEQs));
            
                maxBmPHRInFullFrame.maxHingeRot.MeanAllEQs     = exp(mean(log(maxBmPHRInFullFrame.maxHingeRot.allEQs)));
                maxBmPHRInFullFrame.maxHingeRot.MeanLnAllEQs   = mean(log(maxBmPHRInFullFrame.maxHingeRot.allEQs));
                maxBmPHRInFullFrame.maxHingeRot.StDevLnAllEQs  = std(log(maxBmPHRInFullFrame.maxHingeRot.allEQs));      
            
                % All Conv. EQs
                maxColPHRInFullFrame.maxHingeRot.MeanConvEQs     = exp(mean(log(maxColPHRInFullFrame.maxHingeRot.allConvEQs)));
                maxColPHRInFullFrame.maxHingeRot.MeanLnConvEQs   = mean(log(maxColPHRInFullFrame.maxHingeRot.allConvEQs));
                maxColPHRInFullFrame.maxHingeRot.StDevLnConvEQs  = std(log(maxColPHRInFullFrame.maxHingeRot.allConvEQs));
            
                maxBmPHRInFullFrame.maxHingeRot.MeanConvEQs     = exp(mean(log(maxBmPHRInFullFrame.maxHingeRot.allConvEQs)));
                maxBmPHRInFullFrame.maxHingeRot.MeanLnConvEQs   = mean(log(maxBmPHRInFullFrame.maxHingeRot.allConvEQs));
                maxBmPHRInFullFrame.maxHingeRot.StDevLnConvEQs  = std(log(maxBmPHRInFullFrame.maxHingeRot.allConvEQs));   


        
        % Save all of this data into the folder for the proper EQ, under the correct Sa level (we are already in the right folder)
        % Only save the information that is needed so that it will be more "bug resistant".
        
        % Save the information in a filename that says sens analysis, so show that it was done for only a few (10) EQ's, and is not the full stripe.
        
        
        
            % For sensitivity runs (just filename is different)
            
            if(recordSetNameUsed == 'Sens')
                fileName = sprintf('DATA_stripe_SensRecSet_Sa_%.2f.mat', saTOneForStripe);
            elseif(recordSetNameUsed == 'Full')
                fileName = sprintf('DATA_stripe_FullRecSet_Sa_%.2f.mat', saTOneForStripe);
            elseif(recordSetNameUsed == 'Bn1A')
                fileName = sprintf('DATA_stripe_Bin1A_Sa_%.2f.mat', saTOneForStripe);
            elseif(recordSetNameUsed == 'Bn3A')
                fileName = sprintf('DATA_stripe_Bin3A_Sa_%.2f.mat', saTOneForStripe);
            elseif(recordSetNameUsed == 'Bn4A')
                fileName = sprintf('DATA_stripe_Bin4A_Sa_%.2f.mat', saTOneForStripe);
            elseif(recordSetNameUsed == 'Bn5A')
                fileName = sprintf('DATA_stripe_Bin5A_Sa_%.2f.mat', saTOneForStripe);
            elseif(recordSetNameUsed == 'B5AB')
                fileName = sprintf('DATA_stripe_Bin5AB_Sa_%.2f.mat', saTOneForStripe);
            else
                error('ERROR - recordSetNameUsed not define correctly!')
            end
          
            
                        
            
            save(fileName, 'analysisType', 'maxStoryDriftRatio', 'residualStoryDriftRatio', 'residualStoryDriftRatioAbsVal', 'residualStoryDriftRatioRatio', 'maxFloorAccel', 'maxPHRForAllEle', 'maxColPHRInFullFrame',...
                'maxBmPHRInFullFrame', 'numEQs', 'isAnalysisConv', 'eqNumberLISTToSave', 'maxAvgDriftRatio', 'peakGroundAccel');

            
        % Clear all of the data from this loop and move onto the next loop
            clear stripIndex saTOneForStripe storyNum maxStoryDriftRatio maxFloorAccel maxHingeRot hingeNumWithMaxRot eqIndex eqNumber saFolder eqFolder...
                storyNum floorNum maxTolUsed maxToleranceUsed isConvergedForFullEQ maxPHRForAllEle maxAvgDriftRatio PGA;

        % Clear more results from possible previous processing
            clear maxStoryDriftRatio residualStoryDriftRatio residualStoryDriftRatioAbsVal residualStoryDriftRatioRatio maxFloorAccel maxPHRForAllEle maxColPHRInFullFrame...
                maxBmPHRInFullFrame numEQs isAnalysisConv eqNumberLISTToSave;

                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd MatlabProcessors;

disp('Stripe Processing Finished.');
