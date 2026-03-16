%
% Procedure: ProcessStripeStatisticsELASTIC.m
% -------------------
% Elastic - same as other, but no PHR's!  This procedure opens the output data (DATA_allDataForThisSingleRun.mat) for each IM level and each EQ (as defined in the MatlabInformation folders files - 
%           saTOneForRunLISTOUT.out and eqNumberToRunLISTOUT.out) for the given analysisType.  For each stripE (eACH IM level in the lisT), the stripe information
%           is computed and saved in a file for that Sa level named DATA_stripe_Sa_#.mat.
%   
%           Right now this only processes drift ratios, PFA's and peak PHR's, but later will need to be updated to include more information.
% 
% Assumptions and Notices: 
%           _ THis assumes that the same EQ's were run at each stipe level and will need to be altered if this is not the case.
%           - This assumes that the ProcessSingleRun has been called (many times) and saved all of the DATA for each EQ run.
%           - This must be run with the current directory started in the "MatlabProcessing" folder.
%
% Author: Curt Haselton 
% Date Written: 6-1-04
%
% Sources of Code: none
%
% Functions and Procedures called: none
%
% Variable definitions (all variables are defined at each stripe level, so they will be different for different Sa values): 
%
%       eqIndex - this is a value that is 1:numEQ's, so to get the actual EQ num, we need to look this up in the eqNumberToRunLIST
%
%       eqNumberToRunLIST(eqIndex) - a list of the eqNumbers at the stripes - these are the numbers that are used in OpenSees (i.e. the .tcl input EQ numbers)
%
%       maxStoryDriftRatio{storyNum} - maximum story drift ratio for all EQ's (story num starts at 1 for ground level) - fields are: 
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe
%               - .Mean - mean for all EQ responces
%               - .StDev - standard devation for all EQ responces
%
%       maxFloorAccel{floorNum} - maximum floor accel. for all EQ's (floor num starts at 1 for ground level) - fields are: 
%               - .allEQs(eqIndex) - this is the value for all EQ's of the stripe
%               - .Mean - mean for all EQ responces
%               - .StDev - standard devation for all EQ responces
%
%
%
%
% Units: Whatever OpenSees is using - just be consistent!
%
% -------------------
% function[void] = ProcessStripeStatistics(analysisType)

disp('Stripe Processing Starting...');

% First open the MatlabInformation folder and load the information about that SaLevels where used for stripe and what EQ's were run at each stipe level.
    cd ..;
    cd Output;
    % Convert the folder name to string b/c the cell data type won't work to open folders (just converting type)
    analysisTypeFolder = sprintf('%s', analysisType)
    cd(analysisTypeFolder);

    cd MatlabInformation;

    eqNumberToRunLIST = load('eqNumberToRunLISTOUT.out');
    saTOneForRunLIST = load('saTOneForRunLISTOUT.out');
    nodeNumsAtEachFloorLIST = load('nodeNumsAtEachFloorLISTOUT.out');   % Just to know how many floors and stories there are.
 
    cd ..; % We are now in the Output\analysisTypeFolder folder

% Compute numbers of floors and stories
numFloors = length(nodeNumsAtEachFloorLIST) - 1;
maxStoryNum = numFloors;        % 4 in this case
maxFloorNum = numFloors + 1;    % 5 in this case - the groung floor is floor 1 and the roof is floor 5

% For each stripe level, do the processing and save a .mat file
disp('Entering Sa loop...');

    for stripIndex = 1:length(saTOneForRunLIST)
        disp('At start of Sa loop...');
        % Get the Sa value for this stripe
        saTOneForStripe = saTOneForRunLIST(stripIndex);
        
        
        % Create empty matrices for the EQ loop to use
            for storyNum = 1:maxStoryNum
                maxStoryDriftRatio{storyNum}.allEQs = zeros(length(eqNumberToRunLIST), 1); % CHECK THIS FORMAT
            end

            for floorNum = 2:maxFloorNum
                maxFloorAccel{floorNum}.allEQs = zeros(length(eqNumberToRunLIST), 1); % CHECK THIS FORMAT
            end
        
%             maxHingeRot.allEQs = zeros(length(eqNumberToRunLIST), 1);
%             hingeNumWithMaxRot.allEQs = zeros(length(eqNumberToRunLIST), 1);
            
        % Do loop for each EQ and fill up the vectors with values from all EQ's
        for eqIndex = 1:length(eqNumberToRunLIST)
                disp('At start of EQ loop...');
            
                % Get the Eq number for this EQ                
                    eqNumber = eqNumberToRunLIST(eqIndex);
                
                % Go into the correct folder and open the DATA file for this run
                    saFolder = sprintf('Sa_%.2f', saTOneForStripe);
                    eqFolder = sprintf('EQ_%.0f', eqNumber);
                    cd(eqFolder);
                    cd(saFolder);
                
                % Open the DATA file
                    load('DATA_allDataForThisSingleRun.mat');
                
                % Copy the information that we need for this EQ run
                    for storyNum = 1:maxStoryNum
                        maxStoryDriftRatio{storyNum}.allEQs(eqIndex) = storyDriftRatio{storyNum}.AbsMax;
                    end 

                    for floorNum = 2:maxFloorNum
                        maxFloorAccel{floorNum}.allEQs(eqIndex) = floorAccel{floorNum}.AbsMax(1);   % Added for DOF 1 on 9-2-04
                    end
                
%                     maxHingeRot.allEQs(eqIndex) = maxRotation;
%                     hingeNumWithMaxRot.allEQs(eqIndex) = hingeWithMaxRotation;              
                
                % Delete all of the data that was opened for this run (from DATA_allDataForThisSingleRun.mat) - what I want to save has already been saved into other variables
                %       These are all of the data that are in the file that was opened earlier.
                    clear saFolder eqFolder filePrefix eigenValues fundamentalPeriod nodeNumsAtEachFloorLIST... 
                        nodeNumToRecordLIST elementNumToRecordLIST numNodes poControlNodeNum floorHeightsLIST... 
                        columnNumsAtBaseLIST eigenvaluesAfterEQ minutesToRunThisAnalysis scaleFactorForRun usedNormDisplIncr nodeArray...
                        psuedoTimeVector elementArray storyDriftRatio floorAccel baseShear numIntPointsDispEle...
                        numIntPointsForceEle dtForAnalysisLIST defineHystHingeRecorders defineElementEndSectionRecorders hingeElementsToRecordLIST...
                        maxRotation hingeWithMaxRotation maxConvergedTime;
                
                % Go back to the "Output\analysisTypeFolder" folder
                    cd ..;
                    cd ..;
                
                
        end
        
        % We now have all of the data for all EQ's of this stripe, so do computations to get the means and stDev's
            for storyNum = 1:maxStoryNum
                maxStoryDriftRatio{storyNum}.Mean = mean(maxStoryDriftRatio{storyNum}.allEQs);
                maxStoryDriftRatio{storyNum}.StDev = std(maxStoryDriftRatio{storyNum}.allEQs);
            end 

            for floorNum = 2:maxFloorNum
                maxFloorAccel{floorNum}.Mean = mean(maxFloorAccel{floorNum}.allEQs);
                maxFloorAccel{floorNum}.StDev = std(maxFloorAccel{floorNum}.allEQs);
            end
                
%             maxHingeRot.Mean = mean(maxHingeRot.allEQs);
%             maxHingeRot.StDev = std(maxHingeRot.allEQs);

        
        % Save all of this data into the folder for the proper EQ, under the correct Sa level (we are already in the right folder)
        % Only save the information that is needed so that it will be more "bug resistant".
            fileName = sprintf('DATA_stripe_Sa_%.2f.mat', saTOneForStripe);
            save(fileName, 'analysisType', 'maxStoryDriftRatio', 'maxFloorAccel');
        
        
        % Clear all of the data from this loop and move onto the next loop
            clear stripIndex saTOneForStripe storyNum maxStoryDriftRatio maxFloorAccel maxHingeRot hingeNumWithMaxRot eqIndex eqNumber saFolder eqFolder...
                storyNum floorNum;

        
    end

% Get back to the MatlabProcessors folder where we started
cd ..;
cd ..;
cd MatlabProcessors;

disp('Stripe Processing Finished.');
